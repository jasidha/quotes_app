import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:html/dom.dart'as dom;
import 'package:html/parser.dart'as parser;
import 'package:quotesapp/quotespage.dart';

class Mainpage extends StatefulWidget {
   Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  List<String> quotescategory=["love","inspirational","life","humor"];

  List quotes=[];

  List authors=[];

  bool isDateThere=false;
  @override
  void initState() {

    super.initState();
    setState(() {
      getquotes();
    });
  }


  getquotes()async{
    String url="https://quotes.toscrape.com/";
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document=parser.parse(response.body);
    final quotesclass=document.getElementsByClassName("quote");
    quotes=quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    authors=quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();
setState(() {
  isDateThere=true;
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade100,
        centerTitle: true,
        elevation: 0.0,
        title: Text("Quotes App",style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start,
            children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
               children:
                 quotescategory.map((category){
                   return
                     InkWell(onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder:(context)=>Quotes(category)));
                     },
                       child: Container(
                         decoration: BoxDecoration(
                           color: Colors.red.shade100,
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Column(mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Center(
                               child: Text(
                                 category.toUpperCase(),style: TextStyle(
                                   fontWeight: FontWeight.bold,
                               fontSize: 20),),
                             ),
                           ],
                         ),

                       ),
                     );
                 }).toList(),



            ),
              ListView.builder(
                itemCount:quotes.length ,
                  shrinkWrap: true,
                  itemBuilder:(BuildContext,int index){
                  return
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                  semanticContainer: true,

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Text(quotes[index]),
                                    SizedBox(height: 12,),

                                    Center(child: Text(authors[index])),

                                  ],),
                                )

                              ),
                            ],
                          ),
                        ),
                      );

                  }
              ),
          ],),
        ),
      ) ,

    );
  }
}
