Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BEC010854DB
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81CA56B0151; Wed, 18 Mar 2026 05:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4FE6B0153; Wed, 18 Mar 2026 05:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731D26B0154; Wed, 18 Mar 2026 05:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 61DF66B0151
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:33:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02960C2238
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:33:13 +0000 (UTC)
X-FDA: 84558670308.03.2F29E2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3FCB9C0006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:33:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N36oty7D;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773826392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ka9ekrAm+PRtEIBddzjSTlGztFbLJbLcrB/yL7pqAII=;
	b=cETMWAPML7Z3l3j/EW3Al7vzPIxLF9dKIQeid89bDnaJM+np2TwNuAucaKl62Ip7cu8MBr
	KPDsDEa0BJO/1nk1GBBdu6fB956iXjHbrO7rlAhrwzpK6+HK3EikLI8AKhwhBWt5ZDKJBo
	iGKKdYWhl+RTtqXk1alVj4iTH0DGRho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773826392; a=rsa-sha256;
	cv=none;
	b=XrXZf8CHD5qPE7LaK1w4aMXh3D49AbkOLbwbj0f/8LSmyFq10rtyqHZ/dd+aRGlllTUqB9
	18pRQOJthT/CzltAwrrfVrY3H13i1CFNPjoOatLvtM8F8hiRa1+QT9UjChtyuuRiiZVNxV
	vExs7Fn966B/Cz+TCK22ZI0jsvB8dsU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N36oty7D;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C628431CD;
	Wed, 18 Mar 2026 09:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9091C19421;
	Wed, 18 Mar 2026 09:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773826391;
	bh=uEHOHnogW56+g2NCkawlI23RrTbijq7RbohziykD1t4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N36oty7D6IXjGFsZKN4yobNwiu0L0Ch9p0graCXyTqc4EJXSZSe8IbzaBoOHfCzpJ
	 sE/i0ORGRTpFLanJH4LyEMsIhSGXpsOD1dR5Lu3vJHyjiDXxDXX2t8L2hzHtAqdbjn
	 KXxWVtpg7F6L70xB27ys4lh6EwtEZIWhueY4gEkaR/WV+REmobZHZyVfCck5YHMx12
	 Bzc1lWlRay5jpkfJyIH8DA66pip9nhUPRJSZinp3ov8EG78kaU59S5ZLS/9vWGgxoL
	 Q3YL6QsXyKGBvh1C0nr7gjgdpAhKBmDc3jfBTMpVo/5Fj6oECzoN4iYa1FvAJw+y7F
	 vt4lFIRnrdzCQ==
Date: Wed, 18 Mar 2026 11:33:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Message-ID: <abpxUEijdHJzziEV@kernel.org>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317141534.815634-3-mclapinski@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FCB9C0006
X-Stat-Signature: wfsokd5p9a8h868yxr6hjspody9du5w4
X-HE-Tag: 1773826392-399637
X-HE-Meta: U2FsdGVkX18VF3scGRmE2syzQ2tXjaUtGhOS3yBSZHQaoKrGKeXKfmboHzKZHCWCjWTr1Z2dAY273ZysCQFKAd9kGROmjNqr4znk6Z5M28TXQcA5dhQXx0IGjQJNynn9SnUFsor2eLlkp66lWX+drP/sU3zlMJ/aUL2WjU2kScdrwpWfpfgD8W+kjVQdK9WAbx7NueSNbDR0EDpDRhrFWvbtGHot153wpYhXpHKWsyDesZekoVpHbtsfU2naWz/S66cOclshsCJAfLxOYZH6jtsLcdJaIhiU/fW6Y7Qp4NdHLNwj5W4Z9nYj+0wYasiIftlXuhfOeLdmgkcWgFWL53JGbmwzY9TcOgIaDZ4ZBJUzFEGWuAn2S4BTZILJWEC2pwPAoPktN+uc1Hi/z4yK2WUbREbkNDmUSUOBaCGgH6SDo3yJzZyziEHU3A5ekdcnuv58HVQrw0DVPEArVazHPsLEympRs8Nlod37To+sf+G4a5Sm130KOj1od4uKLkc3woUu+QohYcuu4lileAVkEWb8tkbEzZaPNRSEwXdmcKl7sbNHxA0dVJoLxoUNOH12e95LvwDz56g0SZ3yTujL3kDyka13OcX4fBb18T2ru63aCe2wZR0966F1gJnRhSKkvIp5YxxsepMjhwH6Zbg63qjln2NUGa+2qeqVjozAj8lYDp++axzDzbHWOLbB9HUOdTaLKOj4NtFlZnHPBkpkxhKehha/HDA2WBkndFA8vHoHXHUqja6TRbXTPLxnPcQYcWeNMspMnZeDrHw7Uz+c7AzsfhqFxIE0UhXWfgjgdd2+pWJ+WMaxFCPpB3poT+VuCkemBPs3LxKCjpUBLIzqg0vKJ/3Nd0Ho9FhypNxQrqUr82VPqGdMvLFPxXuwgMxWfTtR4bMyIQ6TKlCzlKhvvSs6ERbhcw+dTl6bawXONfj1REHiqgdCXzmT2RauykBcW85aqSZrH8X7VUJMCvu
 RA4f3ys7
 iPI5qK1/6pv/NEI7GCK7E0KTTUexWjASo0rsPcGJf2jb8tq/Dqq43w5VhG165Awi/HHFIkacPHs1bjRO4I3U4bGeLPIVXQ+8iirHaYCMikMYz5ULcHXPbcgtYWAonIfN6D1UcFUyHMhGGg9bPOAZlrF0Jr0mSZPaNIZHmsFHiGgZTuNNln2eufGlJuTMzcnbOrFdPYe/9egmgBBg3QuBUglqiv1dV9XXeeSfSsEZaDfXN85HEso5mTsPJu942fNc+mfP+RjTZIDenLwG/PrL+5D5C2c9CzqZtDwp2lGlpAI0ymw0/lC/eGYieDNfpipnaPbHXS9mma3PjQHsLLI60nj/UlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Tue, Mar 17, 2026 at 03:15:33PM +0100, Michal Clapinski wrote:
