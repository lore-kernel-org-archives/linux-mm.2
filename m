Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5E9105A594
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D11F6B0099; Thu, 12 Mar 2026 08:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A88D6B00A0; Thu, 12 Mar 2026 08:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5376B00A2; Thu, 12 Mar 2026 08:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 593226B0099
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:50:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0224A1A01DA
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:50:47 +0000 (UTC)
X-FDA: 84537395376.29.B0899AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 551DB40012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:50:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZY3KJESr;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773319846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIsfMs4j+lPCS4kIfeqCQLjUfqJKP3anmoLjCcByYnQ=;
	b=Vdnb8+0MrDrr2DFcDjzQg/8lw+V3UVIZ1KRmpkOfQlzOoEoSARdn/5QEC58xL/q77MGMG7
	77CQVxzCP3C0eanMaSRgLzizWMlO3bqiXwnqRK4ri+TGD5Og8XyYV2xzNVJh9PAtrSwIG/
	byeks0ExS8lIkx3IN4i3dV4ZOSAnGpI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773319846; a=rsa-sha256;
	cv=none;
	b=yom5vnGxilacGp7qN5/kwLfCCtIG734XrcYitPjuLzZzxTbtC0uNVUUchDvfixmmIb4yGY
	vT3zjyAhDw6AaVFFliB5H+TedSB3TQHSWZhyK7aksTNYw0jlPYfUtBAgZjx52RUM299KWu
	mfyQ1w46waFBTsiwKEwdR/IcDbEoFg8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZY3KJESr;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B853260137;
	Thu, 12 Mar 2026 12:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFCAC4CEF7;
	Thu, 12 Mar 2026 12:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773319845;
	bh=MzjiPuohtEDKGClma5RuGX7Y58HlTMD2rexIjeLhUVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZY3KJESrb6TNmp8o0a6KrYC64NHrIYA4JAeYmam/HwkseNmkd8XFZAHVgDqTUIYz+
	 aFmhAqDKX/q9jikQ/fDwk2LeooeXi3bu7QKmIBVFfhWGT2KyXT/kWgXjxcEv41Lptw
	 MDOLCdOf+YEiBrxKWl1Y64zL3K2wWPQ8nBLnNPrg9sMwLSDMQK5k/9wMVY0m18uBND
	 QRopgqmgWpMNXujD03tBd5P6syvdFOemy8RJQ56eAIExnGSDPp73MAeKGao6eczUVq
	 8I/Rx6Uv+91F8V2DAYKMTdDqVpaGj+tiqYdmH56N2V1EJmqeAqCDE1gJnm1K++7OwD
	 CWtArJTQ7JWCA==
Date: Thu, 12 Mar 2026 14:50:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6 1/2] kho: fix deferred init of kho scratch
Message-ID: <abK2ntdGDpDS35J1@kernel.org>
References: <20260311125539.4123672-1-mclapinski@google.com>
 <20260311125539.4123672-2-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311125539.4123672-2-mclapinski@google.com>
X-Stat-Signature: erq1yuyismrs7sxejarswqcusf78t3pe
X-Rspam-User: 
X-Rspamd-Queue-Id: 551DB40012
X-Rspamd-Server: rspam12
X-HE-Tag: 1773319846-582674
X-HE-Meta: U2FsdGVkX1+CLj2YVB/KXXcnfIkYPvyJGnZyYWmWHQmNxFVmJhEtbL4ZAA10JSzp8dOZLGQt1arLEiSdPrboJVhRvGyh4rwVtNJu8Xed0oIhYht3OEP2agMpgRoGdG/y2qyksUxPWKXOyASB3wUnzJKwOUQ7V9jVe5wvdwHuSwxOLjYRklDCwBr/1K264mIS4H52dtPIxqBIF/N+xO7vmNDJEy78/KNhFbB1MNlxs/DVwhXfd5Mmqg6SMHOdNlPrzrOJZj9ytX6JpHDnynUG47S6alhyn5/XX2/O/4nVe6V8TBDjxa84mnQ5E/tWewIS2fIURFXi7kSHjppZ704X7lvzIMfQMpDLabj/2D792UERE2pGSem7LGCv9ErQvCKSIHctxxEdJIhGDmwJsP07+/7Ae4+MEKi3vYsZkakrSAwgwnqYAlSF6ZTfcC+2XWc1HrV5yZ//Ip9/ITa47qYdNdRceUZkVBVZS+6syvJ7a/1XYzbZWSuKMFEsHKGqbe2IlnM1+HJbC78Fw+uFSgKLVGIT3j+50vUiDJ42HGDkOPY/hfEaMR1Xz/yTjkx/2+RKF19td/3bX2X+wQ5KZxPcYfvantBORmO2xhIOLG9vjU1r3dYEnS1/tlLZIMbWruHalcZ+UKwFN+Sy26xbjcncNuz1DB0EM1LMQr0dJxJ46T2h4VGMpR7oAsT4LBy+6YUj2hk/J1pfvoQ3TwtVr4RfHOsvFRKNFYl4mcJvoP7+U2v4j9dBxYqSRZVWYt+ZSf1V9h71rK82b63GUx/PKJYYFhB1GyLA4M+xq4979XWFHVPFxHOSYGj9sMtkTfngpWcFUOGkS7Qp23rLQOO3OFYbZjolDJGr29AHci7bA9VtQkNDcvKE3byZtgVNjXFhf6gOsAw6Se9dQJSdCV1Ihv4D6cKzePZ8CTSp7RbWv426kqeDQHSQ3WQi6d0wr0n1eOK9aoQEMGSn7AWP2hA76r9
 BuPWct+k
 JVv+xa2RRGD+V3zCbRL3mHxk+7g2DDkgTeo5U46+dkxj06sMerneWWHAqJPX3EyAwLEmk/PGGtccl+w1L+UmomFYVsta7kKCy3jUG9F4lZcmXvhIgxlhDaWRS6SEqjQgbE5ao4LFMrPLOAuUY83AMVl2nERcf2G3omlqzA9U/qVpID5VKgUhZl/EXxUiRDjxv5gB2qlPbQ0SZcBamj8EaD2lQRcWAksaaTi+pju6SLK/TxGaEG45Mz33LWrgRSf3Tt3/vZXXzoKU+Q2gDubtyf0rdzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 01:55:38PM +0100, Michal Clapinski wrote:
> Currently, if DEFERRED is enabled, kho_release_scratch will initialize
> the struct pages and set migratetype of kho scratch. Unless the whole
> scratch fit below first_deferred_pfn, some of that will be overwritten
> either by deferred_init_pages or memmap_init_reserved_pages.
> 
> To fix it, I initialize kho scratch early and modify every other
> path to leave the scratch alone.
> 
> In detail:
> 1. Modify deferred_init_memmap_chunk to not initialize kho
> scratch, since we already did that. Then, modify deferred_free_pages
> to not set the migratetype. Also modify reserve_bootmem_region to skip
> initializing kho scratch.
> 
> 2. Since kho scratch is now not initialized by any other code, we have
> to initialize it ourselves also on cold boot. On cold boot memblock
> doesn't mark scratch as scratch, so we also have to modify the
> initialization function to not use memblock regions.
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> ---
> My previous idea of marking scratch as CMA late, after deferred struct
> page init was done, was bad since allocations can be made before that
> and if they land in kho scratch, they become unpreservable.
> Such was the case with iommu page tables.
> ---
>  include/linux/kexec_handover.h     |  6 +++++
>  include/linux/memblock.h           |  2 --
>  kernel/liveupdate/kexec_handover.c | 35 +++++++++++++++++++++++++++++-
>  mm/memblock.c                      | 22 -------------------
>  mm/mm_init.c                       | 17 ++++++++++-----
>  5 files changed, 52 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index ac4129d1d741..612a6da6127a 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -35,6 +35,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
>  int kho_add_subtree(const char *name, void *fdt);
>  void kho_remove_subtree(void *fdt);
>  int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
> +bool pfn_is_kho_scratch(unsigned long pfn);

I think we can rely on MEMBLOCK_KHO_SCRATCH and query ranges rather than
individual pfns.

This will also eliminate the need to special case scratch memory map
initialization on cold boot. 

