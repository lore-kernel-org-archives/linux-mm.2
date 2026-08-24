Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D79BDC61CE3
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10CE6B0099; Mon, 24 Aug 2026 11:29:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2276B009F; Mon, 24 Aug 2026 11:29:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61F56B00A0; Mon, 24 Aug 2026 11:29:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 716676B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:29:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF395A28BD
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:40 +0000 (UTC)
X-FDA: 85136547720.17.DDA42E3
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34364120011
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z2uEwnSo;
	spf=pass (imf29.hostedemail.com: domain of 3YWOMagYKCLQflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3YWOMagYKCLQflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a387GiIlsJuzM9aT5OA2RPOtHkxgW7YP7HmPN81inmc=;
	b=aMXWuIZt2AyYcZrjwxhh1y00Aoo/+ZvGPTcQIvAuyLNKgR9ZVFDp4Qzf2LmNOwi7pJyvQq
	63sN6WneM5KGLnbJhD3LOexONU1PYQ7UXYOvweF5ITQW4cgtjykjfcaPBQX41F1R58wtdZ
	XhrRVHotfvsg+10W4xA7bc7uA+SZQZQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z2uEwnSo;
	spf=pass (imf29.hostedemail.com: domain of 3YWOMagYKCLQflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3YWOMagYKCLQflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585379;
	b=x86gZ6togmZBI4L4PF9m/vzeP6Oo392KCaAAMEgr0Bz4jLy0rIj/68eZKjYQpoeJ6GrEkp
	Ii2tfnAxzvtnbxkTSxjKHLX9GwDbPJJLx6+CMSmtNmNb9W80soRHun9XGp/iIMU70ea9oK
	p4J8Etogt6CM5M36LxBiJr6Nqo7A2kg=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a3899d74c5so4968260a12.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787585378; x=1788190178; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a387GiIlsJuzM9aT5OA2RPOtHkxgW7YP7HmPN81inmc=;
        b=Z2uEwnSoCjvJhvc2CyOlrB6FY83xU7r7uOVT+9s+88QodW8QoWaj26/xGAaqoWUoLn
         AVKrFy1jF29IO8Wfv8p8qnvysrtHmZCq7T5U34al7cV5+9o91cXwb6PJnRHh0Z5JiANr
         Y3LpT1ijdioP7ihHq1RGF8zXv40OPVWI/yGi3cuSv1mPKK5dON92NCNnLcoJ/q8bPJeO
         Kv4Nvy/ejQEGzGcNp+l6oHAJ2zsRHlUWqDkJKfE84mFQ53LpIyLuNDxP8d/dpumN60Ji
         Chc87sujkt+dvdilN0B1QdcmjFvuNLaEslp0mrqera7Pv6fnPxEFcmRetil18KVkc/b2
         eABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585378; x=1788190178;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a387GiIlsJuzM9aT5OA2RPOtHkxgW7YP7HmPN81inmc=;
        b=rp3gYAHPhxbR2lN6hvp6uW2LWxi+J7FJnImYONmA14TH5okdE7aAokcn7j7SMIOQnd
         deWd6ftvLT1+uJWYWpXkTs8oaxgirVEW1ItnUygvN0GMWJMVNR3MTl0Qv5YwqoBx/mlw
         MnupFBfMsijFiewU2ny/3URVINN2YJhCyI90YLrJrjKqErHvl2DPkCRRj+HR3aJIBRxp
         DUBfd5/sbINPqLmpK2/APpLwiVNz8jZiA1pNFCJEzHiYhecnJNfaInaWTz1/zTwDQSHL
         Wnq7cnaHwKMtOAphfSIWgnQMwii9iWF/HW4wpQw4c21y3+H00dbbOUFQZMAI/S6OcNgO
         ZydQ==
X-Forwarded-Encrypted: i=1; AHgh+RrOY3w7jsQozHOlAZC89uwhhkaplvxWV4pAasT9FhAtRN2OwkQgzwe+eo7OXb65RyoDmYHG9BM3zg==@kvack.org
X-Gm-Message-State: AFuF++kLZ3TFPbgEjkqIVjh4kG0Z49Ny8zLfElJxhT20zWEb5hUejhyF
	iDMfFq4PDnzBZ2a3H0ppHT07xJ9T8aoALwyPvDAPQy0Wn5/empoR2G501/dbNdltUwytBO8v/nu
	SCcV0cA==
X-Received: from edxn5.prod.google.com ([2002:a05:6402:5c5:b0:6a1:4f77:f704])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4613:b0:698:9e5e:5df8
 with SMTP id 4fb4d7f45d1cf-6a42f1aca88mr27508443a12.7.1787585377536; Mon, 24
 Aug 2026 08:29:37 -0700 (PDT)
Date: Mon, 24 Aug 2026 15:29:29 +0000
In-Reply-To: <20260824152932.1583506-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20260615234220.3946885-1-lrizzo@google.com> <20260824152932.1583506-1-lrizzo@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824152932.1583506-3-lrizzo@google.com>
Subject: [PATCH v2 2/5] swiotlb/mm: Implement SWIOTLB nocopy page allocator
From: Luigi Rizzo <lrizzo@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <lrizzo@google.com>, 
	Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dragos Tatulea <dtatulea@nvidia.com>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 34364120011
X-Stat-Signature: oc9spdwrgurmxt4333c3fjxnurdx9mg1
X-Rspam-User: 
X-HE-Tag: 1787585379-608715
X-HE-Meta: U2FsdGVkX19+BNS51+fXRYt6AZcxOvCJdwH0g4q2xjy6jYCOsHjkeAVbwsY9TU2ShCTUanTluUGnNNu4cUd6YUKdSOzXJR5522/cTwST077gioxtJSPE9moTD1DilLwvetvCweMRJu1jXgSEsxydeVaCZ7EcLkU1pGI6YYwZEdG8jt1nJ1VTrFOLpTPjx8/h5jauFbHhbnsiYpfIDi/CQrbqU3ahtGpo8CVLrvWNPR5u0dK1mexxHIli1/ts/7o+ubkEIMZScUtjcpi43M8xBW8YHqDYgBQn5Vk1e2Nq6mAjRveSHZFDZRMpv9Lck+QRTaJuotE6PIKsVcUWX8qoTGo4S18mrMf9UsYOV/C2JHq+vGF9DGCFVz5lBgx3bnZOOiVR/oPyeNv7KKM6jIPQF16OCX5WRm+gzUjQLE5t0zRmne+6E0Si8yLnGtEnEdTsek+NQmGC4/nFi4mtWrFPp2EtKDHSzMN5hWGA6LmM5UbbBNvDVoWLe2w4RthsRGKG9Tq36oiF+8d0X0DAKO1Bwi8q+BEYyTOfOFHZx5oEdMQJDR59tqsB2N8kvLcjqtlD11cRTsEsmTSI2VpOg2Ec8ZmTkhpXcbf4zgOqBxZbc337ylreYymHOpiAUyrF0X+VIFamKIs1U8QKinhaZhUCKjVna7HwDYhkRKsHBttc8wWR1jYXPU1nJ6bbQ15+zhmYyDE3h3o8eOok6NPdSdMjbq1NE/whd9HuvUHXFp0FlYRM+yFiukGkkarNXShbebrKWWGsLGbuE3qLOfstO9PBLgSmBXmx+00g4ecaADYqU6MJiQEI/nuuC2zRcjf5faoYfFIKlOAKg3VSNhTG7Q5T7P/m8656oSXlKSXoOTE7heeAz8uZ90cletd/Vhcq8Bkf7y8Wiv8p1aMbd9ci0XTeaVyuA/PRz8gheK2xrOqcXHYI67fqmVUnBO1qI6q9v+V8kR6G2sb5aJQxtKQDogc
 wI15NkVq
 qlKeMwSVxl7hA6gh/RJgIeqn2Wq889wfV+OBl3kzur0rS4b9gMc7BjYANlzesrIKcbaNSFjph3RUt0Idpld3HyN4Bqij390JqFTKMle51AT6uTK5trXYFF7+pgevW6ZH7KvjbkCE+++53TGTiejRz2qvZL5d5/Dh4pTJI8WH22OYvdGPW4nPbOPQj0G8NGWtQBZRW45qKL344liPjWdUoeO0xBpdTsWcsZ+J1UDJmBi0qoqT9oisg571AONqg+l3em3pNHfTzwUfLY2QKjrYMkz0nGtOOyIo0cSTpOeFjK3c3kHLDAvtMtgF022EH+kAU9Wpfjm5r3ySqxVBYgzulME5hAVeDAwBKMr1kfdXJ1rUTifXnlsykOA//Cqb8z2bS4OjTUqXyJz51Qh/twNQcDngivXt74P1OTpSy4VeFrXBIC8UxE4KOLbXDoWP4qIDopjKDm2JBQW4Z/T4O1MUUkXdb+AboH+RUp4ez1JFNy3GGBxRJt6skoc1QGaxA879465KsBDFpEzcOZ2Elz4XKMu6jdCbHUumCACMLMuX7zsMUuLwY1oqo4ROWkTxhEIDHR0dFS5OeANEjAceolqHAn0aP6UpiZrAd4OkrlE18KQ3e6auc2J2chyIS6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce swiotlb_alloc_pages() and swiotlb_free_pages() to allocate
and release compound pages directly from the default SWIOTLB pool.

The allocator is restricted to slots in the static default pool,
with caller-specified percentage limits on pool occupancy.

This will be used for kernel data (e.g. socket buffers) in
nocopy confidential computing.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/swiotlb.h |  24 ++++++
 kernel/dma/swiotlb.c    | 187 ++++++++++++++++++++++++++++++++++++++--
 mm/page_alloc.c         |  51 +++++++++++
 3 files changed, 255 insertions(+), 7 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 3dae0f592063e..4661e361c60e4 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -169,6 +169,23 @@ static inline struct io_tlb_pool *swiotlb_find_pool(struct device *dev,
 	return NULL;
 }
 
+bool swiotlb_pool_is_nocopy(struct io_tlb_pool *pool, phys_addr_t paddr);
+
+static inline bool swiotlb_addr_in_default_pool(struct device *dev,
+						phys_addr_t paddr)
+{
+	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
+
+	return mem && paddr >= mem->defpool.start && paddr < mem->defpool.end;
+}
+
+static inline bool swiotlb_is_nocopy_addr(struct device *dev, phys_addr_t paddr)
+{
+	if (!swiotlb_addr_in_default_pool(dev, paddr))
+		return false;
+	return swiotlb_pool_is_nocopy(&dev->dma_io_tlb_mem->defpool, paddr);
+}
+
 static inline bool is_swiotlb_force_bounce(struct device *dev)
 {
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
@@ -178,6 +195,13 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
 
 void swiotlb_init(bool addressing_limited, unsigned int flags);
 void __init swiotlb_exit(void);
+struct page *swiotlb_alloc_pages(struct device *dev, unsigned int order, gfp_t gfp,
+				 unsigned int percent);
+bool swiotlb_free_pages(struct page *page, unsigned int order);
+void swiotlb_nocopy_inc_ref(struct io_tlb_pool *pool, phys_addr_t phys);
+void swiotlb_nocopy_dec_ref(struct io_tlb_pool *pool, phys_addr_t phys);
+void swiotlb_prep_compound_page(struct page *page, unsigned int order);
+void swiotlb_destroy_compound_page(struct page *page, unsigned int order);
 void swiotlb_dev_init(struct device *dev);
 size_t swiotlb_max_mapping_size(struct device *dev);
 bool is_swiotlb_allocated(void);
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8e4bd9d47735a..6b86a1e955fb4 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -66,17 +66,59 @@
 /**
  * struct io_tlb_slot - IO TLB slot descriptor
  * @orig_addr:	The original address corresponding to a mapped entry.
+ * @nocopy_refcnt:	Lockless atomic refcount for Nocopy buffers.
  * @alloc_size:	Size of the allocated buffer.
  * @list:	The free list describing the number of free entries available
  *		from each index.
  * @pad_slots:	Number of preceding padding slots. Valid only in the first
  *		allocated non-padding slot.
+ * @flags:	Slot attributes (e.g. SWIOTLB_SLOT_NOCOPY for Nocopy buffers).
+ *
+ * The slot descriptor has states identified by @list and @flags (SWIOTLB_SLOT_NOCOPY):
+ *
+ * 1. FREE (list > 0):
+ *    Linear sweep free slot.
+ *
+ * 2. USED (list == 0, SWIOTLB_SLOT_NOCOPY flag is NOT set in @flags):
+ *    Allocated SWIOTLB bounce buffer.
+ *    Fields used: @list, @pad_slots, @orig_addr, @alloc_size.
+ *
+ * 3. USED_NOCOPY (list == 0, SWIOTLB_SLOT_NOCOPY flag is set in @flags):
+ *    Allocated Nocopy SWIOTLB buffer.
+ *    Fields used: @list, @nocopy_refcnt, @alloc_size.
+ */
+#define SWIOTLB_SLOT_NOCOPY	BIT(0)
+
+/*
+ * SWIOTLB nocopy allocations (swiotlb_alloc_pages()) do not have an original
+ * physical address to bounce, but need to pass a caller-specified pool usage
+ * limit (percentage) down to the area search logic.
+ *
+ * To avoid adding a parameter to swiotlb_find_slots(), swiotlb_search_area(),
+ * and swiotlb_search_pool_area(), the desired percentage (0..90) is encoded
+ * into the orig_addr parameter in the reserved high address range starting at
+ * INVALID_PHYS_ADDR (~0ULL).
+ *
+ * - NOCOPY_PCT_TO_ADDR(pct): Encodes a percentage into an orig_addr.
+ * - IS_SWIOTLB_NOCOPY(addr): Identifies a nocopy allocation request and
+ *   restricts slot search to the static default pool.
+ * - NOCOPY_ADDR_TO_PCT(addr): Extracts the percentage to cap max_usable
+ *   slots in swiotlb_search_pool_area().
  */
+#define NOCOPY_PCT_MAX	(90u)
+#define NOCOPY_PCT_TO_ADDR(pct)		(INVALID_PHYS_ADDR - min(pct, NOCOPY_PCT_MAX))
+#define IS_SWIOTLB_NOCOPY(addr)		((addr) >= INVALID_PHYS_ADDR - NOCOPY_PCT_MAX)
+#define NOCOPY_ADDR_TO_PCT(addr)	((unsigned int)(INVALID_PHYS_ADDR - (addr)))
+
 struct io_tlb_slot {
-	phys_addr_t orig_addr;
+	union {
+		phys_addr_t orig_addr;
+		atomic_t nocopy_refcnt;
+	};
 	size_t alloc_size;
 	unsigned short list;
 	unsigned short pad_slots;
+	unsigned int flags;
 };
 
 static bool swiotlb_force_bounce;
@@ -300,6 +342,7 @@ static void swiotlb_init_io_tlb_pool(struct io_tlb_pool *mem, phys_addr_t start,
 		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
 		mem->slots[i].alloc_size = 0;
 		mem->slots[i].pad_slots = 0;
+		mem->slots[i].flags = 0;
 	}
 
 	memset(vaddr, 0, bytes);
@@ -869,12 +912,17 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 			   enum dma_data_direction dir, struct io_tlb_pool *mem)
 {
 	int index = (tlb_addr - mem->start) >> IO_TLB_SHIFT;
-	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
-	unsigned long pfn = PFN_DOWN(orig_addr);
 	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
+	phys_addr_t orig_addr;
+	unsigned long pfn;
 	int tlb_offset;
 
+	/* Nocopy swiotlb buffers do not need bouncing. */
+	if (mem->slots[index].flags & SWIOTLB_SLOT_NOCOPY)
+		return;
+
+	orig_addr = mem->slots[index].orig_addr;
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
 
@@ -904,6 +952,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 		size = alloc_size;
 	}
 
+	pfn = PFN_DOWN(orig_addr);
 	if (PageHighMem(pfn_to_page(pfn))) {
 		unsigned int offset = orig_addr & ~PAGE_MASK;
 		struct page *page;
@@ -1052,7 +1101,8 @@ static int swiotlb_search_pool_area(struct device *dev, struct io_tlb_pool *pool
 	unsigned long max_slots = get_max_slots(boundary_mask);
 	unsigned int iotlb_align_mask = dma_get_min_align_mask(dev);
 	unsigned int nslots = nr_slots(alloc_size), stride;
-	unsigned int offset = swiotlb_align_offset(dev, 0, orig_addr);
+	unsigned long max_usable = pool->area_nslabs;
+	unsigned int offset;
 	unsigned int index, slots_checked, count = 0, i;
 	unsigned long flags;
 	unsigned int slot_base;
@@ -1061,6 +1111,13 @@ static int swiotlb_search_pool_area(struct device *dev, struct io_tlb_pool *pool
 	BUG_ON(!nslots);
 	BUG_ON(area_index >= pool->nareas);
 
+	if (IS_SWIOTLB_NOCOPY(orig_addr)) {
+		max_usable = (pool->area_nslabs * NOCOPY_ADDR_TO_PCT(orig_addr)) / 100;
+		orig_addr = 0;
+	}
+
+	offset = swiotlb_align_offset(dev, 0, orig_addr);
+
 	/*
 	 * Historically, swiotlb allocations >= PAGE_SIZE were guaranteed to be
 	 * page-aligned in the absence of any other alignment requirements.
@@ -1087,7 +1144,7 @@ static int swiotlb_search_pool_area(struct device *dev, struct io_tlb_pool *pool
 	stride = get_max_slots(max(alloc_align_mask, iotlb_align_mask));
 
 	spin_lock_irqsave(&area->lock, flags);
-	if (unlikely(nslots > pool->area_nslabs - area->used))
+	if (unlikely(area->used + nslots > max_usable))
 		goto not_found;
 
 	slot_base = area_index * pool->area_nslabs;
@@ -1164,6 +1221,9 @@ static int swiotlb_search_pool_area(struct device *dev, struct io_tlb_pool *pool
  * Search one memory area in all pools for a sequence of slots that match the
  * allocation constraints.
  *
+ * If IS_SWIOTLB_NOCOPY(orig_addr) is true, the search is restricted to only the
+ * default pool, which is what swiotlb_alloc_pages() is allowed to use.
+ *
  * Return: Index of the first allocated slot, or -1 on error.
  */
 static int swiotlb_search_area(struct device *dev, int start_cpu,
@@ -1177,6 +1237,9 @@ static int swiotlb_search_area(struct device *dev, int start_cpu,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pool, &mem->pools, node) {
+		/* Only search the default pool (first in mem->pools) for nocopy allocations. */
+		if (IS_SWIOTLB_NOCOPY(orig_addr) && pool != &mem->defpool)
+			break;
 		if (cpu_offset >= pool->nareas)
 			continue;
 		area_index = (start_cpu + cpu_offset) & (pool->nareas - 1);
@@ -1229,6 +1292,13 @@ static int swiotlb_find_slots(struct device *dev, phys_addr_t orig_addr,
 			goto found;
 	}
 
+	/*
+	 * Passing a nocopy orig_addr restricts the search to only the
+	 * default pool, so do not attempt dynamic pool expansion.
+	 */
+	if (IS_SWIOTLB_NOCOPY(orig_addr))
+		return -1;
+
 	if (!mem->can_grow)
 		return -1;
 
@@ -1468,11 +1538,16 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 	return tlb_addr;
 }
 
+/*
+ * called with dev == NULL from swiotlb_dealloc_pages(), in this case force offset
+ * and align_mask to 0, pad_slots is also 0, and assume the pages come from the
+ * default system pool.
+ */
 static void swiotlb_release_slots(struct device *dev, phys_addr_t tlb_addr,
 				  struct io_tlb_pool *mem)
 {
 	unsigned long flags;
-	unsigned int offset = swiotlb_align_offset(dev, 0, tlb_addr);
+	unsigned int offset = dev ? swiotlb_align_offset(dev, 0, tlb_addr) : 0;
 	int index, nslots, aindex;
 	struct io_tlb_area *area;
 	int count, i;
@@ -1506,6 +1581,7 @@ static void swiotlb_release_slots(struct device *dev, phys_addr_t tlb_addr,
 		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
 		mem->slots[i].alloc_size = 0;
 		mem->slots[i].pad_slots = 0;
+		mem->slots[i].flags = 0;
 	}
 
 	/*
@@ -1519,7 +1595,7 @@ static void swiotlb_release_slots(struct device *dev, phys_addr_t tlb_addr,
 	area->used -= nslots;
 	spin_unlock_irqrestore(&area->lock, flags);
 
-	dec_used(dev->dma_io_tlb_mem, nslots);
+	dec_used(dev ? dev->dma_io_tlb_mem : &io_tlb_default_mem, nslots);
 }
 
 #ifdef CONFIG_SWIOTLB_DYNAMIC
@@ -1912,3 +1988,100 @@ static const struct reserved_mem_ops rmem_swiotlb_ops = {
 
 RESERVEDMEM_OF_DECLARE(dma, "restricted-dma-pool", &rmem_swiotlb_ops);
 #endif /* CONFIG_DMA_RESTRICTED_POOL */
+
+static inline int swiotlb_nocopy_head_index(struct io_tlb_pool *pool, phys_addr_t phys)
+{
+	return (page_to_phys(compound_head(phys_to_page(phys))) - pool->start) >> IO_TLB_SHIFT;
+}
+
+/**
+ * swiotlb_dealloc_pages() - Actually release Nocopy slots and page metadata
+ * @pool:	SWIOTLB pool containing the buffer.
+ * @parent:	Slot index of the buffer head.
+ */
+static void swiotlb_dealloc_pages(struct io_tlb_pool *pool, unsigned int parent)
+{
+	unsigned int order = get_order(pool->slots[parent].alloc_size);
+	phys_addr_t paddr = pool->start + (parent << IO_TLB_SHIFT);
+	struct page *head = phys_to_page(paddr);
+
+	swiotlb_destroy_compound_page(head, order);
+	swiotlb_release_slots(NULL, paddr, pool);
+}
+
+struct page *swiotlb_alloc_pages(struct device *dev, unsigned int order,
+				 gfp_t gfp, unsigned int percent)
+{
+	struct io_tlb_pool *pool;
+	struct page *page;
+	int index, nslots, i;
+
+	if (WARN_ON_ONCE(!dev || !dev->dma_io_tlb_mem))
+		return NULL;
+
+	if (dev->dma_io_tlb_mem != &io_tlb_default_mem)
+		return NULL;
+
+	index = swiotlb_find_slots(dev, NOCOPY_PCT_TO_ADDR(percent),
+				   PAGE_SIZE << order, (PAGE_SIZE << order) - 1,
+				   &pool);
+	if (index < 0)
+		return NULL;
+
+	nslots = (PAGE_SIZE << order) >> IO_TLB_SHIFT;
+	page = phys_to_page(pool->start + (index << IO_TLB_SHIFT));
+	swiotlb_prep_compound_page(page, order);
+	for (i = 0; i < nslots; i++)
+		pool->slots[index + i].flags |= SWIOTLB_SLOT_NOCOPY;
+	atomic_set(&pool->slots[index].nocopy_refcnt, 1);
+	return page;
+}
+EXPORT_SYMBOL(swiotlb_alloc_pages);
+
+bool swiotlb_free_pages(struct page *page, unsigned int order)
+{
+	struct io_tlb_mem *mem = &io_tlb_default_mem;
+	struct io_tlb_pool *pool = &mem->defpool;
+	struct page *head = compound_head(page);
+	unsigned int parent;
+	phys_addr_t paddr;
+
+	paddr = page_to_phys(head);
+	if (paddr < pool->start || paddr >= pool->end)
+		return false;
+
+	parent = swiotlb_nocopy_head_index(pool, paddr);
+	if (!(pool->slots[parent].flags & SWIOTLB_SLOT_NOCOPY))
+		return false;
+
+	if (atomic_dec_and_test(&pool->slots[parent].nocopy_refcnt))
+		swiotlb_dealloc_pages(pool, parent);
+
+	return true;
+}
+EXPORT_SYMBOL(swiotlb_free_pages);
+
+void swiotlb_nocopy_inc_ref(struct io_tlb_pool *pool, phys_addr_t phys)
+{
+	int head_idx = swiotlb_nocopy_head_index(pool, phys);
+
+	atomic_inc(&pool->slots[head_idx].nocopy_refcnt);
+}
+EXPORT_SYMBOL(swiotlb_nocopy_inc_ref);
+
+void swiotlb_nocopy_dec_ref(struct io_tlb_pool *pool, phys_addr_t phys)
+{
+	int head_idx = swiotlb_nocopy_head_index(pool, phys);
+
+	if (atomic_dec_and_test(&pool->slots[head_idx].nocopy_refcnt))
+		swiotlb_dealloc_pages(pool, head_idx);
+}
+EXPORT_SYMBOL(swiotlb_nocopy_dec_ref);
+
+bool swiotlb_pool_is_nocopy(struct io_tlb_pool *pool, phys_addr_t paddr)
+{
+	int index = (paddr - pool->start) >> IO_TLB_SHIFT;
+
+	return pool->slots[index].flags & SWIOTLB_SLOT_NOCOPY;
+}
+EXPORT_SYMBOL_GPL(swiotlb_pool_is_nocopy);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 083cbcb5bddec..ea148562a76d0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -16,6 +16,7 @@
 
 #include <linux/stddef.h>
 #include <linux/mm.h>
+#include <linux/swiotlb.h>
 #include <linux/highmem.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
@@ -711,6 +712,56 @@ void prep_compound_page(struct page *page, unsigned int order)
 	prep_compound_head(page, order);
 }
 
+#ifdef CONFIG_SWIOTLB
+/*
+ * Prepare a SWIOTLB page (potentially compound).
+ *
+ * We explicitly initialize the head page refcount to 1 because recycled
+ * SWIOTLB pages might have a refcount of 0.
+ *
+ * If order > 0 (compound page), we must explicitly set all tail page
+ * refcounts to 0. This is because SWIOTLB pages might have a boot-default
+ * refcount of 1, but the core memory management subsystem expects tail pages
+ * of a compound page to have a refcount of 0.
+ */
+void swiotlb_prep_compound_page(struct page *page, unsigned int order)
+{
+	init_page_count(page);
+	if (order > 0) {
+		for (int i = 1; i < (1 << order); i++)
+			set_page_count(page + i, 0);
+		prep_compound_page(page, order);
+	}
+}
+
+/*
+ * Destroy a SWIOTLB compound page and restore page refcounts.
+ *
+ * When pages are returned to the SWIOTLB pool, we restore the refcount of
+ * all constituent pages (head and tails) to 1. This resets them to their
+ * clean boot-default state, ensuring they are ready for reuse either as
+ * individual order-0 pages or as part of a new compound allocation.
+ */
+void swiotlb_destroy_compound_page(struct page *page, unsigned int order)
+{
+	if (order > 0) {
+		struct folio *folio = (struct folio *)page;
+
+		__ClearPageHead(page);
+		page[1].flags.f &= ~PAGE_FLAGS_SECOND;
+#ifdef NR_PAGES_IN_LARGE_FOLIO
+		folio->_nr_pages = 0;
+#endif
+		for (int i = 1; i < (1 << order); i++) {
+			page[i].mapping = NULL;
+			clear_compound_head(&page[i]);
+			set_page_count(page + i, 1);
+		}
+	}
+	set_page_count(page, 1);
+}
+#endif /* CONFIG_SWIOTLB */
+
 static inline void set_buddy_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
-- 
2.55.0.766.g2966f0265a-goog


