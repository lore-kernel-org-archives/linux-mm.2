Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9349CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4801C6B00AE; Tue, 26 May 2026 07:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457DE6B00B0; Tue, 26 May 2026 07:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E106B00B1; Tue, 26 May 2026 07:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 253D26B00AE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E50BF1203D0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:08 +0000 (UTC)
X-FDA: 84809321856.06.A1F8C99
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7F78A4000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hCxHISmM;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnP8Y5wWqgsXoauN3f2z0ZKDiaOnvPYLIfkSMaqECP0=;
	b=RbMLyiJzXVtYBBgoPkKDJPF8D624Ki/ptny8QxjvWgjcR8ZeWlkwXK28A2INaPzHhwJwe9
	dG/19fUycacuKvy6+QcXEE0N9KzHkt8UWtXlvmA6XwzYcqOjJTVIRznQBWZikPAjugA7OI
	i1V0y/wIurIiZbofl3oQmywNUsZWs64=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hCxHISmM;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794287; a=rsa-sha256;
	cv=none;
	b=SUrnudeo2d9AqYgyPGqFkrrDgsAdrKlyvBirkPEC7chwkGeLTAnFnutkX6VKCDp8mJND6i
	DTYNcn29PECVIYfID+0GYLgoDgSfn7kS3vcfHyCxWklnKd/d2rgGxyu0NTOveSEJzxILHF
	MajEliyypl+9t6eSuL58V44HyqVKnMA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23FAD169C;
	Tue, 26 May 2026 04:18:00 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 591D13F7D8;
	Tue, 26 May 2026 04:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794285; bh=k6Uj/E1aH0kQC2m9I3HVplP0K8nRc6J1t8roshDs1C0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hCxHISmMRabyL7UYXLAOGySLnBi8uQrqePT0sZuOw+V2ZO1gY1KCe9ZSDzw0nAA3r
	 D0nv7Z7cgVA70DHCm+MLDKK3w7choLzo3dzxwKqrxXRV7vybL0xR4r2AaVtIbAUQI1
	 3i+uheVXOMRTSBKZl6loWhveDA1PD1kLxXlUk6oM=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:02 +0100
Subject: [PATCH RFC v8 13/24] mm: kpkeys: Introduce early page table
 allocator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-13-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=6609;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=k6Uj/E1aH0kQC2m9I3HVplP0K8nRc6J1t8roshDs1C0=;
 b=9jgkUTdPT4k6hdfxCw21Egf6Rt/dNfEwy1iKjBbCKM+WGw+m9SMWQlf3mtpCj6FWHWwOB7DV2
 HGyTlkhei4MBO3RDRPv/ZBbpv7CZ6AKdFQEhKRUTh+hqUvpJ/LvIb2o
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: 7hy441pcay3cxmekt7b4fz9a3ufbqdjt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F78A4000F
X-HE-Tag: 1779794286-885770
X-HE-Meta: U2FsdGVkX19CVa/XxDKed1ir9jWjZf5T/4N/IdlLjHvHZFj3WZrXvNPQ3Wu81juqJyhW7M8gNHZybBt7Vew1ZdhiLl3uVfb964kBnKc7pr1gtuzmlA7maQ68c098j+/BY9EykwE/5GcOj1fdIvax63AjE0uCFubmSLsNwhyKhL17l2RYX6DsT2SIjJsC8NFa3dbu3Zw527vFWwm4zS9t4CT+g1zfvnNG6mR+dZMO7hTQismS0ik1Lt9Qfh4wuUkKPQkS768ygCtmaO/Ud2xq9dJYiaIcIq5rRa6cGQUKyxSOsZ0+jcAcIduQ4zYa45p8NL537KEzj8jm4n/eOArYO2FCBC9NgKmXxGaNLMvizrLxlwjof1uYboqk4I/gidvSuZoHjXVzvpX8U3rqKQ/AZSqvdCIzitFNsgwIQRo8Cw6074g6TsnmW/PDMUtNTLGxa03N7F/bUXESpU1biplBd0v0PlxcACS+pDnDKGZaifmSWjMPjWakqfk5ORLS9eN/gqTq6397PNLh+DVYAuJllDWXn2qt+6GsYoDbjjEUgeSTMur5I64LLWh0gbC6pzNzhbYeb3F/wv9TwSqbEg7B7bebatwcGNIucuoSfXIql4yKIWRUUchmn8GDk97T11zye7v58ZpaCSUfom+0YdM758RlIfLoAxDFaOIKcLzN8Kiudvrw8SYRLxprKC1ITA841OwSqxI+HKTptKMORGiQtwGuhjJeg+21/tnTG8i/WBvIkf1uk3p9mJZfvb8wVKKogX5/BvKhCNYZxBI4H8QP+KDQJZ2Nfx0fr4TbupvRAoK9jiLl1a1aodVuOOdDwIFy+z+t70jbDPoSUu//UbaYN1CpGzPBcpPe3YbShCP+121X3o8bFy24KxwZUrrTXkg6PrHxQbMhZy2i77Hw1HiXKHIyGeiJjxEB9q+mS4HhSAhSnkCqWD4IJp3H54XQaTo2wUcj9kk8EwCiE2ZcYOB
 QRHmdbWC
 hzWDOEMZC6uZXPZ8IIVMlY/+P2yGyF4/8/D4verqRZBblNJtqNdR09IECyIQgOKK2zFS58r+bdsNAJYVkpshjqfPdvODADPjvi2OL4spdHZX9bEW+grsnDZH0/ah60QrwvUn5UFVDQvRmfzK7+UwKga6K1A9XJML8F+ytF7IPtlKfLqhRJuL7f5HJf0b7uicbu2ZBKSC/VN8NTwQmNlGslmGkXmafe60TuA/P1dkVlLa2SUZwt5u+4mRJXqfLy9G9jL1Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables feature aims to protect all page table
