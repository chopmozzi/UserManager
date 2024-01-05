import 'package:flutter/material.dart';
import 'LoginForm.dart';

class UserManager extends StatelessWidget {
  const UserManager({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}