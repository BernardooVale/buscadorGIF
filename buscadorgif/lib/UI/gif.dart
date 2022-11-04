import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:transparent_image/transparent_image.dart';

class gifPagina extends StatelessWidget {

  final Map _gifData;
  const gifPagina(this ._gifData, {super.key});

  Future<void> share() async {
    await FlutterShare.share(
        title: 'GIF', linkUrl: (_gifData["images"]["fixed_height"]["url"]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        actions: [
          IconButton(icon: const Icon(Icons.share),
          onPressed: (){
            share();
          })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: FadeInImage.memoryNetwork(
            key: UniqueKey(),
            placeholder: kTransparentImage,
            image: _gifData["images"]["fixed_height"]["url"],
            height: 300.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
