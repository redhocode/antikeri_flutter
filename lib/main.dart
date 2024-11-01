import 'package:flutter/material.dart';
import 'screens/UserListScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(), // Menetapkan UserListScreen sebagai layar utama
    );
  }
}
