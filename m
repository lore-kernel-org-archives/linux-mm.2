Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF995C79F9F
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B586B00B3; Mon,  7 Sep 2026 23:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73FA6B00B4; Mon,  7 Sep 2026 23:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89D46B00B5; Mon,  7 Sep 2026 23:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A51456B00B3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3828880350
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:12 +0000 (UTC)
X-FDA: 85189101144.27.4E4B12F
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E67B180003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W12vkdWl;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836650;
	b=snHWmecKmyOXwSHowP99Ix9WEUIZYknBb4eox9D2YvvULhIDhsYdYHmnfENHZTHWbXgjq8
	jsT952Xyr7u9v/jnNM7Rw2/hjlm2Scm2oCB1tQVWoqLT2NcXV84NRxn5gdZtvNsWRmx/VY
	3o3YowPtJAo2LJLLFH1KrsNJmQWgtkc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W12vkdWl;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ftmCWznJ9sK2TfrzbteNQ0qTXPtrb89VSG1QYG+6OE=;
	b=Mu5TnckFVgyPIxoCREUi3347+xHuTcwpQGSk6XUekvi9bGwMB8H9dU+hrILgI28EFHiwWC
	pfBUUOhqb6pfICATkm39/p0tUL2UONcraktbx3hzZuvQ9yB7jNDma37QQpu/q7SESDvaxZ
	HS+9oxi4FqKZuu+sUH23X8vtu9CjjYM=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8541875f596so1579926b3a.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836648; x=1789441448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8ftmCWznJ9sK2TfrzbteNQ0qTXPtrb89VSG1QYG+6OE=;
        b=W12vkdWl3Rh29WuXTj6fbVdN3SuA8nYomhNuj0OWh+CCnCQW1QF3SPegDZq1vTysR+
         m3Xzdi2rmpAKyi1LXaTbmzjyA3sKY7VT5VDJehE6YLAfQ6pPwE2Ml/qpCXkCM4uY41SF
         8MW14p3p6fXj/9zzywFx3XoLrwgDC/wuzFoamhOF4sg28HDhGcQCIjzAC4u+SX3EGlyX
         bcTuRJuCgGsjV1eD+gSHhrzSOZZNGFm383LzL+B1MpaSRDTv8aQ1pXZ3uTtvyvSKg+Kv
         rkuFTJ2VcahaMT+hfJ9UGlQYDxoWY8K2qFuYRVBXl+mOCgJ5lZLNtxfpRGMgBUUs5Hpn
         FQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836648; x=1789441448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8ftmCWznJ9sK2TfrzbteNQ0qTXPtrb89VSG1QYG+6OE=;
        b=Z/MF0PI1Z8aLpSNizqOM/bZjjUehh992RfMIgOaCUwre7Y7pdyoYy5gvkzqCgkRNif
         xm9pmifRFn75qX2X9QkkD0sAjTNTMIJvSg/kVQLYIMH9FBsAFRDU8t1hbfq+o5GMEp7M
         P4gK9fc/2e56dVudCqpf9gMJVSaQcE7bo9WLPThemIBuBrDOPJ9Hqf2cLwjq4dkNb7R7
         GChIU6x5x2/UiXNBVSwZd72KQUnbVOjzQZshEvzSt38XtvIoOkw4IP5yfdyHnRhrZGs1
         Q8dweLFUasl6F0RkzMfJ6ORytLsK/Ej4aVkNvZt90P6+eqvfx3upcMNu7V/+uG4h1wGK
         kdPQ==
X-Gm-Message-State: AFuF++nRdXoEpHhgLKAmc/jiOvu9asZv8eA7EbHNhRJryFVdmhCR6XOS
	dEJTCUVgNJOFg4shFjtwfdLzP4VMFRXymuHP4q99tV56r1mpwKLrRyq9DYurfEMh5d4=
X-Gm-Gg: AYBFou1IJo5rd5RDdpRfQc/Im9liH+BgYSBl4hcz2DdX9nOj9InfESRfSHsRxTV+8td
	A0n/b5aNItzgDsMM92xOSdO0JOofOkrJSgxcOksjzMD4JrYXXr6P9yCWI1n4HDH1B69RBZ1oIhO
	sTRLo0SvLV5vY4JTW4jxRdfqHgpnppdBFnsDAZzUfdY3GZQ0R5tBdMigNbdg4uE9RO3h31xqTbZ
	46ZHRaRBOVHkgAu7wdFrOV1me27iTF4rCa57nf166W6P0RnL+0/TiqgP4tPVq+VLVRSAAgqlbAm
	ynSYH8Aov5WYF8C+Kh1kVjX+rfw52gfDbrfKv7Aey7qP0G8K2/aW+3XKGqnpyzTDhvHH2dMpTUV
	NM+oTf7VqZlIF6hJVnuorDJtOSBPDr6kEnHvKrymnLuSGbErH/UdV9xt6+ry+mbJYJ1Ds/jd3cG
	YHtgNrYIacfwbpD2TWFYeLjJK6BRYJ0vCE3CJeNf47q1AeDXzYmcqj4eg5bvO0/QK5QCCHO+466
	TpMZRxZGm0o2ekIOHQ8hjYu
