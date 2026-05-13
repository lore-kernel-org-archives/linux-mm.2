Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE64CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFBBD6B0105; Wed, 13 May 2026 09:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD46D6B0107; Wed, 13 May 2026 09:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9576B0108; Wed, 13 May 2026 09:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9576B0105
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:22:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50AB11C0078
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:04 +0000 (UTC)
X-FDA: 84762459768.26.908D994
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65F5B1C0012
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OSITr4UR;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xAcJFzw5l8sNYVc/df08CWPD7oki7YaxoFEOHbnbjI=;
	b=Je+o8rf5XEwrS3ynmJ4Kgo98DLfuZqt5nCBcMXFju83DqRcWYpYuxOuvqszNYUdMnFPDfY
	IpDE9ebP9cSs0qpd2rj5IVa5lTF1Nn4dZIigi/y5BFmp2ql5f41dPFpJjQ86ULhpMvEIEu
	+jUKv4A3ak/aeX+VNu/nf91Z8fyQ99s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OSITr4UR;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678522; a=rsa-sha256;
	cv=none;
	b=OikbomUUx43ELCKqdmf3BzfxxHB9dfFHrwIl95JwDUFPzNLI7woxcNTYxxf6xLTb/A9VZE
	OVjBYqyp4zmThO2+RWhDVxgZBLjNN1M8mHM1/V0L8qFi/qLr253GunC/Ij7QuzFu5ebd0a
	shYxFeQQ2QauuNWXKjLtcCe4sh9oNSI=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-367d88b9940so3258985a91.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678521; x=1779283321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xAcJFzw5l8sNYVc/df08CWPD7oki7YaxoFEOHbnbjI=;
        b=OSITr4URT9BroVA3ZJnvvQEvg8pGiBr7I3AR0yQLUAAEZsz5qG9mLiEW6v4QXCoZ3c
         7tAnl4nDug+DHg0vUDi/8Vhxm/o7scB//d1qurWe5odDnsRGZpLaBB7d+tTul5eeePgN
         8FYJjSFnqc7Hy7zCHQiJSOdhG4vzz+wZiz9JSMrAWLGa1jmCIYAxXSdrP9EUnlcuGm6E
         pbj13IuJ0N1MspL/1PBi5fpiv1ZrzGvEndO6pKqGn7nJfNobe6MRBI6OZvcWXkNx1oeW
         5SZOa3KSwhGiCt/qA2UF2zgn1HNTKsrsw9iANjY7HKH+ao0rilYxRxKriFPnwIUUe70C
         h1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678521; x=1779283321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8xAcJFzw5l8sNYVc/df08CWPD7oki7YaxoFEOHbnbjI=;
        b=pZhRv6pVQIOl6XomvOHN8rS0WjI+nnGjzwjbwLrpFLFxMIeK1NWFVcwvCHcCVH/43j
         LcITZFFdt1RhoxRjm2WvQbQoCpEanpPtsG6eWwektImkGJZqpb5bajup/nDwRzFs3qEk
         JlSv9kGCR2aJYUfZ5YE7Tf/5PDNhHE0nEpo7hpeUt7dEe0yfSudVUxBYHI1wn+Hy1Xnk
         jLKIOB6nXnUkajG4cdG1p4hXBZUYK8NwbnGcSoOs8YpIYloVaQjiF93HABPaDYffLRie
         OzJh48BOJ7ZUM2oWvTsMp3CsDTaMLadOxZ7Qd5U9o4Kp5uoIZ+OHMZ4K39JN+jBuqxad
         t4aw==
X-Forwarded-Encrypted: i=1; AFNElJ9sWN+EbZX3GX86EAZHVTsvDYUg8k/pLm78kel3/twfaoJ9zLvOy+BSi8LpTEfLlp/wqoGke5zE5w==@kvack.org
X-Gm-Message-State: AOJu0YwrgO9qjdSqkBG01/RIfCMsD6lRvSQg/D1IsDNNYqOkPD/j3kHv
	Pw9fzD+aQYJUt3My/+z3V8WPWNzjT2QEwc2pB8V1fKPmoMb6m/INCpyFWJL9dodHKd8=
