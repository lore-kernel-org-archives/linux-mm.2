Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA95EA4FAA
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E9D6B0088; Mon, 23 Feb 2026 06:07:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2386B0089; Mon, 23 Feb 2026 06:07:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4796B008A; Mon, 23 Feb 2026 06:07:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 58AD46B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:07:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F37E513BD56
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:07:50 +0000 (UTC)
X-FDA: 84475446300.05.ACFE9F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6C4748000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:07:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T1Qj9fQS;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771844869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPriieVDmKWqMBFR4G9YtxqzqfHaNSD1dKKcY0qJxAU=;
	b=1zDNVZYXZBL0UO79dSt+o3m4Cx+2eiQ5CxuyfzJuV6jytKDHbeckKJ41P/YLggWkCIvnQb
	RpBazyOvcSLWSGFvd7cQ2rcQKUF6JYbm5ZuCVwsWOXPbW26IuUsYgWxupAgjFD5kSEIFR/
	/cLkmbhsKw3fPtpt4HxwrOPzKs1iry0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T1Qj9fQS;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771844869; a=rsa-sha256;
	cv=none;
	b=uFHtC3EAPI7p7gk4PzKW3wh9ygaM7t8p/CV48RxcJSkUEiSPiz3p9TjjbN+YcC1uaEpqlQ
	pETsOpzqTHuSdxHBZP7PEJvZRXMj1Vfd8OyP3YtWGDN+qFNOwLhOpONePIX/RRhZ5SkfpK
	3uKocCcyG4en3Gs6etGA5OZCiDgmmYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43FEA43BAD;
	Mon, 23 Feb 2026 11:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FDEC116C6;
	Mon, 23 Feb 2026 11:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771844868;
	bh=0YsJWHREax0w0K2fWlItFC0pBFK8dqhoeUM0EkuZNKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T1Qj9fQSaAfU7lAymctvQoNk2F6nxLXKeGFXUzGa3OO5BJumvXl9nHd5HYD3gxpb2
	 EvtVD+tb2FDM2BgQnih18J9vjvEC3dwW21vHqthFbS7cyLJ29+hjaecdg9sOfOBDz8
	 cBtfsOYn5qAH8XU5dtoSYb1p2sDlpLK9dg47n2FjY+QBqeXhRnpyTYFPNTyWHYh4Zw
	 h9aWqpagWz/lZSDmnPj1zHzIGnCMNHqnqKUZVRp71M0bxqgJAaBv3E49eW5kKco+V7
	 BtA0/aBjJh5OhW50YIDXyGGaMwX8RNJl7/CLh7pWuRwDHSWpP+PdBPRJNAnQptYgFN
	 32FwwBT/ir72A==
Date: Mon, 23 Feb 2026 13:07:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 1/2] kho: fix deferred init of kho scratch
Message-ID: <aZw0_c8TdTYvm2SV@kernel.org>
References: <20260220165203.3213375-1-mclapinski@google.com>
 <20260220165203.3213375-2-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220165203.3213375-2-mclapinski@google.com>
