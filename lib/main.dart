import 'package:flutter/material.dart';
import 'package:nice_page_view/match_brackets.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MatchBrackets(),
    );
  }
}
