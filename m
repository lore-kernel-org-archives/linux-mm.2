Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9157CA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 04:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED626B002A; Sat, 30 Aug 2025 00:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E5E6B002C; Sat, 30 Aug 2025 00:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6D86B002D; Sat, 30 Aug 2025 00:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D97B76B002A
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:17:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 795211DE840
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:17:16 +0000 (UTC)
X-FDA: 83832114072.28.0417379
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9FC17180007
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:17:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o70IgJRg;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756527434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4pII+gG5HXEWCVTHNNohh+A7nN/IkhMUfvsJpq08is=;
	b=EoURLociDnu3usyLgRXV05ptc8yoL4jicQPL0HS1qCBcOex/bzbJ0HgNh9SANeZ3G3nGfT
	NT9WH6xLc1Kw9JStBZWu3OpMUqB+5M5UAFbbElmAltJGQio0TDF/1hyZM0IFO3Yn/MleQr
	5Pi6yWMg08Hb95m9MZ72B33KPOGBjWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756527434; a=rsa-sha256;
	cv=none;
	b=xySdyBAgNe2mpCLHMTtVF5mrNv3paGIrzCx2a/Cgsdgv1uPpVgfbyV4aCWriUfk2xAQXyE
	9pYU42m+muwkEegfooDTO79vjg2CTzrSfQbAxvAn3jCEwWCFxVsR0zx00NQ8yd14KHAD1p
	gk97gH6HKjVoOtMbuhhsZ0AHZrMOaF0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o70IgJRg;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8722E6019B
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A330C4CEF6
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756527433;
	bh=IXTt2fiU9GdqZ/RYPTh7SE10eXhxe7ywNiLwxpZujJE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=o70IgJRgqqM5FRg6OyEkvkdgML9RfgKt3TzNghGTirQwAg/XiYhHpkt54h2uDG7Jh
	 qNi/kBjsABKro8iKS5Ac4jmZ6WqqHJZmaBxhqEifYAIeIjQ07lXU3RLvsNcFJFrGwC
	 nY4X8SWKQuRrUYFlZWZOeNw5+r4eFF7om+QGncG2MBqg/EOEz77lie/C9Ivse6u0cC
	 xxh8X9eCcY3sqSR48J+hu6qEyOxTMtxehqxD/TfY7p7NYQm9C0d5OZIHNjfcHyIdn7
	 7A3rk8UYyqr2m2NBYNKzUKs33fTwDrqxaK0yTzmRlj1Ctqlr5aWGR6L+XJ4GT5uUno
	 dg9YT1Kz9JWVg==
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e96f14a6f2aso1897295276.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 21:17:13 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz0bWwiykdbekFXz0+zhb24+/3rMp6Ur2WuzwIAZ33NzT22uB9C
	kAso3If0c5v4Cx+wcjotsHdmjpvdzQ8VpU9BIz9hF3nSkWGmZMRDwAY7jpeeWPFDl3gRteoCemd
	uGY1GEUF1NaUL74Mklb50932ZGvzfRHp8FpOk4VTHlw==
X-Google-Smtp-Source: AGHT+IHPLHIalXHQEJeaEGaGrSurBq/jbBXdDfwDUa+uI99IsBW+MWPRGeG4lqi9diRpSXOVESzE3ZsFivtRdffwpdY=
X-Received: by 2002:a05:690c:6809:b0:71f:e430:6671 with SMTP id
 00721157ae682-72276406fd1mr11401617b3.22.1756527432252; Fri, 29 Aug 2025
 21:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-9-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-9-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 21:17:01 -0700
