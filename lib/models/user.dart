import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  User? _user = FirebaseAuth.instance.currentUser;
  late final StreamSubscription<void> _subscription;

  UserModel() {
    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
      FirebaseCrashlytics.instance.setUserIdentifier(user?.uid ?? "");
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  bool isSignedIn() => _user != null;

  Future<void> signOut() => FirebaseAuth.instance.signOut();

  Future<UserCredential> signIn(String token) =>
      FirebaseAuth.instance.signInWithCustomToken(token);
}
