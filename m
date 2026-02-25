Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78C3FD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36E216B00CB; Wed, 25 Feb 2026 11:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322F96B00CC; Wed, 25 Feb 2026 11:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E84E6B00CD; Wed, 25 Feb 2026 11:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 086DB6B00CB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1FEF1C853
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:51 +0000 (UTC)
X-FDA: 84483527982.06.F62AF02
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id EE315A0009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ON7ZwqsH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3qCSfaQgKCMEqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3qCSfaQgKCMEqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037290; a=rsa-sha256;
	cv=none;
	b=V1Wv3NQ1d1fsoBjZ6rVn0W5CqfGuyW6P5SENung4sGpnJ6g6lmEBbAarTW0TsjCF1k0wOg
	AuEqls4bum6Zq6AQWMK1DKuG+Y0LlUUrhbp6znhi06t5ayV3/iHSxLc+ctrtBy/IVFWuf4
	115m8Z5JllFcIicgtAVPakbg5e5OT4U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ON7ZwqsH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3qCSfaQgKCMEqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3qCSfaQgKCMEqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPavfHtzfndzWIXWdPBl+t2V385Pl6oyLSG23Scoa5U=;
	b=vmDCwJvWLlnBwS+9CTe1WUsrl8xG5Ux7TIi5+kBNceB0F/UDgNkG+9jYoh5atpdvt2/WQi
	2g6JsaUHmvvf57W2Qm2evzNLbkvk+8T+UtoTVRDeCkhrD3cdIKOJvG79iUw1elFCI0LYWT
	wCmSMT07EPgSuBfr1MteSHOhDC06SK8=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8fc132b0b4so174530566b.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037288; x=1772642088; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPavfHtzfndzWIXWdPBl+t2V385Pl6oyLSG23Scoa5U=;
        b=ON7ZwqsHK3VLUsQsgkXD0VEjgM+BiuQYQ7LHm94ze366SistqA8/+hNkWT/r8zwRUU
         mdzYNncKdMw10EZIexu2mhLX1M4+OjkpxA5JmxRNVuCAMrufbuJlrSarBRp3E9eKJwBv
         8QwdYy7GSjiZzf0w4rMVc7sG6SzZjj1EUDqx5mxu739HpkKV+9oJdLAb8gCALnCzLEAj
         Zfp0IUmkAJaj84K9vAXwG3txHhDSCwsc3Z7aI2ZWuNxllbQNWiqMNDEArhECJcSVhzBq
         KgVG4dRiveS9ItVPgDIgXkaWRHcIV0/BjIJd2FJfsWHPx0fMrzQPjtdbC0tkFco2n5pJ
         zrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037288; x=1772642088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPavfHtzfndzWIXWdPBl+t2V385Pl6oyLSG23Scoa5U=;
        b=AF5wJszDJJ0hoNEcsVkUhUlRg5ru01YfqHpvJIK90JUOtdTILR891CtHf6tluziVRi
         95iJrokv+28VQMiCTKhZHVBhMujLgtyjCski1fNeunnbnfgJhOFuKs1up9Y06vYer2iz
         l6afSE/mMZwusncEvzI1Thtfqc8mLQ1npsoe6BcPOm7EroNs11FcyjnXArKfQhaLhqay
         G5MEdMO8LAMOEBxYrIlN7lYcZ9M1v/629cRmFKQ+5OU6sg/3A3M4qPswN+hsSlGdAD3t
         0tagmjFjP5wskZyMB6V9N4F7xLWoRoKqa/qdIVeanuTmyixDm00EmIRhGgagS9Rjyhgl
         DSDw==
X-Gm-Message-State: AOJu0YzITxsbHl+jUX8q34cx9TtEal+oBcRn3akIcG1GLA8G1+ERI4cg
	B9sFiWR7Q7rMdpVyItms7ouPrblPbFAKS8EEdfM6gPafWXzsBfDmUKRcMvm8mGsdGm/KyAyoZYO
	as3ea2tD12N7LLg==
X-Received: from ejdbx6.prod.google.com ([2002:a17:907:fdc6:b0:b93:4df6:8a2])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:8c5:b0:b80:3346:496 with SMTP id a640c23a62f3a-b9081b98d24mr912485466b.42.1772037288223;
 Wed, 25 Feb 2026 08:34:48 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:34 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-9-e8808a03cd66@google.com>
