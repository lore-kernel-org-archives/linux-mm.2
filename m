Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660B5606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fvdw4mJp
Received: by kanga.kvack.org (Postfix)
	id 717B76B00EF; Mon, 16 Nov 2026 04:14:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF3B6B05C1; Mon, 16 Nov 2026 04:14:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF026B05C2; Mon, 16 Nov 2026 04:14:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37E466B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:14:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0270160857
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:14:25 +0000 (UTC)
X-FDA: 85440421290.18.D773DA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0E7B740007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:14:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fvdw4mJp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820464;
	b=QzGTdnc3nQ4s61qR8l5dpM4HOlKx0PBqTOJuO+K42bQ1DFnffs79M3HKqsjgtJgVpwEp2z
	a+ivbsyW4c/T/ennJ+wB2IHmCKKWxOtIqw19yIbWA+lO4ncL8lG8zF4IdcRAnNh53sz8c6
	u0DGRZncJh8fYyMY08ch0j/uNZujxg0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHfQ+J8qsgYVcG2qrN2v5b0dwvl+0v/d64C0YQIVcm4=;
	b=XaV6w1sBljX8Iee6M1HkjouhsN3+lOolXzx9hWFSlq3tgLh/cJDng83I1Vfx3s97Vb/whs
	kn798kSFHRIIHgRSuT//cRo4QVIAVRhKzrOuy9pGmn8SEtWI2PBmpDScf0VYd2tZtKq6LW
	p1wLnrXDZPBZrnQZFEySWmlSwYvp/ls=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fvdw4mJp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45C28402F7;
	Mon, 16 Nov 2026 09:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E2A1F000C4;
	Mon, 16 Nov 2026 09:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820463;
	bh=IHfQ+J8qsgYVcG2qrN2v5b0dwvl+0v/d64C0YQIVcm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fvdw4mJpFECg2KA6LPT1DGFJnSbwZKVEO+AN1WvYFLAq83I7d06o6FvOn9gRG5jwm
	 GTJibKHMWrptK0v6ilX/UDndcV4rp/Pcq8X+JKUQoMoNCgRxGH5Hzji/WTfXno1W5J
	 TS3/L2R/F/jAlFHd5HZe+DsvgLvv2xbPfvjhMqcA/d3Z9R5AjmIhPOisYmQEsAuxRk
	 rp2K+8yL33dV07r/FAo2j4+tMgMScSIWxMh5IsG3o7nllonmoiUriwzdibZ2SwfC14
	 p4xzdNHQXihXs8TosqXxyqQVrCAZOvMT5JT/7jbO0smFnrZoeBVsSE7zAe0NyM9MfI
	 BHn/gdR4i2x1g==
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
Subject: [PATCH v10 08/13] swiotlb: Align shared IO TLB pools to the shared granule size
Date: Mon, 16 Nov 2026 14:41:31 +0530
Message-ID: <20261116091137.94252-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E7B740007
X-Rspamd-Server: rspam12
X-Stat-Signature: b1o1ujz81nckudxoxf9yc1gems3owabe
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794820463-379329
X-HE-Meta: U2FsdGVkX19AA6qm4Ld7QAiVUug/clNXTkMssXMU80kxarwDk/kCtSRoLS9NaNh3z59Ip1a1mNmUfJdQ8REAO1YrFm3344e5gAZUv11aBsFgnC2GRvw7IFx95O1wR6QcoGlHUkrgHVFHybiSsOwUSuw/8LTVxPAwrIhBsbMoJsfOOiWqcSBEfNWToGwHSyjCR0uc0z+WjAihIOVrDkUSO7NNlDCDe4tmxbrmT62yg5PAC8ZBGKlRYvpN69/y/8Q37+y3tRBzvs8/mL7YhbF5E4o5zLhh3nGDlUMc7cQ42nGbUyukAiqbeSI3lQWi9Uf/srY4rbfTWuoUMLvt1B2PvcFcylySJwJm71ZoUAX5iaE6yc7sewoqaKd6xOqEA9t9uDj5wNFoyH5u3msKnMhXkLSxtcCwPf5Zk6WQLPeipfUc7ahW4G880MhtZgpzzJZyH0wsECg/pRlSeib+MWxs9DWgIvRUmfd3tC2uisYO3grMYYpi62PpdZBSoV+K/qWc0KRSpJ1Vq7fcEX/9QgRfGPaESNduVKsgGPusdErDtIyrQ0fB2viPYS2U9n5GbvcJse0ZAUw5h5WGegdUiYqK+TSOeEKq46l+nsMV+vC80/oDgGQEQe0tyMLaQLLUamHy++erWvhQ/pqbj7HLjg9AgayAW+FEg/zxJwV0/bIXzN97r2J5E/Yz0W+5oNR7EhmqJHz2QvZu4Yw65DXK8WIWqAC77j4zozWu802B+ULhoke6QQ4pewD21qAC5eZfFK8aSsM0tVT8NBuGGsL9jHt5voQwOe23C1iittQoBB73Z8hUwMGUjDxHsNwNsuv4PRAHHqKwO57cx42SiRqFl7E0J3oh8toQegzWMwZ2F8IesIhz9xqMmoYltAB/uz+dPK8DYAaQxhp7Vkl6dM4ZzhX50qXeNDQ2gUcNgo4+s2pAKUegAYaQcmKLDjGicDOrvY9ponFCv/kFdPB64eH9ALN
 iMpdaHtm
 IEu2iACZbYhViVXQWFphBk3hPu8u5+z04RMLiZW7b4/bCuwqoNZenmF4B8gzitxyDdbVE1XKE/MDNxGhZYJJyex5ufLuOQxOnzKEV/cRHhAESQTvjTMdddGFRoT+0anMpyNyetNOLFC1SAUb/2SeRRTuDAs01cbxjAtMdtV/G2NBykkohcsyXqUkLV3U61ZrJkTOtwSerXd68mjo1uLYyv/uZ5GZk6I82H2I4AqfGAvBPZ6e7CleAyHHKhPrR/SZHz2mImhs0bZXKXR+IgjHGj6cBxrE02CW5gmrrCyTHh9C/cLlO4mDplg0GjzDNbh5rCt3D521TiSYxACaOsbCGbrIWEbNCswpL6wY2BqLQhYneTsMXhJJHlShZS6nJN6N8OdDFsxs5USLlDK8INgOAyNM78KbKz/pdLbjjBr4GIjmWzryYSAidbzM05lGdNc5IA5XrbM/JkrK9dijIICWu5HyrMsxziAO6kH6bHjnWarvUw4v+QWJFBt6+1TCGntsSHArv/KwmSHY4O4j+Nj+iFtnmNd/CbLW5WEX8
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
 kernel/dma/swiotlb.c | 53 +++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 2c57b49ac7c0..2bb7d83ee479 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -22,6 +22,7 @@
 
 #include <linux/cache.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/dma-direct.h>
