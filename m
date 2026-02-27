Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1272FD7F92
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 10:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1E36B0005; Fri, 27 Feb 2026 05:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C186B0088; Fri, 27 Feb 2026 05:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B6C6B0089; Fri, 27 Feb 2026 05:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10EDC6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:56:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A75791B73C0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:56:39 +0000 (UTC)
X-FDA: 84489933318.21.9C608C8
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id E368E40007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:56:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jzVy3phn;
	spf=pass (imf12.hostedemail.com: domain of 3Y3ihaQgKCC4TKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Y3ihaQgKCC4TKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772189798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGo8QZoLApXkf2JlvhH1g4xJEOldvoQquuaR7r0ubZ8=;
	b=TihY7zGA9aR6FP+LNxpY5c7nZn/xvby0tvFA6GPgmi8YoPiWpAy1mUTXDxzmT6CZ03YZvC
	Se4EGbBwBh2DWs08nOh9CkXY5VE1W6J1uoP3omUjgXX/yxyU7zhZtdkAnuJDiidart5CO0
	qXtuH1FjhM78Z85uJh6NXv/6m2oDYHA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jzVy3phn;
	spf=pass (imf12.hostedemail.com: domain of 3Y3ihaQgKCC4TKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Y3ihaQgKCC4TKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772189798; a=rsa-sha256;
	cv=none;
	b=S2yScVMMKfovmMIbh4kPKja3NAAiCKxtdtdcMAJUVteuhxU6D3j5mg9VxPQ4NoIe540+MR
	SiuwohXJ8IZbSxRouIwdiDJX/XGMcFelI8Q6dmplXMYj2u6SLjfQyr6Wp7M1WmHD62Beyi
	GCcfOIeuio7PoXs0y+yDX2Fg1tTrGsQ=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43992d6398fso1933244f8f.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772189796; x=1772794596; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bGo8QZoLApXkf2JlvhH1g4xJEOldvoQquuaR7r0ubZ8=;
        b=jzVy3phnPZznXuK7q2G3xIhE0w1o4iVVL9/Ub4/A5Jml/JgQt2q2HyygfzUfdxkwAZ
         ZlfXtPbM4yca+uTGFDXIIPSaj9POywjb1TAsBxrNsXOerFakrCwS5i9ReODsd9CFrR5P
         yB0iozpbp9mdeijtgrPdFS9KPa5nWwy8qHuE4ALzkQJXKEeyK3M/xhJRk6+qWVyLcAYd
         2ddmX/lEPLEYp1P470C7i5JtA6MJ/nK0717lPopYABU4sB00E6m9fesVVKdhrNT0SnZq
         TIQh2h7lr/HFUv6QRzGy2y+DZBWZC2ttg7CSa89kV1WZ17BpOD6rU3jKCBDuVxQEUEou
         DHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772189796; x=1772794596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bGo8QZoLApXkf2JlvhH1g4xJEOldvoQquuaR7r0ubZ8=;
        b=kc95nzf+Uw9zhtQB8KLvYJazSYFOkh6BiiVgmzQCoJDP0JVfY3ZG04lJOeeHk/LjiS
         Tiy0WbJH6JGgn4ho9WK8qVDd2gDxtnlDi7GBA2UmpvW8LCEO1cI9QarI2TT2n33hj+py
         /HyRi+GOSqyBVmmCXoVZSMvnCn/tCSPUAq+fQNHl8XQlIRVjv+lhhdDIHv1fBY9xByHA
         ex7dxGngNlNB0y773VLgDWLkcGh7pbem2R+uf8kpDIkqxb8ml0UXnvroN7jhOILmLqjg
         Q+gShhWVSnrJ+wBwNapGoYJu5Na6wPRWeKziTN/Mvb7RbVVyGXLFGn4Y/dZpYy2qq5Dq
         ywMQ==
X-Gm-Message-State: AOJu0YyFVuEXKadYdqZ0rN3/23P4IktaPbCcgUWgAmhPd7kfdOmOfbeK
	Bg1UXhgX5KjkStuit0gx+BHHAutWJnuu0B2Hf2OMrzbqse33cNd9/h8q25Pqp52Cg96Mh9fvhLQ
	kSefZz8WSDwrFXw==
X-Received: from wrbei4.prod.google.com ([2002:a05:6000:4184:b0:439:7b98:f67e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:18a9:b0:430:f3fb:35fa with SMTP id ffacd0b85a97d-4399de2d883mr3470141f8f.57.1772189795855;
 Fri, 27 Feb 2026 02:56:35 -0800 (PST)
Date: Fri, 27 Feb 2026 10:56:35 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-17-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com> <20260225-page_alloc-unmapped-v1-17-e8808a03cd66@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DGPOUOPLOPVK.29E3EI454OQ74@google.com>
Subject: Re: [PATCH RFC 17/19] mm/page_alloc: implement __GFP_UNMAPPED allocations
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: a9osj1eodm59rdt11r1hhrs17gih9je4
X-Rspamd-Queue-Id: E368E40007
X-Rspamd-Server: rspam10
X-HE-Tag: 1772189797-275063
X-HE-Meta: U2FsdGVkX1/ltBOe3HrHX8Ncl4xKVqhooCPkn9+O0xLKmnBO+nzTZXfpbSjKwNXt7rSiClV+y/lPRrDKjFuAc++Yy4LsR4JLxYtWxEYv/pO7YIP+mFrTl0AUFV3uJzEJVOw9FRlIemH58MxnmkTBr6Dfdzigsd7GBdmq0WC/BSFDOyaZFDJSTc5xwc5CkhT8M+7YX60LpNSLO/U7836o3TNuur4DND/IMzW1Ru91vmtGIddNsXw/d3YXrB5XVR33WMVGS3eQ736rRxkc+5q3D7FzvlncNP4zddhs7K5RzYziW88savBMw/50fZYNBMvArKwpWDiYGtUOSmZsoWup3P+KJlLkPecfsixIheUtmLcFRrN+/cKkHezPdKr1u3XDzD1UacMC6lE9zdueWNq/oXxfaAUoxVhzcP7c3Bxk2WcF1AopyUUtkkKhaQxLPbBQZ/ESS4w8CFhOE3ks2OSbEY7B3HrYZacSV3Wyf8p/1rmKc2oL6xnZW3+gwQaZnnclABswsQQgK8eUB9oukrTittXBEamJsph8UzqZIa+uV6WKV64akiV2bRZ/CT32hdfb1QCheJuYfutb4bxH5qmDX5lGRXvKbDLFJJ3HtLdsD040WDJZGHdFpQBoUGGb06BS9JhpBzuvPUaUBdnppOjWK9hit7UHv/ZaDSydiXWk0FkldLuJfYCBcRrnJftFHcUqMwB02/hPOUis3tt8AwLREqs21plVLx3pv/ntgwAEdxJ/Qb2iww7gftf/vOBgwQl93DsYkqKdvGJXGPepnJxeRhOEEn80bkn6XHV0xjgBwsFtSD765JCx9S4MRDWVCbRYfgUCv8owumIMue1B2hfZk0AeJ0PTXYXogn7QPslgRb2LDpns3PHT8AZTpmqpMFwmZxJl9hM0tbkGCA50y01sR2RwIjx9Vq/mSh3VlIYnxs3zgBcD54DC7L1NbBS3+ndL/oqY/N/xmgV6AiiJCE+
 qsZsR+sU
 cAceocSll34JYbWgc5A3GITLNt7LAFTrR6U389NuCUf3XbZQt3Br09UX1yZ34UZSYgZVdxnDxMaa2nj/c+1RLEh0IPgFa8eIbE0KIv5/tTCXbm57fZsiInxD1I4X6jV3BqIIZVmcsYMmKWqXWPMX3MG+10BR+jKe/pATK3gYxiRxMqKKfNfI57htFFQakljPyq+eAUQPWB1UtnJMutetD/kHB1no5pgyr55Pn35iIYd5RhEnPBecYas5/77Z36uGcVpJbMTzyNhGZT4kN7mfTWkr4zYff1YOgpp+sxAUP3zwonqNN9u1Q/C26MAGAYTGtJ9kXTvn54H58ys06XHTA2gtUELiJpQvtMktPBiVZvpFA43I/vzeBs5x+FBDbCk1uf7TpFItfJgrpEreCp18eHWVofTICR4rcmqL1LYcOcS0iMG9BOqpx7d+ORKojrVVJayHOU4LIo5IGvupo1esrFQfiu9P/WuNEgrl+GWTxLpSRitv5oZE1CLMWh8QHRwxPxv07feltUsKLSIxdE+X+9oHMwNl8dHY3NgbyLAf0uBLKzBsI+QNtcaIgK4ZASpClxwtyjkPIodHYPvIxb4dg9aqXmXOrF0IKgi1OEFmAepHEDw9D/wFBzwxkcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

More bugs found by AI...

(I am not relaying all of the issues, just the interesting ones/ones in
the most interesting bits of code).

On Wed Feb 25, 2026 at 4:34 PM UTC, Brendan Jackman wrote:

> +/* Try to allocate a page by mapping/unmapping a block from the direct map. */
> +static inline struct page *
> +__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
> +		     unsigned int alloc_flags, freetype_t freetype)
> +{
> +	unsigned int ft_flags_other = freetype_flags(freetype) ^ FREETYPE_UNMAPPED;
> +	freetype_t ft_other = migrate_to_freetype(free_to_migratetype(freetype),
> +						  ft_flags_other);
> +	bool want_mapped = !(freetype_flags(freetype) & FREETYPE_UNMAPPED);
> +	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
> +	unsigned long irq_flags;
> +	int nr_pageblocks;
> +	struct page *page;
> +	int alloc_order;
> +	int err;
> +
> +	if (freetype_idx(ft_other) < 0)
> +		return NULL;
> +
> +	/*
> +	 * Might need a TLB shootdown. Even if IRQs are on this isn't
> +	 * safe if the caller holds a lock (in case the other CPUs need that
> +	 * lock to handle the shootdown IPI).
> +	 */
> +	if (alloc_flags & ALLOC_NOBLOCK)
> +		return NULL;
> +
> +	if (!can_set_direct_map())
> +		return NULL;
> +
> +	lockdep_assert(!irqs_disabled() || unlikely(early_boot_irqs_disabled));
> +
> +	/*
> +	 * Need to [un]map a whole pageblock (otherwise it might require
> +	 * allocating pagetables). First allocate it.
> +	 */
> +	alloc_order = max(request_order, pageblock_order);
> +	nr_pageblocks = 1 << (alloc_order - pageblock_order);
> +	spin_lock_irqsave(&zone->lock, irq_flags);
> +	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
> +	spin_unlock_irqrestore(&zone->lock, irq_flags);
> +	if (!page)
> +		return NULL;
> +
> +	/*
> +	 * Now that IRQs are on it's safe to do a TLB shootdown, and now that we
> +	 * released the zone lock it's possible to allocate a pagetable if
> +	 * needed to split up a huge page.
> +	 *
> +	 * Note that modifying the direct map may need to allocate pagetables.
> +	 * What about unbounded recursion? Here are the assumptions that make it
> +	 * safe:
> +	 *
> +	 * - The direct map starts out fully mapped at boot. (This is not really
> +	 *   an assumption" as its in direct control of page_alloc.c).
> +	 *
> +	 * - Once pages in the direct map are broken down, they are not
> +	 *   re-aggregated into larger pages again.
> +	 *
> +	 * - Pagetables are never allocated with __GFP_UNMAPPED.
> +	 *
> +	 * Under these assumptions, a pagetable might need to be allocated while
> +	 * _unmapping_ stuff from the direct map during a __GFP_UNMAPPED
> +	 * allocation. But, the allocation of that pagetable never requires
> +	 * allocating a further pagetable.
> +	 */
> +	err = set_direct_map_valid_noflush(page,
> +				nr_pageblocks << pageblock_order, want_mapped);
> +	if (err == -ENOMEM || WARN_ONCE(err, "err=%d\n", err)) {
> +		__free_one_page(page, page_to_pfn(page), zone,
> +				alloc_order, freetype, FPI_SKIP_REPORT_NOTIFY);

Forgot to take the zone lock.

> +		return NULL;
> +	}
> +
> +	if (!want_mapped) {
> +		unsigned long start = (unsigned long)page_address(page);
> +		unsigned long end = start + (nr_pageblocks << (pageblock_order + PAGE_SHIFT));
> +
> +		flush_tlb_kernel_range(start, end);
> +	}
> +
> +	for (int i = 0; i < nr_pageblocks; i++) {
> +		struct page *block_page = page + (pageblock_nr_pages * i);
> +
> +		set_pageblock_freetype_flags(block_page, freetype_flags(freetype));
> +	}
> +
> +	if (request_order >= alloc_order)
> +		return page;
> +
> +	/* Free any remaining pages in the block. */
> +	spin_lock_irqsave(&zone->lock, irq_flags);
> +	for (unsigned int i = request_order; i < alloc_order; i++) {
> +		struct page *page_to_free = page + (1 << i);
> +
> +		__free_one_page(page_to_free, page_to_pfn(page_to_free), zone,
> +			i, freetype, FPI_SKIP_REPORT_NOTIFY);
> +	}
> +	spin_unlock_irqrestore(&zone->lock, irq_flags);
> +
> +	return page;
> +}

