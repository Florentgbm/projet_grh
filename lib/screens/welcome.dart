import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:projet_grh/screens/homepage.dart';

import '../constants/constant.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pour rendre notre interface responsive
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: mediaQuery.size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [textColor, textLight2Color],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin:
                      EdgeInsets.only(bottom: 50 * mediaQuery.size.height / 896),
                  height: 30,
                  // Le texte déroulant
                  child: Marquee(
                    text:
                        "Bienvenue sur l'application de gestion des ressources humaines",
                    style: const TextStyle(
                      fontSize: 20,
                      color: textWhite,
                      fontFamily: "Prata",
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Container(
                margin:
                    EdgeInsets.only(bottom: 50 * mediaQuery.size.height / 896),
                child: CircularImage("assets/images/rh.png"),
              ),
              Container(
                margin:
                    EdgeInsets.only(bottom: 60 * mediaQuery.size.height / 896),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(primary: textLightColor),
                  child: const Text(
                    "Commencer",
                    style: TextStyle(fontSize: 15, color: textWhite),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
