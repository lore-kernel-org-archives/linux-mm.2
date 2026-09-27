Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA40C98328
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3E86B0093; Sat, 26 Sep 2026 22:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BBCE6B0096; Sat, 26 Sep 2026 22:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580996B0093; Sat, 26 Sep 2026 22:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF876B0093
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A272D16099A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:09 +0000 (UTC)
X-FDA: 85258025538.23.D135001
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 658A1120006
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Nn7HCEXm;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BS5o+gJrZMstILSVwOeeCwCCqKRIe2kUlRPqsjqyE2w=;
	b=l/5r2re0Zu4wuM5awtFQcV18wrehTzbID17kJ/FMj+Y5rz/7x6Sn4yIBdgelRc/dLNeVCK
	LPI8+ZtVTqGpGIOLuNoVtOaRgZXIgxeC9Ei/uFtJkt3EGlU9sKImL6C8ZgYPmGmIwTl2zK
	ebdF/UbJzcB/ipNu/yzHS3/8fL+H7Jo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Nn7HCEXm;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477707;
	b=n4MddXErSFTQzRD/UbNhJV6qxGN6lU8naXRmt4ogiZbHRhba/Lk+Jl8MPjXvrbGNOiYAQ+
	1zN30tUOGSpn+oYLbOLmrje7LWbvL4htEPSeqmIcVNKlxiqUcLMZNLkvfn8ymmpvQnZZrg
	hGTuhDDg66QgV0UpNCeo1QnlOCwKuAE=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-398beb616f5so1054989a91.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477706; x=1791082506; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BS5o+gJrZMstILSVwOeeCwCCqKRIe2kUlRPqsjqyE2w=;
        b=Nn7HCEXmwbWX1mmZLTTlfauSzpbBojxICBA5cDi1FzGlhaZSAls2tSpg41U5pI22I0
         Xq/9W3k+NELy2G8GebfjHuVDoh79ll4wblFQRt4qcQksO4kze2GLwsl7T7YmLaz+r3aB
         SCLpyStgdJGHyVQvV/hRCLUEge448gFuDhGL7zxlsoy49q33R1Si/oZx6Vr2WVRVGzUe
         oFnl2a4xtnI6JoGdQEx/AJtzSpgo1v3wxTTiI6ElhARFBWNdsYpOkhP455bwC0KZcTu3
         iOvfD/AP3nYwRtEzGxGeKxZXRrZwuvZwNy+fAGM1IDiUvItDO0YqRa+aSIS3aBAiKkE9
         flyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477706; x=1791082506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BS5o+gJrZMstILSVwOeeCwCCqKRIe2kUlRPqsjqyE2w=;
        b=AyYAvouQRTOq74PMaiWE6bVj2l6i61X0NPVctzsI4REIK8YeltLoZ9EwbQ4GGoPboB
         lMDuOnY+EAnn1/l2SX9QVYV02RYeWQj194GXPPwQC4D3+/ChH607dpupOiOBwSqdUsKH
         LX81Xj1UXLqzfpyZdmqN/i1N5Vrw6OQrBh9+PRNrV6kSSvACT2dinGvnI8TbySxMtaOf
         0GGwq2DVKgdp2rPAjgqYYsLh3Cg8WvqEyfJ/1nbgGq9+5JmISiOeJCUqt0bD/EhaFd0y
         Cv5TFn5aCygJdjwRRt0sXWmrLg6a07paCBB5sEPTox5jPhL8woJjoJemDN8e9BPQePlS
         8/rw==
X-Gm-Message-State: AFq9FYJ1YpvwYNpyY8qxf9wM+TomgoyVDsT5PNxyPHm+Y13SF/rL5uQa
	/FSntD8LL6qVrgFsNU9vcGTaWvaT1AoWYns5qnJEoFQZdyn3QhnD2XnfUImDaXAzJSo=
X-Gm-Gg: AYBFou3yCp6TkDArrUAEeWcm3VFrG+zsh+Iq2Oz+qQzBBVqsVJhD4IepWmU9kRh82o+
	GRZkbjlBV/ExYxM3ikJsdANpDt+MZ6kcjV3CQsvqvVk0MtmzS5O0Wl7PW/+5X4J4g9dgWQUTMCp
	XWO+yGOg4zdHov652De6xGjDr9ib9RJC496M7jjmq7VAuFLvapjDV7r2asMzpWvtSSKjgwfh+jq
	F97emNqm7eSXk5xx9a76H6lx7jLsRaHfu2zNqr7J/8oN5uGec9m1LN2kQVYZv6+j24tjVkGgic4
	BJNULGowcF4AFyXBdMZ1VbTaR+EiPjvZq4pAt5/ee7N2KCMPphIWXePgmSyiSNP4S0k9BLYN2E1
	8i76PLc0bm6dy0F86tCDrbqLVODLfG/X9yqv1+6N4DcoWp7FCn8uW4gxvMhYbXf2zH6SDKLZjLI
	EN5MypyE+uhv3AN2ka8t0Y5is/iAG66DpSvzvu/IKMgA6kaScWLISMn2a20/j4BnZZWUa8CBc8c
	H6R35WNF5cEpSBdK+SU
