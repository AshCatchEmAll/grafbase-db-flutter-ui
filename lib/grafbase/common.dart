import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>> sendRequest(String query, String suffix,
    String modelName, Map<String, dynamic> variables,
    [Map<String, dynamic> headers = const {}]) async {
  final grafbaseKey = dotenv.env['GRAFBASE_KEY']!;
  final url = dotenv.env['GRAFBASE_URL']!;

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "x-api-key": grafbaseKey,
      ...headers
      // Add any other headers if necessary
    },
    body: jsonEncode({
      "query": query,
      "variables": variables,
    }),
  );

  final responseBody = response.body;

  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(responseBody);
    if (jsonBody['errors'] != null) {
      log("Error! Status Code: ${response.statusCode}");
      print("jsonBody: ${jsonBody['errors']}");
      throw Exception("Errors while calling Grafbase!");
    }
    final data = jsonBody['data'];
    return data;
  } else {
    log("Error! Status Code: ${response.statusCode}");
    throw Exception("Request failed!");
  }
}


String generateFieldQuery(Map<String, dynamic> fields) {
  return fields.entries.map((entry) {
    final key = entry.key;
    final value = entry.value;

    if (value is Map<String, dynamic>) {
      return '$key {\n ${generateFieldQuery(value)} \n}';
    } else {
      return key;
    }
  }).join("\n");
}