X-Gm-Gg: Acq92OGnbxOeDaYZUyi/duJXLsenJ4VSmsD4LxBgimph+GWWGcYwKe6AJYANeVKsnKf
	CTi+IToTivfh7Kx9gGT7DE0CvgkM0Zu2AoAZ5QJVdd/s/kOJdGKBVT71ip2svx+0J4PdUhqeQUR
	PMF9Gc3d3fye0b7/nyrVTjP0aPlCb/x/Chm1qTNqEtmIuyUXU42WW0i9SJxoU6JXRXxeXsVcZb4
	swCTF233DkAa7AMZYROn6VQOjllaxWYlWRgbjv5cG0gyhimisO7gzeCaNeHatjKV3krIoVXlkR2
	uWdV29i3E+oO/esFc/60ZiH7UDn9DJ6DyGW3qqgUccLzFsdBcGvhwD45gG+zBZK/TJwoNVTspR1
	36GADH15u7yYTOZHTrSMED9uiiNSS14UqpVEiRaiYh0XmnZ70XIfi3IjvT7g8ckTpNFfKSM7YgH
	KzLc0ymgW6CxbsNdNfplcYmg8341BFZgecMqfeBTCorYD8ThnvtAxXcjGLYw6wIIBcirrCePQ=
X-Received: by 2002:a17:90a:617:b0:368:f7a7:daee with SMTP id 98e67ed59e1d1-368f7a7df06mr1739782a91.8.1778678520875;
        Wed, 13 May 2026 06:22:00 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.21.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 57/69] mm/sparse-vmemmap: Consolidate HVO enable checks
Date: Wed, 13 May 2026 21:20:22 +0800
Message-ID: <20260513132044.41690-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n6z6w6un61r8y6j7m3kcz6mszybjipoo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 65F5B1C0012
X-Rspam-User: 
X-HE-Tag: 1778678522-707478
X-HE-Meta: U2FsdGVkX18GRNrWhM0vzl0ZTG7G+lR4Y7dESWSPmhFDNaucoHjrIXxgBYygMEKhEQxYbKwp+TBqdFOBimfizXBAiZ6VK4M+HjlR7XZkt4JGgOyoXb0AchkQa91MhVwzcjEDkzau0Ck33Fu7T2rr+YfAvn59U0phmL4hIWrjftk4ADEk/yAOVX13WyFkDCvq2tysVw+DyLY8jL0UUAYttZssuF+cn9JBCtYZLHbGiE/qxP9jhPXwyvgvPaP1W2aTvcxvsQA+y5KZSxUXgWkbS1TEq1K64Jfi6vod/XtOq/1y5/CeI4Btxy4Vbr/kY6zWX2FycJGoNcpzUExyl/EEF4pI6etZphwykM3L0893D8OS4sSK5k53XT2Q+HMpLA28w6bcv9NOdWcYvEe9jRYn35cmiOstJTS1DlcJx2ew+iqoW6G79es71DKGIr9D+mJamde+gKOXW7tktbMHBNpomn9a5tq5IuMDF9nkQe4e8/D17DDrAo8U5DRD0UjBErwO+Tq7A7k09EgnOaZEWsU9dwVxiihZzH7R52u7GcjJbMF3pakmr2ubgmU85WlVGKIVkkFTDhdt7yUixIBWwg1cCqFPtTD2diYDC1XsAMmwPfjodJcsj5bqqYKWD1YnmxeuvYGyTGnvkz8f9+PW0uPdMCcrqkYrcmZhif8fmPFi8G6A/C1AtVmvcgEsWi1N177ZD/xWGoQKbnvCgAoQqLLlGxjcfkRQ+MG4vs3wVjvFXyuKLG2rnmF5BZPeBs2GC5SeX7Et17Q9bivi46ANvCQ1qMpDkkqoWaUEP9AdkVRaoCxLCIknA7f1QlK6FJzKFCTqgF1jPnGGpTuIuA9h/dGdrIrAGdpz6V3UVzU69i+5eixmvQzyePtyEIKvUgLPO/rb5oC8bfCrfJVEaSwVpxVN5jvVCco1laGHEos+XJV70WePTlF2iaHiOWKLuTz5R3EGKnR0DburmW4pwQS7pJ6
 qyk+Pieo
 GaX90/Sib3xL6C7M5SV9E4BxE3QOmL/eqTFZtaxreQ68wDNyzNkagCVd8Ms4NXJAA2UmhtQiYTPo+nsYzAglsJE9YmCpJp/LWe240vR4V4Aa5SFdYKRFqWhOF/azLyKaupKekEHObREr61RE8a1A3IH9mrvG/mf2kucp6ODnaLIqrX8FBiek9nFJTt1CjHa7siG1oncN3DxUwAlF3+uhcK2UgnbWhX2V6FHp99VmdsqUXprGCbJkbLOnoMMcaMtrZXiolkEX4HTAP6Bcb8RGenMG6SaWDOeL8ybcR5Vujg6Nr9klgpZcMRZFiPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HVO depends on build-time conditions that are not fully expressible in
