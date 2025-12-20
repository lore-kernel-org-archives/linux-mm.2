Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89E0E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B9E6B0089; Fri, 19 Dec 2025 23:12:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF286B008A; Fri, 19 Dec 2025 23:12:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02B06B008C; Fri, 19 Dec 2025 23:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB8FE6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:12:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74E15140442
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:12:48 +0000 (UTC)
X-FDA: 84238528416.19.C686B65
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id AF28D20005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:12:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JXyaKzN0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766203966; a=rsa-sha256;
	cv=none;
	b=dCmDuIJcF29YhdlsBC4aAFmv8z4uCvNgfX33Y72N8vzXEPxDFCC+HEWrSn/8V+td67iNs3
	0o5qqC/JAQI9iT/Hhul64yUg83lUQHwKS3juMtULRkXeTIdZL5PexObyGATCubJB8zOxoU
	peXJlDYpRtLJ3vxWmpyqHdzACo4WOvs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JXyaKzN0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766203966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUGlsoiATVHzxINssykwyrQRYZywwCwKQJhqr5QIuf0=;
	b=OWb9RGoslcYE72pjFXX29nPJTqFsan3Zs9YmVOF+nHk8dKJLwcfeymA/yiaz4OnT/ACi5Y
	OpNNQEjaidrek6dIwTqPipf51FidQIXWYmqIVojHEmDrJRsDVh6Q2glbaKU6lY1yJP1t2r
	NzfAi28vJE8ZSIgaXJ6xOhLzupH1eIM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766203966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uUGlsoiATVHzxINssykwyrQRYZywwCwKQJhqr5QIuf0=;
	b=JXyaKzN0bVDCgUM5wufCeV0GcTQiLxQ+2BnDOeTWIxHCBC9/dJBEjdkQTNidnX9bVrkvLS
	fuhF6Pf3zQopbNJFZURMD8PMNRVYH8xIZnlNFLaL1YY+BG1el2pKPZqSKgnlJfcGDQJPqK
	Av0O2eTYvXeIEzUK35SosSxpRc8ejJs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-B5zu8D-vN26gLnhv65nh8Q-1; Fri,
 19 Dec 2025 23:12:42 -0500
X-MC-Unique: B5zu8D-vN26gLnhv65nh8Q-1
X-Mimecast-MFC-AGG-ID: B5zu8D-vN26gLnhv65nh8Q_1766203960
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60CE21956046;
	Sat, 20 Dec 2025 04:12:38 +0000 (UTC)
Received: from localhost (unknown [10.72.112.41])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAC09180049F;
	Sat, 20 Dec 2025 04:12:35 +0000 (UTC)
Date: Sat, 20 Dec 2025 12:12:30 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v5 15/19] mm, swap: add folio to swap cache directly on
 allocation
Message-ID: <aUYiLiGJPt/kAy3I@MiWiFi-R3L-srv>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-15-8862a265a033@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220-swap-table-p2-v5-15-8862a265a033@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF28D20005
X-Stat-Signature: ygzj75qbc4mzriym67wm7e5map5h6xud
X-HE-Tag: 1766203966-972705
X-HE-Meta: U2FsdGVkX1+fw9lhFl3P2APa6/6zcsXBMEugXn2VQ3zpJ8ztZSKh9Jpo4uz4HXLdgsFILy7ugna4EpjsLHAkUlkaBDE9t06Tm3cm+/4HHXHxzT82fMFl3ziQ1ULOxFBu7P30cmJqpuh6ovKH8Rmr8C1Nf1OKFzyATujkSPVBcuT3UaxYQ4QNPL3bHllDIb8lahhJ0zwsmZs+n63wofAoC+XYzCUZoXhCz0B8FonBVDjPFDT78wz3Cbfn9gW6bNT0b9n/WvWgrokSeD09vCJP29uwOC389O0o9j3CxkIpmoLW/7DViky13jhhbShXTcqcq2nKQiTwcN01si7XO/5c07SbkjUp4IxOCBZuYw5XWbgS42CIa1IeMCKk7++53vgC0IX5zTRXz34fTZTKFgpQKMcdNqLSSWi98aOZhxMt+g/jRtjuFckAlTfK67iVLveo9lusml4anOOYn/iTYh1Qntjs+XJegFeWceWdsEwW4l6HA7CAVJNnPp455ZuA4zj20zGx51K4bX/UC35vRhnPbwsSSBERJai97cbWPFq4nO9qwp66jakBvFrdMZWOwboyIJ4S9QoftFeGCgsChOpmchKIuceMK8e3HJOngLVyXcZXg4wwzI2AWyWqkUDMszY7eO/bveuKoo8slXOELqefI3RYL1jtn+iwcU/7FZWY2X/vLhAYemG8ksZ0PXtzaLJ/MS+uVUTPdxQUXOAp3VeHhyurRrOTdYdeNDeUC+t3O8BDNNwb5WmzI+1uy5o2Dbh4733gS3nv64f0J3NlPyOyDBR1h3yvS58Kim5W8tldoR2QyjDzgu4LRVFB4ewZcMDCl2375IjSLqImGlIrXXMxSIocZQuS8qpJrrHmUCHqOvog19jBfmmvQ+oRAWTFqhqNuGahK6guJBfsOZIMPoNoONEQJOHg9tu64uq6VBTBrzt8N1/SLsda1kD9+q5d3WkZ8q6gyHp7/QJwPHp6PGS
 7P2Tk88i
 RDzwEBOtLH3okZx60qt24hD6FLump8ZVaBzlIWgI8ucSALIJeo7yZWXx0rAHeFmHrPTE751K5vDhkJZF5gbALGiwrv5bzA8VjVfVQ6c3stJ3kAI8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 at 03:43am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The allocator uses SWAP_HAS_CACHE to pin a swap slot upon allocation.
