import 'package:flutter/material.dart';

import 'dart:async';

import 'package:todos/model/todo.dart';

import '../firebase_cloud_firestore.dart';

class EditToDo extends StatefulWidget {
  final ToDo todo;

  EditToDo({Key key, @required this.todo})
      : assert(todo != null),
        super(key: key);

  @override
  _EditToDoState createState() => _EditToDoState();
}

class _EditToDoState extends State<EditToDo> {
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController.text = widget.todo.description;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomNameInput = Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.051),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF880E4F),
      ),
      width: MediaQuery.of(context).size.width * 0.89,
        height: MediaQuery.of(context).size.height * 0.40,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.028,),
              child: Text(
                "Enter Description",
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
                      style: TextStyle(color: Color(0xff94b8b8), fontSize: 16.0),
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
                       style: TextStyle(color: Colors.white, fontSize: 16.0,),),
                     IconButton(
                        icon: new Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        onPressed: () {
                          _selectDate(context).then((d) {
                            if(d!=null){
                            setState(() {
                              widget.todo.startDate = d;
                            });}
                          });
                        },
                      ),

                     Text(widget.todo.startDate.day.toString()+"."+
                     widget.todo.startDate.month.toString()+"."+
                     widget.todo.startDate.year.toString(),
                       style: TextStyle(color: Color(0xff94b8b8), fontSize: 16.0,),)
                   ],
                 ),

                 Row(
                   children: <Widget>[
                     Text("End Date :",
                       style: TextStyle(color: Colors.white,fontSize: 16.0,),),
                     IconButton(
                        icon: new Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        onPressed: () {
                          _selectDate(context).then((d) {
                            if(d!=null){
                              setState(() {
                                widget.todo.endDate = d;

                              });}

                          });
                        },
                      ),
                     Text(widget.todo.endDate.day.toString()+"."+
                         widget.todo.endDate.month.toString()+"."+
                         widget.todo.endDate.year.toString(),
                       style: TextStyle(color: Color(0xff94b8b8), fontSize: 16.0,),)
                   ],
                 ),


          ]),
    );

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
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 16.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Edit ToDo"),
          textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Color(0xFF880E4F),
          actions: <Widget>[
            (new FlatButton(
              child: new Text("Done",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
              onPressed: () {
                if (myController.text != '') {
                  widget.todo.description = myController.text;
                }
                FirestoreHelper.updateToDo(widget.todo);
                Navigator.of(context).pop();
              },
            )),
          ],
        ),
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: roomNameInput,
            ),
          ),
        ]),
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );


    return d;
  }
}
