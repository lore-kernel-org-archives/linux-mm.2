Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB2C8D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0DC6B00AB; Mon,  1 Dec 2025 12:49:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071816B00AD; Mon,  1 Dec 2025 12:49:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B576B00AE; Mon,  1 Dec 2025 12:49:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D30386B00AB
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:49:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9420A89342
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:49 +0000 (UTC)
X-FDA: 84171640098.07.BABEE66
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id E631880005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AMs6Gx5O;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glTf5l82CAyS34gmQNiiAmB1Y1gWQru3yGukP2BZCmM=;
	b=g02dA3R8/1NY7JveJBb4zJYOLd2Kr8NhMFdOkzHmDQcJT4bDPRsWEt3vXBK59U6pgRpzwt
	+YsczcgfTVyOoKsLemeCRrgailodQUmNq0mjxD1oJo20GHq7bp1InEYAIUnAH2PeDJrcHG
	55FMRUBCOHOTtHo9FLC5lW2a/9F7BrU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611388; a=rsa-sha256;
	cv=none;
	b=D4vjzG+GZVLLls+Y/FUTi78hvxr1stISJN7JRo3z5bfA2zWXpUkQ0FAOeMlQcFXvSWSVN2
	1zUt7AFGmKGXksck1ogOWAErPziQc70lN//SKAXbvZuCq53lmq5nxtH8MrTHMBWQOsW0iB
	ZC/FfE3z+YnVDTwWJv73GF6hMWzQlv8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AMs6Gx5O;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=glTf5l82CAyS34gmQNiiAmB1Y1gWQru3yGukP2BZCmM=;
	b=AMs6Gx5Oz0rKC37RLwlr1i0I+Ng8hS/SCsISOEL3+Uj2AB7dxEkdqe0AHSQ3ji67uL1opF
	8CVRHzgEUKZ7WG08R6rXh32lqAzPFLRfXbbSVu2LMlR37qodcfyXKtF0HBjs9dRwvna8db
	M6GYHtJOiZz5KCCQoGHatzxRMdWO1kU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-Dhv_RTf1NDGtLAt_24XNXw-1; Mon,
 01 Dec 2025 12:49:44 -0500
X-MC-Unique: Dhv_RTf1NDGtLAt_24XNXw-1
X-Mimecast-MFC-AGG-ID: Dhv_RTf1NDGtLAt_24XNXw_1764611375
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABA4A19560B0;
	Mon,  1 Dec 2025 17:49:35 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28E411800451;
	Mon,  1 Dec 2025 17:49:24 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v13 mm-new 13/16] khugepaged: Introduce mTHP collapse support
