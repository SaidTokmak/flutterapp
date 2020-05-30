import 'dart:io';
import 'package:myapp/model/Task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String taskTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initializeDatabase();
    } 
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //get directory path for device store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path+ 'task.db';

    //open/create the database at path
    var taskDatabase = await openDatabase(path,version : 1, onCreate: _createDb);
    return taskDatabase;
  }

  //create database 
  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //get operation : get all object from database
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    //get database process
    Database db = await this.database;

    //var result = await db.rawQuery('select * from $taskTable');
    var result = await db.query(taskTable);
    return result;
  }

  //insert operation
  Future<int> insertTask(Task task) async{
    Database db = await this.database;

    int result =await db.insert(taskTable, task.toMap());
    return result;
  }

  //update operation
  Future<int> updateTask(Task task) async{
    Database db = await this.database;

    int result =await db.update(taskTable, task.toMap(), where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  //delete operation
  Future<int> deleteTask(int id) async{
    Database db = await this.database;

    int result =await db.rawDelete('delete from $taskTable where $colId = $id');
    return result;
  }

  //get count of task objects in database
  Future<int> getCountTask() async {
    Database db =await this.database;

    List<Map<String, dynamic>> resultList = await db.rawQuery('select count(*) from $taskTable');
    int result = Sqflite.firstIntValue(resultList);
    return result;
  }

  //convert given database maplist to list object
  Future<List<Task>> getTaskList() async {
    var taskMapList = await getTaskMapList();
    int count = taskMapList.length;

    List<Task> taskList = new List<Task>();
    for(int i=0; i<count; i++){
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }
    return taskList;
  }

}