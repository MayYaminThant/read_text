import 'package:flutter/cupertino.dart';

class SpeakController with ChangeNotifier {
  bool _isPause = false;
  String _string = "";

  SpeakController(this._isPause, this._string);

  bool get isPause => _isPause;

  setPause(bool isPause) {
    if (_isPause == isPause) {
      return;
    }

    _isPause = isPause;
    this.notifyListeners();
  }

  String getString() => this._string;

  setString(String string) {
    if (_string == string) {
      return;
    }

    _string = string;
    this.notifyListeners();
  }
}
