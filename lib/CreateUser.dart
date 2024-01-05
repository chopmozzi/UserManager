import 'package:flutter/material.dart';
import 'package:usermanager/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CreateUserScene extends StatefulWidget {
  @override
  _CreateUserSceneState createState() => _CreateUserSceneState();
}

class _CreateUserSceneState extends State<CreateUserScene> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController lessonCountController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  UserType selectedUserType = UserType.admin;

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create User"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: lessonCountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Lesson Count'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                DropdownButton<UserType>(
                  value: selectedUserType,
                  onChanged: (UserType? newValue) {
                    setState(() {
                      selectedUserType = newValue!;
                    });
                  },
                  items: UserType.values.map<DropdownMenuItem<UserType>>(
                        (UserType value) {
                      return DropdownMenuItem<UserType>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Create a User object with the entered values
                User newUser = User(
                  name: nameController.text,
                  phoneNumber: int.parse(phoneNumberController.text),
                  lessonCount: int.parse(lessonCountController.text),
                  address: addressController.text,
                  type: selectedUserType,
                );

                // Use the newUser object as needed
                print(newUser.toMap());

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Create"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _showCreateUserDialog(context);
              },
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}
