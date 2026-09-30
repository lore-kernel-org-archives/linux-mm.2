Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B4C3CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700FA6B0099; Wed, 30 Sep 2026 10:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8196B009B; Wed, 30 Sep 2026 10:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C77D6B009D; Wed, 30 Sep 2026 10:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3990F6B0099
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:07:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B46561407C2
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:45 +0000 (UTC)
X-FDA: 85270606890.26.D9CFBDA
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB28540008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JwsY17Ee;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYQdJhIScJUHBWMaKSahvl3m7trT5SiIAd3TYhaGkKU=;
	b=bNZcsQnFfkH76Z7iT/fQQ4MRgbBZYNUdXd5REn1v34myJBAaNEOgypTlTQ6bplkKdMF3sW
	eSUXbs1mZbnRBmiPYF0ZLB1W8GpOP5HI7wqjFJB+Tp+qENv7UcWsr0xCLr5eO5OC9ccuW5
	BlYuiG1bHkEh/RfdhLHEJsAGfzkq1aE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JwsY17Ee;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777264;
	b=md0Iiw6Omf54bz3/QToGY+d99MDWwuQbIUm10KO99HBDillmMAgR31F03/umR+LP017nD1
	qo4MAR7aNJnzHbXrgFkepwD44T18Ak5Xl+FRjbcTRXdE1dbVSm1Hl60oqRTkgDvXevPdDo
	lCSpMNaqV2+jDAzGjbVSW92fZA84QCw=
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccda24afso2790410a91.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777262; x=1791382062; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LYQdJhIScJUHBWMaKSahvl3m7trT5SiIAd3TYhaGkKU=;
        b=JwsY17EeiInZWC5MtHG0PXSjJOAJ4mXZPgkYJ/rU4UNsc0h/vdEZpfiKIH20gJfBsR
         rHhV/OahB1z8U68ZZ+AeFfn4PNdGAbkstkUlimXaeYunbZJRRCaTYb88rMIW9wtqJjDv
         Bkc0mUbhOl3wdekxprmQrHF4+n0ZV06dNcnMhUeew6XJFG2rqkQW+G/iJnvkTyUHtaXo
         dmXyFz6FkBmsmk4Tpmq4Cmmvl0byCrJgEK1bC5NO8My2DBaQeGTfUNoDX7AKVJLqVSb/
         UrrsHjgPnizsr8AiPUJGw58Iax+5JlN2rVsRsMpf3s3jGQCin+PsPOyCcmdxP5ddPkMm
         27ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777262; x=1791382062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LYQdJhIScJUHBWMaKSahvl3m7trT5SiIAd3TYhaGkKU=;
        b=KzGuWnsT119MImk4s4WK5aWKPa5zgw9hGXoOTVWYMer9XCMvsWGEOgGhiqRCeEEf0L
         P4uDuJLqNVNHEj/1xyr2C6pDP7U/IF0r+q6f9rVlQH7riVkQD0sg56d0DYJvrE/dhJx4
         fMmAo/q/Xa6kJizmFQCEMIQ9SMivJvdTOyU8opNkfv3nMS/viUthvrgp9qqR7oqxdjhl
         vDOZiTyRybh5m1nkH6WrPHD3WGb+/GyXU8uGlMGi3eokhAGB5FNMztK28Y4HkhBCA+Mr
         3p/xF5EQVIkrYvFgzWLfU5q5Xv4P2BQOHbQ3g4bGrtZ6fgEInSoIQf50RKJWm2EWCRCD
         uQHw==
X-Gm-Message-State: AFq9FYLBZ8a7EgqyuHr6wiijBeBu/XsTrT66WJhwLoMBHZSCseLj2ieE
	nSKuaZzpkJRjBXpuxBP/M4FjVkDbUmGctC5qB3RfbT+HymDhfF3S+09PN0D6U6xi/C0=
X-Gm-Gg: AYBFou1m/aycuuxCc1PYiAFYGj1lBNOikQy4Fy/iInVrWF4REj6H7TVVI6AjhvfosKM
	ur5q6+OEZfFp2LhZ6FgZLhJ7EkWnnSr8V92IyE46JRrv05s5ZyDmLMf6pb7U2Po8UHkGGO5oZHP
	IyHcRRVKwsh7pJlyK+RZAarkHKUqJXHmMWc5b/uj8w9JxDe2QqSjaNhMFWpUdCycoMAWA3crFsS
	PCmMRTBMCBzf3MCXbDlly357RLa/1o9SdNLDVP12mn5VJ2lQLIfmkZtJG5nCSZ/lkZeihFRLVvS
	RJf4r5j+sXr7ZXmq2RUtgKNAlH0WuvHLJaRy9SRJYSVC1Cf1mpj1K+P/jicF0G2m7NuGubdzVoC
	ScgQYVnMHFEVEDuQIpW0Mf12b+EulryJPO+WlUFVhNgPzzAWIX/wk3/Bfas7246r+Twaa5J/1Vl
	n7cswrBM09HdUxve5+/2ERpuE7CF/Ir/IoouiHLtp5eBKstarnRw2eB9KHrgSLIgL4bG7IJ75yK
	cQ9TUdHYCdjvw==
