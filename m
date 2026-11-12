Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76BE7606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HHJx6bCv
Received: by kanga.kvack.org (Postfix)
	id 8E86D6B05B0; Thu, 12 Nov 2026 01:36:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872806B05B6; Thu, 12 Nov 2026 01:36:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A376B05B9; Thu, 12 Nov 2026 01:36:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44C716B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:36:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47330A8020
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:36:48 +0000 (UTC)
X-FDA: 85425508896.09.01E7C14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C1C4100009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:36:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHJx6bCv;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794465406;
	b=moE5QYg0A3TVVPMzDHzum63rg/SgXYz4iQ2SA6RkADdiI3jytMRmR9RX05CN6r6AI45Baz
	v+1Fn8x/4xPfZpBGwwH2z7CUhOnCf1PJu/1I9M7YahfG/dvnrHsfnHzKVBWggezGQ4CEva
	ZIYF/sV+uXBJqWXp3KNZj5DiutUEJyc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHJx6bCv;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794465406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RtrIdqsqTNoB8Tp2YQ6uO0c75jIeI1mGbAx+/hHzPc=;
	b=AQSauEaHfQLvblm+UnShU4PUE/cCRy019WlSyAQ1yaxxHQLLfMtRol8Usmi3E+IwWpDnEq
	XD8rag+cp+iDLQ0CwiCoEMCtssNIR0GpQj0aVYaTzOxZsDtT2wjxLkPwtQwaBD965sAXb+
	516kGgPfPSNI2nERVDr/k/WAwpHI9oc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF6F4475FF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A9F1F00AD2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794465404;
	bh=+RtrIdqsqTNoB8Tp2YQ6uO0c75jIeI1mGbAx+/hHzPc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HHJx6bCvvrYAcj4XzMKhYe5PCtP7UJmHVk5/AxixS1L/qgS7HPfBJAKbUwjLjYe4j
	 KECeDwuK9/sViJWgtXu7yQzNnBp+OwFyS3uJwaPVTECSUivfkevd5dXpkeSaTZ8VYV
	 1IAjWsqmVgo/2cjdfb7fSRDYlxoe9HmRJNE+9K3qN12KyaJNRzfeo1ld2XwGPlv8nu
	 rFeDc3h6IULVgvdQbpcJ34+cTVkooBxQH9SB+/g9/U8dbu5upZp4rgw4DoZkajKrZL
	 4SYXR+eMiP8S25df2dJxTNm3keBbwzfLQZbi3pa8yCYzo+qbuwqk4UFZTdZIWNnq4O
	 TEiXO9hKy5ZnQ==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93f259cdc86so349491485a.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:36:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHmJeIt+GMafRfhraXPklOIvh5/Zeri64hSE9yCoXyk0IH1h5Xqq6YjeTbDwktyG1cx3hJbRoSxDA==@kvack.org
X-Gm-Message-State: APuU4Z/kD4DbbX/mgNbvlzBDQRnEthYJkKb9EY4L6J4FYPQ9UXYrvs1D
	3rzzU9mGeYhCg5KGFbsViKO5oBKDPf1bBHNrsAB3AgORwZ4PAwCI1pDIJe0e/gcJxA7opRs0b6n
	23lYxGOrOnIKdPkJ2FTh/e5wuOpU+7ps=
X-Received: by 2002:a05:620a:4691:b0:93e:f0b9:505a with SMTP id
 af79cd13be357-947b007767dmr785468385a.58.1794465403716; Wed, 11 Nov 2026
 22:36:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111232603.9934-1-baohua@kernel.org> <20261111232603.9934-6-baohua@kernel.org>
 <sashiko-outbox-210413@kernel.org>
