Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D45CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3A68E000E; Thu, 11 Sep 2025 23:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264CD8E0001; Thu, 11 Sep 2025 23:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B248E000E; Thu, 11 Sep 2025 23:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 028D78E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:31:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF4C313B782
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:29 +0000 (UTC)
X-FDA: 83879173098.25.FB92429
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 142311A0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iwj5JjO4;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4p++l5rxwNyrk8zr7oH7Pc+TPQw68SwHfcfHt5STCj0=;
	b=ea8TQfBlBjWIvseBfI0z3IV3H8CpcXe6QBfvHTOFy4UVeQmnRChDmczsfEgNU42JB/HwK5
	rzwY1Gvx/vekV60vJnZOTFTAmQk9nwtWgvjGtAz0UVVKhdhg4fkTzvaI6CfkRnSikzmZ6R
	/b2WLPmKO2JVKUxZ+exZFWqI3Qj/hqI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iwj5JjO4;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647888; a=rsa-sha256;
	cv=none;
	b=EBCdwz1g4ZrxnY+cm6DOQjrE0XSFx81qymj/8WBkI9sUVljCJe0XGo6P4qToQzf5niYVX+
	LbZ/MiwUcWuPKuXL0gODdBXsedsXlBm0rlChWGSBhHaNZ/NLoe3s+/ZicxnqM8eV31pEcr
	lj4yi6OROCs7A3x8uYoEf5RUwcahV8w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4p++l5rxwNyrk8zr7oH7Pc+TPQw68SwHfcfHt5STCj0=;
	b=Iwj5JjO4Xyc0GBBYANaT39eJ3BwGVJojzgo10lNgi0Nth/ZCAr6wbsvYPmjrSV+RXJ46iO
	7opp4zOL+SVCFNmmMocNFmModAK+UQXQtaPQQWL3EQQPjNLph+e9vVYtMAQCXosB4BICOW
	3Lb2fkRB15WJp9WlVF+x3x8A87KY0CA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113-0zkMekGkMPGxxyZHp6zZtQ-1; Thu,
 11 Sep 2025 23:31:22 -0400
X-MC-Unique: 0zkMekGkMPGxxyZHp6zZtQ-1
X-Mimecast-MFC-AGG-ID: 0zkMekGkMPGxxyZHp6zZtQ_1757647878
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 181DF1800452;
	Fri, 12 Sep 2025 03:31:18 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D2EED1800452;
	Fri, 12 Sep 2025 03:31:08 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
