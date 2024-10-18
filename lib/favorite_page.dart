import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';
import 'book_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, String>> _favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load the list of favorite books from SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorite_books');
    if (favorites != null) {
      setState(() {
        _favoriteBooks = favorites
            .map((book) => Map<String, String>.from({
                  'titleKey': book.split('|')[0],
                  'authorKey': book.split('|')[1],
                }))
            .toList();
      });
    }
  }

  // Remove book from favorites
  void _removeFavorite(String titleKey, String authorKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorite_books');
    if (favorites != null) {
      favorites.removeWhere((book) => book == '$titleKey|$authorKey');
      await prefs.setStringList('favorite_books', favorites);
      setState(() {
        _favoriteBooks.removeWhere(
            (book) => book['titleKey'] == titleKey && book['authorKey'] == authorKey);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translateKey('favorites')),
      ),
      body: _favoriteBooks.isEmpty
          ? Center(child: Text(AppLocalizations.of(context).translateKey('no_favorites')))
          : ListView.builder(
              itemCount: _favoriteBooks.length,
              itemBuilder: (context, index) {
                String titleKey = _favoriteBooks[index]['titleKey']!;
                String authorKey = _favoriteBooks[index]['authorKey']!;
                return ListTile(
                  title: Text(AppLocalizations.of(context).translateKey(titleKey)),
                  subtitle: Text(AppLocalizations.of(context).translateKey(authorKey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _removeFavorite(titleKey, authorKey);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(
                          titleKey: titleKey,
                          authorKey: authorKey,
                          description: AppLocalizations.of(context).translateKey('${titleKey}_overview'),
                          pages: '320', 
                          genre: 'Fantasy',
                          price: 19.99,
                          publicationDate: DateTime.parse('2023-01-01'),
                          rating: 4.9,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
