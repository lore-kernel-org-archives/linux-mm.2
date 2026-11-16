Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01D7606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAyA5Np3
Received: by kanga.kvack.org (Postfix)
	id 20DC76B05B2; Mon, 16 Nov 2026 04:14:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E54E6B05C1; Mon, 16 Nov 2026 04:14:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD616B05C2; Mon, 16 Nov 2026 04:14:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9A006B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:14:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D6711C425C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:14:07 +0000 (UTC)
X-FDA: 85440420534.03.E5D8237
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E27F918000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:14:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAyA5Np3;
	spf=pass (imf16.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820446;
	b=SrpAs1NEZ/IJb/QBQxSX19xBavi/2pdakMqNPiWGooxi4+UxDRrlL6OIaoQn4tfnwvyzwD
	wCgi2SiwpsrqAiztlU9JXQuilLNqnR21tPGalTDCVLRnHnqQDYNAsfMPyHTzbifOapfFDJ
	qQadDltX2gM7S5W3vxJH3U3WAV8C7V0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAyA5Np3;
	spf=pass (imf16.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUSaeFo1mvVEk8no6IM15BHOisJ9Uj3pDx22Qt7gIqY=;
	b=iIiw3klquZR8HRKDMAFJf+Pk3EDANbZGbn8f3ehNLYaMYVPmFNrZZbjm1JJj4MUmP1bgYp
	qQOasPGXHZa9gMNx2qlDquEX38Vx5NMBRSYZMKRlIPj3RGhbzf0hQUiaAGaAa1jIKVZduR
	0QQnopz1RFGQAyVxrYvS6EDCsYRT2Fo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E21F60E05;
	Mon, 16 Nov 2026 09:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04FF1F000C6;
	Mon, 16 Nov 2026 09:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820445;
	bh=IUSaeFo1mvVEk8no6IM15BHOisJ9Uj3pDx22Qt7gIqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAyA5Np33FkP0mjzUGzlUh0fwv4di/GKXY0SAQ1eiwCbLsNfMOZIPOBU1c0zJBAFU
	 ihMW0gJxadvrVXMXdfZoFdChbnWuYD7ubv5Pj3IVjEcnjyxFPDMuN1xMwk61Eh9G3X
	 ndnFUhd4VYqobbctfPiOjt36AWCdVcl7VpawMMRKAMj3t1QNpdc9Z3XVKJtcvIKJeM
	 XA7CZ9oeB/WqmpWjP4tJiG3k+krvP+w5CKoyBCl/iQMtr7sF3v7W8ev89XpDtxqqez
	 wD4LzYK86GeyE3VyTw+jCDRwymBedhzoueLsUHjiAvYni5OnWmeBDC+Hb1Bz3icW1K
	 VS5UdvMt6bYaw==
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
Subject: [PATCH v10 07/13] dma-direct: Align CoCo shared DMA allocations to the shared granule size
Date: Mon, 16 Nov 2026 14:41:30 +0530
Message-ID: <20261116091137.94252-8-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E27F918000B
X-Stat-Signature: 1rqcf8fwgmn4k8dsdmfs4xpbqy8s4jae
X-Rspam-User: 
X-HE-Tag: 1794820445-853948
X-HE-Meta: U2FsdGVkX1+JH5IKSDip9vTaKAkETNMrNJO7Iroz30ec/s+IvHRyQx0JVOC8oRYDEKBU7GaxDmC2JO8sGIURPgIwSIaIeNDEXuaoZBSVEYgX753RND+I28PaH8vR6C7qxcYzeocKtUh7+8tb9pQg/RV92NAFtmLoEKYOcuFj+UwTp9Rh0JSikRR4pZtLQS1vItykjIGGivjoiRjS0WvgpKDiw4N2/6fmrmZtR/wKNNCFVhcg4zK8zFb4Dkwu0ZqhRTxPot/qpzoBpjV5z6paD2SmQkjeaS17+XtL6iuuoMOspvsyn4JAX2TcNZ7orXdAYH6SWa37vjcmafabQmeWhWT37tAuozmVP5aAWrNLFOUSOgYZe5sj8JJ1xnPTC8klWpIeEHipqGcWV49G+4XkCPDON3Ylt38iwxr2n9Bpm9o11wY769ZB4fMpkqN5Dfio+eF/oG32C0NRYtoA5iCXguu9xrnP8c+rjGFRM3Ax+IHMGbZeutpqY93M+UzMEwCYDjM/YgFanvMEg/H782f1lhWLsk3KoIobpBTHOUyQgcFi/RoA8NArzdqz2/XztOLMGrJYf5hlncdeh5r0omfWJomkbGBrAdFHtSM4LAKCw4AOY8iMdODyDjBg0NCZR/6DOlxX4t7anYtgPoyK3ryunCzfiFP1GVAaKiKGNzYpxJ8KlG44AxXso1X1exIwoJDP4caKujsEfIgTWicC1vyUQaWMMDfw5J7ekU32nq5txXQlX28tW8ioY/DvX4r5wXLF8Zzyc9JFZ2Yh3BW1ZGCRe244U8PoYoRJyt7UYrAPc3omEwT5oNNFUXt5cw94v6tDEe/UpBGgCnVgWYPDmCjoRITChwt+asUGPUeFEoSWsREr5u+tGt4xfWkATgnw5cikiUQg2teJ0uuYVhzuk3rxBuXCCCU1ZHKMAWl7+TGyTZDI3F5gamEdoKzTKrZor33GDF9umbZPa2K2kXtwvzf
 dS4NHI1g
 ldizA/GpPsp70As5clJeD6hZV3gR3TRILEvu/U5vq/hlpGdSNT4n61/9LS37not0oNHEYU4EBXk1SD2fNFDxfTFzWuJ67pf/pNRVOobJbREm3iMF6CQWeYqmkpqZx/EFi6OdNcosp1ulLYffcyk+UughmX/1Yybtf7HlNyaGdaT8MpcxHeRCJWUGApKRnNYRhjzAFKqKAoRCNLzp6DDpgMyWb6mHgvapdGqqx4Z0NnW+VhtArs9ftguNOQXiOujjNrc24AJgbHvgaKanWSjf5TJjDNveoTjQDXGN2SzmENh6xJrb3QfrF/bYuNfEs908cmM2KA6kQCdvRT/N5/uZy4r88D2cF30DAe5dRwjpAU+7YefQYRfutJBVy+SiBvfxojPFembPSyeJEzVnrOhGtw4VWsE0hji+8qyc0vgNdlu/hb+NMkukVgYGDATFMEg/7evvqi6Q8js7ep1kAQdJPEVKS2JatpvG9n911owQgnreSnk1tiGUXCwwUpZGvDY/h2yiZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/direct.c | 51 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 7e71f96b6ffd..675ed698a3ad 100644
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
@@ -125,7 +125,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	WARN_ON_ONCE(!PAGE_ALIGNED(size));
 
 	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
-	page = dma_alloc_contiguous(dev, size, gfp, 0);
+	page = dma_alloc_contiguous(dev, size, gfp, attrs);
 	if (page) {
 		if (dma_coherent_ok(dev, page_to_phys(page), size) &&
 		    (allow_highmem || !PageHighMem(page)))
@@ -202,7 +202,7 @@ static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
 {
 	struct page *page;
 
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true, 0);
 	if (!page)
 		return NULL;
 
@@ -223,6 +223,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	bool remap = false, set_uncached = false;
 	bool mark_mem_decrypt = false;
 	bool allow_highmem = true;
+	struct cc_shared_layout layout;
 	struct page *page;
 	void *cpu_addr;
 
@@ -302,8 +303,15 @@ void *dma_direct_alloc(struct device *dev, size_t size,
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
 
@@ -322,7 +330,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		void *lm_addr;
 
 		lm_addr = page_address(page);
-		if (set_memory_decrypted((unsigned long)lm_addr, PFN_UP(size)))
+		if (dma_set_decrypted(dev, lm_addr, size))
 			goto out_leak_pages;
 	}
 
@@ -381,6 +389,7 @@ void dma_direct_free(struct device *dev, size_t size,
 	phys_addr_t phys;
 	bool mark_mem_encrypted = false;
 	struct io_tlb_pool *swiotlb_pool;
+	struct cc_shared_layout layout;
 	unsigned int page_order = get_order(size);
 
 	/*
@@ -424,6 +433,12 @@ void dma_direct_free(struct device *dev, size_t size,
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
@@ -435,10 +450,8 @@ void dma_direct_free(struct device *dev, size_t size,
 		void *lm_addr;
 
 		lm_addr = phys_to_virt(phys);
-		if (set_memory_encrypted((unsigned long)lm_addr, PFN_UP(size))) {
-			pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
+		if (dma_set_encrypted(dev, lm_addr, size))
 			return;
-		}
 	}
 
 	if (swiotlb_pool)
@@ -451,6 +464,7 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
 {
 	unsigned long attrs = 0;
+	struct cc_shared_layout layout;
 	struct page *page;
 	void *cpu_addr;
 	bool mark_mem_decrypt;
@@ -474,7 +488,13 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
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
 
@@ -500,6 +520,7 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	phys_addr_t phys;
 	void *vaddr = page_address(page);
 	struct io_tlb_pool *swiotlb_pool;
+	struct cc_shared_layout layout;
 	/*
 	 * if the device had requested for an unencrypted buffer,
 	 * convert it to encrypted on free
@@ -516,6 +537,12 @@ void dma_direct_free_pages(struct device *dev, size_t size,
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