Subject: [PATCH RFC 09/19] mm: move migratetype definitions to freetype.h
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE315A0009
X-Stat-Signature: fuj7rw3tipiej8zwqh4org37tm73btjq
X-HE-Tag: 1772037289-622512
X-HE-Meta: U2FsdGVkX1/jYrPUF96b01EcX8dWEBrOkpc+sn8IVo0OgBY3xUqwluPmQdCClm1Gh+Y3gmfiUDnE/kmo3c3eQ62/BiORHlgHssnt6ajKMhejTao4uo7VyiJc/UCdRCwpayx78JvG5sdtmFtPFojD9Z6hs0I++JB2crqbyLAQkcA+b/+aG0oXG/3uIFYwL9CxsVoYDuRKgj6blPRyOgAd9Nd10xGuR1gZXqNhYuU33k0nkUl/xr3j3QG3MEIx+mOvXNX2NH2gaCjg+nrgPqVSkEg+p1piw98fOF4K/dYmyDraXas/HveXniv1xBCgpWbDqWpaCxbrROpPoMwj7CXleBSvcpdey8wEZQTWfEVlwo2bJYgpY6dz8mW+hlbh6QAkLONMTlzvgxEzOV1HxnxK6IEH+zMXof/3IEtmM7CpkLh15ifDsxaCY88Sh0DVImnBNTpwadhd0Ms2wX5gV4DV+/CE9eHnLDP8a4oUN9K3ASeIXe3xC34SlJeB1mtDkw3GpLwCxmGONvBocUG8vxtwiBNhkEqq0xAntXwDjcLje8/xaWxW0nh+yS7f+mKRTsmvPyIRNoTx8WDNCk/M68ClvWA8yptVrMI8CnyjEvIsgGfO0EotH06eG3+DZckKK2tkcv+cTA8e6YH1XE9ommwPIZ/50nAHFsbjAaStxY+77QEiT9U/1PiexFfb98A8fxOemiMhkvI1cfnp6qWLtWIOR1WyaGt4+fSqwISvZzscCaqplBTuVu+N6Nz78bJboANil7dpPS6aTRivuaURYV/cJUSi4e9mFUEbsVro/AoVtYoKCaK5bkEaOUpM5aZ+YxlaJcNR7qMQ5pqEe1jjCPizv07xDMqIjzfqjXWHbDYUFAssTviDWkCJ40uYSsDEL1vai9bOWQ8XI7Op9O4VpmBWXFcdtDpmQMv4iIBCrRU4aYP9iAXyI69Nh2V6pfZBqVj9kLvNdevsyl/qF0C1ICo
 ren9byO+
 df4DN2iNHAQRBkk9qRDuhiFBjMCSBUGRk9hXtCZukaSuTUiikVOM0rXOKIBGtJS1UvGmYcI3NzMFE3fuKBAOgMtxTRq+ClEOcGdqt7wrDfvWcc4om+EYdKS0uZ63bzNLNZlC1VphHOX2th7rB19Wtfbc7Jva3ZXmcftknECn1g0hRpRwTmH3QTRMY+U+6zs/S1kmUX5xYFlAL6F3HZ0suZTLV+bpRfmZRVjR+Iz5PMrh8McDkbFZrDfQ9N9JLCBaYkSZGUYT4Il+/bYoKt+WpqYTGIgfw/bGUa9mQU3V560EeGdu5okoJ3RT/PfyUwyMo/HtM0imkh3UQ4cwQ+MLAbagsz6ADkulT5coJZCO7yvGOdo3QFZM6CiTukVs0CIIr/RsMV+bRHaea28ODnoqae0IC3/c9+5fBhAE46HhiI9MjIWf9Uwa6HZo0DvRCEdfO3PzllO5PByVvmqtZgseLpG9gFIXuhnxvPjNnpDLEZ+mAEiqlO5tPaO11vt/aKt6FNHLxtTndXsNCUB6PLXIMP/LeWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since migratetype are a sub-element of freetype, move the pure
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
index 66a4cfc2afcb0..301328cbb8449 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -62,39 +62,7 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
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
@@ -103,27 +71,10 @@ extern const char * const migratetype_names[MIGRATE_TYPES];
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
@@ -131,30 +82,6 @@ static inline bool migratetype_is_mergeable(int mt)
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


