

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app_local_database/modules/archive/archive.dart';
import 'package:to_do_app_local_database/modules/done/done.dart';
import 'package:to_do_app_local_database/modules/tasks/tasks.dart';
import 'package:to_do_app_local_database/shared/components/cubit/states.dart';

class ToDoCubit extends Cubit <ToDoStatest> {

  ToDoCubit() : super(ToDoIntialState());

  static ToDoCubit get(context) => BlocProvider.of(context);
  List<Widget> title = [
    Text('Tasks'),
    Text('Done'),
    Text('Archived'),
  ];
  List<Widget> screens = [
    TasksTODO(),
    DoneTODO(),
    ArchiveTODO(),
  ];

  List<Map>newtasks = [];
  List<Map>donetasks = [];
  List<Map>archivetasks = [];


  int currentIndex = 0;
  Database? database;

  void change(index) {
    currentIndex = index;
    emit(BottomNavigationBarChangeState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print("data base created");
          database
              .execute('CREATE TABLE Tasks '
              '(id INTEGER PRIMARY KEY, Title TEXT, Date TEXT, Time TEXT , Status TEXT)')
              .then((value) {
            print("create done");
          }).catchError((error) {
            print("the error  in open is  ${error.toString()}");
          });
        }, onOpen: (database) {
          print("database open");
          getDatabase(database);
        }).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert('Insert Into tasks (Title , Time , Date , '
          'Status )Values ("$title", "$time","$date", "new" )')
          .then((value) {
        emit(AppInsertDataBaseState());
        print("$value Inserted success  ");
        getDatabase(database);
        emit(AppGetDataBaseState());
      });
    }).catchError((error) {
      print("the error  in insert is  ${error.toString()}");
    });

  }

  void getDatabase(database) {
    newtasks=[];
    donetasks=[];
    archivetasks=[];
    emit(AppGetDataBaseloadingState());
    database!.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['Status'] == 'new') {
          newtasks.add(element);
        }
        else if (element['Status'] == 'done') {
          donetasks.add(element);
        }
        else
          archivetasks.add(element);
      }


      );


      emit(AppGetDataBaseState());
    }

    );
  }

  bool isShown = false;
  IconData showIcon = Icons.edit;

  void changeIcon({
    required bool iconShow,
    required IconData icon,

  }) {
    isShown = iconShow;
    showIcon = icon;
    emit(BottomSheetChangeState());
  }

  void updateDataBase({
    required String status,
    required int id,


  }) {
    database!.rawUpdate(
        'UPDATE Tasks SET Status = ? WHERE id = ?',
        ['$status', '$id',]).then((value) {
      getDatabase(database);
      emit(AppupdateDataBaseState());
    });
  }

  void deleteDataBase({required id}){

    database!.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value)
    {    getDatabase(database);

    emit(AppDeleteDataBaseState());

    });
  }
}



