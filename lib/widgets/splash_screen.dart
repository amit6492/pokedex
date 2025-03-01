import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/widgets/pokedex_screen.dart'; // 

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Navigate to Main Screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Pokedex()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[300], // Pokédex Theme
      body: Center(
        child: Lottie.asset(
          'assets/poke_loader_1.json', // ✅ Replace with your Pokédex animation
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
