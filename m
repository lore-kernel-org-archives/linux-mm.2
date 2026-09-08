Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E61C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56E76B008A; Tue,  8 Sep 2026 05:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07A36B0093; Tue,  8 Sep 2026 05:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7A06B0095; Tue,  8 Sep 2026 05:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 566836B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:37:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2BF31C204C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:37:28 +0000 (UTC)
X-FDA: 85190092176.11.3E826B3
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 006F24000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:37:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dudD5dZA;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788860247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jdo8OnRnaSJ+QK5iLvvBRCC1dMO84Sr5WG2RzM3Vkaw=;
	b=lGVC5qeuXNrID2c6kuXwxTJlx9RQ/OsSlJ45vmgZEDyaniXkkJRD7sTDIMrcFmhSLzwEKw
	NBIqQ/xOmWFHvVLE3f4r+Z8eIk6SdpFPX217/eEzGT2BqjEFOYY6lboK/alMajV8jlALeN
	P6Bi4XgegVHhhNo2feGGZqNumhkDbds=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788860247;
	b=pLVmAgnhc1btv3GQssd6ANCLYWCXMDEt1g5jEmfnIgihg4xmeqB6ilyGGvv98aTleDGlIk
	tQxldL8XsqPl3JyPfy3tDMhPT+Bj2KudhiDs2QXPHvzx+tDRdh3DgTFzsD+QfEakVY9NDv
	Um/Fx+RotDJf868ogD1IJvp3qAPde3M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dudD5dZA;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8534d507f59so4615263b3a.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 02:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788860246; x=1789465046; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Jdo8OnRnaSJ+QK5iLvvBRCC1dMO84Sr5WG2RzM3Vkaw=;
        b=dudD5dZAh/rNlsxpCgq1uNAj1Ro4cBDVx1hG53dK5Pfdgmm0e9b6f/Y/yCaKcT+c3N
         1rv9reUpKP24x8yXLcKd5laitcs/dNnzFzT64T29VHwB2DR28sxj8OLfL7VCLyp+c6NA
         FIx0wigpbpif27LpEGtg6HEIY4qdPeGoHw2aY4ioqjWsRmJ2CoexO2fYbxGmwxY58tgi
         Bb3VfkayZ/Sv/ZLoAe4Zg+mYuitrdpoiDlcQS3nWFJ/CPB+6J7pD5XyUQw+94Pg9wyKX
         zObAZH4HOv/yeyoVnohonz2yDta10aNYzpQcFpDMbYHP6JRnjefr0A9nX+G44pDrKT3R
         7H6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788860246; x=1789465046;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jdo8OnRnaSJ+QK5iLvvBRCC1dMO84Sr5WG2RzM3Vkaw=;
        b=pCGkQy6iCk0KoLoHiZAzZWVietRsRQCscXNfi18J+MMjZQFtTtUViqLNZXNTfey2tk
         0QM9PoIA59aTpawMEg7QyLvNyA4pLz8Zv0N7L73JHcdkV6kV+qUvYfJLwOC1vubjw+5F
         DOuMU64F3nKuPZd7eGy3wDZQVf034m5j5vN1l+IYDjdHKYKTJnmJpB9YJiXYrUSP+wq0
         EnFmlykQqOQep1ckny/t4g2Yw7nZDiFxwIQjO5MPainChqNpDyoSEv1/iEYNDdn1vtBM
         SP4GAfjau4RXzBK9eqXZf25OLV7+c0GZ4rzsxd8sLDo9mewuZKwS2grdB0B0oKIqgIEZ
         K1Rg==
X-Forwarded-Encrypted: i=1; AKwUvBzUwc9vPtVJQkb4Xdj0o4kHnXh5/Cb4G75kAbz/FUeahCtR52R9ykdgM393v/HOW+mtA2NacigMAQ==@kvack.org
X-Gm-Message-State: AFuF++nfcpvbZMl0t19EFlq5CWBeNc1eCaXe5mpzTWkRaoy0JYsPfdbf
	qD6LWbwzP14cqIeDtMgcdncBCsSQ5RLGiunHJ6EEIER1QEF2jnXTN1Ay
