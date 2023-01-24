import 'package:flutter/material.dart';
import './main.dart';

class Editar extends StatelessWidget {
  const Editar({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TelaEditar(),
    );
  }
}

class TelaEditar extends StatelessWidget {
  const TelaEditar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar palavra'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
          ),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
    );
  }
}
