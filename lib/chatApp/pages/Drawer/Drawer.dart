import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../auth/LoginPage.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // colors: [Colors.blue, Colors.green],
            colors: [
              Color(0xff3e428a),
              Color(0xff783b6e),
              Color(0xffce313a),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(Img.niqaashLogo),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(Img.unknownImage),
              ),
              title: const Text('Moazzam Ali'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DrawerPage(
                      profilePic: Img.unknownImage,
                      name: 'Moazzam Ali',
                      description: 'Description of Moazzam Ali',
                    ),
                  ),
                );
              },
            ),
            const DrawerPersons(
              name: 'Babar Saleem',
            ),
            const DrawerPersons(
              name: 'Ali Husnain',
            ),
            const DrawerPersons(
              name: 'Zeeshan Asghar',
            ),
            const DrawerPersons(
              name: 'Abdul Rehman',
            ),
            const DrawerPersons(
              name: 'Abdul Mueed',
            ),
            const DrawerPersons(
              name: 'Zulqarnain',
            ),
            const SizedBox(
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                color: Colors.black,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }),
                  );
                },
                child: const Text("Log out"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerPersons extends StatelessWidget {
  const DrawerPersons({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage(Img.unknownImage),
      ),
      title: Text(name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DrawerPage(
              profilePic: Img.unknownImage,
              name: name,
              description: 'Description of $name',
            ),
          ),
        );
      },
    );
  }
}

class DrawerPage extends StatelessWidget {
  final String profilePic;
  final String name;
  final String description;

  const DrawerPage({
    super.key,
    required this.profilePic,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(profilePic),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
