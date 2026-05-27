Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36AFCCD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459BD6B0095; Wed, 27 May 2026 07:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C226B0096; Wed, 27 May 2026 07:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D31F6B0098; Wed, 27 May 2026 07:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13ECB6B0095
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61BE64059E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:05 +0000 (UTC)
X-FDA: 84812925330.01.86DBEA9
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf18.hostedemail.com (Postfix) with ESMTP id 359A21C0002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i0SLcDOYmb1KKcrTcXT1ctGnSkxpM46qxNrxSCb9p7s=;
	b=H/HkkkM3ogCQ8i5XSSJ7jGbNSMPrVsE5QqyZyqARJC96ssnTcK0PS0JmkddciGDbMZ5qXE
	dr0sjonaRz1YeCaVw2C1nGXNVy4K8DHquX26VxYX1voJxDr1grynhxdOgWLEsUR7il4ayI
	y9XEEkIl8U7netoFbAvdE+K5Cla6qLo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880083; a=rsa-sha256;
	cv=none;
	b=vbjogD6+JDOp2tk+eyHUZecFT0YSCr85bQTrbXR1BRS3qiQ1gUFCYLDiGqjzZpAqqANa4i
	iaXqkDE6I5E3j7YRa62WiJ9Z6FfJc1R3ccEsAkVtXGyYKAxZ4veDqEddLBz2EZahwrUaag
	oDV0Ut19hPPy1cuUnZPt/oMMYGtUpCo=
Received: from TW003.hihonor.com (unknown [10.77.199.161])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gQRdN0rt8zYl3cl;
	Wed, 27 May 2026 19:06:32 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW003.hihonor.com
 (10.77.199.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:55 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:57 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 05/15] mm: add CONFIG_ANON_VMA_LAZY and folio helpers
Date: Wed, 27 May 2026 19:01:37 +0800
Message-ID: <20260527110147.17815-6-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 359A21C0002
X-Stat-Signature: 8iqjx1sba59gmx9xou79wgaii8g331u8
X-HE-Tag: 1779880083-844206
X-HE-Meta: U2FsdGVkX1/BtEgtfD8UZaKJagE0kuGHfCqc9bnrnow7xhqvqri1JtshFEG+PzbXDpPpRwWDxk+MKJB7JLB1eWJz3R/l+zwc6CozOF3A77MX+VvRq7JxttitLLKgbwBCyRXwIPI3pQ3mnJe1JIz0G/MmAYagR9E0/y1t0x7dUpimsf9yzAiVCZY+mtnOq/It+3xrGeabLpXvlTpbJtYjbbKzZcChrIy5Blaxka0eLfN80FGTyAT55ZtCXZ+ZcIKbevN5auBc9U8WyEZV+3bz+qyuaMvibP02NHlEnzYeAZWRurw2iE3WqxayT3wI+bHZCBepLugDej17VGJa56t4hz/TCO/rR00BHNhzh4odTk2Sr30Zm/psgQ3JHrXd3Pkj6l2eC12CiT/9LHDDYwNriC3i1hyFCT2m+mYa5MNkYKG65Qr66JVaJYeQ9uFG3/TVYuMGSEvtKa/n3mghbUFSWvjfA0M/OoBW6W8YPgP1OjJPevLCLTFEzDOzBBD67h6EHymZBxAm1WWf5TSPS7fJ4RyngQNyfz2vcMrOi38UhVGD8Ok7Y9KFJ787seppEuWLdL2kLinlkKOpriZNxkyGZgJw8dp1eUZNiLQiL70qKIQMY9dE+IrYx+A9ruA4Vyvhx6tpA8HaV65rAb52a1xCV1S6kV4r3ib+NyjwHkIVhQKB9uXE+ziyMoe1+dKPGgySTjhrsea2xnQhdTs7uFSBFaMnFfIqAFnA1WamGuVAX2zjuwfnApuutl9rxIpfEFtQxCSsCbRWyvi0CMHNrhiwsTw2aiQ9YtIGdtJQweJkzL04+toTvPE/B5Gl4ozQhsUN3+CE5YviIL0bWGJgMiETCLj++niD6InwtRPduUKB9PLBd1i5gj2Rl1HxsoOYIcm9ECHtQqag/S4k3uY98QCzUHM7yE/f2DnhVuKyr3vEP34UfThs3aEm+Dmp5GL+Ui19EGYNZSvphOtu/Ux2KXO
 JH4rAafH
 rjTFexNdQTffkY1cxjHNnLDd9sAMsM1gKwOIuP+2zQIRKadbwTtQhEGInHTyw7cWOg+fI3bMHof+m1RaVZzoThxNAPHr6AVH+zLDRjkT0zPMFOGUAg9c5N7Sxvlm6a4Uxrb1f5m8bbcgD/uxav4Ri2B08syujS9V8k3QurliB3BQ9G9AQZuHGgFJm9V/ESGXyL7iW+iQuvTPHmTsGSpdxABNsbuqySnwGUM7dhaHfJ1S9ScAunWyxiqU/+hwafCcV177e7LLqGqP1+/3M//HbfRfv1Kke2/e3Szd2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the ANON_VMA_LAZY optimization foundation:
 - CONFIG_ANON_VMA_LAZY Kconfig option
 - FOLIO_MAPPING_ANON_VMA_LAZY flag for folio->mapping
 - add a runtime switch for ANON_VMA_LAZY

