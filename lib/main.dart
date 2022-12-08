import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_blue/gen/flutterblue.pbserver.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_countdown_timer/countdown.dart';
import 'package:flutter_blue/flutter_blue.dart' as fb;
import 'DevicesList.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'dart:convert' show utf8;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: CalendarWidget(),
      //home: ModeManuel(),
      home: MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatefulWidget {
  MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  List<fb.BluetoothDevice> _connectedDevice = <fb.BluetoothDevice>[];
  List<fb.BluetoothService> services = <fb.BluetoothService>[];
  List<String> strength = <String>[];
  bool connected = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Home Menu'),
              centerTitle: true,
              backgroundColor: Colors.black,
            ),
            body: Container(
                child: Column(
              children: const <Widget>[
                Align(alignment: Alignment.center),
                Text("OPED",
                    style: TextStyle(
                      fontFamily: 'Signatra',
                      fontWeight: FontWeight.bold,
                      fontSize: 90,
                    )),
                Text('Olfactive Performance Enhancing Device',
                    style: TextStyle(
                      fontSize: 10,
                    )),
              ],
            )),
            floatingActionButton: Stack(
              children: [
                Positioned(
                  left: 100,
                  top: 400,
                  child: FloatingActionButton.extended(
                      label: Text('Calendar Programmation'),
                      backgroundColor: Colors.black,
                      heroTag: 'bouton1',
                      onPressed: () async {
                        if (connected == true) {
                          List<Appointment> ds = <Appointment>[];
                          String data = await _read();
                          DateTime start = DateTime.now();
                          DateTime end = DateTime.now();
                          strength = <String>[];
                          String subject = "";
                          String value = "";
                          bool tdone = false;
                          Color couleur = Colors.black;
                          int y = 1;
                          for (int i = 0; i < data.length; i++) {
                            if (data[i] != "." && data[i] != ";") {
                              if (y == 1 || y == 2) {
                                /*if (data[i] == ":") {
                            value += "T";
                          } else*/
                                if (data[i] == " " && tdone == false) {
                                  value += "T";
                                  tdone = true;
                                } else if (data[i] == " " && tdone == true) {
                                } else if (data[i] == "–") {
                                } else {
                                  value += data[i];
                                }
                              } else {
                                value += data[i];
                              }
                            }
                            if (data[i] == ".") {
                              switch (y) {
                                case 1:
                                  {
                                    start = DateTime.parse(value);
                                  }
                                  break;
                                case 2:
                                  {
                                    end = DateTime.parse(value);
                                  }
                                  break;
                                case 3:
                                  {
                                    strength.add(value);
                                  }
                                  break;
                              }
                              value = "";
                              y += 1;
                              tdone = false;
                            }
                            if (data[i] == ";") {
                              subject = value;
                              if (value.contains("Peppermint")) {
                                couleur = Colors.green;
                              } else if (subject.contains("Lavender")) {
                                couleur = Colors.purple;
                              } else if (subject.contains("Orange")) {
                                couleur = Colors.orange;
                              } else if (subject.contains("Lemon")) {
                                couleur = Colors.yellow;
                              }

                              value = "";
                              y = 1;

                              Appointment z = Appointment(
                                  startTime: start,
                                  endTime: end,
                                  subject: subject,
                                  color: couleur);
                              if (start.day == DateTime.now().day &&
                                  end.day == DateTime.now().day) {
                                ds.add(z);
                              }
                            }
                          }
                          //events = DataSource(ds);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalendarWidget(
                                      device: _connectedDevice,
                                      services: services,
                                      events: DataSource(ds))));
                        } else {
                          showDialog(
                              context: context,
                              builder: ((context) => const AlertDialog(
                                  content: Text(
                                      'You should connect to a device first.'))));
                        }
                      }),
                ),
                Positioned(
                  left: 107,
                  bottom: 300,
                  child: FloatingActionButton.extended(
                    label: Text('Manual Programmation'),
                    backgroundColor: Colors.black,
                    heroTag: 'bouton2',
                    onPressed: () {
                      if (connected == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModeManuel(
                                    device: _connectedDevice,
                                    services: services)));
                      } else {
                        showDialog(
                            context: context,
                            builder: ((context) => const AlertDialog(
                                content: Text(
                                    'You should connect to a device first.'))));
                      }
                    },
                  ),
                ),
                Positioned(
                  left: 107,
                  bottom: 200,
                  child: FloatingActionButton.extended(
                    label: Text('Connect to your device'),
                    backgroundColor: Colors.black,
                    heroTag: 'bouton3',
                    onPressed: () async {
                      if (connected == false) {
                        final results = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyHomePage(title: "oui oui baguette !")));
                        if (results != null) {
                          connected = true;
                          services = await results.discoverServices();

                          setState(() {
                            _connectedDevice.add(results);
                          });
                        }
                      } else {
                        if (_connectedDevice.length != 0) {
                          _connectedDevice[0].disconnect();
                          _connectedDevice.clear();
                          connected = false;
                          showDialog(
                              context: context,
                              builder: ((context) => const AlertDialog(
                                  content: Text('Déconnecté'))));
                        }
                      }
                    },
                  ),
                )
              ],
            )));
  }
}

