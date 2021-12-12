import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'Archived_Tasks/ArchivedTasksScreen.dart';
import 'Done_Tasks/DoneTasksScreen.dart';
import 'New_Tasks/NewTasksScreen.dart';
import 'componnent/componnent.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}
List<Map>tasks=[];
Database database;
var TimeController = TextEditingController();
var DateController = TextEditingController();
var TittleController = TextEditingController();
var SacffoldKey = GlobalKey<ScaffoldState>();
var FormKey = GlobalKey<FormState>();
bool IsBottomSheetShown = false;

class _HomeLayoutState extends State<HomeLayout> {
  IconData ICON = Icons.edit;

  int CurrentIndex = 0;
  List<Widget> Screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> ScreensTittle = ["New Tasks ", "Done Tasks ", "Archived Tasks "];
  @override
  void initState() {
    CreatDatabase();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: SacffoldKey,
      appBar: AppBar(
        title: Text(
          ScreensTittle[CurrentIndex],
        ),
      ),
      floatingActionButton: FloatingActionButton(
       // validate:(){ if(FormKey.currentState.validate()){print(TimeController.text,);}},

          child: Icon(
            ICON,
          ),
          backgroundColor: Colors.amber,

          onPressed: () {

            if (IsBottomSheetShown) {
              InsertDatabase (
                database,
                title: TittleController.text,
                date: DateController.text,
                time: TimeController.text,

              ).then((value) {
                Navigator.pop(context);
                setState(() {
                  ICON = Icons.edit;
                });
                IsBottomSheetShown = false;
              });
            } else {
              setState(() {
                ICON = Icons.add;
              });

              SacffoldKey.currentState.showBottomSheet(
                (context) => Container(
                    padding: EdgeInsets.all(20.0),
                    color: Colors.grey[100],
                    child: Column(
                      key: FormKey,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultFormTextField(
                          type: TextInputType.text,
                          Prefix: Icons.title,
                          obscureText: false,
                          text: "task tittle",
                          Controller: TittleController,
                            validate: (value){if(value.isEmpty){return "title must not be empty";}return null;}

                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        DefaultFormTextField(
                          type: TextInputType.datetime,
                          Prefix: Icons.watch,
                          obscureText: false,
                          text: "Task Time",
                          Controller: TimeController,
                          ONTAP: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              TimeController.text =
                                  value.format(context).toString();
                              print(value.format(context));
                            });
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        DefaultFormTextField(
                          type: TextInputType.datetime,
                          Prefix: Icons.calendar_today,
                          obscureText: false,
                          text: "Task Time",
                          Controller: DateController,
                          ONTAP: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse("2022-12-30"),
                            ).then((value) {
                              DateController.text =
                                  DateFormat.yMMMEd().format(value);

                            });
                          },
                        ),
                      ],
                    )),
              ).closed.then((value) {

                setState(() {
                  ICON = Icons.edit;

                });
                IsBottomSheetShown = false;
              });

              IsBottomSheetShown = true;
            }
          },


          heroTag: GetName().then((value) {

            print(value);
          }).catchError(
            (error) {
              print(error.toString);
            },
          ),


          //      onPressed: ()async{
          //  print(await GetName(),);
          //
          //   },
          ),
      body: Screens[CurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        elevation: 70.0,
        type: BottomNavigationBarType.fixed,
        currentIndex: CurrentIndex,
        onTap: (index) {
          setState(() {
            CurrentIndex = index;
          });
          print(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: "Done",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: "Archived",
          ),
        ],
      ),
    );
  }
}

Future<String> GetName() async {
  return "ahmed wahsh";
}

Future<void> CreatDatabase() async {
  try {
    database = openDatabase(
      "Todo.db",
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE tasks (id INTEGER PRIMARY KEY , title Text , date TEXT ,time TEXT ,status TEXT)");
        print("database created");
      },
      onOpen: (database) async {
        await print("database opened");
        GetDataFromDatabase(database).then((value) {
          tasks=value;
          print(tasks);
        });
      },
    )
    as Database;
  } catch (error) {
    print(error.toString());
  }
}

Future InsertDatabase (
    database,
    {@required String title,
    @required String time,
    @required String date,
      }) async {
  return await database.transaction((txn) {
    txn.rawInsert(
      'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new")',
    ).then((value) {
      print('$value inserted successfully');
    }).catchError((error) {
      print('Error When Inserting New Record ${error.toString()}',);
    });
  });
}

Future <List<Map>> GetDataFromDatabase(database)async{
  return tasks=await database.rawQuery('SELECT * FROM tasks ');

}
