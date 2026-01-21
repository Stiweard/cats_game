import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Configuración del juego
  double _score = 0;
  final double _goal = 50;

  // Game Objects
  final Random _random = Random();
  late double _screenWidth;
  late double _screenHeight;
  Timer? _gameLoopTimer;

  // Cats
  double _cat1Top = 100;
  double _cat1Left = 50;
  double _cat2Top = 300;
  double _cat2Left = 200;

  // Bonus/Obstacles
  bool _showYarn = false;
  double _yarnTop = 0;
  double _yarnLeft = 0;

  bool _showWater = false;
  double _waterTop = 0;
  double _waterLeft = 0;

  // Bonus Text
  final List<BonusParticle> _bonusParticles = [];

  // Messages
  final List<String> _loveMessages = [
    "Oreo no para de ronronear por tus caricias. 🐾",
    "Hashito está feliz de tenerte como mamá. 🐱",
    "Oreo y Hashi te aman con todo su corazoncito peludo.",
    "¡Eres la favorita de Oreo y Hashito! 💖",
    "Jenyreth, eres el mundo entero para Oreo y Hashi.",
    "Tus manos hacen magia cuando acaricias a los gatitos. ✨",
    "Oreo está feliz de tenerte como mamá. 🐱",
    "Gracias por darles tanto amor a Oreo y Hashi. ❤️",
  ];

  @override
  void initState() {
    super.initState();
    _startGameLoop();
  }

  void _startGameLoop() {
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 1000), (
      timer,
    ) {
      if (!mounted) return;
      _moveCats();
      _trySpawnItems();
    });
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    super.dispose();
  }

  void _moveCats() {
    if (_score >= _goal) return;

    setState(() {
      _cat1Top = _random.nextDouble() * (_screenHeight - 150);
      _cat1Left = _random.nextDouble() * (_screenWidth - 100);

      _cat2Top = _random.nextDouble() * (_screenHeight - 150);
      _cat2Left = _random.nextDouble() * (_screenWidth - 100);
    });
  }

  void _trySpawnItems() {
    if (_score >= _goal) return;

    // Yarn Spawn (30%)
    if (!_showYarn && _random.nextDouble() < 0.3) {
      setState(() {
        _showYarn = true;
        _yarnTop = _random.nextDouble() * (_screenHeight - 100);
        _yarnLeft = _random.nextDouble() * (_screenWidth - 100);
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _showYarn) setState(() => _showYarn = false);
      });
    }

    // Water Spawn (25%) - Increases difficulty logic could go here
    if (!_showWater && _random.nextDouble() < 0.25) {
      setState(() {
        _showWater = true;
        _waterTop = _random.nextDouble() * (_screenHeight - 100);
        _waterLeft = _random.nextDouble() * (_screenWidth - 100);
      });
      Future.delayed(const Duration(seconds: 2), () {
        // Water disappears faster
        if (mounted && _showWater) setState(() => _showWater = false);
      });
    }
  }

  void _onInteraction(TapDownDetails details, int points) {
    if (_score >= _goal) return;

    setState(() {
      _score += points;
      if (_score > _goal) _score = _goal;
    });

    _addHeart(details.globalPosition, isBig: points > 1);

    if (_score >= _goal) {
      _showWinDialog();
    }
  }

  void _onYarnTapped(TapDownDetails details) {
    setState(() => _showYarn = false);
    _onInteraction(details, 5);
    _addBonusText(details.globalPosition);
  }

  void _onWaterTapped() {
    setState(() {
      _showWater = false;
      _score = 0; // Reset score!
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¡Cuidado! 💦"),
        content: const Text(
          "¡Mojaste a Oreo y Hashi! 😿\nA ellos no les gusta el agua.\nInténtalo de nuevo con amor.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Lo siento, gatos"),
          ),
        ],
      ),
    );
  }

  void _addHeart(Offset position, {bool isBig = false}) {
    setState(() {
      _hearts.add(
        HeartParticle(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          position: position,
          isBig: isBig,
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && _hearts.isNotEmpty) {
        setState(() {
          _hearts.removeAt(0);
        });
      }
    });
  }

  void _addBonusText(Offset position) {
    setState(() {
      _bonusParticles.add(
        BonusParticle(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          position: position,
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && _bonusParticles.isNotEmpty) {
        setState(() {
          _bonusParticles.removeAt(0);
        });
      }
    });
  }

  void _showWinDialog() {
    final String randomMessage =
        _loveMessages[_random.nextInt(_loveMessages.length)];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¡Misión Cumplida! 💖'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Has llenado de amor a Oreo y Hashito.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              randomMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
            child: const Text('Volver al Inicio'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _score = 0;
              });
            },
            child: const Text("Jugar Otra Vez"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFEE140), Color(0xFFFA709A)],
              ),
            ),
          ),

          // Progress Bar
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/'),
                    ),
                    const Text(
                      "Medidor de Amor",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _score / _goal,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 20,
                  ),
                ),
              ],
            ),
          ),

          // Bonus Yarn
          if (_showYarn)
            Positioned(
              top: _yarnTop,
              left: _yarnLeft,
              child: GestureDetector(
                onTapDown: _onYarnTapped,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.8, end: 1.1),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) =>
                      Transform.scale(scale: value, child: child),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/yarn.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),

          // Obstacle Water
          if (_showWater)
            Positioned(
              top: _waterTop,
              left: _waterLeft,
              child: GestureDetector(
                onTap: _onWaterTapped,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.8, end: 1.2),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, value, child) =>
                      Transform.scale(scale: value, child: child),
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Image.asset('assets/water.png'),
                  ),
                ),
              ),
            ),

          // Hashi (Orange)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutBack,
            top: _cat1Top,
            left: _cat1Left,
            child: _buildCat(
              'assets/hashi.png',
              'Hashi',
              Colors.orange,
              (d) => _onInteraction(d, 1),
            ),
          ),

          // Oreo (Black)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutBack,
            top: _cat2Top,
            left: _cat2Left,
            child: _buildCat(
              'assets/oreo.png',
              'Oreo',
              Colors.black87,
              (d) => _onInteraction(d, 1),
            ),
          ),

          // Hearts Particles
          ..._hearts
              .map(
                (heart) => Positioned(
                  left: heart.position.dx - 20,
                  top: heart.position.dy - 50,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: 1.0 - value,
                        child: Transform.translate(
                          offset: Offset(0, -100 * value),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: heart.isBig ? 60 : 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
              .toList(),

          // Bonus Particles
          ..._bonusParticles
              .map(
                (bonus) => Positioned(
                  left: bonus.position.dx - 20,
                  top: bonus.position.dy - 50,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: 1.0 - value,
                        child: Transform.translate(
                          offset: Offset(0, -60 * value),
                          child: const Text(
                            "+5",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.purpleAccent,
                              shadows: [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.white,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildCat(
    String asset,
    String name,
    Color color,
    Function(TapDownDetails) onTap,
  ) {
    return GestureDetector(
      onTapDown: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(asset), // Clean crop
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class HeartParticle {
  final String id;
  final Offset position;
  final bool isBig;

  HeartParticle({required this.id, required this.position, this.isBig = false});
}

class BonusParticle {
  final String id;
  final Offset position;

  BonusParticle({required this.id, required this.position});
}
