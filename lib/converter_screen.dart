import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ConverterScreen();
  }
}

class _ConverterScreen extends State<ConverterScreen> {
  final TextEditingController _controller = TextEditingController();
  double? _usdRate;
  double? _eurRate;
  double? _gbpRate;
  String _error = '';

  Future<void> _convert() async {
    const header = 'samuel y jim';
    const url = 'https://api.exchangerate-api.com/v4/latest/COP';
    //const url = 'https://httpbin.org/get';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'consumer': header},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //print(response.body);
        setState(() {
          _usdRate = data['rates']['USD'];
          _eurRate = data['rates']['EUR'];
          _gbpRate = data['rates']['GBP'];
          _error = '';
        });
      } else {
        setState(() {
          _error = 'Error: No se pudo obtener la tasa de conversión';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Examen Final"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el valor en COP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: _convert, child: const Text('Convertir')),
              const SizedBox(height: 16),
              _error.isNotEmpty
                  ? Text(_error, style: const TextStyle(color: Colors.red))
                  : Container(),
              _usdRate != null
                  ? Text(
                      'USD: ${_controller.text.isNotEmpty ? (double.parse(_controller.text) * _usdRate!).toStringAsFixed(5) : ''}')
                  : Container(),
              _eurRate != null
                  ? Text(
                      'EUR: ${_controller.text.isNotEmpty ? (double.parse(_controller.text) * _eurRate!).toStringAsFixed(5) : ''}')
                  : Container(),
              _gbpRate != null
                  ? Text(
                      'GBP: ${_controller.text.isNotEmpty ? (double.parse(_controller.text) * _gbpRate!).toStringAsFixed(5) : ''}')
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
