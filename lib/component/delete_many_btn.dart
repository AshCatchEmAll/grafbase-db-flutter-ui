import 'package:flutter/material.dart';
import 'package:graphdbio/grafbase/models.dart';

class DeleteManyBtn extends StatefulWidget {
  const DeleteManyBtn({
    super.key,
    required this.grafbaseModel,
  });

  final GrafbaseModel grafbaseModel;

  @override
  State<DeleteManyBtn> createState() => _DeleteManyBtnState();
}

class _DeleteManyBtnState extends State<DeleteManyBtn> {
  bool get enabled => widget.grafbaseModel.selectedIds.isNotEmpty;
  bool get areMany => widget.grafbaseModel.selectedIds.length > 1;
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return Container();
    if (!_isLoaded) {
      return ElevatedButton(
        style:  ElevatedButton.styleFrom(
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
          onPressed: () async {
            setState(() {
              _isLoaded = true;
            });
            print("Did to me : ${widget.grafbaseModel.selectedIds}");
            try{
              await widget.grafbaseModel.deleteMany();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted")));

            } catch(e){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
            }
            
            setState(() {
              _isLoaded = false;
            });
          },
          child: Text(
              areMany?
            "Delete many": "Delete one"));
    } else {
      return CircularProgressIndicator();
    }
  }
}
