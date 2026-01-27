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
    init() {
        self.receipt = Receipt()
    }
    
    func scan(_ sku: SKU) {
        receipt.add(sku)
    }
    
    func subtotal() -> Int {
        var total: Int = 0
        for sku in receipt.scannedItems() {
            total += sku.price()
        }
        
        return total
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

