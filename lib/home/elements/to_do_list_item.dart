import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:todos/firebase_cloud_firestore.dart';
import 'package:todos/home/edit_todo.dart';
import 'package:todos/model/todo.dart';


class toDoListItem extends StatefulWidget {
  final ToDo todo;
  bool selected;


  toDoListItem({
    Key key,
    @required this.todo,this.selected
  }) : assert(todo != null),
        super(key: key);


  @override
  _toDoListItemState createState() => _toDoListItemState();
}

class _toDoListItemState extends State<toDoListItem> {


  @override
  Widget build(BuildContext context) {

    final edit=  IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => EditToDo(todo:widget.todo)));        });
//    final delete=  IconButton(
//        icon: Icon(Icons.delete, color: Colors.red),
//        onPressed: () {});

    final delete=  Padding(
      padding:  EdgeInsets.all(8.0),
      child:CircularCheckBox(
        value: widget.todo.isDone,
        inactiveColor: Color.fromARGB(92,94,100,109),
        activeColor: Colors.red,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onChanged: (bool x) {
          setState(() {
            widget.todo.isDone=!widget.todo.isDone;
            FirestoreHelper.updateToDo(widget.todo);
          });
        },

      ),);

    return  Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xffb3d9ff),
      ),
      width: MediaQuery.of(context).size.width * 0.89,
      height: MediaQuery.of(context).size.height * 0.20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
                children: [
                  Expanded(
                    flex: 8,

                      child: Container(
                          padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.051,top:20,bottom: 20),
                        child: SingleChildScrollView(
                          child: Text(widget.todo.description!=null?widget.todo.description:"",
                            style: TextStyle(
                                color: Color.fromARGB(255,28,28,37),
                              fontSize: 16,
                                decoration: widget.todo.isDone?TextDecoration.lineThrough:TextDecoration.none
                            ),),
                        ),
                    ),),
                  Expanded(
                    flex: 2,
                    child:Container(
                          child: edit,),
                  ),
                  Expanded(
                    flex: 2,
                    child:
                        Container(
                          child: delete,),
                  ),
                ],
              ),
          Padding(
          padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.051),
            child: Text(widget.todo.startDate.day.toString()+"."+
                widget.todo.startDate.month.toString()+"."+
                widget.todo.startDate.year.toString()+" - "+
                widget.todo.endDate.day.toString()+"."+
                widget.todo.endDate.month.toString()+"."+
                widget.todo.endDate.year.toString()
            ),
          )
        ],
      ),
      );
  }



//  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
//    // start the SecondScreen and wait for it to finish with a result
//    final result = await Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => EditToDo(),
//        ));
//
//    // after the SecondScreen result comes back update the Text widget with it
//    if(result!=null && result!=''){
//      setState(() {
//        CreateFamilyDetails.map1.putIfAbsent(result, () => true);
//      });
//    }
//  }
}
