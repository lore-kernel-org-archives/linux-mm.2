Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19177EDF04F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 07:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552526B0005; Thu, 12 Feb 2026 02:38:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529986B008A; Thu, 12 Feb 2026 02:38:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428C76B008C; Thu, 12 Feb 2026 02:38:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED106B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:38:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA8BB1B3EBE
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:38:10 +0000 (UTC)
X-FDA: 84435001140.30.6EE7F66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B8F2D140003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:38:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o7EXiefP;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770881888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uclRVhjqat8H6y83XFXQj0IuAi88GsSzuANZKLG9xIM=;
	b=ZVocb+j2hUWbMTObYPRliwJLcq1MZjsjkGQTWYOJLdl52c6JS6fmIjC0uqfy92A8StpNxG
	zb/oABsoX1WiQl0gQVvDqkot8dn4PBvnusa5LwlTgYmzqJ6s4hXckR7Kp/NMdfuIIPfski
	h8HApSE0Nw2wXMsCGYKjlJw+twdONVo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o7EXiefP;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770881888; a=rsa-sha256;
	cv=none;
	b=ZSESSFy6zIoMWj7tSJYIZUEcYRJ7qmA4/n1As2pBR1n4BI0cGsCtpkQCHHF9EtrepnjuV+
	TUSKA9ae+4suDWAEU6rO5LiU1mbKunr//tgKdfuEFxRwAFvdKhvn4VcKoQ9c+H8HRXz2F0
	2G3aqSi7fOMbsJfI2Y1lhlZEH6JegXQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF3B54036E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D64DC19424
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770881887;
	bh=O2njR3LjP3NL1X2J9vS0Mi8MIZ72B14sKb7SF6X7taw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=o7EXiefPeCQUeP/R+E8cd/s7CFsmxs0FzVWYIrOncOdu+AKi/TVBOln8xyVqnSgVi
	 yU3rekmI+BNC8F2Q5ueFmwVS/hb19X3f7DDZc+K2YB6z2HyOLJjZ0fohvMVppg4vVp
	 hTGAU9i5GnoYuUkEFGyTtS6wTnqXxN6j9BI0fDgvdfAnK28cV0wZNMmSSLmdVkGYPs
	 6/X+hvOmUZyWtkGTjrw4xILZ0BSPOpOfGiq+D2RrjaufGZYu7NT7x+YroQpTo1h7Uj
	 MYifmkGFdDLgUA0vb92nRvWUQ+Ln/DR2kBd1pvfCiz9VAcmX907zOaYv/1+IRBMVkO
	 zYooB/LCflIKw==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-79273a294edso25838107b3.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:38:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWuRV3/4mROUWfSpE1wXpuP/PKoqkvzzStmJSym8jPV7fFmkwCFInkdkXDwG+9+5dDUhBOtIBkuQg==@kvack.org
X-Gm-Message-State: AOJu0YyZSkqlWsdGlMkG89yR9L24vuw8LlO1V/73cANLad+Nz+3P4VH4
	qoGpKRynGw2Lcie0GXJJu9U22/AO2zean5TPLWgYSBWNV64Pj3MJ4ICnC901dKiopAI1sUBVsJf
	7ugfLkWr6LTBINIewCMl5B3qwG23uf75b50aD+CPvPw==
X-Received: by 2002:a05:690c:83:b0:796:3d5f:a2cc with SMTP id
 00721157ae682-797931ef974mr9009397b3.68.1770881886764; Wed, 11 Feb 2026
 23:38:06 -0800 (PST)
MIME-Version: 1.0
References: <20260126065242.1221862-1-youngjun.park@lge.com> <20260126065242.1221862-5-youngjun.park@lge.com>
In-Reply-To: <20260126065242.1221862-5-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 11 Feb 2026 23:37:55 -0800
X-Gmail-Original-Message-ID: <CACePvbXeUx9_dyrSFoz57RnNccoMwiF5u70v6WqHJNFGEZrCPw@mail.gmail.com>
X-Gm-Features: AZwV_QjKF7DQZOWnSfFgHQ3A0KLRp7yx86ZyDNPBWBWIiLHy6kEJ-ydcJQjm__0
Message-ID: <CACePvbXeUx9_dyrSFoz57RnNccoMwiF5u70v6WqHJNFGEZrCPw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 v2 4/5] mm, swap: change back to use each swap
 device's percpu cluster
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, 
	austin.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B8F2D140003
