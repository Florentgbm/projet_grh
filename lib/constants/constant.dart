import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../models/user.dart';

const textColor = Color(0xFF3F9F98);
const darkColor = Color(0xFF000B40);
const textLightColor = Color(0xFF71B9AD);
const textLight2Color = Color(0xFFADDBD2);
const textWhite = Color(0xFFF2F2F2);
const Light = Color(0xFFFFFFFF);

Widget CircularImage(String imagePath) {
  return Container(
    height: 225,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: textLightColor,
          //offset: Offset(19, 3),

          blurRadius: 10,
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 8),
    child: ClipOval(
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    ),
  );
}
// Fonction permettant de récupérer et d'insérer les données de l'API dans la base de données
Future<void> fetchDataAndInsertIntoDatabase() async {
  final apiUrl = Uri.parse('https://randomuser.me/api/?results=100');
  final response = await http.get(apiUrl);

  if (response.statusCode == 200) {
    final data = json.decode(response.body)['results'] as List<dynamic>;

    // Initialisons la base SQLite
    final db = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, gender TEXT, firstName TEXT, lastName TEXT, picture TEXT, email TEXT, location TEXT, phone TEXT, age NUM)',
        );
      },
      version: 1,
    );

    // Insert data into the database
    final batch = db.batch();
    for (final item in data) {
      final user = User(
        gender: item['gender'],
        firstName: item['name']['first'],
        lastName: item['name']['last'],
        picture: item['picture']['large'],
        email: item['email'],
        location: item['location']['street']['name'],
        phone: item['phone'],
        age: item['dob']['age'],
        // On peut ajouter d'autres champs ici en fonction de nos besoins.
      );
      batch.insert('users', user.toMap());
    }
    await batch.commit();

    // Maintenant nous allons fermer la base de données.
    await db.close();
  } else {
    throw Exception('Failed to fetch data from the API');
  }
}

// La méthode qui nous permet de récupérer les données de la base de données SQLite
Future<List<Map<String, dynamic>>> fetchUsersFromDatabase() async {
  final Database db = await openDatabase(
    join(await getDatabasesPath(), 'my_database.db'),
  );

  final List<Map<String, dynamic>> users = await db.query('users');

  return users;
}

class DatabaseHelper {
  DatabaseHelper._(); // Constructeur privé pour suivre le modèle singleton
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            gender TEXT,
            firstName TEXT,
            lastName TEXT,
            picture TEXT,
            email TEXT,
            location TEXT,
            phone TEXT,
            age INTEGER
          )
        ''');
      },
      version: 1, // Utilisez 1 car c'est votre première version
    );
  }

// Autres méthodes pour gérer la base de données, comme update, delete, etc.
}



