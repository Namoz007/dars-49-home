import 'package:dars_49/controllers/todos_controller.dart';
import 'package:dars_49/services/local_notifications_services.dart';
import 'package:dars_49/views/widgets/add_todo.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? day;
  final todosController = TodosController();
  DateTime? alarm;

  void initState() {
    super.initState();
    if (!LocalNotificationsServices.notificationEnabled) {
      LocalNotificationsServices.requestPermission();
    }
  }

  void dayNotification(int second) async {
    await Future.delayed(Duration(seconds: second), () {
      LocalNotificationsServices.dayNotification();
    });
    if (day != null) {
      if (day!.day == DateTime.now().day) {
        LocalNotificationsServices.dayNotification();
        day = DateTime.now();
        setState(() {

        });
      }
    }
  }

  void alarmFunc(int second) {
    Future.delayed(Duration(seconds: second), () {
      LocalNotificationsServices.todoNotification(
        "Eslatma",
        "Ishlashni boshlaganingizga 2 soat boldi, iltimos dam ham oliing",
      );
    });

    setState(() {
      alarm = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime futureTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second + 5);
    int second = futureTime.difference(DateTime.now()).inSeconds;
    dayNotification(second);   //bu har kun ertalap eslatuvchi funksiya
    if(alarm == null){
      alarmFunc(15);
    }else{
      DateTime alarmFutureTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second + 15,);
      alarmFunc(alarmFutureTime.difference(DateTime.now()).inSeconds);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async{
              final data = await showDialog(context: context, builder: (context) => AddTodo());

              if(data != null){
                setState(() {
                  todosController.addTodo(data);
                });
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todosController.getTodos().length,
        itemBuilder: (context, index) {
          final todo = todosController.getTodos()[index];
          DateTime futureTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              DateTime.now().hour,
              DateTime.now().minute,
              DateTime.now().second + 7);
          int todoToDate = futureTime.difference(todo.workTime).inSeconds;
          print(todoToDate);
          if(todo.isComplete){
            Future.delayed(Duration(seconds: todoToDate),
                    () {
                  LocalNotificationsServices.todoNotification(
                      todo.title, todo.description,);
                });
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${todo.title}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  todo.isComplete ? Colors.green : Colors.red,
                            ),
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              "${todo.description}",
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            todo.isComplete = !todo.isComplete;
                          });
                        },
                        icon: todo.isComplete
                            ? Icon(
                                Icons.check_circle_outline_outlined,
                                color: Colors.green,
                                size: 30,
                              )
                            : Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 30,
                              ),
                      ),
                      IconButton(onPressed: (){
                        setState(() {
                          todosController.removeTodo(todo.id);
                        });
                      }, icon: Icon(Icons.delete,color: Colors.red,size: 30,),),
                      Container(
                        width: 80,
                        child: Text(
                            "${todo.workTime.hour}/${todo.workTime.minute}  ${todo.workTime.day}/${todo.workTime.month}/${todo.workTime.year}",),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
