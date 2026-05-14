Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8AFFCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 12:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C366B0088; Thu, 14 May 2026 08:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D726B008A; Thu, 14 May 2026 08:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62F26B008C; Thu, 14 May 2026 08:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 941516B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:11:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 376411C1021
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:11:24 +0000 (UTC)
X-FDA: 84765910488.07.1822513
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2020EA0009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:11:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gTpk+01H;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778760682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s408f9OJoECOc+mlZTweDp5vLMGoJZ+/r8J9/lwIUpM=;
	b=rxArhkHEqu0O8uNmr7cvgbG2ynUm89NG9NmtHzlCfD7t35ZxFsPlZetox1vgSBjiNWrW3d
	Iah71lQaqRWXd8R7AR4VYmblK3QFkrJMC8Ra46DoAm5AJuLk0LjxegRETLQ2IA5dvHgppg
	D67+aP8TiJXUOuzJ08BN2pIQ3u2mKOI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gTpk+01H;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778760682; a=rsa-sha256;
	cv=none;
	b=5OgcpoYLKwvNrdudOYGwoMbDP/avq2mwNRJ63+aw2XvoY44nzXp9Kyglzg1xGOpkX9xy+W
	M5ecA+hrTjzQkrWG2OYMNGgLPvHx1L0pw2rg+ECgkdXpXmJPHtb7PvQ/KchVQeDL55Kxbm
	RkyuWuSeykXNlEvVMsKyYTJCaLuW6j0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FE6F244B;
	Thu, 14 May 2026 05:11:15 -0700 (PDT)
Received: from [10.57.90.238] (unknown [10.57.90.238])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 354633F7B4;
	Thu, 14 May 2026 05:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778760680; bh=b716yINr0J0X6axauXz7i/AggRCorUNpLSdpn0pNKh4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gTpk+01HsJx+SY4XXRi+TfeWLmdtAaSc65TzL+eTZf8NWO1kNgixKc++/RhiXQ/hj
	 RaRszNC/9gBBRo/qgd56UQk1Qx+0vcMYHzFvZ5X8dHcQMmjJc8Bf+s0ooqMA1+1wgw
	 Q3vN42Zhz5yVKfRwP5cYJzQczIfFIQKG5Q8JZbHw=
Message-ID: <83aca9c5-6bd0-438e-b571-c4d0335c9901@arm.com>
Date: Thu, 14 May 2026 13:11:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/slub: hw_tags: skip page-allocator unpoisoning on
 slab allocation
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, harry@kernel.org, ryabinin.a.a@gmail.com
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com
References: <20260513105734.3380544-1-dev.jain@arm.com>
 <20260513105734.3380544-2-dev.jain@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260513105734.3380544-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2020EA0009
