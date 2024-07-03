import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
class MotivationWordsServices{
  final _api = Uri.parse('https://type.fit/api/quotes');

  Future<String> getMotivations() async{
    final response = await http.get(_api);
    List<dynamic> motivationsList = jsonDecode(response.body) as List<dynamic>;
    List<String> motivations = [for(int i = 0;i < motivationsList.length;i++) motivationsList[i]['text']];
    return motivations[Random().nextInt(motivations.length)];
  }
}