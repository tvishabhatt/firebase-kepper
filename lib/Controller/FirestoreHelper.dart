import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  Future<void> addBooks({required String bookname, required String authorname}) async {
    await firebaseFirestore.collection("Books").add({
      "Bookname": bookname,
      "Author'sname": authorname,
    });
  }


  Future<void> addUsers({required String email}) async {
    await firebaseFirestore.collection("Users").add({
      "Email": email,
    });
  }


  Future<void> addBookMarks({
    required String bookname,
    required String authorname,
    required String bookId,
  }) async {

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection("BookMarks")
        .where("bookId", isEqualTo: bookId)
        .get();


    if (querySnapshot.docs.isEmpty) {
      await firebaseFirestore.collection("BookMarks").add({
        "Bookname": bookname,
        "Author'sname": authorname,
        "bookId": bookId,
      });
    } else {
      print("BookMark already exists");
    }
  }


  Future<bool> checkUserExists(String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection("Users")
        .where("Email", isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllBooks() {
    return firebaseFirestore.collection("Books").snapshots();
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllBookMarks() {
    return firebaseFirestore.collection("BookMarks").snapshots();
  }


  Future<void> updateBook({
    required String bookname,
    required String authorname,
    required String docId,
  }) async {

    await firebaseFirestore.collection("Books").doc(docId).update({
      "Bookname": bookname,
      "Author'sname": authorname,
    });

    QuerySnapshot<Map<String, dynamic>> bookmarks = await firebaseFirestore
        .collection("BookMarks")
        .where('bookId', isEqualTo: docId)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> bookmark in bookmarks.docs) {
      await firebaseFirestore.collection("BookMarks").doc(bookmark.id).update({
        "Bookname": bookname,
        "Author'sname": authorname,
      });
    }
  }

  Future<void> deleteBook({required String docId}) async {
    await firebaseFirestore.collection("Books").doc(docId).delete();


    QuerySnapshot<Map<String, dynamic>> bookmarks = await firebaseFirestore
        .collection("BookMarks")
        .where('bookId', isEqualTo: docId)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> bookmark in bookmarks.docs) {
      await firebaseFirestore.collection("BookMarks").doc(bookmark.id).delete();
    }
  }


  Future<void> deleteBookMarks({required String bookname, required String authorname}) async {
    QuerySnapshot<Map<String, dynamic>> bookmarks = await firebaseFirestore
        .collection('BookMarks')
        .where('Bookname', isEqualTo: bookname)
        .where("Author'sname", isEqualTo: authorname)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> bookmark in bookmarks.docs) {
      await firebaseFirestore.collection('BookMarks').doc(bookmark.id).delete();
    }
  }


  Future<void> deleteAllBooks() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore.collection("Books").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allBooks = querySnapshot.docs;

    for (QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot in allBooks) {
      String docId = queryDocumentSnapshot.id;
      await firebaseFirestore.collection("Books").doc(docId).delete();


      QuerySnapshot<Map<String, dynamic>> bookmarks = await firebaseFirestore
          .collection("BookMarks")
          .where('bookId', isEqualTo: docId)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> bookmark in bookmarks.docs) {
        await firebaseFirestore.collection("BookMarks").doc(bookmark.id).delete();
      }
    }
  }
}
