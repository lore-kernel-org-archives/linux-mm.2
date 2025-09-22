Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE5DCAC5A8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 14:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51188E0005; Mon, 22 Sep 2025 10:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01288E0001; Mon, 22 Sep 2025 10:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0018E0005; Mon, 22 Sep 2025 10:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAD758E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:09:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7550311A53A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:09:48 +0000 (UTC)
X-FDA: 83917069656.06.ED5A002
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id B149E18000D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:09:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aX5+bNsp;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758550186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9Qxb9L3z2+JQmqk1+ImwRYPf1zbWOH1yWVv9db+fZfw=;
	b=Hpg8lefAkij/dkn1JxUoEC6Wx3qzu+a2ALF9Qv+gLMAS0SaIQaNS95m9L/svst/BAVuatV
	EVAperbCAPkjiPEAXwl2lHZrXu3xDzm7syGBMlIypwOT36cu/tukedTOVJS0KQ/eR4EG6S
	aOPO4RV7XxmOxz8MVw06pYnHUox1Oe4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758550186; a=rsa-sha256;
	cv=none;
	b=xWTeAsKGS5+fMcYklL37OdUTASBAgRk6KBCTz3uzWPFjqlm/+g6q8GbgRHOZTAKWWdN5os
	zXJTJ1u0u9Mgxaha921/frk1jJQAozS4yf/7njjh6/0zqlKUL1UjddlmmTZX9MD9Cc+568
	JB+VIP3w/SWlwh5MbiBsJwBn1XRbMhc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aX5+bNsp;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-62fd0d29e2bso4336387a12.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758550185; x=1759154985; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Qxb9L3z2+JQmqk1+ImwRYPf1zbWOH1yWVv9db+fZfw=;
        b=aX5+bNspMOJy+OYyYuApoV5Ihe4a/h/sQ5HZb5tX6fdb50ZlXwEsNpXCIvAtPJju5E
         vD4rjUxTxsK1wXMlHKyvIWnAcJ6mm6SYsZZ0N4+PWHuzQTNyD2Ag8R6O5VTCoblRV5D1
         g4mYLDmHbY4Y1PQgnM30vIU/qTJIbDgLKt3UbHS6VzeMHgVVi2YWiGgMry2R+0Hw2oUX
         ZbBK5RTzgeJuHs1t8wDgXTOAg9tcqHOGGBsD6IU4xWvZlmhP4IVvFp1g8WLL7kGcM/9W
         +lAgSOdLkVs5bABkgo7uNtlmg6FMOemKeou/mfjVXkXdZRP5Nag2AkoFjOHugExsqnnI
         /iSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758550185; x=1759154985;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Qxb9L3z2+JQmqk1+ImwRYPf1zbWOH1yWVv9db+fZfw=;
        b=BjLhlyE8bxG7uLFQVcWc1/1/mm1vmUWzFg7iCbddH5R+5fw9FyF58wRM+Lf3IrkROA
         VQ6o4UFcnQ1QKsP8sg07h4HvdsZVib40WU5V19QMfnvrj53AuW+W47fcLsAiILkFZvJv
         CqxutViNvJxjLm5V6H9jgDx4dKggtlgOkexozqMEUjoRXzVeUDAn0BSucuzuRKucu4hs
         HYv9uiAaHuky98EA/dL5jRWGqnXY6oH+tXlxG2JmzsJyPymvqt+1o2tCnptjSQfuFttC
         C43FRAtbCUmTciEAqAGfKNBSYmc6cxqoivdhsSncNACDxJ3vKg96f1plgzYWUqt4y51x
         QO/w==
X-Gm-Message-State: AOJu0YzXqoLyBxt21VB5PpdQEwL+QBuAkhXu5nkyGyCBuSmGr+m0qWuy
	cVioDGu8gGDmTECKV9WSovWPdiFHZImxSLjfPXHpBsBtHQrNXaxKXVwf
