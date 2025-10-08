Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E30B4CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 04:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42AC88E0015; Wed,  8 Oct 2025 00:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB898E0002; Wed,  8 Oct 2025 00:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A32E8E0015; Wed,  8 Oct 2025 00:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 154978E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:40:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D98631A035D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:40:24 +0000 (UTC)
X-FDA: 83973695568.21.10DEC71
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 06FBE8000C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:40:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759898423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4CdxE8CMoT0aWE1+y5A5fa72do+/1xnsq0UYyqE6iA=;
	b=hP/Xus1RtDo3g+v2BJz1t2aHF3iL1S57joD2LQwLUOEQ85WJmG9HprWy+ZUNQoIsmAkZH5
	z/g78/VHUs+6fOY04FDbcJc9rqbTuzg2QsSQOOvSgykO0wyCLD875ZnGelJUG/KXJv4Snc
	FdTvUFhSXGLlYP123a0qf5EXEyrxS9c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759898423; a=rsa-sha256;
	cv=none;
	b=taB7//ehNKlaGy5fiJiztuNQrviOj93kx9SkZPkMMGbFYO8YqOgylBwibgA//Qdh3aizOY
	eOmGNIXDqHLm0hb7seVZOaWZaIADXTVvetqBA3gRHKAS1SbpiT4dflB5tcbOTaFmcvUswy
	MdvyFHmyKybObKBqfSSoyPoDR2Aj0Es=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3ecdf2b1751so4883898f8f.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 21:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759898421; x=1760503221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w4CdxE8CMoT0aWE1+y5A5fa72do+/1xnsq0UYyqE6iA=;
        b=t92H2XzlEQB55/Tnpschrd8J9T8hQYmo8SoUbz8bXITOBxJKMrNyeiODFZUCx6QlOw
         RzugEU0R/c3RhBvEN+ZIFNz5OAef/XnHARfV6J3rgggE0iNBqp/K3AfiFJpwPjgjKp/G
         bChdS28HsTitampUJaM6SmQKNZ0BbsZHLBipptu0P7md+NCVM2XatTuB7bfq1pRO7nUe
         ga7Ah2n5LCXGznG6T9MjVl9jwR1UJeB4HvIvNmo9WlseYTalU4fXagwHzhzHtwz8Kcnf
         dOXx/BUBbnM1M1MdY4le6I8Zmatl93OV5bLf8UqsSMiPOW7vRGJs0P1AAFOeQPCE0Cbl
         aOHw==
X-Forwarded-Encrypted: i=1; AJvYcCVqbjm2t+ZlP5+czolwCgREYHdTXqg+nzKmAlaXCTC7m++hSBSw0G67UIaBeUYuwuBIWAI87ocf8A==@kvack.org
X-Gm-Message-State: AOJu0Yyj1cH5MDHgeICGBhOA5Xr/cI8Kece3YroGtkP3vF5Yn15YioK0
	hCAJ/22I78pfEnIpUDesXTy/ecidWlrUEOiCSlKFNL0jkC60NoEaYJAw
X-Gm-Gg: ASbGnctTzS2++BKEGXjz0F8UlKgTvN6GFuMdWjez7Q0VQHGeBkopE7yxN3xHm5u2+Cs
	lNlOu34TqWvgUgtoq9slq7sNQ3dX35ztXUCFYJHKmv2gciMAykhdS8aV/CFDJFMbcOovaP+5bJe
	ILyt/WMzjQ4AGEIB5rjOlCKMliVCFoCXOCdzotk19mAbm0dbIKTiPrWIFxBCFjjzy04a83STtz6
	Ti2gSmf3o6QxYmfpsAu8YSoHkJu/1n+kPbsw/QAC8LCzBK0YTPUwQX9yGqHsDdb40zyATDF6g6P
	qya9X4aG7ERvlv/cZL5JMjlO4/q9REges6yMyf64ntvqfhzk6V/CgQLY+cKc8sVlFSKPDqhn2pz
	6nlh0u15h/bDaK1hJTdZL9v7uohxCQQ0oQ6tie3s=
