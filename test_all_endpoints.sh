#!/bin/zsh

# Food Delivery App API Test Script
# This script tests all endpoints of the Food Delivery App API

# Base URL
BASE_URL="http://localhost:8008"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
  echo -e "\n${BLUE}================================================================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}================================================================================${NC}\n"
}

# Function to print test case headers
print_test() {
  echo -e "\n${YELLOW}$1${NC}\n"
}

# Function to save response to a variable and print it
call_api() {
  echo -e "${GREEN}Request:${NC} $1"
  echo -e "${GREEN}Payload:${NC}"
  echo "$2" | jq '.' 2>/dev/null || echo "$2"
  echo -e "${GREEN}Response:${NC}"
  RESPONSE=$(eval "$1")
  echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
  echo -e "\n${GREEN}-----------------------------------${NC}\n"
}

# Variable to store authentication key
AUTH_KEY=""

#######################################
print_header "1. AUTHENTICATION ENDPOINTS"
#######################################

print_test "1.1 Sign Up (Create User)"
SIGNUP_PAYLOAD='{
  "userName": "testuser",
  "password": "password123",
  "mobileNo": "1234567890",
  "email": "test@example.com"
}'
call_api "curl -s -X POST ${BASE_URL}/signUp -H 'Content-Type: application/json' -d '$SIGNUP_PAYLOAD'" "$SIGNUP_PAYLOAD"

print_test "1.2 Login"
LOGIN_PAYLOAD='{
  "userId": 1,
  "userName": "testuser",
  "password": "password123"
}'
call_api "curl -s -X POST ${BASE_URL}/login -H 'Content-Type: application/json' -d '$LOGIN_PAYLOAD'" "$LOGIN_PAYLOAD"

# Store the authentication key from login response
# Extract the UUID value from the response
AUTH_KEY=$(echo "$RESPONSE" | grep -o 'UUID=[a-zA-Z0-9]*' | cut -d'=' -f2)
echo -e "${GREEN}Extracted Auth Key:${NC} $AUTH_KEY"

print_test "1.3 Update User"
UPDATE_USER_PAYLOAD='{
  "userId": 1,
  "userName": "updateduser",
  "password": "newpassword123",
  "mobileNo": "0987654321",
  "email": "updated@example.com"
}'
call_api "curl -s -X PUT ${BASE_URL}/updateSignUp -H 'Content-Type: application/json' -H 'Authorization: Bearer ${AUTH_KEY}' -d '$UPDATE_USER_PAYLOAD'" "$UPDATE_USER_PAYLOAD"

print_test "1.4 Logout"
call_api "curl -s -X PATCH '${BASE_URL}/logout?key=${AUTH_KEY}'" "N/A"

#######################################
print_header "2. CUSTOMER ENDPOINTS"
#######################################

print_test "2.1 Add Customer"
CUSTOMER_PAYLOAD='{
  "fullName": "John Doe",
  "age": 30,
  "gender": "Male",
  "mobileNumber": "9876543210",
  "email": "john@example.com",
  "address": {
    "street": "123 Downtown",
    "city": "New York",
    "state": "NY",
    "country": "USA",
    "zipcode": "10001"
  }
}'
call_api "curl -s -X POST ${BASE_URL}/customer/add -H 'Content-Type: application/json' -d '$CUSTOMER_PAYLOAD'" "$CUSTOMER_PAYLOAD"

print_test "2.2 Update Customer"
UPDATE_CUSTOMER_PAYLOAD='{
  "customerId": 1,
  "fullName": "John Updated",
  "age": 31,
  "gender": "Male",
  "mobileNumber": "9876543211",
  "email": "john.updated@example.com",
  "address": {
    "addressId": 1,
    "street": "123 Uptown",
    "city": "New York",
    "state": "NY",
    "country": "USA",
    "zipcode": "10002"
  }
}'
call_api "curl -s -X PUT ${BASE_URL}/customer/update -H 'Content-Type: application/json' -d '$UPDATE_CUSTOMER_PAYLOAD'" "$UPDATE_CUSTOMER_PAYLOAD"

print_test "2.3 View Customer by ID"
call_api "curl -s -X GET ${BASE_URL}/customer/view/1" "N/A"

print_test "2.4 Remove Customer"
call_api "curl -s -X DELETE ${BASE_URL}/customer/remove/1" "N/A"

#######################################
print_header "3. RESTAURANT ENDPOINTS"
#######################################

