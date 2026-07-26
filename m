Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 368D0C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4535E6B00A5; Sun, 26 Jul 2026 18:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403D56B00A6; Sun, 26 Jul 2026 18:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5446B00A7; Sun, 26 Jul 2026 18:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E66336B00A5
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AFE7160551
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:47 +0000 (UTC)
X-FDA: 85032356094.01.FA6AB2E
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id AAFAF140005
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gbFgKF4J;
	spf=pass (imf26.hostedemail.com: domain of 38IhmaggKCPUgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=38IhmaggKCPUgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXx93sUV7eAL90YwUftJYe6mobaN6giLJlOqjthEazc=;
	b=ZyXEp7wktuwh2yOZqFMm128sjaAN7H6lL0xL2K8/9ADdgIx7394m7VlBKiH3jf3ZSCgexE
	n2IIHIixAdx7A/TH+DQKl6Rv+oIe1w7jLuujdhrhFflFYcT9lhpSqkF8VuWLwNoxWnKJ1m
	0NOF2ZNDrM7amx0dtsKpM4Rpj4UXTL8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gbFgKF4J;
	spf=pass (imf26.hostedemail.com: domain of 38IhmaggKCPUgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=38IhmaggKCPUgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104625;
	b=f4HXPVunO6tyBMfDENl0iMu9NxT+FYZwJpEp0znr9+AnuAV20k6hUj53LUEkdyMeL0qruQ
	v0fIr4h2Dxt54z02CgIfltXOcrmQlGpb8QV4Jswt2UNeXXLgokLtaAR8J4ok5NK87x2bZP
	5Xn4qOrznPfKXXF6IgYkPsD/EZZ0k+I=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-698c15b962cso2075272a12.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104624; x=1785709424; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nXx93sUV7eAL90YwUftJYe6mobaN6giLJlOqjthEazc=;
        b=gbFgKF4JA/hX1+COXvKtPhcnSIjLkmuMBXuKt565nW3kx6fcdnq3N8NiBjFB9kscIU
         zgP3Z40+U/bnzIMUCRvNN8Prfhmt95TlZ1bfPkEtZmw8lIudXi2GqIYvA2smtqIfu/nR
         l3y5zCLq17i68OlYJx4st7gpP9AKZanm0oiRr8mWCqGPvWF2wNtVmaD03mG+YSZK86Hc
         4ASIyhivHXCVJ29OafABihDJJ/gjpEkjcN1PZSbzGTbZ9WSfsYAls6WVDU3PBCg+cDBA
         Lor1CeTYWdGrqyJznZzoT8389EYS4pcWkUsyp3qq6dDrr1bVqRiYLWyo3JpoxLQjE+s5
         m9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104624; x=1785709424;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nXx93sUV7eAL90YwUftJYe6mobaN6giLJlOqjthEazc=;
        b=sEYjAsqWMnytxwYOQyXL/gn1ElsFQ4NP/cdFkH8Ie1uL2duUiyBb6u6yY9IQ+efviK
         wesF4GcibWm6ziow1nhDsMkfZtlrEZriChwAj8xO5JOTR9pkTBG6Ec9TGCBsM4HAcNEN
         GmHHroVApE2QMXf8w//qJxwcwxJY5meD+s93RYzzuI1aIRBf/11LA4jKIDp5RJJ0wQ9U
         t6rsp9je4hl30p8MSx68IPU2d95key3rpfK93T9M6lbwxKFFJDJtKnljm1ppkGTtLnXl
         V9lYMvE6Gneflcaj5oTLE6XXFpupuSw9zRzffp5QOhbOYEh3Izfi27YC0xZOm5fOa+kI
         rrNg==
X-Gm-Message-State: AOJu0YwwIfx5Si+iHbjzYLh8AGL58RTmsWMN1b4iLPQkYMLrJhUEoKpy
	Wm6s2qpesr8RAbr1s5Z4w6phviiLrA0Toctp9IbsEYw99NCj1FbYxNRdEHXwI2bLMPjI/RfCVek
	DjNpbMOf2/VD4cA==
X-Received: from edvt17.prod.google.com ([2002:a05:6402:211:b0:684:73fe:8e02])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5511:b0:69a:9355:d1c1 with SMTP id 4fb4d7f45d1cf-69fc118c7cemr2037031a12.41.1785104624095;
 Sun, 26 Jul 2026 15:23:44 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:49 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-16-6f5729aa9832@google.com>
Subject: [PATCH v3 16/26] mm: add definitions for allocating unmapped pages
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
X-Rspam-User: 
X-Rspamd-Queue-Id: AAFAF140005
X-Rspamd-Server: rspam01
X-Stat-Signature: 7whjh9mse66mju7kjbk8mbaaa9bnessz
X-HE-Tag: 1785104625-728911
X-HE-Meta: U2FsdGVkX1+SNGaHXWdEnQSEqViH9NxmREGIqqjzxcWh+eEqhJ9R9pSjYOU5yjeHVuBnZP2EKJfDuHQKBa1W7zgQ80tURL72xeKFxYLPahBCxLP3u5xHvoCh1yqsqq5NU7cvWF3O+XoFZay7ILpCm9mhX0WbJtKRdq6+AvvMq/W9fjLYGapxAs0fdVKMlDC5UpsMMRHtbts41z+vMjgUrMiuG2HSyiJHkZ+pFE/PesI13GZQ5ytKONuoy4HGCejoBzH/f394zIvZEl7O8Ph/ko+ADSQGwpBRg3VZAWf/mGVMLKlXfUtATAIz26Ty+FSNyAB6H6nNJwTYvwufT7SN+Ng/hZsC3AfoDFPkDh4wrxA9kQqgydE7KxpdKU7Q91xbpQTfBGmlmCGzgpUOEnOVS7BvuhzwBFLT2BE3iUD+ToOpAyQVZO/RSsW2aybX1Pc/rTM5HoduR7iTrdKKOFzqqQoz1OW4IiauJwC8q2LYjwgj2K9LmnijJi56BKvwl39+yHD6pRtUVNwnnDEGr0uS1UsIXomwGBWNFfeqCLnTWJusW+sJJlRQfBq5YNtrRu9I3GRBwRuDRrVHSVoJXu+9GlvoBcJPe9G5GgBt3G86R7DXPP5bcPINZBy0FVHCY1rN0rTed0zrh6mbKiQrUCDH0AmADeRW6W+o6SOaYWc70zGdBKhMh09Jv7EFJi9XM5eFJtly63VLnW2oE2KtYSPD09xKhL4QO9aNlah/ycESGRMyahgs98TZV2dLApYSpOI/XF+T1IkJ3qzIsufzQP3v5mjBRFMRysDhZ7mKezky2um2L639iL3z7AlbcFwEojvSoKBD0+robKNo3IJPmbER+whYdVb7e2G8+7toJQwBTdcR6uRx56eU4Ov8hZZB/Jso4ufrKrnnUhS+EeJiQQFytxWeTdDntWf4OWr+jAO7vI8TP0djknFO3reXC5IZ4H1vjGIJBfB4nW+gm10GEBI
 ybtpsi54
 hKpaeufDV72gmfz4Yfzp/iTBZQQMW8nvXCqFZvv4ygquruks6BSuMnDNcRYQuCTV8vmYqVQ7lScDO4jzmo4/IUZZp3NSpA9yzQQ2+BAL3fcfX7vD1w9OE26218YU+Hm4DVsaa4Ec/7vRhwwzxJ6tTN9hZ1RM4rd8vbwnMAtyViqv/u3N0OGr3CUjZefSfLUHNohhEhnfEphLZhUCLWYMvDGZpu1Y6DB7BTOyhjkTnjejz98HkC6vJlGfd36NEIe/eNZcLisjTIJ2+V/c7hROhRnTqo60ECEYOxo0ButDSeDVndOJNrkaik6NtIP1PniT1o/6bglT+6Y9w7xz1qDOTTrdyo4uW6Wx6IHS1ifhWOZ1SKY4hxVkxb8o+fukp4KwC05CjaIEMnl8GreRCrOA/R10KSXLNxamwSESmqH3Jg6+i9lUSkOIma7Wb0G4VHbgwCsZ/VZcdcGMBmiy1a0Tl5qe58Pm3Uc4NEkid4cJGdFRm7jYe5kZNw+OCesdHgtcxB5PisFQhDLzcqmAKcmJaVillSTxlNdiHqc3m/Fxt4FvaCS3aKKhaKYmhuf7EmUURJ3zPVDlg65DD+v1L60htVdqcuqL6FLYfpjAorVAF3jVUPtfpWKEg3XVBRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create ALLOC_UNMAPPED, which requests pages that are not present in the
direct map. Since this feature has a cost (e.g. more freelists), it's
behind a kconfig. Unlike other conditionally-defined alloc flags, it
doesn't fall back to being 0. This prevents building code that uses
ALLOC_UNMAPPED but doesn't depend on the necessary kconfig, since that
would lead to invisible security issues.

Create a freetype flag to record that pages on the freelists with this
flag are unmapped. This is currently only needed for MIGRATE_UNMOVABLE
pages, so the freetype encoding remains trivial.

Also create the corresponding pageblock flag to record the same thing.

To keep patches from being too overwhelming, the actual implementation
is added separately, this is just types, Kconfig boilerplate, etc.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/freetype.h | 70 ++++++++++++++++++++++++++++++++++++++++--------
 mm/Kconfig               |  3 +++
 mm/page_alloc.h          | 18 +++++++++++++
 3 files changed, 80 insertions(+), 11 deletions(-)

diff --git a/include/linux/freetype.h b/include/linux/freetype.h
index 3b0d44023b6a1..37e88dcccdecc 100644
--- a/include/linux/freetype.h
+++ b/include/linux/freetype.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_FREETYPE_H
 #define _LINUX_FREETYPE_H
 
+#include <linux/log2.h>
 #include <linux/types.h>
 #include <linux/mmdebug.h>
 
@@ -64,20 +65,47 @@ static inline bool migratetype_is_mergeable(int mt)
 	return mt < MIGRATE_PCPTYPES;
 }
 
+enum {
+	/* Defined unconditionally as a hack to avoid a zero-width bitfield. */
+	FREETYPE_UNMAPPED_BIT,
+	NUM_FREETYPE_FLAGS,
+};
+
 /*
  * A freetype is the identifier for a page freelist. This consists of a
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
+#define FREETYPE_FLAGS_MASK FREETYPE_UNMAPPED
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
+		if (freetype.migratetype != MIGRATE_UNMOVABLE)
+			return -1;
+		return MIGRATE_TYPES;
+	}
+	/* No other flags are supported. */
+	VM_WARN_ON_ONCE(freetype.flags);
+
 	return freetype.migratetype;
 }
 
