import 'package:flutter/material.dart';
import 'package:textml/screens/conversion_history.dart';
import 'package:textml/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ConversionHistory(),
  ];

  void _onTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabItem,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange.shade900,
        backgroundColor: Colors.orangeAccent.shade100,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.transform),
            label: "conversion",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "history"),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
