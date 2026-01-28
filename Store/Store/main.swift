//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

protocol PricingScheme {
    func discount(for items: [SKU]) -> Int
}

class BuyTwoGetOneFree: PricingScheme {
    private let itemName: String
    
    init(itemName: String) {
        self.itemName = itemName
    }
    
    func discount(for items: [SKU]) -> Int {
        let matchingItems = items.filter { $0.name == itemName }
        let count = matchingItems.count
        
        let freeItems = count / 3
        guard freeItems > 0 else { return 0 }
        
        let unitPrice = matchingItems[0].price()
        return freeItems * unitPrice
    }
}

class GroupedPricingScheme: PricingScheme {
    private let isGroupA: (SKU) -> Bool
    private let isGroupB: (SKU) -> Bool
    private let discountPercent: Int
    
    init(
        isGroupA: @escaping (SKU) -> Bool,
        isGroupB: @escaping (SKU) -> Bool,
        discountPercent: Int
    ) {
        self.isGroupA = isGroupA
        self.isGroupB = isGroupB
        self.discountPercent = discountPercent
    }
    
    func discount(for items: [SKU]) -> Int {
        let groupAItems = items.filter { isGroupA($0) }
        let groupBItems = items.filter { isGroupB($0) }
        
        let pairCount = min(groupAItems.count, groupBItems.count)
        if pairCount == 0 { return 0 }
        
        var totalDiscount = 0
        
        for i in 0..<pairCount {
            let itemA = groupAItems[i]
            let itemB = groupBItems[i]
            
            let discountA = itemA.price() * discountPercent / 100
            let discountB = itemB.price() * discountPercent / 100
            
            totalDiscount += discountA + discountB
        }
        return totalDiscount
    }
}

func nameContains(_ keyword: String) -> (SKU) -> Bool {
    return { sku in sku.name.lowercased().contains(keyword.lowercased())}
}

class Item: SKU {
    var name: String
    var priceInPennies: Int
    init(name: String, priceEach: Int) {
        self.name = name
        self.priceInPennies = priceEach
    }
    func price() -> Int {
        return priceInPennies
    }
}

class Receipt {
    private var items: [SKU]
    init() {
        self.items = []
    }
    func add(_ sku: SKU) {
        items.append(sku)
    }
    
    func scannedItems() -> [SKU] {
        return items
    }
    
    func total() -> Int {
        var sum = 0
        for sku in items {
            sum += sku.price()
        }
        return sum
    }
    
    func output() -> String {
        var result = "Receipt:\n"

        for sku in items {
            let dollars = Double(sku.price()) / 100.0
            result += "\(sku.name): $\(String(format: "%.2f", dollars))\n"
        }

        result += "------------------\n"

        let totalDollars = Double(total()) / 100.0
        result += "TOTAL: $\(String(format: "%.2f", totalDollars))"

        return result
    }
}

class Register {
    private var receipt: Receipt
    private var pricingSchemes: [PricingScheme] = []
    init() {
        self.receipt = Receipt()
    }
    
    func scan(_ sku: SKU) {
        receipt.add(sku)
    }
    
    func addPricingScheme(_ scheme: PricingScheme) {
        pricingSchemes.append(scheme)
    }
    
    func subtotal() -> Int {
        let rawTotal = receipt.total()
        var totalDiscount = 0
        
        for scheme in pricingSchemes {
            let discount = scheme.discount(for: receipt.scannedItems())
            totalDiscount += discount
        }
        
        return rawTotal - totalDiscount
    }
    
    func total() -> Receipt {
        let endTotal = receipt
        receipt = Receipt()
        return endTotal
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

