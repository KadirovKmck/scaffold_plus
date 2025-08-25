import 'package:flutter/material.dart';
import 'package:scaffold_plus/scaffold_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ExamplePage());
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPlus(
      appBar: AppBar(title: const Text('CustomScaffold Example')),
      useBackgroundImage: true,
      backgroundImage: 'assets/images/bg.png',
      body: const Center(child: Text('Hello from CustomScaffold!')),
    );
  }
}
