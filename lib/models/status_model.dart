class StatusModel {
  String docid;
  String imageURL;
  String title;
  String desc;

  StatusModel({this.docid, this.imageURL, this.title, this.desc});

  toMap() {
    Map<String, dynamic> map = Map();

    map['docid'] = docid;
    map['imageURL'] = imageURL;
    map['title'] = title;
    map['desc'] = desc;

    return map;
  }
}
