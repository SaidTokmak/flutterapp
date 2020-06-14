import 'package:flutter/material.dart';
import 'package:myapp/model/Task.dart';
import 'package:myapp/pages/CreateEditTask.dart';
import 'package:myapp/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      taskList = new List<Task>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasklar :)'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToCreateEditTask(Task('', '', 3, ''), 'Task Ekle');
        },
        tooltip: 'Task Ekle',
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int index) =>
              buildTaskCard(context, index)),
    );
  }

  Widget buildTaskCard(BuildContext context, int index) {
    final task = taskList[index];
    return Container(
      child: GestureDetector(
        onTap: () {navigateToCreateEditTask(task, 'Task Düzenle');},
        child: new Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: getPriority(task.priority),
              width: 1.0,
            ),
          ),
          elevation: 5,
          margin: EdgeInsets.only(top: 2, bottom: 6, left: 8, right: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(children: <Widget>[
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child : Text(
                        task.title,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      )
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(task.date)
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(children: <Widget>[
                    Flexible(
                      flex: 8,
                      fit: FlexFit.tight,
                      child: Text(
                        task.description,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          iconSize: 20,
                          icon: Icon(Icons.delete_outline),
                          color: Colors.redAccent,
                          onPressed: () {
                            setState(() {
                              _showAlertDialog(context,task);
                            });
                          }
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          )),
      ),
    );
  }

  void _delete(BuildContext context, Task task) async {
    int result = await databaseHelper.deleteTask(task.id);

    if (result != 0) {
      _showSnackBar(context, 'Task başarılı şekilde silindi');
      updateListView();
    }
  }

  void navigateToCreateEditTask(Task task, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CreateTask(task, title);
    }));

    if (result) {
      updateListView();
    }
  }

  Color getPriority(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.blue;

        break;
      default:
        return Colors.blue;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  }

  void _showAlertDialog(BuildContext context,Task task) {
    
      String taskTitle;

      if(task.title.isNotEmpty && task.title != null){
        taskTitle = task.title;
      }else{
        taskTitle = "Seçili ";
      }

      Widget cancelButton = FlatButton(
        child: Text("Sil"),
        onPressed:  () {
          _delete(context, task);
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      );

      Widget continueButton = FlatButton(
        child: Text("İptal Et"),
        onPressed:  () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Uyarı"),
        content: Text(taskTitle + " taskını silmek istediğine emin misin?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
}

/*Future<void> _showAlertDialog(BuildContext context,Task task) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Bilgilendirme'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Bu taskı silmek istediğinize emin misiniz?'),
            ],
          ),
        ),
        actions: <Widget>[
        FlatButton(
        child: Text("İptal Et"),
        onPressed:  () {
          Navigator.of(context).pop('dialog');
        },
      ),
      FlatButton(
        child: Text("Sil"),
        onPressed:  () {
          _delete(context, task);
          Navigator.of(context).pop('dialog');
        },
      )
        ],
      );
    },
  );
}*/
}
