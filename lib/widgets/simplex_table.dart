import 'package:flutter/material.dart';

class SimplexTable extends StatefulWidget {
  final int rows;
  final int columns;

  const SimplexTable({Key key, this.rows = 0, this.columns = 0})
      : super(key: key);

  @override
  _SimplexTableState createState() => _SimplexTableState();
}

class _SimplexTableState extends State<SimplexTable> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(SimplexTable oldWidget) {
    if (widget.rows != oldWidget.rows) print(oldWidget.rows);
    if (widget.columns != oldWidget.columns) print(oldWidget.columns);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
