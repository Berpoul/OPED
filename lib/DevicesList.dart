import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'main.dart';

void main() {
  debugPrint("okayyyyyyyy");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter BLE Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BluetoothDevice> _connectedDevice = <BluetoothDevice>[];
  final _writeController = TextEditingController();
  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device) &&
        device.name == "Your OPED Device") {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      debugPrint("skusku");
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  ListView _buildListViewOfDevices() {
    List<BluetoothDevice> _connectedDevices = <BluetoothDevice>[];
    List<Container> containers = <Container>[];
    var title = "";
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                  child: Text(
                    'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    if (_connectedDevice.length == 0 ||
                        _connectedDevice.length == 1 &&
                            _connectedDevice[0] != device) {
                      widget.flutterBlue.stopScan();
                      await device.connect();
                      showDialog(
                          context: context,
                          builder: ((context) => const AlertDialog(
                              content: Text('Correctement connecté.'))));

                      _connectedDevice.add(device);
                      debugPrint("ohlà moussaillon!");
                      //_buildListViewOfDevices(_connectedDevice);
                      //var chars;
                      List<BluetoothService> _services =
                          await device.discoverServices();

                      _buildView(_connectedDevice, _services);
                      debugPrint("ici");
                      debugPrint(_connectedDevice[0].name);
                      //late BluetoothDevice dev = _connectedDevices[0];
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuPrincipal(
                                connected: true, connectedDevice: dev),
                          ));*/
                      if (device != null) {
                        debugPrint("miam");
                      }
                      widget.flutterBlue.stopScan();
                      Navigator.pop(context);
                      Navigator.pop(context, device);
                      debugPrint("blmiam");
                    } else {
                      debugPrint("ok ça a déco bg");
                      device.disconnect();
                      _connectedDevice.clear();
                      showDialog(
                          context: context,
                          builder: ((context) =>
                              const AlertDialog(content: Text('Déconnecté'))));
                    }
                  }),
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

  ListView _buildView(_connectedDevice, _services) {
    debugPrint("là");

    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Select your device"),
          backgroundColor: Colors.black,
        ),
        body: _buildView(null, null),
      );
}

class SecondPage extends StatefulWidget {
  final List<BluetoothService> services;
  final BluetoothDevice connectedDevice;
  const SecondPage(
      {required this.connectedDevice, required this.services, super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<BluetoothService> services = <BluetoothService>[];
  @override
  void initState() {
    services = widget.services;
  }

  var newV;
  ListView _buildConnectDeviceView(_services) {
    List<Container> containers = <Container>[];
    //debugPrint(_services);
    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = <Widget>[];
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        newV = characteristic.uuid.toString();
        characteristic.value.listen((value) {
          print(value);
        });
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Text('Value: ' + newV.toString()),
                  ],
                ),
              ],
            ),
          ),
        );
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
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

  final _writeController = TextEditingController();
  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () {},
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Send"),
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  newV = value;
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  final Map<Guid, List<int>> readValues = Map<Guid, List<int>>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("oh que oui"),
        ),
        body: _buildConnectDeviceView(services),
      );
}
