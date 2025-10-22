Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BFE2CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECB3E8E001E; Wed, 22 Oct 2025 14:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4A48E0010; Wed, 22 Oct 2025 14:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9008E001E; Wed, 22 Oct 2025 14:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC37D8E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:40:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96389160920
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:34 +0000 (UTC)
X-FDA: 84026615988.02.E6A6519
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id BF793C000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T2+OvRSv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3ZsOk6Qv0bjTB35AF2OrVFizGo8sQ76q7dZHgplu7A=;
	b=uH+Ml49jBeW9XsaKU3rGrFGUeR86nsPdEE4u+OqdHNb3xpYbpvFiYIZ2HoIYHiztRB7VgS
	8O8WqFAFfPuiPn1QdfT618kqYsJLYGO88hzWMPjSVS8nbA3xE/H3Ncl2ZYe//PdRIgu2Ec
	lljUmqFPNY1BwrgKOFlEe8AE6Z34/Rk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158432; a=rsa-sha256;
	cv=none;
	b=3669gxjZomuX1J7DFkFceSerkDNq8nvxUGfw+/7i1o3FXJxCG1CLbTuhHB6V3AWg8XJqQi
	CYa+MyhiZjqrjFc38tP23DjaaW5PsQyVrY3Xn+p7Obo4Vgy2FqypXY6cJZzDPF3o/ZrkDb
	o6w0b6yRDtK3sjujTbO93F5/vOjy+to=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T2+OvRSv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H3ZsOk6Qv0bjTB35AF2OrVFizGo8sQ76q7dZHgplu7A=;
	b=T2+OvRSvJVHtEG8PPVIMDaRWPSRr3tElj9hjReC3rf8MSWASJ0K1ZvAiUPo2TaTfegVliV
	12HV2nXD4Y9vAxSl8JThAZEF/xpRW1dWTXHxRO2j6oWqkM6ibyql0zQ12tTG4GIFNSaLBC
	C5FfqbneSwZ0Eyl0g28F+WDUeME4ZPM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-7lsRCxfOPCWrq7sQaKqWgg-1; Wed,
 22 Oct 2025 14:40:26 -0400
X-MC-Unique: 7lsRCxfOPCWrq7sQaKqWgg-1
X-Mimecast-MFC-AGG-ID: 7lsRCxfOPCWrq7sQaKqWgg_1761158421
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65B64195608E;
	Wed, 22 Oct 2025 18:40:21 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8740A19560A2;
	Wed, 22 Oct 2025 18:40:11 +0000 (UTC)
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
Subject: [PATCH v12 mm-new 12/15] khugepaged: Introduce mTHP collapse support
Date: Wed, 22 Oct 2025 12:37:14 -0600
Message-ID: <20251022183717.70829-13-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam01
X-Stat-Signature: tznwi5mjp36nya9rb3od7zj4g35ziume
X-Rspam-User: 
X-Rspamd-Queue-Id: BF793C000F
X-HE-Tag: 1761158432-159651
X-HE-Meta: U2FsdGVkX1+kH6d4pSiaHd9M0KSiSiJCm1TfLra/SQA+GZf1D6mgCx/J7CH84nmjEYGsQLSk26rsylkKZDkiAeqmwurKrq4Kez6uf+bOLgOSln2lbAd898OqnPalqbvx6zvK/G7TvouOrno5Xx3gCDWuphGDdBk24nPzMnlq2tq5fyldqhxISH4oEmkUo9VRN87LUAIKsM+AC2jDOdvNlxV2sjLMMQSrxdjaEi250W/Dw4f0G0KxoBCqLP/Z9J50tQnNnEX+qkQPEeGlDyn4vpQGLfZ4XYJqeF5QhMkhC0ehtPuqKK1BZScX7quAPZa/bfBfY6O2TFKNfdANzPabW8jQUglGPIjlGYbeU0MStMeXCDdHugCsjc6LsJ+SRol291tCyCOXRza4Z9Ij4gw9CqNkK8k2D9cyBkpWujmMr0R9l+zrw9WjzMwqDOUfT2vs4WktQnCxeF9qZukjefca9irGujRKULKsjVS45vI7QWfnBhb6HBY8SaChiCSDmGfzpjj7GKwiQtRxLmC/bWxJmKpCTjgMgjCtCVLO0a9i9HsgutX5QxTgb8duBBwOx1B5k4NBFG+Pd3mpyh6wBeVDiVUAlAlyMmFIWJ/BcGNggHRdqhtyGy6DsH1UB5UCPumnZJKCEQzePkkWfXJB7Pv2FaVt6kZNNMuhXbGGtT1jz7W3SQYze/FZpFJlYuOUjTjFgdl2AhWkhIt2njpSdHZ+RnQwUaMBuU6WMxuo4aQiVMnypUUESmiouvplHxZmhc51KHAtp4a2J1Rq6UrFO3w9hou2l18OF3FkNo+6yuhS0OdRJn7YC0wNIX9tPd9FMniz2e0t2thdVjr/OCB/ZSL+GHlzop4YwGHQqfhfyFHo3VQ6LjDGx3VTNpW37/1IwnjMwX51b1X8DCiTCmv/oy/IXmPmnmKwiKz255f8+LIorbvgLk4dkTSHmMY9RTgo12yEbs8Qj/HVWJxJNzlJU+c
 m6EVhQyH
 m0vzatbZeZ/eNKaSL0rKSJ+ilerHrlnUjT3FdDauzRcyQIzRqSyOs9LUfWkQoUT4eof8osUH/W9oa/c3dfcx8buOL9aWkEB7uuaxG10fgE2Y1pq6y76wgjdolD8k2Kf2HKim5Fv6o0bppokJJLxBs/z4Epp5S8AzLyiqIXUrIQJHp1U5CLrmIS62c+cksa5JBjZOEpQ7tnrDJjmcVX3V3B4jEEeX5oPVS3mIsMhbsRXG+y4ZdjRlMrPCvEBeCs9Gggo686js8KOyfiuTKp3SEIF/Y8ztW5ecoHB8gAK0tpO7gNiWb4A7Dj3rxCV135V08Tku7T2DEBPOn0iBvKfmhGP5+aqhK6yt7ufHzIjGa0dGFaKCp7r8NkggFCzw0L3iuAcDnY3Z1w1JmC7CNCSJjcphGvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During PMD range scanning, track occupied pages in a bitmap. If mTHPs are
