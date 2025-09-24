Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CAACAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 21:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250C78E000F; Wed, 24 Sep 2025 17:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2002A8E000A; Wed, 24 Sep 2025 17:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9268E000F; Wed, 24 Sep 2025 17:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E673D8E000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:52:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 951741401F3
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:52:12 +0000 (UTC)
X-FDA: 83925492504.09.E708044
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9109A4000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:52:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxS9SBMl;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758750730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AUDvayvqg9BE8klNDE7FSLcFwgoPSM7ypranwITaVI=;
	b=ylJ3UJcAGigec9bdfdqpaZhvnhQSFePmbnH8ZQvurYOcFyQPQ0XP2c+RkOCjo2YE/vxZ+0
	vvo3b1gGf/sEAsBkqhpxr8PqNpqKZbrZQ0nY1d+e1HHWDDz5hxcfV26PcP5gbcVp3ZUgi2
	7yUy+ISGkfIHDv4+bjhdWc5k5b58V9Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxS9SBMl;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758750730; a=rsa-sha256;
	cv=none;
	b=g0ue17m0q3rFgvCHzzXY1Cxjcu1jFjffqaLUlJJJ2ObKsRFjODvt3yDQmtWq4ZTJKP0IFS
	expmMTTbSUIFTYaGi+IvG8IfbGIQ+VfQ1VEVc0VeEjcR1WVGoSezAsl7HISNY1xhpRaQY2
	o0tLFNogxPqh1VZ7MeRyJcb5WWcP80A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62E6844F73
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA31C2BC9E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758750729;
	bh=iQdWCsrSk5lTPljFQXTLb4QcEJGc6XuFjX4Sva83Jns=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nxS9SBMlwY9w8dJQfoClKLbqedT+m0YIuzFC+jEaJU+ppPHBBrLyF04g5rHGpeQpn
	 Ws0LALcxclyCnKafftpoTI7yq+5OIQ1DGegfW9I2ceTAdeC4kDVo+bQhr9mHS8HtaF
	 DYNNBTtKSG73u9nAydM3+oD3/wICnfpH7hlNc2oyP/G2BNmjwVtnaZ7ZIrCEE1hEkR
	 LsOfokcKkuy8rx4BiQ43cuUCL/tzxbM8ltznD071OqJMvgjwrG5Nq+dNS1v0xasMbV
	 hIN5FbcPDkwO4m+//KHsOoxNaGNiKod5NUMT0qyVK4WnzzkwGcsJnJyE+89jzAtTKo
	 JyI9sLfMSuWlw==
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-eab80c807faso298576276.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:52:09 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxx5rxPu7DnRwS28fsY/AhRP5W5ZyKYluq733p4D8gd8BylPjLc
	uTY9KY5vcVC0Uf58vNbicTPikdR6e039dok1F1D0o5Q9cAJhHkajNAol7r67tE41x57fxhwxmfN
	mSiC3/pXXo/+VZFyPLs4Qc/QVR8d1DZvUtU+HVpI54w==
X-Google-Smtp-Source: AGHT+IE6h7Sw2paq1MWV8efpcCft6nACe03owlUssPI2dTorSSDYoZhEH2eIoM7PeHFQC4ew9rrrs8eFiF6ZcNzluE8=
X-Received: by 2002:a05:6902:1686:b0:e95:3c97:f7d5 with SMTP id
 3f1490d57ef6-eb37fc721acmr1269725276.9.1758750728112; Wed, 24 Sep 2025
 14:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-15-ryncsn@gmail.com>
