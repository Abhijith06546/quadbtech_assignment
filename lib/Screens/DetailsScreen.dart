import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the movie image
              if (movie['image'] != null)
                Image.network(movie['image']['original']),
              SizedBox(height: 16.0),

              // Display the rating
              if (movie['rating'] != null)
                Text(
                  'Rating: ${movie['rating']['average'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.yellow),
                ),
              SizedBox(height: 8.0),

              // Display the genre
              if (movie['genres'] != null && movie['genres'].isNotEmpty)
                Text(
                  'Genres: ${movie['genres'].join(', ')}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.yellow),
                ),
              SizedBox(height: 8.0),

              // Display the language
              if (movie['language'] != null)
                Text(
                  'Language: ${movie['language']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.yellow),
                ),
              SizedBox(height: 16.0),

              // Display the summary title
              Text(
                'Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // Bold white for summary title
              ),
              SizedBox(height: 8.0),

              // Display the summary without HTML tags
              if (movie['summary'] != null)
                Text(
                  _stripHtml(movie['summary']),
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.justify,
                ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  // Function to strip HTML tags from a string
  String _stripHtml(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(exp, '').replaceAll('&nbsp;', ' ').trim();
  }
}