enabled we remove the restriction of max_ptes_none during the scan phase
to avoid missing potential mTHP candidates.

Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
and determine the best eligible order for the collapse. A stack struct is
used instead of traditional recursion. The algorithm splits the bitmap
into smaller chunks to find the best fit mTHP.  max_ptes_none is scaled by
the attempted collapse order to determine how "full" an order must be
before being considered for collapse.

Once we determine what mTHP sizes fits best in that PMD range a collapse
is attempted. A minimum collapse order of 2 is used as this is the lowest
order supported by anon memory.

mTHP collapses reject regions containing swapped out or shared pages.
This is because adding new entries can lead to new none pages, and these
may lead to constant promotion into a higher order (m)THP. A similar
issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
introducing at least 2x the number of pages, and on a future scan will
satisfy the promotion condition once again. This issue is prevented via
the collapse_allowable_orders() function.

Currently madv_collapse is not supported and will only attempt PMD
collapse.

We can also remove the check for is_khugepaged inside the PMD scan as
the collapse_max_ptes_none() function handles this logic now.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/khugepaged.h |   2 +
 mm/khugepaged.c            | 128 ++++++++++++++++++++++++++++++++++---
 2 files changed, 122 insertions(+), 8 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index eb1946a70cff..179ce716e769 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_KHUGEPAGED_H
 #define _LINUX_KHUGEPAGED_H
