Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8CD41099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2767F6B010A; Fri, 20 Mar 2026 14:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B12F6B010D; Fri, 20 Mar 2026 14:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F646B010E; Fri, 20 Mar 2026 14:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D6DB86B010A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1F1DC1895
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:12 +0000 (UTC)
X-FDA: 84567265944.02.9576C42
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id C7EDD18000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=waJgju6v;
	spf=pass (imf06.hostedemail.com: domain of 3yZC9aQgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3yZC9aQgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDyJ1t2Ao3Sy5T6GqN9GajMItk/yFlj6HTa9OXsypQ4=;
	b=0uez6oRiz6yTqjNyBF/MESEJf2bXtF5rFwLKORTD8j+CwjfmV84l/RW3c+Pqbi5y/12pDw
	4w9IVCDIPKMhZUbIUBFdopy3ASBtXNxZt6ZnS107XEcNL9Eb2T6MC47JVqlUHRa0DX4Uos
	Se2q7zRl1O2iz9ov928+H9jUrN6FydA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031050; a=rsa-sha256;
	cv=none;
	b=nSyc6ktKWwVl9RtHMDFohw2J9ej3bZ1aJvVM+KmOyS9pxBghpLTHikqjm55zSH0zeSTOyO
	IILZWmhJ1YJ2JYW8Hv0KtU7X8bdT4zB46Zv0si3Jw/HGA3VOLDd5Lx2S+xxD+hWBa4CKOR
	ffs9E/chWDO8KILeaUmvFZC+yixVlMw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=waJgju6v;
	spf=pass (imf06.hostedemail.com: domain of 3yZC9aQgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3yZC9aQgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485375aa56eso8939865e9.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031049; x=1774635849; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SDyJ1t2Ao3Sy5T6GqN9GajMItk/yFlj6HTa9OXsypQ4=;
        b=waJgju6vBEt6YsWRgvUx7lKQCX7Eje560KzZP+aQtb4T6bJxFj3EiCidNxyqD4TIar
         BUWmOrkpHVBvWZAH7FY12Nvlfu1SuCKvomvgzhH69su0hMXRmFFZBcVRL1DkIvtcO8VJ
         kBOcZZzTzejjuKdlvToV6GuBAbfUNF7ReKbkYql/kL8lEPqGUQJs3B1bRyuX6juZCDaX
         qXo9FBAJxggEPPi10+sAXV1FUL4HagSRxM+fu5L4wHC6t3LnXtIWxBl/lFQ7FraSA5N9
         zcHCNyb07qOcc2uZ0I+uhk4oc6fHC6ToQxtUL4/FgtDQc7qjExQp8AfuM1iQkLO1QM/Q
         a8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031049; x=1774635849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDyJ1t2Ao3Sy5T6GqN9GajMItk/yFlj6HTa9OXsypQ4=;
        b=gJoE02ygkdo02VKNJNGdWb+TPlIyK/Xam3vitylOfSaQcXqInlthDi09h+WopkMHNi
         KoNgfvVA+cytoRfc+64P+YAtlcWhpsaTwujLfiy3YyhztH9zaB8ah7g7dmO2Z8UguUYO
         DG/tokGWA0udGQh4XMO1DnP9ttdT0fJy6vdEBzoBhaTah+3AZeztpaUqKqRpBZbmyKKu
         y8oujubTtKfuW8d/Yd/4BzaZA8bDBGu0jIbC7g6T2cpKe9gCVSQdL4tjrOeGHX+Zzoni
         ROYkT3cYUKxCDFFiw9lWY+Ocm7nJ7o87OZl+vExb48QsfE6N5PfZBXPjWDb+6bZlzfSE
         S+jA==
X-Gm-Message-State: AOJu0YxrGf0H8GC7NI6cEJvQwSqtbcZFTTgj1eS5hJZjtmot+WdTbZN/
	V4PzSPoK5A6V6CLmgLx5iZJli/ft1f4ucFGUV8jlnpVV69Te+aeW54/kg874uLJaj1uwCyD5ND1
	vPH+WAXnQJiC5jQ==
X-Received: from wmbhi3.prod.google.com ([2002:a05:600c:5343:b0:47f:941a:613d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:524e:b0:485:3ae8:2231 with SMTP id 5b1f17b1804b1-486ff01efd8mr58852475e9.30.1774031049299;
 Fri, 20 Mar 2026 11:24:09 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:44 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-20-28bf1bd54f41@google.com>
Subject: [PATCH v2 20/22] mm/page_alloc: implement __GFP_UNMAPPED|__GFP_ZERO allocations
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C7EDD18000B
X-Stat-Signature: pifjf8618zana511bnfrq8cmg64d5uwh
X-Rspam-User: 
X-HE-Tag: 1774031050-306199
X-HE-Meta: U2FsdGVkX18nJYFm+mJehnkZ/coMhaVj0HJxjoqoeu+QJVMvY/8fi7qKO9sB1gskidsqLtBgT8uttsQ8g5QWooAVyBOnjTx3ffYlExJs0+cdAUpsHk0JEGTW4k1JuCR3zlD7GUobjd+fxPyQK8k07Ds01B1bYsRXQfyb2PpXHoTC+Q9lw/LF32YDg24NJXj7eNSsFbzpjHWXjd7adcqhtBlgNbPnRGPjaaQa51oXFFj/6W5ZaEnhp07ZTxsVyNBFaxjrZaDEv6K05PUYxLXSZ5m7arjb6QdVszme5V/vp0EKFQZYKp//kQ2frCKmKnNFPL2WYe8NcrdD9+NTsTqzYDTDdKeZw0Hb50gRHKTNGddaHcmmTugxj2S48B0b6Rx1SqNZiksZMKUjO02ynrbrZb/kju3XULg9hRK+qquhdSX+TRnlZVzZVkKAMBBQzZee8Y7f8LQY2HCZ4fd6j9DmCSVv4S5wsaQSRNiRk+bEfxgFn4DtwBLQ0i1bh6FuDUta+abZMUWTZoowG8YSl0i3qiGi88uCT87jQK/7nldjOjUBw0SKzI7JUuAbY8GPrtexIK46iLQV4uhrZeyIAwrRoOrm/zm4rEG0tUpWJHPQE7JjlbwT3wsccMbumHz3IFn7luHChYVAWpQjrFzhB2TreTVyHeNtFwezuB4ssz1F/te3Ahx/sjxnS4I2TqR2nBgLbnpQr2kTSibEgayu2bfpdzC9tLaHZzTNyCaMa/X0l9WfTjkV+Kj7szOJ3ZxZ3QcBFeiVSWJWwnE2ETZ/7i26l4ZjpsKBCw5tQGbyBGyZpLa5W6dy0VkbY/hXqWdng/vPHIpQYMDvBXtBigKW1Er4gKk5ixqDP+gT1OVBXTEZ4MbSqRnuYR0nod6U+uxcGAGyudGQR4KxvKwF3Wm5Guz+Fd2nhuP90cSs3mwCPHsPtVNwn8++73neIBPrtXEDlJkK5sqG++ceTLByGyht+6l
 CwNbKG/1
 PmIo9ufPwFYWMtmfPAemQgXT9r9t6vTsy6DOrRJXBkpLGyPLZk4i39fZXq7o0nJW9srBHxJ1BbaPQKLdtvnOemy+GL8cnk/eVlEjTrKZ5ZaOe/MOtvDxs1PJ/j6QVL50Uh048CdRCdYJzyehzWlU/2iBON4ZMQqeH1PAGZNLoew6pixdG+Gc5c3bDIODEjb3wAbaRzQCmnzDi866arRUiG6Hv5IEAhX2cJgcnXC/Z8PZMlIPno9zedeFdC1EudEVaFyZJsIHeveIRgmmsnV9mJfaLoGvMYIDSfNrA7j0++Hx3Xjj/RKwZyY5X1L+YHF8kCFEScBKaqHrA61V2VZytjetTq/qDIBrQQIMOGeZTZJfiopr8V8N74vQDxik6Y2QO3u33UqASmBM9yGDkau9p6pj6aqfUj+PJrVkwtPQxHCz4q+NX1oIcH4BtnaU9+NArklmivslFkNuISerCuRisHsgB6TWS2G5/XzdMXMWr/RYr9frHboGXpzEZvGcc8f9kjdk6yTSRiKhJtgmHzzSJd/GOQ9q80jlr4AvYw74nN2EJpcSXtADjl2ByvkH0HOBqn998toPKdRsSTTpMa01QnXi8QGNqfH2hFS8eBTPB4or2vMLsvAzlDa667End9LKvKCD+
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
 mm/Kconfig                           | 11 +++++-
 mm/page_alloc.c                      | 76 +++++++++++++++++++++++++++++++-----
 3 files changed, 78 insertions(+), 11 deletions(-)

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
index e4cb52149acad..05b2bb841d0e0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1506,7 +1506,14 @@ config MERMAP_KUNIT_TEST
 	  If unsure, say N.
 
 config PAGE_ALLOC_UNMAPPED
-	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
-	default COMPILE_TEST
+	bool "Support allocating pages that aren't in the direct map"
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
index 710ee9f46d467..7c91dcbe32576 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -14,6 +14,7 @@
  *          (lots of bits borrowed from Ingo Molnar & Andrew Morton)
  */
 
+#include <linux/mermap.h>
 #include <linux/stddef.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
@@ -1327,15 +1328,72 @@ static inline bool should_skip_kasan_poison(struct page *page)
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
+		mermap = mermap_get_reserved(page + i, PAGE_KERNEL_NOGLOBAL);
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
+			clear_page_mermap(block_page, numpages);
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
@@ -5250,8 +5308,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
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


