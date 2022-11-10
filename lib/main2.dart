import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_countdown_timer/countdown.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: CalendarWidget(),
      //home: ModeManuel(),
      home: MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalendarWidget()));
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModeManuel()));
                    },
                  ),
                )
              ],
            )));
  }
}

class ModeManuel extends StatefulWidget {
  const ModeManuel({super.key});

  @override
  State<ModeManuel> createState() => _ModeManuelState();
}

class _ModeManuelState extends State<ModeManuel> {
  @override
  int rating = 0;
  List<String> values = ['Très faible', 'Faible', 'Moyen', 'Fort', 'Très fort'];
  List<String> liste = [
    'Peppermint',
    'Lavande',
    'Fleur d\'orange',
    'Max détente'
  ];
  late var dropdownValue = liste.first;
  var _startTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  var _startDate = DateTime.now();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  Duration selectedValue = Duration(hours: 0, minutes: 0, seconds: 0);
  late CountdownTimerController controller;

  @override
  void initState() {
    super.initState();

    controller = CountdownTimerController(endTime: endTime);
  }

  Widget build(BuildContext context) {
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
                          'Heure de fin :\n' +
                              DateFormat('HH:mm').format(_startDate),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 35),
                        ),
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: _startTime.hour,
                                  minute: _startTime.minute));
                          if (time != null && time != _startTime) {
                            setState(() {
                              _startTime = time;

                              _startDate = DateTime(
                                _startDate.year,
                                _startDate.month,
                                _startDate.day,
                                _startTime.hour,
                                _startTime.minute,
                              );
                              //final Duration diff =
                              //    DateTime.now().difference(_startDate);
                              //_startDate = DateTime.now().add(diff);
                            });
                          }
                          //Duration diff = _startDate.difference(DateTime.now());
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
                      },
                      label: Text('LANCER'),
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

class CalendarWidget extends StatelessWidget {
  final _controller = CalendarController();
  final _events = DataSource(<Appointment>[]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              title: Text('Calendar Programmation'),
              backgroundColor: Colors.black,
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
          floatingActionButton: Stack(
            children: [
              Positioned(
                right: 30,
                bottom: 20,
                child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    heroTag: 'bouton1',
                    child: const Text('+'),
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
                    }),
              ),
              Positioned(
                left: 70,
                bottom: 20,
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  heroTag: 'bouton2',
                  child: Text('-'),
                  onPressed: () {
                    if (_selectedAppointment != null) {
                      _events.appointments!.removeAt(
                          _events.appointments!.indexOf(_selectedAppointment));
                      _events.notifyListeners(CalendarDataSourceAction.remove,
                          <Appointment>[]..add(_selectedAppointment));
                    } else {
                      print('bite');
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
            view: CalendarView.week,
            showDatePickerButton: true,
            controller: _controller,
            dataSource: _events,
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
  @override
  _SecondRouteState createState() => _SecondRouteState();
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

  List<String> liste = <String>[
    'Peppermint',
    'Lavande',
    'Fleur d\'orange',
    'Max détente'
  ];

  List<Color> listeCouleurs = <Color>[
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.cyan
  ];
  late String dropdownValue = liste.first;
  var _selectedColorIndex = 0;
  int rating = 0;
  List<String> values = ['Très faible', 'Faible', 'Moyen', 'Fort', 'Très fort'];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                title: const Text('New event'),
                backgroundColor: Colors.black,
                /*eading: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),*/

                actions: <Widget>[
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
                ]),
            body: Container(
              //color: Colors.white,
              child:
                  ListView(padding: const EdgeInsets.all(0), children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  leading: const Text(''),
                  title: TextField(
                    controller: TextEditingController(text: _subject),
                    onChanged: (String value) {
                      _subject = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
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
                    contentPadding: const EdgeInsets.fromLTRB(5, 2, 85, 2),
                    leading: const Text(''),
                    title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 7,
                            child: GestureDetector(
                                child: Text(
                                    DateFormat('EEE, MMM dd yyyy')
                                        .format(_startDate),
                                    textAlign: TextAlign.center),
                                onTap: () async {
                                  var date = await showDatePicker(
                                    context: context,
                                    initialDate: _startDate,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );
                                  if (date != null && date != _startDate) {
                                    setState(() {
                                      final Duration difference =
                                          _endDate.difference(_startDate);
                                      _startDate = DateTime(
                                          date.year,
                                          date.month,
                                          date.day,
                                          _startTime.hour,
                                          _startTime.minute,
                                          0);
                                      _endDate = _startDate.add(difference);
                                      _endTime = TimeOfDay(
                                          hour: _endDate.hour,
                                          minute: _endDate.minute);
                                    });
                                  }
                                }),
                          ),
                          Expanded(
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
                                      }))
                        ])),
                SizedBox(height: 25),
                ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(5, 2, 85, 2),
                    leading: const Text(''),
                    title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 7,
                            child: GestureDetector(
                                child: Text(
                                    DateFormat('EEE, MMM dd yyyy')
                                        .format(_endDate),
                                    textAlign: TextAlign.center),
                                onTap: () async {
                                  var date = await showDatePicker(
                                    context: context,
                                    initialDate: _endDate,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );
                                  if (date != null && date != _endDate) {
                                    setState(() {
                                      final Duration difference =
                                          _endDate.difference(_startDate);
                                      _endDate = DateTime(
                                          date.year,
                                          date.month,
                                          date.day,
                                          _endTime.hour,
                                          _endTime.minute,
                                          0);
                                      if (_endDate.isBefore(_startDate)) {
                                        _startDate.subtract(difference);
                                        _startTime = TimeOfDay(
                                            hour: _endDate.hour,
                                            minute: _endDate.minute);
                                      }
                                    });
                                  }
                                }),
                          ),
                          Expanded(
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
                                      }))
                        ])),
                SizedBox(height: 100),
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(85, 2, 5, 2),
                  leading: DropdownButton<String>(
                    items: liste.map<DropdownMenuItem<String>>((String value) {
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
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 100),
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
