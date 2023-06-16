import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:niqaash/chatApp/models/UserModel.dart';

import '../../../constants/constants.dart';
import '../Drawer/Drawer.dart';
import '../chatPages/ChatPage.dart';
import 'PostPage.dart';

//

class HomeView extends StatefulWidget {
  const HomeView(
      {super.key, required this.firebaseUser, required this.userModel});
  final UserModel userModel;
  final User firebaseUser;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double? _rating;

  IconData? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // bottom: const TabBar(
          //   indicatorSize: TabBarIndicatorSize.label,
          //   tabs: [
          //     Tab(icon: Icon(Icons.flight)),
          //     Tab(icon: Icon(Icons.directions_transit)),
          //     Tab(icon: Icon(Icons.directions_car)),
          //   ],
          // ),
          title: const Text('Niqaash'),
          actions: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatViewPage(
                            userModel: widget.userModel,
                            firebaseUser: widget.firebaseUser)));
                // Perform search action
              },
            ),
          ],
        ),
        // body: const TabBarView(
        //   children: [
        //     Icon(Icons.flight, size: 350),
        //     Icon(Icons.directions_transit, size: 350),
        //     Icon(Icons.directions_car, size: 350),
        //   ],
        // ),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("posts").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> userMap =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          // var date = DateTime.fromMicrosecondsSinceEpoch( );
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage(Img.unknownImage),
                                    ),
                                    title: Text(widget.userModel.fullname!),
                                    subtitle: Text(DateTime.parse(
                                            userMap["postTime"]
                                                .toDate()
                                                .toString())
                                        .toString()),
                                    trailing: PopupMenuButton<String>(
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          const PopupMenuItem<String>(
                                            value: 'report',
                                            child: Text('Report'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'hide',
                                            child: Text('Hide'),
                                          ),
                                        ];
                                      },
                                      onSelected: (String value) {
                                        // Handle popup menu actions
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              height: 250,
                                              width: 320,
                                              child: Center(
                                                child: Image.network(
                                                  userMap["postImg"],
                                                  fit: BoxFit.fill,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),

                                            // Image(
                                            //   height: 250,
                                            //   width: 320,
                                            //   fit: BoxFit.cover,
                                            //   image: NetworkImage(
                                            //       userMap["postImg"]),
                                            //   // image: AssetImage(Img.post10),
                                            // ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: RatingBarIndicator(
                                                rating: 2,
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 40,
                                                direction: Axis.vertical,
                                              ),
                                            ),
                                            const SizedBox(
                                                width: 50,
                                                child: Divider(thickness: 3)),
                                            ElevatedButton(
                                                onPressed: () {},
                                                child:
                                                    const Icon(Icons.comment))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(thickness: 3),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle chat button press
                                    },
                                    child: const Icon(Icons.heart_broken),
                                  ),
                                ],
                              ),
                            ),
                          );

                          // return ListTile(
                          //   leading: CircleAvatar(
                          //     backgroundImage: NetworkImage(userMap["postImg"]),
                          //   ),
                          //   // title: Text(userMap["name"] + " (${userMap["age"]})"),
                          //   // subtitle: Text(userMap["email"]),
                          //   trailing: IconButton(
                          //     onPressed: () {
                          //       // Delete
                          //     },
                          //     icon: const Icon(Icons.delete),
                          //   ),
                          // );
                        },
                      ),
                    );
                  } else {
                    return const Text("No data!");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),

        // Column(
        //   children: [
        //     Card(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.stretch,
        //         children: [
        //           ListTile(
        //             leading: const CircleAvatar(
        //               backgroundImage: AssetImage(Img.unknownImage),
        //             ),
        //             title: const Text('John Doe'),
        //             subtitle: const Text('2 hours ago'),
        //             trailing: PopupMenuButton<String>(
        //               itemBuilder: (BuildContext context) {
        //                 return [
        //                   const PopupMenuItem<String>(
        //                     value: 'report',
        //                     child: Text('Report'),
        //                   ),
        //                   const PopupMenuItem<String>(
        //                     value: 'hide',
        //                     child: Text('Hide'),
        //                   ),
        //                 ];
        //               },
        //               onSelected: (String value) {
        //                 // Handle popup menu actions
        //               },
        //             ),
        //           ),
        //           SizedBox(
        //             child: Row(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 const SizedBox(
        //                   child: Padding(
        //                     padding: EdgeInsets.only(right: 8),
        //                     child: Image(
        //                       height: 250,
        //                       width: 320,
        //                       fit: BoxFit.cover,
        //                       image: AssetImage(Img.post10),
        //                     ),
        //                   ),
        //                 ),
        //                 Column(
        //                   children: [
        //                     Padding(
        //                       padding:
        //                           const EdgeInsets.symmetric(horizontal: 8),
        //                       child: RatingBarIndicator(
        //                         rating: 2,
        //                         itemBuilder: (context, index) => const Icon(
        //                           Icons.star,
        //                           color: Colors.amber,
        //                         ),
        //                         itemCount: 5,
        //                         itemSize: 40,
        //                         direction: Axis.vertical,
        //                       ),
        //                     ),
        //                     const SizedBox(
        //                         width: 50, child: Divider(thickness: 3)),
        //                     ElevatedButton(
        //                         onPressed: () {}, child: const Text("data"))
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //           const Divider(thickness: 3),
        //           ElevatedButton(
        //             onPressed: () {
        //               // Handle chat button press
        //             },
        //             child: const Text('Chat'),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(
                    firebaseUser: widget.firebaseUser,
                    userModel: widget.userModel,
                  ),
                ));
          },
          label: const Text("Post"),
          // child: const,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
// class WhatsAppAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const WhatsAppAppBar({super.key});

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: const Text('WhatsApp'),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search),
//           onPressed: () {
//             // Perform search action
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.more_vert),
//           onPressed: () {
//             // Open more options menu
//           },
//         ),
//       ],
//     );
//   }
// }
