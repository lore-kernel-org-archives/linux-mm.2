Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D270CCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812896B0088; Tue, 23 Jun 2026 04:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA126B008A; Tue, 23 Jun 2026 04:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7006D6B0092; Tue, 23 Jun 2026 04:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 491056B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:54:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE2C7166C9A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:54:18 +0000 (UTC)
X-FDA: 84910565796.19.25C2100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C94ACC0002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:54:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UUuEh2rX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782204856;
	b=23m2LKjOl+QaZvl7rOoEWEthXS3+qEmyRUdrGfguMnX4My5dRDntrXBYGiC+TjasdOfLwl
	jmm4cncfqtbSh2KK4TVTLn0SuXpI8Y9T9lC/2iax3DXQ3SCDcZx1+3QTNLdtAr6MqrJdyt
	IXhJm5ol7+JuUs77mgYhtewcbLFsRjQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782204856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=esbnX1lB5kt+A69raC0Yi7SAc8yUIkuorJ+xoJqE3yk=;
	b=E8tXe9B76RfKFdCNAJ6S+dtHfSzjg2iw0X+SbtiglJNOR+GJRq+y+Mp8E/r08H+CtZmrCq
	OnrAX+1MC/Mkg7etXWmP8HT1zkJDZb7xrajNQogsCZ4vJbAsvE+wR/ImQbowO4geZg2rIp
	mqftxc2ZlhbwmRkovwe7euovelgrjdg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UUuEh2rX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0139344263;
	Tue, 23 Jun 2026 08:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FC71F000E9;
	Tue, 23 Jun 2026 08:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782204855;
	bh=esbnX1lB5kt+A69raC0Yi7SAc8yUIkuorJ+xoJqE3yk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UUuEh2rX+g76pPzwPkpOfDilXiG+FFZE+qZXWzOJd+wXpCpKvPqma9VusGwYEYaSm
	 7TlUe9xuJKF8bT4h7kPfqw+g5nbbrz/L5NkicP3jK8ZbtCsFGOVpE4nrlRytqXpcaf
	 O0CT+wKbnCE7XFvZtsLsVYV4S19nXl/acxhsZT5SVv3jAYvMzCsFbD53p4ccK4suGN
	 Q8oN0iA5dpN0bKpmlZa/ca0+F9ixUonrR7Ul17p0li9hkhd1d8FQvxghAK1YiagWqD
	 p+qFOBJPaPvovPQbsgyr/npotqydBBrOjIsyX32Xg13rBL6itpfN9IUiXdK5MiXg1i
	 SfIPjBqaeILGA==
Message-ID: <4358ba84-7ed0-48c0-80e4-23a00355315f@kernel.org>
Date: Tue, 23 Jun 2026 10:54:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: use existing highatomic reserves on the
 buddy fastpath
Content-Language: en-US
To: JP Kobryn <jp.kobryn@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, fvdl@google.com, linux-mm@kvack.org
Cc: shakeel.butt@linux.dev, usama.arif@linux.dev, linux-kernel@vger.kernel.org
References: <20260623004600.113347-1-jp.kobryn@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260623004600.113347-1-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C94ACC0002
X-Rspam-User: 
X-Stat-Signature: iuddnfgqginfp96ajbrjh1cxegrkuwtj
X-HE-Tag: 1782204856-209541
X-HE-Meta: U2FsdGVkX1+FLlB7QIiddTSZM612GbfVRqquMN1IbAyp4I5+WCkGv39lzSRCUWDpkEr1o5aMQ966iNLmRJmDP3wRBPkWR1UtFNDIQP1mxg9q4lYLSQLoi6e/lFTq4ZdzQNXrlshkbjvvCFc5kVLOrBPzW8CM8aZSj3CvyWFOpSulCImAAllI7AIfXqD6AR4z0ilNVmxhPweRbC+/7Ru6QLndpKftDwAidgNILGfmu1YAgnH6SIh+Zj0MQHNQrQ0FkpISHsHl2hI5i6ZC6XsUld0ZS7iu25QmQjNjttid2CCBq4UvL35UDHcFUTVF/H0UsXUi5M2Hzzt1xUOd9cg4R1nhJDigtpq+mQxswFWv+tpw+m/uimWzz1MBIKF4fC3tUslCbOdI4zSmAEJdQ2ELERql1i4k1WNN2laSoW+j33N7ChijPLItbeWPAPbq9Utr+86W4IDb+EeaZCJNNypA5KJ/jlFf2Yf8VmKzI9xsRXsjq03KPfMDbp7ZgS5BxoJAIIuo9p7Q8aAIUI8q2xGncEw1EQ345Dp8T8xeBlvDJqhCN8g4Cag9kX5C9sporYYh6ys5mQPFqkFlbg3GqsgxsOKvT4MCPJPA72AmZjiai6qRAaGYiEO7tGxbhJ+2wWwevzsi6Lf5Vt0LIzYK3W2sXaIN7vW2tzvg7Vn5Kpi04B4PgpiEitvJPkjVkX6I0aE8rfyTclQyB/7VCq8+2dPYQcGhtEyXM7CKh6PXoZnm6K5XgJhF+9uCNk6B07JRwvy29jP8rkAAs5pp1pIzFUYgFXLHjFWp9JoZtESM/mB0gn9LcQPS0i5g1mlilpIlBWcKLq0Nv4ICQJsev1bNQGr4DrUpgAPIB4NRhcPkuYkK9Jd1mLyOrty5i33PLKjXQ1OUlJhf2Tgvw/iYPkYepcmra7OjIrzi7V3gH7/JyZJ9SQFra0x5xgIY3GpPQSPx5LSxuWWx2n8wzCP5gwmZSCc
 vn+IhMqZ
 tCt7+MHa8C6RHAr6iz6Jiqk3u7sZk42fq27mQ5rnSCdzfyg74acHFmukTLhp5jOzGKRRbCewxtpJOVLZnstfp910iOojzTDFoCxjATShxJ62HzD2KJbmboHpD+DCFPuMNtmlhYrNODQZOfJtSKFq6Ov3HSt9Q8JAVyQs2jIV8x9nmNG+WIFzEo2H8seX+nbw3r2M8ZsXoZm/p9GGeWWOud6Ba/Ff2LkcxoyGvOV6JeEmAa2a1Rh1R+Bl1/ZIdTMeVUfKt4YdA2AgAOhhZNLdemlZcilB//AbBI222vW64bua33Y0HSSrfh/sfbX47BIV5q/ujtoXiGlu4VE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 02:46, JP Kobryn wrote:
> ALLOC_HIGHATOMIC currently provides both access to MIGRATE_HIGHATOMIC free
> pages and permission to create new highatomic pageblock reserves. This
> makes it unsuitable for the fastpath.
> 
> However, the fastpath can reach rmqueue_buddy() while MIGRATE_HIGHATOMIC
> reserves have free pages available. In this situation, the allocation can
> fall back to other migratetypes without trying those reserves first.
> 
> Allow high-priority non-blocking allocations to use existing
> MIGRATE_HIGHATOMIC reserves on the buddy fastpath without growing them.
> First tighten the criteria for reserving pageblocks so that growth may only
> occur in the slowpath. Then allow fastpath usage by enabling
> ALLOC_HIGHATOMIC when the GFP mask describes a non-blocking high-priority
> allocation. This logic has been factored out from gfp_to_alloc_flags() to a
> new function gfp_to_alloc_flags_nonblocking().
> 
> A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
> available in the target zone. Before this patch, the workload did not
> consume these blocks. With this patch, eligible order-1 allocations
> reaching the buddy path consumed existing MIGRATE_HIGHATOMIC pageblocks,
> with no highatomic misses observed. The workload did not grow highatomic
> reserves and NAPI page-frag allocations remained healthy with no failures
> or order-0 fallbacks.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> v3:
>   - remove ALLOC_HIGHATOMIC_RESERVE and let ALLOC_HIGHATOMIC keep original behavior
>   - use ALLOC_WMARK_MIN to identify slowpath before growing reserve
>   - factor out non-blocking logic from gfp_to_alloc_flags() into *_nonblocking() helper
>   - dropped reviewed-by tag
> 
> v2: https://lore.kernel.org/linux-mm/20260617234958.150339-1-jp.kobryn@linux.dev/
>   - decouple use semantics from ALLOC_HIGHATOMIC_RESERVE
>   - update changelog to reflect above change and reword test paragraph
>   - adjust comment in PCP path
> 
> v1: https://lore.kernel.org/linux-mm/20260616191420.52556-1-jp.kobryn@linux.dev/
> 
>  mm/page_alloc.c | 44 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 30 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f7db8f049bd2..7330f22e3f8f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3247,10 +3247,11 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  	} while (check_new_pages(page, order));
>  
>  	/*
> -	 * If this is a high-order atomic allocation then check
> -	 * if the pageblock should be reserved for the future
> +	 * Slowpath (precarious) high-atomic allocations may reserve
> +	 * a pageblock for future use.
>  	 */
> -	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
> +	if (unlikely((alloc_flags & ALLOC_HIGHATOMIC) &&
> +			((alloc_flags & ALLOC_WMARK_MASK) == ALLOC_WMARK_MIN)))
>  		reserve_highatomic_pageblock(page, order, zone);
>  
>  	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
> @@ -4473,6 +4474,29 @@ static void wake_all_kswapds(unsigned int order, gfp_t gfp_mask,
>  	}
>  }
>  
> +static inline unsigned int
> +gfp_to_alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
> +{
> +	unsigned int alloc_flags = 0;
> +
> +	if (gfp_mask & __GFP_DIRECT_RECLAIM)
> +		return 0;
> +
> +	/*
> +	 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
> +	 * if it can't schedule.
> +	 */
> +	if (gfp_mask & __GFP_NOMEMALLOC)
> +		return 0;
> +
> +	alloc_flags |= ALLOC_NON_BLOCK;
> +
> +	if (order > 0 && (gfp_mask & __GFP_HIGH))
> +		alloc_flags |= ALLOC_HIGHATOMIC;
> +
> +	return alloc_flags;
> +}
> +
>  static inline unsigned int
>  gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  {
> @@ -4495,18 +4519,9 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  	alloc_flags |= (__force int)
>  		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
>  
> -	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
> -		/*
> -		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
> -		 * if it can't schedule.
> -		 */
> -		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
> -			alloc_flags |= ALLOC_NON_BLOCK;
> -
> -			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
> -				alloc_flags |= ALLOC_HIGHATOMIC;
> -		}
> +	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp_mask, order);
>  
> +	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
>  		/*
>  		 * Ignore cpuset mems for non-blocking __GFP_HIGH (probably
>  		 * GFP_ATOMIC) rather than fail, see the comment for
> @@ -5299,6 +5314,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  	 * memory until all local zones are considered.
>  	 */
>  	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
> +	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
>  
>  	/* First allocation attempt */
>  	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);


