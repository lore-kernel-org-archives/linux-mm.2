Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C17DCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 18:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A996B0005; Thu, 28 May 2026 14:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352306B008A; Thu, 28 May 2026 14:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2686E6B008C; Thu, 28 May 2026 14:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 177AD6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:24:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7376140914
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:24:27 +0000 (UTC)
X-FDA: 84817653774.19.46196F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B5F6C1A0009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:24:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9vGQZ6P;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779992665; a=rsa-sha256;
	cv=none;
	b=kjxvc1EYZ4yaGHM9aLN9PyrGtd0caNVy/uNSZVgbbzpnwWKrYK6sFzhC7H8ChebibzTg9X
	ity6lFHLVLk462NgxH/NRpk+yZt60x0Tm3xi5w3/NBzmFjGstUEypy1KAvvlg0JmpJtafj
	F2rTBJwqy7v3KGLBvRibgANZkosSpHU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9vGQZ6P;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779992665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gB4nu31yDCvzFZgkpHNlp8skj58NUE9KQQaYhdOVdhw=;
	b=e6T7v09teuxwcxr9HBd05krAQAmMu/XOLFvZFvwv0PSaic2SOVQ/RHzUieu1MjSAbuqYgN
	H7rwvnFTwPuKaA2Ev1N5QYviZH1+AKGLZz8DbxhQWi8BuvVwCOJJIacxROzoogO8X67pQX
	HWaF+YkDmiI8DUJL+qufGiIImoiyYRk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0B3F418A1;
	Thu, 28 May 2026 18:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990851F000E9;
	Thu, 28 May 2026 18:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779992664;
	bh=gB4nu31yDCvzFZgkpHNlp8skj58NUE9KQQaYhdOVdhw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f9vGQZ6Pe9ocW5MvHzpFT+VZrU4hVYBEl4eVp14GRFda4FPq5o9xIWklJ/rrpVXFI
	 6//KYPeBd2BxM8zQtEqbEOlOD/7uyCU+CEOQpwD7IrjmzZaLnyD+S3Pd5Y95UGcfvj
	 H09Qqv1Pw1xOvphodYgKrD0/jteonfbvID/pzIs5BTpjQQuitkEEoH0aZbs2mMs/Iy
	 W9fsgtRAaDM8+EDyJ1wrc2hhP673KYLf70SelWLEBeZ1SSbt3ahk8YEJsZcOBtdnio
	 j/1wsfbwbqYcqNo5jkQgVRukoLzwrFFiNg2/fGMGunnyviyRC7HG75XZO5uJiTn7Ws
	 Wp+AuAF3Wl8IA==
Message-ID: <0a805d5f-079a-4eaa-ae37-6b7355a96626@kernel.org>
Date: Thu, 28 May 2026 20:24:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: respect cpusets when checking retry
 suitability
Content-Language: en-US
To: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
References: <tencent_F59F2BA2CC5779308E10DF54593C736D3E0A@qq.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <tencent_F59F2BA2CC5779308E10DF54593C736D3E0A@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B5F6C1A0009
X-Rspamd-Server: rspam03
X-Stat-Signature: 5e7mowwperi4oh8xjsadhxsfqxnotj3k
X-HE-Tag: 1779992665-393796
X-HE-Meta: U2FsdGVkX1//jUefcNjDnZ5WRdUAQGa6skjD/vwI7lYulTEzOqfONv2a6OdBsKvm46y4caF4FsUWonZeIg/EkE4ZnUzKNGJph6qUVVa4iNr5OO/YJ6/4Xmcc5JeKRBTUPH7Y+6sNUTSrIwNJIbMTzAtKRQ8sIal25qkk+4HFQTFX4PSFo7b9oTD0fWAUCTo592jOfFCqiFCwo2y1+F4fkwD8ER8qJQMddf0tpNR1ZrWle25jhwxoye2xnIbu5n1DN4KzKcIANO534Cr0dR/OiuaMKqIeQVuKMYZ9efz2gA0jcGXwciR3QeVN+ZfGYNHSWBGrcBkgEgRp9D2jwYN0VkUt1DFWHwbaYUteVw89fY2HuBlgIda5U2lwJ21JQGCjUANQ9/ZdxSxdZ8vrGH4s+DXSfr6BlmlXjldKNuybd3mSfqXVp/XUriJojOFD105JoE4ADkJciQxIeZqWn3suWQVsffDCCvX2seWqcAVF00qZuMssy1NeuOPF1IPFp+By7cAMs8lxlBUP6QGi1MDO4oDiU6++lzK1FaJze+8Lhm8Ju5xS9rL6F7bs2nDV411UiOg39Ig/Z0Dvds5bjgqvO5sG5OVLlcu8cZcilhadsJgCGxOlv56V57xw5Fw361E+Hb02ZjmsP9osPfJc/g8N//UxNxb+zPBOqwPUPJmy4z0+fg6A6uAbFif9vrD5hFERU7IC4TIOXlWMkixyaAK2ppeeGH3WWMjDw2SFx4ByGDPRv2891ILCKXr0LT0EIWU3LNTWyo2dBIjqznxKB7JGAbNd1Kqr3ayHcKvL3J28JJCsAr/gtdGHGDYZNSulKX1ricUJXNZxC/sMv8N6eSZteu3rnxzIXloRlB/T6Qfwz9+Icb4AN/736p2cLTR77bL4ChnopcLTFJpg48CfAGXwuhVHl6VDweq19jIaA8I+CoH7JJ/nYuJ8+vN6tZmT9DAv7FpCAWdF5WlcqxERmqy
 4fWBr+8Y
 DAkBf4gRwewR7YyIqeh1zMmzD0bSZukXN66TemnZSoJwY+usehLhWFg85aVanmR360wSxkC83vXQJMS3C0O5a++9a/3E3cRG5usycGqdZdx2+9pORcsCDfLx1xAsQau2/kk8o+cwxeBjk/IYiHwkYge7w/l49JEAUyNQ56Bx5E6K4t8Papxl1F0EToK4qcDNvOjhmH1kLDpmQ8qQI8GOP6Gr4zN8ndmmORnSJTc5xORu2hCnkzr27+eha7nIPrG4H91pV5TSujiQCKBLIS2dXrYNbLGAGKo65Dw12VYEIW8m2BpeQJTYh2x3zXk03fMDmXW1DYXt6v6vaTCMLFR5LOz9pZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 14:22, fujunjie wrote:
