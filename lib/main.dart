import 'package:flutter/material.dart';
import 'package:todos/services/authentication.dart';

import 'home/todo_list.dart';
import 'login_and_register/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(title: 'ToDo'),
//    );
//  }
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color =
    {
      50:Color.fromRGBO(136,14,79, .1),
      100:Color.fromRGBO(136,14,79, .2),
      200:Color.fromRGBO(136,14,79, .3),
      300:Color.fromRGBO(136,14,79, .4),
      400:Color.fromRGBO(136,14,79, .5),
      500:Color.fromRGBO(136,14,79, .6),
      600:Color.fromRGBO(136,14,79, .7),
      700:Color.fromRGBO(136,14,79, .8),
      800:Color.fromRGBO(136,14,79, .9),
      900:Color.fromRGBO(136,14,79, 1),
    };
    MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);
    return new MaterialApp(
        title: 'ToDos',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: colorCustom
        ),
        home: new RootPage(auth: new Auth()));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  @override
//  void initState() {
//    super.initState();
//    Navigator.of(context).pushReplacement(new MaterialPageRoute(
//        builder: (BuildContext context) => TodoList()));
//
//  }

  @override
  Widget build(BuildContext context) {

    final text1 = FlatButton(
      onPressed:   (){Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => TodoList()));},
        child:Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09),
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromARGB(255, 36, 36, 44),
              fontSize: MediaQuery.of(context).size.height * 0.038,
              fontWeight: FontWeight.w400),
        )));
//

    print(MediaQuery.of(context).size.height);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              text1,
            ],
          )
        ],
      ),
    );
  }

//  floatingActionButton: FloatingActionButton(
//  onPressed: _incrementCounter,
//  tooltip: 'Increment',
//  child: Icon(Icons.add),
//  )

}