pages (PTPs) by mapping them with a privileged pkey. This is primarily
handled by kpkeys_pgtable_alloc(), called from pagetable_alloc().
However, this does not cover PTPs allocated early, before the
buddy allocator is available. These PTPs are allocated by architecture
code, either 1. from static pools or 2. using the memblock allocator,
and should also be protected.

This patch addresses the second category: PTPs allocated via memblock.
Such PTPs are notably used to create the linear map. Protecting them as
soon as they are allocated would require modifying the linear map while
it is being created, which seems at best difficult. Instead, a
simple allocator is introduced, obtaining pages from memblock and
keeping track of all allocated ranges to set their pkey once it is
safe to do so. PTPs allocated at that stage are not freed, so there
is no need to manage a free list.

Since kpkeys_hardened_pgtables currently requires the linear map to
be PTE-mapped, we can directly allocate page by page using memblock,
without intermediate cache. We rely on memblock allocating
contiguous pages to minimise the number of tracked ranges.

The number of PTPs required to create the linear map is proportional to
the amount of available memory, which means it may be large. At such
an early point, the memblock allocator may however only track a
limited number of regions, and we size the tracking array
(allocated_ranges) accordingly. The array may be quite large as a
result (16KB on arm64), but it is discarded once boot has completed.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h        |   7 +++
 mm/kpkeys_hardened_pgtables.c | 115 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index c7529f9e9f97..0e246354e95c 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -144,6 +144,8 @@ void kpkeys_pgtable_free(struct page *page, unsigned int order);
  */
 void kpkeys_hardened_pgtables_init(void);
 
+phys_addr_t kpkeys_physmem_pgtable_alloc(void);
+
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 static inline bool kpkeys_hardened_pgtables_enabled(void)
@@ -165,6 +167,11 @@ static inline void kpkeys_pgtable_free(struct page *page, unsigned int order) {}
 
 static inline void kpkeys_hardened_pgtables_init(void) {}
 
+static inline phys_addr_t kpkeys_physmem_pgtable_alloc(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 #endif /* _LINUX_KPKEYS_H */
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index fff7e2a64b64..13af4930db3d 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kpkeys.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/set_memory.h>
 
@@ -30,6 +31,9 @@ static int set_pkey_default(struct page *page, unsigned int nr_pages)
 	return ret;
 }
 
