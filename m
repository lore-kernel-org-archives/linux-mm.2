Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE694C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B744A6B00CF; Wed, 15 Jul 2026 09:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B346B00D1; Wed, 15 Jul 2026 09:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A153D6B00D0; Wed, 15 Jul 2026 09:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC656B00CD
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:34:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B80E8014A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:15:01 +0000 (UTC)
X-FDA: 84991056402.23.2691B50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id C9EEA40009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:14:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gQNfz/n4";
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784121299;
	b=uSkJSbDaW0/addhDXjD0Le+42iLObVSiET2Cv4/3HV9xAHe60ktkmCh3blSXYa+wA0yu9U
	ibK9UirHx/jJKTEpxlUJs4BWaFCWvNUbwKx1vXyHU5Mev5dEfmKWlVLhJMtEQmvW6fG/X/
	n7Hf9pI1A3lW0Ywt+HSeJpV9uBxDePQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gQNfz/n4";
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784121299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vM2dkF/6lSWo/swXz9lDfkksfM0DbUYYsHFUpZl+IKQ=;
	b=E8ZhV0Oduc3CZkxowhtSVAOjkXoqX9PGUc5IBXRFt69N+3Y+Abu9ZvSyv2bZlG295/P+3K
	e1kPwopJe/RS2D3iNdx5ZR8KrPxZ5fPf8cFXEJ2Iw6NM8mmEBUaKaq2pzuZPGu37KEB1ly
	2zrFxD1WxlQlwilhfGCqLh9CxftZ/Aw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5995461382;
	Wed, 15 Jul 2026 13:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230F21F000E9;
	Wed, 15 Jul 2026 13:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784121299;
	bh=vM2dkF/6lSWo/swXz9lDfkksfM0DbUYYsHFUpZl+IKQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gQNfz/n4GrHbrVnvIgE2OgeJCJJpUZ0ZBqZufkO6fvqW5Se77tNKewsBgZD/gpLKw
	 JGKciVFxEzfEslsNGysyRVW8RK/F1V/zPxlErEOezScbMjUbt8YpIo3K2A7BZFECdf
	 8HsJ6IVlKkA3c4aVgoM3uBIQYD/Je3wLfTrnZ0q9hzDP/uDmD5OwL5QRLGRG2vp+p4
	 ydiBCToxDIHDkoao24Nwh5wQVW+gIH4WSsWLjZ4BZTG0me1TUDGmc0v9NaRtK8it0A
	 xeTwzvdnny3Bm7oCxnh5tmaXhQrvqNlGk0yeNERqr4guHDUyMzA/agMzf1HPHhz0Yd
	 gCHZAswKY3DFg==
Message-ID: <ada7bf29-1bd2-4de0-bf3c-0916f0ce512f@kernel.org>
Date: Wed, 15 Jul 2026 15:14:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-1-fc4d246f705d@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260715-spin-trylock-followup-v3-1-fc4d246f705d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9EEA40009
X-Stat-Signature: f89rwggdtye8czdrhbuhitnn1qdpnx5w
X-HE-Tag: 1784121299-230080
X-HE-Meta: U2FsdGVkX18FRW+8od24RhgWRLWu8UTtqkE/wORZl9kV1GnTWMmKEIkawKsLp7V8kCf2fKGBjuphdgnVif/uUXtA0+WVlNoBgo6zmZBlDWqsB+4Oumk4aO4UIADbouv8yYwMfGclVOkrWAy3CbxhbJUFohL9tE3ilSUgg96IIdk4/FZAwm4ilACV2icuQDnR2i4maZM7Qz0F4zhrSQl87XqO6b54/DIoPZqaSFCmsmR3QVszDHh2pqIx2pCW8POsiz3/6L2ot7msAvMaSBPRy1yWa1HVleR17mKyHJP1TRad6P/yEvi6dchRlmltOIzCV8n9RRnD/O6Zd0bxhLeeR3by7/MBV3GKetPEoc5FZRxR9AElsmQutFZYbVAM+oMq4jOfVfDgENkJ7BA/l9cMuOjR0ekVNylKJZvB3D981RR6sqo90N0wYv1/t9BAG0BkFjciX9aYlf9BGnLV0O0m5Q+7juSlJeAGBjozMg6MQ3S4KV6ImfVnWDx7AO6tkJMhJtzNdYvQ2kUfKPjs+qFecmQGPyRpMT3BQBZ50sFKG1M9F/4gzoaumJEVXTqXtXqoAEHlQ+HFT/4NyQw9ePpYGEZI//SG5uS05p4+jawsdiNsg/EaPGIVjspyH1RhVGvi0hymQ+JcVcE0ELlQVD4UP0coBEAN2Jp41p8zLt35JUSdGJWPX+qE6GaHyr040Av0aHkwNYU4qrapVybahXRUhcF0B6XEb/4gSRQsewh5Zpv9jlmWNNZOKU/w7mr5vGZHB6ku1cNsVGh1doR8xuHQaCCX9s7lcjjsM64xN9nhhJgxh1yJcxZ6YmQi3so7UZRV+TCfI382OVzvpPEqOUfQIXAygOJsp8T36HO19gbWuldN9DGRMiPZpBLsbtwGOOd6KCzVZBEP+6SQksHlm4erLjjT5loxYBSIpwcSfgRcskdonkz8s5iVoabeG4d5xdq/4GwDUPVFmxICLuPgle4
 e/R9/yj4
 NzDr2lHHGZUoEdgQJ/qdsG1KrL04Bd2J1aVcKr/eQw1z3b6aapV074sOxlOSa6EeOO11/F4Xh0KQfk+TBU7hfG5+zwiWgFFSsHKKkVQWFho/NtI8oN0Qo/gEb6x56OG2emrM18G4cVTMAIFqhTKsT7buMqXCJFh2bOIDOJuiUfK+pvKlvafugi1p0Hh1nuXI3hxnVlSJV3e04UPONq44S/tN3AhYCv0Yc8nIWtoPKpAiMLkBQQrw1ChZiM09IHIpIoq829B7NMe5tqs6ZHWvZ9sKh6iymFBp0umz8RHpFkGelhBZfy+PVJ0nZilyOIQWbybqRtRfljoUFtUrGB2Gub9OJuh79FxUCxJUbkC1pw5eHwIfD4dZ5bNhTOSdCP1icLWzP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 13:03, Brendan Jackman wrote:
> As discussed in the linked patch, the there is some inconsistency between
> "trylock" and "nolock" nomenclature, let's align it. Since "nolock" is
> used in the public API it seems to have more mindshare so do that.
> 
> The linked patch did this for the ALLOC_ flag but forgot about FPI_.
> 
> Link: https://lore.kernel.org/all/20260703-alloc-trylock-v5-1-c87b714e19d3@google.com/
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index af63558391345..c2da85e69a0f8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -90,7 +90,7 @@ typedef int __bitwise fpi_t;
>  #define FPI_TO_TAIL		((__force fpi_t)BIT(1))
>  
>  /* Free the page without taking locks. Rely on trylock only. */
> -#define FPI_TRYLOCK		((__force fpi_t)BIT(2))
> +#define FPI_NOLOCK		((__force fpi_t)BIT(2))
>  
>  /* free_pages_prepare() has already been called for page(s) being freed. */
>  #define FPI_PREPARED		((__force fpi_t)BIT(3))
> @@ -1419,7 +1419,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  	page_table_check_free(page, order);
>  	pgalloc_tag_sub(page, 1 << order);
>  
> -	if (!PageHighMem(page) && !(fpi_flags & FPI_TRYLOCK)) {
> +	if (!PageHighMem(page) && !(fpi_flags & FPI_NOLOCK)) {
>  		debug_check_no_locks_freed(page_address(page),
>  					   PAGE_SIZE << order);
>  		debug_check_no_obj_freed(page_address(page),
> @@ -1558,7 +1558,7 @@ static void free_one_page(struct zone *zone, struct page *page,
>  	struct llist_head *llhead;
>  	unsigned long flags;
>  
> -	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
> +	if (unlikely(fpi_flags & FPI_NOLOCK)) {
>  		if (!spin_trylock_irqsave(&zone->lock, flags)) {
>  			add_page_to_zone_llist(zone, page, order);
>  			return;
> @@ -1569,7 +1569,7 @@ static void free_one_page(struct zone *zone, struct page *page,
>  
>  	/* The lock succeeded. Process deferred pages. */
>  	llhead = &zone->trylock_free_pages;
> -	if (unlikely(!llist_empty(llhead) && !(fpi_flags & FPI_TRYLOCK))) {
> +	if (unlikely(!llist_empty(llhead) && !(fpi_flags & FPI_NOLOCK))) {
>  		struct llist_node *llnode;
>  		struct page *p, *tmp;
>  
> @@ -2882,7 +2882,7 @@ static bool free_frozen_page_commit(struct zone *zone,
>  	if (pcp->free_count < (batch << CONFIG_PCP_BATCH_SCALE_MAX))
>  		pcp->free_count += (1 << order);
>  
> -	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
> +	if (unlikely(fpi_flags & FPI_NOLOCK)) {
>  		/*
>  		 * Do not attempt to take a zone lock. Let pcp->count get
>  		 * over high mark temporarily.
> @@ -2979,7 +2979,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  		migratetype = MIGRATE_MOVABLE;
>  	}
>  
> -	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
> +	if (unlikely((fpi_flags & FPI_NOLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
>  		     && (in_nmi() || in_hardirq()))) {
>  		add_page_to_zone_llist(zone, page, order);
>  		return;
> @@ -3002,7 +3002,7 @@ void free_frozen_pages(struct page *page, unsigned int order)
>  
>  void free_frozen_pages_nolock(struct page *page, unsigned int order)
>  {
> -	__free_frozen_pages(page, order, FPI_TRYLOCK);
> +	__free_frozen_pages(page, order, FPI_NOLOCK);
>  }
>  
>  /*
> @@ -5399,7 +5399,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
>  	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
>  		__free_frozen_pages(page, order,
> -				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
> +				    alloc_flags & ALLOC_NOLOCK ? FPI_NOLOCK : 0);
>  		page = NULL;
>  	}
>  
> @@ -5522,7 +5522,7 @@ EXPORT_SYMBOL(__free_pages);
>   */
>  void free_pages_nolock(struct page *page, unsigned int order)
>  {
> -	___free_pages(page, order, FPI_TRYLOCK);
> +	___free_pages(page, order, FPI_NOLOCK);
>  }
>  
>  /**
> 