>  void kho_memory_init(void);
>  
> @@ -109,6 +110,11 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline bool pfn_is_kho_scratch(unsigned long pfn)
> +{
> +	return false;
> +}
> +
>  static inline void kho_memory_init(void) { }
>  
>  static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 6ec5e9ac0699..3e217414e12d 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -614,11 +614,9 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
>  #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>  void memblock_set_kho_scratch_only(void);
>  void memblock_clear_kho_scratch_only(void);
> -void memmap_init_kho_scratch_pages(void);
>  #else
>  static inline void memblock_set_kho_scratch_only(void) { }
>  static inline void memblock_clear_kho_scratch_only(void) { }
> -static inline void memmap_init_kho_scratch_pages(void) {}
>  #endif
>  
>  #endif /* _LINUX_MEMBLOCK_H */
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 532f455c5d4f..09cb6660ade7 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1327,6 +1327,23 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
>  }
>  EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
>  
> +bool pfn_is_kho_scratch(unsigned long pfn)
> +{
> +	unsigned int i;
> +	phys_addr_t scratch_start, scratch_end, phys = __pfn_to_phys(pfn);
> +
> +	for (i = 0; i < kho_scratch_cnt; i++) {
> +		scratch_start = kho_scratch[i].addr;
> +		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
> +
> +		if (scratch_start <= phys && phys < scratch_end)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(pfn_is_kho_scratch);
> +
>  static int __init kho_mem_retrieve(const void *fdt)
>  {
>  	struct kho_radix_tree tree;
> @@ -1453,12 +1470,27 @@ static __init int kho_init(void)
>  }
>  fs_initcall(kho_init);
>  
> +static void __init kho_init_scratch_pages(void)
> +{
> +	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
> +		return;
> +
> +	for (int i = 0; i < kho_scratch_cnt; i++) {
> +		unsigned long pfn = PFN_DOWN(kho_scratch[i].addr);
> +		unsigned long end_pfn = PFN_UP(kho_scratch[i].addr + kho_scratch[i].size);
> +		int nid = early_pfn_to_nid(pfn);
> +
> +		for (; pfn < end_pfn; pfn++)
> +			init_deferred_page(pfn, nid);
> +	}
> +}
> +
>  static void __init kho_release_scratch(void)
>  {
>  	phys_addr_t start, end;
>  	u64 i;
>  
> -	memmap_init_kho_scratch_pages();
> +	kho_init_scratch_pages();

This should not be required if deferred init would check if a region is
MEMBLOCK_KHO_SCRATCH rather than pfn_is_kho_scratch().

>  	/*
>  	 * Mark scratch mem as CMA before we return it. That way we
> @@ -1487,6 +1519,7 @@ void __init kho_memory_init(void)
>  			kho_in.fdt_phys = 0;
>  	} else {
>  		kho_reserve_scratch();
> +		kho_init_scratch_pages();
>  	}
>  }
>  
> diff --git a/mm/memblock.c b/mm/memblock.c
> index b3ddfdec7a80..ae6a5af46bd7 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_only(void)
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
> -	 * reserve_bootmem_region()
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
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index cec7bb758bdd..969048f9b320 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -798,7 +798,8 @@ void __meminit reserve_bootmem_region(phys_addr_t start,
>  	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		__init_deferred_page(pfn, nid);
> +		if (!pfn_is_kho_scratch(pfn))
> +			__init_deferred_page(pfn, nid);

A bit unrelated, we can move reserve_bootmem_region() to memblock and make
it static.

As for skipping the initialization of, I think that
memmap_init_reserved_pages() should check if the region to reserve is in
scratch and if yes, make reserve_bootmem_region() to skip struct page
initialization.
I believe everything that is MEMBLOCK_RSRV_KERNEL would be in scratch and
all reserved memory in scratch would be MEMBLOCK_RSRV_KERNEL, but it's
better to double check it.

Another somewhat related thing, is that __init_page_from_nid() shouldn't
mess with pageblock migrate types, but only call __init_single_page().
It's up to __init_page_from_nid() caller to decide what migrate type to
use and the caller should set it explicitly.

>  
>  		/*
>  		 * no need for atomic set_bit because the struct
> @@ -2008,9 +2009,12 @@ static void __init deferred_free_pages(unsigned long pfn,
>  
>  	/* Free a large naturally-aligned chunk if possible */
>  	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
> -		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
> +		for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
> +			if (pfn_is_kho_scratch(page_to_pfn(page + i)))
> +				continue;
>  			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
>  					false);

We can move init_pageblock_migratetype() here and below to
deferred_init_pages() and ...

> +		}
>  		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
>  		return;
>  	}
> @@ -2019,7 +2023,7 @@ static void __init deferred_free_pages(unsigned long pfn,
>  	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
>  
>  	for (i = 0; i < nr_pages; i++, page++, pfn++) {
> -		if (pageblock_aligned(pfn))
> +		if (pageblock_aligned(pfn) && !pfn_is_kho_scratch(pfn))
>  			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
>  					false);
>  		__free_pages_core(page, 0, MEMINIT_EARLY);
> @@ -2090,9 +2094,11 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
>  			unsigned long chunk_end = min(mo_pfn, epfn);
>  
> -			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
> -			deferred_free_pages(spfn, chunk_end - spfn);
> +			// KHO scratch is MAX_ORDER_NR_PAGES aligned.
> +			if (!pfn_is_kho_scratch(spfn))
> +				deferred_init_pages(zone, spfn, chunk_end);

skip the entire MEMBLOCK_KHO_SCRATCH regions here and only call
deferred_free_pages() for them.

Since the outer loop already walks regions in memblock.memory it shouldn't
be hard to query memblock_region flags from the iterator, or just replace
the simplified iterator with __for_each_mem_range().
  
> +			deferred_free_pages(spfn, chunk_end - spfn);
>  			spfn = chunk_end;
>  
>  			if (can_resched)
> @@ -2100,6 +2106,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  			else
>  				touch_nmi_watchdog();
>  		}
> +		nr_pages += epfn - spfn;
>  	}
>  
>  	return nr_pages;
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

-- 
Sincerely yours,
Mike.

