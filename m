Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE201099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7FE6B00CA; Fri, 20 Mar 2026 14:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F8D6B00CD; Fri, 20 Mar 2026 14:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2406B00CE; Fri, 20 Mar 2026 14:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 642436B00CA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2539E1A0316
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:49 +0000 (UTC)
X-FDA: 84567264978.13.A0B6BDD
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 71764140002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o98jN2e+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3sZC9aQgKCB4D46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3sZC9aQgKCB4D46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2sqUC5aSTDpuWgDXfdW7DqXvG5I7i7g7XwAZOwAwa3o=;
	b=6YQ3eGlcwoypNo9SND4h58ySqN/t4lwMh+X7IRVfdT6amtm438eU8hT9QImeYRzYkv0R1p
	biopsmW1Xo+cjZkjeYH3ZAb/mgRa0s9LeJWfcQshMQFIEW80Oua0B0dhLlSO77lshKkOpK
	nPWq5V1Gil/pMr8eDzYrEdWMHJNiy6U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o98jN2e+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3sZC9aQgKCB4D46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3sZC9aQgKCB4D46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031027; a=rsa-sha256;
	cv=none;
	b=uUJCH/lBPMh69Acnvc1qB/3RQ+hF6i46weQQGX1X665K1C1pXcE4LIFkY9zrySPUVHVELQ
	nhfdSEqrpxBmsZFFUzf2ru9pCxaiDfDqVBM/obVC7FvVDqWbUEsgk5VtbAGb/WTvTfoPSi
	n97jSG9gnd06wb22u3H5s8EpwH/RvBo=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b4d3919e4so2110887f8f.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031026; x=1774635826; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2sqUC5aSTDpuWgDXfdW7DqXvG5I7i7g7XwAZOwAwa3o=;
        b=o98jN2e+a6OS/ww3C31pn3hh/lNIh3stEXqC7ReHLtxPHnAk4iH3xCkLRDcN+yEfy7
         PwNVvZxBl4Ug6gbvL4RdEwAij3J3GFpzJOQQaOK/pkztQCWdVP8J6Bd7evsdTngut2th
         jOirUg702DnGJJRguh5SyvEie8M6h4TW3vE7fp6NCSJ/u8ZbD4gmvS4ncy2cllHfOuyr
         OuIUsjUcaSzDM0WypLulQ/03WkfHG6Mj7Rnn+1R7Iznt4z32t4c6Sn6jFcwNBYdIRkrZ
         EtlS/HPg1dmn+Lw3XRpZZmVsdbqDfTNGRgZ6TT/3ZJR/jyqKtuHyLdCdJP+UszYDstt/
         91wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031026; x=1774635826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2sqUC5aSTDpuWgDXfdW7DqXvG5I7i7g7XwAZOwAwa3o=;
        b=Pfdgvo3J7Kr4zOgASlciuNGd2mIlWU4sVsVnb2HcgkT1XNLOyNu3E69V7yq9NlUeql
         DGm8H38jInvDSxlNHJP7uGiTgAtADBJZAQ+/ArUXfaw/3xbftA1iCoJ0xQiZdMqWHaoM
         fAUgbUPiQiMLJa/IggOchQQ5kPSFAS/zTFezJdHybgovjFwUt8Ul1tyJow8zkJvCrHPd
         NB5vb5adx+Kk8E5Gp837HEiNaID2ns34xyj1MB2a9nOCUiFtpKyr/6Ml/nD8z8g+VjgK
         YIVIL4G3sd8Rj9Km7Je/NeXK9ztoL9n8pAym1tGXFKwKPfobNP59LQsIdTeQar2gWq6t
         7+7w==
X-Gm-Message-State: AOJu0YzvKt9sGKlUyoDlEZWIbK/dHZWo1BGRxnZowkZNFJMk6ONtlChe
	fHZ1WT6wfCID0OkM2RvynJe9oTOQzh+c7MzCEv1fDvZBe+pYyP3qIYxe7GMH+yVcSITrQeORgh1
	AnycLOAlRJ5K0xA==
