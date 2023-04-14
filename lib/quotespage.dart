import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:html/dom.dart'as dom;
import 'package:html/parser.dart'as parser;
import 'package:http/http.dart';
class Quotes extends StatefulWidget {
  final String categoryname;

  Quotes(this.categoryname);


  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  List quotes=[];
  List authors=[];
  bool isDataThere=false;
  @override
  void initState() {

    super.initState();
    setState(() {
      getquotes();

    });
  }
  getquotes() async {
    String url="https://quotes.toscrape.com/tag/${widget.categoryname}/";
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document=parser.parse(response.body);
    final quotesclass=document.getElementsByClassName("quote");
    quotes=quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    authors=quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();
    setState(() {
      isDataThere=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 40),
              child: Text(
                "${widget.categoryname}quotes",style: TextStyle(
                color: Colors.black,fontWeight: FontWeight.w700,
              ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: quotes.length,
                itemBuilder:(context,index){
                return
                    Card(
                      semanticContainer: true,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(quotes[index]),
                          ),
                          SizedBox(height: 12,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(authors[index]),
                          ),
                        ],),
                      ),
                    );

                }
            ),


          ],),
        ),
      ),


    );
  }
}
