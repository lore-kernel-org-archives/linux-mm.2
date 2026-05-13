Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC449CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229786B0093; Wed, 13 May 2026 05:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201CA6B0095; Wed, 13 May 2026 05:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13EEE6B0096; Wed, 13 May 2026 05:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 092076B0093
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:43:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC5111C180B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:43:50 +0000 (UTC)
X-FDA: 84761909820.20.F55CC45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D07A21A0004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:43:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GejbgU8y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778665429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEmXZQfCiKyW55rAKziIvvivDegcDKhbwNLuhibvVKo=;
	b=mWuBkmdgbdNhqt468bj0zOOpwDqtezYuSEPDjNHVRwSo9zc6oLm5OkH6tmFrj/DSpXKJyO
	kidf5BVxI7+8yyK/j2c1PiOxktd8cTDBOA/WUCYfD2AN0IN8RjYSZmWQUXygzZ18qhHvuq
	aBYdFkjcsR7nRpJeWUinSI1thV/aCCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778665429; a=rsa-sha256;
	cv=none;
	b=xn1qrs6PbDUpm2NbxAKKH+mk4Iv/8/Nqo4gPKEGqkeEg1OZMW5sHWinOXPHBuU+Sc19dUN
	KLbIVy+Z6XGJC32d8jaOB3MfOtvYZeWlkgyDbnoWx/jFTnM6GgPRmuVr2s3ikIkPb1aM8M
	N6plWQ3bwuZ3kDP+N1dveWDluLupJdk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GejbgU8y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF1934030B;
	Wed, 13 May 2026 09:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA797C2BCC7;
	Wed, 13 May 2026 09:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778665427;
	bh=daIGsFCgC7s3aBYTkbVyPm/HvOWGKffRvvCT+FWmZJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GejbgU8yvaGJ7FI6kTLJFuTj2PkzFZzn1clBDyJsFFR5Gv5o3VOqi4Os52tb//Rh2
	 DTykpTfkcub8hAwvjCz7acDAfhctAfaTPjVSunKA8w45WO0/GM6u70fVripW/EGZ0I
	 BsrUNXAKpUv/5C1aFbKY36RPtwqoAY9D7YgkwgClHPtfHMqeRYpUD8UnIsYVd/3fzD
	 82HKL0W2jrV0m6dvFY9yZy2tItTNewKVAyBf1/cbyHh839l0mOfRa5QM88vq8TtqZP
	 d2TQsantAwaD0r/5ktFMsebbRIjstn1AlshwoRiuGss+DKWnIWeoTNunOJQiBiqicq
	 2YHAE7cYiJAOA==
