import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch random movies/shows when the screen loads
    fetchRandomShows();
  }

  // Fetch random shows from the API
  fetchRandomShows() async {
    List randomShows = [];
    for (int i = 0; i < 10; i++) {
      final response = await http.get(Uri.parse('https://api.tvmaze.com/shows/${i + 1}'));
      if (response.statusCode == 200) {
        randomShows.add(json.decode(response.body));
      }
    }
    setState(() {
      searchResults = randomShows;
    });
  }

  // Search movies/shows by query
  searchMovies(String query) async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(hintText: 'Search movies...'),
          onSubmitted: (value) {
            searchMovies(value);
          },
        ),
      ),
      body: searchResults.isEmpty
          ? Center(child: Text('No results found'))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in grid
            crossAxisSpacing: 8.0, // Horizontal space between items
            mainAxisSpacing: 8.0, // Vertical space between items
            childAspectRatio: 0.7, // Adjust the aspect ratio of the grid items
          ),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            // Handle different response formats for search and random fetch
            final movie = searchResults[index]['show'] ?? searchResults[index];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/details', arguments: movie);
              },
              child: GridTile(
                child: Column(
                  children: [
                    Expanded(
                      child: movie['image']?['medium'] != null
                          ? Image.network(movie['image']['medium'], fit: BoxFit.cover)
                          : Container(color: Colors.grey), // Placeholder if no image
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      movie['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
