enum UserType {
  admin, lesson
}

class User {
  int id;
  String name;
  int phoneNumber;
  int lessonCount;
  String address;
  UserType type;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.lessonCount,
    required this.address,
    required this.type
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'lessonCount': lessonCount,
      'address': address,
      'type': type
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      lessonCount: map['lessonCount'],
      address: map['address'],
      type: map['type']
    );
  }
}