Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CEAFCAC59A
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 00:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D688E0002; Fri, 19 Sep 2025 20:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535978E0001; Fri, 19 Sep 2025 20:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471FA8E0002; Fri, 19 Sep 2025 20:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 378D98E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:54:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF6D95B2A9
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 00:54:23 +0000 (UTC)
X-FDA: 83907807606.02.D1B75BB
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1DC8740005
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 00:54:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uh2YkfSj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758329662; a=rsa-sha256;
	cv=none;
	b=oCYKZRxmMqYuk+++JDjuoL8SQz6sUfTkept5IT+KZYpYf5DEfDzegR+31em6XaU5Tt2E0t
	3OGwoTEsPWIl6l7te5Y0RibODF/TzyjcTH/FzWAbSgzcucubJQ5FF5R9QkkNQ4JOWb2zc5
	b+qqvG65zH9SWHDaU6NL+3eRl7dWuow=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uh2YkfSj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758329662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=G8cNMOZczNOgsjexjwKCE71dZObLTWjAOqAKuGQRCD8=;
	b=FBoKsJn/pWPZUfVC6yywB7016e1hgDQWANBzVbmS5Ky+a0pIQsJ8TVlaZpz1yGqkpNeSPk
	ohcSGz0s5JYrQ157rEtSnGRH3iHk2EA/DOCsEXNDzQZYMCrTsr+JjvBvTAkN3yDjDffVwv
	RORflkSndxuthwUafmk4sUfPS4JvPPg=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b07c28f390eso480675566b.2
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758329660; x=1758934460; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8cNMOZczNOgsjexjwKCE71dZObLTWjAOqAKuGQRCD8=;
        b=Uh2YkfSjwSH9/Asmtj4BZgjSBw+DrUG3fOdDB3+2m8FDuXjn6H6FMofNFX6FL6ejer
         XdLZxwDNkauCeEqWSlQ98SOXyDfuMaf9lL73uA5SHGlnw5L6S+YJT7FVKK0MhIWaYTYg
         xfXjsa8ASFILdFTiIy+SJzJ7zyw0WtVtsBT3rcU/Zu6eqkkibEVCF6hXXay/GYh0nO1Q
         pXstxQNLBk33xLL04tu6LU5C/LWuRvs46fdAnoYtuaY9mAPtdmTxlP65p934sEq+bNRg
         fv8eti0Mnx6oyjeopinmjH3CVI+MSWrKhFN54KudWn3cVM6dPByF0fFBynGavQ9TegO1
         3iCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758329660; x=1758934460;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G8cNMOZczNOgsjexjwKCE71dZObLTWjAOqAKuGQRCD8=;
        b=WSLChGvcIM70kpa1eeyZXwZkEMiihkHF79V1BTBCefRjnltR4oT9VadxJ9IkdDbPhm
         zF3yYtLyjqcVFvvqz5UXe8td1voZEUZ5wFG4UjlWMV+oQgeVx8Gutwd/LSiFYU/vxUFK
         l5BrLgtcmU+0Ds3Qu4w3bzb6VqLrDjef2mFx3PB3SlKhd61aUCV2RZiw0SefJkaPveS3
         HpwJap0jWf8phExdL7UDoYSYLD92aXgzeolcU3kZpgqaJrIYe/zx7v6TvC8XEBkEvLFc
         td66LQWCdIx7EjespR35h+mhJ0eMyfxySOZ3p5Cze7CuShZoJb9qL0Cb7WG0ji1b6zsG
         9JCQ==
X-Gm-Message-State: AOJu0YxcPCLOJmahBu59+bp9rlEMhUCA3At+2jjBgUPUNYV87APhtpi2
	6EhbM1XxW1ii5Iw1CG8kJwogfax17anFi4JMCmzpZ3b4kD2sH7amqp7s
X-Gm-Gg: ASbGncteTZKGg4XqSkeSvacbbiXt30eWqeiMu/p+iar2OuSYGwc4DFyQIL5rrq6DYBl
	XAiftvaymrBStu0S4ugdADC5QkASNS4p6GVTNazukOEILwnCYPmfia1KF3T8apcYqqGT4Rl2e6f
	RHy6NV6ZbYG+crAtZzenDMl/RgYorUmY9J91Ls7sCkzcFYfM+z1qwV+qHQqrh712osjvzd0ND+g
	UGqWPbFBxIY9K/fVXbpEREsCGs/HWlm8eg1SMzz+TLBu7P6UidgJxljpZo3iCDSGTcNUAQQ1PBv
	U8H73stRYfbvDzJLvqOsz3BsF/FVqn27dFRF24ahLBFwndOpyGk0caHKwsjMIFGzGI3yPZQ5SQo
	AJ4FciwBwFQAcjNUxfpUj0Q==
