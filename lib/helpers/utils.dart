import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class Utils {
  static provider(BuildContext context, {bool listen: false}) =>
      Provider.of<AuthProvider>(context, listen: listen);
}
