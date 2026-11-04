Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2BA606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MEcDEw27
Received: by kanga.kvack.org (Postfix)
	id 526096B05C5; Wed,  4 Nov 2026 11:49:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0606B05C6; Wed,  4 Nov 2026 11:49:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371C86B05C7; Wed,  4 Nov 2026 11:49:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0920D6B05C5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:49:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 778CB1A078A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:49:08 +0000 (UTC)
X-FDA: 85398021576.06.913E870
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id DD60440007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:49:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEcDEw27;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTuN8WVsJv1I02LCGu8efiiNsZogL+1Yfc4bQSdZvsk=;
	b=js+kodgoGtc3ubId2d22aRYqyAW1c4D4PUSS8fGeMEoYcwAmCjl8jRva59M3IAga8gtBL9
	ssXTHsUtqYP1uHJ+nQaWpoPoVpVKLUt5YSB+IgJMPaOomlRkGC5vFiFCLP5hVQpxTuvfn/
	ACCo2RuqAB+2pvIzMMY1nvCT09OyCTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810946;
	b=bBuj/KB9kdNWwBHc/4V03vIXnQ9HOpROkpHP3lQdWpB46z11ck+NVrgSLw/nHgn4IjHxU+
	9WMdkCUjaxXkfbHrv5/MA93lnY4sKr5GSrfaCBHI6H3T5Gi7FZwR7xJgTGkhoPADF+Ntaa
	fO/5Ba+wZnwFNW/ggxnIF9QRMkQbGAI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEcDEw27;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8931660A9D;
	Wed,  4 Nov 2026 16:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729B31F00A16;
	Wed,  4 Nov 2026 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810946;
	bh=MTuN8WVsJv1I02LCGu8efiiNsZogL+1Yfc4bQSdZvsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEcDEw27BmTAfTMR6Cs9edMuq5bUFf456+f7urheAWgzZwKe3xiSRJwKzGdjEHrql
	 cWQChlV+swCc/ygmAzMyiRWeOKZ3Zod/MJSCs4YKVkNStHFTLRFr7XRBJ8i5AnMbKY
	 xqA4KFGzKcLF5V5hzQC9xy1/MBVZqxg2YMICnQgWgPIDOfHqlNpTjBWubGbW90j7D3
	 D0drESx7uAuvVDS0zy/rHr7ySr1/jyVgjdV22PcJM/OCZCQmovnK5aPzD+Cdti/yIQ
	 lKiKVpIBLzXK2llg4QBU5uz2PV8xkxY2ReMwYaMDuEVANuLVPYjGgcEv+YGQXff5mX
	 FO6mCsNo9+sYg==
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
Subject: [PATCH v9 08/14] swiotlb: Align shared IO TLB pools to the shared granule size
Date: Wed,  4 Nov 2026 22:15:49 +0530
Message-ID: <20261104164555.3555725-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8skpugrrp5oahbnjipt8zm8jpc8fet7w
X-Rspamd-Queue-Id: DD60440007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793810946-684594
X-HE-Meta: U2FsdGVkX18y2GGB7+UGuE9cfQO/hD5MW2Qa+M5S0BvtQlYm4b+z/NeQdG4gRxr3hh+JxkRrbYE/pzX44OD4/6WAqx6bW/x+9mro4lRbPfkvIEKz6/FWRxAzChcESrwd51WSmdcG0aX+bP+rEwl+ZoLud637XSfSELwWKR1U2ChDiIHp9ZyUZFM/cK8FXYkgX7i19QDjYX9EUEYkblIz6WuWdigqCLUwNiIm4Wm9jnha37eEfIcVYJB8pdkHHEqQKjdDP4ZTV8pLgT1xo+52zy2x+1ruQfoUenwFZZGyto+t8RjWV1w4Q1iersn3MCNfAvxB2wvvykAjgtDWqdzT6oxNZwXYgR1CFwtPkmxio/hiVV3i/gHWn0nMj1D7a4+I0V3ZhgEtLxrOCiimBNprDIaYT8tEcbtwA9yW/olAETvyZZZBcRd9PJw450maxSECGal65otZ+WBZ25oQ7beIjLFGXmQgQSz5UH5RGV80TNY+Y7CNxyj0cqYghpOQPhIDodeRGFNE1quUyanR9d28XZKleZgyKOv0f05kiccrIsEO3wZk+87HGYv/lU/EuQCnW9OWgc5s8wnCZr1xzJ9Lp2me37GuIsoNGX7FQQDOB5ofObqereDolq/ODJDCGMgYOJiV2udVEpY1Lu6PB/CHeL/xxXk2cFDImneRAZUxC4BpjJNBLEa/q4Nv+nHEcocUWGCIDYViCOw1zH/GEPj7Xn+B1AKGaPuZ3nmYIPCLQuAhugwCrTgO1DEIM9Yqqk325XzFSX1CkqM1ICqURaL/ICjHquKiluWxbMySErj9w0vE8YpoZ78/VteQsYNmWgL8eTgzk509CqjaNMcYVYMxWSIUfNxS/wEWrWJ07CcjKhL4gyWVuE8OxNQGjA3oVrjEt5atHGHx+Mskz1+o4vyEY7wbI++bEiI8MbhN86srO8tD12BJe79s8dW4DeeFnqjHPRA1nJ7m4oV/JgevMFH
 Csu3V3ap
 07lkRwM1D9vYXTCXqdOSsy4V4koG11HB5rIZi84WJ/nQ+eYdStDmexG//H9CaGMlpoMkeD1R7SQgiyLAK7xmRNNICKhtTgEIQ7QN9J4Pw9fRcC7P3dhUjc14QFcXAg1z8wxw2zyI8/CLvMi30OUFAivpR5kb95wrtLPEJo/vtgDp2cxYhV1pg3vAn3joLf5SsmJesu0n3qWeB5v8pde4CzZtP6tFxV4vpzvd4n92XNMAZVIINWpKURhEP4N+6pcTadVTjvXlraY12aUBvl4RXavnd8lFxOc478OCYApGJ4UZZ5sedo8SCsJE54ndnykLvNMFr0RZ2blCngD8rd2ndDtCRulegTKLvsd0QykiGen7SPH6v6x7QkoLL+/n7ZKHo6jXXHREMPVedid8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Align and size the early memblock pool to the common CoCo shared
