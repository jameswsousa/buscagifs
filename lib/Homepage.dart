import 'dart:math';

import 'package:buscador_de_gifs/animation.dart';
import 'package:buscador_de_gifs/gifPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;
  Color cor;
  var rng;
  int number;

  Future<Map> _searchGifs() async {
    http.Response response;

    if (_search == null)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=QYZSvVlKQ1TieHfPLb8eKtQlbryHE1rL&limit=25&rating=R");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=QYZSvVlKQ1TieHfPLb8eKtQlbryHE1rL&q=$_search&limit=25&offset=$_offset&rating=R&lang=en");
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _searchGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          },
          child: Image.network(
              "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                border: OutlineInputBorder(),
                disabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _searchGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CustomLoadingWidget(),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _gifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _gifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          rng = new Random();
          for (var i = 0; i < 10; i++) {
            number = rng.nextInt(5);
          }
          switch (number) {
            case 0:
              cor = Color(0xff2AFC9C);
              break;
            case 1:
              cor = Color(0xffFFF39F);
              break;
            case 2:
              cor = Color(0xffFB6769);
              break;
            case 3:
              cor = Color(0xff9740FA);
              break;
            case 4:
              cor = Color(0xff22CDFB);
              break;
            default:
          }
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: cor),
                  borderRadius: BorderRadius.circular(5)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomLoadingWidget(),
                    ),
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      height: 300,
                      fit: BoxFit.cover,
                      image: snapshot.data["data"][index]["images"]
                          ["fixed_height"]["url"],
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
          );
        } else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 25;
                });
              },
            ),
          );
      },
    );
  }
}
