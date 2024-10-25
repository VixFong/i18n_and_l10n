import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';
import 'book_detail_page.dart';
import 'favorite_page.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = window.locale; // Initialize with system language

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    
    // Use saved language or system language if none saved
    setState(() {
      _locale = Locale(languageCode ?? window.locale.languageCode, '');
    });
  }

  void _changeLanguage(Locale locale) async {
    setState(() {
      _locale = locale;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Reading App',
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizationsDelegate(), // Add localization delegate
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
        Locale('zh', ''), // Chinese
        Locale('vi', ''), // Vietnamese
        Locale('ar', ''), // Arabic
      ],
      // Apply RTL or LTR based on the locale
      builder: (context, child) {
        return Directionality(
          textDirection: AppLocalizations.of(context).isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translateKey('title')),
      ),
      drawer: SideBar(changeLanguage: (Locale locale) {
        context.findAncestorStateOfType<_MyAppState>()?.setState(() {
          context.findAncestorStateOfType<_MyAppState>()?._changeLanguage(locale);
        });
      }),
      body: Center(
        child: Text(
          AppLocalizations.of(context).translateKey('welcome_message'),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translateKey('title')),
      ),
      drawer: SideBar(changeLanguage: (Locale locale) {
        context.findAncestorStateOfType<_MyAppState>()?.setState(() {
          context.findAncestorStateOfType<_MyAppState>()?._changeLanguage(locale);
        });
      }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).translateKey('popular_book'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              height: 250,
              child: Row(
                children: [
                  Image.network(
                    'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1654215925i/61215351.jpg',
                    width: 180,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The Fellowship of the Ring',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'J.R.R. Tolkien',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Text(AppLocalizations.of(context).translateKey('book_status', {
                          "finished": "20k",
                          "reading": "15k",
                          "saved": "10k",
                        })),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DefaultTabController(
                length: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      isScrollable: true,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: AppLocalizations.of(context).translateKey('adventure')),
                        Tab(text: AppLocalizations.of(context).translateKey('fantasy')),
                        Tab(text: AppLocalizations.of(context).translateKey('detective')),
                        Tab(text: AppLocalizations.of(context).translateKey('psychology')),
                        Tab(text: AppLocalizations.of(context).translateKey('business')),
                        Tab(text: AppLocalizations.of(context).translateKey('horror')),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          buildBooksTab(context),
                          buildBooksTab(context),
                          buildBooksTab(context),
                          buildBooksTab(context),
                          buildBooksTab(context),
                          buildBooksTab(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBooksTab(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          List<Map<String, dynamic>> books = [
            {
              "titleKey": "the_da_vinci_code",
              "authorKey": "dan_brown",
              "rating": 4.9,
              "overviewKey": "da_vinci_code_overview"
            },
            {
              "titleKey": "pride_and_prejudice",
              "authorKey": "jane_austen",
              "rating": 4.8,
              "overviewKey": "pride_and_prejudice_overview"
            },
            {
              "titleKey": "the_great_gatsby",
              "authorKey": "f_scott_fitzgerald",
              "rating": 4.7,
              "overviewKey": "great_gatsby_overview"
            },
            {
              "titleKey": "the_hobbit",
              "authorKey": "jrr_tolkien",
              "rating": 4.9,
              "overviewKey": "the_hobbit_overview"
            },
            {
              "titleKey": "moby_dick",
              "authorKey": "herman_melville",
              "rating": 4.6,
              "overviewKey": "moby_dick_overview"
            },
            {
              "titleKey": "war_and_peace",
              "authorKey": "leo_tolstoy",
              "rating": 4.8,
              "overviewKey": "war_and_peace_overview"
            }
          ];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: BookCard(
              titleKey: books[index]['titleKey'],
              authorKey: books[index]['authorKey'],
              overviewKey: books[index]['overviewKey'],  // Add overviewKey here
              rating: books[index]['rating'],
            ),
          );
        },
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  final Function(Locale) changeLanguage;

  const SideBar({super.key, required this.changeLanguage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'dailybook',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context).translateKey('home')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(AppLocalizations.of(context).translateKey('favorites')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context).translateKey('language')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    changeLanguage: changeLanguage,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const SettingsPage({super.key, required this.changeLanguage});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = 'English'; // default

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage(); // Load the saved language
  }

  // Load the saved selected language from SharedPreferences
  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    setState(() {
      switch (languageCode) {
        case 'es':
          selectedLanguage = 'Spanish';
          break;
        case 'ar':
          selectedLanguage = 'Arabic';
          break;
        case 'zh':
          selectedLanguage = 'Chinese';
          break;
        case 'vi':
          selectedLanguage = 'Vietnamese';
          break;
        default:
          selectedLanguage = 'English';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translateKey('settings')),
      ),
      body: Center(
        child: DropdownButton<String>(
          value: selectedLanguage,
          items: const [
            DropdownMenuItem(
              value: 'English',
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: 'Spanish',
              child: Text('Spanish'),
            ),
            DropdownMenuItem(
              value: 'Arabic',
              child: Text('Arabic'),
            ),
            DropdownMenuItem(
              value: 'Chinese',
              child: Text('Chinese'),
            ),
            DropdownMenuItem(
              value: 'Vietnamese',
              child: Text('Vietnamese'),
            ),
          ],
          onChanged: (String? value) {
            setState(() {
              selectedLanguage = value!;
              if (value == 'English') {
                widget.changeLanguage(const Locale('en', ''));
              } else if (value == 'Spanish') {
                widget.changeLanguage(const Locale('es', ''));
              } else if (value == 'Arabic') {
                widget.changeLanguage(const Locale('ar', ''));
              } else if (value == 'Chinese') {
                widget.changeLanguage(const Locale('zh', ''));
              } else if (value == 'Vietnamese') {
                widget.changeLanguage(const Locale('vi', ''));
              }
            });
          },
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final String titleKey;
  final String authorKey;
  final String overviewKey;
  final double rating;

  const BookCard({
    super.key,
    required this.titleKey,
    required this.authorKey,
    required this.overviewKey,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the BookDetailPage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              print('Overview Key: $overviewKey');
              print('Description: ${AppLocalizations.of(context).translateKey(overviewKey)}');

              return BookDetailPage(
                titleKey: titleKey,
                authorKey: authorKey,
                description: AppLocalizations.of(context).translateKey(overviewKey),
                pages: '320',
                genre: 'Fantasy',
                price: 19.99,
                publicationDate: DateTime.parse('2023-01-01'),
                rating: 4.9,
              );
            },
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1720313229i/968.jpg',
                width: 120,
                height: 150,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context).translateKey(titleKey),
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context).translateKey(authorKey),
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('$rating', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
