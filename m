Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C04FC87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 05:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1364E8E0005; Thu,  7 Aug 2025 01:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E62D8E0001; Thu,  7 Aug 2025 01:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF67F8E0005; Thu,  7 Aug 2025 01:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA9A78E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:32:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63A3C1607E8
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:32:54 +0000 (UTC)
X-FDA: 83748842268.01.D8D956B
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf04.hostedemail.com (Postfix) with ESMTP id 83F4140007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:32:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lj1Wrf5l;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754544772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpAI00LiEUXb+wTxCkHmar9RLUcAHFBYMy1g2PSSR0w=;
	b=oYK9b9KWxo2wFQYMRy/I2pp3TOvgArB5sJk+PAsj56wR8yqbbbzmGWmW3WZmTt8KkSvUAF
	k1Qokc4+6+Pnlm/f83+fYOut6TqMArukGTd78Mg14B4EdQVCNzp8fELACOfp3pUmSit0Xw
	0XI7bXlvnVsgSnFimPya5phjaJCV4qI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754544772; a=rsa-sha256;
	cv=none;
	b=38arADPpKAAjUMPglx4JVrMqadjZmLMPpHTlKZxqYZtKwoduns2kwok7FQep0WW6dCYdrI
	pNqxWXSzGshBSmg/M1JDsZwJ+0XaMhkO6uSwgoE/PD0om7AfQV5Sp0ItbEajUC41YU3dAJ
	4KFNiax2axfd/ajd37ZQW4RGC9fshPA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lj1Wrf5l;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id CC13AA5579E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB20C4CEF7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754544771;
	bh=rAB/UBmBSFxnXd0nKV8bRIRC+NXmYJqrmY/gqpJtuMo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lj1Wrf5l+enWTJt92Q1f37ftQ6dRrRa/7pz9cNsSfOpR54nNChwjJSgnINjviPBQK
	 cxfld5TJinjB/Tm9qvyqfqEsPcQ4N/3QGYgZ0T4RtEYtKtq+yndJPnApo2uiUrPVza
	 kzZ+1f1c/k/slOvXg/YsoEtEqftXUCeH7rIl5Y7fxZ/j6GNA3LqAO+plYqOvLlgO2p
	 t739YkcQDv+WWMV9ItEuD26oJu2rjg/m02FbN0apS5WFYLQT4chCJMyBQtN6Jnv3VZ
	 QU6LLIG7kjmsjf250GeDS3LxclJ7YNvZvMzskGIKOA8n4l59GHG/73thCogbgHfuoy
	 rSUED+Qb852tA==
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-459e497776cso43895e9.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 22:32:51 -0700 (PDT)
X-Gm-Message-State: AOJu0YxlIqsCroE2Ei1zZdIlmBA3Bp+sHpS+2pzeyRlpeguloN7GzXNA
	2guizFjBZssgZnAUte7mKd9ULfcKXNesXut0QBJhjrK/53tH3CMGdT4AtYS/AElsIEEdNqjk7KK
	LiAlyvMba4vddHa7PR8S2oek/EuHH0dP0k6E+JAEL
X-Google-Smtp-Source: AGHT+IHRY2M2xDkw4ZJWViT3kxgvACrWtMMqxvgefNDPmHZPVLE+Ow533nj6Df/LWU4LDwUk6uK+U/WK5zAooMEDvyA=
X-Received: by 2002:a05:600c:3148:b0:456:4607:b193 with SMTP id
 5b1f17b1804b1-459f0357255mr301155e9.7.1754544770158; Wed, 06 Aug 2025
 22:32:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250806161748.76651-1-ryncsn@gmail.com> <20250806161748.76651-2-ryncsn@gmail.com>