X-Google-Smtp-Source: AGHT+IHch9/ftJLZar+bagytdzxWRTkDWRmOOzIGqnFNZ4Rsbi6RYB3Zvqgd5s1fv1Io5v5ehi2r0A==
X-Received: by 2002:a05:6000:26c2:b0:3e7:5f26:f1e5 with SMTP id ffacd0b85a97d-4266e7beb57mr772457f8f.23.1759898421384;
        Tue, 07 Oct 2025 21:40:21 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::30b2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6c49sm28159164f8f.3.2025.10.07.21.40.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 21:40:21 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic into a new helper
Date: Wed,  8 Oct 2025 12:37:48 +0800
Message-ID: <20251008043748.45554-4-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251008043748.45554-1-lance.yang@linux.dev>
References: <20251008043748.45554-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: dadjiubejgsu47hxx55om3h7xcbbtu3m
X-Rspam-User: 
X-Rspamd-Queue-Id: 06FBE8000C
X-HE-Tag: 1759898422-982979
X-HE-Meta: U2FsdGVkX18+9CCwVN5s+JAzNlzPfxNy5jYwdoX9oOHpb+SAbsaWrrwc4axAbr8JrMLv33Wv8zVyvB0/84/xg/3WpyNMmtgl1iKlmxjuqrjDrPBdBnsQwWYjau330JN+LiHDhG/3jJ/LUFUi3TndVC2RPq3119Rgt5oj/77K8UWB7SdxaEI0U7+UCpj8ZVjBYoKnxuL90R0AvufA3Hcn+SAveM0PBgIW/7D9h0zcsVJ0vyGbfeFFOv8G3ZkOxTurn6qW+YI1wWzmd0XH+bYz10ggUEDd2LDzqEcHh4KzVGPeiUX0dBR5N7cuDtJb7S+vqB/UT65b+ZGOiDDZQrGK/nghhz6xlA7QMaDwapOVREGbH1mog00u4TZWN/xuStMwK05Tr8Zu5wUPUgDmlw/+3NKFJtFmUXoAU9pSjOskNx9e0fnqlSVQp0XcGLu4Lj8mUpxyLimDqXE2GtlI33AYvKvjQFU6Zd22OpgCL1zA48RSQLs2rvKZeIdUbXgRiJZIC8CfgsOVtRF+PrS3w8bxPutoJ5jIGyA8toL5JtdQNy/GChchnCl4rj1hihKi+K3iVQWuX3KXr+WYScn7+tuzKncnZSEGottv8zZdFuWLwxl3fJoKSHqOfugvuleuJVOUmLQEzuJqTWlka/cVi8OHsrqeZAEn+Tl2zJLvWg68vytC3YhMoJKnp/2q41AS2v/pHwE4VLcDGUcw6ExU+OO36BdR4nlk1YapQq7RgO8aadsf9XBHaiJOJoPfA8DQFfZSymGXIUHx12ApdgJYpMwivOT/BB//jGc31hwnpJiCaPm/b2DRhozU5FOz+CW+iD7mbI8NGkt44Ux7mn4mTVoOaIfNSOUY1aJmYJyuqV7h8mBeANxSo6k0M/5o2a9y9gobAl6cwUHf5v51Q31Td31EhrfbXMqOIa+q4nwG8zGyw+x/HW1bAHL6mzOM6VFANfoY5MOZ1ThiG5tYcagPDKC
 ibccyIgJ
 ojjxI02DKAT5Gke8wlHbWJNfc6IlbzURGR0/py2o1Z3QsEcAPezMHMyNstAsVjr6hKliQPd/l2IKcdyTJZHTKDZBMXuEwafwmY6rn+Z3xc+gCe9zpoXp0hfg4LD3xRRK+BeKAhESiPqTS/wikfC9FuQU2yTODzhZZdGQQcTAKXKcx1264t+5Ufksc65nuUOQngLXhQbmDPv6cvMWX/9TZjIP2MtZJIi88NWM4vvdSOsEjuNfDEoV4iSaB4vi9SL4tJVrmorAYvCbvnF0bhiAqfIuVRbJfNtixqETAhIUz7uehuQRZTc1S/NnmuI/zeJk4Eh0PN5mlIwOLJoCZKdxbGCtB/fdZ4ltSolb4vQej+zMDiK0W0q3ZlYcOii5pN7VijCWHnZMysEqbqDN+Wo7vJD9OF1Bi1UCGR+zBs12WbVetlP0aFZf/hwLbhVVAB3284X9CjmTFGHr/yWAa8xnkkGeoowUtUNY7eMx9SpXBe49eOsuKgwx6J2P7Gy87O9Ua6JwJuSrhDqXP09tyyaJvZp63Wk3b1/DS/9IPR2ItkwbzQYhmletl18sqGmKVFaHCiSh5uUBki2h8M453fgRDRUQbbJ3m2vaNzPa9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
