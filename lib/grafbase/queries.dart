import 'dart:convert';
import 'dart:developer';
import 'package:graphdbio/grafbase/types.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'common.dart';


String generateReadQuery(
    {String modelName = "User",
    List<String> fields = const ["id", "sub", "email"]}) {
  return """
            query Get$modelName(\$id: ID!) {
                ${modelName.toLowerCase()}(by: {
                      id : \$id
                }) {
                    ${fields.join("\n")}
                }
            }
    """;
}

String generateReadAllQuery(String modelName, List<String> fields) {
  return '''
        query GetAll${modelName}s {
            ${modelName.toLowerCase()}Collection (
                first: 100, 
                orderBy: {
                    createdAt:DESC
                }
            ) {
                edges {
                    node {
                        ${fields.join("\n")}
                    }
                }
            }
        }
    ''';
}

Future<List<Map<String, dynamic>>> handleReadAll(
    String modelName, List<String> fields) async {
  final query = generateReadAllQuery(modelName, fields);
  final res = await sendRequest(query, GrafbaseSuffix.collection, modelName, {});
  final data = res["${modelName.toLowerCase()}Collection"]["edges"];

  // loop through data and then get every node
  final List<Map<String, dynamic>> nodes = [];
  for (var i = 0; i < data.length; i++) {
    final node = data[i]["node"];
    nodes.add(node);
  }

  return nodes;
}


