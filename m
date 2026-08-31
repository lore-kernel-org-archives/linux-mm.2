Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B206C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63DE6B008A; Mon, 31 Aug 2026 03:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B666B008C; Mon, 31 Aug 2026 03:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2AB76B0092; Mon, 31 Aug 2026 03:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DCCD6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:54:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DE96803AB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:36 +0000 (UTC)
X-FDA: 85160802552.24.B960931
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 973A280002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XQqvN+6c;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjT0Dc9Rc0+WQPw0AxlsVqG1ooKsABjb50Q/PiKd2Bg=;
	b=HkO+HZZ4+jMLLd05CK5KPiQEO341ySWuCazJcDp4ZKcBtwki7a3hcsvh1WE4ZxLkli5k5d
	7zRFkHwv7xsGRzNl7p+Ik899pdW5sEQTDgG3tNtMIzBxe3YlKJ9P1Zbu+oacBHOVBPxnfo
	DSxumYfOajCi+PXdwMN+mei6UkS+wkw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XQqvN+6c;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162874;
	b=s9VH7ycML9x0HojTIOQW5fTLS8lu3jfr62vtytYihPwz804fCreSZ8aohEBwb4VuVa632m
	9n5u2CGGYnLzrtIWLtRRgrIXZxPAHFd3cl5lLaaBXir7paDBHYAXxIAmiItoHka93ZIH7Z
	FbyYsylM1rxj6zNVvqbH47IMzjlrk00=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84e27035206so3031769b3a.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162872; x=1788767672; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XjT0Dc9Rc0+WQPw0AxlsVqG1ooKsABjb50Q/PiKd2Bg=;
        b=XQqvN+6cS7H/cXSr5q/L3Y9vfkmg6dGdOKGgjo1UvTG9Ua04mCTaV/hEyKOBFQj5Ca
         /w3Woq2S9SooQJ8aEVpSxXJ9tXsPH1FGx0K/4M56TMDuKj2InVqmFmlsy/Ihs0GOEHgG
         WTfaWpuXi3ECuXv0OHmqls/6SgMza7voEDt6/ryh3Znbvi6fhTmpKqqj3nlPLCzYV5Mj
         r/XLL0br6VQYa3r82Xflaa4ZpylpMQOTkD0B5uecGXJu2El6O4iidUFG286oWNCoEibx
         CWacTGoMw/967qpuspIhAYM1F40ZJqEW5OXk096jl5wihvhnTbDcH+q4/VJfj/ek5M2c
         Pxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162872; x=1788767672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XjT0Dc9Rc0+WQPw0AxlsVqG1ooKsABjb50Q/PiKd2Bg=;
        b=F0MoHr/aGOtNmkOLIXqIh2hTi+JvJ1Wwdsl42pZhjFLi0OJh3x3Y0v0K3fb27QEkDB
         N7JoR+eMvqEBtQhBkV6MkpFeklyRYjl94dPZaogJ4Hd8e6goiF711c6z5zrPWZYU05P8
         JkK10qhi39GT/pm4ioF8vA+3m8Saxigy2/9SZ32NymID/+uUUYoa4R6pAfgcvPuqlvpX
         7YgFQ4LZttA9mlHfFsRK1NFhfx3v7ep6kA4KaXmtcnvCMYqe17rBNycD5zL8jNfkrk2g
         SIUwEyE83Okf2oSklhXaJ+4nn8rum4o028nb7zqJ9ZKvcz6K7viTGLzx46DftgnzQrro
         nvug==
X-Gm-Message-State: AFuF++nabdcQyUi7/XEg38lRnhwhCiqVVDDzhD/3y6zKP98TEwhVxM1D
	CN43A7mWOJDmvvouduYUXrFtmUALCR2TVk6DlLwvatg3tRHwoT3aEeMkIqALUIGWrOA1mB2EBNK
	vDFKV