In-Reply-To: <20250916160100.31545-15-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 24 Sep 2025 14:51:57 -0700
X-Gmail-Original-Message-ID: <CACePvbUNGfy-iYVHcQ9RuTkXgNFa1N39Luj3SnWn_uc8j7fefA@mail.gmail.com>
X-Gm-Features: AS18NWCL9BlmOXMhFRrJJ5d8G7V8Jcg-JWoO69zbocZok6IjOkBkxNbeOJAhbs4
Message-ID: <CACePvbUNGfy-iYVHcQ9RuTkXgNFa1N39Luj3SnWn_uc8j7fefA@mail.gmail.com>
Subject: Re: [PATCH v4 14/15] mm, swap: implement dynamic allocation of swap table
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9109A4000C
X-Stat-Signature: 7qhz3e9qny6krgg6smubce68awaqhb7s
X-HE-Tag: 1758750730-317646
X-HE-Meta: U2FsdGVkX1//Bqm5Lm9otBs1wN6aDzl+YIzlSWeTzAI6I2V1fJrA0qfQC0FpYAytHnkx/pC5OXJZoDYsMtIj2T1zHzePMl2+EUDu7TKKyydgSnAYtvmJvtHQgY6PHqzzLRub0fV2cLQqke9xTuyfydfA0w38Wt9au7UaprU8h7oL/b7SJ2/gfMpqFUel8gmYoIlon5tlxoHpdc8rpeQEUi1NhqVXrwdNBthIysemdeF2TpZxvjjBo97J1/HI1e+w9sF5cDvuc8LeHjC6+yXhx7G7Laa+1Wp0jeK7XJkhE2cOqO6OzkA+C+Fd8Bh18eORXebytf7/XS9pH6BLoItggUdor5Juaa0MWtPhcgQSpekIez9GQZ6zth25mUvAE8liFx5ETcr1YYnJ4Q8r4ctooxQaCSApfu0jKRWTrBjy07Jh2nQFg8L29hCuI8/I2u4WyQnZMlNjGb1wP67KAqe8c5wH5dWD4201Hm6DMONN0PCVJ9gm1NxpwjTMEDiTDpE5WvMehiUJD6jyEI/wA/gWo4X/s0dLrSD6kazraRYVAAAkObZlsOS13JUYiaRMY3Hdib7TqwPK2hUDLM3Iu8zVMEfBkSsQBKHFV1BVzosIqCRE3GSA/kD/boomTIiRx2LktujBLFiN+HQ0kmPyYM5CW2F45FSZHCTbfZB2dsu9pmmkN1AeZSBVtlOBAoLkY7Ved6Pn/4qWiZ9i+nqnjTG7URnk6PEEm96E9lnY06BjbSbNu2DnPlwdOGxEMLGIcyxys0Wk4cEbis8XrI/1sil2+wic5LRkpHp8ZIr8ed3Wh0F3mDzKb39K8/OvXnb2jq349R60y6accioAk4e0mpapOdTQ3czrVZ3f0A3+P1HxUIWER45kow8SLL125iw4b7iL1zBxGw3abRFLeXgOCqXvm1OEe65/Sirqv3+9VyZlg5vh29QkKVtXVTjmJDM5KQZn4AHbxwLdWCI3PORWfiw
 azyMzYzs
 J8bqQypmzIJff8jUiQdm7AIBWxiw9EFJ2jNstJ9W5gJpzNr7bFXLzihYRuksw3YvgynPgUZtiEi7268bcjoNouS5kixsWM+B/eCEbjALftp/vcmjFkZTYMPkSWF6HzZAN0ToxkM9dJAwG7Q05QTtf/9xA2frc7GGra9O4GdTJ5+6N1D4uys9IFQiJ/nQPheh4aZc52Rt6roKNQoAXVrvCtTMJFwiMNaJ6HvN7bYDyZ3/QUc3cErJQI2FU3FtOD4VmTfgP05kTXJerLAAgXkEUSe8xhOcPg4ZhkXDJ366z4gussEXy1S14PJYmkuaSZTIyKKjNDEsOcKkMd0bz5fmwWV/xdT+y+9Seq99czVVh9Jj+IualAiKskBmfjXLjRH+2sM6U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

I assume there are no changes outside of swap_cluster_alloc_table(),
if there is please let me know.

I did one more pass mostly focusing on swap_cluster_alloc_table() .
Looks fine with minor Nitpicks following.

Acked-by: Chris Li <chrisl@kernel.org>


