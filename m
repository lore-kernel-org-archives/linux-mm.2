Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0AF0606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gF5tFVOm
Received: by kanga.kvack.org (Postfix)
	id 216146B05B7; Thu, 12 Nov 2026 06:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C68D6B05C1; Thu, 12 Nov 2026 06:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5746B05C2; Thu, 12 Nov 2026 06:11:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D02B56B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:11:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FC65120564
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:11:49 +0000 (UTC)
X-FDA: 85426201938.10.16833AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 502BE14000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:11:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gF5tFVOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794481907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnGEZvnnpMRgr4BGvsUdhBhUeS7aU015fsB7ODIPjaA=;
	b=WoYoAhBEyWHcNe6wabGq6mSirMSeCkAILDu/yND+ZDYktRPFEBBJaa2EigRJ7G6zW14aZA
	hIpfOS+uZFM9+EhPe9T+XdWIArDS0LTsqNH4dBLxZhneeye+s2HsQ4lk9i8YdOVunLuPGb
	rEhrkMOiaqtBMIKikCszI+ooWJUoqqA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gF5tFVOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794481907;
	b=vAPmwNb9DePdp/r8y6YqqgWnUXdOr4EU+D7dZ9xtuLZOpKeNW4WNunTbZeKXw6BDBeKMpe
	kZNWcGl1rppj89oUC7PCcDM7l79WlMLCMYbPJi9vkVJY7QlemqpTUKwpUPa6QBHjIjLQH7
	qsBSBt4JNlhldd+beOWZj1X8+SsonXg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C9CF47953
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E351F00A14
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794481906;
	bh=NnGEZvnnpMRgr4BGvsUdhBhUeS7aU015fsB7ODIPjaA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gF5tFVOmj+hKuv/u9tJMEmOyOCPsaE0qV+Un4d9UHLL7OfMzB09iBVQJD2QiO226E
	 qlEeB42uSzqlHfNlZDR9eInWm8lnG7Bp1CKxtZMLrxITcjrwSivLBy5pMuGc4LAi7B
	 EOxD6kTOsmKcRZC0UZtERibG+9dDQgCyr6pBWG4ZtxyCAblZMmkSceXcPC3cRNTi5N
	 iwInF/U11HR1EUftYsUl2DrndX/cO6MSdfxmOUowRALlwu91BNxOUUvonjAHgU2R5I
	 xotvpvrHRledIPnK3Br7jkpmxW2YUkBx6YzQVNhmhd24HoDpS9gP2lSw6zCus0MA2l
	 a8mRDcjiZEd0A==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91c11468b5fso35738386d6.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:11:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHRsufpRobLBDdzJ3HKxvuIdusC7juTbvehcp0io8FHAZ6inwmDUuMWK6IWxQBYljx3AMAtNyWsGg==@kvack.org
X-Gm-Message-State: APuU4Z/A2lhsj3wEwipQNQWtb5igSB5rpZHa9uD7AhitJk6kOIvKfPwv
	5rZqG+K6WrjR8rmKnlLsLVCtcffk0jeY26Qu8/ggVRh1CA20rK0hiTRnJprB6Wu9cf3K1TNvu+Z
	GvXRv+ogIr2xcuY28YxOxCxkblE7VGYs=
X-Received: by 2002:a05:620a:472b:b0:944:16e7:15c1 with SMTP id
 af79cd13be357-947afd68775mr958246785a.19.1794481905538; Thu, 12 Nov 2026
 03:11:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111232603.9934-1-baohua@kernel.org> <20261111232603.9934-12-baohua@kernel.org>
 <sashiko-outbox-210419@kernel.org>
In-Reply-To: <sashiko-outbox-210419@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 12 Nov 2026 19:11:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wFye_co4bnJwuaoyshZOE+gcWFthmWD3r94dQgVHp8GQ@mail.gmail.com>
X-Gm-Features: AclHuK9A1r3vfYFu07CpdiG2lvAl7dAtD7d-JH_1uYu-MWR7CtRFEOHr2tv8OVU
Message-ID: <CAGsJ_4wFye_co4bnJwuaoyshZOE+gcWFthmWD3r94dQgVHp8GQ@mail.gmail.com>
Subject: Re: [PATCH v7 11/16] mm/mglru: Run aging when one type has no
 populatable folios
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, 
	liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, 
	mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, 
	ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, 
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, 
	zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 502BE14000B
