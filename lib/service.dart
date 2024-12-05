class PersonModel {
  List<Person>? person;

  PersonModel({this.person});

  PersonModel.fromJson(Map<String, dynamic> json) {
    if (json['person'] != null) {
      person = <Person>[];
      json['person'].forEach((v) {
        person!.add(new Person.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.person != null) {
      data['person'] = this.person!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Person {
  String? id;
  String? name;
  int? age;

  Person({this.id, this.name, this.age});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    return data;
  }
}