On Tue, Sep 16, 2025 at 9:02=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Now swap table is cluster based, which means free clusters can free its
> table since no one should modify it.
>
> There could be speculative readers, like swap cache look up, protect
> them by making them RCU protected. All swap table should be filled with
> null entries before free, so such readers will either see a NULL pointer
> or a null filled table being lazy freed.
>
> On allocation, allocate the table when a cluster is used by any order.
>
> This way, we can reduce the memory usage of large swap device
> significantly.
>
> This idea to dynamically release unused swap cluster data was initially
> suggested by Chris Li while proposing the cluster swap allocator and
> it suits the swap table idea very well.
>
> Co-developed-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h       |   2 +-
>  mm/swap_state.c |   9 +--
>  mm/swap_table.h |  37 ++++++++-
>  mm/swapfile.c   | 197 +++++++++++++++++++++++++++++++++++++-----------
>  4 files changed, 194 insertions(+), 51 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index fe5c20922082..8d8efdf1297a 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -36,7 +36,7 @@ struct swap_cluster_info {
>         u16 count;
>         u8 flags;
>         u8 order;
> -       atomic_long_t *table;   /* Swap table entries, see mm/swap_table.=
h */
> +       atomic_long_t __rcu *table;     /* Swap table entries, see mm/swa=
p_table.h */
>         struct list_head list;
>  };
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index a1478cbff384..b13e9c4baa90 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -91,8 +91,8 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
>         struct folio *folio;
>
>         for (;;) {
> -               swp_tb =3D __swap_table_get(__swap_entry_to_cluster(entry=
),
> -                                         swp_cluster_offset(entry));
> +               swp_tb =3D swap_table_get(__swap_entry_to_cluster(entry),
> +                                       swp_cluster_offset(entry));
>                 if (!swp_tb_is_folio(swp_tb))
>                         return NULL;
>                 folio =3D swp_tb_to_folio(swp_tb);
> @@ -115,11 +115,10 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>  {
>         unsigned long swp_tb;
>
> -       swp_tb =3D __swap_table_get(__swap_entry_to_cluster(entry),
> -                                 swp_cluster_offset(entry));
> +       swp_tb =3D swap_table_get(__swap_entry_to_cluster(entry),
> +                               swp_cluster_offset(entry));
>         if (swp_tb_is_shadow(swp_tb))
>                 return swp_tb_to_shadow(swp_tb);
> -
>         return NULL;
>  }
>
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index e1f7cc009701..52254e455304 100644
> --- a/mm/swap_table.h
> +++ b/mm/swap_table.h
> @@ -2,8 +2,15 @@
>  #ifndef _MM_SWAP_TABLE_H
>  #define _MM_SWAP_TABLE_H
>
> +#include <linux/rcupdate.h>
> +#include <linux/atomic.h>
>  #include "swap.h"
>
> +/* A typical flat array in each cluster as swap table */
> +struct swap_table {
> +       atomic_long_t entries[SWAPFILE_CLUSTER];
> +};
> +
>  /*
>   * A swap table entry represents the status of a swap slot on a swap
>   * (physical or virtual) device. The swap table in each cluster is a
> @@ -76,22 +83,46 @@ static inline void *swp_tb_to_shadow(unsigned long sw=
p_tb)
>  static inline void __swap_table_set(struct swap_cluster_info *ci,
>                                     unsigned int off, unsigned long swp_t=
b)
>  {
> +       atomic_long_t *table =3D rcu_dereference_protected(ci->table, tru=
e);
> +
> +       lockdep_assert_held(&ci->lock);
>         VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> -       atomic_long_set(&ci->table[off], swp_tb);
> +       atomic_long_set(&table[off], swp_tb);
>  }
>
>  static inline unsigned long __swap_table_xchg(struct swap_cluster_info *=
ci,
>                                               unsigned int off, unsigned =
long swp_tb)
>  {
> +       atomic_long_t *table =3D rcu_dereference_protected(ci->table, tru=
e);
> +
> +       lockdep_assert_held(&ci->lock);
>         VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
>         /* Ordering is guaranteed by cluster lock, relax */
> -       return atomic_long_xchg_relaxed(&ci->table[off], swp_tb);
> +       return atomic_long_xchg_relaxed(&table[off], swp_tb);
>  }
>
>  static inline unsigned long __swap_table_get(struct swap_cluster_info *c=
i,
>                                              unsigned int off)
>  {
> +       atomic_long_t *table;
> +
>         VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> -       return atomic_long_read(&ci->table[off]);
> +       table =3D rcu_dereference_check(ci->table, lockdep_is_held(&ci->l=
ock));
> +
> +       return atomic_long_read(&table[off]);
> +}
> +
> +static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
> +                                       unsigned int off)
> +{
> +       atomic_long_t *table;
> +       unsigned long swp_tb;
> +
> +       rcu_read_lock();
> +       table =3D rcu_dereference(ci->table);
> +       swp_tb =3D table ? atomic_long_read(&table[off]) : null_to_swp_tb=
();
> +       rcu_read_unlock();
> +
> +       return swp_tb;
>  }
>  #endif
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 314c5c10d3bd..094e3e75849f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -59,6 +59,9 @@ static void swap_entries_free(struct swap_info_struct *=
si,
>  static void swap_range_alloc(struct swap_info_struct *si,
>                              unsigned int nr_entries);
>  static bool folio_swapcache_freeable(struct folio *folio);
> +static void move_cluster(struct swap_info_struct *si,
> +                        struct swap_cluster_info *ci, struct list_head *=
list,
> +                        enum swap_cluster_flags new_flags);
>
>  static DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
> @@ -105,6 +108,8 @@ static DEFINE_SPINLOCK(swap_avail_lock);
>
>  struct swap_info_struct *swap_info[MAX_SWAPFILES];
>
> +static struct kmem_cache *swap_table_cachep;
> +
>  static DEFINE_MUTEX(swapon_mutex);
>
>  static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
> @@ -401,10 +406,17 @@ static inline bool cluster_is_discard(struct swap_c=
luster_info *info)
>         return info->flags =3D=3D CLUSTER_FLAG_DISCARD;
>  }
>
> +static inline bool cluster_table_is_alloced(struct swap_cluster_info *ci=
)
> +{
> +       return rcu_dereference_protected(ci->table, lockdep_is_held(&ci->=
lock));
> +}
> +
>  static inline bool cluster_is_usable(struct swap_cluster_info *ci, int o=
rder)
>  {
>         if (unlikely(ci->flags > CLUSTER_FLAG_USABLE))
>                 return false;
> +       if (!cluster_table_is_alloced(ci))
> +               return false;
>         if (!order)
>                 return true;
>         return cluster_is_empty(ci) || order =3D=3D ci->order;
> @@ -422,32 +434,90 @@ static inline unsigned int cluster_offset(struct sw=
ap_info_struct *si,
>         return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>  }
>
> -static int swap_cluster_alloc_table(struct swap_cluster_info *ci)
> +static void swap_cluster_free_table(struct swap_cluster_info *ci)
>  {
> -       WARN_ON(ci->table);
> -       ci->table =3D kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER, G=
FP_KERNEL);
> -       if (!ci->table)
> -               return -ENOMEM;
> -       return 0;
> +       unsigned int ci_off;
> +       struct swap_table *table;
> +
> +       /* Only empty cluster's table is allow to be freed  */
> +       lockdep_assert_held(&ci->lock);
> +       VM_WARN_ON_ONCE(!cluster_is_empty(ci));
> +       for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++)
> +               VM_WARN_ON_ONCE(!swp_tb_is_null(__swap_table_get(ci, ci_o=
ff)));
> +       table =3D (void *)rcu_dereference_protected(ci->table, true);
> +       rcu_assign_pointer(ci->table, NULL);
> +
> +       kmem_cache_free(swap_table_cachep, table);
>  }
>
> -static void swap_cluster_free_table(struct swap_cluster_info *ci)
> +/*
> + * Allocate swap table for one cluster. Attempt an atomic allocation fir=
st,
> + * then fallback to sleeping allocation.
> + */
> +static struct swap_cluster_info *
> +swap_cluster_alloc_table(struct swap_info_struct *si,
> +                        struct swap_cluster_info *ci)
>  {
> -       unsigned int ci_off;
> -       unsigned long swp_tb;
> +       struct swap_table *table;
>
> -       if (!ci->table)
> -               return;
> +       /*
> +        * Only cluster isolation from the allocator does table allocatio=
n.
> +        * Swap allocator uses percpu clusters and holds the local lock.
> +        */
> +       lockdep_assert_held(&ci->lock);
> +       lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +
> +       /* The cluster must be free and was just isolated from the free l=
ist. */
> +       VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> +
> +       table =3D kmem_cache_zalloc(swap_table_cachep,
> +                                 __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_N=
OWARN);
> +       if (table) {
Nit: this can goto the same shared exit path exit with
rcu_assign_pointer(ci->table, table) at the end of the function.
It looks cleaner and possibly generates better code because the
compiler doesn't generate two  rcu_assign_pointer() in this function.

> +               rcu_assign_pointer(ci->table, table);
> +               return ci;
> +       }
> +
> +       /*
> +        * Try a sleep allocation. Each isolated free cluster may cause
> +        * a sleep allocation, but there is a limited number of them, so
> +        * the potential recursive allocation is limited.
> +        */
> +       spin_unlock(&ci->lock);
> +       if (!(si->flags & SWP_SOLIDSTATE))

Nit: si->flags & SWP_SOLIDSTATE should never change. However, it is
better to not make assumptions about it. You'd better cache this into
a local variable so that spin_unlock() and later spin_lock() are
paired.

> +               spin_unlock(&si->global_cluster_lock);
> +       local_unlock(&percpu_swap_cluster.lock);
> +
> +       table =3D kmem_cache_zalloc(swap_table_cachep,
> +                                 __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KER=
NEL);
> +
> +       /*
> +        * Back to atomic context. We might have migrated to a new CPU wi=
th a
> +        * usable percpu cluster. But just keep using the isolated cluste=
r to
> +        * make things easier. Migration indicates a slight change of wor=
kload
> +        * so using a new free cluster might not be a bad idea, and the w=
orst
> +        * could happen with ignoring the percpu cluster is fragmentation=
,
> +        * which is acceptable since this fallback and race is rare.
> +        */
> +       local_lock(&percpu_swap_cluster.lock);
> +       if (!(si->flags & SWP_SOLIDSTATE))
Nit: here you should use the cached local variable rather than testing
the !(si->flags & SWP_SOLIDSTATE) again. It is much easier to notice
that the same condition was used if using the same variable as the
test condition.

> +               spin_lock(&si->global_cluster_lock);
> +       spin_lock(&ci->lock);
>
> -       for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> -               swp_tb =3D __swap_table_get(ci, ci_off);
> -               if (!swp_tb_is_null(swp_tb))
> -                       pr_err_once("swap: unclean swap space on swapoff:=
 0x%lx",
> -                                   swp_tb);
> +       /* Nothing except this helper should touch a dangling empty clust=
er. */
> +       if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
> +               if (table)
> +                       kmem_cache_free(swap_table_cachep, table);
> +               return ci;
Nit: consider goto the same exit point for return.
Right now there is no further clean up required before returning ci.
Share the exit path, e.g. goto done label is in general better than
shortcut the return path here for complex functions.

>         }
>
> -       kfree(ci->table);
> -       ci->table =3D NULL;
> +       if (!table) {
> +               move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FRE=
E);
> +               spin_unlock(&ci->lock);
> +               return NULL;
Nit: same for here, you can set ci =3D NULL then goto the done label.
> +       }
> +

