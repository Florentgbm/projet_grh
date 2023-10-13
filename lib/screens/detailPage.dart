import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:projet_grh/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constants/constant.dart';
import 'homepage.dart';

class DetailPage extends StatefulWidget {
  final dynamic user;
  const DetailPage({super.key, required this.user});

  @override
  State<DetailPage> createState() => _DetailPageState();
}


class _DetailPageState extends State<DetailPage> {
  final ageController = TextEditingController();


  // Fonction appelant la méthode updateUser
  void showUpdateUserPopup(BuildContext context, int userId) {
    String? firstName;
    String? lastName;
    String? email;
    String? location;
    String? phone;
    int? age;

    // Remplissons les champs du formulaire avec les données de l'utilisateur
    firstName = widget.user['firstName'] ?? '';
    lastName = widget.user['lastName']?? '';
    email = widget.user['email']?? '';
    location = widget.user['location']?? '';
    phone = widget.user['phone']?? '';
    age = widget.user['age']?? '';

    showPlatformDialog(
      context: context,
      builder: (_) => LayoutBuilder(
        builder: (context, constraints) {
          return AlertDialog(
            title: const Text(
              'Modifier l\'utilisateur',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Prata',
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            content: SingleChildScrollView(
              child: FormBuilder(
                // Utilisons flutter_form_builder pour construire votre formulaire
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormBuilderTextField(
                      name: 'firstName',
                      decoration: const InputDecoration(labelText: 'Prénom'),
                      onChanged: (val) => firstName = val,
                      initialValue: firstName,
                    ),
                    FormBuilderTextField(
                      name: 'lastName',
                      decoration: const InputDecoration(labelText: 'Nom'),
                      onChanged: (val) => lastName = val,
                      initialValue: lastName,
                    ),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(labelText: 'email'),
                      onChanged: (val) => email = val,
                      initialValue: email,
                    ),
                    FormBuilderTextField(
                      name: 'location',
                      decoration: const InputDecoration(labelText: 'Adresse'),
                      onChanged: (val) => location = val,
                      initialValue: location,
                    ),
                    FormBuilderTextField(
                      name: 'phone',
                      decoration: const InputDecoration(labelText: 'Téléphone'),
                      onChanged: (val) => phone = val,
                      initialValue: phone,
                    ),
                    FormBuilderTextField(
                      name: 'age',
                      decoration: const InputDecoration(labelText: 'Âge'),
                      //controller: ageController,
                      keyboardType: TextInputType.number,
                      // Assurons-nous que le clavier affiché est numérique
                      onChanged: (val) {
                        age = val as int?;
                      },
                      initialValue: age.toString(),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Annuler',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Prata',
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Validons et mettons à jour l'utilisateur dans la base de données
                  // Utilisons la fonction updateUser que nous avons créée précédemment
                  final updatedUser = User(
                    // Mettons à jour les données de l'utilisateur avec les nouvelles valeurs
                    gender: "gender",
                    firstName: firstName ?? "",
                    lastName: lastName ?? "",
                    picture: "https://randomuser.me/api/portraits/women/4.jpg",
                    email: email ?? "",
                    location: location ?? "",
                    phone: phone ?? "",
                    age: age ?? 0,
                  );
                  updateUser(userId, updatedUser);
                  showTopSnackBar(
                    Overlay.of(context),
                    const CustomSnackBar.success(message: "Modification réussie!!"),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: const Text(
                  'Modifier',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Prata',
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }




  // Méthode pour mettre à jour un utilisateur dans la base de données par son ID
  Future<void> updateUser(int userId, User newUser) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      newUser.toMap(),
      where: 'id = ?',
      whereArgs: [userId],
    );
  }



// 1. Créez une méthode pour afficher la boîte de dialogue de confirmation de suppression
  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showPlatformDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmez la suppression',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Prata',
            fontWeight: FontWeight.bold,
            color: textColor,
          ),),
        content: const Text('Voulez-vous vraiment supprimer cet utilisateur ?',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Prata',
            fontWeight: FontWeight.bold,
            color: textColor,
          ),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Prata',
                fontWeight: FontWeight.bold,
                color: textColor,
              ),),
          ),
          TextButton(
            onPressed: () {
              // 2. Supprimez l'utilisateur de la base de données ici
              deleteUser(widget.user['id']); // Remplacez 'id' par la clé primaire appropriée

              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.success(message: "Suppression réussie!!"),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );

            },
            child: const Text('Supprimer',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Prata',
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),),
          ),
        ],
      ),
    );
  }

// Méthode pour supprimer un utilisateur de la base de données par son ID
  Future<void> deleteUser(int userId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }



