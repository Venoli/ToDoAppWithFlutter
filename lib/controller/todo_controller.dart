import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todos/model/todo.dart';

class ToDoService {
  static final databaseReference = Firestore.instance;
  static List<ToDo> _todoListData = new List<ToDo>();
  static final ToDoService _singleton = new ToDoService._internal();
  static String userId;
  static ReplaySubject<List<ToDo>> _todo$ = new ReplaySubject<List<ToDo>>();

  factory ToDoService(String _userID) {
    userId = _userID;
    _todo$ = new ReplaySubject<List<ToDo>>();
    getAllToDos();
    return _singleton;
  }
  ToDoService._internal() {
    print("userId : " + userId);
    _todo$ = new ReplaySubject<List<ToDo>>();
    getAllToDos();
  }
  ReplaySubject<List<ToDo>> getToDo() {
    return _todo$;
  }

  static void  getAllToDos(){

    databaseReference
        .collection('todos')
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .listen((data) {
//      _todo$ = new ReplaySubject<List<ToDo>>();
      _todoListData = new List<ToDo>();
      data.documents.forEach((doc) {
        ToDo _t = ToDo.fromDocument(doc);

        _todoListData.add(_t);
      });
      _todo$.add(_todoListData);
    });

  }
}
