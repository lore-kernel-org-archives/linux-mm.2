Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1B5CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A1D6B0088; Mon, 22 Jun 2026 20:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51AF26B008A; Mon, 22 Jun 2026 20:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409C76B008C; Mon, 22 Jun 2026 20:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17B8D6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:16:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9ED8C40332
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:16:03 +0000 (UTC)
X-FDA: 84909259806.03.D04BA6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01778A0003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:16:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lyI9QEjd;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782173762;
	b=seYcy60xhJpfplFxpRk9uiO4d042Kl9v3r/I0pSaFJcPw/x1Vsl26dlfP1biWS0sHrbetK
	TkCFYxb4ryXGuBsdbZZnnxi2au46PDPV0H/n9FkXMYMZecJztroaD6Ow2xaVKgU+EFGSq2
	B/I7ida3DS/rFiRXXdMin6PG40p751U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782173762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umsOQ0srOaaouQ1wwMTp3caQiMkiMWPQfAtHOceVpz4=;
	b=q1LuRpSpZbUnR0o//SPJK9grn881bJBtcOUIrz6hComuQ+Gb/ElQug6ILeVEm+1ORdzloJ
	JcUKsimHiYMTDVpexQZKV9KNiJJaIiY9nIq96PrM2mQWOWJSeD5CZw6IA28kO/I7nIN8eL
	7CGUNbc2bS4OLoUxaaqffjwfIU7eevQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lyI9QEjd;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14F6F402A2;
	Tue, 23 Jun 2026 00:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989571F000E9;
	Tue, 23 Jun 2026 00:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782173760;
	bh=umsOQ0srOaaouQ1wwMTp3caQiMkiMWPQfAtHOceVpz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lyI9QEjd4fWY0bqzQ1QVAa1Kh4MZf8EHugEiH09pxz0VRDGa1Nt0NVAwe4sKaOnnV
	 K0iiCX+9AGmhnGp/K2SeAn0b1ensgVgJlUZUds0M9uUHLeYzVMv3an+60FC8k/Z/Wf
	 HAZOGfDmMO/wSkMCoGtRPKrJV+CS10RWfbDBGIyiK3ThUOxEO/p4CwfDSeqECoeQlq
	 v5qMyQWIzFYA4CAeVYY0y8iBKlSwltjGbqCJ1k5tkeX1SLUDynqf5LS76n1rEKTuff
	 Dq+xa+X9HuO8+x/mcYVYaTo9CicpYZ2IRw1yC7bwuA97aK19Zq23RXS0KS2S66QpIq
	 bcib2jMFj/Z8A==
Date: Tue, 23 Jun 2026 00:15:58 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/7] mm, swap: support zswap and zeroswap as vswap
 backends
