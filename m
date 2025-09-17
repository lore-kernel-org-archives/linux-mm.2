Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36769CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DFCB8E0028; Wed, 17 Sep 2025 10:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889BC8E0003; Wed, 17 Sep 2025 10:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779038E0028; Wed, 17 Sep 2025 10:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 618848E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:20:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10E5B1A058C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:20:13 +0000 (UTC)
X-FDA: 83898951906.05.CEEE598
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7572A40011
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:20:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ju8TW1WS;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758118811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drLEf2q8/O80+2XBQUBylxJhwjKLYp3hBHu2eslb7MQ=;
	b=eXQ11IPJYSkLdBhrMTKtz9UqH36KcEjkx5Leb8lW4czBjix35bGj3OD7kbnQHjGkoi8xzM
	MzP2FuuHMc1rb+MudvtPotrpSPFvr1FFkoD8vgkaPR7GSbKBBGHIPPY6yVG9mmZqkqXWtd
	w4FOU4Awdci2kwBCynwbvS2Rh/Ec6Ek=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ju8TW1WS;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758118811; a=rsa-sha256;
	cv=none;
	b=gCNHnuq6Q3gqORLkbOcQ5LNyJqFPjiItPGHMEP9hPiThX5j73VDreB96K5Q5PYNyfJ0rlo
	ujVoj3ey5EhixamOcjT72IvFsKckJsv7Z3MKNlxFv0DTsTMY2WocBjj/7VuS8iF9QntMvu
	4vuiYEjFO89i+jEz9C36u4IEWajAF10=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9986B60233;
	Wed, 17 Sep 2025 14:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2755DC4CEE7;
	Wed, 17 Sep 2025 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758118810;
	bh=1fjNIj619Fl+lLd9OP9BUcAClw93Z2hY3H7Nlzzv4Xc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ju8TW1WScXt7+y9B+mBjAUjPB6rGDTaKFMxURMULY0VyrjYthHysu2s88SjtAJQpG
	 mzP4tBVg1zaZTFh3yqoccghCFL1QjSbWjaZW1CqldgddDSlBbXb/wMHtWCZpKSSwRc
	 2X4S0ARuzdLtzIs1qqD7yN6tNmCSlr0WGuJgPHrAvYLhbrowIQMhFv8rTsEgQX/OiR
	 aJfA6WGjh5POC9hS56bLHgvApJENr5TlMIYpqBE6VkavRK1t2V1THv+eYVAFXXZGbr
	 cneR41EUGbtu7cVpMgoh4iQL76Hf0VIQhO4XX1hV1Ol/GApYf7QyTHTD91FKkg4q03
	 uc22WkIx6j9sw==
Date: Wed, 17 Sep 2025 17:20:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	elver@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
	Aleksandr Nogikh <nogikh@google.com>
Subject: Re: [PATCH v1] mm/memblock: Correct totalram_pages accounting with
 KMSAN
Message-ID: <aMrDk9ypD20H6zpx@kernel.org>
References: <20250917123250.3597556-1-glider@google.com>
 <aba22290-3577-44fa-97b3-71abd3429de7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aba22290-3577-44fa-97b3-71abd3429de7@redhat.com>
