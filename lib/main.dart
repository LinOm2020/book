import 'package:flutter/material.dart';

void main() {
  runApp(const CareApp());
}

class CareApp extends StatelessWidget {
  const CareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareSphere',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime date;
  final bool isReminder;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    this.isReminder = false,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Note> _notes = [];
  final TextEditingController _controller = TextEditingController();

  String _detectCategory(String text) {
    String t = text.toLowerCase();
    if (t.contains('мам') || t.contains('пап') || t.contains('бабуш') || t.contains('дедуш') || 
        t.contains('сын') || t.contains('доч')) return 'family';
    if (t.contains('день рожд') || t.contains('birthday')) return 'birthday';
    if (t.contains('врач') || t.contains('лекар') || t.contains('здоров')) return 'health';
    if (t.contains('купить') || t.contains('магаз')) return 'shopping';
    if (t.contains('работ') || t.contains('встреч')) return 'work';
    if (t.contains('пароль') || t.contains('code')) return 'password';
    return 'other';
  }

  String _getCategoryName(String cat) {
    switch (cat) {
      case 'family': return 'Семья';
      case 'birthday': return 'Дни рождения';
      case 'health': return 'Здоровье';
      case 'shopping': return 'Покупки';
      case 'work': return 'Работа';
      case 'password': return 'Пароли';
      default: return 'Другое';
    }
  }

  void _addNote(String text) {
    if (text.trim().isEmpty) return;
    String category = _detectCategory(text);

    setState(() {
      _notes.add(Note(
        id: DateTime.now().toString(),
        title: text.length > 40 ? text.substring(0, 37) + '...' : text,
        content: text,
        category: category,
        date: DateTime.now(),
      ));
    });

    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Добавлено в ${_getCategoryName(category)}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CareSphere')),
      body: _notes.isEmpty
          ? const Center(child: Text('Нажми + чтобы добавить заметку', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Новая заметка'),
              content: TextField(
                controller: _controller,
                maxLines: 5,
                decoration: const InputDecoration(hintText: 'Что нужно запомнить?'),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
                ElevatedButton(
                  onPressed: () {
                    _addNote(_controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Добавить'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