Message-ID: <ajnNWRO7apBq2-kQ@google.com>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
 <20260612193738.2183968-3-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612193738.2183968-3-nphamcs@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 76ebiayau6171yhxunjux16wsgyhot3j
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 01778A0003
X-HE-Tag: 1782173761-856596
X-HE-Meta: U2FsdGVkX1+feAO8pXLWlpH9a25yHDJJDHhxVw03SX6tWPP4GYL4rI0obEcDcxqumx4miee3Ok5I/SNF6o9ox+o2pw63dfdX7ROFhnQ1lMX4Hnm0OZYSFnj6Zg7TbnZQAgGWs0FTdvlEc5En69ZOQIcZhZ1wII9BaZ2GhUM9/m4TikF8xaeUDlWsOaCNWyllPaB/aYZ4KkLcODKlBUUPFZiD2PJIZiEwtINEeLRKAKHmXYlbrK+N6IZ6qa46/V1DhbnGuLmXGKob6LjsDWp/uZFzMY5//LPOx1pKmt4wfj841VxsXkKbsauMyCh5GL9P1OBfu/cmlh0u41UXr6oBxt3C5ah032pjF3AiGH7HIpWeyR3Q1HUXJCHkIyFfwSyywhJvsqNUs3fW7ZFqBEDB9Dl67/1TuN3sbxBY4prfYfRExkKbu/I8msdmhyRtprRq+Fl8R6Cb0Usfqlt+bDvGTNtyoGAwvglv9AcJT9FNABPawS+vuUlmYgyQ9NjiutY6rva5AztlSppvSG8GUv2Ar4ISPEZQ2e9HhM30ByCgs/slBjpOKVykF0cw17JAhpkpBvjj+F++rI1sM0wYLt3LW/KdvAmZNTHpmEXE+u07N8yY4qoOBbkbuNYcL1StPg/e2yCbjc3s1e8LpEHvGkNvYljIhRyl+e4G/6arLLAKd28Bj4AxLFOkFWWLhVIuWKBIfo9jUKSchzu4H8dCY1o7XyUT/0vjmycLFOEIdctiDrvKAH0bjpuzzbvS2HPzURCjXCjt96hu4112sJi3AQnEFo6nvKjzNNv5we7Q1Er6C43Ur28G0c8ih8jFd9WJdNJlS2OWzcccuPUbasmAm0CwBcTMJxYZdlv3pgu22xvVn/pAkaRdXwtB32bp2/G6xFqtKkihrAu8ZF2f7OhVTWoDnf49gvSHs8Rca+7DGaydoE2ZD6+vRbFAcjJYH/nV4czsxFJqAEUWQadTuuq6gBD
 bC+qNc0l
 hhSR10oZOisRscdJ5pI7AETTDcHQqCwnlqjQ4ek6uLiZy2AACPN9gPEh29/e2rT82w6wk9RQKZmlbftQrhWK4vqn5vAxrsEhmK9jlVxWA+s436k6pagPAC6+de8mP8O2C+RXD31a49/FojTa7kuwcEeFIVzspwN24FFfaSZc91Hi4xPMd0uBM5osl5HuJ1c8h7ylYnZUPU/9ev3l1QH9D73dCZrVkbEf2MllKvnIfJElwnYMScsQFze/bnXHVZLHFYHH7wLMf02a7Wjf/J5x0UZJXOtspJQiqGcBu3l2QvsZyZdprKQFex7oWuGTbcPy+qZ7FW0wcRNgv5jo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 12:37:33PM -0700, Nhat Pham wrote:
