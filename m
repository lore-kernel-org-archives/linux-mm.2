Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBB1CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 13:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A53A8E000E; Fri, 10 Oct 2025 09:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77CB48E0003; Fri, 10 Oct 2025 09:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B258E000E; Fri, 10 Oct 2025 09:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECF18E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:37:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2ED21DF815
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:37:27 +0000 (UTC)
X-FDA: 83982306534.28.0CB7F92
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3D5F218000D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:37:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gb6Yyrha;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OkzzenWj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gb6Yyrha;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OkzzenWj;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760103445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvcYTxYRDtgRrenJeRWs489UP+bUBsVp/05Xpv/hSxM=;
	b=IkR5uoIc2o1Q0fRulSlpxnX+hJObIuuv5D/F3iR62G5RDRDFl8h83+csPsyw5uV/Oz6kgL
	4WBpt88tQEr3TvGJvqe/rwjB3mCJ0YHohvROJgwh7r+TKws/ZK22PPRptgfBbhucoU0M6u
	dwdEzTuHiX/MxsUq35R8dTz3eTKGuYc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gb6Yyrha;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OkzzenWj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gb6Yyrha;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OkzzenWj;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760103445; a=rsa-sha256;
	cv=none;
	b=SlYYfeKqWp+IjnJ9FY4eYx4eBTvRU4Z2AyMploJpac6ZEdBeqb8TchIYOTnNhTHGfwLRRI
	TRv3cs2GAkR3+8hr98jtOAck6VUIWmgrD+sRQIB5zytCMjRLLHCLzPKm/4w5qeD+guT+ZQ
	h66XQJu5O7fm7O0RG7447M63+pw6TlI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 684C31F747;
	Fri, 10 Oct 2025 13:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760103443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YvcYTxYRDtgRrenJeRWs489UP+bUBsVp/05Xpv/hSxM=;
	b=Gb6YyrhaohqP66OvvfGt1yEKij0xSk+DcWu84T7+sqGkZa5xWwW1w0HBMBC+5dATwQXr8U
	jk/QMcGTnjvgvd2lcXbU7VtbAXM/ogeIgEAJ4fKRaMBJrwFBMFoDwHl/jVerwkqOEtYlxH
	CRljpAPJKJCrzhhFMXkY5VUz1jEUpK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760103443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YvcYTxYRDtgRrenJeRWs489UP+bUBsVp/05Xpv/hSxM=;
	b=OkzzenWjC34QhDfzXyVu+SPSXG5rzheK4hmOWk45UZo4fxEYjIOB7xrgrY1xPPyk71U8UB
	xMnsSBTqz1bx8TCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760103443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YvcYTxYRDtgRrenJeRWs489UP+bUBsVp/05Xpv/hSxM=;
	b=Gb6YyrhaohqP66OvvfGt1yEKij0xSk+DcWu84T7+sqGkZa5xWwW1w0HBMBC+5dATwQXr8U
	jk/QMcGTnjvgvd2lcXbU7VtbAXM/ogeIgEAJ4fKRaMBJrwFBMFoDwHl/jVerwkqOEtYlxH
	CRljpAPJKJCrzhhFMXkY5VUz1jEUpK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760103443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YvcYTxYRDtgRrenJeRWs489UP+bUBsVp/05Xpv/hSxM=;
	b=OkzzenWjC34QhDfzXyVu+SPSXG5rzheK4hmOWk45UZo4fxEYjIOB7xrgrY1xPPyk71U8UB
	xMnsSBTqz1bx8TCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5000E1375D;
	Fri, 10 Oct 2025 13:37:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rH4yExMM6WgZZQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 10 Oct 2025 13:37:23 +0000
Message-ID: <c48ae6d5-3a04-4c32-8084-33d2e10d8d2e@suse.cz>
Date: Fri, 10 Oct 2025 15:37:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm/page_alloc: Batch page freeing in
 free_frozen_page_commit
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Kiryl Shutsemau <kirill@shutemov.name>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
References: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
 <20251002204636.4016712-4-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251002204636.4016712-4-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D5F218000D