X-Gm-Gg: AYBFou2m7scchKIDGovI1GCjQhQGsuZtioAa+5GCZ2PqOTaVAL15hieTnn7YaupHqCj
	8PfTMK0mywdyBifm1JFGu1VMMehJntUQg+brCd0Qb1cKLDPIravpXjBhvhLmr/37cuvGbbFf1D5
	tPrKlw72WpLr4LNrfnu1IJ0LPAt1/yy/84A8FK/AUfSjjXPxWuMCCAcZYIXX8KU+oTYKcb7fYdQ
	9hSFcLG5bcXyx65kgJGgHxK5XYI0UyZpBlrt45b7aMt7/LM+jkc3T6K2OGm9McMvQLSBK/qC3b4
	bnihCDMSStCcHTpNJmtwesVh+ItUmiV9KZd3bboJmYs3ei7Pa5/c+GmvvmCLlBCrkTOb5AEllvz
	hpDLHgh9m/2cATfhe8wPhUM3Gzv8PKiKFDvin+hYzYlUDbQ7TPtt168cHe7VxO2rkBYpZpHdUfq
	lGn7y2pLns5stXk4KDd89+bkj8Ecie3flCbg/N0+TbXA+mqlD2MLMC7JUKgu4=
X-Received: by 2002:a05:6a00:f94:b0:857:7337:5db7 with SMTP id d2e1a72fcca58-8616ac58363mr41402529b3a.21.1788860245006;
        Tue, 08 Sep 2026 02:37:25 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8615292d875sm5324180b3a.25.2026.09.08.02.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 02:37:24 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mm: swap: move LRU insertion out of the swap cache allocator
Date: Tue,  8 Sep 2026 17:37:00 +0800
Message-ID: <20260908093711.2364516-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260825135209.3135169-2-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: stmbtf7csorxxp8gy8363up1ikhi334s
X-Rspamd-Queue-Id: 006F24000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788860246-154027
X-HE-Meta: U2FsdGVkX19h6TA8YDVukuaRQCUVP8QwnwKBdpRFx09HawJr2FEo6kvXjXSmkMRihhtjYID0TiFTEicytG+Y1rjvaA7XRdU82scRQFzCINPf45d6aj1a4VhSjYp3/VPJBQ2QRLj9W7hwzLxeW364/JRGbZueopKtBKz9TILfEDlWsGXcT47ZLAd5PGPdTBkkZmrB59mV2P82TEaZqRUvF8hLaBAUuHrunSWViBMcumCzjnO4CoB8DpOejI5cY0HxDUSgJzrhj8nASmn1bbSgTDMb/3wVCmCR4Xl00xUQWQThBn0UJa4bdVrBjwfcvjSWlGhDo7cAF91CvgMrqpytdbOHwhYsPQnFrv1qMItiEa/lI4rltdrziLxuBOWEPrGBl8OmM5BOg91Wq64t97UC5ojX5MfGKQiPUfGHvYhgijXGEdRoe/xfk9p24DbYZUmcjWaCtgtzD6c9wEovlUyWsZULzh8sQJhDjgY021xtkPYFjfN+6LhAzAoy9UrDCvpsRT8XHgOJIuRZF5RKtE1sSHBuYkkLra5uhw+rtJxVN7gRcRgGbreZl2iRZcE35b2aop6/NI1SxeU0dA/TB6D2ZCDWMIUnH8xsxyGi7UXO3qLVNtNZB2rYYXY4VjJdpvcrj+Wo1q8/vEkGJ9eRPWLetwKIYD2fZyPeD2oCvMj9ahxFk4w+Wkhn7bO8pmADQ8t9av/qFj1ss3fKXWefGrws8a7Og6eLPzuHQtC/G8ykMJ0DAvWoIBf443LadcnjC4DgChamEefEfo+vNnsb3XIjK5nHsaIo6RwyaXzyLHZImIO//FgwTXz0tLbNNcaZvSSGy+fjzvSZGigrc4CnvSW4ygQ4UPsBSKgjq0+nF89D3lva7VJENyw89RSPWnDkksEejvNWq5UoJKxqFc1kfmVkQBLqWbAGVS3rIQAjY0/16qqtAZnUrucK97KdVrZtSLlMNK/50ODxWKgwWtmGpYa
 SOaKDswg
 +oC9WnEA9HNQTg0KJrz0t0cJSHceMCKjnZ2/GbPZZSWd386yuZB8z2Lpa9SYU9oaplDE1iwfUH2BN//1Sey67pNgvpaRiA8bWeD4YSgCy+qOR1DWxRbhaLQd2JzaPbGWndYEKjVvMY6uyllUH7Yu4cNo98WTaxKBI928AJ+ZhKgdsWe36hGubEuJqI5V8LsyLRp08Mp6fNu1xnP9UjZ1Xp6SYoJK9ZnswffTUArHWCSFDpXBQe/czeOFdEwo4qFcBylXNOF0oFwotBqxY6d+5f8QPvSa7x3WfX7pGHhMHPdP5Si4kLNVJlEUUjdMvgbKeRAUmgzTpqni4mrbkOwa3HCcJAYo77NCLNyMZP/mxI2546sfTtA5zc1CgRUtQprIHhomKNNdcBSwsn+ZaepOC1zl023AKt/6I1/eBeLTS8XIZnrDJFNaX60+sEZSfrQrngaDNQnBj/rcfgIcURhZ+dPhvFK52I41yB4E3eF6aVmSSen72eF26ubSMvR5kbxIDz5wF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 15:52:05 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> zswap writeback wants a swap cache folio it can free directly once