> Currently, if DEFERRED is enabled, kho_release_scratch will initialize

Please spell out CONFIG_DEFERRED_STRUCT_PAGE_INIT

> the struct pages and set migratetype of kho scratch. Unless the whole
> scratch fit below first_deferred_pfn, some of that will be overwritten
> either by deferred_init_pages or memmap_init_reserved_pages.

Usually we put brackets after function names to make them more visible.
 
> To fix it, I modified kho_release_scratch to only set the migratetype

Prefer an imperative mood please, e.g. "To fix it, modify
kho_release_scratch() ..."

> on already initialized pages. Then, modified init_pageblock_migratetype
> to set the migratetype to CMA if the page is located inside scratch.
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> ---
>  include/linux/memblock.h           |  2 --
>  kernel/liveupdate/kexec_handover.c | 10 ++++++----
>  mm/memblock.c                      | 22 ----------------------
>  mm/page_alloc.c                    |  7 +++++++
>  4 files changed, 13 insertions(+), 28 deletions(-)
> 
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
> index c9b982372d6e..e511a50fab9c 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1477,8 +1477,7 @@ static void __init kho_release_scratch(void)
>  {
>  	phys_addr_t start, end;
>  	u64 i;
> -
> -	memmap_init_kho_scratch_pages();
> +	int nid;
>  
>  	/*
>  	 * Mark scratch mem as CMA before we return it. That way we
> @@ -1486,10 +1485,13 @@ static void __init kho_release_scratch(void)
>  	 * we can reuse it as scratch memory again later.
>  	 */
>  	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> -			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
> +			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
>  		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
>  		ulong end_pfn = pageblock_align(PFN_UP(end));
>  		ulong pfn;
> +#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
> +		end_pfn = min(end_pfn, NODE_DATA(nid)->first_deferred_pfn);
> +#endif

A helper that returns first_deferred_pfn or ULONG_MAX might be beeter
looking. 

>  
>  		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
>  			init_pageblock_migratetype(pfn_to_page(pfn),
> @@ -1500,8 +1502,8 @@ static void __init kho_release_scratch(void)
>  void __init kho_memory_init(void)
>  {
>  	if (kho_in.scratch_phys) {
> -		kho_scratch = phys_to_virt(kho_in.scratch_phys);
>  		kho_release_scratch();
> +		kho_scratch = phys_to_virt(kho_in.scratch_phys);

Why this change is needed?

>  
>  		if (kho_mem_retrieve(kho_get_fdt()))
>  			kho_in.fdt_phys = 0;
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
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee81f5c67c18..5ca078dde61d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -55,6 +55,7 @@
>  #include <linux/cacheinfo.h>
>  #include <linux/pgalloc_tag.h>
>  #include <linux/mmzone_lock.h>
> +#include <linux/kexec_handover.h>
>  #include <asm/div64.h>
>  #include "internal.h"
>  #include "shuffle.h"
> @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct page *page,
>  		     migratetype < MIGRATE_PCPTYPES))
>  		migratetype = MIGRATE_UNMOVABLE;
>  
> +	/*
> +	 * Mark KHO scratch as CMA so no unmovable allocations are made there.
> +	 */
> +	if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
> +		migratetype = MIGRATE_CMA;
> +

Please pick SJ's fixup for the next respin :)

>  	flags = migratetype;
>  
>  #ifdef CONFIG_MEMORY_ISOLATION
> -- 
> 2.53.0.851.ga537e3e6e9-goog
> 

-- 
Sincerely yours,
Mike.

