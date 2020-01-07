import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';



String ToDoToJson(ToDo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ToDo {
  String id;
  String description;
  String userId;
  DateTime startDate;
  DateTime endDate;
  bool isDone;

  ToDo({
    this.id,
    this.description,
    this.userId,
    this.startDate,
    this.endDate,
    this.isDone,
  });
  ToDo.def();

  ToDo.beforeAddToFirebase(String userId,String description, DateTime startDate,
  DateTime endDate,bool isDone) {
    this.description = description;
    this.userId = userId;
    this.startDate = startDate;
    this.endDate = endDate;
    this.isDone = isDone;
  }

  factory ToDo.fromJson(Map<String, dynamic> json,DocumentSnapshot doc) => new ToDo(
    id: doc.documentID,
    description: json["description"],
    userId: json["user_id"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    isDone: json["isDone"],


  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "user_id": userId,
    "start_date": startDate.toString(),
    "end_date": endDate.toString(),
    "isDone": isDone,


//    "groups": List<dynamic>.from(groups.map((x) => x.toJson()))
  };

  factory ToDo.fromDocument(DocumentSnapshot doc) {
    return ToDo.fromJson(doc.data,doc);
  }
}