In-Reply-To: <sashiko-outbox-210413@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 12 Nov 2026 14:36:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xMUoTsPU-=_QVDqZ-p4Dt+vGJC5G8hed3PWNAk3iv8Bw@mail.gmail.com>
X-Gm-Features: AclHuK9M4cCTbrxDsGbrpPPHixNCymAyYzZTrljomY5vQZE61WTqm7Y65AMrlfk
Message-ID: <CAGsJ_4xMUoTsPU-=_QVDqZ-p4Dt+vGJC5G8hed3PWNAk3iv8Bw@mail.gmail.com>
Subject: Re: [PATCH v7 05/16] mm/mglru: skip zones above reclaim_idx instead
 of rotating them
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
X-Stat-Signature: dt6j9prpzy5xyfeg5jxd8p5zokcmhi5u
X-Rspamd-Queue-Id: 5C1C4100009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794465406-981728
X-HE-Meta: U2FsdGVkX1862Nah06FgrI+vTf2cKoTe3Owtn66WgXta5RPR6C7ccZ+eCh9ChsHBOP4Zp6Xki6hxS9GvTM7K5FzMqanyJLSG8VOnf6kMWDQebYCI8zHqqccJRn9/B54RKJ+Lo7dgpiAFh+7nqq1iG8gWINtJmWNQyyjEnEfrl4+M5VL8ZyOOX9SqLtFGQRo1bzPcWlnVvhp4uGkp4IdOzts+VWyLWQnOyTDmhT7iKs9jqGt9QHk+yEcdpIX98XFYAvdQXfcRkLW9vOprTbTSNX/jl0VSDZ8ya0/mM9F9xooxY674lV2s0G1c8AVmBsQ0/8Bf4/5Ay1t6yC7OfWg4jJbIKNEsHpNr0RkKRDe+ERyYwsR4HQXbAQANgZselVlwz0ZtBGtBwIlVxbJVW4zT2eMxKCF5UKq+ZgNI4lbIK5a6vsSAY4Rb9j4rptXzHSl7F+U2b+QH6vlySO7t7td0TO6qNwf+NSK+wgaUxacsVylWy1yc1VlKAyGrNMXNT2IIfbxBZ4as6tIxG3fX0A0ZkbzUOtllwVqe1n7YSE2jZNB5PDBZRgNAeKU0y3E4Ad//Jew8k2DDTEFsWvniHdG/m6xoXHIV4iUlpI2Uhm65WKamOMBIvl2ECOKssuqvQSxYKwu1R7WK57/Gpnl5OrS7AKYKrsz6UFyqfhHTzIF9LWvcmeNR80a6siiaB8oz4K0mK5ICF7+QaRVJ3FbWC1xGJdNEVVupcHj+c3Rkn5eevU2A4WmMaeFi8OIE1yq9dzfOM5jLEtmNJUoeqK73EtpkpzUADsutKv/2BjD2j5oCf3y6nxVI2BFdRQV2ko/hMhPd5d5cIhoinDvdhvQTbN/lFj3yrRyiPHZFF+zn8imLJ/Wb/1dWu/i3ITGOsOoJIzu8cmbNamItOJd+DWYt+hkVjJSCEM47ExnvZoysSV6ww3kEB3vX9y29T2f2wJjevqABsUxXF1Q32r9qjORtvdP
 4atrGq+0
 bRP/fxZ7YbIbGc4grHXuN7eX/cGb3QV8oqj5O761SyWTRVPuT1FPBlqm7ja8DByy2TehgFE4V+darnjA8Gyq1lPaKq/LeqnFxMFCW72GpChbh8Sz3UuAtGxl+T6I4DgoFd77aL9/jq/MTl0+f1mSKHOg8T9qDcdUz6Sxp8zOiZvMGTOOizBvj9yShDCkF2yPeDT2qJNFvnp34doB9sXgpZ0DbEsPIoXd1f07UV0/9BTaV7bFAmqd8QQURrPje6s/rv+RMNqGNIwJjHqSv+bdV2Vk9E9XEbSfL+AJefNZH805mrzxtTTyynEtInGwgd8IYErmLZHnpcYxsoj/HwBt2S4hr5o9xtWVuXbJSwOOCBAF4h6Cxvm2Dkadea5IqHMyDa7ww7Zr0UV2L4QfvOXBWPr536Yzt6cWWgCSqqx9qCtLdXwPeSeqPvr/LvA1AvornZWbtzsVW4oXJDZM4dViN5V7gy2o3pKcDgmob3Tl6yXPodZpm9MBnf10RHKQnSz5N0+CK+gi6Sy3UEFSS3xgkWFI5yalgF6CXtihG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 1:01=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/mglru: pinned min_seq in try_to_inc_min_seq() stalls aging