X-Google-Smtp-Source: AGHT+IHBlYAPa1hT+fBP7Usd3Oo0gbiEobXnQrEMpSFsvc+pSNfKox5WvrjKVEw+N69Vq30kDjb8OA==
X-Received: by 2002:a17:907:724b:b0:b0c:b51b:821e with SMTP id a640c23a62f3a-b24ed886dfbmr664108566b.9.1758329660069;
        Fri, 19 Sep 2025 17:54:20 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fd016e8d7sm547034666b.62.2025.09.19.17.54.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Sep 2025 17:54:19 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
Date: Sat, 20 Sep 2025 00:54:16 +0000
Message-Id: <20250920005416.5865-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1DC8740005
X-Stat-Signature: hnrof3i73oqtbuebej54mrhfmngsc4wa
X-Rspam-User: 
X-HE-Tag: 1758329661-676540
X-HE-Meta: U2FsdGVkX1+xHUldjOyNEKUnbJuB3XtP+GkQ75qxhhW9Ngm75lBEkunyIp+O5By0ncv4ldTGXwq/46b7RmCYtcJVcBbAFF5GV2/PZfniCscU9lf0UE8b9JS3pz5JaqKhXRGbbAaxet+XqrkrZa6qpyLCC0kS85nqcTDobFFtXsBpRFA1ZnodmtlDvJw9S3sqytgyrJgVxl9vBYGPgMJ0XLxR5cIGiro8AcW30YRBHiqFgxrCyHX7YxcpJq0uJl2wAq5CgRI6yXe2vxEVaQh/YiSjkN+Iq1mCjua3BDxUcATNTxQvOrqN9Cyoj8MlRHovZEmzUXHAyb4UD5df3rNoS7xg8LR4kedCq+mfQ6rZtOxSi7ojyfT4LJb6F2uRe58ag3JHBTaFjeeqynq9vjzbniMYP8fT6fCvkHSlte9OJeVcb9S6oX0NOoKBZBq7GUVNKeuZfXu/2PqnestsQ8/hdTixsrHgD/LGYBcjvviOXovJG36IfqRwrh3IHY1wXgJIVNkgEIz1X+JCV/yZjme8LV5IQ/Ip1JYbdt7AtlIbTa57D75MzxhRfdYgovVJoEtQz0DeNLH6v5znx/XAO3rd4vTDkOeLb+i+E70xOx/cIUNExlIb6dkOZNXsm4P0HJoKeW4KOfqEb45e+6P1ijJFTiaVD77vLWbEkTXeVgPegP0QRAK9lvVT3aNTTbP36OwhlZg3Cy3Qog1/Tb4VrY1lU8Kw93pKe2vEd9Rpbq3qZtCx5wTb/DDAvQRPvrth4a7tk589gJ2jGV/F854p5TPDGPQxbBeyP1bYVUFaDr0wyRFqELDSUYm0Aze+SXp9SqIHrDiqWqG4XJRzFIs3IY12lzAocUQWKvK4WDExSZ4bx6+/cf7yJMMJ+5vsEWZLgv7vlRaR1EbP0lI4EV6XsrXEabff/net9E7kTyHlNPUZu/E1xFDLUsnclwdF/OXhrevKPjyGMMkPSBWfs0XNwuB
 zo4O2XEv
 yiAp0giCZmYrUKWl4IiUsuPL3w+2fAHbD0shJic29hx+AEQeSLb2LzzrK2vfBy8MrhXN+m2mjNrvWdK8QAN0KYYotRJxzytP5HfRAmj1AQ1hhRHWuW2rRWO9f/2i3xlj+vdael2VP6r6O7rqVpvri3liMfsDFgYCrqlWINR9KhcXIe5ceC2SoSN8otou3hiPhrOhtlS4EmNM5b7UziBEaQ4tzy7joegnGaDAxVT7EcYMfVng5wdgVwAYJcb3T2jfFME/pdKK12md0WNmPNx68erTk0XwP4OK1lGT/k+H7j8sK3r4Mk6Ut0L4iD0MKMzABWni+2/xhO648qHluFykp+J/XQrRT94GL1MpdN2VM3hF83ryULV2Flx+vJfy+Rvo81lCzTq++BRjZ3U4I9j9wfTjLaI52jNvqZsanlRboTKwMLyFP5HfmTGVKtvnSC5tbahF8Oa63jMynykCB2hRlmgHj55gkdSVPi9pDCsZXlYExtaXR04ywbktn77DPZsvoiCxWsaoAaJ3/zZGVXY2i07ybkkYLtk2Mlx2PyKPy1hugtaKH3upfv2CP12ZwTxDgFFwwBV382MAh1HknzraCnUWQxq3zeg6s/Ds8SBVgkpZNdzIUsmJmkPvzGFl22C0be5YN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When collapse a pmd, there are two address in use:

  * address points to the start of pmd
  * address points to each individual page

