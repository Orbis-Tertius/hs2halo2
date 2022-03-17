{-# LANGUAGE NoImplicitPrelude #-}


-- Sigma_1^1 formulas over the language {0,1,-1,+,*} of rings.
-- A Sigma^1_1 formula is a first order logic formula surrounded
-- by zero or more second-order existential quantifiers quantifying
-- over unary functions on the ring domain.
module Sigma11Ring
  ( SecondOrderFormula (SecondOrderFormula)
  , SecondOrderQuantifier (ExistsFunction)
  , FirstOrderFormula (Exists, ForAll, And, Or, Not, Top, Bottom, Equals)
  , Term (Apply, Plus, Times, Constant, Variable)
  , FunctionName (FunctionName)
  , RingElementName (RingElementName)
  , DeBruijnIndex (DeBruijnIndex)
  , RingElement (RingElement)
  , UpperBound (UpperBound)
  ) where


import Prelude (Integer)


data SecondOrderFormula = SecondOrderFormula [SecondOrderQuantifier] FirstOrderFormula


-- The list of upper bounds specifies both the arity of the
-- function and the upper bound of each argument.
newtype SecondOrderQuantifier = ExistsFunction [UpperBound]


data FirstOrderFormula =
    Exists UpperBound FirstOrderFormula
  | ForAll UpperBound FirstOrderFormula
  | And FirstOrderFormula FirstOrderFormula
  | Or FirstOrderFormula FirstOrderFormula
  | Not FirstOrderFormula
  | Top
  | Bottom
  | Equals Term Term


data Term =
    Apply FunctionName [Term]
  | Plus Term Term
  | Times Term Term
  | Constant RingElement
  | Variable RingElementName


-- 1 refers to the variable quantified over by the innermost
-- second-order quantifier.
-- 2 refers to the second-innermost, and so on.
newtype FunctionName = FunctionName DeBruijnIndex


-- 1 refers to the variable quantified over by the innermost
-- first-order quantifier.
-- 2 refers to the second-innermost, and so on.
newtype RingElementName = RingElementName DeBruijnIndex


-- A positive integer.
newtype DeBruijnIndex = DeBruijnIndex Integer


-- An element of some unspecified rings. This is short-hand for
-- 0, 1, -1, or some sum thereof. Our intended models are 
-- the integers mod n,
-- and for these rings, we include a constant symbol for each
-- element, and in fact, infinitely many distinct constant
-- symbols for each element.
newtype RingElement = RingElement Integer


newtype UpperBound = UpperBound RingElement
