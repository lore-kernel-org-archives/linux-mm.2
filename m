Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91BBFC44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 20:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E486B6B008A; Wed, 21 Jan 2026 15:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF996B008C; Wed, 21 Jan 2026 15:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C186B0092; Wed, 21 Jan 2026 15:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF78F6B008A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:56:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 737C5D4233
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:56:07 +0000 (UTC)
X-FDA: 84357178374.28.734385D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9FEAF10000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:56:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wgJ4vhPI;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769028965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zaDkYE9nRp4j4Z8D6WixS34mK9kzRND1dp5rUToGDgM=;
	b=MwE9arRp2wwjWibMjQAIjwvdeIL7f1m3XAwYEScgDX7CMEAe7YSg+WvqSIKH1ZNV2Ge7Xc
	14OK3614D3aIC6vXxM8oMHPo57/fRv2kxyvQGZCL7Z6SfAJoNq5+hS5fD7rW5yDAllrgTf
	5pag8xD0/Scx2lZRueqkCXN41+iWZD8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wgJ4vhPI;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769028965; a=rsa-sha256;
	cv=none;
	b=QaYFvGESoo0Qe7QrbGL/v10aoFvcL3E/O9GRd7Z6+uFohbWt3MEu7ID+hdjhxgUSIjbcHC
	paReOKd6l+9Dv2pT8fnNJik7zuBYDpwdizwgxewxVBCfeqoRMpQPcKn9y0leypVLe1C6mF
	hNiYP+st35vyUPdKbBxP6QtxAVQM47A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A328143611;
	Wed, 21 Jan 2026 20:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E9BC4CEF1;
	Wed, 21 Jan 2026 20:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769028964;
	bh=9c2aN3sKqlycUaVBM4faJ8YchGyPwKANJZQK2n0ZgGc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wgJ4vhPI4ZuqWfn5f95uSj9dcbjm5PvLaRj/uNLJy8MsMCRAGP/H9odeyQh8OkRvr
	 W6zEckqL7UziwR+RJeDyL2a9c8Sftac9KGA6sYqApr5cfLlo8NeNkb2Bx/Ngdej61M
	 7ftnd3/LypZLRJ4URK54hnSZKToFndBEmpeSxsA8=
Date: Wed, 21 Jan 2026 12:56:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: david@kernel.org, mhocko@suse.com, vbabka@suse.cz, willy@infradead.org,
 lance.yang@linux.dev, hannes@cmpxchg.org, surenb@google.com,
 jackmanb@google.com, ziy@nvidia.com, weixugc@google.com, rppt@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v5] mm/page_alloc: boost watermarks on atomic allocation
 failure
Message-Id: <20260121125603.47b204cc8fbe9466b25cce16@linux-foundation.org>
In-Reply-To: <20260121065740.35616-1-realwujing@gmail.com>
References: <20260121065740.35616-1-realwujing@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9FEAF10000C
X-Stat-Signature: xkufh31mi8i8i6rq19eg8pd9iajtpwgg
X-Rspam-User: 
X-HE-Tag: 1769028965-530107
X-HE-Meta: U2FsdGVkX1/3qsbgczjgcxudGvhcMYt1Z4tYwMZYwH48P1/owZDiBazKnGZn7sfVIOM/MRQlsS92WaE5Z0qRfzvRtytN2+/v+WmtJmR01aC9njrgvV82xyw+4fsb+SRn/TOjklvP3CHI5DMNwp62p98RkSFs496KaDmZE0kptgz/APAC8njeck47brZ8CJHwelOxMD57BSmn5Cv7v4cBf4iWnPsjXvt0WTJnxbecINqXLXIq/N0SdfNJ8k22Nhy9VYFRsKNSIBSEVWIYWoHULtU8pygbojQ2s/J4bChdNtmi1ahIs6OZ7+n602fYLY8z3DytpUGQTkRuYryL4sElHHUDAE4h8tu2JPZUdhF1kBsHeTCSNSF+Pn794hK9aQfbgAW4n83faaKCMySogXsNOLn3ssAlxvqzAzdIrGSqrkkkHnQ6OTyOA24Jku5J6DjAjT9OjdoBCeAs7vgIIScXHDsfs1G+4ycSg39cmrvQRr7lsy/kZleRBN4dgWjjO5ceZR6b/9lcSMBsY13jENkJ0naDW3XF5Gmg+dENOJeoNWMy9R9lgd/N5nRDXhY/HbUa5NiHk4cnjtpF9mzwGhjlQu3mXEFzot3GfgqBENKgGifDgOqFsEtPk0Cnq0NV4/+QLHQk3Of8yHuhffLVQtOKbf3ogv7mVEY7Zr8HkHwqaIQt5qyIOJUOLujz0nri8aI2clFro6o+LWUl7tEWen9NRnIGeyfP8g3KblZo+zsO4xa6CzC98S3WxXR9kBp8ZaTAQHGg/hjZswTi8Yo/mRgZV0yWjrGPgBdLagQdU9PbOL3h7uykuvdB6IsKkKzBHZ469MMza/lDQExzx3qV38tvYCuBLUPW4ysnY1MalrfJMFXeavVc9KujHOeFvRMz0xsMDVtdJNMlOuKaPhKbdT884eQZuZZOUppWxmbOzzMDUTFRobg7bI0z5X6p7dKd9q6J0/42xywvbo/14+cbv7n
 s4J1DvlH
 tUgi/hr6t0Z2RVVKUxvsj6cr5h8OTwdQiGoH8kidKwgHuwCFqbEaZzYQg0vukZgivAXqBTsOqiAlkAZWvy8Z7Iv9Cx/jxdAbUGtL1F4VHJWnfwLd2tzh/ylRv3/W/bqkpFzk5m6vu/s4p4TTspU+1R0adH84fgq6uqjwmXzt4rE0/rTrsFmOl6tPCSbKK4pd8x92mim0+rtlSU1+JaF+A7Z2+QF1oOuvOTa0w7V+Kfa/a/jBYS5WnSnTgYT5k0omM6uMQWgcT7EYVlnE16SZLxjuMlSCpBYylnh0KLRZQo8DfQmn2VfO+fWLrqWNpYqg3tjO3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 01:57:40 -0500 Qiliang Yuan <realwujing@gmail.com> wrote:

> Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
> pressure as they cannot enter direct reclaim. This patch introduces a
> 'Soft Boost' mechanism to mitigate this.
> 
> When a GFP_ATOMIC request fails or enters the slowpath, the preferred
> zone's watermark_boost is increased. This triggers kswapd to proactively
> reclaim memory, creating a safety buffer for future atomic bursts.
> 
> To prevent excessive reclaim during packet storms, a 1-second debounce
> timer (last_boost_jiffies) is added to each zone to rate-limit boosts.
> 
> This approach reuses existing watermark_boost infrastructure, ensuring
> minimal overhead and asynchronous background reclaim via kswapd.
> 
> Allocation failure logs:
> [38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
> [38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
> [38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
> [38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
> [38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535649.655523] warn_alloc: 59 callbacks suppressed
> [38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
> [38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

This seems sensible to me - dynamically boost reserves in response to
sustained GFP_ATOMIC allocation failures.

It's very much a networking thing and I expect the networking people
have been looking at these issues for years.  So let's start by cc'ing
them!

Obvious question, which I think was asked before: what about gradually
decreasing those reserves when the packet storm has subsided?

> v4:
>   - Introduced watermark_scale_boost and gradual decay via balance_pgdat.

And there it is, but v5 removed this.  Why?

Or perhaps I'm misreading the implementation.

>   - Added proactive soft-boosting when entering slowpath.
> v3:
>   - Moved debounce timer to per-zone to avoid cross-node interference.
>   - Optimized candidate zone selection to reduce global reclaim pressure.
> v2:
>   - Added basic debounce logic and scaled boosting strength based on zone size.
> v1:
>   - Initial proposal: Basic watermark boost on atomic allocation failure.
> ---
>  include/linux/mmzone.h |  1 +
>  mm/page_alloc.c        | 29 ++++++++++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 75ef7c9f9307..8e37e4e6765b 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -882,6 +882,7 @@ struct zone {
>  	/* zone watermarks, access with *_wmark_pages(zone) macros */
>  	unsigned long _watermark[NR_WMARK];
>  	unsigned long watermark_boost;
> +	unsigned long last_boost_jiffies;
>  
>  	unsigned long nr_reserved_highatomic;
>  	unsigned long nr_free_highatomic;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c380f063e8b7..1faace9e2dc5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2189,12 +2189,31 @@ static inline bool boost_watermark(struct zone *zone)
>  
>  	max_boost = max(pageblock_nr_pages, max_boost);
>  
> -	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
> +	zone->watermark_boost = min(zone->watermark_boost +
> +		max(pageblock_nr_pages, zone_managed_pages(zone) >> 10),

">> 10" is a magic number.  What is the reasoning behind choosing this
value?

>  		max_boost);
>  
>  	return true;
>  }
>  
> +static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
> +{
> +	struct zoneref *z;
> +	struct zone *zone;
> +	unsigned long now = jiffies;
> +
> +	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
> +		/* 1 second debounce to avoid spamming boosts in a burst */
> +		if (time_after(now, zone->last_boost_jiffies + HZ)) {
> +			zone->last_boost_jiffies = now;
> +			if (boost_watermark(zone))
> +				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
> +			/* Only boost the preferred zone to be precise */
> +			break;
> +		}
> +	}
> +}
> +
>  /*
>   * When we are falling back to another migratetype during allocation, should we
>   * try to claim an entire block to satisfy further allocations, instead of
> @@ -4742,6 +4761,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (page)
>  		goto got_pg;
>  
> +	/* Proactively boost for atomic requests entering slowpath */
> +	if ((gfp_mask & GFP_ATOMIC) && order == 0)
> +		boost_zones_for_atomic(ac, gfp_mask);
> +
>  	/*
>  	 * For costly allocations, try direct compaction first, as it's likely
>  	 * that we have enough base pages and don't need to reclaim. For non-
> @@ -4947,6 +4970,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		goto retry;
>  	}
>  fail:
> +	/* Boost watermarks on atomic allocation failure to trigger kswapd */
> +	if (unlikely(page == NULL && (gfp_mask & GFP_ATOMIC) && order == 0))
> +		boost_zones_for_atomic(ac, gfp_mask);
> +
>  	warn_alloc(gfp_mask, ac->nodemask,
>  			"page allocation failure: order:%u", order);
>  got_pg:
> -- 
> 2.51.0

