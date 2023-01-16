import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'main.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //SharedPreferences pre = await SharedPreferences.getInstance();
  //pre.setStringList("historic", ["Flutter", "Dart", "App"]);
  //debugPrint("okayyyyyyyy");
  //runApp(Historic(pre: pre));
}

class Historic extends StatelessWidget {
  SharedPreferences pre;
  Historic({super.key, required this.pre});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(children: <Widget>[
            const Text(
              'Manual Diffusions Historic',
              textAlign: TextAlign.center,
            ),
            IconButton(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () async {
                  pre.setStringList("historic", []);
                  (context as Element).markNeedsBuild();
                }),
          ])),
      body: history(title: 'Your historic', pre: pre),
    );
  }
}

class history extends StatefulWidget {
  history({super.key, required this.title, required this.pre});
  SharedPreferences pre;
  final String title;

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  @override
  void initState() {
    super.initState();
  }

  ListView _buildListViewOfEvents(List<String> eventsList) {
    List<Container> containers = <Container>[];
    for (int i = eventsList.length - 1; i >= 0; i--) {
      debugPrint("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      containers.add(
        Container(
          //height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      eventsList[i],
                      textAlign: TextAlign.center,
                    ),
                    const Divider(
                      height: 30,
                      thickness: 5,
                      indent: 0,
                      endIndent: 0,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Column(),
        ...containers,
      ],
    );
  }

  Widget _buildView(eventsList) {
    debugPrint("là");

    return _buildListViewOfEvents(eventsList);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: _buildView(_getHistoric(widget
          .pre)) /*FutureBuilder<dynamic>(
        future: _getHistoric(widget.pre),
        builder: (context, data) {
          if (data.hasData /*&& data.data*/) {
            return _buildView(_getHistoric());
          } else {
            debugPrint("hist vide");
            return _buildView(["ayaya", "ouloulou"]);
          }
        },
      )*/
      );
}

List<String> _getHistoric(SharedPreferences pre) {
  return pre.getStringList("historic") ?? [];
}


/*class hist extends StatelessWidget {
  hist({super.key, required this.title});
  final String title;

  @override
  List<String> eventsList = <String>[];
  _addEventTolist() async {
    String events = await _readHistory();
    String Ievents = "";
    List<String> listEvents = <String>[];
    for (int i = events.length - 1; i >= 0; i++) {
      if (events[i] == ";") {
        listEvents.add(Ievents);
        Ievents = "";
      } else {
        Ievents += events[i];
      }
    }
    return listEvents;
  }

  @override

  //eventsList =
  Future <ListView> _buildListViewOfEvents() async{
    //eventsList = await _addEventTolist();
    List<Container> containers = <Container>[];
    for (String event in await _addEventTolist() as List) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(event),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  Future<ListView> _buildView() async{
    debugPrint("là");

    return await _buildListViewOfEvents();
  }

  Future<String> _readHistory() async {
    String txt = "";
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/history.txt');
      txt = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return txt;
  }

  @override
  Widget build(BuildContext context) async => Scaffold(
        appBar: AppBar(
          title: Text("Select your device"),
          backgroundColor: Colors.black,
        ),
        body: await _buildView(),
      );
}
*/
