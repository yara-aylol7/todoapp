import 'package:taskpro/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function() onpressed,
  bool isUpperCase = true,
  double radius = 10.0,
  required String text,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: onpressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );
Widget defaultFormfield({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  required String? Function(String?) validator,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool? isPassword,
  Function? suffixPressed,

  // required Function save,
}) {
  return TextFormField(
    //obscureText: isPassword!,
    // onSaved: save(),

    onTap: () {
      onTap!();
    },
    controller: controller,
    keyboardType: type,
    autocorrect: true,
    enableSuggestions: true,
    textCapitalization: TextCapitalization.words,
    //autovalidate: true,
    validator: validator,
    onFieldSubmitted: (value) {
      onSubmit!(value);
    },
    onChanged: onChange,

    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        prefix,
      ),
      suffixIcon: suffix != null
          ? IconButton(
              icon: Icon(
                suffix,
              ),
              onPressed: () {
                suffixPressed!();
              },
            )
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),

            SizedBox(
              width: 20.0,
            ),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 20.0,
            ),

            // bottom done & archived :

            IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
            ),

            IconButton(
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              ),
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archive',
                  id: model['id'],
                );
              },
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(
          id: model['id'],
        );
      },
    );
Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: tasks.length,
        //AppCubit.get(context).tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet ,Please Add Some Tsks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 40.0,
      ),
      child: Container(
        width: double.infinity,
        height: 10,
        color: Colors.grey[300],
      ),
    );
