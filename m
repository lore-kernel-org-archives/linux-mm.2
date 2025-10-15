Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD4CCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 03:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44B48E000F; Tue, 14 Oct 2025 23:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4668E0005; Tue, 14 Oct 2025 23:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE49D8E000F; Tue, 14 Oct 2025 23:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AFE58E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:56:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFE18BCC85
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:56:45 +0000 (UTC)
X-FDA: 83998987170.23.8A13F59
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 654BEA0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:56:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dfy4W9ST
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760500604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iC+bIt3lh+BcXGKI7RLWlb4Z81tpVxVGePCWF8n6Ebs=;
	b=WnF7pE3KF9qt8yxPzhE85o5AfkLT3u+YDaLAFdNtG1hOBp61RTQfYdGtXlehqmjKlFYqew
	TFjsKXtkB6whWUji/r4zzB4CCj7EwCJAU+oNfSC9CTRY15sStgA47q5yrfstOHktJ/joGg
	NhzuU6OaK1919ytSn+fnrlPg/OfD+fk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Dfy4W9ST;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760500604; a=rsa-sha256;
	cv=none;
	b=tQIY1oOHLeTZ8blLssOtLVDAo0hL18HCJU+XsX/yTkEYFArQiCj+zdyq/BpBYNeUJ5+0EF
	XrWnjgwDoApVgiK8RllYrphy2dbMFlRpDNagNNUJtzHwD0XktWaf51B5qP4DH6sy65KP/T
	9lKglePaqTMNgjqJU3623Sh/vV5rTD0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iC+bIt3lh+BcXGKI7RLWlb4Z81tpVxVGePCWF8n6Ebs=; b=Dfy4W9ST4fZL+AhcctsetPE2Ob
	pKlsWlOvB8nHjBMDjEJLCSV+dFeMUlOr4aixUpIupF9GOeOETVMCjw+pD+gkoLMEDWYvUMbVLtYAZ
	8Ynj4mV1Su0Npo2kSgZ2QB49Zj95eIB1Z9Sq9C7YPP3wlpsZ4NbjL56cbSJwwq8QhOyZzE+ZtOnIa
	eJEZ7T0qqWrJwmz6GIye1H6x16OLHKmAiICtjcBd2qnC7VbE33dKT2a8JKFRyCvuV9eQ6o3xXkb69
	ytGzAs9Xl7tHOxZJlS0Y4gpb0FPtPA7JYXFjM7WAnLpetgysoFT7jw9ZpgXWssxZganBc97+AuAvB
	h7s/OOzg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8sd0-00000006r1M-2K2w;
	Wed, 15 Oct 2025 03:56:42 +0000
Date: Wed, 15 Oct 2025 04:56:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aO8behuGn5jVo28K@casper.infradead.org>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014182754.4329-1-vishal.moola@gmail.com>
X-Rspamd-Queue-Id: 654BEA0002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qtae1fqctifpy4q1ps3qps34o8e5exkc
X-HE-Tag: 1760500604-636459
X-HE-Meta: U2FsdGVkX180JStXR+08G8rSw7v68VvlOa55XZsEFwwRcV0UuicczdHIrB7WXEg/LL2e39r7oDhTjxz6SwxMbg0lHx3hzvzEHw39Lb8pVbiejBxyO0PWT5QreOAnL3zcQFkp0ZoRzr0IHyCvLCl2cpCuwLF44z8JkO3G6L6fUtPhst8pRRIRjogrOau/OTsgILGVKiRKTAFgSf/MfY5OJ4Vj3A6bS+N4PsUU2rp6ZY6NkErMvQqZYa4h3QU9h9NMiSRq8fjiyvUX7RGb4QUg9V0qsnhJ5pM4PTawdeyeWClhV7xn9Cj2L14wsjA4i2+0knQDQA2mQtMSbxfhICHEVFWf8Mk9CoJGpB2GjE8SsDKG3UgDhG7eftpnkXU4JfE2ScYHT2WhGT3mzM0PN3cUFkJDj+5nWkrkbJT0a3fsq3FpAKkS1fZVY030TRLPVs4dXbyTNfca3VHvfdgt4SjnqB7SYK7tp3pORawu2Yvm67VzbnyTG1y8bqxI7+xoeh1hmDdLpdLvwBONI2eCL6VzVz1W79depH1ZBq8mOqT0dL7CdA/GbGMO2OZipx4wUMthx9pUCj3VE+6P1jLOTppIx19Rqca3MWuPgM7h/Ezlv5lj7jc3doWLQd4vGjROb5f+dF2DksOR1Zss99LArYJdT+lC7oc9GLZhHkhqBGBxUnPv4Ll+TB8ZJB3VwfoAgIJGD6XwtB+j+nY5L2y0LADcc7u0aebXipvJAoGaFdXceFb+WLuheEvCF2icIxOsIoPs4zzRoTLqw2jEhIM1FZFe5zCVJEFH9O729bPfvU0zUGxPnCWZ4GcoJ1zJom+4MVxW/G9HnSkCJUmVnLGjHBny374/YCgxa+7RpbSoI3fVhhnF0kKQP1PYUJ0INL6C0Nj69fCDSQVpHI2BVPxxsWMACrPfXYu3pE39VgdipvzzFdiXJ7SSuBJ6ydBF+D1KSF4O1jqsqsWE9un8k/yC/UM
 P4rTyVe6
 dD3lCLHUGNGbjSp46NRLafyBq0EUSuwFzoWbuBBva35z95TS5RwrYNcg2ClnE7NzVvRqHZGDmqlMOVP+t4a2RUldvtSKCzwwMywiGjiado+lGmx+fL1VpieOpGE1ejkGERfRGA3+OGT0NaxwrSc83EnzCmWPIl3823aHd6HX/6n0XmXMwqa+ghwiMuGnfiNkdV5pohZwtokm63TYXeawSwu1gvJYWcfpiIiGXnMWf6y4OXtYLvPwQw7jOcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 11:27:54AM -0700, Vishal Moola (Oracle) wrote:
> Running 1000 iterations of allocations on a small 4GB system finds:
> 
> 1000 2mb allocations:
> 	[Baseline]			[This patch]
> 	real    46.310s			real    34.380s
> 	user    0.001s			user    0.008s
> 	sys     46.058s			sys     34.152s
> 
> 10000 200kb allocations:
> 	[Baseline]			[This patch]
> 	real    56.104s			real    43.946s
> 	user    0.001s			user    0.003s
> 	sys     55.375s			sys     43.259s
> 
> 10000 20kb allocations:
> 	[Baseline]			[This patch]
> 	real    0m8.438s		real    0m9.160s
> 	user    0m0.001s		user    0m0.002s
> 	sys     0m7.936s		sys     0m8.671s

I'd be more confident in the 20kB numbers if you'd done 10x more
iterations.

Also, I think 20kB is probably an _interesting_ number, but it's not
going to display your change to its best advantage.  A 32kB allocation
will look much better, for example.

Also, can you go into more detail of the test?  Based on our off-list
conversation, we were talking about allocating something like 100MB
of memory (in these various sizes) then freeing it, just to be sure
that we're measuring the performance of the buddy allocator and
not the PCP list.

> This is an RFC, comments and thoughts are welcomed. There is a
> clear benefit to be had for large allocations, but there is
> some regression for smaller allocations.

Also we think that there's probably a later win to be had by
not splitting the page we allocated.

At some point, we should also start allocating frozen pages
for vmalloc.  That's going to be interesting for the users which
map vmalloc pages to userspace.

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 97cef2cc14d3..0a25e5cf841c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3621,6 +3621,38 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	unsigned int nr_allocated = 0;
>  	struct page *page;
>  	int i;
> +	gfp_t large_gfp = (gfp & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> +	unsigned int large_order = ilog2(nr_pages - nr_allocated);
> +
> +	/*
> +	 * Initially, attempt to have the page allocator give us large order
> +	 * pages. Do not attempt allocating smaller than order chunks since
> +	 * __vmap_pages_range() expects physically contigous pages of exactly
> +	 * order long chunks.
> +	 */
> +	while (large_order > order && nr_allocated < nr_pages) {
> +		/*
> +		 * High-order nofail allocations are really expensive and
> +		 * potentially dangerous (pre-mature OOM, disruptive reclaim
> +		 * and compaction etc.
> +		 */
> +		if (gfp & __GFP_NOFAIL)
> +			break;

sure, but we could just clear NOFAIL from the large_gfp flags instead
of giving up on this path so quickly?

> +		if (nid == NUMA_NO_NODE)
> +			page = alloc_pages_noprof(large_gfp, large_order);
> +		else
> +			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
> +
> +		if (unlikely(!page))
> +			break;

I'm not entirely convinced here.  We might want to fall back to the next
larger size.  eg if we try to allocate an order-6 page, and there's not
one readily available, perhaps we should try to allocate an order-5 page
instead of falling back to the bulk allocator?

> @@ -3665,7 +3697,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		}
>  	}
>  
> -	/* High-order pages or fallback path if "bulk" fails. */
> +	/* High-order arch pages or fallback path if "bulk" fails. */

I'm not quite clear what this comment change is meant to convey?

