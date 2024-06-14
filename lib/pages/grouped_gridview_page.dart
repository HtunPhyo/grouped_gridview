import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import 'webview_page.dart';

class GroupedGridviewPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  GroupedGridviewPage({super.key});

  // Function to navigate to webview page
  void _navigateToWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebviewPage(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Grouped Grid View"),
      ),
      body: StreamBuilder<Map<String, List<Map<String, dynamic>>>>(
        stream: firestoreService.getCategorizedLinks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final categorizedLinks = snapshot.data!;
            return ListView(
              children: categorizedLinks.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        entry.key, // Category name
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            3, // Adjust the number of columns as needed
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: entry.value.length,
                      itemBuilder: (context, index) {
                        var doc = entry.value[index];
                        return GestureDetector(
                          onTap: () {
                            _navigateToWebView(context, doc['url']);
                          },
                          child: Card(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    doc['img'], // Replace with your image URL
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(doc['name'],
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
