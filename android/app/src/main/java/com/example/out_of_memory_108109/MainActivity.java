package com.example.out_of_memory_108109;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String METHOD_CHANNEL = "samples.flutter.io/pdf";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        new MethodChannel(flutterEngine.getDartExecutor(), METHOD_CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                         if(call.method.equals("initializePdfRenderer")){
                            result.success(initializePdfRenderer((byte[]) call.argument("documentBytes")));
                        }
                        else {
                            result.notImplemented();
                        }
                    }
                }
        );
    }

    String initializePdfRenderer(byte[] path) {
        try {
            File file = File.createTempFile(
                    ".viewer", ".pdf"
            );
            OutputStream stream = new FileOutputStream(file);
            stream.write(path);
            stream.close();
            return String.valueOf(1);
        } catch (Exception e) {
            return e.toString();
        }
    }
}