import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_kepper/Controller/AuthHelper.dart';
import 'package:firebase_kepper/Controller/FirestoreHelper.dart';
import 'package:firebase_kepper/View/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login_page extends StatefulWidget {
  const login_page({Key? key}) : super(key: key);

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true, // Hide the input for password
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ])),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: OutlinedButton(
                    onPressed: () async {
                        if (_formKey.currentState!.validate()) {

                          String email = _emailController.text.trim();
                          bool userExists = await FirestoreHelper.firestoreHelper.checkUserExists(email);

                          if (!userExists) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("No account found with this email. Please create an account.")),
                            );
                          _showCreateAccountDialog();
                            return;
                          }
                              User? user = await AuthHelper.authHelper.signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              );

                if (user != null) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('user_login', true);
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("User sign in successfully... ")));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home_page(),));
                } else {
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("User sign in faild... ")));
                }
              }},
                    child: Text("SignIn")),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: OutlinedButton(
                  onPressed: () async {
                    User? user = await AuthHelper.authHelper.signInWithGoogle();

                    if (user != null) {
                      String email = user.email!;


                      bool userExists = await FirestoreHelper.firestoreHelper.checkUserExists(email);


                      if (!userExists) {
                        await FirestoreHelper.firestoreHelper.addUsers(email: email);
                      }


                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('user_login', true);


                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("User signed in successfully...")),
                      );
                      Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => home_page()),
                      );
                    } else {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Google sign-in failed...")),
                      );
                    }
                  },
                  child: Text("Sign In With Google"),
                ),
              ),



              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () {
                    _showCreateAccountDialog();
                  },
                  child: Text("Does not have an account? Create account...."),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
  void _showCreateAccountDialog() {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (email.isNotEmpty && password.isNotEmpty) {
                  bool userExists = await FirestoreHelper.firestoreHelper.checkUserExists(email);

                  if (!userExists) {
                    User? user = await AuthHelper.authHelper.signUp(email: email, password: password);
                    if (user != null) {
                      await FirestoreHelper.firestoreHelper.addUsers(email: email);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('user_login', true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Account created successfully!")),
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home_page()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Account creation failed.")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Account with this email already exists. Please sign in.")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter both email and password.")),
                  );
                }
              },
              child: Text("Create Account"),
            ),
          ],
        );
      },
    );
  }
}
// Padding(
//   padding: const EdgeInsets.only(top: 20),
//   child: OutlinedButton(
//       onPressed: () async {
//         User? user = await AuthHelper.authHelper.anonymousSignIn();
//
//         if (user != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("User sign in successfully... ")));
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("User sign in faild... ")));
//         }
//       },
//       child: Text("Anonymous SignIn")),
// ),