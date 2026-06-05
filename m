Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE42CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E536B00AA; Fri,  5 Jun 2026 12:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F3C6B00AC; Fri,  5 Jun 2026 12:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906C46B00AD; Fri,  5 Jun 2026 12:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4516B00AA
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:17:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C3BC1201ED
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:17:30 +0000 (UTC)
X-FDA: 84846364260.18.778D1BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id D640F1C0010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:17:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KespElu+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJ4Ysg15fHDbPXcijjVYNLyDQf/OR2xqlGkIjwxP6zo=;
	b=ECger17NZUGxk8+c/b9bTxCCj8SquIvwbtvBUpNHuy+c0Qi+RUffPqesSiYe8W54RAxvTV
	kCSNtWifgkiFvsyUFQ5Gh1iPhKXJwFNhIsA1HrQD+YGMyBnZ1tu9Tr9cLwYC0s1vY7RKPg
	jCUXJ46PaWEKfRjHJHHB3SnlApdavDI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KespElu+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676248;
	b=DGtyU9NN992TwJYCkiqy8qQAXJY1B+aGg/A/nxe+3v0S7eq7/EFw0OSGWU4sLW9uARGMi8
	FTfLk8FhN0bn+sIG9b4kGOZlyq0EP+triG70CC+sSf2wcvgbkCA8KyeJpA/VgBXXl6xAED
	L6Q+9t/jJckN0HXgcUzQO49rWrk/9L8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TJ4Ysg15fHDbPXcijjVYNLyDQf/OR2xqlGkIjwxP6zo=;
	b=KespElu+aF0vyVu5BD0upsq9B+vfmqSFerwd6m97qBW48Fb6rnC2eIPbEPSgtiLqbeWgIV
	e+00O4wuRhf3RX2PcCDinabwn1zzhVWtzUyylh+ZHXUWPVBkCF3YYMg8l9mAm9ykE/u9lf
	dWVUUnf9thGQ9kdG8e+K/31vaZ7t94Y=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-513-V9EeZsMdM3qtvRzwHx3-zQ-1; Fri,
 05 Jun 2026 12:17:21 -0400
X-MC-Unique: V9EeZsMdM3qtvRzwHx3-zQ-1
X-Mimecast-MFC-AGG-ID: V9EeZsMdM3qtvRzwHx3-zQ_1780676231
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A53741944A98;
	Fri,  5 Jun 2026 16:17:11 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AA84C180049F;
	Fri,  5 Jun 2026 16:16:53 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP collapse support
Date: Fri,  5 Jun 2026 10:14:18 -0600
Message-ID: <20260605161422.213817-12-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EtJgt_apTY0xuRg-oKAjgiXYPvbFNKd9Q3vKtMuPBYg_1780676231
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: wyfweshnxmoxse9asjkjfttae4jf7g5j
X-Rspamd-Queue-Id: D640F1C0010
X-HE-Tag: 1780676247-475902
X-HE-Meta: U2FsdGVkX19n3a1omST72SvfOW4BJ5wUErxZzT3pXjt7fFRiG8BHcPV9W48JtUs2hQKhcuUUg25onK0e901Yi3Cej5ct/TbxFI0kek8tsEz3SagGEFJxTm+J3oomEvXOfAvS8cDqnzc8gICZfKJGjPKoRbLztG6SOXUHf+b7upsanQIjP3GNyRlsfK28jmA5bkQT1L6W0pSZg93NExr64dUze8RdepH1j5ruhdTWWxgM5UttRkzhapJoF9j9W6hTcDpGf/VE7tLbpZNaHolIr2sxSz9SbCzqlD9ew6LeaGRkiZOneBt260rJMZusfQ+hmhPDPbYgkb6x2iInvYjCqhK7N5ChQ17EX/hb++KoHYLX+9b/sTfWYhQUOyhmR1xAKvm2BSeSi0A48uAmYiwpFBJNptodiTMC8T/SYFG1TMkyKHbo5ISKvVn7I2D8CFlD2nEJW0xb8bZt4U5vLycZ8p59BrdjtOyCHcLYBZ4n+dLAfTiGpV5NT30d3gBQhNy3OOoWEio0mbhSK/RWEIlwUOFbL8/IZHhJsbgKhz9dSpl18ES9lzE0LT3cfezKxdrVOrpdvrOBJ+WtEdKLMMQRvW6+EzJxDiHNlqNwWuh2K7UdGc421KCO3zBe2jufif4kekXLOlugirXvIRueSwwNfzxb7f0dmtvIxsKJ3VWf3447ZKWwJFW65qPyL5BjB7xQMoEJlAhweTNNNlFDDHU989vDflT77FU4aDa/J4wm+fq7HXNEiD+DtFURFuYx0SNbhAXPbuJ961Pkan6nygVNV//Rc4thr2gntgq+0mpuBuEGgMkmRiuuL5RfZb9flvJjSzEVt91uzVy1rf13gXfJ5ze4kPjuzSYyBtYl1mPoa5jYwT8UZlvjdLyYUSN00/Fsm3XuX3CIMeN7okUgKAuC/0YoNi9HtRSvO6l8uewXgaICK89UcIGwHTNCxEnLkipqeN7To5AeVaOaePcnlQ+
 03W8gtzF
 WjuFAjYR0R+uOb9KzUn5wvM2NkQOW7nWX41aNfMN8RQtemwN3uNty+OXp814x4lU0pfBPaSn4W17iCt48gSKZwsRWMQkg9xMjNJiGhNotUbTcQc2wj42OHtnNW5LDS4IXAYIwLjKnHvY9CCqv9iPde/Qd4EtwtcACdpMHP3ljPnbznfqERkQPEcbmMQGL6JIzMXjByo0n4oCO0OyQ+3ZckLbmzdOM/tFknGauNk5NGNjhcNg3SHVcQ4Hkd087z9kTl4uSOtJcqijnX2nN/KKJDhmyZ3T6phazYyX0QB2/X2et73Hluo+6VBXSeaiX4ebvwH2wdg868pzy0qOEcpYDa8/JLtBIrVzBskhkwE6FH74RF36f8Wej4aI6vswILgmnuX1EjDX7GIYc3eQAevXjOfi+uyBfoyzwtOvT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable khugepaged to collapse to mTHP orders. This patch implements the
