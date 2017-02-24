//
//  animals.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForAnimalsJSON = Bundle.main.path(forResource: "animals", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAnimalsJSON = try? Data(contentsOf: URL(fileURLWithPath: pathForAnimalsJSON!))

/* Error object */
var parsingAnimalsError: NSError? = nil

/* Parse the data into usable form */
var parsedAnimalsJSON = try! JSONSerialization.jsonObject(with: rawAnimalsJSON!, options: .allowFragments) as! NSDictionary

func parseJSONAsDictionary(_ dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    guard let photosDictionary = parsedAnimalsJSON["photos"] as? NSDictionary else {
        return
    }
    
    guard let photoCollection = photosDictionary["photo"] as? [[String: AnyObject]] else{
        return
    }
    
    
    print(photoCollection.count)
    
    /*for loop through each photo object, grab the key value of photo.title contains the string "interrufftion "*/
    
    for (index, photo) in photoCollection.enumerated(){
        
        guard let commentDictionary = photo["comment"] as? [String: AnyObject] else {
            return
        }
        
        guard let content = commentDictionary["_content"] as? String else {
            return
        }
        
        /* look for string */
        if content.range(of: "interrufftion") != nil{
            print(index)
        }
        
        if let photoURL = photo["url_m"] as? String, index == 2{
            print(photoURL)
        }
    }
}

parseJSONAsDictionary(parsedAnimalsJSON)