class ModeManuel extends StatefulWidget {
  @override
  List<fb.BluetoothDevice> device = <fb.BluetoothDevice>[];
  List<fb.BluetoothService> services = <fb.BluetoothService>[];
  ModeManuel({super.key, required this.device, required this.services});

  @override
  State<ModeManuel> createState() => _ModeManuelState();
}

class _ModeManuelState extends State<ModeManuel> {
  @override
  int rating = 0;
  List<String> values = [
    'Very Weak',
    'Weak',
    'Medium',
    'Strong',
    'Very Strong'
  ];
  List<String> liste = ['Peppermint', 'Lavender', 'Orange', 'Lemon'];
  late var dropdownValue = liste.first;
  var _startTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  var _startDate = DateTime.now();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  Duration selectedValue = Duration(hours: 0, minutes: 0, seconds: 0);
  late CountdownTimerController controller;

  final fb.FlutterBlue flutterBlue = fb.FlutterBlue.instance;
  List<fb.BluetoothDevice> device = <fb.BluetoothDevice>[];
  List<fb.BluetoothService> services = <fb.BluetoothService>[];
  TimeOfDay fin =
      TimeOfDay(hour: DateTime.now().hour + 5, minute: DateTime.now().minute);
  int compteur = 0;
  bool envoi = false;
  Duration diff = Duration();

  @override
  void initState() {
    super.initState();
    device = widget.device;
    services = widget.services;
    controller = CountdownTimerController(endTime: endTime);
  }

  Widget build(BuildContext context) {
    if (device != null && services != null) {
      //debugPrint(device[0].name);
    }

    return Container(
        width: MediaQuery.of(context).size.width,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.black,
                    title: Text('Manual Programmation'),
                    leading: IconButton(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      items:
                          liste.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(
                                  fontSize: 35, color: Colors.black87)),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      value: dropdownValue,
                      elevation: 16,
                      style:
                          const TextStyle(fontSize: 40, color: Colors.black87),
                      underline: SizedBox(),
                    ),
                    SizedBox(height: 100),
                    GestureDetector(
                        child: Text(
                          'Ending Time :\n' +
                              DateFormat('HH:mm').format(_startDate),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 35),
                        ),
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: _startTime);
                          if (time != null) {
                            setState(() {
                              _startTime = time;

                              _startDate = DateTime(
                                _startDate.year,
                                _startDate.month,
                                _startDate.day,
                                _startTime.hour,
                                _startTime.minute,
                              );
                              final Duration diff =
                                  DateTime.now().difference(_startDate);
                            });
                          }
                          diff = _startDate.difference(DateTime.now());
                        }),
                    SizedBox(height: 100),
                    Text(
                      values[rating],
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(fontSize: 20),
                    ),
                    CupertinoSlider(
                      value: rating.toDouble(),
                      min: 0,
                      max: 4,
                      divisions: 4,
                      activeColor: Colors.black87,
                      thumbColor: Colors.black87,
                      onChanged: (selectedValue) {
                        setState(() {
                          rating = selectedValue.toInt();
                        });
                      },
                    ),
                    SizedBox(height: 100),
                    FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          CountdownTimer(
                            controller: controller,
                            endTime: _startDate
                                .difference(DateTime.now())
                                .inMilliseconds,
                          );
                        });

                        compteur = diff.inMilliseconds * 10;
                        compteur += rating;
                        for (fb.BluetoothService s in services) {
                          for (fb.BluetoothCharacteristic c
                              in s.characteristics) {
                            if (c.properties.write) {
                              c.write(utf8.encode("2" + compteur.toString()));
                              debugPrint(diff.inMilliseconds.toString());
                              debugPrint(compteur.toString());
                            }
                          }
                        }
                      },
                      label: Text('START'),
                      backgroundColor: Colors.black87,
                    ),
                  ],
                )))));
  }
}

