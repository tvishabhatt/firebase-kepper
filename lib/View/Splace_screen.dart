import 'dart:async';
import 'package:firebase_kepper/View/IntroPage.dart';
import 'package:firebase_kepper/View/home_page.dart';
import 'package:firebase_kepper/View/login_page.dart'; // Import your login page here
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splace_Screen extends StatefulWidget {
  const Splace_Screen({Key? key}) : super(key: key);

  @override
  State<Splace_Screen> createState() => _Splace_ScreenState();
}

class _Splace_ScreenState extends State<Splace_Screen> {
  @override
  void initState() {
    super.initState();
    navigateUser();
  }

  Future<void> navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool seenIntro = prefs.getBool('intro_is_seen') ?? false;

    bool isLoggedIn = prefs.getBool('user_login') ?? false;

    await Future.delayed(Duration(seconds: 3));

    if (!seenIntro) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => IntroPage()));

    } else if (isLoggedIn) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home_page()));

    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => login_page()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 400),
            Center(
              child: Text(
                "Books APP",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Expanded(child: SizedBox()),
            Text(
              "Made in India with ❤️.",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
