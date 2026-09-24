Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21107C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414856B00A5; Thu, 24 Sep 2026 06:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBFB6B00A6; Thu, 24 Sep 2026 06:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3023A6B00A7; Thu, 24 Sep 2026 06:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9246B00A5
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:07:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5916A5D6A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:07:50 +0000 (UTC)
X-FDA: 85248229500.07.ABCC5EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 049F980005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:07:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNxRqbRX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ0WVrMy94SvEspEtHLkpWdnYwmIG1CQN164cHPWINA=;
	b=r+O5yFEaEumYKI0BbjxvHo/cJPI+iWuKwN9BjXAcAicA/myM6fpTQL2d6Vr5pSuttGsE4a
	s3HDWJVgXyhjJWKLwrr//YCi0Fe3aqCvg7pRgGC1GwyPHLAX65XeI6H96Q1Ws2kBSWUukZ
	KaW9H8ncQuAzX805jKDLmhRZqW0JQhM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNxRqbRX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244469;
	b=kvelN4TRLH2HzJIFiVU7xMQmE7NEx/f4jEcPK9K6wMzlnIw03KQt7n8vJDHBNbDL3T1pNc
	y50SJFtj89MClRlbpa4IqJZ61DBas7jOOaAqTuz3geieXm9d/8JV6GAw9EIGr3c83g5Eq+
	WnDhmR+VuJDlIaEgOA2FzE5vSSY05RE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FD8B4196C;
	Thu, 24 Sep 2026 10:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19E81F00893;
	Thu, 24 Sep 2026 10:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244468;
	bh=GJ0WVrMy94SvEspEtHLkpWdnYwmIG1CQN164cHPWINA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNxRqbRXCBgOSlhg7QIsbDMl/whpfkl0ji4BaBHpuxUxIl14Vx/ArJ7tNq0y1ndJF
	 y9K5awNXnNh1KYw2+eWvCuc/PssjIkDyqaZWu4L877wC/jKUjqJ1vtwayk98/dUizt
	 3iMzqyg/Nr0Yi1NyIP5FNWknNNPLaEoaD4qY7DkTirbj7N+UPwQVnWdkefhMMilbyX
	 qzg/oa0RKZLl0sPbOB816fgurHhifb89rdCCSvVAa8jEUMDiGPzlFZ1/Pr/Yn3kxKf
	 +J7YuR28nAYg+9+WmWPWuGTOd4kD+JTXcvMadE+gkobA8U2AGqOoDVzjqNn7LAMkRu
	 O52L6EXUAbO6Q==
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
Subject: [RFC PATCH v8 07/14] dma-direct: Align CoCo shared DMA allocations to the shared granule size
Date: Thu, 24 Sep 2026 15:35:22 +0530
Message-ID: <20260924100529.1398790-8-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 049F980005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dcf5d6ioxh5wakcozpcoxas1xmko61x7
X-HE-Tag: 1790244468-87655
X-HE-Meta: U2FsdGVkX1+DJumSHxZUodDt6kwqKFiy6Ry0ciCjBzIsdUVLgiMs3O8hjvB9B0GKauLI/vhmG+jXHYG4sfm0gVS/Sa2NVSgoUMNuoh3hi/y5v5dMjOit+Ym2oCcQueAKad0tcx8aCasIsWExfsJt2C8+zNYc/rkCOGR8iZj2824KdGrntF42CPjWSpzCJHhDsjIufQ4jVWXg9ia8WpukvRgV31DbeN3/kVK9ttMJ2OAsxpqDOPnsxEKuTorUhIAY6ENl10bWqmD0BcHyVyKj+notc/y6munZG9QpYTIUcQwOEd3+O2m7p3bsm3KexL7AvT6RJaZmmenYii1YGhIPwgVW4yVNPqDajiMWaCWIgc4Wu2dzV/Xa/rWI8ZQw1HHsR5a6jYRUTzCGnBpqEeSzVL75xNJkTSRzbXFZHVNHa+VF4/lcC0aI0klvH2tToga93KWI4/az9UmhHxFMnI9rJBL3sDnRtbS+gZD4F0070i+fKP5wfFwMO3/qADmcbldBHiGdDtFti5biDhAun0DHyz0cm6iax4XaP6yy9YRTw2GMjSODJNf7JP1v+WkewyH02xTcqb3V+DhgH3tCOGIFkGMp7gBC98MoEnUQ2g1YqvBdm06ntusrsTrgG3C3agaRVsATfjhfla4J8KBJfZ+TBOdFkXBpMMN+G+LegvbG2fkH+/gEpmNicsyPS96YEgBkDv3FfvsFEvTJ4cTTst+w0C8f9BAvyGyIfrKydtDWSC9VSlyq050Ax5odn8d3Eq7p+xdS+RdV4aQ68pCqAq5mRW+72uEB49j50oJ1VP9Sx0DnZaB7UljckJkDQNNO9UurmGLLer8l6EeHoXtnEI4kPNZCC7X3yFhWefPU8Xk7jDQjIW/uKdRn/9Z1Jh8FYx287m5/tkMauXWEMeSAoWp/VcNPfuOwdk2GbhZwBtufc3FmW+Dggc4eV1n7p9kT1qKvN7Ix6pq6On+3jqtYTyZ
 qwCeLzlr
 gTksyyqyPJABE9MTvEBkDys3wu0l6Hdl2de6YERqVBTNSzMr2+3Ifp0+/7aHdSfr5XIhlVeCCRwotWkTkXIqS90/z7yOMt+1aiTx7VfJmRGqZirSjqwqkuvHfLXTQNq+/bBaWvw6goo6wqjJ2ukAlqiwtLmvAuUkxyQJtpE90LMleXXX08QqeOzTJdePpnTd4SRuCvTlKlQUFxrNe6DMzO3OCo4Gdj+BNZFwoK3nyRWoU+fWY/uV8xemGCqD0Nk5HKx+1jdIy52blhUKaBwmPXNg02osUsde56RW8wmBTWDvHqwwBVJx5FLqKczwGTtcIONPHFuUiL/43wcm7o7raJbCaEsMvt61JywkaDqEhABCIiAaV4CoO2bQLx9cS6rNMTmCf1AmRRTTf8/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the common CoCo shared-memory geometry helpers for allocations backed
