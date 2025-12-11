Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67653D3E784
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 01:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08DD6B0005; Wed, 10 Dec 2025 20:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE04F6B0007; Wed, 10 Dec 2025 20:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE7B6B0008; Wed, 10 Dec 2025 20:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 985056B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:01:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CCB08AB65
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:01:20 +0000 (UTC)
X-FDA: 84205386720.13.5D1F84F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 26B2210000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:01:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ghQ+QIvg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765414878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fN1X1bH+SRooNp/weIju+G0+QJvxB0NZ48vW9OAx0fA=;
	b=nVkdz4LJS3TUf6UtbQ+t8zsyPuEZ75IJKso2lwMz9oQgzBiEejBT2Rq65PPe8JWBfGf6gZ
	0Nu/gTty+RfU0Al+vnBWfvKb/Ruz4GXoQPnSge08XvUUmg8VHzuQW8xhtiykaheAwDweI/
	82BN4Jz0Z6cLq8F8QlNstM7u4k8FnQo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ghQ+QIvg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765414878; a=rsa-sha256;
	cv=none;
	b=FSiYJveg2+9d7k0rVvSC9zH1l5S6YBYDblcdDdxbmCbg8T67HIIDEUy17MXwO9iuwChpAv
	mxUMzZFRe0rnKh2B2BnaXDR2njp2CCLp4oOO25x+nOshOKvWWf+Ys/wirfon/EhAWr2Y4p
	bpRaiO7IAL6WziiqeZyVtTy0/DIlBlU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765414877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fN1X1bH+SRooNp/weIju+G0+QJvxB0NZ48vW9OAx0fA=;
	b=ghQ+QIvgALU4S9YpgZozb8s1L1R3pXafIgp6fiedDKqwwK2IwDi8pXwm0elycz9ricm7zR
	IMKoznK8Us/keXAiYvJ38e/wtkT7tLmx0GwLAKP3zDAIcA08jkX0CsUvkZmb29pZEL0QP6
	rU6vEJkMH+wLdRyaQefva6Cu7krqahw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-X9J_fMF1NQqda-fS_cdf-A-1; Wed,
 10 Dec 2025 20:01:11 -0500
X-MC-Unique: X9J_fMF1NQqda-fS_cdf-A-1
X-Mimecast-MFC-AGG-ID: X9J_fMF1NQqda-fS_cdf-A_1765414869
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E721195607C;
	Thu, 11 Dec 2025 01:01:08 +0000 (UTC)
Received: from localhost (unknown [10.72.112.161])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B246B180045B;
	Thu, 11 Dec 2025 01:01:05 +0000 (UTC)
Date: Thu, 11 Dec 2025 09:01:01 +0800
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
Subject: Re: [PATCH v4 01/19] mm, swap: rename __read_swap_cache_async to
 swap_cache_alloc_folio
