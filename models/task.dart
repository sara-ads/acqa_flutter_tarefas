class Task {
  String id;
  String title;
  DateTime date;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.date,
    this.isCompleted = false,
  });
}
