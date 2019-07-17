import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galleryapp/network/NetworkCall.dart';
import 'Upload.dart';


class Main extends StatefulWidget
{
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
   
   Future<List<ImageData>>list;
   List<ImageData> _searchList;
   List<ImageData>aux_list;
   TextEditingController _searchController = new TextEditingController();
   bool _search = false;
   @override
  void initState() {
    // TODO: implement initState

    list = LoadImages();
    aux_list=[];
        
  
    
       _searchController.addListener(() {
          print("clicked");
        _searchList =  aux_list.where((i) =>
              i.prediction.startsWith(_searchController.text)
            )
          .toList();
      _search = true;
     // onChip = getMemebrs(originaList);
     

      setState(() {});
    });
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar:AppBar(
            title:Text("Gallery"),
            bottom:getSearchBar()
             ),
          floatingActionButton:FloatingActionButton(child:Icon(Icons.cloud),onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>Upload()));
          },),
          body:FutureBuilder(
          future:list,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new LinearProgressIndicator(
                  backgroundColor: Colors.deepPurpleAccent,
                );
              default:
              
                 
                if (_search==true)
                {
                   return GridView.count(crossAxisCount: 2, children:
                 List<Widget>.generate(_searchList.length,(index)
                 { 
                   return GridImage(uri:_searchList[index].uri,pre:_searchList[index].prediction,);
                 }));
                }
                else
               
                return GridView.count(crossAxisCount: 2, children:
                 List<Widget>.generate(snapshot.data.length,(index)
                 {  aux_list.add(ImageData(snapshot.data[index].uri,snapshot.data[index].prediction));
                   return GridImage(uri:snapshot.data[index].uri,pre:snapshot.data[index].prediction,);
                 }));
            }}));
          
  
  }
        
        
           getSearchBar()
    {
      return  PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                    title: TextField(
                      
                    controller: _searchController,
                      decoration: InputDecoration(
                          hintText: 'Search image  ',
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ));
    }

  

   }

   
  

   
    
  class GridImage extends StatelessWidget
  {
    String uri;
    String pre;
    GridImage({this.uri,this.pre});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
    
      child: Card(
        child: Column(
          children: <Widget>[
             Image.network(uri),
             Text("prediction:"+pre)
          ],
        )),

      );
      
  }
 

  }

