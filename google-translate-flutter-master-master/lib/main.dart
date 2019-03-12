import 'package:flutter/material.dart';

import 'screens/home-page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Translate',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.grey[600],
      ),
      home: HomePage(title: 'Google Translate'),
    );
  }
}
