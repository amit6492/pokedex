import 'package:flutter/material.dart';
import 'package:myapp/widgets/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ Hide Debug Banner
      title: 'Pokédex',
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashScreen(), // ✅ Start with Splash Screen
    );
  }
}