@@ -367,13 +368,13 @@ void __init swiotlb_update_mem_attributes(void)
 
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
@@ -434,8 +435,8 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
-	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
 	void *tlb;
+	size_t bytes = ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size());
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -443,9 +444,9 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
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
@@ -454,7 +455,7 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	}
 
 	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
+		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
@@ -576,7 +577,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 retry:
-	order = get_order(nslabs << IO_TLB_SHIFT);
+	order = get_order(ALIGN(nslabs << IO_TLB_SHIFT, cc_shared_granule_size()));
 	nslabs = SLABS_PER_PAGE << order;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
@@ -585,6 +586,8 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		if (vstart)
 			break;
 		order--;
+		if (order < get_order(cc_shared_granule_size()))
+			break;
 		nslabs = SLABS_PER_PAGE << order;
 		retried = true;
 	}
@@ -598,8 +601,13 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
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
@@ -624,8 +632,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		goto error_slots;
 
 	if (io_tlb_default_mem.cc_shared) {
-		rc = set_memory_decrypted((unsigned long)vstart,
-					  (nslabs << IO_TLB_SHIFT) >> PAGE_SHIFT);
+		rc = cc_make_shared(vstart, nslabs << IO_TLB_SHIFT);
 		if (rc) {
 			leak_pages = true;
 			goto error_decrypt;
@@ -665,11 +672,11 @@ void __init swiotlb_exit(void)
 
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
 
@@ -709,12 +716,15 @@ void __init swiotlb_exit(void)
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
@@ -726,15 +736,10 @@ static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
 	}
 
 	vaddr = phys_to_virt(paddr);
-	if (cc_shared && set_memory_decrypted((unsigned long)vaddr, PFN_UP(bytes)))
-		goto error;
+	if (cc_shared && cc_make_shared(vaddr, bytes))
+		/* leak pages on error */
+		return NULL;
 	return page;
-
-error:
-	/* Intentional leak if pages cannot be encrypted again. */
-	if (cc_shared && !set_memory_encrypted((unsigned long)vaddr, PFN_UP(bytes)))
-		__free_pages(page, order);
-	return NULL;
 }
 
 /**
@@ -805,9 +810,11 @@ static void swiotlb_free_tlb(void *vaddr, size_t bytes, bool cc_shared)
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


