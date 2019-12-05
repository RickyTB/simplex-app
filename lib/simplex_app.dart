import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:simplex/widgets/simplex_table.dart';

class SimplexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplex',
      theme: ThemeData(
          primarySwatch: Colors.brown, accentColor: Colors.blueAccent),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<SimplexTableState> _tableKey = GlobalKey<SimplexTableState>();
  int _rows = 0;
  int _columns = 0;
  int _selectedRow = 0;

  void _handlePivot() {
    Map<String, String> currentValues = _tableKey.currentState.values;
    int row = _selectedRow;
    int column = _tableKey.currentState.selectedColumn;
    print(
      currentValues['$row$column'],
    );

    Parser p = Parser();

    Map<String, Expression> actualValues = {};
    Expression value = p.parse(currentValues['$row$column']);
    for (var j = 0; j < _columns; j++) {
      Expression exp = p.parse(currentValues['$row$j']);
      final currentValue = exp.simplify();
      actualValues['$row$j'] = p.parse('$currentValue') / value;
    }

    for (var i = 0; i < _rows; i++) {
      if (i == row) continue;
      final pivot = p.parse('-1 * ${currentValues['$i$column']}');

      for (var j = 0; j < _columns; j++) {
        Expression exp = p.parse(currentValues['$i$j']);
        actualValues['$i$j'] = exp + pivot * actualValues['$row$j'];
      }
    }

    Map<String, String> newValues = {};

    ContextModel cm = ContextModel();

    for (var i = 0; i < _rows; i++) {
      for (var j = 0; j < _columns; j++) {
        try {
          newValues['$i$j'] =
              actualValues['$i$j'].evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          newValues['$i$j'] = actualValues['$i$j'].simplify().toString();
        }
      }
    }

    _tableKey.currentState.setValues(newValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simplex'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      onChanged: (value) => setState(
                        () => _columns = int.tryParse(value) ?? 0,
                      ),
                      decoration: InputDecoration(labelText: 'Columnas'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: TextField(
                      onChanged: (value) => setState(
                        () => _rows = int.tryParse(value) ?? 0,
                      ),
                      decoration: InputDecoration(labelText: 'Filas'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              SimplexTable(
                  key: _tableKey,
                  columns: _columns,
                  rows: _rows,
                  onSelectColumn: () => setState(() {})),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      'Columna X${_tableKey.currentState?.selectedColumn ?? 'N/A'}',
                    ),
                  ),
                  SizedBox(width: 8.0),
                  if (_rows > 0)
                    Expanded(
                      child: DropdownButton<String>(
                        items: List.generate(
                          _rows,
                          (int index) => DropdownMenuItem<String>(
                            value: '$index',
                            child: Text('$index'),
                          ),
                        ).toList(),
                        onChanged: (value) => setState(
                          () => _selectedRow = int.tryParse(value) ?? 0,
                        ),
                        value: '$_selectedRow',
                      ),
                    ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: RaisedButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: _handlePivot,
                      child: Text('Pivotear'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
