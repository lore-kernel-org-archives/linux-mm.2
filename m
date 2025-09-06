Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0684CA1013
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 02:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289086B0012; Fri,  5 Sep 2025 22:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260BD8E0005; Fri,  5 Sep 2025 22:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176DD8E0003; Fri,  5 Sep 2025 22:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04BCB6B0012
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:13:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 875EF1403E8
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:13:49 +0000 (UTC)
X-FDA: 83857204578.23.40A6C7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id AFA6320005
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:13:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gIu3n+bI;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757124827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/0WofGsniXs1gi3D1z5x8tiZh9Ye2QqvytMAFEREMU=;
	b=cfwcIZM5A2JR6r8e0KGesJQrRVwy7M2ZtlJHKt4MfzinIVIBtqrzfiwA297r5M5Tsz1rM/
	kTGNqYPvcYYJkPZUPaEQiRRzLNySyg8nRSmyUbShZTx+pbVMY8vfuY3qerkWcezryuZO/p
	r32kK9fh9NYrNVAvDmeoKJeZJDma0V4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gIu3n+bI;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757124827; a=rsa-sha256;
	cv=none;
	b=ygQNUG6lTwzp7Lt+b7dblwSxy46RbpKoyeKDpFjQnJrOLjairlQJyGEt77HxgWHEO04Eym
	yG1Rpreio72A9qENwZPv1zAx44a+4W7PFk4B5nBvLlr2MDqV9btOMVTK7P8qDWLt1qkiOM
	mlxQOqozKACkAWnbK8yY01gt/ZAc6BM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26100602AD
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB36C4CEF9
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757124826;
	bh=kREDYxihjsNEQCHQ1Gg8uaovG4V57ZM7mhrt823Ia98=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gIu3n+bIJYH102X7Mn7EbfsxqsCQC0hfIOdrLxHMnvPCY4OcA4zzJlT7I5vQ/mf5W
	 B4PW9C/ZXLanA7YEqXWl/z1a3KXGTHMf8t5xDlWfu5RaHx4P/JexshuJQlw+oBwg8r
	 xFEWF1Pk5l5ya61qz6RsHQmaTr/f6g5utvYkt6rpi05/B4Cy98r/pJJK4rTIBfqPqc
	 dFDddgf9z71jzFuEo6VcJgCyO7IziHipMqGHWyrAX+wwn/PZzngHf5jve3ckrQrEcL
	 HIdWdPY5T5/v0JUTlIID9wU6ysDeR9kgbQhPN/MnKPjbxKlFpq4Y+2/rVIp/0KFFdp
	 75bOJ5CDm8Rzw==
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so33275e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 19:13:46 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw5LXPY+uld9/YuSU5NvT7HwYNkEa2AeIXXmmdwkj9L3HW6q/SZ
	mShD0zQmfAREYh0PBiAyvU5l4Usvj5qorALMt1mD1tEUplnx14WaOZOrTk1s3Il3WW/fF+30Sfr
	HMDyxVwH3LwYWsj9DYYNqmCw9pymwQWKyUMP4rEAx
X-Google-Smtp-Source: AGHT+IHOHyRlLEm4i4DBFVWpmfTE0LehMNZXHPyyQ1mSMidGAjGdQv0BK1xLqNTXmTFvxV4hroMhCHMftTJWfHdbVX4=
X-Received: by 2002:a05:600c:34cb:b0:45c:b678:296 with SMTP id
 5b1f17b1804b1-45dde17c034mr426725e9.5.1757124825342; Fri, 05 Sep 2025
 19:13:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-7-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-7-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 5 Sep 2025 19:13:34 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMeFqaEKEdn7802jUgqgaSXX8sqmvBTSCACNFtEMaWb-g@mail.gmail.com>
