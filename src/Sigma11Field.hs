{-# LANGUAGE NoImplicitPrelude #-}


-- Sigma_1^1 formulas over the language {0,1,-1,+,*} of fields.
-- A Sigma^1_1 formula is a first order logic formula surrounded
-- by zero or more second-order existential quantifiers quantifying
-- over unary functions on the field domain.
module Sigma11Field
  ( SecondOrderFormula (SecondOrderFormula)
  , SecondOrderQuantifier (ExistsFunction)
  , FirstOrderFormula (Exists, ForAll, And, Or, Not, Top, Bottom, Equals)
  , Term (Apply, Plus, Times, Constant)
  , FunctionArity (FunctionArity)
  , FunctionName (FunctionName)
  , FieldElementName (FieldElementName)
  , DeBruijnIndex (DeBruijnIndex)
  , FieldElement (FieldElement)
  , UpperBound (UpperBound)
  ) where


import Prelude (Integer)


data SecondOrderFormula = SecondOrderFormula [SecondOrderQuantifier] FirstOrderFormula


newtype SecondOrderQuantifier = ExistsFunction FunctionArity


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
  | Constant FieldElement


newtype FunctionArity = FunctionArity Integer


-- 1 refers to the variable quantified over by the innermost
-- second-order quantifier.
-- 2 refers to the second-innermost, and so on.
newtype FunctionName = FunctionName DeBruijnIndex


-- 1 refers to the variable quantified over by the innermost
-- first-order quantifier.
-- 2 refers to the second-innermost, and so on.
newtype FieldElementName = FieldElementName DeBruijnIndex


-- A positive integer.
newtype DeBruijnIndex = DeBruijnIndex Integer


-- An element of some unspecified field. This is short-hand for
-- 0, 1, -1, or some sum thereof. Our intended models are finite fields,
-- and for these fields, we include a constant symbol for each
-- element, and in fact, infinitely many distinct constant
-- symbols for each element.
newtype FieldElement = FieldElement Integer


newtype UpperBound = UpperBound Term