X-Gm-Gg: ASbGncticrPO1rkjmFCna0AvmClvdNDfSwNQ3gKy1fY2avYlMCMifudwwx7SGRipDcP
	+OSnKigDEx8Qq0xrQ9mS90paHseLLkdUjTaG/XNPLbyVnYXUiDjQ7kHgRu8D9AJ95L15dJv90xx
	qtnP3rPSn8y9K11Suedb00LOGlTe1QMDny63TdOW3LHT2SSqc7yDTQ3juNfxbH0uwEY4cvIb/w8
	MyV8JsJl20fYTHSkcAzrPj7a7hWyCX3g1MYicRcct7M9rH4SbW7dyDNzTzOmJJISec15F2uOa/H
	nV1fpAT83D5Ko1eUro3Z+QB6VyXjI8lJgjnOtxHPE7QhctLVEJhyH24L8Ab492dsKBKhKT4/SW7
	Rw7P1maD90n/OQC+3zXg1ZQ==
X-Google-Smtp-Source: AGHT+IEB2ZdENDpkUCxvWNQWI3MofcZPVnk7hSIdbE38FWTyBCvHO/TLHnChB1QFrjn6JS6r7wsFcw==
X-Received: by 2002:a05:6402:3510:b0:634:518b:c439 with SMTP id 4fb4d7f45d1cf-634518bc9f0mr1516448a12.28.1758550184656;
        Mon, 22 Sep 2025 07:09:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62fa5f1389fsm9039905a12.27.2025.09.22.07.09.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Sep 2025 07:09:44 -0700 (PDT)
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
Subject: [Patch v2] mm/khugepaged: use start_addr/addr for better reading
Date: Mon, 22 Sep 2025 14:09:38 +0000
Message-Id: <20250922140938.27343-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: tognikoh5j5d4uun8iib7ue181k9ew76
X-Rspamd-Queue-Id: B149E18000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758550186-53827
X-HE-Meta: U2FsdGVkX19SSR2MI1Ujkxnpsc/A7cBXMI8HkXG/gZh3xL2ig01D4yH+AMHdYuGOmogN2dtJ2ZsiAAYwIpGefeirbLFsPpSh77bu2JLAYBpmLHmFDkMzBz2Wncs3/dUzFk0Omx6ZoJ1D8h4Kj6M6WXickxzDUzjHeO41ge/FD397503NGdUKQjAw9Lc5Ww5dtLVCs9ie4toO1ieOtNqVMo1QBNml26GeKaNGqAz2vv6rf0ePWoqI5aEB8W+K0cLRcPzRHoM7c14CuHNVPjSFSoLuRYtHXPrSUYIyw+blBdnML/AQQ37VO2OsCW8RHwL7hOFTWW+VxTmLxx19/TC4fFz0zMb1cwNaLbqS3q5TnIATfWcC/zLExfsszqu/T6pEVgWmqOeQdv4YGilIL33NLBUZadBPHQ+wKMSDsovs2RDsut0b/jSysR50rQZ81OBJDcl15Nat4suv5U6pPFT2fN9rmisT5xZ6mDnOa/OMh/CkUM2Q+QKLMlf89lUrgMwUjQT7CqVxie6jAjkM41KA2a7ijvXZMZYPNNbtYWbuOx5j3oBv5EPFmog1BnYt5bRDET1m5XxKynEw0yZLicnp/TgQ6xZDkdFGODIEHf1ImiKZPG2o9Vv9xDmsf/deWsPZuZJZcFw1iz1NXBR+d53sc3ZoeY76zJ70pJR67bSS+6UoAAibiM4xUkouYcx6lBefqVulRrPqQStebUijNpkLebWUNLnRSOipkhQ06uP3xoF/uTp2HHWvIbi5Nq/spSvJsLjpJAENW6BxwKBnXLCHi3J3aVUPECIbKyKEhLai1xYlggsnluDrH7MzDDr/GzysDdewHeImCzUdFlaSxy9X6Ru9fJgkG0zPrs9GRAqdb5GFnlx1Luee6EHHSSVPfPSr2rsDjGu46b9STgQW4Zu8q330EZMY5wcEmaHJHonf5nQlfJFlJqKsB8NgZ1gFPTAakKnkI5ucLDPILcXFP6k
 cO9n65My
 UHl4ypxxzhecDMXIOybsQHuHU9QVAys7QEmNPy8zB2X+KkDWj95sfa5zK8lrRWZolxgn9TvHMaKHz2QDoKp1/U+fDlQF2DpMHSAKiRmh+HGdbki0f1WkqTDQpzdBLN+Kj3vEHf3Y6qJH7L7NxBnaagbzB6Q/NbkuIi3cRM7Lnw6uP5UcFC4mMk/yc2J1LsTCS3t1NEvYrBFKtcy13BF0O7kzT5yvfvksCM5iZEQx5Qbji544y33lnHZrliqiiX2x8gnXfI3caPw6ITtaABiZPHmhsnZNH08bRAx5TlNQSgxAAuzZR6YRYwEUuK0bSxUUt3DIgFpGg9MsqS/xBnH1Q8NrV+rwEjQqI9lcLR2MHKUDmB6t5m9Em04D9d2YvOzZSNAZWsjx8BfqzWaCcVDRnoUtRMHEL4KhzSNZY7aZoScK/cOltcwwwtKD0MEbatS4vVAqTJaIta87oooyHnksN94totAzCCmEdVsDD9x1d8SxuaGV/30nN/GDTxzW6MgoVznke+/2qW3jqM6cdFvSstcXTVm0000Aze6nCidYm0/ZA2E0U3gExL/e1cGRCClnAAB8KPYXWx1G4OiXaPuNkE34dWeeu0wQaWhqONzmVamuqdpBppALvNvMdB4qGN6eeantm
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

