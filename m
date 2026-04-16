Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30004F8D750
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610C46B0005; Thu, 16 Apr 2026 10:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1456B0089; Thu, 16 Apr 2026 10:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D75E6B008A; Thu, 16 Apr 2026 10:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 404C26B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:45:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D994CE4A35
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:45:54 +0000 (UTC)
X-FDA: 84664693428.19.DFE3A03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 36B9D80011
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:45:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6sKv1I7;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776350753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlURetGYwP+rF8xw+qDuJhAWb06CalZJJOmLjqFkTCE=;
	b=q6RGga5dnUE0tmd9SF/QSfS+iAAYkAPJQl3gasbM2gfdOR4LnYTJrUmnzPPWH0xgQSZSDK
	RNY1SalzflqWzwxl1ZOH+dE9Gp0lrlRQQsf83jEBRphncqgBk2uy062zyRw0emXprWBdzd
	NydelkQKnyHRP2pxG9sLPAsIFVT8PVU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6sKv1I7;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776350753; a=rsa-sha256;
	cv=none;
	b=QSJE7iw/qrYxeCvpGYQsHe1CAIWJIMXdDoz3lPqXjrUlMWkqiBSZQ2yVf6j5X3wgDpiWkY
	0/85cC/QpSrhuyaed6uucpCtTp4+wweL5bHwdTSw/X7TKbsKwQpLNXnCGoJV7vVd3dqu2l
	Gq19tYXGJwpKdEqG+qFi9nE8r50vw+E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8071360127;
	Thu, 16 Apr 2026 14:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21860C2BCAF;
	Thu, 16 Apr 2026 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776350752;
	bh=/YNr/GrZbYaNzG/uHKxQpL93wASCVsAz1H7F4jBakYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S6sKv1I7r8lh01rJ/h54T12rX/bC+nvPXbpOI43w3SiQHdDRaXBwFP+Fqmsfff1Bb
	 7yiMIrh/olX4qMTGBDjHFRvhmwmWnI8i3+aGqO75OnbIdIWOJf+1uTTKRwfLcq8C6n
	 fmDaz3GnzK2M1vV2adzfjYwvxyy2U/kFcJL8hzhmxxR28WDntbog7SToOKhyFA2K5d
	 lZ+mQn00mD2pk4EF3D0spimLElWx+8RAFzow4FCC9sN2OKWY6Npn+UKaOlnc+k1qOH
	 zXoBDYHg3lkk+3wEc9nqaxS0ZzFZ8SqEwimBsdigfE8SvIgupCHdjjiUzq7g9RkBdf
	 PCCTm9A9iM5hg==
Date: Thu, 16 Apr 2026 17:45:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v8 1/2] kho: fix deferred initialization of scratch areas
Message-ID: <aeD2Fzr6yr4pu9-X@kernel.org>
References: <20260416110654.247398-1-mclapinski@google.com>
 <20260416110654.247398-2-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416110654.247398-2-mclapinski@google.com>
X-Stat-Signature: 7s37fgywbhzynw316hx68tpeorpa9ao9
X-Rspamd-Queue-Id: 36B9D80011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776350753-561556
X-HE-Meta: U2FsdGVkX19fuNclfpFrFPAUJ8kbJSZ6vfGgWDlPuVUuimPNcnN4AT/FI4sizSF3UnzcAvziKC843tmr5ZGBxO12y/l3ov0QZjlELv5x5GgJ8PJWzAWGGPgFyFJLqxURgmi7wCTzWYO+sHiOCK/Az61Uuq+kypR3Yy69fvkQx2FNR5v211W0JNCutLYQOPFuQ9ItOr4AoiEhuoWPCKRX2s2ZLQ4fn2b5H1Jp4R5L3/6vfqJ70RxQx5t/KG+TK/J/v+GWfKyzWdSlbchr5hm+J3n5MPzYTSgqDhDjOeWRkSHxPCYoGYgEfdfN7AgCL0CQP1MPMqa4dP2t6rnWTJUzdXXzJnYFRkBNCKZrAotgjK6NLV/GjZcipBZaQl8wFhfMGIAsAkU4EWFcAgUq+3Qr0zW3r1EtMi1a09qYqje7E/XTY/eIifChzUTQ6GpCkR4kj9VVykSVU4F3QKC7kZ3JiFR6lWC+bYMktLpLDYLD4NXpys3mTYiI9Aetl4am4TP36401UL8hrmXBKaF94oNDFWKwZMFvvOI/Z/mEfwIlh5u5Y4KjKcMvIEDRqFW4abtzQoG3oiVrN/0b0Khdn9s6BUFToDOOFDWwWx+Y5BteZJFZirvJCRQbHYpvMhBelcvSHgL3/y6qMVnzVLk5sSKrvULurDg5RT9+0sVMDmJVHXr2rENgIN5Rfa3BkrfEI97cvOM6z7n+MhSqtIkxv5LsziHpomE3M15bhmuqdIi9o1f0YgwR1cB8gcwtFS63EniPr56pcxB/I5/KjXB+42Ts+deFQRCnOCQt57fN2jaVW8uLxV4rZYvct40gADSjwcr3osisLieU+Jokyl8fGo/4FK/eaH+jEoiXuuPFfwtAM2XmC9mJx2/itRgO1RoiqQpTuopSA0tZWNeIaY/LMMoTLoUAm6i2L3RqXNwh5A0x5YqdM2ZV4ue1Xi1d9rMuubcfi4ZXe/iswBcYTY2oJW1
 NHQckwhn
 B1RjuTN2djOXF5BkGIuPfn0sRbmb5vAChUVUtCk0jpYivfHGqlba+QuYkVdY6TPVjGVLrw3XUAJZMD2zMft/8ehNZ7yXlcEC3DkjjamPNeFHhEP04wJNOGykNWweqB0Ukqixwgv52t6xJhnCx1rpD6H5nihvmLwshuqE9O8+ABZWXijpJgu9LAhJ8j8TpxUWvsGhSp7j2isCpKR14FZvrAKr9KwtpqQqX63LRPxgyA+sB6jtNyv+KtoL6/Js0crczVaTwhLKPrymJEIJjFzF/zP8iUcd7buB5qqQP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Thu, Apr 16, 2026 at 01:06:53PM +0200, Michal Clapinski wrote:
