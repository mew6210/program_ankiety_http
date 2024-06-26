import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:program_ankiety_http/bgcolor.dart';
import 'package:program_ankiety_http/chart/pie_chart.dart';
import '../chart_container.dart';
import 'package:http/http.dart' as http;
import 'package:expandable/expandable.dart';
import 'package:program_ankiety_http/consts.dart';
import 'dart:math';







class Prezentacja extends StatefulWidget {
  final String ip;
  final int port;


  Prezentacja({required this.ip, required this.port});

  @override
  _prezentacja createState() => _prezentacja();
}

class _prezentacja extends State<Prezentacja> {
  String typeofchart="piechart";
  String selectedValue = 'Klasa 1';

  late TextEditingController messageController;




  late String themevalue;




  List<int> valueTable = [];


  @override
  void initState() {
    super.initState();

    messageController = TextEditingController();

    getHTTPGrades();
    usertheme=randomTheme;
    themevalue="randomtheme";

  }





  void getHTTPGrades() async {
    String login=widget.ip;
    String port=widget.port.toString();

    String baseUrl = "http://$login:$port";
    int classValue = getClassNumber();

    var response;
    String responsebody;
    try{
      response = await http.get(Uri.parse('$baseUrl/grades?class=$classValue'));
      responsebody=response.body;
    }
    catch(error){
      print("Server not responding");
      responsebody="Server unresponsive";
    }








    try {
      // Parse the received message into a JSON object
      var jsonData = jsonDecode(responsebody);

      // Check if the JSON object has a "purpose" field and its value is "sendingGrades"
      if (jsonData.containsKey('purpose') &&
          jsonData['purpose'] == 'sendingGrades') {

        valueTable.clear();


        var tagsJson = jsonDecode(responsebody)['grades'];
        List<String>? tags = tagsJson != null ? List.from(tagsJson) : null;



        for(String tag in tags!){
          int tag_int=int.parse(tag);
          valueTable.add(tag_int);

        }





        print('Received sendingGrades message');
      }

    } catch (e) {
      print('Failed to parse JSON: $e');
    }


    setState(() {

    });



  }

  void clearInputs(){
    messageController.clear();


    FocusScope.of(context).unfocus();

  }

  int getClassNumber(){
    int klasa;

    switch(selectedValue){
      case "Klasa 1": klasa=1;
      case "Klasa 2": klasa=2;
      case "Klasa 3": klasa=3;
      case "Klasa 4": klasa=4;
      case "Klasa 5": klasa=5;

      default: klasa=999;
    }




    return klasa;
  }


  // Funkcja obliczająca wariancję
  double calculateVariance(List<int> numbers) {
    double variance;
    try{


    // Oblicz średnią arytmetyczną
    double mean = numbers.reduce((a, b) => a + b) / numbers.length;

    // Oblicz sumę kwadratów różnic między wartościami a średnią
    double sumOfSquares = 0;
    for (var number in numbers) {
      sumOfSquares += pow(number - mean, 2);
    }

    // Oblicz wariancję jako średnią z sumy kwadratów różnic
    variance = sumOfSquares / numbers.length;
    }
    catch(error){
      variance=0;
    }

    return variance;
  }

// Funkcja obliczająca odchylenie standardowe
  double calculateStandardDeviation(List<int> numbers) {
    // Oblicz wariancję za pomocą wcześniej zdefiniowanej funkcji
    double variance = calculateVariance(numbers);

    // Oblicz pierwiastek kwadratowy z wariancji
    double standardDeviation = sqrt(variance);

    return standardDeviation;
  }






  void askForGrades(){

    getHTTPGrades();

  }


  List<int> sortValueTable(List<int> valueTable, bool ascending) {
    List<int> sortedList = List.from(valueTable); // Create a copy to avoid modifying the original list

    sortedList.sort((a, b) => ascending ? a.compareTo(b) : b.compareTo(a));

    return sortedList;
  }



  double calculateAverage(List<int> valueTable) {
    if (valueTable.isEmpty) {
      return 0; // Return 0 for an empty list to avoid division by zero
    }
    return valueTable.reduce((a, b) => a + b) / valueTable.length;
  }


  int? findDominantValue(List<int> valueTable) {
    if (valueTable.isEmpty) {
      return null; // Return null for an empty list
    }
    Map<int, int> countMap = {};
    for (int value in valueTable) {
      countMap[value] = (countMap[value] ?? 0) + 1;
    }
    int dominantValue = countMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return dominantValue;
  }



