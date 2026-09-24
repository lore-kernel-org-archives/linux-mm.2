Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89DF3C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56646B00A7; Thu, 24 Sep 2026 06:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D956B00A9; Thu, 24 Sep 2026 06:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944A16B00AA; Thu, 24 Sep 2026 06:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73BE06B00A7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:08:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13442A0262
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:08:08 +0000 (UTC)
X-FDA: 85248230256.01.D4ADF5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D51D9C0008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:08:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jOTRGxxD;
	spf=pass (imf28.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGXN0p+tMDUsztkVAtcaWVHfdiW84XCTWOSW1jg9k7A=;
	b=Vv0wE+Vg5Fy7frIgmP8Y4HKincZupak7Xi7Wm2PnSMysChv2ef9/g+LC6SKw4TANXpL9FK
	zNe4UATKGT85RVfD/Q/0QxKMEp5sv+4fZEl5UnCQKc25KCDM4eDIXKRxavgTiY70i77Ebs
	quYIDHDQbNrIApgr8mql9948lvtEnHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244485;
	b=Nb9mjNr/S+qlQUMHORlkz3wI0tNpvWACI8Pd6f7ykrp+LvG5KauA7DX7XHvEN4y+6VmYnm
	/IDbfIt8zwbpVf+fvkQAeQTm3JdcQJyOtOCNqceQ+PYSszN2lMga3/1Djc1MyhMnMu0U/4
	jckxsRxa5YXy3hjr/61HCKA3YYmYesw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jOTRGxxD;
	spf=pass (imf28.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69A186022F;
	Thu, 24 Sep 2026 10:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C051F000FF;
	Thu, 24 Sep 2026 10:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244485;
	bh=BGXN0p+tMDUsztkVAtcaWVHfdiW84XCTWOSW1jg9k7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOTRGxxDsAY98FX6mcu4pcKINkDtOF2FH4sRUbg6eYP/v2p6BML6vq3Z0bgTXXi5e
	 oFJbrkUd1n9E6zqSQY5I4XSUWKrWJHeuetk4eiU9j1199VSorr+fLu76TU8bQyQsav
	 rkF7W6bHvONtqYJWJX7RczBTKuXWd28xr8zw//G6Rouh/7u9LOQSqYQ+FFlsDcMc0U
	 h3yQj4EHndV6oq6ey6hp5PXC6ozRqUSq7xqGus4NtabWlmfCvEOG2ULnPGGylMB+GA
	 7pNIaQFtyClmABKsj/ZUywPt/uW3D/DBGipMhTu6HWw4fQcQgXS/RSNIvBilY1mhKt
	 ctP8w0bePzduw==
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
Subject: [RFC PATCH v8 08/14] swiotlb: Align shared IO TLB pools to the shared granule size
Date: Thu, 24 Sep 2026 15:35:23 +0530
Message-ID: <20260924100529.1398790-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6cqi9inzhw54kgx9oxbbne4oytw93t8n
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D51D9C0008
X-HE-Tag: 1790244485-233053
X-HE-Meta: U2FsdGVkX180+qtEnDV5AYsQH3yo/g1MbrAqCOfNpn3SF2g9JCIleuX8TjvYI1MfItnU0zbzScY/+LCc+nSeuRTGwciqKZV8pSat7I1ieVljmzbhToJv/iDAwCjgZT5uypM9BDkcVarpLawlSHMRdlyb5YitU0ijQ/8Skfie2q0hftlruhFD97S1t0NcVF2DUgEf191mzEESPcd2E8gqhI3UnymgWKKMpe7QSU8Xt4YbOQ9ScFY0dIzAas7SRWPvgj5InZWHj58HE3ohSeMvjakUtxIbv8hT9zaUANz7scYzVaCgS3lnkZciljd+cr1fPb36WcSQTjy6bBDIg6jlEuitiks8Jz3L3Y3Jm+Hqpqql7GUkc0Vdi2hfMDl/KK2bSAyHpeNQH/RbKQG43QDj/AWZYik/nnK8bMucZIAQ4sh6cGRXM0qReazDkfOCHjvcE4WB3KR7Gv4IT8PW1MyXRMQ/BAR4nsIkR3AMjd2dOp4s546pQ0W2HupvP1C66J5rLSfH4roDuBnue6uL/fzYWRb9KLIpzt2qmQPJ9SUVmi4Nr/GfQ38pT4J/PFpAborxFqWTQAchK1dii4HuVrDn0+DQLLmpAjnrXRCqHCZJoY1l91yTQsv+6Lhgqu1WhkXD+DYT61DP5/mKnQVExK0/q/6i8hhicQkIwTRBP1iLmvrcTYqq4xZQPrrEeE729VhPZqlCZBY1bKMCtf9VG4Cpbl/BWGKJ/THFxqUA8Glzj7dM5oPRLniROjSaUge4pl3LNPNOo4vDOPStj9SHW9Q3r7NaTIGMHbwIsZKbtLfqvssAwXMKq3dMX5q3fD1kuaAocfdkRnDUaW8Z6ACIMkYThNVDtBL71OPVtL3PZQABQ6/MqstbtZV5uprNuIGCIeeGjSTQJmsZee5csosMhQtbAyJKIrKRLCF6AAspg9QhoqQJrOfynhD7LfpJN0CmVqlzEQrvvkUCjVIeHmPNJ/c
 cPq5R6NC
 t9Mhn9vjn+LepkCcvV2tOkbw2tYzBTgSy2EtgNLhsXwDHDTTxuxR1EK2Avf7XGmuVQvDzLMgCN0Hldn4hL0jXYgHcGlbx5fsX4FHD3njyAgm3z2Lj7gObx2EhY6q948QWlGQ7j9t+6XSH8zrfpjPnC2D3C2Ab05pFVUQwC8L2GiIHS3xZ7zygZK/8SV/dhxQMWZbbOFi4xcsB8QIhI/vYfSrjoXZy2dxKB6gYvVrMAS496G6i/y/+s61+JvIi5IBPVkJDoIh6fKSDyoIKXKFW7VfbOYvQhsh1L5/SO8C6jB+l8k/i3uCMwr4n6WTltUlJgZeLFzzw4aCdmjJQZcnejoKvvIG8ELSdxUsqrbnNP49AeSH+m88LrJlKaBGyv+V1rO4NR+KapU4sUuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 kernel/dma/swiotlb.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index ded7016a46a7..394db93b7eb9 100644
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
@@ -369,13 +369,13 @@ void __init swiotlb_update_mem_attributes(void)
 
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
@@ -436,8 +436,8 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
-	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
 	void *tlb;
+	size_t bytes = ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size());
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -445,9 +445,9 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
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
@@ -456,7 +456,7 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	}
 
 	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
+		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
@@ -578,7 +578,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 retry:
-	order = get_order(nslabs << IO_TLB_SHIFT);
+	order = get_order(ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size()));
 	nslabs = SLABS_PER_PAGE << order;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
@@ -587,6 +587,8 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		if (vstart)
 			break;
 		order--;
+		if (order < get_order(cc_shared_granule_size()))
+			break;
 		nslabs = SLABS_PER_PAGE << order;
 		retried = true;
 	}
@@ -626,8 +628,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		goto error_slots;
 
 	if (io_tlb_default_mem.cc_shared) {
-		rc = set_memory_decrypted((unsigned long)vstart,
-					  (nslabs << IO_TLB_SHIFT) >> PAGE_SHIFT);
+		rc = cc_make_shared(vstart, nslabs << IO_TLB_SHIFT);
 		if (rc) {
 			leak_pages = true;
 			goto error_decrypt;
@@ -667,11 +668,11 @@ void __init swiotlb_exit(void)
 
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
 
@@ -711,12 +712,15 @@ void __init swiotlb_exit(void)
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
@@ -728,13 +732,13 @@ static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
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
@@ -807,9 +811,11 @@ static void swiotlb_free_tlb(void *vaddr, size_t bytes, bool cc_shared)
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