X-Gmail-Original-Message-ID: <CACePvbVAxDnMRpRZwgwCDF2Bp3HUN1XhKYb2-e10t5k7YuDwgQ@mail.gmail.com>
X-Gm-Features: Ac12FXwtYakrZbqUFWEAOb_UhVGOQAcl6wJRZl_eKBG4rUWkdv8Rh8JlkrdITN4
Message-ID: <CACePvbVAxDnMRpRZwgwCDF2Bp3HUN1XhKYb2-e10t5k7YuDwgQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm, swap: implement dynamic allocation of swap table
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FC17180007
X-Stat-Signature: 6gr9jg4ru5bag9gdu3i5ifzwzb5rzyoc
X-Rspam-User: 
X-HE-Tag: 1756527434-301196
X-HE-Meta: U2FsdGVkX1/biY4wwJyTmpt3tC0YYgkXgd3elEpR8RTkqDMPeYn3RsEUqyzsCDO3MJrAfQDuyuXBmcpL6X9aFKK+LoK0YzEZcuyqaqEBu13gEIEwOKH9Q4XO1PhVt+xT1urBnLXdw0w91b9onc9/B4fePK3jAabt9hvXIGGbJXVtgHhsdcFbrG0+4Su5D1hBIaPBBeFYeEUVu1zrQteDKWtXyoxXsASsMYlUnXU1T2szAhVMoc4pyzyaJNYSbjz008tNFo/SRrOQNwCA9fn892SZs7lo6BikUfwuAlZB5BVBbEQEzrXBRDSq5sjs5W7VMG62yp/00s/9b/iajcDxeWsA17N6aWKphr9IBWe5QinVgbuU9B140BhIntGWRccQKCaTcZE4BH2JnUjSMkm/Xri+hchviTApg8zG33ZOZ/ArOEYrOs9/ZTo8cFzHOw7Q5Foen6+Z/k0FGc5x6iYgFz0qN6HsT1x/pnG9iLCBbCooUW3q8xClA4HPpAkPUm2yLlKiARzBxZ+W9X9ynJsDqQMS6l+ArmchRk//JH7cCXMrviiov9/1TOvT4WJB7O/nb9tBn5XdU4rOdPuPOd7WBBNN4TalZ5ehYpjQ7WjkNRBD33w+2LDvDo2yQyCIdZptJlE82VM96EkTlelkzihkJdXVtNqVcmSJg4K7VIrjjGdf4m5KvUbnSqS61oBiZ6Mpl6g2d9ib2FqdcdVT4tM6NPmnjNJDSITOY811Bo22sssZMJKuEgFivxpMwLx1BxvBKh9mPsPwlvJRBKJ57ydviQDtX/pCICQ5z1LnwtF8pL1r9gdpUYbKU3Evgk3hsT5OiCotjfZXujerCjCOYgDLGjtnIuvxOo0BwGcvGFRF4TgvjI+KYQVSG+7XXLADAthgYaceA1cqVKjeReGbWFBQZrFagxpZF+TuqRUNBOzDUAY3xdvHC9M3nKNDIIAdQrZ6vzFnTO0j8SqawLhVf8Y
 8JyERkFJ
 YN/LWhHRxOnfAO5MThK9jKeo45kCjBj5p0pqWyDegdSHNguyRHHGYA5hw+YSbaAjdZkoLkCXM8UkAhAiqbimnq36/i2eIQqvHhsZM+bpcGQ+sT81ULUhOj4LZB1lGt8eMKASh5YooTtaCNjEAxBw4CDwtL7WqS5C8LBIIOsp68gSPsxZ/gFXjt0Pb+CzmWast3c8bfjOt9RImBLcEkqdcMTKqHnVqlgmSkjJpUfpBKa9ClLB8KGexv7kLjt9FJqXY0kaEvyDbaqxLqSzENoQt95QTbxx5TTBdx69K2mMZTo+/gaUco45VOPI9Qy68G1S2Kf+M8Se3LoGMJO6lTTuELbmme/UmPZ9yEYHo/B6/tUOtC5pxGwX+LTRFuY6+B4Ghlxba
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

PS, this version already has my feedback incorporated.

