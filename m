Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ECF3C531D1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1CD6B0096; Thu, 23 Jul 2026 11:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79306B0098; Thu, 23 Jul 2026 11:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92AB6B0099; Thu, 23 Jul 2026 11:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 655C86B0096
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:13:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A3634051D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:13:31 +0000 (UTC)
X-FDA: 85020385422.28.C475B15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 716754000E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:13:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4+cOItT;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784819609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HoPBMTykAXQKt94M9v95tVhkcDwfjpfMlCnu/Xxm4ds=;
	b=gpjI5lpYS3WAajw4GXP9qWevMPhAuyxEvGEO7rqdIeoH5Ro08G0pjcALgv/YYCWu1svo4T
	hMZ0WK3LFdKqsjIZOGA48CHdYwqPKGjGv8ICVyDHfZ+KK8/i34245s+xoZ2tFoFOSLL96U
	zIzptSgS0adbfJXzbRdBBeGUWOPOcp8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4+cOItT;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784819609;
	b=eY+ZVyQpEVDPkfw7KenNHPdmkW/pWr5c2oZFB71WWEq7LESz+ZL6OAzywaqsigTvnwOmzj
	m1LGyTRtlWONiB4Ujf6/IVukoKclLACnNksnZGDuAh0H6IUSFj+yrw0wRXlFpmkoZvh96M
	qkdRIZ1v1+6k3zLTXk87J68W1NNUy88=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0B2660A71;
	Thu, 23 Jul 2026 15:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EB41F000E9;
	Thu, 23 Jul 2026 15:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784819608;
	bh=HoPBMTykAXQKt94M9v95tVhkcDwfjpfMlCnu/Xxm4ds=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C4+cOItT0PnzdfroCEjzlIBcCT0iIVNJSMJ00DEA+XRUedcSK6kfHfm+olDKn9cvS
	 RuYLPUeq8jIyqtW9cYE7NmaPAeTYXW/QatXLgk7nbo3wAS1g170Ogvc0CJdqOOWKYq
	 bAuXzmxNp2eZ1vblRVf7VC7++Nf1+AlokNWcQxqwwNbBZ5k67EBaaiW3GKwW/Z9zy7
	 Y/pQu3lVPRBYIjjeMC5JRXrhN76RBHxvwOFSVP87Poe5dln9KLLpey8rcmjaVWdlrw
	 ozFj8yBt5plg+LI3gv/RC/zaMEVVhxvBToTzbv9ckomOw3NTlmt+yWI0jZMFnZN6ZZ
	 fcBJo+594FICw==
Message-ID: <5a0702a3-9aa1-48e5-bbd8-924289fb1993@kernel.org>
Date: Thu, 23 Jul 2026 17:13:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-5-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260722150006.3848560-5-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 716754000E
X-Rspam-User: 
X-Stat-Signature: antpcgami3q49z1bgq8wux3uyage1k78
X-Rspamd-Server: rspam04
X-HE-Tag: 1784819609-946920
X-HE-Meta: U2FsdGVkX19sBQbhomThtIhdkmyEpQnt25aGGKMBND6rmEdHvn5bE8Jiz7yh8GslBMdAMpVZeTNxbAOvZddAVaWtv5D0Y68+OVq2TkE4vvm1VoV9bPqbphUkQfphCWL1Z0sxqrwXGOEys8Z85UJmwn6+X7jM5g8HVtCBFR+oLzZgsaG1JDsop0c48N2XuMLUok9/CtCqvaZtBtZlCrUGIb+gfHifLqka6PKvIGMEOSV+2rYmqbgF+PPR04iGaQJVJBUjSHJp9jYgD5A1c9avEX7EAzkwEGi9rujVB/2bt+T1qL0o+ip4e/wGClZDAJN6s3AxiZDCigat9PxJQfnPGKMVEsBvWhyTE/nZw8FeUqXCH1//9gwWneiB9RRou5vPzpwfab0RyQzutRNlzSfw8kWk7eXx4vM6e7aTywQf9fMp6mg3zPzFZde+d5FOcEKlkwDgjCDk+UjPxm7h+lfS+/fRZYmzpbqrqPIKFeSWd/yqX3Pdvy+ox7VB//F6infHwvkucCV5WM1h22jp9o/spU7owLMIYd9TGpD4BtR+QogEEuQKx4rYT34GewICb7OZYc5RyXHJ9Gr+G0dYSiqk1JgE/fHwfdOu7mDiyImAu8+v68efzf74GKs4CVIdP5ZDWs1/XmHEo/yGs/hwF9IdAgB2FBolf3iCbbHUVUXBaVaAFjfm5lc+/E2ADiEIdjiI0CMiIPjl27tAhExwGguzr5v8af6WKtQ/I0BFjaexN8cxhI+TcIUCVv0jO4pEwlC8YN+4gwTEMdkLCK7/b4BFT00W59h2Zf/sv8vAroFTxHwoVYnabSWwDojFJZwXwUX+s8mXOxBA5LlhPp86Pgtae9z+eQ2hLCqeQ9J6c6NlTniVlDPrHH9FuCh5seFQHD4Ceg2HAoWgPim6rGOI38Fi4QCcLGmyJgf1dLvaGZ3qN11QQMmrIkDkWHJGFxsamqd74f7U1p6zdQgG5UEJKjW
 pj/TUce6
 0w0Te0nJak3qmIUA8T65U4wfrmBw45UbbhzQAlXazlnPWAXeFXERRsCebDoqXsM994Av2V+RBYoLGjJa9BuJ79Kz93CDmmUg3gAprDRlmFsiY9Ql0TgzOVg48UpQpBvlkj4CE0NKAglFyYIS/By1OIKH/WtUq0sUiioFJKRMYU7MOyRlbfXK8WrM7pc2qr2Md6oPfxlzuT5ny3J2UahbVn4NOeAiO61BhriTzrx7CY28XFwk4e7p679XyfAPEVw/x/UTfk9gaO8DYM7R0NS9qbLSvxRBF0edM1wVtcG3A225QjdVSH7WUBTuuyEq1Xi4wVBLETnXu9ZYaunud8T2AfS85SxjgHxSJN0e6tOAtQ7nD37PKKZamLW3wEiA9q1nGl6umVZmQwe9WwRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 16:56, Johannes Weiner wrote:
> As we deployed defrag_mode into Meta production, pressure spikes and
> excessive swapping were observed on some workloads. Tracing confirmed
> that this is unmovable/reclaimable requests spinning in the allocator
> and direct reclaim, causing excessive amounts of swap.
> 
> The initial plan for defrag_mode was to rely on kswapd/kcompactd to
> produce blocks, and if those are overwhelmed under high pressure, let
> the allocator fall back (__rmqueue_steal()) after its retry loops.
> However, that retrying results in more reclaim on some of these
> workloads than we'd hoped, sometimes excessively so, spurred on by the
> !costly order conditions in should_reclaim_retry().
> 
> The storms are dependent on the request type. Reclaim will inevitably
> make room in existing movable blocks, since that's where the LRU pages
> live. So if movable requests retry on reclaim, they make progress.
> 
> When non-movable requests spin in reclaim that isn't productive. They
> cannot use the individually freed pages, and the process is unlikely
> to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
> They spin and overreclaim excessively, which tanks performance and
> triggers userspace guards like swap exhaustion or pressure based OOM.
> 
> To fix this, send non-movable requests, regardless of order, into
> pageblock reclaim/compaction. This way, they help move things along to
> meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
> and excess OOM rates are no longer observed in production.
> 
> The longer-term plan is still to have all requests, including the
> movable ones, help make blocks to spread the cost of defragmenting
> more evenly and fairly; combined with proper watermarking to reduce
> allocation latencies in the common case. However, doing this naively
> unearths scaling and concurrency limitations in compaction that need
> to be addressed first. Promoting just non-movables for now is the
> minimally viable bug fix for the above issue.
> 
> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/internal.h   |  6 ++++++
>  mm/page_alloc.c | 31 ++++++++++++++++++++++++++-----
>  2 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 6d3402001b93..5acba3470659 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1061,6 +1061,12 @@ struct compact_control {
>  struct capture_control {
>  	struct zone *zone;
>  	int migratetype;
> +	/*
> +	 * Allocation request order. May differ from the compaction
> +	 * order: defrag_mode promotes sub-block allocations to
> +	 * pageblock-order compaction; capture still matches at the
> +	 * original allocation order so prep_new_page() is consistent.
> +	 */

Yeah, a premature capture can't jeopardize the full-pageblock clearing
because compaction_capture() disallows capturing <pageblock_order page from
MOVABLE pageblock for !MOVABLE allocations.

It's thus unlikely the capture will ever succeed in these scenarios. But
it's not wrong.

>  	int order;
>  	struct page *page;
>  };
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4b9686fedb71..f92055827ae9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4152,8 +4152,24 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  		.order = order,
>  		.page = NULL,
>  	};
> +	int compact_order = order;
>  
> -	if (!order)
> +	/*
> +	 * If fallbacks are not permitted (defrag_mode), we either
> +	 * need to reclaim space in a block of matching type, or clear
> +	 * out an entire block to allow __rmqueue_claim() to convert.
> +	 *
> +	 * Reclaim by itself is primarily freeing space in movable
> +	 * blocks, since that's where the LRU pages live. So this
> +	 * works for movable requests, but not for others.
> +	 *
> +	 * For those, promote the order to help make blocks, instead
> +	 * of spinning in reclaim alone unproductively.
> +	 */
> +	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> +		compact_order = max(order, pageblock_order);
> +
> +	if (!compact_order)
>  		return NULL;
>  
>  	psi_memstall_enter(&pflags);
> @@ -4169,8 +4185,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	barrier();
>  	WRITE_ONCE(current->capture_control, &capc);
>  
> -	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
> -							       prio, &capc);
> +	*compact_result = try_to_compact_pages(gfp_mask, compact_order,
> +					       alloc_flags, ac, prio, &capc);
>  
>  	/*
>  	 * Make sure we hide capture control first before we read the captured
> @@ -4215,7 +4231,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  		struct zone *zone = page_zone(page);
>  
>  		zone->compact_blockskip_flush = false;
> -		compaction_defer_reset(zone, order, true);
> +		compaction_defer_reset(zone, compact_order, true);
>  		count_vm_event(COMPACTSUCCESS);
>  		return page;
>  	}
> @@ -4455,9 +4471,14 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  	struct page *page = NULL;
>  	unsigned long pflags;
>  	bool drained = false;
> +	int reclaim_order = order;
> +
> +	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
> +	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> +		reclaim_order = max(order, pageblock_order);
>  
>  	psi_memstall_enter(&pflags);
> -	*did_some_progress = __perform_reclaim(gfp_mask, order, ac);
> +	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
>  	if (unlikely(!(*did_some_progress)))
>  		goto out;
>  


