import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'HomePage.dart';


Future<void> main() async {
  await Supabase.initialize(
    url:'https://ugauqbfaxhzpxgzdesay.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVnYXVxYmZheGh6cHhnemRlc2F5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NTM3NzksImV4cCI6MjA0NzEyOTc3OX0.Xdb2_xp-RchV-4DwRXrE9fcT6z__ECTrohsdBXTWTPw');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'perpustakaanApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BookListPage(),
    );
  }
}

