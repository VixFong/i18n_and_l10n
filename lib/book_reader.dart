import 'package:flutter/material.dart';

class BookReaderPage extends StatefulWidget {
  final String title;
  final List<String> bookContent;
  final int initialPage; // Add initialPage parameter

  const BookReaderPage({
    Key? key,
    required this.title,
    required this.bookContent,
    this.initialPage = 0, // Default to page 0 if not provided
  }) : super(key: key);

  @override
  _BookReaderPageState createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  late PageController _pageController;
  int _currentLeftPage = 1; // Variable to track the left page number
  bool _showLeftArrow = false;
  bool _showRightArrow = false;

  @override
  void initState() {
    super.initState();
    // Initialize the page controller with the initialPage
    _pageController = PageController(initialPage: widget.initialPage ~/ 2); // Divide by 2 to account for 2-page view
    _currentLeftPage = widget.initialPage + 1; // Set the initial left page number
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Display book title
      ),
      body: MouseRegion(
        onHover: (event) {
          // Detect if mouse is near the left or right edge of the screen
          setState(() {
            _showLeftArrow = event.position.dx < 100; // Show left arrow if near left edge
            _showRightArrow = event.position.dx > MediaQuery.of(context).size.width - 100; // Show right arrow if near right edge
          });
        },
        onExit: (_) {
          setState(() {
            _showLeftArrow = false;
            _showRightArrow = false;
          });
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: (widget.bookContent.length / 2).ceil(), // Two pages at a time (left and right)
              onPageChanged: (index) {
                // Update the left page number based on the index
                setState(() {
                  _currentLeftPage = index * 2 + 1;
                });
              },
              itemBuilder: (context, index) {
                final leftPageIndex = index * 2;
                final rightPageIndex = leftPageIndex + 1;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Left page content (odd pages: 1, 3, 5, ...)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.bookContent[leftPageIndex],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      // Divider as book spine
                      Container(
                        width: 2,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      // Right page content (even pages: 2, 4, 6, ...)
                      Expanded(
                        child: SingleChildScrollView(
                          child: rightPageIndex < widget.bookContent.length
                              ? Text(
                                  widget.bookContent[rightPageIndex],
                                  style: const TextStyle(fontSize: 18),
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Display page numbers
            Positioned(
              left: 16,
              bottom: 16,
              child: Text(
                'Page $_currentLeftPage', // Left page number
                style: const TextStyle(fontSize: 16, color: Colors.orange),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Text(
                _currentLeftPage + 1 <= widget.bookContent.length ? 'Page ${_currentLeftPage + 1}' : '',
                style: const TextStyle(fontSize: 16, color: Colors.orange),
              ),
            ),
            // Left arrow
            if (_showLeftArrow && _currentLeftPage > 1)
              Positioned(
                left: 10,
                top: MediaQuery.of(context).size.height / 2 - 30,
                child: GestureDetector(
                  onTap: () {
                    // Go to the previous page set
                    if (_pageController.page! > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 50,
                    color: Colors.black54,
                  ),
                ),
              ),
            // Right arrow
            if (_showRightArrow && _currentLeftPage + 1 < widget.bookContent.length)
              Positioned(
                right: 10,
                top: MediaQuery.of(context).size.height / 2 - 30,
                child: GestureDetector(
                  onTap: () {
                    // Go to the next page set
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 50,
                    color: Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }
}
