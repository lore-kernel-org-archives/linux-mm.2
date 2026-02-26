Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD1CFC5935
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD7C6B00B1; Thu, 26 Feb 2026 06:34:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5056B00B3; Thu, 26 Feb 2026 06:34:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7836B00B4; Thu, 26 Feb 2026 06:34:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12A846B00B1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:34:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B45011CFE9
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:41 +0000 (UTC)
X-FDA: 84486400362.26.9430785
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id EDAD22000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iwH65pKx;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caCWzkT51kBA+1b/gVecuRpXYDomBajxDOrSXa3U1jc=;
	b=e9Rn/H/aLjjJGxKHsCyzTjtNicASPbzJQu9VobPssf80a/44UE0iBAroHmmpFc0Yqmp1ig
	sB1oX2Lgxlqk3mUI0Ms3DDbS8aBoiLdrUxF+l8jwR5gGSeBQTky1vsJB/eXDmBJfYSCxKn
	IzxQXeAsT5Ie/76ur/lDKmmKUka1XNQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iwH65pKx;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105679; a=rsa-sha256;
	cv=none;
	b=WR0J3KFhUFeQLFDgvEHHLXzprwiNuOewscw91kXfX+/09UW2GSFDyWlLe3d0uIjCVAW9lT
	4SC/zz23bxbXZMPjaOhH1SYfBP6rX9aH6V+kxsg11W/8GKWMnMBZpamCFo1JSo2x1MiCJ+
	0g3iPAUs/P+2ep3DGz7AismF1OiqsG8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=caCWzkT51kBA+1b/gVecuRpXYDomBajxDOrSXa3U1jc=;
	b=iwH65pKxu5LpRPMNZ/vYDs9XIVBcTv1gPT58U+Rxwn3FgEXyxD998b65LSZo9fPSJ031aw
	nazqs8ps6h716yU5RmiIIzP9wPotaYiK6YjK6+WTiQmE9LiXwan6xsQU7f7pDuYB3FqmkI
	VFDnikYUT2941qf0s6DCUaGOhTZ0k/M=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 16/21] mm: thp: add THP_SPLIT_PMD_FAILED counter
Date: Thu, 26 Feb 2026 03:23:45 -0800
Message-ID: <20260226113233.3987674-17-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: EDAD22000D
X-Rspamd-Server: rspam02
X-Stat-Signature: x1qcfzfjergx7u6n3cb6xx3jgq54usy4
X-HE-Tag: 1772105678-695717
X-HE-Meta: U2FsdGVkX18a75lcy0YScioUpMo1UXsnJ0idtlcwWQmF8rPuslYvxUNICotAzhfav1z4aTPlV/CfJBaAXvpPgTP/nqyzDP+/7d3bOIq1zERRN8ugDutpjtzOqUSvBn+MGsGB/t4M7j8UD3/v6RI68HzWs0yIpL5DfrYMDqwJKyPZ1SNasl9ZS65mtzO3N4YpPIf8h3ebiWzx3nocCQF4zw9m6D8B4oPBx81ROCUE6lvUYeC4lfSDvSnv+Qrbtj2QGrJughGHjEWrkgjRXNWqfbGpSxjRiN7ONY/HAImHYXxqU4HThMPTxC2noEtZGkhKatUQvSUrWiZZGuQYbl89fj9yTJ7v9uK1YR64NZ2NrC5LXlYAeBgsi9D1Ij3iQm27v6bMrvJ+dbyZDq2ub1+bW8TQdQHwo0fBmIV15XRX/TTTIRbQCCr4aCrg9rQc+c8b8pgKXfGeCMQpvdL/s4cCDqqQf03MtL9exHihVZ3e+2ZiX5exW+d2Ng71KDZKI77xbydOWP6PaCv1lspraLxNIcB7ywjZ8NqeFa6A/sRtr2ws7//4cP5VEjW7fjOLngoaTtjB2Bvl0NeIZy6JjLQTXTYNvpZNGUtD+YpKw0WLz5CLc8mpL2NTnROuUXsjNZtr+ZqXpUmzCOhNs7uhPLrUMnp+n5ujkfGuCPdxWp+xYIT7VJU3JNa+ifFV+IqRRi0JA6FpBDpu/0S9DKBtJYv8lNVrvIoqgmGafOEKyIEamAdxv3tDBGbI7tmO0/mZl80uHbDzgZ7zPRZQzx/fHJ7IGJkMpC5J1drhAt7Y/FwGKpJkkUp5sFJY9yvEclCUK7tlZO0Gcc9RGJKCjlAcXjqf1C/oG4l6+Jcuy5S8juRbgE1BCtnZuS4f8SL5PvSvdsZVyGmDFPpzLlJRr50maRwkoK9drm6h1/7AGj7KLc3IoCLObWTrAYDIdHNMmaJy1swbqXCyX1a8ZB6IOxj9Ksz
 YignRapS
 9CTb7PEtU9ruA3nG+Zm3rOLpnlitN+36a/rjC0DZfAaM71AMEL13+UILFZKYW1waVWhDaaDbqQUMjSHUwv71q+iosGsXjwOySsx/MO+chMNjMdDuglQHzBW2xGwgICPkUyoUpoaiBWa+PDtfQE8gaGA2GfJsNbQzitBXGs+WjEcS7infOPOkdhhdPRf5NBA1GI4AjnoKY36jSZ8aIJ67bSodGFTOVnRYfOyVOdjXvkJf9yKKI2aOnd779Z2kUl3nxfoP/pz1J9OdEz5udxkdq5IM5qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a vmstat counter to track PTE allocation failures during PMD split.
