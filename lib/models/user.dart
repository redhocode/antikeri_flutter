class User {
  final int userId; // Pastikan tipe adalah int
  final String name;

  User({required this.userId, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['USERID'], // Sesuaikan dengan kunci JSON
      name: json['Name'], // Sesuaikan dengan kunci JSON
    );
  }
}
