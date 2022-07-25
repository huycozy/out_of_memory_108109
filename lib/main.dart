import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformChannel extends StatefulWidget {
  const PlatformChannel({super.key});

  @override
  State<PlatformChannel> createState() => _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  final MethodChannel _channel = MethodChannel('samples.flutter.io/pdf');
  int _pageCount = 0;
  ByteData? bytes;
  Uint8List? _documentBytes;

  Future<Uint8List> _readDocumentData() async {
    bytes = await DefaultAssetBundle.of(context)
        .load('assets/sample.pdf');
    return _documentBytes = bytes!.buffer.asUint8List();
  }

  Future<String?> initializePdfRenderer(Uint8List getBytes) async {
    return _channel.invokeMethod('initializePdfRenderer', <String, dynamic>{
      'documentBytes': getBytes,
    });
  }

  Future<void> result() async {
    Uint8List loadBytes = await _readDocumentData();
    final String? pageCount = await initializePdfRenderer(loadBytes);
    _pageCount = int.parse(pageCount!);
    print(_pageCount);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await result();
                  },
                  child: const Text('Get'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PlatformChannel()));
}