X-Stat-Signature: rse3oyxo7fbiqzt8tjetys637byocr4a
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C4748000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1771844869-355550
X-HE-Meta: U2FsdGVkX1/RSWvnsvLAdbq1LxgwMPBhELYjqcEf4AJQ7vt+tvwRhO6Edy9wO1wH+BPtt3KaWog4XzGIyGVvejifGXmCzCJX6e2fyzYSaNOvQVidgiYu0U1faQKIx0xBgg3Msh9wzEBgcS76hLehArakok6zZXQDK1HTq17tUwpPTW+nAKv63TxTiqGK/+aeNWOqoORn8QNujUB+IHO3wLYwEVHbYAllC35eBkrPC8e45yEkjV7L4KnWTTURA+fkvFIBzbmnXXZGdUlhCfTRC9zAoeC2AfHjUF7JI0LtU6oP/vd5v+gdCv+nM8By9f8TkDgY3ecQKEVSFiRP52aCtngHbG67Ag1BgzXU/GnffMY2Rx1mxNeAlJtCfjcHGI4Ysy3gQPEV09LtEmooHGJlT8uD3QH41fEb0c0+83hOGMHnrutB+4qgY+BGW4rHOnUrfP+KqYt+74WrpFgsk+mwU3rPw+dQ63qhYTqS96gPpqjQB56MuOE6L98/LMRrRwFP9CcTNLcfdH3662yfA+IwFqGuUwXSDmqrW8k0r5ZGe+x/rRxkliXygqbiidgqZHWoM/AN4aTqICCHgwa+VH2PhKW7l4NJjbnxMxZl86t0ilzseyK4vZeg1XfyadM2vYgayXu8mAOCpZgjZ6Cq9Dt2mc3acohwltOnrfIW/hGAqkmzfFFXAM4fEo0jK9uZ5cOOY3ZGZvUst2lRfGuDY4MQYZV+2jcGbIoF/J564fhq+lci4C1INJtPxHip72G3a4/ygSuMZgJMDrsCGA8EFyAcwhzzYgwWzuqcaRHga63DPK4FZHmJqzCuVjlUp6RLOSRUsgPKeSEtFVJ6FDbI3pjdp0DqMBHk9TEL/oKtqu1VPVHK58cUSbkf2BWFdf4xaLVp7d7txhpMieiRydds1jKo9BdJ4yemXrEFXiQcTgmFJeLa5Ufnu7LKFIy6JC+WpW3XEe3NBoHc/2lmS1ZMgJh
 A1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 05:52:02PM +0100, Michal Clapinski wrote:
> Currently, mm_core_init calls kho_memory_init, which calls
> kho_release_scratch.
> 
> If DEFERRED is enabled, kho_release_scratch will first initialize the
> struct pages of kho scratch. This is not needed. We can just let
> page_alloc_init_late init it.
> 
> Next, kho_release_scratch will mark scratch as MIGRATE_CMA. If DEFERRED
> is enabled, this will be overwritten later in deferred_free_pages.
> 
> To fix this, I removed the whole kho_release_scratch.
> Marking the pageblocks as MIGRATE_CMA now happens in kho_init, which
> runs after deferred_free_pages.
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/memblock.h           |  2 --
>  kernel/liveupdate/kexec_handover.c | 43 ++++++++----------------------
>  mm/memblock.c                      | 22 ---------------
>  3 files changed, 11 insertions(+), 56 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 221118b5a16e..35d9cf6bbf7a 100644
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
> index b851b09a8e99..de167bfa2c8d 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1377,11 +1377,6 @@ static __init int kho_init(void)
>  	if (err)
>  		goto err_free_fdt;
>  
> -	if (fdt) {
> -		kho_in_debugfs_init(&kho_in.dbg, fdt);
> -		return 0;
> -	}
> -
>  	for (int i = 0; i < kho_scratch_cnt; i++) {
>  		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
>  		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
> @@ -1397,8 +1392,17 @@ static __init int kho_init(void)
>  		 */
>  		kmemleak_ignore_phys(kho_scratch[i].addr);
>  		for (pfn = base_pfn; pfn < base_pfn + count;
> -		     pfn += pageblock_nr_pages)
> -			init_cma_reserved_pageblock(pfn_to_page(pfn));
> +		     pfn += pageblock_nr_pages) {
> +			if (fdt)
> +				init_cma_pageblock(pfn_to_page(pfn));
> +			else
> +				init_cma_reserved_pageblock(pfn_to_page(pfn));
> +		}
> +	}
> +
> +	if (fdt) {
> +		kho_in_debugfs_init(&kho_in.dbg, fdt);
> +		return 0;
>  	}
>  
>  	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
> @@ -1421,35 +1425,10 @@ static __init int kho_init(void)
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
>  	if (kho_in.mem_map_phys) {
>  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
> -		kho_release_scratch();
>  		kho_mem_deserialize(phys_to_virt(kho_in.mem_map_phys));
>  	} else {
>  		kho_reserve_scratch();
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 6cff515d82f4..3eff19124fc0 100644
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
> -- 
> 2.53.0.345.g96ddfc5eaa-goog
> 

-- 
Sincerely yours,
Mike.

