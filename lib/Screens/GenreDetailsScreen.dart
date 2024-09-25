import 'package:flutter/material.dart';

class GenreDetailsScreen extends StatelessWidget {
  final String genre;
  final List<dynamic> movies;

  GenreDetailsScreen({required this.genre, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(genre, style: TextStyle(color: Colors.white)),
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
      body: movies.isEmpty
          ? Center(child: Text('No movies available', style: TextStyle(color: Colors.white))) // Message for no movies
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index]['show'];
          String imageUrl = movie['image']?['medium'] ?? 'https://via.placeholder.com/150';

          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/details', arguments: movie);
            },
            child: Container(
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54, // Dark overlay
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        movie['name'] ?? 'No title available',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
