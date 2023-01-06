import 'package:farfromhome/LocalBindings.dart';
import 'package:farfromhome/ui/page_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:farfromhome/utils/utils.dart';
import 'package:farfromhome/utils/responsive_screen.dart';
import 'package:farfromhome/widgets/widgets.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

List<String> roomList = <String>[
    '3x5',
    '3x9',
    '4x4',
    '4x6',
    'Depa',
  ];

class CustomSearchPage extends StatefulWidget {
  @override
  CustomSearchState createState() => CustomSearchState();
}

class CustomSearchState extends State<CustomSearchPage> {
  final _formKey = GlobalKey<FormState>();

  Screen size;
  var citiesList = ["Bellavista", "Laykakota", "Camal", "Simon Bolivar ", "Centro", "San jose","Alto Alianza"];
  var propertyType = ["Primer piso", "Seguno piso" , "Tercer piso", "Cuarto piso"];
  var propertyIcon = ["bunglow.png","pg.png","hostel.png","flat.png"];
  var propertyColor = [Color(0xff3ABBFA),Color(0xffFBBF36),Color(0xff83E934),Color(0xffA7A4FC)];
  static double _minlowerValue = 0.0;
  String _lowerValueString = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol: '\u0053\u002F\u002E'
                              ).format(_minlowerValue);
  static double _maxupperValue = 350;
  String _upperValueString = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol: ''
                              ).format(_maxupperValue);
  String _upperValueFormatted = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol: '\u0053\u002F'
                              ).format(_upperValue);

  String _lowerValueFormatted = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol: '\u0053\u002F\u002E'
                              ).format(_lowerValue);

  // Value of Featured City starting from -1 : All city | 0 : Ahemdabad | 1 : Mumbai | 2 : Anand | ... in order mentioned in cityList[] in  line 28
  int _selectedIndex = -1;
  String  _locality;
  // 0 : Bunglow , 1 : Paying Guest, 2 : Hostel, 3 : Apartment
  var _selectedProperty = [];
  // 1 RK : 1 Room Kithcen | 3x5 | 3x9 | 4x4 | 4x6 | Depa : Rooms >=5
  var _selectedRoom = [];
  // Range Slider LowerValue
  static double _lowerValue = 20.0;
  // Range Slider UpperValue
  static double _upperValue = 80.0;
  //Value of the check box about shared Room false : not checked | true : checked 
  bool _shareRoom = false;

  void _search() async{
    var userRef= await LocalStorage.sharedInstance.loadUserRef(Constants.userRef);
    Navigator.push(context, MaterialPageRoute(builder: (_)=> SearchResultPage(userRef)));
    // Write Your code to create query and show result on page_search 
  }

  @override
  void initState() {  
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
        body: Stack(
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
          Container(
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: size.getWidthPx(10)),
                    child: Column(
                      children: <Widget>[
                        preferenceTitleWidget(),
                        SizedBox(height: size.getWidthPx(1)),
                        preferenceUpperBoxCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
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
          FocusScope.of(context).requestFocus(new FocusNode());
          if (selected) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  Padding buildPropertyChip(index, chipName, chipImage, chipColor) {
    return 
    Padding(
      padding: (index == 0) ? EdgeInsets.only(left: size.getWidthPx(10)) : EdgeInsets.only(left: size.getWidthPx(25)),
      child: Transform(
        transform: new Matrix4.identity()..scale(1.13),
        child: InputChip(
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(size.getWidthPx(5))),
          avatar: CircleAvatar(
            backgroundColor: chipColor,
            child: Image.asset(
              'assets/icons/'+chipImage,
              width: double.infinity,
            )
            
          ),
          backgroundColor: backgroundColor,
          selectedColor: Colors.black.withOpacity(0.3),
          labelStyle: TextStyle(
              fontFamily: 'Exo2',
              color:
                  (_selectedProperty.contains(index)) ? backgroundColor : textPrimaryColor),
          elevation: 4.0,
          padding: EdgeInsets.symmetric(
              vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
          selected: (_selectedProperty.contains(index)) ? true : false,
          label: Text(chipName),
          onSelected: (selected) {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (selected) {
              setState(() {
                _selectedProperty.add(index);
              });
            }else{
              setState(() {
                _selectedProperty.remove(index);
              });
            }
          },
        ),
      ),
    );
  }

  Widget buildRoomChip() {
    return Container(
      height: size.hp(10.5),
      width: size.wp(80),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                color: _selectedRoom.contains("3x3") ? Colors.black.withOpacity(0.3) : backgroundColor,
                child: TextButton(
                  child: Text(
                    "3x3",
                    style: TextStyle(
                      fontFamily: 'Exo2',
                      color: 
                        _selectedRoom.contains("3x3") ? backgroundColor : textPrimaryColor,
                    ),
                  ),
                  onPressed: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      if(_selectedRoom.contains("3x3")) {
                        _selectedRoom.remove("3x3");
                      }else{
                        _selectedRoom.add("3x3");
                      }
                    });
                  },
                ),
                width: size.wp(26),
                height: size.hp(5),
              ),
              SizedBox(
                width: size.wp(1),
              ),
              Container(
                color: _selectedRoom.contains("3x5") ? Colors.black.withOpacity(0.3) : backgroundColor,
                child: TextButton(
                  child: Text(
                    "3x5",
                    style: TextStyle(
                      fontFamily: 'Exo2',
                      color: 
                        _selectedRoom.contains("3x5") ? backgroundColor : textPrimaryColor,
                    ),
                  ),
                  onPressed: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      if(_selectedRoom.contains("3x5")) {
                        _selectedRoom.remove("3x5");
                      }else{
                        _selectedRoom.add("3x5");
                      }
                    });
                  },
                ),
                width: size.wp(26),
                height: size.hp(5),
              ),
              SizedBox(
                width: size.wp(1),
              ),
              Container(
                color: _selectedRoom.contains("3x9") ? Colors.black.withOpacity(0.3) : backgroundColor,
                child: TextButton(
                  child: Text(
                    "3x9",
                    style: TextStyle(
                      fontFamily: 'Exo2',
                      color: 
                        _selectedRoom.contains("3x9") ? backgroundColor : textPrimaryColor,
                    ),
                  ),
                  onPressed: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      if(_selectedRoom.contains("3x9")) {
                        _selectedRoom.remove("3x9");
                      }else{
                        _selectedRoom.add("3x9");
                      }
                    });
                  },
                ),
                width: size.wp(26),
                height: size.hp(5),
              ),
            ],
          ),
          SizedBox(
            height: size.hp(0.5),
          ),
          Row(
            children: <Widget>[
              Container(
                color: _selectedRoom.contains("4x4") ? Colors.black.withOpacity(0.3) : backgroundColor,
                child: TextButton(
                  child: Text(
                    "4x4",
                    style: TextStyle(
                      fontFamily: 'Exo2',
                      color: 
                        _selectedRoom.contains("4x4") ? backgroundColor : textPrimaryColor,
                    ),
                  ),
                  onPressed: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      if(_selectedRoom.contains("4x4")) {
                        _selectedRoom.remove("4x4");
                      }else{
                        _selectedRoom.add("4x4");
                      }
                    });
                  },
                ),
                width: size.wp(26),
                height: size.hp(5),
              ),
              SizedBox(
                width: size.wp(1),
              ),
              Container(
                color: _selectedRoom.contains("4x6") ? Colors.black.withOpacity(0.3) : backgroundColor,
                child: TextButton(
                  child: Text(
                    "4x6",
                    style: TextStyle(
                      fontFamily: 'Exo2',
                      color: 
                        _selectedRoom.contains("4x6") ? backgroundColor : textPrimaryColor,
                    ),
                  ),
                  onPressed: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      if(_selectedRoom.contains("4x6")) {
                        _selectedRoom.remove("4x6");
                      }else{
                        _selectedRoom.add("4x6");
                      }
                    });
                  },
                ),
                width: size.wp(26),
                height: size.hp(5),
              ),
              SizedBox(
                width: size.wp(1),
              ),
              Container(
                color: _selectedRoom.contains("Depa") ? Colors.black.withOpacity(0.3) : backgroundColor,
                child: TextButton(
                  child: Text(
                    "Depa",
                    style: TextStyle(
                      fontFamily: 'Exo2',
                      color: 
                        _selectedRoom.contains("Depa") ? backgroundColor : textPrimaryColor,
                    ),
                  ),
                  onPressed: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      if(_selectedRoom.contains("Depa")) {
                        _selectedRoom.remove("Depa");
                      }else{
                        _selectedRoom.add("Depa");
                      }
                    });
                  },
                ),
                width: size.wp(26),
                height: size.hp(5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget preferenceTitleWidget() {
    return Row(
      children: <Widget>[
        IconButton(
          padding: new EdgeInsets.fromLTRB(1,1,0,0),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Text("Personaliza tu busqueda",
                style: TextStyle(
                  fontFamily: 'Exo2',
                  fontSize: size.getWidthPx(24),
                  fontWeight: FontWeight.w900,
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRangeSlider() {
    return frs.RangeSlider(
        min: _minlowerValue,
        max: _maxupperValue,
        lowerValue: _lowerValue,
        upperValue: _upperValue,
        divisions: 100,
        showValueIndicator: true,
        valueIndicatorFormatter: (int index, double value) {
          String twoDecimals = NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol: '\u0053\u002F\u002E'
          ).format(value);
          return '$twoDecimals';
        },
        onChanged: (double newLowerValue, double newUpperValue) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
          _lowerValue = newLowerValue;
          _upperValue = newUpperValue;
          _upperValueFormatted = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol: '\u0053\u002F\u002E'
                              ).format(_upperValue);
          _lowerValueFormatted = NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol: '\u0053\u002F\u002E'
                              ).format(_lowerValue);
        });
      },
    );
  }

  Widget _searchField(){
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    size = Screen(MediaQuery.of(context).size);
    return  Container(
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
                decoration: BoxDecoration(
                    color:  Colors.grey.shade100,
                    border:  Border.all(color: Colors.grey.shade400, width: 1.0),
                    borderRadius:  BorderRadius.circular(8.0),
                  ),
                child: TextFormField(
                  style: TextStyle(fontFamily: 'Exo2'),
                  onChanged: (String val) {
                    setState(() {
                      _locality=val;
                    });
                  },
                  decoration:  InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorCurve,
                        size: size.getWidthPx(22),
                      ),
                      hintText: 'Busqueda por calles'),
                ),
              )),
        ],
      ),
      padding: EdgeInsets.only(bottom :size.getWidthPx(8)),
      margin: EdgeInsets.only(top: size.getWidthPx(8), right: size.getWidthPx(8), left:size.getWidthPx(8)),
    );
  }

  Widget getSharedRoomCheck() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: size.getWidthPx(10),
        ),
        Checkbox(
          value: _shareRoom,
          onChanged: (bool value) {
            FocusScope.of(context).requestFocus(new FocusNode());
               setState(() {
                  _shareRoom = value;
              });
          }
        ),
        Text("Cuarto compartido"),
      ],
    );
  }

  Widget getSubmitButton() {
    return ClipRRect(
          borderRadius: BorderRadius.circular(size.getWidthPx(5)),
          child: Container(
          //margin: EdgeInsets.only(bottom: size.hp(3)),
          color: colorCurve,
          child: TextButton(
            child: Text(
              "Buscar",
              style: TextStyle(
                fontFamily: 'Exo2',
                color: Colors.white,
                fontSize: size.getWidthPx(20)
              ),
            ),
            onPressed: (){
              FocusScope.of(context).requestFocus(new FocusNode());
              Fluttertoast.showToast(msg: "Buscando");
              _search();
            },
          ),
          width: size.wp(78),
          height: size.hp(8),
        ),
    );
  }

  Card preferenceUpperBoxCard() {
    return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(
            horizontal: size.getWidthPx(12), vertical: size.getWidthPx(12)),
        borderOnForeground: true,
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.hp(2),
              ),
              leftAlignText(
                  text: "Lugares recomendados :",
                  leftPadding: size.getWidthPx(16),
                  textColor: textPrimaryColor,
                  fontSize: size.getWidthPx(16)),
              HorizontalList(
                children: <Widget>[
                  for(int i=0;i<citiesList.length;i++)
                    buildChoiceChip(i, citiesList[i])
                ],
              ),
              SizedBox(
                height: size.hp(1),
              ),
              _searchField(),
              SizedBox(
                height: size.hp(2),
              ),
              leftAlignText(
                  text: "Que estas buscando:",
                  leftPadding: size.getWidthPx(16),
                  textColor: textPrimaryColor,
                  fontSize: size.getWidthPx(16)),
              HorizontalList(
                children: <Widget>[
                  for(int i=0;i<propertyType.length;i++)
                    buildPropertyChip(i, propertyType[i], propertyIcon[i], propertyColor[i])
                ],
              ),
              SizedBox(
                height: size.hp(2),
              ),
              leftAlignText(
                  text: "Rango de precios: $_lowerValueFormatted  hasta $_upperValueFormatted",
                  leftPadding: size.getWidthPx(16),
                  textColor: textPrimaryColor,
                  fontSize: size.getWidthPx(16)),
              SizedBox(
                height: size.hp(1.5),
              ),
              _buildRangeSlider(),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: size.wp(4),
                  ),
                  Align(alignment: Alignment.centerLeft,child: Text("$_lowerValueString")),
                  SizedBox(
                    width: size.wp(70),
                  ),
                  Align(alignment: Alignment.centerRight,child: Text("$_upperValueString")),
                  SizedBox(
                    width: size.wp(3),
                  ),
                ],
              ),
              SizedBox(height: size.hp(2),),
              leftAlignText(
                  text: "Tamaño de cuartos:",
                  leftPadding: size.getWidthPx(16),
                  textColor: textPrimaryColor,
                  fontSize: size.getWidthPx(16)),
              SizedBox(height: size.hp(2),),
              buildRoomChip(),
              SizedBox(height: size.hp(1),),
              getSharedRoomCheck(),
              SizedBox(height: size.hp(5),),
              getSubmitButton(),
              SizedBox(
                height: size.hp(3),
              )
            ],
          ),
        )
      );
  }
}