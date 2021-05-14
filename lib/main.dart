import 'package:flutter/material.dart';
import 'package:moch/pages/homepage.dart';
import 'package:moch/pages/records.dart';
import 'package:moch/widgets/sendSms.dart';
import 'package:telephony/telephony.dart';

void main() {
  runApp(const MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final telephony = Telephony.instance;

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Records(),
    Text(
      'Index 2: School',
    ),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //listen to sms incoming
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          print(message.body);
        },
        listenInBackground: false);

    return Scaffold(
        appBar: AppBar(
          title: Text('Moch'),
        ),
        body: Container(
          child: _widgetOptions.elementAt(_currentIndex),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => SendSms(),
            );
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Records',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.lock_clock),
                label: 'reserved',
                backgroundColor: Colors.amber)
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}
