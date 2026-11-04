Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8266D608361D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODwixlVM
Received: by kanga.kvack.org (Postfix)
	id 8C5FC6B05B8; Wed,  4 Nov 2026 11:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876AA6B05B9; Wed,  4 Nov 2026 11:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F136B05BA; Wed,  4 Nov 2026 11:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C84E6B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:47:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4235807DA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:47:13 +0000 (UTC)
X-FDA: 85398016746.27.5570C0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B3A3120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:47:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODwixlVM;
	spf=pass (imf29.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMstP/SZKyTAtGdzwkDZv+zBhTOefZsJBVO289hh0iI=;
	b=EdEga5f/96VTuIM2/Iticat5Y/dqm+0vR3YEv1Sk+SaLKN9IbLugiWuc8yVHZ8pBdB4DUr
	hyVwZ0YDWDcMuNrn1pRAA/as608QEc+1pMAXRSrRZ/c7YtwtMea1ksp9Jh1bDh+kDyK+dJ
	kDuAxlmpuC4ewth55ZaYnlhX2zQWFf4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODwixlVM;
	spf=pass (imf29.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810832;
	b=BzJVjCvdCOZ2Z7CwPRBx1U1PDU44wAng34ikYFBQ8eZvQy5rCxRRvhF8UO/Qj8GgaYXxB/
	ciwtpAffUrfNFwzkn/vdtNcHyABUG/+nzw1EqM6gDMFnVNW85cgsvS3Vla+iu+cdj+gJCm
	BGawdsfN44mIGcZ8OwDoxWoEfVvo4gI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59D11405F4;
	Wed,  4 Nov 2026 16:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F18B1F000C1;
	Wed,  4 Nov 2026 16:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810831;
	bh=JMstP/SZKyTAtGdzwkDZv+zBhTOefZsJBVO289hh0iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODwixlVMY/WuHSIBG9jucqNtur/74mXOfme6KyxU15JFDNXPVm+4m3B//5CLGvKpx
	 j08EjiSi+XQprXfYLa6qC1E4xxMJv9V0s5A+XT9xy0tQc419kLYrjCAubJG2lRAeur
	 YeyMcTLHPB+1NL6Gd6J95C6atl0fJ5EMaf6IN1pwi8Ux17257A50eYcjUdHHGCXU1b
	 Bxy2ys/NIo4GNJBlizgc4hdV8jLv3B9JKOVfunCDC2svqT6EV/Pen7TKggPrJa3rT2
	 FROGM7wg5rEmvF+HP0qvXfPBi1JBIuvx5HfJiHm0mcG4OAGcYvo3YXbTpUg5nK9bLh
	 RKreURhgezLOw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
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
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v9 01/14] mm: Add an allocator for CoCo shared memory
Date: Wed,  4 Nov 2026 22:15:42 +0530
Message-ID: <20261104164555.3555725-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bzseo9xpf5aisosodkw9ubsr1nfn54zh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0B3A3120004
X-HE-Tag: 1793810831-258489
X-HE-Meta: U2FsdGVkX19Hnu+Hv6LJS2p9SeeO2e/7u7KFOi2impRO33blRMYmMjqK4w1KF2rZhBCB1ELm94+tLigqEk1VysjrkJFaV+EgR3+CUjiIJTaE2GhX3WYNGk+gGwdDvUF8Jevf8huu8yZx+DbtC9+dZzrjYDvAD0dFx333wUDaIkI1KQruH5d+SVtx39BMI83QI1+QcK57W6WNlwuOGu7C2mCdqBSefkowSdDW5ggtPwGamsLu8L6vA975YCf8UErwlfZOrNbv6a7tlhoTI0kaGvN62O8Zp9XYOEvazrBZabI6G0il1n2dDnD6CV3r5dI3wVisP36vJSg/Usiux+HVxq3Z3HKx20Ewe6xgHX3TexRfDOv38m3PTR1aVJdm3lOlByQldo18JgAXqvLBaOBcP/weC8u01v0MeCAOjVmpUwXUKw5I7Uuam1SUFtMKoYBhKWrFw2h/uK4WTXsjfkQsgE4T6ao7OGR+SVCuBc0Pbao+PwHzQ4kpcyQADVrZ0G8WdpdiTCX1ygXGVVPbUA0aWXLNoVTrpE5WVezxakMtn+ks+5yk0PBpG3/v4YlVEYZ0lkH7ikq4kaf1FfEWWzQn/s0LggS5XEA5LgRLhX5zxsQGGopzwPubxaBSjP3I/MRryfOUKKmdvsJPBbRes+7/wC0D36xnx8DHV7WvmwB7TAuxLkRv0iNSW5CadXlO/zrTA08occ6MH9IgxIY6VmZ0rLDfZaOxthVxBZXSNoUT6npbtZWFfhW0lp2YNyB8hdG5lnE9kfX05FUcUcvD5iSm+r3vqEGd8F3FLJFzpmVj6Sl8c1QqAcf0um45Bnq7TlFag+TOFBo6hH91K3YE6Eu3PVQCscZaBOAXshf7sFYDvnwHECpujNoZW+u3eC1wYz7JQZ3OscEIIfxRBtea1JUkuMymSn/T8NrqgcrSCQ5IahIiXrXDgCAHk31djy0SRbOWNMNQj/gyjpHyqq4zI/e
 bi9xhpXo
 xu4bEpFUWQScddq5RdoQZVlFI/LEj9naBpxkbA9fVRBUqtVjju2h8mrj76cHQjqHt08zpEmAgA74PY6RgXA8Fr3GEkKebmgHji0dU+hkMiO62MoYpQtord8k3fe+m5gRMi8mjx99O3UiFhhrurAxP+n97OV7CrAO+st6GI92h++eWzxgpwgAoTWZ5EmWlxefiVVIzs3mfAhOS5or9wIVSvLRCD1eHTZr8H6gUwsnPnHUxkOiDfJ4hg9oGXN0lwyz43Eu3iixsyIeiJ3ZGluAo8TPHBsslSNMf0hSnr+YZFc9YrIErVDWAPFSxGUht/lh/tolVmhzR4JxmlUCg9LZgYiwHoByGis/lCG58Jk7UsCad0sGCoJOOgGZbng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 mm/cc_shared.c            | 233 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 273 insertions(+)
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
index 2a3ec53d62ee..a712656449d1 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -57,6 +57,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   debug.o gup.o mmap_lock.o vma_init.o char-mem.o \
 			   $(mmu-y)
+obj-y			+= cc_shared.o
 
 # Give 'page_alloc' its own module-parameter namespace
 page-alloc-y := page_alloc.o
diff --git a/mm/cc_shared.c b/mm/cc_shared.c
new file mode 100644
index 000000000000..5c4c971cfb7b
--- /dev/null
+++ b/mm/cc_shared.c
@@ -0,0 +1,233 @@
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
+	/*
+	 * State transitions require a linear-map address and may modify memory.
+	 * Allocate from low memory and defer requested zeroing until afterwards.
+	 * Shared allocations have no migration support, so they must not
+	 * be allocated with __GFP_MOVABLE.
+	 */
+	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO | __GFP_MOVABLE);
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