X-Received: by 2002:a05:6a00:98b:b0:842:2419:6c0b with SMTP id d2e1a72fcca58-86169c71e5cmr35224717b3a.10.1788836647750;
        Mon, 07 Sep 2026 20:04:07 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:07 -0700 (PDT)
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
Subject: [PATCH v2 02/11] mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
Date: Tue,  8 Sep 2026 11:03:26 +0800
Message-ID: <20260908030335.96549-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0E67B180003
X-Stat-Signature: 47c6oy4bck9pqczoweuqhwo7idx158df
X-HE-Tag: 1788836648-231520
X-HE-Meta: U2FsdGVkX19xNMAjP0MrWiPOGTXbEZMlV7PjGlCfoxRwPBVfvJTiBlKSlP4yMB8Rcj00JwY1jOJCqiY9tmn2+Z+Ui2JJomzeZgY0zzks5dgs6Yc3ULtP4lhTynfa0l6BbMzV+YzKpBbw0KbMQI0kW/Pf6SSJR7SEsN5S8HffZL8pyngY58KIuH7esoiK01UV6WxF+diUIeNFnrgfaNRKzaA+fo2ctlC9bkwGI9tAhCvfFK21FxY/NU4ELLYFa20LeRj+M8Rz6b4LCRcKQtQb0Y/nDK9YFNgGob1j+vQnzhdroJMBufgGIgXpHv/iQighRqnbM9+rbAFs+TSwKuwe2flXNBHX4tLVk8Hu4EGbj5RNGGGDYkWumKE3bu6SkU+fCTRJlRLjs7BDmEzV6/btZybedJMD3foRe7YujJQP7L+CxinVcHNknN7qTmZIEyR5sajnfDk/YpV1V9ZFFIsJMiajDoxn31wES5DLu2mGhbsxwwxrbjdnWxFM1sEcKmeyGycdaQ1bsFotZ1LTAXIrAn1bd/l0xPJkXwA9sx1T9DkbLPT0X1D3YZn7HyyjdigDtJHH1fuBIe/eCKdJcVQvCyDhPhF12N4cUSEKm2UhI+BFF5HbskXOSyQEL25UAx//fbswhqWBW/wDqlCEhw/ToEQd4UfaxyZRUDyJ0MXb4/rTnapZPX3JprzUXcGiSqhhjqySwWnPgjbkLtlv2eusUjLp7sshPtWxG+khGbikzYZsZrMa46tsfcBefVuJdQf3KrBj1tssqJjGd8GSYkyTQKM9ITLCZy2DeP1YVeCFF98VGmky7N0IN61waD6XgjcUGY2/RZ7J9JXNp92p9NsHMM9Myw6H0abXUWb2DA4Y0ww4pthv/WwMnloJ861x/5TICnaQ6VBO2G/0oVAQoyQrQJ9IvQberALYZKgoDRdzKPmRKJUJY0CzByfe4YjVTY2XY4JrebCKpVIbqxiWHiA
 GRcB0dnr
 UgeW81EZGhZTWTYgyPkT3SFVIoHUtQmjCzDJd7cS2zPbfZoocxh4vdI9vWLiZpl40v4t8Sjb5nlPrPizzaPz1qMp6KIbyNGu3vMX3OmYVa8PPHNZMloCGUGM+u+uYfu2Xe7N92FWnhuhYK6QnbzsYvDmcGp46gQznujfLzCv8RbplACbh2QpYfwl2AXvRGRCejVhsFSqoyI8U9qKmvIK8x1hvfQ9q/Q9MbK0jPvfs4kB8Z1WOExAj2Hp0kbX2AUQCjR4mxBBDCQNqS6Ag0aIB71pDEfGIK2CegUo9vgrQXC40gmuFD0N4dch00w==
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
index e9b54ea0eff0..d3778ba976a5 100644
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
index eb339c4a71f4..4a57e6c3352c 100644
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
index e62e6aa07f12..70143dd8b579 100644
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
index b408d15baf7b..59b825df83b9 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -139,6 +139,7 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 void sparse_init_subsection_map(void);
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-- 
2.54.0


