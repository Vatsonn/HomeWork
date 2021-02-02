import UIKit

/*
4. Напишите, в чём отличие класса от протокола.
 Протокол определяет образец методов, свойств или другие требования, которые соответствуют определенному конкретному заданию или какой-то функциональности. Протокол фактически не предоставляет реализацию для любого из этих требований, он только описывает как реализация должна выглядеть.
 В Классах же напротив свойства и методы объявляются и описываются.
*/

/*
5. Ответьте, могут ли реализовывать несколько протоколов:

     a) классы (Class), - Могут

     b) структуры (Struct), - Могут

     c) перечисления (Enum), - Могут

     d) кортежи (Tuples). - нет, в данном случае протокол описывается в качестве типа
*/

/*
6. Создайте протоколы для:

     a) Игры в шахматы против компьютера:
 1) протокол-делегат с функцией, через которую шахматный движок будет сообщать о ходе компьютера (с какой на какую клетку);
*/
protocol ChessDelegate{
    
    func computerMove(piece: String, moveFrom: String, moveTo: String)
    
}

class ChessBoard{
    var delegate : ChessDelegate?
    var piece: String
    var moveFrom : String
    var moveTo: String
    
    init(piece: String, moveFrom: String, moveTo: String) {
        self.piece = piece
        self.moveFrom = moveFrom
        self.moveTo = moveTo
    }
    
    func chessEngine(){
        //...
        print("Piece: \(piece), From: \(moveFrom), To: \(moveTo)")
        delegate?.computerMove(piece: piece, moveFrom: moveFrom, moveTo: moveTo)
    }
}

var pawn = ChessBoard(piece: "Pawn", moveFrom: "a2", moveTo: "a4")
pawn.chessEngine()

/*
 2) протокол для шахматного движка, в который передаётся ход фигуры игрока (с какой на какую клетку); Double-свойство, возвращающее текущую оценку позиции (без возможности изменения этого свойства) и свойство делегата.
*/

protocol ChessPlayer {
    var moveFrom: Double {get}
    var moveTo: Double {get}
    
    func playerMove(moveFrom: Double, moveTo: Double) -> Double
    
}

struct ChessEngine: ChessPlayer {
    var delegate : ChessPlayer?
    var moveFrom: Double
    var moveTo: Double
    
    func playerMove(moveFrom: Double, moveTo: Double) -> Double {
        //...
        delegate?.playerMove(moveFrom: moveFrom, moveTo: moveTo)
        return moveTo
    }
}

var player = ChessEngine(moveFrom: 2.0, moveTo: 4.0)
player.playerMove(moveFrom: player.moveFrom, moveTo: player.moveTo)

/*
 b) Компьютерной игры: один протокол для всех, кто может летать (Flyable), второй — для тех, кого можно отрисовывать в приложении (Drawable). Напишите класс, который реализует эти два протокола.
 */

protocol Flyable {
    var nameFly : String { get }
    var type : String { get }
    func flyable()
}

protocol Drawable {
    var x : Int { get }
    var y : Int { get }
    func drawable(name: String)
}

class FlyAndDrow: Flyable, Drawable {
    var nameFly: String
    var type: String
    var x : Int
    var y : Int
    
    init(nameFly: String, type: String, x : Int, y : Int) {
        self.nameFly = nameFly
        self.type = type
        self.x = x
        self.y = y
    }
    
    func flyable() {
        print("\(nameFly) - \(type) : flying")
    }
    
    func drawable(name: String) {
        print("\(name) - is drawn : x = \(x), y = \(y)")
    }
    
}

var bird = FlyAndDrow(nameFly: "Eagle", type: "Bird", x: 100, y: 300)
bird.flyable()
bird.drawable(name: bird.nameFly)

/*
7. Создайте расширение с функцией для:

     a) CGRect, которая возвращает CGPoint с центром этого CGRect’а.
*/

extension CGRect {
    func centerCGRect()-> CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}

var rect = CGRect(x: 100.0, y: 200.0, width: 30, height: 10)
rect.centerCGRect()

/*
     b) CGRect, которая возвращает площадь этого CGRect’а.
*/

extension CGRect {
    var area : CGFloat { return self.size.width * self.size.height }
}

rect.area

/*
     c) UIView, которое анимированно её скрывает (делает alpha = 0).
*/

