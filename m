Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD6C3C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F8C6B00D1; Mon, 21 Sep 2026 10:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17E56B00D3; Mon, 21 Sep 2026 10:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06236B00D5; Mon, 21 Sep 2026 10:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE956B00D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:49:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 103A71201B8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:23 +0000 (UTC)
X-FDA: 85238052606.08.F8DA659
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6446880008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdZns7tR;
	spf=pass (imf30.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7sVvZ0TpR9jG7Z6PhTPLhhY4EWJmZkPJ/dFrOpNRfI=;
	b=3DhAp7lXpAJdtoTJgij4eT3QVZbaZ/MA4yDdJ7epgfh9Qp2QxighJB3BnOWC2ZvyUIVu2I
	p8iAuV2rAG1+xkL6ynRed3QEGjzph7KSgsyxxV8zZJX/8WGcN5R1FKBkrQtVz5L2rUukHG
	CgNtzstRCBrw0CsaUphAIrlN+kZKnA0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdZns7tR;
	spf=pass (imf30.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002161;
	b=JssCvLeVAw1CsydkcispRcsCgL4FWdSar3CVh4NOJQ6vLo/bGfEw9jL1ePutOd0XcVZqGI
	XQXXMAjVqoWcXGrb4Sdsr2C9ceGYhPp+7lHUjv9fEXjvk7mzdteqEde8v0tC0CZoXR+3lb
	frlFpzVLNfcyrwBsUDGXaOCO3e2v6Y8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB845416B1;
	Mon, 21 Sep 2026 14:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E21C1F000FF;
	Mon, 21 Sep 2026 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002160;
	bh=t7sVvZ0TpR9jG7Z6PhTPLhhY4EWJmZkPJ/dFrOpNRfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdZns7tReCovmHsXVFD0CwBYCulv7+HG4ka6oZYWJ8kj6CqlQcNkjR0nDk82rlhve
	 f/a0B57WTKwdXlOAriV0QCKNZ/FFLLLyhvt3Kuu4C23Q1XEadXBHFCeSsQFVtrQjsS
	 HKWwYcRjC5Vg1EuEAGD0vvxNwOuubN8KeP9oyU+2BNE5O+/LKxKJF2orKg7Z0tB3A8
	 iPx16UnvXUpcO31eD4eMzo9preD6/uaQqef3DwhNu3y++KqMYHK/nv93CUjcfhJ1KW
	 Ot1Z0BTcMqt1vWP+CAtR06TdGl0x9DMMryLn4zt+HEJvReHDbPDJfGwOlEtlvvxpht
	 oapMlkvCwpPYg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	christian.koenig@amd.com,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Date: Mon, 21 Sep 2026 20:18:36 +0530
Message-ID: <20260921144847.501151-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6446880008
X-Stat-Signature: 4qc8oucuxh4aoeyhmz5daz7zbb9i9qrf
X-Rspam-User: 
X-HE-Tag: 1790002161-787374
X-HE-Meta: U2FsdGVkX1/6Z20kQ3S6GRb+pt4+UpZfyzugz22TUAnsNEQcx/XFg/znIiLXJ1CRnwEpww3DWqXz2JmFS2wds+3wcsM3d/2sxmHLq/zrxIxKG4MxS0xvWNNyPcdTsyPKla9IdI7UpG8FTfkUkJjIXjyD5q9qt6lyALPufSBW+T1okyob4nxvUzTE9WifxCRB2FKEiUDguN3hbrKWPJEPuY8IMOo3tzEtTdU/lW3891nFgYkH4TqAOXcBnN5r1YOwggmuhQsINM/VnkeHO3+C+6aDbzA6d/Ep7IPfQyuhl4T7N0J3wCtJBscvlwrHHAFaRnHi/mJOlKa7/O5kjHEimlHS/TQGGQ8g4EGqXuAaq506+XU6HJbTblpg3IUXTlisGF4CAMxNUg15OmKTZuQEqHHIk6+pncbLCt2z01g49spFRvWfK3U1+eMkgKyoMV/zlypalAif+8aENG7v7hfcn/J7qmucGhR6c7cF0qFdW3VGzUUz4HkFHv7tL3ZJLoeWypidiWwXv1deVFoxY3a8YhlbqBNi1neIJs56mKWXnLBMJj2tQ8/+PuHbxj49OSCDOzk+tLBnHwjbiFFWTY0xXmXQQCh6wj7w6IsGNwEGi3CcXIlCV53sQFrrH3KNeXSKHop8+OO6O5x6OZFpQ1nSwrdsVtvYojwq6PoowYQLdVmUO892hEXUyTLIJSI9zjA+ITmn9cLB2MtBcT2kAMdw7fshAqkWdQXmx3seROHsMiFBU9rVCX56CgXte8RctHQqE4XNOb3Wbil4ebHF2xs6eiNPqZGTrtKbUGtuGpAPRJyGy/YydrCusabLwfjGq7a1NMEGM4u4tmLCWDpEt9kZdwFzAbLaHd/KM0xumRif7ARoV4mYJSu1qp1W+WQyK72B8s92cl+x9g2S776k2M5oAgl+kIEleBqitEEItJ67ryYOhtLRQuW6/bh5aUvqYzAy/sE9zJ7NH0Woran9E6e
 XCz3PX1x
 hsZR3w8YGDWmBcEpYwH2yYf8MYN2SmIQL9Hff2Ebbp/U2CTHfjWLeOXwBFIUTyiFGqLZGyoFBjWhNR13hIFHGyGJcILn8c9vHi2Ofr6gHAXh72p3gg0+Jg3wKlPu5ypRee1P1fUemWdCTDtGqAMi4gdxUmm8nrFD3ITAqbsSGgXXkcMrUhXfmKB/r0ml159d9IONUr6TcE1UWfT4KBDhEQ6lYhcVLzxNYciIVUJUFOYush54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Confidential-computing guests may require memory shared with the host to
be aligned and transitioned in units larger than PAGE_SIZE. Several DMA
users need struct page-backed allocations satisfying these requirements.
Provide a common allocator instead of requiring each user to open-code
this sequence.

Add alloc_cc_shared_pages() and its node-aware variant. The allocator
rounds the requested size to the architecture's shared granule,
allocates suitably aligned contiguous pages and transitions the
complete range to shared state. It also preserves the caller's GFP
policy.

A private-to-shared transition may alter memory contents. Mask
__GFP_ZERO from the underlying allocation and when requested, clear the
complete transitioned range after cc_make_shared() succeeds.

Return the page and transitioned size so free_cc_shared_pages() can
restore the complete range to private state before freeing it. If
private state cannot be established, retain the allocation instead of
returning a possibly shared page to the buddy allocator.

Also provide the shared-granule geometry and byte-oriented transition
helpers used by the allocator and by callers managing their own backing
memory.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/cc_shared.h |  39 +++++++++
 mm/Makefile               |   1 +
 mm/cc_shared.c            | 172 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 212 insertions(+)
 create mode 100644 include/linux/cc_shared.h
 create mode 100644 mm/cc_shared.c

diff --git a/include/linux/cc_shared.h b/include/linux/cc_shared.h
new file mode 100644
index 000000000000..5f8db7c468c5
--- /dev/null
+++ b/include/linux/cc_shared.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CC_SHARED_H
+#define _LINUX_CC_SHARED_H
+
+#include <linux/gfp_types.h>
+#include <linux/types.h>
+
+struct page;
+
+struct cc_shared_pages {
+	struct page *page;
+	size_t shared_size;
+};
+
+struct cc_shared_layout {
+	size_t requested_size;
+	size_t shared_size;
+	size_t alignment;
+};
+
+/*
+ * Architectures may override this to return the granule used for transitions
+ * between private and shared memory. The value must be a power of two and no
+ * smaller than PAGE_SIZE.
+ */
+size_t arch_cc_shared_granule_size(void);
+
+size_t cc_shared_granule_size(void);
+int cc_shared_calc_layout(size_t requested, struct cc_shared_layout *layout);
+bool cc_shared_range_valid(phys_addr_t base, size_t size);
+int cc_make_shared(void *addr, size_t size);
+int cc_make_private(void *addr, size_t size);
+int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
+		size_t requested, struct cc_shared_pages *mem);
+int alloc_cc_shared_pages(gfp_t gfp,
+		size_t requested, struct cc_shared_pages *mem);
+void free_cc_shared_pages(struct cc_shared_pages *mem);
+
+#endif /* _LINUX_CC_SHARED_H */
diff --git a/mm/Makefile b/mm/Makefile
index e7245cb88c66..6e6544428422 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -56,6 +56,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   compaction.o show_mem.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   debug.o gup.o mmap_lock.o vma_init.o $(mmu-y)
+obj-y			+= cc_shared.o
 
 # Give 'page_alloc' its own module-parameter namespace
 page-alloc-y := page_alloc.o
diff --git a/mm/cc_shared.c b/mm/cc_shared.c
new file mode 100644
index 000000000000..3e33681218f1
--- /dev/null
+++ b/mm/cc_shared.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+#include <linux/align.h>
+#include <linux/cc_shared.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/log2.h>
+#include <linux/mm.h>
+#include <linux/mem_encrypt.h>
+#include <linux/numa.h>
+#include <linux/overflow.h>
+#include <linux/set_memory.h>
+
+size_t __weak arch_cc_shared_granule_size(void)
+{
+	return PAGE_SIZE;
+}
+
+size_t cc_shared_granule_size(void)
+{
+	size_t granule = arch_cc_shared_granule_size();
+
+	if (WARN_ON_ONCE(granule < PAGE_SIZE || !is_power_of_2(granule)))
+		return PAGE_SIZE;
+
+	return granule;
+}
+EXPORT_SYMBOL_GPL(cc_shared_granule_size);
+
+int cc_shared_calc_layout(size_t requested, struct cc_shared_layout *layout)
+{
+	size_t granule, rounded;
+
+	if (!requested || !layout)
+		return -EINVAL;
+
+	granule = cc_shared_granule_size();
+	if (check_add_overflow(requested, granule - 1, &rounded))
+		return -EOVERFLOW;
+
+	rounded = ALIGN_DOWN(rounded, granule);
+	layout->requested_size = requested;
+	layout->shared_size = rounded;
+	layout->alignment = granule;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cc_shared_calc_layout);
+
+bool cc_shared_range_valid(phys_addr_t base, size_t size)
+{
+	size_t granule = cc_shared_granule_size();
+
+	if (!size)
+		return false;
+
+	return IS_ALIGNED(base, granule) && IS_ALIGNED(size, granule);
+}
+EXPORT_SYMBOL_GPL(cc_shared_range_valid);
+
+static int cc_validate_transition(void *addr, size_t size)
+{
+	phys_addr_t phys;
+
+	if (!addr || !size || !PAGE_ALIGNED(addr) ||
+	    !virt_addr_valid(addr))
+		return -EINVAL;
+
+	phys = page_to_phys(virt_to_page(addr));
+	if (!cc_shared_range_valid(phys, size))
+		return -EINVAL;
+
+	return 0;
+}
+
+int cc_make_shared(void *addr, size_t size)
+{
+	int ret = cc_validate_transition(addr, size);
+
+	if (ret)
+		return ret;
+
+	return set_memory_decrypted((unsigned long)addr, size >> PAGE_SHIFT);
+}
+
+int cc_make_private(void *addr, size_t size)
+{
+	int ret = cc_validate_transition(addr, size);
+
+	if (ret)
+		return ret;
+
+	return set_memory_encrypted((unsigned long)addr, size >> PAGE_SHIFT);
+}
+
+int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
+		size_t requested, struct cc_shared_pages *mem)
+{
+	struct cc_shared_layout layout;
+	struct page *page;
+	unsigned int order;
+	bool zero = gfp & __GFP_ZERO;
+	int ret;
+
+	if (!mem)
+		return -EINVAL;
+
+	ret = cc_shared_calc_layout(requested, &layout);
+	if (ret)
+		return ret;
+
+	order = get_order(layout.shared_size);
+	if (order > MAX_PAGE_ORDER)
+		return -EINVAL;
+
+	/*
+	 * State transitions require a linear-map address and may modify memory.
+	 * Allocate from low memory and defer requested zeroing until afterwards.
+	 */
+	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
+	if (nid == NUMA_NO_NODE)
+		page = alloc_pages(gfp, order);
+	else
+		page = alloc_pages_node(nid, gfp, order);
+	if (!page)
+		return -ENOMEM;
+
+	ret = cc_make_shared(page_address(page), layout.shared_size);
+	if (ret) {
+		if (!cc_make_private(page_address(page), layout.shared_size))
+			__free_pages(page, order);
+		else
+			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
+					    layout.shared_size);
+		return ret;
+	}
+
+	if (zero)
+		memset(page_address(page), 0, layout.shared_size);
+
+	mem->page = page;
+	mem->shared_size = layout.shared_size;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(alloc_cc_shared_pages_node);
+
+int alloc_cc_shared_pages(gfp_t gfp,
+		size_t requested, struct cc_shared_pages *mem)
+{
+	return alloc_cc_shared_pages_node(NUMA_NO_NODE, gfp, requested, mem);
+}
+EXPORT_SYMBOL_GPL(alloc_cc_shared_pages);
+
+void free_cc_shared_pages(struct cc_shared_pages *mem)
+{
+	if (!mem || !mem->page)
+		return;
+
+	if (cc_make_private(page_address(mem->page), mem->shared_size)) {
+		pr_warn_ratelimited("leaking %zu bytes that cannot be made private\n",
+				    mem->shared_size);
+		return;
+	}
+
+	__free_pages(mem->page, get_order(mem->shared_size));
+	mem->page = NULL;
+	mem->shared_size = 0;
+}
+EXPORT_SYMBOL_GPL(free_cc_shared_pages);
-- 
2.43.0