granule. Use the same rounded extent when the pool is transitioned and
when it is released. This deliberately leaves the slot count unchanged:
any rounded tail belongs to the pool allocation but is not advertised as
allocatable SWIOTLB space.

Replace the default and dynamic pool set_memory calls with the helpers
so alignment validation and architecture dispatch are kept in one place.
As before, pages are intentionally leaked if their private state cannot
be restored safely.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 47 +++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 2c57b49ac7c0..36fbec2241e4 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -22,6 +22,7 @@
 
 #include <linux/cache.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/dma-direct.h>
@@ -38,7 +39,6 @@
 #include <linux/pfn.h>
 #include <linux/rculist.h>
 #include <linux/scatterlist.h>
-#include <linux/set_memory.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/swiotlb.h>
@@ -367,13 +367,13 @@ void __init swiotlb_update_mem_attributes(void)
 
 	if (!mem->nslabs || mem->late_alloc)
 		return;
-	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
+
+	bytes = ALIGN(mem->nslabs << IO_TLB_SHIFT, cc_shared_granule_size());
 
 	if (io_tlb_default_mem.cc_shared) {
 		int ret;
 
-		ret = set_memory_decrypted((unsigned long)mem->vaddr,
-					   bytes >> PAGE_SHIFT);
+		ret = cc_make_shared(mem->vaddr, bytes);
 		if (ret) {
 			pr_warn("Failed to decrypt default memory pool, disabling it\n");
 			swiotlb_mark_pool_used(mem);
@@ -434,8 +434,8 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
-	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
 	void *tlb;
+	size_t bytes = ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size());
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -443,9 +443,9 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	 * memory encryption.
 	 */
 	if (flags & SWIOTLB_ANY)
-		tlb = memblock_alloc(bytes, PAGE_SIZE);
+		tlb = memblock_alloc(bytes, cc_shared_granule_size());
 	else
-		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
+		tlb = memblock_alloc_low(bytes, cc_shared_granule_size());
 
 	if (!tlb) {
 		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
@@ -454,7 +454,7 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	}
 
 	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
+		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
@@ -576,7 +576,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 retry:
-	order = get_order(nslabs << IO_TLB_SHIFT);
+	order = get_order(ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size()));
 	nslabs = SLABS_PER_PAGE << order;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
