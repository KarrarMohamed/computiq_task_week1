class Todo {
  String title;
  String description;
  bool isCompleted;

  Todo({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  Todo.fromJSON(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        isCompleted = json['isCompleted'];

  Map<String, dynamic> toJSON() => {
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      };

  copyWith({String? titleText, String? descriptionText, bool? isCompletedText}) {
    title = titleText ?? title;
    description = descriptionText ?? description;
    isCompleted = isCompletedText ?? isCompleted;
  }
}
