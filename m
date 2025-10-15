Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F59CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 10:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFB78E0016; Wed, 15 Oct 2025 06:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097B18E0002; Wed, 15 Oct 2025 06:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16678E0016; Wed, 15 Oct 2025 06:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E11B98E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:44:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76740889B4
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:44:28 +0000 (UTC)
X-FDA: 84000014616.16.EBA0320
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 999CC40003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:44:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dd649Wu1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760525066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ja98IX4O3cTLH8elNwZHWRY1chVsyxH3oWvi7WUQjeY=;
	b=d1mkKJeGTHhEileJcfBKhCxWrirqjE7AWoGAIXxdm0v6XS74xkCjPoPsUrh+lmwxAswb+K
	S/vPLJpdUxWRrnWzNe5xQTEEgbJ3WVIsgtVyn6PQ/eM5pSdyiOXWZLw39mW4gbep0S1rzC
	M+NDcmBrZLageg6Msf/c/d8WuRMR4bk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dd649Wu1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760525066; a=rsa-sha256;
	cv=none;
	b=HQwTtk/IcEYkpt4+ZvreqC10nGDNg9agxxcxqWU2owoVzp084XctAnVF9vNfxPt+PUr8H4
	e07S76whp3Vmyri604lagh2vsoiO7DKwFqowVH86508QtbQpk/vulu9F3Do35ApfsWx50/
	74z0WdyDh4OnFY5eJfCPj7j81VbqfyI=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46b303f755aso56653135e9.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760525065; x=1761129865; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ja98IX4O3cTLH8elNwZHWRY1chVsyxH3oWvi7WUQjeY=;
        b=Dd649Wu1GZZNES17jtWuINl/tlLBsJMShkJ9tSATCG8AoZVvOzgE80XHEZRBxJ5xRg
         XtD+n3GDO4kSz/UQg7sBiEZ6aJFeHwVrqRcgoRfUvxj9PBn9MzuUXCJsmipcOwK1M6q1
         YRjF418ojXQTps+HH3wiX0uQou4CiljzK7gCnyhDmmZEcnTMFczmj/yZ8XVHIf0vq6JA
         +lXIXiDCKpIw9tvg9GDNMj7EMBUf0HFVMptDFqixz4GOAG1Np2uMSKcLMqKTM0xBZ9qq
         8hLzJOyjQKHWxUcIjaeJGXafETBpE8kZyx/5pajjRoqMcmFAnJK7rdJb7osi1MPVuui+
         4jug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760525065; x=1761129865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ja98IX4O3cTLH8elNwZHWRY1chVsyxH3oWvi7WUQjeY=;
        b=F465KHQIPMpMCRf6QoJz9KazWQZmiQa14nXIN+QCZ6e8n5rAwogGhbqFiyN1qzvGYF
         8ti9F3v8JCLrVDIOmhRm3Vh2Nc8rvwCmc2/oze6BEzvRH4noqRjs4EDB1oqDq+HCX4To
         IMzQdi9KqM2KhNfOkUPaj1Gx4BZTuOdT6LqD6YwJXC3c61zUgiB5/uH+G4dOYVHgPoM8
         PLYGThMKzRT6yymOU4uKc7ZP6wKSo/eVmytjKxJJsNhWTY2ccOqIV6dWTOHH5aEYJJef
         th5jntISgHt4UsBuAst2B6tNPI61KLda9k/KDoezqw/UZSwm+hft88U61+bI0e64URge
         URow==
X-Gm-Message-State: AOJu0Ywv7gV6B8ZUITK2loIT2GBYQabXcF/WwJVdxRrJnladJWFXR7VV
	lkqO7BZt9gi2ykkOpGnTDqP8kXEpZGVz0UUQt0+WZxWRUzNRo+2AA94L
X-Gm-Gg: ASbGncs1zmb6MJL6PpgwY5Om0QFRyZgKu1WryPSQGR1KPUyhsJ8jk3wB8AdlFMVIGoA
	mB1uf4XkTwyRtNabmFL7vw/tIfGNa84MOvvai/TSToDcOuHlRQo4JhTrm4R4XKk0fw4eBDEZdgQ
	7vv6UzIzr718Rl3S3xXR3/I5PqfSJQavdxSviuq9e4dIEL8QY/U4CmYxSZAeGwyT7ZliRBQOH4G
	ItsdD2s8hcLdoYCE4YrC9KSPrM/1Zooh2px/D5Ym6JKhHXfnf9trRUPpziad1KwYp/HDN47B/0v
	4g0kuBEj4KBQJ1WkQ1jUPSV8NM3yqe/EG3lOVohRV9FGsisyRfFKFLA+RW9Xse/T0t9QcpmqdPC
	SINTj5/R45wd8cOq57iGE4R7lCDG9yyMVt4Qx9KvNTx3pCA==
