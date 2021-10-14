import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_local_database/shared/components/components/components.dart';
import 'package:to_do_app_local_database/shared/components/cubit/states.dart';
import 'package:to_do_app_local_database/shared/components/cubit/to_do_cubit.dart';

class DoneTODO extends StatelessWidget {
  const DoneTODO({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStatest>(
      listener: (context, state) => {},
      builder: (context, state)
      {
        var tasks = ToDoCubit.get(context).donetasks;
        return conditionBuilder(tasks:tasks);
      } ,
    );
  }
}
