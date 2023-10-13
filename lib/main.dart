import 'package:flutter/material.dart';
import 'package:projet_grh/screens/welcome.dart';


import 'constants/constant.dart';
import 'models/user.dart';

Future<void> main() async {
  // Assurez-vous d'initialiser le framework Flutter.
  WidgetsFlutterBinding.ensureInitialized();
  // Appel de la fonction pour récupérer et insérer les données
  await fetchDataAndInsertIntoDatabase();
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),

      home: WelcomePage(),
    );
  }
}

