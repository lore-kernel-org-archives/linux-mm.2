Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A1E606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=exLV5Wbp
Received: by kanga.kvack.org (Postfix)
	id 0F0FB6B05D4; Thu,  5 Nov 2026 13:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053F26B05D5; Thu,  5 Nov 2026 13:41:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DF26B05D6; Thu,  5 Nov 2026 13:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C45016B05D4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F307A8AE1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:55 +0000 (UTC)
X-FDA: 85401934590.23.FC49F5F
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf01.hostedemail.com (Postfix) with ESMTP id 78F8040007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=exLV5Wbp;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904113;
	b=1meORloxLymsq5VYEwFKsqIJSD99Fcd47mXS8eQpKw6+N0w4bf2QxD5t4oJp5qUqJ3YLYX
	kJvmhFfFHyx+rT91Q5q8PpM8nUPyCe60ZK+i7G+BY1DNdWW+97RGKdMexZXb2TNTRyyMaa
	esq1xXzAZnyprg7XRhws2hObYU+wZj0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=exLV5Wbp;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72FcthPtRbjzoeXj7bzWyrfckYFlHv/yxS6YCWw2V4k=;
	b=TX16qKoaCVeFwG0g+kIWL9JYHyWAIyihgyj3NumULKXOmw3um63lia8THa5v/NFR7Itolw
	nbczDowdST+ORxlZXQF81f4jHSWA+ado4MS+b9BXUh6wqc91E7q1fSKgTo4U1BuvUpynPO
	ZeZmi2GuOSBK+KAGAGt5nWgP2vf9iPo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LWCe31d6tLOa8H3T4JFmDGQaqeDnOZg0P/wGm47hWCs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904112; v=1; x=1794508912;
 b=exLV5WbpW30nR7sv2X/mdA1wCDd+SFwkq02C5lPP9SDYbyGQeJorAwVVRVlycDtcpg+6t95F
 Lxr+MiFHi6L30I4ONArx8WuPLXJosmjqBA9Rwy8GaGpVRQZiMhwQ0FqS4pY5abgwFFLgLx/YYI4
 SYkeXPDBOwE0sf+BVJqnX870=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f43eb12c10da9a94;
	Thu, 05 Nov 2026 18:41:52 +0000
X-Mizu-Trace-ID: f43eb12c10da9a94
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 21/32] mm: free PMD swap entries in zap_huge_pmd()
Date: Thu,  5 Nov 2026 10:39:05 -0800
Message-ID: <20261105183940.2236717-22-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 78F8040007
X-Stat-Signature: b3fh31zudnzrr1tuq93zg6bypobgcwgs
X-Rspam-User: 
X-HE-Tag: 1793904113-553335
X-HE-Meta: U2FsdGVkX1+L80CGblEwXZt96fZMJJ0UwMMPsLC9t7p3YKVYuVgnelxfe4Rs9Mubha4SnZK2nOFfQdSzMbhYSfpdNRbBqUDguFwNZ4KPIYYMzxwfbSioKB4WP/6sNLlwxH8O2Ojp42RVM6ehumE7xQpS/6egAf0ipw/Mgb4lkNS/vywD7+sxWJ0DzPBOtUIikAOFI4qVekVUYI9TJebTO0k0XpRfvNt6OnugtejBMhGJw4McEEWpGtYKX3aIqlzjVbFLVjRqukUw7C8nPg1NoOivH+PCaG2oshQxqjWTX5N+kEWtvY7KAISRAN2CFX6u3tRkj/8MO2aSpiuvsytKVAb5KwddAYtJRPOPD10OHvhXLLOVUMXeDg7ZM4EhL2bRqWZVmuoDHZW9muN1PfGmUNCj7hfjCo1+qP4JRdf5SQELCAxfdAk/yk0HUvU4e+qvj9jZFYRoM62Q8c6N8DV44toGP80bvzQW0OhqsPB1lQX7T/dXAOM/e3pqifhus65XC2FOKVDGrpr1FVvXmOInwKsafbfZTAMT+9NbqVuxebakbXOhLe4KjtI5zGcxLk5iFFk5qiEPKeuLkRvWBIsMlA3vqTWTrjSnaDppxyZ1CTl87CUzOPjUaMHHmdpfvRsSLW5fG8zf07iQYYMzu1wf9k5S3T3UI8pUmgFniXAq0COuA+ItifcS+7vgM9f9uk8IYNl9g4vACd8NVxaxpT2SIsS0iAanoqCDwnl9TiqHamL/HoaPSKvM6lrCRlx8gaMQYtBVNdTdGwPPfYkf5Ci9GDpRU0lm//v+0Uh/TWNx0CrFpN5kKsa4I3oIRWYCvmEhptg918/KPg+ZVFwCZzIKd5jwolfpmW9DvNkpQs7JlW/lTGbQuk3Mf3v/RDrDJgRcD2VX2dKfHPDBEqCWny7rwV6Z/J0ivT0aGKcXVycSgE75uc1JGDAj6evDUguj/oQtdYuMz0c0ljFM76J3ehf
 qXG1iTcM
 A+KkMBoR/rYiwGeYTSNOrqi2VlaGoIqGSZRySbDHYfGUULiodsP9kNYAXpK+UOtJeeN4DdE/OKWzTET0vMdIJz4F8oRgKetrqf8ZJck1YhpFRbg6QMgCnoohjP89Bde4lGJ6Al3HYIUR0F3LNSiPCRxBc9fDhvLprxk4Sku5ngD+HsHP7xnLGCV4SLklruHtUkbVU6dt2LbisHEv4Mc8vT4WwO7ZBLPEXLDr02MVptlOOCJPr14DGHz60sGZ8lawXmJjwAklLZ9eQOQziJO8vJTLQhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zap_huge_pmd() assumes any non-present PMD it clears references a folio, so
a PMD swap entry would reach normal_or_softleaf_folio_pmd() and warn.
Worse, nothing would release the slots it points at: unmapping a
swapped-out THP would leak the whole PMD's worth of swap.

Handle it before the folio lookup, as zap_pte_range() already does for a
PTE swap entry.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 101ec72944cbf..f8df5cd723f01 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2594,6 +2594,16 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 
+	if (pmd_is_swap_entry(orig_pmd)) {
+		softleaf_t entry = softleaf_from_pmd(orig_pmd);
+
+		zap_deposited_table(mm, pmd);
+		spin_unlock(ptl);
+		swap_put_entries_direct(entry, HPAGE_PMD_NR);
+		add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+		return true;
+	}
+
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
 	has_deposit = vma_has_deposited_pgtable(vma);
-- 
2.53.0-Meta


