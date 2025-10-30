Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E9BCCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 22:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0486C8E0071; Thu, 30 Oct 2025 18:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020468E006B; Thu, 30 Oct 2025 18:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F4B8E0071; Thu, 30 Oct 2025 18:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAEB98E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:53:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B69EB7E55
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:53:34 +0000 (UTC)
X-FDA: 84056283948.08.5660746
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf12.hostedemail.com (Postfix) with ESMTP id AFD2440006
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:53:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=avDThudj;
	spf=pass (imf12.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761864812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1qA2vWPGU8Cj9JuIKZwmwfLammDUxSGwGNWhYdWVBk=;
	b=TVxHJoGiOJHculUWbQwM62OiOYfkIotYqiJRfgh5vPGM5eg2CqCB9fw7UEotP0E29Ubh+p
	UyrvCrhBzovpq11tm76okWi/Px0OoAeo2Kcj9ZadlSYBdibEd1j8i5fJU8+ZaGoMUA7rF6
	MdnYijRGFrvBOxolebB4cntnn5cqgoI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=avDThudj;
	spf=pass (imf12.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761864812; a=rsa-sha256;
	cv=none;
	b=2JBVgpgAbk8XHPTrizCHbkop47vNoVXYlLLvkAGQpW2JQb56VnbVhlDNBL2lVb5v0DqJ2M
	2w1ayyFpyfTLBohBFNkAruP9B9o0OPUbW5Y8nfVg0GQBXcyh437GK9fxktwsrNAKmbPM/e
	faO63sCfFeWk+hTQs3y7QOsPL/2YN+o=
Date: Thu, 30 Oct 2025 22:53:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761864807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a1qA2vWPGU8Cj9JuIKZwmwfLammDUxSGwGNWhYdWVBk=;
	b=avDThudjCDJNHNsHc4M8wuCiaBsP5T8rU4tubZNUWgW48ZcekS07dUXtfQmytSHETrPFyN
	fYspDU0vPwOVVD/55t4MDB5ehoOw9xAySMm2jWdhoaPrim20zzqPujKugHFASf7cGnpf7C
	AAkZmcCj5SQEfXtwsj9t9yN/2ajVpUo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 01/19] mm/swap: rename __read_swap_cache_async to
 swap_cache_alloc_folio
Message-ID: <ufy26fqfvaxqjywneec3hcuky7ozpa2fm63pxcuuberrvicffv@bkblomeix35w>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-1-3d43f3b6ec32@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-swap-table-p2-v1-1-3d43f3b6ec32@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AFD2440006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: umqgodgzzdrg55fzqqopwncqahiynt4y
X-HE-Tag: 1761864812-938144
X-HE-Meta: U2FsdGVkX1/zRPkzhxJsSWHWliiiYOxHm9RUHM2oy/b9PydpFqs7O9A6i14TAy2d7e8saM/ySKW7IeWIym8Il54kLAO7XkQYBfjP1J81EZQjI4LX0e2+hHxGzJZ4sAjrFZiIJxj1JEN8JE2/cp4Ii6zlSo+ocdxCdczOzTshPaBPH9Y+Pff8c6E4HooSUadpyfYnwoxaC/LCnKQDbuw6MpN9SAunLQPJvAVPnG859h+t3oPf7YrCA/GL21qp18Iy5tT2o5f6WG0mD+JDxrOGWLuWHVoTdEqCk/VK3GZph/HW3KqROKWSM0NrIItlyCIRrFMsQBHmkGXwhlHXH3KvBnaakODm5W19ZGTMku6MVICXdHGSwnWNsZLK9LwJ7QMFqajjZWGI3Ll9Z4dGXHUMR6LNh1Tjr+KyKz3L1PMIRIplv6p2VH69OeHSyjYgUk+H8/xPFXqdAbJfi5piSBOOUinL7ALUnBr18esj8wcDvwSu5XCKjH0P3YtghcEi8rWfoWHhCBe4iwyn7BgIJJAJbQx3KhjbxzRacqvS2x9x8dewUY83NfsU3wOGgJ9AKZFwfj5BQnBcBNelMclQm1RqNQeoMS0CCJClgf7tb1xV/OwKomTCEdn8L9QfRvSKAu119VgpHfRWHxSix6lV0GNqHr4jqjJj30hbJ40xfgeb5ju5/Ks48wOR7qkcRhyt/X4guJsUQMu9sPrGgoGG6VmhOZt8ABWuHKQZpKLRAbkkAsMPrWGP0A/Bgv3bCarafjbZ5NxAifG9st7pHR0jzCOcFbcz1r+ZJS/UutxmE3luxGFZWK4fuHKaCQaeP5NXrHgiz4qnt7LG15TZDOiiK94Tp19K3nsAyz9+idOca4x+61yzb9s4KvdcC/eTS+kFVqMOfJCmWEpZOj8duvicpshTenDHcct7BGlQx9Sc88mAtS9WGtrzG8DC2Wuj58OuFygt0L3Pz4K4gWYH1a8qZl/
 1gOT9ipH
 WllfQaKr7LBQolY826wGDBONOPjyFpuofYvfO0Soavh6q1EfaLTw/xCRzrJxz1K2PsI7k3ycit9sdYO9RLtq8fQMovF7dRLP8XdPAEJLdZSQ2gbqH63gb6o7ztYML6d2nKq3t7m2Wgo1XGZmzXD5JOgH3mrVmkHkLO+PYfndwyYLTB3KdEyFc/yY/vxeO45NIlBQ/k7C0MJa6LhRolnQEIZek/2K4OT1gaMkRWdqCqAPZvU7D2ZIkar0pYGa1Ldm+k9YzIZNCYCrYemrdnkZbwon+rKvNDqxmXHHziJLR0+90fe2Ibha/l5PS+8o2WtB+4lHs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:58:27PM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> __read_swap_cache_async is widely used to allocate and ensure a folio is
> in swapcache, or get the folio if a folio is already there.
> 
> It's not async, and it's not doing any read. Rename it to better present
> its usage, and prepare to be reworked as part of new swap cache APIs.
> 
> Also, add some comments for the function. Worth noting that the
> skip_if_exists argument is an long existing workaround that will be
> dropped soon.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h       |  6 +++---
>  mm/swap_state.c | 49 ++++++++++++++++++++++++++++++++-----------------
>  mm/swapfile.c   |  2 +-
>  mm/zswap.c      |  4 ++--
>  4 files changed, 38 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/swap.h b/mm/swap.h
> index d034c13d8dd2..0fff92e42cfe 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -249,6 +249,9 @@ struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow);
>  void swap_cache_del_folio(struct folio *folio);
> +struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
> +				     struct mempolicy *mpol, pgoff_t ilx,
> +				     bool *alloced, bool skip_if_exists);
>  /* Below helpers require the caller to lock and pass in the swap cluster. */
>  void __swap_cache_del_folio(struct swap_cluster_info *ci,
>  			    struct folio *folio, swp_entry_t entry, void *shadow);
> @@ -261,9 +264,6 @@ void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		struct vm_area_struct *vma, unsigned long addr,
>  		struct swap_iocb **plug);
> -struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_flags,
> -		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
> -		bool skip_if_exists);
>  struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
>  		struct mempolicy *mpol, pgoff_t ilx);
>  struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b13e9c4baa90..7765b9474632 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -402,9 +402,28 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
>  	}
>  }
>  
> -struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> -		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
> -		bool skip_if_exists)
> +/**
> + * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
> + * @entry: the swapped out swap entry to be binded to the folio.
> + * @gfp_mask: memory allocation flags
> + * @mpol: NUMA memory allocation policy to be applied
> + * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> + * @new_page_allocated: sets true if allocation happened, false otherwise
> + * @skip_if_exists: if the slot is a partially cached state, return NULL.
> + *                  This is a workaround that would be removed shortly.
> + *
> + * Allocate a folio in the swap cache for one swap slot, typically before
> + * doing IO (swap in or swap out). The swap slot indicated by @entry must
> + * have a non-zero swap count (swapped out). Currently only supports order 0.

Is it used for swap in? That's confusing because the next sentence
mention that it needs to be already swapped out.

I suspect you're referring to the zswap writeback use case, but in this
case we're still "swapping-in" the folio from zswap to swap it out to
disk. I'd avoid mentioning swap in here because it's confusing.

Otherwise LGTM:
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> + *
> + * Context: Caller must protect the swap device with reference count or locks.
> + * Return: Returns the existing folio if @entry is cached already. Returns
> + * NULL if failed due to -ENOMEM or @entry have a swap count < 1.
> + */
> +struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
> +				     struct mempolicy *mpol, pgoff_t ilx,
> +				     bool *new_page_allocated,
> +				     bool skip_if_exists)
>  {
>  	struct swap_info_struct *si = __swap_entry_to_info(entry);
>  	struct folio *folio;
> @@ -452,12 +471,12 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  			goto put_and_return;
>  
>  		/*
> -		 * Protect against a recursive call to __read_swap_cache_async()
> +		 * Protect against a recursive call to swap_cache_alloc_folio()
>  		 * on the same entry waiting forever here because SWAP_HAS_CACHE
>  		 * is set but the folio is not the swap cache yet. This can
>  		 * happen today if mem_cgroup_swapin_charge_folio() below
>  		 * triggers reclaim through zswap, which may call
> -		 * __read_swap_cache_async() in the writeback path.
> +		 * swap_cache_alloc_folio() in the writeback path.
>  		 */
>  		if (skip_if_exists)
>  			goto put_and_return;
> @@ -466,7 +485,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		 * We might race against __swap_cache_del_folio(), and
>  		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
>  		 * has not yet been cleared.  Or race against another
> -		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
> +		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
>  		 * in swap_map, but not yet added its folio to swap cache.
>  		 */
>  		schedule_timeout_uninterruptible(1);
> @@ -509,10 +528,6 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>   * and reading the disk if it is not already cached.
>   * A failure return means that either the page allocation failed or that
>   * the swap entry is no longer in use.
> - *
> - * get/put_swap_device() aren't needed to call this function, because
> - * __read_swap_cache_async() call them and swap_read_folio() holds the
> - * swap cache folio lock.
>   */
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		struct vm_area_struct *vma, unsigned long addr,
> @@ -529,7 +544,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		return NULL;
>  
>  	mpol = get_vma_policy(vma, addr, 0, &ilx);
> -	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
> +	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
>  					&page_allocated, false);
>  	mpol_cond_put(mpol);
>  
> @@ -647,9 +662,9 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  	blk_start_plug(&plug);
>  	for (offset = start_offset; offset <= end_offset ; offset++) {
>  		/* Ok, do the async read-ahead now */
> -		folio = __read_swap_cache_async(
> -				swp_entry(swp_type(entry), offset),
> -				gfp_mask, mpol, ilx, &page_allocated, false);
> +		folio = swap_cache_alloc_folio(
> +			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
> +			&page_allocated, false);
>  		if (!folio)
>  			continue;
>  		if (page_allocated) {
> @@ -666,7 +681,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  	lru_add_drain();	/* Push any new pages onto the LRU now */
>  skip:
>  	/* The page was likely read above, so no need for plugging here */
> -	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
> +	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
>  					&page_allocated, false);
>  	if (unlikely(page_allocated))
>  		swap_read_folio(folio, NULL);
> @@ -761,7 +776,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  			continue;
>  		pte_unmap(pte);
>  		pte = NULL;
> -		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
> +		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
>  						&page_allocated, false);
>  		if (!folio)
>  			continue;
> @@ -781,7 +796,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  	lru_add_drain();
>  skip:
>  	/* The folio was likely read above, so no need for plugging here */
> -	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
> +	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
>  					&page_allocated, false);
>  	if (unlikely(page_allocated))
>  		swap_read_folio(folio, NULL);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c35bb8593f50..849be32377d9 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1573,7 +1573,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
>   *   CPU1				CPU2
>   *   do_swap_page()
>   *     ...				swapoff+swapon
> - *     __read_swap_cache_async()
> + *     swap_cache_alloc_folio()
>   *       swapcache_prepare()
>   *         __swap_duplicate()
>   *           // check swap_map
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958..a7a2443912f4 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1014,8 +1014,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  		return -EEXIST;
>  
>  	mpol = get_task_policy(current);
> -	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
> -			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
> +	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
> +				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
>  	put_swap_device(si);
>  	if (!folio)
>  		return -ENOMEM;
> 
> -- 
> 2.51.1
> 

