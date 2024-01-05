import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:usermanager/User.dart';
import 'package:usermanager/CreateUser.dart';

class ManagerScene extends StatefulWidget {
  final String enteredValue;

  @override
  _ManagerSceneState createState() => _ManagerSceneState();

  const ManagerScene({super.key, required this.enteredValue});

  Future<List<User>> fetchDataFromDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'usermanager.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE IF NOT EXISTS your_table (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
        });

    List<Map<String, dynamic>> result = await database.rawQuery('SELECT * FROM your_table');

    // Convert the result into a list of User objects
    List<User> users = result.map((map) => User.fromMap(map)).toList();

    // Close the database
    await database.close();

    return users;
  }
}


class _ManagerSceneState extends State<ManagerScene> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController lessonCountController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  UserType selectedUserType = UserType.admin;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    // Call fetchDataFromDatabase when the widget is created
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    List<User> fetchedUsers = await widget.fetchDataFromDatabase();
    setState(() {
      users.addAll(fetchedUsers);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final List<User> users = <User>[
    //   User(name: "지웅", phoneNumber: 01012345678, lessonCount: 4, address: "집", type: UserType.admin),
    //   User(name: "황", phoneNumber: 01034567891, lessonCount: 2, address: "어딘가", type: UserType.lesson)
    // ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              _showCreateUserDialog(context);
            },
          )
        ],
      ),
      body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 1000,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 200,
                columns: const [
                  DataColumn(label: Text('이름')),
                  DataColumn(label: Text('전화 번호')),
                  DataColumn(label: Text('주소')),
                  DataColumn(label: Text('남은 횟수')),
                  DataColumn(label: Text('편집'))
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user.name)),
                    DataCell(Text(user.phoneNumber.toString())),
                    DataCell(Text(user.address)),
                    DataCell(Text(user.lessonCount.toString())),
                    DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                          },
                        ))
                  ],
                  );
                }).toList(),
              ),
            ),
          )
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("회원 가입"),
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
                        child: Text(value
                            .toString()
                            .split('.')
                            .last),
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
                nameController.clear();
                phoneNumberController.clear();
                lessonCountController.clear();
                addressController.clear();

                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
            ElevatedButton(
              onPressed: () async {
                User newUser = User(
                  name: nameController.text,
                  phoneNumber: int.parse(phoneNumberController.text),
                  lessonCount: int.parse(lessonCountController.text),
                  address: addressController.text,
                  type: selectedUserType,
                );

                var databasesPath = await getDatabasesPath();
                String path = join(databasesPath, 'usermanager.db');
                Database database = await openDatabase(path, version: 1);

                await database.insert(
                  'usermanager.db',
                  newUser.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );

                await database.close();

                print(newUser.toMap());

                nameController.clear();
                phoneNumberController.clear();
                lessonCountController.clear();
                addressController.clear();

                Navigator.of(context).pop();
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }
}