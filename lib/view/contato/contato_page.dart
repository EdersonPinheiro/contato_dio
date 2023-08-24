//import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../db/db.dart';
import '../../model/contato.dart';
import 'create_contato_page.dart';
import 'edit_contato_page.dart';

class ContatoPage extends StatefulWidget {
  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  final db = DB();
  late final Uint8List imageBytes;
  bool isLoading = false;
  final contatos = <Contato>[].obs;

  @override
  void initState() {
    super.initState();
    getProductsDB();
  }

  Future<void> getProductsDB() async {
    contatos.value = await db.getContatosDB();
    for (var element in contatos) {
      element.nome;
    }
    print(contatos.value);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (BuildContext context, int index) {
          Contato contato = contatos[index];
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  width: 60,
                  height: 60,
                  child: contato.img != null
                      ? Image.file(
                          File(contato.img.toString()),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey,
                        ),
                ),
                title: Text(contato.nome),
                subtitle: Text(contato.sobrenome ?? ""),
                onTap: () async {
                  print(contato.toJson());
                },
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    Get.to(EditContatoPage(
                      contato: contato,
                      reload: getProductsDB,
                    ));
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            CreateContatoPage(reload: getProductsDB),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
