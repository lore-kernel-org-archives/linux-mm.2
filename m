Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21278E9E303
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 12:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B756B008A; Wed, 11 Feb 2026 07:55:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82BF46B008C; Wed, 11 Feb 2026 07:55:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E2E6B0092; Wed, 11 Feb 2026 07:55:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 658516B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:55:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD2CB5860B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:55:36 +0000 (UTC)
X-FDA: 84432172272.06.32B7386
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8E3B140009
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:55:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uvvqK0Md;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770814535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcD//BzEPgHjV/7gQ+qWY8N5xTNYLgnhdP8UluiR/nY=;
	b=WgPNvwsn9wnGbwGk3C1YF5GNLMEzOugbWeELyznpqOYjjAce+cgXCdjCWxiZmOl9TILQtv
	fzViEEtWzac0WJCybVqsM/yI6xcItIgzt67esU2mjaIlhy0bSMD+bmFrdd37vbkStC2EnH
	49nfwe74P9ti722m8qMzfzRF7zFnstU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770814535; a=rsa-sha256;
	cv=none;
	b=WkIj+uPaHWw0quglJBEWJmyC1eeylTljaWpZmUmvQwiiDo9/PVymmwhpkBqcG4pso8YuZD
	N3oWMA6odhWWGa1fvdgg/EEcL7YetUR84+BhZbgEf9qfN6O6QB9jggX6vx/COWcNr9lmzf
	LN7WnmapdEDsGd/xWr9ADSLPb9dy07c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uvvqK0Md;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770814532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mcD//BzEPgHjV/7gQ+qWY8N5xTNYLgnhdP8UluiR/nY=;
	b=uvvqK0Mdl50ffxRUuAdNTTtwZnIgx4kywsWnCecVkOw1sPX/CLAQhQlR+XHlGQSmHqHUvo
	MJLBGpxZpgLZyOuM1dsK1lMXjZE3Fmd14RzlAWiNSx7z2iG4N6sdfbSzBFM3Js4CAxlxqn
	v2Nl88eeip/zkmRQHn4hFB1PwB1STkM=
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
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC 2/2] mm: thp: add THP_SPLIT_PMD_PTE_ALLOC_FAILED counter
Date: Wed, 11 Feb 2026 04:49:46 -0800
Message-ID: <20260211125507.4175026-3-usama.arif@linux.dev>
In-Reply-To: <20260211125507.4175026-1-usama.arif@linux.dev>
References: <20260211125507.4175026-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E8E3B140009
X-Stat-Signature: d1gejeh8c5c5g9jbymde7m61nasxzi7c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770814534-365459
X-HE-Meta: U2FsdGVkX1/fBgglDUi4IQcFII66aW18N27QC8B2hywDCjLtoTxTMLb8LRWN6EGQyj2ZkuHuFLFriw1yA7KwiyVwh+3ftn1dl30LzW++km/GVWccXkW5igSEMznlwt6S1RXzj0CGSXTij0JxPRfC7LaWuehmuHp6ToMIU059ujd9iGnRGorwZsjSvscGMhM/9xhgALqDEA0oApwcYAnAFdYyvmKqhxDVPmHytQQgeMfjePqtzIGMbJGGRvBpkOQ7I+vDZ1sESKxG0e5MOY7mRhem9jATRBouR9hTnEXL3uMaE/hKJ4041DoaLpJ1wtsK/lqVkKIAoeQuHr0l3O/ZmEIAONLgDfZIUOBYM1BxZZXHrjzxhhoGWrM0S/KAEtYWephvdUdsqWuIR1mOvZYogoa9nEZd9uTpouiFKYs75O8AA4RriFKaawF9W00rXDEBCnmZiJ6DR+4sVYVDlNhYZ1SSqcY6Zxv/oEoZr0TWmRz9sckNSdhahubOTQny9OpW59hwb7vOBGqU97aaLk2fJmSnU+/rxwzq6bNBOL9wwd3gB8aFz1TsgppRXBMkB52NWah7FD1JcIUXougtCZeNTDvVoT8wqb6Uv3AmLZ8kX8XCZ0odmNQqJY0Lutrnf5NZOXKoXl/bM3L7up/AmGnMHstMhLdiTqxkUn6n0SAqpNtXzEgD0x/lCsM+mMm2gU5WWH+WheOfGUjU7syhZmep/ytwg6hpCLydwOlLyHq6CZPIN2OyDKJ0xGzC4/i+rG1mcbjTgfpovi5vh8RpdLLCy1uN9GxhcUA1JWGOu96bZHDHBhena5t8rZQyjP2gTQJ262OVSb9I4SZXrEtZFAU5SVRqxEF9JGExRWAhi95MAIhCm7qLTScm9xJKGnfMDFnVd9eYEkb3Mup256xs+FsZRFIGDuE9ZT9NMEfHqfBwYvuTMnWnAqWWtbZJSbnZnruwvHlS0ur+gSXdvemmDNM
 tYzR2Q3O
 pDCaQs9QprTHx5ILTiI+TpxSTE85DXO8cq1P83Y1BZikgSuEY34pbeCjQFWfaUUil/MIli4Z0zP844GNlbdLe6rsmRUuRZ+2jesxK8AkZhRnOu12kkmk4BcGYRsBAyy5howXSpymWLzt7KeB95xkbr8iDMS9gkvc1uN8FeBPUTaTc3glGS3b0r6eOf3ATtuqLBLSAgOMZbi8EtyUj9FwpgiUvE+lUuUmZ4uv358M3hdHC1iPg87Jt4H/cyBLNtCpX/U3yJMd7ipkZbDLIS/dswmG66w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Visible via /proc/vmstat as thp_split_pmd_pte_alloc_failed.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/vm_event_item.h | 1 +
 mm/huge_memory.c              | 1 +
 mm/rmap.c                     | 3 +++
 mm/vmstat.c                   | 1 +
 4 files changed, 6 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 22a139f82d75f..827c9a8c251de 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -111,6 +111,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		THP_DEFERRED_SPLIT_PAGE,
 		THP_UNDERUSED_SPLIT_PAGE,
 		THP_SPLIT_PMD,
