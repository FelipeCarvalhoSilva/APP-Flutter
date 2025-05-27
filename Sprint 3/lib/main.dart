import 'package:flutter/material.dart';
import 'cadastro_page.dart';
import 'login_page.dart';
import 'inicial_page.dart';
import 'editar_perfil_page.dart'; // Importe as novas páginas
import 'mapa_page.dart';
import 'sobre_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: 'EasyRoute',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(58, 183, 93, 1),
        ),
        useMaterial3: true,
      ),
      // Rota inicial
      home: const TelaInicial(),
      //
      routes: {
        '/login': (context) => const Login(),
        '/cadastro': (context) => const CadastroScreen(),
        '/editar_perfil': (context) => const EditarPerfil(),
        '/mapa': (context) => const MapaScreen(),
        '/sobre': (context) => const SobrePage(),
      },
    ),
  );
}