In-Reply-To: <20250806161748.76651-2-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 Aug 2025 22:32:38 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNSvQTxEOiWZRwwB4117713Ks51AvD0gbMhuA7KUhtARA@mail.gmail.com>
X-Gm-Features: Ac12FXyXdS9CEOgVD9cnX_UtpBJ_eBgMrn2QY5iTZyySscX0lUCFjLmmrl_fVCE
Message-ID: <CAF8kJuNSvQTxEOiWZRwwB4117713Ks51AvD0gbMhuA7KUhtARA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm, swap: only scan one cluster in fragment list
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 83F4140007
X-Stat-Signature: zan379mtpmopibzfjorpgbt1phreo1gp
X-Rspam-User: 
X-HE-Tag: 1754544772-624521
X-HE-Meta: U2FsdGVkX1+53rtK+nWLXFip3HQ3+BnkloN1TcB8aD7G8Grn5OTeFLbr8JGt6x05KREqJqPnu/+vzdq7zU7Vb1WijnFl1IZk2yDVllV2En0EbtQ1VtWFYytKJwSN2xQBejdJi51/F44vAXocsljtCiwu8BPlIAA0ucS1gqjkrsifyzl8P2oGKuZsBIz5vfmc29kElHZjvtbBwB/EMWp8q90Ext+lz0InRwQWLU07m8rvVnR36rtWYdeKjW2yXhQRX8KbURBDLUUN7oa4X2q0Bu/n9K8z6fQB20+w3b6CMlGOXlvjcv5as4gf8uq5aRdX9fhMXvAzkmP7Y9NyL2dhZGrOKgWGoNNAEpgTpOEgp6fAfuW8ToKuBPHwt8RhRm9Ijj0ckLNb/gmOV31Lgu4WeK+//O9XT8NN2TUDLJjL2iALtJTha3SnKevted1JVXQW7GDQeH3+1uadIbqsG/dkWkXmqoC4eqT87ZSUec/JfduuZ9CSg9+Tb8FLtT1HAeR92JQm11B1pbyDr0fn6YLurMfqewgWz8zibKITGTp9LxGMyC5pOg7zglHnrpPAQPS3QjSnjV8VBiqNuetxaeyxtbF8jL7l7qnjgwg2zLigFl2DBJSFjyL98FjI+HbvBgoZ2MMu8pmGVuam+KUvyNH/mCxEgZ5YtroTYdoUM3FICzqsQ7mQF14/9eWeSKm7rzApPcyESUstI/AeQPAXuDkcwr7Ro3uvNsQPPWcVEi8aW3ZED+wVOjMuvXBiwbRtuLxV/tlDMQwm5uXEc7LHAXMKzjzv3k1mj5pX4eaSEMXvhToboFJw8j8WQsjBJgA6iS2zZ3JH+qTj4s1Q9Q6vv48w9zPefzSsECQC1b+bI7fBa5I0fjy1qWoxUGSBCr+D+40t/Tz4eqeq5ljufH85tperqfvL4bXnEtaD5SFEUT75I6UgT6/zICYBMO9sL1oP3R78iUdFoZeuoeII1BcSF2X
 1AJI39nu
 K+B8eFzscUcFxa2EVcrZkdRu25YgZ9Pkl8e+WGR/3OH9DCEqjuTLD3oocUYr9F5OMwOJwioylneJYRDrljXmfNZe+teZvRvybh5U53EhU0OIWoiuLS40HH+IfPpqK4B3jG38MGECp0BDnkSJ5lNEP7aCSMUHkmB014jqk5rWF3zc+sXzkW7RaniLtoYvQh78iPC4rQDPuBCWnLIVLSGKcl13Dt8wmtApgkklvauv21KPSygNgDR1Xs2ksKAyc+b8SNWvN+uFCKodRbOnhdPRQnqJgv6LsnlUsOcNm0jIqz57jJDYut5tUGOxrLIcyF/ROWsyRuvZPjCLfuEskTdyzaO8VFizMxpwhnSE/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Wed, Aug 6, 2025 at 9:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> Fragment clusters were mostly failing high order allocation already.
> The reason we scan it through now is that a swap slot may get freed
> without releasing the swap cache, so a swap map entry will end up in
> HAS_CACHE only status, and the cluster won't be moved back to non-full
> or free cluster list. This may cause a higher allocation failure rate.
>
> Usually only !SWP_SYNCHRONOUS_IO devices may have a large number of
> slots stuck in HAS_CACHE only status. Because when a !SWP_SYNCHRONOUS_IO
> device's usage is low (!vm_swap_full()), it will try to lazy free
> the swap cache.
>
> But this fragment list scan out is a bit overkill. Fragmentation
> is only an issue for the allocator when the device is getting full,
> and by that time, swap will be releasing the swap cache aggressively
> already. Only scan one fragment cluster at a time is good enough to

Only *scanning* one fragment cluster...

> reclaim already pinned slots, and move the cluster back to nonfull.
>
> And besides, only high order allocation requires iterating over the
> list, order 0 allocation will succeed on the first attempt. And
> high order allocation failure isn't a serious problem.
>
> So the iteration of fragment clusters is trivial, but it will slow down
> large allocation by a lot when the fragment cluster list is long.
> So it's better to drop this fragment cluster iteration design.

One side note is that we make some trade off here. We trade lower
success rates >4K swap entry allocation on fragment lists with overall
faster swap entry time, because we stop searching the fragment list
early.

