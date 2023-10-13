// Nous allons définir notre class User qui va nous permettre de recueillir les données que nous cherchons dans l'API

class User {
  int? id;
  final String gender;
  final String firstName;
  final String lastName;
  final String picture;
  final String email;
  final String location;
  final String phone;
  final int age;


  User({
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.picture,
    required this.email,
    required this.location,
    required this.phone,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'firstName': firstName,
      'lastName': lastName,
      'picture': picture,
      'email': email,
      'location': location,
      'phone': phone,
      'age': age,
      // Nous pouvons ajouter d'autres champs si besoin
    };
  }
}