print_test "3.1 Add Restaurant"
RESTAURANT_PAYLOAD='{
  "restaurantName": "Tasty Treats",
  "managerName": "Mike Manager",
  "contactNumber": "5551234567",
  "address": {
    "street": "123 Financial District",
    "city": "San Francisco",
    "state": "CA",
    "country": "USA",
    "zipcode": "94111"
  },
  "itemList": []
}'
call_api "curl -s -X POST ${BASE_URL}/restaurant/add -H 'Content-Type: application/json' -d '$RESTAURANT_PAYLOAD'" "$RESTAURANT_PAYLOAD"

print_test "3.2 Update Restaurant"
UPDATE_RESTAURANT_PAYLOAD='{
  "restaurantId": 1,
  "restaurantName": "Tasty Delights",
  "managerName": "Mike Smith",
  "contactNumber": "5559876543",
  "address": {
    "addressId": 2,
    "street": "123 Marina District",
    "city": "San Francisco",
    "state": "CA",
    "country": "USA",
    "zipcode": "94123"
  },
  "itemList": []
}'
call_api "curl -s -X PUT ${BASE_URL}/restaurant/update -H 'Content-Type: application/json' -d '$UPDATE_RESTAURANT_PAYLOAD'" "$UPDATE_RESTAURANT_PAYLOAD"

print_test "3.3 View Restaurant by ID"
call_api "curl -s -X GET '${BASE_URL}/restaurant/view/1?key=${AUTH_KEY}'" "N/A"

print_test "3.4 Remove Restaurant"
call_api "curl -s -X DELETE ${BASE_URL}/restaurant/remove/1 -H 'Authorization: Bearer ${AUTH_KEY}'" "N/A"

#######################################
print_header "4. CATEGORY ENDPOINTS"
#######################################

print_test "4.1 Add Category"
CATEGORY_PAYLOAD='{
  "categoryId": 1,
  "categoryName": "Italian"
}'
call_api "curl -s -X POST ${BASE_URL}/category/add -H 'Content-Type: application/json' -H 'Authorization: Bearer ${AUTH_KEY}' -d '$CATEGORY_PAYLOAD'" "$CATEGORY_PAYLOAD"

print_test "4.2 Update Category"
UPDATE_CATEGORY_PAYLOAD='{
  "categoryId": 1,
  "categoryName": "Mediterranean"
}'
call_api "curl -s -X PUT ${BASE_URL}/category/update -H 'Content-Type: application/json' -H 'Authorization: Bearer ${AUTH_KEY}' -d '$UPDATE_CATEGORY_PAYLOAD'" "$UPDATE_CATEGORY_PAYLOAD"

print_test "4.3 View Category by ID"
call_api "curl -s -X GET ${BASE_URL}/category/view/1 -H 'Authorization: Bearer ${AUTH_KEY}'" "N/A"

print_test "4.4 View All Categories"
call_api "curl -s -X GET ${BASE_URL}/category/viewall -H 'Authorization: Bearer ${AUTH_KEY}'" "N/A"

print_test "4.5 Remove Category"
call_api "curl -s -X DELETE ${BASE_URL}/category/remove/1 -H 'Authorization: Bearer ${AUTH_KEY}'" "N/A"

#######################################
print_header "5. ITEM ENDPOINTS"
#######################################

print_test "5.1 Add Item"
ITEM_PAYLOAD='{
  "itemName": "Spaghetti Carbonara",
  "quantity": 1,
  "cost": 12.99,
  "category": {
    "categoryId": 1,
    "categoryName": "Italian"
  }
}'
call_api "curl -s -X POST ${BASE_URL}/item/add -H 'Content-Type: application/json' -d '$ITEM_PAYLOAD'" "$ITEM_PAYLOAD"

print_test "5.2 Update Item"
UPDATE_ITEM_PAYLOAD='{
  "itemId": 1,
  "itemName": "Spaghetti Bolognese",
  "quantity": 2,
  "cost": 14.99,
  "category": {
    "categoryId": 1,
    "categoryName": "Italian"
  }
}'
call_api "curl -s -X PUT ${BASE_URL}/item/update -H 'Content-Type: application/json' -H 'Authorization: Bearer ${AUTH_KEY}' -d '$UPDATE_ITEM_PAYLOAD'" "$UPDATE_ITEM_PAYLOAD"

print_test "5.3 View Item by ID"
call_api "curl -s -X GET ${BASE_URL}/item/view/1 -H 'Authorization: Bearer ${AUTH_KEY}'" "N/A"

