import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'UserManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const UserManager());
}