+#define KHUGEPAGED_MIN_MTHP_ORDER	2
+#define MAX_MTHP_BITMAP_STACK	(1UL << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
 
 #include <linux/mm.h>
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 89a105124790..e2319bfd0065 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -93,6 +93,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+struct scan_bit_state {
+	u8 order;
+	u16 offset;
+};
+
 struct collapse_control {
 	bool is_khugepaged;
 
@@ -101,6 +106,13 @@ struct collapse_control {
 
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
+
+	/*
+	 * bitmap used to collapse mTHP sizes.
+	 */
+	 DECLARE_BITMAP(mthp_bitmap, HPAGE_PMD_NR);
+	 DECLARE_BITMAP(mthp_bitmap_mask, HPAGE_PMD_NR);
+	struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_STACK];
 };
 
 /**
@@ -1357,6 +1369,85 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_address,
 	return result;
 }
 
+static void push_mthp_bitmap_stack(struct collapse_control *cc, int *top,
+				   u8 order, u16 offset)
+{
+	cc->mthp_bitmap_stack[++*top] = (struct scan_bit_state)
+		{ order, offset };
+}
+
+/*
+ * collapse_scan_bitmap() consumes the bitmap that is generated during
+ * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
+ *
+ * Each bit in the bitmap represents a single occupied (!none/zero) page.
+ * A stack structure cc->mthp_bitmap_stack is used to check different regions
+ * of the bitmap for collapse eligibility. We start at the PMD order and
+ * check if it is eligible for collapse; if not, we add two entries to the
+ * stack at a lower order to represent the left and right halves of the region.
+ *
+ * For each region, we calculate the number of set bits and compare it
+ * against a threshold derived from collapse_max_ptes_none(). A region is
+ * eligible if the number of set bits exceeds this threshold.
+ */
+static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
+		int referenced, int unmapped, struct collapse_control *cc,
+		bool *mmap_locked, unsigned long enabled_orders)
+{
+	u8 order, next_order;
+	u16 offset, mid_offset;
+	int num_chunks;
+	int bits_set, threshold_bits;
+	int top = -1;
+	int collapsed = 0;
+	int ret;
+	struct scan_bit_state state;
+	unsigned int max_none_ptes;
+
+	push_mthp_bitmap_stack(cc, &top, HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0);
+
+	while (top >= 0) {
+		state = cc->mthp_bitmap_stack[top--];
+		order = state.order + KHUGEPAGED_MIN_MTHP_ORDER;
+		offset = state.offset;
+		num_chunks = 1UL << order;
+
+		/* Skip mTHP orders that are not enabled */
+		if (!test_bit(order, &enabled_orders))
+			goto next_order;
+
+		max_none_ptes = collapse_max_ptes_none(order, !cc->is_khugepaged);
+
+		/* Calculate weight of the range */
+		bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
+		bitmap_set(cc->mthp_bitmap_mask, offset, num_chunks);
+		bits_set = bitmap_weight_and(cc->mthp_bitmap,
+					     cc->mthp_bitmap_mask, HPAGE_PMD_NR);
+
+		threshold_bits = (1UL << order) - max_none_ptes - 1;
+
+		/* Check if the region is eligible based on the threshold */
+		if (bits_set > threshold_bits) {
+			ret = collapse_huge_page(mm, address, referenced,
+						 unmapped, cc, mmap_locked,
+						 order, offset);
+			if (ret == SCAN_SUCCEED) {
+				collapsed += 1UL << order;
+				continue;
+			}
+		}
+
+next_order:
+		if (state.order > 0) {
+			next_order = state.order - 1;
+			mid_offset = offset + (num_chunks / 2);
+			push_mthp_bitmap_stack(cc, &top, next_order, mid_offset);
+			push_mthp_bitmap_stack(cc, &top, next_order, offset);
+		}
+	}
+	return collapsed;
+}
+
 static int collapse_scan_pmd(struct mm_struct *mm,
 			     struct vm_area_struct *vma,
 			     unsigned long start_addr, bool *mmap_locked,
@@ -1364,11 +1455,15 @@ static int collapse_scan_pmd(struct mm_struct *mm,
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
 
@@ -1378,16 +1473,29 @@ static int collapse_scan_pmd(struct mm_struct *mm,
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
+	if (cc->is_khugepaged && enabled_orders == _BITUL(HPAGE_PMD_ORDER))
+		full_scan = false;
+	max_ptes_none = collapse_max_ptes_none(HPAGE_PMD_ORDER, full_scan);
+
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
 		result = SCAN_PMD_NULL;
 		goto out;
 	}
 
-	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, addr += PAGE_SIZE) {
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		_pte = pte + i;
+		addr = start_addr + i * PAGE_SIZE;
 		pte_t pteval = ptep_get(_pte);
 		if (is_swap_pte(pteval)) {
 			++unmapped;
@@ -1412,8 +1520,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			    none_or_zero <= max_ptes_none) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1461,6 +1568,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 			}
 		}
 
+		/* Set bit for occupied pages */
+		bitmap_set(cc->mthp_bitmap, i, 1);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
@@ -1517,9 +1626,12 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_huge_page(mm, start_addr, referenced,
-					    unmapped, cc, mmap_locked,
-					    HPAGE_PMD_ORDER, 0);
+		nr_collapsed = collapse_scan_bitmap(mm, start_addr, referenced, unmapped,
+					      cc, mmap_locked, enabled_orders);
+		if (nr_collapsed > 0)
+			result = SCAN_SUCCEED;
+		else
+			result = SCAN_FAIL;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-- 
2.51.0


