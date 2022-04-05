import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Screens/home_screen.dart';

Future<void> main() async {
  // Initializing Firestore
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBlm_EQi7cs3Z3frfqUfg3F8hqnqVU2kFU",
      authDomain: "fluttermemoapplication.firebaseapp.com",
      projectId: "fluttermemoapplication",
      storageBucket: "fluttermemoapplication.appspot.com",
      messagingSenderId: "116888741394",
      appId: "1:116888741394:web:d0baf78f4e5be239769acb",
    ),
  );
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // Home Widget
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memo Pro',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}
