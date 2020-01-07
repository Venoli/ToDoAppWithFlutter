import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:todos/controller/todo_controller.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/services/authentication.dart';

import '../firebase_cloud_firestore.dart';
import 'elements/to_do_list_item.dart';

class TodoList extends StatefulWidget {
  static HashMap map1 = new HashMap<String, bool>();

  TodoList({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<ToDo> todoData;
//  ScrollController _scrollController;
  final HashMap todoAndListItem = new HashMap<String, toDoListItem>();
  ToDo newToDo = ToDo.def();

//  DateTime selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _scrollController = new ScrollController();
    newToDo.startDate =DateTime.now();
    newToDo.endDate =DateTime.now();
    todoData = new List();

    ToDoService _tds = ToDoService(widget.userId);
    _tds.getToDo().listen(updateStatus);
  }

  updateStatus(List<ToDo> data) {
    setState(() {
      todoData = data;
      print(todoData.length);
    });
  }

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget _buildCategoryWidgets(List<ToDo> toDos) {

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Color(0x00d6dce4),
        endIndent: MediaQuery.of(context).size.width * 0.096,
        indent: MediaQuery.of(context).size.width * 0.109,
        height: MediaQuery.of(context).size.width * 0.054,
      ),
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
//      itemBuilder: (BuildContext context, int index) => categories[index],
      itemBuilder: (context, index) {
        ToDo item = toDos[index];

        return Dismissible(
          // Each Dismissible must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(toDos[index].id),
          // Provide a function that tells the app
          // what to do after an item has been swiped away.
          onDismissed: (direction) {
            // Remove the item from the data source.
            setState(() {

              for(int i =0;i<todoData.length;i++){
                if(todoData[i].id==item.id){
                  todoData.removeAt(i);
                }
              }
              toDos.removeAt(index);
              todoAndListItem.remove(item.id);
              FirestoreHelper.deleteToDo(item.id);



            });

            // Then show a snackbar.
//            Scaffold.of(context)
//                .showSnackBar(SnackBar(content: Text("$item dismissed")));
            Scaffold.of(context)
                .showSnackBar(SnackBar(
              content: Text("Deleted \"${item.description}\""),
              action: SnackBarAction(

                  label: "UNDO",
                  textColor: Colors.blue,
                  onPressed: () {
                    FirestoreHelper.createToDoWithId(item);
                  } )));

          },
          // Show a red background as the item is swiped away.
          background: Container(color: Colors.black),
          child: todoAndListItem[toDos[index].id],
        );
      },
      itemCount: toDos.length,
    );
  }
  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker( //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    return d;
  }
  @override
  Widget build(BuildContext context) {
    final newToDoInput = Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.024,
            left: MediaQuery.of(context).size.width * 0.054,
            right: MediaQuery.of(context).size.width * 0.054,
            bottom: MediaQuery.of(context).size.width * 0.054),
        child: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF880E4F),
          ),
          width: MediaQuery.of(context).size.width * 0.89,
          height: MediaQuery.of(context).size.height * 0.15,
          child: Container(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.075),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.028,
                    ),
                    child: Text(
                      "New ToDo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.051),
                    child: TextFormField(
                      cursorColor: Colors.purple,
                      controller: myController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      onEditingComplete: () {
                        FocusScopeNode currentFocus =
                        FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
//    controller: _textFieldController,
                      decoration: InputDecoration(
                        //Add th Hint text here.
                        hintText: "Enter Description",
                        //Also tstyle the hint as you want here
                        hintStyle: TextStyle(
                          color: Color(0x88F4F7FA),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text("Start Date :",
                        style: TextStyle(color: Colors.white),),
                      IconButton(
                        icon: new Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        onPressed: (){
                          _selectDate(context).then((d){
                            setState(() {
                              newToDo.startDate=d;

                            });
                          });
                        },

                      ),
                    ],
                  ),
                  Row(
                      children: <Widget>[
                        Text("End Date :",
                          style: TextStyle(color: Colors.white),),
                        IconButton(
                          icon: new Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          onPressed: () {
                            _selectDate(context).then((d){
                              newToDo.endDate=d;
                            });
                          },
                        ),]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.065,right: MediaQuery.of(context).size.width*0.045),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.height*0.065,
                              height: MediaQuery.of(context).size.height*0.065,
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                            ),

                            IconButton(
                              icon: new Icon(
                                Icons.done_outline,
                                color: Color(0xFF880E4F),
                                size: 16.0,
                              ),
                              onPressed: () {
                                if (myController.text!='') {

                                  ToDo todo = new ToDo.beforeAddToFirebase(
                                      widget.userId,
                                      myController.text.toString(),
                                      newToDo.startDate,
                                      newToDo.endDate,
                                      false);
                                  FirestoreHelper.createToDo(todo);
                                  myController.clear();
                                }
                                newToDo.startDate =DateTime.now();
                                newToDo.endDate =DateTime.now();
                              },
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ]),
          ),
        ));

    if (todoData != null && todoData.length!=0) {


      todoData.forEach((t) {
        todoAndListItem.putIfAbsent(
            t.id,
                () => toDoListItem(
              todo: t,
              selected: false,
            ));
      });
      List<Widget> dateAndLists = new List<Widget>();

      todoData.sort((a, b) => a.endDate.compareTo(b.endDate));

      List<ToDo> thisDayToDo = new List<ToDo>();
      bool isFirst=true;
      DateTime endDate =todoData[0].endDate;
      for(int i=0;i<todoData.length;i++){
        if(endDate.day==todoData[i].endDate.day&&endDate.month==todoData[i].endDate.month&&endDate.year==todoData[i].endDate.year) {

          if (isFirst) {
            DateTime today=DateTime.now();
            DateTime yesterday = new DateTime(DateTime.now().year, DateTime.now().month , DateTime.now().day-1);
            DateTime tomorrow = new DateTime(DateTime.now().year, DateTime.now().month , DateTime.now().day+1);

            String text='';
            if(endDate.day==today.day&&endDate.month==today.month&&endDate.year==today.year){
              text="Today";
            }else if(endDate.day==yesterday.day&&endDate.month==yesterday.month&&endDate.year==yesterday.year){
              text="Yesterday";
            }else if(endDate.day==tomorrow.day&&endDate.month==tomorrow.month&&endDate.year==tomorrow.year){
              text="Tomorrow";
            }else{
             text =endDate.day.toString()+"."+endDate.month.toString()+"."+endDate.year.toString();
            }

            dateAndLists.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text, style: TextStyle(color: Color(0xff94b8b8),
                  fontWeight: FontWeight.bold,fontSize: 16),),
            ));
            isFirst = false;
          }

          thisDayToDo.add(todoData[i]);

          if (i+1<todoData.length){
            if (!(endDate.day==todoData[i+1].endDate.day&&endDate.month==todoData[i+1].endDate.month&&endDate.year==todoData[i+1].endDate.year)) {
              thisDayToDo.forEach((F){
                print(F.id);
              });
              dateAndLists.add(
                _buildCategoryWidgets(thisDayToDo),
              );

              endDate = todoData[i + 1].endDate;
              thisDayToDo = new List<ToDo>();
              isFirst = true;
            }
        }else{
            thisDayToDo.forEach((F){
              print(F.id);
            });
            dateAndLists.add(
              _buildCategoryWidgets(thisDayToDo),
            );
          }
        }
      }

