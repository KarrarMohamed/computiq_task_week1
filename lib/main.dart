import 'package:computiq_task_week1/todos/add_todo_widget.dart';
import 'package:computiq_task_week1/todos/todos_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final prefs = watch(sharedPreferencesProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: prefs.when(
        data: (_) => const HomePage(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text('Something went wrong'),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            isDismissible: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
            context: context,
            builder: (_) => const AddTodoWidget(),
          );
        },
      ),
      appBar: AppBar(
        title: Text('Notes App'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: const TodosListViewWidget(),
      ),
    );
  }
}