+/* pkeys physmem allocator (PPA) - implemented below */
+static void ppa_finalize(void);
+
 struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order)
 {
 	struct page *page;
@@ -60,4 +64,115 @@ void __init kpkeys_hardened_pgtables_init(void)
 		return;
 
 	static_branch_enable(&kpkeys_hardened_pgtables_key);
+
+	ppa_finalize();
+}
+
+/*
+ * pkeys physmem allocator (PPA): allocator for very early page tables
+ * (especially for creating the linear map), based on memblock. Allocated
+ * ranges are tracked so that their pkey can be set once it is safe to do so.
+ */
+
+/*
+ * We may have to track many ranges when allocating page tables for the linear
+ * map, as their number grows with the amount of available memory. Assuming that
+ * memblock returns contiguous blocks whenever possible, the number of ranges
+ * to track cannot however exceed the number of regions that memblock itself
+ * tracks. memblock_allow_resize() hasn't been called yet at that point, so
+ * that limit is the size of the statically allocated array.
+ */
+#define PHYSMEM_MAX_RANGES	INIT_MEMBLOCK_MEMORY_REGIONS
+
+struct physmem_range {
+	phys_addr_t addr;
+	phys_addr_t size;
+};
+
+struct pkeys_physmem_allocator {
+	struct physmem_range allocated_ranges[PHYSMEM_MAX_RANGES];
+	unsigned int nr_allocated_ranges;
+};
+
+static struct pkeys_physmem_allocator pkeys_physmem_allocator __initdata;
+
+static int __init set_pkey_pgtable_phys(phys_addr_t pa, phys_addr_t size)
+{
+	unsigned long addr = (unsigned long)__va(pa);
+	int ret;
+
+	ret = set_memory_pkey(addr, size / PAGE_SIZE, KPKEYS_PKEY_PGTABLES);
+
+	WARN_ON(ret);
+	return ret;
+}
+
+static bool __init ppa_try_extend_last_range(phys_addr_t addr, phys_addr_t size)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+	struct physmem_range *range;
+
+	if (!ppa->nr_allocated_ranges)
+		return false;
+
+	range = &ppa->allocated_ranges[ppa->nr_allocated_ranges - 1];
+
+	/* Merge the new range into the last range if they are contiguous */
+	if (addr == range->addr + range->size) {
+		range->size += size;
+		return true;
+	} else if (addr + size == range->addr) {
+		range->addr -= size;
+		range->size += size;
+		return true;
+	}
+
+	return false;
+}
+
+static void __init ppa_register_allocated_range(phys_addr_t addr,
+						phys_addr_t size)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+	struct physmem_range *range;
+
+	if (!addr)
+		return;
+
+	if (ppa_try_extend_last_range(addr, size))
+		return;
+
+	/* Could not extend the last range, create a new one */
+	if (WARN_ON(ppa->nr_allocated_ranges >= PHYSMEM_MAX_RANGES))
+		return;
+
+	range = &ppa->allocated_ranges[ppa->nr_allocated_ranges++];
+	range->addr = addr;
+	range->size = size;
+}
+
+static void __init ppa_finalize(void)
+{
+	struct pkeys_physmem_allocator *ppa = &pkeys_physmem_allocator;
+
+	for (unsigned int i = 0; i < ppa->nr_allocated_ranges; i++) {
+		struct physmem_range *range = &ppa->allocated_ranges[i];
+
+		set_pkey_pgtable_phys(range->addr, range->size);
+	}
+}
+
+phys_addr_t __ref kpkeys_physmem_pgtable_alloc(void)
+{
+	size_t size = PAGE_SIZE;
+	phys_addr_t addr;
+
+	addr = memblock_phys_alloc_range(size, size, 0,
+					 MEMBLOCK_ALLOC_NOLEAKTRACE);
+	if (!addr)
+		return addr;
+
+	ppa_register_allocated_range(addr, size);
+
+	return addr;
 }

-- 
2.51.2


