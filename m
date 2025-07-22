Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D0AC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6031C8E000A; Tue, 22 Jul 2025 11:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3438E0001; Tue, 22 Jul 2025 11:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A23D8E000A; Tue, 22 Jul 2025 11:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3441A8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:06:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10E68111705
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:06:32 +0000 (UTC)
X-FDA: 83692227024.29.3C9D97E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 62EFEA0002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:06:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xGAtL16zmuaVNOacDsHTa8W8Gp9Cm/Z85IpW5LkUqQk=;
	b=rAoIrToxVJO0f0OpifSVH05dDNpQC+LB6MXfYelB2S78ZPg08O9F50DaQzIxGg3hBVQLZl
	oHVPwdnOlWhS+C1RGHv8d5GqT1OYGJ1fBvZhGb0dfB4XQI+5yTqy6Tt+atG1I8dILd6jMk
	g0E2ccPRirQrN/oqQ7AfYXL5byLfrYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196790; a=rsa-sha256;
	cv=none;
	b=eucT1XZ0YNFRCXBucd/Bw12dAHanXILHs3Hq49EuAH87WJxelSXMBd6CNVXbSBIlWlM2hR
	YwH9CBpgMBbQGqzamOzPxrNwR7voPvlEPYkXP7emJum4wh7sqmv1D70NpWxgwLFL+TAIrV
	cBQg7GOS6bSXiBUOJxu896FN917iGZI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14530152B;
	Tue, 22 Jul 2025 08:06:24 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.163.92.223])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AFC053F6A8;
	Tue, 22 Jul 2025 08:06:25 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v3 3/3] khugepaged: Optimize collapse_pte_mapped_thp() by PTE batching
Date: Tue, 22 Jul 2025 20:35:59 +0530
Message-Id: <20250722150559.96465-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250722150559.96465-1-dev.jain@arm.com>
References: <20250722150559.96465-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62EFEA0002
X-Stat-Signature: bs3jwiaibgx7u475jhfzhj9dbow47u31
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753196790-451201
X-HE-Meta: U2FsdGVkX19f9wnQvxK5CgBD/O4Lly7ZmdZsNVR969elw2yDArYDWxiVAwhtut/xazGTUsqpSUEFrObbiWPCTGBksn/JAGcGD7ZoYEVS97x5pNj5GwR2aot5E438s3vVpDkahw8qcnWy/6ZwI+dFiyokGMufzE1PKTBAJmMRBZ5ky5cIpSl7nEMfbUSsH1ukLmDHLsyr3RoqUIw3HBJxkQCJodj0MmtzPz7PgcxEE2+WQbBD+c2QlVI6jtWTfTobqBQGH/H3k3U9iOzCCyi57JUZ4Qc0srp2gqwRfOgb15f70Q9jeZ/38px+JOgu0iWxF/syE/AJttkNlvfzpTQHjY6BWIikguNdKgtam7EYymZ7YW5G55uN5IhfPSjIDPZfPMCUaJ1OuR2l9LunzL7VcgoaeaVwih7KaJTpzfS+YcrGVnuDi0agnmEO58OXDHCy5CvAqnOXn6Id1p6C3Dc1JUuYXhWY77VynQ2V5IS4b3YeCizW2LT2nhQDDduLJeRsXNl4Wle8+LNngXCOGvK1aogD0jmi52VzCW5FY2vWkdYOQG5bkMVA/ZefV6JBxEv9Az7v7Qlw9Uabuc5/ap8ICFhgdpJPRvkA2Toe9H+qzZxZGf/mfaACO3JaTglgnBxbpxd19Y1zJDx2MkDWN+SBx/clqYBblK9TXLcTkqz0ejemck056k/0QooUcQK+iDDy8aW9zSlhGty8hZQtUUum+lUj4e/tPtrpWDw5M3f7pLGMXjVi31IenuAxT9xbt10Q18K/MA+yO75yrG1GWQEzqWNUJNZBJcrhECHTpvRdIKiYsn1BZaRQhwLNGCuSRCixFWspLYWfO0reDQOz15zzHf7UNN7cfcFF5utB2cp1tP0Ac8aIwjFSUdl9FO7QLQUIOqdXLe8RR02n87fB8HyLlj0UEpTVVyZh2Sj3lL78k/GaaQcWjrkbHPUDSu7PHEhHm5zwETrnzBcwdC5aGtN
 /LMEfBY+
 /TtI+6Mh1gUQBRO81GC8zFIidcbqUtvrMJjYDPbGP6Oh1QYQAi2kWQhBYIvaApDSuyv6niEgErGKL6I7yM0Gi/AX93PbUGEthBIxl2yZw3G/34xa2t53sEiwolddGkurc+QD19EdMMsZY3+zWcaNxO5BWzWXLqKYp9zDTfvesvW+h2r1lL7tlsxYRoDyECRXO7OQcbgRbKUvpzGrUuEUh4eSD/Eh8Par9ilClFXxUduNy/hs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use PTE batching to optimize collapse_pte_mapped_thp().

