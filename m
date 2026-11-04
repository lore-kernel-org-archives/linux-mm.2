Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88697606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWbnbjUp
Received: by kanga.kvack.org (Postfix)
	id A9FBE6B05BC; Wed,  4 Nov 2026 11:49:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A518E6B05CD; Wed,  4 Nov 2026 11:49:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91ADE6B05CE; Wed,  4 Nov 2026 11:49:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 678756B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:49:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E59C11607A6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:49:57 +0000 (UTC)
X-FDA: 85398023634.07.87E9B1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 45834180004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:49:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RWbnbjUp;
	spf=pass (imf06.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/F4y/7yxyUDiC6xbvLu9ph4vBP4DM40ibzlyQTAOh0c=;
	b=7Eoa5MiokdTXEFqWWpTMXLzgOJAB8JoSPN9ZC4n+I8mcy0AIj8gHCz2/zcKURcfcipH8DS
	IkBzW++JgdnxR4udVDBDC7faGJvJSCYduEVBFaQ8IN/JFo51cNfiOTU1K5d7tvNrJyrKTx
	uYvTdSaYDJ84OlhOniEPIINQeJa41pM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810996;
	b=h5MTnN+JdhJTKiDc0xaRK+JN6V7V+7PwixhqU9UqC1304ddt2wgBSk2GvSOyRk1jJrIL8S
	exklpIVnJc0Me+f5I1gj6vyy5jZ+gDpcwfcSrn28swBoVN9YNdC2QkGiMHpVHv2jt/PmbF
	5+JELKklvOhf0pXSqiFUQTjwGFo+86k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RWbnbjUp;
	spf=pass (imf06.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB72060A9B;
	Wed,  4 Nov 2026 16:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B930F1F000C1;
	Wed,  4 Nov 2026 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810995;
	bh=/F4y/7yxyUDiC6xbvLu9ph4vBP4DM40ibzlyQTAOh0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWbnbjUpfcX8JPUtmuRRRCIpDFvsLf9pqqzPslxkKD2RW15cGeD2lmNoiUBS74a0Y
	 SK5oXVrncs9sW/hdhJWhVViUBObYdXEPZzcY/6JZa3wYB0srmUx94GCxxim1PRhGQH
	 NYtWn8urGtrK810fIT355NtKDPkwPR4iQYws3XmxSoBr5P8JBVVUUhgKcai+BtxaY7
	 YzBTuAK+D3G/Y67o6Itb9nX6LoU5qHj4DUV8BsKY5vy7BMj+H/Y0/4NTownwGAqee+
	 1dM/rFeD1dys8RnQur4rk2ju7Bhp3ztICE4SZi5mD8T3BDb8glKh+Z+qwD1mbRZ2sJ
	 sAM/WrZPS3GnQ==
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
Subject: [PATCH v9 11/14] dma-buf: system_heap: Allocate shared buffers using CoCo shared memory allocator
Date: Wed,  4 Nov 2026 22:15:52 +0530
Message-ID: <20261104164555.3555725-12-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: d8dbfaaodo8ietdihmownr3jxtjiyym3
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 45834180004
X-Rspam-User: 
X-HE-Tag: 1793810996-11584
X-HE-Meta: U2FsdGVkX18lf7TUrN8TKdFE3x4JGsNdBE/z2v59BckcHb2liFBp0amed8q0kuN7o61BKACcvIDDfL/W2Zu3WmWaS7wzFszp1QfGiP2mvgjwXah+xLKM50N8qYvCtDc9m1YUUYLAz1448iCMR/zZA4wk7gvn+c1H16HR35FPASJgyBFfoBx8+FrwB1clopR30j+xwaTNTerwXFNlH1k5WQlU144DsvtMjRWXD2cVXRod4n3p3a7uZD3wtPs+Uxhe49W5VR6q8P233LMVkEaYyaNIJiBVIOftACQOK5kP321ILR1p62/30N//HuabGiv9dwD5OV0OvKKLdA41lhtF9Fy0AhB975KjEUTWWDdygDmzwLuZtHXbsd6buORgc2FYLU1HjbYy6yPenPnVbhV8/y7gUUzx1pNOWYevuW86vBnSloufVAVscfWHyyXM3ytnNl92S3QS/RMpraGuK5CD+25e65VCB3dk1zo+wEkq4bw41GYwaXSKWMoQjyIAhOXoY0s9BccWW4WXu+HOxcA6gzMoVS9Jqk3WMNa2nTvueUL2tQnYVlCfEL0ocs7Zj+qK05POxS2KAGNp96WboACUjJAo46zYzkUSFOhedMlBH+5ebrF0iuQvy2JzEFnag70c39enWQxu0ZTTv+Gt2GcK1d1Obn8LgQCiOEUW0mfykb6qz1Z5z7DD1oNX9nPs6sLDU0KZ609M39Q88wAykVmVGDIwJZZSrQFvSIPMEGpiVyGB2j+py3/pU9bh7+adukNkem88arYdoKRvTOOPB1NLoE01AKU7x8un2Fs9AvW/LfddzuVycVgqNAuBEmJ9m+BEk4AOqpaZSS1Rc7GznKB97DM0G4S/lccpVZxRa93gTVWRpQxEXZHByJHWyo67wuUAH1Wu01Pa3reYofCvkSgEfQ2/qkeqrQ91hwHxxbBPbYKz+I6b/nzqNjgt9vCdPxy+E1ATe2lBwn+JNe0javd
 Uv/SS7zH
 uFIyL/h7S8EE1TnMcWO/qa7O1Avlf/qplftX3EgYDK5qmoAy6WBJpF7GQleFjwGuEGVljxAINyiVYWGvQNof6nVwZYo+8PzKt8HzzsjjFWXWC53LGixfqVYrLiipWXaGfvgrQYtMrGPIxkLp//jQj8BXgPowRpG/lt4iLceFbwGzagGEYxHT6Oot0ly6aKZwC/hmySd28yfmrnHTV47TuLBYSDkT8wqiOQImR1Xfa14kGevCmIlW32kgjdpEhS1WQFxwFmw3Fv8+GZWmlm33s3/0QOrd2lj0Hc7RfzVCvU05Q3Y/vrEJHxtUj2hyHzzVwyR1I18vvMlvOU9shqTNx4YKnTG6nVbPJ7QH3XutDeBDjTUqgqFK7kN2dCP9n3klnLiOnm/bYYRfw8293op96KLQRyNT1YIU1nvqM/CW1moRfT5OMpPMLEE/qdFz7a+S7fZlTrA4I4PxQFQNznknApHIQdPV4up5VLLq86Rymra2nJ/f3okzXdeNUeBoRWo2+TJu8MUgZoWoSUfC2ff2hlMym7G18Xfg7mifAQl6UJP5VB2Nyine34wKgmFtSQ5PMMDHRQRNTdVQc92B3ePOTus9Jo8klM7FflNtAL12GsPhvj4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The system_cc_shared heap currently allocates its backing pages using the
normal system-heap order policy and changes each resulting compound page to
shared state. That is unsafe when an architecture requires state changes in
units larger than PAGE_SIZE: an order-0 tail is neither sufficiently aligned
nor large enough to transition independently.

Use the common CoCo shared-page allocator for every backing allocation of the
shared heap. Preserve the existing preferred-order search and its GFP policy:
each candidate order is passed to the common allocator as a byte request, and
that allocator rounds it up when the architecture shared granule is larger.

Add __GFP_COMP for shared allocations because an order-0 candidate can
be rounded into a high-order allocation. The system heap uses
compound_order() and page_size() for accounting and release, so the
returned allocation must retain compound-page semantics.

Calculate a rounded internal backing length but retain the original
length in dma_buf::size. The preceding scatterlist-length change ensures
that the rounded tail is not included in DMA mappings or other
operations. This permits a 4 KiB request on a 64 KiB shared-granule
system without exposing the extra 60 KiB to an importer.

Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Cc: Brian Starkey <Brian.Starkey@arm.com>
Cc: John Stultz <jstultz@google.com>
Cc: "T.J. Mercier" <tjmercier@google.com>
Cc: "Christian König" <christian.koenig@amd.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/dma-buf/heaps/system_heap.c | 121 ++++++++++++----------------
 1 file changed, 53 insertions(+), 68 deletions(-)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index b5b8cdf65f23..5970b76416ae 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -11,14 +11,13 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/err.h>
 #include <linux/highmem.h>
-#include <linux/mem_encrypt.h>
 #include <linux/mm.h>
-#include <linux/set_memory.h>
 #include <linux/module.h>
 #include <linux/pgtable.h>
 #include <linux/scatterlist.h>
@@ -65,34 +64,6 @@ static gfp_t order_flags[] = {HIGH_ORDER_GFP, HIGH_ORDER_GFP, LOW_ORDER_GFP};
 static const unsigned int orders[] = {8, 4, 0};
 #define NUM_ORDERS ARRAY_SIZE(orders)
 
-static int system_heap_set_page_decrypted(struct page *page)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-	unsigned int nr_pages = 1 << compound_order(page);
-	int ret;
-
-	ret = set_memory_decrypted(addr, nr_pages);
-	if (ret)
-		pr_warn_ratelimited("dma-buf system heap: failed to decrypt page at %p\n",
-				    page_address(page));
-
-	return ret;
-}
-
-static int system_heap_set_page_encrypted(struct page *page)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-	unsigned int nr_pages = 1 << compound_order(page);
-	int ret;
-
-	ret = set_memory_encrypted(addr, nr_pages);
-	if (ret)
-		pr_warn_ratelimited("dma-buf system heap: failed to re-encrypt page at %p, leaking memory\n",
-				    page_address(page));
-
-	return ret;
-}
-
 static int dup_sg_table(struct sg_table *from, struct sg_table *to)
 {
 	struct scatterlist *sg, *new_sg;
@@ -337,6 +308,20 @@ static void system_heap_vunmap(struct dma_buf *dmabuf, struct iosys_map *map)
 	iosys_map_clear(map);
 }
 