X-Stat-Signature: gymko8af31ordehiuyepzzo7aoc47yqh
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794481907-973377
X-HE-Meta: U2FsdGVkX19zFhBnLixec2//jepXDYwclTyzoW8nly3hCyJdfE/gRftvnY7dcO6DD+xG04KEPSnA6c3vDW6+vQtCiowe+EkbN1KiATkOhSnnmYykewBjgOWyERyZNbdaa5oB+gnJ6NiWdXZhpXzHnhOw0hmqPuNJ4Z3/kaBpFY1tta1iVqc+Dc8LnATKsuCyV/UZO/Rz8mVtjKMrZfp2XoBDlicFMsBYpb0xajvaU+X01pT9NMcRSb3B8A51vtp8ZziEUr/rB+uW4LBto6PKygiovQIQV21KPFyT+/JNnuWgAmMe3AbLM7W1jrtaWnXhbAioOSo0wLIaDfIbEjahzkkOosRuiBmaphLbjXrDFT6tymwtybyiYdIjLGTswf8CnJwkZeoZJjQQH3JVxeIP4cq9Wgzvs324+LvqSq8aWiLUb/BPjkrew1fZ5zqbS5fxxu+v6G19k50G3YpA0kOzw1X6lgJcXaHR1OREebl2vo6JasetgjWpRj3mUWoeTWPTKe0M8OOERQsZ2mfv/wWuso1VMzaVNP38W/RL22/14igJdwgnzt61ZbtFizKN0rRJ04qC0zkWkn93GlLuECpg0uZvJGAv2kOtYcSETqDj79Z0FKSJiHtmhtS79YkesIZFmzUpNkojwX4LRTd1oHAvuzHD7tYEwFA3lVvktcca52mXMjyVJk5AJBjsgRnezr7WYmgtQtXsO+F/tLpL5yUug3gfO5ysiuncHSio93/VfN+FgkxJc+8NytVQyNzpyNDz8ja6jiQVaD+B+uyAn6iisFXMzLU6R0wOabSaCof2Es+Dr/wJHXweaavhHn6FYj644VMXBUKtVBl6R7ch3W8xBm5Y+TXRx5yV/2wIl3hGV7ABEHDh4tRT5tPP0lvurQ07JS97SZhhjGoNqU0plwjPIHCQiODEB5xIJZTlxcxOv/JDdv++bZpyvBWgWDMFTIaIT/xoA/bT66/mARe8e7E
 HPaILgoF
 UI+wOIkNOrVLSapNR0h0OxJ64/kZdW4NMVocGeelfC7ubp3zj1XLln1oPHUyYUk/Acg04Opf8wBrb+d+1M3mRF1R5megfPHnwSHPjlOvvtNjcPvm6azqOfLwCWts+NuT/7S3CujoAoXuVhOiHplyOuaYmenFCE6xdaKfqucExGdgbgKdAn9qAacz8EX3D3NozafMVgE9+rshxYmShHdXfRPP+OclfK97wsgZjEpbdoYEscUbNraALhILq0Xa3Vs8OHECL6WwoAjE4dOAABm9K9OaQNwbnuFvZC81LaZT6cUNeo5Ek76n7E++9Z1vurzyWimfENKCcJXiockFl45cf+bxhimnEptkLeQBC4iwEa+tLJgcSCxXg61gXC8Uivn8Y+RfDMOwZ6Y6+ByvzkGkUieE0BQnQXZEdDHaf1lzQz4rMkQPiUDbxlnzcZn5tbv4UMLSnS2mDOXLo3splQqSWahBlYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 1:01=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] mm/mglru: skipped aging in try_to_shrink_lruvec() when zero
