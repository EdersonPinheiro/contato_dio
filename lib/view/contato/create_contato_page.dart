// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/product/contato_controller.dart';
import '../../db/db.dart';
import '../../model/contato.dart';
import 'package:uuid/uuid.dart';

class CreateContatoPage extends StatefulWidget {
  final Function reload;
  const CreateContatoPage({super.key, required this.reload});
  @override
  _CreateContatoPageState createState() => _CreateContatoPageState();
}

class _CreateContatoPageState extends State<CreateContatoPage> {
  final _formKey = GlobalKey<FormState>();
  ContatoController controller = new ContatoController();
  final db = DB();

  @override
  void initState() {
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File file = File(image.path);
      imageFile = image;
      setState(() {
        controller.imgController.text = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Contato"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30),
                    controller.imgController.text.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: Image.file(
                                  File(
                                      controller.imgController.text.toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment(0.5, 0.5),
                                child: IconButton(
                                  iconSize: 45,
                                  icon: Icon(Icons.image_outlined),
                                  onPressed: pickImage,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey,
                              ),
                              Align(
                                alignment: Alignment(0.5, 0.5),
                                child: IconButton(
                                  iconSize: 45,
                                  icon: Icon(Icons.image_outlined),
                                  onPressed: pickImage,
                                ),
                              ),
                            ],
                          ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: controller.nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Insira o nome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: controller.sobrenomeController,
                      decoration: const InputDecoration(
                        labelText: 'Sobrenome',
                      ),
                    ),
                    TextFormField(
                      controller: controller.numeroController,
                      decoration: const InputDecoration(
                        labelText: 'Número Celular',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Insira a quantidade';
                        } else if (int.tryParse(value) == null) {
                          return "A quantidade deve conter apenas números";
                        } else if (int.parse(value) <= 0) {
                          return "A quantidade deve ser maior que zero";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            const uuid = Uuid();
                            final newContato = Contato(
                                localId: uuid.v4(),
                                img: controller.imgController.text,
                                nome: controller.nomeController.text,
                                sobrenome: controller.sobrenomeController.text,
                                numero: controller.numeroController.text,
                                status: "new");
                            await db.addContato(newContato);
                            Get.back();
                            widget.reload();
                          }
                        },
                        child: Text('Criar')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
