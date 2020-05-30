import 'package:flutter/material.dart';

class Export extends StatefulWidget {
  @override
  _ExportState createState() => _ExportState();
}

class _ExportState extends State<Export> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: Text('Versiyon Notları'),
      ),
      body :  Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("versiyon 1.0.4 notları",style: new TextStyle(fontSize:25.0,fontWeight:FontWeight.bold),),
                ),
              ),
              Text("- Bu versiyonda task silme eklendi"),
              Text("- Task eklemek için yeni sayfa geldi. Floating button ile gidilebilir"),
              Text("- Sqflite bağlantısı ile veriler telefon veritabanında tutulmaya başlandı"),
              Text("- Sayfalar arası geçiş işlemi yapıldı"),
              Text("- Tasklar önceliklerine göre renklendirildi"),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text("by said"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}