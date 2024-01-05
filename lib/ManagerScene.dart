import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:usermanager/User.dart';

class ManagerScene extends StatelessWidget {
  final String enteredValue;

  const ManagerScene({super.key, required this.enteredValue});

  Future<List<User>> fetchDataFromDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'your_database.db');

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

  @override
  Widget build(BuildContext context) {
    final List<User> users = <User>[
      User(id: 1, name: "지웅", phoneNumber: 01012345678, lessonCount: 4, address: "집", type: UserType.admin),
      User(id: 2, name: "황", phoneNumber: 01034567891, lessonCount: 2, address: "어딘가", type: UserType.lesson)
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: (){

          },
        ),
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
                        icon: Icon(Icons.edit),
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
}
