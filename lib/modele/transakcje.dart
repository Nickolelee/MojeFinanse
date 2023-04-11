import 'package:flutter/material.dart';

class Transakcje {
  final String id;
  final String tytul;
  final double wartosc;
  final DateTime data;

  Transakcje({
    required this.id,
    required this.tytul,
    required this.wartosc,
    required this.data,
  });
}
