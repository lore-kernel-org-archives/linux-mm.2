Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80390C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E9A6B009B; Tue, 15 Sep 2026 11:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736AD6B00A2; Tue, 15 Sep 2026 11:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D736B00A5; Tue, 15 Sep 2026 11:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49D636B009B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:28:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7D9CA0476
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:28:26 +0000 (UTC)
X-FDA: 85216378212.03.021FF73
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A976C0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:28:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=splJMSXx;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=splJMSXx;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789486105;
	b=Elv6t26Wpp8KEi8fpNxGT0e8kcf5fVW4Pqhr6ajbMf5RkkYjHUqKW+gkRi5SHfam3boZda
	tgczzrbenPzteM5wve+G3HuS1HQwsgO1E0kHFZmNwWNJWZRmD7KNfsQbQNn73PVZ+zekX4
	TD5M/0GLaZSR8dxaxN9tw5RzlWjbRyU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789486105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEW88ZQnSuhZNPj3vkXIV8NZ1wmCRrjqEwOa3KU5UvU=;
	b=LiLOxRhF9ijG0b324DDC2YGgeqZDliHra+FSn/itLZruAwU493jZUoQLP8AWq09PYelIBV
	BesWRwiQuEOZRAgXkzdf8AfXZavPGksjRcAyfb1GG35pQsINn7xD2262rP3CsTO9EyFuKs
	gosF5apgdbH2OzslyHcHFZdWpJWGE6o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QEW88ZQnSuhZNPj3vkXIV8NZ1wmCRrjqEwOa3KU5UvU=; b=splJMSXxhNub0eAzI8FujE44l6
	r4XyiRYshHMUnl86YfqkEb/+1g/xAqFKnDS7oAtZRCdHl+ol9kwgKqFB+vMzPAwuouJv8NHBQGCRw
	ef2KBchTH6801R2hPBb1AX1QZh8Z8RB2Sd0bKZVDcCy7FXjJhXbuyfSQWFn5T3Cp60+xexWLaChrR
	YL2q1jTyNaoVC852BBCLZGXqr2Pfyqj76IVCbXOf5H0lCDwBq/lyowLowr/y27glmiEEhjSu3WE0l
	b+D1Naua42STbyZlsM3JJ7SlqmHdDAEOU3ArukM5LPYIp61pQ0jNFnCNajqePYwIFrDLMwRajzQl0
	5GnonEZA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6V53-000000079xT-0yw0;
	Tue, 15 Sep 2026 15:28:21 +0000
Date: Tue, 15 Sep 2026 11:28:19 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Yury Norov <yury.norov@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Eliot Courtney <ecourtney@nvidia.com>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Yury Norov <ynorov@nvidia.com>
Subject: Re: [PATCH] lib: fix lock initialization in region allocation
 benchmark
