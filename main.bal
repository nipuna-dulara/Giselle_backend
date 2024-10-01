import ballerina/http;
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

service on new http:Listener(9091) {
    private final mongodb:Database ecommerceDb;

    function init() returns error? {
        self.ecommerceDb = check mongoDb->getDatabase("ecommerce");

        // Add some initial dummy data
        mongodb:Collection items = check self.ecommerceDb->getCollection("items");
        mongodb:Collection shops = check self.ecommerceDb->getCollection("shops");
        mongodb:Collection users = check self.ecommerceDb->getCollection("users");
        mongodb:Collection purchases = check self.ecommerceDb->getCollection("purchases");
        mongodb:Collection offers = check self.ecommerceDb->getCollection("offers");

        // Insert sample data
        // Items
        // Items
        Item item1 = {
            "itemId": uuid:createType1AsString(),
            "shopId": "shop123",
            "price": 150,
            "tags": ["electronics"],
            "productName": "Smartphone",
            "brand": "BrandX", // Added required field
            "description": "A smartphone with advanced features", // Added required field
            "varients": [{"color": "Black", "size": "6.5 inch", "qty": 10}] // Added required field
        };

        check items->insertOne(item1);

        // Shops
        Shop shop1 = {
            "shopId": "shop123",
            "shopName": "Tech Store",
            "owner": {"name": "John", "email": "john@techstore.com", "phone": "1234567890", "address": "123, Main Street"}, // Added required field
            "background": "white", // Added required field
            "color": {"primary": "blue", "secondary": "gray"}, // Added required field
            "logo": "logo.png", // Added required field
            "font": {"primary": "Arial", "secondary": "Helvetica"}, // Added required field
            "description": "A store that sells tech products", // Added required field
            "insights": [{"totalViews": 1000, "totalLikes": 500, "totalShares": 200, "totalOrders": 50, "totalRevenue": 10000, "totalProducts": 100}] // Added required field
        };

        check shops->insertOne(shop1);

        // Users
        User user1 = {"userId": "user123", "name": "Alice", "email": "alice@mail.com", "phone": "1234567890", "address": "456, Main Street", "orders": [{"orderId": "order123"}], "cart": [{"itemId": item1.itemId, "itemPrice": item1.price}], "wishlist": [{"itemId": item1.itemId}], "notifications": [{"notificationId": "notification123", "notificationText": "New offer", "notificationDate": "2024-09-29", "notificationType": "offer"}]};
        check users->insertOne(user1);

        // // Purchases
        // Purchase purchase1 = {"purchaseId": uuid:createType1AsString(), "userId": "user123", "shopId": "shop123", "items": [{"itemId": item1.itemId, "itemPrice": item1.price, "itemQty": 1}], "totalAmount": 150, "purchaseDate": "2024-09-29"};
        // check purchases->insertOne(purchase1);

        // // Offers
        // Offer offer1 = {"offerId": uuid:createType1AsString(), "shopId": "shop123", "offerText": "20% off", "offerStartDate": "2024-10-01", "offerEndDate": "2024-10-15", "offerDiscount": 20};
        // check offers->insertOne(offer1);

    }

    resource function get items() returns Item[]|error {
        mongodb:Collection items = check self.ecommerceDb->getCollection("items");
        stream<Item, error?> result = check items->find();
        return from Item i in result
            select i;
    }

    resource function get shops() returns Shop[]|error {
        mongodb:Collection shops = check self.ecommerceDb->getCollection("shops");
        stream<Shop, error?> result = check shops->find();
        return from Shop s in result
            select s;
    }

    resource function get users() returns User[]|error {
        mongodb:Collection users = check self.ecommerceDb->getCollection("users");
        stream<User, error?> result = check users->find();
        return from User u in result
            select u;
    }

    resource function get purchases() returns Purchase[]|error {
        mongodb:Collection purchases = check self.ecommerceDb->getCollection("purchases");
        stream<Purchase, error?> result = check purchases->find();
        return from Purchase p in result
            select p;
    }

    resource function get offers() returns Offer[]|error {
        mongodb:Collection offers = check self.ecommerceDb->getCollection("offers");
        stream<Offer, error?> result = check offers->find();
        return from Offer o in result
            select o;
    }
}

# Define the necessary types for the items, shops, users, purchases, and offers
public type Item record {|
    string itemId;
    string shopId;
    decimal price;
    string[] tags;
    string productName;
    Varient[]? varients;
    string? description;
    string? brand;
|};

public type Varient record {|
    string color;
    string size;
    int qty;
|};

public type Shop record {|
    string shopId;
    string shopName;
    Owner owner;
    string? description;
    string? background;
    Color? color;
    string? logo;
    Font? font;
    Insight[]? insights;
|};

public type Owner record {|
    string name;
    string email;
    string? phone;
    string? address;
|};

public type Color record {|
    string primary;
    string secondary;
|};

public type Font record {|
    string primary;
    string secondary;
|};

public type Insight record {|
    int totalViews;
    int totalLikes;
    int totalShares;
    int totalOrders;
    decimal totalRevenue;
    int totalProducts;
|};

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

public type Purchase record {|
    string purchaseId;
    string userId;
    string shopId;
    PurchaseItem[] items;
    decimal totalAmount;
    string purchaseDate;
    string? deliveryDate;
    string? deliveryAddress;
    string? paymentMethod;
    string? paymentStatus;
    string? deliveryStatus;
|};

public type PurchaseItem record {|
    string itemId;
    decimal itemPrice;
    int itemQty;
|};

public type Offer record {|
    string offerId;
    string shopId;
    string offerText;
    string offerStartDate;
    string offerEndDate;
    decimal offerDiscount;
    string? offerCode;
    string? offerStatus;
    string? bannerImage;
|};
