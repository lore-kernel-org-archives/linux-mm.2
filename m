Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9BEC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0BDA6B00AC; Thu, 24 Jul 2025 01:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2DE6B00AD; Thu, 24 Jul 2025 01:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E215A8E0002; Thu, 24 Jul 2025 01:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB9A56B00AC
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:23:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 644521602B3
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:25 +0000 (UTC)
X-FDA: 83698015170.20.8B59EF9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id B0361160002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753334603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cpjXG0rczMgzyEbMOK4gukpaI8qpKLWW4kvFW+d4rVs=;
	b=Gq7wEzO5thkAc6M3/oSbzKBNYxGgUI6vd0uhbgZA9QPWrRKR1KR3TOr82+Ai8s+/byd/lC
	ps+tIXxTa2XCUJ71xa8ZBPDTjfqv6EgynXnXStOhlI18MdJPjyeNJf91WcEspV89XYeIaB
	pFHvjaCcs0bHJ5haVmmfcWAysuOtsbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753334603; a=rsa-sha256;
	cv=none;
	b=7RHdrMEdrgGCPNoVaw2f3eSjRfIKmx6O6OQko3RmWVvnKM5ZlpZ7RqWQtwKGjAikd97Sdm
	44G3GkMngfL1Ns3ISeajAsOZEHaV22bemodMbyp0T/9lM96yyFMWXLddWJxrOTmwz6JhQq
	QOWTzvivHbUXhe9L/7V88M4ceKcsAHQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B86AF1A32;
	Wed, 23 Jul 2025 22:23:16 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5B6FB3F66E;
	Wed, 23 Jul 2025 22:23:19 -0700 (PDT)
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
Subject: [PATCH v4 3/3] khugepaged: Optimize collapse_pte_mapped_thp() by PTE batching
Date: Thu, 24 Jul 2025 10:53:01 +0530
Message-Id: <20250724052301.23844-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250724052301.23844-1-dev.jain@arm.com>
References: <20250724052301.23844-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bjkx1j1rpdonmsf1g1t1znekpkbqsrm4
X-Rspamd-Queue-Id: B0361160002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753334603-563508
X-HE-Meta: U2FsdGVkX19bX/zMQwWBMPhgMZzI0i7omveK4EF8ZC82tQTt6lANghLlfk4G3S2HjihACsvxkTDk2jgbxdhxDnawYVzKKm38ljol3MOO2Z4O904kmJlwa7I2Zm8V67bPeJaYIsY76yybGw2wTwRkfhZ5bwtCF1kfhL++UJForHxgayQyOT4oyhDSGKjXdydRTj7onAxTBi2/UI0Wvq53pqx6Lqv8VabSlT1ljkgP8MGD5d2baavdIBCUwH4RPQwjh2UPmc7m030GhBMyhd3asIj7mmg8zbMrdks3ntJpzCDI777RrXc+MQBCOk4aijBoLTM1FhBCaRTxs2nhj8CB5jxFplFL5w8aoGuNGXQia8ilnZIy4fae3ooYt91NmiG1411NoJrG6hIDQcWgCHspKfET2i8I8Fw11DWxgSdXu9BCqhXSg3fof/kDApAdZCmKzEd8eNae9l10osI0rE2f02V9TnaJu3BovJK2pPWL9/aS2jo8UaSHYuXoc1osYP+hwQrDrJgsZ/3qaQLKJlZdNHU4Ly9apy8WQqKRgb8LhEjz08hLXCguT7pmTYqnbMcbWBwcukboCgx+gQvsJO4exUkcyoxxd6SQtEdAB37T/+5g/2h26wd4vTjvZGZq/U8fmbokgOgvaqM+I6GXV2yj5olqCc6bqe51Qodqpc1Q6lOS1m5YbQuPRE2tzc+X/UuhWyTHzm9FI5Kf1+SwRNCkwyxwPyB0rV+Fe0qiyQPTwVmOpyetErGu5VxyMy5Q61LwNci/ZxG+lMywwfKpzAtb0gX4ca+Zb9tQ/1ylkTvcXjV0CDZI7/z2TLa/uAIJtiVI04WKXEBkqLWdrQ66qH8ApTsOpHztQ3yNGb60pDm9yzCdiq3GbfF+9nos0jbXixQnJNu2kl0FpZpdKVYzkUq4DVvPWHAhhlPxMpTZ/b6C9clnhNRAt7uScBqIXMO4xoqIyL/XVmaZHE2n/0uRg8o
 KxhV5+lT
 x3FmWBChNnaEMVBJtKnbeaROdxsdFtzcU6M0zffUmtLJNIVogzG5ATgrmUKpe2Xl0PNl/Uo8MnJ/VSafa4f8UQ49zo/5HzUa6HfflYhnbnm06e+2k59K4jpneFvUevG/zPHj/tK3eScDjPhq4zITeNsI+6atbbjoaablIR+X5a6pa1wqxiwvDidYrP4NskUZSe1q3jwOqoO6X3B40TIK5UwgUrlDWJEnJljq9yzLKtY8wVPIG5xadJkmkWr6p8weWNlPskvgAcamOGCotVD4xZY9CkYLowM1Qqz2c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use PTE batching to batch process PTEs mapping the same large folio. An
improvement is expected due to batching mapcount manipulation on the
folios, and for arm64 which supports contig mappings, the number of
TLB flushes is also reduced.

Note that we do not need to make a change to the check
"if (folio_page(folio, i) != page)"; if i'th page of the folio is equal
to the first page of our batch, then i + 1, .... i + nr_batch_ptes - 1
pages of the folio will be equal to the corresponding pages of our
batch mapping consecutive pages.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/khugepaged.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f23e943506bc..374a6a5193a7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1503,15 +1503,17 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 			    bool install_pmd)
 {
+	int nr_mapped_ptes = 0, result = SCAN_FAIL;
+	unsigned int nr_batch_ptes;
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
@@ -1625,11 +1627,15 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		goto abort;
 
 	/* step 2: clear page table and adjust rmap */
-	for (i = 0, addr = haddr, pte = start_pte;
-	     i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE, pte++) {
+	for (i = 0, addr = haddr, pte = start_pte; i < HPAGE_PMD_NR;
+	     i += nr_batch_ptes, addr += nr_batch_ptes * PAGE_SIZE,
+	     pte += nr_batch_ptes) {
+		unsigned int max_nr_batch_ptes = (end - addr) >> PAGE_SHIFT;
 		struct page *page;
 		pte_t ptent = ptep_get(pte);
 
+		nr_batch_ptes = 1;
+
 		if (pte_none(ptent))
 			continue;
 		/*
@@ -1643,26 +1649,29 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
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
@@ -1695,10 +1704,10 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
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


