Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8EA2CA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 02:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04ECF6B002C; Fri, 29 Aug 2025 22:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026C66B002D; Fri, 29 Aug 2025 22:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FBA6B002F; Fri, 29 Aug 2025 22:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1CDF6B002C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:31:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68A5213ACA0
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:31:59 +0000 (UTC)
X-FDA: 83831848758.15.C457F35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7A6334000F
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:31:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CGCM3cYk;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756521117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1/VpdDcOAPpInsjHYvOwnXtV1w00SROAiXWFFYhCfo=;
	b=OIak64ip42VEYN+/uVa+60568c8Kj/lgUc1iCIjf04UhiWAAqoElKeRZnj6Nqc1ZcbqsZn
	WPmDJbLJi+EU+ZwRkb769VSZL60K/U+xqMPYip1IAgfce6qzqh9YXYFY2iPXYM6wNbbDZV
	06SlCWVHuLjWVB+Wu3cuYl50GoDPsa0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CGCM3cYk;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756521117; a=rsa-sha256;
	cv=none;
	b=F/d4ilDLcNZ3O5x555BLB5cvbcU2IyaQJR62qaU2Rll95z+lkISz/SXN+NiD+NWcBKHi+f
	SMcooXFKnj3788FBoC0paavsW2UN+A2fGxnM7OzSmVBPNfwl3O8okQHDiceZK41EsKZ8kO
	Ek00tQjPrE/Uwv0vOvZ842fTtpXyRnk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDA996014D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F94EC4CEF0
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756521116;
	bh=Qbk3ufjm+mHQmXJE4KXXr1lVhVvMiDBMpPdSh5VLrgE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CGCM3cYkEaWqbHX4Ih7GQF6EKLLWUOUNZsMLkgykPVScEJJU6zRE+uRlUHc0fnp3E
	 16o7U63nIOFsGQ8OBXw7y8PxM7FS8SqNbQ+WqBznoYfBnRSaMvk1gV5rw7O7jD3HMp
	 g2Xc7aDC6xtmdCkZEuySuUQBmwqOYl5+J6jAl/alN30hNanLkdiaylBPc0unhIAIT9
	 t40BV2jjzJcvS7XTXK3s5vyof8wpC1AQ1rMYb/607l0HZ4gVMABFqw64kjV0WcgAP0
	 EyHFeq56CGoOScPy+1jYA31Y/IvX5NAwRFJzZi+yMC56TBoaee4FvFDKAch0ETYs1o
	 1jHT7Fb0NGX1w==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-72199d5a30aso16416567b3.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:31:56 -0700 (PDT)
X-Gm-Message-State: AOJu0YzYBqli6f81f7w2r9uruI/M3lCae1BayuREd7UKVsLSOn2tkhQh
	gYDqVqvJiUWrwcpuKH5yHSLQrA1XiVo5FYazq0Gxp40phSln3nXMrSQP8k/G1JOUxtpdqNOcbhn
	yDTOzctLj1Kx0ARK6Ee0YnoJn4yr2wXzOz+dg9cHJfg==
X-Google-Smtp-Source: AGHT+IEPrDj81p2PxHJ0miG89ZZNb5JEtiOuCeWYt4DcTwA5imwj2wgvHVk0Fx33+4iiguqJQJb8ANwvjE1eQIUlTgU=
X-Received: by 2002:a05:690c:6282:b0:71c:4152:82f9 with SMTP id
 00721157ae682-7227635cd3emr7470277b3.8.1756521115724; Fri, 29 Aug 2025
 19:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-4-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-4-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 19:31:44 -0700
