import 'package:flutter/material.dart';

class SimplexTable extends StatefulWidget {
  final int rows;
  final int columns;
  final Function onSelectColumn;

  const SimplexTable(
      {Key key, this.rows = 0, this.columns = 0, this.onSelectColumn})
      : super(key: key);

  @override
  SimplexTableState createState() => SimplexTableState();
}

class SimplexTableState extends State<SimplexTable> {
  Map<String, String> _values = {};
  int _columnSelected = 0;

  @override
  void didUpdateWidget(SimplexTable oldWidget) {
    if (widget.rows != oldWidget.rows || widget.columns != oldWidget.columns)
      _generateValues();
    super.didUpdateWidget(oldWidget);
  }

  void _generateValues() {
    Map<String, String> newValues = {};
    for (var i = 0; i < widget.rows; i++) {
      for (var j = 0; j < widget.columns; j++) {
        newValues['$i$j'] = _values['$i$j'] ?? '0';
      }
    }
    setState(() {
      _values = newValues;
    });
  }

  void setValues(Map<String, String> newValues) {
    setState(() {
      _values = newValues;
    });
  }

  int get selectedColumn {
    return _columnSelected;
  }

  Map<String, String> get values {
    return _values;
  }

  Future _showDialog(int row, int column) {
    String value;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Nuevo valor"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Fila ${row + 1}, Columna ${column + 1}',
            ),
            onChanged: (val) => value = val,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop(value);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.columns == 0) return Container();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: _columnSelected,
        columns: List.generate(
          widget.columns,
          (index) => DataColumn(
            label: Text(
              (index == 0 || index == widget.columns - 1) ? '' : 'X$index',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            numeric: true,
            onSort: (index, _) => setState(() {
              _columnSelected = index;
              widget.onSelectColumn();
            }),
          ),
        ),
        rows: List.generate(
          widget.rows,
          (row) => DataRow(
            cells: List.generate(
              widget.columns,
              (column) => DataCell(
                Text(_values['$row$column'] ?? '0'),
                onTap: () => _showDialog(row, column).then(
                  (result) => setState(
                    () => _values['$row$column'] =
                        result ?? _values['$row$column'],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
