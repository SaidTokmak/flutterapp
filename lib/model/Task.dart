class Task {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  //default constructer and withId construcker
  Task(this._title, this._date, this._priority, [this._description]);
  
  Task.withId(this._id, this._title, this._date, this._priority, [this._description]);

  //write getter methods
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  //write setter methods
  set title(String newTitle){
    if(newTitle.length <= 30){
      this._title = newTitle;
    }
  }
  set description(String newDescription){
    if(newDescription.length <= 255){
      this._description = newDescription;
    }
  }
  set priority(int newPriority){
    this._priority = newPriority;
  }
  set date(String newDate){
    this._date = newDate;
  }

  //Convert Task object to Map object because Sqflite required Map object
  Map<String,dynamic> toMap() {
    var map = Map<String,dynamic>();
    if(_id != null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  //Convert Map object to Task object
  Task.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}