and __collapse_huge_page_isolate() was almost duplicated.

This patch cleans things up by moving all the common PTE checking logic
into a new shared helper, thp_collapse_check_pte(). While at it, we use
vm_normal_folio() instead of vm_normal_page().

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 243 ++++++++++++++++++++++++++----------------------
 1 file changed, 130 insertions(+), 113 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b5c0295c3414..7116caae1fa4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -61,6 +61,12 @@ enum scan_result {
 	SCAN_PAGE_FILLED,
 };
 
+enum pte_check_result {
+	PTE_CHECK_SUCCEED,
+	PTE_CHECK_CONTINUE,
+	PTE_CHECK_FAIL,
+};
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
 
@@ -533,62 +539,139 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 	}
 }
 
+/*
+ * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
+ * @pte:           The PTE to check
+ * @vma:           The VMA the PTE belongs to
+ * @addr:          The virtual address corresponding to this PTE
+ * @foliop:        On success, used to return a pointer to the folio
+ *                 Must be non-NULL
+ * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
+ * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
+ * @shared:        Counter for shared pages. Must be non-NULL
+ * @scan_result:   Used to return the failure reason (SCAN_*) on a
+ *                 PTE_CHECK_FAIL return. Must be non-NULL
+ * @cc:            Collapse control settings
+ *
+ * Returns:
+ *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
+ *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
+ *   PTE_CHECK_FAIL     - Abort collapse scan
+ */
+static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio **foliop, int *none_or_zero,
+		int *unmapped, int *shared, int *scan_result,
+		struct collapse_control *cc)
+{
+	struct folio *folio = NULL;
+
+	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
+		(*none_or_zero)++;
+		if (!userfaultfd_armed(vma) &&
+		    (!cc->is_khugepaged ||
+		     *none_or_zero <= khugepaged_max_ptes_none)) {
+			return PTE_CHECK_CONTINUE;
+		} else {
+			*scan_result = SCAN_EXCEED_NONE_PTE;
+			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+			return PTE_CHECK_FAIL;
+		}
+	} else if (!pte_present(pte)) {
+		if (!unmapped) {
+			*scan_result = SCAN_PTE_NON_PRESENT;
+			return PTE_CHECK_FAIL;
+		}
+
+		if (non_swap_entry(pte_to_swp_entry(pte))) {
+			*scan_result = SCAN_PTE_NON_PRESENT;
+			return PTE_CHECK_FAIL;
+		}
+
+		(*unmapped)++;
+		if (!cc->is_khugepaged ||
+		    *unmapped <= khugepaged_max_ptes_swap) {
+			/*
+			 * Always be strict with uffd-wp enabled swap
+			 * entries. Please see comment below for
+			 * pte_uffd_wp().
+			 */
+			if (pte_swp_uffd_wp(pte)) {
+				*scan_result = SCAN_PTE_UFFD_WP;
+				return PTE_CHECK_FAIL;
+			}
+			return PTE_CHECK_CONTINUE;
+		} else {
+			*scan_result = SCAN_EXCEED_SWAP_PTE;
+			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+			return PTE_CHECK_FAIL;
+		}
+	} else if (pte_uffd_wp(pte)) {
+		/*
+		 * Don't collapse the page if any of the small PTEs are
+		 * armed with uffd write protection. Here we can also mark
+		 * the new huge pmd as write protected if any of the small
+		 * ones is marked but that could bring unknown userfault
+		 * messages that falls outside of the registered range.
+		 * So, just be simple.
+		 */
+		*scan_result = SCAN_PTE_UFFD_WP;
+		return PTE_CHECK_FAIL;
+	}
+
+	folio = vm_normal_folio(vma, addr, pte);
+	if (unlikely(!folio) || unlikely(folio_is_zone_device(folio))) {
+		*scan_result = SCAN_PAGE_NULL;
+		return PTE_CHECK_FAIL;
+	}
+
+	if (!folio_test_anon(folio)) {
+		VM_WARN_ON_FOLIO(true, folio);
+		*scan_result = SCAN_PAGE_ANON;
+		return PTE_CHECK_FAIL;
+	}
+
+	/*
+	 * We treat a single page as shared if any part of the THP
+	 * is shared.
+	 */
+	if (folio_maybe_mapped_shared(folio)) {
+		(*shared)++;
+		if (cc->is_khugepaged && *shared > khugepaged_max_ptes_shared) {
+			*scan_result = SCAN_EXCEED_SHARED_PTE;
+			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+			return PTE_CHECK_FAIL;
+		}
+	}
+
+	*foliop = folio;
+
+	return PTE_CHECK_SUCCEED;
+}
+
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long start_addr,
 					pte_t *pte,
 					struct collapse_control *cc,
 					struct list_head *compound_pagelist)
 {
-	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
+	int pte_check_res;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				goto out;
-			}
-		} else if (!pte_present(pteval)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto out;
-		} else if (pte_uffd_wp(pteval)) {
-			result = SCAN_PTE_UFFD_WP;
-			goto out;
-		}
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out;
-		}
 
