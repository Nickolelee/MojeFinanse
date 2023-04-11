import 'package:aplikacja_wydatki/widgety/chart_bar.dart';
import 'package:flutter/material.dart';
import '../modele/transakcje.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transakcje> aktualTransakcje;

  Chart(this.aktualTransakcje);

  List<Map<String, Object>> get grupyWartosciTransakcji {
    return List.generate(7, (index) {
      final dzienTygodnia = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < aktualTransakcje.length; i++) {
        if (aktualTransakcje[i].data.day == dzienTygodnia.day &&
            aktualTransakcje[i].data.month == dzienTygodnia.month &&
            aktualTransakcje[i].data.year == dzienTygodnia.year) {
          totalSum += aktualTransakcje[i].wartosc;
        }
      }

      return {
        'dzień': DateFormat.E().format(dzienTygodnia).substring(0, 1),
        'wartość': totalSum
      };
    });
  }

  double get maxWydane {
    return grupyWartosciTransakcji.fold(0.0, (sum, item) {
      return sum + (item['wartość'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: grupyWartosciTransakcji.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  (data['dzień'] as String),
                  (data['wartość'] as double),
                  maxWydane == 0.0
                      ? 0.0
                      : (data['wartość'] as double) / maxWydane),
            );
          }).toList(),
        ),
      ),
    );
  }
}
