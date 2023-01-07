import 'dart:typed_data';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

const String interceptJS ='''

var origOpen = XMLHttpRequest.prototype.open;
XMLHttpRequest.prototype.open = function() {
    this.addEventListener('load', function() {
        if (this.responseURL.includes('/kcsapi/')) {
            KcapiToFlutter(this);
        }
    });
    origOpen.apply(this, arguments);
};
function KcapiToFlutter(data) {
    kcMessage.postMessage("conning_tower_responseURL:"+data.responseURL+"conning_tower_readyState:"+data.readyState+"conning_tower_responseText:"+data.responseText+"conning_tower_END");
}

''';

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);

  return unit8List;
}
Future<WebResourceResponse?> interceptRequest(
    WebResourceRequest orgRequest) async {
    var kcResponse = await http.get(orgRequest.url, headers: orgRequest.headers);

    String temp = kcResponse.body + interceptJS;
    return WebResourceResponse(
        contentEncoding: 'gzip',
        contentType: 'application/javascript',
        data: convertStringToUint8List(temp),
        headers: kcResponse.headers,
        reasonPhrase: kcResponse.reasonPhrase,
        statusCode: kcResponse.statusCode);
}