X-Received: by 2002:a17:90b:2809:b0:39e:4c7e:bc3 with SMTP id 98e67ed59e1d1-3a0986a46b9mr6089057a91.17.1790477706208;
        Sat, 26 Sep 2026 19:55:06 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:05 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 03/12] mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
Date: Sun, 27 Sep 2026 10:54:32 +0800
Message-ID: <20260927025441.741633-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8eob95q7cz4hpkiqpia45ergt1tihdwn
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 658A1120006
X-HE-Tag: 1790477707-773032
X-HE-Meta: U2FsdGVkX1+omEGniBJ+kTvrn57911uT6MJ3OW3HgCNDmKreGQ3MXEBSOh1XbM10/tsoIJ8g4fuFa3HZEmYPYJW47W1I7exaQmpQmHM3MeKekPFLcbnAZWNQNA9e/hoasMgvyViuPRtjr+i4zbYur+z4+cqnOE5kaUUE1SFEMyXYKKIXxzTpuacH3O7FZntfUtIbm2SAJBL2Pld5wVbvwo1nzhTei9o4VuGKsPCGnxrp5v1XVlJ0jCXVJp3f9TLFifYaBx/qoV5Ci1Cvi+hwe/LpGN5ofnJez0JR1rXhX+W5Ol72kBtU0lsra2ujP1mX7yBvUXvkBaCFa4RnQgKykZzaU6G/XOSigIufeI+zFmHj8cWxEPMF7ZW27OJnhNbkhXOkLp4Tsd3D4jUoI10DbwWjnmlTdl0eV5W8zHJCBygXe47xOuYV09gaIKy0mjUesDImjBOtzvcJITddH0Sh+hWwaUQ2z8zcoyQ5SDCgcFdMN3GCY2AJHW/Ia02HM2xDyB3fGR0MUsAR6LtLSola/AfpM6lINfH+8aJqehCzbpn2URCkst8rv8QNm+q5CWzBzjMdF26VZxfz6Rig6hmnaGtp87U5BhF3WjxsGwrsnrz7yVP2ehUoe+jagGB4I6SUC2asE4e5KkVexMogs1ans8IryaORbmiMbHZieB5EeEiVNlIai9qJhc8GN14NcEmGRIQN7db575Zh4V9ARyVRAATovwpS9l8rBFn/FdzvFacB2FtVGk2SzAISdB8LVidRLrIx3H5oVb6Fb8ULKsUZVvJEY7BOUQkv+T9QkHSFHk4fN7fpPF0+V9AcPhB+Xdv67CKQ6QGhHzuHAlHoC3aX9Uf3zbOy/mEtsDIsu73jhAhYoui1gc5akYtPAmme1xCS11K8CnIFgcDqe0P3e9saONulSFrNrQiIq0nk0jRiUtyxfGRSnjSfaMCfsYbdL4VWwJMw4kq0T2eZj5RwTDS
 pFr/afCH
 ARNjA+2+V1PzbbDVU794a/5iRT7wBOw2wCV3Ctl1X+7fAAnQhoaZd4ioZgnths/UzxTfr5EsAXubyJfSyMbwqvbbk/R0cz8ATgvQri8aoJYFaL29OFUrf0ZMEqsdtP2XGrLshJAARxPhI+OkXXvTvL2i8YJTuMarfhedVJp2+OTLga9peU8lGDN+tTW3dvMRxIsdUQ1CnDOIytFeh42QEYg4IaGvXLkuCuFXEm5nVhsBxtmDHyqNu9PKECpkhC2zp4bNMtwHMupvfOlwM52fu6LKZ+b4aW+/LTnyNCHesJl3P4klPBCLaMJO85HlcnmDsArjeIuTwx9L6pCc7AQvZuhVZ7NPsYui93qvlv873mQnQP+3+qZub/9bgx9BAqz6Rc1AK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The section-based vmemmap optimization infrastructure is guarded by
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it can also be used by
ZONE_DEVICE users that set dev_pagemap::vmemmap_shift. Introduce
CONFIG_VMEMMAP_OPTIMIZATION as a common config for the shared
infrastructure.

Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
ZONE_DEVICE when the architecture opts in to DAX vmemmap optimization,
and use it to guard the generic sparse-vmemmap state and helpers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v5:
- Move this patch after the shared tail-page factoring.
- Select VMEMMAP_OPTIMIZATION from ZONE_DEVICE instead of DEV_DAX,
  covering all users of dev_pagemap::vmemmap_shift, reported by
  Sashiko.

