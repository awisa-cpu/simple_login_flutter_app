import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_flutterapp/screens/login_page.dart';
import 'package:login_flutterapp/screens/welcome_page.dart';
import 'dart:developer' show log;

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(
      auth.userChanges(),
    );
    //the above function just binds the changes/notifications to the user from firebase.auth
    // but then we need to process those changes using the ever
    ever(_user, _initialScreen);
    //the above function takes in a listener which is the user
    //  and a call back function to call anytime the listener receives any changes
  }

  _initialScreen(User? user) {
    if (user == null) {
      log("Login page");
      Get.offAll(
        () => const LoginPage(),
      );
    } else {
      Get.offAll(
        () => WelcomePage(
          email: user.email,
        ),
      );
    }
  }

  void registerUser(String email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar(
        "About User",
        "User Message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account Creation Failed",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void logIn(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar(
        "About Login",
        "Login Message",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        titleText: const Text(
          "Login Failed",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void logOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      Get.snackbar(
        "Logout Error",
        "Logout failure",
        titleText: const Text(
          "Try again",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