This enables monitoring of split failures due to memory pressure after
the lazy PTE page table allocation change.

The counter is incremented in three places:
- __split_huge_pmd(): Main entry point for splitting a PMD
- try_to_unmap_one(): When reclaim needs to split a PMD-mapped THP
- try_to_migrate_one(): When migration needs to split a PMD-mapped THP

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/vm_event_item.h | 1 +
 mm/huge_memory.c              | 1 +
 mm/rmap.c                     | 3 +++
 mm/vmstat.c                   | 1 +
 4 files changed, 6 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a0201..ce696cf7d6321 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -98,6 +98,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		THP_DEFERRED_SPLIT_PAGE,
 		THP_UNDERUSED_SPLIT_PAGE,
 		THP_SPLIT_PMD,
+		THP_SPLIT_PMD_FAILED,
 		THP_SCAN_EXCEED_NONE_PTE,
 		THP_SCAN_EXCEED_SWAP_PTE,
 		THP_SCAN_EXCEED_SHARED_PTE,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 55b14ba244b1b..fc0a5e91b4d40 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3347,6 +3347,7 @@ int __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 	if (vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(vma->vm_mm);
 		if (!pgtable) {
+			count_vm_event(THP_SPLIT_PMD_FAILED);
 			mmu_notifier_invalidate_range_end(&range);
 			return -ENOMEM;
 		}
diff --git a/mm/rmap.c b/mm/rmap.c
index 2519d579bc1d8..2dae46fff08ae 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2067,8 +2067,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				pgtable_t pgtable = prealloc_pte;
 
 				prealloc_pte = NULL;
+
 				if (!arch_needs_pgtable_deposit() && !pgtable &&
 				    vma_is_anonymous(vma)) {
+					count_vm_event(THP_SPLIT_PMD_FAILED);
 					page_vma_mapped_walk_done(&pvmw);
 					ret = false;
 					break;
@@ -2471,6 +2473,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				prealloc_pte = NULL;
 				if (!arch_needs_pgtable_deposit() && !pgtable &&
 				    vma_is_anonymous(vma)) {
+					count_vm_event(THP_SPLIT_PMD_FAILED);
 					page_vma_mapped_walk_done(&pvmw);
 					ret = false;
 					break;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 667474773dbc7..da276ef0072ed 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1408,6 +1408,7 @@ const char * const vmstat_text[] = {
 	[I(THP_DEFERRED_SPLIT_PAGE)]		= "thp_deferred_split_page",
 	[I(THP_UNDERUSED_SPLIT_PAGE)]		= "thp_underused_split_page",
 	[I(THP_SPLIT_PMD)]			= "thp_split_pmd",
+	[I(THP_SPLIT_PMD_FAILED)]		= "thp_split_pmd_failed",
 	[I(THP_SCAN_EXCEED_NONE_PTE)]		= "thp_scan_exceed_none_pte",
 	[I(THP_SCAN_EXCEED_SWAP_PTE)]		= "thp_scan_exceed_swap_pte",
 	[I(THP_SCAN_EXCEED_SHARED_PTE)]		= "thp_scan_exceed_share_pte",
-- 
2.47.3


