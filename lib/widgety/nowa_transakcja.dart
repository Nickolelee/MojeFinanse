// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NowaTransakcja extends StatefulWidget {
  final Function addTx;

  NowaTransakcja(this.addTx);

  @override
  State<NowaTransakcja> createState() => _NowaTransakcjaState();
}

class _NowaTransakcjaState extends State<NowaTransakcja> {
  final _tytulController = TextEditingController();
  final _wartoscController = TextEditingController();
  DateTime? _zaznaczonaData;

  void _potwierdzDanych() {
    if (_wartoscController.text.isEmpty) {
      return;
    }
    final wprowTytul = _tytulController.text;
    final wprowWartosc = double.parse(_wartoscController.text);

    if (wprowTytul.isEmpty || wprowWartosc <= 0 || _zaznaczonaData == null) {
      return;
    }

    widget.addTx(
      wprowTytul,
      wprowWartosc,
      _zaznaczonaData,
    );

    Navigator.of(context).pop();
  }

  void _obecnyWyborDaty() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((wybranaData) {
      if (wybranaData == null) {
        return;
      }
      setState(() {
        _zaznaczonaData = wybranaData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Tytuł'),
                controller: _tytulController,
                // onChanged: (value) {
                onSubmitted: (_) => _potwierdzDanych(),
                //   tytulInput = value;
                //  },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Wartość'),
                controller: _wartoscController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _potwierdzDanych(),
                // onChanged: (value) => wartoscInput = value,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _zaznaczonaData == null
                            ? 'Nie wybrano daty'
                            : 'Wybrana Data: ${DateFormat.yMd().format(_zaznaczonaData!)}',
                      ),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: Text(
                              'Wybierz datę',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _obecnyWyborDaty,
                          )
                        : TextButton(
                            onPressed: _obecnyWyborDaty,
                            child: Text('Wybierz datę'),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              textStyle: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                  ],
                ),
              ),
              ElevatedButton(
                child: Text('Dodaj Transakcje'),
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                  color: Theme.of(context).textTheme.button!.color,
                )),
                onPressed: _potwierdzDanych,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
