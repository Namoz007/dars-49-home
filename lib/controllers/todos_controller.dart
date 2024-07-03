import 'package:dars_49/models/todo.dart';

class TodosController{
  List<Todo> _todos = [
    Todo(id: 1, title: "Dars qilish", description: "Tezoq darsingni qil", workTime: DateTime.now(), isComplete: false),
  ];

  // DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,DateTime.now().second + 5)

  List<Todo> getTodos(){
    return [..._todos];
  }

  void addTodo(Todo todo){
    todo.id = _todos[_todos.length -1].id + 1;
    _todos.add(todo);
  }

  void removeTodo(int id){
    _todos.removeWhere((todo) => todo.id == id);
  }


}