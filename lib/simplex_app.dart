import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplex/widgets/simplex_table.dart';

class SimplexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplex',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _rows = 0;
  int _columns = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simplex'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Row(
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
              ),
              SimplexTable(
                columns: _columns,
                rows: _rows,
              )
            ],
          ),
        ),
      ),
    );
  }
}
