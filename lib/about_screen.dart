import 'package:flutter/material.dart';
import 'package:image_to_pdf/home_page.dart';
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         leading: IconButton(
           icon: Icon(Icons.arrow_back,color: Colors.white,),
           onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
           },
         ),
         title: Text('About App'),
         backgroundColor: Colors.pink.shade400,
       ),
     body: Container(
       width: MediaQuery.of(context).size.width,
       height: MediaQuery.of(context).size.height,
       child: Padding(
         padding: EdgeInsets.only(top: 15.0,left: 15.0,right: 5.0),
         child:Text('You can easily convert any image to PDF using this app.\n\nYou can also convert photos from your camera to PDF.',style: TextStyle(fontSize: 20.0),)
       ),
     )
    );
  }
}
