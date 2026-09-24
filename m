Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47094C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529E36B0098; Thu, 24 Sep 2026 06:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9DE6B0099; Thu, 24 Sep 2026 06:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9AC6B009B; Thu, 24 Sep 2026 06:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 154E36B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:06:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4E53140239
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:06:09 +0000 (UTC)
X-FDA: 85248225258.01.8536A40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1DDCE4000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:06:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ch5tx7zD;
	spf=pass (imf01.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6i5Bn/p9hoYkPkAS4fE0FC3u08lww1IyLVqKIgULjmw=;
	b=DXs9eD6YANesRWYE/Vs5/oFHuTh6R2SZ2teINX3RQiB3pXOi0i8qooayivQ7YY2g2fLH2A
	imyqwnXSZ/rGshQi0zFmPeX/yr04kM2/Xw4rGYh12N925Nyyy50azGBW/dI/WQYmN8WQza
	X1Xk6bI680NMAeh4lNtv6gKuxbRUbSM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ch5tx7zD;
	spf=pass (imf01.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244368;
	b=52SdIDVbFcqDpaqkOqagODbmNEhP/123/bExXunSyq7F9s7rRgisXvaY45KeoqBtVKGEyK
	nlV1Tnc+LpOY276ksKoDzFTQlmD+J0RS70Lxrx4DVi+hVlMAfGJrKtBBejVzh+/0QhsY9o
	jVE0vh7+eIAR+4YNSXGBU6rAB2gmBm0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4490F43C58;
	Thu, 24 Sep 2026 10:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26BD1F00893;
	Thu, 24 Sep 2026 10:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244367;
	bh=6i5Bn/p9hoYkPkAS4fE0FC3u08lww1IyLVqKIgULjmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ch5tx7zDK2am4maKTos8NryZBOb9Q9yKA2U1aj8MpTofoC0f4brL3bAeytSaOvGYy
	 fDsWrt8SVwJVn9N1tSC9N7RcwWe3yGqb9p6XSr09zdW6qYzPndPqljKfmUQl7WxIAO
	 ulbER1KfvK1A+1r06J85qrf9/l7nA8SJoiENU7EMpivAr8GTvf0biNlSXhA5R8ZS1o
	 PqzwZEI1d+rqcIXxLuUvmNB7qS+eDjNsrYtizjnVC25Jm9KuFhBltE4xoGZbO84fYQ
	 zMCmmYyUuQTLuB4dwHz/aOgbihC2Fsm2XyqIyVf9nCSvR/8f40Pbdy6G6PuW0zk3WW
	 sY7AF4kTeKdMw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
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
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 01/14] mm: Add an allocator for CoCo shared memory
Date: Thu, 24 Sep 2026 15:35:16 +0530
Message-ID: <20260924100529.1398790-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DDCE4000B
X-Rspam-User: 
X-Stat-Signature: y7xpsc47nzcsmqdjhyykxe58ia8kcf4a
X-HE-Tag: 1790244367-953066
X-HE-Meta: U2FsdGVkX1+ICvabYS/RtAKW9vA/bvA3zCJ/CdZtZMPoyPQceHPJgvETg+Hoh9111npMLEFfUak2FLSdqWp1E+DjK4EZ7beGxYyDU5Nzq/jnD2xSTe0FQ/Csq09u5pvwXA2idHTdVYN5RpJFb+i22MyKXah5B2DiQ8BwhUS3cSFG5cpRYojwiMUbkfEhhqbH7o5xYTjVU1Ay1f52zCYvgdT5hzwKryCyor2gwD4K/Q9rUw5wymh6qvDNUnQb/stl6aRB2z/lHAN7yztbmN9uTISZv14Ly/KdMtelDcsMWpxnmHgFeBbeO28ECLPKgsSLUorGAny3KNY4Jd6Fk536xO1eMaSFkkVUu/46kwZV+kz6/xrK5dXFaLbBkXO70c3EpikKlOgHQMKwjmi47qamduyM+UuWLIs9Zz+nOskEO/YyzijilObJ1TSTE9ClbaDiK/fkajrP9qpmfCji5fO+cmVyyKUtPiEM7N6IR/IN4V+cL8im/pyO0HYBJ7HwPfE2W0zcN2e94ny2xt/ydlzI92XMkoUq6pYI6yUhVwxx2bUpeCfUgJBF1Al2crfKXV5yTZeLULFFKFogHWIPEOrnMCz6rtyLcGeIvC3tdn37qQtxPGEkqUeZevs6JvntlPAVFVVz/Qdn5rFUE2wgclPOLYg8Sdhpy19+aE/vfhLdFAhHVASrwnEwP2VFMDWdIVfulEF3GmYzKswFP96xV24F7Y0JphLt72Y4wJy0Fj5yRdfzKA6ZueT1fXNp9JzPFV+dLlBvkbyi24NwqKLzhY7PT4R3q7IG0YzTbFydRH6C7hvmt1SblrGjQJJKDmjdZE/115xDKI4gRk43kAZrrmGgJ6CPdoAfA8r1UYyVS+iy9aKviRc/aeH9LgP5Gk+GcUwYzmSGVuqJ2kBK2bhNNebxrU586pYYgDQrojtY+OLDHBqugzRxKuf5LRG70w6wY3ZkNm/hD0UKX6LSpTMc9rT
 Q4hTzIZt
 4CwpCF6ECa15CFyzOKHOcLUY7IbZCyVSIqmuxwlC7LTnCiwowoPqNH/5Wl8H0OYt4WMknJst2b62Yy0+gQkSgZ5nP1tWW0hhxms9kh8bqyEG/2PJhwovH5YZCUb/ci5ps2GXG8v/1h92PkH6avP2aZ+ubRpbp5lRDXr+/EGkBy/CxzZ8qeniJfo3umzFvkrTgACdF3K1m0vgYGU2IB1Kc1HzZh3dG28rcW1ibL1Q/IB8yKknYsx/ODESi8DmRZfU8dNR16/704VX15+p2TB3ESMPc8sPAa45PYsyTpeFpNBQD2RMhOF+fCnyDol5S+Q5Y+n9mHfIRo+/s0AQyXcFtvEOnQBz+rn2P/f3SM1JqyLXmOaHIY3Kunjt3Mw==
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

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/cc_shared.h |  39 +++++++
 mm/Makefile               |   1 +
 mm/cc_shared.c            | 232 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 272 insertions(+)
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
index 000000000000..85e16f4504b8
--- /dev/null
+++ b/mm/cc_shared.c
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+#include <linux/align.h>
+#include <linux/cc_platform.h>
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
+static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
+					size_t requested,
+					struct cc_shared_pages *mem)
+{
+	struct cc_shared_layout layout;
+	struct page *page;
+	unsigned int order;
+	bool zero = gfp & __GFP_ZERO;
+	int ret;
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
+
+/**
+ * alloc_cc_shared_pages_node - allocate memory that can be shared
+ * @nid: NUMA node from which to allocate, or %NUMA_NO_NODE
+ * @gfp: allocation flags
+ * @requested: number of bytes requested; must be nonzero
+ * @mem: storage for the allocated page and the size of the shared range
+ *
+ * Allocate at least @requested bytes and make the allocation shared when
+ * memory encryption is active.  A memory-state transition requires a valid
+ * linear-map address, so such allocations never come from high memory
+ *
+ * The shared range may be rounded up to the architecture's transition
+ * granule.  On success, @mem->shared_size records the actual size that was
+ * made shared and must be retained unchanged for free_cc_shared_pages().
+ * @mem is not modified on failure.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
+			       size_t requested,
+			       struct cc_shared_pages *mem)
+{
+	struct page *page;
+	unsigned int order;
+
+	if (!mem || !requested)
+		return -EINVAL;
+
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		return __alloc_cc_shared_pages_node(nid, gfp, requested, mem);
+
+	order = get_order(requested);
+	if (order > MAX_PAGE_ORDER)
+		return -EINVAL;
+
+	if (nid == NUMA_NO_NODE)
+		page = alloc_pages(gfp, order);
+	else
+		page = alloc_pages_node(nid, gfp, order);
+	if (!page)
+		return -ENOMEM;
+
+	mem->page = page;
+	mem->shared_size = requested;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(alloc_cc_shared_pages_node);
+
+/**
+ * alloc_cc_shared_pages - allocate memory that can be shared
+ * @gfp: allocation flags
+ * @requested: number of bytes requested; must be nonzero
+ * @mem: storage for the allocated page and the size of the shared range
+ *
+ * Equivalent to alloc_cc_shared_pages_node() with %NUMA_NO_NODE.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int alloc_cc_shared_pages(gfp_t gfp,
+			  size_t requested, struct cc_shared_pages *mem)
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
+	if (!cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		goto free_pages;
+
+	if (cc_make_private(page_address(mem->page), mem->shared_size)) {
+		pr_warn_ratelimited("leaking %zu bytes that cannot be made private\n",
+				    mem->shared_size);
+		return;
+	}
+
+free_pages:
+	__free_pages(mem->page, get_order(mem->shared_size));
+	mem->page = NULL;
+	mem->shared_size = 0;
+}
+EXPORT_SYMBOL_GPL(free_cc_shared_pages);
-- 
2.43.0


