Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CB6C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502446B00E6; Tue,  4 Aug 2026 15:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2DC6B00EC; Tue,  4 Aug 2026 15:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F09D6B00EE; Tue,  4 Aug 2026 15:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09C646B00E6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:25:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E62D140163
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:34 +0000 (UTC)
X-FDA: 85064566188.01.723AFA4
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id AC90E1A0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u2G6hqEi;
	spf=pass (imf19.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geBTcCptRliUmzhkX/SVMpzDuh58iStAuLW+HnKYxWU=;
	b=nWSWXJGrqaw1x13NkjZfc6YC3mAD2errx1qhvrr+sGxoHgRbIVzSJ5qxbJODeE2UuyCLw9
	Ag5Vtl24hq64iqeZvJp+LRjOzvbofTXWqMzxc/Oy6gdhBuCsvNv9VbuO8zFHR71R5H/hMP
	Zowb2rspfkjcDZF3Gd+1sXj5X8W0rOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871532;
	b=lIUk/f4ZcTq59rmInzIoCniGD5DNugh2VVrkqCbKXRzXWfPz69Pcze1PhQMcmozU5+GyXX
	IEY0VmeR1+KVSReRgzcQmezYOoFC3Bvv6Ig2ZCLfTlHVBqlGmpvnheUPFQMbN/N6wB9znr
	G0VITu0wjEk0pMvu/N69Euyi3uIOl5Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u2G6hqEi;
	spf=pass (imf19.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785871531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=geBTcCptRliUmzhkX/SVMpzDuh58iStAuLW+HnKYxWU=;
	b=u2G6hqEi51nhf0mr0uDzHxvKicocCqA6MAzaVDI4UjoE1Ie6BmiaQpyPM/o6o0cAU4xnKi
	Ou0JgTb+njRMLuI2VrHhPphBJrcIf3hd3lWV0/VwUHHFcLtPVpZNBc55Xum4DioltpPCd+
	mTeeHNr4k6j0TzYke7FIaxBSitAhOzc=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 04 Aug 2026 13:25:01 -0600
Subject: [PATCH v3 3/7] mm/khugepaged: introduce a count_collapse_event()
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-khugepaged_pte_refactor-v3-3-0364cad642a0@linux.dev>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC90E1A0002
X-Stat-Signature: pds95wxm1wosbxhhe31k1q7i4ioxb6we
X-HE-Tag: 1785871532-518140
X-HE-Meta: U2FsdGVkX18S48XSaCTQATIX3aj0zSYkGrPiVdr0pfuOxcEGt0ZQJLFHoc0NGHeCFWevRR4XDZpNyC1mgU5rpTMEMUXWO+lCIaudAgjlZ4YQmd4sVt3AoWCBxEwN1xJ8RIK28QxwgAf+z/li2SNWEJ73U4vUIZEvP8b1etthOe4Go9yPgrJrnun3aRCjgrkx15IAl8YFCSF8DhNVeO6hh7xkYQiJIFYlYWbszufI5iQs18GJDVTmTn4/a07Qt4muTHat6ISTtrdiO7UFQ4lMA5tD8K5eY9IW0W3S4t7uofby0/kl7xYUcycVoxUA+hfwrXkCpq+3Dfkfj5N0Ec5n4Mmia6BBUh3EROUN2kI8azzvQ3RnqS04n7ulHBHFKuonQz7ovEmA7bL03LcYzSKJm6NaP74ocBXp4pDt/CCND9yKlMOPhwv7dEQXY+nRHKRszJLiGuzq0dfvfJxS5P3HmhjjAG30o+q8G9HEi1dGf6QDVeKoFSWrlzadppgodHAt7SAc4v13lP0Bs3yEpA1ARBmsKwqC7x1+1PrayoS+dLiuEyN2NeFezuvbTkSX7rqo3Ru8A3OFg8gubK+A0Dv9aOcu76K7uFtPV8VIRsm0SU4oiV2juaVG5UEFUrBsIykWkEqnj2eH2QwKKpj/U2iyHocoo07qXWi/6r1+2WfAsnB6ihOkPDd4xB0S2H5NueC/OHhZcu0ZtQZn3zkwxyAFN9s72o3+qmJSRp8aGd0GD1A0LZ8ErnuToFo/uDo3ArHz6/4uW/tLw1s79Tk4O+H/N63cSEdH/BaPJQuYZQC0CrpHAfTnRgP0GSB7mq+MwlstgdZIAR74ymNvooD1Wejjyfk4O1jopeKAbSWBPB6SBAx9sTDxqCaUtp/vi/xT1d5L0xi/nRB7c5nxi4oQv7GCeCdy9Os175nDw/aFrHSFqGE8/THzP+LW5stGH9Q46hxKxAT0kEOnSVy8bZt4Rtx
 21c24I3u
 UE+ZFvHRZsaSlzQRFSsrhxKUhSdfLFwnzaHsItT59PxHruyksPPzi/eQ8kVHBi+ELHgfC0uOfb68WcRuo4eBs+62quXAXKn6SUWgQzNRUUte5HIQqH79PIsK6wpeXl1Q58KinxaksPRJ9wRjWt48tRdMX1l2tYiFyyTP/4Mey6q4DRDIjU6u0zZOFAQDToudalhh8YZc6Ho6q7dn8/ZAhnOGUjZ5zF/O3YXiIe9nSxz6KNyWt/6A14F72urttVUw6THEB/UFoRz2dFwY0VwTwY+3j+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a simple helper function to help reduce a often used, and
duplicate pattern across the khugepaged code.

When collapsing to a PMD we need to record a vm_event and the mTHP_stat
event. When doing mTHP collapse we only update the mTHP stat.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9b15c1740943..a2691587a510 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -689,6 +689,14 @@ static inline bool pte_is_referenced(struct collapse_control *cc, pte_t pteval,
 		mmu_notifier_test_young(vma->vm_mm, addr));
 }
 
+static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
+		enum mthp_stat_item mthp_event)
+{
+	if (is_pmd_order(order))
+		count_vm_event(vm_event);
+	count_mthp_stat(order, mthp_event);
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
@@ -709,9 +717,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
-				if (is_pmd_order(order))
-					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out;
 			}
 			continue;
@@ -753,9 +760,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			 */
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				if (is_pmd_order(order))
-					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+				count_collapse_event(order, THP_SCAN_EXCEED_SHARED_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out;
 			}
 		}
@@ -1264,15 +1270,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
 	if (!folio) {
 		*foliop = NULL;
-		if (is_pmd_order(order))
-			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
-		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
+		count_collapse_event(order, THP_COLLAPSE_ALLOC_FAILED,
+				     MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
-	if (is_pmd_order(order))
-		count_vm_event(THP_COLLAPSE_ALLOC);
-	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
+	count_collapse_event(order, THP_COLLAPSE_ALLOC, MTHP_STAT_COLLAPSE_ALLOC);
 
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
@@ -1662,9 +1665,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
-						MTHP_STAT_COLLAPSE_EXCEED_NONE);
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
 			continue;
@@ -1672,9 +1674,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (!pte_present(pteval)) {
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
-						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
 			/*
@@ -1731,9 +1732,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (folio_maybe_mapped_shared(folio)) {
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
-						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
 			}
 		}

-- 
2.55.0


