import 'dart:convert';
import 'package:buscadorgif/UI/gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;

class paginaPrincipal extends StatefulWidget {
  const paginaPrincipal({Key? key}) : super(key: key);

  @override
  State<paginaPrincipal> createState() => _paginaPrincipalState();
}

class _paginaPrincipalState extends State<paginaPrincipal> {

  String _pesquisa = "";
  int offset = 0;

  int _pegaTamanho(List data){

    if(_pesquisa == ""){

      return data.length;
    } else {
      return data.length + 1;
    }

  }

  Future<Map> _pegaGif() async{

    http.Response response;

    if(_pesquisa == ""){

      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=cYlaXKO2weSulKqZgEijRZw5jbArkLE2&limit=25&rating=g"));
    } else{

      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=cYlaXKO2weSulKqZgEijRZw5jbArkLE2&q=$_pesquisa&limit=25&offset=$offset&rating=g&lang=en"));
    }

    return jsonDecode(response.body);

  }

  Widget _criaTabelaGifs(BuildContext context, AsyncSnapshot snapshot){

    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        itemCount: _pegaTamanho(snapshot.data["data"]),
        itemBuilder: (context, index){

          if(_pesquisa == "" || index < snapshot.data["data"].length) {
            return GestureDetector(
              child: Image.network(
                  snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover),
              onTap: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => gifPagina(snapshot.data["data"][index]))
                );
              },
            );
          } else {
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.add, color: Colors.white70, size: 70),
                  Text("Carrega Mais", style:TextStyle(color: Colors.white70, fontSize: 22))
                ],
              ),
              onTap: (){
                setState(() {
                  offset += 25;
                });
              },
              onLongPress: (){
                FlutterShare.share(
                    title: 'GIF', linkUrl: (snapshot.data["images"]["fixed_height"]["url"])
                );
              },
            );
          }
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black38,
      body: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(10.0),
              child: TextField(
                onSubmitted: (text){
                  setState(() {
                    _pesquisa = text;
                  });
                },
                decoration: const InputDecoration(
                    labelText: "Pesquise aqui",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder()
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 18.0),
                textAlign: TextAlign.center,
              )
          ),
          Expanded(
            child: FutureBuilder(
                future: _pegaGif(),
                builder: (context, snapshot){

                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                            strokeWidth: 5.0,
                          )
                      );
                    default:
                      if(snapshot.hasError) {
                        return Container();
                      } else {
                        return _criaTabelaGifs(context, snapshot);
                      }
                  }
                }
            ),
          ),
        ],
      ),
    );
  }
}