//      final listView = Container(
//        child: _buildCategoryWidgets(),
//      );

      // Scroll to first selected item
//      for (int i = 0; i < todoData.length; i++) {
//        if (todoAndListItem[todoData[i].id].selected) {
//          _scrollController.animateTo(
//              i * MediaQuery.of(context).size.height * 0.10,
//              duration: new Duration(seconds: 2),
//              curve: Curves.ease);
//          break;
//        }
//      }




      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            leading:
//          new IconButton(
//            icon:
            new Icon(
              Icons.bookmark,
              color: Colors.white,
              size: 16.0,
            ),
//            onPressed: () => Navigator.of(context).pop(),
//          ),
            title: Text("ToDo"),
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Color(0xFF880E4F),
//          actions: <Widget>[
//            (new FlatButton(
//              child: new Text("Done",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                    color: Colors.black,
//                    fontSize: 16.0,
//                  )),
//              onPressed: (){
////                _createHome();
//                },
//            )),
//          ],
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Logout',
                      style:
                      new TextStyle(fontSize: 17.0, color: Colors.white)),
                  onPressed: signOut)
            ],
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.black),
            child: SingleChildScrollView(
//              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.054,
                        top: MediaQuery.of(context).size.width * 0.070,
                      ),
                      child: Column(
                        children:dateAndLists,
                      )),

                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  transitionDuration: Duration(microseconds: 100),
                  barrierColor: Color(0xffadb6c1).withOpacity(.8),
                  barrierLabel: 'Dialog',
                  pageBuilder: (_, __, ___) {
                    return Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.25,
                          bottom:
                          MediaQuery
                              .of(context)
                              .size
                              .height * 0.25,
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    (0.03),
                                right: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    (0.03)),
                            child: GestureDetector(
                              onTap: () {
                                FocusScopeNode currentFocus = FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              child: Scaffold(
                                  resizeToAvoidBottomPadding: false,
                                  backgroundColor: Colors.transparent,
                                  body: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[

                                        newToDoInput
                                      ])),)
                        )
                    );
                  });
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF880E4F),
          ),