Subject: [PATCH v11 12/15] khugepaged: Introduce mTHP collapse support
Date: Thu, 11 Sep 2025 21:28:07 -0600
Message-ID: <20250912032810.197475-13-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 142311A0005
X-Rspamd-Server: rspam05
X-Stat-Signature: ogq8z61yo6kja4duohcad7jxqehphe4a
X-Rspam-User: 
X-HE-Tag: 1757647887-524777
X-HE-Meta: U2FsdGVkX18gKCeRuOcUNGo7Fln/jH/vTt4mVuM6qs/GInbipVH7hoGXpRYlxi9P+03bSK3HN80pfKs/Zk1LLGTLh/w7muIYgeCHINOa15DqP2tpboF90XsUlVzPz1QIU54PweUsFo4TzbsY7saOv2Gnn4Ko8+kvQoyq8Ho87ugk50kCo/L4lutdx5hLoe1nLI3PEuCTSZmEQS3PDFpYMSgF25gUOu6IW7aPHNxCh2sP7ls60xJoneO9+qYiR47py0Q6tqrgKBlaDTF6iFUG9S6dMGcAELRzYLzKiWQputkpIJ2vTHq3mEE+agpyDONuBwh0XuwhcpB1cNlb0GHZjquYSSdC6zpjgFwHIefwRk6CqAXNkdA2L6SVwLgy3XqI3M434M6tlXyUuzlbvF/Sl0d8a2s2eg5xci59S3VG+p0F59BU2wuTzBSPNkDtbkrr8ag+HA3t9IbR3P8rXxzVZFakMjI88uqyReC9tKVwoljcsozJRuyQORl7bE8kvV8HOVRYlxsRsI1VKTywWNbdnA7rocglJQZAmuIPksWn9aZP4i4k+cq+FSwzYGP5sl56YLJbJR0EwzXLO452+XC/Xtf0x29zKXxl+8uQrsiQHHN/uNyyQSqgifs3Ks2Z12Dx1nvwVnuBUzboBe101gVODlOnQoyVunB+Y5/KBkz2HziwCXJUGJncItSITG5/iiwDE6cRQfYW9P21X4PGseFKrZdL0uKQJaYXi4FNyBDy+Ehkm68qHtmYUZGhbGgdEVC1aVnVzim96NyUeSb1tS4kVU4QvLZYnO19ISd74THhrIzNaDzn0erDtdsoFNSWgBFp0WTQyV30iNqxVsFt7zTJAcn7HqSvCdRB0EIJyzQ3zqZjuS8v//tvITcWs+uqrgcCUiXw7eIO9psrCWmgpg0mjy54eLV3YXqeOti37PR6N0qg3e01CxZUlfanPGDay8fpkqwFMDv2np1ruN3f0d0
 MFCqlt1C
 TA1rLVUR953WaIcSUF11hb2g2wnVOyuUrz5PtLxhkFGz657cilu7p0g/Vpsfe8ZVUabHVqHW9xC8V4ft8KFK7HDPAQ68tJPpjtZT8jFGPfhzz7m4YxWo/OQyZ/ZQ9L/IempQUKg8blmlX3YWuRK20vlA17T3Kvah5uGlheheZF/y3zgOExVNNOi3taS8wwPxRMiS2XPFXik7rSARCExkFUpMSGKph4MPUaNTmBXFfSZ/gGPPgFiaWvsnV1+z02KAIgGsrdBK8BdMStGjjteXdQEt3coVFDXSH93HFFUeZZc4SQwm3xsPGV1UeX2xciW3otifh8GB8OBSCXLtyewxoot8Nsak22d2hRRDQMUngwmtNO4KHgF4Jd3SuLQK6pUoEfGPilE8uO8j52q+E7Ya/TInL+Q==
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

Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/khugepaged.h |   2 +
 mm/khugepaged.c            | 123 ++++++++++++++++++++++++++++++++++---
 2 files changed, 116 insertions(+), 9 deletions(-)

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
index d224fa97281a..8455a02dc3d6 100644
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
@@ -1361,6 +1373,85 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_address,
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
+		max_none_ptes = collapse_max_ptes_none(order);
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
 			     unsigned long address, bool *mmap_locked,
@@ -1368,30 +1459,39 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
+	int i;
 	int result = SCAN_FAIL, referenced = 0;
-	int none_or_zero = 0, shared = 0;
+	int none_or_zero = 0, shared = 0, nr_collapsed = 0;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long _address;
+	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
-
+	bool is_pmd_only;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, address, &pmd);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+
+	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, cc->is_khugepaged);
+
+	is_pmd_only = enabled_orders == _BITUL(HPAGE_PMD_ORDER);
+
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!pte) {
 		result = SCAN_PMD_NULL;
 		goto out;
 	}
 
-	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, _address += PAGE_SIZE) {
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		_pte = pte + i;
+		_address = address + i * PAGE_SIZE;
 		pte_t pteval = ptep_get(_pte);
 		if (is_swap_pte(pteval)) {
 			++unmapped;
@@ -1416,8 +1516,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			    (!cc->is_khugepaged || !is_pmd_only ||
+				none_or_zero <= khugepaged_max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1425,6 +1525,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 				goto out_unmap;
 			}
 		}
+		/* Set bit for occupied pages */
+		bitmap_set(cc->mthp_bitmap, i, 1);
 		if (pte_uffd_wp(pteval)) {
 			/*
 			 * Don't collapse the page if any of the small
@@ -1521,9 +1623,12 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_huge_page(mm, address, referenced,
-					    unmapped, cc, mmap_locked,
-					    HPAGE_PMD_ORDER, 0);
+		nr_collapsed = collapse_scan_bitmap(mm, address, referenced, unmapped,
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