+static void system_heap_free_page(struct page *page, bool cc_shared)
+{
+	struct cc_shared_pages mem;
+
+	if (!cc_shared) {
+		__free_pages(page, compound_order(page));
+		return;
+	}
+
+	mem.page = page;
+	mem.shared_size = page_size(page);
+	free_cc_shared_pages(&mem);
+}
+
 static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
 {
 	struct system_heap_buffer *buffer = dmabuf->priv;
@@ -345,19 +330,8 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
 	int i;
 
 	table = &buffer->sg_table;
-	for_each_sgtable_sg(table, sg, i) {
-		struct page *page = sg_page(sg);
-
-		/*
-		 * Intentionally leak pages that cannot be re-encrypted
-		 * to prevent shared memory from being reused.
-		 */
-		if (cc_shared_buffer(buffer) &&
-		    system_heap_set_page_encrypted(page))
-			continue;
-
-		__free_pages(page, compound_order(page));
-	}
+	for_each_sgtable_sg(table, sg, i)
+		system_heap_free_page(sg_page(sg), cc_shared_buffer(buffer));
 	sg_free_table(table);
 	kfree(buffer);
 }
@@ -375,22 +349,39 @@ static const struct dma_buf_ops system_heap_buf_ops = {
 	.release = system_heap_dma_buf_release,
 };
 
