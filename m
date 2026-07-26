Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A69BC53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4CA6B00A7; Sun, 26 Jul 2026 18:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675846B00A9; Sun, 26 Jul 2026 18:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D856B00AA; Sun, 26 Jul 2026 18:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28F9E6B00A7
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94DD11A0561
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:49 +0000 (UTC)
X-FDA: 85032356178.24.215D794
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf11.hostedemail.com (Postfix) with ESMTP id F248440004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wHy8AEaa;
	spf=pass (imf11.hostedemail.com: domain of 38ohmaggKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=38ohmaggKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcSdlflfpwT5PIWdrFhCrwpAAQDN4Yx1nAAyXq4J3Vg=;
	b=gIg3JdTGvpAgPNYWd09G13Hhsvf6YVg8FpUoZMocV7AtqVP5RRFUmLJ+LrbaolUPMqpMl/
	KPwKVMCJVVwe8aC7lojdM3YuodPCbOFIFypaSylSi/vMZkTZoD34+NawAcc+Nv8AgX3QC4
	pcTjB9zpjIbuS6ZIOkcZFA8ESYhrhzo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wHy8AEaa;
	spf=pass (imf11.hostedemail.com: domain of 38ohmaggKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=38ohmaggKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104628;
	b=5foQX/qf51zI8kHxsvDJQUNcCfD/pBG9PglB6EoilKfk0kg1avfYMrYCxYLnB6dQrK72qW
	x8O7B0r63y2ca5aCmAh4E39txFt36FOO9+sQ08udpKvDr8QX4mFZHPYJOwlKd0kbY1bkFP
	AaxeJJsh++VS9JDtNay2eSgpVZ8vPzA=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15d4bd2afeso201080866b.3
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104627; x=1785709427; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tcSdlflfpwT5PIWdrFhCrwpAAQDN4Yx1nAAyXq4J3Vg=;
        b=wHy8AEaaAhD8nZZ+cn9sIeKY1ekJwYT8OcofBNfino4sc9HbhCNvNG/jH6UxtHAiu5
         OKx8eqrViT0Xz8rJRynkIxIDrwqQ59X6eear0mjz0eOeZPYBsc7iUG0PmqV8Ykc4dCr8
         qphXzYmaLif8DAUsNhPXeyPYSRyRDwAIdAbRXVGG9qFIIXbQjNPEx4gJPcE57ai8OYZ4
         KqSysbxjGn4zSvn0h+KfDrUp2bTnhtjsmwphqf+kxv4K/HhQUzJz3YEFDwOBbebwPSDm
         uEf/dEDCKTDylvLYcreiidxa3MpoylUAPaokczhMeIGnTF51XHjTMP0F6Mo43o8ThhFt
         l4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104627; x=1785709427;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tcSdlflfpwT5PIWdrFhCrwpAAQDN4Yx1nAAyXq4J3Vg=;
        b=iRxi1Hf4nW9dzNqX6eB4u/boWcfe6lkDmKAulTKWvPPzxIm/stLIskeorv38CkrMfS
         ulXQKFD31r3cVEVGtJKkpXGgzKTBrpAxWsgODRKs4ZWAErncXKOgNktHDmKCsDRa3NQU
         basP+rHEHa8EMw4m/2fJVKFnyqseHJ5+wLVDala0epBWzc5nYvSkB5xnPp/+tDAZ42mB
         ylVe35sgthAsZyZLcdQ9Zr4nWqMetgspv8TFnuvIzwaLptLfIBc3oM+7kBYkk3sGQw/K
         +Ams7iRTLa0nTl882wT7NrSXiaD/Dh5afPoE9/RGDw14X+s96Uk4RTG62jThNYUrXSo8
         XpoQ==
X-Gm-Message-State: AOJu0YyXa5Hs9Jg8rYC57n4DWSboTb5KTxicKqIpVOn0cmOZd40i/Isf
	Lu3XRnI0oUq12H4rTcgEwMG717QSu+5Pdf1guu5Alf5wJQZJIWYDV9hBdhE4u2UknEAkRiqf7T+
	fcQM31NwrG+YCiA==
X-Received: from edgi13-n2.prod.google.com ([2002:a05:6402:a58d:20b0:69e:f058:8db2])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:9fca:b0:c16:9d13:26ba with SMTP id a640c23a62f3a-c1f1f0ab0cdmr277102966b.35.1785104626214;
 Sun, 26 Jul 2026 15:23:46 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:50 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-17-6f5729aa9832@google.com>
Subject: [PATCH v3 17/26] mm: encode freetype flags in pageblock flags
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
X-Rspamd-Queue-Id: F248440004
X-Rspam-User: 
X-Stat-Signature: imsc3fx7rq43j954udt9cxfapgohp8dz
X-Rspamd-Server: rspam04
X-HE-Tag: 1785104627-146258
X-HE-Meta: U2FsdGVkX1/SIYIbaLwuXLMJPoZxn/jeHAbuQU7k3iL30KAl5NW9/ZYljdyeNUs1H5GiIQ0NPUv1VjxNHmLfoHVIwxTqOkSkC0ps8yQVLCpcu6y3uitQvCP67jwZN1eTuZwMxu1encb9DGUP2mw2yuCyrM1TFTQl30+RmOWWTx5NDOJcx/2COGN8dk6Cyt0zILCN+K4p7bJN1V66JdDenrt6DDu3w1t0CtFs3LvJOv5FORw0PdIWbalE0EL4j1Rpd5ErtKgDQ4SOw1lDqO5A4Jj3AgcqikJVJeGjqNCdk616EH8UejfbzOTmVE5yrm0/ZW39g30r63GqAmvtdKFFQHijiBJ4s9zCU8kIQTTeVCM+edOwWTRRLrpvKpv40UsO66brpIQNHgIwMqUfWVYyPTn1SYJR4gX0LQc0VgB5TFApaUyMqCzkZtGpkLlGjsb9JYVXVwnIywnh6K/OJ92Slj2pM8bwJa4adoy2NPLhBdzJ8BSoTW8HFB/bVnktQNJQBou2YHJrJPyxuOpge1GignEnZpcdd4FH1LntgEbkYZxQIOUrIFPouBnhk5/MVT4NoJiFwmgycs7EyWBjglcvAiYZgP+F/e+MtJj2A2zxncvFOndm2wL/Po0keoXrgYR6AHx2AFT5NyTE7u2JikTY83890KcilRjUDWVPRxIeFdV0sbVOUQE1EAoIr0YIMAU97xv0vfzRxiOF0t69K6l+l4F+aGzPr/47rvLbihAAiRYkaDo73qkCS0GKWNOqVeFFsp5ZZOYAQIdSuIfp5/zNUIGd/O/GQHQx5KrWZB2mDrt4EZKvfqAL8H69lmN2ngviaUjTkw86WuAf3yPnjusJpy/QqX0tT1suzDFf7hMkzHbj7bbkIjt7YwKw9T8KeAqNcLa6w+tCfBop7mobiCnHc/bLCvLmqGSrhrXlfZLyKWFUFmun34g2LKvAdmXNlCQhQ84AvhTetqqUaTYxm3i
 FJ28S3ji
 kuaY/Ke5rKCoRzKm1asytO6M2iymuEI5BY828IX0lMi9+Hfd+Aa5msoElnQgF6sQY51c2h4NYKk/4C9PonnbyoUPmPAgTrrFjdwwPWNgwOJ02xCvl8BjZqqQo0GfJXOyDIs375JtUegxErnHWc9kNmyoNSdTKumOV2+TYX7GoEKtm+bDrQnRscNOx7XUKdZhijQ0RKQyIvLI7KsOKM1QL7V1LjpWQ9UkCP4+7EBfsTU5yKJJRFCzx375jwMz4hwf6HgyccRzH333b3uqnoTEc4YoPedI7D+qV1CarGR4PK3zvYOlhEO+WYf8STzinxKtcbrVNEjIz0cVG1sm3aVZ+QilUBJ0SDO/RNPV+HKXI5lfTFSoJTJUF8XomxPH1JL0e02tvB+OKPifebOlBCgBrMHpYK5PXmliwEXEDHKld43WKXYeZlXd9YZuEhAjId62rwdUr6YrsN/AouE16NJQnAJg/apHUAR4DJSA+7WEpiTKM0JVG9a4GrMaiIpVjNRbOS1g3PARr8Ddg6bhBqxfy2C+JHMWS8mrNBKFtxE0qrDJuW8ThtGY49SvuyGvUfEwdWNg8sG9N0yBM0wIRY7GJNd15GzhzYfa9P0OCvzkyN6rfVRj5tel+akzygg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for implementing allocation from FREETYPE_UNMAPPED lists.

Since it works nicely with the existing allocator logic, and also offers
a simple way to amortize TLB flushing costs, ALLOC_UNMAPPED will be
implemented by changing mappings at pageblock granularity. Therefore,
encode the mapping state in the pageblock flags.

Also add the necessary logic to record this from a freetype, and
reconstruct a freetype from the pageblock flags.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/pageblock-flags.h | 10 ++++++++++
 mm/page_alloc.c                 | 33 ++++++++++++++++++++-------------
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 9a6c3ea17684d..b634280050071 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -11,6 +11,8 @@
 #ifndef PAGEBLOCK_FLAGS_H
 #define PAGEBLOCK_FLAGS_H
 
+#include <linux/freetype.h>
+#include <linux/log2.h>
 #include <linux/types.h>
 
 /* Bit indices that affect a whole block of pages */
@@ -18,6 +20,9 @@ enum pageblock_bits {
 	PB_migrate_0,
 	PB_migrate_1,
 	PB_migrate_2,
+	PB_freetype_flags,
+	PB_freetype_flags_end = PB_freetype_flags + NUM_FREETYPE_FLAGS - 1,
+
 	PB_compact_skip,/* If set the block is skipped by compaction */
 
 #ifdef CONFIG_MEMORY_ISOLATION
@@ -37,6 +42,7 @@ enum pageblock_bits {
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
 #define PAGEBLOCK_MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
+#define PAGEBLOCK_FREETYPE_FLAGS_MASK (((1 << NUM_FREETYPE_FLAGS) - 1) << PB_freetype_flags)
 
 #ifdef CONFIG_MEMORY_ISOLATION
 #define PAGEBLOCK_ISO_MASK	BIT(PB_migrate_isolate)
@@ -44,6 +50,10 @@ enum pageblock_bits {
 #define PAGEBLOCK_ISO_MASK	0
 #endif
 
+#define PAGEBLOCK_FREETYPE_MASK (PAGEBLOCK_MIGRATETYPE_MASK | \
+				 PAGEBLOCK_ISO_MASK | \
+				 PAGEBLOCK_FREETYPE_FLAGS_MASK)
+
 #if defined(CONFIG_HUGETLB_PAGE)
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4965019dc2286..33b7d354e1e03 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -363,11 +363,8 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 	unsigned long *bitmap;
 	unsigned long word_bitidx;
 
-#ifdef CONFIG_MEMORY_ISOLATION
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 8);
-#else
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
-#endif
+	/* NR_PAGEBLOCK_BITS must divide word size. */
+	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4 && NR_PAGEBLOCK_BITS != 8);
 	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
@@ -440,19 +437,20 @@ static __always_inline freetype_t
 __get_pfnblock_freetype(const struct page *page, unsigned long pfn,
 			bool ignore_iso)
 {
-	unsigned long mask = PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK;
+	unsigned long mask = PAGEBLOCK_FREETYPE_MASK;
+	enum migratetype migratetype;
+	unsigned int ft_flags;
 	unsigned long flags;
-	enum migratetype mt;
 
 	flags = __get_pfnblock_flags_mask(page, pfn, mask);
-	mt = flags & PAGEBLOCK_MIGRATETYPE_MASK;
+	ft_flags = (flags & PAGEBLOCK_FREETYPE_FLAGS_MASK) >> PB_freetype_flags;
 
+	migratetype = flags & PAGEBLOCK_MIGRATETYPE_MASK;
 #ifdef CONFIG_MEMORY_ISOLATION
-	if (!ignore_iso && flags & BIT(PB_migrate_isolate))
-		mt = MIGRATE_ISOLATE;
+	if (!ignore_iso && (flags & BIT(PB_migrate_isolate)))
+		migratetype = MIGRATE_ISOLATE;
 #endif
-
-	return migrate_to_freetype(mt, 0);
+	return migrate_to_freetype(migratetype, ft_flags);
 }
 
 /**
@@ -576,6 +574,15 @@ static void set_pageblock_migratetype(struct page *page,
 				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
+static inline void set_pageblock_freetype_flags(struct page *page,
+						unsigned int ft_flags)
+{
+	unsigned int flags = ft_flags << PB_freetype_flags;
+
+	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
+				  PAGEBLOCK_FREETYPE_FLAGS_MASK);
+}
+
 void __meminit init_pageblock_migratetype(struct page *page,
 					  enum migratetype migratetype,
 					  bool isolate)
@@ -599,7 +606,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		flags |= BIT(PB_migrate_isolate);
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
+				  PAGEBLOCK_FREETYPE_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM

-- 
2.54.0


