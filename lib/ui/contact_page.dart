import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  @override
  _ContactPageState createState() => _ContactPageState();

  ContactPage({this.contact});
}

class _ContactPageState extends State<ContactPage> {

  final _nomeController  =TextEditingController();
  final _emailController  =TextEditingController();
  final _phoneController  =TextEditingController();
  final _nameFocus = FocusNode();

  Contact _editedContact;
  bool _userEdited = false;



  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nomeController.text = _editedContact.nome;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red,
            centerTitle: true,
            title: Text(_editedContact.nome ?? "Novo contato")),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
            onPressed: () {

              if(_editedContact.nome !=null && _editedContact.nome.isNotEmpty){
                Navigator.pop(context, _editedContact);
              }else{
                FocusScope.of(context).requestFocus(_nameFocus);
              }

            }),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file==null) return;
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/person"),
                      )),
                ),
              ),
              Divider(height: 20.0, color: Colors.transparent,),

              TextField(
                focusNode: _nameFocus,
                controller: _nomeController,
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.nome = text;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Nome",
                    border: OutlineInputBorder()
                ),
              ),

              Divider( color: Colors.transparent,),

              TextField(
                controller: _emailController,
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.email = text;
                },
                decoration: InputDecoration(
                    labelText: "E-mail",
                    border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              Divider( color: Colors.transparent,),

              TextField(
                controller: _phoneController,

                onChanged: (text){
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                decoration: InputDecoration(
                    labelText: "Telefone",
                    border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if(_userEdited){
      showDialog(context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Descartar alterações?"),
          content: Text("Se sair as alterações serão perdidas."),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Sim"),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }
}
