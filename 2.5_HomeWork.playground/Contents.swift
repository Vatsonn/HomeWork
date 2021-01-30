import UIKit

//4. Напишите, для чего нужны дженерики.
//Дженерики позволяют создавать многократно используемые функции и типы данных, которые могут работать с любым типом.

//5. Укажите, чем ассоциированные типы отличаются от дженериков.
//Ассоциированные типы используются в протоколах, и указываются с помощью ключевого слова associatedtype

//6. Создайте функцию, которая:
//a) получает на вход два Equatable-объекта и, в зависимости от того, равны ли они друг другу, выводит разные сообщения в лог;
func equatable<T: Equatable>(_ a: T, _ b: T){
    if a == b {
        print("Параметра эквивалентны")
    } else {
       print("Параметра не эквивалентны")
    }
}

let oneValueEq = 5
let twoValueEq = 5
equatable(oneValueEq, twoValueEq)


//b) получает на вход два сравниваемых (Comparable) друг с другом значения, сравнивает их и выводит в лог наибольшее;
func comparable<T: Comparable>(_ a: T, _ b: T){
//    if a > b {
//        print("Наибольшее значение \(a)")
//    } else {
//       print("Наибольшее значение \(b)")
//    }
    
    switch a == b || a > b || a < b {
    case a > b:
        print("Наибольшее значение \(a)")
    case a < b:
        print("Наибольшее значение \(b)")
    default:
        print("Параметра эквивалентны")
    }
}

let oneValueComp = 25.3
let twoValueComp = 32.6
comparable(oneValueComp, twoValueComp)


//c) получает на вход два сравниваемых (Comparable) друг с другом значения, сравнивает их и перезаписывает первый входной параметр меньшим из двух значений, а второй параметр — большим;
func changeComparable<T: Comparable>(_ a: inout T, _ b: inout T){
    
    switch a == b || a > b || a < b {
    case a > b:
        var temp : T
        temp = a
        a = b
        b = temp
        print("Первый параметр = \(a), Второй параметр = \(b)")
    case a < b:
        print("Первый параметр = \(a), Второй параметр = \(b)")
    default:
        print("Параметра эквивалентны")
    }
}

var oneValueCh = "aaa"
var twoValueCh = "bbb"
changeComparable(&oneValueCh, &twoValueCh)

//d) получает на вход две функции, которые имеют дженерик — входной параметр Т и ничего не возвращают; сама функция должна вернуть новую функцию, которая на вход получает параметр с типом Т и при своём вызове вызывает две функции и передаёт в них полученное значение (по факту объединяет две функции).

func main<T>(func1: (T) -> Void, func2: (T) -> Void, value: T) -> () {

    func threeFunc(_ a: T){
        func1(a)
        func2(a)
    }

    return threeFunc(value)
}

func oneFunc<T>(_ a: T){
    print("Вызов первой \(a)")
}

func twoFunc<T>(_ a: T){
    print("Вызов второй \(a)")
}


main(func1: oneFunc, func2: twoFunc, value: "функции")
main(func1: oneFunc, func2: twoFunc, value: 123)


//7. Создайте расширение для:

//      a) Array, у которого элементы имеют тип Comparable, и добавьте генерируемое свойство, которое возвращает максимальный элемент;
extension Array where Element: Comparable {
    func maximum() -> Element {
        var max = self[0]
        for i in self {
            if max < i {max = i}
        }
        return max
    }
}
let array = [5, 65, 23, 7]
array.max()


//      b) Array, у которого элементы имеют тип Equatable, и добавьте функцию, которая удаляет из массива идентичные элементы.
extension Array where Element: Equatable {
    func eqDell() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
var arrayTwo = [5, 65, 23, 5, 7, 23, 65, 23, 7]
arrayTwo.eqDell()


// 8. Создайте специальный оператор для:

//      a) возведения Int-числа в степень: оператор ^^, работает 2^3, возвращает 8;
infix operator ^^
func ^^(value: Int, exp: Int) -> Int {
    var valueExp = value
    for _ in 1...exp-1{
        valueExp *= value
    }
    return valueExp
}
2^^3
5^^4

//      b) копирования во второе Int-числа удвоенного значения первого 4 ~> a, после этого a = 8;
infix operator ~>
func ~>(value: Int, double: inout Int) -> Int{
    double = value * 2
    return double
}
var a = 0
4 ~> a
 
//      c) присваивания в экземпляр tableView делегата: myController <* tableView, поле этого myController становится делегатом для tableView;
infix operator <*
func <*(myController: UIViewController, tableView: UITableView){
    tableView.delegate = (myController as! UITableViewDelegate)
}
let myController = UIViewController()
let tableView = UITableView()
//myController <* tableView

//      d) суммирует описание двух объектов с типом CustomStringConvertable и возвращает их описание: 7 + “ string” вернет “7 string”.
struct CustomStringConvertable<Element>{
    var element : Element
}

infix operator +++
func +++(a: CustomStringConvertable<Int>, b: CustomStringConvertable<String>) -> String{
    return "\(a.element)\(b.element)"
}
let left = CustomStringConvertable(element: 7)
let right = CustomStringConvertable(element: " string")
left +++ right


// 9. Напишите для библиотеки анимаций новый аниматор:
//      a) изменяющий фоновый цвет для UIView;
let view = UIView()

protocol Animator {
    associatedtype MyView
    associatedtype Value
    
    init(_ value: Value)
    
    func animate(myView: MyView)
}

class BackgroundColorAnimator: Animator{
    let newColor : UIColor
    
    required init(_ value: UIColor){
        newColor = value
    }
    
    func animate(myView: UIView){
        UIView.animate(withDuration: 2){
            myView.backgroundColor = self.newColor
        }
    }
}

infix operator -->
func --><T: Animator>(left: T, right: T.MyView){
    left.animate(myView: right)
}

BackgroundColorAnimator(.blue) --> view


//      b) изменяющий center UIView;
class CenterChange: Animator{
    let newCenter : CGPoint
    
    required init(_ value: CGPoint){
        newCenter = value
    }
    
    func animate(myView: UIView){
        UIView.animate(withDuration: 2){
            myView.center = self.newCenter
        }
    }
}

CenterChange(CGPoint(x: 100, y: 100)) --> view

//      c) делающий scale-трансформацию для UIView.
class ScaleView: Animator{
    let newScale : CGFloat
    
    required init(_ value: CGFloat){
        newScale = value
    }
    
    func animate(myView: UIView){
        UIView.animate(withDuration: 2){
            myView.layer.cornerRadius = self.newScale / 2
        }
    }
}

ScaleView(view.frame.width) --> view
