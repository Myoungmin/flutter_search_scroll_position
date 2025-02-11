import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchableListView(),
    );
  }
}

class SearchableListView extends StatefulWidget {
  const SearchableListView({super.key});

  @override
  SearchableListViewState createState() => SearchableListViewState();
}

class SearchableListViewState extends State<SearchableListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<int> _items = List.generate(100, (index) => index);
  final double _itemHeight = 50.0; // ListTile 높이 고정

  void _scrollToItem(String value) {
    if (value.isEmpty) return;
    final int? index = int.tryParse(value);
    if (index != null && index >= 0 && index < _items.length) {
      final double targetOffset = index * _itemHeight;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "숫자 검색 (0-99)",
                border: OutlineInputBorder(),
              ),
              onSubmitted: _scrollToItem,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _items.length,
              itemExtent: _itemHeight, // 항목 높이 고정
              itemBuilder: (context, index) => ListTile(
                title: Text(_items[index].toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
