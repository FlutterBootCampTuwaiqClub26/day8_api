import 'package:day8_api/screens/characters_screen.dart';
import 'package:day8_api/service/api.dart';
import 'package:flutter/material.dart';

void main() {
  Api().getCharacters();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner:  false,
      home: CharactersScreen()
    );
  }
}