Kconfig, including whether sizeof(struct page) is a power of two and
whether the supported folio order range can use the optimized layout.

Those checks are currently duplicated in several places. Define
SPARSEMEM_VMEMMAP_OPTIMIZATION in bounds.c when the build-time
requirements are met, and use that generated constant to guard the
generic HVO code.

This centralizes the build-time checks instead of repeating them
throughout the HVO paths.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  1 -
 drivers/dax/Kconfig                           |  2 +-
 fs/Kconfig                                    |  2 +-
 include/linux/mm_types.h                      |  3 +-
 include/linux/mmzone.h                        | 38 ++++++++-----------
 include/linux/page-flags-layout.h             |  2 +
 include/linux/page-flags.h                    | 28 ++------------
 kernel/bounds.c                               |  5 +++
 mm/Kconfig                                    |  2 +-
 mm/hugetlb_vmemmap.c                          |  2 +
 mm/hugetlb_vmemmap.h                          |  4 +-
 mm/internal.h                                 |  3 --
 mm/sparse.c                                   |  6 +--
 mm/util.c                                     |  2 +-
 14 files changed, 38 insertions(+), 62 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
index 5f8424eade2b..db1b15f686e3 100644
--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
+++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,7 +11,6 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
-#undef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 60cb05dce53d..cb7710c29885 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -8,7 +8,7 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
-	select SPARSEMEM_VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP && SPARSEMEM_VMEMMAP
+	select SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLE if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP && SPARSEMEM_VMEMMAP
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/fs/Kconfig b/fs/Kconfig
index 496cfa2379e5..ab3937abe07f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -278,7 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
-	select SPARSEMEM_VMEMMAP_OPTIMIZATION
+	select SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLE
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..9a7cd7575f3a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -546,6 +546,7 @@ FOLIO_MATCH(flags, _flags_3);
 FOLIO_MATCH(compound_info, _head_3);
 #undef FOLIO_MATCH
 
+#ifndef __GENERATING_BOUNDS_H
 /**
  * struct ptdesc -    Memory descriptor for page tables.
  * @pt_flags: enum pt_flags plus zone/node/section.
@@ -1990,5 +1991,5 @@ static inline unsigned long mmf_init_legacy_flags(unsigned long flags)
 			   (1UL << MMF_HAS_MDWE_NO_INHERIT));
 	return flags & MMF_INIT_LEGACY_MASK;
 }
-
+#endif /* __GENERATING_BOUNDS_H */
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index efb37f2ffec4..0d49d6e163ff 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -3,8 +3,6 @@
 #define _LINUX_MMZONE_H
 
 #ifndef __ASSEMBLY__
-#ifndef __GENERATING_BOUNDS_H
-
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/list_nulls.h>
@@ -96,33 +94,32 @@
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
-/*
- * Hugepage Vmemmap Optimization (HVO) requires struct pages of the head page to
- * be naturally aligned with regard to the folio size.
- *
- * HVO which is only active if the size of struct page is a power of 2.
- */
-#define MAX_FOLIO_VMEMMAP_ALIGN					\
-	(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION) &&	\
-	 is_power_of_2(sizeof(struct page)) ?			\
-	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
-
 /* The number of vmemmap pages required by a vmemmap-optimized folio. */
 #define OPTIMIZED_FOLIO_VMEMMAP_PAGES		1
 #define OPTIMIZED_FOLIO_VMEMMAP_SIZE		(OPTIMIZED_FOLIO_VMEMMAP_PAGES * PAGE_SIZE)
 #define OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES	(OPTIMIZED_FOLIO_VMEMMAP_SIZE / sizeof(struct page))
 #define OPTIMIZABLE_FOLIO_MIN_ORDER		(ilog2(OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES) + 1)
 