> should_compact_retry() handles COMPACT_SKIPPED by asking
> compaction_zonelist_suitable() whether reclaim can make a later
> compaction attempt worthwhile. That answer is used for the current
> allocation, so it should follow the same zone eligibility rules as the
> allocation itself.
> 
> When cpusets are enabled, allocator slowpath decisions are marked with
> ALLOC_CPUSET. The allocation path, direct compaction and reclaim retry
> all skip zones rejected by __cpuset_zone_allowed().
> 
> compaction_zonelist_suitable() does not apply that filter. It only walks
> ac->zonelist/ac->nodemask, so it can return true because a zone that is
> not usable for the current allocation would pass __compaction_suitable().
> 
> That does not let the allocation use the disallowed zone. Later
> allocation and direct compaction paths still apply cpuset filtering.
> However, it can make should_compact_retry() retry based on memory that
> this allocation cannot use.
> 
> Pass gfp_mask down and apply the same ALLOC_CPUSET check in
> compaction_zonelist_suitable(). This keeps the retry decision aligned
> with the zones that the allocation is allowed to use.

Nice find.

> A temporary debugfs probe was also used to call the old and new
> compaction_zonelist_suitable() predicates in the same two-node NUMA guest.
> The task was restricted to mems=0 while ac->nodemask covered nodes 0-1.
> After putting pressure on node0, node0 failed __compaction_suitable() for
> order-10 and node1 passed it, but node1 was rejected by
> __cpuset_zone_allowed(). In that state the old predicate returned true and
> the patched predicate returned false.

Nice that you verified it like this.

> Signed-off-by: fujunjie <fujunjie1@qq.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Also probably this? That commit introduced the other cpuset checks for
direct compaction.

Fixes: 435b3894e742 ("mm:page_alloc: fix the NULL ac->nodemask in
__alloc_pages_slowpath()")

(not stable material though)

Thanks!

> ---
>  include/linux/compaction.h |  2 +-
>  mm/compaction.c            |  6 +++++-
>  mm/page_alloc.c            | 15 +++++++++------
>  3 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> index 173d9c07a895..c829c48d1c71 100644
> --- a/include/linux/compaction.h
> +++ b/include/linux/compaction.h
> @@ -101,7 +101,7 @@ extern void compaction_defer_reset(struct zone *zone, int order,
>  				bool alloc_success);
>  
>  bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
> -					int alloc_flags);
> +					int alloc_flags, gfp_t gfp_mask);
>  
>  extern void __meminit kcompactd_run(int nid);
>  extern void __meminit kcompactd_stop(int nid);
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 3648ce22c807..2295b2487dfc 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2447,7 +2447,7 @@ bool compaction_suitable(struct zone *zone, int order, unsigned long watermark,
>  
>  /* Used by direct reclaimers */
>  bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
> -		int alloc_flags)
> +		int alloc_flags, gfp_t gfp_mask)
>  {
>  	struct zone *zone;
>  	struct zoneref *z;
> @@ -2460,6 +2460,10 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
>  				ac->highest_zoneidx, ac->nodemask) {
>  		unsigned long available;
>  
> +		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
> +		    !__cpuset_zone_allowed(zone, gfp_mask))
> +			continue;
> +
>  		/*
>  		 * Do not consider all the reclaimable memory because we do not
>  		 * want to trash just for a single high order allocation which
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ddeb79fa12db..93d56ba339fb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4199,7 +4199,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  }
>  
>  static inline bool
> -should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
> +should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
> +		     int alloc_flags,
>  		     enum compact_result compact_result,
>  		     enum compact_priority *compact_priority,
>  		     int *compaction_retries)
> @@ -4221,7 +4222,8 @@ should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
>  	 * migration targets. Continue if reclaim can help.
>  	 */
>  	if (compact_result == COMPACT_SKIPPED) {
> -		ret = compaction_zonelist_suitable(ac, order, alloc_flags);
> +		ret = compaction_zonelist_suitable(ac, order, alloc_flags,
> +						   gfp_mask);
>  		goto out;
>  	}
>  
> @@ -4274,7 +4276,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  }
>  
>  static inline bool
> -should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
> +should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
> +		     int alloc_flags,
>  		     enum compact_result compact_result,
>  		     enum compact_priority *compact_priority,
>  		     int *compaction_retries)
> @@ -4892,9 +4895,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	 * of free memory (see __compaction_suitable)
>  	 */
>  	if (did_some_progress > 0 && can_compact &&
> -			should_compact_retry(ac, order, alloc_flags,
> -				compact_result, &compact_priority,
> -				&compaction_retries))
> +	    should_compact_retry(gfp_mask, ac, order, alloc_flags,
> +				 compact_result, &compact_priority,
> +				 &compaction_retries))
>  		goto retry;
>  
>  	/* Reclaim/compaction failed to prevent the fallback */
> 
> base-commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7


