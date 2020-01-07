import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'model/todo.dart';


class FirestoreHelper with ChangeNotifier {
  static String tuyaAccessToken = "";
  static String tuyaGetDeviceToken = "";
  static final databaseReference = Firestore.instance;

  static void createToDo(ToDo todo) async {
//    print(todo.date.toString()+todo.description +todo.user_id);

    await databaseReference
        .collection('todos')
        .document()
        .setData({
      'user_id': todo.userId,
      'description': todo.description,
      'start_date': todo.startDate.toString(),
      'end_date': todo.endDate.toString(),
      'isDone':todo.isDone
    });
  }
  static void createToDoWithId(ToDo todo) async {
//    print(todo.date.toString()+todo.description +todo.user_id);

    await databaseReference
        .collection('todos')
        .document(todo.id)
        .setData({
      'user_id': todo.userId,
      'description': todo.description,
      'start_date': todo.startDate.toString(),
      'end_date': todo.endDate.toString(),
      'isDone':todo.isDone
    });
  }

  static void updateToDo(ToDo todo) async {
//    print(todo.date.toString()+todo.description +todo.user_id);

    await databaseReference
        .collection("todos")
        .document(todo.id)
        .updateData({
      'description': todo.description,
      'start_date': todo.startDate.toString(),
      'end_date': todo.endDate.toString(),
      'isDone':todo.isDone
        });
  }
  static void deleteToDo(String id) async {

    try {
      databaseReference
          .collection('todos')
          .document(id)
          .delete();
    } catch (e) {
    print(e.toString());
    }
  }








//  static Future<List<String>> getData() async {
//    final List<String> recommendRooms = <String>[];
//    await databaseReference
//        .collection("todos")
//        .getDocuments()
//        .then((QuerySnapshot snapshot) {
//      snapshot.documents.forEach((f) => recommendRooms.add(f.data['name']));
//    });
//
//    return recommendRooms;
//  }




}