Considering the plan to collapse mTHP, name the first one to start_addr
and second one to addr for better reading and consistency.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>

---
v2: use start_addr/addr instead
---
 mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ec3f91a345a0..e3f7d1760567 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 }
 
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
-					unsigned long address,
+					unsigned long start_addr,
 					pte_t *pte,
 					struct collapse_control *cc,
 					struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long addr = start_addr;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, address += PAGE_SIZE) {
+	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			++none_or_zero;
@@ -570,7 +571,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			result = SCAN_PTE_UFFD_WP;
 			goto out;
 		}
-		page = vm_normal_page(vma, address, pteval);
+		page = vm_normal_page(vma, addr, pteval);
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
+		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
 
@@ -985,21 +986,21 @@ static int check_pmd_still_valid(struct mm_struct *mm,
  */
 static int __collapse_huge_page_swapin(struct mm_struct *mm,
 				       struct vm_area_struct *vma,
-				       unsigned long haddr, pmd_t *pmd,
+				       unsigned long start_addr, pmd_t *pmd,
 				       int referenced)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long address, end = haddr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
 	int result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
 
-	for (address = haddr; address < end; address += PAGE_SIZE) {
+	for (addr = start_addr; addr < end; addr += PAGE_SIZE) {
 		struct vm_fault vmf = {
 			.vma = vma,
-			.address = address,
-			.pgoff = linear_page_index(vma, address),
+			.address = addr,
+			.pgoff = linear_page_index(vma, addr),
 			.flags = FAULT_FLAG_ALLOW_RETRY,
 			.pmd = pmd,
 		};
@@ -1009,7 +1010,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 			 * Here the ptl is only used to check pte_same() in
 			 * do_swap_page(), so readonly version is enough.
 			 */
-			pte = pte_offset_map_ro_nolock(mm, pmd, address, &ptl);
+			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
 				result = SCAN_PMD_NULL;
@@ -1252,7 +1253,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				   struct vm_area_struct *vma,
-				   unsigned long address, bool *mmap_locked,
+				   unsigned long start_addr, bool *mmap_locked,
 				   struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1261,26 +1262,26 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
-	unsigned long _address;
+	unsigned long addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
-	result = find_pmd_or_thp_or_none(mm, address, &pmd);
+	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
-	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
+	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
 		result = SCAN_PMD_NULL;
 		goto out;
 	}
 
-	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, _address += PAGE_SIZE) {
+	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
+	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (is_swap_pte(pteval)) {
 			++unmapped;
@@ -1328,7 +1329,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 			goto out_unmap;
 		}
 
-		page = vm_normal_page(vma, _address, pteval);
+		page = vm_normal_page(vma, addr, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
@@ -1397,7 +1398,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
 		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, _address)))
+		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&
@@ -1410,7 +1411,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_huge_page(mm, address, referenced,
+		result = collapse_huge_page(mm, start_addr, referenced,
 					    unmapped, cc);
 		/* collapse_huge_page will return with the mmap_lock released */
 		*mmap_locked = false;
-- 
2.34.1


