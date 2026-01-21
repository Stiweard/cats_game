import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFEE140), Color(0xFFFA709A)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Title
            const Text(
              'Para Jenyreth',
              style: TextStyle(
                fontFamily: 'Cursive',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black26,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Cat Avatars Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAvatarPreview('assets/oreo.png', 'Oreo'),
                const SizedBox(width: 20),
                _buildAvatarPreview('assets/hashi.png', 'Hashi'),
              ],
            ),

            const SizedBox(height: 50),

            // Start Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/game');
              },
              icon: const Icon(Icons.favorite, color: Colors.pinkAccent),
              label: const Text(
                'Comenzar Aventura',
                style: TextStyle(fontSize: 20, color: Colors.pinkAccent),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),

            const SizedBox(height: 20),

            // How to Play Button
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Cómo Jugar 🎮"),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("💖 Toca a Oreo y Hashi para darles amor."),
                        SizedBox(height: 10),
                        Text("🧶 ¡Atrapa el ovillo de lana para bonus!"),
                        SizedBox(height: 10),
                        Text("💧 ¡EVITA el agua! A los gatos no les gusta."),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Entendido"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.help_outline, color: Colors.white),
              label: const Text(
                '¿Cómo jugar?',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Hecho con mucho cariño de Stiweard ❤️",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPreview(String asset, String name) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipOval(child: Image.asset(asset, fit: BoxFit.cover)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
