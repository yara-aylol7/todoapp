import 'package:taskpro/shared/components/component.dart';
import 'package:taskpro/shared/components/constants.dart';
import 'package:taskpro/shared/cubit/cubit.dart';
import 'package:taskpro/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class newTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var tasks = AppCubit.get(context).NewTasks;
        return tasksBuilder(tasks: tasks);
      },
      listener: (context, state) {},
    );
  }
}
