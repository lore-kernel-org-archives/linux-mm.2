Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE55FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D3A6B00C2; Wed, 25 Feb 2026 11:34:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BABA6B00C3; Wed, 25 Feb 2026 11:34:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D8C6B00C4; Wed, 25 Feb 2026 11:34:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADD96B00C2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B3B51A0642
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:44 +0000 (UTC)
X-FDA: 84483527688.07.6A10A87
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3061CA0014
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jIIqc2LL;
	spf=pass (imf25.hostedemail.com: domain of 3oCSfaQgKCLkiZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3oCSfaQgKCLkiZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6dMpkYViAUrdEwSDReAldFnaFb5enKamHBWexZy16E=;
	b=FUMXxbmOs0zxVFVQRW+oEUqbsQaB29umUrDb2Ws3BEJ70Atgrbt2ypYRmuFPBOwQNVqhcp
	DCBv1C0U+ViPDWp7jIdZohHJk25p1H0YmXaX6pFNxEcalxGRTnok19VNMUSGEchd8C2to7
	vcLzWII4rZGvAO6IZO3ygW4roZ2McVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037282; a=rsa-sha256;
	cv=none;
	b=qiPu4vnQjT/+PTjNPH8NNpdR+uZG9dKQmIXNYDmQQh/JUBZJuyzq9rXJKLJ5Os30Mhit2d
	PUZH0I5X+UPJEbYzHZiR0uGr3ZB9gbpnI9aRielA2BmOAWI3TrBe/MiAQjtbpTrurW1g6o
	zqSoxXDnpmpA8NsDwKHxGkPBQF+iQ0Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jIIqc2LL;
	spf=pass (imf25.hostedemail.com: domain of 3oCSfaQgKCLkiZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3oCSfaQgKCLkiZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-483bcfdaf7dso18350365e9.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037281; x=1772642081; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l6dMpkYViAUrdEwSDReAldFnaFb5enKamHBWexZy16E=;
        b=jIIqc2LLxXzno4pmzmGiDLwgZcj8UQup6gTvJZTJ6xjwh+MCkOb5vNAzC9DH7/vK+A
         cmaO4I7W4e+XtS3zF6SHbZw4dVL70XbfLV2wwagmNrzWrGyk2TH3zmTAmvVQORZvsHte
         2e/hhrsBGXSGPQWwkcjVw18HA/baai6od2XzKuPNe6wvEU5Cvm3iDwgNQSbRFQSb4ZGH
         kiAM2CX9K/BrYyyY7AYPnkzB4lj8LqrP+e3mTpKAUEAYhJpM6r3jCjHDWcg0fnXrQ+3J
         0LPeL9gL8cFAC+bNXFjulniPbBPwVW2pHP5rv/kml/EOSZubK0Z3cFNwTw+BXoINh+9k
         fxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037281; x=1772642081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l6dMpkYViAUrdEwSDReAldFnaFb5enKamHBWexZy16E=;
        b=sdwaJOvsY418ltlv6sWobBqnFKQW/7b6EydcJNFii7RPH51pNDwMqrMFMriH0nDvJz
         OCX3uTk2SPsrgi476Vu9GnDSUZiZBGUqumHI0NUe4SV5xTIefdVC35pksPJv7ryGhSgD
         FdOwNVHituvufPnDE3C2GJhltoPDCqCHFIt3XNhY5zHpQwrELZgSDT4hmFzaXem39/Dn
         C8+ahYhTZv57389r/dg8f4aFb2FWNLOEpi7jKPMtpDXTQC2TDt0YNWBBMQiJB1/NLM17
         kkeXzw+/gNvHUGHuB22UMh5mJTa+OQ/ZACnZwTNcn3CrpgWvbLyguCbqySu/JbNivh3r
         lz0g==
X-Gm-Message-State: AOJu0Yy8vs8GQwJb1sZInM2DXPEj0N9itx3Ui/OGFfLu1qwTfbjBPpbK
	Nj+y3syc07KJTwaGn2+xTphUhWqd1gTsuYsBo3OWA9YAttIQstyO7uhnUqgvMO3ia1MUwQghoB9
	k+2UTf4RBsoa7cg==
X-Received: from wmhx9.prod.google.com ([2002:a05:600c:4209:b0:47e:e922:b080])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8444:20b0:483:afbb:a086 with SMTP id 5b1f17b1804b1-483afbba1e8mr149626355e9.29.1772037280597;
 Wed, 25 Feb 2026 08:34:40 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:29 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-4-e8808a03cd66@google.com>
Subject: [PATCH RFC 04/19] x86/mm: introduce the mermap
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
X-Rspamd-Server: rspam09
X-Stat-Signature: 189njhf7tnfpccwwfp4f4yi1b16jjzia
X-Rspamd-Queue-Id: 3061CA0014
X-Rspam-User: 
X-HE-Tag: 1772037281-335354
X-HE-Meta: U2FsdGVkX1/MGjjeU4JWiVVfHV2bo53GtKgtzYruTpen6H7ckDFT+u3rZYeutc8BN3CRrSFcMXS8qsF9RIk22eydMRbOKbyVxTazk/BXG7XXjdv8f/WVcPtLwpHV3bY4KUyx4LvC1b+cksqP1JnHfV1IJdpYIJwrRuLQZ36UPPruEJ2HG6mZVqHowB/ZEuyDWtgDL2rUU5jmSLCIWrC7Vp07Ml/hZ5EZkwoTv2DxxyJiv4NPnGivWwjIp6BVg+tgEfpw6kDh/z3SK6aH/DpuugkEjyfN2m5Y6zuWZbsoUy47jZvFzEECFJimMHpwMo4HQNo4cfuqngSVAsaqW1DKpfrimyPBintWM2HFjD9RDCJOq/OjJ20vI719VVTrGArKH9KTh/sHJK101Vujq02Z93jdWKR1J/FG49wiDYlmQE3VqcLb4WpP8n25p140TcY43hSEOSu/vOc/kKuAFNyD1SpEg7KKQEHinyln3qUmjP/dmSfoJRTOWUAl+gkO0XYUwl+qYGmDB7bPy4SM/1Wl1MYP4j8yu/9kBcuKqKa74hdv+/DX5/CBXZ+a0bbySZWDY4Y8j/aTPocrMbLbuxi1hz6Y9mrIgUn73dYL/jjD40bO/iD2abfmUbyPDPwmUe5/rwbtSypN5sYCa3p7ZwUGqZ2w1fI4WZmWbSxx3CDOwqv1GfsehPQ5BvsDK0OQbapu+m6mY050oCGNumsrVEveVOiI02f9yoXHNKANcqnbbG/ZLHdDjOwy+hdFwWLD12xgauNVM2ixQN/2a1xmkQUXU1AVVjwckEjftokuyZyMYkaPspTIshIPyoUnorbpDuA721BucLzrpcIyPuObKnkT8H3SDb1Lup/wh8LBXHwjzlTFz9f+IoqVos63rmtFQyVQCsxeqAEKTSWiWpIpba5ifX2HUFWL2OsTOfh3Uq3YIRCjUZF7EJNPQ/j/mV2JnljukkGkTH75o0ICKIzhZT2
 IcKiyPTF
 i7te23zPlC28JHa2lA/INcrIT/+Wx3opVyh8ml1vjgdkLB4wiSdh/A0f6R1D+Q/2p+//kpp2Jkuvd+HkpPm9nDsBFULAlskxz5tn1AQfQBUNKoOMO47k4yQZuaqqOuLtcbCG/oJ510IMXvNSaXwPi0bLf/6UJl9Mv1tXpKvuiEaz9XLSWq1jYdb3BUpP2m/9t3GorkAdilKlQNzKWD17yLtSeBd76Bnw/Fe4QFauIJXzs0KmuGJMZ8MynlZpx1ajePxAD537QL06Z/O8DpilhOg04ySvjmYmEbTErXDYhiPemkfxmn/rcaraTFzsX6Gn/LREl8Uwbi1M0Yyc9FWU1zkP76Y/4sH2RRJWaF/sPYxvuf25/Jtow2gL2qrc0ovTgYU+TCZnZTQyV0iWc2nD8o/1Gj4gM/Lu3RvBlz9ghR3yS5V8o+s+TK+A7Gme4HvK0qnXNNEhBWjv9EDqQ+jYbwFZgZhUtGvZZAPn0Ge2RuSKAsYT81+FAhj62BR0CuCM7s0Cs9/o3ifuQuwDv9BfJATu8ULmFvtNLXCf69TjfP5NuJMBAjpGWHQLjr73CKKVmk1ljTZtQ3UxZVPmGmsQzFeJZRvDRvH8PlIdxX7aUR/P012nY6+Z09qBjyHUQCnRv6ObEIzXaAm+eTFWj6cPVxcsCMZshTGDUry9hrpe1n8x3xpzMzz5a0RuDquNxqt938zrREhNJYsXC4dW/nAgSXgBMat1M4J0awOss
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mermap provides a fast way to create ephemeral mm-local mappings of
physical pages. The purpose of this is to access pages that have been
removed from the direct map. Potential use cases are:

1. For zeroing __GFP_UNMAPPED pages (added in a later patch).

2. For populating guest_memfd pages that are protected by the
   GUEST_MEMFD_NO_DIRECT_MAP feature [0].

3. For efficient access of pages protected by Address Space Isolation
   [1].

[0] https://lore.kernel.org/all/20250924151101.2225820-1-patrick.roy@campus.lmu.de/
[1] https://linuxasi.dev

The details of this mechanism are described in the API comments. However
the key idea is to use CPU-local virtual regions to avoid a need for
synchronizing. On x86, this can also be used to prevent TLB shootdowns.

Because the virtual region is CPU-local, allocating from the mermap
disables migration. The caller is forbidden to use the returned value
from any other context, and migration is re-enabled when it's freed.

One might notice that mermap_get() bears a strong similarity to
kmap_local_page(). The most important differences between mermap_get()
and kmap_local_page() are:

1. mermap_get() allows mapping variable sizes while kmap_local_page()
   specifically maps a single order-0 page.
2. As a consequence of 1 (combined with the need for mermap_get() to be
   an extremely simple allocator), mermap_get() should be expected to
   fail, while kmap_local_page() is guaranteed to work up to a certain
   degree of nesting.
3. While the mappings provided by kmap_local_page() are _logically_
   local to the calling context (it's a bug for software to access them
   from elsewhere), they are _physically_ installed into the shared
   kernel pagetables. This means their locality doesn't provide any
   protection from hardware attacks. In contrast, the mermap is
   physically local to the creating mm, taking advantage of the new
   mm-local kernel address region.

So that the mermap is available even in contexts where failure is not
tolerable there is also a _reserved() variant, which is fixed at
allocating a single base page. This is useful, for example, for zeroing
__GFP_UNMAPPED pages, where handling failure would be extremely
inconvenient. The _reserved() variant is simply implemented by leaving
one base-page space unavailable for non-_reserved allocations, and
requiring an atomic context.

This mechanism obviously requires manipulating pagetables. The kernel
doesn't have a "library" that is 100% suitable for the mermap's needs
here. This is resolved with a hack, namely exploiting
apply_to[_existing_page_range(), which is _almost_ suitable for the
requirements. This will need some later refactoring (perhaps creating
the "library") to resolve the hacks it introduces, which are:

1. It introduces an indirect branch, which is likely to be pretty slow
   on some platforms.

2. It uses a magic sentinel pagetable value, instead of pte_none(), for
   unmapped regions, to trick apply_to_existing_page_range() into
   operating on them (while still ensuring no pagetable allocations take
   place).

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/mermap.h           |  23 +++
 arch/x86/include/asm/pgtable_64_types.h |   8 +-
 include/linux/mermap.h                  |  63 +++++++
 include/linux/mermap_types.h            |  43 +++++
 include/linux/mm_types.h                |   4 +
 kernel/fork.c                           |   5 +
 mm/Kconfig                              |  11 ++
 mm/Makefile                             |   1 +
 mm/mermap.c                             | 319 ++++++++++++++++++++++++++++++++
 mm/pgalloc-track.h                      |   6 +
 11 files changed, 483 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bf68dcea3fee..c8b5b787ab5fb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -37,6 +37,7 @@ config X86_64
 	select ZONE_DMA32
 	select EXECMEM if DYNAMIC_FTRACE
 	select ACPI_MRRM if ACPI
+	select ARCH_SUPPORTS_MERMAP
 
 config FORCE_DYNAMIC_FTRACE
 	def_bool y
diff --git a/arch/x86/include/asm/mermap.h b/arch/x86/include/asm/mermap.h
new file mode 100644
index 0000000000000..9d7614716b718
--- /dev/null
+++ b/arch/x86/include/asm/mermap.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_MERMAP_H
+#define _ASM_X86_MERMAP_H
+
+#include <asm/tlbflush.h>
+
+static inline void arch_mermap_flush_tlb(void)
+{
+	/*
+	 * No shootdown allowed, IRQs may be off. Luckily other CPUs are not
+	 * allowed to access our region so the stale mappings are harmless, as
+	 * long as they still point to data belonging to this process.
+	 */
+	__flush_tlb_all();
+}
+
+static inline bool arch_mermap_pgprot_allowed(pgprot_t prot)
+{
+	/* Mermap is mm-local so global mappings would be a bug. */
+	return !(pgprot_val(prot) & _PAGE_GLOBAL);
+}
+
+#endif /* _ASM_X86_MERMAP_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index cfb51b65b5ce9..b1d0bd6813cc7 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -105,12 +105,18 @@ extern unsigned int ptrs_per_p4d;
 
 #define MM_LOCAL_PGD_ENTRY	-240UL
 #define MM_LOCAL_BASE_ADDR	(MM_LOCAL_PGD_ENTRY << PGDIR_SHIFT)
-#define MM_LOCAL_END_ADDR	((MM_LOCAL_PGD_ENTRY + 1) << PGDIR_SHIFT)
+#define MM_LOCAL_START_ADDR	((MM_LOCAL_PGD_ENTRY) << PGDIR_SHIFT)
+#define MM_LOCAL_END_ADDR	(MM_LOCAL_START_ADDR + (1UL << PGDIR_SHIFT))
 
 #define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
 #define LDT_REMAP_SIZE		PMD_SIZE
 #define LDT_END_ADDR		(LDT_BASE_ADDR + LDT_REMAP_SIZE)
 
+#define MERMAP_BASE_ADDR	LDT_END_ADDR
+#define MERMAP_CPU_REGION_SIZE	PMD_SIZE
+#define MERMAP_SIZE		(MERMAP_CPU_REGION_SIZE * NR_CPUS)
+#define MERMAP_END_ADDR		(MERMAP_BASE_ADDR + (NR_CPUS * MERMAP_CPU_REGION_SIZE))
+
 #define __VMALLOC_BASE_L4	0xffffc90000000000UL
 #define __VMALLOC_BASE_L5 	0xffa0000000000000UL
 
diff --git a/include/linux/mermap.h b/include/linux/mermap.h
new file mode 100644
index 0000000000000..5457dcb8c9789
--- /dev/null
+++ b/include/linux/mermap.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MERMAP_H
+#define _LINUX_MERMAP_H
+
+#include <linux/mermap_types.h>
+#include <linux/mm.h>
+
+#ifdef CONFIG_MERMAP
+
+#include <asm/mermap.h>
+
+int mermap_mm_prepare(struct mm_struct *mm);
+void mermap_mm_init(struct mm_struct *mm);
+void mermap_mm_teardown(struct mm_struct *mm);
+
+/* Can the mermap be called from this context? */
+static inline bool mermap_ready(void)
+{
+	return in_task() && current->mm && current->mm->mermap.cpu;
+}
+
+struct mermap_alloc *mermap_get(struct page *page, unsigned long size, pgprot_t prot);
+void *mermap_get_reserved(struct page *page, pgprot_t prot);
+void mermap_put(struct mermap_alloc *alloc);
+
+static inline void *mermap_addr(struct mermap_alloc *alloc)
+{
+	return (void *)alloc->base;
+}
+
+/*
+ * arch_mermap_flush_tlb() is called before a part of the local CPU's mermap
+ * region is remapped to a new address. No other CPU is allowed to _access_ that
+ * region, but the region was mapped there.
+ *
+ * This may be called with IRQs off.
+ *
+ * On arm64, this will need to be a broadcast TLB flush. Although the other CPUs
+ * are forbidden to access the region, they can leak the data that was mapped
+ * there via CPU exploits. Violating break-before-make would mean the data
+ * available to these CPU exploits is unpredictable.
+ */
+extern void arch_mermap_flush_tlb(void);
+extern bool arch_mermap_pgprot_allowed(pgprot_t prot);
+
+#if IS_ENABLED(CONFIG_KUNIT)
+struct mermap_alloc *__mermap_get(struct mm_struct *mm, struct page *page,
+			unsigned long size, pgprot_t prot, bool use_reserve);
+void __mermap_put(struct mm_struct *mm, struct mermap_alloc *alloc);
+unsigned long mermap_cpu_base(int cpu);
+unsigned long mermap_cpu_end(int cpu);
+#endif
+
+#else /* CONFIG_MERMAP */
+
+static inline int mermap_mm_prepare(struct mm_struct *mm) { return 0; }
+static inline void mermap_mm_init(struct mm_struct *mm) { }
+static inline void mermap_mm_teardown(struct mm_struct *mm) { }
+static inline bool mermap_ready(void) { return false; }
+
+#endif /* CONFIG_MERMAP */
+
+#endif /* _LINUX_MERMAP_H */
diff --git a/include/linux/mermap_types.h b/include/linux/mermap_types.h
new file mode 100644
index 0000000000000..08e43100b790e
--- /dev/null
+++ b/include/linux/mermap_types.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MERMAP_TYPES_H
+#define _LINUX_MERMAP_TYPES_H
+
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_MERMAP
+
+/* Tracks an individual allocation in the mermap. */
+struct mermap_alloc {
+	/* Currently allocated. */
+	bool in_use;
+	/* Requires flush before reallocating. */
+	bool need_flush;
+	unsigned long base;
+	/* Non-inclusive. */
+	unsigned long end;
+};
+
+struct mermap_cpu {
+	/* Next address immediately available for alloc (no TLB flush needed). */
+	unsigned long next_addr;
+	struct mermap_alloc allocs[4];
+#ifdef CONFIG_MERMAP_KUNIT_TEST
+	u64 tlb_flushes;
+#endif
+};
+
+struct mermap {
+	struct mutex init_lock;
+	struct mermap_cpu __percpu *cpu;
+};
+
+#else /* CONFIG_MERMAP */
+
+struct mermap {};
+
+#endif /* CONFIG_MERMAP */
+
+#endif /* _LINUX_MERMAP_TYPES_H */
+
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index dbad8df91f153..2760b0972c554 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -7,6 +7,7 @@
 #include <linux/auxvec.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/mermap_types.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
 #include <linux/maple_tree.h>
@@ -34,6 +35,7 @@
 struct address_space;
 struct futex_private_hash;
 struct mem_cgroup;
+struct mermap;
 
 typedef struct {
 	unsigned long f;
@@ -1159,6 +1161,8 @@ struct mm_struct {
 		atomic_t membarrier_state;
 #endif
 
+		struct mermap mermap;
+
 		/**
 		 * @mm_users: The number of users including userspace.
 		 *
diff --git a/kernel/fork.c b/kernel/fork.c
index ee8a9450f0f1d..5d74b55a42c4c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/anon_inodes.h>
+#include <linux/mermap.h>
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
 #include <linux/sched/mm.h>
@@ -1130,6 +1131,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 
 	mm->user_ns = get_user_ns(user_ns);
 	lru_gen_init_mm(mm);
+
+	mermap_mm_init(mm);
+
 	return mm;
 
 fail_pcpu:
@@ -1173,6 +1177,7 @@ static inline void __mmput(struct mm_struct *mm)
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
 	exit_mmap(mm);
+	mermap_mm_teardown(mm);
 	mm_put_huge_zero_folio(mm);
 	set_mm_exe_file(mm, NULL);
 	if (!list_empty(&mm->mmlist)) {
diff --git a/mm/Kconfig b/mm/Kconfig
index 15f4da9ba8f4a..06c1c125e9636 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1480,4 +1480,15 @@ config MM_LOCAL_REGION
 
 source "mm/damon/Kconfig"
 
+config ARCH_SUPPORTS_MERMAP
+	bool
+
+config MERMAP
+	bool "Support for epheMERal mappings within the kernel"
+	default COMPILE_TEST
+	depends on ARCH_SUPPORTS_MERMAP
+	select MM_LOCAL_REGION
+	help
+	  Support for epheMERal mappings within the kernel.
+
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244eb..b1ac133fe603e 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -150,3 +150,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_MERMAP) += mermap.o
diff --git a/mm/mermap.c b/mm/mermap.c
new file mode 100644
index 0000000000000..d65ecfc06b58e
--- /dev/null
+++ b/mm/mermap.c
@@ -0,0 +1,319 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/io.h>
+#include <linux/mermap.h>
+#include <linux/mm.h>
+#include <linux/mmu_context.h>
+#include <linux/mutex.h>
+#include <linux/pagemap.h>
+#include <linux/pgtable.h>
+#include <linux/sched.h>
+
+#include <kunit/visibility.h>
+
+/*
+ * As a hack to allow using apply_to_existing_page_range() for these mappings,
+ * which skips pte_none() entries, unmap using a special non-"none" sentinel
+ * value.
+ */
+static inline int set_unmapped_pte(pte_t *ptep, unsigned long addr, void *data)
+{
+	pte_t pte = pfn_pte(0, pgprot_nx(PAGE_NONE));
+
+	VM_BUG_ON(pte_none(pte));
+	set_pte(ptep, pte);
+	return 0;
+}
+
+static void __mermap_put(struct mm_struct *mm, struct mermap_alloc *alloc)
+{
+	unsigned long size = PAGE_ALIGN(alloc->end - alloc->base);
+
+	if (WARN_ON_ONCE(!alloc->in_use))
+		return;
+
+	apply_to_page_range(mm, alloc->base, size, set_unmapped_pte, NULL);
+
+	WRITE_ONCE(alloc->in_use, false);
+
+	migrate_enable();
+}
+
+/* Return a region allocated by mermap_get(). */
+void mermap_put(struct mermap_alloc *alloc)
+{
+	__mermap_put(current->mm, alloc);
+}
+EXPORT_SYMBOL(mermap_put);
+
+static inline unsigned long mermap_cpu_base(int cpu)
+{
+	return MERMAP_BASE_ADDR + (cpu * MERMAP_CPU_REGION_SIZE);
+
+}
+
+/* Non-inclusive */
+static inline unsigned long mermap_cpu_end(int cpu)
+{
+	return MERMAP_BASE_ADDR + ((cpu + 1) * MERMAP_CPU_REGION_SIZE);
+
+}
+
+static inline void mermap_flush_tlb(int cpu, struct mermap_cpu *mc)
+{
+#ifdef CONFIG_MERMAP_KUNIT_TEST
+	mc->tlb_flushes++;
+#endif
+	arch_mermap_flush_tlb();
+}
+
+/* Call with migration disabled. */
+static inline struct mermap_alloc *mermap_alloc(struct mm_struct *mm,
+						unsigned long size, bool use_reserve)
+{
+	int cpu = raw_smp_processor_id();
+	struct mermap_cpu *mc = this_cpu_ptr(mm->mermap.cpu);
+	unsigned long cpu_end = mermap_cpu_end(cpu);
+	struct mermap_alloc *alloc = NULL;
+
+	/*
+	 * This is an extremely stupid allocator, there can only ever be a small
+	 * number of allocations so everything just works on linear search.
+	 *
+	 * Allocations are "in order", i.e. if the whole region is free it
+	 * allocates from the beginning. If there are any existing allocations
+	 * it allocates from right after the last (highest address) one. Any
+	 * free space before that goes unused.
+	 *
+	 * Once an allocation has been freed, the space it occupied must be flushed
+	 * from the TLB before it can be reused.
+	 *
+	 * Visual example of how this is suppose to behave (A for allocated, T for
+	 * TLB-flush-pending):
+	 *
+	 *  _______________ Start with everything free.
+	 *  AaaA___________ Allocate something.
+	 *  TttT___________ Free it. (Region needs a TLB flush now).
+	 *  TttTAaaaaaaaA__ Allocate something else.
+	 *  TttTAaaaaaaaAAA Allocate the remaining space.
+	 *  TttTTtttttttTAA Free the allocation before last.
+	 *  ^^^^^^^^^^^^^   This could all be reused now but for simplicity it
+	 *                  isn't. Another allocation at this point  will fail.
+	 *  TttTTtttttttTTT Free the last allocation.
+	 *  _______________ Next time we allocate, first flush the TLB
+	 *  AA_____________ Now we're back at the beginning.
+	 */
+
+	if (use_reserve) {
+		if (WARN_ON_ONCE(size != PAGE_SIZE))
+			return NULL;
+		lockdep_assert_preemption_disabled();
+	} else {
+		cpu_end -= PAGE_SIZE;
+	}
+
+	if (WARN_ON_ONCE(!in_task()))
+		return NULL;
+	guard(preempt)();
+
+	/* Out of already-available space? */
+	if (mc->next_addr + size > cpu_end) {
+		unsigned long new_next = mermap_cpu_base(cpu);
+
+		/* Would we have space after a TLB flush? */
+		for (int i = 0; i < ARRAY_SIZE(mc->allocs); i++) {
+			struct mermap_alloc *alloc = &mc->allocs[i];
+
+			/*
+			 * The space between the uppermost allocated alloc->end
+			 * (or the base of the CPU's region if there are no
+			 * current allocations) and mc->next_addr has been
+			 * unmapped in the pagetables, but not flushed from the
+			 * TLB. Set new_next to point to the beginning of that
+			 * space.
+			 */
+			if (READ_ONCE(alloc->in_use))
+				new_next = max(new_next, alloc->end);
+		}
+		if (size > cpu_end - new_next)
+			return NULL;
+
+		mermap_flush_tlb(cpu, mc);
+		mc->next_addr = new_next;
+	}
+
+	/* Find an alloc-tracking structure to use */
+	for (int i = 0; i < ARRAY_SIZE(mc->allocs); i++) {
+		if (!READ_ONCE(mc->allocs[i].in_use)) {
+			alloc = &mc->allocs[i];
+			break;
+		}
+	}
+	if (!alloc)
+		return NULL;
+	alloc->in_use = true;
+	alloc->base = mc->next_addr;
+	alloc->end = alloc->base + size;
+	mc->next_addr += size;
+
+	return alloc;
+}
+
+struct set_pte_ctx {
+	pgprot_t prot;
+	unsigned long next_pfn;
+};
+
+static inline int do_set_pte(pte_t *pte, unsigned long addr, void *data)
+{
+	struct set_pte_ctx *ctx = data;
+
+	set_pte(pte, pfn_pte(ctx->next_pfn, ctx->prot));
+	ctx->next_pfn++;
+
+	return 0;
+}
+
+static struct mermap_alloc *
+__mermap_get(struct mm_struct *mm, struct page *page,
+	     unsigned long size, pgprot_t prot, bool use_reserve)
+{
+	struct mermap_alloc *alloc = NULL;
+	struct set_pte_ctx ctx;
+	int err;
+
+	if (size > MERMAP_CPU_REGION_SIZE || WARN_ON_ONCE(!mm || !mm->mermap.cpu))
+		return NULL;
+	if (WARN_ON_ONCE(!arch_mermap_pgprot_allowed(prot)))
+		return NULL;
+
+	size = PAGE_ALIGN(size);
+
+	migrate_disable();
+
+	alloc = mermap_alloc(mm, size, use_reserve);
+	if (!alloc) {
+		migrate_enable();
+		return NULL;
+	}
+
+	/* This probably wants to be optimised. */
+	ctx.prot = prot;
+	ctx.next_pfn = page_to_pfn(page);
+	err = apply_to_existing_page_range(mm, alloc->base, size, do_set_pte, &ctx);
+	if (err) {
+		WRITE_ONCE(alloc->in_use, false);
+		return NULL;
+	}
+
+	return alloc;
+}
+
+/*
+ * Allocate a region of virtual memory, and map the page into it. This tries
+ * pretty hard to be fast but doesn't try very hard at all to actually succeed.
+ *
+ * The returned region is physically local to the current mm. It is _logically_
+ * local to the current CPU but this is not enforced by hardware so it can be
+ * exploited to mitigate CPU vulns. This means the caller must not map memory
+ * here that doesn't belong to the current process. The caller must also perform
+ * a full TLB flush of the region before freeing the pages that have been mapped
+ * here.
+ *
+ * This may only be called from process context, and the caller must arrange to
+ * first call mermap_mm_prepare(). (It would be possible to support this in IRQ,
+ * but it seems unlikely there's a valid usecase given the TLB flushing
+ * requirements). If it succeeds, it disables migration until you call
+ * mermap_put().
+ *
+ * This is guaranteed not to allocate.
+ *
+ * Use mermap_addr() to get the actual address of the mapped region.
+ */
+struct mermap_alloc *mermap_get(struct page *page, unsigned long size, pgprot_t prot)
+{
+	return __mermap_get(current->mm, page, size, prot, false);
+}
+EXPORT_SYMBOL(mermap_get);
+
+/*
+ * Allocate a single PAGE_SIZE page via mermap_get(), requiring preemption to be
+ * off until it is freed. This always succeeds.
+ */
+void *mermap_get_reserved(struct page *page, pgprot_t prot)
+{
+	lockdep_assert_preemption_disabled();
+	return __mermap_get(current->mm, page, PAGE_SIZE, prot, true);
+}
+EXPORT_SYMBOL(mermap_get_reserved);
+
+/*
+ * Internal - do unconditional (cheap) setup that's done for every mm. This
+ * doesn't actually prepare the mermap for use until someone calls
+ * mermap_mm_prepare().
+ */
+void mermap_mm_init(struct mm_struct *mm)
+{
+	mutex_init(&mm->mermap.init_lock);
+}
+
+/*
+ * Set up the mermap for this mm. The caller doesn't need to call
+ * mermap_mm_teardown(), that's take care of by the normal mm teardown
+ * mechanism. This is idempotent and thread-safe.
+ */
+int mermap_mm_prepare(struct mm_struct *mm)
+{
+	int err = 0;
+	int cpu;
+
+	guard(mutex)(&mm->mermap.init_lock);
+
+	/* Already done? */
+	if (likely(mm->mermap.cpu))
+		return 0;
+
+	mm->mermap.cpu = alloc_percpu_gfp(struct mermap_cpu,
+					  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!mm->mermap.cpu)
+		return -ENOMEM;
+
+	/* So we can use this from the page allocator, preallocate pagetables. */
+	mm_flags_set(MMF_LOCAL_REGION_USED, mm);
+	for_each_possible_cpu(cpu) {
+		unsigned long base = mermap_cpu_base(cpu);
+
+		err = apply_to_page_range(mm, base, MERMAP_CPU_REGION_SIZE,
+					  set_unmapped_pte, NULL);
+		if (err) {
+			/*
+			 * Clear .cpu now to inform mermap_ready(). Any partial
+			 * page tables get cleared up by mm teardown.
+			 */
+			free_percpu(mm->mermap.cpu);
+			mm->mermap.cpu = NULL;
+			break;
+		}
+		per_cpu_ptr(mm->mermap.cpu, cpu)->next_addr = base;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mermap_mm_prepare);
+
+/* Clean up mermap stuff on mm teardown. */
+void mermap_mm_teardown(struct mm_struct *mm)
+{
+	int cpu;
+
+	if (!mm->mermap.cpu)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct mermap_cpu *mc = this_cpu_ptr(mm->mermap.cpu);
+
+		for (int i = 0; i < ARRAY_SIZE(mc->allocs); i++)
+			WARN_ON_ONCE(mc->allocs[i].in_use);
+	}
+
+	free_percpu(mm->mermap.cpu);
+}
diff --git a/mm/pgalloc-track.h b/mm/pgalloc-track.h
index e9e879de8649b..51fc4668d7177 100644
--- a/mm/pgalloc-track.h
+++ b/mm/pgalloc-track.h
@@ -2,6 +2,12 @@
 #ifndef _LINUX_PGALLOC_TRACK_H
 #define _LINUX_PGALLOC_TRACK_H
 
+#include <linux/mm.h>
+#include <linux/pgalloc.h>
+#include <linux/pgtable.h>
+
+#include "internal.h"
+
 #if defined(CONFIG_MMU)
 static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
 				     unsigned long address,

-- 
2.51.2