X-Gm-Features: Ac12FXyekCXojyng6Hzz-z4j_C2L9uOYC8K-WNpguiLstyHhzuyD4bdHp-T2mQ4
Message-ID: <CAF8kJuMeFqaEKEdn7802jUgqgaSXX8sqmvBTSCACNFtEMaWb-g@mail.gmail.com>
Subject: Re: [PATCH v2 06/15] mm, swap: rename and move some swap cluster
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
X-Rspamd-Queue-Id: AFA6320005
X-Rspam-User: 
X-Stat-Signature: xz5zsgw8s7k7d1wdtkf887symim5as98
X-Rspamd-Server: rspam09
X-HE-Tag: 1757124827-946000
X-HE-Meta: U2FsdGVkX1+6ZyHxFoKCbIxfpROKR1ZIcWLPKMPpiY7apUrAthboEDGTWjsMQR5VcIYvZeb2qzZQFEV7fUwxSYXwQGMB9Etq22kfv3fPphfvX7M/FC6pqv6HBxvNFGd2VjQ3S27jf04RXtBOfPSzkZxtQu72SV9SDGJ7JEFUmpdEhcn/rAtU45L0IRo28UTZXIyl7+2oo6CCzsNmHvTYAZJt1Uu0H2UW1zBR9Y2X9+iZjcMmAU4dsdDxQPeX4tJUTp/zX2nNFNxQ7++KSIld8I6jGHq88ur0EkxrN3ru07VLKs6gdrE9CyU7q0GWd3yYbcRxn02PdSNTRYWMMsOAGmrh1feCZQgGIq/FJV400AIhrnFdIEJULc8yySAlMmuGRPagUx+rceVpx2cMPAhHVZHaqfE703ZEiZqiZag2ZhiSqcit4KRtS4PFr0rQm0N4XvKY7q8emzEyoH7BLK2TaQHPoMNwysZQrorSmq1z+t87NpnTPAGsNyBRHi3GBa/rXstXsUZVp3ZihVJuqWjgQbBQ4PRPZY3yHk4IEFJTvuxbcrX1YywOOd9REQuftcV60YICZEWAjqWqwb2ZjhhJsxlq1FwSFC556Je2cSoWtYWX91wtSBd64F0tCQYhBaAIztdpzi9+yvhyuAAKtwbLFtsK1ladXqu/5nqubNjEOoroh+t8LHKgmBFLPME8TZLeMlNuy8kI0yYwju+dIP1RE2RT8elDfWK6+EieRe1kXSfiOl6IZclYnzP7HsXopnhIwPnN+WAOy8LzbuyiV2kjaYG1pOgkNttZjdzS5+OmsEqMn4oRkWwsco9BGCdcRdWPl96qpzcftBqEXpksfuRJZsYawKKL3iKo1h4Bp5lfhHa/KC42pVTzUrp9pSBSFOfdOSXPwNbNmkC/hSEn9Cm/U2fpLhG8eKKO89cWV3SLw5IizoUYX+ya4elYutr1zQiUXrC7Q5oUwFCMhGvhCEl
 tR8R8ISs
 i8an9RyOU1M5vTFfLrHmlnagj7w0SXM9wnoSuVsvRrgvYNItWuiKELaHN9kteDmnnIoOfnco9FXB2zL43n6FMyVSpFtQxYxLsWfCvEWVesAf6yyAB8afWgxjXOmGNxsqzDuGC55fNupSAfyhzv9sLdTcQ7/zZUtH/NAi8SDkCjGWcw++eCC0rx3a8mwBf+Z68NdLuSQvDLs5+Y+LaSKKnz90MgoGp19PbMOJhEf0NrJx0nxiMMggecavKx22D2N/VZQSYoDb2yHVhmczoF2HcvK1GXogZQj/znngyFrO+RMj3VdjQl46jUVGpfgZKl47Mjj6rLkM4PkIsFjo8sVKrzARZroKhf7MPdAfkxo2Yzdwd1DXMklqfSA3q5Cw1suSdiGPw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, move cluster related definitions and helpers to