> Currently, if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled,
> kho_release_scratch() will initialize the struct pages and set migratetype
> of KHO scratch. Unless the whole scratch fits below first_deferred_pfn,
> some of that will be overwritten either by deferred_init_pages() or
> memmap_init_reserved_range().
> 
> To fix it, make memmap_init_range(), deferred_init_memmap_chunk() and
> memmap_init_reserved_range() recognize KHO scratch regions and set
> migratetype of pageblocks in those regions to MIGRATE_CMA.
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Your signed-off should be last here :)
https://docs.kernel.org/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

> ---
>  include/linux/memblock.h           |  7 +++--
>  kernel/liveupdate/kexec_handover.c | 25 ------------------
>  mm/memblock.c                      | 41 ++++++++++++++----------------
>  mm/mm_init.c                       | 27 ++++++++++++++------
>  4 files changed, 43 insertions(+), 57 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 6ec5e9ac0699..410f2a399691 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -614,11 +614,14 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
>  #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>  void memblock_set_kho_scratch_only(void);
>  void memblock_clear_kho_scratch_only(void);
> -void memmap_init_kho_scratch_pages(void);
> +bool memblock_is_kho_scratch_memory(phys_addr_t addr);
>  #else
>  static inline void memblock_set_kho_scratch_only(void) { }
>  static inline void memblock_clear_kho_scratch_only(void) { }
> -static inline void memmap_init_kho_scratch_pages(void) {}
> +static inline bool memblock_is_kho_scratch_memory(phys_addr_t addr)
> +{
> +	return false;
> +}
>  #endif
>  
>  #endif /* _LINUX_MEMBLOCK_H */
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 18509d8082ea..a507366a2cf9 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1576,35 +1576,10 @@ static __init int kho_init(void)
>  }
>  fs_initcall(kho_init);
>  
> -static void __init kho_release_scratch(void)
> -{
> -	phys_addr_t start, end;
> -	u64 i;
> -
> -	memmap_init_kho_scratch_pages();
> -
> -	/*
> -	 * Mark scratch mem as CMA before we return it. That way we
> -	 * ensure that no kernel allocations happen on it. That means
> -	 * we can reuse it as scratch memory again later.
> -	 */
> -	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> -			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
> -		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
> -		ulong end_pfn = pageblock_align(PFN_UP(end));
> -		ulong pfn;
> -
> -		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
> -			init_pageblock_migratetype(pfn_to_page(pfn),
> -						   MIGRATE_CMA, false);
> -	}
> -}
> -
>  void __init kho_memory_init(void)
>  {
>  	if (kho_in.scratch_phys) {
>  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
> -		kho_release_scratch();
>  
>  		if (kho_mem_retrieve(kho_get_fdt()))
>  			kho_in.fdt_phys = 0;
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 4224fdaa8918..fab234f732c3 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -17,6 +17,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/memblock.h>
>  #include <linux/mutex.h>
> +#include <linux/page-isolation.h>
>  
>  #ifdef CONFIG_KEXEC_HANDOVER
>  #include <linux/libfdt.h>
> @@ -959,28 +960,6 @@ __init void memblock_clear_kho_scratch_only(void)
>  {
>  	kho_scratch_only = false;
>  }
> -
> -__init void memmap_init_kho_scratch_pages(void)
> -{
> -	phys_addr_t start, end;
> -	unsigned long pfn;
> -	int nid;
> -	u64 i;
> -
> -	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
> -		return;
> -
> -	/*
> -	 * Initialize struct pages for free scratch memory.
> -	 * The struct pages for reserved scratch memory will be set up in
> -	 * memmap_init_reserved_pages()
> -	 */
> -	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> -			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
> -		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
> -			init_deferred_page(pfn, nid);
> -	}
> -}
>  #endif
>  
>  /**
> @@ -1971,6 +1950,18 @@ bool __init_memblock memblock_is_map_memory(phys_addr_t addr)
>  	return !memblock_is_nomap(&memblock.memory.regions[i]);
>  }
>  
> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> +bool __init_memblock memblock_is_kho_scratch_memory(phys_addr_t addr)

We already have a block under #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH, please
add this function to that block.

> +{
> +	int i = memblock_search(&memblock.memory, addr);
> +
> +	if (i == -1)
> +		return false;
> +
> +	return memblock_is_kho_scratch(&memblock.memory.regions[i]);
> +}
> +#endif
> +
>  int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
>  			 unsigned long *start_pfn, unsigned long *end_pfn)
>  {
> @@ -2262,6 +2253,12 @@ static void __init memmap_init_reserved_range(phys_addr_t start,
>  		 * access it yet.
>  		 */
>  		__SetPageReserved(page);
> +
> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH

No need for #ifdef here, there's a stub returning false for
CONFIG_MEMBLOCK_KHO_SCRATCH=n case.

> +		if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
> +		    pageblock_aligned(pfn))
> +			init_pageblock_migratetype(page, MIGRATE_CMA, false);
> +#endif
>  	}
>  }
>  
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..890c3ae21ba0 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -916,8 +916,15 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>  		 * over the place during system boot.
>  		 */
>  		if (pageblock_aligned(pfn)) {
> -			init_pageblock_migratetype(page, migratetype,
> -					isolate_pageblock);
> +			int mt = migratetype;
> +
> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH

Ditto.

> +			if (memblock_is_kho_scratch_memory(page_to_phys(page)))
> +				mt = MIGRATE_CMA;
> +#endif

memmap_init_zone_range() is called each time for a region in
memblock.memory. This means either entire range will be KHO_SCRATHC or not
and we can check for memblock_is_kho_scratch_memory() once for every region
in memmap_init_zone_range().

> +
> +			init_pageblock_migratetype(page, mt,
> +						   isolate_pageblock);
>  			cond_resched();
>  		}
>  		pfn++;
> @@ -1970,7 +1977,7 @@ unsigned long __init node_map_pfn_alignment(void)
>  
>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>  static void __init deferred_free_pages(unsigned long pfn,
> -		unsigned long nr_pages)
> +		unsigned long nr_pages, enum migratetype mt)
>  {
>  	struct page *page;
>  	unsigned long i;
> @@ -1983,8 +1990,7 @@ static void __init deferred_free_pages(unsigned long pfn,
>  	/* Free a large naturally-aligned chunk if possible */
>  	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
>  		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
> -			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
> -					false);
> +			init_pageblock_migratetype(page + i, mt, false);
>  		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
>  		return;
>  	}
> @@ -1994,8 +2000,7 @@ static void __init deferred_free_pages(unsigned long pfn,
>  
>  	for (i = 0; i < nr_pages; i++, page++, pfn++) {
>  		if (pageblock_aligned(pfn))
> -			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
> -					false);
> +			init_pageblock_migratetype(page, mt, false);
>  		__free_pages_core(page, 0, MEMINIT_EARLY);
>  	}
>  }
> @@ -2051,6 +2056,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  	u64 i = 0;
>  
>  	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
> +		enum migratetype mt = MIGRATE_MOVABLE;
>  		unsigned long spfn = PFN_UP(start);
>  		unsigned long epfn = PFN_DOWN(end);
>  
> @@ -2060,12 +2066,17 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  		spfn = max(spfn, start_pfn);
>  		epfn = min(epfn, end_pfn);
>  
> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH

No need for #ifdef here as well.

> +		if (memblock_is_kho_scratch_memory(PFN_PHYS(spfn)))
> +			mt = MIGRATE_CMA;
> +#endif
> +
>  		while (spfn < epfn) {
>  			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
>  			unsigned long chunk_end = min(mo_pfn, epfn);
>  
>  			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
> -			deferred_free_pages(spfn, chunk_end - spfn);
> +			deferred_free_pages(spfn, chunk_end - spfn, mt);
>  
>  			spfn = chunk_end;
>  
> -- 
> 2.54.0.rc1.555.g9c883467ad-goog
> 

-- 
Sincerely yours,
Mike.

