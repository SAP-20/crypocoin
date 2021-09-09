import 'package:crypcoin/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client httpClient;
  Web3Client ethClient;
  final myAddress="0x60956B24515a650C0479087bC14300995bcF6641";
  bool data = false ;
  int myAmt=0;
  var mydata;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpClient = Client();
    ethClient = Web3Client("https://mainnet.infura.io/v3/8c4b5a3dab544df6b02b24c81e57d0e3", httpClient);
    getBalance(myAddress);
  }
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0xd9145CCE52D386f254917e481eB44e9943F39138";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "PKCoin"),EthereumAddress.fromHex(contractAddress));
    return contract;
  }



  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await  loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(contract: contract,function: ethFunction, params: args);
    return result;
  }
  Future<void> getBalance(String targetAddress) async {
    List<dynamic> result = await query("getB"
        "balance",[]);
    mydata=result[0];
    data = true;
    setState(() {

    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: ZStack([
        VxBox().blue600.size(context.screenWidth, context.percentHeight * 30).make(),
        VStack([
          (context.percentHeight*10).heightBox,
          "\$CrypoCoin".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(
            child: VStack([
              "Balance".text.gray700.xl2.semiBold.makeCentered(),
              10.heightBox,
              data?"\$$mydata".text.bold.xl5.makeCentered().shimmer():CircularProgressIndicator().centered()
            ])
          )
          .p16.white.size(context.screenWidth,context.percentHeight * 18 ).rounded.shadowXl.make().p16(),
          SliderWidget(
            min: 0,
            max: 100,
            finalVal: (value) {
              myAmt = (value * 100) .round();
              print(myAmt);
            }
          ).centered(),
          HStack([
              FlatButton.icon(onPressed: () {},color: Colors.blue,shape: Vx.roundedSm, icon: Icon(Icons.refresh,color: Colors.white,), label: "Refresh".text.white.make()).h(50),
            FlatButton.icon(onPressed: () {},color: Colors.green,shape: Vx.roundedSm, icon: Icon(Icons.call_made_outlined,color: Colors.white,), label: "deposit".text.white.make()).h(50),
            FlatButton.icon(onPressed: () {},color: Colors.red,shape: Vx.roundedSm, icon: Icon(Icons.call_received,color: Colors.white,), label: "withdraw".text.white.make()).h(50),

          ],alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          ).p16()
        ])
      ]),
    );
  }
}
