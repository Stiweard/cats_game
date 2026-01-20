import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Para Ella',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const CatGameScreen(),
    );
  }
}

class CatGameScreen extends StatefulWidget {
  const CatGameScreen({super.key});

  @override
  State<CatGameScreen> createState() => _CatGameScreenState();
}

class _CatGameScreenState extends State<CatGameScreen> {
  // Configuración del juego
  double _score = 0; // Progreso de 0.0 a 1.0
  final double _goal = 20; // Cuántos toques para ganar

  // Posiciones de los gatos (iniciales)
  double _cat1Top = 100;
  double _cat1Left = 50;
  double _cat2Top = 300;
  double _cat2Left = 200;

  // Tamaño de pantalla
  late double _screenWidth;
  late double _screenHeight;

  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Mover los gatos cada 1.5 segundos para que sea relajante
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      _moveCats();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _moveCats() {
    if (_score >= _goal) return; // Si ganó, dejan de moverse

    setState(() {
      // Mueve al Gato 1 a una posición aleatoria
      _cat1Top = _random.nextDouble() * (_screenHeight - 150);
      _cat1Left = _random.nextDouble() * (_screenWidth - 100);

      // Mueve al Gato 2
      _cat2Top = _random.nextDouble() * (_screenHeight - 150);
      _cat2Left = _random.nextDouble() * (_screenWidth - 100);
    });
  }

  void _onCatTapped() {
    if (_score >= _goal) return;

    setState(() {
      _score++;
    });

    // Feedback visual (SnackBar rápido o sonido sería ideal)
    if (_score >= _goal) {
      _showLoveMessage();
    }
  }

  void _showLoveMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Lo lograste! ❤️'),
        content: const Text(
          'Sabía que cuidarías bien de ellas incluso a la distancia.\n\n'
          'Tus gatas te extrañan, pero saben que eres la mejor.\n'
          'Y yo... bueno, yo te quiero ver feliz. ¡Ánimo!',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _score = 0; // Reiniciar
              });
            },
            child: const Text('Jugar otra vez'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones actuales
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo bonito
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFEE140), Color(0xFFFA709A)],
              ),
            ),
          ),

          // Barra de progreso (Amor Meter)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                const Text(
                  "Llenando el medidor de amor...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _score / _goal,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  color: Colors.white,
                  minHeight: 15,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),

          // Gato 1
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _cat1Top,
            left: _cat1Left,
            child: GestureDetector(
              onTap: _onCatTapped,
              child: _buildCatWidget('assets/gato1.png'),
            ),
          ),

          // Gato 2
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            top: _cat2Top,
            left: _cat2Left,
            child: GestureDetector(
              onTap: _onCatTapped,
              child: _buildCatWidget('assets/gato2.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatWidget(String assetPath) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.2,
        ), // More transparent to show off the png
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(assetPath),
        ),
      ),
    );
  }
}
