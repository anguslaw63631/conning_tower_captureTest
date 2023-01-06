import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

void printUri(Uri input){
  print("WEB URI");
  print(input.authority);
  print(input.queryParameters);
  print(input.query);
  print(input.data);
  print(input.path);
  print(input.fragment);
  print(input.host);
  print(input.origin);
  print(input.userInfo);
  print(input.scheme);
  print(input.queryParametersAll);
  print("WEB END");
}

void printRequestInfo(WebResourceRequest request) {
  print("==========");
  print("KCA Request Info:");
  // print("KCA Request method:");
  // print(request.method);
  print("KCA Request headers:");
  print(request.headers);
  print("KCA Request url:");
  print(request.url);
  // print("KCA Request isRedirect:");
  // print(request.isRedirect);
  // print("KCA Request isForMainFrame:");
  // print(request.isForMainFrame);
  // print("KCA Request hasGesture:");
  // print(request.hasGesture);
  print("==========");
}

Uint8List stringToUint8List(String s){
  var encodedString = utf8.encode(s);
  var encodedLength = encodedString.length;
  var data = ByteData(encodedLength+4);
  data.setUint32(0, encodedLength,Endian.big);
  var bytes = data.buffer.asUint8List();
  bytes.setRange(4, encodedLength+4, encodedString);
  return bytes;

}

Future<WebResourceResponse?> interceptRequest(
    WebResourceRequest orgRequest) async {
  printRequestInfo(orgRequest);
  var kcResponse = await http.post(orgRequest.url, headers: orgRequest.headers);

  print("==========");
  print("KCA Response By http Info:");
  print("KCA Response headers:");
  print(kcResponse.headers);
  print("KCA Response request:");
  print(kcResponse.request);
  print("KCA Response reasonPhrase:");
  print(kcResponse.reasonPhrase);
  print("KCA Response contentLength:");
  print(kcResponse.contentLength);
  print("KCA Response isRedirect:");
  print(kcResponse.isRedirect);
  print("KCA Response persistentConnection:");
  print(kcResponse.persistentConnection);
  print("KCA Response body:");
  print(kcResponse.body);
  print("KCA Response statusCode:");
  print(kcResponse.statusCode);
  print("==========");

  return WebResourceResponse(
      contentEncoding: 'gzip',
      contentType: 'text/plain',
      data: kcResponse.bodyBytes,
      headers: kcResponse.headers,
      reasonPhrase: kcResponse.reasonPhrase,
      statusCode: kcResponse.statusCode);
}



Future<WebResourceResponse?> interceptRequestByDIO(
    WebResourceRequest orgRequest,Dio dio) async {
  printRequestInfo(orgRequest);
  Response kcResponse;
  print("start dio");

  Options dioOptions = Options(
    contentType: "application/x-www-form-urlencoded",
    followRedirects: false,
    headers: orgRequest.headers,
    method: 'POST',
  );

  try {
    // kcResponse = await dio.post(
    //   orgRequest.url.toString(),
    //   options:dioOptions,
    // queryParameters: orgRequest.url.queryParameters,
    // data: orgRequest.url.authority);
    kcResponse = await dio.postUri(orgRequest.url.uriValue,options: dioOptions);
  } on DioError catch (e) {
    // The request was made and the server responded with a status code
    if (e.response != null) {
      print("DIO Error(NOT NULL)");
      print(e.error);
      print(e.requestOptions);
      print(e.response);
      print(e.type);
      print(e.message);
      print(e.response?.statusCode);
      return null;
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print("DIO Error(NULL)");
      print(e.requestOptions);
      print(e.message);
      return null;
    }
  }
  print("==========");
  print("KCA Response By DIO:");
  print("KCA Response statusCode:");
  print(kcResponse.statusCode);
  // print("KCA Response isRedirect:");
  // print(kcResponse.isRedirect);
  print("KCA Response headers:");
  print(kcResponse.headers);
  print("KCA Response statusMessage:");
  print(kcResponse.statusMessage);
  print("KCA Response data:");
  print(kcResponse.data);
  // print("KCA Response redirects:");
  // print(kcResponse.redirects);
  // print("KCA Response extra:");
  // print(kcResponse.extra);
  // print("KCA Response requestOptions:");
  // print(kcResponse.requestOptions);
  print("==========");
  return WebResourceResponse(
      contentEncoding: 'gzip',
      contentType: 'text/plain',
      data: stringToUint8List(kcResponse.data),
      statusCode: kcResponse.statusCode,);
}

// Future<WebResourceResponse?> interceptRequestByHttpclient(
//     WebResourceRequest orgRequest) async {
//   Future<WebResourceResponse?> kcResponseForReturn;
//   printRequestInfo(orgRequest);
//   var client = HttpClient();
//   try {
//     HttpClientRequest request = await client.postUrl(orgRequest.url);
//
//     HttpClientResponse kcResponse = await request.close();
//
//     // Process the response
//     var kcResponseBody = await kcResponse.transform(utf8.decoder).join();
//     Uint8List result = json.decode(kcResponseBody);
//
//     print("==========");
//     print("KCA Response By HttpClient:");
//     print("KCA Response redirects:");
//     print(kcResponse.redirects);
//     print("KCA Response headers:");
//     print(kcResponse.headers);
//     print("KCA Response isRedirect:");
//     print(kcResponse.isRedirect);
//     print("KCA Response statusCode:");
//     print(kcResponse.statusCode);
//     print("KCA Response certificate:");
//     print(kcResponse.certificate);
//     print("KCA Response compressionState:");
//     print(kcResponse.compressionState);
//     print("KCA Response connectionInfo:");
//     print(kcResponse.connectionInfo);
//     print("KCA Response contentLength:");
//     print(kcResponse.contentLength);
//     print("KCA Response cookies:");
//     print(kcResponse.cookies);
//     print("KCA Response persistentConnection:");
//     print(kcResponse.persistentConnection);
//     print("KCA Response reasonPhrase:");
//     print(kcResponse.reasonPhrase);
//     print("KCA Response first:");
//     print(kcResponse.first);
//     print("KCA Response isBroadcast:");
//     print(kcResponse.isBroadcast);
//     print("KCA Response last:");
//     print(kcResponse.last);
//     print("KCA Response length:");
//     print(kcResponse.length);
//     print("KCA Response single:");
//     print(kcResponse.single);
//     print("==========");
//
//     kcResponseForReturn = WebResourceResponse(
//         contentEncoding: 'gzip',
//         contentType: 'text/plain',
//         data: result,
//         statusCode: kcResponse.statusCode) as Future<WebResourceResponse?>;
//   } finally {
//     client.close();
//   }
//   return kcResponseForReturn;
// }
