import 'package:flutter/material.dart';

void main() => runApp(Home());
// List of items
List<String> list = [];
// Temporary variable for storing memo data
String memo;
// Form key (For Validation)
final GlobalKey<FormState> key = GlobalKey<FormState>();

class Home extends StatelessWidget {
  // Home Widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memo Pro',
      // Initial Route when App Starts
      initialRoute: '/',
      // Named Routes for all widgets in App
      routes: {
        // We can use any string instead of '\'
        '/': (context) => HomeScreen(), // Main Screen Route
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Function for deleting value from the list
  void delItem(int index) {
    setState(() {
      list.removeAt(index);
    });
    print(list); // For console logs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo Pro'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/memo.png',
          ),
        ),
      ),
      body: ListView.builder(
        // .length will automatically determine the size of list
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
            child: Card(
              elevation: 5.0,
              child: ListTile(
                // Smile, because it's good for health
                leading: Icon(
                  Icons.notes,
                  color: Colors.red,
                  // size: 40,
                ),
                // Icon Butoon to delete value at certain index
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    delItem(index);
                  },
                ),
                // Setting title to ListTile
                title: Text(
                  '${list[index]}',
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Floating Action Button to add values into the list
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
                        decoration: InputDecoration(
                          labelText: 'Memo',
                        ),
                        validator: (_val) {
                          if (_val.isEmpty) {
                            return '*Required';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (_val) {
                          memo = _val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RaisedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              Text("Add Memo"),
                            ],
                          ),
                          onPressed: () {
                            if (key.currentState.validate()) {
                              setState(() {
                                list.add(memo);
                              });
                              key.currentState.save();
                              Navigator.of(context).pop();
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
