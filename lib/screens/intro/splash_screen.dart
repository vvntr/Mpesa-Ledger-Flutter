import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:mpesa_ledger_flutter/app.dart';
import 'package:mpesa_ledger_flutter/blocs/firebase/firebase_auth_bloc.dart';
import 'package:mpesa_ledger_flutter/blocs/runtime_permissions/runtime_permission_bloc.dart';
import 'package:mpesa_ledger_flutter/database/databaseProvider.dart';
import 'package:mpesa_ledger_flutter/services/firebase/firebase_auth.dart';
import 'package:mpesa_ledger_flutter/sms_filter/index.dart';
import 'package:mpesa_ledger_flutter/widgets/dialogs/alertDialog.dart';

class SplashScreen extends StatefulWidget {
  var runtimePermissionBloc = RuntimePermissionsBloc();
  var firebaseAuthBloc = FirebaseAuthBloc();
  var onAuthStateChanged = FirebaseAuthProvider();
  var databaseProvider = DatabaseProvider();
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.runtimePermissionBloc.dispose();
    widget.firebaseAuthBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.runtimePermissionBloc.permissionDenialStream.listen((data) {
      if (data) {
        return AlertDialogWidget(
          context,
          title: "SMS Permission",
          content: Text("To use MPESA LEDGER, allow SMS permissions"),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
              },
            ),
            FlatButton(
              child: Text("ALLOW PERMISSIONS"),
              onPressed: () {
                widget.runtimePermissionBloc.checkAndRequestPermissionSink
                    .add(null);
                Navigator.pop(context);
              },
            )
          ],
        ).show();
      }
    });

    widget.runtimePermissionBloc.openAppSettingsStream.listen((data) {
      if (data) {
        return AlertDialogWidget(
          context,
          title: "SMS Permission",
          content: Text(
              "To use MPESA LEDGER, allow SMS permissions are needed, please go to settings > Permissions and turn or SMS"),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
              },
            ),
            FlatButton(
              child: Text("TURN ON"),
              onPressed: () {
                SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
                AppSettings.openAppSettings();
              },
            )
          ],
        ).show();
      }
    });

    widget.runtimePermissionBloc.continueToAppStream.listen((void data) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (route) => App()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "TEST",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 45.0),
            ),
            Text(
              "TEST",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 45.0),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: widget.onAuthStateChanged.onAuthStateChanged,
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.data != null) {
                  return Column(
                    children: <Widget>[
                      CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                      GoogleSignInButton(
                        onPressed: () {
                          // widget.firebaseAuthBloc.signInSink.add(null);
                          SMSFilter sms = SMSFilter();
                          sms.getSMSObject();
                          // DatabaseProvider databaseProvider = DatabaseProvider();
                          // databaseProvider.select();
                        },
                      ),
                    ],
                  );
                } else {
                  // widget.runtimePermissionBloc.checkAndRequestPermissionSink
                  //     .add(null);
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}