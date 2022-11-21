import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farfromhome/LocalBindings.dart';
import 'package:farfromhome/ui/page_add_house.dart';
import 'package:farfromhome/ui/page_custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:farfromhome/model/models.dart';
import 'package:farfromhome/utils/utils.dart';
import 'package:farfromhome/widgets/drawer.dart';
import 'package:farfromhome/widgets/widgets.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Screen size;
  int _selectedIndex = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Property> recentList =  List();
  List<Property> topList =  List();
  var citiesList = ["Bellavista", "Laykakota", "Camal", "Simon Bolivar ", "Centro", "San jose","Alto Alianza"];
  Image image1;
  String docRef;
  String isLoggedIn;
  DocumentSnapshot docsSnap;

  void getUserDetails() async{
    //isLoggedIn= await LocalStorage.sharedInstance.loadAuthStatus(Constants.isLoggedIn);
    docRef= await LocalStorage.sharedInstance.loadUserRef(Constants.userRef);
    print('docRef :'+ docRef);
    if(docRef != "NULL"){
      FirebaseFirestore.instance.doc('/User/'+docRef).get().then((DocumentSnapshot docs) {
        print("Doc found");
        setState(() {
          docsSnap = docs;  
        });
      });
    }else{
      setState((){docsSnap=null;});
      print("Doc Not Exsist");
    }
  }

  @override
  void initState() {

    // TODO: implement initState
    // TODO: implement initState
    super.initState();
    setState((){docsSnap=null;});
    getUserDetails();
    
    image1 = Image.asset("assets/drawer_design.png", gaplessPlayback: true);

    topList
    ..add(Property(propertyName:"Cuarto Barato", propertyLocation:"Bellavista ", image:"feature_1.jpg", propertyPrice:"110"))
    ..add(Property(propertyName:"Cuarto Camal", propertyLocation:"Camal ", image:"feature_2.jpg", propertyPrice:"150"))
    ..add(Property(propertyName:"Cuarto cerca al mercado", propertyLocation:"Centro ", image:"feature_3.jpg", propertyPrice:"170"))
    ..add(Property(propertyName:"Cuarto grande", propertyLocation:"Simon bolivar ", image:"hall_1.jpg", propertyPrice:"200"))
    ..add(Property(propertyName:"Cuarto a 10 min de la u", propertyLocation:"San jose ", image:"hall_2.jpeg", propertyPrice:"130"));

    recentList
    ..add(Property(propertyName:"Cuarto economico", propertyLocation:"Camal ", image:"hall_1.jpg", propertyPrice:"110"))
    ..add(Property(propertyName:"Cuarto amplio", propertyLocation:"Bellavista ", image:"hall_2.jpeg", propertyPrice:"180"))
    ..add(Property(propertyName:"Cuarto doble", propertyLocation:"Simon bolivar ", image:"feature_1.jpg", propertyPrice:"150"))
    ..add(Property(propertyName:"Apartamento cerca al mercado", propertyLocation:"Bellavista ", image:"hall_1.jpg", propertyPrice:"250"))
    ..add(Property(propertyName:"Cuarto solo", propertyLocation:"Bellavista", image:"feature_3.jpg", propertyPrice:"100"));
  }

  // void addTopList(){
  //   final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(DateTime.parse('2019-03-13 16:49:42.044').millisecondsSinceEpoch);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image1.image, context);
  }

  @override
  Widget build(BuildContext context) {
    //final docData = docsSnap.data() as Map<String, dynamic>;

    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    FlutterStatusbarcolor.setStatusBarColor(Colors.blue[700].withOpacity(0.9));
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
      backgroundColor: backgroundColor,
      key: _scaffoldKey,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: backgroundColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: backgroundColor),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                upperPart()
              ],
            ),
          ),
        ),
      ),

     //drawer: docData != null ? drawer(image1,context,docData['profileImage'],docData['firstName']+" "+docData['lastName'],docData['email'],"true",'/User/'+docRef)
     //                         : drawer(image1,context,'assets/icons/avatar.png','Iniciar sesion / Registrarse ','','false',null),

            drawer: drawer(image1,context,'assets/icons/avatar.png','Iniciar sesion / Registrarse ','','false',null),
    );
  }

  Widget upperPart() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: UpperClipper(),
          child: Container(
            height: size.getWidthPx(240),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorCurve, colorCurve],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.getWidthPx(36)),
              child: Column(
                children: <Widget>[
                  titleWidget(),
                  SizedBox(height: size.getWidthPx(1)),
                  upperBoxCard(),
                ],
              ),
            ),
            postHouse(),
            leftAlignText(
                text: "Lugares en tendencia",
                leftPadding: size.getWidthPx(16),
                textColor: textPrimaryColor,
                fontSize: 16.0
              ),
            HorizontalList(
              children: <Widget>[
                for (int i = 0; i < topList.length; i++)
                  propertyCard(topList[i])
              ],
            ),
            leftAlignText(
                text: "Recien agregados",
                leftPadding: size.getWidthPx(16),
                textColor: textPrimaryColor,
                fontSize: 16.0),
            HorizontalList(
              children: <Widget>[
                for (int i = 0; i < recentList.length; i++)
                  propertyCard(recentList.toList()[i])
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget postHouse(){
    return Card(
        margin: EdgeInsets.symmetric(
              horizontal: size.getWidthPx(20), vertical: size.getWidthPx(10)),
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          child: Container(
            height: size.getWidthPx(270),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: new EdgeInsets.only(top: size.getWidthPx(15)),
                    child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Buscas un nuevo inquilino',
                            style: TextStyle(
                                fontFamily: 'Exo2',
                                fontSize: size.getWidthPx(17),
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                            ),
                          ),
                        ),
                    ),
                  ),
                  Container(
                    child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Para tu propiedad?',
                            style: TextStyle(
                                fontFamily: 'Exo2',
                                fontSize: size.getWidthPx(17),
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                            ),
                          ),
                        ),
                    ),
                  ),
                  SizedBox(
                    height: size.getWidthPx(3),
                  ),
                  Container(
                    child: Image.asset(
                      'assets/post_house.png',
                      fit: BoxFit.fitWidth,
                      width: size.wp(100),
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.fromLTRB(size.getWidthPx(15),0,size.getWidthPx(15),size.getWidthPx(6)),
                    child: SizedBox(
                      width: double.infinity,
                      child:  new ElevatedButton(
                        /*
                        color: Colors.blue[700],
                        colorBrightness: Brightness.dark,
                        */
                        child: Text('Publica tu cuarto'),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=> AddHouse(docRef)));
                          print('Añadir cuarto');
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget titleWidget() {
    return Row(
      children: <Widget>[
        IconButton(
          padding: new EdgeInsets.fromLTRB(1,1,0,0),
          icon: Icon(
            FontAwesomeIcons.bars,
            color: Colors.white,
          ),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Que tipo de cuarto",
                  style: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: size.getWidthPx(24),
                      fontWeight: FontWeight.w900,
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
              Text("estas buscando?",
                style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: size.getWidthPx(24),
                    fontWeight: FontWeight.w900,
                    color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Card upperBoxCard() {
    return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(
            horizontal: size.getWidthPx(20), vertical: size.getWidthPx(0)),
        borderOnForeground: true,
        child: Container(
          height: size.getWidthPx(150),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Center(
                  child: Hero(
                    tag: 'searcHero',
                    child: _searchWidget(),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> CustomSearchPage()));
                },
              ),
              leftAlignText(
                  text: "Lugares mas buscados :",
                  leftPadding: size.getWidthPx(16),
                  textColor: textPrimaryColor,
                  fontSize: 16.0),
              HorizontalList(
                children: <Widget>[
                  for(int i=0;i<citiesList.length;i++)
                    buildChoiceChip(i, citiesList[i])
                ],
              ),
            ],
          ),
        ));
  }

  Widget _searchWidget() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    size = Screen(MediaQuery.of(context).size);
    return Container(
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: height / 400),
                  padding: EdgeInsets.all(size.getWidthPx(0)),
                  alignment: Alignment.center,
                  height: size.getWidthPx(40),
                  decoration:  BoxDecoration(
                      color: Colors.grey.shade100,
                      border:  Border.all(color: Colors.grey.shade400, width: 1.0),
                      borderRadius:  BorderRadius.circular(8.0)),
                  child: Row(children: <Widget>[
                    SizedBox(width: size.getWidthPx(10),),
                    Icon(Icons.search,color: colorCurve),
                    Text("Buscar por lugar, avenida, calle")
                  ],) 
              ),),
          ],
        ),
        padding: EdgeInsets.only(bottom :size.getWidthPx(8)),
        margin: EdgeInsets.only(top: size.getWidthPx(8), right: size.getWidthPx(8), left:size.getWidthPx(8)),
    );
  }

  Padding leftAlignText({text, leftPadding, textColor, fontSize, fontWeight}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text??"",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w500,
                color: textColor)),
      ),
    );
  }

  Card propertyCard(Property property) {
    return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        borderOnForeground: true,
        child: Container(
            height: size.getWidthPx(150),
            width: size.getWidthPx(170),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0)),
                    child: Image.asset('assets/${property.image}',
                        fit: BoxFit.fill)),
                SizedBox(height: size.getWidthPx(8)),
                leftAlignText(
                    text: property.propertyName,
                    leftPadding: size.getWidthPx(8),
                    textColor: colorCurve,
                    fontSize: 14.0),
                leftAlignText(
                    text: property.propertyLocation,
                    leftPadding: size.getWidthPx(8),
                    textColor: Colors.black54,
                    fontSize: 12.0),
                SizedBox(height: size.getWidthPx(4)),
                leftAlignText(
                  text: NumberFormat.compactCurrency(
                        decimalDigits: 2,
                        symbol: '\u0053\u002F\u002E'
                    ).format(double.parse(property.propertyPrice)),
                    leftPadding: size.getWidthPx(8),
                    textColor: colorCurve,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800),
              ],
            ),
          ),
        );
  }

  Padding buildChoiceChip(index, chipName) {
    return Padding(
      padding: EdgeInsets.only(left: size.getWidthPx(8)),
      child: ChoiceChip(
        backgroundColor: backgroundColor,
        selectedColor: colorCurve,
        labelStyle: TextStyle(
            fontFamily: 'Exo2',
            color:
                (_selectedIndex == index) ? backgroundColor : textPrimaryColor),
        elevation: 4.0,
        padding: EdgeInsets.symmetric(
            vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
        selected: (_selectedIndex == index) ? true : false,
        label: Text(chipName),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