> mm/swap.h, also tidy up and add a "swap_" prefix for cluster lock/unlock
> helpers, so they can be used outside of swap files. And while at it, add
> kerneldoc.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/swap.h | 34 ----------------
>  mm/swap.h            | 70 ++++++++++++++++++++++++++++++++
>  mm/swapfile.c        | 97 +++++++++++++-------------------------------
>  3 files changed, 99 insertions(+), 102 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 23452f014ca1..7e1fe4ff3d30 100644
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
> index a69e18b12b45..39b27337bc0a 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -7,10 +7,80 @@ struct swap_iocb;
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
> +/**
> + * swap_cluster_lock - Lock and return the swap cluster of given offset.
> + * @si: swap device the cluster belongs to.
> + * @offset: the swap entry offset, pointing to a valid slot.
> + *
> + * Context: The caller must ensure the offset is in the valid range and
> + * protect the swap device with reference count or locks.
> + */
> +static inline struct swap_cluster_info *swap_cluster_lock(
> +               struct swap_info_struct *si, unsigned long offset)
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
> index 1bd90f17440f..547ad4bfe1d8 100644
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
> @@ -257,9 +254,9 @@ static int __try_to_reclaim_swap(struct swap_info_str=
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
> @@ -384,19 +381,6 @@ static void discard_swap_cluster(struct swap_info_st=
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
>  #define LATENCY_LIMIT          256
>
>  static inline bool cluster_is_empty(struct swap_cluster_info *info)
> @@ -424,34 +408,12 @@ static inline unsigned int cluster_index(struct swa=
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
> @@ -807,7 +769,7 @@ static unsigned int alloc_swap_scan_cluster(struct sw=
ap_info_struct *si,
>         }
>  out:
>         relocate_cluster(si, ci);
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         if (si->flags & SWP_SOLIDSTATE) {
>                 this_cpu_write(percpu_swap_cluster.offset[order], next);
>                 this_cpu_write(percpu_swap_cluster.si[order], si);
> @@ -874,7 +836,7 @@ static void swap_reclaim_full_clusters(struct swap_in=
fo_struct *si, bool force)
>                 if (ci->flags =3D=3D CLUSTER_FLAG_NONE)
>                         relocate_cluster(si, ci);
>
> -               unlock_cluster(ci);
> +               swap_cluster_unlock(ci);
>                 if (to_scan <=3D 0)
>                         break;
>         }
> @@ -913,7 +875,7 @@ static unsigned long cluster_alloc_swap_entry(struct =
swap_info_struct *si, int o
>                 if (offset =3D=3D SWAP_ENTRY_INVALID)
>                         goto new_cluster;
>
> -               ci =3D lock_cluster(si, offset);
> +               ci =3D swap_cluster_lock(si, offset);
>                 /* Cluster could have been used by another order */
>                 if (cluster_is_usable(ci, order)) {
>                         if (cluster_is_empty(ci))
> @@ -921,7 +883,7 @@ static unsigned long cluster_alloc_swap_entry(struct =
swap_info_struct *si, int o
>                         found =3D alloc_swap_scan_cluster(si, ci, offset,
>                                                         order, usage);
>                 } else {
> -                       unlock_cluster(ci);
> +                       swap_cluster_unlock(ci);
>                 }
>                 if (found)
>                         goto done;
> @@ -1202,7 +1164,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
>         if (!si || !offset || !get_swap_device_info(si))
>                 return false;
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>         if (cluster_is_usable(ci, order)) {
>                 if (cluster_is_empty(ci))
>                         offset =3D cluster_offset(si, ci);
> @@ -1210,7 +1172,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
>                 if (found)
>                         *entry =3D swp_entry(si->type, found);
>         } else {
> -               unlock_cluster(ci);
> +               swap_cluster_unlock(ci);
>         }
>
>         put_swap_device(si);
> @@ -1478,14 +1440,14 @@ static void swap_entries_put_cache(struct swap_in=
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
> @@ -1503,7 +1465,7 @@ static bool swap_entries_put_map(struct swap_info_s=
truct *si,
>         if (count !=3D 1 && count !=3D SWAP_MAP_SHMEM)
>                 goto fallback;
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>         if (!swap_is_last_map(si, offset, nr, &has_cache)) {
>                 goto locked_fallback;
>         }
> @@ -1512,21 +1474,20 @@ static bool swap_entries_put_map(struct swap_info=
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
> @@ -1576,7 +1537,7 @@ static void swap_entries_free(struct swap_info_stru=
ct *si,
>         unsigned char *map_end =3D map + nr_pages;
>
>         /* It should never free entries across different clusters */
> -       VM_BUG_ON(ci !=3D offset_to_cluster(si, offset + nr_pages - 1));
> +       VM_BUG_ON(ci !=3D swp_offset_cluster(si, offset + nr_pages - 1));
>         VM_BUG_ON(cluster_is_empty(ci));
>         VM_BUG_ON(ci->count < nr_pages);
>
> @@ -1651,9 +1612,9 @@ bool swap_entry_swapped(struct swap_info_struct *si=
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
> @@ -1676,7 +1637,7 @@ int swp_swapcount(swp_entry_t entry)
>
>         offset =3D swp_offset(entry);
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>
>         count =3D swap_count(si->swap_map[offset]);
>         if (!(count & COUNT_CONTINUED))
> @@ -1699,7 +1660,7 @@ int swp_swapcount(swp_entry_t entry)
>                 n *=3D (SWAP_CONT_MAX + 1);
>         } while (tmp_count & COUNT_CONTINUED);
>  out:
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         return count;
>  }
>
> @@ -1714,7 +1675,7 @@ static bool swap_page_trans_huge_swapped(struct swa=
p_info_struct *si,
>         int i;
>         bool ret =3D false;
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>         if (nr_pages =3D=3D 1) {
>                 if (swap_count(map[roffset]))
>                         ret =3D true;
> @@ -1727,7 +1688,7 @@ static bool swap_page_trans_huge_swapped(struct swa=
p_info_struct *si,
>                 }
>         }
>  unlock_out:
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         return ret;
>  }
>
> @@ -2660,8 +2621,8 @@ static void wait_for_allocation(struct swap_info_st=
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
> @@ -3577,7 +3538,7 @@ static int __swap_duplicate(swp_entry_t entry, unsi=
gned char usage, int nr)
>         offset =3D swp_offset(entry);
>         VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
>         VM_WARN_ON(usage =3D=3D 1 && nr > 1);
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>
>         err =3D 0;
>         for (i =3D 0; i < nr; i++) {
> @@ -3632,7 +3593,7 @@ static int __swap_duplicate(swp_entry_t entry, unsi=
gned char usage, int nr)
>         }
>
>  unlock_out:
> -       unlock_cluster(ci);
> +       swap_cluster_unlock(ci);
>         return err;
>  }
>
> @@ -3731,7 +3692,7 @@ int add_swap_count_continuation(swp_entry_t entry, =
gfp_t gfp_mask)
>
>         offset =3D swp_offset(entry);
>
> -       ci =3D lock_cluster(si, offset);
> +       ci =3D swap_cluster_lock(si, offset);
>
>         count =3D swap_count(si->swap_map[offset]);
>
> @@ -3791,7 +3752,7 @@ int add_swap_count_continuation(swp_entry_t entry, =
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
>

