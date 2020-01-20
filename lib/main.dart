import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _calendarController;
  List<dynamic> _selectedEvents;
  Map<DateTime, List<dynamic>> _events;
  TextEditingController _eventController;
  final usersRef = Firestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _selectedEvents = [];
    _eventController = TextEditingController();
    _events = {};

  }


  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map){
    Map<String, dynamic> newMap ={};
    map.forEach((key, value){
      newMap[key.toString()] =map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map){
    Map<DateTime, dynamic> newMap ={};
    map.forEach((key, value){
      newMap[DateTime.parse(key)] =map[key];
    });
    return newMap;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.week,
            onDaySelected: (date, events){
              setState(() {
                _selectedEvents = events;
              });
            },
              calendarStyle: CalendarStyle(
                todayColor: Colors.orange,
                selectedColor: Theme.of(context).primaryColor,
                todayStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
              ),
                calendarController: _calendarController,
           ),
            ... _selectedEvents.map((event) => ListTile(
              title: Text(event),
            ))


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _getListClassrooms,
      ),
    );
  }
  _showAddDialog(){
    showDialog(
      context: context,
      builder: (context) =>AlertDialog(
        content: TextField(
          controller: _eventController,

        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Save"),
            onPressed: (){
              print(_selectedEvents);
              if(_eventController.text.isEmpty) return;
              setState(() {


              if(_events[_calendarController.selectedDay] != null){
                _events[_calendarController.selectedDay].add(_eventController.text);
              }else{
                _events[_calendarController.selectedDay] =[_eventController.text];
              }
              _eventController.clear();
              Navigator.pop(context);
              });
            },
          )
        ],
      )

    );
  }
}




_getListClassrooms() {
  final usersRef = Firestore.instance.collection('classrooms');

  usersRef
      .getDocuments()
      .catchError((e) => print("${e.toString()}"))
      .then((QuerySnapshot data) {
    for (int i = 0; i < data.documents.length; i++) {
      print("print, $data.documents[i].data");
    }

});
      }



