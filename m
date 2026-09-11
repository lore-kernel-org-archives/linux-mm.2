Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91222C88E42
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78E16B0093; Fri, 11 Sep 2026 01:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4FFC6B0095; Fri, 11 Sep 2026 01:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F806B0096; Fri, 11 Sep 2026 01:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 619756B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:03:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE0CDA0765
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:41 +0000 (UTC)
X-FDA: 85200288642.17.89647AD
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id A8C41180002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IwXVaFmx;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103018;
	b=Kqe3ZvWR3Dik9+HVgjq/svPoVkv2aWPZK2sTlmIzt3of/8hqpUh0TBsA873vGxlMCnyqsG
	WR8oWLOfHC+3Edy/j+51ZpziZiHgCFsubhArIOVaG8s0MEl76hSDl8gKzKg19IrMZThayb
	l8pS/5f+SsdwWnmVfUTzEYdq5RUiISE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IwXVaFmx;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bR1GMYxjFGrp68HZ8kexJBvgYVBJednZ0YGt4vUS+s=;
	b=gdjup8iVn2Ykp8sYlZVwm3ZsX4zTvWT1gGjfAjVhYea3EYp8GZHLgkh+FE+ok6iqNehZjU
	LDJGiR2RE6XKOZz23g1HKnjgQ1bF3c8YsZ7ObMau39DNjzi2yYcVGsT7db3EII9YAbWKSj
	glF+cgabhB1SF4rzleYUB26a5LdZ+wc=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4afso548399a12.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103016; x=1789707816; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6bR1GMYxjFGrp68HZ8kexJBvgYVBJednZ0YGt4vUS+s=;
        b=IwXVaFmxYljarDPoYsjSzXfSrn/OZs92YevtL7VDaRhs5J3YCi86jMOSmI9MEE6Zxp
         cEimhP3oUlo2Fm2lY84Cb84M6y3tGEVO3lJQGXWPpuk6PijjQbGcMqjXqx5Kv1MSFYDm
         nw0X8q+qlu/ZMqyZj3sYQmC7XpxQ+G777nJ0k+GB9S/WyYM9kauJiqkc1jn6IcmGVypY
         N9lsLWsN/Mfv7Pw2N0t196f8jKkp49rkHmcpkndhaplLed3QhXfjUpNVjrZP0xsa+w1V
         kmCt+vLbjWh9MIBLgaxBl/qLbSs8fz4FzK819f4o3koKhCFawit92zPQk1mtPHLqofdp
         AfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103016; x=1789707816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6bR1GMYxjFGrp68HZ8kexJBvgYVBJednZ0YGt4vUS+s=;
        b=QhZXI5qi+yp/+wFc8OSqE+wqM9c5qMb4zo0r1vcF/x2JK2vxd6k06GCV9HHQfECMAd
         muEdOPTOMq7w0+E89gUbUBq/ScuqRm36cy5fbQj1SSgUpwD9Q6OOdQfkAu864rOlk2Ww
         MHXEhH9AZ8HBQl7J0euY/V0FRTDphd0QMgIwzhVteNoia5ER5aI/FsIdxwCe1YpJP28d
         Q5ScQbMiotqD2HM9lNtqPYNHvgakc92b6by2Jas976QmqGbTbF4xUfRqW/jd8447h/+g
         jQCNx5EwwpB/RzRpZURl7AfP7u6a7xRVjQ+OKILj18TfMi+aKNQ6nrJpn3y9lWtNsIYu
         zFGw==
X-Gm-Message-State: AFuF++lhpFjL3xvHTI0O6OJQdDQsa/tXB228qFPMc+kOkr+6BuFv72NX
	kuff+TSw51zz4rJdhLs0vTGUsIKMGYvAaayh/2VwrsI/gLmx6t+vZalFyrgsDv76vs8=
