package com.foodapp;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.foodapp.model.Address;
import com.foodapp.repository.AddressDAO;

@SpringBootTest
public class AddressTest {

    @Autowired
    private AddressDAO addressDAO;

    @Test
    public void testSaveAddress() {
        Address address = new Address();
        address.setArea("Test Area");
        address.setCity("Test City");
        address.setState("Test State");
        address.setCountry("Test Country");
        address.setPincode("123456");
        
        Address savedAddress = addressDAO.save(address);
        System.out.println("Saved Address ID: " + savedAddress.getAddressId());
    }
}
