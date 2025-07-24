Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3AFC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C4A8E0045; Thu, 24 Jul 2025 01:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03CD38E0002; Thu, 24 Jul 2025 01:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD6F8E0045; Thu, 24 Jul 2025 01:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D84F48E0002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:23:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5125D5803F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:21 +0000 (UTC)
X-FDA: 83698015002.21.7281E77
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF21C180006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:23:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753334599; a=rsa-sha256;
	cv=none;
	b=4R2rvhiJO/TVzJsHIE7AgoPRTit1okM1F3L5e1muK9eSLeytL9en5bnc8b4YcpYqngUVVI
	Qdez2rdCnO0rvSju6xNvfYTKaZSvyaXIxAeef/VVy9SAgQGphTCd3zjJy03gRIjepXbgVe
	i8Ni4UsIgWIZbP2IcL/Mo8qKguAWW3E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753334599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0N37wXa6c2aq0gp0JcAWzgd1HkDq1nfxstk8+vbrzZs=;
	b=WqQQP5c/e+4E9CCITK/+9Q8O7EkCa+yLUWSkWHVN+t3siUjroESwOX1cvB++wuNSJYi+LD
	JJCko51yuP1vqBbH4/Tr0xcEM3/ZXFPoMWOzfIQjBYZcdQc0yK4A3rw76C10ozAvjshWh3
	wiV2zUaFzYe9xWYKKgV7YQRuTM8Hh+Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91A411A32;
	Wed, 23 Jul 2025 22:23:12 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3969C3F66E;
	Wed, 23 Jul 2025 22:23:14 -0700 (PDT)
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
Subject: [PATCH v4 2/3] khugepaged: Optimize __collapse_huge_page_copy_succeeded() by PTE batching
Date: Thu, 24 Jul 2025 10:53:00 +0530
Message-Id: <20250724052301.23844-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250724052301.23844-1-dev.jain@arm.com>
References: <20250724052301.23844-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AF21C180006
X-Stat-Signature: 5fe5y5dkzr5tpbqww5dz3aje88azsdep
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753334599-331470
X-HE-Meta: U2FsdGVkX19bl8flHl+owvHqy+WNqrYTvyO6h13ck1U/txwg34DOjA3etljwPHoj81o3OVxglGvBGAwuJ6iy1lcPpS5cMjpqouOouJ3k+QrhyeZZkAgvMhAe/RahVQ+yEUCyh8v4p6U+p8fG/ypCWGtSw32v1XcrU6/ZiAAfC/PEbJIPmWgfgOK6DqCcAaYQQWvOw3jdGhWYCOyjM61tI/MiS72v4auNiRyBXRClmFEjh8eQtzhyECuRLMnPpDBv7YrXAi6Y0EA0p1w16yrwjRIcmz63mdvGpwb5wDCIN8exo9CF/1BvvyNTz2OUqkHowts3ekV+wlSN+xvre96a6r6GiOXCMDFPeC3Rgy+4Vxqwg0vmVOEmXZlXAS1dI6Z939X7FGTZF0VGYsf1WZso6xxtsFlN+QfB1nGvRHYHF1hc9Obxj/WpTsovrwGCcK456tz4Ool0OabnbWZvXmJuV6wQyBAq+V/juAx3trWI14JZcZxumugFJSbtRsVzgeKjgyZnFE2GGX5EK5FzkioPg2H5wn5MuFHlrGb3p3fFLutQJQ1mRK7TuvPvuNTHO2rrSOpEySBVJ5P5950S+yv7C0K/EOPPoEmCCFRFYO01ueiZ3f45xVmlrYFZTNp1HMjpukW1HAho/109cOoILKbxTY5uvtlE/o5EZnVeCRZckwCDrVmPy5roJhWJJCChtko8PGiasg2uBWgwYRpzRM7iLxPW8maRPwYALGPkw8TK3cyA9jsrqRm+hOUT3Z/N5qySk9cJPksM8n+e/J2wKmC2FhXsjliiKMXSOLHlIQdUUrkMGyHQtv38lLs1miR8ov9oViLkbo5s+z8sNz0Z+zEFNV2/fL0B4Y1h+m5JXZ/x85+gGpkx8ltuHNeJzpNcPEJ301sXt7A3xM9Mc4htHt0ZJQLFKvnaABMLnSkfn0NiN+mi/ajAUXuF/U/Jnm1N1x+7hfICITGZDl+MRXf6ZvG
 p1FQ58Bb
 1dhohX5Y+05PbJXP3/56Aa1JFL2LhHHbWHZ1AJKRLr48GtRuVFN31ZYEU8tD6nU/aF9mgZodzK5O0eNscPOL5vdNjdXhkfyRZCW6bs5enEF87bAZwSYgCpj0y8XvPS4F9h4n7w83aIWUUIw2VxHdNTkx+fOeZYTX/Ms42tz94rKFk6+WxA6JRdmLUJZKn4DEm+WSg/TWYBbhrtMXa6Hg8OMAZjP1rwgqLryJPTD+VEjnckeSMbgJHZ3aCcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use PTE batching to batch process PTEs mapping the same large folio. An
improvement is expected due to batching refcount-mapcount manipulation on
the folios, and for arm64 which supports contig mappings, the number of
TLB flushes is also reduced.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/khugepaged.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a55fb1dcd224..f23e943506bc 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -700,12 +700,15 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 						spinlock_t *ptl,
 						struct list_head *compound_pagelist)
 {
+	unsigned long end = address + HPAGE_PMD_SIZE;
 	struct folio *src, *tmp;
-	pte_t *_pte;
 	pte_t pteval;
+	pte_t *_pte;
+	unsigned int nr_ptes;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, address += PAGE_SIZE) {
+	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
+	     address += nr_ptes * PAGE_SIZE) {
+		nr_ptes = 1;
 		pteval = ptep_get(_pte);
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
@@ -722,18 +725,26 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 			struct page *src_page = pte_page(pteval);
 
 			src = page_folio(src_page);
-			if (!folio_test_large(src))
+
+			if (folio_test_large(src)) {
+				unsigned int max_nr_ptes = (end - address) >> PAGE_SHIFT;
+
+				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
+			} else {
 				release_pte_folio(src);
+			}
+
 			/*
 			 * ptl mostly unnecessary, but preempt has to
 			 * be disabled to update the per-cpu stats
 			 * inside folio_remove_rmap_pte().
 			 */
 			spin_lock(ptl);
-			ptep_clear(vma->vm_mm, address, _pte);
-			folio_remove_rmap_pte(src, src_page, vma);
+			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
+			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
 			spin_unlock(ptl);
-			free_folio_and_swap_cache(src);
+			free_swap_cache(src);
+			folio_put_refs(src, nr_ptes);
 		}
 	}
 
-- 
2.30.2


