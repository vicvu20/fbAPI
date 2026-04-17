import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';

class ApiService {
  final String url =
      'https://opentdb.com/api.php?amount=10&type=multiple';

  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results
          .map((q) => Question.fromJson(q))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}