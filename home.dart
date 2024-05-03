import 'dart:ffi';
import 'dart:html';
import 'dart:mirrors';
import 'dart:svg';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FlightBooking extends StatefulWidget {
  const FlightBooking({super.key});

  @override
  State<FlightBooking> createState() => _FlightBookingState();
}
class _FlightBookingState extends State<FlightBooking> {
  TextEditingController idController   = TextEditingController();
  TextEditingController _passengernameController = TextEditingController();
  TextEditingController departureController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  late dynamic db = null;
  List<Map<String, Object?>> Flights = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupDatabase();
  }

  void setupDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'FlightBooking_db.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE flights (id INTEGER PRIMARY KEY, passenger name TEXT, departure TEXT, destination TEXT)',
        );
      },
      version: 2,
    );
    db = await database;

    retrieve();
  }

  void save() async {
    await db.insert(
      'flights',
      {"departure": departureController.text, "destination": destinationController.text,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    retrieve();
  }

  void retrieve() async {
    final List<Map<String, Object?>> flights = await db.query('flights');
    setState(() {
      this.flights = flights;
    });
  }

  void deleteFlight(id) async {
    await db.delete(
      'flights',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
    retrieve();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title:Text("Flight Booking System")),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: departureController,
              decoration: const InputDecoration(
                label: Text("Departure"),
              ),
            ),
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(
                label: Text("Destination"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                save();
              },
              child: Text("Save Book Flight"),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text('Departure'),
                      ),
                      DataColumn(
                        label: Text('Destination'),
                      ),
                      DataColumn(
                        label: Text('Action'),
                      ),
                    ],
                    rows: flights
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  e['departure'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['destination'].toString(),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    deleteFlight(e['id']);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
        
        ElevatedButton(
          onPressed:(){
            // Navigate to Hotel Selection Page
          },
          child:
    Text("Selection Hotel"),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigate to Order Cart Page
          },
          child:Text("View Order Cart"),
        ),
        ElevatedButton(
        onPressed:(){
          //Navigate to Register Page
        },
        child:
        Text("Register"),
        ),
        ElevatedButton(
          onPressed() {
            //Navigate to Partner Page
          },
          child:Text("Our Partners")
        ),
        ElevatedButton(
          onPressed:() {
            //Navigate to Search Ticket Page
          },
          child:
          Text("Search Tickets"),
            ),
          ],
        ),
      ),
    );
  }
}

      
    
  