main scanning logic using a bitmap to track occupied pages and the
algorithm to find optimal collapse sizes.

Previous to this patch, PMD collapse had 3 main phases, a light weight
scanning phase (mmap_read_lock) that determines a potential PMD
collapse, an alloc phase (mmap unlocked), then finally heavier collapse
phase (mmap_write_lock).

To enabled mTHP collapse we make the following changes:

During PMD scan phase, track occupied pages in a bitmap. When mTHP
orders are enabled, we remove the restriction of max_ptes_none during the
scan phase to avoid missing potential mTHP collapse candidates. Once we
have scanned the full PMD range and updated the bitmap to track occupied
pages, we use the bitmap to find the optimal mTHP size.

Implement mthp_collapse() to walk forward through the bitmap and
determine the best eligible order for each naturally-aligned region. The
algorithm starts at the beginning of the PMD range and, for each offset,
tries the highest order that fits the alignment. If the number of
occupied PTEs in that region satisfies the max_ptes_none threshold for
that order, a collapse is attempted. On failure, the order is
decremented and the same offset is retried at the next smaller size. Once
the smallest enabled order is exhausted (or a collapse succeeds), the
offset advances past the region just processed, and the next attempt
starts at the highest order permitted by the new offset's natural
alignment.

The algorithm works as follows:
    1) set offset=0 and order=HPAGE_PMD_ORDER
    2) if the order is not enabled, go to step (5)
    3) count occupied PTEs in the (offset, order) range using
       bitmap_weight_from()
    4) if the count satisfies the max_ptes_none threshold, attempt
       collapse; on success, advance to step (6)
    5) if a smaller enabled order exists, decrement order and retry
       from step (2) at the same offset
    6) advance offset past the current region and compute the next
       order from the new offset's natural alignment via __ffs(offset),
       capped at HPAGE_PMD_ORDER
    7) repeat from step (2) until the full PMD range is covered

mTHP collapses reject regions containing swapped out or shared pages.
This is because adding new entries can lead to new none pages, and these
may lead to constant promotion into a higher order mTHP. A similar
issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
introducing at least 2x the number of pages, and on a future scan will
satisfy the promotion condition once again. This issue is prevented via
the collapse_max_ptes_none() function which imposes the max_ptes_none
restrictions above.

We currently only support mTHP collapse for max_ptes_none values of 0
and HPAGE_PMD_NR - 1. resulting in the following behavior:

    - max_ptes_none=0: Never introduce new empty pages during collapse
    - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
      available mTHP order

Any other max_ptes_none value will emit a warning and default mTHP
collapse to max_ptes_none=0. There should be no behavior change for PMD
collapse.

Once we determine what mTHP sizes fits best in that PMD range a collapse
is attempted. A minimum collapse order of 2 is used as this is the lowest
order supported by anon memory as defined by THP_ORDERS_ALL_ANON.

Currently madv_collapse is not supported and will only attempt PMD
collapse.

