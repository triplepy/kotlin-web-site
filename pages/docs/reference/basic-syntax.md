---
type: doc
layout: reference
category: "Basics"
title: "Basic Syntax"
---

# 기본 문법

## 패키지 정의

패키지 명세는 소스 파일 상단에 위치해야합니다.

``` kotlin
package my.demo

import java.util.*

// ...
```

디렉토리와 패키지는 일치하지 않아도 됩니다. 소스파일은 파일 시스템 내 어느 장소에나 위치할 수 있습니다.  

자세한 내용은 [Packages](packages.html)를 참조하세요. 

## 함수 정의

두 개의 `Int`형 파라미터와 `Int`형 리턴 타입을 갖는 함수 :

``` kotlin
fun sum(a: Int, b: Int): Int {
    return a + b
}
```

식 몸체와 리턴 타입을 추론하는 함수 :

``` kotlin
fun sum(a: Int, b: Int) = a + b
```

의미 있는 값을 리턴하지 않는 함수 :

``` kotlin
fun printSum(a: Int, b: Int): Unit {
    print(a + b)
}
```

`Unit` 리턴 타입은 생략할 수 있습니다 :

``` kotlin
fun printSum(a: Int, b: Int) {
    print(a + b)
}
```

자세한 내용은 [Functions](functions.html)를 참조하세요.

## 로컬 변수 정의

한 번만 대입할 수 있는 (읽기 전용) 로컬 변수:

``` kotlin
val a: Int = 1
val b = 1   // `Int` type is inferred
val c: Int  // Type required when no initializer is provided
c = 1       // definite assignment
```

변경가능한 변수

``` kotlin
var x = 5 // `Int` type is inferred
x += 1
```

자세한 내용은 [Properties And Fields](properties.html)를 참조하세요.


## 주석

Java와 JavaScript처럼 Kotlin 역시 라인 주석과 블럭 주석을 지원합니다.

``` kotlin
// 이게 end-of-line (라인 주석) 입니다.

/* 이 것은 블록 주석 입니다.
   여러 줄로 작성할 수 있습니다. */
```

Java와는 다르게 Kotlin의 블록 주석은 중첩이 가능합니다.

주석 문법에 대한 자세한 내용은 [코틀린 코드의 문서화](kotlin-doc.html)를 참조하세요.

## 문자열 템플릿 사용

``` kotlin
fun main(args: Array<String>) {
    if (args.size == 0) return

    print("First argument: ${args[0]}")
}
```

자세한 내용은 [문자열 템플릿](basic-types.html#string-templates)를 참조하세요.

## 조건식 사용

``` kotlin
fun max(a: Int, b: Int): Int {
    if (a > b) {
        return a
    } else {
        return b
    }
}
```

*if*{: .keyword }를 식으로 사용:

``` kotlin
fun max(a: Int, b: Int) = if (a > b) a else b
```

자세한 내용은 [*if*{: .keyword }-expressions](control-flow.html#if-expression)를 참조하세요.

## Using nullable values and checking for *null*{: .keyword }

A reference must be explicitly marked as nullable when *null*{: .keyword } value is possible.

Return *null*{: .keyword } if `str` does not hold an integer:

``` kotlin
fun parseInt(str: String): Int? {
    // ...
}
```

Use a function returning nullable value:

``` kotlin
fun main(args: Array<String>) {
    if (args.size < 2) {
        print("Two integers expected")
        return
    }

    val x = parseInt(args[0])
    val y = parseInt(args[1])

    // Using `x * y` yields error because they may hold nulls.
    if (x != null && y != null) {
        // x and y are automatically cast to non-nullable after null check
        print(x * y)
    }
}
```

or

``` kotlin
    // ...
    if (x == null) {
        print("Wrong number format in '${args[0]}'")
        return
    }
    if (y == null) {
        print("Wrong number format in '${args[1]}'")
        return
    }

    // x and y are automatically cast to non-nullable after null check
    print(x * y)
```

See [Null-safety](null-safety.html).

## Using type checks and automatic casts

The *is*{: .keyword } operator checks if an expression is an instance of a type.
If an immutable local variable or property is checked for a specific type, there's no need to cast it explicitly:

``` kotlin
fun getStringLength(obj: Any): Int? {
    if (obj is String) {
        // `obj` is automatically cast to `String` in this branch
        return obj.length
    }

    // `obj` is still of type `Any` outside of the type-checked branch
    return null
}
```

or

``` kotlin
fun getStringLength(obj: Any): Int? {
    if (obj !is String) return null

    // `obj` is automatically cast to `String` in this branch
    return obj.length
}
```

or even

``` kotlin
fun getStringLength(obj: Any): Int? {
    // `obj` is automatically cast to `String` on the right-hand side of `&&`
    if (obj is String && obj.length > 0) {
        return obj.length
    }

    return null
}
```

See [Classes](classes.html) and [Type casts](typecasts.html).

## Using a `for` loop

``` kotlin
fun main(args: Array<String>) {
    for (arg in args) {
        print(arg)
    } 
}
```

or

``` kotlin
for (i in args.indices) {
    print(args[i])
} 
```

See [for loop](control-flow.html#for-loops).

## Using a `while` loop

``` kotlin
fun main(args: Array<String>) {
    var i = 0
    while (i < args.size) {
        print(args[i++])
    }  
}
```

See [while loop](control-flow.html#while-loops).

## Using `when` expression

``` kotlin
fun cases(obj: Any) {
    when (obj) {
        1          -> print("One")
        "Hello"    -> print("Greeting")
        is Long    -> print("Long")
        !is String -> print("Not a string")
        else       -> print("Unknown")
    }
}
```

See [when expression](control-flow.html#when-expression).

## Using ranges

Check if a number is within a range using *in*{: .keyword } operator:

``` kotlin
if (x in 1..y-1) {
    print("OK")
}
```

Check if a number is out of range:

``` kotlin
if (x !in 0..array.lastIndex) {
    print("Out")
}
```

Iterating over a range:

``` kotlin
for (x in 1..5) {
    print(x)
}
```

See [Ranges](ranges.html).

## Using collections

Iterating over a collection:

``` kotlin
for (name in names) {
    println(name)
}
```

Checking if a collection contains an object using *in*{: .keyword } operator:

``` kotlin
if (text in names) { // names.contains(text) is called
    print("Yes")
}
```

Using lambda expressions to filter and map collections:

``` kotlin
names
        .filter { it.startsWith("A") }
        .sortedBy { it }
        .map { it.toUpperCase() }
        .forEach { print(it) }
```

See [Higher-order functions and Lambdas](lambdas.html).
