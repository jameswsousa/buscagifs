import 'package:flutter/material.dart';

// A animação original usava flare_flutter (assets/loading.flr), pacote
// descontinuado que não compila mais com o Flutter atual.
class CustomLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      alignment: Alignment.center,
      child: CircularProgressIndicator(color: Colors.white),
    );
  }
}
