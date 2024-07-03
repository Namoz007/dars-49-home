import 'package:dars_49/models/todo.dart';
import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  final todoTitle = TextEditingController();
  final todoDescription = TextEditingController();
  DateTime? todoWorkTime;
  String? error;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Todo"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            error != null
                ? Text(
                    "$error",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                  )
                : SizedBox(),
            TextFormField(
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Todo title bosh bolmasligi kerak";
                }

                return null;
              },
              controller: todoTitle,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: "Todo title"),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Todo description bosh bolmasligi kerak";
                }

                return null;
              },
              controller: todoDescription,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: "Todo description"),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                todoWorkTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025));
                setState(() {});
              },
              child: Text("Todo uchun vaqt"),
            ),
            todoWorkTime != null ? Text("${todoWorkTime}") : SizedBox(),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (todoWorkTime != null) {
                Navigator.of(context).pop(
                  Todo(
                      id: 0,
                      title: todoTitle.text,
                      description: todoDescription.text,
                      workTime: todoWorkTime!,
                      isComplete: false),
                );
              } else {
                setState(() {
                  error = "Todo uchun vaqt tanlang";
                });
              }
            }
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
