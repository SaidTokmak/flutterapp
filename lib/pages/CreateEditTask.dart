import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/model/Task.dart';
import 'package:myapp/utils/database_helper.dart';

class CreateTask extends StatefulWidget {
  final String appBarTitle;
  final Task task;
  CreateTask(this.task, this.appBarTitle);

  @override
  _CreateTaskState createState() => _CreateTaskState(this.task,appBarTitle);
}

class _CreateTaskState extends State<CreateTask> {
  String appBarTitle;
  Task task;
  _CreateTaskState(this.task, this.appBarTitle);

  static var _priorities = ['High','Medium','Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    titleController.text = task.title;
    descriptionController.text = task.description;

    return WillPopScope( 
      onWillPop: (){
        moveToLastScreen();
      },
      child : Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
            moveToLastScreen();
          }),
        ),
        body : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children : <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      DropdownButton(
                        items: _priorities.map((String dropDownStringItem){
                          return DropdownMenuItem<String>(
                            child: Text(dropDownStringItem),
                            value: dropDownStringItem,);
                          }).toList(), 
                        value: getPriorityAsString(task.priority),  
                        onChanged: (priority){
                          setState(() {
                            updatePriorityAsInt(priority);
                          });
                        }
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: titleController,
                    onChanged: (value){
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Task Konusu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: descriptionController,
                    onChanged: (value){
                      updateDesc();
                    },
                    decoration: InputDecoration(
                      labelText: 'Task Açıklaması',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: (){
                            setState(() {
                              _save();
                            });
                          },
                          child: Text('Kaydet', textScaleFactor: 1.5,),
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: (){
                            setState(() {
                              moveToLastScreen();
                            });
                          },
                          child: Text('Vazgeç', textScaleFactor: 1.5,),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High': 
        task.priority = 1;
        break;
      case 'Medium':
        task.priority = 2;
        break;   
      default: 
        task.priority = 3;
        break;
    }
  }

  String getPriorityAsString(int index) {
    switch (index) {
      case 1: return _priorities[0];
      case 2: return _priorities[1];
      case 3: return _priorities[2];   
        break;
      default: return _priorities[3];
    }
  }

  void updateTitle() {
    task.title = titleController.text;
  }

  void updateDesc() {
    task.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();

    task.date = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    int result;
    if(task.id != null) {  //update
      result = await DatabaseHelper().updateTask(task);
    } else { //insert
      result = await DatabaseHelper().insertTask(task);
    }
    if(result != null) {
      _showAlertDialog('Bilgilendirme','Task başarıyla kaydedildi.');
    }else{
      _showAlertDialog('Bilgilendirme','Task başarıyla kaydedildi.');
    }
    
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}