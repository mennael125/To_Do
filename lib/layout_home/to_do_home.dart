
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_local_database/shared/components/components/components.dart';
import 'package:to_do_app_local_database/shared/components/cubit/states.dart';
import 'package:to_do_app_local_database/shared/components/cubit/to_do_cubit.dart';



class ToDOList extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();

  var formKey = GlobalKey<FormState>();


  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoCubit()..createDatabase(),
      child: BlocConsumer<ToDoCubit, ToDoStatest>(
        listener: (context, state) => {
          if (state is AppInsertDataBaseState) {Navigator.pop(context)}
        },
        builder: (context, state) {
          ToDoCubit cubit = ToDoCubit.get(context);
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // async

                if (cubit.isShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                      width: double.infinity,
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DefaultFormField(
                                  controller: titleController,
                                  textKeyboard: TextInputType.text,
                                  prefix: Icons.title,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Please enter the title";
                                    }
                                    return null;
                                  },
                                  textLabel: "Task title "),
                              SizedBox(
                                height: 20,
                              ),
                              DefaultFormField(
                                  controller: timeController,
                                  textKeyboard: TextInputType.datetime,
                                  prefix: Icons.watch_later_outlined,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Please enter the time";
                                    }
                                    return null;
                                  },
                                  textLabel: "Task time ",
                                  onTaped: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              DefaultFormField(
                                  controller: dateController,
                                  textKeyboard: TextInputType.datetime,
                                  prefix: Icons.calendar_today,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Please enter the date";
                                    }
                                    return null;
                                  },
                                  textLabel: "Task date ",
                                  onTaped: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate:
                                      DateTime.parse("2021-11-11"),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                    elevation: 50,
                  )
                      .closed
                      .then((value) {
                    cubit.changeIcon(iconShow: false, icon: Icons.edit);
                  });
                  cubit.changeIcon(iconShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.showIcon),
            ),
            key: scaffoldKey,
            appBar: AppBar(
              title: cubit.title[cubit.currentIndex],
            ),
            body: state is!AppGetDataBaseloadingState
                ? cubit.screens[cubit.currentIndex]
                : Center(child: CircularProgressIndicator()),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.change(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archived')
              ],
            ),
          );
        },
      ),
    );
  }
}
