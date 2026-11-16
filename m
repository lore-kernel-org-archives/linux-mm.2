Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0A1606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUjXNyHJ
Received: by kanga.kvack.org (Postfix)
	id E17A16B05B6; Mon, 16 Nov 2026 04:12:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF01A6B05B7; Mon, 16 Nov 2026 04:12:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7D76B05B8; Mon, 16 Nov 2026 04:12:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A542D6B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:12:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37CBF80827
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:12:19 +0000 (UTC)
X-FDA: 85440415998.23.1718739
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A09DF1A0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:12:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUjXNyHJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxfUAOszvQCTXUmZErFMvX2ZmocarrUeS5PZzSS+txo=;
	b=ubp4l5TeYbjUluJ7U2UwN7RYMHM9t22qFbp/7RQcQcgJPDon1x3qFqFLfS3343WNYpfp7h
	Oa5y1q64M51n6O66hjUy2mzIohBTvPdozL1JsoZY/SfnSrIQR+6Nf/I3HTK51yaRaM9qEn
	tXwPsd67PtZSN3cwHOgZ0BNUeCtD2vw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUjXNyHJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820337;
	b=NysY0vel9BDFq++4TzJKEfbZZBLbBq+2LTMNpvcBS4c25r6b5qu9knqIZygDsCrsaflXVi
	JFBDpAsp35YXV8kIyzogIVH16DqK3z8xJwNXa1YmMGuxS49ehzDb8nyO8Lrrgj0wXvFXv+
	RHCyyCm4ebvV2Enhl8OquPO6hJws+r8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F6A36281A;
	Mon, 16 Nov 2026 09:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5114D1F000C4;
	Mon, 16 Nov 2026 09:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820336;
	bh=IxfUAOszvQCTXUmZErFMvX2ZmocarrUeS5PZzSS+txo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUjXNyHJ9Hg2zHxR9TjqEO7QRgDHSG8VfPYUe7za4T5zhiyhT3JvYwjMfSPgBzfF6
	 +6CNLavCTp1Ihs4HuQS7B6uqzFxy4fu4Cvn/KubNIRS8rxFoxkO+oD56YhjXGx8vEQ
	 upXFmBjUfrcM7lCEyaFh3c+bqNKWIylB1FzphK0gmZeipB1D1S76cS0bzHV247Q9EK
	 hNGaaOYIp2Kd3iegiULYZpUuHRpcvmFR6uNmlSbbgd5OrEHc04/uA4snUPsYGcAuGi
	 T8wAutIVuvWHb2eEzzthL4MVOvWd8A4lKxXgCJD3tNtnxIIrw45hKwrNbR/CcMVWys
	 JqsLtyboolF+A==
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
Subject: [PATCH v10 01/13] mm: Add an allocator for CoCo shared memory
Date: Mon, 16 Nov 2026 14:41:24 +0530
Message-ID: <20261116091137.94252-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A09DF1A0004
X-Stat-Signature: 83o4ihs35awq6qafug5ezjatknbzshjt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794820337-414273
X-HE-Meta: U2FsdGVkX1/EL73aHe3T/pMyPtg8jAJ1/sFJga5TsFknbT3KCH0eD7g7d0vJeJZpgsLNH0CjNkth6aQBbHb5BG+OoLKd9aOfAgd5qMip1MxxlnD5arnuH9rV9rJhngzAerLtxillk+wot4oenwBQDs/bbqvZMwafyTIOzruOkwv3F+hAuwuWdBUnhY9/gdtKYB6yv9UNb0HH0VibRCcx9AJjHCGvmDkwQD1W/+dSqg3HV9Erot9kQKOAofJv+77PjZGBQ9LZTM17Q5+t1TOwRsMmkbDGseNcjznzVqcPEW6coNJGadme3FQ4q/SxK6lkFuzf0LZQKUZNzzwOVTqRgDTpexKvufcMVe/ETfNTOYQ58sKf/Cx0PDPzgRquSdErSIcezM92W+/3Hngn0sV9eGTLmKAfsEhpnCxo8if+/f5wDuunGcLyFFX+SPLGhYP159rUwHKgR/BEURiO9MB8S6S5fXabyDxocSXdOBt/2qgG0qriUdiZjJQ7RhknaQF85IS7gbAeF+/zCZYd42WmyY3a9Cc+vk7rnbjLQjWAfCpTn0DkyY4wH8flwspdgyLH3eKkWd52K423mTvR2Qes+kBONJmivRNhZYOtMQVsKX/+bjQgQJK0CaZgoWVVkeiGVAfg/rDy2xTSZZml+i2Hkgfce45llWGFsAzM46LI68iB5qpzhjp7L/4iStm6OG5qrqxJ1XHW8WMNjo53F2/FTx+1+H/SLtGGmyCiCsyKgjmkWqq2gWwdZJ9rIvVJwW/ek3VyR5Ek5EC/7W+3bqE+d1Iku5Zhlkn6JnW2a48668mzk1gXcsZMyxmZ+7gNSCrO43EpentgggK4dRTWYFF/83OknytCbi2x5BwGFucFNj8IvX/kMRl58xq2FgyjahR5h5XbBhEW8fKp/UJe8WUx0ejBHTrJ9F9cYStQTZHB7z8rOAaJLUYN/0CAGO6u6EHpfQVOyY6MZy5MJjTwTUN
 25FgCKcH
 kOMDvs4JxotVmuLrCEQ5wx/qswYEOL21GtjMmdUNI+TI3wIuj3GnZ9ZZf5kYPHpJxNEw3XJbW2jR6EGlaXLqRsg4X/f58n3olscxZh1UHW7QUN+PBpmymnLpbfJuMFCGiOp5XKuLBun38hTYP2QtmQfpciayr5F8cp5Jg7FbZ/R1DB1OviT7kSSp8rFJdQ/Rx7tQqCJxZdySgfDfBRdUvSUJ5RGBlSFxIadpZ5FPmqgtlEKpKNY5g6dQBgAy2qum9Qtp30Tqx5pv67cT2HsF7gt05mYqG90m4ap4c+45zQ8xzP+Q+lrxNleQQol1JRlU74Ene+jzMSkZRv/8IjAltV43v1kMM3W6E0c4hoLtFJOxMu1o=
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
 MAINTAINERS               |   2 +
 include/linux/cc_shared.h |  39 +++++++
 mm/Makefile               |   1 +
 mm/cc_shared.c            | 238 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 280 insertions(+)
 create mode 100644 include/linux/cc_shared.h
 create mode 100644 mm/cc_shared.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e626e45d432..5ce879ea2ef4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28553,6 +28553,8 @@ F:	drivers/pci/tsm/
 F:	drivers/virt/coco/guest/
 F:	drivers/virt/coco/tsm-core.c
 F:	include/linux/*tsm*.h
+F:	include/linux/cc_shared.h
+F:	mm/cc_shared.c
 F:	samples/tsm-mr/
 
 TRUSTED SERVICES TEE DRIVER
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
index 000000000000..77ee65c4c35e
--- /dev/null
+++ b/mm/cc_shared.c
@@ -0,0 +1,238 @@
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
+		/*
+		 * A failed transition may leave the range partially
+		 * shared, with no indication of which pages changed state.
+		 * Converting the whole range back to private is not safe
+		 * on architectures that cannot handle pages which are
+		 * already private. Leak the allocation rather than return
+		 * pages with uncertain state to the allocator.
+		 */
+		pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
+				    layout.shared_size);
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


