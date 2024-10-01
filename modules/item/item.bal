import test.database;

import ballerinax/mongodb;

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

public function getItems() returns Item[]|error {
    mongodb:Collection items = check database.mongoDb->getDatabase("ecommerce")    ->getCollection("items");
    stream<Item, error?> result = check items->find();
    return from Item i in result
        select i;
}