X-Gmail-Original-Message-ID: <CACePvbXpgZvESMm6RxZZ7b5=ju0neqxnFdjQXCCmDypfnp56DA@mail.gmail.com>
X-Gm-Features: Ac12FXwd-OdLiP0V-2CboGBgm60Mb7Ehp8cllLDWLCYlwZQ6uzyse6KW-LWZXxY
Message-ID: <CACePvbXpgZvESMm6RxZZ7b5=ju0neqxnFdjQXCCmDypfnp56DA@mail.gmail.com>
Subject: Re: [PATCH 3/9] mm, swap: rename and move some swap cluster
 definition and helpers
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7A6334000F
X-Rspam-User: 
X-Stat-Signature: 96ffmspo8h1xs89w7gfdxd77smab78iw
X-Rspamd-Server: rspam09
X-HE-Tag: 1756521117-813146
X-HE-Meta: U2FsdGVkX18U7kxT0PjWNQtps49FzrpW7kG3Wn7QqFt6fxhNPRx1DGHyeFflv3BA18Za6H4su1YWDdToaCFAy3Q7kdPyDMozoCIMUMgxloLZgTR9+K2OMP0Ye4cgpduuQvMvvTagOQIOK4IOCSo1hcQ1+13BJ//0teejpR9r35O2nhU4XgBB092o/AVaVp4KhmU8YWFbCwIbY56SJKOB2bsy5jvYZiiSfWwVxB4KSHEPjy4ZWhM9u1dMh4I5PnxKORzAj5GJDoPeCS2okrqyxqCACRWmUgFCcOGb8BRjHoW+KxP9idBISCK2kxzpyOyT70Q/RKnxidrXvd6TpddOd9XsrJNlmomE0VX5v16FO/hjRLbOcFGStnkSgTkvy/D++Zo2ID2PbaaemLswU3O4WfkP/6WpD8Hl/lF8AOC/kvEmqgGGlo3rNH/o2lmXEjS9ZtE/DfnAI2cIqRpx2Tij3JUz0pvFg9rLDzgpqHF4sfGKtzYTlkdGFP779JVhZfjkbKuREfgPhlFd3yI/hWAP1NOHKdJA0E4gOsyLEIqURI8yBcbs6IkLZIeSO6/NKQ6r03oedyNzGAlD8BQYtIHiGZdPOtyQK2ZFgF0QOmHCXCBBpWZpIqZHF6IpxyNlTtjzsi1EsCd6SrwWvIYufWdyUD5RahFd9pdZxqN/THx4/PGdDHhJtkHs5RcDwSsMlHY3mnmg7Cau+hC+68/eY7yoHV1yJRoG8x5KsTORUYT/exO6zR4DswLIvL2MjEi/6P2X+VLqJqxQL94bbY/kB6uVS/qDLiyNL3baI5alz4ODMlH70Vh1+SxYkR03mpsfAdGlXLMD2GAbM9JqN1F0nE32r/0aBva9iGSY10cqiBpoxa55F0jXf4PLG8yMyO8iZM2H15Nzo8qSdUMWzkFyDMt0F1Ji3Y2XW+kP0A4rHIBZp2H0WFik8+/i6A9BS7/6Il7f8xyY9BlkEOcOqjp0mbU
 NrVcQEt9
 bnW4KO9XHBf3iTjfDUYLvqPg+IMeAZ+FzbM8fFNT1ENC8YGv49Vo8uZ+2SwUNb3cFctLaTV9v+KK5w55xG6myMlFJxPMkhBZmdxOn+azZ9u01YdnyGJpizh7cde6NPWBJMlxAaGUbocow7dz0sC5WdLlG469WUe0yJMTJVVEkb1+mgtmxCGkjMIjVjX1DV981DRZVjNvtHNG5Fok8KQwJkkDPTF44lWs+VSrPhlmzQQeJDA56vFB8+yIWn8uUBFwYcfNlMAqTKZKUPri+grYUCjFd+mqjbnLfO5MAeZOHiRO3hLCCcns79isbV1V59fSicQC4ciO6a9iC4XHQKtu93U2lNenmA57ZLbrBQaHSMuDgScbnAHOQErSso56fgDmzv1UPgjN2WIV5uu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No functional change patch is easier to review :-)

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, move cluster related definitions and helpers to
> mm/swap.h, also tidy up and add a "swap_" prefix for cluster lock/unlock
> helpers, so they can be used outside of swap files.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h | 34 ---------------
>  mm/swap.h            | 63 ++++++++++++++++++++++++++++
>  mm/swapfile.c        | 99 ++++++++++++++------------------------------
>  3 files changed, 93 insertions(+), 103 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index c2da85cb7fe7..20efd9a34034 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -235,40 +235,6 @@ enum {
>  /* Special value in each swap_map continuation */
>  #define SWAP_CONT_MAX  0x7f    /* Max count */
>
> -/*
> - * We use this to track usage of a cluster. A cluster is a block of swap=
 disk
> - * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk. =
All
> - * free clusters are organized into a list. We fetch an entry from the l=
ist to
> - * get a free cluster.
> - *
> - * The flags field determines if a cluster is free. This is
> - * protected by cluster lock.
> - */
> -struct swap_cluster_info {
> -       spinlock_t lock;        /*
> -                                * Protect swap_cluster_info fields
> -                                * other than list, and swap_info_struct-=
>swap_map
> -                                * elements corresponding to the swap clu=
ster.
> -                                */
> -       u16 count;
> -       u8 flags;
> -       u8 order;
> -       struct list_head list;
> -};
> -
> -/* All on-list cluster must have a non-zero flag. */
> -enum swap_cluster_flags {
> -       CLUSTER_FLAG_NONE =3D 0, /* For temporary off-list cluster */
> -       CLUSTER_FLAG_FREE,
> -       CLUSTER_FLAG_NONFULL,
> -       CLUSTER_FLAG_FRAG,
> -       /* Clusters with flags above are allocatable */
> -       CLUSTER_FLAG_USABLE =3D CLUSTER_FLAG_FRAG,
> -       CLUSTER_FLAG_FULL,
> -       CLUSTER_FLAG_DISCARD,
> -       CLUSTER_FLAG_MAX,
> -};
> -
>  /*
>   * The first page in the swap file is the swap header, which is always m=
arked
>   * bad to prevent it from being allocated as an entry. This also prevent=
s the
> diff --git a/mm/swap.h b/mm/swap.h
> index bb2adbfd64a9..223b40f2d37e 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -7,10 +7,73 @@ struct swap_iocb;
>
>  extern int page_cluster;
>
> +#ifdef CONFIG_THP_SWAP
> +#define SWAPFILE_CLUSTER       HPAGE_PMD_NR
> +#define swap_entry_order(order)        (order)
> +#else
> +#define SWAPFILE_CLUSTER       256
> +#define swap_entry_order(order)        0
> +#endif
> +
> +/*
> + * We use this to track usage of a cluster. A cluster is a block of swap=
 disk
> + * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk. =
All
> + * free clusters are organized into a list. We fetch an entry from the l=
ist to
> + * get a free cluster.
> + *
> + * The flags field determines if a cluster is free. This is
> + * protected by cluster lock.
> + */
> +struct swap_cluster_info {
> +       spinlock_t lock;        /*
> +                                * Protect swap_cluster_info fields
> +                                * other than list, and swap_info_struct-=
>swap_map
> +                                * elements corresponding to the swap clu=
ster.
> +                                */
> +       u16 count;
> +       u8 flags;
> +       u8 order;
> +       struct list_head list;
> +};
> +
> +/* All on-list cluster must have a non-zero flag. */
> +enum swap_cluster_flags {
> +       CLUSTER_FLAG_NONE =3D 0, /* For temporary off-list cluster */
> +       CLUSTER_FLAG_FREE,
> +       CLUSTER_FLAG_NONFULL,
> +       CLUSTER_FLAG_FRAG,
> +       /* Clusters with flags above are allocatable */
> +       CLUSTER_FLAG_USABLE =3D CLUSTER_FLAG_FRAG,
> +       CLUSTER_FLAG_FULL,
> +       CLUSTER_FLAG_DISCARD,
> +       CLUSTER_FLAG_MAX,
> +};
> +
>  #ifdef CONFIG_SWAP
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
>
> +static inline struct swap_cluster_info *swp_offset_cluster(
> +               struct swap_info_struct *si, pgoff_t offset)
> +{
> +       return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> +}
> +
> +static inline struct swap_cluster_info *swap_cluster_lock(
> +               struct swap_info_struct *si,
> +               unsigned long offset)
> +{
> +       struct swap_cluster_info *ci =3D swp_offset_cluster(si, offset);
> +
> +       spin_lock(&ci->lock);
> +       return ci;
> +}
> +
> +static inline void swap_cluster_unlock(struct swap_cluster_info *ci)
> +{
> +       spin_unlock(&ci->lock);
> +}
> +
>  /* linux/mm/page_io.c */
>  int sio_pool_init(void);
>  struct swap_iocb;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 12f2580ebe8d..618cf4333a3d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -58,9 +58,6 @@ static void swap_entries_free(struct swap_info_struct *=
si,
>  static void swap_range_alloc(struct swap_info_struct *si,
>                              unsigned int nr_entries);
>  static bool folio_swapcache_freeable(struct folio *folio);
> -static struct swap_cluster_info *lock_cluster(struct swap_info_struct *s=
i,
> -                                             unsigned long offset);
> -static inline void unlock_cluster(struct swap_cluster_info *ci);
>
>  static DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
> @@ -259,9 +256,9 @@ static int __try_to_reclaim_swap(struct swap_info_str=
uct *si,
>          * swap_map is HAS_CACHE only, which means the slots have no page=
 table
>          * reference or pending writeback, and can't be allocated to othe=
rs.
>          */
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>         need_reclaim =3D swap_only_has_cache(si, offset, nr_pages);
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         if (!need_reclaim)
>                 goto out_unlock;
>
> @@ -386,20 +383,7 @@ static void discard_swap_cluster(struct swap_info_st=
ruct *si,
>         }
>  }
>
> -#ifdef CONFIG_THP_SWAP
> -#define SWAPFILE_CLUSTER       HPAGE_PMD_NR
> -
> -#define swap_entry_order(order)        (order)
> -#else
> -#define SWAPFILE_CLUSTER       256
> -
> -/*
> - * Define swap_entry_order() as constant to let compiler to optimize
> - * out some code if !CONFIG_THP_SWAP
> - */
> -#define swap_entry_order(order)        0
> -#endif
> -#define LATENCY_LIMIT          256
> +#define LATENCY_LIMIT 256
>
>  static inline bool cluster_is_empty(struct swap_cluster_info *info)
>  {
> @@ -426,34 +410,12 @@ static inline unsigned int cluster_index(struct swa=
p_info_struct *si,
>         return ci - si->cluster_info;
>  }
>
> -static inline struct swap_cluster_info *offset_to_cluster(struct swap_in=
fo_struct *si,
> -                                                         unsigned long o=
ffset)
> -{
> -       return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> -}
> -
>  static inline unsigned int cluster_offset(struct swap_info_struct *si,
>                                           struct swap_cluster_info *ci)
>  {
>         return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>  }
>
> -static inline struct swap_cluster_info *lock_cluster(struct swap_info_st=
ruct *si,
> -                                                    unsigned long offset=
)
> -{
> -       struct swap_cluster_info *ci;
> -
> -       ci =3D offset_to_cluster(si, offset);
> -       spin_lock(&ci->lock);
> -
> -       return ci;
> -}
> -
> -static inline void unlock_cluster(struct swap_cluster_info *ci)
> -{
> -       spin_unlock(&ci->lock);
> -}
> -
>  static void move_cluster(struct swap_info_struct *si,
>                          struct swap_cluster_info *ci, struct list_head *=
list,
>                          enum swap_cluster_flags new_flags)
> @@ -809,7 +771,7 @@ static unsigned int alloc_swap_scan_cluster(struct sw=
ap_info_struct *si,
>         }
>  out:
>         relocate_cluster(si, ci);
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         if (si->flags & SWP_SOLIDSTATE) {
>                 this_cpu_write(percpu_swap_cluster.offset[order], next);
>                 this_cpu_write(percpu_swap_cluster.si[order], si);
> @@ -876,7 +838,7 @@ static void swap_reclaim_full_clusters(struct swap_in=
fo_struct *si, bool force)
>                 if (ci->flags =3D=3D CLUSTER_FLAG_NONE)
>                         relocate_cluster(si, ci);
>
> -               unlock_cluster(ci);
> +               swap_cluster_unlock(ci);
>                 if (to_scan <=3D 0)
>                         break;
>         }
> @@ -915,7 +877,7 @@ static unsigned long cluster_alloc_swap_entry(struct =
swap_info_struct *si, int o
>                 if (offset =3D=3D SWAP_ENTRY_INVALID)
>                         goto new_cluster;
>
> -               ci =3D lock_cluster(si, offset);
> +               ci =3D swap_cluster_lock(si, offset);
>                 /* Cluster could have been used by another order */
>                 if (cluster_is_usable(ci, order)) {
>                         if (cluster_is_empty(ci))
> @@ -923,7 +885,7 @@ static unsigned long cluster_alloc_swap_entry(struct =
swap_info_struct *si, int o
>                         found =3D alloc_swap_scan_cluster(si, ci, offset,
>                                                         order, usage);
>                 } else {
> -                       unlock_cluster(ci);
> +                       swap_cluster_unlock(ci);
>                 }
>                 if (found)
>                         goto done;
> @@ -1204,7 +1166,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
>         if (!si || !offset || !get_swap_device_info(si))
>                 return false;
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>         if (cluster_is_usable(ci, order)) {
>                 if (cluster_is_empty(ci))
>                         offset =3D cluster_offset(si, ci);
> @@ -1212,7 +1174,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
>                 if (found)
>                         *entry =3D swp_entry(si->type, found);
>         } else {
> -               unlock_cluster(ci);
> +               swap_cluster_unlock(ci);
>         }
>
>         put_swap_device(si);
> @@ -1480,14 +1442,14 @@ static void swap_entries_put_cache(struct swap_in=
fo_struct *si,
>         unsigned long offset =3D swp_offset(entry);
>         struct swap_cluster_info *ci;
>
> -       ci =3D lock_cluster(si, offset);
> -       if (swap_only_has_cache(si, offset, nr))
> +       ci =3D swap_cluster_lock(si, offset);
> +       if (swap_only_has_cache(si, offset, nr)) {
>                 swap_entries_free(si, ci, entry, nr);
> -       else {
> +       } else {
>                 for (int i =3D 0; i < nr; i++, entry.val++)
>                         swap_entry_put_locked(si, ci, entry, SWAP_HAS_CAC=
HE);
>         }
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>  }
>
>  static bool swap_entries_put_map(struct swap_info_struct *si,
> @@ -1505,7 +1467,7 @@ static bool swap_entries_put_map(struct swap_info_s=
truct *si,
>         if (count !=3D 1 && count !=3D SWAP_MAP_SHMEM)
>                 goto fallback;
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>         if (!swap_is_last_map(si, offset, nr, &has_cache)) {
>                 goto locked_fallback;
>         }
> @@ -1514,21 +1476,20 @@ static bool swap_entries_put_map(struct swap_info=
_struct *si,
>         else
>                 for (i =3D 0; i < nr; i++)
>                         WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CAC=
HE);
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>
>         return has_cache;
>
>  fallback:
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>  locked_fallback:
>         for (i =3D 0; i < nr; i++, entry.val++) {
>                 count =3D swap_entry_put_locked(si, ci, entry, 1);
>                 if (count =3D=3D SWAP_HAS_CACHE)
>                         has_cache =3D true;
>         }
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         return has_cache;
> -
>  }
>
>  /*
> @@ -1578,7 +1539,7 @@ static void swap_entries_free(struct swap_info_stru=
ct *si,
>         unsigned char *map_end =3D map + nr_pages;
>
>         /* It should never free entries across different clusters */
> -       VM_BUG_ON(ci !=3D offset_to_cluster(si, offset + nr_pages - 1));
> +       VM_BUG_ON(ci !=3D swp_offset_cluster(si, offset + nr_pages - 1));
>         VM_BUG_ON(cluster_is_empty(ci));
>         VM_BUG_ON(ci->count < nr_pages);
>
> @@ -1653,9 +1614,9 @@ bool swap_entry_swapped(struct swap_info_struct *si=
, swp_entry_t entry)
>         struct swap_cluster_info *ci;
>         int count;
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>         count =3D swap_count(si->swap_map[offset]);
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         return !!count;
>  }
>
> @@ -1678,7 +1639,7 @@ int swp_swapcount(swp_entry_t entry)
>
>         offset =3D swp_offset(entry);
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>
>         count =3D swap_count(si->swap_map[offset]);
>         if (!(count & COUNT_CONTINUED))
> @@ -1701,7 +1662,7 @@ int swp_swapcount(swp_entry_t entry)
>                 n *=3D (SWAP_CONT_MAX + 1);
>         } while (tmp_count & COUNT_CONTINUED);
>  out:
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         return count;
>  }
>
> @@ -1716,7 +1677,7 @@ static bool swap_page_trans_huge_swapped(struct swa=
p_info_struct *si,
>         int i;
>         bool ret =3D false;
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>         if (nr_pages =3D=3D 1) {
>                 if (swap_count(map[roffset]))
>                         ret =3D true;
> @@ -1729,7 +1690,7 @@ static bool swap_page_trans_huge_swapped(struct swa=
p_info_struct *si,
>                 }
>         }
>  unlock_out:
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         return ret;
>  }
>
> @@ -2662,8 +2623,8 @@ static void wait_for_allocation(struct swap_info_st=
ruct *si)
>         BUG_ON(si->flags & SWP_WRITEOK);
>
>         for (offset =3D 0; offset < end; offset +=3D SWAPFILE_CLUSTER) {
> -               ci =3D lock_cluster(si, offset);
> -               unlock_cluster(ci);
> +               ci =3D swap_cluster_lock(si, offset);
> +               swap_cluster_unlock(ci);
>         }
>  }
>
> @@ -3579,7 +3540,7 @@ static int __swap_duplicate(swp_entry_t entry, unsi=
gned char usage, int nr)
>         offset =3D swp_offset(entry);
>         VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
>         VM_WARN_ON(usage =3D=3D 1 && nr > 1);
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>
>         err =3D 0;
>         for (i =3D 0; i < nr; i++) {
> @@ -3634,7 +3595,7 @@ static int __swap_duplicate(swp_entry_t entry, unsi=
gned char usage, int nr)
>         }
>
>  unlock_out:
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         return err;
>  }
>
> @@ -3733,7 +3694,7 @@ int add_swap_count_continuation(swp_entry_t entry, =
gfp_t gfp_mask)
>
>         offset =3D swp_offset(entry);
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>
>         count =3D swap_count(si->swap_map[offset]);
>
> @@ -3793,7 +3754,7 @@ int add_swap_count_continuation(swp_entry_t entry, =
gfp_t gfp_mask)
>  out_unlock_cont:
>         spin_unlock(&si->cont_lock);
>  out:
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         put_swap_device(si);
>  outer:
>         if (page)
> --
> 2.51.0
>