X-Rspamd-Server: rspam07
X-Stat-Signature: sft36dz5qf876os1uuthaw9q8yj3fp7g
X-HE-Tag: 1770881888-640437
X-HE-Meta: U2FsdGVkX1/2yFiQlgvTjbea+rc1N1vfUsMifwE3SAjihDozrobIOH30QxhxF//SlATXIagsWSf7jLWnE0G5vJ32O/T53yHDrS4cwT+KgB/5YGl8Z6KQnxsu2sL9bQYHKKSqz1CxtIh/1G3gnRJ1UE7Hi7sMDRI3ftikuqFNX4HPZbGEZgd6fkC0PbX4Ugymhtihya3yr266xE9oEZ7JRwduhpp42OSxmF4Z+Nt8oIETNrBiFalTChhD2dakAAJoU+dSerFen+58HYLbsElxnetMjjLtDPcdmP0MU40qjzkV/dzQha2yPe31R8YsalWRPxxvp9oswThShWqWYrDmXiU99SLWrp3R6ehZjQXUDwEWEPVxSWPHocBs0FHEAiyZKllhdrUNS2FMUYMnUh/BtKvtxXdnwUNBryvLta+Nyd1jWUVKJHIsoOo4UOcivEW6Ozon2vPUSBJDbtpKbEF8OGih0UGAiLkT1P+T594/VwH2ZPJA6QoMPkFsBaBOa/IkKWdlUdyjCTYjOmTEixvIdBtfITOh1d2Gb1orzlmUmp2qom9maIbBxWPYjbmA9TqBGShz2buopiwStK3sWQ2JOPfssym9ocKcJCJLT1AY+fTdslu4+4DEmIOv/FL4oCrfeoa3ORu9FU1pmPwgvVuRRZg+evk+H68WwZpPWIViGJkKFU8TDy+BoTdUAcBjnMadNWwd48LyNF5rD2GDN0hc/J81PdIJ2jxgKtLqU9yB8GVBBMH2WXSutyw4WriKop6TpakWz0eqaErd/EtjrojgoY2qxcBjPDOB/LI7EmH6ekLwNtCMpX0MRXwRKJ17d8/JbWi5CuzAH8JmnGZBoVKAQ+IBtcAOVpIj+ARSGI5MDHIPkq55STVz69lxKTB6q6iL9Wp+stG2oAhqI2CBafFqhiBAHQm8kt5AsfSGuI2G6I12zU3P/mwTV0DIP3N4yP7UEb2Lvm1q/6JZS4430Bm
 oTpt+Yck
 GFj/uXGlOgEGnIPYMDDyW5Ez0P08PIS01zt7Q/pSUFvn1p2ZfJQG400VGb9SdKb3AjjydCoycl0xwoa3f4J0pkoNwqVl1fKoEM5M7B9qZ6haPLRteY6Tc2sL6sWyT35+oV+guj2jI6E6Tp/ss2fZTdpLxMbGLHFkNkflpSQRLgSnJJevexPxgPDPpSHfU7gJ1cPt/xb0xZqaCZANf2ttY+tWWT14Lg0SdYG0dxHhToFEtS3K69q2S30wpb9dw2lBdHIdnMiIK34whZcSEpN954lOQH0xCOcedRmDCU2atuJLvaW4rq7wXKJqxajNzNfrIMpcbn24hVFDb2P6gfiJihzQTsz1Xks49aM8IluLETFZrY+o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 25, 2026 at 11:08=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> This reverts commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
> allocation fast path").
>
> Because in the newly introduced swap tiers, the global percpu cluster
> will cause two issues:
> 1) it will cause caching oscillation in the same order of different si
>    if two different memcg can only be allowed to access different si and
>    both of them are swapping out.
> 2) It can cause priority inversion on swap devices. Imagine a case where
>    there are two memcg, say memcg1 and memcg2. Memcg1 can access si A, B
>    and A is higher priority device. While memcg2 can only access si B.
>    Then memcg 2 could write the global percpu cluster with si B, then
>    memcg1 take si B in fast path even though si A is not exhausted.

One idea is that, instead of using percpu per swap device.
You can make the global percpu cluster per tier. Because the max tier
number is smaller than the max number of swap devices. That is likely
a win.

Chris