X-Stat-Signature: xm5cfomy5663jwcgipqr8c9cnrce1rqi
X-HE-Tag: 1778760681-881517
X-HE-Meta: U2FsdGVkX1+2uXaEaw2/pOiFnb+GUFvGbq3n46AHDbvvH4lqINq5/7vWDXuz7/4tkFeNRHJC+dCoNr5ObF2BmIcn2e5zsHbN2ZPZltXjCF2lSr1YB9JUCUsG/dk1J1aDtBNAiG6V99WZ7nsXASWlVHyutakY5E7iq2e+ecH4f2BjJHxq2Q//qSJoHnUj5vzuluWIE1x1NV7Qr9sHMoa3/hqxEXGOGcA6QRSNTuHMaL5xnDqFXHN0CyOukdtK1zd/6xqznNDyTU4VCAV3mN/U3sstIk5KT43IC2tG+WBYRdx+MCi2RiYXcqFoMsEoaF5OTe/ptw/1ujA8eh5k5SfY6sECQcU6El2CWi7yn0JOs7awGBlZjBLgGi88pJR679Zz3X2Ls9oS6Rf7XoGq+CMpVYAVw8XCvtNgrMFrjKVwTHNaFbT1whz8bUGfSkEujTneipN4SjlSkQ5RUhrGP7jiUuNyVRBivgPZ+k8yW5JmobXoAu2ASh3Loae7z9RTxCIdew3905MLkslZvc8REJmCkNiEdbe6Oo99CIcc8reWS2Eca/T2mHN2WF9wX5d4bnPs+jxG5ZNFX1uLy9WVlDsHaYwFmttaH8cwcPLX/ALS34ATiAFhcGg30sAmLFNqEmlph1lGMoe2eIwrC5Y9ZFo2HmojpjtpWIGSdw18I1MWvCaruMngdoUc1azWyx+MQE5oPppvqKlSkUv/tBw8nlR1OnSndTifbPYxF7VVNhXcLaSHWxHBVcrBXuNDTCq25CsXV6+AsaOKmT8ytp5Lcr0oxaAa0p5iCzH+uoVQNwtYOvLCnXpUUpD5DRmahPGBvVM1fCgdd1asiOUKtXsao8uDT4pM9gZo4rDGowAKRWE7sHTjyBxRqmXION1F4bqr4fpUuFtXyJ3cjXjY6mbNSkBkc1cqY9ExzzoGDiGCFEJbgkxfzImo9cU4/cVujSQhYN79qp7aBFpB0FsHZcqMNOh
 28ws+QS0
 z7D5TbQWrtSrIEmfGvj1D498qjgMPWwUI7JPg3C/A+rcBy3X4u/MSF/q8luGks7y8tFJZMp73wxA0yIDGGyrmg9W0wEQerOUDNS7t6G++yCNj1md4RPK9bk6ruafIzvQyz26x394wDV/TpZwJ/ETUOqlJZZPGNw97+dehTCutbAP5wa7+DwScpk6wlqzhNg3Dzh0gxZLItwlE4uQbqvH6R0F/rFs7jTFIXj4RJ7qQrQ7tsK15Wi4EbSJ75k6PckXDqWICm+dvx7Ud+8am/dmNTHkAHyTeMizp830GaqfdMLvpuQOKu2ospUM9k1zhV9jWLAlVoQSLRFm/RCQpdkR24ri43J8IXWea/+x1HEMQgPx6lcFLkXdR2gQe/lFQdbPQDQw/RZF6sTbR/scbE/0QQn9wo4q66c0z47lg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/05/2026 11:57, Dev Jain wrote:
> When a new slab page is allocated, the buddy will unpoison the page.
> Then slab immediately poisons the page via kasan_poison_slab(). This
> is wasted work.
> 
> Similar to what is done in vmalloc currently, use GFP_SKIP_KASAN
> (hw tags flag only) to skip unpoisoning of the slab page.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/page_alloc.c |  2 +-
>  mm/slub.c       | 11 +++++++++--
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 227d58dc3de6..c3a69913aaa9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7723,7 +7723,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
>  	struct alloc_context ac = { };
>  	struct page *page;
>  
> -	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
> +	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_SKIP_KASAN));
>  	/*
>  	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
>  	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
> diff --git a/mm/slub.c b/mm/slub.c
> index 0baa906f39ab..da3520769d1f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3269,9 +3269,16 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
>  	struct slab *slab;
>  	unsigned int order = oo_order(oo);
>  
> +	/*
> +	 * New slab pages are immediately poisoned by kasan_poison_slab()
> +	 * before any object is handed out, so page allocator unpoisoning
> +	 * is wasted work for HW_TAGS KASAN.
> +	 */
> +	flags |= __GFP_SKIP_KASAN;

You will also want to elide kasan_poison_slab() right? In which case, it might
be better to handle __GFP_SKIP_KASAN in allocate_slab() (which calls
alloc_slab_page()), because that's the place where kasan_poison_slab() currently
is and it's probably better to keep the logic together.

Note that there is a wrinkle though; logically, there are different types of
memory poison; KASAN_PAGE_FREE, KASAN_PAGE_REDZONE, KASAN_SLAB_REDZONE, etc.
Memory returned by the page allocator with __GFP_SKIP_KASAN set, will have
KASAN_PAGE_FREE poison (I think). But kasan_poison_slab() sets
KASAN_SLAB_REDZONE poison.

However, this is only distinguished in practice for KASAN_GENERIC. For
KASAN_SW_TAGS and KASAN_HW_TAGS these distinct logical types all map to the same
KASAN_TAG_INVALID tag. So this optimization can only be safely applied to
KASAN_SW_TAGS and KASAN_HW_TAGS.

It would be nice if this could be abstracted away somehow...

> +
>  	if (unlikely(!allow_spin))
> -		page = alloc_frozen_pages_nolock(0/* __GFP_COMP is implied */,

nit: you may want to keep this comment around?

> -								  node, order);
> +		page = alloc_frozen_pages_nolock(__GFP_SKIP_KASAN,
> +						 node, order);
>  	else if (node == NUMA_NO_NODE)
>  		page = alloc_frozen_pages(flags, order);
>  	else


