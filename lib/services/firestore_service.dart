import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference link =
      FirebaseFirestore.instance.collection('link');

  Stream<QuerySnapshot> getLinks() {
    return link.snapshots();
  }

  // get data from firebase return Categorized data
  Stream<Map<String, List<Map<String, dynamic>>>> getCategorizedLinks() {
    return link.snapshots().map((querySnapshot) {
      Map<String, List<Map<String, dynamic>>> categorizedLinks = {};

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        List categories = data['category'] as List;

        for (String category in categories) {
          if (!categorizedLinks.containsKey(category)) {
            categorizedLinks[category] = [];
          }
          categorizedLinks[category]!.add(data);
        }
      }

      return categorizedLinks;
    });
  }
}
