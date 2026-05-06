Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C1BCD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DD696B0093; Wed,  6 May 2026 05:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E4D6B0095; Wed,  6 May 2026 05:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A49B6B0096; Wed,  6 May 2026 05:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68C3E6B0093
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:45:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D7B8A071C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:39 +0000 (UTC)
X-FDA: 84736512798.15.CD8448A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7476D40008
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="pzJ0nG/t";
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8C9tZL7gpvuEBG0T+2oueQIx5zK24TqQVWeXHW32JE=;
	b=dS9cjEzIDYvfuWCZD8Kxr8EpPPY7LN9EONxri2WgpzFUxeDWMI2+P+hqd+a9yP7AWpunTw
	1E5jVOlzpFjtN8x8rNttxCdkKlrCuHpZB9yYimS8ZBd80BcB9yODe3KcHg3Cgizv6fDxdJ
	1TJzA+K7o0hquMtsDqpJZGZMsvmbSvk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="pzJ0nG/t";
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060737; a=rsa-sha256;
	cv=none;
	b=FuHnQUgo3mbKYKEtvr44fRD0s78otrirznggLAuuV4uLONy4o982VsLjeMDVEc3Gwqk1JH
	63ibh6jRDb0kIkI2a/5tJVXIjLnoPY/LzSSG3fjuZmh0j5xo1FlgA37Em0H9VsKefbNIKa
	uD0DJBHrerfrHrIs8sbeoQu9+IH6n9w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49C163328;
	Wed,  6 May 2026 02:45:31 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BAB2B3F7B4;
	Wed,  6 May 2026 02:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060736; bh=WFSAinoeSdGbZS0HtLKn0OlKsR2qi4l9xuRSCZXTgnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzJ0nG/tFSWCFnx4LKVFc/jvZ/e6hA2Xe3F7Qg6/50lgBzXX+YLRGWHvyUuOtbZ/7
	 gkwcrbZxsLf9bmVVRJMILFpbFgEHDsFgMoonN4g1UQnx8cn+yq/AI3achiIgKhC4Fe
	 CtxbYr29XumOkeuYeI6s8Tp3boOJd510gW8Gdv7o=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 2/9] mm/rmap: refactor hugetlb pte clearing in try_to_unmap_one
Date: Wed,  6 May 2026 15:14:57 +0530
Message-Id: <20260506094504.2588857-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7476D40008
X-Rspam-User: 
X-Stat-Signature: o9ftzxgg1qfo4jmjdpod8b864jbs85it
X-HE-Tag: 1778060737-783026
X-HE-Meta: U2FsdGVkX18QGAr2bAcZ6B7LZbUkthrV5Zw2bXWRCIPlZfOsYKP8hA0Z1yv5rQIep+PXUHVMgImsmETkodbvMau/GyzZwQ8IrWGmiMM45E2SEO1Syw/0Cq415NaXzCJ/GgRiKRaHXQ4L/fpyLN7CkAVoaodMNn4UR/exSiejKRojxqMCdOWuvb6DB4vmkJZYSMs/7Xsx9nPg7QHxy8NNuoLLbDbRMVWPnm4vdoNS02xPZ6Kx4Y2ANR3YXux7R3synn/Cg9zJWJ8cUfREb3ugmljewXyNRY58ioZJvOUKuRhysl8eVu5teobuoVSxHWAS7338wNTCk0fJnN5IzCo7Tr2wPUn4U3qme+O0FGsn+Ha/GWOscdF8VDbSRSA63p7dszgsIFn7yG1YYuOczAqXNT5n4sOmxrNR/JLu8291MpaQz2JEVGpvk1X3r+xOpicyrenZk8SA1M158cYAaVQDmbH5WFYriBJbeBYrVvzdxf0cTfgrzlNehKsigzQF+g80SRsb7kPKbiIt5J50ntUoGnhJDRE3j9KZllzNkubfzTPYnZKiqv1YJX9XuF2Wnb6AbivEX149oJh2C2XNYfW//Fwu5KAWmFLWx468MUcNK12DSSFfMer1zaLHtppNuTjcTYpZixUpwX/0UWOzNbMmBMDnCZL84AZv7FO/iXiLkzs0qS2zvzrHbjAixFZPOClcsK+1tPufyO0dRB6yf34k3rr3HOb8qq43A42GtnT7IB1ijQ29cPNB1UTu9TahrXgw3bNFF1CLqBqhthFfMlfCSOt6tusXc2UL/2Dh71M512VmAwPoTteOcqvZJpepINEUKNhil/zjvJImfrZvRaGWf3IaUwOeumvJaVnUTN1OEYLrDVKv2To4fY0HqIKkNlWVCdzVub3q6E8lBkqSoc5mF1ocJS0HT3bDVChCEMCv1dTt8NKEzMoPHsjWUVL6b/gRH142+iIcOHyEc8e7fx5
 aj8n7HSn
 hetaXJ8ToTQQseotb/fodKVtp/BIJVaFZ0UNrsjzzIj4ffxEr53GU9Jhtytw61wPL++q//dH9uqeUNVV9HRTbSUgYZfd+E9PJparrgkNQXG0Ebyi/vrJkCVOzgwtjzq6KnzrdKBLoMpxIJz80pHAMvI8AcwZmU0Guxn3YTyYCRjBpkwSYuuNv0k4zv4NGulwh/4u/T3u8fJTxMT6KOCLcvvEt5TK53L9n3knC/rll20aCgY2iaXBGfHYUdCYiEL+F+cdIpeOlHEgypfA29sTZjADeIjBwhUKVrvoU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify the code by refactoring the folio_test_hugetlb() branch into
a new function.

While at it, convert BUG helpers to WARN helpers.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 117 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 48 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a5f067a09de0f..a98acdea0530a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,6 +1978,68 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+/* Returns false if unmap needs to be aborted */
+static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page_vma_mapped_walk *pvmw,
+		struct page *page, enum ttu_flags flags, pte_t *pteval,
+		struct mmu_notifier_range *range, bool *exit_walk)
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
+			*exit_walk = true;
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
+			*exit_walk = true;
+			return true;
+		}
+		hugetlb_vma_unlock_write(vma);
+		tlb_finish_mmu(&tlb);
+	}
+	*pteval = huge_ptep_clear_flush(vma, pvmw->address, pvmw->pte);
+	if (pte_dirty(*pteval))
+		folio_mark_dirty(folio);
+
+	*exit_walk = false;
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2115,56 +2177,15 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
+			bool exit_walk;
 
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
+			ret = unmap_hugetlb_folio(vma, folio, &pvmw, subpage,
+						  flags, &pteval, &range,
+						  &exit_walk);
+			if (exit_walk) {
+				page_vma_mapped_walk_done(&pvmw);
+				break;
 			}
-			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
-			if (pte_dirty(pteval))
-				folio_mark_dirty(folio);
 		} else if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
 			end_addr = address + nr_pages * PAGE_SIZE;
-- 
2.34.1


