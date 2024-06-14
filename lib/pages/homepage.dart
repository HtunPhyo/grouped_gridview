import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import 'webview_page.dart';

// this hompage is currently no used
// current hompage is groupded_gridview_page

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getLinks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List linklist = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: linklist.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _navigateToWebView(context, linklist[index]['url']);
                  },
                  child: Card(
                    child: Stack(
                      children: [
                        // Background image
                        Positioned.fill(
                          child: Image.network(
                            linklist[index]
                                ['img'], // Replace with your image URL
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          children: [
                            Text(linklist[index]['name']),
                            Text(linklist[index]['url']),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text('Something went wrong');
          }
        },
      ),
    );
  }
}