X-Gm-Gg: AYBFou0+B5SYDqmiXEzIgJ3rPci1b96m/N2aeS3ZNaUzChb6lgqvdtXzvqUWAVAQwj8
	O4+xq5TTkDLs1GT+sdo6YHc/yycAk6bapbRhlJQOIFTJj5bOQjcngIU+YfOHYjmiKwXyFnW+S+r
	rQji4yxcsjlDRAnmIxHoDVnrhCuhiq5zTwPH6lgiYrmbmix7wNX8QfyiJLxOYefJH6QzJtZbvBl
	+8Ur04jmYj43IloBVD4bXglb04II6dC+Y72E7UbuE99PaD/I8NPzVaqpHKvw1H1EinPvYDydj0b
	ujhShXxABj142yLTQ1YMv5NY422MB/h22Xnh1dNHyhYsuDL5s4cao+tydxWbOOCNplXzvJzVnBF
	lKGZIS22zV16ldSSActP/+qOaeIinL2lYRK2rTjbut1ksnIRsJDlmUVAEFdID8GiWkI+Ej3CDds
	1VPfr6PJrb799EEl7nCoY3FBEowXLx/+TsCk73MGMCH+5W/YV3kYR/qpdMjlqGVmLW1maz+7gWF
	NAvFdayoLdKn+EeyPj1C74sR0fk3u5ilmZKRw==
X-Received: by 2002:a17:90b:48c7:b0:398:9be8:ea66 with SMTP id 98e67ed59e1d1-39d9c226c4dmr4442740a91.19.1789103016270;
        Thu, 10 Sep 2026 22:03:36 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.03.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:03:35 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 02/11] mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
Date: Fri, 11 Sep 2026 13:02:19 +0800
Message-ID: <20260911050228.58884-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8C41180002
X-Stat-Signature: bduuu8ji49an7q3zocqgo1gon5c6jyu1
X-Rspam-User: 
X-HE-Tag: 1789103017-654163
X-HE-Meta: U2FsdGVkX1+HCW6EHsSUgY3fuzp0pDsCljFcZY0RBzCY/AJ3kyJQ4AtLZeb29jKaqJcOBWkiFrebuf9hol4WJTF3vXlFqrPzRx/eMzpSE9MlsQYd/Hprz0kiMirehHsku11dt4pkEuq2qqkszZv+eOkfMHL103QV0Mq1gAUNVoPh2ewwoxUh3agl+dX+UNv40SDAebt6GgFh6j58WEBEMANB8ekeYVOuFuIqF++H1G2Bq0RZgak4kcRwC+H1gCw1r1HnSzbH1MWyh9sEHqv/zY3NmLYpbvsIm9XYPUVWyWW0Sg7+BuxIWo95UYA9k11fy7Z3ta+mcmTBOGCg2wvM6xvJMIk8R1eG+1akUJXyjAaQwU6p6UkAaYbrDEtvmb2Luhbndrk+SCbFUljJKeUPC2FLjaegpssUQE/TAoypLafKMY2YKYoRTahKY0BqvpcM6qiPK8iMBkMHaKGhS+Ok2JpRfQnof3ngqx1AJuF8c5NyEwEUSBU7fO8HfDEejL47uhm5OeZDgFQtnjwK3ZU70N9GmxN8KnxDzIDO10vyYJ1wLz/qPDDGYrMHr6ksikFqW3/kdTOWvwNAGVhb32+LKWmJLoHVl9H15unwi2YpxWr3lnhNjYmnCaoWQIr9iJGl+A2YFt2aMJYdnXat5rsvIfFrc9QL5/ycqTJjcTohRvjA0/Ge7+NPtlfD1nhKorTqjHww3Yz4sNk8WPR9Dg27TPlgiyX99WPh6WDQPj5P3Dg468AreVdholbh37p4ElmS+03yUSIN2mJrwHvq3sEw7DGDh7DCc9Xox5/K6p0NwGyDmw3egc2KHR/evTSEJZ5ZMDwKvoXdu2pcoS/TDKqRsvMkBAoSE1FTqSBFT18dXYhzh5uN4FXNurGrygFEnyFWPBqHgKOPPQMJIqhI4WTi7fKtBcQ8XGfR8dFDaZzD08+fX6JhcMTdG1g776KH4WwPWgtlqWqXxi7QmAZDGt5
 bOuCYcXO
 IqrpmTjjTHiPY0n3mWYUZwvZLgx19XUster7coq/nAdhFy42TYqMFj7O32Qk5ZrKJRh7jE9vTqzFB1Ai9brcczAXKG/IqYcqEAAOmSvgvhOdn4dq9/ASSeHqEfALvlkY6ECSj/l670h76GNVYDIBJnaRLHoLhUzsGJ20uhPwsJYOQwadUyZwapAjHWspNbk6HOfSGFI16H6jg/1khYnHBGkJM532eFA7pKe6qrDb14fJCn5Ws/huo/zKlF3NKErg4aLzGNrGl5l5EWInqSwDxAq3zhrMMV8pZ4HC1ISAI8hpvH3706LnViGyQSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB and sparse-vmemmap each have their own helper to allocate the