X-Received: by 2002:a17:90b:574b:b0:39e:6c68:1550 with SMTP id 98e67ed59e1d1-3a4d152ef8dmr727985a91.24.1790777262347;
        Wed, 30 Sep 2026 07:07:42 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.07.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:07:41 -0700 (PDT)
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
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 03/12] mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
Date: Wed, 30 Sep 2026 22:06:18 +0800
Message-ID: <20260930140627.57431-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB28540008
X-Stat-Signature: r43cctsxw6iitaeuyi3qms6tcecag9es
X-Rspam-User: 
X-HE-Tag: 1790777263-270797
X-HE-Meta: U2FsdGVkX1/DvLz9EQmwtH2x2pzftIwz0bdcIqsT3a6qLyomvZJJtOeNe57svIyd2dgLrmZg7vV+bwbD6BXUt+x6rrntWlOHb0zFdlV47fBLfzpmmnU7Naw2pywVA5FLTu76co5pYUwFA6eEihPbXuqC23XBmxv4bCLoxRKpCA85jYNz2qdvdFNuO3c/ixQCv80sgGgC4zF9k5Q/vte9N+/bvlpY33H6TnA07syEP43RpydtUEuisbdEIg9Qd8xv87D8alRmFjgvROhemiQ9qbE1yfZq/d3rCNRnXx0IOaOC1TNJdmSL7SB64oRYhFr5rHFvxpe9PdR7DVF95VXw79Fn7GQln+9pEu5+dfsmf5gZaJPxM1yEvPc8rpACyDwYS87qPA7ZUPkxRNZlgDuB+saz7NMPV772ZRhXGBcbOj7LtrKb61Vi1M2JXZdZ8vqKkuSglk13YqMJm9tmb9BiG+DrJ12N4lEgPihjyj3WVSxMHtQmLST94B/qexl6ZLtcSLJGEpP6T+0S7xCZ9JGKsHb1UYknHG6e1SARcjt7uwaIFg9hofSRRUgzoXo32OrGHO2l08IJkrYYEKw5+nDNQ7fOB8/LLSE4c5MR3fpw9rpIJYDLylNQwXKVsVcFgeA57WPDvys03WXp6yMhCchIklHTNWV2ZQomohzHZUliEZU6GpOBbZaVEeViKkiymMv9DqRgD8W1Um8nFFlXb3LO4Ah8GZNT/kjJvS2s0IrvY3p6GHPGDkUSS/36zZpiEQUQOTKj+X/yAo4Xe0dFqLqSChs5MQXT9Wm0dsHc5HCCHKSMAQVqsXF/afezobloJMezA6+7X9FzLZK9Gb329ElXALlZpFm915dqU9y2qtryEFItT+S104NPv+ZDJKR4djqJ/XpzAq5My15LjzTZ96ZnoqGkgmbHgV5LlsTmHz2PsN3YyUCgjcgWvoGKwWU402ZB7Opd/aefLdlLW2bJ4F+
 t0HxYSQe
 w9MZ8cMDftJs4ia+MCpWfbvYnrqY+34w8aHKW3x730gKh0Edns+9ifQIP8kOigoR3oUNzSory9KrhJH08aAeqaPbqSY54EEgMgs4TSpasvzS85+6IkZFld4Hjh2JZajrEt8Cu4N8yyzrheP42A2N8Ew7uOK4RxEI/6ArCT0p9Hlv+8o5SymK7hH1y51VwxuTsSdF2Q/5BL8OxFuLEHmIwGCWKq5+9AWtDBMVYdABvHk1qIYNdP32z5upJgJtZWXCM4LuNPVy+zSId4VPpnYWYvTf3Dt5vaAid7qRg7NnLZeGkwSz7qe0uSFUjXmFLsNccL6ZSMaKUZ00Ci/Skt9sBi8yvHd+bXCs6U3B29h18KzHlimKZKeT4ReCb3Yev6VOMvLG6BAXc5uB41cEAKT6YglmkJd77AU82Zuz0od8FBnvw0QTZQD8QRZCqmiXc1TkbEVGeZKvNPnlD/z0=
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from David Hildenbrand

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
index 0ace48268095..6916a3690778 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -169,7 +169,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 	return p;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
 #define VMEMMAP_OPTIMIZATION_NR_ORDERS	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
 
 static __ref struct page **vmemmap_tails(struct zone *zone)
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


