Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18180E9907D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852A36B008C; Fri, 10 Apr 2026 06:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB636B0092; Fri, 10 Apr 2026 06:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA866B0093; Fri, 10 Apr 2026 06:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD2E6B008C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:32:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EACDD589C5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:40 +0000 (UTC)
X-FDA: 84642282480.17.CDE59BA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4CBD540011
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hlfgag3m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817159; a=rsa-sha256;
	cv=none;
	b=I6vO6p/iYNqBOYc4MeML9/t+TutMNrhsqmdtmD91zyQ62ZCpgc2wYuYvflDZz2xvUqJl0C
	6aUvCehOayBpqe+zYhWbCiPVnJoSa2Xw2Pjl9a11436ZJLUzQfvZSGOKuOpHEXDqZtkKxn
	C1gKL9E4j7nRzsT1wq+v6/CMAfpsYq4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hlfgag3m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvQUW9r2k1zUAE/WM2/OtV9ZWn4hYhTm/W+zHDMUAkc=;
	b=rk3LA0EY7ZP7jg9QkjT5ze+wAEtMqor8EiPPLFKbaWn6sINHdjS+F4LK9VCLX3QZlogFUa
	TTU+6173314i9WNPQ0UQN2+9+RQKx3jhio89mpLaJguYJrFvNbtpmIAwjYDqbQHFvSIdFD
	vASPZFam97E8GBGUW3eJpsg2wNWzDu8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90C291D15;
	Fri, 10 Apr 2026 03:32:32 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1D7403FAF5;
	Fri, 10 Apr 2026 03:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817158; bh=KqK/BLpNLmdQmMsGUTYd1FsmAxRcfYnyllCg9XkaRKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlfgag3mwCqDdiXjfNp6lxjv9ajfCvqnk5tv2ugz0FTuP0baBeKU00MNal0bmhW/c
	 wKEcljzN0/PwWMn7eJTz8IKalf1LNPmZMCozknskvDnUGYDX93b1f+AZTCCBfCQ/8J
	 CPk8cUx3BxA54lJSKuwhbRRgJzyFaZfSDXpZ0DxE=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 2/9] mm/rmap: refactor hugetlb pte clearing in try_to_unmap_one
Date: Fri, 10 Apr 2026 16:01:57 +0530
Message-Id: <20260410103204.120409-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4CBD540011
X-Stat-Signature: xe3ehfkfohr93h5m3q1z9xsawfquraxq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775817159-880833
X-HE-Meta: U2FsdGVkX1+trj8sZ2PBbpn3AjlZqlCDAfsKyQ1W6Y4OTeF864Da5IB0aUFDT4n3mXc5osfwMTR5RjuoueJsdMW23SIeAT0ZWwqhZgFX9i4apWoJtNq+8dFp8t9gmkGfDtOZb7vU4SFq5dAPCTpmsGZ1I9MkovnQc6lVuxm7VrF4XzY8NOdPEKGditL2/sq4QReQpUZRH8dh+ZBKdxz48L16Xp+TsRJ4VWE1/fepG5QWQwJXWpbU2HXUanH21o0q7bBtKq+fpJguaRNf4CFug6tuSHCTugYM8WbsoHhFPha01rgyV/vsu6uQ8aQRQXQy0mdbM5c75HrJIjfVeu/kolj2S94EyBhb2KNnOc8KO6cceeV/EGpg8pITubHUFkofgOSvSQY2rEjdLpdN0dCnP7tHBYSXsvP/lqJW5FCR3ERypwkV4SeFzeE8mNMPP0Xue+z3akgRN2zXl5yXaUUKevl6C5DnBwebOWKCrcEFtSPlbK0deQfSfcP2MWavR2o9ukBjj6icsvfIwGj59S5AaXA90PdGN9ZqaLmItIwWHBbW4GC3m/GI80qIZ00mP8M7VntVxg70ip1kfSwthwjpNjg2DyXjnAipylcW+gFPtWDk2KZ2Ca2HgV3VX1Lf9FDrNl/gh0EyXmsu7+aohT3xLGW543T0ym4otPZifnCsRczkZsUixHeYXTUerJi7FrLxp93Ky6RbzT0/7Ir2yzUjSSq4LeeazD7RZUAXfdJzwZOFnsRKkY5WCGqtFo9k0u3A0DjOSRRUteeubZZjdpG93MHUdv7HUukV36KiihlnzCDL8FBBCSApDCVn5aAlGap9lshR10hhkXI2/s7M7021JgyuKd/m5k/RkS8KuH+HzwqF6PUXinbYzWjQJ3go3twWqyZdE5Exz/BvhnUa95s57yFrfHnNeiR3X0C/A9zt2khQiLm7PeXDI4suRYrT+pAUr0zfSUvLGBw8UDsLKlJ
 oE9oHYaM
 5zEzcyXnQrCNY7Dc3ly0eQle3hqlmVguF64RXDN6wlDaslVAdRCrMyRtSB6EveBzIX+aAbF/mhbgI1jGHPMFcFl+ihTI3VHSvmSRE2PI/9eI6EJVi6F7eWYY8n5UYPw5MaruYY2oV20tUr0cZuKpjG/bveDP0ZBbMXFeI2RKD9HFQRjJeEQ/sUSTnWtssXCsImtLayVN0Wgc/v7eguDvUNzXetyE02Mhp7QQkMW727hoRcpUmuYTH52UAFOuDt/CUDpHDykNTJduw5ZpEmVgfUkKhIsqLhwNh/0y0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify the code by refactoring the folio_test_hugetlb() branch into