>   folios are scanned
> - [Medium] mm/mglru: repeated aging in try_to_shrink_lruvec() when
>   no_populatable persists
> - [Low] mm/mglru: stale max_seq passed to should_run_aging() in
>   try_to_shrink_lruvec()
> --
>
> commit b68a220713e0f1b121c4874a48ac05f55108264a
> Author: Barry Song (Xiaomi) <baohua@kernel.org>
>
> mm/mglru: Run aging when one type has no populatable folios
>
> This commit moves the aging check in try_to_shrink_lruvec() after
> evict_folio_lists() and passes a no_populatable flag to should_run_aging(=
)
> so aging runs when one LRU type makes no scan progress despite remaining
> scan budget.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 085450819ee8e..41dd77652c82f 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5105,7 +5105,8 @@ static bool lru_gen_imbalanced(struct lruvec *lru=
vec, struct scan_control *sc,
> >  }
> >
> >  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_=
seq,
> > -                          struct scan_control *sc, int swappiness)
> > +                          struct scan_control *sc, int swappiness,
> > +                          bool no_populatable)
> >  {
> >       DEFINE_MIN_SEQ(lruvec);
> >
> > @@ -5117,6 +5118,13 @@ static bool should_run_aging(struct lruvec *lruv=
ec, unsigned long max_seq,
> >       if (sc->priority =3D=3D DEF_PRIORITY)
> >               return false;
> >
> > +     /*
> > +      * Run aging if scan budget remains but no folios
> > +      * in populatable generations are available to scan.
> > +      */
> > +     if (no_populatable)
> > +             return true;
> > +
> >       /* better to run aging even though eviction is still possible */
> >       if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D m=
ax_seq)
> >               return true;
> > @@ -5221,20 +5229,17 @@ static bool try_to_shrink_lruvec(struct lruvec =
*lruvec, struct scan_control *sc)
> >       lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
> >
> >       while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
> > +             unsigned long orig_file, orig_anon;
> >               DEFINE_MAX_SEQ(lruvec);
> > +             bool no_populatable;
> >
> >               if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
> >                       need_rotate =3D true;
> >                       break;
> >               }
> >
> > -             if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> > -                     trace_mm_mglru_aging(lruvec, sc, swappiness);
> > -                     if (try_to_inc_max_seq(lruvec, max_seq, swappines=
s, false))
> > -                             need_rotate =3D true;
> > -                     should_age =3D true;
> > -             }
> > -
> > +             orig_anon =3D nr[LRU_GEN_ANON];
> > +             orig_file =3D nr[LRU_GEN_FILE];
> >               if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LR=
U_BATCH))
> >                       break;
> >
>
> [Severity: High]
> Does moving should_run_aging() and try_to_inc_max_seq() after
> evict_folio_lists() skip aging whenever evict_folio_lists() scans zero
> folios?
>
> mm/vmscan.c:scan_folios() {
>         ...
>         if (sc->priority =3D=3D DEF_PRIORITY)
>                 seq =3D lrugen->max_seq - MIN_NR_GENS;
>         else if (sc->priority > DEF_PRIORITY / 2)
>                 seq =3D lrugen->max_seq - 1;
>         else
>                 seq =3D lrugen->max_seq;
>
>         seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + =
1, seq);
>         ...
> }
>
> At DEF_PRIORITY, when only MIN_NR_GENS generations remain
> (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq),
> scan_folios() caps seq to max_seq - MIN_NR_GENS, which is below min_seq
> and already empty.  evict_folio_lists() then returns 0 and breaks out of
> the loop before reaching should_run_aging(), making the mandatory
> evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq aging
> check unreachable at DEF_PRIORITY.
>
> Similarly, at DEF_PRIORITY / 2 < sc->priority < DEF_PRIORITY,
> scan_folios() caps seq to max_seq - 1.  Whenever all evictable folios for
> the budgeted type(s) are in max_seq (for example when both types only hav=
e
> folios in max_seq, or when only one type has budget left),
> evict_folio_lists() returns 0 and breaks before aging can run, leaving
> need_rotate false as well so shrink_one() fails to rotate a sizable memcg=
.
>
> Finally, when sc->priority <=3D DEF_PRIORITY / 2, running
> evict_folio_lists() before should_run_aging() scans directly from max_seq
> (where min_gen =3D=3D max_gen in sort_folio() disables tier protection) b=
efore
> aging can split the youngest generation, and breaks without aging if the
> first batch satisfies should_abort_scan().

As I mentioned in my earlier reply [1], Bo Zhang suggested
the following change to me off-list:

@@ -5233,6 +5231,7 @@ static bool try_to_shrink_lruvec(struct lruvec
*lruvec, struct scan_control *sc)
                unsigned long orig_file, orig_anon;
                DEFINE_MAX_SEQ(lruvec);
                bool no_populatable;
