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

  void _scrollToItem(String value) {
    if (value.isEmpty) return;
    final int? index = int.tryParse(value);
    if (index != null && index >= 0 && index < _items.length) {
      _scrollController.animateTo(
        index * 50.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _SearchBarDelegate(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text(_items[index].toString()),
              ),
              childCount: _items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SearchBarDelegate({required this.child});

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 4,
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) => false;
}
