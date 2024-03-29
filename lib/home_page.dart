import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_app/post_details.dart';
import 'package:flutter_reddit_app/upload_post.dart';

class HomePage extends StatefulWidget {
  String email;
  String userImage;
  HomePage({this.email, this.userImage});
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String userName;
  String userImage;
  @override
  initState() {
    super.initState();
    Firestore.instance
        .collection('users')
        .where("email", isEqualTo: widget.email)
        .snapshots()
        .listen((onData) {
      setState(() {
        userImage = onData.documents[0].data['userImage'];
        userName = onData.documents[0].data['displayName'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(userName),
              accountEmail: new Text(widget.email),
              decoration: new BoxDecoration(
                color: Colors.orange[800],
              ),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(userImage)),
            ),
            new ListTile(
                leading: Icon(Icons.apps),
                title: new Text("Apps"),
                onTap: () {
                  Navigator.pop(context);
                }),
            new ListTile(
                leading: Icon(Icons.dashboard),
                title: new Text("Docs"),
                onTap: () {
                  Navigator.pop(context);
                }),
            new ListTile(
                leading: Icon(Icons.settings),
                title: new Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                }),
            new Divider(),
            new ListTile(
                leading: Icon(Icons.info),
                title: new Text("About"),
                onTap: () {
                  Navigator.pop(context);
                }),
            new ListTile(
                leading: Icon(Icons.power_settings_new),
                title: new Text("Logout"),
                onTap: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        centerTitle: true,
        title: Text(userName),
        // leading: InkWell(
        //     child: CircleAvatar(
        //       radius: 20.0,
        //       backgroundColor: const Color(0xFF778899),
        //       backgroundImage: NetworkImage(userImage),
        //     )),
      ),
      body: _buildBody(context, widget.email),
    );
  }

  Widget _buildBody(BuildContext context, String email) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('News_Feed').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return FirestoreListView(
            documents: snapshot.data.documents, email: email);
      },
    );
  }
}

class FirestoreListView extends StatefulWidget {
  List<DocumentSnapshot> documents;
  String email;

  FirestoreListView({this.documents, this.email});

  @override
  FirestoreListViewState createState() {
    return new FirestoreListViewState();
  }
}

class FirestoreListViewState extends State<FirestoreListView> {
  String image;
  String userId;
  String userImage;
  String userName;
  bool liked = false;
  int likes = 0;
  var userInfo;
  List<Comment> comments = [];

  @override
  initState() {
    super.initState();
    Firestore.instance
        .collection('users')
        .where("email", isEqualTo: widget.email)
        .snapshots()
        .listen((onData) {
      setState(() {
        userInfo = onData;
        userImage = onData.documents[0].data['userImage'];
        userName = onData.documents[0].data['displayName'];
        userId = onData.documents[0].data['uid'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.orange[400],
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.orange[800],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadPost(
                    documents: widget.documents, email: widget.email)),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        color: Colors.orange[100],
        child: ListView.builder(
            itemCount: widget.documents.length,
            itemExtent: media.size.height * .2,
            itemBuilder: (BuildContext context, int index) {
              String title = widget.documents[index].data['title'].toString();
              String description =
                  widget.documents[index].data['description'].toString();
              String image =
                  widget.documents[index].data['uploaderImage'].toString();
              String postedImage =
                  widget.documents[index].data['postedImage'].toString();
              String name = widget.documents[index].data['username'].toString();

              // String userImg = userInfo.do;
              return ListTile(
                title: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.cyan),
                        color: Colors.white),
                    padding: EdgeInsets.all(5.0),
                    margin: EdgeInsets.only(top: 5.0),
                    child: Stack(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: media.size.width * .2,
                              height: media.size.height * .1,
                              alignment: FractionalOffset.center,
                              decoration: new BoxDecoration(
                                  color:
                                      const Color.fromRGBO(247, 64, 106, 1.0),
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(5.0)),
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(postedImage))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                        width: media.size.width * .5,
                                        child: Text(
                                          title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    Container(
                                      width: media.size.width * .1,
                                      height: media.size.height * .05,
                                      alignment: FractionalOffset.center,
                                      decoration: new BoxDecoration(
                                          color: const Color.fromRGBO(
                                              247, 64, 106, 1.0),
                                          borderRadius: new BorderRadius.all(
                                              const Radius.circular(20.0)),
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(image))),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Expanded(
                                  child: Container(
                                    width: media.size.width * .5,
                                    child: Text(
                                      description,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          bottom: 0.0,
                          child: Container(
                            height: 30.0,
                            color: Colors.orange[800],
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "$likes Likes",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "${comments.length} comments",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.comment,
                                              color: Colors.white),
                                          onPressed: () {}),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostDetails(
                            documents: widget.documents,
                            index: index,
                            userImage: userImage,
                            userName: userName,
                            userId: userId)),
                  );
                },
              );
            }),
      ),
    );
  }
}