directly by CMA or the page allocator. Round the backing allocation to a
whole shared granule and pass the resolved shared-allocation attribute
through the DMA contiguous allocator so it can enforce the mandatory
alignment. Transition the complete range through the common shared/private
helpers.

Recompute the layout before freeing ordinary direct allocations so the
transition back to private memory and dma_free_contiguous() cover exactly
the range acquired by the allocation path. If restoring private state
fails, retain the existing fail-safe behavior and leak the pages rather
than returning potentially shared memory to the allocator.

This also applies the same rules to dma_direct_alloc_pages(), covering
callers which require a struct page result rather than a CPU virtual
address.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Assisted-by: Codex:gpt-5
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/direct.c | 51 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index cb14419f8a09..09a8a842fc6f 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -11,10 +11,10 @@
 #include <linux/scatterlist.h>
 #include <linux/pfn.h>
 #include <linux/vmalloc.h>
-#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 
 #include "direct.h"
 
@@ -85,7 +85,7 @@ static int dma_set_decrypted(struct device *dev, void *vaddr, size_t size)
 {
 	int ret;
 
-	ret = set_memory_decrypted((unsigned long)vaddr, PFN_UP(size));
+	ret = cc_make_shared(vaddr, size);
 	if (ret)
 		pr_warn_ratelimited("leaking DMA memory that can't be decrypted\n");
 	return ret;
@@ -95,7 +95,7 @@ static int dma_set_encrypted(struct device *dev, void *vaddr, size_t size)
 {
 	int ret;
 
-	ret = set_memory_encrypted((unsigned long)vaddr, PFN_UP(size));
+	ret = cc_make_private(vaddr, size);
 	if (ret)
 		pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
 	return ret;
@@ -115,7 +115,7 @@ static struct page *dma_direct_alloc_swiotlb(struct device *dev, size_t size,
 }
 
 static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
-		gfp_t gfp, bool allow_highmem)
+		gfp_t gfp, bool allow_highmem, unsigned long attrs)
 {
 	int node = dev_to_node(dev);
 	struct page *page;
@@ -124,7 +124,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	WARN_ON_ONCE(!PAGE_ALIGNED(size));
 
 	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
-	page = dma_alloc_contiguous(dev, size, gfp, 0);
+	page = dma_alloc_contiguous(dev, size, gfp, attrs);
 	if (page) {
 		if (dma_coherent_ok(dev, page_to_phys(page), size) &&
 		    (allow_highmem || !PageHighMem(page)))
@@ -184,7 +184,7 @@ static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
 {
 	struct page *page;
 
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true, 0);
 	if (!page)
 		return NULL;
 
@@ -205,6 +205,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	bool remap = false, set_uncached = false;
 	bool mark_mem_decrypt = false;
 	bool allow_highmem = true;
+	struct cc_shared_layout layout;
 	struct page *page;
 	void *cpu_addr;
 
@@ -285,8 +286,15 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		return NULL;
 	}
 
+	if (mark_mem_decrypt) {
+		if (cc_shared_calc_layout(size, &layout))
+			return NULL;
+		size = layout.shared_size;
+	}
+
 	/* we always manually zero the memory once we are done */
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, allow_highmem);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO,
+					allow_highmem, attrs);
 	if (!page)
 		return NULL;
 