On arm64, suppose khugepaged is scanning a pte-mapped 2MB THP for collapse.
Then, calling ptep_clear() for every pte will cause a TLB flush for every
contpte block. Instead, clear_ptes() does a contpte_try_unfold_partial()
which will flush the TLB only for the (if any) starting and ending contpte
block, if they partially overlap with the range khugepaged is looking at.

For all arches, there should be a benefit due to batching atomic operations
on mapcounts due to folio_remove_rmap_ptes() and saving some calls.

Note that we do not need to make a change to the check
"if (folio_page(folio, i) != page)"; if i'th page of the folio is equal
to the first page of our batch, then i + 1, .... i + nr_batch_ptes - 1
pages of the folio will be equal to the corresponding pages of our
batch mapping consecutive pages.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/khugepaged.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 63517ef7eafb..1ff0c7dd2be4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1503,15 +1503,16 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 			    bool install_pmd)
 {
+	int nr_mapped_ptes = 0, nr_batch_ptes, result = SCAN_FAIL;
 	struct mmu_notifier_range range;
 	bool notified = false;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
+	unsigned long end = haddr + HPAGE_PMD_SIZE;
 	struct vm_area_struct *vma = vma_lookup(mm, haddr);
 	struct folio *folio;
 	pte_t *start_pte, *pte;
 	pmd_t *pmd, pgt_pmd;
 	spinlock_t *pml = NULL, *ptl;
-	int nr_ptes = 0, result = SCAN_FAIL;
 	int i;
 
 	mmap_assert_locked(mm);
@@ -1625,11 +1626,15 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		goto abort;
 
 	/* step 2: clear page table and adjust rmap */
-	for (i = 0, addr = haddr, pte = start_pte;
-	     i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE, pte++) {
+	for (i = 0, addr = haddr, pte = start_pte; i < HPAGE_PMD_NR;
+	     i += nr_batch_ptes, addr += nr_batch_ptes * PAGE_SIZE,
+	     pte += nr_batch_ptes) {
+		int max_nr_batch_ptes = (end - addr) >> PAGE_SHIFT;
 		struct page *page;
 		pte_t ptent = ptep_get(pte);
 
+		nr_batch_ptes = 1;
+
 		if (pte_none(ptent))
 			continue;
 		/*
@@ -1643,26 +1648,29 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 			goto abort;
 		}
 		page = vm_normal_page(vma, addr, ptent);
+
 		if (folio_page(folio, i) != page)
 			goto abort;
 
+		nr_batch_ptes = folio_pte_batch(folio, pte, ptent, max_nr_batch_ptes);
+
 		/*
 		 * Must clear entry, or a racing truncate may re-remove it.
 		 * TLB flush can be left until pmdp_collapse_flush() does it.
 		 * PTE dirty? Shmem page is already dirty; file is read-only.
 		 */
-		ptep_clear(mm, addr, pte);
-		folio_remove_rmap_pte(folio, page, vma);
-		nr_ptes++;
+		clear_ptes(mm, addr, pte, nr_batch_ptes);
+		folio_remove_rmap_ptes(folio, page, nr_batch_ptes, vma);
+		nr_mapped_ptes += nr_batch_ptes;
 	}
 
 	if (!pml)
 		spin_unlock(ptl);
 
 	/* step 3: set proper refcount and mm_counters. */
-	if (nr_ptes) {
-		folio_ref_sub(folio, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
+	if (nr_mapped_ptes) {
+		folio_ref_sub(folio, nr_mapped_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
 	}
 
 	/* step 4: remove empty page table */
@@ -1695,10 +1703,10 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 			: SCAN_SUCCEED;
 	goto drop_folio;
 abort:
-	if (nr_ptes) {
+	if (nr_mapped_ptes) {
 		flush_tlb_mm(mm);
-		folio_ref_sub(folio, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
+		folio_ref_sub(folio, nr_mapped_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
 	}
 unlock:
 	if (start_pte)
-- 
2.30.2


