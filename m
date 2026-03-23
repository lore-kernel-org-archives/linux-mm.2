Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893BFF46111
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F412D6B008C; Mon, 23 Mar 2026 09:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19836B0092; Mon, 23 Mar 2026 09:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E569A6B0093; Mon, 23 Mar 2026 09:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3DEA6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:36:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D93413BFF8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:36:34 +0000 (UTC)
X-FDA: 84577427508.25.DC6FD55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C0D9120008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:36:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BO9uapdY;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774272992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFZpkgpB8Q9WOcXyrerLafB/jFrEEVBBRRjjUAtQZEM=;
	b=BIzG5M4Q1y1JRXKpZkxVjeSkXuBprs4T5xL423IrhMT2H/S9HmhhWAwnIEXvUiExQXGb3L
	2vhnOgGj6ou8OabUAHpdllhFz+zRQ/WbuKmhxycs8eHW/XbaB174CNxsw7l8GvzCHiRZxy
	rbVYBfAzw9obV6vt7z/YXeUeC3Hs00A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BO9uapdY;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774272992; a=rsa-sha256;
	cv=none;
	b=TFqKItiS4vaxmzcH+NSsQDaZY8TgoWPR6jEa5/YgGNfHPrq70pG3p2t42RgrIr8LPlwllR
	huULeunsAKuqasv56lx6OjYixGyD3UCH8sQJsV3nB4Ze+K7ZZjVI72VHO5h/Ei1NQOKr3g
	jlcpzK08UkdzHWk72HqbReEXtXSOOLQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4099F600CB;
	Mon, 23 Mar 2026 13:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8D5C2BC9E;
	Mon, 23 Mar 2026 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774272991;
	bh=CPpDOfhpdW9UBLtwsezPEAAxhyR2+9b1dCeOhUI5JGQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BO9uapdYjE0Kvpst573nixVmOGKL3AhixRvJB0IGJRs6pLvII6DVOdZd5tv0R2Pit
	 UaPMiUqUbaZcRHHQh5SDOQaFT0NmR/wCthC3xqMQ2E/MWmEIUGN7+8fzZXO3hPH4pw
	 K0lmplr7nfH49zdAHS9cm+zqIwrKCJ/bUlBtQBIBf6bDiZ3lxKXgXI62aFR9+g6v+W
	 MCeB5N8aECpgkXhMyKOE4UnxRN+cCAg0KSQ+/4UkHs4gQyXIrhDvWi25HaXO0gLRlW
	 JKcs9KnFCM62E7op1Xu9SkZvz+PWlu63FoYXOxh3LKO1xHzGH+4qbF6hbtVaIopZhs
	 1MNLV8L8o7CAg==
Message-ID: <44aadc9c-28d2-497d-ba4e-659517e8ca47@kernel.org>
Date: Mon, 23 Mar 2026 14:36:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: don't increase highatomic reserve after
 pcp alloc
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zhiguo Jiang <justinjiang@vivo.com>
References: <20260320173426.1831267-1-fvdl@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260320173426.1831267-1-fvdl@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C0D9120008
X-Rspamd-Server: rspam08
X-Stat-Signature: ozibua8ouc5psrqmrikeurntzstaiokg
X-HE-Tag: 1774272992-574814
X-HE-Meta: U2FsdGVkX1+y/Dwm07ovG1BikH5dDOvXP4gzUZ1yZ2UcUCHQDUr6RvkePXnfUcllkkX+D4Tp3i4xUcUAyI2mLwMmEohfTGfEoR7/BWTCvsFQIurSvwcoERamKV7unSsx8ADZ4up9HjTs6cQThNaZEzNXiwVZbWtS4ZcjlC5CRdrPDDCp8P8UWxRR+MK7PvVMXUxxGVUnrMv9LPM2sbEjyB2TpIsmyNmAqzDLDHTM6tyF2fXSjRlfN8t5fLMSEN4OEobeuxWPafIlx/QT0OlGn1417tQvRlDZEIb1QvCheUt/s7EyBQjikSdDjvaW73Kg2YV/JTh7YyllS3qlr8MNnV5X7PlZVmQNOxyfoz1gNkFeESi/16g3sL9rmZzKjHt6eIl0zxsSRhpSa8WcHlSpGjwxZ3kDsV592yy0wl0VMURHti7v2IjfT2rGaNIgT/LGAB4I15ypbaumDEgMM8qhJMwUsMnuEte2MPoYB1NUKsY3guGjLPTvdXV5GvO72yVvrKfakuTHHU06pvla3tEQAgKEVwfK31aImBDmejLODF1pmLlGhtWi1zZ8X8ojPPEmgcvm35BeQfvJr2x0AdGHYvzb3Y29r1tWwIHwAm5X5Hvg7nApH52YhEpTdSs2kMDM7L3kxWaEFH3+lwgn0daqge8JlHWybMwjwHyWX16PZ0CN02mtY8OMk6dmEhVb9JrqrnlPJNrQWWzhlP42Vu2/QYz8RtMITdRDKagxNLDizIxCTzXkW4wNDff5lQ+mPx1ynd8t7ZdpI7pTyoLg7IWaGr05LTRPVzbCPR0wWPziHCs3ff9BBaEmk1UA0uOBKYyZQEvbyehfZNXDziWgo6ueqBGKuFCuQvqRCobYYoR4vmdo8fH4cWeoFBQYWlPuslRmUfJc8zYnRTk5MbTOsABZaYBUUWcJ1ZWTwrDfWEWmQq1ssRHlY49FzXeFuWHgnS8ReHjtWLaXW7U3yVX7M9+
 4FvCQTuU
 sMt6FSzL5JIFd5X3CijB7A5Ld2XomyvqzdDdOGOnaDzsUVK9AxACU3XnpT/haxQK67uReVWEU5zTi/O1765ReTuujTyrYKBUF+DD0Fk0go3vwy0IH94sLvmrAnRHAp6Bzm/oLZAWyPCatc/Oi5k2AZE1QfsQEg6gmN/2yrRrNETdUIwfaLi7BzbP+i4SDlV1AyGjnI0PZ6jJwpJ+2JBycsW9RZ4nZc8/FuRONzOATm1OBYEQj7WzvAXxWcvETDsf2bky00oV1aIeocqYx6SR6ofp2EvBMJw0vJVqsnAR2te01zS+frzgeUQvTbHV5J+HskluypQt7wVsE0qW/5QVCY75DQhtemCa0x23TJX/NtJuhAwPLJGKmH919gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 6:34 PM, Frank van der Linden wrote:
> Higher order GFP_ATOMIC allocations can be served through a
> PCP list with ALLOC_HIGHATOMIC set. Such an allocation can
> e.g.  happen if a zone is between the low and min watermarks,
> and get_page_from_freelist is retried after the alloc_flags
> are relaxed.
> 
> The call to reserve_highatomic_pageblock() after such a PCP
> allocation will result in an increase every single time:
> the page from the (unmovable) PCP list will never have
> migrate type MIGRATE_HIGHATOMIC, since MIGRATE_HIGHATOMIC
> pages do not appear on the unmovable PCP list. So a new
> pageblock is converted to MIGRATE_HIGHATOMIC.
> 
> Eventually that leads to the maximum of 1% of the zone being
> used up by (often mostly free) MIGRATE_HIGHATOMIC pageblocks,
> for no good reason. Since this space is not available for
> normal allocations, this wastes memory and will push things
> in to reclaim too soon.
> 
> This was observed on a system that ran a test with bursts of
> memory activity, pared with GFP_ATOMIC SLUB activity. These
> would lead to a new slab being allocated with GFP_ATOMIC,
> sometimes hitting the get_page_from_freelist retry path by
> being below the low watermark. While the frequency of those
> allocations was low, it kept adding up over time, and the
> number of MIGRATE_ATOMIC pageblocks kept increasing.
> 
> If a higher order atomic allocation can be served by
> the unmovable PCP list, there is probably no need yet to
> extend the reserves. So, move the check and possible extension
> of the highatomic reserves to the buddy case only, and
> do not refill the PCP list for ALLOC_HIGHATOMIC if it's
> empty. This way, the PCP list is tried for ALLOC_HIGHATOMIC
> for a fast atomic allocation. But it will immediately fall
> back to rmqueue_buddy() if it's empty. In rmqueue_buddy(),
> the MIGRATE_HIGHATOMIC buddy lists are tried first (as before),
> and the reserves are extended only if that fails.
> 
> With this change, the test was stable. Highatomic reserves
> were built up, but to a normal level. No highatomic failures
> were seen.
> 
> This is similar to the patch proposed in [1] by Zhiguo Jiang,
> but re-arranged a bit.
> 
> Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
> Signed-off-by: Frank van der Linden <fvdl@google.com>
> Link: https://lore.kernel.org/all/20231122013925.1507-1-justinjiang@vivo.com/ [1]
> Fixes: 44042b4498728 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")

Makes sense to me and looks ok. Thanks.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..57e17a15dae5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -243,6 +243,8 @@ unsigned int pageblock_order __read_mostly;
>  
>  static void __free_pages_ok(struct page *page, unsigned int order,
>  			    fpi_t fpi_flags);
> +static void reserve_highatomic_pageblock(struct page *page, int order,
> +					 struct zone *zone);
>  
>  /*
>   * results with 256, 32 in the lowmem_reserve sysctl:
> @@ -3275,6 +3277,13 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  		spin_unlock_irqrestore(&zone->lock, flags);
>  	} while (check_new_pages(page, order));
>  
> +	/*
> +	 * If this is a high-order atomic allocation then check
> +	 * if the pageblock should be reserved for the future
> +	 */
> +	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
> +		reserve_highatomic_pageblock(page, order, zone);
> +
>  	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
>  	zone_statistics(preferred_zone, zone, 1);
>  
> @@ -3346,6 +3355,20 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
>  			int batch = nr_pcp_alloc(pcp, zone, order);
>  			int alloced;
>  
> +			/*
> +			 * Don't refill the list for a higher order atomic
> +			 * allocation under memory pressure, as this would
> +			 * not build up any HIGHATOMIC reserves, which
> +			 * might be needed soon.
> +			 *
> +			 * Instead, direct it towards the reserves by
> +			 * returning NULL, which will make the caller fall
> +			 * back to rmqueue_buddy. This will try to use the
> +			 * reserves first and grow them if needed.
> +			 */
> +			if (alloc_flags & ALLOC_HIGHATOMIC)
> +				return NULL;
> +
>  			alloced = rmqueue_bulk(zone, order,
>  					batch, list,
>  					migratetype, alloc_flags);
> @@ -3961,13 +3984,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  		if (page) {
>  			prep_new_page(page, order, gfp_mask, alloc_flags);
>  
> -			/*
> -			 * If this is a high-order atomic allocation then check
> -			 * if the pageblock should be reserved for the future
> -			 */
> -			if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
> -				reserve_highatomic_pageblock(page, order, zone);
> -
>  			return page;
>  		} else {
>  			if (cond_accept_memory(zone, order, alloc_flags))


