import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/consts/scrren_splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ScreenSplash(),
      title: 'Music',
      color: Colors.white,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, elevation: 0),
      ),
    );
  }
}