-#define __NR_OPTIMIZABLE_FOLIO_ORDERS		(MAX_FOLIO_ORDER - OPTIMIZABLE_FOLIO_MIN_ORDER + 1)
-#define NR_OPTIMIZABLE_FOLIO_ORDERS		\
-	((__NR_OPTIMIZABLE_FOLIO_ORDERS > 0 &&	\
-	  IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? __NR_OPTIMIZABLE_FOLIO_ORDERS : 0)
+#ifdef SPARSEMEM_VMEMMAP_OPTIMIZATION
+/*
+ * Hugepage Vmemmap Optimization (HVO) requires the struct page of the head page
+ * to be naturally aligned with regard to the vmemmap size of the maximal folio.
+ */
+#define MAX_FOLIO_VMEMMAP_ALIGN			(MAX_FOLIO_NR_PAGES * sizeof(struct page))
+#define NR_OPTIMIZABLE_FOLIO_ORDERS		(MAX_FOLIO_ORDER - OPTIMIZABLE_FOLIO_MIN_ORDER + 1)
+#else
+#define MAX_FOLIO_VMEMMAP_ALIGN			0
+#define NR_OPTIMIZABLE_FOLIO_ORDERS		0
+#endif
 
 static inline bool order_vmemmap_optimizable(unsigned int order)
 {
+	if (!IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION))
+		return false;
 	return order >= OPTIMIZABLE_FOLIO_MIN_ORDER;
 }
 
+#ifndef __GENERATING_BOUNDS_H
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
@@ -2044,7 +2041,7 @@ struct mem_section {
 	 */
 	struct page_ext *page_ext;
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+#ifdef SPARSEMEM_VMEMMAP_OPTIMIZATION
 	/*
 	 * The order of compound pages in this section. Typically, the section
 	 * holds compound pages of this order; a larger compound page will span
@@ -2236,7 +2233,7 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 }
 #endif
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+#ifdef SPARSEMEM_VMEMMAP_OPTIMIZATION
 static inline void section_set_order(struct mem_section *section, unsigned int order)
 {
 	VM_WARN_ON(section->order && order && section->order != order);
@@ -2277,9 +2274,6 @@ static inline unsigned int pfn_to_section_order(unsigned long pfn)
 
 static inline bool section_vmemmap_optimizable(const struct mem_section *section)
 {
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
 	return order_vmemmap_optimizable(section_order(section));
 }
 
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
index 760006b1c480..6a7e7f3dbb93 100644
--- a/include/linux/page-flags-layout.h
+++ b/include/linux/page-flags-layout.h
@@ -2,6 +2,7 @@
 #ifndef PAGE_FLAGS_LAYOUT_H
 #define PAGE_FLAGS_LAYOUT_H
 
+#ifndef __GENERATING_BOUNDS_H
 #include <linux/numa.h>
 #include <generated/bounds.h>
 
@@ -121,4 +122,5 @@
 				(NR_NON_PAGEFLAG_BITS + NR_PAGEFLAGS))
 
 #endif
+#endif /* __GENERATING_BOUNDS_H */
 #endif /* _LINUX_PAGE_FLAGS_LAYOUT */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 12665b34586c..df7f6dea2e5b 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -198,32 +198,12 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
-/*
- * For tail pages, if the size of struct page is power-of-2 ->compound_info
- * encodes the mask that converts the address of the tail page address to
- * the head page address.
- *
- * Otherwise, ->compound_info has direct pointer to head pages.
- */
-static __always_inline bool compound_info_has_mask(void)
-{
-	/*
-	 * The approach with mask would work in the wider set of conditions,
-	 * but it requires validating that struct pages are naturally aligned
-	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
-	 */
-	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	return is_power_of_2(sizeof(struct page));
-}
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
 	unsigned long mask;
 
-	if (!compound_info_has_mask()) {
+	if (!IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION)) {
 		/* Bit 0 encodes PageTail() */
 		if (info & 1)
 			return info - 1;
@@ -232,8 +212,8 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 	}
 
 	/*
-	 * If compound_info_has_mask() is true the rest of the info encodes
-	 * the mask that converts the address of the tail page to the head page.
+	 * If HVO is enabled the rest of the info encodes the mask that converts
+	 * the address of the tail page to the head page.
 	 *
 	 * No need to clear bit 0 in the mask as 'page' always has it clear.
 	 *
@@ -257,7 +237,7 @@ static __always_inline void set_compound_head(struct page *tail,
 	unsigned int shift;
 	unsigned long mask;
 
-	if (!compound_info_has_mask()) {
+	if (!IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION)) {
 		WRITE_ONCE(tail->compound_info, (unsigned long)head | 1);
 		return;
 	}
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 02b619eb6106..9638260d67f8 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -8,6 +8,7 @@
 #define __GENERATING_BOUNDS_H
 #define COMPILE_OFFSETS
 /* Include headers that define the enum constants of interest */
+#include <linux/mm_types.h>
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
 #include <linux/kbuild.h>
@@ -30,6 +31,10 @@ int main(void)
 	DEFINE(LRU_GEN_WIDTH, 0);
 	DEFINE(__LRU_REFS_WIDTH, 0);
 #endif
+	if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLE) &&
+	    is_power_of_2(sizeof(struct page)) &&
+	    MAX_FOLIO_ORDER >= OPTIMIZABLE_FOLIO_MIN_ORDER)
+		DEFINE(SPARSEMEM_VMEMMAP_OPTIMIZATION, 1);
 	/* End of constants */
 
 	return 0;