//Fonction appelant la méthode addUser
  void showAddUserPopup(BuildContext context) {
    String? firstName = "";
    String? lastName = "";
    String? email = "";
    String? location = "";
    String? phone = "";
    int? age = 0;

    showPlatformDialog(
      context: context,
      builder: (_) =>
          LayoutBuilder(
            builder: (context, constraints) {
              return AlertDialog(
                title: const Text(
                  'Ajouter un nouvel utilisateur',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prata',
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                content: SingleChildScrollView(
                  child: FormBuilder(
                    // Utilisez flutter_form_builder pour construire votre formulaire
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FormBuilderTextField(
                          name: 'firstName',
                          decoration: const InputDecoration(labelText: 'Prénom'),
                          onChanged: (val) => firstName = val,
                        ),
                        FormBuilderTextField(
                          name: 'lastName',
                          decoration: const InputDecoration(labelText: 'Nom'),
                          onChanged: (val) => lastName = val,
                        ),
                        FormBuilderTextField(
                          name: 'email',
                          decoration: const InputDecoration(labelText: 'email'),
                          onChanged: (val) => email = val,
                        ),
                        FormBuilderTextField(
                          name: 'location',
                          decoration: const InputDecoration(labelText: 'Adresse'),
                          onChanged: (val) => location = val,
                        ),
                        FormBuilderTextField(
                          name: 'phone',
                          decoration: const InputDecoration(
                              labelText: 'Téléphone'),
                          onChanged: (val) => phone = val,
                        ),
                        FormBuilderTextField(
                          name: 'age',
                          decoration: const InputDecoration(labelText: 'Âge'),
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          // Assurez-vous que le clavier affiché est numérique
                          onChanged: (val) {
                            age = val as int?;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Prata',
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Validons et ajoutons le nouvel utilisateur à la base de données
                      // firstName, lastName, email, location, phone, age sont les valeurs du formulaire

                      addUser(firstName, lastName, email, location, phone, age);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.success(message: "Utilisateur ajouter avec succès!!"),
                      );
                    },
                    child: const Text(
                      'Ajouter',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Prata',
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
    // Méthode pour ajouter un nouvel utilisateur à la base de données
  Future<void> addUser(
      String? firstName,
      String? lastName,
      String? email,
      String? location,
      String? phone,
      int? age,
      ) async {
    final user = User(
      gender: "gender",
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      picture: "https://randomuser.me/api/portraits/women/4.jpg",
      email: email ?? "",
      location: location ?? "",
      phone: phone ?? "",
      age: age ?? 0,
    );

    final db = await DatabaseHelper.instance.database;
    await db.insert('users', user.toMap());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Informations de l'employé",
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
      backgroundColor: textLight2Color,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: textLightColor,
                      blurRadius: 40,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: ClipOval(
                  child: Image.network(
                    widget.user['picture'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Arc(
            edge: Edge.TOP,
            arcType: ArcType.CONVEY,
            height: 30,
            child: Container(
              width: double.infinity,
              color: Light,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35, bottom: 10),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.user['firstName'] } ",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "${widget.user['lastName'] } ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adresse électronique: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "${widget.user['email'] } ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adresse: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "${widget.user['location'] } ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Téléphone: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "${widget.user['phone'] } ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Age: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "${widget.user['age'] } ans",
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Prata',
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton.icon(
                    onPressed: () {
                      // Appelez la fonction showUpdateUserPopup en passant l'ID de l'utilisateur actuel
                      showUpdateUserPopup(context, widget.user['id']);
                    },
                    icon: const Icon(
                      Icons.change_circle_outlined,
                      //color: Colors.red,
                    ),
                    label: const Text(
                      "Modifier les infos",
                      style: TextStyle(
                          fontFamily: 'Prata',
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(textColor),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 13),
                        ),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Light,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: textLight2Color,
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => showDeleteConfirmationDialog(context),
                  icon: const Icon(
                    CupertinoIcons.delete_solid,
                    color: Colors.red,
                  ),
                  label: const Text(
                    "Supprimer l'employé",
                    style: TextStyle(
                        fontFamily: 'Prata',
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(textColor),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 13),
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                ),
                ElevatedButton.icon(
                  onPressed: () => showAddUserPopup(context),
                  icon: const Icon(
                    Icons.add_circle_outline,
                    //color: Colors.red,
                  ),
                  label: const Text(
                    "Ajouter employé",
                    style: TextStyle(
                        fontFamily: 'Prata',
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(textColor),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 13),
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                )
              ],
            ),
          ),
    )
  );

  }
}


