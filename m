Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38AB4C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BBC16B00AC; Thu, 24 Sep 2026 06:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093E46B00AD; Thu, 24 Sep 2026 06:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBDC6B00AE; Thu, 24 Sep 2026 06:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCBDA6B00AC
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:08:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4659C802AE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:08:58 +0000 (UTC)
X-FDA: 85248232356.18.FC8982D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 86D22C0005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:08:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UuUMyUgz;
	spf=pass (imf10.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/F4y/7yxyUDiC6xbvLu9ph4vBP4DM40ibzlyQTAOh0c=;
	b=aGwJobsWbuZpSp62RBtWpMS1l6XCREIhn1MZFg5daS11EQHYrRvZeEfFvNPgduvloFnEO0
	YAbimlBP9tveuWWd7fA6V49DdmFb7rf+s3nGrEihV0QPtsJpDd0SdIssyvG6x7Dhvpps5T
	Ul1PVnXQxQCKNW9rNi/2l9UJRz6sgwM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UuUMyUgz;
	spf=pass (imf10.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244536;
	b=Sbbjh0ooITs/2+eaaSHEwgJ7U58uzJonR6eTTG2HOxXBXbOk7dk/ujHuLgLbOelTwaTm2G
	sH3UVr9AxIKdKS6L09KUe0kB4DAlgU37rvCx30ktG/qL2rlbnbFHyhYAOGAyFoskjp/ra6
	5SBvRnj7NHepYLk/Oszt5gMrQnwAoaI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C682D40C06;
	Thu, 24 Sep 2026 10:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A8A1F00893;
	Thu, 24 Sep 2026 10:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244535;
	bh=/F4y/7yxyUDiC6xbvLu9ph4vBP4DM40ibzlyQTAOh0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuUMyUgzUZWtthyh61vaCwP7ZLcWxHojwv+uEizpKSKXauzTbqg6EVPm0mJDppj3X
	 ztyjgCs08HO+QzCrg8WCWibDXFvPYpFUKjIYI4O6sAoOJr+8RltFEDWZuHR05Mmh3j
	 drE4nAushbHuhZXqr7khJTBd9CfA7GwiknoMQ8yVPjKzfEYauZlDgzQk77n+jj0y3T
	 q8sHWy4IAz2LpKhmDLPNDY5p9N9napTpJ2vyOkZCuS505Ogd89yBRjUeGWBX4ZwPsU
	 cgg41AK1Qx1QJI002BGvsJUwlMCFUqXRoyHGKNpPql89lBdfad+a7TqNmPIQYO3YtP
	 eNHWgKjV1jtWQ==
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
Subject: [RFC PATCH v8 11/14] dma-buf: system_heap: Allocate shared buffers using CoCo shared memory allocator
Date: Thu, 24 Sep 2026 15:35:26 +0530
Message-ID: <20260924100529.1398790-12-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 86D22C0005
X-Stat-Signature: m1uy9dcjkbc57wtqua8kq7zbroqk4rqs
X-HE-Tag: 1790244536-326886
X-HE-Meta: U2FsdGVkX1+fN93+ZOMDYFv6iM7q+wM3tavC3CRuSL3G7TmrIFXxpr8F/gyAIFaSLK+CHO1kZ0lpnZ0ahe/FRFs6ZT0tYDFWZWiitkWI954CvxqmrtKXA0egdMXrCeQfg5xFPIB5Ix9pBVbB4Dm1S1iWFMah6d1huFmIaP02MMhfU52l+vxqKNKZrLo0+FWBlqjS5olhT9h/hwqu4BP0jASxY33bmHbQ8klzRRk+h43LDB/IKZFg2YV/kSnmmNykpsZDI2uO8rXVcZVFyoFgmAOHi2PNHMN+KbuHFfQdMFEc+UquuTlpBWHLbH80mRffPK93ngIthQH5qVpyQ4vdo72OX7NBtMK3konUBZ1dLhTEvu0n+B4S6N0H4R5G5aEVpoK6GHgCmnnJLp064mw/F94gSeo5YjBqyX7q0A+b5z3rBfq/0sGXxNEHx6waL2hrK4SMSr7wNQC49AFnL6Lv9xf/aDRoz7JmnqnFYF44gAm6IrStcwmb7+7eWY9pBWAk1CN4POHAQ3H9HkR7ckf9ONISY7c0fehuY+MIvpzbnCIfRI9Bw1KwfQTfaI4Z8WZrxvJ7mEJeiCHA+NqTnpIw14ajWUAeKGsubn3L40omSm+tdzTsl5f5QQ4/2vDVvOvzQvZQatqqsVZ4Ocl9nCzhL63jr1HXTkRIVF3TjvpOT8ZcSO1aIRKPxkbdmQnBvK/S04x/QRR09RIlY/ta1GyCzdIVCQE9/ImnZerdsyWNQBgcUjdbRiXCuTk2O7bGO+xr2NNAOk9jz3zblguWazf8eK8xg03plx8uYK+laRYWXB6Iq/N0CcCa4zGSS43K93Vp5p0bcvROoxA/oRg72UZT5+SMEk0XDmNvsjw6Vqu/8s7yJRnYgdzIZNZji/e5OsNtRIwIY+JOLD6+05s/F4/PbQQMeMR3o1dFZc3BK7KLwTTKBtg584Fv8oALY4iDqv1mZVSFl4h3X4mP3ouEIBW
 WLhKh1Om
 U+DUorHwatiTWgmnFnF2+cbHWivciERUwVFjK/C3Si98kfv36re7s3zSv6x3yoe3+oHpASDMJgXM6hKOuaBKoYHM4HN/FeCQdawBO+jRmi4EaXNQfWMvNlx68sJL3cTHijlJCuf7EU/8E4c8rccYCWRER+muwVbeUBWaaKK7Tvz3nv5zF2/bva4N9ouZ2F95HVKy3wKGH3cP7q6NMg2vezjx+V2mluGMQRURnE7/UK9o4G8sywskW4uNzC/re3UwK733elyM6Iu/y4CoVUKXmtk4E/5LsK5u0amhP8rVOPJcrhnU/+ul/TF4pIAHbOIo/FcA3Yfo/SBbzy+MCMuH6Qn0aRJcKIvI/oTEyhtVRnZ2DNEmUo1rmVSBmg4uTNPEM8zL5jp25R6hRzSxP/5GWsFV3mTifpEY69TQJkUnk5B0jyXIiBCrNQR/SY8ob4gcEfSw0kaKcHkefSPF7OS2Rn/oEarQCg7eQsPN4+v59O0uS6I3WeFnrY+LvbyTD2C93GuCBP+cn+KO94Qw9TnrjajPy5tZjZMU0YuBIOP/YiHF0mTzTT3C8iZwvoLSs++YAyide2L3H0/f6J0P2ep1oocaK12h9kFQIq/QSC4OsXMAfkAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


