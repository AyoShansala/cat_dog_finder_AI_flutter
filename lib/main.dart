import 'package:cat_dog_clasification_app/home.dart';
import 'package:cat_dog_clasification_app/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog and Cat Finder',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
