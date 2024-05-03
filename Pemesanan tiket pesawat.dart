import 'dart:ffi';
import 'dart:html';
import 'dart:html_common';
import 'dart:io';
import 'dart:svg';
import 'dart:web_audio';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'FlightBooking_db.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE flights (id INTEGER PRIMARY KEY, passenger_name TEXT, destination TEXT , departure_date TEXT)',
      );
    },
    version: 1,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: bookingsForm(),
    );
  }
}
class bookingsForm extends StatefulWidget {
     const bookingsForm({Key key}): super (key:key);

     @override
     _bookingsFormState createState() =>
     _bookingsFormState();
}


class _bookingsFormState extends
State<BookingForm>{
  final TextEditingController _passengernameController
  = TextEditingController();
  final TextEditingController
  _destinationController =TextEditingController();
    final TextEditingController
    _departuredateController = TextEditingController();

    future<void> _submitBooking() async{
      final Database db =await database;
      await db.insert(
        'booking ticket',
        {
          'passenger_name': _passengernameController.text,
         'destination':_destinationController.text,
         'departure_date': _departuredateController.text,
        },
        ConflictAlgorithm:
    ConflictAlgorithm.replace, 
      );
      // Tambahkan logika untuk menampilkan pesan sukses atau navigasi ke halaman lain
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar:AppBar(
          title:const Text('Flight Ticket Booking'),
        ),
        body: Padding(
           Padding: const EdgeInsets.all(16.0),
           child:Column(
             crossAxisAlignment:
        CrossAxisAlignment.start,
            children:[
              TextField(
                controller:_departuredateController,
                decoration:Const
        InputDecoration(labelText: 'passenger name'),
              ),
              TextField(
                controller:_tujuanController,
                decoration:const
        InputDecoration(labelText: 'destination'),
              ),
              TextField(
                controller:_namaController,
                decoration:const
        InputDecoration(labelText:'departure date'),
              ),
              ElevatorButton(
                onPressed:_submitBooking,
                child: const Text('booking ticket'),
              ),
            ],
           ),
        ),
      );
    }
  }



    