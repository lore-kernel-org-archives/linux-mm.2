Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1018C982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 01:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5236B008A; Wed, 16 Sep 2026 21:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86F36B008C; Wed, 16 Sep 2026 21:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CCF6B0092; Wed, 16 Sep 2026 21:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80CC76B008A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:35:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCFAF160174
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:35:48 +0000 (UTC)
X-FDA: 85221537576.28.64DCAB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2D61240009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:35:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AaNPuBUa;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789608947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xY8MXqZQKMcl2CIWuQH5x81TYqIBertgZUarW5BI/rY=;
	b=lREKCKppREyuLPlGfWSpMGKue4qqUw8nlj5/O34/UrZu60r2J29CrKwJA7P22ZKSBSHYvT
	nvQBh8fiQJlueDpj0ekxsoT9T7Pcb8r1IKQEINAbmDsLzdLAlVHx78I1hoAGuoijkggGIu
	y/fE8w2c+EGFxqJA21o++10C9rsEPmQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789608947;
	b=UhG5de48T2CHII24Ed4DL2s0b03KP2p70nFvRd60cZv20p9fPS1lIR7a7ETBglpULHFmdV
	UdqTZTfbFhrlLQwghemi7sg5ZAuTp4bi3WrYqIo0n2dlbNNrd0BdJ9kPoQQ4d5rrSuaFF6
	sCNcezJ5HqKZmawGybVW8wg8p/0ZCiE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AaNPuBUa;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2865601EF;
	Thu, 17 Sep 2026 01:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65DF1F000FF;
	Thu, 17 Sep 2026 01:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789608946;
	bh=xY8MXqZQKMcl2CIWuQH5x81TYqIBertgZUarW5BI/rY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AaNPuBUaXfkXKF6L293sg4La152kF9SYon65H25RqbxF4jVF2jFvXi18CcDRwfWhi
	 wv0130+KWysnx0l4YB6VKqwgbMFpsc9UA2OKhPkVYGqxsg8wD8LqHtZgIAVP1Owloc
	 hfY0DHS4zqgTZSomdebsvxMCn5S9l0oD0ciFxm0Y=
Date: Wed, 16 Sep 2026 18:35:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, Muchun Song
 <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Randy Dunlap
 <rdunlap@infradead.org>
Subject: Re: [PATCH v4 00/11] mm: Switch device DAX to section-based vmemmap
 optimization
Message-Id: <20260916183545.b8244db6aa2caf783b1fa5e9@linux-foundation.org>
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4igr7a7joozwpcbusgiy8txwe6hjaj9x
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D61240009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789608947-203172
X-HE-Meta: U2FsdGVkX18r03jDgi/S4tAf059aNc7NUVZ9MuD6G+MDxADO+nQ+bhsUyvzhDaTQE/7GmtXeFXVSba5eJP/7uSoALfW1Lo625/2fPV8XsXdxt0XCNNxq2ELa5fXz0riwjeQoQyRar7rVlweB6bbY9LFpjVuh5TviX24NmJdD7D4ZzNAOxuK/mubfWSWUcQbnC2jCPILf0gkNBPzC2msug6uGSDC21wZS6pbQmuG3EbwlFgztf4ZWRmmdjcEV3RKA9qMa4B+HyZM+KON+2xGy2PKyUpGF6tUgwyTxH/l6TbCCaQ0trmOSkhcVqJbE4vwRcy7Cda7+/jDu5575voEbHTUBfNPtipsxmRSYVvUoneKy7qf3wh+KqECTlqRrJJrAuGD53cMjCsaVIHyXmVWUOhOIdA5kJg7uaZ7gUm8c55yA4TfFSd1fNShKB52/BB9qDvxwTznJ01BJdgwb80DiteVj3h8U2ZbvtKXFmbj+r2NoIAfJAZB/ug1twQGdL98ObuPgaBavRnV2/NewF4eCwXZnEKptx/XJVXJwTjAXGb5xLqd801KXcb7KzaFRBODL2BiXQgbnUy1ZlkX0mVnerS5iDuCOT1kaJIUnU2N7SUt/LBx83xL4gW5IpGZlegge6WnV8QiIPTgUZecvIDSo5XTUYdYQb5FEopB62xen8b9Ux7eyQpqys+/3n/afLLlXgmdiQFLnoRVMOyS9mOVdz1ySxH1QOHGVRz0Eq5nQbvc06oi/dEbQqgCUvzfoC8C7UkR/oOe1D9K7v7cIvXkPpPz1rIQepJnkAAawpNVXnFUb1Hy6khSg8jt5wv+iE3t3CddmAtWSlSnWLbBRqObMgSA1DPhAHiE3+cs4zoZbpisAKvCYouRY4XSMDsWMTSDDmJJ+YS5c0uw4F+YLa8G5OMgmLHtJsgY+h6s6Rp7i2E7+OooEgDlxWrNon0RH/HIFKdR4OeM6efg/Q25HlnO
 snrOPQw6
 I7uJlV78EPbCZWvZRU5vVRmU05+LPNi1OVH1q1+Qy8BayEwrMkxSF8Xn7QSSa7rh7mWdPHa3E+PADxsr2sotoTbnj3EemABZ5wfCMdlC9UxrvO94dqYGVVBNng0YpgNFPKw3D6Bn7m6JDNJTR5eYxiQwaWEKdTfAZoTGRFoS3pArZVYyfza/SHPAMXNLT/D+2wB8VxzXvjHMXl0ADxMa/A6x/DtiEIp1pWczsywcEOKBMITKVJbMwnZZgMorlejQhCs8lWA1CXJ/tYMzCUan5v5oNGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 14:43:30 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> This series is split out from the earlier, larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset addresses
