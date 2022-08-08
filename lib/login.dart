import 'dart:io';

import 'package:file_pick/file_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String path = "";
  late String _email, _password;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("login"),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          label: Text("Email-Address")),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          label: Text("Password"),
                          suffixIcon: Icon(Icons.remove_red_eye)),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        auth
                            .signInWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((value) => Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FilePick();
                                })))
                            .catchError((error) => showDialog(
                                context: context,
                                builder: (context) {
                                  return Text(error.toString());
                                }));
                      },
                      child: Container(
                        child: Center(
                            child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                        color: Color.fromRGBO(0, 10, 141, 1),
                        width: double.infinity,
                        height: 60,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "don't have an account? ",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
