Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8375C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992386B0088; Fri, 10 Jul 2026 08:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942EE6B008A; Fri, 10 Jul 2026 08:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837516B008C; Fri, 10 Jul 2026 08:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BBA26B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:40:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7F591C3ADB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:40:31 +0000 (UTC)
X-FDA: 84972825462.16.5F82EEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E832C40006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:40:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QCF4e1f7;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783687230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tng6ULGnh9Em64xwRpMVoclTAzrdwj4WFKuUCJoYag4=;
	b=O/CsTgIWCxEI6NMgabXE1JEklY+fzslqnmO1X85Ipi1TZUKzHWYh0+L/oTmK5fOsmIdE4Y
	KZrTGfzyUmBdzk5WBBO6FZWpeJbjwTtaU1AVUvf6TXVvnXgk8FNyR4SQsgpsRdJa/gulcZ
	z5plh7Se7FRmagZOeqDztZ8j4rv+C5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783687230;
	b=jHGV0GdofGvJSrkDmhqZPSHg+CpAbSWRZLJUGiXwv0xrL7pkulkfFKGdO0tmRcZOw4rCsU
	wA9w1609Cuz20ejmxyFJeD3j8ad+j9wZJdK8q764ZFpPsUuxjEcQ2lFeCFjmBPJTPl3rf7
	skBAKBWOYKevivvcACajr54te3IATQA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QCF4e1f7;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DAE0418C9;
	Fri, 10 Jul 2026 12:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED731F000E9;
	Fri, 10 Jul 2026 12:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783687229;
	bh=Tng6ULGnh9Em64xwRpMVoclTAzrdwj4WFKuUCJoYag4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QCF4e1f7E6b/KOcYr84Em8IiMgqopMFhVRtaoOghoFn8cPYxRll20EGedByzpYxb/
	 S/dRvwP6TeA4UwVrzkkJNcRlREIOtYGufgRPJR9TQV4eQzvEzQ1a2ObfG68PN4lhTM
	 0jAZ4Q8sSuF33CSJdpHE+PDTnxLI+zJdne7EVcALYz1DNNYdffNan+CsZqyxlmh/NQ
	 DFoj0H9dFfnUmfZN2dwTlP99L79Ekf/ldSHeXPYxMW7HTTHV6N7BcNvD6//uKhLG11
	 1yfZy049sE9eb0vX/Mjmb+EkSCJVZ3kXf4RHDmrl+Dh/yWVrizRS1i/kB/FIng6EuU
	 rK6O9lxxTatXQ==
