import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleuth/core/const/color_constants.dart';
import 'package:sleuth/screens/common_widgets/tab_bar.dart';
import 'package:sleuth/screens/onboarding/page/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sleuth',
      theme: ThemeData(
        textTheme:
            TextTheme(bodyText1: TextStyle(color: ColorConstants.textColor)),
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? TabBarPage() : OnboardingPage(),
    );
  }
}
