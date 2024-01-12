// late SharedPreferences prefs;

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Controller/Provider/net_provider.dart';
import 'View/my_webview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UrlProvider(),
        )
      ],
      builder: (context, child) => MaterialApp(
        theme: ThemeData.light(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: "Hello",
        home: MyWebView(url: "https://www.google.com/"),
      ),
    );
  }
}
