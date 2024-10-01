import test.database;

import ballerinax/mongodb;

public type User record {|
    string userId;
    string name;
    string email;
    string? phone;
    string? address;
    Order[]? orders;
    CartItem[]? cart;
    WishlistItem[]? wishlist;
    Notification[]? notifications;
|};

public type Order record {|
    string orderId;
|};

public type CartItem record {|
    string itemId;
    decimal itemPrice;
|};

public type WishlistItem record {|
    string itemId;
|};

public type Notification record {|
    string notificationId;
    string notificationText;
    string notificationDate;
    string notificationType;
|};

public function getUsers() returns User[]|error {
    mongodb:Collection users = check database.mongoDb->getDatabase("ecommerce")    ->getCollection("users");
    stream<User, error?> result = check users->find();
    return from User u in result
        select u;
}
