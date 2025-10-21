Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BECDCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 21:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0E08E0016; Tue, 21 Oct 2025 17:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1A68E0002; Tue, 21 Oct 2025 17:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE198E0016; Tue, 21 Oct 2025 17:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9708E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:24:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E80C2C0680
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:24:39 +0000 (UTC)
X-FDA: 84023400678.25.4E890B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1CFC040017
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:24:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fd7YyQbg;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761081878; a=rsa-sha256;
	cv=none;
	b=E872DzOcFlR1ZwbpQDP+iA/AB2BONwYG7phntgZ+foZcF/kr32Q0NgLl2AJldaYedGn7z/
	ObPgaV/7fSDr9EgwSpumfEvRva08iI3WOp7wRnVavuhrE4sRM2Ymrw5REc5+3Dwb5WCDE8
	5CryD2oRH9IZqb+ia7OUyNKqlesZ8cw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fd7YyQbg;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761081878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=is2DfcXX2jw9dyGl0DhbHzFw1uXgpdA6sVxb+ttjkqg=;
	b=Hww5NJ4/mNRKcs+GzkH0vEaHKcFNEY2Ehi5r/xAAumXQ7bYCsB2FwQq805msP5+O/60jAO
	IFnIbG1Luo+8puf4T4WwK/NzNegH0IrqbtxbRLIdnD5zJN1UhQ+XIbpBEBKpK72evNZqZP
	ukDiaMrbOFCHL6vwMkCdlteCIxx9SFI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23C8741A34;
	Tue, 21 Oct 2025 21:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E9EC4CEF1;
	Tue, 21 Oct 2025 21:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761081877;
	bh=oqkW0jXITuUuP1+YPYte4eJvwGa2Mg1pWU6Rq32htJo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Fd7YyQbgM7JOcm0pPSTvo8rC23g00gbXsNPzTfSAX65pGNKoko2XIkUo3Gv+Ifr88
	 ZZmmnayyqQ409qX+8bfe83maT//uPddN1a1uxkb3gPBuThXRApnYAyZom3aLrMzM1m
	 dwGQGQIwC32drpZYgkPIUfhwpp57HPhP/hPwXf6M=
Date: Tue, 21 Oct 2025 14:24:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Uladzislau Rezki
 <urezki@gmail.com>
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-Id: <20251021142436.323fec204aa6e9d4b674a4aa@linux-foundation.org>
In-Reply-To: <20251021194455.33351-2-vishal.moola@gmail.com>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1CFC040017
X-Stat-Signature: 4dwm6cfn9rt79hqhoduz5czm4n8rebdk
X-HE-Tag: 1761081877-704010
X-HE-Meta: U2FsdGVkX1/ja6rfB9fHn05NnNqbeMRczTqxCUDNry03ZOanhFJouCYkVEiX1M283Z9AJo3HJSZLH5KAZmHDb+WLUn5Mnk5/rgO5wO7dpEu/0EuW3i3Ebv7pRXd9TZgzooNfWzEwxj4RxTgcTYZwm8ZtToEy7DefBTnVR7OgV1x/jiCqipFifyObTV8Ye44Bm83AW7wS5PvjPOOCiHzpYtHMfPZt01TKe3wKLyU3UDy2920gG8ujBs/fMw7UVzR02pU+8D99gs1F7tPFl2yOC8XW5CQZVCdeiELwmT1WBRyxcACTA6jNjJHyh0GSr7do5jQ4QnRMYzKrYpERr2uJ0J5B1rxSJFvbWRvlTfsFcDOmZUklMfNZjudbeb0xmvQJHXwEaH8LbIPq6UgVzhJDe1l3dtP8lkNJmcAzwxGES6HP42o8nTxXy2bZCw/yDnmUcnNURkR8drQxV+l84eO/c72aBf9YPtv87RAMPbbL8WP3rRi6H8fR/dk+KID9FToxMrnTB9GvyKhfa6rATvh618tvye73Vda7VUHQSBjlMRM+1q2Xw3m0BQrihfM/ORIN2eiLtBFyIbp2rqtM0PAbXsB8GC42Fc+gHjvohAC7npqwGGMgkfWn/1tfcREYA+3fw7CuHMjrNWJYy8m6p4KdFK+9dTJrz1C5lhxv2cYBDaRsHEgSHazfDG0p90LxIFPSGm0HiDFbEsZx3xoSiCUgueWy+gbNvZnoqI6okskhYU6i3uf7cwxND+lH4m7veLjU+mEyeklWJaTchYrIBMiC2dGoJ1T6goikh5DNs2ARY04TMIhge2eMVI06Y+7MHQhU1n74QVJod27t51XYaAKitlNxD1whkBirbVxJID5DyTRoype8BNvNvFUhKiLC0vHJU4dgZCB05+f/14Qs5ImKBbUCJmfzqAzzFu+kIPIR6EFB4MrvHmmEZg4Cw0XkwjkF0Zra//kc5hAAgBBmHsc
 sOX+/fTs
 Hu63gMfKy0mKH4Vl1Cd8xKXPNCuuPcaglp5cVkFfxjXIFdqxlt1pO/9MpcTkf6V8i9xOmckoojjirIR6hXQr2XZH14TjJzo86oqBcHhUvPxePU49+wd4buvVL2y9/XbbFLCpel3wWk641KLuyxr3mlhFZ+972jGeoHPl630DokSv4l4VdVLi05CXcNcL0bFXTdPb+nZ1eAej1bseCoG44cC/f/o15zS1VYpT0N/z12OzJu595cVZsR/x4m0Zg0PlTd3BRMR0fkdcs6HagnZbUm1b9X27pq41XELtSuajkVG26ARVsJEV/EOsdI5lEUSI2i2UUewpK/NacyHeAwPA78wzjlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 12:44:56 -0700 "Vishal Moola (Oracle)" <vishal.moola@gmail.com> wrote:

> Sometimes, vm_area_alloc_pages() will want many pages from the buddy
> allocator. Rather than making requests to the buddy allocator for at
> most 100 pages at a time, we can eagerly request large order pages a
> smaller number of times.

Does this have potential to inadvertently reduce the availability of
hugepages?

> We still split the large order pages down to order-0 as the rest of the
> vmalloc code (and some callers) depend on it. We still defer to the bulk
> allocator and fallback path in case of order-0 pages or failure.
> 
> Running 1000 iterations of allocations on a small 4GB system finds:
> 
> 1000 2mb allocations:
> 	[Baseline]			[This patch]
> 	real    46.310s			real    0m34.582
> 	user    0.001s			user    0.006s
> 	sys     46.058s			sys     0m34.365s
> 
> 10000 200kb allocations:
> 	[Baseline]			[This patch]
> 	real    56.104s			real    0m43.696
> 	user    0.001s			user    0.003s
> 	sys     55.375s			sys     0m42.995s

Nice, but how significant is this change likely to be for a real workload?

> ...
>
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3619,8 +3619,44 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		unsigned int order, unsigned int nr_pages, struct page **pages)
>  {
>  	unsigned int nr_allocated = 0;
> +	unsigned int nr_remaining = nr_pages;
> +	unsigned int max_attempt_order = MAX_PAGE_ORDER;
>  	struct page *page;
>  	int i;
> +	gfp_t large_gfp = (gfp &
> +		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
> +		| __GFP_NOWARN;

Gee, why is this so complicated?

> +	unsigned int large_order = ilog2(nr_remaining);

Should nr_remaining be rounded up to next-power-of-two?

> +	large_order = min(max_attempt_order, large_order);
> +
> +	/*
> +	 * Initially, attempt to have the page allocator give us large order
> +	 * pages. Do not attempt allocating smaller than order chunks since
> +	 * __vmap_pages_range() expects physically contigous pages of exactly
> +	 * order long chunks.
> +	 */
> +	while (large_order > order && nr_remaining) {
> +		if (nid == NUMA_NO_NODE)
> +			page = alloc_pages_noprof(large_gfp, large_order);
> +		else
> +			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
> +
> +		if (unlikely(!page)) {
> +			max_attempt_order = --large_order;
> +			continue;
> +		}
> +
> +		split_page(page, large_order);
> +		for (i = 0; i < (1U << large_order); i++)
> +			pages[nr_allocated + i] = page + i;
> +
> +		nr_allocated += 1U << large_order;
> +		nr_remaining = nr_pages - nr_allocated;
> +
> +		large_order = ilog2(nr_remaining);
> +		large_order = min(max_attempt_order, large_order);
> +	}
>  
>  	/*
>  	 * For order-0 pages we make use of bulk allocator, if
> -- 
> 2.51.0