X-Gm-Gg: AR+sD13hbCdCKjJqBkpdMk4Qy+m8P8qEpVPxjMHR1VdUKnZK9Z5EQE7Fy7mC3sPBxDv
	73WjW7xrulI/dtIi2Tk1+4LL5tnWnyKRrlCa1sa00Emv6XPzaCzY0r8fXL9dStF6xk8N//Y2MzX
	5Rdj2jpWhdDs3TBLpnRhNMhP5lVbp0xUOXICWc/Joqd70uyOSlbRdGKqrLeFY5Vvi8GEXpE4G7/
	CUgfE+kZKJD0wTl1NbYizDTEQXpd7Pwwb62MHygT/2oOmCcBc41VVaHnHMGyEJ7dRY0TBBh0MfM
	hUyA4ddsOEK3aOsdACA1sF4/KgaoFEMR7i8ssmQDvSzHQ2X+b8Y2ILrmIVp93zAOrb8inaOpav5
	Hg5KGIcFHorEfTWjrsHpaD0IPqNsQLSKIqXosyyeMcQa1ugf7IDT16aY8HDIGBpCW81RubhzoeG
	kMJ9nk/JYAlGaOhl/E+J2JQBPYut+JabMrgB2Vazdj8T4yNl8mMdgLAHcUMprhCFahAGgggSAKx
	Duq2o5cpUCRu+avixN4k0gV
X-Received: by 2002:a05:6a00:3c8b:b0:857:726d:2e98 with SMTP id d2e1a72fcca58-857726d2fc5mr22906110b3a.21.1788162872037;
        Mon, 31 Aug 2026 00:54:32 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.54.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:54:31 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 01/11] mm/sparse-vmemmap: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
Date: Mon, 31 Aug 2026 15:53:32 +0800
Message-ID: <20260831075342.57563-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b9ntxh1pitz1w8ghzwihds4f6se56478
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 973A280002
X-Rspam-User: 
X-HE-Tag: 1788162873-751510
X-HE-Meta: U2FsdGVkX19s7qGKZ9NUtkBSzx+yE4LmLeEmigphV3X6w/uOpwygzG4PEnHjIRgELwmpXQvrbwJD5W2aion9JbBa0rMVJcCR7wRamzkVp5fkl56qhO+bRoYdxbMPb5e1QTmNiKWvISJyAtmP3NZWBbN/7nwJvmgOK+wHuacj/za+/hVb4FJ5H1wgii3ZHgjJBUrxeTC75bgnV0RH4TyUPTX1jlHvMYDEW6wTe+3eCgn6cUdPYggW082JFK/8LNrEV67ToPprJnR2WSu3r2v3UMVDGV0Puozs+KbJmM78ddLcEMxK8Y+/iF74yVLhMd+e2F9TIaXyDQs3ftMUHnmmBpRaQqVB0Wn6mQ/YTaonnPVaksifgNLmHm7bZm/2VAbqTO7snWSNhMTCgyMo45tcijyK9JFTXfyt9m9E+51ijTeGu8vpxSjum2nXV8P3Rj38NjM+0W8MYRo2ruFaejNsjXZmD0LmhSC3n9QxWjZT9e/RiPlez9QENWaB0F6mwdOlLgVojR572mcbfaqPozuh9UvKM5qgTKqmoDY+t5oho6Fm4uOLaT/+MwkAr/dwQqC9XEsLpGc+y0mmFgvNVloQk0NjxUTbS/bsXbn4hcuUlGvni1oDikZFNsQ+8bgjfb8crQKGc2APlkwwHWWCuBlNnOQ128dOqX5tySUCB5iy/CYKWuN9hRSYf3HjFzkFG5077agUnICzPwnvwsMYUwNpdSZRDa3NImZOAJ8rk0a8ekC7lGZpCB7GovX7zMHuB1ik0RD3A2afyXA8HDWe6roEkBiiayqTQc2CkdWgBYSVQAQFFQ5UZ3N0eK13PbN3d3mSW0yGNtRBEOpXDxTsAt4KreY9uadiokqRKavTnpt9scaGfTda7k9UaDNiWucUNajV87XBpvtrJaazCg8Z+YKHdxvR8XF/GJJlkQhAu5u9m3SpdOI1C7e8YZLKwTSk2pababzxaHkXxJoiRBBV+vo
 9QDgPhPx
 6IO3IrEWKAfoDkn1esy+2hUb066ajrT7YSc2o1JIijaKvKxrD6m8z/7/0nPGq28EO0/X2tx4bCLry7ktfK9DYhR3dAkCJ5IaTAvZloDfwCCinr90hnHNlC4pHVjoo7IXgnEY4NOhT/DqAhGBn618shfDguzxVpTYq5LBlXgF4DT/7jUHEEuS2SCBHXziSQdFIEvCXf6PK/OOh5NYM5KDgMKBJUivNPBR8sMuZNup5Mu5fpa91q2D8pcpfqMTqUOP+ykvD1AGnoutfmbrdHnARLsfksx+9x70BajxhsZnGzwtYIM/43/J1aczPR6uRETLaR1mrP035sZQt0Y6sKHD6V9VGbyxBg00JEnIjCcBac/rdfS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The section-based vmemmap optimization infrastructure is still guarded by
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it also can be used by device
DAX. Introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION as a common config
for the shared infrastructure.

Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
DEV_DAX when the architecture opts in to DAX vmemmap optimization, and
use it to guard the generic sparse-vmemmap state and helpers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  2 +-
 drivers/dax/Kconfig                           |  1 +
 fs/Kconfig                                    |  1 +
 include/linux/mm.h                            |  3 +++
 include/linux/mmzone.h                        | 13 +++++++------
 include/linux/page-flags.h                    |  5 ++---
 mm/Kconfig                                    |  3 +++
 mm/sparse.h                                   |  4 ++--
 8 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
