import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
  final Map<int, GlobalKey> _itemKeys = {
    for (var i = 0; i < 100; i++) i: GlobalKey()
  };

  void _scrollToItem(String value) {
    if (value.isEmpty) return;
    final int? index = int.tryParse(value);
    if (index == null || index < 0 || index >= _items.length) return;

    final key = _itemKeys[index];
    if (key == null) return;

    final context = key.currentContext;
    if (context != null) {
      // 1. 이미 렌더링된 경우 바로 스크롤
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // 2. 예상 위치로 먼저 스크롤
      final double estimatedOffset = index * 50.0;

      _scrollController
          .animateTo(
        estimatedOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      )
          .then((_) {
        // 3. 스크롤이 완료된 후 다시 `ensureVisible` 실행
        SchedulerBinding.instance.addPostFrameCallback((_) {
          final newContext = key.currentContext;
          if (newContext != null) {
            Scrollable.ensureVisible(
              newContext,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      });
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
              itemBuilder: (context, index) => ListTile(
                key: _itemKeys[index], // 각 아이템에 GlobalKey 적용
                title: Text(_items[index].toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