print_test "5.4 View All Items"
call_api "curl -s -X GET ${BASE_URL}/item/viewall" "N/A"

print_test "5.5 Remove Item"
call_api "curl -s -X DELETE ${BASE_URL}/item/remove/1 -H 'Authorization: Bearer ${AUTH_KEY}'" "N/A"

#######################################
print_header "6. CART ENDPOINTS"
#######################################

print_test "6.1 Register Cart"
CART_PAYLOAD='{
  "customer": {
    "customerId": 2
  },
  "itemList": []
}'
call_api "curl -s -X POST '${BASE_URL}/cart/register?key=${AUTH_KEY}' -H 'Content-Type: application/json' -d '$CART_PAYLOAD'" "$CART_PAYLOAD"

print_test "6.2 Add Item to Cart"
call_api "curl -s -X POST '${BASE_URL}/cart/add?cartId=1&itemId=1&key=${AUTH_KEY}'" "N/A"

print_test "6.3 View Cart by ID"
call_api "curl -s -X GET '${BASE_URL}/cart/view/1?key=${AUTH_KEY}'" "N/A"

print_test "6.4 Clear Cart"
call_api "curl -s -X DELETE '${BASE_URL}/cart/clear/1?key=${AUTH_KEY}'" "N/A"

#######################################
print_header "7. ORDER ENDPOINTS"
#######################################

print_test "7.1 Save Order"
ORDER_PAYLOAD='{
  "orderDate": "2025-09-15T12:00:00",
  "orderStatus": "PENDING",
  "cart": {
    "cartId": 1
  }
}'
call_api "curl -s -X POST '${BASE_URL}/order/save?key=${AUTH_KEY}' -H 'Content-Type: application/json' -d '$ORDER_PAYLOAD'" "$ORDER_PAYLOAD"

print_test "7.2 Update Order"
UPDATE_ORDER_PAYLOAD='{
  "orderId": 1,
  "orderDate": "2025-09-15T12:30:00",
  "orderStatus": "CONFIRMED",
  "cart": {
    "cartId": 1
  }
}'
call_api "curl -s -X PUT '${BASE_URL}/order/update?key=${AUTH_KEY}' -H 'Content-Type: application/json' -d '$UPDATE_ORDER_PAYLOAD'" "$UPDATE_ORDER_PAYLOAD"

print_test "7.3 View Order by ID"
call_api "curl -s -X GET '${BASE_URL}/order/view/1?key=${AUTH_KEY}'" "N/A"

print_test "7.4 View Orders by Customer ID"
call_api "curl -s -X GET '${BASE_URL}/order/viewbycustomer/2?key=${AUTH_KEY}'" "N/A"

print_test "7.5 Remove Order"
call_api "curl -s -X DELETE '${BASE_URL}/order/remove/1?key=${AUTH_KEY}'" "N/A"

#######################################
print_header "8. BILL ENDPOINTS"
#######################################

print_test "8.1 Add Bill"
BILL_PAYLOAD='{
  "billDate": "2025-09-15T13:00:00",
  "totalCost": 27.98,
  "totalItem": 2,
  "order": {
    "orderId": 1
  }
}'
call_api "curl -s -X POST '${BASE_URL}/bill/add?key=${AUTH_KEY}' -H 'Content-Type: application/json' -d '$BILL_PAYLOAD'" "$BILL_PAYLOAD"

print_test "8.2 Update Bill"
UPDATE_BILL_PAYLOAD='{
  "billId": 1,
  "billDate": "2025-09-15T13:30:00",
  "totalCost": 42.97,
  "totalItem": 3,
  "order": {
    "orderId": 1
  }
}'
call_api "curl -s -X PUT '${BASE_URL}/bill/update?key=${AUTH_KEY}' -H 'Content-Type: application/json' -d '$UPDATE_BILL_PAYLOAD'" "$UPDATE_BILL_PAYLOAD"

print_test "8.3 View Bill by ID"
call_api "curl -s -X GET '${BASE_URL}/bill/view/1?key=${AUTH_KEY}'" "N/A"

print_test "8.4 View Total Bills by Customer ID"
call_api "curl -s -X GET '${BASE_URL}/bill/viewtotal/2?key=${AUTH_KEY}'" "N/A"

print_test "8.5 Remove Bill"
call_api "curl -s -X DELETE '${BASE_URL}/bill/remove/1?key=${AUTH_KEY}'" "N/A"

echo -e "\n${GREEN}All API tests completed!${NC}\n"