> Hence in order to support swap tier, revert commit to use
> each swap device's percpu cluster.
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Co-developed-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  include/linux/swap.h |  17 ++++--
>  mm/swapfile.c        | 142 ++++++++++++++-----------------------------
>  2 files changed, 57 insertions(+), 102 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 1e68c220a0e7..6921e22b14d3 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -247,11 +247,18 @@ enum {
>  #define SWAP_NR_ORDERS         1
>  #endif
>
> -/*
> - * We keep using same cluster for rotational device so IO will be sequen=
tial.
> - * The purpose is to optimize SWAP throughput on these device.
> - */
> + /*
> +  * We assign a cluster to each CPU, so each CPU can allocate swap entry=
 from
> +  * its own cluster and swapout sequentially. The purpose is to optimize=
 swapout
> +  * throughput.
> +  */
> +struct percpu_cluster {
> +       local_lock_t lock; /* Protect the percpu_cluster above */
> +       unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offs=
et */
> +};
> +
>  struct swap_sequential_cluster {
> +       spinlock_t lock; /* Serialize usage of global cluster */
>         unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offs=
et */
>  };
>
> @@ -277,8 +284,8 @@ struct swap_info_struct {
>                                         /* list of cluster that are fragm=
ented or contented */
>         unsigned int pages;             /* total of usable pages of swap =
*/
>         atomic_long_t inuse_pages;      /* number of those currently in u=
se */
> +       struct percpu_cluster   __percpu *percpu_cluster; /* per cpu's sw=
ap location */
>         struct swap_sequential_cluster *global_cluster; /* Use one global=
 cluster for rotating device */
> -       spinlock_t global_cluster_lock; /* Serialize usage of global clus=
ter */
>         struct rb_root swap_extent_root;/* root of the swap extent rbtree=
 */
>         struct block_device *bdev;      /* swap device or bdev of swap fi=
le */
>         struct file *swap_file;         /* seldom referenced */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index dd97e850ea2c..5e3b87799440 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -118,18 +118,6 @@ static atomic_t proc_poll_event =3D ATOMIC_INIT(0);
>
>  atomic_t nr_rotate_swap =3D ATOMIC_INIT(0);
>
> -struct percpu_swap_cluster {
> -       struct swap_info_struct *si[SWAP_NR_ORDERS];
> -       unsigned long offset[SWAP_NR_ORDERS];
> -       local_lock_t lock;
> -};
> -
> -static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) =
=3D {
> -       .si =3D { NULL },
> -       .offset =3D { SWAP_ENTRY_INVALID },
> -       .lock =3D INIT_LOCAL_LOCK(),
> -};
> -
>  /* May return NULL on invalid type, caller must check for NULL return */
>  static struct swap_info_struct *swap_type_to_info(int type)
>  {
> @@ -477,7 +465,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>          * Swap allocator uses percpu clusters and holds the local lock.
>          */
>         lockdep_assert_held(&ci->lock);
> -       lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +       lockdep_assert_held(this_cpu_ptr(&si->percpu_cluster->lock));
>
>         /* The cluster must be free and was just isolated from the free l=
ist. */
>         VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> @@ -495,8 +483,8 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>          */
>         spin_unlock(&ci->lock);
>         if (!(si->flags & SWP_SOLIDSTATE))
> -               spin_unlock(&si->global_cluster_lock);
> -       local_unlock(&percpu_swap_cluster.lock);
> +               spin_unlock(&si->global_cluster->lock);
> +       local_unlock(&si->percpu_cluster->lock);
>
>         table =3D swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KE=
RNEL);
>
> @@ -508,9 +496,9 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>          * could happen with ignoring the percpu cluster is fragmentation=
,
>          * which is acceptable since this fallback and race is rare.
>          */
> -       local_lock(&percpu_swap_cluster.lock);
> +       local_lock(&si->percpu_cluster->lock);
>         if (!(si->flags & SWP_SOLIDSTATE))
> -               spin_lock(&si->global_cluster_lock);
> +               spin_lock(&si->global_cluster->lock);
>         spin_lock(&ci->lock);
>
>         /* Nothing except this helper should touch a dangling empty clust=
er. */
> @@ -622,7 +610,7 @@ static bool swap_do_scheduled_discard(struct swap_inf=
o_struct *si)
>                 ci =3D list_first_entry(&si->discard_clusters, struct swa=
p_cluster_info, list);
>                 /*
>                  * Delete the cluster from list to prepare for discard, b=
ut keep
> -                * the CLUSTER_FLAG_DISCARD flag, percpu_swap_cluster cou=
ld be
> +                * the CLUSTER_FLAG_DISCARD flag, there could be percpu_c=
luster
>                  * pointing to it, or ran into by relocate_cluster.
>                  */
>                 list_del(&ci->list);
> @@ -953,12 +941,11 @@ static unsigned int alloc_swap_scan_cluster(struct =
swap_info_struct *si,
>  out:
>         relocate_cluster(si, ci);
>         swap_cluster_unlock(ci);
> -       if (si->flags & SWP_SOLIDSTATE) {
> -               this_cpu_write(percpu_swap_cluster.offset[order], next);
> -               this_cpu_write(percpu_swap_cluster.si[order], si);
> -       } else {
> +       if (si->flags & SWP_SOLIDSTATE)
> +               this_cpu_write(si->percpu_cluster->next[order], next);
> +       else
>                 si->global_cluster->next[order] =3D next;
> -       }
> +
>         return found;
>  }
>
> @@ -1052,13 +1039,17 @@ static unsigned long cluster_alloc_swap_entry(str=
uct swap_info_struct *si,
>         if (order && !(si->flags & SWP_BLKDEV))
>                 return 0;
>
> -       if (!(si->flags & SWP_SOLIDSTATE)) {
> +       if (si->flags & SWP_SOLIDSTATE) {
> +               /* Fast path using per CPU cluster */
> +               local_lock(&si->percpu_cluster->lock);
> +               offset =3D __this_cpu_read(si->percpu_cluster->next[order=
]);
> +       } else {
>                 /* Serialize HDD SWAP allocation for each device. */
> -               spin_lock(&si->global_cluster_lock);
> +               spin_lock(&si->global_cluster->lock);
>                 offset =3D si->global_cluster->next[order];
> -               if (offset =3D=3D SWAP_ENTRY_INVALID)
> -                       goto new_cluster;
> +       }
>
> +       if (offset !=3D SWAP_ENTRY_INVALID) {
>                 ci =3D swap_cluster_lock(si, offset);
>                 /* Cluster could have been used by another order */
>                 if (cluster_is_usable(ci, order)) {
> @@ -1072,7 +1063,6 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si,
>                         goto done;
>         }
>
> -new_cluster:
>         /*
>          * If the device need discard, prefer new cluster over nonfull
>          * to spread out the writes.
> @@ -1129,8 +1119,10 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>                         goto done;
>         }
>  done:
> -       if (!(si->flags & SWP_SOLIDSTATE))
> -               spin_unlock(&si->global_cluster_lock);
> +       if (si->flags & SWP_SOLIDSTATE)
> +               local_unlock(&si->percpu_cluster->lock);
> +       else
> +               spin_unlock(&si->global_cluster->lock);
>
>         return found;
>  }
> @@ -1311,41 +1303,8 @@ static bool get_swap_device_info(struct swap_info_=
struct *si)
>         return true;
>  }
>
> -/*
> - * Fast path try to get swap entries with specified order from current
> - * CPU's swap entry pool (a cluster).
> - */
> -static bool swap_alloc_fast(struct folio *folio)
> -{
> -       unsigned int order =3D folio_order(folio);
> -       struct swap_cluster_info *ci;
> -       struct swap_info_struct *si;
> -       unsigned int offset;
> -
> -       /*
> -        * Once allocated, swap_info_struct will never be completely free=
d,
> -        * so checking it's liveness by get_swap_device_info is enough.
> -        */
> -       si =3D this_cpu_read(percpu_swap_cluster.si[order]);
> -       offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> -       if (!si || !offset || !get_swap_device_info(si))
> -               return false;
> -
> -       ci =3D swap_cluster_lock(si, offset);
> -       if (cluster_is_usable(ci, order)) {
> -               if (cluster_is_empty(ci))
> -                       offset =3D cluster_offset(si, ci);
> -               alloc_swap_scan_cluster(si, ci, folio, offset);
> -       } else {
> -               swap_cluster_unlock(ci);
> -       }
> -
> -       put_swap_device(si);
> -       return folio_test_swapcache(folio);
> -}
> -
>  /* Rotate the device and switch to a new cluster */
> -static void swap_alloc_slow(struct folio *folio)
> +static void swap_alloc_entry(struct folio *folio)
>  {
>         struct swap_info_struct *si, *next;
>         int mask =3D folio_memcg(folio) ?
> @@ -1363,6 +1322,7 @@ static void swap_alloc_slow(struct folio *folio)
>                 if (get_swap_device_info(si)) {
>                         cluster_alloc_swap_entry(si, folio);
>                         put_swap_device(si);
> +
>                         if (folio_test_swapcache(folio))
>                                 return;
>                         if (folio_test_large(folio))
> @@ -1522,11 +1482,7 @@ int folio_alloc_swap(struct folio *folio)
>         }
>
>  again:
> -       local_lock(&percpu_swap_cluster.lock);
> -       if (!swap_alloc_fast(folio))
> -               swap_alloc_slow(folio);
> -       local_unlock(&percpu_swap_cluster.lock);
> -
> +       swap_alloc_entry(folio);
>         if (!order && unlikely(!folio_test_swapcache(folio))) {
>                 if (swap_sync_discard())
>                         goto again;
> @@ -1945,9 +1901,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
>                          * Grab the local lock to be compliant
>                          * with swap table allocation.
>                          */
> -                       local_lock(&percpu_swap_cluster.lock);
>                         offset =3D cluster_alloc_swap_entry(si, NULL);
> -                       local_unlock(&percpu_swap_cluster.lock);
>                         if (offset)
>                                 entry =3D swp_entry(si->type, offset);
>                 }
> @@ -2751,28 +2705,6 @@ static void free_cluster_info(struct swap_cluster_=
info *cluster_info,
>         kvfree(cluster_info);
>  }
>
> -/*
> - * Called after swap device's reference count is dead, so
> - * neither scan nor allocation will use it.
> - */
> -static void flush_percpu_swap_cluster(struct swap_info_struct *si)
> -{
> -       int cpu, i;
> -       struct swap_info_struct **pcp_si;
> -
> -       for_each_possible_cpu(cpu) {
> -               pcp_si =3D per_cpu_ptr(percpu_swap_cluster.si, cpu);
> -               /*
> -                * Invalidate the percpu swap cluster cache, si->users
> -                * is dead, so no new user will point to it, just flush
> -                * any existing user.
> -                */
> -               for (i =3D 0; i < SWAP_NR_ORDERS; i++)
> -                       cmpxchg(&pcp_si[i], si, NULL);
> -       }
> -}
> -
> -
>  SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  {
>         struct swap_info_struct *p =3D NULL;
> @@ -2856,7 +2788,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>
>         flush_work(&p->discard_work);
>         flush_work(&p->reclaim_work);
> -       flush_percpu_swap_cluster(p);
>
>         destroy_swap_extents(p);
>         if (p->flags & SWP_CONTINUED)
> @@ -2885,6 +2816,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         arch_swap_invalidate_area(p->type);
>         zswap_swapoff(p->type);
>         mutex_unlock(&swapon_mutex);
> +       free_percpu(p->percpu_cluster);
> +       p->percpu_cluster =3D NULL;
>         kfree(p->global_cluster);
>         p->global_cluster =3D NULL;
>         vfree(swap_map);
> @@ -3268,7 +3201,7 @@ static struct swap_cluster_info *setup_clusters(str=
uct swap_info_struct *si,
>  {
>         unsigned long nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLU=
STER);
>         struct swap_cluster_info *cluster_info;
> -       int err =3D -ENOMEM;
> +       int cpu, err =3D -ENOMEM;
>         unsigned long i;
>
>         cluster_info =3D kvcalloc(nr_clusters, sizeof(*cluster_info), GFP=
_KERNEL);
> @@ -3278,14 +3211,27 @@ static struct swap_cluster_info *setup_clusters(s=
truct swap_info_struct *si,
>         for (i =3D 0; i < nr_clusters; i++)
>                 spin_lock_init(&cluster_info[i].lock);
>
> -       if (!(si->flags & SWP_SOLIDSTATE)) {
> +       if (si->flags & SWP_SOLIDSTATE) {
> +               si->percpu_cluster =3D alloc_percpu(struct percpu_cluster=
);
> +               if (!si->percpu_cluster)
> +                       goto err;
> +
> +               for_each_possible_cpu(cpu) {
> +                       struct percpu_cluster *cluster;
> +
> +                       cluster =3D per_cpu_ptr(si->percpu_cluster, cpu);
> +                       for (i =3D 0; i < SWAP_NR_ORDERS; i++)
> +                               cluster->next[i] =3D SWAP_ENTRY_INVALID;
> +                       local_lock_init(&cluster->lock);
> +               }
> +       } else {
>                 si->global_cluster =3D kmalloc(sizeof(*si->global_cluster=
),
>                                      GFP_KERNEL);
>                 if (!si->global_cluster)
>                         goto err;
>                 for (i =3D 0; i < SWAP_NR_ORDERS; i++)
>                         si->global_cluster->next[i] =3D SWAP_ENTRY_INVALI=
D;
> -               spin_lock_init(&si->global_cluster_lock);
> +               spin_lock_init(&si->global_cluster->lock);
>         }
>
>         /*
> @@ -3566,6 +3512,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>  bad_swap_unlock_inode:
>         inode_unlock(inode);
>  bad_swap:
> +       free_percpu(si->percpu_cluster);
> +       si->percpu_cluster =3D NULL;
>         kfree(si->global_cluster);
>         si->global_cluster =3D NULL;
>         inode =3D NULL;
> --
> 2.34.1
>
>

