import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: 'Home', backgroundColor: Colors.red),
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
    );
  }
}
