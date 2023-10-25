import 'package:flutter/material.dart';

import 'student_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primarySwatch: Colors.cyan, primaryColor: Colors.cyan[800]),
      debugShowCheckedModeBanner: false,
      home: StudentList(),
    );
  }
}
