import 'dart:convert';
import 'dart:developer';

import 'package:graphdbio/grafbase/common.dart';
import 'package:graphdbio/grafbase/types.dart';

String generateDeleteMutation(String modelName) {
  return '''mutation Delete${modelName}(\$id: ID!) {
          ${modelName.toLowerCase()}Delete(by:{
              id: \$id
            }) {
              deletedId
          }
      }
  ''';
}

String generateDeleteMany(String modelName) {
  return '''mutation ${modelName}DeleteMany(\$ids: [ID!]!) {
          ${modelName.toLowerCase()}DeleteMany(
            input{
                by:{
                  id: \$ids
                }
            }
            ){  
              deletedIds
          }
      }
  ''';
}

Future<List<dynamic>> handleDeleteMany(
    String modelName, List<String> ids) async {
  try {
    final String query = generateDeleteMutation(modelName);
    final deletedIDs = [];
    for (String id in ids) {
      final response = await sendRequest(
          query, GrafbaseSuffix.delete, modelName, {'id': id});

      log("response: ${response}");
      deletedIDs.add(
          response[modelName.toLowerCase() + 'Delete']['deletedId']);
    }

    return deletedIDs;
  } catch (e) {
    print("Error executing delete many: ${e}");
    rethrow;
  }
}
