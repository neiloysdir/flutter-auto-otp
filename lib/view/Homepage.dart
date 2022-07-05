import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_service/controller/data_fetcher.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataFetcher _dataFetcher = DataFetcher();
  TextEditingController? textEditingController1;

  String _comingSms = 'Unknown';

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(
      () {
        _comingSms = comingSms!;
        print("====>Message: $_comingSms");
        //depends on sms length
        print(_comingSms[29]);
        textEditingController1?.text = _comingSms[30] +
            _comingSms[31] +
            _comingSms[32] +
            _comingSms[33] +
            _comingSms[34] +
            _comingSms[
                35]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
      },
    );
  }

  @override
  void initState() {
    super.initState();
    textEditingController1 = TextEditingController();
    initSmsListener();
  }

  @override
  void dispose() {
    textEditingController1?.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            PinCodeTextField(
              appContext: context,
              pastedTextStyle: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
              ),
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 50,
                fieldWidth: 40,
                inactiveFillColor: Colors.white,
                inactiveColor: Colors.blueGrey,
                selectedColor: Colors.blueGrey,
                selectedFillColor: Colors.white,
                activeFillColor: Colors.white,
                activeColor: Colors.blueGrey,
              ),
              cursorColor: Colors.black,
              animationDuration: Duration(milliseconds: 300),
              enableActiveFill: true,
              controller: textEditingController1,
              keyboardType: TextInputType.number,
              boxShadows: [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
              onCompleted: (v) {
                //do something or move to next screen when code complete
              },
              onChanged: (value) {
                print(value);
                setState(() {
                  print('$value');
                });
              },
            ),
            MaterialButton(
              onPressed: () async {
                await _dataFetcher.sendOTP();
              },
              child: Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
