import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper{
  AuthHelper._();

  static final AuthHelper authHelper =AuthHelper._();

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn=GoogleSignIn();

  Future<User?> anonymousSignIn() async{
    UserCredential userCredential = await firebaseAuth.signInAnonymously();
    User? user =userCredential.user;
    return user;
  }

  Future<User?> signUp({required String email,required String password})async{
    UserCredential userCredential =await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user =userCredential.user;
    return user;
  }

  Future<User?> signIn({required String email,required String password})async{
    UserCredential userCredential =await firebaseAuth
    .signInWithEmailAndPassword(email: email, password: password);

    User? user =userCredential.user;
    return user;
  }

  Future<void> signOutUser()async{
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  Future<User?> signInWithGoogle()async{
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }


}