Message-ID: <tniaziqadej6t3f6herhfzsxu3di7deewfbgfpr57mlsurbbak@mkzuybcvjj24>
References: <20260911155244.1406122-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911155244.1406122-1-ynorov@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A976C0002
X-Stat-Signature: 14t3i4sbp539k94rehfqdxmqzj574fxx
X-Rspamd-Server: rspam01
X-HE-Tag: 1789486104-75661
X-HE-Meta: U2FsdGVkX19hs/byK+fdWS9eveCMW7AVy5Lu750YOToC2ZJm6867n+nM9FE2xe3InoCqB1SBLWZC/jVdYvO9D26EfHXtn12wWo36sBtYZAcbBWsg3xlHAmz8EFzC1RZoWZxDNPFUt6zREZb9HoVsp7gt2t/VEx+IvCw9alis3m5RZRDvCXQDYjSM+dBjz+dt3CF+Yu6QKnfURSmq0xRgwahEJHf1OJ9mF7TTtpBqlAoE+9SPx9LWIzS88JYRlae/kAcDbZKY1/WaiLJsoxlqDBnh+2xKaOYYKf/RfG8O2G2d8m59H72oY0S6P9iE+I78VjGpaVIa8om9W0422VMnDjaXFH0HiwyaHhWkmy23xTfv+bqajgLJaoEbV59W5jOZ3xIQ9UOAKFBBNd4SOoiCC8BGNXcnTflslPFMJ+pCTQb5+TJhegKVrQT5LhT2InsNLp75akGoHAz8OaRZ2+tv0S/QwT5neuvPABc9bCNifA0lVh9ox4iHq8+7Y4hHsR/kR8yZGWtEJNbhBjiWq7g3t22teuuSr8KwYHnd1EOnNioryY0cE1ipZkWl8WDmulRRmhm7WaKqT1IU76GXbWtZYhQuNzC8QfkkpSMc6eQ4za+SswF9X/7l8h3FmaVEo/VDG+1xA7HNazpPMwmJIJOpBYLgAfWJkz/p5/DT8KviVlTnXY/PI6f6rLnEubEKS8CEkJvDTgm9DRXMnVo5Pj4Srmpc/VDg8CYahmpy7psjgEJfacu56N9Xvf4utvExwuaUys5Bdxzb/h9kKQggz7e9wtz9+zXfHpKVMpv3amG5oTi6/w4sNN0P4CkR2LsgiayA1RBuvcboPYkkV5FqXaCzL8IhLwDQQJXjUyUGaPAZW0mz4gmMEqXANJU3PZAhqQkGgJ4pZPni1jskIVx3CadIAwlkjvkSFpHi9xsBLn/XW+9upFkUzN6Iez0RYhE55NgjXMXgGVtO509YamlSI68
 Aa/8dwrk
 xvnFnC1ZLvFJj7Va7V3AT4uDngyL5/fgwrJvOUr7FpYxHyJFDRlzEcH5sDjYafOSACr1tXCHQ+FC2tEaOG8N9g84lSDeegp/z2RtSxSXpvj4xlBK8sEPIvKiJ+h5MlKrvAaG+OWrGCHZ81/RwZaKqNyr8Dgg/tgmurBYPcWdG/RbTDT10vaDhIDepXnYkXE6Twb+ujWLu4lhKD46hqJ3mBR7YEa3l2taJkQZsrfr8smxgFs4LIs6digPn8smtV6PPMEq+JdKWBmCLIdhJyst2UqEh2N8vF0sA5fOCNSYV2YvwuiLTvWwibRdYh3eOg2mtMcZitzynP9TkgiEfL/DR30dIViC2vfZsTXvL+JaPHKDXOTu4A8KUltXlM1UVL1bF5/odyBhvqX9YZWznds0XZ+mHNlb3wLNElcnFA2Bird3xdEFwBBd0pl857eK6Ht1PwSmJwMzbNk1zrH022pHDwgSTr9Y6optbXrx+jngPlCg22/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/11 11:52AM, Yury Norov wrote:
> The Maple Tree benchmark uses MTREE_INIT() for a stack-allocated tree.
> Its static spinlock initializer leaves lockdep to use the lock address
> as the class key. Since the address is on the stack, the first allocation
> triggers "INFO: trying to register non-static key" and disables lockdep.
> 
> The IDA benchmark has the same problem through IDA_INIT(), but runs after
> Maple Tree and therefore encounters an already disabled lockdep.
> 
> Use mt_init_flags() and ida_init() to initialize the locks with persistent
> lock-class keys. Keep initialization outside the timed allocation paths.
> 
> Fixes: f4806cc63cc6 ("lib: test bitmap vs IDA vs Maple Tree performance for region allocations")
> Closes: https://lore.kernel.org/oe-lkp/202609101106.771b567e-lkp@intel.com
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  lib/region_alloc_benchmark.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/region_alloc_benchmark.c b/lib/region_alloc_benchmark.c
> index e88b4cf55c62..a644f3d5431a 100644
> --- a/lib/region_alloc_benchmark.c
> +++ b/lib/region_alloc_benchmark.c
> @@ -78,11 +78,13 @@ static size_t __init ida_size(unsigned long nr_ids)
>  
>  static unsigned long __init benchmark_ida(unsigned long cap)
>  {
> -	struct ida ida = IDA_INIT(ida);
> +	struct ida ida;
>  	unsigned long cnt, idx, off, nr_ids = 0;
>  	ktime_t alloc_time, free_time;
>  	int id = -ENOSPC;
>  
> +	ida_init(&ida);
> +
>  	alloc_time = ktime_get();
>  	for (cnt = 0; cnt <= cap; cnt++) {
>  		for (off = 0; off < reg_sz[cnt]; off++) {
> @@ -125,12 +127,14 @@ static unsigned long __init benchmark_ida(unsigned long cap)
>  
>  static unsigned long __init benchmark_maple_tree(unsigned long cap)
>  {
> -	struct maple_tree mt = MTREE_INIT(mt, MT_FLAGS_ALLOC_RANGE);
> +	struct maple_tree mt;
>  	unsigned long cnt, idx;
>  	ktime_t alloc_time, free_time;
>  	size_t sz;
>  	int ret;
>  
> +	mt_init_flags(&mt, MT_FLAGS_ALLOC_RANGE);
> +
>  	alloc_time = ktime_get();
>  	for (cnt = 0; cnt <= cap; cnt++) {
>  		ret = mtree_alloc_range(&mt, &idx, xa_mk_value(cnt + 1),
> -- 
> 2.53.0
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

