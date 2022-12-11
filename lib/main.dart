import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';




void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'app',
      theme: ThemeData(
        primaryColor: Colors.grey[200],
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool click = false; //계산 버튼 애니메이션 변수

  var comma = NumberFormat('###,### 원'); //콤마 찍는 변수

  //final comma = NumberFormat("###,###,###,### 원"); //콤마 관련 변수 선언

  var t1 = TextEditingController();
  var t2 = TextEditingController();
  var t3 = TextEditingController();




  double taxincome = 0;
  double taxspending = 0;
  double creditcard_help = 0;
  double spending_Food_help = 0;
  double estimate_tax = 0;


  @override
  void initState() {

     t1 = TextEditingController();
     t2 =TextEditingController();
     t3 =TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    t1.dispose();
    t2.dispose();
    t3.dispose();
  }

//1.콤마를 추가하면서 문자가 된 숫자 값을 replaceAll을 이용해 콤마를 제거해준다.
  //2. 콤마를 제거한 숫자 값을 double.parse로 변환해준다.
  //3. double로 된 숫자 값을 해당 변수에 넣어주고 계산식을 적용한다.
  void convertStringtoDouble() {
    var t1text =t1.text;
    var t1convert= t1text.replaceAll(",", "");
    var income=double.parse(t1convert);

    var t2text =t2.text;
    var t2convert = t2text.replaceAll(",","");
    var spending_Food =double.parse(t2convert);

    var t3text = t3.text;
    var t3convert = t3text.replaceAll(",", "");
    var spending_Product =double.parse(t3convert);


        taxincome = income * 1/10;
        spending_Food_help = spending_Food * 9/109;
        taxspending = spending_Product *1/10;
        creditcard_help = spending_Product *13/1000;
        estimate_tax = (income *1/10) -(spending_Product*1/10) -(spending_Product*13/1000) -(spending_Food*75/1000);

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          '23년 일반사업자 음식점 부가세계산기',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(
              5,
            )),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(16, 16),
                    color: Colors.black38,
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    offset: Offset(-16, -16),
                    color: Colors.white70,
                    blurRadius: 16,
                    spreadRadius: 2,
                  )
                ],
              ),
              width: 360,
              height: 120,
              child: Text('사용방법 : '),
            ),
            SizedBox(
              height: 20,
            ),

            TextField(
              controller: t1,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              inputFormatters: [ThousandsFormatter()],




            ),

            TextField(
              controller: t2,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              inputFormatters: [ThousandsFormatter()],

            ),
            TextField(
              controller: t3,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              inputFormatters: [ThousandsFormatter()],
              ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  click = !click;

                   convertStringtoDouble();

                  //taxcalcualtor();
                });
              },
              child: AnimatedContainer(
                  child: Icon(
                    Icons.currency_exchange_sharp,
                    color: Colors.white,
                  ),
                  height: 50,
                  width: 70,
                  duration: Duration(milliseconds: 1),
                  curve: Curves.easeInBack,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: click
                          ? null
                          : [
                              BoxShadow(
                                offset: Offset(16, 16),
                                color: Colors.black38,
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                offset: Offset(-10, -10),
                                color: Colors.white70,
                                blurRadius: 16,
                                spreadRadius: 2,
                              )
                            ])),
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.black38,
                            blurRadius: 16,
                            spreadRadius: 2),
                        BoxShadow(
                            offset: Offset(-10, -10),
                            color: Colors.white70,
                            blurRadius: 16,
                            spreadRadius: 2)
                      ]),
                  child: Text(
                    '매출 과세표준',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Text(comma.format(taxincome)), //taxincome
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.black38,
                            blurRadius: 16,
                            spreadRadius: 2),
                        BoxShadow(
                            offset: Offset(-10, -10),
                            color: Colors.white70,
                            blurRadius: 16,
                            spreadRadius: 2)
                      ]),
                  child: Text(
                    '지출 과세표준',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Text(comma.format(taxspending)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.black38,
                            blurRadius: 16,
                            spreadRadius: 2),
                        BoxShadow(
                            offset: Offset(-10, -10),
                            color: Colors.white70,
                            blurRadius: 16,
                            spreadRadius: 2)
                      ]),
                  child: Text(
                    '신용카드 공제',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Text(comma.format(creditcard_help)),
                //신용카드 공제 매출의 1.3%
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.black38,
                            blurRadius: 16,
                            spreadRadius: 2),
                        BoxShadow(
                            offset: Offset(-10, -10),
                            color: Colors.white70,
                            blurRadius: 16,
                            spreadRadius: 2)
                      ]),
                  child: Text(
                    '식자재매입공제',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Text(comma.format(spending_Food_help)),
                //의제매입공제 식자재 매출의 2억미만 8.26% , 2억 초과 7.24%
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 0),
                            color: Colors.black38,
                            blurRadius: 16,
                            spreadRadius: 2),
                        BoxShadow(
                            offset: Offset(-10, -10),
                            color: Colors.white70,
                            blurRadius: 16,
                            spreadRadius: 2)
                      ]),
                  child: Text(
                    '예상 부가세',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Text(comma.format(estimate_tax)),
              ],
            ),

            //제스쳐 디텍터, 애니매이션 컨테이너,
          ],
        ),
      )
          // (매출*1/10) - (공산품+서비스+광고비 지출 * 1/10) - 신용카드공제 - 의제매입공제

          ),
    );
  }
}