v4:
- Rename SPARSEMEM_VMEMMAP_OPTIMIZATION to VMEMMAP_OPTIMIZATION
  (suggested by Mike Rapoport)
- Collect Acked-by from Mike Rapoport

v2:
- Fix SPARSEMEM_VMEMMAP_OPTIMIZATION being selected without SPARSEMEM_VMEMMAP
  reported by Sashiko.
- Add an explicit DEV_DAX dependency on ZONE_DEVICE
- Collect Acked-by from Qi Zheng
---
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  2 +-
 fs/Kconfig                                    |  1 +
 include/linux/mm.h                            |  3 +++
 include/linux/mmzone.h                        | 10 +++++-----
 include/linux/page-flags.h                    |  5 ++---
 mm/Kconfig                                    |  5 +++++
 mm/sparse-vmemmap.c                           |  2 +-
 mm/sparse.h                                   |  6 +++---
 8 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
index bc3e549795c3..72a92cb9b53d 100644
--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
+++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,7 +11,7 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
-#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#undef CONFIG_VMEMMAP_OPTIMIZATION
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
diff --git a/fs/Kconfig b/fs/Kconfig
index d1c210c6508f..1454b7fe9641 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
+	select VMEMMAP_OPTIMIZATION
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c49ef99b4413..070ce27e9cd3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5175,6 +5175,9 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 	unsigned long nr_pages;
 	unsigned long nr_vmemmap_pages;
 
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
 	if (!pgmap || !is_power_of_2(sizeof(struct page)))
 		return false;
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 68807ff7f946..ee9cbaaa63f4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -102,9 +102,9 @@
  *
  * HVO which is only active if the size of struct page is a power of 2.
  */
-#define MAX_FOLIO_VMEMMAP_ALIGN \
-	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
-	 is_power_of_2(sizeof(struct page)) ? \
+#define MAX_FOLIO_VMEMMAP_ALIGN					\
+	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
+	 is_power_of_2(sizeof(struct page)) ?			\
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
 /* The number of retained vmemmap pages with HVO enabled. */
@@ -1150,7 +1150,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 	struct page **vmemmap_tails;
 #endif
 } ____cacheline_internodealigned_in_smp;
@@ -2014,7 +2014,7 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 	/*
 	 * Normally, sections hold regular (order-0) pages. However, for
 	 * sections with HVO enabled, this tracks the compound page order
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 86dd0470da11..7080a6a1a79e 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -208,14 +208,13 @@ enum pageflags {
 static __always_inline bool compound_info_has_mask(void)
 {
 	/*
-	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
-	 * makes a difference.
+	 * Limit mask usage to HVO where it makes a difference.
 	 *
 	 * The approach with mask would work in the wider set of conditions,
 	 * but it requires validating that struct pages are naturally aligned
 	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
 	 */
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	return is_power_of_2(sizeof(struct page));
diff --git a/mm/Kconfig b/mm/Kconfig
index bc7befafb47b..30170a936f1f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -461,6 +461,10 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config VMEMMAP_OPTIMIZATION
+	bool
+	depends on SPARSEMEM_VMEMMAP
+
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
@@ -1220,6 +1224,7 @@ config ZONE_DMA32
 config ZONE_DEVICE
 	bool "Device memory (pmem, HMM, etc...) hotplug support"
 	depends on MEMORY_HOTREMOVE
+	select VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	select XARRAY_MULTI
 
 	help
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 46d9a25b3275..38c36399f53e 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -169,7 +169,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 	return p;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 #define VMEMMAP_OPTIMIZATION_NR_ORDERS	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
 
 static __ref struct page **vmemmap_tails_alloc(struct zone *zone)
diff --git a/mm/sparse.h b/mm/sparse.h
index 6e7aaeaa5594..326ad43bb5c3 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -10,7 +10,7 @@
 
 #include <linux/mmzone.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
 	return section->compound_page_order;
@@ -75,7 +75,7 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
 
 static inline bool vmemmap_optimizable_order(unsigned int order)
 {
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	if (!is_power_of_2(sizeof(struct page)))
@@ -142,7 +142,7 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 #endif
 void sparse_init_subsection_map(void);
-- 
2.54.0


