Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3175FC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EECB06B009B; Tue, 11 Aug 2026 08:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4866B009D; Tue, 11 Aug 2026 08:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA816B009E; Tue, 11 Aug 2026 08:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B08896B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:49:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B14E0A0421
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:29 +0000 (UTC)
X-FDA: 85088969658.20.EC6C953
Received: from out-181.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC1BF80006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FgdY7UQX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u47oBE0boWW/Z9dLtIXQCCcO1q1VmCr6ZGR13oxSM8M=;
	b=Okd1Yab3oYHP87ZDRAgHN3cOun2I0tw7/wWZJgbYAztKhBWxHTGDBDY+on/pNsJRifeY/1
	XM17Auhy9huP9o4ju8jORYjLjSLe9r/MjIrilzpD9tFmxEerzDVB2cQw18C7p5K03AEyM1
	h04bXn7bhYdqf/37N89rL21JLfjifug=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FgdY7UQX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452568;
	b=TiCtS7MzJBn+XCHLKy05E4BwCPNgYfqXW4CRwhXIqqpnSB8ohYRb+x52C2v2qnAHlTdUwj
	YuCWF9itbCGDIkBX1yctOhufIR21egLmPx/FRSqAccN9MJYXw++axieECfJces8fydX8tp
	Ad4RI3CyBkmaCRbZ5mO7yTQPhIxzXvk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786452566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u47oBE0boWW/Z9dLtIXQCCcO1q1VmCr6ZGR13oxSM8M=;
	b=FgdY7UQX5jyHRSntUu1pa2fX7kXHK/7n4g3HTWKzTQpjBGwG+w/wrlSQSj49FudTxWFf+r
	XrMx6KwhrTRWa52ehzMVQuysYiE1aWwAs8vUq/QGgWH73ReM9iXo9obMgICamB7q/4+jC+
	xkS0/ArToShMHtFz9eOiWyP4/ng0B18=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 11 Aug 2026 06:48:35 -0600
Subject: [PATCH v4 3/7] mm/khugepaged: introduce a count_collapse_event()
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC1BF80006
X-Stat-Signature: 46kkf5c3aabwd5y9uq6m58q5xmzh9w1n
X-Rspam-User: 
X-HE-Tag: 1786452567-410508
X-HE-Meta: U2FsdGVkX18SNcSdf+Xov5Jvh1tq/gl0SyAdKnGWoubDRa7pyCJpk1ZmLYhJmBKpEeVxDiAygBboMCi4uc9p+l418qEqw6TZY4GHfaeMG3vKO8Dd8s3deusYrP4tO+0WU2MCIVja73ezM1dI5NXrDUnzaEByYpu2DrK7veI7BadH5N0snz/Dq/imt9xQU3RbiSy9hFf9sXjZEooy7tpeegPXDjph3NG38H57JMd8x5GYO08Omt2tenjjplbETOJA1DVDd2ghMvpOQR44maI8l280SIAu8wmQNsjKJApvMxFHXoaXKQoyP4tbdUjq6SMBmznrNsscnG2kiFwFsoa7phkDCqg6qIMV3wRjMHBJEtGhHol01rlUkIVCgv9WO709oGmUPA6QTYiHa0purmKhkcs0ln3kDEtLgjrrns4xQMHyjz/HLc8qP0NovUfK4dYsujmeBv71PvqxQ6p+A1SVCzr5/Jw0R/4QZbmZ3XDcqmCvqFm54DXKHqMZR5wOFkV4ldkq9+Qx8O60s/EEs+OEgVox9jp0DmB7VYV1l7/B6HMIsXg0B7C3vsWBWTyJDxWhXx3vlENBaL76DRsFqzrQzvzJDAsbwQtvJpDk+c0AGHhAEsdwr8tvpY5VeiMbuXoJtAuf0AZFzRD7FD17oHFRv2zCe5IEffjlbmXVfxI9nctailThGFxh4Ls4Zj22RTcmdnx0LauegNabBoNhnI1vqUKjxmN6ZuDma5riyvWjYRcxSdKDhT0rFgBBcvyqHoRjYJbRZ6w7Px8pjeuEV8NvkolIXI+VolyitkBk4g3gHoCOzjm4b0WlmzzqaJV6azYGbi5MS/AmHIoKqNP4GVzKK49v19N6MzynNyjfRlW3v2hMRkFVmW9mOCXmsBqH/0p3ev36XKlQtsfKRZ1b2/Ly1Mxdk2VTNQiSL9SyjuwEAM0rzBPbIVAwDHEf6VuPk/V0q01nsYExpVTSwkHu52f
 k/08+AKB
 fEpP3ZmEIpMzZlflWxptLPMxS4Ta6q/UKsICdrpsK8LkVfxywsSHWmvGPkesgJk5ilM2MjDhrDtKthf1D0iBevvyt+dFIYyHc8btg6WatZhiHHPH3IpdNz7WUsxNgxfiyv4Hxeewx0J71z5tQyCB7aptLAottVHJ6EREPgMzQwx0dvnPWiTJj7CEe1J0FrHAPk4b8yTEEyb7CH/NJNIUgUSQ959nVTr8DFtchiuZu9sOX8CZb21z+c4KP/iZk/KElyvC7
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8babd4c97db6..cae510aa2914 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -688,6 +688,14 @@ static inline bool folio_pte_referenced(struct folio *folio,
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
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
@@ -708,9 +716,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -752,9 +759,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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


