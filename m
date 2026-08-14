Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6136C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744906B0721; Fri, 14 Aug 2026 19:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5806B0723; Fri, 14 Aug 2026 19:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3AE6B0724; Fri, 14 Aug 2026 19:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 077F86B0721
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:28:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74C611A02AC
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:28:43 +0000 (UTC)
X-FDA: 85101466926.03.9D2BC76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 886F040003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:28:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zw9dTzSL;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786750121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eR4S2R/3oS5YObv7yGePjWbnUk9MHYzmwJK1zpSKt00=;
	b=zxECeUxUgKraKHe8DWHh2ypelclYLPjMu5S7uBUbU/K1Xqit0FVknp/0/BsOqvYgWeVtR/
	/pc/MUM81FtiiSTXNMsY7wLXyK6awCY+U1+0CNCvcm0637fypIVayEIQLRh3alPmxA/lgz
	JZ+Yc05drDqxrvLbr8ej0KPxvEbMg+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786750121;
	b=n198p0bgGveDbnIuakG5uLRLbvK/FOGdtmd2NfxoyBTLWeTu2vZI8O0DL7T+asXumnU+Py
	bzoia4y3Ay3wvSs34pxHFfmd+sHBD985cyEMUx6w0OHPVHYJhDjoqAzqKP/6/XH2NsH9eT
	nhaP+hVhzg0g7FnyY9zCMppz3KQnPlc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zw9dTzSL;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F35A4081D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BF91F000E9
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786750120;
	bh=eR4S2R/3oS5YObv7yGePjWbnUk9MHYzmwJK1zpSKt00=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Zw9dTzSLUxQpDIw/lVAvqAB0YYnGVDU7raeqpaZV+Yq37HD5BpFIo9wP2ZTDLTV1e
	 sTGsulZynnetyPaJ6bkANREye0Izy4trpPDE0T5+J/7PgnKQZoerdYqu4IjDmKFKg0
	 Hz5/81WijEdvom9NhOH9XJ8wfiRxT+j79kv5tZPiTXotLfd43FbdFNO3kFwpzAr5gb
	 4voOitjZTyRf4lbghgfE2ESpzwvSBhxExQkc0W9kcP3ru7S/PPA2DM3bM6bNCrCSjv
	 TGD24Wxa0kTTHj8PnqV79/+Uzi1usL2382YQeNQwPSKauNTNwAXTLJzrbGqG6vdpNg
	 ewT5Wob0UFAiQ==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-930c0f9c1b1so91290585a.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:28:40 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz3vLbFoDnL6sR346od+oCJeQL9k5lPuEsX8vR3t+8REdK03/9V
	JEM9gMbSTp1xdSUq3wKYE2ddguH775XzH8mlKoN5qNlSgF0EBRQhp/3hQuexkB5++koGNmOzt5B
	kUSKORwYu22CLoYtGKinpxPncknNfFDw=
X-Received: by 2002:a05:620a:25d0:b0:934:9639:3a4 with SMTP id
 af79cd13be357-936d2382c37mr824631685a.41.1786750119522; Fri, 14 Aug 2026
 16:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260806103003.3924438-1-baoquan.he@linux.dev> <20260806103003.3924438-4-baoquan.he@linux.dev>
