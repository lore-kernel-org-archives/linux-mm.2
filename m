Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FC3D0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015716B0099; Tue, 25 Nov 2025 13:12:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F136B009B; Tue, 25 Nov 2025 13:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45486B00B4; Tue, 25 Nov 2025 13:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC5D96B0099
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:12:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DFD413A984
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:12:12 +0000 (UTC)
X-FDA: 84149923704.16.7E19ABB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3FE041C0005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:12:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlxTL7fk;
	spf=pass (imf21.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764094330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfA/hYmD361EE96G1eLlGb5Ff+lL5hfIlzV3fZrZd2c=;
	b=RKwpWjas7oePhPINOJVEM+Dwp4blk1oc2LnsaPz3276PB3Uq5NQx7uNkrfRDJeLi/yory3
	QpaL7FTA9njqRPCDs1iVD45Q+H+Z8JWOZHykhQPFDKuu6+fg+TXXtd6TzOijqxBM8wFgGi
	n7w0y749130tevL+uRzFGqeYYgGEtME=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlxTL7fk;
	spf=pass (imf21.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764094330; a=rsa-sha256;
	cv=none;
	b=bjg2HiJMetSErTfcPXXnJi4ERxH41a60JZqFvNHjfHwDWT6tKiklhjFxNHTzou8LSvgxSl
	0pVWhd4BBfR5N5+FNL78R6WWS14OtkbKJsh+SE0kUjDsSDFt8eQy77ZD/fAsz8mKGypOqt
	T7yed30SuEOFlXL1sb2RKksGCAXkHcE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A8E143D77
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09825C19423
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764094329;
	bh=20h0Yms98FU//c2uJHcW2xbdUbSzj+9tNH2dgg3W98Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tlxTL7fkIdih6K/xeGwZjjIVL6hhYsKY82wkGW7MpacDFRW93iJXoaHbY4zIrLqui
	 cKfST5o0AlOk0/yYHG8r6CxrXQOflf5ekuT9IxdyFqElGFEQLVNEeRJItqZbL6u9Vk
	 v9OOlkMv0LPWmbieiR8jhdTFwrcLdQjIREquIekyWKyqDJMtsDdvlyJXx3TC+5A0oA
	 zEThHstJbvUUfGxckITLNcaUV5wT50J6Fzp1C4yeB56tXJya+YAC/XWx6gAk+t0hq8
	 2CUF4U29mtNzSJOpXNil9R3bgkMJROfgfbsKS1SIoWS2/1VaAOjCRmrXM3J/yb5LxP
	 IcxXlIfUFtzaw==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-657a6028fbbso1227935eaf.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:12:08 -0800 (PST)
X-Gm-Message-State: AOJu0YxeW1E1w/rK+lIMkVVLVHaU8AaWdZ1fCaKx+sOHUyYu5es95nJX
	1WX3yyj9zx1UqGz0PNz5a5JP2pL+LX9+7rHXxWn0SgGSwMNu8AAwPHxjqke9cB7CldjyCttj54+
	55ItQQsSDDyaoEDoQlrBVvI5ZkDeBplY=
X-Google-Smtp-Source: AGHT+IG1fMk5Olrjw1poUTt8BoLWV4BFgW//y1qM1sUNEhuO7m1sM+dbK2lo1llPYbR1wUYFbTBxuqF4kKpoCbTOn/k=
X-Received: by 2002:a05:6820:217:b0:657:5e6f:b9d7 with SMTP id
 006d021491bc7-657bddb52dbmr1431721eaf.6.1764094328063; Tue, 25 Nov 2025
 10:12:08 -0800 (PST)
MIME-Version: 1.0
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com> <20251125-swap-table-p2-v3-14-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-14-33f54f707a5c@tencent.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 25 Nov 2025 19:11:56 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0iHJw3sQNq8r6YxJmd-1Lk_pNaJGhhS6-X7=mpPeq4AZQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmrG8xAaCayhRHIMXzfydzOLm-lXoiFp9OspLLHqjGODPBuMf8ZZYsigws
Message-ID: <CAJZ5v0iHJw3sQNq8r6YxJmd-1Lk_pNaJGhhS6-X7=mpPeq4AZQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/19] mm, swap: cleanup swap entry management workflow
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3FE041C0005
X-Stat-Signature: edzoku4m9y1yixiyy3etpxcrg6xsigzj
X-Rspam-User: 
X-HE-Tag: 1764094330-432560
X-HE-Meta: U2FsdGVkX1+teAu3YJDumtSw5p+juKN2PSOTw58/EvqMvz+fwRcLWaRlsNin3tpej5UDoeTySwQpyKf8PlWxKEWczF587SxamHew2cUE2cHOqfUnbAm8xHIK/orT8xAYU+T853T6XGvEYrm6juqjEykvj8DF4o3dHl02tMprZE6BtflzHVE0yc9EUoFHZI2eQouUgzOKXAGPMugk0apK2WqkvHT8Xmd/SE89AjcDAh4OYPNzct6mrQ69Wi6qDgUvXUg7d8ggTAuvlx3/YhYGlz+2W+1ui841tbci0uQAYKboQGQCSeMx0N/jfOE3AzWUDq3zyPHFEWUqlwTvLKR6lvwUY4kKXrvc/X/2CNmt9mojpqkpQJ/JhMOgv1j0WOrpxVXw8uxkZ4BkNL3H01mYy/D7KV+2gDK1PoibYmxVXwha3uaYK/R1lJWQCfuwXXClRFKVz+UXCZNvzILeH3MR2OCzH9iNSiWfqiO8YVJQwJWy59j2gC/j3naJuuqG9lzn43QM/bjPleBUgB98580c6YzV8eEXzl51vY2XrXXxAJ8jUGruoBiyh0mkMYWlhVf8cCTtLEF4emFeqXeIbvJVXyD/ExjxtzwQbGIlLP5angVat7XEQZTmrJqx5PRbQICqBkwsqnHQrs6AmBNlUKq3SxIFeMJG6CrbTyBMRLifZVzUghbi8CV5I/uJDCvRVlugB16OEY3e4pOlwoEBWwUCrmuUudCPJpZJ/YJZfDQoY8duiUgDlSiytl2tNAEujilVVb7HUfUJ8B6xm90Bznm5GYkLGXPgmkme4Mh6D3PSrUPXsf6so227ZeWUmYmFgcsrbdJf7OvALkTqGI6Yo/5m17DAoc1a5mmzzUbzspoQkS5kSEvhWiRBaTMkNWjwbKQFxuQT8NDZLR9dHSKPRm58DaqdFoXohiO4rCaOJtkvTltlgmralRzIO6WSxI9SKwhSbORhBeq8xWi4chtt4Qd
 6DX7ZNoJ
 4Hj7mTrvojm5Qcr7jPqfSqdeRxETEp1AVHhYlHArBvGvcIUwDaLpFjvGTc2P70VlqL7y6b3Yck3LvKFl/sACVJLW+5YBSvCl1XCE7KKKPaM+etM74qwzl0m24YrtgYb3Fkee8W1xlRSq0C4xwSQYlbiWGqGW4LMdrkXuG9X5PKqQTh4RCWYFUC+PLIjQlqYpA0xYRO7hV9pkAjyzrnaFu5lpOXVkeQxVCE4uqrYQ+Mzyn4ik2UqbPHDzEgB3G8RSwu/d/mDAB7vk3AycdDkNkfG/D8mW+Z5/zUNiyxt4OV3YH9HgZYH7eNopGmmSKDCTNyRTPRI/HY/tNo8Qv09z6ThYqT9fvJZez1Ql/5Q/sF7B00is=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 8:18=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> The current swap entry allocation/freeing workflow has never had a clear
> definition. This makes it hard to debug or add new optimizations.
>
> This commit introduces a proper definition of how swap entries would be
> allocated and freed. Now, most operations are folio based, so they will
> never exceed one swap cluster, and we now have a cleaner border between
> swap and the rest of mm, making it much easier to follow and debug,
> especially with new added sanity checks. Also making more optimization
> possible.
>
> Swap entry will be mostly allocated and free with a folio bound.
> The folio lock will be useful for resolving many swap ralated races.
>
> Now swap allocation (except hibernation) always starts with a folio in
> the swap cache, and gets duped/freed protected by the folio lock:
>
> - folio_alloc_swap() - The only allocation entry point now.
>   Context: The folio must be locked.
>   This allocates one or a set of continuous swap slots for a folio and
>   binds them to the folio by adding the folio to the swap cache. The
>   swap slots' swap count start with zero value.
>
> - folio_dup_swap() - Increase the swap count of one or more entries.
>   Context: The folio must be locked and in the swap cache. For now, the
>   caller still has to lock the new swap entry owner (e.g., PTL).
>   This increases the ref count of swap entries allocated to a folio.
>   Newly allocated swap slots' count has to be increased by this helper
>   as the folio got unmapped (and swap entries got installed).
>
> - folio_put_swap() - Decrease the swap count of one or more entries.
>   Context: The folio must be locked and in the swap cache. For now, the
>   caller still has to lock the new swap entry owner (e.g., PTL).
>   This decreases the ref count of swap entries allocated to a folio.
>   Typically, swapin will decrease the swap count as the folio got
>   installed back and the swap entry got uninstalled
>
>   This won't remove the folio from the swap cache and free the
>   slot. Lazy freeing of swap cache is helpful for reducing IO.
>   There is already a folio_free_swap() for immediate cache reclaim.
>   This part could be further optimized later.
>
> The above locking constraints could be further relaxed when the swap
> table if fully implemented. Currently dup still needs the caller
> to lock the swap entry container (e.g. PTL), or a concurrent zap
> may underflow the swap count.
>
> Some swap users need to interact with swap count without involving folio
> (e.g. forking/zapping the page table or mapping truncate without swapin).
> In such cases, the caller has to ensure there is no race condition on
> whatever owns the swap count and use the below helpers:
>
> - swap_put_entries_direct() - Decrease the swap count directly.
>   Context: The caller must lock whatever is referencing the slots to
>   avoid a race.
>
>   Typically the page table zapping or shmem mapping truncate will need
>   to free swap slots directly. If a slot is cached (has a folio bound),
>   this will also try to release the swap cache.
>
> - swap_dup_entry_direct() - Increase the swap count directly.
>   Context: The caller must lock whatever is referencing the entries to
>   avoid race, and the entries must already have a swap count > 1.
>
>   Typically, forking will need to copy the page table and hence needs to
>   increase the swap count of the entries in the table. The page table is
>   locked while referencing the swap entries, so the entries all have a
>   swap count > 1 and can't be freed.
>
> Hibernation subsystem is a bit different, so two special wrappers are her=
e:
>
> - swap_alloc_hibernation_slot() - Allocate one entry from one device.
> - swap_free_hibernation_slot() - Free one entry allocated by the above
> helper.
>
> All hibernation entries are exclusive to the hibernation subsystem and
> should not interact with ordinary swap routines.
>
> By separating the workflows, it will be possible to bind folio more
> tightly with swap cache and get rid of the SWAP_HAS_CACHE as a temporary
> pin.
>
> This commit should not introduce any behavior change
>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Kairui Song <kasong@tencent.com>

For hibernation changes

Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>

> ---
>  arch/s390/mm/gmap_helpers.c |   2 +-
>  arch/s390/mm/pgtable.c      |   2 +-
>  include/linux/swap.h        |  58 ++++++++---------
>  kernel/power/swap.c         |  10 +--
>  mm/madvise.c                |   2 +-
>  mm/memory.c                 |  15 +++--
>  mm/rmap.c                   |   7 ++-
>  mm/shmem.c                  |  10 +--
>  mm/swap.h                   |  37 +++++++++++
>  mm/swapfile.c               | 148 +++++++++++++++++++++++++++++++-------=
------
>  10 files changed, 193 insertions(+), 98 deletions(-)
>
> diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> index 549f14ad08af..c3f56a096e8c 100644
> --- a/arch/s390/mm/gmap_helpers.c
> +++ b/arch/s390/mm/gmap_helpers.c
> @@ -32,7 +32,7 @@ static void ptep_zap_softleaf_entry(struct mm_struct *m=
m, softleaf_t entry)
>                 dec_mm_counter(mm, MM_SWAPENTS);
>         else if (softleaf_is_migration(entry))
>                 dec_mm_counter(mm, mm_counter(softleaf_to_folio(entry)));
> -       free_swap_and_cache(entry);
> +       swap_put_entries_direct(entry, 1);
>  }
>
>  /**
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index d670bfb47d9b..c3fa94a6ec15 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -692,7 +692,7 @@ static void ptep_zap_softleaf_entry(struct mm_struct =
*mm, softleaf_t entry)
>
>                 dec_mm_counter(mm, mm_counter(folio));
>         }
> -       free_swap_and_cache(entry);
> +       swap_put_entries_direct(entry, 1);
>  }
>
>  void ptep_zap_unused(struct mm_struct *mm, unsigned long addr,
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 69025b473472..ac3caa4c6999 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -452,14 +452,8 @@ static inline long get_nr_swap_pages(void)
>  }
>
>  extern void si_swapinfo(struct sysinfo *);
> -int folio_alloc_swap(struct folio *folio);
> -bool folio_free_swap(struct folio *folio);
>  void put_swap_folio(struct folio *folio, swp_entry_t entry);
> -extern swp_entry_t get_swap_page_of_type(int);
>  extern int add_swap_count_continuation(swp_entry_t, gfp_t);
> -extern int swap_duplicate_nr(swp_entry_t entry, int nr);
> -extern void swap_free_nr(swp_entry_t entry, int nr_pages);
> -extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
>  int swap_type_of(dev_t device, sector_t offset);
>  int find_first_swap(dev_t *device);
>  extern unsigned int count_swap_pages(int, int);
> @@ -472,6 +466,29 @@ struct backing_dev_info;
>  extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
>  sector_t swap_folio_sector(struct folio *folio);
>
> +/*
> + * If there is an existing swap slot reference (swap entry) and the call=
er
> + * guarantees that there is no race modification of it (e.g., PTL
> + * protecting the swap entry in page table; shmem's cmpxchg protects t
> + * he swap entry in shmem mapping), these two helpers below can be used
> + * to put/dup the entries directly.
> + *
> + * All entries must be allocated by folio_alloc_swap(). And they must ha=
ve
> + * a swap count > 1. See comments of folio_*_swap helpers for more info.
> + */
> +int swap_dup_entry_direct(swp_entry_t entry);
> +void swap_put_entries_direct(swp_entry_t entry, int nr);
> +
> +/*
> + * folio_free_swap tries to free the swap entries pinned by a swap cache
> + * folio, it has to be here to be called by other components.
> + */
> +bool folio_free_swap(struct folio *folio);
> +
> +/* Allocate / free (hibernation) exclusive entries */
> +swp_entry_t swap_alloc_hibernation_slot(int type);
> +void swap_free_hibernation_slot(swp_entry_t entry);
> +
>  static inline void put_swap_device(struct swap_info_struct *si)
>  {
>         percpu_ref_put(&si->users);
> @@ -499,10 +516,6 @@ static inline void put_swap_device(struct swap_info_=
struct *si)
>  #define free_pages_and_swap_cache(pages, nr) \
>         release_pages((pages), (nr));
>
> -static inline void free_swap_and_cache_nr(swp_entry_t entry, int nr)
> -{
> -}
> -
>  static inline void free_swap_cache(struct folio *folio)
>  {
>  }
> @@ -512,12 +525,12 @@ static inline int add_swap_count_continuation(swp_e=
ntry_t swp, gfp_t gfp_mask)
>         return 0;
>  }
>
> -static inline int swap_duplicate_nr(swp_entry_t swp, int nr_pages)
> +static inline int swap_dup_entry_direct(swp_entry_t ent)
>  {
>         return 0;
>  }
>
> -static inline void swap_free_nr(swp_entry_t entry, int nr_pages)
> +static inline void swap_put_entries_direct(swp_entry_t ent, int nr)
>  {
>  }
>
> @@ -541,11 +554,6 @@ static inline int swp_swapcount(swp_entry_t entry)
>         return 0;
>  }
>
> -static inline int folio_alloc_swap(struct folio *folio)
> -{
> -       return -EINVAL;
> -}
> -
>  static inline bool folio_free_swap(struct folio *folio)
>  {
>         return false;
> @@ -558,22 +566,6 @@ static inline int add_swap_extent(struct swap_info_s=
truct *sis,
>         return -EINVAL;
>  }
>  #endif /* CONFIG_SWAP */
> -
> -static inline int swap_duplicate(swp_entry_t entry)
> -{
> -       return swap_duplicate_nr(entry, 1);
> -}
> -
> -static inline void free_swap_and_cache(swp_entry_t entry)
> -{
> -       free_swap_and_cache_nr(entry, 1);
> -}
> -
> -static inline void swap_free(swp_entry_t entry)
> -{
> -       swap_free_nr(entry, 1);
> -}
> -
>  #ifdef CONFIG_MEMCG
>  static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>  {
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 0beff7eeaaba..546a0c701970 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -179,10 +179,10 @@ sector_t alloc_swapdev_block(int swap)
>  {
>         unsigned long offset;
>
> -       offset =3D swp_offset(get_swap_page_of_type(swap));
> +       offset =3D swp_offset(swap_alloc_hibernation_slot(swap));
>         if (offset) {
>                 if (swsusp_extents_insert(offset))
> -                       swap_free(swp_entry(swap, offset));
> +                       swap_free_hibernation_slot(swp_entry(swap, offset=
));
>                 else
>                         return swapdev_block(swap, offset);
>         }
> @@ -197,6 +197,7 @@ sector_t alloc_swapdev_block(int swap)
>
>  void free_all_swap_pages(int swap)
>  {
> +       unsigned long offset;
>         struct rb_node *node;
>
>         while ((node =3D swsusp_extents.rb_node)) {
> @@ -204,8 +205,9 @@ void free_all_swap_pages(int swap)
>
>                 ext =3D rb_entry(node, struct swsusp_extent, node);
>                 rb_erase(node, &swsusp_extents);
> -               swap_free_nr(swp_entry(swap, ext->start),
> -                            ext->end - ext->start + 1);
> +
> +               for (offset =3D ext->start; offset < ext->end; offset++)
> +                       swap_free_hibernation_slot(swp_entry(swap, offset=
));
>
>                 kfree(ext);
>         }
> diff --git a/mm/madvise.c b/mm/madvise.c
> index b617b1be0f53..7cd69a02ce84 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -694,7 +694,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigne=
d long addr,
>                                 max_nr =3D (end - addr) / PAGE_SIZE;
>                                 nr =3D swap_pte_batch(pte, max_nr, ptent)=
;
>                                 nr_swap -=3D nr;
> -                               free_swap_and_cache_nr(entry, nr);
> +                               swap_put_entries_direct(entry, nr);
>                                 clear_not_present_full_ptes(mm, addr, pte=
, nr, tlb->fullmm);
>                         } else if (softleaf_is_hwpoison(entry) ||
>                                    softleaf_is_poison_marker(entry)) {
> diff --git a/mm/memory.c b/mm/memory.c
> index ce9f56f77ae5..d89946ad63ec 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -934,7 +934,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct =
mm_struct *src_mm,
>         struct page *page;
>
>         if (likely(softleaf_is_swap(entry))) {
> -               if (swap_duplicate(entry) < 0)
> +               if (swap_dup_entry_direct(entry) < 0)
>                         return -EIO;
>
>                 /* make sure dst_mm is on swapoff's mmlist. */
> @@ -1744,7 +1744,7 @@ static inline int zap_nonpresent_ptes(struct mmu_ga=
ther *tlb,
>
>                 nr =3D swap_pte_batch(pte, max_nr, ptent);
>                 rss[MM_SWAPENTS] -=3D nr;
> -               free_swap_and_cache_nr(entry, nr);
> +               swap_put_entries_direct(entry, nr);
>         } else if (softleaf_is_migration(entry)) {
>                 struct folio *folio =3D softleaf_to_folio(entry);
>
> @@ -4933,7 +4933,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         /*
>          * Some architectures may have to restore extra metadata to the p=
age
>          * when reading from swap. This metadata may be indexed by swap e=
ntry
> -        * so this must be called before swap_free().
> +        * so this must be called before folio_put_swap().
>          */
>         arch_swap_restore(folio_swap(entry, folio), folio);
>
> @@ -4971,6 +4971,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (unlikely(folio !=3D swapcache)) {
>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSI=
VE);
>                 folio_add_lru_vma(folio, vma);
> +               folio_put_swap(swapcache, NULL);
>         } else if (!folio_test_anon(folio)) {
>                 /*
>                  * We currently only expect !anon folios that are fully
> @@ -4979,9 +4980,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pages=
, folio);
>                 VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>                 folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
> +               folio_put_swap(folio, NULL);
>         } else {
> +               VM_WARN_ON_ONCE(nr_pages !=3D 1 && nr_pages !=3D folio_nr=
_pages(folio));
>                 folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, addr=
ess,
> -                                       rmap_flags);
> +                                        rmap_flags);
> +               folio_put_swap(folio, nr_pages =3D=3D 1 ? page : NULL);
>         }
>
>         VM_BUG_ON(!folio_test_anon(folio) ||
> @@ -4995,7 +4999,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>          * Do it after mapping, so raced page faults will likely see the =
folio
>          * in swap cache and wait on the folio lock.
>          */
> -       swap_free_nr(entry, nr_pages);
>         if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags)=
)
>                 folio_free_swap(folio);
>
> @@ -5005,7 +5008,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                  * Hold the lock to avoid the swap entry to be reused
>                  * until we take the PT lock for the pte_same() check
>                  * (to avoid false positives from pte_same). For
> -                * further safety release the lock after the swap_free
> +                * further safety release the lock after the folio_put_sw=
ap
>                  * so that the swap count won't change under a
>                  * parallel locked swapcache.
>                  */
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f955f02d570e..f92c94954049 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -82,6 +82,7 @@
>  #include <trace/events/migrate.h>
>
>  #include "internal.h"
> +#include "swap.h"
>
>  static struct kmem_cache *anon_vma_cachep;
>  static struct kmem_cache *anon_vma_chain_cachep;
> @@ -2148,7 +2149,7 @@ static bool try_to_unmap_one(struct folio *folio, s=
truct vm_area_struct *vma,
>                                 goto discard;
>                         }
>
> -                       if (swap_duplicate(entry) < 0) {
> +                       if (folio_dup_swap(folio, subpage) < 0) {
>                                 set_pte_at(mm, address, pvmw.pte, pteval)=
;
>                                 goto walk_abort;
>                         }
> @@ -2159,7 +2160,7 @@ static bool try_to_unmap_one(struct folio *folio, s=
truct vm_area_struct *vma,
>                          * so we'll not check/care.
>                          */
>                         if (arch_unmap_one(mm, vma, address, pteval) < 0)=
 {
> -                               swap_free(entry);
> +                               folio_put_swap(folio, subpage);
>                                 set_pte_at(mm, address, pvmw.pte, pteval)=
;
>                                 goto walk_abort;
>                         }
> @@ -2167,7 +2168,7 @@ static bool try_to_unmap_one(struct folio *folio, s=
truct vm_area_struct *vma,
>                         /* See folio_try_share_anon_rmap(): clear PTE fir=
st. */
>                         if (anon_exclusive &&
>                             folio_try_share_anon_rmap_pte(folio, subpage)=
) {
> -                               swap_free(entry);
> +                               folio_put_swap(folio, subpage);
>                                 set_pte_at(mm, address, pvmw.pte, pteval)=
;
>                                 goto walk_abort;
>                         }
> diff --git a/mm/shmem.c b/mm/shmem.c
> index eb9bd9241f99..56a690e93cc2 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -971,7 +971,7 @@ static long shmem_free_swap(struct address_space *map=
ping,
>         old =3D xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0=
);
>         if (old !=3D radswap)
>                 return 0;
> -       free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
> +       swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);
>
>         return 1 << order;
>  }
> @@ -1654,7 +1654,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                         spin_unlock(&shmem_swaplist_lock);
>                 }
>
> -               swap_duplicate_nr(folio->swap, nr_pages);
> +               folio_dup_swap(folio, NULL);
>                 shmem_delete_from_page_cache(folio, swp_to_radix_entry(fo=
lio->swap));
>
>                 BUG_ON(folio_mapped(folio));
> @@ -1675,7 +1675,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                 /* Swap entry might be erased by racing shmem_free_swap()=
 */
>                 if (!error) {
>                         shmem_recalc_inode(inode, 0, -nr_pages);
> -                       swap_free_nr(folio->swap, nr_pages);
> +                       folio_put_swap(folio, NULL);
>                 }
>
>                 /*
> @@ -2161,6 +2161,7 @@ static void shmem_set_folio_swapin_error(struct ino=
de *inode, pgoff_t index,
>
>         nr_pages =3D folio_nr_pages(folio);
>         folio_wait_writeback(folio);
> +       folio_put_swap(folio, NULL);
>         swap_cache_del_folio(folio);
>         /*
>          * Don't treat swapin error folio as alloced. Otherwise inode->i_=
blocks
> @@ -2168,7 +2169,6 @@ static void shmem_set_folio_swapin_error(struct ino=
de *inode, pgoff_t index,
>          * in shmem_evict_inode().
>          */
>         shmem_recalc_inode(inode, -nr_pages, -nr_pages);
> -       swap_free_nr(swap, nr_pages);
>  }
>
>  static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
> @@ -2391,9 +2391,9 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>         if (sgp =3D=3D SGP_WRITE)
>                 folio_mark_accessed(folio);
>
> +       folio_put_swap(folio, NULL);
>         swap_cache_del_folio(folio);
>         folio_mark_dirty(folio);
> -       swap_free_nr(swap, nr_pages);
>         put_swap_device(si);
>
>         *foliop =3D folio;
> diff --git a/mm/swap.h b/mm/swap.h
> index 6777b2ab9d92..9ed12936b889 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -183,6 +183,28 @@ static inline void swap_cluster_unlock_irq(struct sw=
ap_cluster_info *ci)
>         spin_unlock_irq(&ci->lock);
>  }
>
> +/*
> + * Below are the core routines for doing swap for a folio.
> + * All helpers requires the folio to be locked, and a locked folio
> + * in the swap cache pins the swap entries / slots allocated to the
> + * folio, swap relies heavily on the swap cache and folio lock for
> + * synchronization.
> + *
> + * folio_alloc_swap(): the entry point for a folio to be swapped
> + * out. It allocates swap slots and pins the slots with swap cache.
> + * The slots start with a swap count of zero.
> + *
> + * folio_dup_swap(): increases the swap count of a folio, usually
> + * during it gets unmapped and a swap entry is installed to replace
> + * it (e.g., swap entry in page table). A swap slot with swap
> + * count =3D=3D 0 should only be increasd by this helper.
> + *
> + * folio_put_swap(): does the opposite thing of folio_dup_swap().
> + */
> +int folio_alloc_swap(struct folio *folio);
> +int folio_dup_swap(struct folio *folio, struct page *subpage);
> +void folio_put_swap(struct folio *folio, struct page *subpage);
> +
>  /* linux/mm/page_io.c */
>  int sio_pool_init(void);
>  struct swap_iocb;
> @@ -363,9 +385,24 @@ static inline struct swap_info_struct *__swap_entry_=
to_info(swp_entry_t entry)
>         return NULL;
>  }
>
> +static inline int folio_alloc_swap(struct folio *folio)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline int folio_dup_swap(struct folio *folio, struct page *page)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline void folio_put_swap(struct folio *folio, struct page *page=
)
> +{
> +}
> +
>  static inline void swap_read_folio(struct folio *folio, struct swap_iocb=
 **plug)
>  {
>  }
> +
>  static inline void swap_write_unplug(struct swap_iocb *sio)
>  {
>  }
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 567aea6f1cd4..7890039d2f65 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -58,6 +58,9 @@ static void swap_entries_free(struct swap_info_struct *=
si,
>                               swp_entry_t entry, unsigned int nr_pages);
>  static void swap_range_alloc(struct swap_info_struct *si,
>                              unsigned int nr_entries);
> +static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int =
nr);
> +static bool swap_entries_put_map(struct swap_info_struct *si,
> +                                swp_entry_t entry, int nr);
>  static bool folio_swapcache_freeable(struct folio *folio);
>  static void move_cluster(struct swap_info_struct *si,
>                          struct swap_cluster_info *ci, struct list_head *=
list,
> @@ -1478,6 +1481,12 @@ int folio_alloc_swap(struct folio *folio)
>          */
>         WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
>
> +       /*
> +        * Allocator should always allocate aligned entries so folio base=
d
> +        * operations never crossed more than one cluster.
> +        */
> +       VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio->swap.val, size), folio);
> +
>         return 0;
>
>  out_free:
> @@ -1485,6 +1494,62 @@ int folio_alloc_swap(struct folio *folio)
>         return -ENOMEM;
>  }
>
> +/**
> + * folio_dup_swap() - Increase swap count of swap entries of a folio.
> + * @folio: folio with swap entries bounded.
> + * @subpage: if not NULL, only increase the swap count of this subpage.
> + *
> + * Context: Caller must ensure the folio is locked and in the swap cache=
.
> + * The caller also has to ensure there is no raced call to
> + * swap_put_entries_direct before this helper returns, or the swap
> + * map may underflow (TODO: maybe we should allow or avoid underflow to
> + * make swap refcount lockless).
> + */
> +int folio_dup_swap(struct folio *folio, struct page *subpage)
> +{
> +       int err =3D 0;
> +       swp_entry_t entry =3D folio->swap;
> +       unsigned long nr_pages =3D folio_nr_pages(folio);
> +
> +       VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +       VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
> +
> +       if (subpage) {
> +               entry.val +=3D folio_page_idx(folio, subpage);
> +               nr_pages =3D 1;
> +       }
> +
> +       while (!err && __swap_duplicate(entry, 1, nr_pages) =3D=3D -ENOME=
M)
> +               err =3D add_swap_count_continuation(entry, GFP_ATOMIC);
> +
> +       return err;
> +}
> +
> +/**
> + * folio_put_swap() - Decrease swap count of swap entries of a folio.
> + * @folio: folio with swap entries bounded, must be in swap cache and lo=
cked.
> + * @subpage: if not NULL, only decrease the swap count of this subpage.
> + *
> + * This won't free the swap slots even if swap count drops to zero, they=
 are
> + * still pinned by the swap cache. User may call folio_free_swap to free=
 them.
> + * Context: Caller must ensure the folio is locked and in the swap cache=
.
> + */
> +void folio_put_swap(struct folio *folio, struct page *subpage)
> +{
> +       swp_entry_t entry =3D folio->swap;
> +       unsigned long nr_pages =3D folio_nr_pages(folio);
> +
> +       VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +       VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
> +
> +       if (subpage) {
> +               entry.val +=3D folio_page_idx(folio, subpage);
> +               nr_pages =3D 1;
> +       }
> +
> +       swap_entries_put_map(__swap_entry_to_info(entry), entry, nr_pages=
);
> +}
> +
>  static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
>  {
>         struct swap_info_struct *si;
> @@ -1725,28 +1790,6 @@ static void swap_entries_free(struct swap_info_str=
uct *si,
>                 partial_free_cluster(si, ci);
>  }
>
> -/*
> - * Caller has made sure that the swap device corresponding to entry
> - * is still around or has not been recycled.
> - */
> -void swap_free_nr(swp_entry_t entry, int nr_pages)
> -{
> -       int nr;
> -       struct swap_info_struct *sis;
> -       unsigned long offset =3D swp_offset(entry);
> -
> -       sis =3D _swap_info_get(entry);
> -       if (!sis)
> -               return;
> -
> -       while (nr_pages) {
> -               nr =3D min_t(int, nr_pages, SWAPFILE_CLUSTER - offset % S=
WAPFILE_CLUSTER);
> -               swap_entries_put_map(sis, swp_entry(sis->type, offset), n=
r);
> -               offset +=3D nr;
> -               nr_pages -=3D nr;
> -       }
> -}
> -
>  /*
>   * Called after dropping swapcache to decrease refcnt to swap entries.
>   */
> @@ -1935,16 +1978,19 @@ bool folio_free_swap(struct folio *folio)
>  }
>
>  /**
> - * free_swap_and_cache_nr() - Release reference on range of swap entries=
 and
> - *                            reclaim their cache if no more references =
remain.
> + * swap_put_entries_direct() - Release reference on range of swap entrie=
s and
> + *                             reclaim their cache if no more references=
 remain.
>   * @entry: First entry of range.
>   * @nr: Number of entries in range.
>   *
>   * For each swap entry in the contiguous range, release a reference. If =
any swap
>   * entries become free, try to reclaim their underlying folios, if prese=
nt. The
>   * offset range is defined by [entry.offset, entry.offset + nr).
> + *
> + * Context: Caller must ensure there is no race condition on the referen=
ce
> + * owner. e.g., locking the PTL of a PTE containing the entry being rele=
ased.
>   */
> -void free_swap_and_cache_nr(swp_entry_t entry, int nr)
> +void swap_put_entries_direct(swp_entry_t entry, int nr)
>  {
>         const unsigned long start_offset =3D swp_offset(entry);
>         const unsigned long end_offset =3D start_offset + nr;
> @@ -1953,10 +1999,9 @@ void free_swap_and_cache_nr(swp_entry_t entry, int=
 nr)
>         unsigned long offset;
>
>         si =3D get_swap_device(entry);
> -       if (!si)
> +       if (WARN_ON_ONCE(!si))
>                 return;
> -
> -       if (WARN_ON(end_offset > si->max))
> +       if (WARN_ON_ONCE(end_offset > si->max))
>                 goto out;
>
>         /*
> @@ -2000,8 +2045,8 @@ void free_swap_and_cache_nr(swp_entry_t entry, int =
nr)
>  }
>
>  #ifdef CONFIG_HIBERNATION
> -
> -swp_entry_t get_swap_page_of_type(int type)
> +/* Allocate a slot for hibernation */
> +swp_entry_t swap_alloc_hibernation_slot(int type)
>  {
>         struct swap_info_struct *si =3D swap_type_to_info(type);
>         unsigned long offset;
> @@ -2029,6 +2074,27 @@ swp_entry_t get_swap_page_of_type(int type)
>         return entry;
>  }
>
> +/* Free a slot allocated by swap_alloc_hibernation_slot */
> +void swap_free_hibernation_slot(swp_entry_t entry)
> +{
> +       struct swap_info_struct *si;
> +       struct swap_cluster_info *ci;
> +       pgoff_t offset =3D swp_offset(entry);
> +
> +       si =3D get_swap_device(entry);
> +       if (WARN_ON(!si))
> +               return;
> +
> +       ci =3D swap_cluster_lock(si, offset);
> +       swap_entry_put_locked(si, ci, entry, 1);
> +       WARN_ON(swap_entry_swapped(si, offset));
> +       swap_cluster_unlock(ci);
> +
> +       /* In theory readahead might add it to the swap cache by accident=
 */
> +       __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
> +       put_swap_device(si);
> +}
> +
>  /*
>   * Find the swap type that corresponds to given device (if any).
>   *
> @@ -2190,7 +2256,7 @@ static int unuse_pte(struct vm_area_struct *vma, pm=
d_t *pmd,
>         /*
>          * Some architectures may have to restore extra metadata to the p=
age
>          * when reading from swap. This metadata may be indexed by swap e=
ntry
> -        * so this must be called before swap_free().
> +        * so this must be called before folio_put_swap().
>          */
>         arch_swap_restore(folio_swap(entry, folio), folio);
>
> @@ -2231,7 +2297,7 @@ static int unuse_pte(struct vm_area_struct *vma, pm=
d_t *pmd,
>                 new_pte =3D pte_mkuffd_wp(new_pte);
>  setpte:
>         set_pte_at(vma->vm_mm, addr, pte, new_pte);
> -       swap_free(entry);
> +       folio_put_swap(folio, page);
>  out:
>         if (pte)
>                 pte_unmap_unlock(pte, ptl);
> @@ -3741,28 +3807,22 @@ static int __swap_duplicate(swp_entry_t entry, un=
signed char usage, int nr)
>         return err;
>  }
>
> -/**
> - * swap_duplicate_nr() - Increase reference count of nr contiguous swap =
entries
> - *                       by 1.
> - *
> +/*
> + * swap_dup_entry_direct() - Increase reference count of a swap entry by=
 one.
>   * @entry: first swap entry from which we want to increase the refcount.
> - * @nr: Number of entries in range.
>   *
>   * Returns 0 for success, or -ENOMEM if a swap_count_continuation is req=
uired
>   * but could not be atomically allocated.  Returns 0, just as if it succ=
eeded,
>   * if __swap_duplicate() fails for another reason (-EINVAL or -ENOENT), =
which
>   * might occur if a page table entry has got corrupted.
>   *
> - * Note that we are currently not handling the case where nr > 1 and we =
need to
> - * add swap count continuation. This is OK, because no such user exists =
- shmem
> - * is the only user that can pass nr > 1, and it never re-duplicates any=
 swap
> - * entry it owns.
> + * Context: Caller must ensure there is no race condition on the referen=
ce
> + * owner. e.g., locking the PTL of a PTE containing the entry being incr=
eased.
>   */
> -int swap_duplicate_nr(swp_entry_t entry, int nr)
> +int swap_dup_entry_direct(swp_entry_t entry)
>  {
>         int err =3D 0;
> -
> -       while (!err && __swap_duplicate(entry, 1, nr) =3D=3D -ENOMEM)
> +       while (!err && __swap_duplicate(entry, 1, 1) =3D=3D -ENOMEM)
>                 err =3D add_swap_count_continuation(entry, GFP_ATOMIC);
>         return err;
>  }
>
> --
> 2.52.0
>
>

