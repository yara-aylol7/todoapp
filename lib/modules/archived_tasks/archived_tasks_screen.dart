import 'package:taskpro/shared/components/component.dart';
import 'package:taskpro/shared/cubit/cubit.dart';
import 'package:taskpro/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class archivedTasksScreen extends StatelessWidget {
  const archivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return tasksBuilder(tasks: tasks);
      },
      listener: (context, state) {},
    );
  }
}
