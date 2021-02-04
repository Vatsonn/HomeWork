import UIKit

//4. Напишите, для чего нужны дженерики.
//Дженерики позволяют создавать многократно используемые функции и типы данных, которые могут работать с любым типом.

//5. Укажите, чем ассоциированные типы отличаются от дженериков.
//Ассоциированные типы используются в протоколах, и указываются с помощью ключевого слова associatedtype
//а отличаются чем?
//отличаются реализацией, а так что с помощью дженериков что с помощью ассоциированных типов можем создавать функции которые могут принимать в себя любой тип данных

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
    if a == b {
        print("Параметра эквивалентны")
    } else if a > b {
        print("Наибольшее значение \(a)")
    } else {
        print("Наибольшее значение \(b)")
    }
}

let oneValueComp = 25.3
let twoValueComp = 32.6
comparable(oneValueComp, twoValueComp)
//Это что?
//Исправил ))

//c) получает на вход два сравниваемых (Comparable) друг с другом значения, сравнивает их и перезаписывает первый входной параметр меньшим из двух значений, а второй параметр — большим;
func changeComparable<T: Comparable>(_ a: inout T, _ b: inout T){
    
    if a > b {
        var temp : T
        temp = a
        a = b
        b = temp
    }
}

var oneValueCh = 365//"bbb"
var twoValueCh = 10//"aaa"
changeComparable(&oneValueCh, &twoValueCh)
oneValueCh
twoValueCh
//Исправил ))
//Задание не требует вывода текста в консоль.
//Достаточно было обменять переменные, если a > b.
//Исправил

//d) получает на вход две функции, которые имеют дженерик — входной параметр Т и ничего не возвращают; сама функция должна вернуть новую функцию, которая на вход получает параметр с типом Т и при своём вызове вызывает две функции и передаёт в них полученное значение (по факту объединяет две функции).

func main<T>(_ func1: @escaping (T) -> Void, _ func2: @escaping (T) -> Void) -> ((T) -> Void) {
  
    return {
        func1($0)
        func2($0)
    }
}

let resultFunc: (String) -> Void = main( { print("\($0) первой функции") }, { print("\($0) второй функции") })
resultFunc("Вызов")
//Реализация также будет немного отличаться.
//Что-то всю голову сломал с этим заданием )) реализовал так, но я думаю не верная реализация
//хотел реализовать без реализации функции threeFunc, а сразу указать return {_ in func1(value), func2(value)}, но так возвращает ошибку
//По условию требуется из функции main возвращать другую функцию, которая при вызове будет вызывать func1 и func2.
//Понял спс

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
//Вызывается встроенная функция max.
//Название вашей maximum.
//Исправил, изначально функцию обозвал max и потом при вызове забыл исправить
array.maximum()

//Что будет?
let ints: [Int] = []
ints.maximum
//функция вернет первый [0] элемент массива, так как массив объявлен пустым то ни чего не вернется
//Точно такое поведение будет?
//Нет, в данном сулчае возвращается () -> Int, внутрь функции мы даже не попадаем

//При пустом массиве обращение к элементу по индексу 0 означает выход за пределы массива.
//Проведете эксперимент, запустив программу?
//И что нужно сделать, чтобы исправить?
//Предположу что нужно как-то ограничить вызов метода подобным условием Element != self.isEmpty, но не получается так реализовать и других мыслей нет ((

//      b) Array, у которого элементы имеют тип Equatable, и добавьте функцию, которая удаляет из массива идентичные элементы.
extension Array where Element: Equatable {
    func unique() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
var arrayTwo = [5, 65, 23, 5, 7, 23, 65, 23, 7]
arrayTwo.unique()

//Если Element: Hashable, то какая может быть другая реализация?
//Протокол Hashable реализует протокол Equatable, поэтому все что применимо к Equatable будет применимо и к Hashable
//Другая реализация с применением цикла, создать временный массив в который в цикле складывать путем сравнения только уникальные элементы из основного массива

//Чем отличается Set от Array?
//Set это множество в нем могуть содержаться только уникальные значения

//Можно ли использовать Set для решения задачи?
//Я почему-то не думал что так просто можно реализовать с помощью множества
extension Array where Element: Hashable {
    func uniqueWithSet() -> Array {
        return Array(Set(self))
    }
}

var arrayThree = [5, 65, 23, 5, 7, 23, 65, 23, 7]
arrayThree.uniqueWithSet()

// 8. Создайте специальный оператор для:

//      a) возведения Int-числа в степень: оператор ^^, работает 2^3, возвращает 8;
infix operator ^^
func ^^(value: Double, exp: Int) -> Double {
    var valueExp = value
    for _ in 1...abs(exp)-1{
        valueExp *= value
    }
    if exp < 0{
        return 1/valueExp
    } else {
        return valueExp
    }
}
2^^3
5^^4
2 ^^ -5
3 ^^ -6

//      b) копирования во второе Int-числа удвоенного значения первого 4 ~> a, после этого a = 8;
infix operator ~>
func ~>(value: Int, double: inout Int){
    double = value * 2
}
var a = 0
4 ~> a
 
//      c) присваивания в экземпляр tableView делегата: myController <* tableView, поле этого myController становится делегатом для tableView;
infix operator <*
func <*(myController: UITableViewDelegate, tableView: UITableView){
    tableView.delegate = myController
}
class VC: UIViewController, UITableViewDelegate {}
let myController = VC()
let tableView = UITableView()
myController <* tableView
//Почему последняя строка закомментирована? 😏
//Как исправить, чтобы работало в соответствии с условием задания?
//Исправил

//      d) суммирует описание двух объектов с типом CustomStringConvertable и возвращает их описание: 7 + “ string” вернет “7 string”.
//struct StructOne<Element>: CustomStringConvertible{
//    var element : Element
//    var description: String{
//        return "\(element)"
//    }
//}
//
//struct StructTwo<Element>: CustomStringConvertible{
//    var element : Element
//    var description: String{
//        return "\(element)"
//    }
//}

infix operator +++
func +++(left: CustomStringConvertible, right: CustomStringConvertible) -> String{
    return "\(left)\(right)"
}
//let left = StructOne(element: 7)
//let right = StructTwo(element: " string")
//left +++ right
//Думаю имелся ввиду тип CustomStringConvertible
//Я пытался найти тип который указан в задании CustomStringConvertable, не нашел и создал свой ))

//Число и строка уже реализуют этот протокол.
7 +++ " string"

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
