import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_room/Controller/controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Controller _controller = Get.put(Controller());
  final _messageCollection = FirebaseFirestore.instance.collection('chats');
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Public Chat Room', style: GoogleFonts.handlee()),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink,
                Colors.red,
                Colors.redAccent,
              ],
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      /// StreamBuilder is used to get the data from the firestore
      /// QuerySnapshot is a snapshot of the data from the firestore
      body: StreamBuilder<QuerySnapshot>(
        /// stream is used to get the data from the firestore via the collection
        stream: _messageCollection.snapshots(),
        // builder is used to build the listview/view
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final memoDocs = snapshot.data!.docs;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: memoDocs.length,
            itemBuilder: (context, index) {
              final memoDoc = memoDocs[index];

              return Dismissible(
                key: Key(memoDoc.id),
                onDismissed: (direction) =>
                    _messageCollection.doc(memoDoc.id).delete(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: SizedBox(
                        height: 30,
                        width: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.pink,
                                Colors.red,
                                Colors.redAccent,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              index.toString(),
                              style: GoogleFonts.handlee(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          memoDoc['message'],
                          style: GoogleFonts.handlee(),
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.date_range_rounded,
                                  size: 15, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                memoDoc['date'],
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.insert_drive_file,
                                  size: 15, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                memoDoc.id,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () {
                          _messageCollection.doc(memoDoc.id).delete();
                        },
                      ),
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Form(
                                key: key,
                                child: TextFormField(
                                  style: GoogleFonts.handlee(),
                                  maxLines: 1,
                                  initialValue: memoDoc['message'],
                                  onChanged: (value) {
                                    _messageCollection
                                        .doc(memoDoc.id)
                                        .update({'message': value});
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        style: GoogleFonts.handlee(),
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          labelStyle: GoogleFonts.handlee(),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return '*Required';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          _controller.message.value = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Send"),
                              SizedBox(width: 5),
                              Icon(Icons.send_rounded, size: 15),
                            ],
                          ),
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              key.currentState!.save();
                              Get.back();

                              _messageCollection.add(
                                {
                                'message': _controller.message.value,
                                'date':
                                    '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                              }
                              
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
