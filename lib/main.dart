import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'app',
          theme: ThemeData(
            primaryColor: Colors.grey[200],
          ),
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// 뉴모피즘 변수 값
  final off1 = -2.0;
  final off2 = 2.0;
  final blurR = 2.0;
  final spredR = 2.0;

//

  bool cred = false; //신용카드 공제 조건식

  bool click = false; //계산 버튼 애니메이션 변수

  var comma = NumberFormat('###,### 원'); //콤마 찍는 변수

  var t1 = TextEditingController(); //매출 입력칸
  var t2 = TextEditingController(); // 식자재 지출 입력칸
  var t3 = TextEditingController(); //  그외 지출 입력칸

  double taxincome = 0; //매출 과세표준
  double taxspending = 0; // 지출 과세표준
  double creditcard_help = 0; // 신용카드공제
  double spending_Food_help = 0; //의제 매입 공제
  double estimate_tax =
      0; //예상 부가세  = (t1 *1/10) - (t3 *1/10) - (t1 *13/1000) - (t2*9/109)
  double overcreditcard_help = 10000000;

//컨트롤러 초기화
  @override
  void initState() {
    t1 = TextEditingController();
    t2 = TextEditingController();
    t3 = TextEditingController();
    super.initState();
  }

  // 컨트롤러 메모리 누수 막기 위해
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
    var t1text = t1.text;
    var t1convert = t1text.replaceAll(",", "");
    var income = double.parse(t1convert);

    var t2text = t2.text;
    var t2convert = t2text.replaceAll(",", "");
    var spending_Food = double.parse(t2convert);

    var t3text = t3.text;
    var t3convert = t3text.replaceAll(",", "");
    var spending_Product = double.parse(t3convert);

    taxincome = income * 1 / 10;
    spending_Food_help = spending_Food * 9 / 109;
    taxspending = spending_Product * 1 / 10;
    creditcard_help = income * 13 / 1000;

    //신용카드공제, 의제매입공제 조건식
    if (creditcard_help > 10000000) {
      creditcard_help = 10000000;
    }

    estimate_tax =
        taxincome - taxspending - creditcard_help - spending_Food_help;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              setState(() {
                FocusScope.of(context).unfocus();
              });
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '23년 일반사업자 음식점 부가세 계산기',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(off2, off2),
                          color: Colors.black38,
                          blurRadius: blurR,
                          spreadRadius: spredR,
                        ),
                        BoxShadow(
                          offset: Offset(off1, off1),
                          color: Colors.white70,
                          blurRadius: blurR,
                          spreadRadius: spredR,
                        )
                      ],
                    ),
                    width: ScreenUtil().setWidth(360),
                    height: ScreenUtil().setHeight(120),
                    child: Text(
                      ' ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    maxLength: 11,
                    controller: t1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    inputFormatters: [ThousandsFormatter()],
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: ' 매 출 : 신용카드, 배달어플, 현금영수증',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLength: 11,
                    controller: t2,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    inputFormatters: [ThousandsFormatter()],
                    decoration: InputDecoration(
                        counterText: "", hintText: '지출 1 :  농축산물,   식자재,   면세물품'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLength: 11,
                    controller: t3,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    inputFormatters: [ThousandsFormatter()],
                    decoration: InputDecoration(
                        counterText: "", hintText: '지출 2 : 공산품, 배달대행, 광고비,월세'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        click = !click;
                        convertStringtoDouble();

                        FocusScope.of(context).unfocus(); //키보드 내리는 함수
                      });
                    },
                    child: AnimatedContainer(
                        child: Icon(
                          Icons.currency_exchange_sharp,
                          color: Colors.blue,size:ScreenUtil().setSp(30),
                        ),
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(70),
                        duration: Duration(milliseconds: 1),
                        curve: Curves.easeInBack,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: click
                                ? null
                                : [
                                    BoxShadow(
                                      offset: Offset(off2, off2),
                                      color: Colors.black38,
                                      blurRadius: blurR,
                                      spreadRadius: spredR,
                                    ),
                                    BoxShadow(
                                      offset: Offset(off1, off1),
                                      color: Colors.white70,
                                      blurRadius: blurR,
                                      spreadRadius: spredR,
                                    )
                                  ])),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: ScreenUtil().setHeight(20),
                        width: ScreenUtil().setWidth(120),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(off2, off2),
                                  color: Colors.black38,
                                  blurRadius: blurR,
                                  spreadRadius: spredR),
                              BoxShadow(
                                  offset: Offset(off1, off1),
                                  color: Colors.white70,
                                  blurRadius: blurR,
                                  spreadRadius: spredR)
                            ]),
                        child: Text(
                          '매출 과세표준',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setHeight(20),
                          child: Text(
                            comma.format(taxincome),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12),
                                color: Colors.black54),
                            textAlign: TextAlign.end,
                          )), //taxincome
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: ScreenUtil().setHeight(20),
                        width: ScreenUtil().setWidth(120),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(off2, off2),
                                  color: Colors.black38,
                                  blurRadius: blurR,
                                  spreadRadius: spredR),
                              BoxShadow(
                                  offset: Offset(off1, off1),
                                  color: Colors.white70,
                                  blurRadius: blurR,
                                  spreadRadius: spredR)
                            ]),
                        child: Text(
                          '지출 과세표준',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setHeight(20),
                          child: Text(
                            comma.format(taxspending),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12),
                                color: Colors.black54),
                            textAlign: TextAlign.end,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: ScreenUtil().setHeight(20),
                        width: ScreenUtil().setWidth(120),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(off2, off2),
                                  color: Colors.black38,
                                  blurRadius: blurR,
                                  spreadRadius: spredR),
                              BoxShadow(
                                  offset: Offset(off1, off1),
                                  color: Colors.white70,
                                  blurRadius: blurR,
                                  spreadRadius: spredR)
                            ]),
                        child: Text(
                          '신용카드공제',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12)
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setHeight(20),
                          child: Text(
                            comma.format(creditcard_help),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12),
                                color: Colors.black54),
                            textAlign: TextAlign.end,
                          )),
                      //신용카드 공제 매출의 1.3%
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height:ScreenUtil().setHeight(20),
                        width: ScreenUtil().setWidth(120),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(off2, off2),
                                  color: Colors.black38,
                                  blurRadius: blurR,
                                  spreadRadius: spredR),
                              BoxShadow(
                                  offset: Offset(off1, off1),
                                  color: Colors.white70,
                                  blurRadius: blurR,
                                  spreadRadius: spredR)
                            ]),
                        child: Text(
                          '의제매입공제',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12)
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setHeight(20),
                          child: Text(
                            comma.format(spending_Food_help),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12),
                                color: Colors.black54),
                            textAlign: TextAlign.end,
                          )),
                      //의제매입공제 식자재 매출의 2억미만 8.26% , 2억 초과 7.24%
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: ScreenUtil().setHeight(20),
                        width:ScreenUtil().setWidth(120),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(off2, off2),
                                  color: Colors.black38,
                                  blurRadius: blurR,
                                  spreadRadius: spredR),
                              BoxShadow(
                                  offset: Offset(off1, off1),
                                  color: Colors.white70,
                                  blurRadius: blurR,
                                  spreadRadius: spredR)
                            ]),
                        child: Text(
                          '예상 부가세',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12)
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setHeight(20),
                          child: Text(
                            comma.format(estimate_tax),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12),
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.end,
                          )),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