> SWAP_HAS_CACHE is being deprecated as it caused a lot of confusion.
> This pinning usage here can be dropped by adding the folio to swap
> cache directly on allocation.
> 
> All swap allocations are folio-based now (except for hibernation), so
> the swap allocator can always take the folio as the parameter. And now
> both swap cache (swap table) and swap map are protected by the cluster
> lock, scanning the map and inserting the folio can be done in the same
> critical section. This eliminates the time window that a slot is pinned
> by SWAP_HAS_CACHE, but it has no cache, and avoids touching the lock
> multiple times.
> 
> This is both a cleanup and an optimization.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h |   5 --
>  mm/swap.h            |  10 +---
>  mm/swap_state.c      |  58 +++++++++++--------
>  mm/swapfile.c        | 161 ++++++++++++++++++++++-----------------------------
>  4 files changed, 105 insertions(+), 129 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index aaa868f60b9c..517d24e96d8c 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -452,7 +452,6 @@ static inline long get_nr_swap_pages(void)
>  }
>  
>  extern void si_swapinfo(struct sysinfo *);
> -void put_swap_folio(struct folio *folio, swp_entry_t entry);
>  extern int add_swap_count_continuation(swp_entry_t, gfp_t);
>  int swap_type_of(dev_t device, sector_t offset);
>  int find_first_swap(dev_t *device);
> @@ -533,10 +532,6 @@ static inline void swap_put_entries_direct(swp_entry_t ent, int nr)
>  {
>  }
>  
> -static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
> -{
> -}
> -
>  static inline int __swap_count(swp_entry_t entry)
>  {
>  	return 0;
> diff --git a/mm/swap.h b/mm/swap.h
> index 9ed12936b889..ec1ef7d0c35b 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -277,13 +277,13 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
> -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> -			 void **shadow, bool alloc);
>  void swap_cache_del_folio(struct folio *folio);
>  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
>  				     struct mempolicy *mpol, pgoff_t ilx,
>  				     bool *alloced);
>  /* Below helpers require the caller to lock and pass in the swap cluster. */
> +void __swap_cache_add_folio(struct swap_cluster_info *ci,
> +			    struct folio *folio, swp_entry_t entry);
>  void __swap_cache_del_folio(struct swap_cluster_info *ci,
>  			    struct folio *folio, swp_entry_t entry, void *shadow);
>  void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> @@ -459,12 +459,6 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
>  	return NULL;
>  }
>  
> -static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> -				       void **shadow, bool alloc)
> -{
> -	return -ENOENT;
> -}
> -
>  static inline void swap_cache_del_folio(struct folio *folio)
>  {
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 327c051d7cd0..29fa8d313a79 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -122,35 +122,56 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>  	return NULL;
>  }
>  
> +void __swap_cache_add_folio(struct swap_cluster_info *ci,
> +			    struct folio *folio, swp_entry_t entry)
> +{
> +	unsigned long new_tb;
> +	unsigned int ci_start, ci_off, ci_end;
> +	unsigned long nr_pages = folio_nr_pages(folio);
> +
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> +
> +	new_tb = folio_to_swp_tb(folio);
> +	ci_start = swp_cluster_offset(entry);
> +	ci_off = ci_start;
> +	ci_end = ci_start + nr_pages;
> +	do {
> +		VM_WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)));
> +		__swap_table_set(ci, ci_off, new_tb);
> +	} while (++ci_off < ci_end);
> +
> +	folio_ref_add(folio, nr_pages);
> +	folio_set_swapcache(folio);
> +	folio->swap = entry;
> +
> +	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> +	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> +}
> +
>  /**
>   * swap_cache_add_folio - Add a folio into the swap cache.

With my understanding, __swap_cache_add_folio() is the pure
functionality of adding a folio into swap cache. While
swap_cache_add_folio() is specifically adding a folio into swap cache
during swap in path. Not sure if we can rename them to reflect this
clearer. At least from the functiona name and below kernel doc we can't
feel that. Maybe:
__swap_cache_add_folio() -> swap_cache_add_folio()
swap_cache_add_folio() -> swap_cache_add_swapin_folio()

From a brain storm, just for reference.

>   * @folio: The folio to be added.
>   * @entry: The swap entry corresponding to the folio.
>   * @gfp: gfp_mask for XArray node allocation.
>   * @shadowp: If a shadow is found, return the shadow.
> - * @alloc: If it's the allocator that is trying to insert a folio. Allocator
> - *         sets SWAP_HAS_CACHE to pin slots before insert so skip map update.
>   *
>   * Context: Caller must ensure @entry is valid and protect the swap device
>   * with reference count or locks.
>   */
> -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> -			 void **shadowp, bool alloc)
> +static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> +				void **shadowp)
>  {
>  	int err;
>  	void *shadow = NULL;
> +	unsigned long old_tb;
>  	struct swap_info_struct *si;
> -	unsigned long old_tb, new_tb;
>  	struct swap_cluster_info *ci;
>  	unsigned int ci_start, ci_off, ci_end, offset;
>  	unsigned long nr_pages = folio_nr_pages(folio);
>  
> -	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> -	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> -	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> -
>  	si = __swap_entry_to_info(entry);
> -	new_tb = folio_to_swp_tb(folio);
>  	ci_start = swp_cluster_offset(entry);
>  	ci_end = ci_start + nr_pages;
>  	ci_off = ci_start;
.....snip...