X-Received: from wrpb13.prod.google.com ([2002:adf:f24d:0:b0:43b:458d:a320])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4282:b0:439:b791:f920 with SMTP id ffacd0b85a97d-43b6423faafmr7481372f8f.17.1774031025790;
 Fri, 20 Mar 2026 11:23:45 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:30 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-6-28bf1bd54f41@google.com>
Subject: [PATCH v2 06/22] x86/mm: introduce the mermap
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71764140002
X-Stat-Signature: z6cuognkknodfr4ap1mhj7qz5ebjyop6
X-Rspam-User: 
X-HE-Tag: 1774031027-575290
X-HE-Meta: U2FsdGVkX185BlzNqSCiJ9vlcQUNfKpZpxxeRVYn9NfUZOJcT8VHwnfqIX6n1c52xj/8K6sDbJQr8DgTthOAPpopjNRrrP7ZCTZgeZeBikvmrzW1lR6bwQohYAgiGyamU4lnOYEoFRsck9D0cWBweZYLlgMgYLhhGUAVc5FYuSxS4rDLLQCqexRgvyrgdInoWeS9PGXs4iz6LjFFS/+PJBa7fuCkHZ+08kjM3iZUo1P4kw7bFoBAaobGJNS/2b3T5N2jPqsCGMo5bVyWneG6k0Kj30F14n6QgI0HRS+jfVlj/7FzFB0J10+Xcbjzsl9corQ2CqIInGi9C3cnMqRQGrhrkzJN5QskgonW9AqVIymVesP7e+IO5k4X8PDgaSNjqo4scmnfhoU0d+AhCSKbCKrf6xsiirQ7Bss58ZFbZqbAAc5/O4SWml8HUqvOZ1671+vQJTW2a350awqfSyTIbxGMbKGa3p4HtZtXHiHAd3vxHnE0/2/9lyZ1LJuuRTJdex60Y3auM+IFEbL4ICj+OWWJw715dwsY2rtLqL/h7tVAgfRa6J/N02IWWFizgjE5YX1IMasGvT1F4GHZv0kgX80ENeHc8s8ikjAG5gIzsyIfZugqxsh5FbN4M6qMcKs85WcbntVTRUk4uTkhFA29mS4DJX7HzmuprQ/U7NWCIjJ+Q/ZaqYFI9fpR0sqtcl0sR5LIu40OOOKDsC6MzNWn4TjIe6JujW3smqvi39WUUnaXR/zHiF5PzyYker5m+Mk4j1PaBVBOm80mj6vYGag+kmhW6GdgXQIucPiq7K0xkGtx3k3mRmR6EoS5VHNpVWTFiwFHUqjDVSroOLpqLhHSK1hcUzw2YsHGY8KY7YGxZdIvT9pXfd0EkfPKgrqJIJ6Tv3U97q/PphzYuP1Ecq5QTVv2qFOXC/VguRy2y3PQpA0tCyy4J36RFKJFq+jXhd8WoLMXZA4HKwPTDaKbIsW
 MZQLz6ob
 uuuYyTqMiShwzMRQnjgalSJJO4Ih8+77TFRhS8wwYWMIofj6IfT9nKSLD7t6OidE87d3BLRiBb64KAt8z97vgTL0SiplN+Cp8hB5IUv+zaGdZXtgi0X9Nad0gKFNjzAX4TDxT0ZLy/2spweoOW3wAd9iY45cjIhEmX8ybuIUQwcJo9HeJQkgbVAPuEfXTcAMrarkkSCBwXr/k/CMO5z+FWN+xe+4eSkrEfqIEFbY3Sn9Ihtk9v2SocPJ+0yJpxf3cWf8wTwC/pDY3Oh7hW6CzEGLeLA==
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

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/mermap.h           |  23 +++
 arch/x86/include/asm/pgtable_64_types.h |   8 +-
 include/linux/mermap.h                  |  63 ++++++
 include/linux/mermap_types.h            |  41 ++++
 include/linux/mm_types.h                |   4 +
 kernel/fork.c                           |   5 +
 mm/Kconfig                              |  10 +
 mm/Makefile                             |   1 +
 mm/mermap.c                             | 334 ++++++++++++++++++++++++++++++++
 mm/pgalloc-track.h                      |   6 +
 11 files changed, 495 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d7073b6077c62..f093252b5eab5 100644
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
index 1181565966405..fb6c3daacfeb8 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -105,11 +105,17 @@ extern unsigned int ptrs_per_p4d;
 
 #define MM_LOCAL_PGD_ENTRY	-240UL
 #define MM_LOCAL_BASE_ADDR	(MM_LOCAL_PGD_ENTRY << PGDIR_SHIFT)
