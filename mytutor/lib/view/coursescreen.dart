import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mytutor/model/config.dart';
import 'package:mytutor/view/cartscreen.dart';
import 'package:mytutor/view/tutorscreen.dart';
import 'package:mytutor/view/subscribescreen.dart';
import 'package:mytutor/view/favouritescreen.dart';
import 'package:mytutor/view/loginpage.dart';
import 'package:mytutor/view/profilescreen.dart';
import 'package:ndialog/ndialog.dart';

import '../model/config.dart';
import '../model/user.dart';
import '../model/course.dart';
import '../model/cart.dart';

class CourseScreen extends StatefulWidget {
  final User user;
  const CourseScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<Course> courselist = <Course>[];

  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  //int numofitem = 0;
  var color;
  int cart = 0;
  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    _loadCourse(1, search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => CartScreen(
                            user: widget.user,
                          )));
              _loadCourse(1, search);
              _loadMyCart();
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(widget.user.cart.toString(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.name.toString()),
              accountEmail: Text(widget.user.email.toString()),
            ),
            _createDrawerItem(
              icon: Icons.library_books,
              text: 'Courses',
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CourseScreen(user: widget.user)))
              },
            ),
            _createDrawerItem(
              icon: Icons.school,
              text: 'Tutors',
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => tutorScreen(user: widget.user)))
              },
            ),
            _createDrawerItem(
              icon: Icons.control_point,
              text: 'Subscibe',
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const SubscribeScreen()))
              },
            ),
            _createDrawerItem(
              icon: Icons.bookmark,
              text: 'Favourite',
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const FavouriteScreen()))
              },
            ),
            _createDrawerItem(
                icon: Icons.person,
                text: 'My Profile',
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const ProfileScreen()))
                    }),
          ],
        ),
      ),
      body: courselist.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)))
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Course ",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 1),
                      children: List.generate(courselist.length, (index) {
                        return InkWell(
                          splashColor: Colors.amber,
                          onTap: () => {_loadCourseDetails(index)},
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: MyConfig.server +
                                      "/Mobile_lab3/assets/courses/" +
                                      courselist[index].subjectId.toString() +
                                      '.jpg',
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Text(
                                courselist[index].subjectName.toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: Column(children: [
                                              Text("RM " +
                                                  double.parse(courselist[index]
                                                          .subjectPrice
                                                          .toString())
                                                      .toStringAsFixed(2)),
                                              Text(courselist[index]
                                                      .subjectSessions
                                                      .toString() +
                                                  " classes"),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          )),
                        );
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadCourse(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void _loadCourse(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(MyConfig.server + "/Mobile_lab3/php/subjectscreen.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['Course'] != null) {
          courselist = <Course>[];
          extractdata['Course'].forEach((v) {
            courselist.add(Course.fromJson(v));
          });
        } else {
          titlecenter = "No Course Available";
        }
        setState(() {});
      } else {
        setState(() {
          if (courselist.isEmpty) {
            titlecenter = "No Course Available";
          }
        });
      }
    });
  }

  _loadCourseDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Course Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: MyConfig.server +
                      "/Mobile_lab3/assets/courses/" +
                      courselist[index].subjectId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  courselist[index].subjectName.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Course Description: \n" +
                      courselist[index].subjectDescription.toString()),
                  Text("Price: RM " +
                      double.parse(courselist[index].subjectPrice.toString())
                          .toStringAsFixed(2)),
                  Text("Session Available: " +
                      courselist[index].subjectSessions.toString() +
                      " classes"),
                  Text(
                      "Rating : " + courselist[index].subjectRating.toString()),
                ]),
              ],
            )),
          );
        });
  }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadCourse(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  void _loadMyCart() {
    http
        .post(
            Uri.parse(MyConfig.server + "/Mobile_lab3/php/load_mycartqty.php"))
        .timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {});
      }
    });
  }

  _addtocartDialog(int index) {
    _addtoCart(index);
  }

  void _addtoCart(int index) {
    http.post(Uri.parse(MyConfig.server + "/Mobile_lab3/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subject_id": courselist[index].subjectId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
