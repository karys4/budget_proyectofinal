import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); //Id. único del formulario
  String _userName; //variable que almacena el correo del usuario
  String _password; //variable que almacena la contraseña

  bool _formValidate() {
    if (_formKey.currentState.validate()) {
      //Ejecuta la validación del formulario
      _formKey.currentState
          .save(); //Ejecuta el evento onSaved de cada TextFormField
      return true;
    }
    return false;
  }

  void _registerAccount() async {
    if (_formValidate()) {
      try {
        print("UserName:" + _userName);
        print("Password:" + _password);
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _userName, password: _password);
        print("Create user Ok: ${user.uid}");
        Navigator.pop(context);
      } catch (e) {
        print("AuthError: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String _validateEmail(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'El Email no es válido';
      else
        return null;
    }

    String _validatePassword(String value) {
      if (value.isEmpty)
        return "Escriba una contraseña";
      else if (value.length < 6)
        return "La contraseña debe tener por lo menos 6 caracteres";
      else
        return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Register Screen"),
      ),
      body: ListView(
        padding: EdgeInsets.all(32.0),
        children: <Widget>[
          SizedBox(
            height: 80.0,
          ),
          Center(
            child: Text("Crear Usuario", style: TextStyle(fontSize: 20.0)),
          ),
          SizedBox(
            height: 80.0,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) => _validateEmail(input),
                  onSaved: (input) => _userName = input,
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (input) => _validatePassword(input),
                  onSaved: (input) => _password = input,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          RaisedButton(
              color: Theme.of(context).accentColor,
              elevation: 5.0,
              splashColor: Colors.blueGrey,
              child: Text('Crear Usuario'),
              onPressed: () => _registerAccount()),
          FlatButton(
              child: Text('Ya tienes cuenta? Iniciar sesión'),
              onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
