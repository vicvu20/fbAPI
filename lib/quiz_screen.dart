import 'package:flutter/material.dart';
import 'api_service.dart';
import 'question.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _api = ApiService();

  List<Question> _questions = [];
  int _index = 0;
  int _score = 0;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    final questions = await _api.fetchQuestions();
    setState(() {
      _questions = questions;
    });
  }

  void checkAnswer(String selected) {
    if (_answered) return;

    setState(() {
      _answered = true;
      if (selected == _questions[_index].correctAnswer) {
        _score++;
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _index++;
        _answered = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_index >= _questions.length) {
      return Scaffold(
        body: Center(
          child: Text("Score: $_score / ${_questions.length}"),
        ),
      );
    }

    final q = _questions[_index];

    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(q.question, textAlign: TextAlign.center),
          ...q.options.map((option) {
            return ElevatedButton(
              onPressed: () => checkAnswer(option),
              child: Text(option),
            );
          }).toList()
        ],
      ),
    );
  }
}