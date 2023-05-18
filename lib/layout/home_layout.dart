import 'package:taskpro/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:taskpro/modules/done_tasks/done_tasks_screen.dart';
import 'package:taskpro/modules/new_tasks/new_tasks_screen.dart';
import 'package:taskpro/shared/components/component.dart';
import 'package:taskpro/shared/components/constants.dart';
import 'package:taskpro/shared/cubit/cubit.dart';
import 'package:taskpro/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

//1. create database& tables
//2.open database
//3.insert to db
//4.get from db
//5.update in db
//7.delete from db
class HomeLayout extends StatelessWidget {
  late Database database;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                // Titles[currentIndex],
                cubit.Titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              //condition: true, // مشان دائما نفذ السكرين
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => AppCubit.get(context)
                  .Screens[AppCubit.get(context).currentIndex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              // اول تجربة
              /* onPressed: () async {
              try {
                var name = await getName();
                print(name);
              } catch (error) {
                print('error ${error.toString()}');
                
              }
            },*/
              // طريقة تانية لمعالجة الخطأ
              // مافي داعي لل async
              onPressed: () {
                // الشي الثابت
                if (cubit.isBottomSheetShow) {
                  // التحقق من الادخال
                  if (formkey.currentState!.validate()) {
                    //bloc
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    //setstate:
                    /* insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    ).then((value) {
                      getDataFromDatabase(database).then((value) {
                        Navigator.pop(context);
                        // setState(() {
                        // isBottomSheetShow = false;
                        //fabicon = Icons.edit;
                        //tasks = value;
                        //print(tasks);
                        //});
                      });
                    });*/
                  }
                } else {
                  titleController.clear();
                  timeController.clear();
                  dateController.clear();
                  scaffoldkey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          // بدي حط فورم مشان اتحقق
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //task
                                defaultFormfield(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "title must not be empty ";
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                // time
                                defaultFormfield(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    // timepicker :
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then(
                                      (value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      },
                                    );
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "time must not be empty ";
                                    }
                                    return null;
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                // date
                                defaultFormfield(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    // datepicker :
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2026-05-03'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "date must not be empty ";
                                    }
                                    return null;
                                  },
                                  label: 'Task Date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 15.0,
                      )
                      .closed
                      .then((value) {
                    //bloc:
                    cubit.ChangeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                    /* setState(() {
                    fabicon = Icons.edit;
                  });*/
                  });
                  cubit.ChangeBottomSheetState(isShow: true, icon: Icons.add);
                  /*setState(() {
                  fabicon = Icons.add;
                });*/
                }
                // ثالث تجربة
                // insertToDatabase();
                // ثاني تجربة
                /*getName().then((value) {
                print(value);
                print('yara');
                // throw ('أنا عملت  خطأ');
              }).catchError((error) {
                print('error ${error.toString()}');
              });*/
              },
              child: Icon(
                cubit.fabicon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                //state :
                /*setState(() {
                currentIndex = index;
              });*/
                // bloc :
                cubit.ChangeIndexs(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