+		THP_SPLIT_PMD_PTE_ALLOC_FAILED,
 		THP_SCAN_EXCEED_NONE_PTE,
 		THP_SCAN_EXCEED_SWAP_PTE,
 		THP_SCAN_EXCEED_SHARED_PTE,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4c9a8d89fc8aa..8d7c9f67f8a1d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3332,6 +3332,7 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 	if (vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(vma->vm_mm);
 		if (!pgtable) {
+			count_vm_event(THP_SPLIT_PMD_PTE_ALLOC_FAILED);
 			mmu_notifier_invalidate_range_end(&range);
 			return;
 		}
diff --git a/mm/rmap.c b/mm/rmap.c
index c6ff23fc12944..5c4afedb29d5a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2070,8 +2070,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				pgtable_t pgtable = prealloc_pte;
 
 				prealloc_pte = NULL;
+
 				if (!arch_needs_pgtable_deposit() && !pgtable &&
 				    vma_is_anonymous(vma)) {
+					count_vm_event(THP_SPLIT_PMD_PTE_ALLOC_FAILED);
 					page_vma_mapped_walk_done(&pvmw);
 					ret = false;
 					break;
@@ -2474,6 +2476,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				prealloc_pte = NULL;
 				if (!arch_needs_pgtable_deposit() && !pgtable &&
 				    vma_is_anonymous(vma)) {
+					count_vm_event(THP_SPLIT_PMD_PTE_ALLOC_FAILED);
 					page_vma_mapped_walk_done(&pvmw);
 					ret = false;
 					break;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 99270713e0c13..473edfa624a41 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1408,6 +1408,7 @@ const char * const vmstat_text[] = {
 	[I(THP_DEFERRED_SPLIT_PAGE)]		= "thp_deferred_split_page",
 	[I(THP_UNDERUSED_SPLIT_PAGE)]		= "thp_underused_split_page",
 	[I(THP_SPLIT_PMD)]			= "thp_split_pmd",
+	[I(THP_SPLIT_PMD_PTE_ALLOC_FAILED)]	= "thp_split_pmd_pte_alloc_failed",
 	[I(THP_SCAN_EXCEED_NONE_PTE)]		= "thp_scan_exceed_none_pte",
 	[I(THP_SCAN_EXCEED_SWAP_PTE)]		= "thp_scan_exceed_swap_pte",
 	[I(THP_SCAN_EXCEED_SHARED_PTE)]		= "thp_scan_exceed_share_pte",
-- 
2.47.3