> Build the virtual swap layer on top of the swap-table infrastructure.
> Virtual swap entries decouple PTE swap entries from physical backing,
> allowing pages to be compressed by zswap (or detected as zero-filled)
> without pre-allocating a physical swap slot.
> 
> This patch only supports zswap and zero-page backends. If zswap_store
> fails, the page stays dirty in the swap cache (AOP_WRITEPAGE_ACTIVATE)
> - physical disk backing fallback comes in the next patch. Zswap
> writeback of vswap-backed entries is also disabled - the shrinker
> skips when no physical swap pages are available.
> 
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
[..]
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 993406074d58..466f8a182716 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -38,6 +38,7 @@
>  #include <linux/zsmalloc.h>
>  
>  #include "swap.h"
> +#include "vswap.h"
>  #include "internal.h"
>  
>  /*********************************
> @@ -762,7 +763,7 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
>   * Carries out the common pattern of freeing an entry's zsmalloc allocation,
>   * freeing the entry itself, and decrementing the number of stored pages.
>   */
> -static void zswap_entry_free(struct zswap_entry *entry)
> +void zswap_entry_free(struct zswap_entry *entry)
>  {
>  	zswap_lru_del(&zswap_list_lru, entry);
>  	zs_free(entry->pool->zs_pool, entry->handle);
> @@ -994,16 +995,21 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	struct swap_info_struct *si;
>  	int ret = 0;
>  
> +	/* try to allocate swap cache folio */
>  	si = get_swap_device(swpentry);
>  	if (!si)
>  		return -EEXIST;
>  
> +	/*
> +	 * Vswap entries have no physical backing - writeback would fail
> +	 * and SIGBUS the caller. Bail before we waste a swap-cache folio
> +	 * allocation.
> +	 */

Seems like this comment belongs in the previous patch, and the other
comment movement is undoing what last patch did.

>  	if (si->flags & SWP_VSWAP) {
>  		put_swap_device(si);
>  		return -EINVAL;
>  	}
>  
> -	/* try to allocate swap cache folio */
>  	mpol = get_task_policy(current);
>  	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
>  				       NO_INTERLEAVE_INDEX);
> @@ -1416,25 +1422,25 @@ static bool zswap_store_page(struct page *page,
>  	if (!zswap_compress(page, entry, pool))
>  		goto compress_failed;
>  
> -	old = xa_store(swap_zswap_tree(page_swpentry),
> -		       swp_offset(page_swpentry),
> -		       entry, GFP_KERNEL);
> -	if (xa_is_err(old)) {
> -		int err = xa_err(old);
> +	if (is_vswap_entry(page_swpentry)) {
> +		vswap_zswap_store(page_swpentry, entry);
> +	} else {
> +		old = xa_store(swap_zswap_tree(page_swpentry),
> +			       swp_offset(page_swpentry),
> +			       entry, GFP_KERNEL);
> +		if (xa_is_err(old)) {
> +			int err = xa_err(old);
> +
> +			WARN_ONCE(err != -ENOMEM,
> +				  "unexpected xarray error: %d\n", err);
> +			zswap_reject_alloc_fail++;
> +			goto store_failed;
> +		}
>  
> -		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
> -		zswap_reject_alloc_fail++;
> -		goto store_failed;
> +		if (old)
> +			zswap_entry_free(old);
>  	}
>  
> -	/*
> -	 * We may have had an existing entry that became stale when
> -	 * the folio was redirtied and now the new version is being
> -	 * swapped out. Get rid of the old.
> -	 */
> -	if (old)
> -		zswap_entry_free(old);
> -
>  	/*
>  	 * The entry is successfully compressed and stored in the tree, there is
>  	 * no further possibility of failure. Grab refs to the pool and objcg,
> @@ -1487,6 +1493,7 @@ bool zswap_store(struct folio *folio)
>  	struct mem_cgroup *memcg = NULL;
>  	struct zswap_pool *pool;
>  	bool ret = false;
> +	bool partial_store = false;
>  	long index;
>  
>  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
> @@ -1524,8 +1531,10 @@ bool zswap_store(struct folio *folio)
>  	for (index = 0; index < nr_pages; ++index) {
>  		struct page *page = folio_page(folio, index);
>  
> -		if (!zswap_store_page(page, objcg, pool))
> +		if (!zswap_store_page(page, objcg, pool)) {
> +			partial_store = index > 0;
>  			goto put_pool;
> +		}
>  	}
>  
>  	if (objcg)
> @@ -1548,7 +1557,9 @@ bool zswap_store(struct folio *folio)
>  	 * offsets corresponding to each page of the folio. Otherwise,
>  	 * writeback could overwrite the new data in the swapfile.
>  	 */
> -	if (!ret) {
> +	if (partial_store && is_vswap_entry(swp))
> +		folio_release_vswap_backing(folio);

Hmm the above should also only happen in the !ret case, but that's not
obvious from the code here. I think all of this should go under if
(!ret), but maybe reverse the polarity to avoid the indentation?

	if (ret)
		return ret;

	if (is_vswap_entry(swp)) {
		if (partial_store)
			folio_release_vswap_backing(folio);
		return ret;
	}

	...

Alternatively you can move the check_old code for xarray into a helper
and do:

	if (!ret) {
		if (is_vswap_entry(swp)) {
			if (partial_store)
				folio_release_vswap_backing(folio);
		} else {
			zswap_free_old_xa_entries(swp, nr_pages)
		}
	}

Also, I think you can probably drop partial_store and check the index
directly here.

> +	else if (!ret && !is_vswap_entry(swp)) {
>  		unsigned type = swp_type(swp);
>  		pgoff_t offset = swp_offset(swp);
>  		struct zswap_entry *entry;
> @@ -1588,8 +1599,7 @@ bool zswap_store(struct folio *folio)
>  int zswap_load(struct folio *folio)
>  {
>  	swp_entry_t swp = folio->swap;
> -	pgoff_t offset = swp_offset(swp);
> -	struct xarray *tree = swap_zswap_tree(swp);
> +	struct swap_info_struct *si = __swap_entry_to_info(swp);
>  	struct zswap_entry *entry;
>  
>  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
> @@ -1599,16 +1609,25 @@ int zswap_load(struct folio *folio)
>  		return -ENOENT;
>  
>  	/*
> -	 * Large folios should not be swapped in while zswap is being used, as
> -	 * they are not properly handled. Zswap does not properly load large
> -	 * folios, and a large folio may only be partially in zswap.
> +	 * zswap_load() does not support large folios. For non-vswap
> +	 * entries this is unexpected on the swapin path: WARN and
> +	 * sigbus. For vswap entries __swap_cache_add_check() has already
> +	 * filtered out ZSWAP-backed THPs under the cluster lock, so the
> +	 * large folio here is zero- or phys-backed; return -ENOENT to
> +	 * fall through to the phys/zero IO path.

Hmm should we start simple and avoid THP swapin for vswap initially?

IIUC, it isn't really vswap specific. Even without vswap, it's possible
that an entire folio is on-disk, not in zswap, in which case THP swap
should be allowed.

I assume it's not common for zswap to be enabled and an entire THP worth
of pages are not in zswap, so maybe we can add this later?

>  	 */
> -	if (WARN_ON_ONCE(folio_test_large(folio))) {
> -		folio_unlock(folio);
> -		return -EINVAL;
> +	if (folio_test_large(folio)) {
> +		if (WARN_ON_ONCE(!swap_is_vswap(si))) {
> +			folio_unlock(folio);
> +			return -EINVAL;
> +		}
> +		return -ENOENT;
>  	}
>  
> -	entry = xa_load(tree, offset);
> +	if (swap_is_vswap(si))
> +		entry = vswap_zswap_load(swp);
> +	else
> +		entry = xa_load(swap_zswap_tree(swp), swp_offset(swp));
>  	if (!entry)
>  		return -ENOENT;
>  
> @@ -1623,16 +1642,14 @@ int zswap_load(struct folio *folio)
>  	if (entry->objcg)
>  		count_objcg_events(entry->objcg, ZSWPIN, 1);
>  
> -	/*
> -	 * We are reading into the swapcache, invalidate zswap entry.
> -	 * The swapcache is the authoritative owner of the page and
> -	 * its mappings, and the pressure that results from having two
> -	 * in-memory copies outweighs any benefits of caching the
> -	 * compression work.
> -	 */
>  	folio_mark_dirty(folio);
> -	xa_erase(tree, offset);
> -	zswap_entry_free(entry);
> +
> +	if (swap_is_vswap(si)) {
> +		folio_release_vswap_backing(folio);

Is there any advantage to calling folio_release_vswap_backing() over
zswap_entry_free()? Seems like __vswap_release_backing() ends up just
calling zswap_entry_free() -- and I don't see any vswap-specific state
being cleaned up.

I wonder if the zswap code should call zswap_entry_free() directly? Same
goes for the call in zswap_store() above.

> +	} else {
> +		xa_erase(swap_zswap_tree(swp), swp_offset(swp));
> +		zswap_entry_free(entry);
> +	}
>  
>  	folio_unlock(folio);
>  	return 0;
> -- 
> 2.53.0-Meta
> 