We can also remove the check for is_khugepaged inside the PMD scan as
the collapse_max_ptes_none() function handles this logic now.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 146 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 138 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ec886a031952..430047316f43 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -99,6 +99,8 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+#define KHUGEPAGED_MIN_MTHP_ORDER	2
+
 struct collapse_control {
 	bool is_khugepaged;
 
@@ -110,6 +112,9 @@ struct collapse_control {
 
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
+
+	/* Each bit represents a single occupied (!none/zero) page. */
+	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
 };
 
 /**
@@ -1440,20 +1445,130 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	return result;
 }
 
+/* Return the highest naturally aligned order that fits at @offset within a PMD. */
+static unsigned int max_order_from_offset(unsigned int offset)
+{
+	if (offset == 0)
+		return HPAGE_PMD_ORDER;
+
+	return min_t(unsigned int, __ffs(offset), HPAGE_PMD_ORDER);
+}
+
+/*
+ * mthp_collapse() consumes the bitmap that is generated during
+ * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
+ *
+ * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
+ * page. We start at the PMD order and check if it is eligible for collapse;
+ * if not, we check the left and right halves of the PTE page table we are
+ * examining at a lower order.
+ *
+ * For each of these, we determine how many PTE entries are occupied in the
+ * range of PTE entries we propose to collapse, then we compare this to a
+ * threshold number of PTE entries which would need to be occupied for a
+ * collapse to be permitted at that order (accounting for max_ptes_none).
+ *
+ * If a collapse is permitted, we attempt to collapse the PTE range into a
+ * mTHP.
+ */
+static enum scan_result mthp_collapse(struct mm_struct *mm,
+		unsigned long address, int referenced, int unmapped,
+		struct collapse_control *cc, unsigned long enabled_orders)
+{
+	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
+	enum scan_result last_result = SCAN_FAIL;
+	int collapsed = 0;
+	bool alloc_failed = false;
+	unsigned long collapse_address;
+	unsigned int offset = 0;
+	unsigned int order = HPAGE_PMD_ORDER;
+
+	while (offset < HPAGE_PMD_NR) {
+		nr_ptes = 1UL << order;
+
+		if (!test_bit(order, &enabled_orders))
+			goto next_order;
+
+		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
+		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
+						      offset + nr_ptes);
+
+		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
+			enum scan_result ret;
+
+			collapse_address = address + offset * PAGE_SIZE;
+			ret = collapse_huge_page(mm, collapse_address, referenced,
+						 unmapped, cc, order);
+			switch (ret) {
+			/* Cases where we continue to next collapse candidate */
+			case SCAN_SUCCEED:
+				collapsed += nr_ptes;
+				fallthrough;
+			case SCAN_PTE_MAPPED_HUGEPAGE:
+				goto next_offset;
+			/* Cases where lower orders might still succeed */
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+				alloc_failed = true;
+				last_result = ret;
+				goto next_order;
+			/* Cases where no further collapse is possible */
+			case SCAN_PMD_MAPPED:
+				fallthrough;
+			default:
+				last_result = ret;
+				goto done;
+			}
+		}
+
+next_order:
+		/*
+		 * Continue with the next smaller order if there is still
+		 * any smaller order enabled. When at the smallest order
+		 * we must always move to the next offset.
+		 */
+		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
+			(enabled_orders & GENMASK(order - 1, 0))) {
+			order--;
+			continue;
+		}
+next_offset:
+		/*
+		 * Advance past the region we just processed and determine the
+		 * highest order we can attempt next. Since huge pages must be
+		 * naturally aligned, the max order we can attempt next is
+		 * limited by the alignment of the new offset.
+		 * E.g. if we collapsed a order-2 mTHP at offset 0, offset
+		 * becomes 4 and __ffs(4) == 2, so the next attempt starts at
+		 * order 2.
+		 */
+		offset += nr_ptes;
+		order = max_order_from_offset(offset);
+	}
+done:
+	if (collapsed)
+		return SCAN_SUCCEED;
+	if (alloc_failed)
+		return SCAN_ALLOC_HUGE_PAGE_FAIL;
+	return last_result;
+}
+
 static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
+	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
+	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 	pmd_t *pmd;
-	pte_t *pte, *_pte;
+	pte_t *pte, *_pte, pteval;
+	int i;
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr;
+	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
@@ -1465,8 +1580,19 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
+	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+
+	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
+
+	/*
+	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
+	 * scan all pages to populate the bitmap for mTHP collapse.
+	 */
+	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
+		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
 		cc->progress++;
@@ -1474,11 +1600,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, addr += PAGE_SIZE) {
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		_pte = pte + i;
+		addr = start_addr + i * PAGE_SIZE;
+		pteval = ptep_get(_pte);
+
 		cc->progress++;
 
-		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1558,6 +1686,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			}
 		}
 
+		/* Set bit for occupied pages */
+		__set_bit(i, cc->mthp_present_ptes);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
@@ -1616,9 +1746,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	if (result == SCAN_SUCCEED) {
 		/* collapse_huge_page expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
-		result = collapse_huge_page(mm, start_addr, referenced,
-					    unmapped, cc, HPAGE_PMD_ORDER);
-		/* collapse_huge_page will return with the mmap_lock released */
+		result = mthp_collapse(mm, start_addr, referenced,
+				       unmapped, cc, enabled_orders);
+		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
 	}
 out:
-- 
2.54.0


