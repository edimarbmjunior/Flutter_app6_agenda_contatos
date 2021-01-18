import 'dart:io';

import 'package:app6agendacontatos/helpers/contact_helper.dart';
import 'package:app6agendacontatos/util/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {ORDER_AZ, ORDER_ZA}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helperContact = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    /*Contact c = Contact();
    c.nome      = "Edimar";
    c.email     = "edimar@gmail.com";
    c.telefone  = "5464514654654";
    c.img       = null;
    helperContact.saveContact(c);
    Future<List> listContatoFuture = helperContact.getAllContacts();
    listContatoFuture.then((listaResultado) {
      for (Contact c in listaResultado){
        print(c);
      }
    });
    print("Fim");*/

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(// Botão para ordenar a listagem
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de A-Z"),
                value: OrderOptions.ORDER_AZ,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de Z-A"),
                value: OrderOptions.ORDER_ZA,
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      // Habilita a ação de clicar no objeto
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                // Para Poder colocar uma imagem redonda
                width: 80.0,
                height: 80.0,
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
                    image: contacts[index].img != null ?
                    FileImage(File(contacts[index].img))
                        : AssetImage("img/male-shadow-circle-512.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].nome ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? "",
                        style: TextStyle(fontSize: 18.0)),
                    Text(
                      contacts[index].telefone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        // _showContactPage(contact: contacts[index]);
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    // Mostrar opções que pode realizar ao clicar em algo
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          launch("tel:${contacts[index].telefone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(
                              context); // Sempre retira a ultima tela colocada na pilha de telas
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          helperContact.deleteContact(contacts[index].id);
                          contacts.removeAt(index);
                          Navigator.pop(
                              context); // Sempre retira a ultima tela colocada na pilha de telas
                          _getAllContacts();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContactPage(
                contact: contact,
              )),
    );
    if (null != recContact) {
      if (contact != null) {
        await helperContact.updateContact(recContact);
      } else {
        await helperContact.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helperContact.getAllContacts().then((resultado) {
      setState(() {
        contacts = resultado;
      });
    });
  }

  void _orderList(OrderOptions resuult){
    switch(resuult){
      case OrderOptions.ORDER_AZ:
        contacts.sort((a,b)=> a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
        break;
      case OrderOptions.ORDER_ZA:
        contacts.sort((a,b)=> b.nome.toLowerCase().compareTo(a.nome.toLowerCase()));
        break;
    }
    setState(() {

    });
  }
}
