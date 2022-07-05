import 'package:dio/dio.dart';
import 'connection_helper.dart';

class DataFetcher {
  final ConnectionHelper _connectionHelper = ConnectionHelper();
  //TODO: Give necessary inputs
  Future<bool> sendOTP() async {
    dynamic data = {"email": "inputemail"};
    Response<dynamic>? response = await _connectionHelper.postData(
      "inputAPIUrl",
      data,
    );
    if (response != null && response.statusCode == 201) {
      try {
        return true;
      } catch (e) {
        print(e);
      }
    }
    return false;
  }
}
