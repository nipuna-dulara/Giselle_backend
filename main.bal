import test.database;
import test.item;
import test.purchase;
import test.shop;
import test.user;

import ballerina/http;

service / on new http:Listener(9091) {

    function init() returns error? {
        // Initialize the database
        check database:initDb();

        // Optionally, insert initial dummy data if needed
        check database:insertDummyData();
    }

    // Route the service to the respective modules
    resource function get items() returns item:Item[]|error {
        return check item:getItems();
    }

    resource function get shops() returns shop:Shop[]|error {
        return check shop:getShops();
    }

    resource function get users() returns user:User[]|error {
        return check user:getUsers();
    }

    resource function get purchases() returns purchase:Purchase[]|error {
        return check purchase:getPurchases();
    }

    // resource function get offers() returns offer:Offer[]|error {
    //     return check offer:getOffers();
    // }
}