//          bottomNavigationBar: dateTimePicker,
        ),
      );
    }else{

      return  GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            leading:
//          new IconButton(
//            icon:
            new Icon(
              Icons.bookmark,
              color: Colors.white,
              size: 16.0,
            ),
//            onPressed: () => Navigator.of(context).pop(),
//          ),
            title: Text("ToDo"),
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Color(0xFF880E4F),
//          actions: <Widget>[
//            (new FlatButton(
//              child: new Text("Done",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                    color: Colors.black,
//                    fontSize: 16.0,
//                  )),
//              onPressed: (){
////                _createHome();
//                },
//            )),
//          ],
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Logout',
                      style:
                      new TextStyle(fontSize: 17.0, color: Colors.white)),
                  onPressed: signOut)
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.black),
            child: SingleChildScrollView(
//              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.054,
                        top: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child:
                         Center(
                           child: Text("You haven't any ToDos yet",
                           style: TextStyle(color: Color(0xff85adad),
                           fontWeight: FontWeight.bold,fontSize: 16),
                           ),
                         )
                       ),

                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  transitionDuration: Duration(microseconds: 100),
                  barrierColor: Color(0xffadb6c1).withOpacity(.8),
                  barrierLabel: 'Dialog',
                  pageBuilder: (_, __, ___) {
                    return Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.25,
                          bottom:
                          MediaQuery
                              .of(context)
                              .size
                              .height * 0.25,
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    (0.03),
                                right: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    (0.03)),
                            child: GestureDetector(
                              onTap: () {
                                FocusScopeNode currentFocus = FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              child: Scaffold(
                                  resizeToAvoidBottomPadding: false,
                                  backgroundColor: Colors.transparent,
                                  body: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[

                                        newToDoInput
                                      ])),)
                        )
                    );
                  });
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF880E4F),
          ),
//          bottomNavigationBar: dateTimePicker,
        ),
      );
    }
  }



  handleNewDate(DateTime date) {
//                    for (var item in todoData) {
//                  toDoListItem tItem = todoAndListItem[item.id];
//
//                  if (item.date.month == date.month &&
//                      item.date.day == date.day&&
//                      item.date.year == date.year ) {
//                    setState(() {
//                      tItem.selected = true;
//
//                      todoAndListItem.update(item.id, (e) => tItem,
//                          ifAbsent: () => tItem);
//                    });
//
//                  } else {
//                    setState(() {
//                      tItem.selected = false;
//                      todoAndListItem.update(item.id, (e) => tItem,
//                          ifAbsent: () => tItem);
//                    });
//
//                  }
//                }
  }

//  void _createHome() async{
//    if(myController.text!='') {
//    List<Group> rooms=[];
//      List<String> rooms = [];

//    map1.forEach((key, value) {
//     if (value){
//       Group group=new Group(key, 1, null,);
//       rooms.add(group);
//     }
//    });
//      CreateFamilyDetails.map1.forEach((key, value) {
//        if (value) {
//          rooms.add(key);
//        }
//      });
//      var db = new DatabaseHelper();
//      User user;

//    Homes home =new Homes(myController.text,user.username,rooms,null);
//    await db.saveHome(home);

//      await db.saveHome(myController.text, user.username, rooms);

//    }
//
//    Navigator.push(context,
//        MaterialPageRoute(builder: (context) => HomePage()));
//  }
  signOut() async {
    try {
      todoData = null;
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}
