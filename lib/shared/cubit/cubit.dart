import 'package:bloc/bloc.dart';
import 'package:taskpro/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:taskpro/modules/done_tasks/done_tasks_screen.dart';
import 'package:taskpro/modules/new_tasks/new_tasks_screen.dart';
import 'package:taskpro/shared/components/constants.dart';
import 'package:taskpro/shared/cubit/states.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  // object :
  static AppCubit get(context) => BlocProvider.of(context);
// cubit with bottomnavigation ber
  int currentIndex = 0;
  List<Widget> Screens = [
    newTasksScreen(),
    DoneTasksScreen(),
    archivedTasksScreen(),
  ];
  List<String> Titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void ChangeIndexs(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  // instace of ' Future <String>'
  /*Future<String> getName() async {
    return 'Yara AL-hassan';
  }*/

  // db
  //1. create database

  //cubit with database
  late Database database;
  List<Map> NewTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      // name db
      'todo.db',
      version: 1,
      onCreate: (database, version) {
// id integer
//title String
//date String
//time String
//staus String
        //
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT , status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when creating table${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);

        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

// insert data
  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfuly');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting new  record ${error.toString()}');
      });
    });
  }

  // get data :
  void getDataFromDatabase(database) {
    NewTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          NewTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

// update
  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  //delete:
  void deleteData({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

// change icn bottomsheet with cubit:
  bool isBottomSheetShow = false;
  IconData fabicon = Icons.edit;
  void ChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShow = isShow;
    fabicon = icon;
    emit(AppChangeBottomSheetState());
  }
}
