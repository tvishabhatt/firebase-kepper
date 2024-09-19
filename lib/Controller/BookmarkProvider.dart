import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'FirestoreHelper.dart';

class BookmarkProvider with ChangeNotifier {
  Map<String, bool> _isBookmarked = {};

  bool isBookmarked(String docId) => _isBookmarked[docId] ?? false;

  Future<void> toggleBookmark(String docId, String bookname, String authorname) async {
    _isBookmarked[docId] = !isBookmarked(docId);

    if (_isBookmarked[docId] == true) {

      await FirestoreHelper.firestoreHelper.addBookMarks(
        bookname: bookname,
        authorname: authorname,
        bookId: docId,
      );
    } else {

      await FirestoreHelper.firestoreHelper.deleteBookMarks(
        authorname: authorname,
        bookname: bookname,
      );
    }

    notifyListeners();
  }

  void initializeBookmarks(List<QueryDocumentSnapshot<Map<String, dynamic>>> bookmarks) {
    for (var bookmark in bookmarks) {
      _isBookmarked[bookmark.id] = true;
    }
    notifyListeners();
  }
}