> a single, self-contained step: switching device DAX to the section-based
> sparse-vmemmap optimization infrastructure introduced for HugeTLB.
> 
> After the HugeTLB conversion, optimized vmemmap state is described by
> the memory section and the sparse-vmemmap population path can allocate or
> reuse shared tail vmemmap pages based on that metadata. Device DAX still
> uses the older DAX-specific population model, including a separate tail
> vmemmap page reservation and architecture-specific logic to locate or
> populate reusable tail pages.
> 
> ...
>
> This is intended to be the third smaller step toward the broader HVO
> generalization. The wider HVO consolidation between HugeTLB and device
> DAX is left for follow-up series.

Thanks, I updated mm-unstable to this version.

> v4:
> - Rename CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION to
>   CONFIG_VMEMMAP_OPTIMIZATION (suggested by Mike Rapoport)
> - Collect Acked-by tags from Mike Rapoport
> 

Here's how v4 altered mm.git:

 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |    2 +-
 drivers/dax/Kconfig                           |    2 --
 fs/Kconfig                                    |    2 +-
 include/linux/mm.h                            |    2 +-
 include/linux/mmzone.h                        |    6 +++---
 include/linux/page-flags.h                    |    2 +-
 include/linux/vmemmap-optimization.h          |    6 +++---
 mm/Kconfig                                    |    3 ++-
 8 files changed, 12 insertions(+), 13 deletions(-)

--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h~b
+++ a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,7 +11,7 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
-#undef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+#undef CONFIG_VMEMMAP_OPTIMIZATION
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
--- a/drivers/dax/Kconfig~b
+++ a/drivers/dax/Kconfig
@@ -8,8 +8,6 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
-	depends on ZONE_DEVICE
-	select SPARSEMEM_VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
--- a/fs/Kconfig~b
+++ a/fs/Kconfig
@@ -278,7 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
-	select SPARSEMEM_VMEMMAP_OPTIMIZATION
+	select VMEMMAP_OPTIMIZATION
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
--- a/include/linux/mm.h~b
+++ a/include/linux/mm.h
@@ -5174,7 +5174,7 @@ static inline bool __vmemmap_can_optimiz
 	unsigned long nr_pages;
 	unsigned long nr_vmemmap_pages;
 
-	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	if (!pgmap || !is_power_of_2(sizeof(struct page)))
--- a/include/linux/mmzone.h~b
+++ a/include/linux/mmzone.h
@@ -103,7 +103,7 @@
  * HVO which is only active if the size of struct page is a power of 2.
  */
 #define MAX_FOLIO_VMEMMAP_ALIGN					\
-	(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION) &&	\
+	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
 	 is_power_of_2(sizeof(struct page)) ?			\
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
@@ -117,7 +117,7 @@
 	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
 #define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
 	((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 &&	\
-	  IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
+	  IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION)) ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -2020,7 +2020,7 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 	/*
 	 * Normally, sections hold regular (order-0) pages. However, for
 	 * sections with HVO enabled, this tracks the compound page order
--- a/include/linux/page-flags.h~b
+++ a/include/linux/page-flags.h
@@ -214,7 +214,7 @@ static __always_inline bool compound_inf
 	 * but it requires validating that struct pages are naturally aligned
 	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
 	 */
-	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	return is_power_of_2(sizeof(struct page));
--- a/include/linux/vmemmap-optimization.h~b
+++ a/include/linux/vmemmap-optimization.h
@@ -14,7 +14,7 @@
 #include <linux/mmdebug.h>
 #include <linux/mmzone.h>
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
 	return section->compound_page_order;
@@ -64,7 +64,7 @@ static inline unsigned int pfn_to_sectio
 {
 	return 0;
 }
-#endif /* CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION */
+#endif /* CONFIG_VMEMMAP_OPTIMIZATION */
 
 static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
 {
@@ -79,7 +79,7 @@ static inline bool vmemmap_optimizable_p
 
 static inline bool vmemmap_optimizable_order(unsigned int order)
 {
-	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	if (!is_power_of_2(sizeof(struct page)))
--- a/mm/Kconfig~b
+++ a/mm/Kconfig
@@ -461,7 +461,7 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
-config SPARSEMEM_VMEMMAP_OPTIMIZATION
+config VMEMMAP_OPTIMIZATION
 	bool
 	depends on SPARSEMEM_VMEMMAP
 
@@ -1224,6 +1224,7 @@ config ZONE_DMA32
 config ZONE_DEVICE
 	bool "Device memory (pmem, HMM, etc...) hotplug support"
 	depends on MEMORY_HOTREMOVE
+	select VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	select XARRAY_MULTI
 
 	help
_


