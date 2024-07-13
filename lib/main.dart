import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:info_portal/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDZrYolma9f6f6LRo8aGzQnyqwyLvY3wLs",
          appId: "1:523530339165:android:fb6f5d6283258d046e5eb4",
          messagingSenderId: "523530339165",
          projectId: "info-portal-300dd"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
