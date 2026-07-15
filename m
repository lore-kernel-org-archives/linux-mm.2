Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22D0C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9ADB6B0099; Tue, 14 Jul 2026 23:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72AA6B00A9; Tue, 14 Jul 2026 23:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8B716B00AA; Tue, 14 Jul 2026 23:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 871846B0099
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:19:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D81BD1605A0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:00:44 +0000 (UTC)
X-FDA: 84989508408.03.E64410E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id DAF15160003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:00:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g0Y25ZaN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784084443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPhmQGvxVsdgikGQPOW7y5soGlfMNgvozbvH3hbHJ10=;
	b=wVqP4VHU+7qT4pHFdw4bpQyq1lUXbxnDrl/VwTZKmw9WnRZe54aXTbW3EyREImVAAIoaSl
	pERy6vyZD1XeHePCdbgnGjJ5sNpPblIsDtq9eSOYf5/HmGB0HaFExitNePnXx+wOkN6OD8
	Q4lYG1zN4lSmaXzGygZEBJIhrjQRM8I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g0Y25ZaN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784084443;
	b=uG5O1zaBlJcBBR8JhqBL92KcUcVOCUI5yi7yZP2wdQscAkVhyLUGmO2OSd4CCVKeF8+sck
	T4RjRBrBDUQdTBNQllTXQiiRSRJJg3svKPZYMt6gElcWw50+JkiAHmbKWoimVTEX9w26lE
	Tc88HZTJk0tlQBedI9CzdX//oPTujSM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784084442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iPhmQGvxVsdgikGQPOW7y5soGlfMNgvozbvH3hbHJ10=;
	b=g0Y25ZaN13hUpfo35BfhhZPrBo92+NuqPvsavHPSHAEwwzeBVp2jtqrxsYJXihZr7eHhhE
	x53XX7XW/BTPKL016ZhG2ozjHdqJZVjX4ZvIpWJEGZGudUUpANjH+KZuiV5WnpDFyO9WBJ
	5HtjRBx6attbQOE6gOtT2uTjJLxv/Y4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-kbESWq2OMgy90tgGrgby2Q-1; Tue,
 14 Jul 2026 23:00:40 -0400
X-MC-Unique: kbESWq2OMgy90tgGrgby2Q-1
X-Mimecast-MFC-AGG-ID: kbESWq2OMgy90tgGrgby2Q_1784084437
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 273AA19560B2;
	Wed, 15 Jul 2026 03:00:37 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A581A180028B;
	Wed, 15 Jul 2026 03:00:25 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2 3/7] mm/khugepaged: introduce a count_collapse_event() helper
Date: Tue, 14 Jul 2026 20:59:32 -0600
Message-ID: <20260715025941.1571316-4-npache@redhat.com>
In-Reply-To: <20260715025941.1571316-1-npache@redhat.com>
References: <20260715025941.1571316-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: f8HdYxqovXKFrPW4v9QJt9E0P-QBkkcjQDvfm-6dfRQ_1784084437
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DAF15160003
X-Stat-Signature: 8hkw9ceh9z5n5ix8whcyp9a38s7i4egw
X-Rspam-User: 
X-HE-Tag: 1784084442-413759
X-HE-Meta: U2FsdGVkX1/k9Fq9DbCV0NstkpSJbd6zIb9KTYTuyJhfM5HZByzO+0vuPDQcbOt6eFofv55WUfLb+EJZqnuUSKtjuWcN26cpcWau0/ilpx+WTpMlwMRVu20mnX8D6DobROpIsqfKXwe1LVAlwcmZJoo5IjqTs3UvtEq8Pe8d/M+1ToOh73jRveYhU4cNhvBonHKPvZjBWimY1HBdvft+s1kPqYJM+lKS4rwEdThD1K5WdxlveWb4lFeR35NJREC0D5iZxfXgN7HBiiG7OXxujbMNuQiWSPSQJCBcMbKSTnf010UjjdCvBCGI0EOKRxtWssD2zZ+rLT1LMqD/3UE4cNfVsH510UzQPOboDBqPKOO4wrUlxoqHPUnZnajJvFlgi2Pp8Ddc1fND50WqIC/S9ykqBOsJv2c9Al9TeiTT/mZgpLI3PvJj6UAUWVrR8FScD7Ta7qoxu0AaGAM0XRpcLwgUt3HG5AcOAYRM0VP/n/IrRzqYJ2s9ScVGuhslaYRW9Sl+lHylgaUBCp6870/0PiWYRgbw4VR2EVLrYHZksGqTEN/7Faaz2tMV5v4ItJqgXiKctTqJHvQNvTHAB+APvbL8qDUcsb7xLLZoqflClxW6znaIQagwc/6KfvLNEe8P+FOebydnucMyANF+gMKM7KeUe3kB5J1QcFTA5Q78LhVQ0zw0D5qwkCLtaeS7V/G9n/GgfK7Xwl8/mWUCji+eg7ez01TrfS14U+JrfCyWkuQiERHWTdK+cL8BufprtMGkkAgko8077pXG767TYQwZprBGoRTC+DRsB57d4rwZaUfH9cINhYZ+KwKWy2UvUHwduz0jfrLxvkUHelX7U16JqeYB4cz2XAz9imLrALHS31V137PsqjGH698J/5sHI5/MJ2pESKDzaHIEDxEwEGjD4/5U2MgSW4JOd2SRIDS+nyRFM3arxexLTBnwDxW93KeR+m72Gg2YI+B0kwj39oH
 r4HeAXda
 TcLlE0j9mHkDrQ0t5fDyZOoRMrbwlBfUPfiTqKz5ijQoSH9zJLjT5B0uw6aPdcmIyNDzS5ncFWUuTAtD5lndvYJ3gIq3nUxMVDlwDbAnH8x8KFgGvAMhqNs3revaJ5uS/65eedxEQMNIMfqbEKF6awqWwPBjkKZMn4s3FZs6psW0yNL8T3A9gQO0YpK6t12ioj4M7l08F8zCHJQ2Fz75ZVvZ/KSk0832ttnp0zlNv66YtgZ+mAi+Vag2nJkI8JTFtPi2QlYKFj81B2/0R+vHWvWrRFGuNqkJe/FTTWWfHXpzgqZIEufQFEs1loWAH13MaknNPbM0VHdV5ic3p+6iPpfTOS0I4iro05oC87V9KhMFbV48VbXBi4Icn/wwKSYcW6VNnjXCul1GkFEbzKSNfyRmkNJj5JBAnPxvM
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
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e92e2b928f17..f65bbe2051b3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -689,6 +689,14 @@ static inline bool collapse_is_referenced(struct collapse_control *cc, pte_t pte
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
+						MTHP_STAT_COLLAPSE_EXCEED_NONE);
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
+						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
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
+				MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
-	if (is_pmd_order(order))
-		count_vm_event(THP_COLLAPSE_ALLOC);
-	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
+	count_collapse_event(order, THP_COLLAPSE_ALLOC, MTHP_STAT_COLLAPSE_ALLOC);
 
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
@@ -1662,8 +1665,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
 						MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
@@ -1672,8 +1674,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (!pte_present(pteval)) {
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
 						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
@@ -1731,8 +1732,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (folio_maybe_mapped_shared(folio)) {
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
 						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
 			}
-- 
2.54.0