Nit: Might need another assign table label here.

> +       rcu_assign_pointer(ci->table, table);

Nit: I would put the "done:" label here. You are welcome to use a
different label name.

> +       return ci;
>  }
>
>  static void move_cluster(struct swap_info_struct *si,
> @@ -479,7 +549,7 @@ static void swap_cluster_schedule_discard(struct swap=
_info_struct *si,
>
>  static void __free_cluster(struct swap_info_struct *si, struct swap_clus=
ter_info *ci)
>  {
> -       lockdep_assert_held(&ci->lock);
> +       swap_cluster_free_table(ci);
>         move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
>         ci->order =3D 0;
>  }
> @@ -494,15 +564,11 @@ static void __free_cluster(struct swap_info_struct =
*si, struct swap_cluster_info
>   * this returns NULL for an non-empty list.
>   */
>  static struct swap_cluster_info *isolate_lock_cluster(
> -               struct swap_info_struct *si, struct list_head *list)
> +               struct swap_info_struct *si, struct list_head *list, int =
order)
>  {
> -       struct swap_cluster_info *ci, *ret =3D NULL;
> +       struct swap_cluster_info *ci, *found =3D NULL;
>
>         spin_lock(&si->lock);
> -
> -       if (unlikely(!(si->flags & SWP_WRITEOK)))
> -               goto out;
> -
>         list_for_each_entry(ci, list, list) {
>                 if (!spin_trylock(&ci->lock))
>                         continue;
> @@ -514,13 +580,19 @@ static struct swap_cluster_info *isolate_lock_clust=
er(
>
>                 list_del(&ci->list);
>                 ci->flags =3D CLUSTER_FLAG_NONE;
> -               ret =3D ci;
> +               found =3D ci;
>                 break;
>         }
> -out:
>         spin_unlock(&si->lock);
>
> -       return ret;
> +       if (found && !cluster_table_is_alloced(found)) {
> +               /* Only an empty free cluster's swap table can be freed. =
*/
> +               VM_WARN_ON_ONCE(list !=3D &si->free_clusters);
> +               VM_WARN_ON_ONCE(!cluster_is_empty(found));
> +               return swap_cluster_alloc_table(si, found);
> +       }
> +
> +       return found;
>  }
>
>  /*
> @@ -653,17 +725,27 @@ static void relocate_cluster(struct swap_info_struc=
t *si,
>   * added to free cluster list and its usage counter will be increased by=
 1.
>   * Only used for initialization.
>   */
> -static void inc_cluster_info_page(struct swap_info_struct *si,
> +static int inc_cluster_info_page(struct swap_info_struct *si,
>         struct swap_cluster_info *cluster_info, unsigned long page_nr)
>  {
>         unsigned long idx =3D page_nr / SWAPFILE_CLUSTER;
> +       struct swap_table *table;
>         struct swap_cluster_info *ci;
>
>         ci =3D cluster_info + idx;
> +       if (!ci->table) {
> +               table =3D kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL=
);
> +               if (!table)
> +                       return -ENOMEM;
> +               rcu_assign_pointer(ci->table, table);
> +       }
> +
>         ci->count++;
>
>         VM_BUG_ON(ci->count > SWAPFILE_CLUSTER);
>         VM_BUG_ON(ci->flags);
> +
> +       return 0;
>  }
>
>  static bool cluster_reclaim_range(struct swap_info_struct *si,
> @@ -845,7 +927,7 @@ static unsigned int alloc_swap_scan_list(struct swap_=
info_struct *si,
>         unsigned int found =3D SWAP_ENTRY_INVALID;
>
>         do {
> -               struct swap_cluster_info *ci =3D isolate_lock_cluster(si,=
 list);
> +               struct swap_cluster_info *ci =3D isolate_lock_cluster(si,=
 list, order);
>                 unsigned long offset;
>
>                 if (!ci)
> @@ -870,7 +952,7 @@ static void swap_reclaim_full_clusters(struct swap_in=
fo_struct *si, bool force)
>         if (force)
>                 to_scan =3D swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
>
> -       while ((ci =3D isolate_lock_cluster(si, &si->full_clusters))) {
> +       while ((ci =3D isolate_lock_cluster(si, &si->full_clusters, 0))) =
{
>                 offset =3D cluster_offset(si, ci);
>                 end =3D min(si->max, offset + SWAPFILE_CLUSTER);
>                 to_scan--;
> @@ -1018,6 +1100,7 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>  done:
>         if (!(si->flags & SWP_SOLIDSTATE))
>                 spin_unlock(&si->global_cluster_lock);
> +
>         return found;
>  }
>
> @@ -1885,7 +1968,13 @@ swp_entry_t get_swap_page_of_type(int type)
>         /* This is called for allocating swap entry, not cache */
>         if (get_swap_device_info(si)) {
>                 if (si->flags & SWP_WRITEOK) {
> +                       /*
> +                        * Grab the local lock to be complaint
> +                        * with swap table allocation.
> +                        */
> +                       local_lock(&percpu_swap_cluster.lock);
>                         offset =3D cluster_alloc_swap_entry(si, 0, 1);
> +                       local_unlock(&percpu_swap_cluster.lock);
>                         if (offset) {
>                                 entry =3D swp_entry(si->type, offset);
>                                 atomic_long_dec(&nr_swap_pages);
> @@ -2679,12 +2768,21 @@ static void wait_for_allocation(struct swap_info_=
struct *si)
>  static void free_cluster_info(struct swap_cluster_info *cluster_info,
>                               unsigned long maxpages)
>  {
> +       struct swap_cluster_info *ci;
>         int i, nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
>
>         if (!cluster_info)
>                 return;
> -       for (i =3D 0; i < nr_clusters; i++)
> -               swap_cluster_free_table(&cluster_info[i]);
> +       for (i =3D 0; i < nr_clusters; i++) {
> +               ci =3D cluster_info + i;
> +               /* Cluster with bad marks count will have a remaining tab=
le */
> +               spin_lock(&ci->lock);
> +               if (rcu_dereference_protected(ci->table, true)) {
> +                       ci->count =3D 0;
> +                       swap_cluster_free_table(ci);
> +               }
> +               spin_unlock(&ci->lock);
> +       }
>         kvfree(cluster_info);
>  }
>
> @@ -2720,6 +2818,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         struct address_space *mapping;
>         struct inode *inode;
>         struct filename *pathname;
> +       unsigned int maxpages;
>         int err, found =3D 0;
>
>         if (!capable(CAP_SYS_ADMIN))
> @@ -2826,8 +2925,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         p->swap_map =3D NULL;
>         zeromap =3D p->zeromap;
>         p->zeromap =3D NULL;
> +       maxpages =3D p->max;
>         cluster_info =3D p->cluster_info;
> -       free_cluster_info(cluster_info, p->max);
>         p->max =3D 0;
>         p->cluster_info =3D NULL;
>         spin_unlock(&p->lock);
> @@ -2839,6 +2938,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         p->global_cluster =3D NULL;
>         vfree(swap_map);
>         kvfree(zeromap);
> +       free_cluster_info(cluster_info, maxpages);
>         /* Destroy swap account information */
>         swap_cgroup_swapoff(p->type);
>
> @@ -3217,11 +3317,8 @@ static struct swap_cluster_info *setup_clusters(st=
ruct swap_info_struct *si,
>         if (!cluster_info)
>                 goto err;
>
> -       for (i =3D 0; i < nr_clusters; i++) {
> +       for (i =3D 0; i < nr_clusters; i++)
>                 spin_lock_init(&cluster_info[i].lock);
> -               if (swap_cluster_alloc_table(&cluster_info[i]))
> -                       goto err_free;
> -       }
>
>         if (!(si->flags & SWP_SOLIDSTATE)) {
>                 si->global_cluster =3D kmalloc(sizeof(*si->global_cluster=
),
> @@ -3240,16 +3337,23 @@ static struct swap_cluster_info *setup_clusters(s=
truct swap_info_struct *si,
>          * See setup_swap_map(): header page, bad pages,
>          * and the EOF part of the last cluster.
>          */
> -       inc_cluster_info_page(si, cluster_info, 0);
> +       err =3D inc_cluster_info_page(si, cluster_info, 0);
> +       if (err)
> +               goto err;
>         for (i =3D 0; i < swap_header->info.nr_badpages; i++) {
>                 unsigned int page_nr =3D swap_header->info.badpages[i];
>
>                 if (page_nr >=3D maxpages)
>                         continue;
> -               inc_cluster_info_page(si, cluster_info, page_nr);
> +               err =3D inc_cluster_info_page(si, cluster_info, page_nr);
> +               if (err)
> +                       goto err;
> +       }
> +       for (i =3D maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i+=
+) {
> +               err =3D inc_cluster_info_page(si, cluster_info, i);
> +               if (err)
> +                       goto err;
>         }
> -       for (i =3D maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i+=
+)
> -               inc_cluster_info_page(si, cluster_info, i);
>
>         INIT_LIST_HEAD(&si->free_clusters);
>         INIT_LIST_HEAD(&si->full_clusters);
> @@ -3963,6 +4067,15 @@ static int __init swapfile_init(void)
>
>         swapfile_maximum_size =3D arch_max_swapfile_size();
>
> +       /*
> +        * Once a cluster is freed, it's swap table content is read
> +        * only, and all swap cache readers (swap_cache_*) verifies
> +        * the content before use. So it's safe to use RCU slab here.
> +        */
> +       swap_table_cachep =3D kmem_cache_create("swap_table",
> +                           sizeof(struct swap_table),
> +                           0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
> +
>  #ifdef CONFIG_MIGRATION
>         if (swapfile_maximum_size >=3D (1UL << SWP_MIG_TOTAL_BITS))
>                 swap_migration_ad_supported =3D true;
> --
> 2.51.0
>