Message-ID: <d5972a1d-42cd-4510-b734-c47b927af501@kernel.org>
Date: Wed, 13 May 2026 11:43:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/22] mm/page_alloc: introduce ALLOC_NOBLOCK
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-18-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-18-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D07A21A0004
X-Stat-Signature: k8z18txgtokxh8ijb1cmxrdcz5ji95e3
X-Rspam-User: 
X-HE-Tag: 1778665428-636157
X-HE-Meta: U2FsdGVkX1/B8bJ5BZABE+5afFRziN5/LsYOBPyqVmTCYVEh2+uirdYMAaRK2pDwnsl/8w8oH4XyerwGEF/AesodvQGv/xisrl8dz+xdSzKZyM5320mxzqbfTox7UneWaAbPi0Rqt4VlSD50RM96+PYnSDQ2me/Z5T/kzybmonjO4Wkx7VgvEQfoz8GvbGe4zZvYhjtmaYb0oLWVVzRKCBbJr9Bl1zkoh2prepc9hG3EXj3IC4SRi7WXPPbfRmN1uLRhI7PsJwGZonjrc9C9hAQfdGeBI35VFw+7ZFaXd5N6H69kK5gPPA1JEJ9612nJAJkkF7P4/KFSGWtAg/bZ7cK+F9ToKNcs7uHi/UHjWsFJhfjWmHO/Oa9a2S75ttg/vgBWJnU0qwf+GlP9m15qbHoz6HMRdc1gprJqq0nEYyR14X9oWXqNJIMlzN3EJD3flKmfIS7RXFHvHjBPit652n5hYuM3E+JUcdGgNf9Rrk6LQim25kwf+cYS72HbTGKsfKrmWfzok86lPgPVK0Sg+JwgpFESsylDgEoCca+A7Hcc/3kEkd6Z23YaljwbYHvtk/uoK0VFeFUKqOcuM7t+94IP2sB7eOpbaHQnXuDVBMIU8UGs70H65vkhUbgkib99fbDFSfuPOzZoapPPEXh0qRF2Na49ZHbB+E+Aj/heAE4VkmbH0g325wRbZQFM+Dau3UELyvqh/PmyGWgxhVPz1NKIORx92tILgYvPrRvUHcSlrak0kdBL+FIxF9JCjFuhEscfLvFIhGyIKecD97kjp5DFrtyYW6PIDJbYLww/+HZ6sZmnERUsobbJMBTnifOXSCJZbgYA3gBxKNGSJxu5tw+uD9p7ShG5qrBwD0itsxZF+6ji63tDdf1GqP4XIChMzAKAGcJBL7vsugVcDrm0porGUDQ1BnEz6HRTix2Ar/AuSPsoIEEMrhjzjLGhvJoy/5v4D4ts8dZXv4MgGr9
 Zx49bfKJ
 XxCDWpvueey/GvKTpw1X2dOGoUMNRtCHekIdZoJIwJXiJvy2k1u6AjqI3gSoJsd2hcszm3TTvcRcOvL0l0nMQuoo2q+9SYXUjNLBu3FEXmdpyLJjLFSw0FukVu5DAuk51Q1Fn9t+tJRBKxcqDfdR+/k+SDtiAJy5TptbqALkk9JNCy5PAMy+2JCanq64Q5TLWr9WAe72zwOVDBOyGx3hnz58ZNsNVuK1RoFcD4ibtlj5ozZF8QkBgt/tOoRAycyfUsxagIHfMN3d9HYgbee8QNCSdGoAHDMrAZnqN7QrMYjdM5zQXSVWn2WOhW34teqlNVuV1pYM1RbX5RFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> This flag is set unless we can be sure the caller isn't in an atomic
> context.
> 
> The allocator will soon start needing to call set_direct_map_* APIs
> which cannot be called with IRQs off. It will need to do this even
> before direct reclaim is possible.
> 
> Despite the fact that, in principle, ALLOC_NOBLOCK is distinct from
> __GFP_DIRECT_RECLAIM, in order to avoid introducing a GFP flag, just
> infer the former based on whether the caller set the latter. This means
> that, in practice, ALLOC_NOBLOCK is just !__GFP_DIRECT_RECLAIM, except
> that it is not influenced by gfp_allowed_mask. This could change later,
> though.

I don't think it should change later? We wouldn't want false positives
during boot, or what do you have in mind?
I wonder if the implementation of the "not influenced" is correct though...

> Call it ALLOC_NOBLOCK in order to try and mitigate confusion vs the
> recently-removed ALLOC_NON_BLOCK, which meant something different.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/internal.h   |  1 +
>  mm/page_alloc.c | 29 ++++++++++++++++++++++-------
>  2 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index cc19a90a7933f..865991aca06ea 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1431,6 +1431,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
>  #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
>  #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
>  #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
> +#define ALLOC_NOBLOCK	       0x1000 /* Caller may be atomic */
>  
>  /* Flags that allow allocations below the min watermark. */
>  #define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9a07c552a1f8a..83d06a6db6433 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4608,6 +4608,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
>  
>  	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
> +		alloc_flags |= ALLOC_NOBLOCK;

