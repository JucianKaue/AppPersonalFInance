import 'package:flutter/material.dart';

String _dropdownValue = 'Receita';

void main() => {
      runApp(MaterialApp(
        home: Scaffold(
          body: ListaTransferencia() 
          ) 
          )
      )
    };

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controllerTextNome = TextEditingController();
  final TextEditingController _controllerTextValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Controle de Finanças"), backgroundColor: Colors.blueGrey),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Editor(_controllerTextNome, 'Nome', 'Jobesclaudio', Icons.person_add, TextInputType.text),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Editor(_controllerTextValor, 'Valor', '69.00', Icons.monetization_on, TextInputType.number),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropDownField(),
            ),

            ElevatedButton(
              onPressed: () {
                final String? titularConta = _controllerTextNome.text;
                final double? valor = double.tryParse(_controllerTextValor.text);

                debugPrint(titularConta);
                debugPrint(valor.toString());
                if (titularConta != null && valor != null) {
                  final transferenciaCriada =
                      Transferencia(valor, titularConta, _dropdownValue);
                  debugPrint("Transferencia Criada");
                  Navigator.pop(context, transferenciaCriada);
                }
              },
              child: const Text('enviar'),
            )
          ],
        ));
  }

  void _criaTransferencia() {
    final String TitularConta = _controllerTextNome.text;
    final double? valor = double.tryParse(_controllerTextValor.text);
    if (TitularConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, TitularConta, _dropdownValue);
      print(TitularConta);
      print(valor);
    }
  }
}

class DropDownField extends StatefulWidget {
  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButton(
        items: [
          DropdownMenuItem(child: Row(children: [Icon(Icons.paid, color: Colors.green), Text('Receita')]), value: 'Receita'),
          DropdownMenuItem(child: Row(children: [Icon(Icons.paid, color: Colors.red), Text('Despesa')]), value: 'Despesa')
        ],
        value: _dropdownValue,
        onChanged: dropdownCallback,
      )
      
    );
  }
}

class Editor extends StatelessWidget {
  final TextEditingController _controlador;
  final String _rotulo;
  final String _dica;
  final IconData? _icone;
  final TextInputType _keyboardtype;
  Editor(this._controlador, this._rotulo, this._dica, this._icone, this._keyboardtype);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controlador,
        style: TextStyle(
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          labelText: _rotulo,
          hintText: _dica,
        ),
        keyboardType: this._keyboardtype,
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia; 
  const ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    late Widget _icon;
    late String _text;

    if (_transferencia.tipo == 'Receita') {
      _icon = Icon(Icons.monetization_on, color: Colors.green);
      _text = "Receita";
    } else if (_transferencia.tipo == 'Despesa') {
      _icon = Icon(Icons.monetization_on, color: Colors.red);
      _text = "Despesa";
    }

    return Card(
        child: ListTile(
        leading: _icon,
        title: Text('$_text - R\$ ${this._transferencia.valor.toString()}'),
        subtitle: Text('NOME: ${this._transferencia.nome_origem}'),
      ));
    
  }
}

class Transferencia {
  double valor;
  String nome_origem;
  String tipo;
  Transferencia(this.valor, this.nome_origem, this.tipo);
}

class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _transferencias = List.empty(growable: true);

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = _transferencias[indice];

          return ItemTransferencia(transferencia);
        },
      ),
      appBar: AppBar(
        title: Text('Tranferencias'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));

          future.then(
            (value) {
              debugPrint("Chegou no Future");
              debugPrint("$value");
              _transferencias.add(value);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class IFCBank extends StatelessWidget {
  const IFCBank({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          title: Text('Controle de Finanças'),
          backgroundColor: Colors.blueGrey),
      body: FormularioTransferencia(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    ));
  }
}

class ListaTransferenciaState extends State<ListaTransferencia> {
  void _atualiza(Transferencia transeferencia) {
    setState(() {
      widget._transferencias.add(transeferencia);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: widget._transferencias.length,
          itemBuilder: (context, indice) {
            final Transferencia = widget._transferencias[indice];

            return ItemTransferencia(Transferencia);
          },
        ),
        appBar: AppBar(
            title: Text('Controle de Finanças'),
            backgroundColor: Colors.blueGrey),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final Future future =
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FormularioTransferencia();
            }));

            future.then(
              (value) {
                if (value != null) {
                  _atualiza(value);
                }
              },
            );
          },
          child: Icon(Icons.add),
        ));
  }
}