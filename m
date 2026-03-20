Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC83F1099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388266B00D5; Fri, 20 Mar 2026 14:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3352A6B00D4; Fri, 20 Mar 2026 14:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA136B00D5; Fri, 20 Mar 2026 14:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4E06B00D3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA65058525
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:58 +0000 (UTC)
X-FDA: 84567265356.13.AB1057C
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id D5F55A0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dcES4NF3;
	spf=pass (imf15.hostedemail.com: domain of 3u5C9aQgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3u5C9aQgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibXE5nBh6a5dlrrhmxZTf5YrTT0KKxMS4jhTkhJEyho=;
	b=SMfitvgVpvJhOAXrp2lrRV90Tsx3x4zGsFZN2IQv9jOSnlvsHOqDEmCrWRswUgBIGkhAs/
	6MDGtbcKK48jr7/EhmmAEUB6lSfBdY0GeXBNyNZowkAbiDxWnpID2GUBUBdfXKBSaOxc+z
	nicMGAw2IVcXKP0GACP45R/Ep45Wf0g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dcES4NF3;
	spf=pass (imf15.hostedemail.com: domain of 3u5C9aQgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3u5C9aQgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031037; a=rsa-sha256;
	cv=none;
	b=LbrmFvUiV8gocOTB5/RugIU4j9VcrXjn3awkmuKoYJNp9+3nfQgTWLPDVtmeqjV0Z+jbyS
	u7Zx4Cu10x86SuTGaaXx8lFsFyvBaMcHkiy2ZixQDg0LHshe7zZBEwBKsSzzgE4VcJOi3r
	vx7YywnuvH+VAdRRwY8IWkheEHp/ZE0=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso7873295e9.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031035; x=1774635835; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ibXE5nBh6a5dlrrhmxZTf5YrTT0KKxMS4jhTkhJEyho=;
        b=dcES4NF3oB4j7FkVezzIHIbsvkXvixUGD6nDdMm0SfkuS8FS2yRqj16VwdnuJ91Uli
         Sr5rH+r9voOtdIK6hJqKz0pBFipimqw0lOAna9FdNYD/A5R46CQzgHgjAvilT9TWjLJv
         2Oj+pbI+IUTF8Xw7+H/oTDBuaw8boaZOjDevx2vq51X2Y/FTpQZXsb1UFt/3xYzorN2Y
         20EJmO/+F5ELkSAxSZee+ESQRjMfS9bIE9XdDwuhS/J6qFkspv6L4DY9iApfgMsdln4z
         U+HzS+moh3jakpYF93T2ksC6DVeNtY7sannAksXtfUGQtdSvjUr7KfWWnyW9AuILyw8B
         ZL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031035; x=1774635835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ibXE5nBh6a5dlrrhmxZTf5YrTT0KKxMS4jhTkhJEyho=;
        b=Ki6oWYmFqYNru3O33nAViblMtWjVtU4D80oby5l/i/gKYV61eyESsgtIlujJAfVAh0
         0aHrt+miLxVkjy+7DZN2z7JxCmtk9B8dFBYvLGOpGUrtjsQ4RVcLUDj24yq30xNfmR2a
         xeLANrO/lfc7JfMrVkLlvY79ixdRRdKtGgTI++8I2o2223UPh0TGim8lRPHSxzSivtEh
         mRDTLTXTqKg6LmMtGpH29o5cyrIOq60BlVyvSPDXoL6mfEH3xE9qXa8f3A1MYveLma/p
         SkQdtRJAG4dI4Qq2JBNygIHq5kShYkFhRzFj/nVcBkf74lzykIFV/xqZUzK20Ov+m09G
         l8uA==
X-Gm-Message-State: AOJu0Yz91UkACxc28/IXHer+EnqU40gdxfxztxh+7J82oIVA/3zibRaC
	4sAUUxHolCl5sC6Uvzji4qdIEWzkil9vvjkqsxnLf+bAWTG3hGSaglHeQ9w9oK8VXvOSd8yBjmM
	l8ulxT58UBmrjsw==
X-Received: from wmps28.prod.google.com ([2002:a05:600c:319c:b0:486:fb6f:bc58])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e09:b0:485:4526:ee06 with SMTP id 5b1f17b1804b1-486fedfb677mr61908675e9.11.1774031035298;
 Fri, 20 Mar 2026 11:23:55 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:36 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-12-28bf1bd54f41@google.com>
Subject: [PATCH v2 12/22] mm: add definitions for allocating unmapped pages
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
X-Rspamd-Queue-Id: D5F55A0005
X-Stat-Signature: 7gdhf64jtn3k5f3yczozoxmsbmzqfz6q
X-Rspam-User: 
X-HE-Tag: 1774031036-738787
X-HE-Meta: U2FsdGVkX1+xflKCwx+w8BR+0jnCJT29KCd+zvrMD/C8j/qVW9DuYVDzyV/1xrLDuxtreEDy+X7fQh8bX7W/7jXUPI6fUzOkVYztqXPtfT4bSy/vQSAWudrgC8lyB1x0GxrNYr+XzsSqi0VUfCsqONxsGO8MD1c/zRjFt2TL/OZrWYm9uecMRmxP32v6tFbN+rairPnaf3CpGyTX1ZMwaRd418Awhx9MY/Ph9xJzz0TrpG8f2D1IyRwcagJlzbGLs59MIsddgaGgh3wjPrL2rwOvh1QVvRRTAoIth1j2I2b4YPrmRqwgF5axbL4nBqgQxGPmj8/f149qFMpUEyj6Rryt31LM4Bxs0vTUCSdjWnSSpeJi43dKumtEXpPJPgLicJuMU/GVjalDRIyHo2bZ3BYgS8G6q/JYUsrm4LiVyTAWCiz6VHLj0ANmSzc59810CvTMsjaE3NmYHLOOydwDGQB7l7lx5sTXnhiuXeOD/l4w+XfQ1Xg7O5lMbHz6PDp2NwUrzphxKbPNWsiWwjzwNv9dv9hi2NVv7NoRUyumUQjNcXWC/UbELw0H2UR+p005KqWdfkb72L5rpqrf0iFjyKeIfCohV5NReXpIklZecAYZXX3g45a4LcapVMW5azlQXCiABlp/8S9zUwrblLYgwHviQImh7/VxIuXLlnGfQjDfiQDLGZ/YMHRFC+jUA9zDBvIeCLgNGdiWVLRPhCWSzpwPZN7N3DAy3g7VZJfjUG9F26ES5dCgIG+zQWNUt4I8E5Bwyz9tA5lqZFYidP6CKgG/AO2rxM0CqTrHcO1KfboCYYR8iov0RvkbNCYJ09oS1s0oYVBiczXzeY/MrTgaDBVK7gdVfTQZEi4fbfqq7kHv7ExQmlYRBqfCmlIQmmoeErm5MkVYTasPB8JKhVopgpSIiXiUbCRztyKHMd9v/01rrsVqH+bJnrDCtlm5hMKawB/hZF3ftzq9+awkr/R
 0Yy3jPL4
 mmGlow4rQf4uYoet66J6TWbTMYWnRzGnSen+IUpLAhNnt9DOkEzxeyfc9SlzBjt7JMQTe7LoxmJtcwde96R1DxsfqIA+2V3PBFPDZbM7fh3YsM0khk4ST4BSTYrqEEogpdwSWsEyyo5aIROv/5qaTWGrkYpPOcXEbtxdZk4mf4mq5eTDrCg6tEuqGIeovvjNDORcSbZDUST/tqJ8GhE5x4BfrS+JB8UGW8BI+M+pxJNr9ciDJxK1tzfzc4vuhoTbdwbeVgYeOouGbm2k8gqXub1UUhq2ULOeSViSDiHy6ijxyn0Yo722N9+bVxygfoJeWIrHK1LQT0Bu7f6E+q3gaGHJnZQm9P/Ra6y0uZBtlFIdJMRIOU+V9bqmK+hIn1JmQuXeOJu3ODGn8HJg+z9IeUxPSCaAek/G++NxqXu6Wlav9kVpBWqKD4LyJNYwZQqAa2toUU4Gx1iBdLrHV6GbU74Xr0ffu+eiDQ9/JakxWbeMAZq4UMeeQlFsVMkFqVGnnh8WDV32Qr/Mkh+SEI9xdBvjVDyCPnjIxkrVwggmITmxR+FjkWRFUKcrtNqLRfEpAf73c0k0zfbw6q5qXG9MIylLYOxq6WWtGgge0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create __GFP_UNMAPPED, which requests pages that are not present in the
direct map. Since this feature has a cost (e.g. more freelists), it's
behind a kconfig. Unlike other conditionally-defined GFP flags, it
doesn't fall back to being 0. This prevents building code that uses
__GFP_UNMAPPED but doesn't depend on the necessary kconfig, since that
would lead to invisible security issues.

Create a freetype flag to record that pages on the freelists with this
flag are unmapped. This is currently only needed for MIGRATE_UNMOVABLE
pages, so the freetype encoding remains trivial.

Also create the corresponding pageblock flag to record the same thing.

To keep patches from being too overwhelming, the actual implementation
is added separately, this is just types, Kconfig boilerplate, etc.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/freetype.h       | 43 +++++++++++++++++++++++++++++++++---------
 include/linux/gfp_types.h      | 26 +++++++++++++++++++++++++
 include/trace/events/mmflags.h |  9 ++++++++-
 mm/Kconfig                     |  4 ++++
 4 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/include/linux/freetype.h b/include/linux/freetype.h
index 11bd6d2b94349..a8d0c344a5792 100644
--- a/include/linux/freetype.h
+++ b/include/linux/freetype.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_FREETYPE_H
 #define _LINUX_FREETYPE_H
 
+#include <linux/log2.h>
 #include <linux/types.h>
 #include <linux/mmdebug.h>
 
@@ -64,35 +65,61 @@ static inline bool migratetype_is_mergeable(int mt)
 	return mt < MIGRATE_PCPTYPES;
 }
 
+enum {
+	/* Defined unconditionally as a hack to avoid a zero-width bitfield. */
+	FREETYPE_UNMAPPED_BIT,
+	NUM_FREETYPE_FLAGS,
+};
+
 /*
  * A freetype is the index used to identify free lists. This consists of a
  * migratetype, and other bits which encode orthogonal properties of memory.
  */
 typedef struct {
-	int migratetype;
+	unsigned int migratetype : order_base_2(MIGRATE_TYPES);
+	unsigned int flags : NUM_FREETYPE_FLAGS;
 } freetype_t;
 
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+#define FREETYPE_UNMAPPED			BIT(FREETYPE_UNMAPPED_BIT)
+#define NUM_UNMAPPED_FREETYPES			1
+#else
+#define FREETYPE_UNMAPPED			0
+#define NUM_UNMAPPED_FREETYPES			0
+#endif
+
 /*
  * Return a dense linear index for freetypes that have lists in the free area.
  * Return -1 for other freetypes.
  */
 static inline int freetype_idx(freetype_t freetype)
 {
+	/* For FREETYPE_UNMAPPED, only MIGRATE_UNMOVABLE has an index. */
+	if (freetype.flags & FREETYPE_UNMAPPED) {
+		VM_WARN_ON_ONCE(freetype.flags & ~FREETYPE_UNMAPPED);
+		if (!IS_ENABLED(CONFIG_PAGE_ALLOC_UNMAPPED))
+			return -1;
+		if (freetype.migratetype != MIGRATE_UNMOVABLE)
+			return -1;
+		return MIGRATE_TYPES;
+	}
+	/* No other flags are supported. */
+	VM_WARN_ON_ONCE(freetype.flags);
+
 	return freetype.migratetype;
 }
 
-/* No freetype flags actually exist yet. */
-#define NR_FREETYPE_IDXS MIGRATE_TYPES
+/* One for each migratetype, plus one for MIGRATE_UNMOVABLE-FREETYPE_UNMAPPED */
+#define NR_FREETYPE_IDXS (MIGRATE_TYPES + NUM_UNMAPPED_FREETYPES)
 
 static inline unsigned int freetype_flags(freetype_t freetype)
 {
-	/* No flags supported yet. */
-	return 0;
+	return freetype.flags;
 }
 
 static inline bool freetypes_equal(freetype_t a, freetype_t b)
 {
-	return a.migratetype == b.migratetype;
+	return a.migratetype == b.migratetype && a.flags == b.flags;
 }
 
 static inline freetype_t migrate_to_freetype(enum migratetype mt,
@@ -100,10 +127,8 @@ static inline freetype_t migrate_to_freetype(enum migratetype mt,
 {
 	freetype_t freetype;
 
-	/* No flags supported yet. */
-	VM_WARN_ON_ONCE(flags);
-
 	freetype.migratetype = mt;
+	freetype.flags = flags;
 	return freetype;
 }
 
diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 6c75df30a281d..61d32697ea335 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -56,6 +56,9 @@ enum {
 	___GFP_NOLOCKDEP_BIT,
 #endif
 	___GFP_NO_OBJ_EXT_BIT,
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+	___GFP_UNMAPPED_BIT,
+#endif
 	___GFP_LAST_BIT
 };
 
@@ -97,6 +100,10 @@ enum {
 #define ___GFP_NOLOCKDEP	0
 #endif
 #define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+#define ___GFP_UNMAPPED		BIT(___GFP_UNMAPPED_BIT)
+/* No #else - __GFP_UNMAPPED should never be a nop. Break the build if it isn't supported. */
+#endif
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -295,6 +302,25 @@ enum {
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
+/*
+ * Allocate pages that aren't present in the direct map. If the caller changes
+ * direct map presence, it must be restored to the previous state before freeing
+ * the page. (This is true regardless of __GFP_UNMAPPED).
+ *
+ * This uses the mermap (when __GFP_ZERO), so it's only valid to allocate with
+ * this flag where that's valid, namely from process context after the mermap
+ * has been initialised for that process. This also means that the allocator
+ * leaves behind stale TLB entries in the mermap region. The caller is
+ * responsible for ensuring they are flushed as needed.
+ *
+ * This is currently incompatible with __GFP_MOVABLE and __GFP_RECLAIMABLE, but
+ * only because of allocator implementation details, if a usecase arises this
+ * restriction could be dropped.
+ */
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+#define __GFP_UNMAPPED ((__force gfp_t)___GFP_UNMAPPED)
+#endif
+
 /* Room for N __GFP_FOO bits */
 #define __GFP_BITS_SHIFT ___GFP_LAST_BIT
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index a6e5a44c9b429..bb365da355b3a 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -61,11 +61,18 @@
 # define TRACE_GFP_FLAGS_SLAB
 #endif
 
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+# define TRACE_GFP_FLAGS_UNMAPPED TRACE_GFP_EM(UNMAPPED)
+#else
+# define TRACE_GFP_FLAGS_UNMAPPED
+#endif
+
 #define TRACE_GFP_FLAGS				\
 	TRACE_GFP_FLAGS_GENERAL			\
 	TRACE_GFP_FLAGS_KASAN			\
 	TRACE_GFP_FLAGS_LOCKDEP			\
-	TRACE_GFP_FLAGS_SLAB
+	TRACE_GFP_FLAGS_SLAB			\
+	TRACE_GFP_FLAGS_UNMAPPED
 
 #undef TRACE_GFP_EM
 #define TRACE_GFP_EM(a) TRACE_DEFINE_ENUM(___GFP_##a##_BIT);
diff --git a/mm/Kconfig b/mm/Kconfig
index e98db58d515fc..b915af74d33cc 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1506,3 +1506,7 @@ config MERMAP_KUNIT_TEST
 	  If unsure, say N.
 
 endmenu
+
+config PAGE_ALLOC_UNMAPPED
+	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
+	default COMPILE_TEST

-- 
2.51.2


