// RUN: %dafny /env:0 /dprint:"%t.dfy" /compile:0 "%s" > "%t.result"
// RUN: %diff "%s.expect" "%t.result"

module A {
 export Spec provides T, f
 export Body provides f reveals T

 datatype T = CT1 | CT2 (X: int)

 function f(): T { CT1 }
}

module B {
  import A`Spec

  function g(): A.T { A.f() }
}

module C {
  import A`Body
  import B

  function g(): A.T { A.CT1 }

  function h(x : A.T): int { 
    match x 
      case CT1 => 0 
      case CT2(n) => n
  }
  function k(x : A.T): int { if x.CT1? then 1 else x.X }
  function i(): int {
    match B.g()
       case CT1 => 0
       case CT2(n) => n
  }
}

module CBad {
  import A`Spec

  function g(): A.T { A.CT1 } //can't construct one

  function h(x : A.T): int { 
    match x //can't match
      case CT1 => 0 
      case CT2(n) => n //constructor not resolved, so error here
  }
  function k(x : A.T): int { if x.CT1? then 1 else x.X } // can't access destructors
}

