Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FCB71099B34
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227B06B00D4; Fri, 20 Mar 2026 14:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2DC6B00D7; Fri, 20 Mar 2026 14:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFC06B00D8; Fri, 20 Mar 2026 14:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB4946B00D4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 968881DAC9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:02 +0000 (UTC)
X-FDA: 84567265524.19.7D0FD13
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id BE6172000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Scq6nWWJ;
	spf=pass (imf03.hostedemail.com: domain of 3v5C9aQgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3v5C9aQgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCYW2ni6m62XGMoe5pWNGbD93sifZ1F5uJs6ndkREVw=;
	b=EdGxJ+uPpHQ0jSbU/fnNPXlBdXPHjX6OsXek/WTxdoISjyRSCnDOLLo6skpd4Ir/g/SlZi
	fs+VfEIbbfURPwAd4b5NdRPjv0IsjoJD747fjfMIEvzOge2urZM96LIRYrarw9bDibjLMM
	f510nBYGH2XrbVefgFHjyfXy3Jx+erc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031040; a=rsa-sha256;
	cv=none;
	b=0tWkmZKAJMkUobeJTa+Zx8n7LODuWdMxct+8lO66DGxn1Ksr8mzikjcOsz+WglYF5L/NBy
	TRTHzUQDcmVtyfrryDpwceg3PxxXTspaK8ejxrzml5uvsVy2nEaCxzkyEdY9kcVaabBSEG
	fB9cVpxH2F293G2eOmLM50kpIne3g1A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Scq6nWWJ;
	spf=pass (imf03.hostedemail.com: domain of 3v5C9aQgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3v5C9aQgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836abfc742so6630865e9.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031039; x=1774635839; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yCYW2ni6m62XGMoe5pWNGbD93sifZ1F5uJs6ndkREVw=;
        b=Scq6nWWJS32NosP7uC8OkvkuG8Fc+RUiwgIf3cJoGPkL+YnudvXBRuKuNDSFX8ytWS
         VRmyZhbasQb5qqnQCvU66/Gqob4JhHZu/GiCbkz7CouEdZ3F24O19K7VXSclR6C9SMFB
         QczpXdKyGuZU3KpTo6GQL04EnafdilAQQAe4NyZflEunIhjmRqXFmKt5/g56zCAGs7oO
         81YjVIn+76GdkzFRAjXhmQvxH3Vj+prIxtAwXBSQBRV7Hw7LVDqD3CIeSbb0kEMWGpXl
         ojwkjceHB0dwV3ouB1ihV6eTdhb/SYd1EXhjSSvie4kRuIE2uO0ZUUcOmun4giVLnXqx
         Z76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031039; x=1774635839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yCYW2ni6m62XGMoe5pWNGbD93sifZ1F5uJs6ndkREVw=;
        b=G1eSYIT6OMfBrEYv4tmBVzd8VeGZBg21qZqEl3DeILMJ7hQ/AMNAV2MQHxBsC+0XOz
         BYXwEIe0qQJ0LrmRI7swrlrjElb9XBDnHewCdNskMhrk2CxRXSpGfN/HL2LItKr46AeU
         YixEmPgs1uoYzXJKJdzc/ZLACBHR9CNzf/HMp1V/OQsBC0tQxMyvsTrosBWkAbIfAnO6
         gX9fBLVQPxhm1JRP2idXQkoE1OErfxo9y+OSmbetSSNZc6zps3UZ4rsNM2N8/J60RL0f
         088Xm3f+6+Q3IhflZyzL+odDZr8pt95W6vF0TPAvIngoivALVk9IPTdQVzBTOpTTltiL
         Npnw==
X-Gm-Message-State: AOJu0YwzZkz57d1f+Sp5CIU1h33XZZDegM4exjnyE7ME858KyoLjKOQk
	NxPB4HtvkkqAwuqzA1crlc8vp+TEA0BojPFqKDJdbQBmiJbyVRPkqDqJ5pKd06271NKV5f/cXOi
	OsJsGurCADP45Yw==
X-Received: from wmbhi3.prod.google.com ([2002:a05:600c:5343:b0:47f:941a:613d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c84:b0:480:1c69:9d36 with SMTP id 5b1f17b1804b1-486fee0d808mr59836105e9.17.1774031039185;
 Fri, 20 Mar 2026 11:23:59 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:38 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-14-28bf1bd54f41@google.com>
Subject: [PATCH v2 14/22] mm: encode freetype flags in pageblock flags
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE6172000D
X-Stat-Signature: 3z1wunu5zou38mn9cssp1syam1ws615k
X-HE-Tag: 1774031040-698784
X-HE-Meta: U2FsdGVkX18a/u8n8Kma3VO3iz+bU7jVScB6uEPza4MqN64vp8qQg9BkpciNOZiPnK5HdELwjGknWReFIWm1PmmUySuA8cO/XLz7zZMJxhPEz5K+1vR6+Ebx2FiOgxadtRXY39jUzRcwViT6EemfJQqMD3WL7uDbTni6sxkbavM8NKGwJ8qyesJ+qrfsA8UFYhim1IuiJtqKNuP7zCjmMh9b7lYbB/+ybPmG8fWrgIjHrFU2WWiWEirJkVDe23MmOmkbKkv1CIB9kWabnitcUle/T9CLCBAQe8mAFiV7GHxVT16BI0SKHvgOlykBT4/PU1fbXTCtyw4fwnHF5ylciL5n7xcC6LGwvnJ3FTjMDJd3sZypt/sXN38dd8wwv4QIHxBP+I+8Vbp9mjAftp7wVHN3U3O0EXQYjghJRgaLnB8HiazxoIv1QDEeyOSa8nk1IFNty7kz4lvkzIJy5SwW+aQYGsNVZwGHlFEkBuLfzQERHTBQyA25gmfWv6DihQXpEGz2e4sRiLq8lCqZtb88u/J08dmXblLny9tTWV70NmA216Vd+/SKyCV3GF4skD6QXMpi+6/fyvHXrpQ3nuC7M0hByf6y2ZXOOJQQmwH7JGRvS2vzEAEoaHYlWvZyMJ7cAQJbJE/s8H/3wnWJErvCgombjX0WhCh8MARMzs3ZJmzFgkEEnXN8fcbIYR7hLCrD66iBC9RJdS3/nMxlz4b5XWBpiELU+Oxhsy5GmOjVvx1DnUdrc4zQvZJJoVtgR3d5ob3RmDbxGCSMNEF+MxdFdpa8Dwle0Ky2i2CcLpOS83D/eBg5pr74F7xy8CoG3fHCEkkit4QFYsiQi9sBNvda2PP3O/CiF33ig/8u+OFsZLz1AnoKv1KS0ckdZQSnvoHmiL+oRPnB95XnkczIBkRRVzoaqO2mkaC2S3+HpZAAvvvrcD8JmhACAPeOGhWd4KdFSmI5ztHpGFNSk2KktgP
 IgV/qGlG
 /0H6cQDbBcKMVdTqC+DDreKWNaUm/jv9nxHcSNsYfIH+t09wPvBSQeZLWEjyYIGEjm+pnx7N1WXQWJp9qaanYt/BZX4xcN296EXF2Q4z/VRK+MqA1F2YWFfI0TErUqcUcOA4Ze1qIakEdVRhdM8zmPFGXFRTmd8hmxEGrC9xMXYZgiRO7JXwoi9yYbBBevJ+qkafiv7j9DOVUzAd2nxg83dMyS/bJ6e8IG/4D2iok6IHnU4jEJ+/672sNJGqg2n3bl46Snw7QBW2UysZUZEWOHIp1n+kGoR4IF9bBh3/PfmlBgRMnLK36/k5tyCzUeE7AWKKRgTiFSwx57d2nKFnNK/RQmGBitIf1byBiKAJ6d95CQND6RGk3D6z05sQACKo/E37Z77EEyaylADglsMS8DLfTIuq412xZFUQDCOvWz96ZnNTYXCRO43H3p/syLrZI5al4gcs9nKOndRHL6MG8ymhPpgZKEoF3iPYxcXdgtEStvTT1DkG74uflOnTsn7pq0lUdTeOkTqZlZz6NUwaRKdf+xQN8uOIzeSOR89mt1Ax7z6br/acWOFXpUzDFXS4PhQk9/m8Qb7FEEKds+VYZUmiB+DnLKU1mQJyo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for implementing allocation from FREETYPE_UNMAPPED lists.

Since it works nicely with the existing allocator logic, and also offers
a simple way to amortize TLB flushing costs, __GFP_UNMAPPED will be
implemented by changing mappings at pageblock granularity. Therefore,
encode the mapping state in the pageblock flags.

Also add the necessary logic to record this from a freetype, and
reconstruct a freetype from the pageblock flags.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/pageblock-flags.h | 10 ++++++++++
 mm/page_alloc.c                 | 33 +++++++++++++++++++++++++--------
 2 files changed, 35 insertions(+), 8 deletions(-)

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
index d16f7b7bdf282..994ddcb132aed 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -357,11 +357,8 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
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
 
@@ -434,9 +431,20 @@ __always_inline freetype_t
 __get_pfnblock_freetype(const struct page *page, unsigned long pfn,
 			bool ignore_iso)
 {
-	int mt = get_pfnblock_migratetype(page, pfn);
+	unsigned long mask = PAGEBLOCK_FREETYPE_MASK;
+	enum migratetype migratetype;
+	unsigned int ft_flags;
+	unsigned long flags;
 
-	return migrate_to_freetype(mt, 0);
+	flags = __get_pfnblock_flags_mask(page, pfn, mask);
+	ft_flags = (flags & PAGEBLOCK_FREETYPE_FLAGS_MASK) >> PB_freetype_flags;
+
+	migratetype = flags & PAGEBLOCK_MIGRATETYPE_MASK;
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (!ignore_iso && flags & BIT(PB_migrate_isolate))
+		migratetype = MIGRATE_ISOLATE;
+#endif
+	return migrate_to_freetype(migratetype, ft_flags);
 }
 
 /**
@@ -570,6 +578,15 @@ static void set_pageblock_migratetype(struct page *page,
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
@@ -593,7 +610,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		flags |= BIT(PB_migrate_isolate);
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
+				  PAGEBLOCK_FREETYPE_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM

-- 
2.51.2


