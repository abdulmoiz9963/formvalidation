import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Information Form',
      home: StudentForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, String>> _students = [];
  int? _editingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00BFA5), Color(0xFF00695C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 600,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Color(0xFF004D40),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Student Information Form',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildTextField(_firstNameController, 'First Name', 'Please enter your first name'),
                            SizedBox(height: 20.0),
                            _buildTextField(_lastNameController, 'Last Name', 'Please enter your last name'),
                            SizedBox(height: 20.0),
                            _buildTextField(_emailController, 'Email Address', 'Please enter a valid email address', isEmail: true),
                            SizedBox(height: 20.0),
                            _buildTextField(_rollNoController, 'Roll Number', 'Please enter your roll number'),
                            SizedBox(height: 20.0),
                            _buildTextField(_phoneController, 'Phone Number', 'Please enter a valid phone number', isPhone: true),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    if (_editingIndex == null) {
                                      // Add new student
                                      _students.add({
                                        'firstName': _firstNameController.text,
                                        'lastName': _lastNameController.text,
                                        'email': _emailController.text,
                                        'rollNo': _rollNoController.text,
                                        'phone': _phoneController.text,
                                      });
                                    } else {
                                      // Edit existing student
                                      _students[_editingIndex!] = {
                                        'firstName': _firstNameController.text,
                                        'lastName': _lastNameController.text,
                                        'email': _emailController.text,
                                        'rollNo': _rollNoController.text,
                                        'phone': _phoneController.text,
                                      };
                                      _editingIndex = null;
                                    }
                                    _firstNameController.clear();
                                    _lastNameController.clear();
                                    _emailController.clear();
                                    _rollNoController.clear();
                                    _phoneController.clear();
                                  });
                                }
                              },
                              child: Text(
                                _editingIndex == null ? 'SUBMIT' : 'UPDATE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00BFA5),
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                textStyle: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 600,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: _students
                            .asMap()
                            .entries
                            .map(
                              (entry) => ListTile(
                                title: Text(
                                  '${entry.key + 1}. ${entry.value['firstName']} ${entry.value['lastName']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  'Email: ${entry.value['email']}\nRoll No: ${entry.value['rollNo']}\nPhone: ${entry.value['phone']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          _firstNameController.text = entry.value['firstName']!;
                                          _lastNameController.text = entry.value['lastName']!;
                                          _emailController.text = entry.value['email']!;
                                          _rollNoController.text = entry.value['rollNo']!;
                                          _phoneController.text = entry.value['phone']!;
                                          _editingIndex = entry.key;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _students.removeAt(entry.key);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String validationMsg, {bool isEmail = false, bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Color(0xFF004D40),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMsg;
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (isPhone && !RegExp(r'^\d{11}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }
}
