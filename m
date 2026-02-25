Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2619EFD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34666B00D9; Wed, 25 Feb 2026 11:35:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB096B00DA; Wed, 25 Feb 2026 11:35:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDDDD6B00DB; Wed, 25 Feb 2026 11:35:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96F6E6B00D9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:35:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6885F140696
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:35:04 +0000 (UTC)
X-FDA: 84483528528.22.E4FB28B
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id B01A91C0014
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:35:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fnTq0GDN;
	spf=pass (imf18.hostedemail.com: domain of 3tCSfaQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3tCSfaQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IxPs+shi9o6AXlEGCilkkLX6RGxoXvE/7sr5zHVQPU=;
	b=foZrrWJ31R1kUGHkTp3xqTJK5H5D37r1jS2PGoWLOtqb/VDQtv+9GE9LrorMuGf94eRzuZ
	zniKC5C4ANgT5d/ggVbgS9ChJVxz0q+6ovr55V2LNZ2a+GSU7FcKM/YMNCmiY+AoZ3R1PR
	VIkJMZMKQivSPJS/qouV5gdrSOdgSLs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fnTq0GDN;
	spf=pass (imf18.hostedemail.com: domain of 3tCSfaQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3tCSfaQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037302; a=rsa-sha256;
	cv=none;
	b=EPCGCyzDZoPiHVErhuMW3XlieCXU5xbVw8qeD4yOTj9hVbsQiiIn+uSplBn3+TR0Z7Rvim
	xmRhPMx2c5Ak+771sWpbPSRY/JFT8QFIgnn8s/mGd1EFcGnR7ev6SaA7YcuwkT7W+VJszI
	fp1PRwRxrK1O2kZYga23A7e9eqhg1FY=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43990373d35so613818f8f.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037301; x=1772642101; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8IxPs+shi9o6AXlEGCilkkLX6RGxoXvE/7sr5zHVQPU=;
        b=fnTq0GDN3eS4vzuNSHfQMf1cv7MxBkcSg3BgdD9NHvYUs9iRcINkKxJEQvY2LnCfnT
         2lSgcr3A9sug1lA+y03M37Txbt1sEGlKVnwQQjYcbToq1/JvTQV29G1CSsKVbbqjSc08
         LvzJ0lWwmjU0e/qtkjIoGrUBM+EIN3JOCn67ehCWijIJu3iqGaS/IMr4oiCxFw5fyUDi
         fxoqxelGFzBO9N7AsSCjvGFYjq/TKh3fRslAZHUmGp6+1q+pwC0voAROt8RiUeFh1zmX
         tlNCAEzIQwibrf+s8mnWzx/gzehE6zn0SQKcWjFoEUj/pot1bIXx+KJRgx2umcZPwqx6
         lv/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037301; x=1772642101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8IxPs+shi9o6AXlEGCilkkLX6RGxoXvE/7sr5zHVQPU=;
        b=alBKxlO/xfKcCNeY1Nlp2edILuNhiKZtnd+PMuN5VvRqII5oFIbpZTYYa5tprgu6tM
         v6ghdJTRLxFLF4stjM0IeVmM0AE55c5FPA72kLEdQPwiTxNPKuHn4j3FcqS+SGqFmudm
         +ASyGZSmCXk/22HRlHmdSVNVs+ZvZfa8U2J1BC99nXzlHhYmyreSK14UecMzrzr6IttP
         iRZ6SCRioYvTBtKEEGmRETZ4uH5ymQ8MUsLSMpOTTJIhrcyVTRMLzAcq51LemQgIdnRE
         sqMjAZ5LvXWnu3NTyr48ZttBRHZ8WbPXQ0cSEoLlsRYdAr/x4rznv6sQ5mnz8BVZs6OO
         AJjg==
X-Gm-Message-State: AOJu0YxBoHLvFuG2rBuYORW/wgFVywL+Zqsz73PZiNO6hZ0sFKaCrc9X
	J0tHpceRa1E9IzMMbPMEing63wqccj0rHpee7t28kNnix1tVrx7v1fcr3EFXWehGHuJNiU+aWvF
	MqA6ncvJBvB0mVQ==
X-Received: from wrph15.prod.google.com ([2002:adf:f4cf:0:b0:42f:b132:61e6])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:64c6:0:b0:435:b755:c67e with SMTP id ffacd0b85a97d-439942fbd3cmr2235545f8f.49.1772037300603;
 Wed, 25 Feb 2026 08:35:00 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:43 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-18-e8808a03cd66@google.com>
Subject: [PATCH RFC 18/19] mm/page_alloc: implement __GFP_UNMAPPED|__GFP_ZERO allocations
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B01A91C0014
X-Stat-Signature: ggrbd7k3uzp15ro99mjkutj7cs8khz35
X-Rspam-User: 
X-HE-Tag: 1772037302-620494
X-HE-Meta: U2FsdGVkX18B/VM57Vlx42VL+visEBfVEyHyhdUoCN86VO/CAlbcW/0ts5UxCC5fAEQ26YKDw0NLnng5cuwvtQjqhhxRvjIa6RhPeB4jdcxco75jmO04JXyaG3dkIiJTJSQV+CSeO9Y8X1GZ1sRHIINykb4Q5OQZXhKJmocWdqMhi+mqCMKmohiHFBTZqkm7lHJXx1QS/2UZuSSvgM7mbW03PN4nMDz3BaTi5TpA67rCSyY9IOBE13NZWk/l1H3kSqaYmTJfGc5IS4TRcAVlx1viIWWNL+v/fQ3ao5jAcXXftvjMVz/FA0EIPmyUB/xA5uwjmwWp1M4/ty3CrDzOmMVKbHqhuik0f1iBZqr5LgkqSDmtfrz/PwGBZ8S8ofJiNiidXxiiRnblotc5EJ11dlKHNMjsGYxSUsbSN1lHYPhWltPyIqcukqdXCFMfTjLt4jooBk7nQr5SFHIituREbjQvSBP4dcheI3jJbKysYdMRIbdBzpArM6cBjD9YFbVKobsL5IZUYNd5ePcp25d5lJux92dc4e8sFlSzIwJ3wHaDPyJvA7OQsLaufGpdhzMXpmqWuLMnZUV+DeG7Lh0V63O/yM8GjDTEZhgt1C2MWGPi2/nfFpuY3TzmKFaBoktAyQ1IRVptLJxlAfIwc7Q43c/z0rvs6d+66cL/+J5rCt15zCAcbOTFH+Xk3D+8mFF7d8s6g7oWHTsTh6FwpXcgryihTdMBWvpT6SSzxYdJtmvzFpL2oE4z8q71U141OsOmGea+CorUjjx+ARQ9XTc9rHWqitn572Pue/81M04n5wid13lB/4MgMSI8mORh86hEMcKjzNM9lbj+sT264fv17bEiK5AnE0e3nkUNTGrWJ/UTEVHdDe8U1Xvvc7Et/E+vv3yY1op4p8zqh76vgGW6st5H026In86f9oeMBS1h8/ojAC6zA11UwExsNAYYQ6XqTe2vNtjO1ftldGzWpzS
 fiK4XoCs
 AsjmnGWv2WMU/Ol12jbEPCUDRmr4fPGR2Npuj5mqvp0iBM9l1p7PPNtyWIhpcGGnxV1OIY70hX+WzV/u33NLIK/Lj+/WS2AEUJHMP0Bx05hbSM26Q8LZfdfxdkPfYt5BHNvqABO4ytGoSqiaj61h67fELZAXjnIE/y+4QlhLMUf6MTxo6OmsOiCsspEo7InDZOChk5xkDYBJ9Tck9FgsXDa9zVU81Bdww5JgNaHoYoyk3cWR778vAh71CObszH19RCqZ440adnbq8zvtLnhn+rMs0MnEhyrKCO0DlkjbSNsO2l8HFfVfRtAGwqSFpKWI3s16V+ZWDyhVVpyFYmXnIYc8HQ3cVO8vzv0CHs7lJXu8BwySK7OBp5nsn+kasiu3uFwch/LQ7RgwUsRlpjzjUl9Ld0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pages being zeroed here are unmapped, so they can't be zeroed via
the direct map. Temporarily mapping them in the direct map is not
possible because:

- In general this requires allocating pagetables,

- Unmapping them would require a TLB shootdown, which can't be done in
  general from the allocator (x86 requires IRQs on).

Therefore, use the new mermap mechanism to zero these pages.

The main mermap API is expected to fail very often. In order to avoid
needing to fail allocations when that happens, instead fallback to the
special mermap_get_reserved() variant, which is less efficient.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/pgtable_types.h |  2 +
 mm/Kconfig                           | 12 +++++-
 mm/page_alloc.c                      | 76 +++++++++++++++++++++++++++++++-----
 3 files changed, 79 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 2ec250ba467e2..c3d73bdfff1fa 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -223,6 +223,7 @@ enum page_cache_mode {
 #define __PAGE_KERNEL_RO	 (__PP|   0|   0|___A|__NX|   0|   0|___G)
 #define __PAGE_KERNEL_ROX	 (__PP|   0|   0|___A|   0|   0|   0|___G)
 #define __PAGE_KERNEL		 (__PP|__RW|   0|___A|__NX|___D|   0|___G)
+#define __PAGE_KERNEL_NOGLOBAL	 (__PP|__RW|   0|___A|__NX|___D|   0|   0)
 #define __PAGE_KERNEL_EXEC	 (__PP|__RW|   0|___A|   0|___D|   0|___G)
 #define __PAGE_KERNEL_NOCACHE	 (__PP|__RW|   0|___A|__NX|___D|   0|___G| __NC)
 #define __PAGE_KERNEL_VVAR	 (__PP|   0|_USR|___A|__NX|   0|   0|___G)
@@ -245,6 +246,7 @@ enum page_cache_mode {
 #define __pgprot_mask(x)	__pgprot((x) & __default_kernel_pte_mask)
 
 #define PAGE_KERNEL		__pgprot_mask(__PAGE_KERNEL            | _ENC)
+#define PAGE_KERNEL_NOGLOBAL	__pgprot_mask(__PAGE_KERNEL_NOGLOBAL   | _ENC)
 #define PAGE_KERNEL_NOENC	__pgprot_mask(__PAGE_KERNEL            |    0)
 #define PAGE_KERNEL_RO		__pgprot_mask(__PAGE_KERNEL_RO         | _ENC)
 #define PAGE_KERNEL_EXEC	__pgprot_mask(__PAGE_KERNEL_EXEC       | _ENC)
diff --git a/mm/Kconfig b/mm/Kconfig
index 3200ea8836432..134c6aab6fc50 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1503,7 +1503,15 @@ config MERMAP_KUNIT_TEST
 	  If unsure, say N.
 
 config PAGE_ALLOC_UNMAPPED
-	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
-	default COMPILE_TEST
+	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST || KUNIT
+	default COMPILE_TEST || KUNIT
+	depends on MERMAP
+
+config PAGE_ALLOC_KUNIT_TESTS
+	tristate "KUnit tests for the page allocator" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Builds KUnit tests for the page allocator.
 
 endmenu
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f7754080dd25b..9b35e91dadeb5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -14,6 +14,7 @@
  *          (lots of bits borrowed from Ingo Molnar & Andrew Morton)
  */
 
+#include <linux/mermap.h>
 #include <linux/stddef.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
@@ -1365,15 +1366,72 @@ static inline bool should_skip_kasan_poison(struct page *page)
 	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
-static void kernel_init_pages(struct page *page, int numpages)
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+static inline bool pageblock_unmapped(struct page *page)
 {
-	int i;
+	return freetype_flags(get_pageblock_freetype(page)) & FREETYPE_UNMAPPED;
+}
 
-	/* s390's use of memset() could override KASAN redzones. */
-	kasan_disable_current();
-	for (i = 0; i < numpages; i++)
-		clear_highpage_kasan_tagged(page + i);
-	kasan_enable_current();
+static inline void clear_page_mermap(struct page *page, unsigned int numpages)
+{
+	void *mermap;
+
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHMEM));
+
+	/* Fast path: single mapping (may fail under preemption). */
+	mermap = mermap_get(page, numpages << PAGE_SHIFT, PAGE_KERNEL_NOGLOBAL);
+	if (mermap) {
+		void *buf = kasan_reset_tag(mermap_addr(mermap));
+
+		for (int i = 0; i < numpages; i++)
+			clear_page(buf + (i << PAGE_SHIFT));
+		mermap_put(mermap);
+		return;
+	}
+
+	/* Slow path, map each page individually (always succeeds). */
+	for (int i = 0; i < numpages; i++) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		mermap = mermap_get_reserved(page + i, PAGE_KERNEL);
+		clear_page(kasan_reset_tag(mermap_addr(mermap)));
+		mermap_put(mermap);
+		local_irq_restore(flags);
+	}
+}
+#else
+static inline bool pageblock_unmapped(struct page *page)
+{
+	return false;
+}
+
+static inline void clear_page_mermap(struct page *page, unsigned int numpages)
+{
+	BUG();
+}
+#endif
+
+static void kernel_init_pages(struct page *page, unsigned int numpages)
+{
+	int num_blocks = DIV_ROUND_UP(numpages, pageblock_nr_pages);
+
+	for (int block = 0; block < num_blocks; block++) {
+		struct page *block_page = page + (block << pageblock_order);
+		bool unmapped = pageblock_unmapped(block_page);
+
+		/* s390's use of memset() could override KASAN redzones. */
+		kasan_disable_current();
+		if (unmapped) {
+			clear_page_mermap(page, numpages);
+		} else {
+			for (int i = 0; i < min(numpages, pageblock_nr_pages); i++)
+				clear_highpage_kasan_tagged(block_page + i);
+		}
+		kasan_enable_current();
+
+		numpages -= pageblock_nr_pages;
+	}
 }
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
@@ -5284,8 +5342,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	ac->nodemask = nodemask;
 	ac->freetype = gfp_freetype(gfp_mask);
 
-	/* Not implemented yet. */
-	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED && gfp_mask & __GFP_ZERO)
+	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED &&
+	    WARN_ON(!mermap_ready()))
 		return false;
 
 	if (cpusets_enabled()) {

-- 
2.51.2


