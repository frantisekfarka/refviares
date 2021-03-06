Require Import List.
Require Import Arith.Max.
Require Import Arith.Lt.
Require Import Arith.Le.
Require Import Arith.PeanoNat.

Require Import defns.
Require Import fusion.


Lemma boundnTCon_dec:
  forall (S : nsgn) (a : tcon),
    { L | boundnTCon a L S } +
    { forall L, ~ (boundnTCon a L S)}.
Proof.
Admitted.

Lemma boundsnTCon_dec:
  forall (sS : snsgn) (a : tcon),
    {kappa | boundsnTCon a kappa sS} + {forall kappa , ~ boundsnTCon a kappa sS}.
Proof.
Admitted.

Lemma boundnCon_dec:
  forall (S : nsgn) (c : con),
    { A | boundnCon c A S } +
    { forall A, ~ (boundnCon c A S)}.
Proof.
Admitted.

Lemma boundsnCon_dec:
  forall (sS :snsgn) (c : con),
    { tau | boundsnCon c tau sS } +
    { forall tau, ~boundsnCon c tau sS }.
Proof.
Admitted.

Lemma boundnTCon_determinacy:
  forall (S : nsgn) (a : tcon) (L1 L2 : nK),
    boundnTCon a L1 S ->
    boundnTCon a L2 S ->
    L1 = L2.
Proof.
Admitted.

Lemma boundsnTCon_determinacy:
  forall (sS : snsgn) (a : tcon) (kappa1 kappa2 : snK),
    boundsnTCon a kappa1 sS ->
    boundsnTCon a kappa2 sS ->
    kappa1 = kappa2.
Proof.
Admitted.

Lemma boundnCon_determinacy:
  forall (S : nsgn) (c : con) (A1 A2 : nTy),
    boundnCon c A1 S ->
    boundnCon c A2 S ->
    A1 = A2.
Proof.
Admitted.

Lemma boundsnCon_determinacy:
  forall (sS : snsgn) (a : tcon) (tau1 tau2 : snTy),
    boundsnCon a tau1 sS ->
    boundsnCon a tau2 sS ->
    tau1 = tau2.
Proof.
Admitted.

(** depth auxiliaries **)

Fixpoint depth_K (L:nK) : nat :=
  match L with
  | kindstar_nl_type => 0
  | (kindstar_nl_pi_intro nA nL) => S (depth_K nL)
end.