-#define MM_LOCAL_END_ADDR	((MM_LOCAL_PGD_ENTRY + 1) << PGDIR_SHIFT)
+#define MM_LOCAL_START_ADDR	((MM_LOCAL_PGD_ENTRY) << PGDIR_SHIFT)
+#define MM_LOCAL_END_ADDR	(MM_LOCAL_START_ADDR + (1UL << PGDIR_SHIFT))
 
 #define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
 #define LDT_END_ADDR		(LDT_BASE_ADDR + PMD_SIZE)
 
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
index 0000000000000..c1c83b223c28d
--- /dev/null
+++ b/include/linux/mermap_types.h
@@ -0,0 +1,41 @@
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
+	struct mermap_alloc normal_allocs[3];
+	struct mermap_alloc reserve_alloc;
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
index 0ca7cb7da918f..2c60a451f96e7 100644
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
@@ -1172,6 +1174,8 @@ struct mm_struct {
 		atomic_t membarrier_state;
 #endif
 
+		struct mermap mermap;
+
 		/**
 		 * @mm_users: The number of users including userspace.
 		 *
diff --git a/kernel/fork.c b/kernel/fork.c
index ff075c74333fe..2770b4d296846 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/anon_inodes.h>
+#include <linux/mermap.h>
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
 #include <linux/sched/mm.h>
@@ -1144,6 +1145,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 
 	mm->user_ns = get_user_ns(user_ns);
 	lru_gen_init_mm(mm);
+
+	mermap_mm_init(mm);
+
 	return mm;
 
 fail_pcpu:
@@ -1187,6 +1191,7 @@ static inline void __mmput(struct mm_struct *mm)
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
 	exit_mmap(mm);
+	mermap_mm_teardown(mm);
 	mm_put_huge_zero_folio(mm);
 	set_mm_exe_file(mm, NULL);
 	if (!list_empty(&mm->mmlist)) {
diff --git a/mm/Kconfig b/mm/Kconfig
index 2813059df9c1c..2bf1dbcc8cb10 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1484,4 +1484,14 @@ config MM_LOCAL_REGION
 
 source "mm/damon/Kconfig"
 
+config ARCH_SUPPORTS_MERMAP
+	bool
+
+config MERMAP
+	bool "Support for epheMERal mappings within the kernel"
+	depends on ARCH_SUPPORTS_MERMAP
+	depends on MM_LOCAL_REGION
+	help
+	  Support for epheMERal mappings within the kernel.
+
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index ffd06cf7a04e6..0c45677f4a538 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -150,3 +150,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_MERMAP) += mermap.o
diff --git a/mm/mermap.c b/mm/mermap.c
new file mode 100644
index 0000000000000..7cddc202755ee
--- /dev/null
+++ b/mm/mermap.c
@@ -0,0 +1,334 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/io.h>
+#include <linux/error-injection.h>
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
+#include "internal.h"
+
+static inline int set_unmapped_pte(pte_t *ptep, unsigned long addr, void *data)
+{
+	set_pte(ptep, __pte(0));
+	return 0;
+}
+
+VISIBLE_IF_KUNIT void __mermap_put(struct mm_struct *mm, struct mermap_alloc *alloc)
+{
+	unsigned long size = PAGE_ALIGN(alloc->end - alloc->base);
+
+	if (WARN_ON_ONCE(!alloc->in_use))
+		return;
+
+	__apply_to_page_range(mm, alloc->base, size, set_unmapped_pte,
+			      NULL, PGRANGE_CREATE | PGRANGE_NOLOCK);
+
+	WRITE_ONCE(alloc->in_use, false);
+
+	migrate_enable();
+}
+EXPORT_SYMBOL_IF_KUNIT(__mermap_put);
+
+/* Return a region allocated by mermap_get(). */
+void mermap_put(struct mermap_alloc *alloc)
+{
+	__mermap_put(current->mm, alloc);
+}
+EXPORT_SYMBOL(mermap_put);
+
+VISIBLE_IF_KUNIT inline unsigned long mermap_cpu_base(int cpu)
+{
+	return MERMAP_BASE_ADDR + (cpu * MERMAP_CPU_REGION_SIZE);
+
+}
+EXPORT_SYMBOL_IF_KUNIT(mermap_cpu_base);
+
+/* Non-inclusive */
+VISIBLE_IF_KUNIT inline unsigned long mermap_cpu_end(int cpu)
+{
+	return MERMAP_BASE_ADDR + ((cpu + 1) * MERMAP_CPU_REGION_SIZE);
+
+}
+EXPORT_SYMBOL_IF_KUNIT(mermap_cpu_end);
+
+static inline void mermap_flush_tlb(int cpu, struct mermap_cpu *mc)
+{
+#if IS_ENABLED(CONFIG_MERMAP_KUNIT_TEST)
+	mc->tlb_flushes++;
+#endif
+	arch_mermap_flush_tlb();
+}
+
+/* Call with preemption disabled in use_reserve, else with migration disabled. */
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
+	 *                  isn't. Another allocation at this point will fail.
+	 *  TttTTtttttttTTT Free the last allocation.
+	 *  _______________ Next time we allocate, first flush the TLB.
+	 *  AA_____________ Now we're back at the beginning.
+	 */
+
+	/* Keep one page for mermap_get_reserved(). */
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
+		for (int i = 0; i < ARRAY_SIZE(mc->normal_allocs); i++) {
+			struct mermap_alloc *alloc = &mc->normal_allocs[i];
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
+	/*
+	 * Find an alloc-tracking structure to use. Keep one for
+	 * mermap_get_reserved() - that should never be contended since it can
+	 * only be allocated with preemption off.
+	 */
+	if (WARN_ON_ONCE(mc->reserve_alloc.in_use))
+		return NULL;
+	if (use_reserve) {
+		alloc = &mc->reserve_alloc;
+	} else {
+		for (int i = 0; i < ARRAY_SIZE(mc->normal_allocs); i++) {
+			if (!READ_ONCE(mc->normal_allocs[i].in_use)) {
+				alloc = &mc->normal_allocs[i];
+				break;
+			}
+		}
+		if (!alloc)
+			return NULL;
+	}
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
+VISIBLE_IF_KUNIT struct mermap_alloc *
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
+	err = __apply_to_page_range(mm, alloc->base, size, do_set_pte, &ctx,
+				    PGRANGE_CREATE | PGRANGE_NOLOCK);
+	if (err) {
+		WRITE_ONCE(alloc->in_use, false);
+		return NULL;
+	}
+
+	return alloc;
+}
+EXPORT_SYMBOL_IF_KUNIT(__mermap_get);
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
+ALLOW_ERROR_INJECTION(mermap_get, NULL);
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
+		/* Note this pointlessly iterates over PTEs to initialise. */
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
+		for (int i = 0; i < ARRAY_SIZE(mc->normal_allocs); i++)
+			WARN_ON_ONCE(mc->normal_allocs[i].in_use);
+		WARN_ON_ONCE(mc->reserve_alloc.in_use);
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


