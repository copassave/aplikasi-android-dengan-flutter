import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myrecipes/my_recipes_list.dart';
import 'recipes/recipe_list.dart';
import 'shopping/shopping_list.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> pageList = <Widget>[];
  static const String prefSelectedIndexKey = 'selectedIndex';

  @override
  void initState() {
    super.initState();
    pageList.add(const RecipeList());
    pageList.add(const MyRecipesList());
    pageList.add(ShoppingList());
    getCurrentIndex();
  }

  void saveCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefSelectedIndexKey, _selectedIndex);
  }

  void getCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(prefSelectedIndexKey)) {
      setState(() {
        _selectedIndex = prefs.getInt(prefSelectedIndexKey);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    saveCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    String title;
    switch (_selectedIndex) {
      case 0:
        title = 'Resep';
        break;
      case 1:
        title = 'Bookmark';
        break;
      case 2:
        title = 'Belanja';
        break;
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/icon_recipe.svg',
                  color: _selectedIndex == 0 ? Colors.red : Colors.grey,
                  semanticsLabel: 'Resep'),
              label: 'Resep'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/icon_bookmarks.svg',
                  color: _selectedIndex == 1 ? Colors.red : Colors.grey,
                  semanticsLabel: 'Bookmark'),
              label: 'Bookmark'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/icon_shopping_list.svg',
                  color: _selectedIndex == 2 ? Colors.red : Colors.grey,
                  semanticsLabel: 'Belanja'),
              label: 'Belanja'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.yellow,
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.yellow,
          statusBarColor: Colors.yellow,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.yellow,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),
    );
  }
}
