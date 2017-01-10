---
type: doc

layout: reference

category: "Syntax"

title: "Control Flow"

---

 

# Control Flow ( 제어 흐름 )

 

## If Expression

 

Kotlin 에서  *if* {: .keyword} 표현식은 반환값을 가집니다.

따라서 삼항연사자는 쓰지않아도 됩니다.(condition ? then : else), 왜냐하면 보통의 경우  *if*{: .keyword } 이 표현식으로도 잘 사용할 수 있기 때문입니다.

 

```kotlin

// Traditional usage ( 전통적인 사용 )

var max = a

if (a < b) max = b

 

// With else

var max: Int

if (a > b) {

    max = a

} else {

    max = b

}

 

// As expression ( 표현식으로 )

val max = if (a > b) a else b
```

 

*if*{: .keyword } 문이 여러 block을 사용할 수 있고, 마지막 표현식은 block 의 값입니다

 

``` kotlin

val max = if (a > b) {

    print("Choose a")

    a

} else {

    print("Choose b")

    b

}

```

 

다른 표현식을 사용하기 보다 *if*{: .keyword } 표현을 사용한다면,  (예를들어, 값을 반환하거나 변수에 할당 할 때) 

'else' 와같은 표현이 필요합니다.

 

문법을 참고할 수 있습니다.  [grammar for *if*{: .keyword }](grammar.html#if).

 

## When Expression

 

*when*{: .keyword } 표현은 c언어의 연산자 같은 switch문을 대신해서 사용할 수 있습니다.  가장 간단한 형태로는 다음과 같습니다.



```
when(x) {

    1 -> print("x == 1")

    2 -> print("x == 2")

    else -> { // Note the block

        print("x is neither 1 nor 2")

    }

}
```

*when*{: .keyword } 은 일부 분기의 조건이 충족 될 때까지 모든 조건 분기에 대해 해당 인수를 순차적으로 찾습니다. 

*when*{: .keyword }은 표현식 또는 statement로 사용할 수 있습니다.  이는 표현식으로 사용되는 경우 , 값은

만족 된 지점의 전체 식의 값이된다. 이것은 문장의 값으로 사용하면

각 지점은 무시됩니다. (그냥 *와 같은 * 경우 {: .keyword}, ​​각 지점은 블록, 그리고 그 값 수

블록의 마지막 식의 값이다.)

