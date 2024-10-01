import test.database;

import ballerinax/mongodb;

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

public function getPurchases() returns Purchase[]|error {
    mongodb:Collection purchases = check database.mongoDb->getDatabase("ecommerce")    ->getCollection("purchases");
    stream<Purchase, error?> result = check purchases->find();
    return from Purchase p in result
        select p;
}