On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Now swap table is cluster based, which means free clusters can free its
> table since no one should modify it.
>
> There could be speculative readers, like swap cache look up, protect
> them by making them RCU safe. All swap table should be filled with null
> entries before free, so such readers will either see a NULL pointer or
> a null filled table being lazy freed.
>
> On allocation, allocate the table when a cluster is used by any order.
>
> This way, we can reduce the memory usage of large swap device
> significantly.
>
> This idea to dynamically release unused swap cluster data was initially
> suggested by Chris Li while proposing the cluster swap allocator and
> I found it suits the swap table idea very well.
>
> Co-developed-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h       |   2 +-
>  mm/swap_state.c |   9 ++-
>  mm/swap_table.h |  32 +++++++-
>  mm/swapfile.c   | 202 ++++++++++++++++++++++++++++++++++++++----------
>  4 files changed, 197 insertions(+), 48 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index ce3ec62cc05e..ee33733027f4 100644
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
> index c0342024b4a8..a0120d822fbe 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -87,7 +87,8 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
>         struct folio *folio;
>
>         for (;;) {
> -               swp_tb =3D __swap_table_get(swp_cluster(entry), swp_clust=
er_offset(entry));
> +               swp_tb =3D swap_table_get(swp_cluster(entry),
> +                                       swp_cluster_offset(entry));
>                 if (!swp_tb_is_folio(swp_tb))
>                         return NULL;
>                 folio =3D swp_tb_to_folio(swp_tb);
> @@ -107,10 +108,9 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>  {
>         unsigned long swp_tb;
>
> -       swp_tb =3D __swap_table_get(swp_cluster(entry), swp_cluster_offse=
t(entry));
> +       swp_tb =3D swap_table_get(swp_cluster(entry), swp_cluster_offset(=
entry));
>         if (swp_tb_is_shadow(swp_tb))
>                 return swp_tb_to_shadow(swp_tb);
> -
>         return NULL;
>  }
>
> @@ -135,6 +135,9 @@ int swap_cache_add_folio(swp_entry_t entry, struct fo=
lio *folio, void **shadowp)
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
>
>         ci =3D swap_cluster_lock(swp_info(entry), swp_offset(entry));
> +       if (unlikely(!ci->table))
> +               goto fail;
> +
>         ci_start =3D swp_cluster_offset(entry);
>         ci_end =3D ci_start + nr_pages;
>         ci_off =3D ci_start;
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index ed9676547071..4e97513b11ef 100644
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
> @@ -76,15 +83,36 @@ static inline void *swp_tb_to_shadow(unsigned long sw=
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
>
>  static inline void __swap_table_set_folio(struct swap_cluster_info *ci,
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 0c8001c99f30..00651e947eb2 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -105,6 +105,8 @@ static DEFINE_SPINLOCK(swap_avail_lock);
>
>  struct swap_info_struct *swap_info[MAX_SWAPFILES];
>
> +static struct kmem_cache *swap_table_cachep;
> +
>  static DEFINE_MUTEX(swapon_mutex);
>
>  static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
> @@ -402,10 +404,17 @@ static inline bool cluster_is_discard(struct swap_c=
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
> @@ -423,32 +432,98 @@ static inline unsigned int cluster_offset(struct sw=
ap_info_struct *si,
>         return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>  }
>
> -static int swap_table_alloc_table(struct swap_cluster_info *ci)
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
> + * Allocate a swap table may need to sleep, which leads to migration,
> + * so attempt an atomic allocation first then fallback and handle
> + * potential race.
> + */
> +static struct swap_cluster_info *
> +swap_cluster_alloc_table(struct swap_info_struct *si,
> +                        struct swap_cluster_info *ci,
> +                        int order)
>  {
> -       unsigned int ci_off;
> -       unsigned long swp_tb;
> +       struct swap_cluster_info *pcp_ci;
> +       struct swap_table *table;
> +       unsigned long offset;
>
> -       if (!ci->table)
> -               return;
> +       /*
> +        * Only cluster isolation from the allocator does table allocatio=
n.
> +        * Swap allocator uses a percpu cluster and holds the local lock.
> +        */
> +       lockdep_assert_held(&ci->lock);
> +       lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +
> +       table =3D kmem_cache_zalloc(swap_table_cachep,
> +                                 __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_N=
OWARN);
> +       if (table) {
> +               rcu_assign_pointer(ci->table, table);
> +               return ci;
> +       }
> +
> +       /*
> +        * Try a sleep allocation. Each isolated free cluster may cause
> +        * a sleep allocation, but there is a limited number of them, so
> +        * the potential recursive allocation should be limited.
> +        */
> +       spin_unlock(&ci->lock);
> +       if (!(si->flags & SWP_SOLIDSTATE))
> +               spin_unlock(&si->global_cluster_lock);
> +       local_unlock(&percpu_swap_cluster.lock);
> +       table =3D kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_K=
ERNEL);
>
> -       for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> -               swp_tb =3D __swap_table_get(ci, ci_off);
> -               if (!swp_tb_is_null(swp_tb))
> -                       pr_err_once("swap: unclean swap space on swapoff:=
 0x%lx",
> -                                   swp_tb);
> +       local_lock(&percpu_swap_cluster.lock);
> +       if (!(si->flags & SWP_SOLIDSTATE))
> +               spin_lock(&si->global_cluster_lock);
> +       /*
> +        * Back to atomic context. First, check if we migrated to a new
> +        * CPU with a usable percpu cluster. If so, try using that instea=
d.
> +        * No need to check it for the spinning device, as swap is
> +        * serialized by the global lock on them.
> +        *
> +        * The is_usable check is a bit rough, but ensures order 0 succes=
s.
> +        */
> +       offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> +       if ((si->flags & SWP_SOLIDSTATE) && offset) {
> +               pcp_ci =3D swap_cluster_lock(si, offset);
> +               if (cluster_is_usable(pcp_ci, order) &&
> +                   pcp_ci->count < SWAPFILE_CLUSTER) {
> +                       ci =3D pcp_ci;
> +                       goto free_table;
> +               }
> +               swap_cluster_unlock(pcp_ci);
>         }
>
> -       kfree(ci->table);
> -       ci->table =3D NULL;
> +       if (!table)
> +               return NULL;
> +
> +       spin_lock(&ci->lock);
> +       /* Nothing should have touched the dangling empty cluster. */
> +       if (WARN_ON_ONCE(cluster_table_is_alloced(ci)))
> +               goto free_table;
> +
> +       rcu_assign_pointer(ci->table, table);
> +       return ci;
> +
> +free_table:
> +       if (table)
> +               kmem_cache_free(swap_table_cachep, table);
> +       return ci;
>  }
>
>  static void move_cluster(struct swap_info_struct *si,
> @@ -480,7 +555,7 @@ static void swap_cluster_schedule_discard(struct swap=
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
> @@ -495,15 +570,11 @@ static void __free_cluster(struct swap_info_struct =
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
> @@ -515,13 +586,19 @@ static struct swap_cluster_info *isolate_lock_clust=
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
> +               return swap_cluster_alloc_table(si, found, order);
> +       }
> +
> +       return found;
>  }
>
>  /*
> @@ -654,17 +731,27 @@ static void relocate_cluster(struct swap_info_struc=
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
> @@ -845,7 +932,7 @@ static unsigned int alloc_swap_scan_list(struct swap_=
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
> @@ -870,7 +957,7 @@ static void swap_reclaim_full_clusters(struct swap_in=
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
> @@ -1018,6 +1105,7 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>  done:
>         if (!(si->flags & SWP_SOLIDSTATE))
>                 spin_unlock(&si->global_cluster_lock);
> +
>         return found;
>  }
>
> @@ -1885,7 +1973,13 @@ swp_entry_t get_swap_page_of_type(int type)
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
> @@ -2678,12 +2772,21 @@ static void wait_for_allocation(struct swap_info_=
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
> @@ -2719,6 +2822,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         struct address_space *mapping;
>         struct inode *inode;
>         struct filename *pathname;
> +       unsigned int maxpages;
>         int err, found =3D 0;
>
>         if (!capable(CAP_SYS_ADMIN))
> @@ -2825,8 +2929,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
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
> @@ -2838,6 +2942,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         p->global_cluster =3D NULL;
>         vfree(swap_map);
>         kvfree(zeromap);
> +       free_cluster_info(cluster_info, maxpages);
>         /* Destroy swap account information */
>         swap_cgroup_swapoff(p->type);
>
> @@ -3216,11 +3321,8 @@ static struct swap_cluster_info *setup_clusters(st=
ruct swap_info_struct *si,
>         if (!cluster_info)
>                 goto err;
>
> -       for (i =3D 0; i < nr_clusters; i++) {
> +       for (i =3D 0; i < nr_clusters; i++)
>                 spin_lock_init(&cluster_info[i].lock);
> -               if (swap_table_alloc_table(&cluster_info[i]))
> -                       goto err_free;
> -       }
>
>         if (!(si->flags & SWP_SOLIDSTATE)) {
>                 si->global_cluster =3D kmalloc(sizeof(*si->global_cluster=
),
> @@ -3239,16 +3341,23 @@ static struct swap_cluster_info *setup_clusters(s=
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
> @@ -3962,6 +4071,15 @@ static int __init swapfile_init(void)
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

