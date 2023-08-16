import 'package:graphdbio/grafbase/mutation.dart';
import 'package:graphdbio/grafbase/queries.dart';

abstract class GrafbaseModel {
  String get modelName; // To get the name of the model
  Map<String, Type>
      get fields; // Map containing field names and their corresponding Dart types
  List<String> selectedIds = [];


  Future<List<Map<String, dynamic>>> readAll(
   ) async {
       return handleReadAll(modelName, fields.keys.toList());
    }


  Future<List<dynamic>> deleteMany(
   ) async {
       return handleDeleteMany(modelName, selectedIds);
    }
  
}

abstract class GrafbaseNestedField{
  String get fieldName;
  Map<String, Type> get nestedFields;
  List<String> selectedIds = [];

  
}

//Sample implementation
class UserModel extends GrafbaseModel {



  @override
  String get modelName => 'User';

  @override
  Map<String, Type> get fields => {
        'id': int,
       
        'email': String,
        'sub': String,
        'createdAt': DateTime,
        'updatedAt': DateTime,
      };

  

}









class CapsuleModel extends GrafbaseModel {
  @override
  String get modelName => 'Capsule';

  @override
  Map<String, Type> get fields => {
        'id': int,
        'content': String,
        'caption': String,
        'createdAt': DateTime,
        'updatedAt': DateTime,
        'members' :List<String>,
       
      };

  
}



List<GrafbaseModel> models = [
  UserModel(),
  CapsuleModel(),
];