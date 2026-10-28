import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const HauntedMansionApp());
}

// 🧛 The oldest resident — never changes
class HauntedMansionApp extends StatelessWidget {
  const HauntedMansionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Haunted Signup Mansion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // I changed this this color to D1B1C8 for the seed color cause it matches the theme better
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD1B1C8)),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
