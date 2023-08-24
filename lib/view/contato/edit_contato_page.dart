import 'dart:io';

import 'package:contato_dio/controllers/product/contato_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../db/db.dart';
import '../../model/contato.dart';

class EditContatoPage extends StatefulWidget {
  final Contato contato;
  final Function reload;
  const EditContatoPage(
      {super.key, required this.contato, required this.reload});

  @override
  State<EditContatoPage> createState() => _EditContatoState();
}

class _EditContatoState extends State<EditContatoPage> {
  final db = DB();
  ContatoController controller = ContatoController();

  @override
  void initState() {
    super.initState();
    controller.imgController.text = widget.contato.img;
    controller.nomeController.text = widget.contato.nome;
    controller.sobrenomeController.text = widget.contato.sobrenome ?? '';
    controller.numeroController.text = widget.contato.numero;
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
        title: Text(widget.contato.nome),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
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
                                  File(controller.imgController.text),
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
                    TextFormField(
                      controller: controller.nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira o nome do produto';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controller.sobrenomeController,
                      decoration: const InputDecoration(labelText: 'Sobrenome'),
                      maxLines: 3,
                    ),
                    TextFormField(
                      controller: controller.numeroController,
                      decoration: const InputDecoration(labelText: 'Número'),
                      maxLines: 9,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final newContato = Contato(
                                  img: controller.imgController.text,
                                  nome: controller.nomeController.text,
                                  sobrenome:
                                      controller.sobrenomeController.text,
                                  numero: controller.nomeController.text,
                                  status: 'delete');

                              await db.deleteContatoDB(newContato);
                              Get.back();
                              widget.reload();
                            },
                            child: const Text('Excluir'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.red;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final newContato = Contato(
                                localId: widget.contato.localId,
                                img: controller.imgController.text,
                                nome: controller.nomeController.text,
                                sobrenome: controller.sobrenomeController.text,
                                numero: controller.numeroController.text,
                                status: "edit",
                              );
                              await db.updateContato(newContato);
                              Get.back();
                              widget.reload();
                              return;
                            },
                            child: const Text('Salvar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tem certeza que deseja excluir este produto ?'),
          content: Text(
              'Excluindo o produto você também exclui todo o histórico de movimentações relacionado'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await db.deleteContatoDB(widget.contato);
              },
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.red;
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
