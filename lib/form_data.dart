import 'package:hive/hive.dart';
part 'form_data.g.dart';


@HiveType(typeId: 0)
class form_data{
        @HiveField(0)
        String name;
        @HiveField(1)
        String contact;
        @HiveField(2)
        String email;
        @HiveField(3)
        String passwrod;
        @HiveField(4)
        String city;
        @HiveField(5)
        String gender;
        @HiveField(6)
        String skill;
        @HiveField(7)
        String images;


        @override
        String toString() {
                return 'form_data{name: $name, contact: $contact, email: $email, passwrod: $passwrod, city: $city, gender: $gender, skill: $skill, images_1: $images}';
        }

        form_data(this.name, this.contact, this.email, this.passwrod, this.city, this.gender, this.skill, this.images);
}