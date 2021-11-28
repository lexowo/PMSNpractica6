import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/product_dao.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:firebase/views/card_product.dart';
import 'package:flutter/material.dart';

class ListProducts extends StatefulWidget {
  ListProducts({Key? key}) : super(key: key);

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {

  late FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Productos'),
        actions: [
          IconButton(
            color: Colors.green,
            onPressed: (){
              Navigator.pushNamed(context, '/agregar');
            }, 
            icon: Icon(Icons.add_circle)
          )
        ],
      ),
      body: StreamBuilder(
        stream: _firebaseProvider.getAllProducts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document){
              return CardProduct(productDocument: document);
            }).toList(),
          );
        }
      ),
    );
  }
}