Message-ID: <0048210a-e186-49c7-9897-32c9b66336c6@kernel.org>
Date: Fri, 10 Jul 2026 14:40:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Harry Yoo <harry@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-2-affb5fe5ed00@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-spin-trylock-followup-v1-2-affb5fe5ed00@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E832C40006
X-Stat-Signature: bu85gg8oufw8tcn4qww158iq7j1m7geo
X-HE-Tag: 1783687229-981297
X-HE-Meta: U2FsdGVkX19awE6Y7qryROx2yuVxKApWoW+1kG0+PCBJgzdtYfmNjTeIaUiWC2azlK4035XEzA+nIppx8fPXxt8ZX80ONZ1NoFWDfrAu5GKxe5NP8jc97T7o6MSTtnxP2x1pPYYzupww4/tpNIs168eH+uwtEo7FuLGGs2LpX2VWqPc13RwhndWVBy9SBa/3w++WqCofNFu8uHNx0ASGeXflqJrcxAS+USdAMhKSQSfV+ZGlNjww2xuN2g4Jpxgck3KCvthmQL5EThW6QaVk2ceAZwQ4qpW3S2lxUIVQmzmdLIljoSVTsmzaVvLbzs/wip4BFxP4FVsQmMWsv6Fu+3/GVb1Ln+FAsV92nv4/PL/gbDwrWaFeg29cZhEyzf7WZblm2Wq1Pp6dglSLg9DKyQ9js+CFqrpr1zy4rdLprx1pU7GEB+C59JlqIAYKmJR+wpfJSJUCWJJWlhjSqSSsJfcHx5HhdhW5kPfRemy7xtNxTKVqwKsFMyssm623jQj1P5AhUeTeHUx/FL8tmiCH3nvHcfFrFx0D0FV9cS1Z7yb9JffdM3Y3FpR9Xqq0Yjkwh/UOFJGvA1yrGydo/kmu5VCaUjIMBjGLeKeS7heEyaLfw37LZtin8CtZuSU1vR4qSJKza/9vcwZGJh0kMYaRUTVCRTjWrvETOEQU478J1mM4V3bpVmyu9dt7v96jvEWoJjocSMdS+yH1a6DwXl15N62Ap9pyqTIa1THSgsB+mVwQ187ctQt2vBZZaaRett9TqKYas5YZXuZHxIQKtvz4K0gc01PRPceiKbFycb2xka/jzq0XlrWf+xj8+QkbpL2T3dKVGwv3PxNCe0D9KmUiqHvmSMO0TRDGzXtkxpNQjHZ8cRIkGoAC5OAIawZHSoKJS53bD6185HcwocNIdLbMFYivvsLz70MApkfPZHTErYP/euw5MUT9rp2RsrPXM8Pf+mLYFI8phUKL7ZtBCDa
 4hLomi+f
 mHb8XD1AoBlkFcUOIaLAM0P31vKgdworoGiAe4nsONV3uXe3dp3/JUTCWiPBjN5LV2A6WDrDLKQ0Bl05AmG7FZjvuncWgHcf02BtYbuPRbQ5o9+iYc22BVXyTJy8kWQlCpxJe2lw3GukHPFUh8Ub8OpUj2ObbpmcMZ+VYRTklT79L/wgJt96drK7yLEoOl5HpZVTvbLzxqa0vkdRLV4lDxStm+SS+VEU1q5L8AohLDnwMYRw4fAukWrsXxB4DfwC3nUFt3KqsjQoEpak3pQkX3SaUnXQIZB+LgwYi/MfnP0+dMGbP6CaXU359OrDzV3lwLR+hmdl7fsUOimwsNMZXKSVjGIDndHbYQ7sk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 12:42, Brendan Jackman wrote:
> As discussed in the linked patch, the there is some inconsistency between
> "trylock" and "nolock" nomenclature, let's align it. Since "nolock" is
> used in the public API it seems to have more mindshare so do that.
> 
> The linked patch did this for the ALLOC_ flag but forgot about FPI_.
> 
> Link: https://lore.kernel.org/all/20260703-alloc-trylock-v5-1-c87b714e19d3@google.com/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Naming things is hard. Maybe it should have all been called "nospin". I
don't know anymore :)
_nolock() functions and ALLOC_NOLOCK are part of API, FPI_ is internal so
it's not that urgent. Furthermore:

> ---
>  mm/page_alloc.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5fe1c11f919d7..ba8d882072de5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -90,7 +90,7 @@ typedef int __bitwise fpi_t;
>  #define FPI_TO_TAIL		((__force fpi_t)BIT(1))
>  
>  /* Free the page without taking locks. Rely on trylock only. */

here's a "trylock"

> -#define FPI_TRYLOCK		((__force fpi_t)BIT(2))
> +#define FPI_NOLOCK		((__force fpi_t)BIT(2))

And here's not anymore.

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
> -	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
> +	if (unlikely((fpi_flags & FPI_NOLOCK) && !can_spin_trylock())) {

can_spin_trylock() was matched with FPI_TRYLOCK, now not anymore

>  		add_page_to_zone_llist(zone, page, order);
>  		return;
>  	}
> @@ -3001,7 +3001,7 @@ void free_frozen_pages(struct page *page, unsigned int order)
>  
>  void free_frozen_pages_nolock(struct page *page, unsigned int order)
>  {
> -	__free_frozen_pages(page, order, FPI_TRYLOCK);
> +	__free_frozen_pages(page, order, FPI_NOLOCK);
>  }
>  
>  /*
> @@ -5409,7 +5409,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
>  	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
>  		__free_frozen_pages(page, order,
> -				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
> +				    alloc_flags & ALLOC_NOLOCK ? FPI_NOLOCK : 0);

Although here it does improve things. Sigh.

>  		page = NULL;
>  	}
>  
> @@ -5532,7 +5532,7 @@ EXPORT_SYMBOL(__free_pages);
>   */
>  void free_pages_nolock(struct page *page, unsigned int order)
>  {
> -	___free_pages(page, order, FPI_TRYLOCK);
> +	___free_pages(page, order, FPI_NOLOCK);
>  }
>  
>  /**
> 


