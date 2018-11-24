import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToBuyList extends StatefulWidget {
  @override
  _ToBuyListState createState() => _ToBuyListState();
}

class _ToBuyListState extends State<ToBuyList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Buy List"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Firestore.instance
                  .runTransaction((Transaction transaction) async {
                CollectionReference reference =
                    Firestore.instance.collection('tobuy_data');
                await reference.add({"title": "", "editing": true});
              });
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('tobuy_data').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return FirestoreListView(documents: snapshot.data.documents);
        },
      ),
    );
  }
}

class FirestoreListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;
  FirestoreListView({this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemExtent: 80.0,
      itemBuilder: (BuildContext context, int index) {
        String title = documents[index].data['title'].toString();
        return ListTile(
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Colors.amber),
            ),
            padding: EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: // Text(title),
                      !documents[index].data['editing']
                          ? Text(title)
                          : TextFormField(
                              initialValue: title,
                              onFieldSubmitted: (String item) {
                                Firestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot snapshot = await transaction
                                      .get(documents[index].reference);
                                  await transaction.update(
                                      snapshot.reference, {'title': item});

                                  await transaction.update(snapshot.reference,
                                      {"editing": !snapshot['editing']});
                                });
                              },
                            ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Firestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot snapshot =
                          await transaction.get(documents[index].reference);
                      await transaction.delete(snapshot.reference);
                    });
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
