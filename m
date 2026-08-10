Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E95D5C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 06:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3D656B007B; Mon, 10 Aug 2026 02:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE926B008A; Mon, 10 Aug 2026 02:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD0E6B008C; Mon, 10 Aug 2026 02:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74C116B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:39:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EFD680610
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:39:37 +0000 (UTC)
X-FDA: 85084408794.28.89F58E4
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98CAE100009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:39:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dmkIujJr;
	spf=pass (imf05.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786343975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=beTjDQjSO+WsmxqeYJG6yL+QaVmFzIIDf21MXqCQ/Uc=;
	b=sN5Y8JL/z9+pvvtsr8ydZNDBlQK/kBuYZZl12jEIeU97Meia1M9y5uqKC5YkhEXWOmjmYU
	molilNXp4v/mmwsTh7w9EbQX2fXhpPSkwXuG4atWqhjDaoUxttHvh4p91k1dJvO0Lsceo/
	8ZOqahN9hXN8K1NL50Z37mx6iU12BoQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786343975;
	b=QAqZFKqYlziLOeAUbJ3EPoB95PuuB153ji2Gk7HRyqJNx2Y0gPZkJyR3JBKy8hWLHyQL3o
	2mKFWpjtcjTe7AouKTgpakhUDFwCh5G+qnS9AwtN7Mo1AovQpdynpaNnja8f0PO6huH3DQ
	lNX9CyZJ5gnDYMEuiFgxWK751DLomEE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dmkIujJr;
	spf=pass (imf05.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b2a8173142so5838e87.1
        for <linux-mm@kvack.org>; Sun, 09 Aug 2026 23:39:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786343974; cv=none;
        d=google.com; s=arc-20260327;
        b=XvIFAzzV48n63sSFqyM7bWEonm04Dxa3C259P7iP8Ocx8eEsUScWC+RqquLPlxB/Km
         6fYZlL2Q/ja2fTbhUkzNriYb/xuoVfXKi2F5xEZ7ga+5/QK5gN3r+33SL8dLqq0PlHEZ
         lg2r6TY28EDeRUMczVtikTtjjU9CRmsuT5UhdcCZvoBJOv3TSgyFonlTiyckd2kQTR+x
         Wr3+Os9bDsMv1GYtMnpk3ucu1iZ7rwxC4n73WNc0BWJAee4OQo5oU0VPit1KUOHB4T0K
         lDi/3LKJ6gsFU8h0RevnkfHZ00PEb4AK7J3+7HZ52HLqYwZ1gCRG3Qhbf6SD/5FRS4Ud
         9ztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=beTjDQjSO+WsmxqeYJG6yL+QaVmFzIIDf21MXqCQ/Uc=;
        fh=c+AWe0rlKw+BP8+BDFs+Xqq3yVDMGhAUb+rkKy2jRm8=;
        b=HbckVRARcAiZ5nn5HxuAgTvQYfs2OUZxENFblS2v2rnK4f2L44GTZX3mToVeHG4mhu
         wzkO91yoM0wOfWggs/Wmsm3UyC4XbbNwg1oWOVHFK9p91zR0LOEYoBhwK/MWKzQn0JSf
         UVHxqNskdEJ6yJCBnphMBRsTGHqe21fSUQ+hfh00PQHAcMWP+/6c3P9O+BxtI9aW0Cbk
         YPrUzggWcKI3Al5fDLP0zkxRCoLLAyREDC68cXSrhkeOSGZsoEbibnTyTZFFPjZqpQpA
         6cg7bUgiRLaH4cNCJ5OF/XcvCb+64I911yntqTie65AMuohqcY8L2SiNzwb1x6MfhfHe
         CtaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786343974; x=1786948774; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=beTjDQjSO+WsmxqeYJG6yL+QaVmFzIIDf21MXqCQ/Uc=;
        b=dmkIujJrAQHt80Hh4mPpGR16BFEhb8gYd0YZAjkzE9LiHMjNuSot+76lQ2cY1i5TzY
         RauLcvEXF1/afRS7a6iKsUf+Wsfy8ieU5gqf7Ja167D8n7T5KNwOuLN3uBHuWTmMvuDW
         Gti1urO6IxNVCniicZQeiX08s3JSmSJPS0nNpN4t4Iuhdfl8dnOHp5bFZVlPccAWfwfS
         dVKphqJ2aeEk06bmCqo5jF94myzhV7FTVMFZMpAlmIxO3ZfZh+Lx7v3K7rmZ/0i/vCch
         awFiclRiQFaw4BNjX6krP1WLN+WEiA97PdOqTFGfzKgdEYUGnslh0+gpfA415buOxH38
         0HJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786343974; x=1786948774;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=beTjDQjSO+WsmxqeYJG6yL+QaVmFzIIDf21MXqCQ/Uc=;
        b=TS5T8XPG38kYpj9bxnbtnkTkgIbRRXEXt4GBoS6bqNPsELTypLgKuoz33RbpNJhp2G
         P9QTR8/Hpb/ApS8GNV5EsVYUr8RS37fEc0sEdQ12DNgqKnBAiwCVItxUb252lEJJ9mRX
         N3bVlZEJLNmGZwCgeLDQQqlmrMG7HiNn0b5SMhw9LoMzgfPRJJa7XFl37qVNqtKG08dr
         SeHnAo34heay/IiKHW+5ke0sR6QmsBqiVlgGTs44gVyCR7OVxLntx7uLKS2ULEcGazdX
         gyA+2e9Wjxr5fqw5AvXRLmvGmNfeAL3UD32Zrwy6L/jX1Ps6ShZTck0yN4Mx4r92TRyH
         7FFg==
X-Forwarded-Encrypted: i=1; AHgh+RrmUDRGAxW1clzGVedpjerwQLzx56WszO6HAinVArP2oU1l89KD5s1OKmtm9XJuPWpUgnR9pirUwA==@kvack.org
X-Gm-Message-State: AOJu0YwhVxsR3F3RWu8X/HurRmzl+EBaxbjpZGFpJ/wgtPhUf2wFp+qM
	kQfNHmq9oN7FcwxMBkuJPxL+Y5c18A7aD/pBZYAWiSM5rHJo11uarpxkpNvqSHN8IO5IzDswsQZ
	+bt0Kq9AGHpvahG/pOglmx8fDxtRsIf+ObncOJg+b
X-Gm-Gg: AR+sD13NhVoAfBdZ213k4gv1G12wHOirNQ+CfBYfUJoiY6/llobfBV7kKR0d5wyWwdf
	RT6e5bQOUOEEdPMbuO7YECGWel4XR90325p+yqokk9l+F0qftmi487NR+Xjvg/LXzv88TLIET+N
	mpNdwzU2svsg3oSaSrjVHVijoX1qCe4oxe9jaykiYmoGTc77mp/28L/hbXD4/K2ZRngxjsfTt7l
	zXPo/8LVRzs47eZKleZZhwLB+oskrn8hC/8yBlEHqFOWCmMw6U4zBxzLwOQE8MYaSOUAibu9Xd0
	A/rMELXREbaoLlueUFSMjhNMFX7B0qlHnADdjKBdWSz4Mf0U0j6vEPpUlaejii0FCqBkUt5YbSF
	GCePwcjB9YJLg1EABP8KoqINrMtueWzvg
X-Received: by 2002:a05:6512:1295:b0:5b2:a5e9:3aba with SMTP id
 2adb3069b0e04-5b30c3e8046mr177757e87.6.1786343973513; Sun, 09 Aug 2026
 23:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260809043250.2917406-1-souravpanda@google.com>
 <E2FFA328-21B3-4E3D-8CB9-5638B4CB545B@linux.dev> <CANruzcSySUn_gLEh9kxwvatSCn4hizcy6v2BkcMe0Jb=HoUOSw@mail.gmail.com>
 <60440F8D-5EE8-4254-9057-5FAD09B5D1FF@linux.dev>
In-Reply-To: <60440F8D-5EE8-4254-9057-5FAD09B5D1FF@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Sun, 9 Aug 2026 23:39:22 -0700
X-Gm-Features: AUfX_mzV0G9J2-6RqZjaZy-QsI12nKUBfR0xw1cGVt7-LTZShBonbQZL_4PZrbw
Message-ID: <CANruzcQ_1533umf4ym-t5EVm_WX5rrYtCbCqaTdvNr6EgOYR=w@mail.gmail.com>
Subject: Re: [PATCH v5] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, akpm@linux-foundation.org, usama.arif@linux.dev, 
	shakeel.butt@linux.dev, wangkefeng.wang@huawei.com, anshuman.khandual@arm.com, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	hannes@cmpxchg.org, riel@surriel.com, sj@kernel.org, vbabka@suse.cz, 
	mhocko@suse.com, bjackman@google.com, zi.yan@sent.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 98CAE100009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: b5b8d69wourcnec7bzhw95uuj68qcsi7
X-HE-Tag: 1786343975-698345
X-HE-Meta: U2FsdGVkX1/UXQDWK+wTeovm8gUCB2bbhBZrH3MfCB+E2FeHWWkXpu/lGlCHYBam26abx35Loxf7sFYwjHHFHA3qSHBpGEEjlI/Sg4q4v0JbpVJ/UB1C5JP02gs1CLYoRHRvKxAY6tUdDpvAKMDaxE6ca+4ob7HRrcc55j/+f4AMMh63VjtHIxe78fn0HMrugOBy08LD5X3+VBjsOF4gOaNBWC3A3iG5gQmu72OdNmmoiaeAaMyxZFl0t0VLHUebBethWp9NOFwsD5n4xCMviFX2kBwivK3trXk/+C3VPFs+mmIocLBgdSnc7zRU4vRK5KqA1QbkZcOYahjo+J5JCAILJmXK4iyaBMC8zWK7YUMdLEUwW40qz0eLyg+Y0WnyxSEoGMQHSlos5GZE34R84K1odj9ajOIKnOYAzz5vhQb2J/JbnDP7PHxP4psxfQGPoN+1gmWlIDPCkidVH7PLopoSSwPUynTStSU2syKNWC9qLvYXnHxODA1Wwl09j4c7jVEC5OMqAUWTWJ2k8yiKwlvsXDNgNNMciLw97MmV+at3a59nwjfO9AKDJAlwOdic4YkLMKI/QzSCOjm4vkMCz++pYvQH4Y2gpPt3Q2nzF0QyEtBV2zLeMX/HLqeIBq/kxLBiEymj5oCAW+2O4PvbUWHOKIKOb6sc5lEGaVk/oXnLJo3nO0DN9ZZFRrKJxBWQx/6IjH339XP+F25btoSAlNJBbrFM9j9hsMwvzRLA3Q8ge2QWzMbMiActMiIZkYJ1qobocyz01VinL1Wllo3mVPnyd59tUme0Feb4Gt1UP4gS/0pxICuhUUxBrFSJ5VJg22nclgNYvx1kCVNFQTLiCxyl+8G3+ZqRlK3ik/SoWAAxtQTzb2UKZ2xq+Tee8QA6ZLHFujFuCa0xvMu/lusngOXHhPoOMUXu6s6S8Pj0LYGqyJH/km0Qoamj0qRCjMPgXqDWo708gsiV4ZE0mCX
 kRP0bpJU
 j4KiXVOm4YCE4aqum4QCsgnB1Y7qIYaIstgiFyUvu7zvRpORAVVAD7xlMVpbNni12ZvpFyc3M33Wc9Fsye1NOF8oDhBRWfvRKqRSVu1yV6mDVodOLk+LTfKLm/AXHb0cDsusebWziMLiEU7oWOH0rKV/FLOWl5FpciQm8xHkWwxlN3mJjLrAybbBfs18qQPBNoikokKZ/dPWMvT43chdFaJ+W9wpeRmTVCrLp1Q1HrlCvHYm0NMmxiTEKitmR/czTydxbjvzXz2b/jG0+ILPZhP3ySStogFfAAwvH4r3lCDF3qqWYqg13J1P1GFRctZaoQk40Sy90uERCu8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 9, 2026 at 7:24=E2=80=AFPM Muchun Song <muchun.song@linux.dev> =
wrote:
>
>
>
> > On Aug 10, 2026, at 04:11, Sourav Panda <souravpanda@google.com> wrote:
> >
> > On Sat, Aug 8, 2026 at 11:58=E2=80=AFPM Muchun Song <muchun.song@linux.=
dev> wrote:
> >>
> >>
> >>
> >>> On Aug 9, 2026, at 12:32, Sourav Panda <souravpanda@google.com> wrote=
:
> >>>
> >>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> >>> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> >>> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> >>> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> >>> alloc_gigantic_frozen_folio().
> >>>
> >>> Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> >>> allocation on hugetlb_cma[nid] without verifying if nid is included i=
n
> >>> the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensu=
res
> >>> the initial preferred node allocation honors the memory policy / node=
mask.
> >>>
> >>> However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask i=
n
> >>> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> >>> leading to a null pointer dereference kernel panic when nodemask is N=
ULL.
> >>>
> >>> Fix this by checking if nodemask is NULL in
> >>> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> >>> cpuset_current_mems_allowed (safely read using a seqcount retry loop)=
.
> >>> This ensures that the initial node check and fallback loop safely hon=
or
> >>> the task's cpuset without violating cpuset constraints or causing NUL=
L
> >>> pointer dereferences.
> >>>
> >>> From a userspace perspective, this bug allows an unprivileged user to
> >>> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> >>> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> >>> configured on a subset of NUMA nodes.
> >>>
> >>> This can be reproduced by booting a VM with two NUMA nodes, restricti=
ng
> >>> CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
> >>> hugepagesz=3D1G hugepages=3D0), and running a program that allocates =
a
> >>> 1GB hugepage area without reserving, restricts allocation to Node 0
> >>> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> >>>
> >>> void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >>>                  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >>>                  MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >>> unsigned long nodemask =3D 1; /* Node 0 */
> >>> mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >>>       sizeof(nodemask) * 8, 0);
> >>> memset(ptr, 0, 1UL << 30); /* Trigger fault */
> >>>
> >>> This results in a NULL pointer dereference:
> >>>
> >>> BUG: kernel NULL pointer dereference, address: 0000000000000000
> >>> #PF: supervisor read access in kernel mode
> >>> #PF: error_code(0x0000) - not-present page
> >>> Oops: Oops: 0000 [#1] SMP NOPTI
> >>> RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >>> Call Trace:
> >>>  <TASK>
> >>>  only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >>>  alloc_surplus_hugetlb_folio+0x6d/0x100
> >>>  alloc_hugetlb_folio+0x3c5/0x660
> >>>  hugetlb_no_page+0x3d9/0x650
> >>>
> >>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugep=
ages")
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Sourav Panda <souravpanda@google.com>
> >>> ---
> >>> Changes in v5:
> >>> - Replaced defaulting nodemask to &node_states[N_MEMORY] with safely =
reading
> >>> cpuset_current_mems_allowed using a seqcount retry loop, ensuring fal=
lback
> >>> allocations comply with task hardwall cpusets as suggested by Usama A=
rif.
> >>> - v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-soura=
vpanda@google.com/
> >>> - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-sourav=
panda@google.com/
> >>> - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-soura=
vpanda@google.com/
> >>> - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-sourav=
panda@google.com/
> >>>
> >>> mm/hugetlb_cma.c | 15 ++++++++++++++-
> >>> 1 file changed, 14 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> >>> index 39344d6c78d8..3ae9347078e9 100644
> >>> --- a/mm/hugetlb_cma.c
> >>> +++ b/mm/hugetlb_cma.c
> >>> @@ -3,6 +3,7 @@
> >>> #include <linux/mm.h>
> >>> #include <linux/cma.h>
> >>> #include <linux/compiler.h>
> >>> +#include <linux/cpuset.h>
> >>> #include <linux/mm_inline.h>
> >>>
> >>> #include <asm/page.h>
> >>> @@ -30,11 +31,23 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
> >>>      int node;
> >>>      struct folio *folio;
> >>>      struct page *page =3D NULL;
> >>> +     nodemask_t local_node_mask;
> >>>
> >>>      if (!hugetlb_cma_size)
> >>>              return NULL;
> >>>
> >>> -     if (hugetlb_cma[nid])
> >>> +     if (!nodemask) {
> >>> +             unsigned int cpuset_mems_cookie;
> >>> +
> >>> +             do {
> >>> +                     cpuset_mems_cookie =3D read_mems_allowed_begin(=
);
> >>> +                     local_node_mask =3D cpuset_current_mems_allowed=
;
> >>
> >> I think it only makes sense to move cma_alloc_frozen_compound() inside=
 the
> >> loop. Otherwise, during subsequent memory allocations, we could still =
face
> >> unexpected allocation failures.
> >>
> >> Muchun,
> >> Thanks.
> >
> > Hi Muchun!
>
> Hi,
>
> >
> > What do you think of the following diff? This way
> > cma_alloc_frozen_compound is also protected from stale nodemasks.
> >
> >         if (!hugetlb_cma_size)
> >             return NULL;
> >
> >    -    if (hugetlb_cma[nid])
> >    +retry_cpuset:
> >    +    if (!nodemask) {
> >    +        cpuset_mems_cookie =3D read_mems_allowed_begin();
> >    +        local_node_mask =3D cpuset_current_mems_allowed;
> >    +        nmask =3D &local_node_mask;
> >    +    } else {
> >    +        nmask =3D nodemask;
> >    +    }
> >    +
> >    +    if (hugetlb_cma[nid] && node_isset(nid, *nmask))
> >             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], order)=
;
> >
> >         if (!page && !(gfp_mask & __GFP_THISNODE)) {
> >    -        for_each_node_mask(node, *nodemask) {
> >    +        for_each_node_mask(node, *nmask) {
> >                 if (node =3D=3D nid || !hugetlb_cma[node])
> >                     continue;
> >
> >    @@ -48,6 +61,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int
> > order, gfp_t gfp_mask,
> >             }
> >         }
> >
> >    +    if (!page && !nodemask &&
> > unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> >    +        goto retry_cpuset;
> >    +
> >         if (!page)
> >             return NULL;
>
> The overall looks good to me. But can we change it to this here?
>
>         if (!page) {
>                 if (!nodemask &&
>                     unlikely(read_mems_allowed_retry(cpuset_mems_cookie))=
)
>                         goto retry_cpuset;
>                 return NULL;
>         }
>
> That way, we can remove the 'if (!page)' check here.

Sure thing! Thanks! I shall send this tomorrow noon (PST) since I am
OOO starting Thursday.

  @@ -30,15 +31,27 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int
order, gfp_t gfp_mask,
    int node;
    struct folio *folio;
    struct page *page =3D NULL;
  + const nodemask_t *nmask;
  + nodemask_t local_node_mask;
  + unsigned int cpuset_mems_cookie;

    if (!hugetlb_cma_size)
      return NULL;

  - if (hugetlb_cma[nid])
  +retry_cpuset:
  + if (!nodemask) {
  +   cpuset_mems_cookie =3D read_mems_allowed_begin();
  +   local_node_mask =3D cpuset_current_mems_allowed;
  +   nmask =3D &local_node_mask;
  + } else {
  +   nmask =3D nodemask;
  + }
  +
  + if (hugetlb_cma[nid] && node_isset(nid, *nmask))
      page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], order);

    if (!page && !(gfp_mask & __GFP_THISNODE)) {
  -   for_each_node_mask(node, *nodemask) {
  +   for_each_node_mask(node, *nmask) {
        if (node =3D=3D nid || !hugetlb_cma[node])
          continue;

  @@ -48,8 +61,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int
order, gfp_t gfp_mask,
      }
    }

  - if (!page)
  + if (!page) {
  +   if (!nodemask &&
  +       unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
  +     goto retry_cpuset;
      return NULL;
  + }


>
> Muchun,
> Thanks.
>
> >
> > If this looks good to you, I'll send out v6 with this change.
> >
> > With regards,
> > Sourav Panda
> >
> >>
> >>> +             } while (read_mems_allowed_retry(cpuset_mems_cookie));
> >>> +
> >>> +             nodemask =3D &local_node_mask;
> >>> +     }
> >>> +
> >>> +     if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> >>>              page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], ord=
er);
> >>>
> >>>      if (!page && !(gfp_mask & __GFP_THISNODE)) {
> >>> --
> >>> 2.55.0
>
>

