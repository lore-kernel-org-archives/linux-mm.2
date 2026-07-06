Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1462C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94AC6B00CD; Mon,  6 Jul 2026 11:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BC16B00CE; Mon,  6 Jul 2026 11:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83896B00D1; Mon,  6 Jul 2026 11:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 818DF6B00CD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:44:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13D8B1661EF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:51 +0000 (UTC)
X-FDA: 84958774782.01.862233B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2FAE420006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JvsKgC6Q;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Cr9Tv04iscHstsqijOSB1nXfodRf1ay3tseK8r1HWU=;
	b=iIdzEbKKMDQZEAUmK61MHOf/T472H7RXI52ZfVjNnP8COQLAP1CFwOsq4tL1AAH7+Tbkem
	1he7h6a88p+AP5oMvNncrio14t7h+8SWIJfIN5xT6A/7Q0wYqaM9vSkLQeR/3oaGhFQdEP
	DtVSjUU+zYNTLgiWydqn5MAzEXfAEBk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JvsKgC6Q;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352689;
	b=UxAe0ReOO/v6TGuaNVQnuQHKNv9hfrRzYxo9IhUpUJXe48+izR3ODBXncju3TabnX3yM4m
	lreCzXk+VfwbqHT8FMRzfh+vTA9Sm50weZPjRoaBEOBNIgfSjOEXbOb7+5Ozh+pfm0q6st
	jyXiKVjih1A2G4T6dIqLBgSJqT9izEg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Cr9Tv04iscHstsqijOSB1nXfodRf1ay3tseK8r1HWU=;
	b=JvsKgC6QmQ0IBtt6DsS495y+D4ww/MB7g4+avJXGqyy0Li/MRfEH9n2BQwcu5DLYpV4KUy
	VbtFu7u9/3BpC9HbV2ukhC+1UZ6ZMb5pYk/EZsvCmyFHq0q7GBYOsXYbuK+OFBcjwO4cTn
	p6tHTEaRVmwS3tkg1Xymih/rI7mMAEY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-PHuIRXnBPDCgGhZSdEPIPw-1; Mon,
 06 Jul 2026 11:44:42 -0400
X-MC-Unique: PHuIRXnBPDCgGhZSdEPIPw-1
X-Mimecast-MFC-AGG-ID: PHuIRXnBPDCgGhZSdEPIPw_1783352678
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A7D11802673;
	Mon,  6 Jul 2026 15:44:38 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.58.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28439195604B;
	Mon,  6 Jul 2026 15:44:29 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 3/8] mm/khugepaged: introduce a count_collapse_event() helper
Date: Mon,  6 Jul 2026 09:44:50 -0600
Message-ID: <20260706154500.39178-4-npache@redhat.com>
In-Reply-To: <20260706154500.39178-1-npache@redhat.com>
References: <20260706154500.39178-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: t8bueHb8_Wi2FoBuOIWPWaiGnKnMbYM-gCuZVxOz6Xs_1783352678
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FAE420006
X-Stat-Signature: uuxk9a6d674f9wwbdzpgr8p5tpxgwihx
X-HE-Tag: 1783352689-649464
X-HE-Meta: U2FsdGVkX19DgT2E9pok00FsxBMShxR72ZYoSiw8hPv06yXjo2S0JDMcC+ZWg4X2LzeQSv25z1ISeGQiDVyW3RCWeR6eq1yaGn9DQAC9ZFtYu4LcpEUoO+l2m01NMRz1nn0d0LqMv5Jx4SLYHIlJeKEgXEB8ePpb3MrUzmq4Dt9cjtuzDDAtuviDHQFY3zjbjDRJ42k1cSiOOhXJGWw1bd+Ru5PGkGyU6y0uOkg7Ai1GuED9pKWOFNdppEBm65QDFyZL+0Fiwf9UPvaKcwyaI5q2m2xbHID1dZMRvQRdOCM524/yxPQmoebvTRCeirEtXT90lOeFx6UhgDy2zbN32pvOmooSzN52nKASLxd3RFi0EQAqZ4ntR/tZ/BWxk4sNlpMBWsrXQ6MNZX8JziNv1QISnDzUVI2qdhaWfz4VyfpALixpkCWMv5q0XW/t8MsV+eHWy75RRuDqjXqv1+JUZU16ysUWw0a7GP6IKwSOM5eBzxZxwQsBsedzBJhDTJY6WIDknWmCm2s3Ayi77bmBjSD4zjexCwTK4PSw+oER8vpkV6Y6Ow3Ok5oGpnJgpiobgLWv1rGlJgOXp1LVex2Fmx6JoiWEuYUENrv2d0Rdjcvz8ICG1oMYqEN8neHkoH/1e7znq1KFZI7Zi4tV0jDc+2CUhzRFCW2NDN+K4b+Pxl4hxEEYHT9ffg0AwmI6B08wXOoNG2/XqJmW946g83S/gDTOjX1HgZEZLheiFWdvuaZlplzry1wcTofPJdasQyf6cvB7XyiFRCWvOflYVtbDs/d5BoghIvGwvgacaflBhhEqmj/y2qh4qwtjTJVD5hL8Sbl3hLqowuaxBs4RIIOPO3TdBBNgRhhdoVQqgvv2z4S7nq4LXyxhxCI+vfis+4pp84pcTEA5e53p6VPPs6gAwm+D2Pwbs630Ci+Wojd24TA3z8WZ5cu9eKSmqauqNMS/8XiUd1s1uBc1EM4VJwL
 3+x6mXsd
 x1QY8+F7BCZzZhtXSaFS5yLTe8aFh5EKvX1VcSjlp9ahB+ILmCT2E66OJhQV5wAeoS5FVgMfrlg1fQ6Izh7nQiSv2T8tT0PSTGu0SSTqTXllRetOU8C2z8IFo+SnnyOzJQC6PeuaFXYl17AcR+9XfR5IasMl9Kz55JHuJOYVVu//s+ruOTNR+9rh6rLlVF0fFTjdWFyS2F6wPfWalNEkB/3ON8v6JqneA7PZeQRJFe5o8AW2E/mkO/BREANT5CGwXuVP74hf32xP1w04EGMCjTF2Nm0QpVJTelp7j5RSYGIoVUEGp6kzYnvEO7rMShlQajVSUgyPAoX2P1eiFert0znlvYxNVIkFn3wai217AKWu5S5eyf7+aPAph2/elBId7PqQc480z6zIxkd0=
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

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 48b008a3c891..7047253a6fb6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -692,6 +692,14 @@ static inline bool collapse_is_young(struct collapse_control *cc, pte_t pteval,
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
@@ -712,9 +720,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -756,9 +763,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -1267,15 +1273,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
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
@@ -1665,8 +1668,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
 						MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
@@ -1675,8 +1677,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (!pte_present(pteval)) {
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
 						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
@@ -1734,8 +1735,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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


