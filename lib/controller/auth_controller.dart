import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalexamflutter/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  bool isLoggedIn = false;

  Future<UserModel?> addUser(UserModel userModel) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      final userAuth = credential.user;
      await userCollection.doc(userAuth!.uid).set(userModel.toMap());
      return userModel;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userAuth = credential.user;
      if (userAuth == null) {
        return null;
      }
      final user = await userCollection.doc(userAuth.uid).get();
      final userJson = jsonEncode(user.data());
      return UserModel.fromJson(userJson);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return null;
      }
    }
    return null;
  }

  Future<void> isLogin() async {
    final credential = auth.currentUser;
    if (credential != null) {
      isLoggedIn = true;
    }
  }

  Future<UserModel> getUser() async {
    final user = auth.currentUser;
    final userDoc = await userCollection.doc(user!.uid).get();
    final userJson = jsonEncode(userDoc.data());
    return UserModel.fromJson(userJson);
  }

  Future<void> editUser(UserModel newUser) async {
    final user = auth.currentUser;
    await userCollection.doc(user!.uid).update(newUser.toMap());
    await auth.currentUser!.updateEmail(newUser.email);
  }
}
