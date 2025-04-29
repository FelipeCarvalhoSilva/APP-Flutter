import 'package:flutter/material.dart';
import 'cadastro_page.dart';
import 'login_page.dart';
import 'inicial_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(58, 183, 93, 1),
        ),
        useMaterial3: true,
      ),
      home: const TelaInicial(),
    ),
  );
}
