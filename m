Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0986BFD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 588A96B00CC; Wed, 25 Feb 2026 11:34:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5669F6B00CD; Wed, 25 Feb 2026 11:34:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457816B00CE; Wed, 25 Feb 2026 11:34:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18B096B00CC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA01A1BE68
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:52 +0000 (UTC)
X-FDA: 84483528024.28.1EC0B39
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2B9901A000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kR+cUKCt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3qSSfaQgKCMIriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3qSSfaQgKCMIriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037291; a=rsa-sha256;
	cv=none;
	b=2gI3yNH6gNIl4H2pY4iLKrUYgAP3x0SkOyMkIRGH4tVHH7ADuuH/Dkh+LPeRB/fjGzqr5E
	5cz0VVyti66uzkdH+xzhxibH9r5OabAeD3QGRQjxTRenpBR7z8YUSXxykrjuiDkFsegMJG
	CO0AcYh6i7N8Sy3VahWWQVbn5urzfBo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kR+cUKCt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3qSSfaQgKCMIriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3qSSfaQgKCMIriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3owdeu4kE4g7S0Z4PekGxXbX8IdWlNVillVf61xXvw=;
	b=ofS015xDJEVx2sJFquxn85VF6YwJ3X2CUYfJ1Q+ZXj8u9/ZP2No+tr7GkckorVQEWbnMye
	peAYTfz+yOZvdF+IWFaPQsK7Ay/3Fvh7An2gjBX4JqyCATej8V4r709szXtQnuEK1/euy3
	CdOdhGpYYgVES+J6sgfECEja0ylCzuQ=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-483a2db68caso53636495e9.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037290; x=1772642090; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S3owdeu4kE4g7S0Z4PekGxXbX8IdWlNVillVf61xXvw=;
        b=kR+cUKCtLHFspOIz2H/7SoXFPF9Wc7b1JE6aEddYAFnAYphhczaggbYizfolqRBfDk
         L8aM8vjM0WdewFkdHfUapMAe6FxcUOrWVF/aXbn9tk29w4JxO8fpYadNn0KGX6a5j2J4
         vrXoSA3XYK+EL5iU6b1I3c1JJVp/mkA++Ib+VZXSh+owsUBnF4+6QPHgE9xje+z9J0R6
         EanhlLTUfmQ/mIGsDto774gdehW/3SZacUwyj5SkAe5wG7HwXZDRFIyEZOKHR4AE5mr4
         TXM5TpxNAycTfK4N4JZ+cx/IwvkZDb3MYRoQ8cDrgDQg9QcR1pIHH92vHlj/uOvLqBBU
         lz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037290; x=1772642090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3owdeu4kE4g7S0Z4PekGxXbX8IdWlNVillVf61xXvw=;
        b=A4/9pRAuYLmolLCBEsUMWfaY/x5/wDlSwXz3VnZGe3hdj4CumrRquZ4eRZOQhxeQdl
         nUzqA5N7Ni/oy8krNwp815b4ovf0R1BJVNerW9XvVOPLssE2IDUq1nopZ4OEZDopMCL2
         RWBluG4C1BFDfERYf8DFWdscB6kHljcyVn3a1xOsZD6sVcnxWJ6hG4IXMTMvvbmM72/W
         Dx+4BOoSLpTq0q5sJ+Qodu7bZD9e0JbDH8uVLQcIbyRxyXUDRp1qdYXzIt/mjE8jhBgg
         3tx/j6RromAgdENXcLa5h0XN5eLtMUhKW5ReJl5JGv9V0UbwEzpSa5SDGXm8fMYUCIa+
         doVQ==
X-Gm-Message-State: AOJu0YxwsSWTeS0qr5Si6aqG9Yr4YiIaXinnxA0weynl2Mop4uy36ykt
	THJEy25mfZqv3QYcV//NgU863it2KDnMxmxA4dwshoHeBMWtOj7Srd1bHFEEEWb4SAYXvzN3iNo
	a9+zGovFNwuOB/A==
X-Received: from wmo14.prod.google.com ([2002:a05:600c:230e:b0:483:41b6:adeb])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4589:b0:480:1e9e:f9b with SMTP id 5b1f17b1804b1-483a95dea3emr345095145e9.16.1772037289584;
 Wed, 25 Feb 2026 08:34:49 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:35 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-10-e8808a03cd66@google.com>
