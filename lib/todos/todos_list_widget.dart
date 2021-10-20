import 'dart:convert';

import 'package:computiq_task_week1/main.dart';
import 'package:computiq_task_week1/todos/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosState extends ChangeNotifier {
  final _todos = <Todo>[];
  late ProviderReference _ref;

  List<Todo> get todos => _todos;

  var _isLoading = false;

  bool get isLoading => _isLoading;

  void setIsLoadingTo(bool update) {
    if (_isLoading != update) {
      _isLoading = update;
      notifyMyListeners();
    }
  }

  TodosState({required ProviderReference reference}) {
    _ref = reference;
    _initializeTodos();
  }

  void _initializeTodos() {
    setIsLoadingTo(true);
    var prefs = _ref.read(sharedPreferencesProvider).data;
    var todosString = prefs!.value.get('todos');
    debugPrint(todosString.toString());
    if (todosString != null) {
      var todosJsonList = jsonDecode(todosString as String);
      if (todosJsonList != null) {
        _todos.addAll(todosJsonList.map<Todo>((element) => Todo.fromJSON(element)).toList());
      }
    }

    setIsLoadingTo(false);
  }

  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    await _update();
  }

  Future<void> removeTodo(int pos) async {
    _todos.removeAt(pos);
    await _update();
  }

  void updateCompletionStatus(int pos) {
    _todos[pos].copyWith(isCompletedText: !_todos[pos].isCompleted);
    _update();
  }

  Future<void> _update() async {
    var prefs = _ref.read(sharedPreferencesProvider);
    await prefs.data!.value.setString('todos', jsonEncode(_todos.map((e) => e.toJSON()).toList()));
    notifyMyListeners();
  }

  // ==============================================================================================
  bool _isDisposed = false;

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

final todosProvider = ChangeNotifierProvider.autoDispose<TodosState>((ref) {
  return TodosState(reference: ref);
});

final todosCountProvider = Provider.autoDispose<int>((ref) {
  final todosNotifier = ref.watch(todosProvider);
  return todosNotifier.todos.length;
});

class TodosListViewWidget extends ConsumerWidget {
  const TodosListViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final todosNotifier = watch(todosProvider);
    return todosNotifier.todos.isEmpty
        ? const Center(
            child: Text('There are no notes added yet'),
          )
        : ListView.builder(
            itemCount: todosNotifier.todos.length,
            itemBuilder: (context, pos) => CheckboxListTile(
              title: Text(todosNotifier.todos[pos].title),
              subtitle: Text(todosNotifier.todos[pos].description),
              value: todosNotifier.todos[pos].isCompleted,
              onChanged: (update) {
                watch(todosProvider.notifier).updateCompletionStatus(pos);
              },
            ),
          );
  }
}
