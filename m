Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 785BCC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700976B0092; Mon, 14 Sep 2026 03:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9376B0093; Mon, 14 Sep 2026 03:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616DA6B0095; Mon, 14 Sep 2026 03:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FCCD6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:48:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACC32C120E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:48:24 +0000 (UTC)
X-FDA: 85211590128.10.746D2D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1331720006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:48:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oWbdszQA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oWbdszQA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789372103;
	b=yIV1L+zLYGP3bHuwWgWzCBXFpGi2QVdKCNNDfQIaCfcQULCwr/o0WzncgaSvGGhrTAwAsa
	Hx3HwfBBy1bC1V/gzrWWIJMgR67hmmRU+GPk442ZPoAb+1pefr4phcGwMdaQWu19Q7VnbV
	qGvVtBFDdeZJHxo8Iz03DQyL5cQmPQw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789372103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/n4jJya1prgN2dgSLwbe0z8ok1AwZZQSKHus8wzgars=;
	b=3MNLksqLEOHn8AvEPXG7I0QtQoFSWu9CuBgilxqVe530C7tDN/oUwf/OwMtTa+290g8MhZ
	BJZ0GU2S0OX2bbO11CYsWgVCzfV3LIAuCYr8PMLFFbDiB16fuLkgZBsfJ8F9d4EoCbyLbk
	3WHlTaUsBP2gXuT4jJB1B7JAxLYSiA4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A469601F6;
	Mon, 14 Sep 2026 07:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EAE1F00893;
	Mon, 14 Sep 2026 07:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789372101;
	bh=/n4jJya1prgN2dgSLwbe0z8ok1AwZZQSKHus8wzgars=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=oWbdszQAd9TfvfSdxVo0ei1jr7TWFdO8PW6YUfAIgVPGAcAdqW0Cin0CapR33m0Ik
	 5ljlDtHfpvuV5Hirmw3LPZRghnK+ogBXDQ3l9/ZKG9HC153vQigjP0zE5BAfBBymWo
	 fOxTfBWesTiO4i2LmC11BYWyV/ODpDdx/BjuvfVT3h1Dj8PAxlbdUpiAlWIk6hpWfB
	 5NJbIPIExI1MB0Qlh2ITMEzokDQkftL8snyoTso0fTcKwkUydwAmddsoV6UH7HDgaH
	 HySIopvR/79X02ohoxbp2OleIUnnEqc9+VgzavjQzxdEgJSN1qG5NhqNqKI9vD/msx
	 e8m+2Quks4mJg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 01/11] mm/sparse-vmemmap: introduce
 CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260911050228.58884-2-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
 <20260911050228.58884-2-songmuchun@bytedance.com>
Date: Mon, 14 Sep 2026 10:48:14 +0300
Message-Id: <178937209455.4188640.17761540933640972197.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 1331720006
X-Stat-Signature: juyewgtamegec6wfs9gxa4hgy911qcps
X-Rspamd-Server: rspam01
X-HE-Tag: 1789372102-161649
X-HE-Meta: U2FsdGVkX19jJzCeeVQVXmk9POLPnQBQnhxIlyaQjyTdW7n3DVcs+rTZqgnA6kII5kWeG81DeOoATK5o2rUlEhSLubT4h14bziw/pCxaEprNTlVkcrYWcvInEltP8HwL8dO8KmLr8UVe44aLqT46178LId958CSg2MBPCLtqDxUq5cLBEop0+8v8O16zQCuMd+AseGhQJVh4V+cP4YOmRinEC0ZOay3rSqiQC6KaZ4xnP5+3/jwakd5dmt9b6jkvcf2OLEQ/Z5fVWTNlWGWf58lfja8vrGLobmFjfGaty92SKZQVDIctg/Qvp5hpQmXG6CYrnCIFChpzIAA2hDL/CO4egj3ZUl1rJM344sNzJKCLb/ZtM072Xjs3zZcNW7xfE4ML8av5brql+YtBAlFxc/5DSidTFLV7ZvgnQKZBDeTD0bHI5ZHdPtObK4e3WMAxbdGkr4C2Npd8IR2RxBY1L1WSZDPFtOf2iK5R/MzM7vnNxsAGo6R8HVxTVQQE3+fsiCj1jYBhS+BEjnAObThKzUW0MFe4c8CZcwJujbki2+tjMnPajrr3czm9liYfH6wqos5X9GiazD7F4/R3nG3uloorKTgeCCK+yRwYqtTir0B14Was4HfxJHf4rG7AGOr9ZSm5W6y2KG5124pPytYI/wSq9Ke47PO0HYzhn6GejiIUE0YhYDUkPTtRl6LQr8gZCxQhjUFDkKw7nsGOEGeB1hCbOpV/e6aH7uwNx1wqKZIIBkoqk2uf9Yh6geKlSLUqXaiToEbMtJN6daNbcku1WOEB0lfTss7qWxz7tHA5fRJbNYPKejt4+U6aNBHrCHrzgaSryDHBOky0x+cnV80rdacRaZPz9WoD+fxk4yh1RRYUOFT7z6w/RATFyJEJ4i4LatUI2zb6sCmekqJEJzVacUUz81klsMAEbynIN1SiK1u47I8wCWeFR/afWTCWunanpmLSJv2GHrUVM7FBP19
 HdA+3jwg
 RGfpStcxmoRG4R71b1maaFJwPZSj7FJ0Kh/99/OsLoSyeJNLoI2Q+wW/CBbHzOVA4v2o6SDvjH+MEn7zRlXXsIqTtGkgGgdaT0dZTpNzBwLHaEyLghIT326BuxnTqw1CZXN0+3jUlRGydR7bvg+gsN+77JfcwKH1cu2NLAXVuLu1gAAbJFqttzrdfkvNxgb8usSWUCV4DjpuYAPs8PF/IrGEa4TR8CYYZI3Zd8cM7SiUyKNZXS0l53YtUJ/gnRwZEvwxvXkPVy5Fc/r8RbbmF5DhXZwM0uQJEfM+fwLcJQforE1+TFST2jAwiTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> The section-based vmemmap optimization infrastructure is still guarded by
> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it also can be used by device
> DAX. Introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION as a common config

CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION is a bit mouthful :)

I think that dropping _SPARSEMEM won't hurt readability.

> for the shared infrastructure.
> 
> Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
> DEV_DAX when the architecture opts in to DAX vmemmap optimization, and
> use it to guard the generic sparse-vmemmap state and helpers.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>
> diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
> index bc3e549795c3f..5f8424eade2bd 100644
> --- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
> +++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
> @@ -11,7 +11,7 @@
>  #undef CONFIG_PGTABLE_LEVELS
>  #undef CONFIG_ILLEGAL_POINTER_VALUE
>  #undef CONFIG_SPARSEMEM_VMEMMAP
> -#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +#undef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>  #undef CONFIG_NR_CPUS
>  #undef CONFIG_PARAVIRT_XXL
>  
> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> index 602f9a0839a91..6250954b0fa7a 100644
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -8,6 +8,8 @@ if DAX
>  config DEV_DAX
>  	tristate "Device DAX: direct access mapping device"
>  	depends on TRANSPARENT_HUGEPAGE
> +	depends on ZONE_DEVICE
> +	select SPARSEMEM_VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
>  	help
>  	  Support raw access to differentiated (persistence, bandwidth,
>  	  latency...) memory via an mmap(2) capable character
> diff --git a/fs/Kconfig b/fs/Kconfig
> index d1c210c6508f0..9b32ce79cc805 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>  	def_bool HUGETLB_PAGE
>  	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
>  	depends on SPARSEMEM_VMEMMAP
> +	select SPARSEMEM_VMEMMAP_OPTIMIZATION
>  
>  config HUGETLB_PMD_PAGE_TABLE_SHARING
>  	def_bool HUGETLB_PAGE
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c49ef99b4413b..a2ebe87e76546 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5175,6 +5175,9 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
>  	unsigned long nr_pages;
>  	unsigned long nr_vmemmap_pages;
>  
> +	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
> +		return false;
> +
>  	if (!pgmap || !is_power_of_2(sizeof(struct page)))
>  		return false;
>  
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index acd94cecc0d39..97511f651ebc0 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -102,9 +102,9 @@
>   *
>   * HVO which is only active if the size of struct page is a power of 2.
>   */
> -#define MAX_FOLIO_VMEMMAP_ALIGN \
> -	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
> -	 is_power_of_2(sizeof(struct page)) ? \
> +#define MAX_FOLIO_VMEMMAP_ALIGN					\
> +	(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION) &&	\
> +	 is_power_of_2(sizeof(struct page)) ?			\
>  	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
>  
>  /* The number of retained vmemmap pages with HVO enabled. */
> @@ -116,7 +116,8 @@
>  #define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
>  	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
>  #define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
> -	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
> +	((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 &&	\
> +	  IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
>  
>  enum migratetype {
>  	MIGRATE_UNMOVABLE,
> @@ -1155,7 +1156,7 @@ struct zone {
>  	/* Zone statistics */
>  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
>  	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>  	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
>  #endif
>  } ____cacheline_internodealigned_in_smp;
> @@ -2019,7 +2020,7 @@ struct mem_section {
>  	unsigned long section_mem_map;
>  
>  	struct mem_section_usage *usage;
> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>  	/*
>  	 * Normally, sections hold regular (order-0) pages. However, for
>  	 * sections with HVO enabled, this tracks the compound page order
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 86dd0470da117..462e89e055485 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -208,14 +208,13 @@ enum pageflags {
>  static __always_inline bool compound_info_has_mask(void)
>  {
>  	/*
> -	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
> -	 * makes a difference.
> +	 * Limit mask usage to HVO where it makes a difference.
>  	 *
>  	 * The approach with mask would work in the wider set of conditions,
>  	 * but it requires validating that struct pages are naturally aligned
>  	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
>  	 */
> -	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
> +	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
>  		return false;
>  
>  	return is_power_of_2(sizeof(struct page));
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bc7befafb47b5..c180d40cd6712 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -461,6 +461,10 @@ config SPARSEMEM_VMEMMAP
>  	  pfn_to_page and page_to_pfn operations.  This is the most
>  	  efficient option when sufficient kernel resources are available.
>  
> +config SPARSEMEM_VMEMMAP_OPTIMIZATION
> +	bool
> +	depends on SPARSEMEM_VMEMMAP
> +
>  #
>  # Select this config option from the architecture Kconfig, if it is preferred
>  # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
> diff --git a/mm/sparse.h b/mm/sparse.h
> index d3a71ef4fad0f..3151d4db75753 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -10,7 +10,7 @@
>  
>  #include <linux/mmzone.h>
>  
> -#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
>  static inline unsigned int section_compound_order(const struct mem_section *section)
>  {
>  	return section->compound_page_order;
> @@ -75,7 +75,7 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
>  
>  static inline bool vmemmap_optimizable_order(unsigned int order)
>  {
> -	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
> +	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
>  		return false;
>  
>  	if (!is_power_of_2(sizeof(struct page)))

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