a new function.

No functional change is intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 116 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 49 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 62a8c912fd788..a9c43e2f6e695 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,6 +1978,67 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page_vma_mapped_walk *pvmw,
+		struct page *page, enum ttu_flags flags, pte_t *pteval,
+		struct mmu_notifier_range *range, bool *walk_done)
+{
+	/*
+	 * The try_to_unmap() is only passed a hugetlb page
+	 * in the case where the hugetlb page is poisoned.
+	 */
+	VM_WARN_ON_PAGE(!PageHWPoison(page), page);
+	/*
+	 * huge_pmd_unshare may unmap an entire PMD page.
+	 * There is no way of knowing exactly which PMDs may
+	 * be cached for this mm, so we must flush them all.
+	 * start/end were already adjusted above to cover this
+	 * range.
+	 */
+	flush_cache_range(vma, range->start, range->end);
+
+	/*
+	 * To call huge_pmd_unshare, i_mmap_rwsem must be
+	 * held in write mode.  Caller needs to explicitly
+	 * do this outside rmap routines.
+	 *
+	 * We also must hold hugetlb vma_lock in write mode.
+	 * Lock order dictates acquiring vma_lock BEFORE
+	 * i_mmap_rwsem.  We can only try lock here and fail
+	 * if unsuccessful.
+	 */
+	if (!folio_test_anon(folio)) {
+		struct mmu_gather tlb;
+
+		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
+		if (!hugetlb_vma_trylock_write(vma)) {
+			*walk_done = true;
+			return false;
+		}
+
+		tlb_gather_mmu_vma(&tlb, vma);
+		if (huge_pmd_unshare(&tlb, vma, pvmw->address, pvmw->pte)) {
+			hugetlb_vma_unlock_write(vma);
+			huge_pmd_unshare_flush(&tlb, vma);
+			tlb_finish_mmu(&tlb);
+			/*
+			 * The PMD table was unmapped,
+			 * consequently unmapping the folio.
+			 */
+			*walk_done = true;
+			return true;
+		}
+		hugetlb_vma_unlock_write(vma);
+		tlb_finish_mmu(&tlb);
+	}
+	*pteval = huge_ptep_clear_flush(vma, pvmw->address, pvmw->pte);
+	if (pte_dirty(*pteval))
+		folio_mark_dirty(folio);
+
+	*walk_done = false;
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2115,56 +2176,13 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				 PageAnonExclusive(subpage);
 
 		if (folio_test_hugetlb(folio)) {
-			bool anon = folio_test_anon(folio);
-
-			/*
-			 * The try_to_unmap() is only passed a hugetlb page
-			 * in the case where the hugetlb page is poisoned.
-			 */
-			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
-			/*
-			 * huge_pmd_unshare may unmap an entire PMD page.
-			 * There is no way of knowing exactly which PMDs may
-			 * be cached for this mm, so we must flush them all.
-			 * start/end were already adjusted above to cover this
-			 * range.
-			 */
-			flush_cache_range(vma, range.start, range.end);
+			bool walk_done;
 
-			/*
-			 * To call huge_pmd_unshare, i_mmap_rwsem must be
-			 * held in write mode.  Caller needs to explicitly
-			 * do this outside rmap routines.
-			 *
-			 * We also must hold hugetlb vma_lock in write mode.
-			 * Lock order dictates acquiring vma_lock BEFORE
-			 * i_mmap_rwsem.  We can only try lock here and fail
-			 * if unsuccessful.
-			 */
-			if (!anon) {
-				struct mmu_gather tlb;
-
-				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-				if (!hugetlb_vma_trylock_write(vma))
-					goto walk_abort;
-
-				tlb_gather_mmu_vma(&tlb, vma);
-				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
-					hugetlb_vma_unlock_write(vma);
-					huge_pmd_unshare_flush(&tlb, vma);
-					tlb_finish_mmu(&tlb);
-					/*
-					 * The PMD table was unmapped,
-					 * consequently unmapping the folio.
-					 */
-					goto walk_done;
-				}
-				hugetlb_vma_unlock_write(vma);
-				tlb_finish_mmu(&tlb);
-			}
-			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
-			if (pte_dirty(pteval))
-				folio_mark_dirty(folio);
+			ret = unmap_hugetlb_folio(vma, folio, &pvmw, subpage,
+						  flags, &pteval, &range,
+						  &walk_done);
+			if (walk_done)
+				goto walk_done;
 		} else if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
 			end_addr = address + nr_pages * PAGE_SIZE;
-- 
2.34.1


