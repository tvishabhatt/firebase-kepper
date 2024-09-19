import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_kepper/Controller/BookmarkProvider.dart';
import 'package:firebase_kepper/Controller/ThemeController.dart';
import 'package:firebase_kepper/View/Splace_screen.dart';
import 'package:firebase_kepper/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
try{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
}
catch(e){
  print('Firebase initialization failed: $e');
}

  runApp(
      MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (context) => ThemeController(),),
       ChangeNotifierProvider(create: (context) => BookmarkProvider(),)
        ],
        child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeController=Provider.of<ThemeController>(context);
    return MaterialApp(
      title: 'Books App',
      debugShowCheckedModeBanner: false,
      theme:themeController.isDarkTheme ?ThemeData.dark():ThemeData.light(),
      home:Splace_Screen(),
    );
  }
}