Message-ID: <aToXzaKrS1WQlXhL@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-1-cb7e28a26a40@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205-swap-table-p2-v4-1-cb7e28a26a40@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Stat-Signature: tgi5axxnq6fk8wj166fs1waadfknu9hz
X-Rspamd-Queue-Id: 26B2210000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1765414877-164896
X-HE-Meta: U2FsdGVkX19bUL7SgsPtRmLNxnUzxF/VX1wfK5sG7kY/AR7DjuWURTkZYBVqn+IaehpUGS/O99dUM10VdPJfTtsrCEv95VFd2yFmpd5dVICVKcB81DzsGS3rEgH0WRWQ3NYEMPOanMsP2N43WtT+3w6gPzeZNN1I3/Ten0Y6/EXNDRAMTXbF6r+yeURdCmHpeMG3aHfH+koK8zYlFAT4GCMDVKC5vqwLSS9XMjAzUlpEByYo4kWTFpChdyFGYGPAk0yzsb2Dj+ZxmErK05YIQ9OV8Ozhk79EfUBcRzObhwLlIJMfJU6271iMWkemeWa4dLKVSRTeg1wC6802KsguzDTzLE0+nif7Xp1rDVsHNfgxwy7/dL7E7L83WOdSrgqtM4N/AWSkHTblIJTlBloCn36HwrkPrmql1tzFSEf2Gg5seXaA//TBdoi3/NgEPrYkVWmKAaakCk8Q5FyhGkbayLjs7WCunxyRs/RIve3BEWGvf5SULuoBWNF5PBHeeWOhm8Lut5lrif9PbzWYReIphoWOtukhXJ1NaL6m7zcM9MJ2IRqF03l7xHAiPRbPU9D4ZbmtGHTfjtOZ9RHiYwjg7EJrKSttPlPm1/lvtzDOohu8qVs/p4yJVLERHrKYgLKDO8ZGcRgx4xdWvvKYRxGMHzzIi/Vf5cFutUYII3S68NTBOi9T1EzDfp/jMSrd9kEQgdm/J3CvFbyQdJpcS+oYwz76t16my4wEFTBxk5Euuq1gNx3ErRxyx4s5GbU60nhyrqtQjr2BAYM9/DyucfCY7VDKM2NEXJRWJjae8O1Y7zLtOwD7Dq9y7dAvlTzp0SivrP+Dtc5Cm0qR5Hs5Wn9xFJGWTpNq2KlSE4tsQZQSlwO1kdhoLJTdsOo2Ea6JQiqELA882UZSVI6eiiNkeeiWlrU7FKM/VRlNgvj4wayyGyZ2RTG7v+BZ02KKzpREpfd4tFCrldAGVbH5Z0ya0xI
 XgGuQSiR
 9ctLL8dKZPa4F1Z6cO1swlzjZZiDzqHVcAP9TLQdz4+HWubHkQIXgNM0hCMDREozHZdtY0hZF1OpI702OpJm9XDz6apMuXEXd5XJW/BW+DeaixcSvXCORRYzmFgH+VAr7WJLby4QrudYj2FPYu3emxSaDx4KfZI8fEn/nAMJhhqZ1OcwTkqpMfUSTwg9TUWpOPpzbIxaleNgiOAC8+mA+fj4WLer/uESaq+CjdA6frnFxUQGsu8e0vOrAgCdHmSbgsRP5Pi8m3bH2uQHNt8CWPI9Lmn3tXRXYXQZ0Vy9e6/SYDpLy20tOk/6/vjfnGqK5RVAUx/u1ljeq8ZpvScmika4/QkgbS21OlUSbzNP5j+LhTesP9p8Wm5QWd8amtP1wcQoo9uoAythOzMI7LnFb356G50czV+dzWp6GR+D6Q77unFNJ9u2SW2Lb/2pOH0VFr3ZYg8gsTTSG6z4oMe0FSrWPnupD/g8d4EkVzbML5iQHGS/r/ijNQTNkl0xYjjCWC/6tlNMWd6//UtGf3tvI2qG1kG1x69QZv5bxg6R6kfSVb/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/05/25 at 03:29am, Kairui Song wrote:
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
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h       |  6 +++---
>  mm/swap_state.c | 46 +++++++++++++++++++++++++++++++++-------------
>  mm/swapfile.c   |  2 +-
>  mm/zswap.c      |  4 ++--
>  4 files changed, 39 insertions(+), 19 deletions(-)

LGTM,

Reviewed-by: Baoquan He <bhe@redhat.com>

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
> index 5f97c6ae70a2..08252eaef32f 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -402,9 +402,29 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
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
> + * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
> + * @entry must have a non-zero swap count (swapped out).
> + * Currently only supports order 0.
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
> @@ -452,12 +472,12 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
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
> @@ -466,7 +486,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		 * We might race against __swap_cache_del_folio(), and
>  		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
>  		 * has not yet been cleared.  Or race against another
> -		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
> +		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
>  		 * in swap_map, but not yet added its folio to swap cache.
>  		 */
>  		schedule_timeout_uninterruptible(1);
> @@ -525,7 +545,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		return NULL;
>  
>  	mpol = get_vma_policy(vma, addr, 0, &ilx);
> -	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
> +	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
>  					&page_allocated, false);
>  	mpol_cond_put(mpol);
>  
> @@ -643,9 +663,9 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
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
> @@ -662,7 +682,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  	lru_add_drain();	/* Push any new pages onto the LRU now */
>  skip:
>  	/* The page was likely read above, so no need for plugging here */
> -	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
> +	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
>  					&page_allocated, false);
>  	if (unlikely(page_allocated))
>  		swap_read_folio(folio, NULL);
> @@ -767,7 +787,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  			if (!si)
>  				continue;
>  		}
> -		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
> +		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
>  						&page_allocated, false);
>  		if (si)
>  			put_swap_device(si);
> @@ -789,7 +809,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  	lru_add_drain();
>  skip:
>  	/* The folio was likely read above, so no need for plugging here */
> -	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
> +	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
>  					&page_allocated, false);
>  	if (unlikely(page_allocated))
>  		swap_read_folio(folio, NULL);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 46d2008e4b99..e5284067a442 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1574,7 +1574,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
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
> 2.52.0
> 