diff --git a/mm/Kconfig b/mm/Kconfig
index c85ed7d7f37d..52d9d69a95ff 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -410,7 +410,7 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
-config SPARSEMEM_VMEMMAP_OPTIMIZATION
+config SPARSEMEM_VMEMMAP_OPTIMIZATION_ENABLE
 	bool
 	depends on SPARSEMEM_VMEMMAP
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 6f6f1740f540..1305bee1195a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -22,6 +22,7 @@
 #include "hugetlb_vmemmap.h"
 #include "internal.h"
 
+#ifdef SPARSEMEM_VMEMMAP_OPTIMIZATION
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
  *
@@ -693,3 +694,4 @@ static int __init hugetlb_vmemmap_init(void)
 	return 0;
 }
 late_initcall(hugetlb_vmemmap_init);
+#endif
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index b4d0ba27b42c..dfd48be6b231 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -10,7 +10,7 @@
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#if defined(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && defined(SPARSEMEM_VMEMMAP_OPTIMIZATION)
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
@@ -32,8 +32,6 @@ static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate
 {
 	int size = hugetlb_vmemmap_size(h) - OPTIMIZED_FOLIO_VMEMMAP_SIZE;
 
-	if (!is_power_of_2(sizeof(struct page)))
-		return 0;
 	return size > 0 ? size : 0;
 }
 #else
diff --git a/mm/internal.h b/mm/internal.h
index 9597a703bc73..afdae79640b5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1023,9 +1023,6 @@ static inline bool vmemmap_page_optimizable(const struct page *page)
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long nr_pages = 1UL << pfn_to_section_order(pfn);
 
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
 	return (pfn & (nr_pages - 1)) >= OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES;
 }
 #else
diff --git a/mm/sparse.c b/mm/sparse.c
index bdf23709a1c7..598da1651e49 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -301,10 +301,8 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	if (compound_info_has_mask()) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
-				    MAX_FOLIO_VMEMMAP_ALIGN));
-	}
+	VM_WARN_ON(IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION) &&
+		   !IS_ALIGNED((unsigned long)pfn_to_page(0), MAX_FOLIO_VMEMMAP_ALIGN));
 
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
diff --git a/mm/util.c b/mm/util.c
index 3cc949a0b7ed..4543f2b6ffa1 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1338,7 +1338,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 		foliop = (struct folio *)page;
 	} else {
 		/* See compound_head() */
-		if (compound_info_has_mask()) {
+		if (IS_ENABLED(SPARSEMEM_VMEMMAP_OPTIMIZATION)) {
 			unsigned long p = (unsigned long)page;
 
 			foliop = (struct folio *)(p & info);
-- 
2.54.0


