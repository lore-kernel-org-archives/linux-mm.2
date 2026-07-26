Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B9AC531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CEAD6B009F; Sun, 26 Jul 2026 18:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D016B00A0; Sun, 26 Jul 2026 18:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146716B00A1; Sun, 26 Jul 2026 18:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD7EE6B009F
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EE49805BA
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:39 +0000 (UTC)
X-FDA: 85032355758.26.CA19139
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9626440007
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZqpDuGRH;
	spf=pass (imf27.hostedemail.com: domain of 354hmaggKCOwXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=354hmaggKCOwXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EehayEF6PE+dVjTzVxUExaSQ5/A35bcakQSkMtI1JI=;
	b=R3MikhIFVzy/vdk5YJy7335zchG8K1lWPrhBxu2zQe4D0TzMNoGcwD+4xc7i6DNMZZ+SxF
	QfVwHYoh6z8L6bzXdXqTAppmW08D7ex0hi10Q8UgaXxS80QR5HsZdLQWjcSJpeKAW3zW8v
	JX8GGHvu0aTFThIrcUqMUtW+Ac2A/sU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZqpDuGRH;
	spf=pass (imf27.hostedemail.com: domain of 354hmaggKCOwXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=354hmaggKCOwXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104617;
	b=gIOLrXA4u2qjbx6k7lNsfBYVgOcqP1j941WymTnujni1WVi1A7oo9ta5u3X1pQLNyPYnsR
	lHWMMFjGa2CrX676HmvA2ipI97AIdfjqaOEuvoPX4AEZlR2Itm/HHe35+3gOTDVmh4+nv/
	zo3lzcZwMVwCsqvEB97gprY6/xiZw54=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954b1c6310so19836145e9.0
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104616; x=1785709416; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4EehayEF6PE+dVjTzVxUExaSQ5/A35bcakQSkMtI1JI=;
        b=ZqpDuGRHpv1hIOmnTAWQGXoLu9jHHHfFMmHESkSRRgCtEcd3cuygprWy0UIapGyrA3
         y33UxcYWIvmzH8HIQhEf1L2R4E41OcfF7tOr/xR+nDgx2fXJMhMINSmiiIKdB9s8q2Nq
         Dwrj0Elyu+O5k/LMgrPdsRxz30rsB9LLeXyfC7yw3MfnwkKaSBtl1ZgPbwxaZxgDnY2A
         LAUv4wKYFzIsoDLuk1VTX1AWU6ccNoHWMQxTllC29qb0WOJMpdvYz0VVI3jx682xbSXR
         gb43uyMk2Zne9Zr4QM3Z3B6vAidX95qkSQoX/BFvBbi4XiYY05ufuuiiAfGSLvQzFLu6
         EgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104616; x=1785709416;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4EehayEF6PE+dVjTzVxUExaSQ5/A35bcakQSkMtI1JI=;
        b=Cotw3kYlmHQlnrM55WqBIA1CPefur/XLF4lyELG59kfUmZ3e925cH0L1vYoCyP6hm0
         ZezBwsUIvv2L+2dxAqv4Lo1VnfKilrRNFkY9g5zPgxpjl0MoDB1VkdRAWi0P1IDNDwXP
         /KoC52pnSRvCb8Vp/pxzg6mgc55JvySBYHCP8VDG8HM3p+hQeW030iT5ioOKbaN16o2n
         LzK/8T2Bum6nC8YvP8rrBlTOmRSuqmunqm5+J+UmktGok66SlMAxmH1nTHotF/jA98h7
         NJTovPKNDXHh1lAispz7wLHHebc03DJmo0ZTG1pfkeEcaGhFSAFt4aWaCmJi4bdLGZRg
         4FGA==
X-Gm-Message-State: AOJu0YweM5Y5Ba6LJ7zQzWNKryx/C6F2+IsnIq3KsXSojKJ9BBFSOiE3
	zQFloysXbta6WC2j1OjfBTswtKLQUvDQLzXOg4+OFna82Uks9GU/c22r0eZ/xTMCH5PezDvDqE1
	DojKrWBhHJCvfOQ==
X-Received: from wmaq23.prod.google.com ([2002:a05:600c:6c97:b0:493:bd80:da9b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:630d:b0:495:7952:64df with SMTP id 5b1f17b1804b1-496b570d9e3mr86371495e9.36.1785104615991;
 Sun, 26 Jul 2026 15:23:35 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:44 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-11-6f5729aa9832@google.com>
Subject: [PATCH v3 11/26] x86/mm: introduce the mermap
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9626440007
X-Stat-Signature: 1niyfxk97iezu3crkyingtghgdbsyzsn
X-HE-Tag: 1785104617-735106
X-HE-Meta: U2FsdGVkX1+I3rQrlgp+2WpMY5GGUnn3y/uTKC2FchfYX4PljurIlFsM1j2G1bU5GGR+IXX5sSVSOt88FmbkWRxR0K3uU8BG/h/m0zPZ4PsO6QvyP5njbhKbDJQbYPt8CmBhspzHehiAjfKEKnV9hQMq6Bl7Xg9VU8BO68Dfy7ll+lV86Sd5jMJpd1iWYxIl41iM+uW9t/QZPaaUgcm6gXFmlDMyi0vYwOMqLqd9BJWxtNPeCdZjtSrQid6FxyzwmEl2+3+7YejcpFcUT1Kt+yRCIJ1P2kslqM0kaiBoeM6pWzE4zMMTVHUegUfYzWYgg5bG1kYzDXk1YsWO9T6DLrICBj5hmKuPR+LZpvfJ7sBAFQhdR8NA68Y7k1XEdJzEQyGeYqQ88v+35ygsFU4TPS50nZ0y4i1zcBNPaEAZBGX9lT1uAqfJnLSgshBQWbGdyKqWWaPCpek7JUwpgOWXRdWHCYLpYAWvz7tVGJfB1clKpY/B18pfBjD+VVdKUDkyf79PoxqTJD3admc+vaLvavZEsNQ4+DorwlvX63/U4TftyC/wiJ3YgTTej2UCQiwQrVc2Z9Twv5LRNTl40f4I9de4XxClnMV+7jd8lNdwFPU77/GEm7oE99gDKh6x1bdB4hR7QJt/ImPb9Y4rwOZMVL5TAwYgwjZCdF3I5Ab3Dqt8p03xJM88nWDQvy7zbnFGYYMqjOzTh/zXMKciCZ03pVTSVBzpqBE9c3tXslXIgSyOpnzC6BisTi6oeBQcaBt3k5fHgfOWS8hsE3XvUqy8LKY2lwRjHCWF3RjPn9+afH9/rgra5m8Pn02HeQ8jv3k85Ny/hZ9JKDim3cS2Q7wJTwWWM+6FQAX++exi8AJqZe6pamzGTCmXJRK3OB/7l+CKiMH46HY6KBoFHZzN+MJY5yoQf3A0zWW0yEpNv4cIAYHLuBuZV6gDHOy4mlLtVj6n/TbvRfLtYakfznLBhPa
 2xa3P2/f
 wzYhSdzyKkObeySISPTbkVZi/ts83s/gymmQzmVce+AuVjIM3oskj2lpZAYLQNtLQknpLexZzju+0QXOHUAe4U2R7R8S9BngBb6F+PT9Q3IQc8HjFbOsM4k1NptcmrxaBLH6lONd7P6d5JNtmMyYiENx5dbjoclrxg5Hw8qSyEte4XUp6v+K1WeozfXda/80e0X/d669e2EMnDXmdbCPFShSq6fjbuwTMzlks5ys1AxoGlvmS/N+s4JN9NPDzxG801WDV0iMb2ajeaMFNhoE+UFBlwT3zUbqRKofN5Nn9kbSiYEH2rzr8UpBSZ2QRJj1CndWM/ZZPuKCncLJRx7EnBfw4HZHqkIbENIIAmq3zVw1yyqD3mWZO0TA0S7lr1BFPma14Lkm7Maewhc7LFK7qyc/l++9wuOI07XjIsTxK96KaxkvzEIwV/VsF4Zp6wl66SeefWbU04gdBLflMMu4ShafwNRoH2LmVEio0NYXlHvV6ApH20x0PdEzHy0GA06fC2m4feTjZV+I9mw3EUg1ZEyn7HU44bTkGgWoEGTx535ctExq8MWugiwec2Bmd9+wtFv6red4NoDgA7DYJ57xDD5hz+9tQWo9+0531APuQ+bFYYiLGrSaHNkBqg1S9C7YhDbttPAYEh/02/KIDTjzID2gl2BVnBDzEXMIfvlBAFVE9MdyiAUKFDHiacRpVh53N6sShC90/OG72/kI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mermap provides a fast way to create ephemeral mm-local mappings of
physical pages. The purpose of this is to access pages that have been
removed from the direct map. Potential use cases are:

1. For zeroing direct-map-nonpresent pages (added in a later patch).

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
unmapped pages, where handling failure would be extremely inconvenient.
The _reserved() variant is simply implemented by leaving one base-page
space unavailable for non-_reserved allocations, and requiring an atomic
context.

Note for Sashiko: Yes, the data mapped by the mermap is exposed to
Meltdown-style attacks by the current process. This is completely
intentional. Data is only supposed to be mapped there that the current
process is allowed to read anyway.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/mermap.h           |  23 +++
 arch/x86/include/asm/pgtable_64_types.h |   8 +-
 arch/x86/include/asm/pgtable_types.h    |   2 +
 include/linux/mermap.h                  |  63 ++++++
 include/linux/mermap_types.h            |  41 ++++
 include/linux/mm_types.h                |   4 +
 kernel/fork.c                           |   5 +
 mm/Kconfig                              |   9 +
 mm/Makefile                             |   1 +
 mm/mermap.c                             | 338 ++++++++++++++++++++++++++++++++
 11 files changed, 494 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 33c1282bfbf93..6b4d81a280d3b 100644
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
 
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index af08d98be9309..f397e4311cf66 100644
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
index d39fddf57edc8..bb80d60cf3498 100644
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
@@ -35,6 +36,7 @@
 struct address_space;
 struct futex_private_hash;
 struct mem_cgroup;
+struct mermap;
 
 typedef struct {
 	unsigned long f;
@@ -1211,6 +1213,8 @@ struct mm_struct {
 		atomic_t membarrier_state;
 #endif
 
+		struct mermap mermap;
+
 		/**
 		 * @mm_users: The number of users including userspace.
 		 *
diff --git a/kernel/fork.c b/kernel/fork.c
index 4fb23ea33b7da..7c2050e76d1bc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/anon_inodes.h>
+#include <linux/mermap.h>
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
 #include <linux/sched/mm.h>
@@ -1143,6 +1144,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 		goto fail_pcpu;
 
 	lru_gen_init_mm(mm);
+
+	mermap_mm_init(mm);
+
 	return mm;
 
 fail_pcpu:
@@ -1186,6 +1190,7 @@ static inline void __mmput(struct mm_struct *mm)
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
 	exit_mmap(mm);
+	mermap_mm_teardown(mm);
 	mm_put_huge_zero_folio(mm);
 	set_mm_exe_file(mm, NULL);
 	if (!list_empty(&mm->mmlist)) {
diff --git a/mm/Kconfig b/mm/Kconfig
index cb531c1436f77..bf8c4c6264c73 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1507,6 +1507,15 @@ config MM_LOCAL_REGION
 	bool
 	depends on ARCH_SUPPORTS_MM_LOCAL_REGION
 
+config ARCH_SUPPORTS_MERMAP
+	bool
+	select ARCH_SUPPORTS_MM_LOCAL_REGION
+
+config MERMAP
+	bool
+	depends on ARCH_SUPPORTS_MERMAP
+	select MM_LOCAL_REGION
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index ab37ef428d98d..9cf282c154104 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
+obj-$(CONFIG_MERMAP) += mermap.o
diff --git a/mm/mermap.c b/mm/mermap.c
new file mode 100644
index 0000000000000..2bead38eadfe8
--- /dev/null
+++ b/mm/mermap.c
@@ -0,0 +1,338 @@
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
+	__apply_to_page_range(mm, alloc->base, size, set_unmapped_pte,
+			      NULL, PGRANGE_CREATE | PGRANGE_NOLOCK);
+
+	WRITE_ONCE(alloc->in_use, false);
+}
+EXPORT_SYMBOL_IF_KUNIT(__mermap_put);
+
+/* Return a region allocated by mermap_get(). */
+void mermap_put(struct mermap_alloc *alloc)
+{
+	cant_migrate();
+	if (WARN_ON_ONCE(!alloc->in_use))
+		return;
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
+/* Call with preemption disabled if use_reserve, else with migration disabled. */
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
+	 * Visual example of how this is supposed to behave (A for allocated, T for
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
+	alloc = mermap_alloc(mm, size, use_reserve);
+	if (!alloc)
+		return NULL;
+
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
+ * Must be called with migration disabled, and it must stay disabled until you
+ * call mermap_put().
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
+ * requirements).
+ *
+ * This is guaranteed not to allocate.
+ *
+ * Use mermap_addr() to get the actual address of the mapped region.
+ */
+struct mermap_alloc *mermap_get(struct page *page, unsigned long size, pgprot_t prot)
+{
+	struct mermap_alloc *alloc;
+
+	cant_migrate();
+	alloc = __mermap_get(current->mm, page, size, prot, false);
+	if (alloc) {
+		/* Leaving migration disabled is intentional. */
+		return alloc;
+	}
+	return NULL;
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
+	mm->mermap.cpu = NULL;
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
+		struct mermap_cpu *mc = per_cpu_ptr(mm->mermap.cpu, cpu);
+
+		for (int i = 0; i < ARRAY_SIZE(mc->normal_allocs); i++)
+			WARN_ON_ONCE(mc->normal_allocs[i].in_use);
+		WARN_ON_ONCE(mc->reserve_alloc.in_use);
+	}
+
+	free_percpu(mm->mermap.cpu);
+}

-- 
2.54.0


