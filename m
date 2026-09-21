Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543C5C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63CD66B00A9; Mon, 21 Sep 2026 10:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6142A6B00C2; Mon, 21 Sep 2026 10:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52AD76B00E5; Mon, 21 Sep 2026 10:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7906B00A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:50:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 925D61401BC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:26 +0000 (UTC)
X-FDA: 85238055252.27.AB5EA47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 054AF1A0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HhhVBHd7;
	spf=pass (imf19.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XD9KbmPFTDvG/++FINRoeRjfo1Owk1SK7Ef5Ny4pkE=;
	b=Gntp+fE0dcDJgxdedOkdqQv1adxu0MjUFf5zTPqelsqbG+R08ksIl5fxxDjNfp/kLG5Mvm
	H7fOt8MJECv3pxC8SL5HYgL4a2qamRjorXc4Zj5FPE+0YlBztTmo00wlRc1D4xjka8u2E8
	uQISl5eUpGXfexbnwCmMWPdYWWqthPs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HhhVBHd7;
	spf=pass (imf19.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002225;
	b=vdGojv04AVXqRtHYk9HbwVu1zV1+JfgXfBc2rHTDcAkX+FHiSyatef8rsAkRl2a5Aj3pLl
	DKgAh7GMHlpLd7hDh/YEUX5S1nVLScHpMhjSXgKI6KkbjzIcltvFRVq0+xkhSs4Z35NHn6
	dOhMUzYgvqw0OTIfV3/MUb2L2rlFHpE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9619B600C8;
	Mon, 21 Sep 2026 14:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAD21F00893;
	Mon, 21 Sep 2026 14:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002224;
	bh=2XD9KbmPFTDvG/++FINRoeRjfo1Owk1SK7Ef5Ny4pkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhhVBHd70NwE6tFDSR7EWwSk5kUn7dx1kha7j/ncW7XELIYaoWokPSNoeR4Gb7csH
	 manH/KE1JbmJ0i/7twyR8DQ5XrSNGVGXxOuKAD+RPrR+xXRboXZTQPlJ3QmEqu859i
	 HZU0YFWzKtkC9U5gYk+hQL+Nk1Q/jBfPYKwtVIz5itpVENE+9110tsSKuHgFvohU87
	 NP77rfhWL7u4mvtugGaq0ws9V+9f5uQ3MDPuE4Cb8F3CfiH0z1Pbw4bXnIUOU/GE2O
	 JQkgUxAsfSs1Z5A0oGnQxHSA6wqJm37P5biOyVae7LUBXaPY5G/IlRwsFO2EbC8dFE
	 osNmzMILFDf9Q==
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
Subject: [RFC PATCH v7 09/13] swiotlb: Align shared IO TLB pools to the shared granule size
Date: Mon, 21 Sep 2026 20:18:43 +0530
Message-ID: <20260921144847.501151-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zzewcq4t75jiubtic6a56ozsb91ftute
X-Rspamd-Queue-Id: 054AF1A0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1790002224-532586
X-HE-Meta: U2FsdGVkX1/5FN+DpxkvW0VaQIPsoM0cARLkT+q/menu/iX0p1UfqiCi10CyQqVYsnnpWdFHCQ1I9ucZFuQQxB9NjMiBgTMyPf0yGrasO2E9RoZWyitQvmK1rfDTOl3MubtQVFHknLQ5RIZwiuDyHf0AvubIl2gFoO9akmiBXukkYj9v4VbM/shwSEgVlotVsN82d8iBQY2butDQp5EA0fsGqlBk8aJHqJiv7kCARGzpknrEailPUZFoKvD3/0b+aw3tCJ0aEhdS3R1SsoAbMrb7HqEbfIIhiTITN2qDyVUWR5L0EWHdlqzDmRDhT1OV6rCJjCY959t07tAkoNwVYS/H6sw0du+DIdUr3cwv0Qpha5Uvd/tVsijf49obDEUVTH/lUOT3Dm1/3Mne5svIZ6Ta/6LSwfNxpX6tF37x8Y6VIklY4e5KYI9YqexR4QVMc7o7huYeoKy/RONeujDTMT+SPyaioR5oMFuIt6Uz9luXxA7iknMVJh9n3/Oge9vkg5oI02o7GRt+9k2mnG9jvgny5ar0gLHB2Xj56UVOgyOMcOMKgRIWurFN2KL+eg8S78Tzgu3XIewOY+yq8Xr6iSkfeWHloZbpHmN6TJrSWvX09iKBdv4mhdDABolJU/42zz35+te+chK09DtvBxDd147KWciPblCvbvySRpWa8B38TQubn0FPzSpvRbYRxy81FVxOd864+5myOw8t+K/UHnS8Uj3mjAdJCJCnkS3Cmdf3Cor7UX5T3z1vtBLdMfCASiwxhF3OPJyD5dQTXBZ6EuEaqCMDg9m/HN3+xtmvKPwhAXpFOtywv9WP4b1OJa83xasLXYCXGh2S26kpzqhdAMagwA0SINUQg8P0afG8DCB+iwJxQA/EwQOZP4V7GhTCIFWzEALgSi2MH04E+yo0egLLcTJvU9g2lCesHnEWpHMLc8VVvtt9nijEq2vtNZhKxQ+t/1QpHyDCP45LH3o
 EJKPMiFR
 xFaqbczXYJn+LzKSyTdEtV6fUB2htb7LysIzm9VsgIjiXigoTtRIxZdTRaO6N69bYQrI8X3OGHTvMjSRMCwghM/OrYKJFYtrfCDiCuCJcHQ1nB28F7szwcq+BtS5OAW30bIpIla/wOrkLeoIJGXLS8jskqG3Zq6G2O6rDSPxJv9Jr4vC91YBT6kU6879a2iG/tXvnO004fLpyNdmY/HJCji8znhyLoGLhEkblaqPgd3Ir3gU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Align and size the early memblock pool to the common CoCo shared
granule. Use the same rounded extent when the pool is transitioned and
when it is released. Re-zero the extent after a successful
private-to-shared transition because the architecture operation may
change memory contents. This deliberately leaves the slot count
unchanged: any rounded tail belongs to the pool allocation but is not
advertised as allocatable SWIOTLB space.

Replace the default and dynamic pool set_memory calls with the helpers
so alignment validation and architecture dispatch are kept in one place.
As before, pages are intentionally leaked if their private state cannot
be restored safely.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index ded7016a46a7..9928d75efc2d 100644
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
@@ -369,16 +369,18 @@ void __init swiotlb_update_mem_attributes(void)
 
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
+		} else {
+			memset(mem->vaddr, 0, bytes);
 		}
 	}
 }
