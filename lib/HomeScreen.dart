import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ToBuyList.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  HomeScreen({Key key, this.userName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//Valores de Pop Menu Button
class Constants {
  static const String newBudget = 'New Budget';
  static const String createList = 'Create List';
  //static const String signOut = 'Sign Out';

  static const List<String> options = <String>
      //Opciones a mostrarse en la lista
      [newBudget, createList];
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController startingController = TextEditingController();
  TextEditingController newExpenseController = TextEditingController();
  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.options.map((String options) {
                return PopupMenuItem<String>(
                  value: options,
                  child: Text(options),
                );
              }).toList();
            },
          )
        ],
      ),

      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            getImage(),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'You can still spend: ' + this.displayResult,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: startingController,
                  decoration: InputDecoration(
                      labelText: 'Starting Budget',
                      hintText: 'Enter your budget',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.0)
                          //borderSide: BorderSide(color: Colors.black),
                          )),
                )),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: newExpenseController,
                        decoration: InputDecoration(
                            labelText: 'New Expense',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0))),
                      ),
                    ),
                    //Este contenedor agrega un espacio entre TextField y botón Add
                    Container(
                      width: 10.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        child: Text('Add'),
                        color: Colors.amber,
                        onPressed: () {
                          setState(() {
                            this.displayResult = _addExpense();
                          });
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget getImage() {
    AssetImage assetImage = AssetImage('assets/icon.png');
    Image image = Image(
      image: assetImage,
      width: 80.0,
      height: 80.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(25.0),
    );
  }

  String _addExpense() {
    double startingBudget = double.parse(startingController.text);
    double newExpense = double.parse(newExpenseController.text);
    double leftToSpend = (startingBudget - newExpense);
    String result = "$leftToSpend";
    return result;
  }

//Método para realizar acciones de acuerdo a selección de Menú
  void choiceAction(String option) {
    if (option == Constants.newBudget) {
      startingController.text = '';
      newExpenseController.text = '';
      displayResult = '';
    } else if (option == Constants.createList) {
      print("Crear una lista");
      Navigator.push(context, MaterialPageRoute(builder: (_) => ToBuyList()));
    }
  }
}