var _selectedAppointment = null;
void calendarTapped(CalendarTapDetails calendarTapDetails) {
  if (calendarTapDetails.targetElement == CalendarElement.agenda ||
      calendarTapDetails.targetElement == CalendarElement.appointment) {
    final Appointment appointment = calendarTapDetails.appointments![0];
    _selectedAppointment = appointment;
  }
}

CountdownTimer lancement(controller, DateTime _endDate) {
  return CountdownTimer(
    controller: controller,
    endTime: _endDate.millisecondsSinceEpoch,
  );
}

_write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/my_file.txt');
  await file.delete();
  await file.writeAsString(text);
}

Future<String> _read() async {
  String txt = "";
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    txt = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
  return txt;
}

class CalendarWidget extends StatelessWidget {
  final _controller = CalendarController();
  var events = DataSource(<Appointment>[]);
  List<fb.BluetoothDevice> device = <fb.BluetoothDevice>[];
  List<fb.BluetoothService> services = <fb.BluetoothService>[];
  CalendarWidget(
      {super.key,
      required this.device,
      required this.services,
      required this.events});
  List<String> strength = <String>[];
  String envoiBT = "1";
  String writeFile = "";
  late Directory directory;
  late String filePath;

  //final File file = File(path.toString() + '.to/my_file.txt');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              title: Row(children: <Widget>[
                IconButton(
                  padding: const EdgeInsets.fromLTRB(5, 0, 30, 0),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Calendar Programmation',
                  textAlign: TextAlign.center,
                ),
                IconButton(
                    padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      writeFile = "";
                      if (strength.length > 0 &&
                          strength[0] != null &&
                          events.appointments!.length > 0 &&
                          events.appointments![0] != null) {
                        for (int i = 0; i < events.appointments!.length; i++) {
                          /////////////////////////////////////
                          ///
                          writeFile += DateFormat('yyyy-MM-dd – kk:mm')
                                  .format(events.appointments![i].startTime) +
                              ".";
                          writeFile += DateFormat('yyyy-MM-dd – kk:mm')
                                  .format(events.appointments![i].endTime) +
                              ".";
                          writeFile += strength[i] + ".";
                          writeFile += events.appointments![i].subject + ";";
                        }
                      }
                      await _write(writeFile);
                      debugPrint(await _read());
                    }),
              ])),
          floatingActionButton: Stack(
            children: [
              Positioned(
                right: 54,
                bottom: 20,
                child: FloatingActionButton.extended(
                    backgroundColor: Colors.black,
                    heroTag: 'bouton1',
                    label: const Text('+'),
                    onPressed: () {
                      _secondPage(BuildContext context, Widget page) async {
                        final dataFromSecondPage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => page),
                            )) /*as Appointment*/;
                        if (dataFromSecondPage != null) {
                          events.appointments!.add(dataFromSecondPage.event);
                          events.notifyListeners(CalendarDataSourceAction.add,
                              <Appointment>[dataFromSecondPage.event]);
                          strength = dataFromSecondPage.strength;
                        }

                        if (strength.length > 0 && strength[0] != null) {
                          debugPrint(strength.length.toString());
                        }

                        //}
                      }

                      _secondPage(
                          context,
                          SecondRoute(
                            strength: strength,
                          ));
                    }),
              ),
              Positioned(
                left: 118,
                bottom: 20,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.black,
                  heroTag: 'bouton2',
                  label: Text('-'),
                  onPressed: () {
                    if (_selectedAppointment != null) {
                      events.appointments!.removeAt(
                          events.appointments!.indexOf(_selectedAppointment));
                      events.notifyListeners(CalendarDataSourceAction.remove,
                          <Appointment>[]..add(_selectedAppointment));
                    } else {
                      print('bite');
                    }
                  },
                ),
              ),
              Positioned(
                //width: MediaQuery.of(context).size.width,
                left: 165,
                bottom: 20,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.black,
                  heroTag: 'bouton3',
                  label: Text("Synchronize"),
                  onPressed: () async {
                    writeFile = "";
                    if (envoiBT != "1") {
                      envoiBT = "1";
                    }
                    if (strength.length > 0 &&
                        strength[0] != null &&
                        events.appointments!.length > 0 &&
                        events.appointments![0] != null) {
                      for (int i = 0; i < events.appointments!.length; i++) {
                        envoiBT += events.appointments![i].startTime
                            .difference(DateTime.now())
                            .inMilliseconds
                            .toString();
                        envoiBT += '.';

                        envoiBT += events.appointments![i].endTime
                            .difference(events.appointments![i].startTime)
                            .inMilliseconds
                            .toString();
                        envoiBT += '.';

                        envoiBT += strength[i] + ';';

                        /////////////////////////////////////
                        ///
                        writeFile += DateFormat('yyyy-MM-dd – kk:mm')
                                .format(events.appointments![i].startTime) +
                            ".";
                        writeFile += DateFormat('yyyy-MM-dd – kk:mm')
                                .format(events.appointments![i].endTime) +
                            ".";
                        writeFile += strength[i] + ".";
                        writeFile += events.appointments![i].subject + ";";
                      }
                    }
                    await _write(writeFile);
                    debugPrint(await _read());
                    for (fb.BluetoothService s in services) {
                      for (fb.BluetoothCharacteristic c in s.characteristics) {
                        if (c.properties.write) {
                          c.write(utf8.encode(envoiBT));
                          debugPrint(envoiBT);
                        }
                      }
                    }
                  },
                ),
              )
            ],
          ),

          /*FloatingActionButton(
                  child: const Text('ADD'),
                  onPressed: () {
                    _secondPage(BuildContext context, Widget page) async {
                      final dataFromSecondPage = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => page),
                          )) as Appointment;
                      _events.appointments!.add(dataFromSecondPage);
                      _events.notifyListeners(CalendarDataSourceAction.add,
                          <Appointment>[dataFromSecondPage]);
                      //}
                    }

                    _secondPage(context, SecondRoute());
                  }),*/
          //if (_controller.selectedDate != null) {
          /*final Appointment app = Appointment(
                    startTime: _controller.selectedDate!,
                    endTime:
                        _controller.selectedDate!.add(const Duration(hours: 2)),
                    subject: 'Peppermint\nIntense',
                    color: Colors.green);
                _events.appointments!.add(app);
                _events.notifyListeners(
                    CalendarDataSourceAction.add, <Appointment>[app]);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => SecondRoute()),
                    ));
            },
          ),*/

          body: SfCalendar(
            selectionDecoration:
                BoxDecoration(border: Border.all(color: Colors.black)),
            view: CalendarView.day,
            minDate: DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            maxDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 23, 59, 59),
            showDatePickerButton: false,
            controller: _controller,
            dataSource: events,
            todayHighlightColor: Colors.black,
            onTap: calendarTapped,
          )),
    );
  }
}