index bc3e549795c3..5f8424eade2b 100644
--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
+++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,7 +11,7 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
-#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#undef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 602f9a0839a9..85ad4c135cdd 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -8,6 +8,7 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
+	select SPARSEMEM_VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/fs/Kconfig b/fs/Kconfig
index d1c210c6508f..9b32ce79cc80 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
+	select SPARSEMEM_VMEMMAP_OPTIMIZATION
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a9fbe26536f4..edadd7549b72 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5188,6 +5188,9 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 	unsigned long nr_pages;
 	unsigned long nr_vmemmap_pages;
 
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
+		return false;
+
 	if (!pgmap || !is_power_of_2(sizeof(struct page)))
 		return false;
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c9ae7991a8b2..e9b54ea0eff0 100644
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
+	(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION) &&	\
+	 is_power_of_2(sizeof(struct page)) ?			\
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
 /* The number of retained vmemmap pages with HVO enabled. */
@@ -116,7 +116,8 @@
 #define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
 	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
 #define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
-	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
+	((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 &&	\
+	  IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -1155,7 +1156,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
@@ -2019,7 +2020,7 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 	/*
 	 * Normally, sections hold regular (order-0) pages. However, for
 	 * sections with HVO enabled, this tracks the compound page order
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index ae2ebaed6d4d..de3c06062bc6 100644
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
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	return is_power_of_2(sizeof(struct page));
diff --git a/mm/Kconfig b/mm/Kconfig
index c1ddf59c0d71..b5f8372cd164 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -461,6 +461,9 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config SPARSEMEM_VMEMMAP_OPTIMIZATION
+	bool
+
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
diff --git a/mm/sparse.h b/mm/sparse.h
index 049272aba84e..b408d15baf7b 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -10,7 +10,7 @@
 
 #include <linux/mmzone.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_order(const struct mem_section *section)
 {
 	return section->order;
@@ -72,7 +72,7 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
 
 static inline bool vmemmap_optimizable_order(unsigned int order)
 {
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	if (!is_power_of_2(sizeof(struct page)))
-- 
2.54.0