@@ -436,8 +438,8 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
-	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
 	void *tlb;
+	size_t bytes = ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size());
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -445,9 +447,9 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
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
@@ -456,7 +458,7 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	}
 
 	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
+		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
@@ -578,7 +580,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 retry:
-	order = get_order(nslabs << IO_TLB_SHIFT);
+	order = get_order(ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size()));
 	nslabs = SLABS_PER_PAGE << order;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
@@ -587,6 +589,8 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		if (vstart)
 			break;
 		order--;
+		if (order < get_order(cc_shared_granule_size()))
+			break;
 		nslabs = SLABS_PER_PAGE << order;
 		retried = true;
 	}
@@ -626,8 +630,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		goto error_slots;
 
 	if (io_tlb_default_mem.cc_shared) {
-		rc = set_memory_decrypted((unsigned long)vstart,
-					  (nslabs << IO_TLB_SHIFT) >> PAGE_SHIFT);
+		rc = cc_make_shared(vstart, nslabs << IO_TLB_SHIFT);
 		if (rc) {
 			leak_pages = true;
 			goto error_decrypt;
@@ -667,11 +670,11 @@ void __init swiotlb_exit(void)
 
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
 
@@ -711,12 +714,15 @@ void __init swiotlb_exit(void)
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
@@ -728,13 +734,13 @@ static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
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
@@ -807,9 +813,11 @@ static void swiotlb_free_tlb(void *vaddr, size_t bytes, bool cc_shared)
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


