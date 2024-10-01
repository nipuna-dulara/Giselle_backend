import test.item;
import test.shop;
import test.user;

import ballerina/uuid;
import ballerinax/mongodb;

configurable string host = "localhost";
configurable int port = 27017;
configurable string username = "testUser";
configurable string password = "testPassword";
configurable string database = "ecommerce";

// Initialize MongoDB client
final mongodb:Client mongoDb = check new ({
    connection: {
        serverAddress: {
            host,
            port
        },
        auth: <mongodb:ScramSha256AuthCredential>{
            username,
            password,
            database
        }
    }
});

public function initDb() returns error? {
    return;
}

// Function to insert initial dummy data
public function insertDummyData() returns error? {
    mongodb:Database ecommerceDb = check mongoDb->getDatabase("ecommerce");
    mongodb:Collection items = check ecommerceDb->getCollection("items");
    mongodb:Collection shops = check ecommerceDb->getCollection("shops");
    mongodb:Collection users = check ecommerceDb->getCollection("users");

    // Add items
    item:Item item1 = {
        "itemId": uuid:createType1AsString(),
        "shopId": "shop123",
        "price": 150,
        "tags": ["electronics"],
        "productName": "Smartphone",
        "brand": "BrandX",
        "description": "A smartphone with advanced features",
        "varients": [{"color": "Black", "size": "6.5 inch", "qty": 10}]
    };
    check items->insertOne(item1);

    // Add shops
    shop:Shop shop1 = {
        "shopId": "shop123",
        "shopName": "Tech Store",
        "owner": {"name": "John", "email": "john@techstore.com", "phone": "1234567890", "address": "123, Main Street"},
        "background": "white",
        "color": {"primary": "blue", "secondary": "gray"},
        "logo": "logo.png",
        "font": {"primary": "Arial", "secondary": "Helvetica"},
        "description": "A store that sells tech products",
        "insights": [{"totalViews": 1000, "totalLikes": 500, "totalShares": 200, "totalOrders": 50, "totalRevenue": 10000, "totalProducts": 100}]
    };
    check shops->insertOne(shop1);

    // Add users
    user:User user1 = {
        "userId": "user123",
        "name": "Alice",
        "email": "alice@mail.com",
        "phone": "1234567890",
        "address": "456, Main Street",
        "orders": [{"orderId": "order123"}],
        "cart": [{"itemId": item1.itemId, "itemPrice": item1.price}],
        "wishlist": [{"itemId": item1.itemId}],
        "notifications": [{"notificationId": "notification123", "notificationText": "New offer", "notificationDate": "2024-09-29", "notificationType": "offer"}]
    };
    check users->insertOne(user1);

    return;
}