X-Rspamd-Queue-Id: 7572A40011
X-Stat-Signature: kxouxi5fr9wno6pdwfqkr35a33cqu7un
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758118811-381966
X-HE-Meta: U2FsdGVkX1+UCpDJIJHKhhZ/Eu85t1oOmG2d1UIzv6oHIKVPSMn+IebQjZJCeDaC2hz1LV2NU+dU/2i7lCMvWfhIYtrOPKo9iZTfbOMyhmkjYFqeHKyW+MWot4h9He4h3YisyRxJ0SbWsFmm88P7rFuZMRd1sFlsKjCr8ui1+irqlMluQHnDg+lElMCBsZwSff4CS5PtJFBtgjP45TXhZ4IS997HgBH+w7u0ngeit/sXzrQ10m+GP7hlpqMcIbUpZWrjJOt5+SWZHNszp2yQfxvyUiBmV4hIWW/W+HNLdZBcFkbjFQsP3daR2nPFpNWPO3maabKAtaHeItoLPEewIHhtuUKP7GT2Sn12SuN5UEcX5KuhjBCNv7UsVH9oc0myGm1mR6VA+0ftWjbI1tk08t/mQIO/sEOIiB2Izu16UQW4QhHqGJBDb1U9wVzuxYOy7S1+JoW61OLNW2eC72pTeCI7C3k8B4/mjno+vQ8iqmlWpjGUQiOH1yp6bonf0rSlv5ou7i9fzmdhAi6bOn6EI7iNIl4sdG1hHtO8Crz2CqRd9izfU/HqPWHAZyPQ26eqJxORi8hf1+Zl1fC0A3DIvEN9WGSJZ/BjgJ79wQ5Tx3NKLUpLS4V/6tOZgLe5GWbOugLID31pOQ9JYCaz1LcjnoZEzp7aDZoDR5ljfPTrtSkp0OR9fw9HAjbmTudQQwfIr0fomHYPqIB0UV10QFIABRkS3fwIS6pG8ckAGDyb4JjuuqTvydlIeQLBaZJtoWWK4DyxjzBY002t2028gahD25Phd4WeMgjBJxl2PmkJaZyuIVZRscEKj8ikibtfWELpQZAQOYpYv8ey09yIUl/eqA9moTGVFMcf0sqnXdmguyQ40Thpqnwy/QdnP2ookxMNVznK+pcRc/8UxhDdoXEdFm2Epr0dzSEgvHfINUs2iTT9ZK3G7FNedKP1LYdnPaH87mQmZpnYcIh5H8qehr6
 wwDE6NFP
 Qlp4XEiSglzYGoiDsJC3q9bhLsqY5WdKoDagNm6ypZPjuykUOj8FUXHp2AWWJfTe4Y4Ivcf/+Uq/mX/Z0wbczHPUBDsYbYXAuf1n0T7K653PPh9OyTKrNeYmD2ED51VhT0V2UJQK+LSif8v9yEEoX8LdMhI+7W9XRyhnj5c2Vt9jzxwXuiKGP3Gw6njyH3Tj2AIO1MFiVIhMsUYLT2DpAekFS5A+IOdg8NyPn05iI2f4jvwD2Ce3TL1TYv3plL5PA1hLYbRFYqFeozfROdJq2E73OaCioP2wJ0/W6IpPw6UdkAGQztOkAPN5/LyOTExYKFeKoAopo1VGQX+RM36YFfj3xxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 03:29:51PM +0200, David Hildenbrand wrote:
> On 17.09.25 14:32, Alexander Potapenko wrote:
> > When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
> > for metadata instead of returning them to the early allocator. The callers,
> > however, would unconditionally increment `totalram_pages`, assuming the
> > pages were always freed. This resulted in an incorrect calculation of the
> > total available RAM, causing the kernel to believe it had more memory than
> > it actually did.
> > 
> > This patch refactors `memblock_free_pages()` to return the number of pages
> > it successfully frees. If KMSAN stashes the pages, the function now
> > returns 0; otherwise, it returns the number of pages in the block.
> > 
> > The callers in `memblock.c` have been updated to use this return value,
> > ensuring that `totalram_pages` is incremented only by the number of pages
> > actually returned to the allocator. This corrects the total RAM accounting
> > when KMSAN is active.
> > 
> > Cc: Aleksandr Nogikh <nogikh@google.com>
> > Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> > ---
> >   mm/internal.h |  4 ++--
> >   mm/memblock.c | 18 +++++++++---------
> >   mm/mm_init.c  |  9 +++++----
> >   3 files changed, 16 insertions(+), 15 deletions(-)
> > 
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 45b725c3dc030..ae1ee6e02eff9 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -742,8 +742,8 @@ static inline void clear_zone_contiguous(struct zone *zone)
> >   extern int __isolate_free_page(struct page *page, unsigned int order);
> >   extern void __putback_isolated_page(struct page *page, unsigned int order,
> >   				    int mt);
> > -extern void memblock_free_pages(struct page *page, unsigned long pfn,
> > -					unsigned int order);
> > +extern unsigned long memblock_free_pages(struct page *page, unsigned long pfn,
> > +					 unsigned int order);
> >   extern void __free_pages_core(struct page *page, unsigned int order,
> >   		enum meminit_context context);
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 117d963e677c9..de7ff644d8f4f 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -1834,10 +1834,9 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
> >   	cursor = PFN_UP(base);
> >   	end = PFN_DOWN(base + size);
> > -	for (; cursor < end; cursor++) {
> > -		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
> > -		totalram_pages_inc();
> > -	}
> > +	for (; cursor < end; cursor++)
> > +		totalram_pages_add(
> > +			memblock_free_pages(pfn_to_page(cursor), cursor, 0));
> >   }
> 
> That part is clear. But for readability we should probably just do
> 
> if (memblock_free_pages(pfn_to_page(cursor), cursor, 0))
> 	totalram_pages_inc();
> 
> Or use a temp variable as an alternative.

I prefer this one and totalram_pages_add() after the loop 
 
> LGTM
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.

