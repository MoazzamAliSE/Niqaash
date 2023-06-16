// class PostModel {
//   String postId;
//   String userId;
//   String text;
//   List<CommentModel> comments;
//   List<String> likedBy;
//   Map<String, int> ratings;

//   PostModel({
//     required this.postId,
//     required this.userId,
//     required this.text,
//     required this.comments,
//     required this.likedBy,
//     required this.ratings,
//   });

//   factory PostModel.fromMap(Map<String, dynamic> map) {
//     List<dynamic> commentsData = map['comments'] ?? [];
//     List<CommentModel> comments = commentsData
//         .map((comment) => CommentModel.fromMap(comment))
//         .toList();

//     Map<String, dynamic> ratingsData = map['ratings'] ?? {};
//     Map<String, int> ratings = ratingsData.cast<String, int>();

//     return PostModel(
//       postId: map['postId'],
//       userId: map['userId'],
//       text: map['text'],
//       comments: comments,
//       likedBy: List<String>.from(map['likedBy']),
//       ratings: ratings,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'postId': postId,
//       'userId': userId,
//       'text': text,
//       'comments': comments.map((comment) => comment.toMap()).toList(),
//       'likedBy': likedBy,
//       'ratings': ratings,
//     };
//   }

//   bool isSeenByUser(String userId) {
//     return likedBy.contains(userId);
//   }

//   void markAsSeenByUser(String userId) {
//     if (!likedBy.contains(userId)) {
//       likedBy.add(userId);
//     }
//   }

//   void markAsUnseenByUser(String userId) {
//     likedBy.remove(userId);
//   }

//   double calculateAverageRating() {
//     if (ratings.isEmpty) {
//       return 0.0;
//     }

//     int totalRating = 0;
//     ratings.forEach((_, rating) {
//       totalRating += rating;
//     });

//     return totalRating / ratings.length;
//   }

//   List<String> getUsersWithRating(int rating) {
//     List<String> usersWithRating = [];
//     ratings.forEach((userId, userRating) {
//       if (userRating == rating) {
//         usersWithRating.add(userId);
//       }
//     });
//     return usersWithRating;
//   }
// }

// class CommentModel {
//   String userId;
//   String userName;
//   String userProfilePic;
//   String text;

//   CommentModel({
//     required this.userId,
//     required this.userName,
//     required this.userProfilePic,
//     required this.text,
//   });

//   factory CommentModel.fromMap(Map<String, dynamic> map) {
//     return CommentModel(
//       userId: map['userId'],
//       userName: map['userName'],
//       userProfilePic: map['userProfilePic'],
//       text: map['text'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'userName': userName,
//       'userProfilePic': userProfilePic,
//       'text': text,
//     };
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String postId;
  String userId;
  String? text;
  String? imageUrl;
  DateTime postDate;
  List<CommentModel> comments;
  List<String> likedBy;
  Map<String, int> ratings;

  PostModel({
    required this.postId,
    required this.userId,
    this.text,
    this.imageUrl,
    required this.postDate,
    required this.comments,
    required this.likedBy,
    required this.ratings,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> commentsData = map['comments'] ?? [];
    List<CommentModel> comments = commentsData
        .map((comment) => CommentModel.fromMap(comment))
        .toList();

    Map<String, dynamic> ratingsData = map['ratings'] ?? {};
    Map<String, int> ratings = ratingsData.cast<String, int>();

    return PostModel(
      postId: map['postId'],
      userId: map['userId'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      postDate: (map['postDate'] as Timestamp).toDate(),
      comments: comments,
      likedBy: List<String>.from(map['likedBy']),
      ratings: ratings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'text': text,
      'imageUrl': imageUrl,
      'postDate': postDate,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'likedBy': likedBy,
      'ratings': ratings,
    };
  }

  bool isSeenByUser(String userId) {
    return likedBy.contains(userId);
  }

  void markAsSeenByUser(String userId) {
    if (!likedBy.contains(userId)) {
      likedBy.add(userId);
    }
  }

  void markAsUnseenByUser(String userId) {
    likedBy.remove(userId);
  }

  double calculateAverageRating() {
    if (ratings.isEmpty) {
      return 0.0;
    }

    int totalRating = 0;
    ratings.forEach((_, rating) {
      totalRating += rating;
    });

    return totalRating / ratings.length;
  }

  List<String> getUsersWithRating(int rating) {
    List<String> usersWithRating = [];
    ratings.forEach((userId, userRating) {
      if (userRating == rating) {
        usersWithRating.add(userId);
      }
    });
    return usersWithRating;
  }
}

class CommentModel {
  String userId;
  String userName;
  String userProfilePic;
  String text;

  CommentModel({
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.text,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'],
      userName: map['userName'],
      userProfilePic: map['userProfilePic'],
      text: map['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfilePic': userProfilePic,
      'text': text,
    };
  }
}