extension UIView {
    func hiddenIs() {
        return UIView.animate(withDuration: 2.0) {
            self.alpha = 0
        }
    }
}

var menu = UIView()
menu.hiddenIs

/*
     d) Протокола Comparable, который на вход получает ещё два параметра того же типа: первый  ограничивает минимальное значение, второй —  максимальное, — и возвращает текущее значение, ограниченное этими двумя параметрами. Пример использования:

7.bound(minValue: 10, maxValue: 21) → 10

7.bound(minValue: 3, maxValue: 6) → 6

7.bound(minValue: 3, maxValue: 10) → 7
*/
 
extension Comparable {
    func bound(minValue: Self , maxValue: Self) -> Self {
        let number = self
        let eqRange = minValue..<maxValue
        let b = true
        switch b {
        case eqRange.contains(number):
            return self
        case (number < minValue) :
            return minValue
        default:
            return maxValue
        }
    }
}

"asd".bound(minValue: "aaa", maxValue: "aab")

7.bound(minValue: 10, maxValue: 21)
7.bound(minValue: 3, maxValue: 6)
7.bound(minValue: 3, maxValue: 10)

/*
     e) Array, который содержит элементы типа Int: функцию для подсчёта суммы всех элементов.
*/

extension Array where Element == Int  {
    func sum() -> Int {
        var sumElement = 0

        for i in self {
            sumElement += i
        }
        return sumElement
    }
}

let array = [10, 3, 5, 12]
array.sum()
type(of: array[0])

let strings = ["asd", "asd", "asd"]
//strings.sum()

//Есть одно интересное решение этой задачи:

protocol Summable {

    static func +(lhs: Self, rhs: Self) -> Self

}

extension Int: Summable { }

extension String: Summable { }

extension Array where Element: Summable {

    func summ() -> Element? {

        guard var result = first else { return nil }

        for number in self.dropFirst() {

            result = result + number

        }

        return result

    }

}

let rek: Array = [10,20]

let string = ["asd", "asd", "asd"]

rek.summ()

string.summ()

//Теперь можно легко добавить поддержку суммирования элементов массива для любого типа, для которого есть реализация оператора +.
//Сделать это можно так:
//extension SomeTypeWithPlus: Summable { }

/*
 8. Напишите, в чём основная идея Protocol Oriented Programming.
 Основная идея Protocol Oriented Programming заключается в повышении переиспользования кода, в лучшем структурировании код, в уменьшении дублирования кода.
 */

//--------------------------------------------------------------------------------------
//Дополнительные задания:
/*
1. Можно ли ограничить протокол только для классов?
Да, можно:
 */
protocol OnlyClass: class {
    func testFunc()
}

class TestClass: OnlyClass {
    func testFunc() {
        //....
    }
}

protocol OnlyClass1: AnyObject {
    func testFunc()
}

class TestClass1: OnlyClass1 {
    func testFunc() {
        //....
    }
}

//2. Можно ли создать опциональные функции (необязательные к реализации) у протоколов?
// Можно, НО с обязательным указанием атрибута @objc и подобные протоколы могут приниматься только классами
@objc protocol OptionalType {
    @objc optional func testFunc()
}
class OptionalStruct: OptionalType {
}
//А какой еще способ есть чисто для swift протоколов?
//Затрудняюсь ответить, гугл то же ((

//Предоставить реализацию по умолчанию.
protocol A {
    func a()
}

extension A {
    func a() {}
}

//Да, Никита об этом говорил в видеоуроках, я думал о такой реализации, но почему-то привязался к тому, что опциональная функция должна иметь обязательный клучевое слово optional

//3. Можно ли в extension создавать хранимые свойства (stored property)?
// Нет, нельзя, только вычисляемые свойства

//Хотелось бы хранимое свойство-экземпляра.
//Можно ли? А обойти?

//Обойти можно с использованием методов objc_getAssociatedObject и objc_setAssociatedObject.

