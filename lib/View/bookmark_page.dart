import 'package:firebase_kepper/Controller/ThemeController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_kepper/Controller/FirestoreHelper.dart';

class bookmark_page extends StatefulWidget {
  const bookmark_page({Key? key}) : super(key: key);

  @override
  State<bookmark_page> createState() => _bookmark_pageState();
}

class _bookmark_pageState extends State<bookmark_page> {
  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirestoreHelper.firestoreHelper.fetchAllBookMarks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No bookmarks available"));
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> allBookmarks = snapshot.data!.docs;

              return ListView.builder(
                itemCount: allBookmarks.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(allBookmarks[i].data()['Bookname']),
                    subtitle: Text(allBookmarks[i].data()["Author'sname"]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
