import 'dart:convert';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:projet_grh/models/user.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../constants/constant.dart';
import 'detailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> users = [];
  String searchQuery = ''; // Variable pour stocker le texte de recherche


  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }
//Fonction de rafraîchissement de la page 
  Future<void> _refreshData() async {
    await fetchDataFromDatabase();
  }

  // Fonction pour trier  les utilisateurs
  List<Map<String, dynamic>> reverseUsersOrder(List<Map<String, dynamic>> userList) {
    return userList.reversed.toList();
  }


// La méthode qui nous permet d'appeler notre méthode fetchUsersFromDatabase() définit au niveau du fichier constant
  Future<void> fetchDataFromDatabase() async {
    final fetchedUsers = await fetchUsersFromDatabase();
    final reversedUsers = reverseUsersOrder(fetchedUsers);
    setState(() {
      users = reversedUsers;
    });
  }

  void showSnackBar(String message) {
    final overlayState = Overlay.of(context);
    if (overlayState != null) {
      showTopSnackBar(
        overlayState,
        CustomSnackBar.error(
          message: message,
          textStyle: TextStyle(color: Colors.white),
          backgroundColor: Colors.red,
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  // Fonction retournant la barre de recherche

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      decoration: BoxDecoration(
        color: Light,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: textColor, // Couleur de l'ombre
            blurRadius: 4, // Flou de l'ombre
            spreadRadius: 1, // Écart de l'ombre
            offset: Offset(0, 2), // Position de l'ombre (horizontal, vertical)
          )
        ],
      ),
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(
          child: Row(
            children: [
              Container(
                // Search widget
                margin: EdgeInsets.only(left: 5),
                height: 50,
                width: 250,
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Rechercher un employé",
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value; // Mettre à jour le texte de recherche
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  //Fonction de filtrage des utilisateurs par nom et prénom
  List<Map<String, dynamic>> getFilteredUsers() {
    // Filtrons les utilisateurs en fonction du texte de recherche
    return users
        .where((user) =>
    user['lastName']
        .toLowerCase()
        .contains(searchQuery.toLowerCase()) ||
        user['firstName']
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Liste du personnel",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'SecularOne',
              fontSize: 20,
              color: textColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: Light,
          iconTheme: const IconThemeData(
            color:
                darkColor, // Définir la couleur des icônes de la barre d'applications
          ),
        ),
        body: Column(children: [
          // Nous plaçons ici notre barre de recherche
          buildSearchBar(),
          Expanded(
            child: RefreshIndicator(
              key: UniqueKey(),
              onRefresh: _refreshData, // Méthode à appeler lors du rafraîchissement
              child: ListView(children: [
                Container(
                    //height: 500,
                    padding: const EdgeInsets.only(top: 15),
                    decoration: const BoxDecoration(
                        color: textLight2Color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        )),
                    child: Column(
                      children: [
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: fetchUsersFromDatabase(),
                          // Remplacez par votre future pour charger les utilisateurs
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Afficher un indicateur de chargement pendant le chargement des utilisateurs
                              return const Center(
                                  child: ColorfulCircularProgressIndicator(
                                colors: [
                                  textColor,
                                  textLightColor,
                                  textLight2Color
                                ],
                                strokeWidth: 8,
                                indicatorHeight: 60,
                                indicatorWidth: 60,
                              ));
                            } else if (snapshot.hasError) {
                              // Afficher un message d'erreur si une erreur s'est produite lors du chargement des utilisateurs
                              final errorMessage = snapshot.error.toString();
                              WidgetsBinding.instance!.addPostFrameCallback((_) {
                                showSnackBar(errorMessage);
                              });
                              return const Center(
                                child: ColorfulCircularProgressIndicator(
                                  colors: [
                                    textColor,
                                    textLightColor,
                                    textLight2Color
                                  ],
                                  strokeWidth: 8,
                                  indicatorHeight: 60,
                                  indicatorWidth: 60,
                                ),
                              );
                            } else if (snapshot.hasData) {
                              // Affichons la liste des utilisateurs une fois qu'ils sont chargés
                              final users = getFilteredUsers();
                              return GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 0.68,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  for (int i = 0; i < users.length; i++)
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, top: 8),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Light,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 2),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    users[i]['lastName'],
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: textColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Prata',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 2),
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    users[i]['firstName'],
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: textColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Prata',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(1),
                                            child: Image.network(
                                              users[i]['picture'],
                                              height: 160,
                                              width: 180,
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPage(
                                                    user: users[i],
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.info_rounded,
                                              //color: Colors.red,
                                            ),
                                            label: const Text(
                                              "Voir les infos",
                                              style: TextStyle(
                                                  fontFamily: 'Prata',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        textColor),
                                                padding:
                                                    MaterialStateProperty.all(
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2, horizontal: 4),
                                                ),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8)))),
                                          )
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      ],
                    ))
              ]),
            ),
          ),
        ]));
  }
}
