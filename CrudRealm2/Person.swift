import Foundation
import RealmSwift

class Person: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var age: Int = 0
    
    convenience init(name: String, age: Int) {
        self.init()
        self.name = name
        self.age = age
    }
}

