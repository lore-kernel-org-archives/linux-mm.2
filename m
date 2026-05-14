Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8AE8CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0257C6B0088; Thu, 14 May 2026 06:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19A76B008A; Thu, 14 May 2026 06:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E716B008C; Thu, 14 May 2026 06:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1A3E6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:50:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EC191C11E9
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:50:13 +0000 (UTC)
X-FDA: 84765705906.21.354AE44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9102B100005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:50:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qRFzwpqq;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778755811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WP5HkGCOXeBumcbhVpqSb/Y1ZYkL1EbKrS+A/QdanYU=;
	b=6eC5PZ6ihrM4RIbDqrm75AWJl6hVMAytTrHHMTD3dYe9tSzuqWJJo1VsXSdqiqF7fOdk9d
	reLGxrNh+MgZyXStL2s0oDqZaToSTjqdZUnSlJYDZ1wtwQGVb76QXdRQETtqA/0tGv0AdP
	H3jUF85z2rcPtaaMQUfF2mvkkphMBjI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778755811; a=rsa-sha256;
	cv=none;
	b=j0g3PnDbMXu+AXWwZPNAau+gz1LkAE9GOVBUIeXIQblaEr6m2FS14SbJZRVTZzePcyfAKO
	15Hhlt0azo5DEKJo0YD5vFwCBfNtCOt82hueeec9LG8mMU53ZBVgvQ1BQz3AWiG1Yx1aDf
	+lyPdBh6LKIx16a/6vdms+h2L5iaOuY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qRFzwpqq;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E6F244014;
	Thu, 14 May 2026 10:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E5CC2BCB3;
	Thu, 14 May 2026 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778755810;
	bh=WMLrsduBdHE1KBwJsp823Q6gclXLxlObdPC//VOAMuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qRFzwpqqmLxT1/JTTa2PruTcM8MX1aELx2TzgGdbRDuYDw/98TWHbMmHekAa2qcrE
	 KWrkq8OhlrtFF+Qez/UNeNBVg514WoznSJWEGy2OFMFgTu/2aGbMdVMSY7TCfAG2Qx
	 SBBkuk3glKr1A24CgWMGuBw5ppTWNqtM3tKArIMfD0h59gQq+3P99Ib6LNLWiPp21i
	 Ro/pIpYDQ/RVyV57kvczzTSwegO/EORFlitgGY54kiwP6zsRiODUZRKS7rGbUwx1h1
	 aDKUo9H75nDKPzpa09q/FxnbTrxhNcsiLqNdZi57GYBz82yPseJDSIgwgTwY49iWfZ
	 W3RYHRkeghvCg==
Date: Thu, 14 May 2026 11:50:03 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hrushikesh Salunke <hsalunke@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rkodsara@amd.com, bharata@amd.com, ankur.a.arora@oracle.com, 
	shivankg@amd.com
Subject: Re: [PATCH v4] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
Message-ID: <agWnE389JGhDMj7S@lucifer>
References: <20260504063942.553438-1-hsalunke@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504063942.553438-1-hsalunke@amd.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9102B100005
X-Rspam-User: 
X-Stat-Signature: stxbw7sh5a15syy999zua96tp3s8guot
X-HE-Tag: 1778755811-639619
X-HE-Meta: U2FsdGVkX19/XnjeF0VQJV8O0z3g4ILDDNkmBKMdn8mrHxF6o6qa8ln2ljnyMvn3kmcdQjXMNuOirJrC4EGyQLaKZVfegw6IAbgc++ix+XOHA1RZyeitC+e8xcqrxBKpcQb1dWCsVqstOCtXhWlM31mA5aPX1p5TqAZdnPTdddHpPXfqiHHsAuzvATy+QNtkBR8jKqGEWq5eu00JzunsiT53UAai62oh5h1jaOmwVac+c0nXzImqodyaDSWVbaWAaGs6rTfLidSYh75fueUgegQmiACl3/dFNwMYYyUrSoeXfzBw86HOBpGyY5bX3HaGTxOJKYP4PJcn8qOGlOQKx9Sr6VLBcxYIYQ6Sh91X1voTal8gJUmu9DTyc5A3xxMMYHDolXWR7rxUiczB8KBkd34qDfMns+Wsf6daY9myUsf15Np8cGUdFw1tTyFMgxWZsYGzvyLQfAIKSRSrpK6+2OpqwkObMq/7/MFCo/1ABnhQEAdv2QjOT0N0eJuPdi3RaqW94NQqe0JoEHp3kAAhjEbdEHg/b0TIyVEn1nhbF9t8zK9U06dLB/CWeZIbyJ/2N7NC3pLxz60C39l+n0goGUdH/USsu4Nj7u6H7CHVLjU6PCuZjYsVrh86IrVG2mLasJ3/fetF3dTB6AEfti9lrJZiyRUQqk/MSId/3ENSOrA6zmy+MClnB2WemfWIKULJnpBInCGu7oY5jg10GOLlbHnFvS11rT7ZWtVpg6BxfYPUmO2VlpTsQdUOtnDnPf495FLXsHG532h+Ev844qWL3WJ6bo8av8Cwy3Tfq2cwe/VjQGVSLscPiFa+ZQuxltrZCayZ2fwBUCGmOxGgef5dp4+7of2VkFqWXtpzrlbBMC5UaXkwp8x/2vF8fMNyng/h8PcZY35lDJnurIxbyS+h6s6TgJBcv6vIJf+7PYLNIB2tzdZ2H2uGFUxXek1hSLwJ+DfV9bXHeUekJIxd2bw
 H0lMokNl
 xkO9q/xNCHKeheuBjw6/eSjP12LeDElfBkUPniyrToKi7vRyRzXddx5eyomYGujR+FPqqvrqO4YbpjJLQe3JoM9P31VDotyb4FpnpS5zbBJP0bGyDL0r1n0kxzm3Z4hf6jphw3GLUrTX6zyqKs4EdeKgfVL6zXhR/ciwlVqGSKyrmVOv5zWJDw5Jtr5PNRx23D7FFrLr5NIqFJp/1R9o8IexfLkiiS90CWrNfnWDKeXqIMx9vkUQOlB78LowGzpzfgviH4ymDFsibLJcy/+c8YhLGA2GJYROlT033FtO01BrwTh3iiBHA6Ir0VpJIUsQezzP5X11+QjgHq/Ud5V0t4O225v4b/jKus3F0tmEhKexq+gg78/Z5JubJ9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 06:39:19AM +0000, Hrushikesh Salunke wrote:
> When init_on_alloc is enabled, kernel_init_pages() clears every page
> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
> kmap_local_page()/kunmap_local() overhead and prevents the architecture
> clearing primitive from operating on contiguous ranges.
>
> Introduce clear_highpages_kasan_tagged() as a static batch clearing
> helper in page_alloc.c that calls clear_pages() for the full contiguous
> range on !HIGHMEM systems, bypassing the per-page kmap overhead and
> allowing a single invocation of the arch clearing primitive across the
> entire allocation. The HIGHMEM path falls back to per-page clearing
> since those pages require kmap.
>
> Replace kernel_init_pages() with direct calls to the new helper, as it
> becomes a trivial wrapper.
>
> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>
>   Before: 0.445s
>   After:  0.166s  (-62.7%, 2.68x faster)

Wow nice!

>
> Kernel time (sys) reduction per workload with init_on_alloc=1:
>
>   Workload            Before       After       Change
>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%

Lovely :)

>
> Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>

All looks sensible to me so:

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

Cheers, Lorenzo

> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
> Hi Andrew,
>
> This is v4 of the batch page clearing patch. v3 is already in
> mm-unstable, please replace it with this one.
> The only change is moving clear_highpages_kasan_tagged() from
> include/linux/highmem.h to mm/page_alloc.c as a static function,
> addressing the code size concern you raised on ARM allmodconfig.
>
> Thanks,
> Hrushikesh
>
> base commit: 2bcc13c29c711381d815c1ba5d5b25737400c71a
>
> v3: https://lore.kernel.org/all/20260422102729.166599-1-hsalunke@amd.com/
> v2: https://lore.kernel.org/all/20260421042451.76918-1-hsalunke@amd.com/
> v1: https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com/
>
> Changes since v3:
> - Moved clear_highpages_kasan_tagged() from include/linux/highmem.h to
>   mm/page_alloc.c as a static function to avoid code size increase. As
>   the function is only used within page_alloc.c.
>
> Changes since v2:
> - Moved kasan_disable_current()/kasan_enable_current() into
>   clear_highpages_kasan_tagged(), per David and Zi Yan's suggestion.
> - Removed kernel_init_pages() and replaced its two call sites with
>   direct calls to the helper.
>
> Changes since v1:
> - Dropped cond_resched() and PROCESS_PAGES_NON_PREEMPT_BATCH as
>   kernel_init_pages() runs inside the page allocator and can be
>   called from atomic context, making cond_resched() unsafe. The
>   original code never had a cond_resched() here, and the
>   performance gain comes from batching, not rescheduling.
>
> - Moved the !HIGHMEM/HIGHMEM branching into a new
>   clear_highpages_kasan_tagged() helper in highmem.h, per David's
>   suggestion.
>
>  mm/page_alloc.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 65e205111553..3a59577f58a5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1208,14 +1208,18 @@ static inline bool should_skip_kasan_poison(struct page *page)
>  	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
>  }
>
> -static void kernel_init_pages(struct page *page, int numpages)
> +static void clear_highpages_kasan_tagged(struct page *page, int numpages)
>  {
> -	int i;
> -
>  	/* s390's use of memset() could override KASAN redzones. */
>  	kasan_disable_current();
> -	for (i = 0; i < numpages; i++)
> -		clear_highpage_kasan_tagged(page + i);
> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {

I hope that, soon, we won't need this :)

> +		clear_pages(kasan_reset_tag(page_address(page)), numpages);
> +	} else {
> +		int i;
> +
> +		for (i = 0; i < numpages; i++)
> +			clear_highpage_kasan_tagged(page + i);
> +	}
>  	kasan_enable_current();
>  }
>
> @@ -1428,7 +1432,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
>  			init = false;
>  	}
>  	if (init)
> -		kernel_init_pages(page, 1 << order);
> +		clear_highpages_kasan_tagged(page, 1 << order);
>
>  	/*
>  	 * arch_free_page() can make the page's contents inaccessible.  s390
> @@ -1853,7 +1857,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>  	}
>  	/* If memory is still not initialized, initialize it now. */
>  	if (init)
> -		kernel_init_pages(page, 1 << order);
> +		clear_highpages_kasan_tagged(page, 1 << order);
>
>  	set_page_owner(page, order, gfp_flags);
>  	page_table_check_alloc(page, order);
> --
> 2.43.0
>