Date: Mon,  1 Dec 2025 10:46:24 -0700
Message-ID: <20251201174627.23295-14-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E631880005
X-Stat-Signature: tpmzi77qyr3ugihnkjhbxductj8isj9b
X-HE-Tag: 1764611387-484541
X-HE-Meta: U2FsdGVkX1/H/Qq+oyW3fcWp8/bHXVTQ5Fn0eVgxFdZ0Eg6RgwZHy4lE04SQuO7VvblcQSZdFK7iiKQqNoh6Pd873ar48MGZ2pz4CDH5tknTgq33zlHcdVReKzXKKRIHTQ0Ir8U7zyRIbBusXz6/Q/mtZ7x5oAAk906eatX66lDWjakYKkyRRtaHneUQpQL8bU7c0AP19cvHDKK5KQVQreinjTkPwmFicAiNlic4wcmTyPvecdBD8JCkMke7pZC8VTVBrXyco0eY1DeE8vnKdEMcIHSqmHZWNmsclPa/Zt5PxlBrW5cziNZ6Rjk7wOmRd8a5BUaOfKvGuJ84X8Pvcj4OPwDs6Be84jaabTPvkK4fHubceYhDS6iD+qxVv5aS3lxwD8E2mIzum83ifXSaHOqj91c68roQlJ5AEl0D/8KC3X+kyD/Cm+p8Zb4v9MVhIo0CHTahCfk2xmELX5uJ/rVzeery7xQvi5zsgWMc1cvmE+wSgMrpiieo60fmmVdwQ2hjYuYYbX1Yhr+T6S8efPuU7c5vadVo5aFQsylE4xHM5plxkwCZC26fVwS5b+UDKQ9zuMILhtAw0IUxI89t5W2IMzY5ER5z8AVjrVojIhXWKfejk/XBeSRT4qX5x6y8J61Avp2DnUGMEJezI1r0bXV+fW7fmHiv9Du01Ca4tT1TAh3fb21d2QjfefodCFnzT+D0+so9xB6oOBTk7pZqM+0MOLORTaHznv1jNdNHJx4t5ccvrIxnzFQL8ZH0wg5O3hZVDna2PYbHRGKSmDzMrQs1Vztu+HD8DrmFiHx6ytLVg0sUWS5TzQ22BjodnuKBbtkvThO3+H+z/t1CNC0mREkWyVxj/yZJ83geoOJtn8LtltMfiJ15xyD/QA6Uwk4YtQsUs1RGfVnnebHJIepUuoXNBMv2NhIdALAf6b9d6k17FZBSV50QkfTJLc4HvfR+I11xEAsV/mXyC3k13k8
 DqKqquNk
 jAMYVvuyT2NBg6MYl4cTR94PV8r2Dq3S3+vwMmqyY9NdDcmdmOlqBINxP9hpX3hw1sAa7ci1qteTR2LGbKFQEkCbElTihQxyEem+g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable khugepaged to collapse to mTHP orders. This patch implements the
main scanning logic using a bitmap to track occupied pages and a stack
structure that allows us to find optimal collapse sizes.

Previous to this patch, PMD collapse had 3 main phases, a light weight
scanning phase (mmap_read_lock) that determines a potential PMD
collapse, a alloc phase (mmap unlocked), then finally heavier collapse
phase (mmap_write_lock).

To enabled mTHP collapse we make the following changes:

During PMD scan phase, track occupied pages in a bitmap. When mTHP
orders are enabled, we remove the restriction of max_ptes_none during the
scan phase to avoid missing potential mTHP collapse candidates. Once we
have scanned the full PMD range and updated the bitmap to track occupied
pages, we use the bitmap to find the optimal mTHP size.

Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
and determine the best eligible order for the collapse. A stack structure
is used instead of traditional recursion to manage the search. The
algorithm recursively splits the bitmap into smaller chunks to find the
highest order mTHPs that satisfy the collapse criteria. We start by
attempting the PMD order, then moved on the consecutively lower orders
(mTHP collapse). The stack maintains a pair of variables (offset, order),
indicating the number of PTEs from the start of the PMD, and the order of
the potential collapse candidate.

The algorithm for consuming the bitmap works as such:
    1) push (0, HPAGE_PMD_ORDER) onto the stack
    2) pop the stack
    3) check if the number of set bits in that (offset,order) pair
       statisfy the max_ptes_none threshold for that order
    4) if yes, attempt collapse
    5) if no (or collapse fails), push two new stack items representing
       the left and right halves of the current bitmap range, at the
       next lower order
    6) repeat at step (2) until stack is empty.

Below is a diagram representing the algorithm and stack items:

                           offset       mid_offset
                            |         |
                            |         |
                            v         v
          ____________________________________
         |          PTE Page Table            |
         --------------------------------------
			    <-------><------->
                             order-1  order-1

We currently only support mTHP collapse for max_ptes_none values of 0
and HPAGE_PMD_NR - 1. resulting in the following behavior:

    - max_ptes_none=0: Never introduce new empty pages during collapse
    - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
      available mTHP order

Any other max_ptes_none value will emit a warning and skip mTHP collapse
attempts. There should be no behavior change for PMD collapse.

Once we determine what mTHP sizes fits best in that PMD range a collapse
is attempted. A minimum collapse order of 2 is used as this is the lowest
order supported by anon memory as defined by THP_ORDERS_ALL_ANON.

