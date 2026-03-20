Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 346921099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77F36B00D2; Fri, 20 Mar 2026 14:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF9D6B00D3; Fri, 20 Mar 2026 14:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEDA6B00D4; Fri, 20 Mar 2026 14:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AAE96B00D2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43638B8114
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:57 +0000 (UTC)
X-FDA: 84567265314.06.3C10F39
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 735C880004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f2D5koDG;
	spf=pass (imf30.hostedemail.com: domain of 3uZC9aQgKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3uZC9aQgKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14rGLwIJsIU7kDdMmmS+f3PtwDgFodk3F7eGnVzIexI=;
	b=M2MvPDGlbuFysbFd00+C5y3efo1btr9sWw5oK0eXuMEEeIvVeacccPb0q6pYfA8TGfnrem
	C2NeIHKL09BYIbdYTN+BlDIbxFVCHC+QnAztkuo4wBMuW8ueEGC7K1M62QdCXTLUPAf5+F
	wjnK5AqHQz+fqjVYfTLMTDFlWT835So=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f2D5koDG;
	spf=pass (imf30.hostedemail.com: domain of 3uZC9aQgKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3uZC9aQgKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031035; a=rsa-sha256;
	cv=none;
	b=UOKkVQCIhLShc/xK13Q17O6X1tSu8eQiEuwnsykpxFW3xADJH1IJcxG4w75TCL9DdV5tnb
	UrNuMuovySXIcN5iugJrmui4R5Jb4DFaqsrCB18c5HNllR4lRbDSv8MST5Ad+MIAJBBafn
	P9J/78tVDFzYDrApmbMVXJW//iHZUG8=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b42cd4becso1492958f8f.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031034; x=1774635834; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=14rGLwIJsIU7kDdMmmS+f3PtwDgFodk3F7eGnVzIexI=;
        b=f2D5koDGv2QbFsTupYXIBCBqLIN6RxoqeWp5dOv5e+3rm0lm7fg6P24atL0VwQBs/i
         2WZ1GpWspCfPeoSsCEc4gy8S0rso85vQNjbG04kzFG9FtpZn/WmoqNik9WNaDTUFCgVq
         3P4j+p0UEkFuYbSsgRl0XTWaqdMmVQzvNUIpryNkmCiU/uLSK6w8a6yKsRdiayYP90e7
         /3u8uAUuKTmv+kFaAYsk8O1Vrhf/NKTClwdywMzm8S2L71YQHXT7YJU1VD6owOgbdTa5
         zwlSq9MBuA2PrF7kStJrsiAqBMhoDkXfierD2e4bbvrP+5n/iAFTV5iCcApOjBfq02W4
         x3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031034; x=1774635834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=14rGLwIJsIU7kDdMmmS+f3PtwDgFodk3F7eGnVzIexI=;
        b=exmmPkoHfYGfKipL8mbXYKXsIDpp5bo4VEm5t3V3dmKBxHKuvKMQC51QaNInRY2Zz3
         lvY4NlZ/y+eWOc5nCJTy3nwEIL9j7co0bTw5RZnjPan74x/kiwiwlEfDfzbZFGWDHMUC
         0fuejMAmrnefP0d+Fmf7bZlm0tK3SRR+BR7DfDCXieE8sIeJLDCF4FHknZc69DRPV/Cj
         7PqG5wFHvy+KGevkZb9FytjFpKj8WqnQ71NW3CJW4GOafyDpCNBF+7QalW6wMOf480BF
         E6Zv4eTh0IOf9MHwgHlhchAyLRus2zPhaPuuB/suWJicjcVz2wN7ePqXGEU6ptb2Gz6u
         HIPg==
X-Gm-Message-State: AOJu0YwzUs61NFLapsK7DpkTEk9haMGbEPsZx9b4x7bsiYbvu7214AGa
	FLp6f+YlvlRi6lMT9FiZHl+lBzTXOl4XoVqV2U0zctHDSG/y+URXL2KMMJiALoFTZ/YmtZ9/yqD
	qiuy3TJNd2ylpmQ==
X-Received: from wrpr5.prod.google.com ([2002:adf:f705:0:b0:43b:4410:e055])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2d86:b0:43b:5557:ed9d with SMTP id ffacd0b85a97d-43b5772991dmr9595848f8f.25.1774031033776;
 Fri, 20 Mar 2026 11:23:53 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:35 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-11-28bf1bd54f41@google.com>
Subject: [PATCH v2 11/22] mm: move migratetype definitions to freetype.h
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 735C880004
X-Stat-Signature: 6xsd6ugg881fux1z8khudgaywfc1gn4o
X-Rspam-User: 
X-HE-Tag: 1774031035-811766
X-HE-Meta: U2FsdGVkX19+fSVLubzPLmNIb/nn8+Z6bPcwJHPPfCCUDZ2sxIzC/HbCg+gR0kgCatlQnjDFrO+phxT2hmoJK84efxygltQrKceBV3qvMYrZmp6lADcBf8v8nBcowjxRP20tcHsX0LxSa3nZlUrLI3Sx1YHUwVz+s8/g6rylVFDIwZOx0N9oCr/OL/HCq7fnvlHiZSgRF3xpuCwKo9XecsGcpHseH8RNJ5be8bT4qzf+inWP/+86x45Qcy6qAAgP0YiKt65ZP6Uq+DO8+tEgDowU7SImmZQVyB+Plyh7AEKVeuK+Guf8aipJm4n6atbd8HoRTDUBib0vLRZdMV5z62AdOv3GiyHUD19ZD8Ej/TXYHpBMp4UnpGCWExdowoNjd3DNXqATaKOEq/AUNuc0/RMJ+lLV2jnZGz2M8rxHtw8biIAq4csXuNSuIdBZ+seo81tHxw6Eur5JeBJCawh2Aog1SWoQXcZWB349dFNNL04Uw4XognXc/3F0Yu4xS95QNRZZW5xVPV04dDppyz/aE4wdLjIYKUnSmuWM3CIP2kZVzLgnmwd0ZwE9sj/mTBgSc0THP8G8ZIKDgkVJiZUn2a49B8UaUIQ57n4vZEEmvLY2gSeFJQfxsHtOzcDJ7+fs/B+u+DzEZNv+B4Hgn03i/WIGpOjDGW2NduIxfxszORLgF/+2QoXRZTh9/PvbkT54xbDgrg8dFaiSsuOYMGVhr8y2xVdG1lpRANOu7ixboRtIYMbesWxErXRyYrEg2UzQD+9P4zLACG7bmne/NJA0gqvuClz/swj5v0CmSlAVwBQVhj3uYfPstih5Vw4EqdI3x/KWuB8T91jZbft4rs0As7445xdBf2sSmUw8PT9cZkPZqAs5gHitTVSf9QtZyHsfK40OidDD8CQYELANs5dQuTur2u6q6pPaQGQuy7egwJ2ZVcHyVLd4gh5bPJF4gW5hLid8Bzso27/xyddkm7k
 hR/D8E81
 M/lT7R6KjHIEd58/K+frm2j04szYpD64ZX/ltfWX31DihJJdu6h/IUsqTNjwYc04Gjnop0LpQGkbSd39PMhDW8Wces7BLyQqaQucbBGyx3QSOr7YB2erVBRmOvanQ7PTeNuAtkVfRVRweuNtYDESBYwlSJXvK0FiUJx8RuP0dZDdEBz39B63DfLoKPQPpg/vzAgsiPZGwoJ8jHAt2tELWotUhH5n4BLwjgbZACQG9WykKPCzo6j11nVU1yZ/8ve7t/rQf51fOuib0DTK2qyUZBYoZWjJ27UVexIJ3h6WbBVkkQ6c26FcHITGMfupUD/Hct6UxDgl7Waw1LdNT/T1bnDA/FC1eiLefvUZOrh10a5pfpM/BdnmPyZxWYwDzLMRghwWH/BI3Kvewy2+1erfmCvAe6H7/Neo6VjYsNxvjt0rJsufauwzXIM85X/fFBIq19Khp3y4Nytx/5sni5Cd/J1G43iDg8rW/vQTp4wVAM3FvKB6f38MDNW2k1Qmoy0u+izuV/nd5ai9AY+8DQo5LXIiYuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since migratetypes are a sub-element of freetype, move the pure
definitions into the new freetype.h.

This will enable referring to these raw types from pageblock-flags.h.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/freetype.h | 84 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmzone.h   | 73 -----------------------------------------
 2 files changed, 84 insertions(+), 73 deletions(-)

diff --git a/include/linux/freetype.h b/include/linux/freetype.h
index 9f857d10bb5db..11bd6d2b94349 100644
--- a/include/linux/freetype.h
+++ b/include/linux/freetype.h
@@ -3,6 +3,66 @@
 #define _LINUX_FREETYPE_H
 
 #include <linux/types.h>
+#include <linux/mmdebug.h>
+
+/*
+ * A migratetype is the part of a freetype that encodes the mobility
+ * requirements for the allocations the freelist is intended to serve.
+ *
+ * It's also currently overloaded to encode page isolation state.
+ */
+enum migratetype {
+	MIGRATE_UNMOVABLE,
+	MIGRATE_MOVABLE,
+	MIGRATE_RECLAIMABLE,
+	MIGRATE_PCPTYPES,	/* the number of types on the pcp lists */
+	MIGRATE_HIGHATOMIC = MIGRATE_PCPTYPES,
+#ifdef CONFIG_CMA
+	/*
+	 * MIGRATE_CMA migration type is designed to mimic the way
+	 * ZONE_MOVABLE works.  Only movable pages can be allocated
+	 * from MIGRATE_CMA pageblocks and page allocator never
+	 * implicitly change migration type of MIGRATE_CMA pageblock.
+	 *
+	 * The way to use it is to change migratetype of a range of
+	 * pageblocks to MIGRATE_CMA which can be done by
+	 * __free_pageblock_cma() function.
+	 */
+	MIGRATE_CMA,
+	__MIGRATE_TYPE_END = MIGRATE_CMA,
+#else
+	__MIGRATE_TYPE_END = MIGRATE_HIGHATOMIC,
+#endif
+#ifdef CONFIG_MEMORY_ISOLATION
+	MIGRATE_ISOLATE,	/* can't allocate from here */
+#endif
+	MIGRATE_TYPES
+};
+
+/* In mm/page_alloc.c; keep in sync also with show_migration_types() there */
+extern const char * const migratetype_names[MIGRATE_TYPES];
+
+#ifdef CONFIG_CMA
+#  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
+#else
+#  define is_migrate_cma(migratetype) false
+#endif
+
+static inline bool is_migrate_movable(int mt)
+{
+	return is_migrate_cma(mt) || mt == MIGRATE_MOVABLE;
+}
+
+/*
+ * Check whether a migratetype can be merged with another migratetype.
+ *
+ * It is only mergeable when it can fall back to other migratetypes for
+ * allocation. See fallbacks[MIGRATE_TYPES][3] in page_alloc.c.
+ */
+static inline bool migratetype_is_mergeable(int mt)
+{
+	return mt < MIGRATE_PCPTYPES;
+}
 
 /*
  * A freetype is the index used to identify free lists. This consists of a
@@ -35,4 +95,28 @@ static inline bool freetypes_equal(freetype_t a, freetype_t b)
 	return a.migratetype == b.migratetype;
 }
 
+static inline freetype_t migrate_to_freetype(enum migratetype mt,
+					     unsigned int flags)
+{
+	freetype_t freetype;
+
+	/* No flags supported yet. */
+	VM_WARN_ON_ONCE(flags);
+
+	freetype.migratetype = mt;
+	return freetype;
+}
+
+static inline enum migratetype free_to_migratetype(freetype_t freetype)
+{
+	return freetype.migratetype;
+}
+
+/* Convenience helper, return the freetype modified to have the migratetype. */
+static inline freetype_t freetype_with_migrate(freetype_t freetype,
+					       enum migratetype migratetype)
+{
+	return migrate_to_freetype(migratetype, freetype_flags(freetype));
+}
+
 #endif /* _LINUX_FREETYPE_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c456ddd1f5979..af662e4912591 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -116,39 +116,7 @@
 #define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
 #define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
 
-enum migratetype {
-	MIGRATE_UNMOVABLE,
-	MIGRATE_MOVABLE,
-	MIGRATE_RECLAIMABLE,
-	MIGRATE_PCPTYPES,	/* the number of types on the pcp lists */
-	MIGRATE_HIGHATOMIC = MIGRATE_PCPTYPES,
 #ifdef CONFIG_CMA
-	/*
-	 * MIGRATE_CMA migration type is designed to mimic the way
-	 * ZONE_MOVABLE works.  Only movable pages can be allocated
-	 * from MIGRATE_CMA pageblocks and page allocator never
-	 * implicitly change migration type of MIGRATE_CMA pageblock.
-	 *
-	 * The way to use it is to change migratetype of a range of
-	 * pageblocks to MIGRATE_CMA which can be done by
-	 * __free_pageblock_cma() function.
-	 */
-	MIGRATE_CMA,
-	__MIGRATE_TYPE_END = MIGRATE_CMA,
-#else
-	__MIGRATE_TYPE_END = MIGRATE_HIGHATOMIC,
-#endif
-#ifdef CONFIG_MEMORY_ISOLATION
-	MIGRATE_ISOLATE,	/* can't allocate from here */
-#endif
-	MIGRATE_TYPES
-};
-
-/* In mm/page_alloc.c; keep in sync also with show_migration_types() there */
-extern const char * const migratetype_names[MIGRATE_TYPES];
-
-#ifdef CONFIG_CMA
-#  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
 #  define is_migrate_cma_page(_page) (get_pageblock_migratetype(_page) == MIGRATE_CMA)
 /*
  * __dump_folio() in mm/debug.c passes a folio pointer to on-stack struct folio,
@@ -157,27 +125,10 @@ extern const char * const migratetype_names[MIGRATE_TYPES];
 #  define is_migrate_cma_folio(folio, pfn) \
 	(get_pfnblock_migratetype(&folio->page, pfn) == MIGRATE_CMA)
 #else
-#  define is_migrate_cma(migratetype) false
 #  define is_migrate_cma_page(_page) false
 #  define is_migrate_cma_folio(folio, pfn) false
 #endif
 
-static inline bool is_migrate_movable(int mt)
-{
-	return is_migrate_cma(mt) || mt == MIGRATE_MOVABLE;
-}
-
-/*
- * Check whether a migratetype can be merged with another migratetype.
- *
- * It is only mergeable when it can fall back to other migratetypes for
- * allocation. See fallbacks[MIGRATE_TYPES][3] in page_alloc.c.
- */
-static inline bool migratetype_is_mergeable(int mt)
-{
-	return mt < MIGRATE_PCPTYPES;
-}
-
 #define for_each_free_list(list, zone, order) \
 	for (order = 0; order < NR_PAGE_ORDERS; order++) \
 		for (unsigned int idx = 0; \
@@ -185,30 +136,6 @@ static inline bool migratetype_is_mergeable(int mt)
 		     idx < NR_FREETYPE_IDXS; \
 		     idx++)
 
-static inline freetype_t migrate_to_freetype(enum migratetype mt,
-					     unsigned int flags)
-{
-	freetype_t freetype;
-
-	/* No flags supported yet. */
-	VM_WARN_ON_ONCE(flags);
-
-	freetype.migratetype = mt;
-	return freetype;
-}
-
-static inline enum migratetype free_to_migratetype(freetype_t freetype)
-{
-	return freetype.migratetype;
-}
-
-/* Convenience helper, return the freetype modified to have the migratetype. */
-static inline freetype_t freetype_with_migrate(freetype_t freetype,
-					       enum migratetype migratetype)
-{
-	return migrate_to_freetype(migratetype, freetype_flags(freetype));
-}
-
 extern int page_group_by_mobility_disabled;
 
 freetype_t get_pfnblock_freetype(const struct page *page, unsigned long pfn);

-- 
2.51.2