In-Reply-To: <20260806103003.3924438-4-baoquan.he@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 15 Aug 2026 07:28:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yF=NN896RqhGWGtkhQPFr2ZSsFC2izhA456J_fnRv78A@mail.gmail.com>
X-Gm-Features: AUfX_myxINIUemzjxm2Fs1iOU7eYFEcSBQKTnvR7Z1OroZSJvdTxXyQnPcddykA
Message-ID: <CAGsJ_4yF=NN896RqhGWGtkhQPFr2ZSsFC2izhA456J_fnRv78A@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] mm/mglru: skip empty PUD subtrees during aging
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: kmt6bcu9pmyx4c5usbeux5hwzesxx9fm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 886F040003
X-HE-Tag: 1786750121-374657
X-HE-Meta: U2FsdGVkX1+lf7ELFXZbNAdXG4eBt9bCmlMpqHNXy+66Xyt0uOdcnbwRRZISmZalURDwEyH212FMjlGheb7cF8o1sLNVyY8emX+EtgZVyZbQMggCdMDmSUuISXrRYGsIr/4lF33+W+92d3Nx5C8WXWjIRoDOnHTNcVVEezY486kGmNRNV2IAoGl1iFxQX+S6P9lpbbcyY0rcG8x2nLDctQ6bO+TFxv/XIl+JJyVefiFtrCi7xnl1gip8U8GQ/+8sYQzf22mnx6NHP4atFSpmcNYTKkl0r+e5oY4qKt8VjMmD6aiGBCtW1s1yOYEW0loLN1K16ZtQQcCEUaP0TSRnAFGSC1Xi3MeCLa3BO6I4Pc8wyTcmiweEllsYNpgCZBBI9DZqmmPREnhvxF3raAPCOjT+ATdno76TXp+dCn8Dm0eyTBCcfpOXz3j1zHLaijnCnSs4TLfUSlcVC/SRxW+yTTuXOptps3N1yMLSwOzHLUdziJihA+MrOwup9YYH64MPOOs+Kz/dNm7aogDp4lGxQT86FVkSB8wOF9ThyoRpg9sj/5YKJgEErf1JwrNiXFKV2mXj/R0rru+aEjCF63K5w5YRBodgcN9AC/2k541hYhqxgkPLaETdJAc4HLz2pfvsy5R2yfhiuZ3Btgu9e0uamN2W6SDH+57igiE+Y2hd6pWLQpuCKgnc/BbLKB0BmmXcDApPDQp2Jairyu66ohxyqoFVWd0pxAjlbZogMreuJsCOCwKDcGpKFD+XwZHD/CsLztmDu2pw7xvCum0mpLhyWjtCAKZHPbNxKe89JbaO1+YWTE61BEZbceRCMQnWvlbAy7swQf72PPzwSJTcxSiC4Dqytts10x9muBsDyouDYlE9ydL+RrGBHIIamc/uz/trzMy/tkQBAdlEX5jFRZQ3olV4eI7MKIg9S8WbXZsdXPahfBCAcR8c2Qc6YNccs2jQBt2MwsqlgoOT+scTM5G
 Zv3dMwW+
 v1DNR8dhSHcVfwFuPlew9rDQZh867QbjXoUI12DlfyOgUFn4mo9iiWutuF1PW/rkkl71+g/BXWIk16ST7YFFCkqXUzMbg52b0WctDNb0k8HXel3pKtoSybd6/RXJFBaXrJCaHJXZddxQ/8lwts6uJl9LP+Vk35by8vtZiaySGCa11A246dyZSTTJA+LfSaYt8cH+ZAb1JP9XVUVavPxlTx3nahQYd47UTcTRBBX2YKlYdSGkKvwx8OCAlNIyaIucN6LyrsPmjZmH7bJbUrTlz0M1U6usZ6B85VjJy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 6:30=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> The aging walk descends every present PUD and iterates all 512 of its
> PMDs, testing the PMD-level Bloom filter on each. For a process whose
> memory lives only on other NUMA nodes, every PUD of this lruvec fails
> the PMD test, so the whole PMD iteration is pure waste - and on
> multi-socket systems these cross-node walks are common because
> lru_gen_use_mm() marks an mm for all nodes at every context switch.
>
> Add a PUD-level Bloom filter (pud_filters) one level up. walk_pmd_range()
> now reports whether it found any young leaf entries; walk_pud_range()
> records that in the PUD filter and, on subsequent generations, skips the
> whole 1GB subtree when the filter says it had none last generation.
> The double-buffered filter flips with each new iteration, and the
> existing eviction feedback (lru_gen_look_around()) keeps hot regions
> marked, so newly hot or migrated-in pages are re-examined promptly
> rather than suppressed indefinitely.
>
> force_scan walks bypass the PUD test, so manual aging and newly added
> mm's always rescan and re-populate the filter.
>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  mm/vmscan.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 47 insertions(+), 3 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a397c62b2e5d..74edfe2a747d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2816,6 +2816,13 @@ static bool __maybe_unused seq_is_valid(struct lru=
vec *lruvec)
>   * walk_pmd_range(); the eviction also report them when walking the rmap
>   * in lru_gen_look_around().
>   *
> + * A second, coarser pair of filters (pud_filters) sits one level up. It
> + * remembers which 1GB PUD subtrees had young leaf entries, so walk_pud_=
range()
> + * can skip whole subtrees whose 512 PMDs would all fail the PMD-level t=
est =E2=80=94
> + * e.g. the page tables of a process whose memory lives only on other NU=
MA
> + * nodes (cross-node empty walks). It mirrors the PMD-level filters: pop=
ulated
> + * by walk_pmd_range()/lru_gen_look_around(), flipped by reset_pud_bloom=
_filter().
> + *
>   * For future optimizations:
>   * 1. It's not necessary to keep both filters all the time. The spare on=
e can be
>   *    freed after the RCU grace period and reallocated if needed again.
> @@ -2907,6 +2914,23 @@ static void reset_bloom_filter(struct lru_gen_mm_s=
tate *mm_state, unsigned long
>         __reset_bloom_filter(mm_state->filters, seq);
>  }
>
> +static bool test_pud_bloom_filter(struct lru_gen_mm_state *mm_state, uns=
igned long seq,
> +                                 void *item)
> +{
> +       return __test_bloom_filter(mm_state->pud_filters, seq, item);
> +}
> +
> +static void update_pud_bloom_filter(struct lru_gen_mm_state *mm_state, u=
nsigned long seq,
> +                                   void *item)
> +{
> +       __update_bloom_filter(mm_state->pud_filters, seq, item);
> +}
> +
> +static void reset_pud_bloom_filter(struct lru_gen_mm_state *mm_state, un=
signed long seq)
> +{
> +       __reset_bloom_filter(mm_state->pud_filters, seq);
> +}

