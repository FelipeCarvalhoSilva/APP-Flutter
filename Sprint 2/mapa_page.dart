import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:io';
// Importação para usar MapType e controlar erros
import 'package:flutter/foundation.dart';

// Constante para a chave API do Google Maps
const String GOOGLE_MAPS_API_KEY = 'EMPTY';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  // Definir a posição inicial do mapa (por exemplo, São Paulo, Brasil)
  static const CameraPosition _posicaoInicial = CameraPosition(
    target: LatLng(-23.550520, -46.633308),
    zoom: 13,
  );

  // Lista para armazenar marcadores no mapa
  final Set<Marker> _marcadores = {};

  // Flag para controlar erros de inicialização do mapa
  bool _mapError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();

    // Configurar a chave API do Google Maps
    _configurarChaveAPI();

    // Adicionar um marcador inicial
    _marcadores.add(
      const Marker(
        markerId: MarkerId('marcador_inicial'),
        position: LatLng(-23.550520, -46.633308),
        infoWindow: InfoWindow(
          title: 'São Paulo',
          snippet: 'A maior cidade do Brasil',
        ),
      ),
    );
  }

  // Método para configurar a chave API do Google Maps
  void _configurarChaveAPI() async {
    if (kIsWeb) {
      // Configurar chave API para Web
      // Nota: No ambiente web, a chave API geralmente é definida no HTML
      // Este é um exemplo de como poderia ser feito programaticamente
      try {
        // Para web, você pode precisar configurar de maneira diferente
        // Este é apenas um exemplo ilustrativo
        if (GOOGLE_MAPS_API_KEY != 'EMPTY') {
          final script = '''
            var script = document.createElement('script');
            script.src = 'https://maps.googleapis.com/maps/api/js?key=$GOOGLE_MAPS_API_KEY';
            document.head.appendChild(script);
          ''';
          // Implementar a lógica de injeção de script se necessário
        }
      } catch (e) {
        print('Erro ao configurar API para Web: $e');
      }
    } else if (Platform.isAndroid) {
      // Configurar chave API para Android
      try {
        // Em produção, você usaria o arquivo android/app/src/main/AndroidManifest.xml
        // para definir a chave API, mas este é um exemplo de como seria
        // uma configuração programática
        if (GOOGLE_MAPS_API_KEY != 'EMPTY') {
          // Configuração programática (exemplo)
          // Na prática, isso seria feito no AndroidManifest.xml
        }
      } catch (e) {
        print('Erro ao configurar API para Android: $e');
      }
    } else if (Platform.isIOS) {
      // Configurar chave API para iOS
      try {
        // Em produção, você usaria o arquivo ios/Runner/AppDelegate.swift
        // para definir a chave API, mas este é um exemplo de como seria
        // uma configuração programática
        if (GOOGLE_MAPS_API_KEY != 'EMPTY') {
          // Configuração programática (exemplo)
          // Na prática, isso seria feito no AppDelegate.swift
        }
      } catch (e) {
        print('Erro ao configurar API para iOS: $e');
      }
    }
  }

  // Função para adicionar um novo marcador onde o usuário tocar
  void _adicionarMarcador(LatLng posicao) {
    setState(() {
      _marcadores.add(
        Marker(
          markerId:
              MarkerId('marcador_${DateTime.now().millisecondsSinceEpoch}'),
          position: posicao,
          infoWindow: InfoWindow(
            title: 'Novo Local',
            snippet:
                'Lat: ${posicao.latitude.toStringAsFixed(4)}, Lng: ${posicao.longitude.toStringAsFixed(4)}',
          ),
        ),
      );
    });
  }

  // Função para mover a câmera para uma posição
  Future<void> _irParaPosicao(CameraPosition posicao) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(posicao));
  }

  // Método para construir o widget do mapa com tratamento de erro
  Widget _buildMapWidget() {
    // Verificar se a chave API é válida
    if (GOOGLE_MAPS_API_KEY == 'EMPTY') {
      return _buildErrorWidget(
          "Chave API não configurada. Configure a chave API do Google Maps.");
    }

    // Verificar se estamos em modo web, que pode ter problemas específicos
    if (kIsWeb) {
      try {
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoInicial,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _marcadores,
          onTap: _adicionarMarcador,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
        );
      } catch (e) {
        return _buildErrorWidget(e.toString());
      }
    } else {
      try {
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoInicial,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _marcadores,
          onTap: _adicionarMarcador,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
        );
      } catch (e) {
        return _buildErrorWidget(e.toString());
      }
    }
  }

  // Widget para mostrar mensagem de erro
  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[700],
            ),
            const SizedBox(height: 16),
            const Text(
              'Não foi possível carregar o Google Maps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Erro: $error',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              onPressed: () {
                setState(() {
                  _mapError = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          // Botão para retornar à página inicial
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            tooltip: 'Página Inicial',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Página Inicial'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              title: const Text('Editar Perfil'),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.pushNamed(context, '/editar_perfil');
              },
            ),
            ListTile(
              title: const Text('Mapa'),
              leading: const Icon(Icons.map),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sobre o App'),
              leading: const Icon(Icons.info),
              onTap: () {
                Navigator.pushNamed(context, '/sobre');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMapWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _marcadores.clear();
                    });
                  },
                  child: const Text('Limpar Marcadores'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Voltar para Início'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Exibir locais pré-definidos para o usuário escolher
          showModalBottomSheet(
            context: context,
            builder: (context) => SizedBox(
              height: 240,
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Ir para:'),
                    tileColor: Colors.blue,
                    textColor: Colors.white,
                  ),
                  ListTile(
                    title: const Text('São Paulo'),
                    subtitle: const Text('Brasil'),
                    leading: const Icon(Icons.location_city),
                    onTap: () {
                      _irParaPosicao(const CameraPosition(
                        target: LatLng(-23.550520, -46.633308),
                        zoom: 13,
                      ));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Rio de Janeiro'),
                    subtitle: const Text('Brasil'),
                    leading: const Icon(Icons.beach_access),
                    onTap: () {
                      _irParaPosicao(const CameraPosition(
                        target: LatLng(-22.9068, -43.1729),
                        zoom: 13,
                      ));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Brasília'),
                    subtitle: const Text('Brasil'),
                    leading: const Icon(Icons.account_balance),
                    onTap: () {
                      _irParaPosicao(const CameraPosition(
                        target: LatLng(-15.7801, -47.9292),
                        zoom: 13,
                      ));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.explore),
      ),
    );
  }
}
