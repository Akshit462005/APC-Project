package com.foodapp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.foodapp.authexceptions.AuthorizationException;
import com.foodapp.authservice.UserSessionService;
import com.foodapp.exceptions.ItemException;
import com.foodapp.model.Item;
import com.foodapp.service.ItemService;

@RestController
@RequestMapping("/item")
public class ItemServiceController {
	
	@Autowired
	ItemService itemService;
	
	@Autowired
	UserSessionService userSessionService;
	
	@PostMapping("/add")
	public ResponseEntity<Item> addItem(@RequestBody Item item, @RequestParam String key) throws ItemException, AuthorizationException {
		Integer sessionId = userSessionService.getUserSessionId(key);
    	
    	if(sessionId != null) {
			Item newItem = itemService.addItem(item);
			return new ResponseEntity<Item>(newItem, HttpStatus.CREATED);
    	} else {
    		throw new AuthorizationException("Not authorized");
    	}
	}
	
	@PutMapping("/update")
	public ResponseEntity<Item> updateItem(@RequestBody Item item, @RequestParam String key) throws ItemException, AuthorizationException {
		Integer sessionId = userSessionService.getUserSessionId(key);
    	
    	if(sessionId != null) {
			Item updatedItem = itemService.updateItem(item);
			return new ResponseEntity<Item>(updatedItem, HttpStatus.OK);
    	} else {
    		throw new AuthorizationException("Not authorized");
    	}
	}
	
	@GetMapping("/view/{itemId}")
	public ResponseEntity<Item> getItem(@PathVariable("itemId") Integer itemId, @RequestParam String key) throws ItemException, AuthorizationException {
		Integer sessionId = userSessionService.getUserSessionId(key);
    	
    	if(sessionId != null) {
			Item item = itemService.viewItem(itemId);
			return new ResponseEntity<Item>(item, HttpStatus.ACCEPTED);
    	} else {
    		throw new AuthorizationException("Not authorized");
    	}
	}
	
	@DeleteMapping("/remove/{itemId}")
	public ResponseEntity<Item> removeItem(@PathVariable("itemId") Integer itemId, @RequestParam String key) throws ItemException, AuthorizationException {
		Integer sessionId = userSessionService.getUserSessionId(key);
    	
    	if(sessionId != null) {
			Item removedItem = itemService.removeItem(itemId);
			return new ResponseEntity<Item>(removedItem, HttpStatus.ACCEPTED);
    	} else {
    		throw new AuthorizationException("Not authorized");
    	}
	}
	
	@GetMapping("/viewall")
	public ResponseEntity<List<Item>> getAllItems(@RequestParam String key) throws ItemException, AuthorizationException {
		Integer sessionId = userSessionService.getUserSessionId(key);
    	
    	if(sessionId != null) {
			List<Item> items = itemService.viewAllItems();
			return new ResponseEntity<List<Item>>(items, HttpStatus.OK);
    	} else {
    		throw new AuthorizationException("Not authorized");
    	}
	}
}