When this is called from __alloc_pages_slowpath(), gfp_allowed_mask is
already applied, so it will be influenced.

> +
>  		/*
>  		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
>  		 * if it can't schedule.
> @@ -4801,14 +4803,13 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
>  
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
> -						struct alloc_context *ac)
> +		       struct alloc_context *ac, unsigned int alloc_flags)
>  {
>  	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
>  	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
>  	bool nofail = gfp_mask & __GFP_NOFAIL;
>  	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
>  	struct page *page = NULL;
> -	unsigned int alloc_flags;
>  	unsigned long did_some_progress;
>  	enum compact_priority compact_priority;
>  	enum compact_result compact_result;
> @@ -4860,7 +4861,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	 * kswapd needs to be woken up, and to avoid the cost of setting up
>  	 * alloc_flags precisely. So we do that now.
>  	 */
> -	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
> +	alloc_flags |= gfp_to_alloc_flags(gfp_mask, order);

Is it safe to just combine them? You come with ALLOC_WMARK_LOW and combine
with ALLOC_WMARK_MIN from gfp_to_alloc_flags() but these are not bit flags,
I think you end up with ALLOC_WMARK_LOW effectively.
Probably you need to pass the old alloc_flags to gfp_to_alloc_flags, mask
only ALLOC_NOBLOCK from it and combine with newly calculated alloc_flags. By
not recomputing ALLOC_NOBLOCK you also avoid the problem pointed out above?

(or we decide to not use gfp flag but a new function and then it's more like
what alloc_frozen_pages_nolock_noprof() does).

>  
>  	/*
>  	 * We need to recalculate the starting point for the zonelist iterator
> @@ -5086,6 +5087,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	return page;
>  }
>  
> +static inline unsigned int init_alloc_flags(gfp_t gfp_mask, unsigned int flags)
> +{
> +	/*
> +	 * If the caller allowed __GFP_DIRECT_RECLAIM, they can't be atomic.
> +	 * Note this is a separate determination from whether direct reclaim is
> +	 * actually allowed, it must happen before applying gfp_allowed_mask.
> +	 */
> +	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
> +		flags |= ALLOC_NOBLOCK;
> +	return flags;
> +}
> +
>  static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  		int preferred_nid, nodemask_t *nodemask,
>  		struct alloc_context *ac, gfp_t *alloc_gfp,
> @@ -5166,7 +5179,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	struct list_head *pcp_list;
>  	struct alloc_context ac;
>  	gfp_t alloc_gfp;
> -	unsigned int alloc_flags = ALLOC_WMARK_LOW;
> +	unsigned int alloc_flags = init_alloc_flags(gfp, ALLOC_WMARK_LOW);
>  	int nr_populated = 0, nr_account = 0;
>  
>  	/*
> @@ -5307,7 +5320,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  		int preferred_nid, nodemask_t *nodemask)
>  {
>  	struct page *page;
> -	unsigned int alloc_flags = ALLOC_WMARK_LOW;
> +	unsigned int alloc_flags = init_alloc_flags(gfp, ALLOC_WMARK_LOW);
>  	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
>  	struct alloc_context ac = { };
>  
> @@ -5352,7 +5365,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  	 */
>  	ac.nodemask = nodemask;
>  
> -	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
> +	page = __alloc_pages_slowpath(alloc_gfp, order, &ac, alloc_flags);
>  
>  out:
>  	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
> @@ -7872,11 +7885,13 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
>  	 */
>  	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
>  			| gfp_flags;
> -	unsigned int alloc_flags = ALLOC_TRYLOCK;
> +	unsigned int alloc_flags = init_alloc_flags(alloc_gfp, ALLOC_TRYLOCK);
>  	struct alloc_context ac = { };
>  	struct page *page;
>  
>  	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
> +	VM_WARN_ON_ONCE(!(alloc_flags & ALLOC_NOBLOCK));
> +
>  	/*
>  	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
>  	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
> 


