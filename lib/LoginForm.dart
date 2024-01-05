import 'package:flutter/material.dart';
import 'ManagerScene.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _memberNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 회원 가입 레이블
        const Text(
          '회원 가입',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0), // 간격 조절

        // 회원 번호 입력 필드
        SizedBox(
          width: 400.0, // Adjust the width as needed
          child: TextField(
            controller: _memberNumberController,
            decoration: const InputDecoration(
              hintText: '회원 번호',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),

        // Button to navigate to the second screen as a modal
        ElevatedButton(
          onPressed: () {
            String enteredValue = _memberNumberController.text;
            // Navigate to the second screen as a modal
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return ManagerScene(enteredValue: enteredValue);
                },
              ),
            );
          },
          child: const Text('Show Second Screen as Modal'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _memberNumberController.dispose();
    super.dispose();
  }
}