import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:socket_logger/log_list.dart';
import 'package:socket_logger/socket_service.dart';

final getIt = GetIt.instance;
void main() {
  getIt.registerSingleton(SocketService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final c = TextEditingController(text: getIt<SocketService>().host);

    return MaterialApp(
      title: 'Socket Logger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Socket Logger'),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsetsDirectional.only(start: 8.0, end: 8.0),
                child: SocketControl(c: c),
              ),
              LogList(),
            ],
          )),
    );
  }
}

class SocketControl extends StatefulWidget {
  const SocketControl({
    Key? key,
    required this.c,
  }) : super(key: key);

  final TextEditingController c;

  @override
  State<SocketControl> createState() => _SocketControlState();
}

class _SocketControlState extends State<SocketControl> {
  @override
  Widget build(BuildContext context) {
    var service = getIt<SocketService>();
    var connected = service.connected;

    return TextField(
      controller: widget.c,
      decoration: InputDecoration(
        hintText: 'Enter socket',
        suffix: connected
            ? MaterialButton(
                child: const Text('Disconnect'),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () {
                  service.disconnect();
                  setState(() {});
                })
            : MaterialButton(
                child: const Text('Connect'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  service.connect(widget.c.text);
                  setState(() {});
                }),
      ),
    );
  }
}