> writeback completes, i.e. one that is not on the LRU (folio_add_lru()
> stages the folio in a per-CPU batch that holds a reference until it is
> drained, which keeps remove_mapping() from freeing the folio on
> synchronous devices, and likely on asynchronous ones too).
> 
> So defer the LRU addition to the callers of __swap_cache_alloc_folio(),
> no functional change intended.
> 
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/swap.h       |  6 +++---
>  mm/swap_state.c | 20 ++++++++++++--------
>  mm/zswap.c      |  5 +++--
>  3 files changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/swap.h b/mm/swap.h
> index 77d2d14eda42..fc44daae1de1 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -304,9 +304,9 @@ bool swap_cache_has_folio(swp_entry_t entry);
>  struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_del_folio(struct folio *folio);
> -struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
> -				     unsigned long orders, struct vm_fault *vmf,
> -				     struct mempolicy *mpol, pgoff_t ilx);
> +struct folio *__swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
> +				       unsigned long orders, struct vm_fault *vmf,
> +				       struct mempolicy *mpol, pgoff_t ilx);
>  /* Below helpers require the caller to lock and pass in the swap cluster. */
>  void __swap_cache_add_folio(struct swap_cluster_info *ci,
>  			    struct folio *folio, swp_entry_t entry);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 727a17ee7821..07418fc94f00 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -483,13 +483,11 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>  	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
>  	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
>  
> -	/* Caller will initiate read into locked new_folio */
> -	folio_add_lru(folio);
>  	return folio;
>  }
>  
>  /**
> - * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
> + * __swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
>   * @targ_entry: swap entry indicating the target slot
>   * @gfp: memory allocation flags
>   * @orders: allocation orders, must be non zero
> @@ -501,13 +499,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>   * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
>   * @targ_entry must have a non-zero swap count (swapped out).
>   *
> + * The returned folio is locked and is NOT on the LRU. The caller must either
> + * add it to the LRU with folio_add_lru() so page reclaim can find it, or free
> + * it directly once done; a folio left off the LRU is unreclaimable and leaks.
> + *
>   * Context: Caller must protect the swap device with reference count or locks.
>   * Return: Returns the folio if allocation succeeded and folio is in the swap
>   * cache. Returns error code if failed due to race, OOM or invalid arguments.
>   */
> -struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
> -				     unsigned long orders, struct vm_fault *vmf,
> -				     struct mempolicy *mpol, pgoff_t ilx)
> +struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
> +				       unsigned long orders, struct vm_fault *vmf,
> +				       struct mempolicy *mpol, pgoff_t ilx)
>  {
>  	int order, err;
>  	struct folio *ret;
> @@ -643,12 +645,13 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
>  		folio = swap_cache_get_folio(entry);
>  		if (folio)
>  			return folio;
> -		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
> +		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
>  	} while (PTR_ERR(folio) == -EEXIST);
>  
>  	if (IS_ERR_OR_NULL(folio))
>  		return NULL;
>  
> +	folio_add_lru(folio);
>  	swap_read_folio(folio, plug);
>  	if (readahead) {
>  		folio_set_readahead(folio);
> @@ -683,12 +686,13 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
>  		folio = swap_cache_get_folio(entry);
>  		if (folio)
>  			return folio;
> -		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
> +		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
>  	} while (PTR_ERR(folio) == -EEXIST);
>  
>  	if (IS_ERR(folio))
>  		return folio;
>  
> +	folio_add_lru(folio);
>  	swap_read_folio(folio, NULL);
>  	return folio;
>  }
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..8163e6c5f76c 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1000,8 +1000,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  		return -EEXIST;
>  
>  	mpol = get_task_policy(current);
> -	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
> -				       NO_INTERLEAVE_INDEX);
> +	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
> +					 NO_INTERLEAVE_INDEX);
>  	put_swap_device(si);
>  
>  	/*
> @@ -1013,6 +1013,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	 */
>  	if (IS_ERR(folio))
>  		return PTR_ERR(folio);
> +	folio_add_lru(folio);
>  
>  	/*
>  	 * folio is locked, and the swapcache is now secured against
> -- 
> 2.53.0-Meta
> 
> 

I checked the callers of __swap_cache_alloc_folio(). The regular 
swap-in paths add the folio to the LRU after allocation, while 
the zswap writeback path keeps it off-LRU for the dropbehind 
handling in patch 3. 
The new allocator contract is preserved by all callers.

swapfile.c still references the old name in a comment — minor 
consistency nit.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
KunWu


