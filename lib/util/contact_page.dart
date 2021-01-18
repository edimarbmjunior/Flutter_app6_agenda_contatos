import 'dart:io';

import 'package:app6agendacontatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited = false;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _nomeFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      // Forma de chamar o objeto que foi passado na instancia da classe acima, que é uma widget
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nomeController.text = _editedContact.nome;
      _emailController.text = _editedContact.email;
      _telefoneController.text = _editedContact.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact.nome ?? "Novo contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (null != _editedContact.nome &&
                  _editedContact.nome.isNotEmpty) {
                Navigator.pop(context, _editedContact);// Sempre retira a ultima tela colocada na pilha de telas e retorna um ainformação
              } else {
                FocusScope.of(context)
                    .requestFocus(_nomeFocus); //coloca no edito do nome
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  //Habilita a ação de clicar no objeto
                  child: Container(
                    // Para Poder colocar uma imagem redonda
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //Duas formas de colocar imagem
                      //1
                      /*image: DecorationImage(
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img))
                              : AssetImage("img/male-shadow-circle-512.png")),*/
                      // 2
                      image: DecorationImage(
                        image: _editedContact.img != null ?
                        FileImage(File(_editedContact.img))
                            : AssetImage("img/male-shadow-circle-512.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: (){//Função para usar a camera(Porem no IOS deve uma alteração no modo de permissão de usar a camera, este arquivo deverá receber alteração "ios/Runner/info.plist")
                    ImagePicker
                        .pickImage(source: ImageSource.camera)
                        .then((file){
                          if(null == file){
                            return;
                          }
                          setState(() {
                            _editedContact.img = file.path;
                          });
                    });
                  },
                ),
                TextField(
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  decoration: InputDecoration(
                    labelText: "Nome",
                  ),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                  ),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _telefoneController,
                  decoration: InputDecoration(
                    labelText: "Telefone",
                  ),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.telefone = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);// Sempre retira a ultima tela colocada na pilha de telas
                  },
                  child: Text("Cancelar")
              ),
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);// Sempre retira a ultima tela colocada na pilha de telas
                    Navigator.pop(context);// Sempre retira a ultima tela colocada na pilha de telas
                  },
                  child: Text("Sim")
              ),
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