+               long scanned;

                if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
                        need_rotate =3D true;
@@ -5241,8 +5240,7 @@ static bool try_to_shrink_lruvec(struct lruvec
*lruvec, struct scan_control *sc)

                orig_anon =3D nr[LRU_GEN_ANON];
                orig_file =3D nr[LRU_GEN_FILE];
-               if (!evict_folio_lists(nr, lruvec, sc, swappiness,
MIN_LRU_BATCH))
-                       break;
+               scanned =3D evict_folio_lists(nr, lruvec, sc,
swappiness, MIN_LRU_BATCH);

                if (should_abort_scan(lruvec, sc))
                        break;
@@ -5263,6 +5261,9 @@ static bool try_to_shrink_lruvec(struct lruvec
*lruvec, struct scan_control *sc)
                        should_age =3D true;
                }

+               if (!scanned)
+                       break;
+
                cond_resched();
        }


This gives aging a chance to run even when
evict_folio_lists() returns 0.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4xMUoTsPU-=3D_QVDqZ-p4Dt+vGJC5G8=
hed3PWNAk3iv8Bw@mail.gmail.com/

>
> > @@ -5248,6 +5253,15 @@ static bool try_to_shrink_lruvec(struct lruvec *=
lruvec, struct scan_control *sc)
> >               if (root_reclaim(sc) && should_age)
> >                       break;
> >
> > +             no_populatable =3D (nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] =
=3D=3D orig_anon) ||
> > +                              (nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] =
=3D=3D orig_file);
>
> [Severity: Medium]
> Can no_populatable stay true across every MIN_LRU_BATCH iteration and
> trigger repeated aging when one type still scans 0 folios after aging?
>

This is very unlikely. As long as while (!list_empty(head))
holds, we will have a non-zero scanned count:

while (!list_empty(head)) {
        struct folio *folio =3D lru_to_folio(head);
        int delta =3D folio_nr_pages(folio);

        scanned +=3D delta;

Aging should also help move some folios into
populatable generations.

> nr[] is computed once in lru_gen_prepare_scan() and is only decremented b=
y
> scanned folios.  If scan_folios() continues to return 0 for one type whil=
e
> the other type makes progress (for instance when sc->priority <=3D
> DEF_PRIORITY / 2 already scans up to max_seq, when max_seq has no eligibl=
e
> folios of that type, or when walk_mm() promotes all referenced folios int=
o
> the new youngest generation), nr[type] remains equal to orig_anon or
> orig_file.  In cgroup reclaim (!root_reclaim(sc)), the loop does not brea=
k

Folios shouldn't be promoted repeatedly, as earlier aging
should have already cleared their PTE young bits.

> on should_age, so should_run_aging() returns true and calls
> try_to_inc_max_seq() on every 64-page batch of the other type; in
> root_reclaim(sc), it runs unnecessary aging and aborts scanning the
> populated type after one extra batch.

>
> > +             if (should_run_aging(lruvec, max_seq, sc, swappiness, no_=
populatable)) {
> > +                     trace_mm_mglru_aging(lruvec, sc, swappiness);
> > +                     if (try_to_inc_max_seq(lruvec, max_seq, swappines=
s, false))
> > +                             need_rotate =3D true;
> > +                     should_age =3D true;
> > +             }
>
> [Severity: Low]
> Can should_run_aging() see a stale max_seq alongside a fresh min_seq here=
?
>
> DEFINE_MAX_SEQ(lruvec) snapshots max_seq at the start of the loop before
> evict_folio_lists(), whereas should_run_aging() reads min_seq after
> evict_folio_lists() finishes.  If a concurrent reclaimer advances max_seq
> and min_seq during eviction, should_run_aging() compares the new min_seq
> against the old max_seq, which can falsely trigger the aging branch, fail
> try_to_inc_max_seq() on the stale max_seq, and set should_age =3D true so
> root_reclaim(sc) aborts on the next pass.

I guess this is a pre-existing race that could also occur
before this patchset, but the patch somehow widens the race
window. One possible approach is to read max_seq later,
just before calling should_run_aging().

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.99=
34-1-baohua@kernel.org?part=3D11