@@ -85,33 +113,53 @@ static inline freetype_t freetype_from_idx(unsigned int idx)
 {
 	freetype_t freetype;
 
-	freetype.migratetype = idx;
+	if (idx == MIGRATE_TYPES) {
+		freetype.flags = FREETYPE_UNMAPPED;
+		freetype.migratetype = MIGRATE_UNMOVABLE;
+	} else {
+		VM_WARN_ON_ONCE(idx < 0 || idx > MIGRATE_TYPES);
+		freetype.flags = 0;
+		freetype.migratetype = idx;
+	}
 	return freetype;
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
 
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+static inline bool freetype_unmapped(freetype_t freetype)
+{
+	return !!(freetype.flags & FREETYPE_UNMAPPED);
+}
+#else
+static inline bool freetype_unmapped(freetype_t freetype)
+{
+	return false;
+}
+#endif
+
 static inline bool freetypes_equal(freetype_t a, freetype_t b)
 {
-	return a.migratetype == b.migratetype;
+	return a.migratetype == b.migratetype && a.flags == b.flags;
 }
 
 static inline freetype_t migrate_to_freetype(enum migratetype mt,
 					     unsigned int flags)
 {
-	freetype_t freetype;
+	freetype_t freetype = {
+		.migratetype = mt,
+		.flags = flags,
+	};
 
-	/* No flags supported yet. */
-	VM_WARN_ON_ONCE(flags);
+	VM_WARN_ON_ONCE(flags & ~FREETYPE_FLAGS_MASK);
+	VM_WARN_ON_ONCE(mt >= MIGRATE_TYPES);
 
-	freetype.migratetype = mt;
 	return freetype;
 }
 
diff --git a/mm/Kconfig b/mm/Kconfig
index adf71788971a2..aa5f041ce1a67 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1530,3 +1530,6 @@ config MERMAP_KUNIT_TEST
 source "mm/damon/Kconfig"
 
 endmenu
+
+config PAGE_ALLOC_UNMAPPED
+	bool
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 9928aa9012588..fac8e5304bb03 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -56,6 +56,24 @@
  * alloc_tag_sub_check().
  */
 #define ALLOC_NO_CODETAG       0x1000
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+/*
+ * Allocate pages that aren't present in the direct map. If the caller changes
+ * direct map presence, it must be restored to the previous state before freeing
+ * the page. (This is true regardless of ALLOC_UNMAPPED).
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
+#define ALLOC_UNMAPPED	       0x2000
+#endif
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)

-- 
2.54.0


