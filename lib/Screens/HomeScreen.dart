import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'GenreDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<dynamic>> contentByGenre = {};
  bool isLoading = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchContent();
  }

  // Fetch both movies and shows from the API and group by genre
  fetchContent() async {
    setState(() {
      isLoading = true;
    });

    List<String> searchTerms = ['all', 'action', 'drama', 'comedy', 'horror', 'thriller'];
    List<dynamic> allContent = [];

    for (String term in searchTerms) {
      final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$term'));
      if (response.statusCode == 200) {
        List newContent = json.decode(response.body);
        allContent.addAll(newContent);
      } else {
        print('Failed to load content: ${response.statusCode}');
      }
    }

    // Group content (movies and shows) by genre
    for (var item in allContent) {
      String genre = item['show']['genres'].isNotEmpty ? item['show']['genres'][0] : 'Unknown';
      if (!contentByGenre.containsKey(genre)) {
        contentByGenre[genre] = [];
      }
      contentByGenre[genre]!.add(item);
    }

    setState(() {
      isLoading = false;
    });
  }

  void navigateToGenreDetails(String genre) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GenreDetailsScreen(genre: genre, movies: contentByGenre[genre] ?? []),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.of(context).pushNamed('/search');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Welcome', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed('/search');
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red)))
          : ListView(
        children: contentByGenre.entries.map((entry) {
          String genre = entry.key;
          List<dynamic> content = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      genre,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () => navigateToGenreDetails(genre),
                      child: Text(
                        'See All',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: content.length > 7 ? 7 : content.length,
                  itemBuilder: (context, index) {
                    final item = content[index]['show'];
                    String imageUrl = item['image']?['medium'] ?? 'https://via.placeholder.com/150';

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/details', arguments: item);
                      },
                      child: Container(
                        width: 130,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: 130,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 150,
                                      width: 130,
                                      color: Colors.grey,
                                      child: Center(child: Text('Image not available')),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              item['name'] ?? 'No title available',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
