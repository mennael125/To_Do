
import 'package:flutter/material.dart';
import 'package:to_do_app_local_database/shared/components/cubit/to_do_cubit.dart';

Widget DefaultButtton({
  double raduis = 0,
  double width = double.infinity,
  Color color = Colors.blue,
  bool isupper = true,
  required String text,
  required void fun(),
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(raduis),
      ),
      child: MaterialButton(
        child: Text(
          " ${isupper ? text.toUpperCase() : text} ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: fun,
      ),
    );

Widget DefaultFormField({
  required TextEditingController controller,
  required TextInputType textKeyboard,
  IconData? suffix,
  GestureTapCallback? onTaped,
  bool ispassword = false,
  required IconData prefix,
  ValueChanged<String>? onchange,
  ValueChanged<String>? onfieldsubmitted,
  required FormFieldValidator<String> validate,
  required String textLabel,
  VoidCallback? suffixpressed,
}) =>
    TextFormField(
      validator: validate,
      controller: controller,
      keyboardType: textKeyboard,
      obscureText: ispassword,
      decoration: InputDecoration(
        labelText: textLabel,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
          icon: Icon(suffix),
          onPressed: suffixpressed,
        )
            : null,
        border: OutlineInputBorder(),
      ),
      onChanged: onchange,
      onFieldSubmitted: onfieldsubmitted,
      onTap: onTaped,
    );

Widget buildTaskItem(Map model,context) => Dismissible(

  key:Key  (model['id'].toString()),
  onDismissed: (direction){
    ToDoCubit.get(context).deleteDataBase(id: model['id']);
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40,

          child: Text(

            "${model['Time']}",

            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),

          ),

        ),

        SizedBox(

          width: 20,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                "${model['Title']}",

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

              ),

              SizedBox(

                height: 10,

              ),

              Text(

                "${model['Date']}",

                style:

                TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),

              ),

            ],

          ),

        ),

        SizedBox(

          width: 20,

        ),

        IconButton(

          onPressed: (){

            ToDoCubit.get(context).updateDataBase(status: 'done', id: model['id']);



          },

          icon:Icon( Icons.check_circle_outline),

          color: Colors.grey,

          iconSize: 30,



        ),

        SizedBox(

          width: 20,

        ),

        IconButton(

          onPressed: (){

            ToDoCubit.get(context).updateDataBase(status: 'archive', id: model['id']);

          },

          icon:Icon( Icons.archive),

          color: Colors.grey,

          iconSize: 30,

        ),

      ],

    ),

  ),
);

Widget conditionBuilder(

    {
      required tasks,
    }
    )=>tasks.length > 0
    ? ListView.separated(
    itemBuilder: (context, index) =>
        buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20),
      child: Container(
        width: double.infinity,
        height: 2,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length)
    : Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 60,
          color: Colors.grey[600],
        ),
        Text(
          "No tasks yet",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
              color: Colors.grey[600]),
        )
      ],
    ));