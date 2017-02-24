//
//  hearthstone.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForHearthstoneJSON = Bundle.main.path(forResource: "hearthstone", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawHearthstoneJSON = try? Data(contentsOf: URL(fileURLWithPath: pathForHearthstoneJSON!))

/* Error object */
var parsingHearthstoneError: NSError? = nil

/* Parse the data into usable form */
var parsedHearthstoneJSON = try! JSONSerialization.jsonObject(with: rawHearthstoneJSON!, options: .allowFragments) as! NSDictionary

func parseJSONAsDictionary(_ dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    print("why nothings printing ---- ")
    guard let basicCardDictionaries = parsedHearthstoneJSON["Basic"] as? [[String:AnyObject]] else {
        print("Cannot find key 'Basic' in \(parsedHearthstoneJSON)")
        return
    }
    var numMinionsCost5 = 0
    var numMinionBattleCry = 0
    var numWeaponDurabilityOf2 = 0
    var sumMinionCost = 0
    var sumMinionCount = 0
    var sumNonZeroMinionAttack = 0
    var sumNonZeroMinionHealth = 0
    
    for cardDictionary in basicCardDictionaries {
        
        guard let cardType = cardDictionary["type"] as? String else {
            print("Cannot find key 'type' in \(cardDictionary)")
            return
        }
        
        
        if cardType == "Minion" {
            sumMinionCount += 1
            
            guard let cost = cardDictionary["cost"] as? Int else {
                return
            }
            
            sumMinionCost += cost
            
            if let cardText = cardDictionary["text"] as? String,  cardText.range(of: "Battlecry") != nil{
                numMinionBattleCry += 1
            }

            if cost == 5 {
                numMinionsCost5 += 1
            }
            
            if let attack = cardDictionary["attack"] as? Int, let health = cardDictionary["health"] as? Int, cost != 0 {
                sumNonZeroMinionAttack += attack
                sumNonZeroMinionHealth += health
            }
            
            
        }
        
        if cardType == "Weapon" {
            guard let durability = cardDictionary["durability"] as? Int else{
                return
            }
            
            if durability == 2{
                numWeaponDurabilityOf2 += 1
            }
        }

    }
    var sumCostRatio = (Double(sumNonZeroMinionAttack) + Double(sumNonZeroMinionHealth)) / Double(sumMinionCost)
    
    print("found \(numMinionsCost5) minions with cost at 5")
    print("\(numWeaponDurabilityOf2) weapon have a durability of 2")
    print("\(numMinionBattleCry) minions battlecry ")
    print("\( Double(sumMinionCost)/Double(sumMinionCount) ) average cost per minion")
    print("\(sumNonZeroMinionAttack) attack again \(sumNonZeroMinionHealth) health, \(sumMinionCost) cost \(sumCostRatio)")
}
parseJSONAsDictionary(parsedHearthstoneJSON)
