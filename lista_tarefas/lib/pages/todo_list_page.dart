import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/todo.dart';
import 'package:lista_tarefas/repositories/todo_repositories.dart';
import 'package:lista_tarefas/themes/theme_manager.dart';

import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  ThemeManager _themeManager = ThemeManager();

  List<Todo> tarefas = [];
  Todo? deletedTarefa;
  int? deletedTarefaPos;
  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Caderninho'),
          backgroundColor: const Color(0xff89BBFE),
          // actions: [
          //   Switch(
          //       value: _themeManager.themeMode == ThemeMode.dark,
          //       onChanged: (newValue) {
          //         _themeManager.toggleTheme(newValue);
          //       })
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa aqui',
                        hintText: 'Ex.: Estudar Flutter',
                        errorText: errorText,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff89BBFE),
                            width: 3,
                          ),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String text = todoController.text;

                      if (text.isEmpty) {
                        setState(() {
                          errorText = 'O título não pode ser vazio!';
                        });
                        return;
                      }

                      setState(() {
                        Todo newTodo = Todo(
                          title: text,
                          date: DateTime.now(),
                        );
                        tarefas.add(newTodo);
                        errorText = null;
                      });
                      todoController.clear();
                      todoRepository.saveTodoList(tarefas);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14)),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo tarefa in tarefas)
                      TodoListItem(
                        todo: tarefa,
                        onDelete: onDelete,
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text('Possui ${tarefas.length} tarefas pendentes'),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: showDeleteTodosConfirmationDialogs,
                    child: const Text('Limpar tudo'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTarefa = todo;
    deletedTarefaPos = tarefas.indexOf(todo);

    setState(() {
      tarefas.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso!',
          style: const TextStyle(color: Color(0xff060708)),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              tarefas.insert(
                deletedTarefaPos!,
                deletedTarefa!,
              );
            });
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
    todoRepository.saveTodoList(tarefas);
  }

  void showDeleteTodosConfirmationDialogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo?'),
        content:
            const Text('VocÊ tem certeza de que quer apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('Limpar tudo'),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      tarefas.clear();
    });
    todoRepository.saveTodoList(tarefas);
  }
}
