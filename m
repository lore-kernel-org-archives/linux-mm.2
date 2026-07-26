Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6077C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F8C6B00A3; Sun, 26 Jul 2026 18:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A4A6B00A4; Sun, 26 Jul 2026 18:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46CA6B00A5; Sun, 26 Jul 2026 18:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7186B00A3
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E56161A05CA
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:42 +0000 (UTC)
X-FDA: 85032355884.12.B38A5E3
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3D7DAC0004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CAZNInZD;
	spf=pass (imf10.hostedemail.com: domain of 364hmaggKCPAbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=364hmaggKCPAbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJ016WzmOmjAhyGBWYX+UBcW2OEU4+qqQQA/OudZHpY=;
	b=q2Lu/lwO0Pkqx6tCjp/Im4Hy0qIVJc1wK9MMsP1+BsMgZoGoyKjlNuDCLIiVtEJKAnd1KM
	XgvYCfg3W9JnN0EaN/DcN0Wby2LrZlad+f/EklapIE6DG9kRxdquREbibnvUF2ob67Mvgw
	qkF82SH+wdD9eRvaySNeTww0OrigHq4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CAZNInZD;
	spf=pass (imf10.hostedemail.com: domain of 364hmaggKCPAbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=364hmaggKCPAbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104621;
	b=YU3txva959jWvW90gAOPrYLbnSWHM1cHXOl4/78XvYQXWdCHs5N4xjB8Wjlv05VNCjqavz
	TrcHFM280tyKbXcBB+EtZsnreMIgG/tp7R/ud222sPHQQ3h/UM3KzXfgDhVdCdesZ8fXA/
	sQOwaXPfaaB92HwQeSuHG+5yilTxJ0Q=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c167e032f03so188993966b.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104620; x=1785709420; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gJ016WzmOmjAhyGBWYX+UBcW2OEU4+qqQQA/OudZHpY=;
        b=CAZNInZDY/H9KayyZCi4b3fz+9ZTe5JuITgJKhJR2i98aKMxkbEX/dqA6PU9+i65xT
         NU8NmHjPsi1TVdcGV+M34I4YssVhPSyryCBED0zEpmizj35/Bjw3hJYA/CoCXS2RNwy6
         zSUsCE5qVXqikIJib7cMpFb/e5gI2VjNTaukyKPOVxv9Gvc33FuIEGjbZz20HzhxwttG
         E2F+GYnqEF2aOQ5yULYeMtLf/KKnPevo7hNWnFMRZTC1W3bc4raG7XE1O75Ur42uISzJ
         oO8EUYQg5ZKVJGqFEK+LiKeVpOwpGgbFdKorMz+yROEeOW6xhaAUVA1BqCvPkJsjlbJ5
         EyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104620; x=1785709420;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gJ016WzmOmjAhyGBWYX+UBcW2OEU4+qqQQA/OudZHpY=;
        b=GfXNybB/lNuUI5I4AcqCpHr1EgZJXLe1lLnErYqRiTO+PkI2vCph+YcGFNNzk0JcAE
         8LESedERjvUZgsDDxv7b4PdG8Idd/B31TTg2yE2XtEZYtezgGUnpukUhYAOOvwLwvmT2
         E0nXBgCN+6JZu3zvSN0KcVEcZFqpRgHEvNWoA09ISDrDHsWr+wqCsjB8OFH6QOMOwmOy
         YlB+cTlK8Cb5f2kn0XgwXaA0ccnraB1WG6ku2H/7IUbK0ge/bc9fkdNyT9CZluYAaMzM
         Ek8ImSF1V6BgC6XuLyl/A4CpdpY8r0jVO4tcQ48ST0DtnyHPsyZg3AuFm77mlkYAKATF
         OmZw==
X-Gm-Message-State: AOJu0YyS/rsB0xJdR7aklhbOcvH4dnd85wWiPSrFGAEmCtx7Er7LTE5t
	B/7pVVMd6tbt3kS7/i1zwon+Sc2WVZEAIF+RQgomLyc4RE6jO6alKBztOieJyyBB/x0an1cksHG
	yM/CObF08xTwZ2A==
X-Received: from ejbce22.prod.google.com ([2002:a17:906:b256:b0:c16:114a:da6e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9622:b0:c17:40e5:3d7f with SMTP id a640c23a62f3a-c1f1f4237dbmr272268266b.56.1785104619456;
 Sun, 26 Jul 2026 15:23:39 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:47 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-14-6f5729aa9832@google.com>
Subject: [PATCH v3 14/26] mm: move migratetype definitions to freetype.h
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 3D7DAC0004
X-Rspam-User: 
X-Stat-Signature: wq6q5apcebrrkter9phk4popmcci5pwn
X-Rspamd-Server: rspam04
X-HE-Tag: 1785104621-151908
X-HE-Meta: U2FsdGVkX18/rJGdEnVqRRmCtFEyA6Gd1WM5xezyxfgoel7CP2X7W13MKmMIvcokJUM75/wHUSuYueVJhMumKH+cWbEcjobucYhehCTqskC/trj7smbpDZg9CgLCIr+zycTDU5oRltGU0l3jhH3/eLI1sWGkOW6HNHuyPUfyo1FeD6OhTR8gs1tUjeNp3ZGmwlRpVlpHEs8i7YJAPZSD9wxS3F74fsf1STpOVaZIkvcWtcjtxbKfCR2RbdP/ox5xrwiaKF1rguEVdozdbi0WBa5xIMFKPbxy7Y7d3y66398IscjCTnXQoA7IVmnk/jdcMfizZ7BwT/I8PLgUl0CI7oTvS9QwOBX0GFdD/thhMDUCQSF+biLJIbRQCEi62iGBoh8iA/SkO8wJyHb+cHyEoyvz51Mi/siks148Xen+ghZn0KZ/duQHeb2cCViYzrQc9j7t0maXhXK6/Homd0XhMf345zqbuzu/gBgchxhjmfJ+vez+wIAKDwM4QkEVWHwQvjlwG0raCbJZ/5XZ/6KyDgjxm2mhD694YVMhf/P3kWICzL94PmsRxas2CCxKt0vQkl5eUUImt88w5S19Z8cjnDhm8xmQqOgShAaJEv7OOtjDdiwECIPl4dzTNh0xUS/glTqvR864TOBGoj/GmWCBb0KcASouVVsdqIy7CkFRDbi0LuN5J9S+xqonWeNL7gn028VcODf7EvcAoa0kjxFaaB1Sr/25VvPZyL7RUMWV3YBgceKD0yGid6VPCDNKn6qEnbVVIOZmQrfVATip1SGes3MicxzuUac72RgAv2c98NDvV/vPyX3Qvv2xm0pDYgXxiE/6e6hb7RyOdt4809KMx2N4LE2mKEpm3RmQWDjCMdOB/AgLcF4SmmoFa029u8ThJ8oWZyGn7l8ljC1p2e++2dR8HhWL9P2SYzcYfJHXItmfps//GbtDvu/8jK+tgRtLnkRu4Ejy6BvGHicNaqS
 a9dIQyxy
 hkiDTEAlLGPRbiWNcyYeLHQ/SYMustVtQ0MJ/tI0QsqIGXnIM5ORtyTjsxSojclt67SYFCpVwJlmspJGzc8EfJ72Fs+c8rz2CzZZ79EZBxsruXL/GGosk8YemEvgFEaFnHvp7OkNNdddunEbrx4F3F3ODcMJ9mWrvA8k5m0C2JfpJ2p0sve5TckA8U7zlI0GJEif7G/DVB2lcDmDW5FbHid/oYrVIFhlcm09ywARMlI3DLajWb/Pn/qwAn8rftNqzWidtJh28Cc0NDiJVtmOBQ5mtJfmgO7ddE5zjtA1vqj+TAWMWAHehWrk5R/atLnV0EJbHV9k3rvSHClRyr276TNwu8omY3MvzWWSGCDrGEaA0rZhwrq1FlbqV2BhQUR0obsVtVz9yvpYztHy+9e5SrLKZo+Wkt7MXYCm76rz1hMQ1sYEhQmY5T3FDH5RtPnP58YSpr4F2HIXtUx3GMKZ2sWxnOHjxdkJZS6pK6sTzGK8IdaZrzxAse1dXeM6qdT9D/TKBiK2GQ4cz4eoiU8W3qUIoXeVpC3/S14zJEzudiZ+UAu0ywTe/9lzFgO65LgeISiOep1yeKPfuinEKDbng5SQ2ZuXbRSuW6LIkS0PW1fGkjhG5ODBslxovuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since migratetypes are a sub-element of freetype, move the pure
definitions into the new freetype.h.

This will enable referring to these raw types from pageblock-flags.h.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/freetype.h | 84 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmzone.h   | 73 -----------------------------------------
 2 files changed, 84 insertions(+), 73 deletions(-)

diff --git a/include/linux/freetype.h b/include/linux/freetype.h
index b56a029de4ea4..b16dcd58e184c 100644
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
  * A freetype is the identifier for a page freelist. This consists of a
@@ -42,4 +102,28 @@ static inline bool freetypes_equal(freetype_t a, freetype_t b)
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
index 9fc77c4e70267..78455285dda7c 100644
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
 #define for_each_free_list(list, zone, order) 				\
 	for (order = 0; order < NR_PAGE_ORDERS; order++) 		\
 		for (unsigned int __idx = 0; 				\
@@ -185,30 +136,6 @@ static inline bool migratetype_is_mergeable(int mt)
 			(list = &(zone)->free_area[order].free_list[__idx], 1); \
 		     __idx++)
 
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
2.54.0


