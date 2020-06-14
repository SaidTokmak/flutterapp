import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
   HomePageState createState() =>  HomePageState();
}

class  HomePageState extends State <HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TaskingMe!'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/saidwallpaper.jpg"),
            fit: BoxFit.cover, 
          )
        ),

      ),      
    );
  }
}