import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cw_6/code.dart';
import 'package:cw_6/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("To-Do List"),
        ),
        body: TodoList(),
        backgroundColor: Colors.black,
      ),
    );
  }
}
