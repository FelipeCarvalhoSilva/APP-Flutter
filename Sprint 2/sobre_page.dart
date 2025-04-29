import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o App')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Editar Perfil'),
              onTap: () {
                Navigator.pushNamed(context, '/editar_perfil');
              },
            ),
            ListTile(
              title: const Text('Mapa'),
              onTap: () {
                Navigator.pushNamed(context, '/mapa');
              },
            ),
            ListTile(
              title: const Text('Sobre o App'),
              onTap: () {
                Navigator.pushNamed(context, '/sobre');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('EasyRoute v1.0.0'),
              SizedBox(height: 20),
              Text('Aplicativo para gerenciamento de rotas'),
            ],
          ),
        ),
      ),
    );
  }
}
