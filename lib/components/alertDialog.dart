// import 'package:flutter/material.dart';
//
// class Popup extends StatelessWidget {
//   const Popup({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Future<void> _showMyDialog(String input) async {
//       return showDialog<void>(
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(input.toString()),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: const <Widget>[
//                   Text('Would you like to approve of this message?'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Ok'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//         context: context,
//       );
//     }
//   }
// }