I notice this patch will suffer from fragment list trap behavior. The
clusters go from free -> non full -> fragment -> free again (ignore
the full list for now). Only when the cluster is completely free
again, it will reset the cluster back to the free list. Otherwise
given random swap entry access pattern, and long life cycle of some
swap entry.  Free clusters are very hard to come by. Once it is in the
fragment list, it is not easy to move back to a non full list. The
cluster will eventually gravitate towards the fragment list and trap
there. This kind of problem is not easy to expose by the kernel
compile work load, which is a batch job in nature, with very few long
running processes. If most of the clusters in the swapfile are in the
fragment list. This will cause us to give up too early and force the
more expensive swap cache reclaim path more often.

To counter that fragmentation list trap effect,  one idea is that not
all clusters in the fragment list are equal. If we make the fragment
list into a few buckets by how empty it is. e.g. >50% vs <50%. I
expect the <50% free cluster has a very low success rate for order >0
allocation. Given an order "o", we can have a math formula P(o, count)
of the success rate if slots are even randomly distributed with count
slots used. The >50% free cluster will likely have a much higher
success rate.  We should set a different search termination threshold
for different bucket classes. That way we can give the cluster a
chance to move up or down the bucket class. We should try the high
free bucket before the low free bucket.

That can combat the fragmentation list trap behavior.

BTW, we can have some simple bucket statistics to see what is the
distribution of fragmented clusters. The bucket class threshold can
dynamically adjust using the overall fullness of the swapfile.

Chris

>
> Test on a 48c96t system, build linux kernel using 10G ZRAM, make -j48,
> defconfig with 768M cgroup memory limit, on top of tmpfs, 4K folio
> only:
>
> Before: sys time: 4432.56s
> After:  sys time: 4430.18s
>
> Change to make -j96, 2G memory limit, 64kB mTHP enabled, and 10G ZRAM:
>
> Before: sys time: 11609.69s  64kB/swpout: 1787051  64kB/swpout_fallback: =
20917
> After:  sys time: 5572.85s   64kB/swpout: 1797612  64kB/swpout_fallback: =
19254
>
> Change to 8G ZRAM:
>
> Before: sys time: 21524.35s  64kB/swpout: 1687142  64kB/swpout_fallback: =
128496
> After:  sys time: 6278.45s   64kB/swpout: 1679127  64kB/swpout_fallback: =
130942
>
> Change to use 10G brd device with SWP_SYNCHRONOUS_IO flag removed:
>
> Before: sys time: 7393.50s  64kB/swpout:1788246  swpout_fallback: 0
> After:  sys time: 7399.88s  64kB/swpout:1784257  swpout_fallback: 0
>
> Change to use 8G brd device with SWP_SYNCHRONOUS_IO flag removed:
>
> Before: sys time: 26292.26s 64kB/swpout:1645236  swpout_fallback: 138945
> After:  sys time: 9463.16s  64kB/swpout:1581376  swpout_fallback: 259979
>
> The performance is a lot better for large folios, and the large order
> allocation failure rate is only very slightly higher or unchanged even
> for !SWP_SYNCHRONOUS_IO devices high pressure.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> ---
>  mm/swapfile.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b4f3cc712580..1f1110e37f68 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -926,32 +926,25 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>                 swap_reclaim_full_clusters(si, false);
>
>         if (order < PMD_ORDER) {
> -               unsigned int frags =3D 0, frags_existing;
> -
>                 while ((ci =3D isolate_lock_cluster(si, &si->nonfull_clus=
ters[order]))) {
>                         found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
>                                                         order, usage);
>                         if (found)
>                                 goto done;
> -                       /* Clusters failed to allocate are moved to frag_=
clusters */
> -                       frags++;
>                 }
>
> -               frags_existing =3D atomic_long_read(&si->frag_cluster_nr[=
order]);
> -               while (frags < frags_existing &&
> -                      (ci =3D isolate_lock_cluster(si, &si->frag_cluster=
s[order]))) {
> -                       atomic_long_dec(&si->frag_cluster_nr[order]);
> -                       /*
> -                        * Rotate the frag list to iterate, they were all
> -                        * failing high order allocation or moved here du=
e to
> -                        * per-CPU usage, but they could contain newly re=
leased
> -                        * reclaimable (eg. lazy-freed swap cache) slots.
> -                        */
> +               /*
> +                * Scan only one fragment cluster is good enough. Order 0
> +                * allocation will surely success, and large allocation
> +                * failure is not critical. Scanning one cluster still
> +                * keeps the list rotated and reclaimed (for HAS_CACHE).
> +                */
> +               ci =3D isolate_lock_cluster(si, &si->frag_clusters[order]=
);
> +               if (ci) {
>                         found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
>                                                         order, usage);
>                         if (found)
>                                 goto done;
> -                       frags++;
>                 }
>         }
>
> --
> 2.50.1
>
>