mTHP collapses reject regions containing swapped out or shared pages.
This is because adding new entries can lead to new none pages, and these
may lead to constant promotion into a higher order (m)THP. A similar
issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
introducing at least 2x the number of pages, and on a future scan will
satisfy the promotion condition once again. This issue is prevented via
the collapse_max_ptes_none() function which imposes the max_ptes_none
restrictions above.

Currently madv_collapse is not supported and will only attempt PMD
collapse.

We can also remove the check for is_khugepaged inside the PMD scan as
the collapse_max_ptes_none() function handles this logic now.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 183 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 175 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 33b70ca070b4..fcb927cd5456 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -92,6 +92,32 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+#define KHUGEPAGED_MIN_MTHP_ORDER	2
+/*
+ * The maximum number of mTHP ranges that can be stored on the stack.
+ * This is calculated based on the number of PTE entries in a PTE page table
+ * and the minimum mTHP order.
+ *
+ * ilog2(MAX_PTRS_PER_PTE) is log2 of the maximum number of PTE entries.
+ * This gives you the PMD_ORDER, and is needed in place of HPAGE_PMD_ORDER due
+ * to restrictions of some architectures (ie ppc64le).
+ *
+ * At most there will be 1 << (PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER) mTHP ranges
+ */
+#define MTHP_STACK_SIZE	(1UL << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
+
+/*
+ * Defines a range of PTE entries in a PTE page table which are being
+ * considered for (m)THP collapse.
+ *
+ * @offset: the offset of the first PTE entry in a PMD range.
+ * @order: the order of the PTE entries being considered for collapse.
+ */
+struct mthp_range {
+	u16 offset;
+	u8 order;
+};
+
 struct collapse_control {
 	bool is_khugepaged;
 
@@ -100,6 +126,11 @@ struct collapse_control {
 
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
+
+	/* bitmap used for mTHP collapse */
+	DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
+	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
+	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
 };
 
 /**
@@ -1375,6 +1406,121 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
 	return result;
 }
 
+static void mthp_stack_push(struct collapse_control *cc, int *stack_size,
+				   u16 offset, u8 order)
+{
+	const int size = *stack_size;
+	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
+
+	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
+	stack->order = order;
+	stack->offset = offset;
+	(*stack_size)++;
+}
+
+static struct mthp_range mthp_stack_pop(struct collapse_control *cc, int *stack_size)
+{
+	const int size = *stack_size;
+
+	VM_WARN_ON_ONCE(size <= 0);
+	(*stack_size)--;
+	return cc->mthp_bitmap_stack[size - 1];
+}
+
+static unsigned int mthp_nr_occupied_pte_entries(struct collapse_control *cc,
+						 u16 offset, unsigned long nr_pte_entries)
+{
+	bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
+	bitmap_set(cc->mthp_bitmap_mask, offset, nr_pte_entries);
+	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, HPAGE_PMD_NR);
+}
+
+/*
+ * mthp_collapse() consumes the bitmap that is generated during
+ * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
+ *
+ * Each bit in cc->mthp_bitmap represents a single occupied (!none/zero) page.
+ * A stack structure cc->mthp_bitmap_stack is used to check different regions
+ * of the bitmap for collapse eligibility. The stack maintains a pair of
+ * variables (offset, order), indicating the number of PTEs from the start of
+ * the PMD, and the order of the potential collapse candidate respectively. We
+ * start at the PMD order and check if it is eligible for collapse; if not, we
+ * add two entries to the stack at a lower order to represent the left and right
+ * halves of the PTE page table we are examining.
+ *
+ *                         offset       mid_offset
+ *                         |         |
+ *                         |         |
+ *                         v         v
+ *      --------------------------------------
+ *      |          cc->mthp_bitmap            |
+ *      --------------------------------------
+ *                         <-------><------->
+ *                          order-1  order-1
+ *
+ * For each of these, we determine how many PTE entries are occupied in the
+ * range of PTE entries we propose to collapse, then we compare this to a
+ * threshold number of PTE entries which would need to be occupied for a
+ * collapse to be permitted at that order (accounting for max_ptes_none).
+
+ * If a collapse is permitted, we attempt to collapse the PTE range into a
+ * mTHP.
+ */
+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
+		int referenced, int unmapped, struct collapse_control *cc,
+		bool *mmap_locked, unsigned long enabled_orders)
+{
+	unsigned int max_ptes_none, nr_occupied_ptes;
+	struct mthp_range range;
+	unsigned long collapse_address;
+	int collapsed = 0, stack_size = 0;
+	unsigned long nr_pte_entries;
+	u16 offset;
+	u8 order;
+
+	mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
+
+	while (stack_size > 0) {
+		range = mthp_stack_pop(cc, &stack_size);
+		order = range.order;
+		offset = range.offset;
+		nr_pte_entries = 1UL << order;
+
+		if (!test_bit(order, &enabled_orders))
+			goto next_order;
+
+		max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
+
+		if (max_ptes_none == -EINVAL)
+			return collapsed;
+
+		nr_occupied_ptes = mthp_nr_occupied_pte_entries(cc, offset, nr_pte_entries);
+
+		if (nr_occupied_ptes >= nr_pte_entries - max_ptes_none) {
+			int ret;
+
+			collapse_address = address + offset * PAGE_SIZE;
+			ret = collapse_huge_page(mm, collapse_address, referenced,
+						 unmapped, cc, mmap_locked,
+						 order);
+			if (ret == SCAN_SUCCEED) {
+				collapsed += nr_pte_entries;
+				continue;
+			}
+		}
+
+next_order:
+		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
+			const u8 next_order = order - 1;
+			const u16 mid_offset = offset + (nr_pte_entries / 2);
+
+			mthp_stack_push(cc, &stack_size, mid_offset, next_order);
+			mthp_stack_push(cc, &stack_size, offset, next_order);
+		}
+	}
+	return collapsed;
+}
+
 static int collapse_scan_pmd(struct mm_struct *mm,
 			     struct vm_area_struct *vma,
 			     unsigned long start_addr, bool *mmap_locked,
@@ -1382,11 +1528,15 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
+	int i;
 	int result = SCAN_FAIL, referenced = 0;
-	int none_or_zero = 0, shared = 0;
+	int none_or_zero = 0, shared = 0, nr_collapsed = 0;
 	struct page *page = NULL;
+	unsigned int max_ptes_none;
 	struct folio *folio = NULL;
 	unsigned long addr;
+	unsigned long enabled_orders;
+	bool full_scan = true;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
@@ -1396,22 +1546,34 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+
+	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, cc->is_khugepaged);
+
+	/*
+	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
+	 * scan all pages to populate the bitmap for mTHP collapse.
+	 */
+	if (cc->is_khugepaged && enabled_orders == BIT(HPAGE_PMD_ORDER))
+		full_scan = false;
+	max_ptes_none = collapse_max_ptes_none(HPAGE_PMD_ORDER, full_scan);
+
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
-	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, addr += PAGE_SIZE) {
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		_pte = pte + i;
+		addr = start_addr + i * PAGE_SIZE;
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			    none_or_zero <= max_ptes_none) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1479,6 +1641,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 			}
 		}
 
+		/* Set bit for occupied pages */
+		bitmap_set(cc->mthp_bitmap, i, 1);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
@@ -1535,9 +1699,12 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_huge_page(mm, start_addr, referenced,
-					    unmapped, cc, mmap_locked,
-					    HPAGE_PMD_ORDER);
+		nr_collapsed = mthp_collapse(mm, start_addr, referenced, unmapped,
+					      cc, mmap_locked, enabled_orders);
+		if (nr_collapsed > 0)
+			result = SCAN_SUCCEED;
+		else
+			result = SCAN_FAIL;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-- 
2.51.1