@@ -305,7 +313,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		void *lm_addr;
 
 		lm_addr = page_address(page);
-		if (set_memory_decrypted((unsigned long)lm_addr, PFN_UP(size)))
+		if (dma_set_decrypted(dev, lm_addr, size))
 			goto out_leak_pages;
 	}
 
@@ -364,6 +372,7 @@ void dma_direct_free(struct device *dev, size_t size,
 	phys_addr_t phys;
 	bool mark_mem_encrypted = false;
 	struct io_tlb_pool *swiotlb_pool;
+	struct cc_shared_layout layout;
 	unsigned int page_order = get_order(size);
 
 	/*
@@ -408,6 +417,12 @@ void dma_direct_free(struct device *dev, size_t size,
 		/* Swiotlb doesn't need a page attribute update on free */
 		mark_mem_encrypted = false;
 
+	if (mark_mem_encrypted) {
+		if (WARN_ON_ONCE(cc_shared_calc_layout(size, &layout)))
+			return;
+		size = layout.shared_size;
+	}
+
 	if (is_vmalloc_addr(cpu_addr)) {
 		vunmap(cpu_addr);
 	} else {
@@ -419,10 +434,8 @@ void dma_direct_free(struct device *dev, size_t size,
 		void *lm_addr;
 
 		lm_addr = phys_to_virt(phys);
-		if (set_memory_encrypted((unsigned long)lm_addr, PFN_UP(size))) {
-			pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
+		if (dma_set_encrypted(dev, lm_addr, size))
 			return;
-		}
 	}
 
 	if (swiotlb_pool)
@@ -435,6 +448,7 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
 {
 	unsigned long attrs = 0;
+	struct cc_shared_layout layout;
 	struct page *page;
 	void *cpu_addr;
 	bool mark_mem_decrypt;
@@ -458,7 +472,13 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		goto setup_page;
 	}
 
-	page = __dma_direct_alloc_pages(dev, size, gfp, false);
+	if (mark_mem_decrypt) {
+		if (cc_shared_calc_layout(size, &layout))
+			return NULL;
+		size = layout.shared_size;
+	}
+
+	page = __dma_direct_alloc_pages(dev, size, gfp, false, attrs);
 	if (!page)
 		return NULL;
 
@@ -484,6 +504,7 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	phys_addr_t phys;
 	void *vaddr = page_address(page);
 	struct io_tlb_pool *swiotlb_pool;
+	struct cc_shared_layout layout;
 	/*
 	 * if the device had requested for an unencrypted buffer,
 	 * convert it to encrypted on free
@@ -500,6 +521,12 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	if (swiotlb_pool)
 		mark_mem_encrypted = false;
 
+	if (mark_mem_encrypted) {
+		if (WARN_ON_ONCE(cc_shared_calc_layout(size, &layout)))
+			return;
+		size = layout.shared_size;
+	}
+
 	if (mark_mem_encrypted && dma_set_encrypted(dev, vaddr, size))
 		return;
 
-- 
2.43.0


