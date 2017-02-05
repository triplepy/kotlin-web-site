---
type: doc
layout: reference
title: "Kotlin 1.1의 새로운 기능"
---

# What's New in Kotlin 1.1
# Kotlin 1.1의 새로운 기능

Kotlin 1.1 is currently [available in beta](https://blog.jetbrains.com/kotlin/2017/01/kotlin-1-1-beta-is-here/). Here you can find a list of new features available in this release.
Note that any new functionality is subject to change before Kotlin 1.1 is released.

Kotlin 1.1은 현재 [베타버전으로 사용할 수 있습니다](https://blog.jetbrains.com/kotlin/2017/01/kotlin-1-1-beta-is-here/). 여기에서 이번 릴리즈로 사용할 수 있는 새로운 기능을 리스트로 확인할 수 있습니다.
Kotlin 1.1이 릴리즈 되기 전에 새로운 기능은 변경될 수 있습니다.

## JavaScript

Starting with Kotlin 1.1, the JavaScript target is no longer considered experimental. All language features are supported,
and there are many new tools for integration with the front-end development environment. See [below](#javascript-backend) for
a more detailed list of changes.

Kotlin 1.1부터 JavaScript 실험은 끝났습니다. 모든 언어 기능이 지원되고 (역자주 *Kotlin으로 작성 된 모든 언어가 JavaScript로 컴파일 될 수 있음), 
프론트엔드 개발환경의 통합을 위한 새로운 도구가 많이 있습니다. 자세한 변경 사항은 [아래](#javascript-backend)쪽을 참조해주세요. 


## 코루틴 (실험판)

The key new feature in Kotlin 1.1 is *coroutines*, bringing the support of `future`/`await`, `yield` and similar programming
patterns. The key feature of Kotlin's design is that the implementation of coroutine execution is part of the libraries,
not the language, so you aren't bound to any specific programming paradigm or concurrency library.

Kotlin 1.1의 새로운 핵심 기능은 *코루틴 (coroutines)*이며 `future` / `await`, `yield` 및 유사한 프로그래밍 패턴을 지원합니다.
Kotlin의 디자인 핵심 기능은 코루틴 실행의 구현이 라이브러리의 일부이며, 언어가 아니기 때문에 특정 프로그래밍 패러다임이나 동시성 라이브러리에 구속되지 않습니다.

A coroutine is effectively a light-weight thread that can be suspended and resumed later. A coroutine is started with a coroutine builder function and is suspended with special suspending functions. For example, `future` starts a coroutine and, when you use `await`, the execution of the coroutine is suspended while the operation being awaited is executed, and is resumed (possibly on a different thread) when the operation being awaited completes.

코루틴은 일시 중지되고 나중에 다시시작 할 수 있는 효과적인 가벼운 스레드 입니다. 코루틴은 코루틴 빌더로 시작되고 특수 중단 함수로 중단 됩니다. 예를 들어 `future`는 코루틴을 시작하고 `await`를 사용하면 await 작업이 실행되는 동안 코루틴이 중단되고 await 작업이 완료되면 코루틴은 재개됩니다.

The standard library uses coroutines to support *lazily generated sequences* with `yield` and `yieldAll` functions.
In such a sequence, the block of code that returns sequence elements is suspended after each element has been retrieved,
and resumed when the next element is requested. Here's an example:

표준 라이브러리는 코루틴을 사용하여 `yield`와 `yieldAll` 함수로 *지연 생성 시퀀스*를 지원합니다. 이러한 시퀀스에서 시퀀스 요소를 반환하는 코드블럭은 각 요소를 받은 후 중단되며 다음 요소가 요청 될 때 재개됩니다.
다음 예제를 확인해보세요.

``` kotlin
val seq = buildSequence {
    println("Yielding 1")
    yield(1)
    println("Yielding 2")
    yield(2)
    println("Yielding a range")
    yieldAll(3..5)
}

for (i in seq) {
    println("Generated $i")
}
```

출력 값:

```
Yielding 1
Generated 1
Yielding 2
Generated 2
Yielding a range
Generated 3
Generated 4
Generated 5
```

The implementation of `future`/`await` is provided as an external library, [kotlinx.coroutines](https://github.com/kotlin/kotlinx.coroutines).
Here's an example showing its use:

`future`/`await` 구현은 외부 라이브러리 [kotlinx.coroutines](https://github.com/kotlin/kotlinx.coroutines)로 제공됩니다. 다음은 사용법 예제 입니다.

``` kotlin
future {
    val original = asyncLoadImage("...original...") // Future 생성
    val overlay = asyncLoadImage("...overlay...")   // Future 생성
    ...
    // suspend while awaiting the loading of the images
    // then run `applyOverlay(...)` when they are both loaded
    // 이미지 로딩을 대기하는 동안 중단
    // 둘 다 로드되었을 때 `applyOverlay(...)`을 실행
    return applyOverlay(original.await(), overlay.await())
}
```

kotlinx.coroutines `future` implementation relies on `CompletableFuture` and therefore requires JDK 8, but it also provides portable `defer` primitive and it's possible to build other implementations.

kotlinx.coroutines `future` 구현은 `CompletableFuture`에 의존하기 때문에 JDK 8이 필요합니다만, 이식가능한 `defer` 프리미티브를 제공하기도 하여 다른 구현을 만들 수 있습니다.

The [KEEP document](https://github.com/Kotlin/kotlin-coroutines/blob/master/kotlin-coroutines-informal.md) provides an extended
description of the coroutine functionality.

[KEEP document](https://github.com/Kotlin/kotlin-coroutines/blob/master/kotlin-coroutines-informal.md)는 코루틴 기능에 대한 자세한 설명을 제공합니다. 

Note that coroutines are currently considered an **experimental feature**, meaning that the Kotlin team is not committing
to supporting the backwards compatibility of this feature after the final 1.1 release.

코루틴은 현재 **실험적 기능**으로 Kotlin 팀이 최종 1.1 릴리즈 이후 이 기능이 하위 호환성을 지원한다는 않을 수 있음을 의미합니다.

## Other Language Features

### 타입 별칭

A type alias allows you to define an alternative name for an existing type.
This is most useful for generic types such as collections, as well as for function types.
Here are a few examples:

타입 별칭을 사용하면 기존 타입에 대한 대체 이름을 정의 할 수 있습니다.
이 것은 콜렉션과 같은 제네릭 타입 및 함수 타입에 가장 유용합니다. 다음은 몇 가지 예제입니다. 

``` kotlin
typealias FileTable<K> = MutableMap<K, MutableList<File>>

typealias MouseEventHandler = (Any, MouseEvent) -> Unit
```

자세한 내용은 [KEEP](https://github.com/Kotlin/KEEP/blob/master/proposals/type-aliases.md)을 확인하세요. 


### Bound callable references

You can now use the `::` operator to get a [member reference](reflection.html#function-references) pointing to a method or property of a specific object instance.
Previously this could only be expressed with a lambda.
Here's an example:

`::` 연산자를 사용하여 특정 객체 인스턴스의 메소드나 속성을 가리키는 [멤버 참조](reflection.html#function-references)를 얻을 수 있습니다.
이전에 이것은 람다로만 표현할 수 있었습니다.

``` kotlin
val numberRegex = "\\d+".toRegex()
val numbers = listOf("abc", "123", "456").filter(numberRegex::matches)
// Result is list of "123", "456"
```

자세한 내용은 [KEEP](https://github.com/Kotlin/KEEP/blob/master/proposals/bound-callable-references.md)을 확인하세요.


### Sealed and data classes

Kotlin 1.1 removes some of the restrictions on sealed and data classes that were present in Kotlin 1.0.
Now you can define subclasses of a sealed class anywhere in the same file, and not just as nested classes of the sealed class.
Data classes can now extend other classes.
This can be used to define a hierarchy of expression classes nicely and cleanly:

Kotlin 1.1은 Kotlin 1.0에 있는 데이터 클래스 및 클래스에 대한 일부 제약이 제거됩니다.
이제 봉인 클래스의 하위 클래스를 동일한 파일에 정의 할 수 있으며 봉인 클래스의 중첩 클래스가 아닌 클래스의 하위 클래스를 정의할 수 있습니다.
데이터 클래스는 이제 다른 클래스를 확장할 수 있습니다.
이것은 표현 클래스의 계층 구조를 명확하게 정의하는 데 사용할 수 있습니다.

``` kotlin
sealed class Expr

data class Const(val number: Double) : Expr()
data class Sum(val e1: Expr, val e2: Expr) : Expr()
object NotANumber : Expr()

fun eval(expr: Expr): Double = when (expr) {
    is Const -> expr.number
    is Sum -> eval(expr.e1) + eval(expr.e2)
    NotANumber -> Double.NaN
}
```

자세한 내용은 [봉인 클래스](https://github.com/Kotlin/KEEP/blob/master/proposals/sealed-class-inheritance.md)와 
[데이터 클래스](https://github.com/Kotlin/KEEP/blob/master/proposals/data-class-inheritance.md)를 확인하세요.


### Destructuring in lambdas

You can now use the [destructuring declaration](multi-declarations.html) syntax to unpack the arguments passed to a lambda.
Here's an example:

이제 [구조분해 선언](multi-declarations.html) 문법을 사용하여 람다에 전달 된 인수를 해제할 수 있습니다.
다음은 예제입니다.

``` kotlin
map.mapValues { (key, value) -> "$value!" }
```

자세한 내용은 [KEEP](https://github.com/Kotlin/KEEP/blob/master/proposals/destructuring-in-parameters.md)을 참조하세요.


### 사용되지 않은 파라미터에 대한 언더스코어

For a lambda with multiple parameters, you can use the `_` character to replace the names of the parameters you don't use:

다수의 파라미터를 가진 람다의 경우, `_` 문자를 사용하여 사용하지 않은 파라미터의 이름을 변경할 수 있습니다 :

``` kotlin
map.forEach { _, value -> println("$value!") }
```

이것은 또한 [구조분해 선언](multi-declarations.html):에서도 작동합니다.

``` kotlin
val (_, status) = getResult()
```

자세한 내용은 [KEEP](https://github.com/Kotlin/KEEP/blob/master/proposals/underscore-for-unused-parameters.md)을 참조하세요.


### 숫자 리터럴에서 언더스코어

Just as in Java 8, Kotlin now allows to use underscores in numeric literals to separate groups of digits:

Java 8에서와 마찬가지로 Kotlin은 숫자 리터럴(numeric literals)에서 언더스코어를 사용하여 숫자(digits) 그룹을 구분할 수 있습니다.

``` kotlin
val oneMillion = 1_000_000
val hexBytes = 0xFF_EC_DE_5E
val bytes = 0b11010010_01101001_10010100_10010010
```

자세한 내용은 [KEEP](https://github.com/Kotlin/KEEP/blob/master/proposals/underscores-in-numeric-literals.md)을 참조하세요.


### 프로퍼티를 위한 짧은 구문

For properties without custom accessors, or with the getter defined as an expression body, the property type can now be omitted:

사용자 접근자가 없는 프로퍼티의 경우, 또는 표현식 본문으로 정의 된 getter를 사용하면 이제 프로퍼티 타입을 생략 할 수 있습니다.  
``` kotlin
val name = ""

val lazyName get() = ""
```

For both of these properties, the compiler will infer that the property type is `String`.

두 프로퍼티의 경우, 컴파일러는 프로퍼티 타입이 `String`이라고 추론할 것입니다.


### 인라인 프로퍼티 접근자

You can now mark property accessors with the `inline` modifier if the properties don't have a backing field.
Such accessors are compiled in the same way as [inline functions](inline-functions.html).

프로퍼티에 backing field가 없는 경우, 프로퍼티 접근자를 `inline` 제한자로 표시할 수 있습니다.
이러한 접근자는 [인라인 함수](inline-functions.html)와 같은 방식으로 컴파일 됩니다.

``` kotlin
val foo: Foo
    inline get() = Foo()
```

자세한 내용은 [KEEP](https://github.com/Kotlin/KEEP/blob/master/proposals/inline-properties.md)을 참조하세요


### 지역 위임 프로퍼티

You can now use the [delegated property](delegated-properties.html) syntax with local variables.
One possible use is defining a lazily evaluated local variable:

이제 [위임 프로퍼티](delegated-properties.html) 문법을 로컬 변수와 함께 사용할 수 있습니다.
한 가지 가능한 방법은 지연 연산 된 지역 변수를 정의하는 것입니다.

``` kotlin
fun foo() {
    val data: String by lazy { /* calculate the data */ }
    if (needData()) {
        println(data)   // data is calculated at this point
    }
}
```

자세한 내용은 [KEEP](https://github.com/Kotlin/KEEP/blob/master/proposals/local-delegated-properties.md)을 참조하세요.


### 위임 프로퍼티 바인딩 차단

For [delegated properties](delegated-properties.html), it is now possible to intercept delegate to property binding using the
`provideDelegate` operator.
For example, if we want to check the property name before binding, we can write something like this:

[위임 프로퍼티](delegated-properties.html)의 경우, `provideDelegate`연산자를 사용하여 프로퍼티 바인딩에 위임하는 것을 가로 챌 수 있습니다.
예를들어, 바인딩하기 전에 프로퍼티의 이름을 확인하려면 다음과 같이 작성할 수 있습니다.

``` kotlin
class ResourceLoader<T>(id: ResourceID<T>) {
    operator fun provideDelegate(thisRef: MyUI, property: KProperty<*>): ReadOnlyProperty<MyUI, T> {
        checkProperty(thisRef, property.name)
        ... // 프로퍼티 생성
    }

    private fun checkProperty(thisRef: MyUI, name: String) { ... }
}

fun <T> bindResource(id: ResourceID<T>): ResourceLoader<T> { ... }

class MyUI {
    val image by bindResource(ResourceID.image_id)
    val text by bindResource(ResourceID.text_id)
}
```

The `provideDelegate` method will be called for each property during the creation of a `MyUI` instance, and it can perform
the necessary validation right away.

`provideDelegate` 메서드는 `MyUI` 인스턴스를 생성하는 동안 각 프로퍼티에 대해 호출 될 것이고, 필요한 검증을 즉시 수행 할 수 있습니다.


### 일반 enum 값 접근

It is now possible to enumerate the values of an enum class in a generic way:

enum 클래스의 값을 빈반적으로 열거 할 수 있습니다.

``` kotlin
enum class RGB { RED, GREEN, BLUE }

print(enumValues<RGB>().joinToString { it.name }) // RED, GREEN, BLUE 출력
```


### DSL에서 암시적 리시버를 위한 스코프 제어

The `@DslMarker` annotation allows to restrict the use of receivers from outer scopes in a DSL context.
Consider the canonical [HTML builder example](type-safe-builders.html):

`@DslMarker` 주석은 DSL 문맥에서 외부 스코프로부터 리시버의 사용을 제한 할 수 있게 해줍니다.
정규 [HTML 빌더 예제](type-safe-builders.html)를 고려해보세요.

``` kotlin
table {
    tr {
        td { +"Text" }
    }
}
```

In Kotlin 1.0, code in the lambda passed to `td` has access to three implicit receivers: the one passed to `table`, to `tr`
and to `td`. This allows you to call methods that make no sense in the context - for example to call `tr` inside `td` and thus
to put a `<tr>` tag in a `<td>`.

Kotlin 1.0에서 `td`에 전달 된 람다 코드는 3개의 암시적 리시버인 : `table`에서, `tr`로, 그리고 `td`로 전달 됩니다.
이렇게 되면 문맥에서 의미가 없는 메소드를 호출 하는 것을 허용할 수 있습니다. 예를 들어, `td`에서 `tr`을 호출하고 `<tr>`태그를 `<td>`에 넣을 수 있습니다.

In Kotlin 1.1, you can restrict that, so that only methods defined on the implicit receiver of `td`
will be available inside the lambda passed to `td`. You do that by defining your annotation marked with the `@DslMarker` meta-annotation
and applying it to the base class of the tag classes:

Kotlin 1.1에서는 이를 제한 할 수 있으므로, `td`의 암시적 리시버에 정의 된 메소드만 `td`에 전달 된 람다 안에서 사용할 수 있습니다.
`@DslMarker` 메타주석으로 표시 된 주석을 정의하고 이를 태그 클래스의 베이스 클래스로 적용하면 됩니다. 


``` kotlin
@DslMarker
annotation class HtmlTagMarker

@HtmlTagMarker
abstract class Tag(val name: String) { ... }

class TD() : Tag("td") { ... }

fun Tag.td(init: TD.() -> Unit) {
}
```

Now that the implicit receiver of the `init` lambda passed to the `td` function is a class annotated with `@HtmlTagMarker`,
so the outer receivers of types which also have this annotation will be blocked.

이제 `td` 함수에 전달 된 `init` 람다의 암묵적 리시버는 `@HtmlTagMarker`로 주석 처리 된 클래스이므로, 이 주석을 가진 타입의 외부 리시버는 차단 될 것 입니다. 

자세한 내용은 [KEEP](https://github.com/Kotlin/KEEP/blob/master/proposals/scope-control-for-implicit-receivers.md)을 참고하세요.


### `rem` 연산자

The `mod` operator is now deprecated, and `rem` is used instead. See [this issue](https://youtrack.jetbrains.com/issue/KT-14650) for motivation.

`mod` 연산자는 더 이상 사용되지 않으며 대신 `rem`이 사용됩니다. 바뀌게 된 계기는 [이슈](https://youtrack.jetbrains.com/issue/KT-14650)를 확인하세요.

## 표준 라이브러리

### String to number 변환

There is a bunch of new extensions on the String class to convert it to a number without throwing an exception on invalid number:
`String.toIntOrNull(): Int?`, `String.toDoubleOrNull(): Double?` etc.

String 클래스에는 잘못 된 숫자에 예외를 던지지 않고 숫자로 변환하는 새로운 익스텐션이 있습니다.
`String.toIntOrNull(): Int?`, `String.toDoubleOrNull(): Double?` 등.

Also integer conversion functions, like `Int.toString()`, `String.toInt()`, `String.toIntOrNull()`,
each got an overload with `radix` parameter, which allows to specify the base of conversion.

또한 `Int.toString()`, `String.toInt()`, `String.toIntOrNull()`과 같은 정수 변환 함수는 `radix` 파라미터로 오버로드를 가지므로 변환의 베이스를 허용할 수 있습니다. 

### onEach()

`onEach` is a small, but useful extension function for collections and sequences, which allows to perform some action,
possibly with side-effects, on each element of the collection/sequence in a chain of operations.
On iterables it behaves like `forEach` but also returns the iterable instance further. And on sequences it returns a
wrapping sequence, which applies the given action lazily as the elements are being iterated.

`onEach`는 작지만 콜렉션과 시퀀스를 위한 유용한 확장 함수로서, 일련의 연산에서 콜렉션 / 시퀀스의 각 요소에 대해 부작용이 있을 수 있는 일부 동작을 수행 할 수 있습니다. 
이터러블에서 `forEach`와 같이 동작하지만 이터러블 인스턴스를 더 반환합니다. 그리고 시퀀스에서 래핑 시퀀스를 반환합니다. 래핑 시퀀스는 요소가 반복되는 동안 지연된 동작을 적용합니다.

### takeIf() 그리고 also()

These are two general-purpose extension functions applicable to any receiver.

이들은 어떠한 리시버에도 적용 할 수 있는 두 가지 범용 확장 함수 입니다.
 
`also` is like `apply`: it takes the receiver, does some action on it, and returns that receiver. 
The difference is that in the block inside `apply` the receiver is available as `this`, 
while in the block inside `also` it's available as `it` (and you can give it another name if you want).
This comes handy when you do not want to shadow `this` from the outer scope:

`also`는 `apply`와 같습니다: 리시버를 갖고, 어떤 행동을 수행 하고나서 리시버를 반환합니다. 
두 가지의 차이점은 `apply`는 내부의 블록에서 리시버가 `this`로 사용 가능하지만, `also`는 내부의 블록에서 `it`로 사용이 가능합니다. (원한다면 다른 이름도 부여 가능합니다.)
이것은 바깥 쪽 범위에서 `this`를 숨기고 싶지 않을 때 편리합니다 :

```kotlin
fun Block.copy() = Block().also { it.content = this.content }
```

`takeIf` is like `filter` for a single value. It checks whether the receiver meets the predicate, and
returns the receiver, if it does or `null` if it doesn't. 
Combined with an elvis-operator and early returns it allows to write constructs like:

`takeIf`는 단일 값에 대해 `filter`와 같습니다. 리시버가 술어인지 아닌지 여부를 확인한 후 리시버를 반환하고 수신자가 없으면 `null`을 반환 합니다.

```kotlin
val outDirFile = File(outputDir.path).takeIf { it.exists() } ?: return false
// do something with existing outDirFile

val index = input.indexOf(keyword).takeIf { it >= 0 } ?: error("keyword not found")
// do something with index of keyword in input string, given that it's found
```


### groupingBy()

This API can be used to group a collection by key and fold each group simultaneously. For example, it can be used
to count the frequencies of characters in a text:

이 API를 사용하여 key로 컬렉션을 그룹화하고 각 그룹을 동시에 폴드 할 수 있습니다. 예를들어, 텍스트의 문자 빈도를 세는 데 사용할 수 있습니다.

``` kotlin
val frequencies = words.groupingBy { it }.eachCount()
```

### Map.toMap() 그리고 Map.toMutableMap()

These functions can be used for easy copying of maps:

이 함수를 사용하여 map을 쉽게 복사할 수 있습니다.

``` kotlin
class ImmutablePropertyBag(map: Map<String, Any>) {
    private val mapCopy = map.toMap()
}
```

### minOf() 그리고 maxOf()

These functions can be used to find the minimum and maximum of two given numbers.

이 함수는 주어진 두 숫자의 최소값과 최대값을 찾는 데 사용할 수 있습니다.

### Array 같은 List 인스턴스화 함수

Similar to the `Array` constructor, there are now functions that create `List` and `MutableList` instances and initialize
each element by calling a lambda:

`Array` 생성자와 비슷하게, `List`와 `MutableList` 인스턴스를 생성하고 람다를 호출하여 각 요소를 초기화하는 함수가 있습니다.

``` kotlin
List(size) { index -> element }
MutableList(size) { index -> element }
```

### Map.getValue()

This method on `Map` returns an existing value corresponding to the given key or throws an exception, mentioning which key was not found.
If the map was produced with `withDefault`, this method will return the default value instead of throwing an exception.

이 메서드는 `Map`에 주어진 키에 상응하는 기존 값을 반환하거나 어떤 키가 발견되지 않았는지에 대한 예외를 던집니다. Map이 `withDefault`를 사용해 생성 된 경우, 이 메서드는 예외를 던지는 대신 기본값을 반환합니다.

### 추상 컬렉션

These abstract classes can be used as base classes when implementing Kotlin collection classes.
For implementing read-only collections there are `AbstractCollection`, `AbstractList`, `AbstractSet` and `AbstractMap`, 
and for mutable collections there are `AbstractMutableCollection`, `AbstractMutableList`, `AbstractMutableSet` and `AbstractMutableMap`.
On JVM these abstract mutable collections inherit most of their functionality from JDK's abstract collections.

추상 클래스는 Kotlin 컬렉션 클래스를 구현할 때 기본 클래스로 사용할 수 있습니다. 
읽기 전용 콜렉션을 구현하기 위해 `AbstractCollection`, `AbstractList`, `AbstractSet` 그리고 `AbstractMap` 이 있으며, 
뮤터블 콜렉션에는 `AbstractMutableCollection`, `AbstractMutableList`, `AbstractMutableSet` 그리고 `AbstractMutableMap`이 있습니다.
JVM에서 이러한 추상 뮤터블 컬렉션은 JDK의 추상 컬렉션에서 대부분의 기능을 상속받습니다. 

## JVM 백엔드

### Java 8 바이트코드 지원

Kotlin has now the option of generating Java 8 bytecode (`-jvm-target 1.8` command line option or the corresponding options
in Ant/Maven/Gradle). For now this doesn't change the semantics of the bytecode (in particular, default methods in interfaces
and lambdas are generated exactly as in Kotlin 1.0), but we plan to make further use of this later.

Kotlin은 이제 Java 8 바이트 코드 (`-jvm-target 1.8` 명령 행 옵션 또는 Ant / Maven / Gradle 유사한 옵션).
현재로서는 바이트 코드의 의미를 변경하지 않습니다만, (특히 인터페이스 및 람다의 기본 메서드는 Kotlin 1.0에서와 같이 정확하게 생성됩니다.) 저희는 나중에 이를 만들어 사용할 계획입니다.

### Java 8 표준 라이브러리 지원

There are now separate versions of the standard library supporting the new JDK APIs added in Java 7 and 8.
If you need access to the new APIs, use `kotlin-stdlib-jre7` and `kotlin-stdlib-jre8` maven artifacts instead of the standard `kotlin-stdlib`.
These artifacts are tiny extensions on top of `kotlin-stdlib` and they bring it to your project as a transitive dependency.

Java 7 및 8에 추가 된 새 JDK API를 지원하는 표준 라이브러리의 별도 버전이 있습니다. 새 API에 대한 접근이 필요하면 표준 `kotlin-stdlib` 대신 `kotlin-stdlib-jre7` 및 `kotlin-stdlib-jre8` maven 아티팩트를 사용하세요.
이 아티팩트는 `kotlin-stdlib`의 맨 위에 있는 작은 익스텐션들이며, 여러분의 프로젝트에 추이 종속성으로 가져옵니다.

### 바이트코트에서 파라미터 이름

Kotlin now supports storing parameter names in the bytecode. This can be enabled using the `-java-parameters` command line option.

Kotlin은 이제 바이트 코드에 파라미터 이름을 저장하는 것을 지원합니다. 이것은 `-java-parameters` 명령 행 옵션을 사용하여 가능하도록 할 수 있습니다.

### 인라이닝 상수

The compiler now inlines values of `const val` properties into the locations where they are used.

컴파일러는 `const val` 프로퍼티 값을 사용 된 위치로 인라인 합니다.

### 뮤터블 클로져 변수

The box classes used for capturing mutable closure variables in lambdas no longer have volatile fields. This change improves
performance, but can lead to new race conditions in some rare usage scenarios. If you're affected by this, you need to provide
your own synchronization for accessing the variables.

람다에서 뮤터블 클로저 변수를 캡쳐하는 데 사용되는 박스 클래스는 더 이상 휘발성 필드를 갖지 않습니다. 이 변경으로 인해 성능은 향상되지만 드물지만 사용하면서 특정 상황에 새로운 경쟁 조건이 발생할 수도 있습니다.
이 문제의 영향을 받으면 변수에 엑세스 하기 위해 자체 동기화를 제공해야 합니다.


### javax.scripting 지원

Kotlin now integrates with the [javax.script API](https://docs.oracle.com/javase/8/docs/api/javax/script/package-summary.html) (JSR-223). See [here](https://github.com/JetBrains/kotlin/tree/master/libraries/examples/kotlin-jsr223-local-example)
for an example project using the API.

Kotlin은 이제 [javax.script API](https://docs.oracle.com/javase/8/docs/api/javax/script/package-summary.html) (JSR-223)와 통합됩니다. API를 사용하는 예제 프로젝트는 [여기](https://github.com/JetBrains/kotlin/tree/master/libraries/examples/kotlin-jsr223-local-example)를 확인하세요.


## JavaScript 백엔드

### 통합 표준 라이브러리

A much larger part of the Kotlin standard library can now be used from code compiled to JavaScript.
In particular, key classes such as collections (`ArrayList`, `HashMap` etc.), exceptions (`IllegalArgumentException` etc.) and a few
others (`StringBuilder`, `Comparator`) are now defined under the `kotlin` package. On the JVM, the names are type
aliases for the corresponding JDK classes, and on the JS, the classes are implemented in the Kotlin standard library.

Kotlin 표준 라이브러리의 훨씬 더 많은 부분이 이제 컴파일 된 코드에서 JavaScript로 사용될 수 있습니다.
특히 콜렉션 (`ArrayList`, `HashMap` 등), 예외 (`IllegalArgumentException` 등)와 몇가지 다른 것들 (`StringBuilder`, `Comparator`)과 같은 키 클래스는 `kotlin` 패키지에 정의되어 있습니다.
JVM에서 해당 이름은 해당 JDK 클래스의 타입 별칭이며 JS에서는 클래스가 Kotlin 표준 라이브러리에 구현됩니다.

### 더 나은 코드 생성

JavaScript backend now generates more statically checkable code, which is friendlier to JS code processing tools,
like minifiers, optimisers, linters, etc.

JavaScript 백엔드는 이제 정적으로 검사 가능한 코드를 생성합니다. 이 코드는 minifier, optimisers, linters 등과 같은 JS 코드 처리 도구에 친숙합니다. 

### `external` 제한자

If you need to access a class implemented in JavaScript from Kotlin in a typesafe way, you can write a Kotlin
declaration using the `external` modifier. (In Kotlin 1.0, the `@native` annotation was used instead.)
Unlike the JVM target, the JS one permits to use external modifier with classes and properties.
For example, here's how you can declare the DOM `Node` class:

타입세이프 방식으로 Kotlin에서 JavaScript로 구현 된 클래스에 접근해야 하는 경우, Kotlin `external` 제한자를 사용하여 선언 할 수 있습니다. (Kotlin 1.0에서는 `@native` 주석이 대신 사용되었습니다.)
JVM과 달리 JS에서는 클래스 및 속성과 함께 외부 제한자를 사용할 수 있습니다.
예를 들어, 다음은 DOM `Node` 클래스를 선언하는 방법입니다.

``` kotlin
external class Node {
    val firstChild: Node

    fun appendChild(child: Node): Node

    fun removeChild(child: Node): Node

    // 등..
}
```

### 임포트 처리 개선

You can now describe declarations which should be imported from JavaScript modules more precisely.
If you add the `@JsModule("<module-name>")` annotation on an external declaration it will be properly imported
to a module system (either CommonJS or AMD) during the compilation. For example, with CommonJS the declaration will be
imported via `require(...)` function.
Additionally, if you want to import a declaration either as a module or as a global JavaScript object,
you can use the `@JsNonModule` annotation.

For example, here's how you can import JQuery into a Kotlin module:

JavaScript 모듈에서 가져와야하는 선언을 보다 정확하게 선언할 수 있습니다. `@JsModule("<module-name>")` 주석을 외부 선언에 추가하면 컴파일 과정에서 모듈 시스템 (CommonJS 또는 AMD)로 적절하게 임포트 됩니다. 예를 들어, CommonJS를 사용하면 `require (...)`함수를 통해 선언을 가져올 수 있습니다.
또한 선언을 모듈이나 전역 JavaScript 객체로 가져오려면 `@JsNonModule` 주석을 사용할 수 있습니다.
예를들어, JQuery를 Kotlin 모듈로 가져오는 방법은 다음과 같습니다.
 
``` kotlin
@JsNonModule
@JsName("$")
external abstract class JQuery {
    fun toggle(duration: Int = 0): JQuery
    fun click(handler: (Event) -> Unit): JQuery
}

@JsModule("jquery")
@JsNonModule
@JsName("$")
external fun JQuery(selector: String): JQuery
```

In this case, JQuery will be imported as a module named `jquery`. Alternatively, it can be used as a $-object,
depending on what module system Kotlin compiler is configured to use.

You can use these declarations in your application like this:

이 경우 JQuery는 `jquery`라는 모듈로 가져올 것입니다. 또는 $-object로 사용할 수 있습니다. Kotlin 컴파일러가 사용하도록 구성된 모듈 시스템에 따라 다릅니다.
이러한 선언은 다음과 같이 애플리케이션에서 사용할 수 있습니다.

``` kotlin
fun main(args: Array<String>) {
    JQuery(".toggle-button").click {
        JQuery(".toggle-panel").toggle(300)
    }
}
```
