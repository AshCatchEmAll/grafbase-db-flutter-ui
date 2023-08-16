import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphdbio/component/delete_many_btn.dart';
import 'package:graphdbio/grafbase/common.dart';
import 'package:graphdbio/grafbase/models.dart';
import 'package:graphdbio/grafbase/mutation.dart';
import 'package:graphdbio/grafbase/queries.dart';

class DynamicDataTable extends StatefulWidget {
  @override
  _DynamicDataTableState createState() => _DynamicDataTableState();
}

class _DynamicDataTableState extends State<DynamicDataTable> {
  // List<String> selectedRows = [];
  late GrafbaseModel grafbaseModel;
  final List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      grafbaseModel = UserModel();
      final res = await grafbaseModel.readAll();

      setState(() {
        data.addAll(res);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grafbase DataTable"),
        actions: [
         DeleteManyBtn(grafbaseModel: grafbaseModel)
            
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
               
                children: [
                  ...models.map((model) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color(0xff171C1F)),
                        
                        ),
                        onPressed: () async {
                          setState(() {
                            grafbaseModel = model;
                            data.clear();
                          });
                          final res = await grafbaseModel.readAll();
                          setState(() {
                            data.addAll(res);
                          });
                        },
                        child: Text(model.runtimeType.toString()),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            DataTable(
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    if (data.isEmpty) return [];
    return data[0]
        .keys
        .map((key) => DataColumn(label: Text(key.toUpperCase(), 
        style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white),
        )))
        .toList();
  }

  List<DataRow> _buildRows() {
    return data.map((row) {
      return DataRow(
        selected: grafbaseModel.selectedIds.contains(row['id']),
        onSelectChanged: (bool? selected) {
          setState(() {
            if (selected != null && selected) {
              grafbaseModel.selectedIds.add(row['id']);
            } else {
              grafbaseModel.selectedIds.remove(row['id']);
            }
          });

          print("Selected Row ID(s) : ${grafbaseModel.selectedIds} ");
        },
        cells:
            row.keys.map((key) => DataCell(Text(row[key].toString()))).toList(),
      );
    }).toList();
  }
}


