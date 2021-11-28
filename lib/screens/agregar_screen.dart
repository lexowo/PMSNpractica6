import 'dart:io';

import 'package:firebase/models/product_dao.dart';
import 'package:firebase/providers/firebase_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';

class Agregar extends StatefulWidget {
  Agregar({Key? key}) : super(key: key);

  @override
  _AgregarState createState() => _AgregarState();
}

class _AgregarState extends State<Agregar> {

  late FirebaseProvider  _firebaseProvider;

  TextEditingController _controllernomprod = TextEditingController();
  TextEditingController _controllerdescprod = TextEditingController();

  File? imagen;
  UploadTask? tarea;
  String? zelda;

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
        title: Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SizedBox(height: 10,),
            Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                imagen != null ? Image.file(imagen!, width: 160, height: 160, fit: BoxFit.cover,) : FlutterLogo(size: 160,),
                SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60,),
                    ElevatedButton(onPressed: ()=>jalarImagen(), child: Icon(Icons.photo, color: Colors.red,)),
                  ],
                ),
              ]
            ),
            SizedBox(height: 10,),
            _crearTextFieldnomprod(),
            SizedBox(height: 10,),
            _crearTextFielddescprod(),
            ElevatedButton(
              onPressed: (){
                if(_controllerdescprod.text=='' || _controllernomprod.text=='' || imagen==null){
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(
                        'Porfavor llene la imagen y los campos con datos validos para completar la operacion.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ok',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        )
                      ],
                    )
                  );
                }else{
                  subirImagen().then((value) {
                    _firebaseProvider.saveProduct(
                      ProductDAO(
                        nomprod: _controllernomprod.text,
                        descprod: _controllerdescprod.text,
                        imgprod: zelda
                      )
                    ).then((value) => Navigator.pop(context));
                  });
                }
              },
              child: Text('Guardar Producto')
            )
          ],
        ),
      ),
    );
  }

  Future jalarImagen() async{
    try{
      final imagen = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagen == null) return;

      final imagenTemp = File(imagen.path);
      setState(()=>this.imagen= imagenTemp);
    } on PlatformException catch (e){
      print('Fallo escoger imagen: $e');
    }
  }

  Future subirImagen() async{
    if (imagen==null) return;

    final nombreArchivo = Path.basename(imagen!.path);
    final destino = 'files/$nombreArchivo';

    tarea = FirebaseProvider.saveFile(destino,imagen!);

    if (tarea == null) return;

    final snapshot = await tarea!.whenComplete((){});
    zelda = await snapshot.ref.getDownloadURL();
  }

  Widget _crearTextFieldnomprod(){
    return TextField(
      controller: _controllernomprod,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Nombre del Producto",
        //errorText: "Este campo es obligatorio"
      ),
      onChanged: (value){

      },
    );
  }

  
  Widget _crearTextFielddescprod(){
    return TextField(
      controller: _controllerdescprod,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: "Descripcion del Producto",
        //errorText: "Este campo es obligatorio",
      ),
      onChanged: (value){

      },
    );
  }
}