/*Appointment calendarTapped(CalendarTapDetails calendarTapDetails) {
      Appointment _selectedAppointment = new Appointment(startTime: DateTime.now(), endTime: DateTime.now())
      if (calendarTapDetails.targetElement==CalendarElement.agenda || calendarTapDetails.targetElement==CalendarElement.appointment) {
        final Appointment appointment = calendarTapDetails.appointments![0];
        _selectedAppointment = appointment;}
        return _selectedAppointment;
        
      
    }*/

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

DataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(hours: 2)),
    isAllDay: true,
    subject: 'Meeting',
    color: Colors.blue,
    startTimeZone: '',
    endTimeZone: '',
  ));

  return DataSource(appointments);
}

class SecondRoute extends StatefulWidget {
  List<String> strength = <String>[];
  SecondRoute({super.key, required this.strength});
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class PassageInfos {
  List<String> strength = <String>[];
  Appointment event =
      Appointment(startTime: DateTime.now(), endTime: DateTime.now());

  PassageInfos(List<String> strength) {
    this.strength = strength;
  }
}

class _SecondRouteState extends State<SecondRoute> {
  final _ColorPicker = ColorPicker(
    pickerColor: Colors.black,
    onColorChanged: (Color color) {
      print(color);
    },
  );
  var _subject;
  var _isAllDay = false;
  DateTime _startDate = DateTime.now();
  var _endDate = DateTime.now();
  var _startTime = TimeOfDay(
    hour: DateTime.now().hour,
    minute: DateTime.now().minute,
  );
  var _endTime = TimeOfDay(
    hour: DateTime.now().hour,
    minute: DateTime.now().minute,
  );

  List<String> liste = <String>['Peppermint', 'Lavender', 'Orange', 'Lemon'];

