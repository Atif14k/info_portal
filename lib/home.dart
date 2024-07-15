import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:info_portal/add_info.dart';
import 'package:info_portal/database.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController location = TextEditingController();

  Stream? EmployeeStream;

  getonload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getonload();
    super.initState();
  }

  Widget allEmployeedetails() {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Name: " + ds["Name"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blue),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        name.text = ds["Name"];
                                        age.text = ds["Age"];
                                        location.text = ds["Location"];
                                        EditEmployeeDetail(ds["Id"]);
                                      },
                                      child: Icon(Icons.edit,
                                          color: Colors.orange)),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        await DatabaseMethods()
                                            .deleteEmployeeDetail(ds["Id"]);
                                      },
                                      child: Icon(Icons.delete,
                                          color: Colors.orange))
                                ],
                              ),
                              Text(
                                "Age: " + ds["Age"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.orange),
                              ),
                              Text(
                                "Location: " + ds["Location"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  Widget build(context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => InfoAdd()));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "INFO",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text("PORTAL",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
          ],
        )),
        body: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [Expanded(child: allEmployeedetails())],
            )));
  }

  Future EditEmployeeDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel)),
                      SizedBox(width: 60),
                      Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Details",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Name",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: name,
                        decoration: InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.name,
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Age",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: age,
                        decoration: InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.number,
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Location",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: location,
                        decoration: InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.streetAddress,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> updateInfo = {
                              "Name": name.text,
                              "Age": age.text,
                              "Id": id,
                              "Location": location.text
                            };
                            await DatabaseMethods()
                                .updateEmployeeDetail(updateInfo, id)
                                .then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Update")))
                ],
              ),
            ),
          ));
}