//Реализуете?:
//Я нашел в интернете реалиацию, но мне в некторых местах сложно понять что проихсодит ))
//В частности не понятно в данные методах: key: UnsafeRawPointer
//key: UnsafeRawPointer что оно значит, что сюда необходимо подставить?
//Что пишут в интернете: key: UnsafeRawPointer!: Указатель, который является ключом, связанным с объектом для сохранения.
//Но мне это ни чего не говорит ((
//Так же не понятно: OBJC_ASSOCIATION_RETAIN_NONATOMIC
//В интернете пишут OBJC_ASSOCIATION_RETAIN_NONATOMIC: Он сохраняет объект не атомарно с сильной ссылкой
//Так же мне ни чего это не говорит (( не понимаю
struct AssociatedKeys {
    static var toggleState: UInt8 = 0
}

protocol ToggleProtocol {
    func toggle()
}

enum ToggleState {
    case on
    case off
}

extension UIButton: ToggleProtocol {

    private(set) var toggleState: ToggleState {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.toggleState) as? ToggleState else {
                return .off
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.toggleState, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func toggle() {
        toggleState = toggleState == .on ? .off : .on

        if toggleState == .on {
            // Shows background for status on
        } else {
            // Shows background for status off
        }
    }
}

//4. Можно ли в extension объявлять вложенные типы, а именно: классы/структуры/перечисления/протоколы.
// Можно кроме протоколов:
extension TestClass{
    
    class NestedClass {
        //...
    }
    
    struct NestedStruct {
        //...
    }
    
    enum NestedEnum {
        case a
    }
    
}

//5. Можно ли в extension класса/структуры/перечисления реализовать соответствие протоколу?
// Да, можно:
class ForExtensionClass{
    let name: String
    let age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

struct ForExtensionStruct{
    let name: String
    let age: Int
}

enum ForExtensionEnum {
}

protocol ForExtension{
    func testFunc()
}

extension ForExtensionClass: ForExtension{
    func testFunc() {
        //...
    }
}

extension ForExtensionStruct: ForExtension{
    func testFunc() {
        //...
    }
}

extension ForExtensionEnum: ForExtension{
    func testFunc() {
        //...
    }
}

//6. Можно ли в протоколе объявить инициализатор?
//Да, можно:
protocol InitProtocol {
    init(name: Int)
}

//А в extension добавить новый инициализатор для класса/структуры/перечисления/протокола?
//Нет, нельзя

//Для классов может получится?
//Да, действительно:
extension ForExtensionClass {
    convenience init(name: String, newAge: Int) {
        self.init(name: name, age: newAge)
    }
}

//Ну а для структур?
//Да:
extension ForExtensionStruct {
    init(name: String, newAge: Int) {
        self.init(name: name, age: newAge)
    }
}
// А для перечислений?
//Насколько я понимаю в перечислениях не используются инициализаторы

//7. Как в протоколе объявить readonly свойство?
protocol ReadonlyName {
    var name: String { get }
}

//Можно ли его реализовать в классе/структуре/перечислении с помощью let?
//Любая переменная объявленая оператором let будет иметь свойство только для чтения
//Пример
//Только в классах и в структурах, в перечислениях var и let не используются
class ReadonlyNameClass {
    let name : String = "Vadim"
}
struct ReadonlyNameStruct {
    let name : String = "Vadim"
}

//Реализовать протокол со свойством в виде let
//Это невозможно, в протоколах испоьзвуют только var

class ReadonlyClass: ReadonlyName {
    let name: String

    init(name: String) { self.name = name }
}
//Так можно?
//Вопрос стоял возможно ли реализовать протокол со свойством в виде let, в вашем приведенном примере указана реализация класса с требованием протокола
//или я что-то не допонимаю )))

//8. Поддерживают ли протоколы множественное наследование?
//Да:
protocol MultipleInheritance: InitProtocol, ReadonlyName, ForExtensionClass{
}

//9. Можно ли создать протокол, реализовать который могут только определенные классы/структуры/перечисления?
// Предположу что нельзя, не смог найти информацию по этому поводу
class SomeClass {}
protocol Some: SomeClass {}

//Эксперименты в Xcode помогают ответить на многие вопросы.
//Согласен, всегда экспереминтирую, но невсегда удается найти верное решение ))

//10. Можно ли определить тип, который реализует одновременно несколько несвязанных между собой протоколов?
// Да:
protocol ProtocolOne{
}
protocol ProtocolTwo{
}
struct AnyStruct: ProtocolOne, ProtocolTwo{
}

//А так?
//И так можно:
typealias manyProtocol = ProtocolOne & ProtocolTwo
struct AnyStructTwo : manyProtocol{}