X-Stat-Signature: s191s4mhuf3frbnbqkzj8ygkmzn9mqa3
X-Rspam-User: 
X-HE-Tag: 1760103444-538388
X-HE-Meta: U2FsdGVkX1+8iPnr0u+ee2ZExPU6HVPPo8Gy/28o4PMb2p1yVYd5RHDCDHowxhBTYlTpyAEWyZG25GoGhYN1U8wjuP6H5qZ+UpmTZlk/G6Rr46MsUL/KpVaDrz3UnkZejcCBkOn93Ixa5Ju1wpvOYKpfCFwmqsSikG1JCAATs+Mtw6W4I8H6Wct608yekw/eDxpVfJbFigSfBhMjFmx0h2U80eCRV25cqSJVPc2n5aaWre5EY9vMGUu1uAHUfkLH5d0jPWZsg0m28ocCbmMn6kiZgCbbMzQDmzvh5oCaIJEDOBaK1V5g0uGb7CrIbjebIX3wOeN+cOBiVfgsbOo6rSUMD3mtREOGTJZ7Ygyqov/Em60iSCBaAx4Aac+Kx+EtmTioOf0gn8D25LPPCs8EcaoeOrMFC7yjNk0Igs1Nu4QTNCr+/R2H8ycziFISrNSYeD0M83yOnD9pzeJBZ9JMF7UhjMUyx2e/eAvQzP8gVdHUN09LjwN5JPZCFf2s95sVKYJP+8E2vZ93mRurpJ2vzLHSoq1WG8iTtk9mgb7pa2lVU+bqoIXae4EZ4IxIdLJt5YQbO4rawptizXGBcBFTR68b6XeVUVJCa20oIsoQXe813apIGNccK8Rr64Lcrc9P4StyVGELCbEpWCaVEypCulY+fCmho66Ifxtn8k8Gf+DTv6hoFb6i9dHRTbU9C61c/OKXusWqkv3zLy7GyTYvwtOGB7qwDRHMydrSpB4NRcDZVI0kwRDcSi9AN6vD0nCuASpRUzNELuhYzpolo4hcfHV6FfA9M2Xzhu84HCA2+HHzBMBe3o5hmWBYtIjw5n2bH+46BJAaqeKplpP7+lQQ1fqfNqi+M+9wTWqea3KmutKzjtjxwCpbg+n0WqDNFaEsFoSfi6ua6F0p/gtvCcimzM4XXHafnj6vqXQ3qH1PiwASblLjT2jxTbaiMPEqfDOVIpqbfyqwQxS5eRM/3R4
 V4fcgCfQ
 gPrANSU6F0LC70iuAcTEZ1y8o7ng8C+VuF+ddK7VDqzuiyOyHoWR8J2fDsHLDtjhqL9Te0QaXjhNjM+1etNUbR2oJWRs05M6LBf5PhldzgDAvoDWZ0NjsSLv3kkGbwgGjUZNDkQQ9AUJug0oodBkqaS0EpbmZfFNSxoU9CDBa8hrszNnqmkZtXFPJSjVQfeg/78bgrAqIKBwzPtQ38SJuCjW8Ckorfn/+U4VXtBKmsc92x9GbHtA7cwBv6eosckqed/Na8jgn66ROTfbI0RgAdOvfwuu/f572x5pF4+fbH/uwEzDqdiSc/2J01eQmvy4V74+iMzJP24xTnRC7unjTIroeR83NEz6tmteFmLy7MQF1q6YqAJUGkk2LFEMsKUHZJ25vLKSX/YDhpHkkXELw2WO4j1cDmLP2cYl7C7UpYl+5FfksIXhjKZNgsM5n/5rssxuhlTwkFE8S9C05Q1ALBRN6pvlKmlCEljGXOHKfK08YCTdV9hzahvZt9+FUXz9kcE4J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 22:46, Joshua Hahn wrote:
> Before returning, free_frozen_page_commit calls free_pcppages_bulk using
> nr_pcp_free to determine how many pages can appropritately be freed,
> based on the tunable parameters stored in pcp. While this number is an
> accurate representation of how many pages should be freed in total, it
> is not an appropriate number of pages to free at once using
> free_pcppages_bulk, since we have seen the value consistently go above
> 2000 in the Meta fleet on larger machines.
> 
> As such, perform batched page freeing in free_pcppages_bulk by using
> pcp->batch member. In order to ensure that other processes are not
> starved of the zone lock, free both the zone lock and pcp lock to yield to
> other threads.
> 
> Note that because free_frozen_page_commit now performs a spinlock inside the
> function (and can fail), the function may now return with a freed pcp.
> To handle this, return true if the pcp is locked on exit and false otherwise.
> 
> In addition, since free_frozen_page_commit must now be aware of what UP
> flags were stored at the time of the spin lock, and because we must be
> able to report new UP flags to the callers, add a new unsigned long*
> parameter UP_flags to keep track of this.
> 
> Suggested-by: Chris Mason <clm@fb.com>
> Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/page_alloc.c | 66 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 57 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f525f197c5fd..9b9f5a44496c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2818,12 +2818,21 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
>  	return high;
>  }
>  
> -static void free_frozen_page_commit(struct zone *zone,
> +/*
> + * Tune pcp alloc factor and adjust count & free_count. Free pages to bring the
> + * pcp's watermarks below high.
> + *
> + * May return a freed pcp, if during page freeing the pcp spinlock cannot be
> + * reacquired. Return true if pcp is locked, false otherwise.
> + */
> +static bool free_frozen_page_commit(struct zone *zone,
>  		struct per_cpu_pages *pcp, struct page *page, int migratetype,
> -		unsigned int order, fpi_t fpi_flags)
> +		unsigned int order, fpi_t fpi_flags, unsigned long *UP_flags)
>  {
>  	int high, batch;
> +	int to_free, to_free_batched;
>  	int pindex;
> +	int cpu = smp_processor_id();
>  	bool free_high = false;
>  
>  	/*
> @@ -2861,15 +2870,20 @@ static void free_frozen_page_commit(struct zone *zone,
>  		 * Do not attempt to take a zone lock. Let pcp->count get
>  		 * over high mark temporarily.
>  		 */
> -		return;
> +		return true;
>  	}
>  
>  	high = nr_pcp_high(pcp, zone, batch, free_high);
>  	if (pcp->count < high)
> -		return;
> +		return true;
> +
> +	to_free = nr_pcp_free(pcp, batch, high, free_high);
> +	if (to_free == 0)
> +		return true;
>  
> -	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
> -			   pcp, pindex);
> +free_batch:
> +	to_free_batched = min(to_free, batch);
> +	free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
>  	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&