Current naming is not easy to distinguish these two and error prone.

Name the first one to pmd_addr and second one to pte_addr.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
---
 mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4c957ce788d1..6d03072c1a92 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 }
 
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
-					unsigned long address,
+					unsigned long pmd_addr,
 					pte_t *pte,
 					struct collapse_control *cc,
 					struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long pte_addr = pmd_addr;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, address += PAGE_SIZE) {
+	     _pte++, pte_addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			++none_or_zero;
@@ -570,7 +571,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			result = SCAN_PTE_UFFD_WP;
 			goto out;
 		}
-		page = vm_normal_page(vma, address, pteval);
+		page = vm_normal_page(vma, pte_addr, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
@@ -655,8 +656,8 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
-								     address)))
+		     folio_test_referenced(folio) ||
+		     mmu_notifier_test_young(vma->vm_mm, pte_addr)))
 			referenced++;
 	}
 
@@ -985,21 +986,21 @@ static int check_pmd_still_valid(struct mm_struct *mm,
  */
 static int __collapse_huge_page_swapin(struct mm_struct *mm,
 				       struct vm_area_struct *vma,
-				       unsigned long haddr, pmd_t *pmd,
+				       unsigned long pmd_addr, pmd_t *pmd,
 				       int referenced)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long address, end = haddr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long pte_addr, end = pmd_addr + (HPAGE_PMD_NR * PAGE_SIZE);
 	int result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
 
-	for (address = haddr; address < end; address += PAGE_SIZE) {
+	for (pte_addr = pmd_addr; pte_addr < end; pte_addr += PAGE_SIZE) {
 		struct vm_fault vmf = {
 			.vma = vma,
-			.address = address,
-			.pgoff = linear_page_index(vma, address),
+			.address = pte_addr,
+			.pgoff = linear_page_index(vma, pte_addr),
 			.flags = FAULT_FLAG_ALLOW_RETRY,
 			.pmd = pmd,
 		};
@@ -1009,7 +1010,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 			 * Here the ptl is only used to check pte_same() in
 			 * do_swap_page(), so readonly version is enough.
 			 */
-			pte = pte_offset_map_ro_nolock(mm, pmd, address, &ptl);
+			pte = pte_offset_map_ro_nolock(mm, pmd, pte_addr, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
 				result = SCAN_PMD_NULL;
@@ -1252,7 +1253,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				   struct vm_area_struct *vma,
-				   unsigned long address, bool *mmap_locked,
+				   unsigned long pmd_addr, bool *mmap_locked,
 				   struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1261,26 +1262,26 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
-	unsigned long _address;
+	unsigned long pte_addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(pmd_addr & ~HPAGE_PMD_MASK);
 
-	result = find_pmd_or_thp_or_none(mm, address, &pmd);
+	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
-	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
+	pte = pte_offset_map_lock(mm, pmd, pmd_addr, &ptl);
 	if (!pte) {
 		result = SCAN_PMD_NULL;
 		goto out;
 	}
 
-	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, _address += PAGE_SIZE) {
+	for (pte_addr = pmd_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
+	     _pte++, pte_addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (is_swap_pte(pteval)) {
 			++unmapped;
@@ -1328,7 +1329,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 			goto out_unmap;
 		}
 
-		page = vm_normal_page(vma, _address, pteval);
+		page = vm_normal_page(vma, pte_addr, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
@@ -1397,7 +1398,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
 		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, _address)))
+		     mmu_notifier_test_young(vma->vm_mm, pte_addr)))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&
@@ -1410,7 +1411,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_huge_page(mm, address, referenced,
+		result = collapse_huge_page(mm, pmd_addr, referenced,
 					    unmapped, cc);
 		/* collapse_huge_page will return with the mmap_lock released */
 		*mmap_locked = false;
-- 
2.34.1