@@ -585,6 +585,8 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		if (vstart)
 			break;
 		order--;
+		if (order < get_order(cc_shared_granule_size()))
+			break;
 		nslabs = SLABS_PER_PAGE << order;
 		retried = true;
 	}
@@ -598,8 +600,13 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		free_pages((unsigned long)vstart, order);
 
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
-		if (nslabs < IO_TLB_MIN_SLABS)
+		if (nslabs <= IO_TLB_MIN_SLABS)
 			return rc;
+
+		/* Avoid infinite loop */
+		if (WARN_ON(nslabs < (cc_shared_granule_size() >> IO_TLB_SHIFT)))
+			return rc;
+
 		retried = true;
 		goto retry;
 	}
@@ -624,8 +631,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		goto error_slots;
 
 	if (io_tlb_default_mem.cc_shared) {
-		rc = set_memory_decrypted((unsigned long)vstart,
-					  (nslabs << IO_TLB_SHIFT) >> PAGE_SHIFT);
+		rc = cc_make_shared(vstart, nslabs << IO_TLB_SHIFT);
 		if (rc) {
 			leak_pages = true;
 			goto error_decrypt;
@@ -665,11 +671,11 @@ void __init swiotlb_exit(void)
 
 	pr_info("tearing down default memory pool\n");
 	tbl_vaddr = (unsigned long)phys_to_virt(mem->start);
-	tbl_size = PAGE_ALIGN(mem->end - mem->start);
+	tbl_size = ALIGN(mem->end - mem->start, cc_shared_granule_size());
 	slots_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), mem->nslabs));
 
 	if (io_tlb_default_mem.cc_shared) {
-		if (set_memory_encrypted(tbl_vaddr, tbl_size >> PAGE_SHIFT))
+		if (cc_make_private((void *)tbl_vaddr, tbl_size))
 			leak_pages = true;
 	}
 
@@ -709,12 +715,15 @@ void __init swiotlb_exit(void)
 static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
 		u64 phys_limit, unsigned long attrs)
 {
-	unsigned int order = get_order(bytes);
 	bool cc_shared = attrs & __DMA_ATTR_ALLOC_CC_SHARED;
+	unsigned int order;
 	struct page *page;
 	phys_addr_t paddr;
 	void *vaddr;
 
+	if (cc_shared)
+		bytes = ALIGN(bytes, cc_shared_granule_size());
+	order = get_order(bytes);
 	page = alloc_pages(gfp, order);
 	if (!page)
 		return NULL;
@@ -726,13 +735,13 @@ static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
 	}
 
 	vaddr = phys_to_virt(paddr);
-	if (cc_shared && set_memory_decrypted((unsigned long)vaddr, PFN_UP(bytes)))
+	if (cc_shared && cc_make_shared(vaddr, bytes))
 		goto error;
 	return page;
 
 error:
 	/* Intentional leak if pages cannot be encrypted again. */
-	if (cc_shared && !set_memory_encrypted((unsigned long)vaddr, PFN_UP(bytes)))
+	if (cc_shared && !cc_make_private(vaddr, bytes))
 		__free_pages(page, order);
 	return NULL;
 }
@@ -805,9 +814,11 @@ static void swiotlb_free_tlb(void *vaddr, size_t bytes, bool cc_shared)
 	    dma_free_from_pool(NULL, vaddr, bytes))
 		return;
 
+	if (cc_shared)
+		bytes = ALIGN(bytes, cc_shared_granule_size());
 	/* Intentional leak if pages cannot be encrypted again. */
 	if (!cc_shared ||
-	    !set_memory_encrypted((unsigned long)vaddr, PFN_UP(bytes)))
+	    !cc_make_private(vaddr, bytes))
 		__free_pages(virt_to_page(vaddr), get_order(bytes));
 }
 
-- 
2.43.0


