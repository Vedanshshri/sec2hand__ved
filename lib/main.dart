import 'package:flutter/material.dart';
import 'package:sec2hand/ui_screens/sortPage.dart';
import 'package:sec2hand/ui_screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "home",
      routes: {
        "home": (context) => SplashScreen(),
        "sortpage": (context) => SortPage(),
      },
      title: 'Sec2Hand',
    );
  }
}