Subject: [PATCH RFC 10/19] mm: add definitions for allocating unmapped pages
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
X-Stat-Signature: 3hk743tkteqzke8a7wnpo8kgtsjinwrf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B9901A000C
X-HE-Tag: 1772037290-605735
X-HE-Meta: U2FsdGVkX1+ywm2TfPCrjeZP856AiqbG+j6uY7DNfgSyBiJXTFMhgmBjx08lYDMqDNoNIWHa+DhcbLdlf48F6KdndahSD76bfwMGEyd3SkbfzBFBFsABT7ePTBczR31UVVoOx98F9WaFyBsq6dhkdEna3MfX99afXS6+VNapQKJAkITPTUqL5mKAtewSntqu3lKzy+0EN48SiO+Ijg3euVgTMo0Q8/hKiLMjB31w3s9b24Yit1z7ba1WiLfEE31jTAzg9V3NKTswEAwGbkEDy0lSp9xpUWBOqZ7rDcI1m0WDbBFkGejq/hX7/ZKePPZNwO4fdA5LqSBbd5n/8Vs5xWU5ZN8tuTvw6O3t3K4bCmQLoA11ZjcXCZNSvGfg6+/u0DAALwQXt+CpWwGU1hEqsBeIXLX86TDI3JO0azL6AH77NmD36XL82XBB4jFkvpRo6lJmE9NiBqyJXyHIo67FolYcJ4tMV9Jv++Q4ugVfNyAEoe8UKahKQx/hgN4Dpr8sROTkZsxiMG0s4CrFWQv5Cz/gwcPGjetdSEqeKRoVYP5EjXFa17G9x91X/vQxGEZrvgg7xPT9u5IiZD7jI1kGhbRxLVBMbZcOweacsiICx+reu1qBhiBwHib3Zl7ixf3yZ68n7QAVuZbvOJFvXN7oT2OS0iv3xzlZGwU+5hjJCfOPkdSb11eo2OH2f6jlA9SUzKnGXitMu3uk42Lecr5uhfV/NHM26E6ODYIqEBtOuatetU2A25X7PNQHpC1ctBISbwK9Rtt5o9Ks3qNYCsgrNrjMigdJbRbdf0xULczTjTgkMMsuyxPz4gG4oxE3H8p0FN/fSkBVLBQitjDw56YyAiUF9ySjzDq2RmLUaAJXnGycDuBiEmLkeoaX1ACNxTT9zSBIU5oHHPwGVd4YX5PMgAbzV7hijMLGI38mMZ98CnYdJnCj23PBVw4oPz8jHbdByqBRyWEkUoBt9xqDy7v
 BG2ruWw8
 Uxj1hPFRhcunOxN521wifVRny/vp+21P381ibMKzbakx04QdZhmDOmRXZyiOeUWgMqLCK4NcJGq3pqMhi9U/sFRxFpe5kCDW306F8KOGAJTSLhoFfnyUm5a+3PLrUGOk4zMYMIcEL8I3DAkct2swV6yAcKorW10pPqEs1SlnOiAuEKQsc5WOs6UDUaseiciF/VbmGhK/4SgLb4CfFEPNqbmeaR5gje1xTxn8vktTjRI2rdE6U66urSvfqQ0bUJg4rNOkEcyzAFSS6CHn/ZD4yNKoUfgVK0XYsbMTri6pnkwTQsYGfYZBlD2hOcGCb5FIx69b+ztUqphLYin+/OPisyIe/1/P4KUrNOLALo7SQb5/Aru8yc/qMfh7v3+PX1q6kOHMu3pLfl60Gew+MUvb+w2Su5UkPS1f2aUvvrh0i5ni0hNw3/y8ODadrifXg5j7GKbWlnvnjrAJ8wS3DpgndLUjlyU/thjpYyj7bV1hf6zVI5aw7Nb06bBRlFzsj+ySLr/9ow9PYMzzT/F2vflYNl6LqK6FLRc4BJI6XqVD+I0Ov7PoTGw6pL6D6Z1dOgaIK5h8rzhP07g7RCMjRVBSwHUrl8rcXxwb+HOYMQBiv3ppEyVlaVEGt1hP720hCXlTO5pCfppUUb27iXtE=
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
 include/linux/freetype.h       | 41 +++++++++++++++++++++++++++++++++--------
 include/linux/gfp_types.h      | 26 ++++++++++++++++++++++++++
 include/trace/events/mmflags.h |  9 ++++++++-
 mm/Kconfig                     |  4 ++++
 4 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/include/linux/freetype.h b/include/linux/freetype.h
index 11bd6d2b94349..3b0d41b8c857f 100644
--- a/include/linux/freetype.h
+++ b/include/linux/freetype.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_FREETYPE_H
 #define _LINUX_FREETYPE_H
 
+#include <linux/log2.h>
 #include <linux/types.h>
 #include <linux/mmdebug.h>
 
@@ -64,30 +65,56 @@ static inline bool migratetype_is_mergeable(int mt)
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
index 814bb2892f99b..1f4f49bacb5b4 100644
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
@@ -293,6 +300,25 @@ enum {
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
index bd49eb9ef2165..ccf1cda90cf4a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1503,3 +1503,7 @@ config MERMAP_KUNIT_TEST
 	  If unsure, say N.
 
 endmenu
+
+config PAGE_ALLOC_UNMAPPED
+	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
+	default COMPILE_TEST

-- 
2.51.2