This feature delays anon_vma allocation until fork, reducing memory
overhead for VMAs without children.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/page-flags.h | 23 +++++++++++
 mm/Kconfig                 | 14 +++++++
 mm/internal.h              | 16 ++++++++
 mm/mmap.c                  |  9 ++++
 mm/rmap.c                  | 84 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 146 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e03d816e8b9..c0cc43118877 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -696,6 +696,12 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemmap_self_hosted)
  * the FOLIO_MAPPING_ANON_KSM bit may be set along with the FOLIO_MAPPING_ANON
  * bit; and then folio->mapping points, not to an anon_vma, but to a private
  * structure which KSM associates with that merged folio.  See ksm.h.
+ *
+ * If CONFIG_ANON_VMA_LAZY is enabled, the FOLIO_MAPPING_ANON_KSM bit is used
+ * for the ANON_VMA_LAZY optimization. In this case, folio->mapping points to
+ * the ANON_VMA_LAZY root VMA instead of anon_vma. The folio_test_anon()
+ * check also needs to be updated accordingly.
+
  *
  * Please note that, confusingly, "folio_mapping" refers to the inode
  * address_space which maps the folio from disk; whereas "folio_mapped"
@@ -711,11 +717,16 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemmap_self_hosted)
 #define FOLIO_MAPPING_ANON	0x1
 #define FOLIO_MAPPING_ANON_KSM	0x2
 #define FOLIO_MAPPING_KSM	(FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM)
+#define FOLIO_MAPPING_ANON_VMA_LAZY	FOLIO_MAPPING_ANON_KSM
 #define FOLIO_MAPPING_FLAGS	(FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM)
 
 static __always_inline bool folio_test_anon(const struct folio *folio)
 {
+#ifdef CONFIG_ANON_VMA_LAZY
+	return ((unsigned long)folio->mapping & FOLIO_MAPPING_FLAGS) != 0;
+#else
 	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0;
+#endif
 }
 
 static __always_inline bool folio_test_lazyfree(const struct folio *folio)
@@ -734,6 +745,18 @@ static __always_inline bool PageAnon(const struct page *page)
 {
 	return folio_test_anon(page_folio(page));
 }
