Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 178FECD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E316B00D6; Tue,  5 May 2026 12:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EEB6B00D7; Tue,  5 May 2026 12:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDC86B00D8; Tue,  5 May 2026 12:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFFF6B00D6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DFBEA140554
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:11 +0000 (UTC)
X-FDA: 84733847982.08.B9EF8E3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id BE10C40014
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UWnqVtTi;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzqZeNH0Lv3JnQDH3gpdpa6STmyMD3amRDvLnl/6SzQ=;
	b=0vTH1aIszJJGj1aYBmj0p0t7L3/jypbYPkj3oJOI+3Zyw8b8VBC5y+KfNvcqgxXDe9IINX
	NpaXbSrQ+4ZTqXjX9ukeT1sYMH/a1RtfbKUqK/eEoLzIcJKp2TwGAjpcmiV+3cUCt7ibkP
	en9W8pbn/XYkXlV/otlPZBqwLLO3Hck=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UWnqVtTi;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997290; a=rsa-sha256;
	cv=none;
	b=pxBrufN1ePLAkFErm5g+fZpCbycVSXhY2SEuL5//49fEf9L/tT445RVKegG1jNLVdavx8T
	XJ5ozwn0+JRnQjPL57TBl/5SO/NPuCO67gBsJYwhOIfahkc0SuokPhMKKmwCEbgKHdA2Qp
	gX39PuJ7G8kILDX8st3nNd0jfV/zh/I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7ABE514BF;
	Tue,  5 May 2026 09:07:57 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B02BD3F763;
	Tue,  5 May 2026 09:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997282; bh=+4mPtU8ML5lnaH7LBGXsM7pqQ71TUsjEb8tbnZNz60I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UWnqVtTiScYhyf2YNfT5kwzRiOxZ2+MxnuBhDO6eaoxCD6MrQj73ajhFdbV5hnASr
	 Iltr+1TATmFuqayCN02ByZ7XV1AsqXE1fdf0YNQD90xEve37wWgcuOO+CtjZT+PFR+
	 s3n5MHf4xZSUaJEOkOpQd3apjCCPt2FZznaavMIk=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:02 +0100
Subject: [PATCH RFC v7 13/24] mm: kpkeys: Introduce early page table
 allocator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-13-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=6674;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=+4mPtU8ML5lnaH7LBGXsM7pqQ71TUsjEb8tbnZNz60I=;
 b=5vOnQto1KS+1yKFStg02+/OAXLFol1nVopa7ZEdXQ7Cx1SD8A1ujKOazl0i+AvzNgruHVjxJI
 Bt5gGNPNB06BKXFoMekN7Dnm07z8yxqvVr+UiyHt52uI6YuDKzZMh9u
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE10C40014
X-Stat-Signature: gnkbszogbfty13i3ejciyaofrdms9w6p
X-HE-Tag: 1777997288-717561
X-HE-Meta: U2FsdGVkX1/b9r5RcrgJzH7Xi8hd+hIhm1xUWgtL1mKAWxzm2aT+VFttED9ShxEBXsgKBYiODWV016eWUXpBDCq8xb7M7oqDQ0xYGH7mEdXrrrqaTW28Zs0CwAq//MplPmOLB4SbfMI1DPrA36OWM6HSNbritCFsA7O9Xb0J73nooMtk3Ko/wIyUPaA/vYazm2Uv0V4iDxZz1YOxNdBmCq7BbPpOQ1om4wDj2zg43DfQiWUaI0zhGybuUu/YM6wu8A7UxeiFxRZUc7cTvf1Le7uTGE4615oP/jQpvYHPQYFeOR7zzmR8XUdEYI3zGmAVOW5sQ82Td7uECPPeLVNu812hSHP7MIvDcYl4PJdPmFCmIZyPaoiAaUDD6tBHaNNH6GCGsF7DUt0VTNR8gTfpFgBxGzlDEp959Lbsik/05aL3Y5NAvU02uwA3LwSH0vJNkjgpknS1n/IsrVYRVk3wCyQaKVAWKBpvRnxApGKqNHJaiU/c2QPJ4NPs0/KVJPyjdMC+b9FDQKsYcVf/CsYymkYQ8xUTzkb5DGfZTHZq2UOOg5+QfdmA4mZkH3RdgMJuOiKWs5F3bcwRqxW1cEgKTzG4C2FnbFihfjD8WWmAEpdvVVQmT2RmKifzfktwtvl9eUxfRd/59IJPv0zgJugzUmZLaaYkTJXuIdIu7OpA0o6iKuaCb/HkJPF0ARDTUSxjTqFLUgvq4xxLKLIuJqtpZ4lkc3Y0l+bVMQeHaVvpIoxhrjZTps7KcduaZv6zA0kGRQxHbRbb/IoyZO3rOTnb0UBNycIIVWmAZd7ySF12PZuQN4zU4RVc0tWiLQoE/BbPQI6SFhnFuJRcqfQbDd0hDC2c/5pBDH9myVhIdlC14sTGmqoIDDt53rJ+ONqJVJFRiQGVFoeqgt40C0NAXUD1r9pPyVhZdZR4QR+796oYoHY+/8kkbyKe5Nuu/UAA4lgWBvkv6liyrIwk+btyub7
 1yftRtJ7
 wZpy62QnAp8uEXf9xQoQgA/F8GNVV03H/RFqFjkXePKrYkb0Pu59jrdIx7FuCaMOG2SrGO4+xXyaSRzgAaC8W0EDiqO/RSDBe9vFneBuY9NXe5ijEBZaPqTNCFi1aF0D6SjoqXx+8tOwe1Otvau2d/euxBfyvqLUxeJwXJQ2pW8ZTDKCDLI6qN/j0wJwWzh+WYpw/zg6FV8gax7Y5AukjBX0p3w==
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
 mm/kpkeys_hardened_pgtables.c | 116 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index c9f63415162b..544a2d954bc1 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -140,6 +140,8 @@ void kpkeys_pgtable_free(struct page *page, unsigned int order);
  */
 void kpkeys_hardened_pgtables_init(void);
 
+phys_addr_t kpkeys_physmem_pgtable_alloc(void);
+
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 static inline bool kpkeys_hardened_pgtables_enabled(void)
@@ -161,6 +163,11 @@ static inline void kpkeys_pgtable_free(struct page *page, unsigned int order) {}
 
 static inline void kpkeys_hardened_pgtables_init(void) {}
 
+static inline phys_addr_t kpkeys_physmem_pgtable_alloc(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 #endif /* _LINUX_KPKEYS_H */
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index fff7e2a64b64..c7a8935571ac 100644
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
@@ -60,4 +64,116 @@ void __init kpkeys_hardened_pgtables_init(void)
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
+	pr_debug("%s: addr=%pa, size=%pa\n", __func__, &addr, &size);
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


