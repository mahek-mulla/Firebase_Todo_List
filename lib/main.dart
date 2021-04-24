//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.cyan,
      accentColor: Colors.lightGreen[200],
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List todo = List();
  String input = "";

  createToDos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("mytodos").doc(input);

    //MAp
    Map<String, String> todo = {"todotitle": input};
    documentReference.set(todo).whenComplete(() {
      print("$input created");
    }); //
  }

  deleteToDos() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "My To do List",
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    title: Text("Add ToDo List"),
                    content: TextField(
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          createToDos();
                          Navigator.of(context).pop();
                        },
                        child: Text("Add"),
                      )
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add, color: Colors.black),
          ),
          body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("mytodos").snapshots(),
              builder: (context, snapshots) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshots.data.docs[index];
                    return Dismissible(
                        key: Key(index.toString()),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          shadowColor: Colors.black,
                          child: ListTile(
                            title: Text(documentSnapshot["todotitle"]),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  todo.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ));
                  },
                );
              })),
    );
  }
}