+static struct page *system_heap_alloc_order(unsigned int order,
+	     gfp_t flags, bool cc_shared)
+{
+	struct cc_shared_pages mem;
+
+	if (!cc_shared)
+		return alloc_pages(flags, order);
+
+	/* The shared granule can raise the actual allocation order. */
+	flags |= __GFP_COMP;
+	if (alloc_cc_shared_pages(flags, PAGE_SIZE << order, &mem))
+		return NULL;
+
+	return mem.page;
+}
+
 static struct page *alloc_largest_available(unsigned long size,
-					    unsigned int max_order)
+		unsigned int max_order, bool cc_shared)
 {
 	struct page *page;
-	int i;
 	gfp_t flags;
+	int i;
 
 	for (i = 0; i < NUM_ORDERS; i++) {
 		if (size <  (PAGE_SIZE << orders[i]))
 			continue;
 		if (max_order < orders[i])
 			continue;
+
 		flags = order_flags[i];
 		if (mem_accounting)
 			flags |= __GFP_ACCOUNT;
-		page = alloc_pages(flags, orders[i]);
+		page = system_heap_alloc_order(orders[i], flags, cc_shared);
 		if (!page)
 			continue;
 		return page;
@@ -405,6 +396,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 {
 	struct system_heap_buffer *buffer;
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+	struct cc_shared_layout layout;
 	unsigned long size_remaining = len;
 	unsigned long sg_remaining = len;
 	unsigned int max_order = orders[0];
@@ -417,6 +409,16 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	struct page *page, *tmp_page;
 	int i, ret = -ENOMEM;
 
+	if (cc_shared) {
+		int err;
+
+		err = cc_shared_calc_layout(len, &layout);
+		if (err)
+			return ERR_PTR(err);
+
+		size_remaining = layout.shared_size;
+	}
+
 	buffer = kzalloc_obj(*buffer);
 	if (!buffer)
 		return ERR_PTR(-ENOMEM);
@@ -439,7 +441,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 			goto free_buffer;
 		}
 
-		page = alloc_largest_available(size_remaining, max_order);
+		page = alloc_largest_available(size_remaining, max_order,
+					       cc_shared);
 		if (!page)
 			goto free_buffer;
 
@@ -464,14 +467,6 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 		list_del(&page->lru);
 	}
 
-	if (cc_shared_buffer(buffer)) {
-		for_each_sgtable_sg(table, sg, i) {
-			ret = system_heap_set_page_decrypted(sg_page(sg));
-			if (ret)
-				goto free_pages;
-		}
-	}
-
 	/* create the dmabuf */
 	exp_info.exp_name = dma_heap_get_name(heap);
 	exp_info.ops = &system_heap_buf_ops;
@@ -486,22 +481,12 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	return dmabuf;
 
 free_pages:
-	for_each_sgtable_sg(table, sg, i) {
-		struct page *p = sg_page(sg);
-
-		/*
-		 * Intentionally leak pages that cannot be re-encrypted
-		 * to prevent shared memory from being reused.
-		 */
-		if (cc_shared_buffer(buffer) &&
-		    system_heap_set_page_encrypted(p))
-			continue;
-		__free_pages(p, compound_order(p));
-	}
+	for_each_sgtable_sg(table, sg, i)
+		system_heap_free_page(sg_page(sg), cc_shared);
 	sg_free_table(table);
 free_buffer:
 	list_for_each_entry_safe(page, tmp_page, &pages, lru)
-		__free_pages(page, compound_order(page));
+		system_heap_free_page(page, cc_shared);
 	kfree(buffer);
 
 	return ERR_PTR(ret);
-- 
2.43.0


