import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:search/screens/map_screen.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init.initMapkit(apiKey: '0b369467-ba08-4222-b583-81c369398640');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AddAdress(),
    );
  }
}

class AddAdress extends StatefulWidget {
  const AddAdress({super.key});

  @override
  State<AddAdress> createState() => _AddAdressState();
}

class _AddAdressState extends State<AddAdress> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];
  late SearchManager searchManager;
  SearchSession? searchSession;
  late SearchSessionSearchListener listener;

  @override
  void initState() {
    super.initState();
    log('Инициализация состояния');
    searchManager =
        SearchFactory.instance.createSearchManager(SearchManagerType.Combined);
    _searchController.addListener(_onSearchChanged);

    listener = SearchSessionSearchListener(
      onSearchResponse: _handleSearchResponse,
      onSearchError: _handleSearchError,
    );
    log('Инициализация завершена');
  }

  void _handleSearchResponse(SearchResponse response) {
    log('Получен ответ поиска');
    final List<String> newSuggestions = response.collection.children
        .map((item) => item.toString())
        .where((name) => name != null)
        .toList();
    log('Новые предложения: $newSuggestions');

    setState(() {
      _suggestions = newSuggestions;
    });
  }

  void _handleSearchError(error) {
    print('Произошла ошибка при поиске: $error');
  }

  void _onSearchChanged() {
    log('Текст поиска изменен: ${_searchController.text}');
    if (_searchController.text.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }
    _performSearch(_searchController.text);
  }

  final boundingBox = const BoundingBox(
      Point(latitude: 41.185, longitude: 19.638),
      Point(latitude: 81.858, longitude: 180.0));
  void _performSearch(String query) {
    log('Выполнение поиска для запроса: $query');

    try {
      if (searchManager == null) {
        log('SearchManager не инициализирован');
        return;
      }

      final geometry = const Geometry.fromCircle(
          Circle(Point(latitude: 41.185, longitude: 19.638), radius: 100));

      final searchOptions = SearchOptions(searchTypes: SearchType.None);
      log('дошли');
      // searchSession?.cancel();
      try {
        searchSession = searchManager.submit(
          geometry,
          searchOptions,
          listener,
          text: query,
        );
      } catch (e) {
        log('Произошла ошибка при поиске: $e');
      }
      if (searchSession != null) {
        log('Поисковая сессия создана успешно');
      } else {
        log('Не удалось создать поисковую сессию');
      }
    } catch (e, stackTrace) {
      log('Ошибка при выполнении поиска: $e');
      log('Stack trace: $stackTrace');
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    searchSession?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            _performSearch(value);
          },
          controller: _searchController,
          autofocus: true,
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              },
              child: Text('go to Map page')),
          Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      print('Выбран адрес: ${_suggestions[index]}');
                    },
                  );
                },
              )),
        ],
      ),
    );
  }
}

//ios console output
// tqwimKl9EHiaa+yGIU2I <warn>: Empty operatorInfo!
// [log] Инициализация состояния
// [log] Инициализация завершена
// [log] Текст поиска изменен:
// [log] Текст поиска изменен: р
// [log] Выполнение поиска для запроса: р
// [log] дошли
// Lost connection to device.

// Exited.