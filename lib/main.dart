import 'package:flutter/material.dart';

import 'Screens/DetailsScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/SearchScreeen.dart';
import 'Screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData.dark(), // Use a dark theme for a better Netflix-like feel
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/details': (context) => DetailsScreen(), // Add your details screen
      },
    );
  }
}