-		folio = page_folio(page);
-		if (!folio_test_anon(folio)) {
-			VM_WARN_ON_FOLIO(true, folio);
-			result = SCAN_PAGE_ANON;
-			goto out;
-		}
+		pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
+					&folio, &none_or_zero, NULL, &shared,
+					&result, cc);
 
-		/* See hpage_collapse_scan_pmd(). */
-		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				goto out;
-			}
-		}
+		if (pte_check_res == PTE_CHECK_CONTINUE)
+			continue;
+		else if (pte_check_res == PTE_CHECK_FAIL)
+			goto out;
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
@@ -1264,11 +1347,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	pte_t *pte, *_pte;
 	int result = SCAN_FAIL, referenced = 0;
 	int none_or_zero = 0, shared = 0;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
+	int pte_check_res;
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
@@ -1287,81 +1370,15 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				goto out_unmap;
-			}
-		} else if (!pte_present(pteval)) {
-			if (non_swap_entry(pte_to_swp_entry(pteval))) {
-				result = SCAN_PTE_NON_PRESENT;
-				goto out_unmap;
-			}
 
-			++unmapped;
-			if (!cc->is_khugepaged ||
-			    unmapped <= khugepaged_max_ptes_swap) {
-				/*
-				 * Always be strict with uffd-wp
-				 * enabled swap entries.  Please see
-				 * comment below for pte_uffd_wp().
-				 */
-				if (pte_swp_uffd_wp(pteval)) {
-					result = SCAN_PTE_UFFD_WP;
-					goto out_unmap;
-				}
-				continue;
-			} else {
-				result = SCAN_EXCEED_SWAP_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-				goto out_unmap;
-			}
-		} else if (pte_uffd_wp(pteval)) {
-			/*
-			 * Don't collapse the page if any of the small
-			 * PTEs are armed with uffd write protection.
-			 * Here we can also mark the new huge pmd as
-			 * write protected if any of the small ones is
-			 * marked but that could bring unknown
-			 * userfault messages that falls outside of
-			 * the registered range.  So, just be simple.
-			 */
-			result = SCAN_PTE_UFFD_WP;
-			goto out_unmap;
-		}
+		pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
+					&folio, &none_or_zero, &unmapped,
+					&shared, &result, cc);
 
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out_unmap;
-		}
-		folio = page_folio(page);
-
-		if (!folio_test_anon(folio)) {
-			VM_WARN_ON_FOLIO(true, folio);
-			result = SCAN_PAGE_ANON;
+		if (pte_check_res == PTE_CHECK_CONTINUE)
+			continue;
+		else if (pte_check_res == PTE_CHECK_FAIL)
 			goto out_unmap;
-		}
-
-		/*
-		 * We treat a single page as shared if any part of the THP
-		 * is shared.
-		 */
-		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				goto out_unmap;
-			}
-		}
 
 		/*
 		 * Record which node the original page is from and save this
-- 
2.49.0