Lemma cstu_K_depth:
  forall (L L' : nK) (n : nat),
    n = depth_K L -> cstu_nK L L' -> n = depth_K L'.
Proof.
  intros.
  generalize dependent L.
  generalize dependent L'.
  induction n.
  intros.
  destruct L.
  inversion H0.
  auto.
  inversion H.
  (* step *)
  intros.
  destruct L'.
  inversion H0.
  rewrite <- H1 in H.
  inversion H.
  destruct L.
  inversion H.
  cbv.
  f_equal.
  apply IHn with L.
  inversion H.
  reflexivity.
  inversion H0.
  assumption.
Qed.

Fixpoint depth_nTy (A:nTy) : nat :=
  match A with
  | (typestar_nl_tcon tcon) => 0
  | (typestar_nl_pi_intro A B) => S (max (depth_nTy A) (depth_nTy B))
  | (typestar_nl_pi_elim A N) => S (depth_nTy A)
end.

Require Import Arith.Compare_dec.

Lemma cstu_nTy_depth':
  forall (m n : nat), n <= m -> 
  forall (A A' : nTy), 
    n = depth_nTy A -> cstu_nTy A A' -> n = depth_nTy A'.
Proof.
  induction m.
  (* case m = 0 *)
  intros.
  destruct n.
  destruct A.
  inversion H1.
  rewrite H0.
  auto.
  replace (depth_nTy (typestar_nl_pi_intro A1 A2))
    with (S (max (depth_nTy A1) (depth_nTy A2)))
    in H0 by (cbv; auto).
  inversion H0.
  replace (depth_nTy (typestar_nl_pi_elim A nte5))
    with (S (depth_nTy A))
    in H0 by (cbv; auto).
  inversion H0.
  inversion H.
  (* case m = S m' *)
  intros.
  inversion H1.
  rewrite H0.
  rewrite <- H2.
  auto.
  (* pi_intro *)
  replace (depth_nTy (typestar_nl_pi_intro nA' nB'))
    with (S (max (depth_nTy nA') (depth_nTy nB')))
    by (cbv; auto).
  rewrite <- H4 in H0.
  replace (depth_nTy (typestar_nl_pi_intro nA nB))
    with (S (max (depth_nTy nA) (depth_nTy nB)))
    in H0 by (cbv; auto).
  rewrite H0.
  f_equal.
  remember (depth_nTy nA).
  remember (depth_nTy nB).
  assert (n0 = depth_nTy nA').
  apply IHm with nA.
  apply lt_n_Sm_le.
  apply lt_le_trans with n.
  rewrite H0.
  apply le_lt_n_Sm.
  apply le_max_l.
  assumption.
  assumption.
  assumption.
  assert (n1 = depth_nTy nB').
  apply IHm with nB.
  apply lt_n_Sm_le.
  apply lt_le_trans with n.
  rewrite H0.
  auto with arith.
  auto.
  auto.
  auto.
  auto.
  (* elim case *)
  destruct n.  
  rewrite <- H4 in H0.
  replace ( depth_nTy (typestar_nl_pi_elim nA nM))
    with (S (depth_nTy nA)) in H0 by (cbv; auto).
  inversion H0.
  (* step *)
  replace ( depth_nTy (typestar_nl_pi_elim nA' nM'))
    with (S (depth_nTy nA')) by (cbv; auto).
  f_equal.
  rewrite <- H4 in H0.
  replace ( depth_nTy (typestar_nl_pi_elim nA nM))
  with (S (depth_nTy nA)) in H0 by (cbv; auto).
  apply IHm with nA.
  auto with arith.
  auto.
  auto.
Qed.  

Lemma cstu_nTy_depth:
  forall (n : nat) (A A' : nTy),
    n = depth_nTy A -> cstu_nTy A A' -> n = depth_nTy A'.
Proof.
  intros.
  eauto using cstu_nTy_depth'.
Qed.

Fixpoint depth_nte (M :nte) : nat :=
  match M with
  | (termstar_nl_con c) => 0
  | (termstar_nl_ixc ixc) => ixc
  | (termstar_nl_ixt ixt) => ixt
  | (termstar_nl_pi_intro A M) => S (depth_nte M)
  | (termstar_nl_pi_elim M N) => S (max (depth_nte M) (depth_nte N))
  end.


(*
TODO: Accessible relation akin to:

Fixpoint algdepth (sS : snsgn) (sG : snctx) (M N : nte) (tau : snTy)
         (H1 : algeq_nl_te sS sG M N tau) : nat :=
  match H1 with
  | algeq_nl_te_whr_l _ _ _ _ _ _ _ algeqM'N => S (| algeqM'N |)
  | algeq_nl_te_whr_r _ _ _ _ _ _ _ algeqMN' => S (| algeqMN' |)
  | algeq_nl_te_streq _ _ _ _ _ streqMN => S (| streqMN |)
  | algeq_nl_te_eta_exp _ _ _ _ _ _ _ _ _ _ algeqM'N' => S (| algeqM'N' |)
  end.
with strdepth ...
  math H2 with
  | streq_nl_te_zero               => 0
  | streq_nl_te_succ               => 0
  | streq_nl_te_con                => 0
  | streq_nl_te_pi_elim            => max (| streqM1N1 |) (| algeq M2N2 |)
  end.
*)


(*
Definition eqdepth (sS : nsgn) (sG : nctx) (M N : nte) (tau : snTy) : nat :=
  match (M, N, tau) with
  | (termstar_nl_con c0, termstar_nl_con c1, tau) => 0
  | (termstar_nl_ixc ixc, term_nl_icx, tau) => ixc
  | (termstar_nl_pi_elim M1 N1, termstar_nl_pi_elim M2 N2, tau) => max (M1 N1 tau) 
  | (_, _, _) => 0
  end.
*)
                                               
                                               

(** decidability of weak head-reduction **)

Lemma whr_nl_te_dec:
  forall (M : nte),
    {M' | whr_nl_te M M'} + {forall M', ~ whr_nl_te M M'}.
Proof.
  induction M; try solve [ right; intros; intro; inversion H ].
  destruct M1.
  destruct IHM1.
  left.
  destruct s.
  exists (termstar_nl_pi_elim x M2).
  apply whr_nl_te_head.
  assumption.
  right; intros; intro; inversion H.
  apply n with nM'.
  assumption.
  destruct IHM1.
  left.
  destruct s.
  exists (termstar_nl_pi_elim x M2).
  apply whr_nl_te_head.
  assumption.
  right; intros; intro; inversion H.
  apply n with nM'.
  assumption.
  destruct IHM1.
  left.
  destruct s.
  exists (termstar_nl_pi_elim x M2).
  apply whr_nl_te_head.
  assumption.
  right; intros; intro; inversion H.
  apply n with nM'.
  assumption.
  assert ({ N | tuts_nte M1 M2 N } + {forall N, ~ (tuts_nte M1 M2 N)}).
  apply tuts_nte_dec.
  destruct H.
  left.
  destruct s.
  exists x.
  apply whr_nl_te_subst.
  assumption.
  right; intros; intro; inversion H.
  apply n with M'.
  assumption.
  inversion H3.
  destruct IHM1.
  left.
  destruct s.
  exists (termstar_nl_pi_elim x M2).
  apply whr_nl_te_head.
  assumption.
  right; intros; intro; inversion H.
  apply n with nM'.
  assumption.
Qed.  

Lemma whr_nl_te_determinacy:
  forall (M M' M'' : nte),
    whr_nl_te M M' ->
    whr_nl_te M M'' ->
    M' = M''.
Proof.
  induction M.
  intros.
  inversion H.
  intros. inversion H.
  intros. inversion H.
  intros. inversion H.
  clear IHM2.
  destruct M1.
  intros.
  inversion H.
  inversion H0.
  f_equal.
  apply IHM1.
  assumption.
  assumption.
  intros.
  inversion H.
  inversion H0.
  f_equal.
  apply IHM1.
  assumption.
  assumption.
  intros.
  inversion H.
  inversion H0.
  f_equal.
  apply IHM1.
  assumption.
  assumption.
  intros.
  inversion H.
  inversion H0.
  apply tuts_nte_determinacy with M1 M2.
  assumption.
  assumption.
  inversion H9.
  inversion H4.
  intros.
  inversion H.
  inversion H0.
  f_equal.
  apply IHM1.
  assumption.
  assumption.
Qed.

Lemma streq_nl_te_determinacy_l:
  forall (sS : snsgn) (sG : snctx) (M N : nte) (tau : snTy),
    ( streq_nl_te sS sG M N tau ) -> ~ (exists M', whr_nl_te M M').
Proof.
  induction M.
  intros.
  intro.
  destruct H0.
  inversion H0.
  intros.
  intro.
  destruct H0.
  inversion H0.
  intros.
  intro.
  destruct H0.
  inversion H0.
  intros.
  intro.
  destruct H0.
  inversion H0.
  (* step case *)
  destruct M1.
  intros.
  intro.
  inversion H0.
  inversion H1.
  inversion H.
  apply IHM1 with nN1 (stype_nl_pi_intro tau2 tau).
  assumption.
  exists nM'.
  assumption.
  intros.
  intro.
  inversion H0.
  inversion H1.
  inversion H.
  apply IHM1 with nN1 (stype_nl_pi_intro tau2 tau).
  assumption.
  exists nM'.
  assumption.
  intros.
  intro.
  inversion H0.
  inversion H1.
  inversion H.
  apply IHM1 with nN1 (stype_nl_pi_intro tau2 tau).
  assumption.
  exists nM'.
  assumption.
  intros.
  inversion H.
  inversion H4.  
  intros.
  intro.
  destruct H0.
  inversion H0.
  inversion H.
  apply IHM1 with nN1 (stype_nl_pi_intro tau2 tau).
  assumption.
  exists nM'.
  assumption.
Qed.  

Lemma streq_nl_te_determinacy_r:
  forall (sS : snsgn) (sG : snctx) (M N : nte) (tau : snTy),
    ( streq_nl_te sS sG M N tau ) -> ~ (exists N', whr_nl_te N N').
Proof.
  intros sS sG M N.
  generalize dependent M.
  induction N.
  intros.
  intro.
  destruct H0.
  inversion H0.
  intros.
  intro.
  destruct H0.
  inversion H0.
  intros.
  intro.
  destruct H0.
  inversion H0.
  intros.
  intro.
  destruct H0.
  inversion H0.
  (* step case *)
  destruct N1.
  intros.
  intro.
  inversion H0.
  inversion H1.
  inversion H.
  apply IHN1 with nM1 (stype_nl_pi_intro tau2 tau).
  assumption.
  exists nM'.
  assumption.
  intros.
  intro.
  inversion H0.
  inversion H1.
  inversion H.
  apply IHN1 with nM1 (stype_nl_pi_intro tau2 tau).
  assumption.
  exists nM'.
  assumption.
  intros.
  intro.
  inversion H0.
  inversion H1.
  inversion H.
  apply IHN1 with nM1 (stype_nl_pi_intro tau2 tau).
  assumption.
  exists nM'.
  assumption.
  intros.
  inversion H.
  inversion H5.  
  intros.
  intro.
  destruct H0.
  inversion H0.
  inversion H.
  apply IHN1 with nM1 (stype_nl_pi_intro tau2 tau).
  assumption.
  exists nM'.
  assumption.
Qed.  


Fixpoint strdepth_nte (M : nte) : nat :=
  match M with
  | (termstar_nl_con c) => 0
  | (termstar_nl_ixc ixc) => ixc
  | (termstar_nl_ixt ixt) => 0
  | (termstar_nl_pi_intro A M) => 0
  | (termstar_nl_pi_elim M N) => S (strdepth_nte M)
end.

Lemma streq_nl_te_strong_determinacy':
  forall (n : nat) (sS : snsgn) (sG : snctx) (M N : nte) (tau1 tau2 : snTy),
    n = strdepth_nte M ->
    ( streq_nl_te sS sG M N tau1 ) ->
    ( streq_nl_te sS sG M N tau2 ) ->
    tau1 = tau2.
Proof.
  intros n sS.
  induction n.
  intros.
  destruct M.
  inversion H0.
  inversion H1.
  eauto using boundsnCon_determinacy.
  destruct ixc.
  inversion H0.
  rewrite <- H4 in H1.
  rewrite <- H7.
  inversion H1.
  reflexivity.
  inversion H.
  inversion H0.
  inversion H0.
  inversion H.
  (* step case *)
  intros.
  destruct M.
  inversion H0.
  inversion H1.
  eauto using boundsnCon_determinacy.
  destruct ixc.
  inversion H0.
  rewrite <- H7.
  rewrite <- H4 in H1.
  inversion H1.
  reflexivity.
  inversion H.
  inversion H0.
  inversion H1. 
  apply IHn with snctx5 (termstar_nl_ixc ixc) (termstar_nl_ixc ixc).
  rewrite H3.
  cbv; auto.
  assumption.
  rewrite <- H6 in H13; inversion H13.
  rewrite <- H19.
  assumption.
  inversion H1.
  inversion H1.
  destruct N.
  inversion H1.
  inversion H1.
  inversion H1.
  inversion H1.
  (* interesting case *)
  inversion H0.
  inversion H1.
  assert ( (stype_nl_pi_intro tau3 tau1) =  (stype_nl_pi_intro tau5 tau2)).
  apply IHn with sG M1 N1.
  inversion H.
  auto.
  assumption.
  assumption.
  inversion H20.
  auto.
Qed.

Fixpoint algdepth_snTy (tau : snTy) : nat :=
  match tau with
  | (stype_nl_tcon a) => 0
  | (stype_nl_pi_intro tau1 tau2) => algdepth_snTy tau2
end.

Fixpoint algdepth_nte (M : nte) : nat :=
  match M with
  | (termstar_nl_con c) => 1
  | (termstar_nl_ixc ixc) => 1
  | (termstar_nl_ixt ixt) => 1
  | (termstar_nl_pi_intro A M) => 1
  | (termstar_nl_pi_elim M N) => S (algdepth_nte M)
end.

Definition algdepth (M N : nte) (tau : snTy) : nat :=
  (algdepth_nte M) + (algdepth_nte N) + (S (algdepth_snTy tau)).


Lemma algeq_nl_te_strong_determinacy':
  forall (m n : nat) (sS : snsgn) (sG : snctx) (M N : nte) (tau1 tau2 : snTy),
    n <= m -> 
    n = algdepth M N tau1 ->
    ( algeq_nl_te sS sG M N tau1 ) ->
    ( algeq_nl_te sS sG M N tau2 ) ->
    tau1 = tau2.
Proof.
Admitted.


Lemma streq_nl_te_strong_determinacy:
  forall (sS : snsgn) (sG : snctx) (M N : nte) (tau1 tau2 : snTy),
    ( streq_nl_te sS sG M N tau1 ) ->
    ( streq_nl_te sS sG M N tau2 ) ->
    tau1 = tau2.
Proof.
  eauto using streq_nl_te_strong_determinacy'.
Qed.

Lemma algeq_nl_te_strong_determinacy:
  forall (sS : snsgn) (sG : snctx) (M N : nte) (tau1 tau2 : snTy),
    ( algeq_nl_te sS sG M N tau1 ) ->
    ( algeq_nl_te sS sG M N tau2 ) ->
    tau1 = tau2.
Proof.
Admitted.

Lemma algdepth_pi_elim:
  forall (M M' N N' : nte) (tau1 tau2 : snTy),
    cs_nte M M' -> cs_nte N N' ->
    algdepth (termstar_nl_pi_elim M' (termstar_nl_ixc 0))
    (termstar_nl_pi_elim N' (termstar_nl_ixc 0)) tau2
    < algdepth M N (stype_nl_pi_intro tau1 tau2).
Proof.
Admitted.



Lemma algdepth_pi_intro:
  forall (M N : nte) (tau1 tau2 : snTy),
    ~ (0 = algdepth M N (stype_nl_pi_intro tau1 tau2)).
Proof.
  intros.
  intro.
  destruct M.
  destruct N.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
  destruct N.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
  destruct N.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
  destruct N.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
  destruct N.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
  inversion H.
Qed.   

Lemma algdepth_whr_l:
  forall (M N M' : nte) (tau : snTy),
    whr_nl_te M M' ->
    ~ (0 = algdepth M N tau).
Proof.
  intros.
  intro.
  inversion H.
  rewrite <- H2 in H0.
  destruct N.
  destruct tau.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  rewrite <- H2 in H0.
  destruct N.
  destruct tau.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.  
Qed.

Lemma algdepth_whr_r:
  forall (M N N' : nte) (tau : snTy),
    whr_nl_te N N' ->
    ~ (0 = algdepth M N tau).
Proof.
  intros.
  intro.
  inversion H.
  rewrite <- H2 in H0.
  destruct M.
  destruct tau.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  rewrite <- H2 in H0.
  destruct M.
  destruct tau.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.
  inversion H0.  
Qed.

Require Import Arith.Plus.


Lemma algdepth_nte_pos:
  forall (M : nte),
    0 < algdepth_nte M.
Proof.
  intros.
  destruct M.  
  auto.
  auto.
  auto.
  auto.
  replace (algdepth_nte (termstar_nl_pi_elim M1 M2))
  with (S (algdepth_nte M1)) by (cbv; auto).
  auto with arith.
Qed.

Lemma algdepth_tuts:
  forall (M N M' : nte),
    tuts_nte M N M' ->
    algdepth_nte M' < algdepth_nte M + algdepth_nte N.
Proof.
  induction M.
  intros; inversion H.
  assert (0 < algdepth_nte N) by (auto using algdepth_nte_pos).
  auto with arith.
  intros; inversion H.
  assert (0 < algdepth_nte N) by (auto using algdepth_nte_pos).
  auto with arith.
  intros; inversion H.
  assert (0 < algdepth_nte N) by (auto using algdepth_nte_pos).
  auto with arith.
  assert (0 < algdepth_nte N) by (auto using algdepth_nte_pos).
  auto with arith.  
  intros; inversion H.
  assert (0 < algdepth_nte N) by (auto using algdepth_nte_pos).
  auto with arith.
  intros; inversion H.
  assert (0 < algdepth_nte N) by (auto using algdepth_nte_pos).
  replace (algdepth_nte (termstar_nl_pi_elim nM' nN'))
          with (S (algdepth_nte nM')) by (cbv; auto).
  replace (algdepth_nte (termstar_nl_pi_elim M1 M2) + algdepth_nte N)
  with (S (algdepth_nte M1 + algdepth_nte N)) by (cbv; auto).
  apply lt_n_S.
  apply IHM1.
  assumption.
Qed.  
  
Lemma algdepth_whr:
  forall (M M' : nte),   
    whr_nl_te M M' ->
    algdepth_nte M' < algdepth_nte M.
Proof.
  induction M.
  intros; inversion H.
  intros; inversion H.
  intros; inversion H.
  intros; inversion H.
  intros.  
  inversion H.
  rewrite H0.
  admit.
  cbv.
  apply lt_n_S.
  apply IHM1.
  assumption.
Admitted.

Lemma algdepth_cs:
  forall (M M' : nte),
    cs_nte M M' -> (algdepth_nte M') <= S (algdepth_nte M).
Proof.
  induction M.
  intros.
  inversion H.
  auto.
  intros; inversion H.
  auto.
  intros.
  inversion H.
  auto.
  intros.
  inversion H.
  auto.
  intros.
  inversion H.
  cbv.
  apply le_n_S.
  apply IHM1.
  assumption.
Qed.
  
Lemma algdepth_cs_strong:
  forall (M M' N N' : nte) (tau1 tau2 : snTy),
    cs_nte M M' ->
    cs_nte N N' ->
    algdepth (termstar_nl_pi_elim M' (termstar_nl_ixc 0))
    (termstar_nl_pi_elim N'  (termstar_nl_ixc 0)) tau2 < algdepth M N (stype_nl_pi_intro tau1 tau2).
Proof.
  unfold algdepth.
  intros.
  replace (algdepth_snTy (stype_nl_pi_intro tau1 tau2))
      with ((algdepth_snTy tau2)) by (cbv; auto).
  apply plus_lt_compat_r.
  apply plus_le_lt_compat.
  apply le_S_n.
  apply le_trans with (algdepth_nte N').
  admit.
  admit.
  admit.
Admitted.

Lemma algdepth_le_whr_l:
  forall (M N M' : nte) (a : tcon),
    whr_nl_te M M' ->
    algdepth M' N (stype_nl_tcon a) < algdepth M N (stype_nl_tcon a).
Proof.
  intros.
  apply plus_lt_compat_r.
  apply plus_lt_compat_r.
  apply algdepth_whr.
  assumption.
Qed.

Lemma algdepth_le_whr_r:
  forall (M N N' : nte) (a : tcon),
    whr_nl_te N N' ->
    algdepth M N' (stype_nl_tcon a) < algdepth M N (stype_nl_tcon a).
Proof.
  intros.
  apply plus_lt_compat_r.
  apply plus_lt_compat_l.
  auto using algdepth_whr.
Qed.


Lemma phony:
  forall (n : nat) (M N : nte) (tau : snTy),
    algdepth M N tau <= n.
Admitted.

(*
Lemma streq_nl_te_dec:
  forall (m n : nat) (sS : snsgn) (sG : snctx) (M N : nte),
    n <= m -> n = depth_nte M -> wfssig_nl sS -> 
    { tau | streq_nl_te sS sG M N tau } + { forall tau , ~ streq_nl_te sS sG M N tau}.
Proof.  
  intro.
  induction m.
  (* depth 0 *)
  intros.
  destruct M.
  destruct N.
  assert ({tau | boundsnCon con5 tau sS} +
          {forall tau , ~boundsnCon con5 tau sS}) by (apply boundsnCon_dec).
  assert ({con5 = con0} + {con5 <> con0}) by (apply eq_tcon).
  destruct H2.
  destruct H3.
  left.
  rewrite <- e.
  destruct s.
  exists x.
  apply streq_nl_te_con. 
  assumption.
  assumption.
  right.
  intros.
  intro.
  inversion H2.
  contradiction.
  right.
  intros.
  intro.
  inversion H2.
  apply n0 with tau.
  rewrite H5.
  assumption.
  (* con ~ ixc *)
  right.
  intros; intro.
  inversion H2.
  (* con ~ ixt *)
  right.
  intros; intro.
  inversion H2.
  (* con ~ pi_intro *)
  right.
  intros; intro.
  inversion H2.
  (* con ~ pi_elim *)
  right.
  intros; intro.
  inversion H2.
  (* ixc cases *)
  destruct N.
  right.
  intros; intro.
  inversion H2.
  (* ixc ~ ixc *)
  assert ({ixc = ixc0} + {ixc <> ixc0}) by (apply Nat.eq_dec).
  destruct H2.
  destruct sG.
  (* empty ctx *)
  right.
  intros; intro.
  inversion H2.
  (* nonempty ctx *)
  destruct ixc.
  left.
  rewrite <- e.
  exists s.
  apply streq_nl_te_var_zero.
  assumption.
  replace (depth_nte (termstar_nl_ixc (S ixc))) with (S ixc) in H0 by (cbv; auto).
  rewrite H0 in H.
  apply le_n_0_eq in H.
  inversion H.
  right; intros; intro.
  inversion H2.
  rewrite H3 in H6.
  contradiction.
  rewrite H3 in H4.
  contradiction.
  (* ixc ~ ixt *)
  right.
  intros; intro.
  inversion H2.
  (* ixc ~ pi_intro *)
  right.
  intros; intro.
  inversion H2.
  (* ixc ~ pi_elim *)
  right.
  intros; intro.
  inversion H2.
  (* ixt cases *)
  right.
  intros; intro.
  inversion H2.
  (* pi_intro cases *)
  right.
  intros.
  intro.
  inversion H2.
  (* pi_elim cases *)
  destruct N.
  (* pi_elim ~ con *)
  right.
  intros; intro.
  inversion H2.
  (* pi_elim ~ ixc *)
  right.
  intros; intro.
  inversion H2.
  (* pi_elim ~ ixt *)
  right.
  intros; intro.
  inversion H2.
  (* pi_elim ~ pi_intro *)
  right.
  intros; intro.
  inversion H2.
  (* pi_elim ~ pi_elim *)
  replace (depth_nte (termstar_nl_pi_elim M1 M2)) with (S (max (depth_nte M1) (depth_nte M2)))
   in H0 by (cbv;auto).
  apply le_n_0_eq in H.
  rewrite <- H in H0.
  inversion H0.
  (* step cases *)
  intros.
  destruct M.
  (* con *)
  destruct N.
  assert ({tau | boundsnCon con5 tau sS} +
          {forall tau , ~boundsnCon con5 tau sS}) by (apply boundsnCon_dec).
  assert ({con5 = con0} + {con5 <> con0}) by (apply eq_tcon).
  destruct H2.
  destruct H3.
  left.
  rewrite <- e.
  destruct s.
  exists x.
  apply streq_nl_te_con. 
  assumption.
  assumption.
  right.
  intros.
  intro.
  inversion H2.
  contradiction.
  right.
  intros.
  intro.
  inversion H2.
  apply n0 with tau.
  rewrite H5.
  assumption.
  (* con ~ ixc *)
  right.
  intros; intro.
  inversion H2.
  (* con ~ ixt *)
  right.
  intros; intro.
  inversion H2.
  (* con ~ pi_intro *)
  right.
  intros; intro.
  inversion H2.
  (* con ~ pi_elim *)
  right.
  intros; intro.
  inversion H2.
  (* ixc cases *)
  destruct N.
  right.
  intros; intro.
  inversion H2.
  (* ixc ~ ixc *)
  assert ({ixc = ixc0} + {ixc <> ixc0}) by (apply Nat.eq_dec).
  destruct H2.
  destruct sG.
  (* empty ctx *)
  right.
  intros; intro.
  inversion H2.
  (* nonempty ctx *)
  destruct ixc.
  replace (depth_nte (termstar_nl_ixc 0)) with 0 in H0 by (cbv; auto).
  rewrite <- e.
  left.
  exists s.
  apply streq_nl_te_var_zero.
  assumption.
  rewrite <- e.
  assert ({tau | streq_nl_te sS sG (termstar_nl_ixc ixc) (termstar_nl_ixc ixc) tau} +
        {forall tau , ~ streq_nl_te sS sG (termstar_nl_ixc ixc) (termstar_nl_ixc ixc) tau}).
  apply IHm with ixc.
  replace (depth_nte (termstar_nl_ixc (S ixc))) with (S ixc) in H0 by (cbv; auto).
  rewrite H0 in H.
  auto with arith.
  cbv; auto.
  assumption.
  inversion H2.
  left.
  destruct H3.
  exists x.
  apply streq_nl_te_var_succ.
  assumption.
  assumption. 
  right.
  intros; intro.
  inversion H4.
  apply H3 with tau.
  assumption.
  right; intros; intro.
  inversion H2.
  rewrite H3 in H6.
  contradiction.
  rewrite H3 in H4.
  contradiction.
  (* ixc ~ ixt *)
  right.
  intros; intro.
  inversion H2.
  (* ixc ~ pi_intro *)
  right.
  intros; intro.
  inversion H2.
  (* ixc ~ pi_elim *)
  right.
  intros; intro.
  inversion H2.
  (* ixt cases *)
  right.
  intros; intro.
  inversion H2.
  (* pi_intro cases *)
  right.
  intros; intro.
  inversion H2.
  (* pi_elim cases *) 
  destruct N.
  (* pi_elim ~ con *)
  right.
  intros; intro.
  inversion H2.
  (* pi_elim ~ ixc *)
  right.
  intros; intro.
  inversion H2.
  (* pi_elim ~ ixt *)
  right.
  intros; intro.
  inversion H2.
  (* pi_elim ~ pi_intro *)
  right.
  intros; intro.
  inversion H2.
  (* pi_elim ~ pi_elim *)
  assert ({tau | streq_nl_te sS sG M1 N1 tau} +
          {forall tau , ~ streq_nl_te sS sG M1 N1 tau}).  
  remember (depth_nte M1).
  apply IHm with n0.
  replace (depth_nte (termstar_nl_pi_elim M1 M2)) with (S (max (depth_nte M1) (depth_nte M2))) in H0 by (cbv; auto).
  rewrite <- Heqn0 in H0.
  rewrite H0 in H.
  apply le_S_n in H.
  apply le_trans with (Nat.max n0 (depth_nte M2)).
  apply le_max_l.
  assumption.
  assumption.
  assumption.
  destruct H2.
  destruct s.
  destruct x.
  right.
  intros; intro.
  inversion H2.
  assert ( (stype_nl_tcon tcon5) = (stype_nl_pi_intro tau2 tau)).
  eauto using streq_nl_te_strong_determinacy.
  inversion H12.
  assert ({tau1 | algeq_nl_te sS sG M2 N2 tau1} +
        {forall tau1 , ~ algeq_nl_te sS sG M2 N2 tau1}).
  admit. (* from mutual lemma *)
  destruct H2.
  destruct s0.
  assert ({x = x1} + {x <> x1}) by (decide equality; apply eq_con).
  destruct H2.
  left.
  exists x2.
  apply streq_nl_te_pi_elim with x1.
  assumption.
  rewrite <- e.
  assumption.
  right.
  intros; intro.
  inversion H2.
  assert ( (stype_nl_pi_intro x1 x2) =  (stype_nl_pi_intro tau2 tau)).
  eauto using streq_nl_te_strong_determinacy.
  inversion H12.
  assert (x = tau2) by (eauto using algeq_nl_te_strong_determinacy).
  apply n0.
  rewrite H13; rewrite H14; auto.
  right.
  intros; intro.
  inversion H2.
  apply n0 with tau2.
  assumption.
  right.
  intros; intro.
  inversion H2.
  apply n0 with (stype_nl_pi_intro tau2 tau).
  assumption.
Admitted.
*)


(* MAIN THEOREM *)
(*
Fixpoint streq_nl_te_dec' (n : nat)
  (sS : snsgn) (sG : snctx) (M N : nte) {struct n}:
    depth_nte M <= n -> wfssig_nl sS -> 
    { tau | streq_nl_te sS sG M N tau } + { forall tau , ~ streq_nl_te sS sG M N tau}
with algeq_nl_te_dec' (n m : nat) 
  (sS : snsgn) (sG : snctx) (M N : nte) (tau : snTy) {struct m}:
    m <= n -> algdepth M N tau = m ->
    wfssig_nl sS ->
    { algeq_nl_te sS sG M N tau } + {~ algeq_nl_te sS sG M N tau}.
Proof.
*)

(*
Fixpoint algeq_nl_te_dec'' (n m : nat) 
  (sS : snsgn) (sG : snctx) (M N : nte) (tau : snTy) {struct m}:
    m <= n -> algdepth M N tau = m ->
    wfssig_nl sS ->
    { algeq_nl_te sS sG M N tau } + {~ algeq_nl_te sS sG M N tau}.
Admitted.
 *)

Fixpoint streq_nl_te_dec' (n : nat) (sS : snsgn) (sG : snctx) (M N : nte)
  (algeq_lemma : forall (sS : snsgn) (sG : snctx) (M N : nte) (tau : snTy),
       wfssig_nl sS -> {algeq_nl_te sS sG M N tau} + {~ algeq_nl_te sS sG M N tau}) {struct n} :
    depth_nte M <= n -> wfssig_nl sS -> 
    { tau | streq_nl_te sS sG M N tau } + { forall tau , ~ streq_nl_te sS sG M N tau}
.
(*
Lemma streq_nl_te_dec':
  forall (n : nat) (sS : snsgn) (sG : snctx) (M N : nte),
    depth_nte M <= n -> wfssig_nl sS -> 
    { tau | streq_nl_te sS sG M N tau } + { forall tau , ~ streq_nl_te sS sG M N tau}.
*)
  (* Lemma 1 *)
  intros.

  generalize dependent N.
  generalize dependent M.
  generalize dependent sG.
  generalize dependent sS.
  induction n.
  
  (* depth 0 *)
  intros.
  destruct M.
  destruct N.
  assert ({tau | boundsnCon con5 tau sS} +
          {forall tau , ~boundsnCon con5 tau sS}) by (apply boundsnCon_dec).
  assert ({con5 = con0} + {con5 <> con0}) by (apply eq_tcon).
  destruct H1.
  destruct H2.
  left.
  rewrite <- e.
  destruct s.
  exists x.
  apply streq_nl_te_con. 
  assumption.
  assumption.
  right.
  intros.
  intro.
  inversion H1.
  contradiction.
  right.
  intros.
  intro.
  inversion H1.
  apply n with tau.
  rewrite H4.
  assumption.
  (* con ~ ixc *)
  right.
  intros; intro.
  inversion H1.
  (* con ~ ixt *)
  right.
  intros; intro.
  inversion H1.
  (* con ~ pi_intro *)
  right.
  intros; intro.
  inversion H1.
  (* con ~ pi_elim *)
  right.
  intros; intro.
  inversion H1.
  (* ixc cases *)
  destruct N.
  right.
  intros; intro.
  inversion H1.
  (* ixc ~ ixc *)
  assert ({ixc = ixc0} + {ixc <> ixc0}) by (apply Nat.eq_dec).
  destruct H1.
  destruct sG.
  (* empty ctx *)
  right.
  intros; intro.
  inversion H1.
  (* nonempty ctx *)
  destruct ixc.
  left.
  rewrite <- e.
  exists s.
  apply streq_nl_te_var_zero.
  assumption.
  replace (depth_nte (termstar_nl_ixc (S ixc))) with (S ixc) in H by (cbv; auto).
  apply le_n_0_eq in H.
  inversion H.
  right; intros; intro.
  inversion H1.
  rewrite H2 in H5.
  contradiction.
  rewrite H2 in H3.
  contradiction.
  (* ixc ~ ixt *)
  right.
  intros; intro.
  inversion H1.
  (* ixc ~ pi_intro *)
  right.
  intros; intro.
  inversion H1.
  (* ixc ~ pi_elim *)
  right.
  intros; intro.
  inversion H1.
  (* ixt cases *)
  right.
  intros; intro.
  inversion H1.
  (* pi_intro cases *)
  right.
  intros.
  intro.
  inversion H1.
  (* pi_elim cases *)
  destruct N.
  (* pi_elim ~ con *)
  right.
  intros; intro.
  inversion H1.
  (* pi_elim ~ ixc *)
  right.
  intros; intro.
  inversion H1.
  (* pi_elim ~ ixt *)
  right.
  intros; intro.
  inversion H1.
  (* pi_elim ~ pi_intro *)
  right.
  intros; intro.
  inversion H1.
  (* pi_elim ~ pi_elim *)
  replace (depth_nte (termstar_nl_pi_elim M1 M2)) with (S (max (depth_nte M1) (depth_nte M2)))
   in H by (cbv;auto).
  apply le_n_0_eq in H.
  inversion H.
  (* step cases *)
  intros.
  destruct M.
  (* con *)
  destruct N.
  assert ({tau | boundsnCon con5 tau sS} +
          {forall tau , ~boundsnCon con5 tau sS}) by (apply boundsnCon_dec).
  assert ({con5 = con0} + {con5 <> con0}) by (apply eq_tcon).
  destruct H1.
  destruct H2.
  left.
  rewrite <- e.
  destruct s.
  exists x.
  apply streq_nl_te_con. 
  assumption.
  assumption.
  right.
  intros.
  intro.
  inversion H1.
  contradiction.
  right.
  intros.
  intro.
  inversion H1.
  apply n0 with tau.
  rewrite H4.
  assumption.
  (* con ~ ixc *)
  right.
  intros; intro.
  inversion H1.
  (* con ~ ixt *)
  right.
  intros; intro.
  inversion H1.
  (* con ~ pi_intro *)
  right.
  intros; intro.
  inversion H1.
  (* con ~ pi_elim *)
  right.
  intros; intro.
  inversion H1.
  (* ixc cases *)
  destruct N.
  right.
  intros; intro.
  inversion H1.
  (* ixc ~ ixc *)
  assert ({ixc = ixc0} + {ixc <> ixc0}) by (apply Nat.eq_dec).
  destruct H1.
  destruct sG.
  (* empty ctx *)
  right.
  intros; intro.
  inversion H1.
  (* nonempty ctx *)
  destruct ixc.
  replace (depth_nte (termstar_nl_ixc 0)) with 0 in H by (cbv; auto).
  rewrite <- e.
  left.
  exists s.
  apply streq_nl_te_var_zero.
  assumption.
  rewrite <- e.
  assert ({tau | streq_nl_te sS sG (termstar_nl_ixc ixc) (termstar_nl_ixc ixc) tau} +
        {forall tau , ~ streq_nl_te sS sG (termstar_nl_ixc ixc) (termstar_nl_ixc ixc) tau}).
  apply IHn.
  assumption.
  replace (depth_nte (termstar_nl_ixc (S ixc))) with (S ixc) in H by (cbv; auto).
  apply le_S_n in H.
  cbv; auto.
  inversion H1.
  left.
  destruct H2.
  exists x.
  apply streq_nl_te_var_succ.
  assumption.
  assumption. 
  right.
  intros; intro.
  inversion H3.
  apply H2 with tau.
  assumption.
  right; intros; intro.
  inversion H1.
  rewrite H2 in H5.
  contradiction.
  rewrite H2 in H3.
  contradiction.
  (* ixc ~ ixt *)
  right.
  intros; intro.
  inversion H1.
  (* ixc ~ pi_intro *)
  right.
  intros; intro.
  inversion H1.
  (* ixc ~ pi_elim *)
  right.
  intros; intro.
  inversion H1.
  (* ixt cases *)
  right.
  intros; intro.
  inversion H1.
  (* pi_intro cases *)
  right.
  intros; intro.
  inversion H1.
  (* pi_elim cases *) 
  destruct N.
  (* pi_elim ~ con *)
  right.
  intros; intro.
  inversion H1.
  (* pi_elim ~ ixc *)
  right.
  intros; intro.
  inversion H1.
  (* pi_elim ~ ixt *)
  right.
  intros; intro.
  inversion H1.
  (* pi_elim ~ pi_intro *)
  right.
  intros; intro.
  inversion H1.
  (* pi_elim ~ pi_elim *)
  assert ({tau | streq_nl_te sS sG M1 N1 tau} +
          {forall tau , ~ streq_nl_te sS sG M1 N1 tau}).  
  apply IHn.
  assumption.
  replace (depth_nte (termstar_nl_pi_elim M1 M2)) with (S (max (depth_nte M1) (depth_nte M2))) in H by (cbv; auto).
  apply le_S_n in H.
  apply le_trans with (Nat.max (depth_nte M1) (depth_nte M2)).
  apply le_max_l.
  assumption.
  destruct H1.
  destruct s.
  destruct x.
  right.
  intros; intro.
  inversion H1.
  assert ( (stype_nl_tcon tcon5) = (stype_nl_pi_intro tau2 tau)).
  eauto using streq_nl_te_strong_determinacy.
  inversion H11.
  assert ({algeq_nl_te sS sG M2 N2 x1} +
          {~ algeq_nl_te sS sG M2 N2 x1}).
  apply algeq_lemma. (* with n (algdepth M2 N2 x1). *)
  (*apply phony.
  reflexivity.*)
  assumption.
  destruct H1.
  left.
  exists x2.
  apply streq_nl_te_pi_elim with x1.
  assumption.
  assumption.
  right.
  intros; intro.
  inversion H1.
  assert ( (stype_nl_pi_intro x1 x2) =  (stype_nl_pi_intro tau2 tau)).
  eauto using streq_nl_te_strong_determinacy.
  inversion H11.
  apply n0.
  rewrite H13; auto.
  right.
  intros; intro.
  inversion H1.
  apply n0 with (stype_nl_pi_intro tau2 tau).
  assumption.
Qed.

  (*
  right.
  intros; intro.
  inversion H1.
  apply n0 with (stype_nl_pi_intro tau2 tau).
  assumption.
*)
  (* Lemma b 


Lemma algeq_nl_te_dec:
  forall (n : nat) (sS : snsgn) (sG : snctx) (M N : nte) (tau : snTy),
    algdepth M N tau <= n ->
    wfssig_nl sS ->
    { algeq_nl_te sS sG M N tau } + {~ algeq_nl_te sS sG M N tau}.
Proof. *)

(*
Definition proofOrder (sS : snsgn) (sG : snctx) (M1 M2 N1 N2 : nte)
           (tau1 tau2 : snTy) :=
  algdepth M1 N1 tau1 < algdepth M2 N2 tau2.

Lemma proofOrder_wf: forall (sS : snsgn) (sG : snctx) (M N : nte),
          well_founded (proofOrder sS sG M M N N).
Admitted.  
 *)

Fixpoint algeq_nl_te_dec' (n m : nat) (sS : snsgn) (sG : snctx) (M N : nte) (tau : snTy)
         (streq_lemma : forall (sS : snsgn) (sG : snctx) (M N : nte),
                          wfssig_nl sS -> { tau | streq_nl_te sS sG M N tau } + { forall tau , ~ streq_nl_te sS sG M N tau})
         {struct m}:
    m <= n -> algdepth M N tau = m ->
    wfssig_nl sS ->
    { algeq_nl_te sS sG M N tau } + {~ algeq_nl_te sS sG M N tau}.
  (* Lemma 2 *)
  generalize dependent tau.
  generalize dependent N.
  generalize dependent M.
  generalize dependent sG.
  generalize dependent sS.
  generalize dependent m.
  induction n.
  (* algdepth 0 - only by streq and for tau = a  *)
  intros.
  assert ({tau | streq_nl_te sS sG M N tau} + {forall tau, ~streq_nl_te sS sG M N tau}).
  eauto using streq_lemma.
  destruct H2.
  destruct s.
  assert ({x = tau} + {x <> tau}) by (decide equality; apply eq_con).
  destruct H2.
  rewrite e in s.
  destruct tau.
  (* decide from streq for tau = a *)
  left.
  apply algeq_nl_te_streq.
  assumption.
  (* contradiction from tau = tau1 -> tau2 *)
  apply le_n_0_eq in H.
  rewrite <- H in H0.
  right.
  intro.
  apply algdepth_pi_intro with M N tau1 tau2.
  symmetry.
  assumption.
  (* contradiction on determiancy from x <> tau *)
  right.
  intro.
  inversion H2.
  apply streq_nl_te_determinacy_l with sS sG M N x.
  assumption.
  exists nM'.
  assumption.
  inversion H4.
  apply streq_nl_te_determinacy_r with sS sG M N x.
  assumption.
  exists nN'.
  assumption.
  apply streq_nl_te_determinacy_r with sS sG M N x.
  assumption.
  exists nN'.
  assumption.
  apply streq_nl_te_determinacy_r with sS sG M N x.
  assumption.
  exists nN'.
  assumption.
  apply n.
  apply streq_nl_te_strong_determinacy with sS sG M N.
  assumption.
  rewrite <- H8.
  assumption.
  rewrite <- H10 in H0.
  apply le_n_0_eq in H.
  rewrite <- H in H0.
  apply algdepth_pi_intro with M N tau1 tau2.
  symmetry; assumption.
  (* contradiction from ~streq *)
  right.
  intro.
  apply le_n_0_eq in H.
  rewrite <- H0 in H.
  inversion H2.  
  assert (0 <> algdepth M N tau) by (eauto using algdepth_whr_l).
  contradiction.
  assert (0 <> algdepth M N tau) by (eauto using algdepth_whr_r).
  contradiction.
  apply n with (stype_nl_tcon a).
  assumption.
  rewrite <- H9 in H.
  assert (0 <> algdepth M N (stype_nl_pi_intro tau1 tau2)) by (eauto using algdepth_pi_intro).
  rewrite H10 in H11.
  rewrite <- H9 in H11.
  contradiction.
  (* step case *)
  intros.
  destruct tau.
  (* whr and streq cases *)
  assert ({M'| whr_nl_te M M'} + {forall M', ~ whr_nl_te M M'}) by (apply whr_nl_te_dec). 
  destruct H2.
  destruct s.
  assert ({ algeq_nl_te sS sG x N (stype_nl_tcon tcon5) } + { ~ algeq_nl_te sS sG x N (stype_nl_tcon tcon5)}).
  apply IHn with(algdepth x N (stype_nl_tcon tcon5)) .
  apply le_S_n.
  apply lt_le_trans with (algdepth M N (stype_nl_tcon tcon5)).
  apply algdepth_le_whr_l.
  assumption.
  rewrite H0.
  assumption.
  reflexivity.
  assumption.
  destruct H2.
  (* case whr M and algeq *)
  left.
  apply algeq_nl_te_whr_l with x.
  assumption.
  assumption.
  (* case "possible whr N" *)
  assert ({N'| whr_nl_te N N'} + {forall N', ~ whr_nl_te N N'}) by (apply whr_nl_te_dec).
  destruct H2.
  destruct s.
  assert ({ algeq_nl_te sS sG M x0 (stype_nl_tcon tcon5) } + { ~ algeq_nl_te sS sG M x0 (stype_nl_tcon tcon5)}). 
  apply IHn with (algdepth M x0 (stype_nl_tcon tcon5)).
  apply le_S_n.
  apply lt_le_trans with (algdepth M N (stype_nl_tcon tcon5)).
  apply algdepth_le_whr_r.
  assumption.
  rewrite H0.
  assumption.
  reflexivity.
  assumption.
  destruct H2.
  (* case whr N and algeq *)
  left.
  apply algeq_nl_te_whr_r with x0.
  assumption.
  assumption.
  (* neither whr M nor whr N *)
  right.
  intro.
  inversion H2.
  (* contradiction on whr M *)
  assert (nM' = x) by (eauto using whr_nl_te_determinacy).
  apply n0.
  rewrite <- H10.
  assumption.
  (* contradiction on whr N *)
  assert (nN' = x0) by (eauto using whr_nl_te_determinacy).
  apply n1.
  rewrite <- H10.
  assumption.
  (* contradiction on streq for tcon *)
  eapply streq_nl_te_determinacy_l with sS sG M N (stype_nl_tcon tcon5).
  assumption.
  exists x.
  assumption.
  (* whr M and ~algeq and ~whr N *)
  right.
  intro.
  inversion H2.
  assert (x = nM') by (eauto using whr_nl_te_determinacy).
  apply n0.
  rewrite H10.
  assumption.
  apply n1 with nN'.
  assumption.
  (* contradiction on whr M and streq *)  
  apply streq_nl_te_determinacy_l with sS sG M N (stype_nl_tcon tcon5).
  assumption.
  exists x.
  assumption.
  (* case ~ whr M *)
  assert ({N'| whr_nl_te N N'} + {forall N', ~ whr_nl_te N N'}) by (apply whr_nl_te_dec).
  destruct H2.
  destruct s.
  assert ({ algeq_nl_te sS sG M x (stype_nl_tcon tcon5)} + { ~ algeq_nl_te sS sG M x (stype_nl_tcon tcon5)}).
  apply IHn with(algdepth M x (stype_nl_tcon tcon5)).
  apply le_S_n.
  apply lt_le_trans with (algdepth M N (stype_nl_tcon tcon5)).
  apply algdepth_le_whr_r.
  assumption.
  rewrite H0.
  assumption.
  reflexivity.
  assumption.
  destruct H2.
  (* decide by whr N and algeq *)
  left.
  apply algeq_nl_te_whr_r with x.
  assumption.
  assumption. 
  (* ~ whr M and whr N and and ~algeq *)
  right.
  intro.
  inversion H2.
  (* contradiction on whr M *)
  apply n0 with nM'.
  assumption.
  assert (x = nN').
  apply whr_nl_te_determinacy with N.
  assumption.
  assumption.
  rewrite <- H10 in H9.
  contradiction.
  (* whr M and streq *)
  eapply streq_nl_te_determinacy_r with sS sG M N (stype_nl_tcon tcon5).
  assumption.
  exists x.
  assumption.
  (* neither whr M nor whr N on tcon hence streq *)
  assert ({tau | streq_nl_te sS sG M N tau} + {forall tau, ~ streq_nl_te sS sG M N tau})  
    by (apply streq_lemma; assumption). (* with (depth_nte M);  auto with arith).*)
  destruct H2.
  destruct s.
  assert ({x = (stype_nl_tcon tcon5)} + { x <> (stype_nl_tcon tcon5)}) by (decide equality; apply eq_con).
  destruct H2.
  (* decide from streq *)
  left.
  apply algeq_nl_te_streq.
  rewrite <- e.
  assumption.
  (* contradiction from determinacy of streq *)
  right.
  intro.
  inversion H2.
  apply n0 with nM'.
  assumption.
  apply n1 with nN'.
  assumption.
  assert (x =  stype_nl_tcon tcon5).
  eauto using (streq_nl_te_strong_determinacy).
  contradiction.
  (* contradiction from all *)
  right.
  intro.
  inversion H2.
  apply n0 with nM'; auto.
  apply n1 with nN'; auto.
  apply n2 with  (stype_nl_tcon tcon5); auto.
  (* algeq step *)
  assert ({ M' | cs_nte M M'}).
  apply cs_nte_dec.
  assert ({ N' | cs_nte N N'}).
  apply cs_nte_dec.
  destruct H2.
  destruct H3.
  assert ({algeq_nl_te sS (tau1 :: sG) (termstar_nl_pi_elim x (termstar_nl_ixc 0)) (termstar_nl_pi_elim x0 (termstar_nl_ixc 0)) tau2} +
         {~algeq_nl_te sS (tau1 :: sG) (termstar_nl_pi_elim x (termstar_nl_ixc 0)) (termstar_nl_pi_elim x0 (termstar_nl_ixc 0)) tau2}).
  apply IHn with (algdepth (termstar_nl_pi_elim x (termstar_nl_ixc 0)) (termstar_nl_pi_elim x0 (termstar_nl_ixc 0)) (tau2)).
  apply le_S_n.
  apply lt_le_trans with ( (algdepth M N (stype_nl_pi_intro tau1 tau2))).
  apply algdepth_pi_elim; assumption.
  rewrite H0.
  assumption.
  reflexivity.
  assumption.
  destruct H2.
  (* decide for eta expansion *)
  left.
  apply algeq_nl_te_eta_exp with x x0.
  assumption.
  assumption.
  assumption.
  (* propagate negation *)
  right.
  intro.
  apply n0.
  inversion H2.
  assert (x = nM').
  apply cs_nte_determinacy with M.
  auto.
  auto.
  rewrite H12.
  assert (x0 = nN').
  apply cs_nte_determinacy with N.
  auto.
  auto.
  rewrite H13.
  assumption.
Qed.


Lemma streq_nl_te_dec:
  forall (sS : snsgn) (sG : snctx) (M N : nte),
    wfssig_nl sS ->
    { tau | streq_nl_te sS sG M N tau } + { forall tau , ~ streq_nl_te sS sG M N tau}
with algeq_nl_te_dec:
  forall (sS : snsgn) (sG : snctx) (M N : nte) (tau : snTy),
    wfssig_nl sS ->
    { algeq_nl_te sS sG M N tau } + {~ algeq_nl_te sS sG M N tau}.
Proof.
  intros.
  apply streq_nl_te_dec' with (depth_nte M).
  assumption.
  auto with arith.
  assumption.
  (* lemma 2 *)
  intros.
  apply algeq_nl_te_dec' with (algdepth M N tau) (algdepth M N tau).
  assumption.
  auto with arith.
  reflexivity.
  assumption.
Qed.

STOP.


     
Lemma eq_nTy':
  forall (m n : nat) (sS : snsgn) (sG : snctx) (A1 A2 : nTy) (kappa : snK),
    n <= m -> n = depth_nTy A1 ->
    wfssig_nl sS ->
    ( walgeq_nl_Ty sS sG A1 A2 kappa )
      \/ ~ (walgeq_nl_Ty sS sG A1 A2 kappa).
Proof.
  induction m.
  intros.
  destruct A1.
  destruct A2.
  assert ({boundsnTCon tcon5 kappa sS} +
          {~boundsnTCon tcon5 kappa sS}) by (apply boundsnTCon_dec).
  assert ({tcon5 = tcon0} + {tcon5 <> tcon0}) by (apply eq_tcon).
  destruct H2.
  destruct H3.
  rewrite <- e.
  left.
  apply walgeq_nl_Ty_refl.
  assumption.
  assumption.
  right.
  intros.
  intro.
  inversion H2.
  contradiction.
  right.
  intros.
  intro.
  inversion H2.
  apply n0.
  rewrite H5.
  assumption.
  (* tcon ~ pi_intro *)
  right.
  intros.
  intro.
  inversion H2.
  (* tcon ~ pi_elim *)
  right.
  intros.
  intro.
  inversion H2.
  (* pi_intro and pi_intro at 0 *)
  replace (depth_nTy (typestar_nl_pi_intro A1_1 A1_2))
      with (S (max (depth_nTy A1_1) (depth_nTy A1_2))) in H0 by (cbv; auto).
  rewrite H0 in H.
  inversion H.
  (* pi_elim ~ pi_elim at 0 *)
  replace (depth_nTy (typestar_nl_pi_elim A1 nte5))
      with (S (depth_nTy A1)) in H0 by (cbv; auto).
  rewrite H0 in H.
  inversion H.
  (* STEP case *)
  intros.
  destruct A1.
  destruct A2.
  assert ({tcon0 = tcon5} + {tcon0 <> tcon5}) by (apply eq_tcon).
  assert ({boundsnTCon tcon5 kappa sS}
          + {~boundsnTCon tcon5 kappa sS}) by (apply boundsnTCon_dec).
  destruct H2.
  destruct H3.
  left.
  rewrite e.
  auto using walgeq_nl_Ty_refl.
  right.
  intros.
  intro.
  inversion H2.
  rewrite <- H4 in H8.
  apply n0.
  assumption.
  right.
  intros.
  intro.  
  inversion H2.
  symmetry in H5; contradiction.
  right.
  intros.
  intro.
  inversion H2.  
  right.
  intros.
  intro.
  inversion H2.
  destruct A2.
  right.
  intros.
  intro.
  inversion H2.
  (* pi_intro ~ pi_intro at S n *)  
  replace (depth_nTy (typestar_nl_pi_intro A1_1 A1_2))
    with (S (max (depth_nTy A1_1) (depth_nTy A1_2))) in H0 by (cbv; auto).
  remember (depth_nTy A1_1).
  remember (depth_nTy A1_2).
  assert ((exists A1_2',  cstu_nTy A1_2 A1_2') \/ (forall A1_2' , ~cstu_nTy A1_2 A1_2')).
  apply cstu_nTy_dec.
  assert ((exists A2_2',  cstu_nTy A2_2 A2_2') \/ (forall A2_2' , ~cstu_nTy A2_2 A2_2')).
  apply cstu_nTy_dec.
  destruct H2.
  destruct H2.
  destruct H3.
  destruct H3.
  assert ((walgeq_nl_Ty sS sG A1_1 A2_1 kappa) \/
           ~ walgeq_nl_Ty sS sG A1_1 A2_1 kappa).
  apply IHm with n0.
  apply lt_n_Sm_le.
  apply lt_le_trans with n.
  rewrite H0.
  apply le_lt_n_Sm.
  apply le_max_l.
  assumption.
  assumption.
  assumption.
  assert ((walgeq_nl_Ty sS (erasure_Ty A1_1 :: sG) x x0 kappa) \/
           ~ walgeq_nl_Ty sS (erasure_Ty A1_1 :: sG) x x0 kappa).
  apply IHm with n1.
  apply lt_n_Sm_le.
  apply lt_le_trans with n.
  rewrite H0.
  apply le_lt_n_Sm.
  apply le_max_r.
  assumption.
  apply cstu_nTy_depth with A1_2.
  assumption.
  assumption.
  assumption.
  (* we have both IH now ... *)
  destruct H4.
  destruct H5.
  destruct kappa.  
  left.
  apply walgeq_nl_Ty_pi_intro with x x0.
  assumption.
  assumption.
  assumption.
  assumption.
  right.
  intros.
  intro.
  inversion H6.
  right.
  intro.
  inversion H6.
  assert (nA2' = x).
  apply cstu_nTy_determinacy with A1_2.
  assumption.
  assumption.
  rewrite H18 in H17.
  assert (nB2' = x0).
  apply cstu_nTy_determiancy with A2_2.
  assumption.
  assumption.
  rewrite H19 in H17.
  rewrite <- H15 in H5.
  contradiction.
  (* next case *)
  right.
  intros.
  intro.
  inversion H6.
  rewrite <- H15 in H4.
  contradiction.
  (* not cstu *)
  right.
  intros.
  intro.
  inversion H4.
  apply H3 with nB2'.
  assumption.
  (* not cstu - symmetric case *)
  right.
  intros.
  intro.
  inversion H4.
  apply H2 with nA2'.
  assumption.
  (* pi_elim ~ pi_intro *)
  right.
  intros.
  intro.
  inversion H2.
  (* _ ~ pi elim *)
  destruct A2.
  right.
  intros.
  intro.
  inversion H2.
  right.
  intros.
  intro.
  inversion H2.
  (* pi_elim ~ pi_elim *)
  assert ((exists tau, algeq_nl_te sS sG nte5 nte0 tau) \/ (forall tau , ~ algeq_nl_te sS sG nte5 nte0 tau)).
  admit.
  destruct H2.
  destruct H2. 
  assert (walgeq_nl_Ty sS sG A1 A2 (skind_nl_pi_intro x kappa)
          \/ ~ walgeq_nl_Ty sS sG A1 A2 (skind_nl_pi_intro x kappa)).
  replace (depth_nTy (typestar_nl_pi_elim A1 nte5)) with (S (depth_nTy A1)) in H0 by (cbv; auto).
  destruct n.
  inversion H0.
  apply IHm with n.
  auto with arith.
  auto with arith.
  assumption.
  destruct H3.
  left.
  apply walgeq_nl_Ty_pi_elim with x.
  assumption.
  assumption.
  right.
  intro.
  inversion H4.
  admit. (* x = tau *)
  right.
  intro.
  inversion H3.
  apply H2 with tau.
  assumption.
Admitted.

Lemma eq_nTy:
  forall (sS : snsgn) (sG : snctx) (A1 A2 : nTy) (kappa : snK),
    wfssig_nl sS ->
    ( walgeq_nl_Ty sS sG A1 A2 kappa ) \/ ~ (walgeq_nl_Ty sS sG A1 A2 kappa).
Proof.
  intros.
  eauto using eq_nTy'.
Qed.
    
Lemma eq_nK:    
  forall (sS : snsgn) (sG : snctx) (L1 L2 : nK),
    wfssig_nl sS ->
    ( algeq_nl_K sS sG L1 L2 ) \/ (~ (algeq_nl_K sS sG L1 L2)).
Proof.
  intros.
  remember (depth_K(L1)).
  generalize dependent L2.
  generalize dependent L1.
  generalize dependent sG.
  induction n.
  intros.
  destruct L1.
  destruct L2.
  (* case type ~ type *)
  left.
  apply algeq_nl_K_type.
  assumption.
  (* case type ~ pi_intro *)
  right.
  intro.
  inversion H0.
  inversion Heqn.
  (* case S n *)
  intros.
  destruct L1.
  destruct L2.
  inversion Heqn.
  right.
  intro.
  inversion H0.
  inversion Heqn; clear Heqn.
  (* case S n *)
  destruct L2.
  right.
  intro.
  inversion H0.
  (* step case pi_intro ~ pi_intro *)
  assert (( exists L' , cstu_nK L1 L' )
          \/ (forall L',  ~ (cstu_nK L1 L'))) by (apply cstu_nK_dec).
  assert (( exists L' , cstu_nK L2 L'  )
          \/ (forall L',  ~ (cstu_nK L2 L'))) by (apply cstu_nK_dec).
  inversion H0.
  destruct H3.
  inversion H2.
  destruct H4.
  assert (( algeq_nl_K sS (erasure_Ty nTy5 :: sG) x x0 )
          \/ (~ (algeq_nl_K sS (erasure_Ty nTy5 :: sG) x x0))).
  apply IHn.
  apply cstu_K_depth with L1; assumption. 
  assert (( walgeq_nl_Ty sS sG nTy5 nTy0 skind_nl_type )
          \/ (~ (walgeq_nl_Ty sS sG nTy5 nTy0 skind_nl_type))).
  eauto using eq_nTy.
  destruct H5.
  destruct H6.
  left.
  apply algeq_nl_K_pi_intro with x x0. 
  assumption.
  assumption.
  assumption.  
  assumption.
  right.
  intro.
  apply H6.
  inversion H7.
  assumption.
  right.
  intro.
  apply H5.
  inversion H7.
  assert (x = nK').
  apply cstu_nK_determiancy with L1; assumption.
  rewrite H18.
  assert (x0 = nL').
  apply cstu_nK_determinacy with L2; assumption.
  rewrite H19.
  assumption.
  right.
  intro.
  inversion H5.
  apply H4 with nL'.
  assumption.
  right.
  intro.
  inversion H4.
  apply H3 with nK'.
  assumption.
Qed.  
  
Lemma wftype_nl_dec:
  forall (S : nsgn) (G : nctx) (A : nTy),
    wfsig_nl S -> wfctx_nl S G ->
    { exists L , wftype_nl S G A L } +
    { forall L, ~ (wftype_nl S G A L)}.
Proof.
  intros.
  generalize dependent G.
  induction A.
  (* base case tcon *)
  intros.
  assert ({ exists L , boundnTCon tcon5 L S } +
    { forall L, ~ (boundnTCon tcon5 L S)}) by (apply boundnTCon_dec).
  destruct H1.
  left.
  destruct e.
  exists x.
  apply ty_nl_tcon.
  assumption.
  assumption.
  right.
  intro.
  intro.
  inversion H1.
  apply n with L.
  assumption.
  (* step case pi_intro *)
  intros.
  assert ({exists L , wftype_nl S G A1 L}
          + {forall L, ~ wftype_nl S G A1 L}).
  apply IHA1.
  assumption.
  intros.
  assert ({exists L , wftype_nl S G A2 L}
          + {forall L, ~ wftype_nl S G A2 L}).
  apply IHA2.
  assumption.
(*  destruct H1.
  destruct H2.
  left.
  destruct e.
  destruct e0.
  exists (kindstar_nl_type).
  apply ty_nl_pi_intro with G A1.
*)



  
Lemma eq_nTy:
  forall (sS : snsgn) (sG : snctx) (kappa : snK) (A B : nTy),
    { walgeq_nl_Ty sS sG A B kappa } + {~ (walgeq_nl_Ty sS sG A B kappa)}.
Proof.
  intros.



  
  
Lemma tycheck_dec:
  forall (S : nsgn) (G : nctx) (M : nte),
    {exists (A : nTy),  wfterm_nl S G M A
    (forall (A : nTy), ~(wfterm_nl S G M A)).
Proof.
  intros.
  generalize dependent G.
  (* by induction on structure of the term *)
  induction M.
  