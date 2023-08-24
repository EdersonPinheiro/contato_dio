class Contato {
  String? localId;
  String img;
  String nome;
  String? sobrenome;
  String numero;
  String? status;

  Contato(
      {this.localId,
      required this.img,
      required this.nome,
      this.sobrenome,
      required this.numero,
      this.status});

  factory Contato.fromJson(Map<String, dynamic> json) {
    return Contato(
        localId: json['localId'],
        img: json['img'],
        nome: json['nome'],
        sobrenome: json['sobrenome'],
        numero: json['numero'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'localId': localId,
        'image': img,
        'nome': nome,
        'sobrenome': sobrenome,
        'numero': numero,
        'status': status
      };
}