> --
>
> commit a9558af5b6eefdf9bb9a64058218b290ef8ecc66
> Author: Kairui Song <kasong@tencent.com>
>
> mm/mglru: skip zones above reclaim_idx instead of rotating them
>
> This commit restricts scan_folios() and lruvec_populated_min_seq() to zon=
es up
> to sc->reclaim_idx instead of scanning and rotating folios in higher zone=
s.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 51c2ee66b3ee8..273aa8c56bec8 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3992,7 +3992,7 @@ static bool inc_min_seq(struct lruvec *lruvec, in=
t type, int swappiness)
> >
> >  /* Similar to lruvec_evictable_size, return the oldest populated seq o=
f the type */
> >  static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, i=
nt type,
> > -                                           unsigned long max_seq)
> > +                                           int zone_limit, unsigned lo=
ng max_seq)
> >  {
> >       int gen, zone;
> >       unsigned long min_seq;
> > @@ -4003,7 +4003,7 @@ static unsigned long lruvec_populated_min_seq(str=
uct lruvec *lruvec, int type,
> >       min_seq =3D READ_ONCE(lrugen->min_seq[type]);
> >       while (min_seq <=3D max_seq) {
> >               gen =3D lru_gen_from_seq(min_seq);
> > -             for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> > +             for (zone =3D 0; zone < zone_limit; zone++) {
> >                       if (!list_empty(&lrugen->folios[gen][type][zone])=
)
> >                               return min_seq;
> >               }
> > @@ -4026,7 +4026,7 @@ static void try_to_inc_min_seq(struct lruvec *lru=
vec, int swappiness)
> >       /* Requires at least MIN_NR_GENS gens for basic functionality */
> >       seq =3D lrugen->max_seq - MIN_NR_GENS;
> >       for_each_evictable_type(type, swappiness) {
> > -             min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, =
seq + 1);
> > +             min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, =
MAX_NR_ZONES, seq + 1);
> >               if (min_seq[type] > lrugen->min_seq[type])
> >                       seq_inc_flag =3D true;
> >       }
>
> [ ... ]
>
> > @@ -4780,24 +4773,22 @@ static int scan_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
> >        * when under pressure to respect swappiness more and reduce IO c=
ost.
> >        */
> >       if (sc->priority =3D=3D DEF_PRIORITY)
> > -             min_seq =3D lrugen->min_seq[type];
> > +             seq =3D lrugen->min_seq[type];
> >       else
> > -             min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen=
->max_seq);
> > +             seq =3D lrugen->max_seq;
> >
> > -     gen =3D lru_gen_from_seq(min_seq);
> > +     seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + =
1, seq);
> > +     gen =3D lru_gen_from_seq(seq);
> >       max_gen =3D lru_gen_from_seq(max_seq);
> >
> > -     for (i =3D MAX_NR_ZONES; i > 0; i--) {
> > +     /* Scan eligible zones in descending order. */
> > +     for (zone_idx =3D sc->reclaim_idx; zone_idx >=3D 0; zone_idx--) {
>
> [Severity: High]
> As reported by KunWu Chan on RFC v5 [1], does skipping zones above
> sc->reclaim_idx in scan_folios() while try_to_inc_min_seq() still checks =
all
> MAX_NR_ZONES stall aging during zone-constrained reclaim (for example,
> GFP_DMA32 reclaim when ZONE_NORMAL is populated)?
>
> When an lruvec has MAX_NR_GENS (4) generations, lrugen->min_seq[type] sta=
rts
> at max_seq - 3.  Because scan_folios() no longer rotates folios in zones =
above
> sc->reclaim_idx, any folios in those zones keep try_to_inc_min_seq() from
> advancing lrugen->min_seq[type] once eligible zones are drained.
>
> In should_run_aging():
>
> mm/vmscan.c:should_run_aging() {
>         ...
>         if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_se=
q)
>                 return true;
>
>         /* try to avoid aging, do gentle reclaim at the default priority =
*/
>         if (sc->priority =3D=3D DEF_PRIORITY)
>                 return false;
>
>         /* better to run aging even though eviction is still possible */
>         return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
> }
>
> With min_seq pinned at max_seq - 3, evictable_min_seq() + MIN_NR_GENS nev=
er
> reaches max_seq, so should_run_aging() returns false and scan_folios() dr=
ains
> eligible zones down to the youngest generation max_seq where sort_folio()
> disables tier protection and workingset promotion (min_gen =3D=3D max_gen=
).
>
> Even with the follow-up commits in this series (commit "mm/mglru: Run agi=
ng
> when pages are rare outside the youngest gen", commit "mm/mglru: Run agin=
g
> when one type has no populatable folios", and commit "mm/mglru: Restrict
> eviction accounting to eligible zones"), at priorities above DEF_PRIORITY=
 / 2
> scan_folios() caps seq at max_seq - 1 and evict_folio_lists() returns 0 o=
nce
> older generations are empty in eligible zones, causing try_to_shrink_lruv=
ec()
> to break out before calling should_run_aging() until priority drops to

I'm not sure why this is marked as high severity, as it
seems more like a performance concern. Also, when we
scan the youngest generation, tier protection and
workingset promotion are no longer needed, as the
folios are already in the youngest generation.

Actually, I created a silly test case that forces
GFP_DMA32 for anon folios:

diff --git a/mm/memory.c b/mm/memory.c
index fe72e66c9c2e..350ac4a834e6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1251,7 +1251,7 @@ static inline struct folio
*folio_prealloc(struct mm_struct *src_mm,
        if (need_zero)
                new_folio =3D vma_alloc_zeroed_movable_folio(vma, addr);
        else
-               new_folio =3D vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,=
 addr);
+               new_folio =3D vma_alloc_folio(GFP_USER | __GFP_DMA32, 0,
vma, addr);

        if (!new_folio)
                return NULL;
@@ -5053,7 +5053,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
        if (!folio) {
                /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO
devices and zswap */
                if (swap_entry_synchronous(si, entry))
-                       folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
+                       folio =3D swapin_sync(entry,
GFP_HIGHUSER_MOVABLE | __GFP_DMA32,

thp_swapin_suitable_orders(si, vmf) | BIT(0),
                                            vmf, NULL, 0);
                else


In this case, the current patchset still performs much
better on MGLRU than using CLRU.

MGLRU
*** Executing round 0 ***
set swappiness to 60

real 1m57.803s
user 25m34.833s
sys 6m8.024s


CLRU:
*** Executing round 0 ***
set swappiness to 60

Endless....(CLRU can't finish the kernel build at all)

If we do want to trigger aging earlier when evict_folio_lists()
returns 0, rather than waiting until the priority drops to
DEF_PRIORITY / 2, Bo Zhang shared an idea with me off-list
that might address this issue.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9f759d213614..3721725852b3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4033,8 +4033,6 @@ static void try_to_inc_min_seq(struct lruvec
*lruvec, int swappiness)

        /* see the comment on lru_gen_folio */
        if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
-               unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;
-
                if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < =
seq)
                        min_seq[LRU_GEN_ANON] =3D seq;
                else if (min_seq[LRU_GEN_FILE] > seq &&
min_seq[LRU_GEN_ANON] < seq)
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

> DEF_PRIORITY / 2 and scans max_seq without tier protection.
>
> [1] https://lore.kernel.org/r/CAN_Opa-AScm9=3DEeXO_Uy8VjbQ=3DbqY9P++rFP8H=
1RhUB4dOt6xw@mail.gmail.com
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.99=
34-1-baohua@kernel.org?part=3D5