+
+static inline bool folio_test_anon_vma_lazy(const struct folio *folio)
+{
+#ifdef CONFIG_ANON_VMA_LAZY
+	unsigned long flags = (unsigned long)folio->mapping;
+
+	return (flags & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_ANON_VMA_LAZY;
+#else
+	return false;
+#endif
+}
+
 #ifdef CONFIG_KSM
 /*
  * A KSM page is one of those write-protected "shared pages" or "merged pages"
diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..c16b5d9b3ce9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1412,6 +1412,20 @@ config LOCK_MM_AND_FIND_VMA
 	bool
 	depends on !STACK_GROWSUP
 
+config ARCH_SUPPORTS_ANON_VMA_LAZY
+	def_bool n
+
+config ANON_VMA_LAZY
+	bool "Lazy allocation of anon_vma"
+	def_bool y
+	depends on ARCH_SUPPORTS_ANON_VMA_LAZY && MMU
+	help
+	  For anonymous VMAs without children, avoid allocating anon_vma
+	  and anon_vma_chain to reduce memory overhead.
+
+	  Say Y to enable this optimization for anonymous VMAs without
+	  children.
+
 config IOMMU_MM_DATA
 	bool
 
diff --git a/mm/internal.h b/mm/internal.h
index 3dbbd118a78c..639f9c287f4c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -248,6 +248,22 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 
 /* anon_vma_tree_t APIs */
 
+/* Encoded anon_vma tree type. Must fit within ANON_VMA_TREE_BITS. */
+#define ANON_VMA_TREE_REGULAR 0 /* regular anon_vma */
+#define ANON_VMA_TREE_VMA     1
+#define ANON_VMA_TREE_PARENT  2
+#define ANON_VMA_TREE_INVALID 3 /* reserved */
+
+#define ANON_VMA_TREE_BITS 2
+#define ANON_VMA_TREE_MASK ((1UL << ANON_VMA_TREE_BITS) - 1)
+
+#ifdef CONFIG_ANON_VMA_LAZY
+extern bool anon_vma_lazy_enable;
+static inline bool anon_vma_lazy_enabled(void) { return anon_vma_lazy_enable; }
+#else
+static inline bool anon_vma_lazy_enabled(void) { return false; }
+#endif
+
 static inline anon_vma_tree_t make_anon_vma_tree(struct anon_vma *anon_vma)
 {
 	return (anon_vma_tree_t)anon_vma;
diff --git a/mm/mmap.c b/mm/mmap.c
index eac1fb3823eb..2ae733eb39f0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1558,6 +1558,15 @@ static const struct ctl_table mmap_table[] = {
 				.extra2         = (void *)&mmap_rnd_compat_bits_max,
 		},
 #endif
+#ifdef CONFIG_ANON_VMA_LAZY
+		{
+				.procname	= "anon_vma_lazy",
+				.data		= &anon_vma_lazy_enable,
+				.maxlen		= sizeof(anon_vma_lazy_enable),
+				.mode		= 0600,
+				.proc_handler	= proc_dobool,
+		},
+#endif
 };
 #endif /* CONFIG_SYSCTL */
 
diff --git a/mm/rmap.c b/mm/rmap.c
index 5c4eb090c801..48c4463d8b2c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -87,6 +87,90 @@
 static struct kmem_cache *anon_vma_cachep;
 static struct kmem_cache *anon_vma_chain_cachep;
 
+#ifdef CONFIG_ANON_VMA_LAZY
+/*
+ * ANON_VMA_LAZY: defer anon_vma allocation until fork().
+ *
+ * anon_vma and anon_vma_chain exist mainly to support reverse mapping
+ * across multiple processes. For VMAs that belong to a single process,
+ * eagerly creating anon_vma introduces unnecessary memory and setup
+ * overhead.
+ *
+ * This optimization delays anon_vma creation until fork(). Before that
+ * the VMA stays in a lazy state and no anon_vma or anon_vma_chain
+ * topology is created.
+ *
+ * vma->anon_vma encodes the anonymous VMA state. Low bits of the pointer
+ * distinguish lazy states:
+ *
+ *   NULL
+ *        VMA has no anonymous or CoW pages.
+ *
+ *   regular anon_vma
+ *        Standard anon_vma with anon_vma_chain topology.
+ *
+ *   anon_vma_lazy_root | ANON_VMA_TREE_VMA
+ *        Lazy root for the VMA that first faults anonymous pages.
+ *        No anon_vma or anon_vma_chain topology exists.
+ *
+ *   parent_anon_vma | ANON_VMA_TREE_PARENT
+ *        Lazy state for VMAs created during fork(). The lazy parent_anon_vma
+ *        refers to the anon_vma of the parent VMA.
+ *
+ * Anonymous folios extend folio->mapping with FOLIO_MAPPING_ANON_VMA_LAZY:
+ *
+ *   anon_vma | FOLIO_MAPPING_ANON
+ *        regular anonymous mapping
+ *
+ *   anon_vma_lazy_root | FOLIO_MAPPING_ANON_VMA_LAZY
+ *        lazy anonymous mapping
+ *
+ * In typical workloads most VMAs remain in ANON_VMA_TREE_VMA state.
+ * These VMAs have no anon_vma, no anon_vma_chain and only a single VMA.
+ * Reverse mapping can therefore be performed without anon_vma locking,
+ * providing a faster rmap path for the common case.
+ *
+ * During fork(), VMAs in ANON_VMA_TREE_VMA are upgraded to regular
+ * anon_vma in the parent to establish sharing topology. Child VMAs are
+ * created as ANON_VMA_TREE_PARENT and do not allocate anon_vma,
+ * avoiding additional fork overhead.
+ *
+ * Folio mapping rules:
+ *
+ *   Lazy anonymous folios store the lazy root in folio->mapping using
+ *   FOLIO_MAPPING_ANON_VMA_LAZY. This allows rmap walkers to resolve the
+ *   owning VMA without requiring anon_vma topology.
+ *
+ *   folio->mapping may be updated during fork() when lazy VMAs are
+ *   upgraded to regular anon_vma. dup_anon_rmap() in copy_page_range()
+ *   performs the upgrade and installs the new anon_vma mapping.
+ *
+ *   folio_move_anon_rmap() updates folio->mapping when anonymous folios
+ *   move between VMAs.
+ *
+ *   As with regular anonymous memory, __folio_remove_rmap() does not
+ *   clear folio->mapping. Rmap walkers validate mappings using
+ *   folio_mapped().
+ *
+ * VMA split keeps vma->anon_vma unchanged. The lazy root holds an extra
+ * reference so folio->mapping remains valid without scanning folios.
+ *
+ * Internal helpers:
+ *
+ *   anon_vma_link_t
+ *        The value encodes a reference to anon_vma topology. Low bits
+ *        are used as type tags to distinguish different anon_vma
+ *        implementations (e.g. regular anon_vma or anon_vma_lazy).
+ *
+ *   anon_rmap_t
+ *        anon_rmap_t wraps the tagged pointer used by the rmap code and
+ *        provides a type-safe interface for reverse mapping operations,
+ *        covering both regular anon_vma and lazy anon_vma mappings.
+ */
+
+bool anon_vma_lazy_enable;
+#endif
+
 static inline struct anon_vma *anon_vma_alloc(void)
 {
 	struct anon_vma *anon_vma;
-- 
2.17.1


