import 'package:flutter/material.dart';
import 'package:myapp/pages/HomePage.dart';
import 'package:myapp/pages/TaskList.dart';
import 'package:myapp/pages/ExportJson.dart';

void main() => runApp(MaterialApp(home: Myapp()));

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskingMe',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        body: callPage(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Anasayfa'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_list),
                title: Text('Task Listesi'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.import_export),
                title: Text('Dışa/içe Aktar'),
              ),
            ]),
      ),
    );
  }
  
  Widget callPage(int currentIndex){
    switch (currentIndex) {
      case 0 : return HomePage(); 
      case 1 : return TaskList(); 
      case 2 : return Export(); 
        
        break;
      default : return TaskList(); 
    }
  }
}