We could do this handling once after all batches. But maybe it's better to
act as soon as it becomes true, and checking once ber batch isn't measurably
slower, dunno.

>  	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
>  			      ZONE_MOVABLE, 0)) {
> @@ -2887,6 +2901,35 @@ static void free_frozen_page_commit(struct zone *zone,
>  		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
>  			atomic_set(&pgdat->kswapd_failures, 0);
>  	}
> +	high = nr_pcp_high(pcp, zone, batch, free_high);

It's not clear why we recalculate this. Ah I see, the calculation involves a
ZONE_BELOW_HIGH check which we might have changed above. So as a result ths
patch isn't a straightforward "we free the same amount of pages but in
smaller batches" but something different (and I'm not immediately sure what
exactly).

I think it's an argument for doing the ZONE_BELOW_HIGH test above just once
in the end, and not recalculating "high" here. I'd just stick to the
"to_free" calculated uprofront and decreasing it by "to_free_batched" each
round.
We should maybe also check that pcp->count went to 0 and bail out so we
don't make useless iterations in rare cases when someone else drains the pcp
between our batches (free_pcppages_bulk() protects itself from passing too
high "count" so it would be just some wasted cpu otherwise, not a disaster).

> +	to_free -= to_free_batched;
> +	if (pcp->count >= high) {
> +		pcp_spin_unlock(pcp);
> +		pcp_trylock_finish(*UP_flags);
> +
> +		pcp_trylock_prepare(*UP_flags);
> +		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
> +		if (!pcp) {
> +			pcp_trylock_finish(*UP_flags);
> +			return false;
> +		}
> +
> +		/*
> +		 * Check if this thread has been migrated to a different
> +		 * CPU. If that is the case, give up and indicate that
> +		 * the pcp is returned in an unlocked state.
> +		 */
> +		if (smp_processor_id() != cpu) {

We could have remembered the old pcp pointer and compare that instead of
doing smp_processor_id(), although that should also work.

> +			pcp_spin_unlock(pcp);
> +			pcp_trylock_finish(*UP_flags);
> +			return false;
> +		}
> +	}
> +
> +	if (to_free > 0 && pcp->count >= high)
> +		goto free_batch;
> +
> +	return true;
>  }
>  
>  /*
> @@ -2934,7 +2977,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  	pcp_trylock_prepare(UP_flags);
>  	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
>  	if (pcp) {
> -		free_frozen_page_commit(zone, pcp, page, migratetype, order, fpi_flags);
> +		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
> +						order, fpi_flags, &UP_flags))
> +			return;
>  		pcp_spin_unlock(pcp);
>  	} else {
>  		free_one_page(zone, page, pfn, order, fpi_flags);
> @@ -3034,8 +3079,11 @@ void free_unref_folios(struct folio_batch *folios)
>  			migratetype = MIGRATE_MOVABLE;
>  
>  		trace_mm_page_free_batched(&folio->page);
> -		free_frozen_page_commit(zone, pcp, &folio->page, migratetype,
> -					order, FPI_NONE);
> +		if (!free_frozen_page_commit(zone, pcp, &folio->page,
> +				migratetype, order, FPI_NONE, &UP_flags)) {
> +			pcp = NULL;
> +			locked_zone = NULL;
> +		}
>  	}
>  
>  	if (pcp) {