I'd rather have symmetric names such as update_pmd_bloom_filter()
and update_pud_bloom_filter(), rather than
update_bloom_filter() and update_pud_bloom_filter().
it could also be:

update_bloom_filter(mm_state, seq, pmd + i, PMD);
update_bloom_filter(mm_state, seq, pud + i, PUD);

I think either approach would make the intent clearer than the current
naming.


> +
>  /***********************************************************************=
*******
>   *                          mm_struct list
>   ***********************************************************************=
*******/
> @@ -3146,8 +3170,10 @@ static bool iterate_mm_list(struct lru_gen_mm_walk=
 *walk, struct mm_struct **ite
>
>         spin_unlock(&mm_list->lock);
>
> -       if (mm && first)
> +       if (mm && first) {
>                 reset_bloom_filter(mm_state, walk->seq + 1);
> +               reset_pud_bloom_filter(mm_state, walk->seq + 1);
> +       }
>
>         if (*iter)
>                 mmdrop(*iter);
> @@ -3728,10 +3754,11 @@ static void walk_pmd_range_locked(pud_t *pud, uns=
igned long addr, struct vm_area
>         *first =3D -1;
>  }
>
> -static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned lon=
g end,
> +static bool walk_pmd_range(pud_t *pud, unsigned long start, unsigned lon=
g end,
>                            struct mm_walk *args)
>  {
>         int i;
> +       bool young =3D false;
>         pmd_t *pmd;
>         unsigned long next;
>         unsigned long addr;
> @@ -3790,6 +3817,7 @@ static void walk_pmd_range(pud_t *pud, unsigned lon=
g start, unsigned long end,
>                         continue;
>
>                 walk->mm_stats[MM_NONLEAF_ADDED]++;
> +               young =3D true;
>
>                 /* carry over to the next generation */
>                 update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
> @@ -3799,6 +3827,8 @@ static void walk_pmd_range(pud_t *pud, unsigned lon=
g start, unsigned long end,
>
>         if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &s=
tart, &end))
>                 goto restart;
> +
> +       return young;
>  }
>
>  static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long=
 end,
> @@ -3809,6 +3839,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long=
 start, unsigned long end,
>         unsigned long addr;
>         unsigned long next;
>         struct lru_gen_mm_walk *walk =3D args->private;
> +       struct lru_gen_mm_state *mm_state =3D get_mm_state(walk->lruvec);
>
>         VM_WARN_ON_ONCE(p4d_leaf(*p4d));
>
> @@ -3822,7 +3853,20 @@ static int walk_pud_range(p4d_t *p4d, unsigned lon=
g start, unsigned long end,
>                 if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
>                         continue;
>
> -               walk_pmd_range(&val, addr, next, args);
> +               /*
> +                * Cross-node empty walk suppression. A 1GB PUD subtree w=
hose
> +                * 512 PMDs all failed the PMD-level Bloom filter last ge=
neration
> +                * found no young leaf entries for this lruvec, so skip t=
he whole
> +                * PMD iteration instead of re-checking every entry. This=
 mirrors
> +                * the PMD-level filter one level up and mainly cuts the =
cost of
> +                * walking page tables of processes whose memory lives on=
ly on
> +                * other NUMA nodes.
> +                */

Is this a common case? It seems a bit odd to me that NUMA balancing
doesn't keep the process and its memory on the same NUMA node.
Or is it because users don't pin processes and memory properly?

> +               if (!walk->force_scan && !test_pud_bloom_filter(mm_state,=
 walk->seq, pud + i))
> +                       continue;
> +
> +               if (walk_pmd_range(&val, addr, next, args))
> +                       update_pud_bloom_filter(mm_state, walk->seq + 1, =
pud + i);
>
>                 if (need_resched() || walk->batched >=3D MAX_LRU_BATCH) {
>                         end =3D (addr | ~PUD_MASK) + 1;

Thanks
Barry