X-Google-Smtp-Source: AGHT+IG61k8TsU+nB/wUHMVmWo7EiG1XXr0JninDaZK/tiZZ7l9Az3/JlEMJMgkqkdZo6AaTLocEaA==
X-Received: by 2002:a05:600c:1907:b0:470:ff87:6c2d with SMTP id 5b1f17b1804b1-470ff8770dcmr13266675e9.29.1760525064699;
        Wed, 15 Oct 2025 03:44:24 -0700 (PDT)
Received: from fedora ([31.94.20.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab5250ddsm170242205e9.6.2025.10.15.03.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 03:44:24 -0700 (PDT)
Date: Wed, 15 Oct 2025 03:44:22 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aO97BjvNZNh0UV3u@fedora>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO9Z90vphRcyFv2n@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO9Z90vphRcyFv2n@milan>
X-Rspam-User: 
X-Rspamd-Queue-Id: 999CC40003
X-Rspamd-Server: rspam03
X-Stat-Signature: 6o1yc9hcpb68cwiq4hqjgx6gj9zrje9z
X-HE-Tag: 1760525066-592953
X-HE-Meta: U2FsdGVkX19icM/aYiD0uyJoGXTLuscl8kgw3V43yuTu7HcISnBrxQaLjQyhrD2cf1u8rQTQZBC7XTrCZ1x/zL/+uoIp77qhCP3mGSlaZyhhvg21u9h/BEj5Cj5CMeHoQX0KqiTXXAac/UFrLsY8MEOAK2VjM5CghQEk36v6phiEh9+/kCK+wbHbSHEi1OYLvGedbICDPrLCgrFr0u3Lgut8oyCk0FhQ6YcwWn0NcMxV1DUzO2tdMjYMs8iQENpd9/hrZnZIW2Yl1bNDZgklfFpM6oQ9mnD+a1D0sZLJv0OBYvM0zVMOqF4Xa1YrKxp0o6mERYwBUFhvBHzpbDJ41CeVntbTjK7VMupnFMgsK29dM4bg091qZTRWhOGuJpIs5rzfBvmIOnttnwJNwlU8Si/uwpJcJb3tZSsTTz5c/UVFOqjdPMlOLD2ndVabru9FHcsrEQgoJXuX3gYeqDI8tBsqGcvbmEGEU5+EhzwkKHUY5RWFiaBHmgk2+hDGo+JxOyXeQEacwzSObG6kUcnZTxE1kSH0K3HLBAqi+dDVP/wU6JLJjoTBpTmX4cII1PPpfQL6b0cD4Mefg270jcfD8Lede+d31ozUgKrfRDWmeqCOEHuNw9BRao5VEAC1r1k6Er7d2EE06tvPx2H2++rYgAMmhtjxn956+XEg+xDfmTwhUw9ii5Ey8835Jfgmn6A/k209sPugnXVKvHv/VuG53tKqYOYenR3tS0rmN1BzjxnbrdmdIGK4y3h3y4pTslpJX4FgCYD1Ez0GOeeiOq6/wDMC/pE+PW3H+HCGqsT18yfBCBsBX+FV123y/ufic9Jx3/ahF3ChxFPOBiyZ1QrvTwMq0j9NKzHLjKyn3uBff6DvB/ORj/twhjJC4ZAOTl2u+Zq4tlnbTN89WqgsYngCJ7+I+sI7EQivGExLmxv7/K/UwoG6YgHEk/3pp3flsuaM+V2Ho7qGPNP7SHHB9lP
 n/jhxIuj
 DwEfEd6dctQAB4km3swPsOa9+Etr7WqpTt8BJNKR8zDG0wnhObzFTRA4YOFlpGs/GS4uZdFBiTIUXswJxeIjec7xNlSJk8Bw9CcKXEd0VmigRb7F5NKOkbWlmqG9+6KU5ZFN3HoltWUtVDSLc1lk/+hJ7rxHWbuOLOs8m5cMGoKr2JKZL0AcboywPJvJnL+MlNcj06gQeDFIn6Lqrj+bOBaot4gBzmgdZqNgYvYIPMnN+onePe93XReX7CwFNVlv+v9hcNjOQw6PQtFteG77sEJWQ8gsAWSSiSsuYPErjpG1pAMwQT/KLQYabTmX8uTx3+jBmNKGJqrCMjmKiNXZIoQ+Ix7RJMTYvKJhXRvyqOfuVrwNonFZIkB7hEdsOMC1VYhFXcmHIDKY5qHcjlltwoB4fKBJsXbyzhwVcp+wJu5lrcTjq2gg4VYrI1cR9QUPtQE1TBUxZYhnP2OJJrhW5b5tUrnyVKINoY0ltuYL29n5OTh0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:23:19AM +0200, Uladzislau Rezki wrote:
> On Tue, Oct 14, 2025 at 11:27:54AM -0700, Vishal Moola (Oracle) wrote:
> > Sometimes, vm_area_alloc_pages() will want many pages from the buddy
> > allocator. Rather than making requests to the buddy allocator for at
> > most 100 pages at a time, we can eagerly request large order pages a
> > smaller number of times.
> > 
> > We still split the large order pages down to order-0 as the rest of the
> > vmalloc code (and some callers) depend on it. We still defer to the bulk
> > allocator and fallback path in case of order-0 pages or failure.
> > 
> > Running 1000 iterations of allocations on a small 4GB system finds:
> > 
> > 1000 2mb allocations:
> > 	[Baseline]			[This patch]
> > 	real    46.310s			real    34.380s
> > 	user    0.001s			user    0.008s
> > 	sys     46.058s			sys     34.152s
> > 
> > 10000 200kb allocations:
> > 	[Baseline]			[This patch]
> > 	real    56.104s			real    43.946s
> > 	user    0.001s			user    0.003s
> > 	sys     55.375s			sys     43.259s
> > 
> > 10000 20kb allocations:
> > 	[Baseline]			[This patch]
> > 	real    0m8.438s		real    0m9.160s
> > 	user    0m0.001s		user    0m0.002s
> > 	sys     0m7.936s		sys     0m8.671s
> > 
> > This is an RFC, comments and thoughts are welcomed. There is a
> > clear benefit to be had for large allocations, but there is
> > some regression for smaller allocations.
> > 
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> >  mm/vmalloc.c | 34 +++++++++++++++++++++++++++++++++-
> >  1 file changed, 33 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 97cef2cc14d3..0a25e5cf841c 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3621,6 +3621,38 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  	unsigned int nr_allocated = 0;
> >  	struct page *page;
> >  	int i;
> > +	gfp_t large_gfp = (gfp & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> > +	unsigned int large_order = ilog2(nr_pages - nr_allocated);
> >
> If large_order is > MAX_ORDER - 1 then there is no need even try
> larger_order attempt.
> 
> >> unsigned int large_order = ilog2(nr_pages - nr_allocated);
> I think, it is better to introduce "remaining" variable which
> is nr_pages - nr_allocated. And on entry "remaining" can be set
> to just nr_pages because "nr_allocated" is zero.

I like the idea too.

> Maybe it is worth to drop/warn if __GFP_COMP is set also?

split_page() has a BUG_ON(PageCompound) within, so we don't need one out
here for now.

> > +
> > +	/*
> > +	 * Initially, attempt to have the page allocator give us large order
> > +	 * pages. Do not attempt allocating smaller than order chunks since
> > +	 * __vmap_pages_range() expects physically contigous pages of exactly
> > +	 * order long chunks.
> > +	 */
> > +	while (large_order > order && nr_allocated < nr_pages) {
> > +		/*
> > +		 * High-order nofail allocations are really expensive and
> > +		 * potentially dangerous (pre-mature OOM, disruptive reclaim
> > +		 * and compaction etc.
> > +		 */
> > +		if (gfp & __GFP_NOFAIL)
> > +			break;
> > +		if (nid == NUMA_NO_NODE)
> > +			page = alloc_pages_noprof(large_gfp, large_order);
> > +		else
> > +			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
> > +
> > +		if (unlikely(!page))
> > +			break;
> > +
> > +		split_page(page, large_order);
> > +		for (i = 0; i < (1U << large_order); i++)
> > +			pages[nr_allocated + i] = page + i;
> > +
> > +		nr_allocated += 1U << large_order;
> > +		large_order = ilog2(nr_pages - nr_allocated);
> > +	}
> >  
> So this is a third path for page allocation. The question is should we
> try all orders? Like already noted by Matthew, if there is no 5-order
> page but there is 4-order page? Try until we check all orders. For
> example we can get different order pages to fulfill the request.
>
> The concern is then if it is a waste of high-order pages. Because we can
> easily go with a single page allocator. Whereas someone in a system can not.

I feel like if we have high order pages available we'd rather allocate
those. Since the buddy allocator just coalesces the pages when they're
freed again, as soon as these allocations free up we are much more
likely to have large order pages ready to go again.

> Apart of that, maybe we can drop the bulk_path instead of having three paths?

Probably. I'd say that just depends on whether we care about maintaining
the optimizations for smaller vmallocs() - which I have no strong opinion
on.

> --
> Uladzislau Rezki

