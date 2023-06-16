import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:niqaash/chatApp/pages/splashScreen.dart';
import 'package:uuid/uuid.dart';

import 'chatApp/models/helper/FirebaseHelper.dart';
import 'chatApp/models/UserModel.dart';
import 'chatApp/pages/Post/HomeView.dart';
import 'firebase_options.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    // Logged In
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(
          MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    } else {
      runApp(const MyApp());
    }
  } else {
    // Not logged in
    runApp(const MyApp());
  }
}

// Not Logged In
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primaryColor: Colors.purple, primarySwatch: Colors.purple),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// Already Logged In
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primaryColor: Colors.purple, primarySwatch: Colors.purple),
      debugShowCheckedModeBanner: false,
      home: HomeView(userModel: userModel, firebaseUser: firebaseUser),
      // home: Home(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}
///////////////////////////////////
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:go_router/go_router.dart';
// import 'firebase_options.dart';
// import 'view/Home/homePage.dart';
// import 'package:flutter/services.dart';
// import 'view/auth/login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// /// The route configuration.
// final GoRouter _router = GoRouter(
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return const LoginPage();
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           path: 'details',
//           builder: (BuildContext context, GoRouterState state) {
//             return const PostCard();
//           },
//         ),
//       ],
//     ),
//   ],
// );

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // routerConfig: _router,
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // text fields' controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();

//   final CollectionReference _productss =
//       FirebaseFirestore.instance.collection('products');

//   // This function is triggered when the floatting button or one of the edit buttons is pressed
//   // Adding a product if no documentSnapshot is passed
//   // If documentSnapshot != null then update an existing product
//   Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
//     String action = 'create';
//     if (documentSnapshot != null) {
//       action = 'update';
//       _nameController.text = documentSnapshot['name'];
//       _priceController.text = documentSnapshot['price'].toString();
//     }

//     await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext ctx) {
//           return Padding(
//             padding: EdgeInsets.only(
//                 top: 20,
//                 left: 20,
//                 right: 20,
//                 // prevent the soft keyboard from covering text fields
//                 bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(labelText: 'Name'),
//                 ),
//                 TextField(
//                   keyboardType:
//                       const TextInputType.numberWithOptions(decimal: true),
//                   controller: _priceController,
//                   decoration: const InputDecoration(
//                     labelText: 'Price',
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                   child: Text(action == 'create' ? 'Create' : 'Update'),
//                   onPressed: () async {
//                     final String name = _nameController.text;
//                     final double? price =
//                         double.tryParse(_priceController.text);
//                     if (price != null) {
//                       if (action == 'create') {
//                         // Persist a new product to Firestore
//                         await _productss.add({"name": name, "price": price});
//                       }

//                       if (action == 'update') {
//                         // Update the product
//                         await _productss
//                             .doc(documentSnapshot!.id)
//                             .update({"name": name, "price": price});
//                       }

//                       // Clear the text fields
//                       _nameController.text = '';
//                       _priceController.text = '';

//                       // Hide the bottom sheet
//                       Navigator.of(context).pop();
//                     }
//                   },
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   // Deleteing a product by id
//   Future<void> _deleteProduct(String productId) async {
//     await _productss.doc(productId).delete();

//     // Show a snackbar
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('You have successfully deleted a product')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Kindacode.com'),
//       ),
//       // Using StreamBuilder to display all products from Firestore in real-time
//       body: StreamBuilder(
//         stream: _productss.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             return ListView.builder(
//               itemCount: streamSnapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 final DocumentSnapshot documentSnapshot =
//                     streamSnapshot.data!.docs[index];
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(documentSnapshot['name']),
//                     subtitle: Text(documentSnapshot['price'].toString()),
//                     trailing: SizedBox(
//                       width: 100,
//                       child: Row(
//                         children: [
//                           // Press this button to edit a single product
//                           IconButton(
//                               icon: const Icon(Icons.edit),
//                               onPressed: () =>
//                                   _createOrUpdate(documentSnapshot)),
//                           // This icon button is used to delete a single product
//                           IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () =>
//                                   _deleteProduct(documentSnapshot.id)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }

//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//       // Add new product
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _createOrUpdate(),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

//////////

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'firebase_options.dart';
// import 'socialMedia/components/life_cycle_event_handler.dart';
// import 'socialMedia/landing/landing_page.dart';
// import 'socialMedia/screens/mainscreen.dart';
// import 'socialMedia/services/user_service.dart';
// import 'socialMedia/utils/config.dart';
// import 'socialMedia/utils/constants.dart';
// import 'socialMedia/utils/providers.dart';
// import 'socialMedia/view_models/theme/theme_view_model.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Config.initFirebase();
//   // await Firebase.initializeApp();
//     await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   WidgetsBinding.instance.addObserver(
//   //     LifecycleEventHandler(
//   //       detachedCallBack: () => UserService().setUserStatus(false),
//   //       resumeCallBack: () => UserService().setUserStatus(true),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: providers,
//       child: Consumer<ThemeProvider>(
//         builder: (context, ThemeProvider notifier, Widget? child) {
//           return MaterialApp(
//             title: Constants.appName,
//             debugShowCheckedModeBanner: false,
//             theme: themeData(
//               notifier.dark ? Constants.darkTheme : Constants.lightTheme,
//             ),
//             home: StreamBuilder(
//               stream: FirebaseAuth.instance.authStateChanges(),
//               builder: ((BuildContext context, snapshot) {
//                 if (snapshot.hasData) {
//                   return const TabScreen();
//                 } else {
//                   return Landing();
//                 }
//               }),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   ThemeData themeData(ThemeData theme) {
//     return theme.copyWith(
//       textTheme: GoogleFonts.nunitoTextTheme(
//         theme.textTheme,
//       ),
//     );
//   }
// }