shared vmemmap tail page used by vmemmap optimization.

Factor that logic into a common vmemmap_shared_tail_page() helper. It
allocates the page through vmemmap_alloc_block(), and uses cmpxchg()
to install the per-zone shared page.

Expose zone->vmemmap_tails under CONFIG_SPARSEMEM_VMEMMAP to match the
shared helper's build condition. This avoids a
!CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION stub; when optimization is
disabled, the array has no entries and the compiler folds away the unused
paths, so no storage or runtime overhead is added.

This removes duplicate allocation logic while still handling both the
early boot and runtime paths through the same helper.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Acked-by from Qi Zheng
---
 include/linux/mmzone.h |  2 +-
 mm/hugetlb_vmemmap.c   | 28 +---------------
 mm/sparse-vmemmap.c    | 74 +++++++++++++++++-------------------------
 mm/sparse.h            |  1 +
 4 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 97511f651ebc..1a18c1c40c8c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1156,7 +1156,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index f977d0a7e002..5ddf06b83c96 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -493,32 +493,6 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
-static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	struct page *tail, *p;
-	int node = zone_to_nid(zone);
-
-	tail = READ_ONCE(zone->vmemmap_tails[idx]);
-	if (likely(tail))
-		return tail;
-
-	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
-	if (!tail)
-		return NULL;
-
-	p = page_to_virt(tail);
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, tail)) {
-		__free_page(tail);
-		tail = READ_ONCE(zone->vmemmap_tails[idx]);
-	}
-
-	return tail;
-}
-
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
@@ -535,7 +509,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_get_tail(h->order, folio_zone(folio));
+	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f22d815d7af0..7388a5b5cce3 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -42,27 +42,13 @@
 #include "mm_init.h"
 #include "sparse.h"
 
-/*
- * Allocate a block of memory to be used to back the virtual memory map
- * or to back the page tables that are used to create the mapping.
- * Uses the main allocators if they are available, else bootmem.
- */
-
-static void * __ref __earlyonly_bootmem_alloc(int node,
-				unsigned long size,
-				unsigned long align,
-				unsigned long goal)
-{
-	return memmap_alloc(size, align, goal, node, false);
-}
-
-void * __meminit vmemmap_alloc_block(unsigned long size, int node)
+void __ref *vmemmap_alloc_block(unsigned long size, int node)
 {
 	/* If the main allocator is up use that, fallback to bootmem. */
 	if (slab_is_available()) {
 		gfp_t gfp_mask = GFP_KERNEL|__GFP_RETRY_MAYFAIL|__GFP_NOWARN;
 		int order = get_order(size);
-		static bool warned __meminitdata;
+		static bool warned;
 		struct page *page;
 
 		page = alloc_pages_node(node, gfp_mask, order);
@@ -76,8 +62,7 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 		}
 		return NULL;
 	} else
-		return __earlyonly_bootmem_alloc(node, size, size,
-				__pa(MAX_DMA_ADDRESS));
+		return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node, false);
 }
 
 static void * __meminit altmap_alloc_block_buf(unsigned long size,
@@ -184,39 +169,40 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 	return p;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
+	void *addr;
+	struct page *page;
+	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 
-	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(zone->vmemmap_tails)))
 		return NULL;
 
-	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
+	page = READ_ONCE(zone->vmemmap_tails[idx]);
+	if (likely(page))
+		return page;
+
+	addr = vmemmap_alloc_block(PAGE_SIZE, zone_to_nid(zone));
+	if (!addr)
 		return NULL;
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
 
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
+		page = (struct page *)addr + i;
+		mm_zero_struct_page(page);
+		init_compound_tail(page, NULL, order, zone);
+	}
 
-	return tail;
-}
-#else
-static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	return NULL;
+	page = virt_to_page(addr);
+	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
+		if (slab_is_available())
+			__free_page(page);
+		else
+			memblock_free(addr, PAGE_SIZE);
+		page = READ_ONCE(zone->vmemmap_tails[idx]);
+	}
+
+	return page;
 }
-#endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 					 struct vmem_altmap *altmap)
@@ -229,7 +215,7 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
-	page = vmemmap_get_tail(order, zone);
+	page = vmemmap_shared_tail_page(order, zone);
 	if (!page)
 		return NULL;
 
diff --git a/mm/sparse.h b/mm/sparse.h
index 3151d4db7575..a250bea4088e 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -142,6 +142,7 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 void sparse_init_subsection_map(void);
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-- 
2.54.0