  List<Color> listeCouleurs = <Color>[
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.cyan
  ];
  late String dropdownValue = liste.first;
  var _selectedColorIndex = 0;
  int rating = 0;
  List<String> values = [
    'Very Weak',
    'Weak',
    'Medium',
    'Strong',
    'Very Strong'
  ];
  String smell = "";
  PassageInfos passage = new PassageInfos(<String>[]);
  @override
  void initState() {
    passage = PassageInfos(widget.strength);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                title: Row(
                  children: <Widget>[
                    IconButton(
                      padding: const EdgeInsets.fromLTRB(5, 0, 60, 0),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Adding a new event',
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      padding: const EdgeInsets.fromLTRB(60, 0, 5, 0),
                      icon: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        String libele = dropdownValue;
                        Color couleur = Colors.blue;
                        if (libele == 'Peppermint') {
                          couleur = Colors.green;
                          smell = "0";
                        }
                        if (libele == 'Lavender') {
                          couleur = Colors.purple;
                          smell = "1";
                        }
                        if (libele == 'Orange') {
                          couleur = Colors.orange;
                          smell = "2";
                        }
                        if (libele == 'Lemon') {
                          couleur = Colors.yellow;
                          smell = "3";
                        }

                        DateTime start = DateTime(
                          _startDate.year,
                          _startDate.month,
                          _startDate.day,
                          _startTime.hour,
                          _startTime.minute,
                        );

                        DateTime end = DateTime(
                          _endDate.year,
                          _endDate.month,
                          _endDate.day,
                          _endTime.hour,
                          _endTime.minute,
                        );

                        passage.event = Appointment(
                            startTime: start,
                            endTime: end,
                            subject:
                                '$_subject \nSmell : $libele\nStrength : ' +
                                    values[rating].toString(),
                            color: couleur);

                        passage.strength.add(rating.toString());

                        Navigator.pop(context, passage);
                      },
                    )
                  ],
                )

                /*eading: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),*/