  ChartContainer getchart(){
    switch(typeofchart){
      case "piechart": return ChartContainer(title: selectedValue, color: const Color(0xfff0f0f0) , chart: PieChartContent(valueTable: sortValueTable(valueTable, true),));
      case "kolumnowychart": return ChartContainer(title: selectedValue, color: const Color(0xfff0f0f0), chart: BarChartContent(valueTable: sortValueTable(valueTable, true),));
      case "linechart": return ChartContainer(title: selectedValue,color: const Color(0xfff0f0f0f),chart: LineChartContent(valueTable: sortValueTable(valueTable, true),));
      default: return ChartContainer(title: 'ErroredChart', color: const Color(0xfff0f0f0), chart: BarChartContent(valueTable: sortValueTable(valueTable, true),));
    }



  }



  void resolveTheme(){
    switch(themevalue){
      case "randomtheme": usertheme=randomTheme; break;
      case "weighttheme": usertheme=weightTheme; break;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: userTheme.backGroundColor,
      appBar: AppBar(
        title: Text("Prezentacja"),
      ),
      body: RawKeyboardListener(
        focusNode:FocusNode(),
        autofocus:true,

        onKey: (event){
          if(event.isKeyPressed(LogicalKeyboardKey.digit1)){
            selectedValue="Klasa 1";
            getHTTPGrades();
            setState(() {

            });

          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit2)){
            selectedValue="Klasa 2";
            getHTTPGrades();
            setState(() {

            });

          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit3)){
            selectedValue="Klasa 3";
            getHTTPGrades();
            setState(() {

            });

          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit4)){
            selectedValue="Klasa 4";
            getHTTPGrades();
            setState(() {

            });

          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit5)){
            selectedValue="Klasa 5";
            getHTTPGrades();
            setState(() {

            });

          }
          if(event.isKeyPressed(LogicalKeyboardKey.keyQ)){
            typeofchart="piechart";

            setState(() {

            });

          }
          if(event.isKeyPressed(LogicalKeyboardKey.keyW)){
            typeofchart="kolumnowychart";

            setState(() {

            });

          }
          if(event.isKeyPressed(LogicalKeyboardKey.keyE)){
            typeofchart="linechart";

            setState(() {

            });

          }


          if(event.isKeyPressed(LogicalKeyboardKey.keyA)){
            themevalue="randomtheme";

            setState(() {
              resolveTheme();
            });

          }


          if(event.isKeyPressed(LogicalKeyboardKey.keyS)){
            themevalue="weighttheme";

            setState(() {
              resolveTheme();
            });

          }




        },



        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [

                DropdownButton<String>(
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      getHTTPGrades();
                    });
                  },
                  items: <String>['Klasa 1', 'Klasa 2', 'Klasa 3', 'Klasa 4', 'Klasa 5']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                DropdownButton<String>(
                  value: typeofchart,
                  onChanged: (String? newValue) {
                    setState(() {
                      typeofchart = newValue!;
                    });
                  },
                  items: <String>['piechart', 'kolumnowychart', 'linechart']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                SizedBox(height: 16),


                DropdownButton<String>(
                  value: themevalue,
                  onChanged: (String? newValue) {
                    setState(() {
                      themevalue = newValue!;
                      resolveTheme();
                    });
                  },
                  items: <String>['randomtheme', 'weighttheme']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),





                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: askForGrades,
                    child: Icon(Icons.refresh),
                  ),
                ),

                getchart(),


                Align(
                    alignment: Alignment.center,
                    child:ExpandablePanel(
                        header: Text("Dane",textAlign: TextAlign.center,style: dataListStyle),
                        collapsed: Text(""),
                        expanded:Align(
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children:[
                                Text("Ilość opini: ${valueTable.length}",style: dataListStyle),
                                Text("Średnia: ${calculateAverage(valueTable)}",textAlign: TextAlign.center,style: dataListStyle),
                                Text("Dominanta: ${findDominantValue(valueTable)}",textAlign: TextAlign.center,style: dataListStyle),
                                Text("Wariancja: ${calculateVariance(valueTable)}",style: dataListStyle),
                                Text("Odchylenie standardowe: ${calculateStandardDeviation(valueTable)}",style: dataListStyle),
                                Text("Mediana: 5-6",style: dataListStyle),


                              ]

                          ),
                        )





                    )
                )
                ,


              ],
            ),
          ),
        ),
      ),
    );
  }}