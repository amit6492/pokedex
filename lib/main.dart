import 'package:flutter/material.dart';
import 'package:myapp/widgets/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashScreen(),
    );
  }
}