                /*actions: <Widget>[
                  IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      String libele = dropdownValue;
                      Color couleur = Colors.blue;
                      if (libele == 'Peppermint') {
                        couleur = Colors.green;
                      }
                      if (libele == 'Lavande') {
                        couleur = Colors.purple;
                      }
                      if (libele == 'Fleur d\'orange') {
                        couleur = Colors.orange;
                      }
                      if (libele == 'Max détente') {
                        couleur = Colors.grey;
                      }
                      Appointment nouvoSlot = Appointment(
                          startTime: DateTime(
                            _startDate.year,
                            _startDate.month,
                            _startDate.day,
                            _startTime.hour,
                            _startTime.minute,
                          ),
                          endTime: DateTime(
                            _endDate.year,
                            _endDate.month,
                            _endDate.day,
                            _endTime.hour,
                            _endTime.minute,
                          ),
                          subject: '$_subject \n$libele',
                          color: couleur);
                      Navigator.pop(context, nouvoSlot);
                    },
                  )
                ]*/
                ),
            body: Container(
              //color: Colors.white,
              child:
                  ListView(padding: const EdgeInsets.all(0), children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(45, 0, 99, 0),
                  leading: const Text(''),
                  title: TextField(
                    controller: TextEditingController(text: _subject),
                    onChanged: (String value) {
                      _subject = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add Title',
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                  thickness: 1,
                ),
                SizedBox(height: 50),
                Text(
                  "Starting time :",
                  style: TextStyle(
                      fontSize: 30, decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
                /*ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    leading: Icon(
                      Icons.access_time,
                      color: Colors.black54,
                    ),
                    title: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text('All Day'),
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Switch(
                                  value: _isAllDay,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isAllDay = value;
                                    });
                                  },
                                ))),
                      ],
                    )),*/
                ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(30, 2, 85, 2),
                    leading: const Text(''),
                    title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex: 7,
                              child: _isAllDay
                                  ? const Text('')
                                  : GestureDetector(
                                      child: Text(
                                          DateFormat('HH:mm')
                                              .format(_startDate),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 50)),
                                      onTap: () async {
                                        var time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _startTime.hour,
                                                minute: _startTime.minute));
                                        if (time != null &&
                                            time != _startTime) {
                                          setState(() {
                                            _startTime = time;
                                            final Duration difference =
                                                _endDate.difference(_startDate);
                                            _startDate = DateTime(
                                                _startDate.year,
                                                _startDate.month,
                                                _startDate.day,
                                                _startTime.hour,
                                                _startTime.minute,
                                                0);
                                            /*_endDate =
                                                _startDate.add(difference);*/
                                            _endTime = TimeOfDay(
                                                hour: _endDate.hour,
                                                minute: _endDate.minute);
                                          });
                                        }
                                      })),
                          /*Expanded(
                              flex: 3,
                              child: _isAllDay
                                  ? const Text('')
                                  : GestureDetector(
                                      child: Text(
                                        DateFormat('hh:mm a')
                                            .format(_startDate),
                                        textAlign: TextAlign.right,
                                      ),
                                      onTap: () async {
                                        var time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _startTime.hour,
                                                minute: _startTime.minute));
                                        if (time != null &&
                                            time != _startTime) {
                                          setState(() {
                                            _startTime = time;
                                            final Duration difference =
                                                _endDate.difference(_startDate);
                                            _startDate = DateTime(
                                                _startDate.year,
                                                _startDate.month,
                                                _startDate.day,
                                                _startTime.hour,
                                                _startTime.minute,
                                                0);
                                            _endDate =
                                                _startDate.add(difference);
                                            _endTime = TimeOfDay(
                                                hour: _endDate.hour,
                                                minute: _endDate.minute);
                                          });
                                        }
                                      }))*/
                        ])),
                SizedBox(height: 25),
                Text(
                  "Ending time :",
                  style: TextStyle(
                      fontSize: 30, decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
                ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(30, 2, 85, 2),
                    leading: const Text(''),
                    title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex: 7,
                              child: _isAllDay
                                  ? const Text('')
                                  : GestureDetector(
                                      child: Text(
                                          DateFormat('HH:mm').format(_endDate),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 50)),
                                      onTap: () async {
                                        var time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _endTime.hour,
                                                minute: _endTime.minute));
                                        if (time != null && time != _endTime) {
                                          setState(() {
                                            _endTime = time;
                                            final Duration difference =
                                                _endDate.difference(_startDate);
                                            _endDate = DateTime(
                                                _endDate.year,
                                                _endDate.month,
                                                _endDate.day,
                                                _endTime.hour,
                                                _endTime.minute,
                                                0);
                                            if (_endDate.isBefore(_startDate)) {
                                              _startDate =
                                                  _endDate.subtract(difference);
                                              /*_startTime = TimeOfDay(
                                                  hour: _startDate.hour,
                                                  minute: _startDate.minute);*/
                                            }
                                          });
                                        }
                                      })),
                          /*Expanded(
                              flex: 3,
                              child: _isAllDay
                                  ? const Text('')
                                  : GestureDetector(
                                      child: Text(
                                        DateFormat('hh:mm a').format(_endDate),
                                        textAlign: TextAlign.left,
                                      ),
                                      onTap: () async {
                                        var time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _endTime.hour,
                                                minute: _endTime.minute));
                                        if (time != null && time != _endTime) {
                                          setState(() {
                                            _endTime = time;
                                            final Duration difference =
                                                _endDate.difference(_startDate);
                                            _endDate = DateTime(
                                                _endDate.year,
                                                _endDate.month,
                                                _endDate.day,
                                                _endTime.hour,
                                                _endTime.minute,
                                                0);
                                            if (_endDate.isBefore(_startDate)) {
                                              _startDate =
                                                  _endDate.subtract(difference);
                                              _startTime = TimeOfDay(
                                                  hour: _startDate.hour,
                                                  minute: _startDate.minute);
                                            }
                                          });
                                        }
                                      }))*/
                        ])),
                SizedBox(height: 35),
                Text(
                  "Smell : ",
                  style: TextStyle(
                      fontSize: 30, decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(100, 2, 5, 2),
                  leading: DropdownButton<String>(
                      items:
                          liste.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      value: dropdownValue,
                      elevation: 16,
                      style: const TextStyle(fontSize: 28, color: Colors.black),
                      underline: SizedBox()),
                ),
                SizedBox(height: 50),
                Text(
                  "Strength :",
                  style: TextStyle(
                      fontSize: 30, decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  values[rating],
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CupertinoSlider(
                      value: rating.toDouble(),
                      min: 0,
                      max: 4,
                      divisions: 4,
                      activeColor: Colors.black87,
                      thumbColor: Colors.black87,
                      onChanged: (selectedValue) {
                        setState(() {
                          rating = selectedValue.toInt();
                        });
                      },
                    ),
                  ],
                )
              ]),
            )));
  }
}
