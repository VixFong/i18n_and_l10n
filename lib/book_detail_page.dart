  import 'package:flutter/material.dart';
  import 'app_localizations.dart';
  import 'book_reader.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class BookDetailPage extends StatefulWidget {
    final String titleKey;
    final String authorKey;
    final String description;
    final String pages;
    final String genre;
    final double price; 
    final DateTime publicationDate; 
    final double rating;

    const BookDetailPage({
      super.key,
      required this.titleKey,
      required this.authorKey,
      required this.description,
      required this.pages,
      required this.genre,
      required this.price, 
      required this.publicationDate, 
      required this.rating, 
    });

    @override
    _BookDetailPageState createState() => _BookDetailPageState();
  }

  class _BookDetailPageState extends State<BookDetailPage> {
    bool _isFavorite = false;

    @override
    void initState() {
      super.initState();
      _checkIfFavorite();
    }

    // Check if the book is already in the favorite list
    Future<void> _checkIfFavorite() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? favorites = prefs.getStringList('favorite_books');
      if (favorites != null && favorites.contains('${widget.titleKey}|${widget.authorKey}')) {
        setState(() {
          _isFavorite = true;
        });
      }
    }

    // Add or remove the book from favorites
    void _toggleFavorite() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? favorites = prefs.getStringList('favorite_books') ?? [];
      setState(() {
        if (_isFavorite) {
          favorites.remove('${widget.titleKey}|${widget.authorKey}');
        } else {
          favorites.add('${widget.titleKey}|${widget.authorKey}');
        }
        prefs.setStringList('favorite_books', favorites);
        _isFavorite = !_isFavorite;
      });
    }

    // Add the _getBookContent method here
    List<String> _getBookContent(String titleKey, BuildContext context) {
      switch (titleKey) {
        case 'the_fellowship_of_the_ring':
          return [
            AppLocalizations.of(context).translateKey('fellowship_page_1'),
            AppLocalizations.of(context).translateKey('fellowship_page_2'),
            AppLocalizations.of(context).translateKey('fellowship_page_3'),
          ];
        case 'the_da_vinci_code':
          return [
            AppLocalizations.of(context).translateKey('da_vinci_code_page_1'),
            AppLocalizations.of(context).translateKey('da_vinci_code_page_2'),
            AppLocalizations.of(context).translateKey('da_vinci_code_page_3'),
          ];
        case 'pride_and_prejudice':
          return [
            AppLocalizations.of(context).translateKey('pride_and_prejudice_page_1'),
            AppLocalizations.of(context).translateKey('pride_and_prejudice_page_2'),
            AppLocalizations.of(context).translateKey('pride_and_prejudice_page_3'),
          ];
        default:
          return [AppLocalizations.of(context).translateKey('no_content')];
      }
    }

    @override
    Widget build(BuildContext context) {
      final localizations = AppLocalizations.of(context);  // Create an instance of AppLocalizations

        print('Genre passed: ${widget.genre}');
        print('Translated genre: ${localizations.translateKey(widget.genre.toLowerCase())}');

      return Scaffold(
        appBar: AppBar(
          title: Text(localizations.translateKey('book_detail')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1523543570i/34684622.jpg',
                  width: 150,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            localizations.translateKey(widget.titleKey),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 24),
                            const SizedBox(width: 4),
                            // Format rating using formatNumber
                            Text(localizations.formatNumber(widget.rating.toInt()), style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      localizations.translateKey(widget.authorKey),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Information Section (Pages, Author, Genre)
                    Row(
                      children: [
                        // Pages Info
                        Column(
                          children: [
                            const Icon(Icons.book, color: Colors.red),
                            const SizedBox(height: 5),
                            // Translate "pages" and display localized page count
                            Text(
                              '${widget.pages} ${localizations.translateKey('pages')}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(width: 40),
                        // Author Info
                        Column(
                          children: [
                            const Icon(Icons.person, color: Colors.orange),
                            const SizedBox(height: 5),
                            Text(
                              localizations.translateKey(widget.authorKey),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(width: 40),
                        // Genre Info
                        Column(
                          children: [
                            const Icon(Icons.category, color: Colors.blue),
                            const SizedBox(height: 5),
                            // Ensure widget.genre is correctly translated
                            Text(
                              '${localizations.translateKey('genre')}: ${localizations.translateKey(widget.genre.toLowerCase())}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Add formatted price, date, and rating
                   Text(
                      // Translate "Price" and format the price based on locale
                      '${localizations.translateKey('price')}: ${localizations.formatCurrency(widget.price)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      // Translate "Published on" and format the publication date
                      '${localizations.translateKey('published_on')}: ${localizations.formatDate(widget.publicationDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    // Book Overview
                    Text(
                      localizations.translateKey('overview'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 20),

                    // Buttons (Start Reading and Favorite)
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.blue, // Button color
                          ),
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            int lastReadPage = prefs.getInt('${widget.titleKey}_lastPage') ?? 0;
                            
                            // Retrieve localized story content based on the titleKey
                            List<String> bookPages = _getBookContent(widget.titleKey, context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookReaderPage(
                                  title: localizations.translateKey(widget.titleKey),
                                  bookContent: bookPages,
                                  initialPage: lastReadPage, // Start from the last read page
                                ),
                              ),
                            );
                          },
                          child: Text(
                            localizations.translateKey('start_reading'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                          onPressed: _toggleFavorite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
