// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../modele/transakcje.dart';
import 'package:intl/intl.dart';

class TransakcjaLista extends StatelessWidget {
  final List<Transakcje> transakcje;
  final Function usunTx;

  TransakcjaLista(this.transakcje, this.usunTx);

  @override
  Widget build(BuildContext context) {
    return transakcje.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'Nie dodano żadnych transakcji',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                          child: Text('\$${transakcje[index].wartosc}')),
                    ),
                  ),
                  title: Text(
                    transakcje[index].tytul,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transakcje[index].data),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? TextButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text('Usuń'),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.error)),
                          onPressed: () => usunTx(transakcje[index].id),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).colorScheme.error,
                          onPressed: () => usunTx(transakcje[index].id),
                        ),
                ),
              );
            },
            itemCount: transakcje.length,
          );
  }
}
