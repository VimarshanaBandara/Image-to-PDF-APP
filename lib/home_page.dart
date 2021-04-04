import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWrite;



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String fileName="pdfFile.pdf";
  final picker = ImagePicker();
  final pdf = pdfWrite.Document();
  List<File> image = [];
  final fileNameController = TextEditingController();

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }
   bool darkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? Colors.grey.shade700 : Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.pink.shade400,
        title: Text('IMAGE to PDF',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23.0,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Colors.black87,
            ),
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 8.0,
              color: Colors.black87,
            ),
          ],
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.home,color:Colors.white),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child:GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              image.isEmpty
                  ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400.0,
                  child:Center(
                      child: Material(
                        child: Container(
                          width: MediaQuery.of(context).size.width-120,
                          height: 40.0,
                          decoration: BoxDecoration(

                            color: darkMode ? Colors.grey.shade700 : Colors.grey[200],
                          ),
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            label: Text('Pick Image',
                              style: TextStyle(color: Colors.white,fontSize: 25.0),),
                            icon: Icon(Icons.image, color:Colors.white,size: 35.0,),
                            textColor: Colors.white,
                            splashColor: Colors.red,
                            color: Colors.pink.shade400,
                            onPressed: (){
                              setState(() {
                                fileName = DateTime.now().toString()+".pdf";
                              });

                              getImageFromGallery();
                            },

                          ),
                        ),
                      )
                  )
              )
                  : Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    height: 200,
                    width: MediaQuery.of(context).size.width - 20,
                    child: image != null
                        ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: image.length,
                      itemBuilder: (context, index) => Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            height: 200,
                            width: 200,

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.file(
                                image[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            left: 15,
                            child: Container(
                              width: 46,
                              height: 26,
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade400,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : SizedBox(),
                  ),
                ],
              ),
              image.isEmpty
                  ? SizedBox()
                  : Container(
                color: darkMode ?  Colors.grey.shade700 :  Colors.grey[200],
                child: Container(
                  color: darkMode ?  Colors.grey.shade700 :  Colors.grey[200],
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 26),
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  width: MediaQuery.of(context).size.width - 20,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Save Name: ",
                            style: TextStyle(
                                color: darkMode ?  Colors.white :  Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 50,
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(30),
                              border:
                              Border.all(color: Colors.black12, width: 1),
                            ),
                            child: TextField(
                              controller: fileNameController,
                              decoration: InputDecoration.collapsed(
                                  hintText:fileName,
                                  hintStyle:
                                  TextStyle(color: Colors.grey,fontSize: 18.0,fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              image.isEmpty
                  ? SizedBox()
                  : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RaisedButton(
                    color: Colors.pink.shade400,

                    onPressed: () {
                      getImageFromGallery();
                    },
                    child: Text(
                      "Import Image",
                      style: TextStyle(fontSize: 18, color: Colors.white,

                      ),
                    ),

                  ),
                  RaisedButton(
                    color: Colors.pink.shade400,

                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      /*setState(() {
                              fileName=fileNameController.text;
                            });*/
                      createPDF();

                    },
                    child:  Text(
                      "Convert to Pdf",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),

                  ),
                ],
              ),
            ],
          ),
        ),
      ),
       drawer: Drawer(
         child: ListView(
           children: [
             Container(
               height: 240.0,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(
                     bottomRight: Radius.circular(25.0),
                     bottomLeft: Radius.circular(25.0),
                   ),
                   color:Colors.pink.shade400
               ),
               child: Column(
                 children: [
                   Padding(
                     padding: EdgeInsets.only(top: 15.0),
                     child: Container(
                       width: 160.0,
                       height: 160.0,
                       decoration: BoxDecoration(
                           image: DecorationImage(
                             image: AssetImage('images/logo.png',),
                             fit: BoxFit.cover,
                           )
                       ),
                     ),
                   ),
                   SizedBox(height: 10.0,),
                   Text('Image to pdf',style: TextStyle(fontSize: 20.0,color: Colors.white,fontWeight: FontWeight.bold),),
                   Text('Powered by VM Mobile',style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold),),
                 ],
               ),
             ),
             ListTile(
               leading: Icon(Icons.perm_device_information_outlined),
               title: Text('About',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.grey),),
               trailing: IconButton(
                 icon: Icon(Icons.menu),
                 onPressed: (){},
               ),
             ),
             Divider(),
             ListTile(
               leading: Icon(Icons.privacy_tip),
               title: Text('Privacy & policy',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.grey),),
               trailing: IconButton(
                 icon: Icon(Icons.menu),
                 onPressed: (){},
               ),
             ),
             Divider(),

             ListTile(
               leading: Icon(Icons.home),
               title: Text('Home',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.grey),),
               trailing: IconButton(
                 icon: Icon(Icons.menu),
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                 },
               ),
             ),
             Divider(),
             ListTile(
               leading: Icon(Icons.nightlight_round),
               title: Text('Dark Mode',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.grey),),
               trailing: IconButton(
                 icon: Icon(Icons.menu),
                 onPressed: () {
                   setState(() {
                     darkMode = true;
                   });                    },
               ),
             ),
             Divider(),
             Divider(),
             ListTile(
               leading: Icon(Icons.brightness_5_sharp),
               title: Text('Light Mode',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.grey),),
               trailing: IconButton(
                 icon: Icon(Icons.menu),
                 onPressed: () {
                   setState(() {
                     darkMode = false;
                   });                    },
               ),
             ),
           ],
         ),
       ),
    );
  }

  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  createPDF() async {
    for (var img in image) {
      final image = pdfWrite.MemoryImage(img.readAsBytesSync());

      pdf.addPage(pdfWrite.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pdfWrite.Context context) {
            return pdfWrite.Center(child: pdfWrite.Image(image));
          }));
      //final dir = await getExternalStorageDirectory();
      Directory dir = Directory('/storage/emulated/0/Download');
      print("${dir.path}/example.pdf");
      final file = File('${dir.path}/'+fileName);
      await file.writeAsBytes(await pdf.save());
      showPrintedMessage('wait 5 seconds', 'saved to documents');
    }
  }



  showPrintedMessage(String title, String msg) {
    Flushbar(
      title: title,
      message: msg,
      duration: Duration(seconds: 5),
      icon: Icon(
        Icons.info,
        color: Colors.blue,
      ),
    )..show(context);
  }
}
