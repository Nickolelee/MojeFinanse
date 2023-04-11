// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, duplicate_import, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:aplikacja_wydatki/widgety/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import './widgety/nowa_transakcja.dart';
import './widgety/transakcja_lista.dart';
import 'package:flutter/material.dart';
import './modele/transakcje.dart';
import './widgety/chart.dart';

void main() {
  /* WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twoje Wydatki',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.black87,
        ),
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transakcje> _userTransakcje = [
    /* Transakcje(
      id: 't1',
      tytul: 'Nowe Buty',
      wartosc: 69.99,
      data: DateTime.now(),
    ),
    Transakcje(
      id: 't2',
      tytul: 'Benzyna',
      wartosc: 49.95,
      data: DateTime.now(),
    ), */
  ];

  bool _pokazWykres = false;

  List<Transakcje> get _aktualTransakcje {
    return _userTransakcje.where((tx) {
      return tx.data.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _dodajNowaTransakcje(
      String txTytul, double txWartosc, DateTime wybranaData) {
    final newTx = Transakcje(
      tytul: txTytul,
      wartosc: txWartosc,
      data: wybranaData,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransakcje.add(newTx);
    });
  }

  void _startNowejTransakcji(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NowaTransakcja(_dodajNowaTransakcje),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _usunTransakcje(String id) {
    setState(() {
      _userTransakcje.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Twoje Wydatki',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startNowejTransakcji(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Twoje Wydatki',
            ),
            actions: [
              IconButton(
                onPressed: () => _startNowejTransakcji(context),
                icon: Icon(Icons.add),
              ),
            ],
          );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransakcjaLista(_userTransakcje, _usunTransakcje),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pokaż Wykres',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Switch.adaptive(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: _pokazWykres,
                    onChanged: (val) {
                      setState(() {
                        _pokazWykres = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_aktualTransakcje),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _pokazWykres
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_aktualTransakcje),
                    )
                  : txListWidget
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startNowejTransakcji(context),
                  ),
          );
  }
}
