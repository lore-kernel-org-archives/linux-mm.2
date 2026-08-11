Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB98C5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842B66B008A; Mon, 10 Aug 2026 23:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9AA6B0092; Mon, 10 Aug 2026 23:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708636B0092; Mon, 10 Aug 2026 23:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30E536B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:07:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8944540333
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:12 +0000 (UTC)
X-FDA: 85087502304.23.6755225
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1B777140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kEOSdFEl;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786417631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZ/rjKRcYKxx8KUHZb4cFiPQxKG7HSt16TQtpyQm7Yk=;
	b=F082ZSiNTNxBblsff3aZzzBqaHrOfY3kVlaWS7PIszboSg/6woYmiBNK0br4ydQZOnn0Pq
	wQwI4h8Ei2asRPW6LQKAA/h89urb+g/0MH0MIlWnD0JDr09eQtFnn+jUjr+3VIqNDM+VH6
	eQAgdtn75RWDPcaQso5yHmiNdaNKE4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786417631;
	b=cnrHL+lLZRU+Ht74OrSmpMqXDtsnYImEhHU3RFFOFmSPeXRFt3VS352XqIwm7DuukcDAid
	6/jiauexiQtT/n6btL8xnN2s9m5X3WacH2Cj89+x8kTXaUPZfYkhiQE4bfkmonCdMVfxxt
	CSpPjZ160DIBo8V/eJhCu+Jom+YU28E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kEOSdFEl;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eZ/rjKRcYKxx8KUHZb4cFiPQxKG7HSt16TQtpyQm7Yk=; b=kEOSdFEluEJOxNHhfym9xqH9nc
	pQLLzVDfYv4xko/kenTv63WmjX7h+eRwy5uib9secxUzrKuCHnQj5QLFPURhUiQe32Az9Xe9MaUF9
	ujvJ18g7t7KzgoJsYML9R8z/zanxAxZWDTSAxLlQmpNWaxA2l2IBvXdl5zfdvrlAtUxExHuNTXqo8
	67zOIHV7yNVoLs3fHIlDiO3Ny5Fk8on0gl3tBRxuUtPnmgeSxcWsHHkyY7k15vOGqqsl6i8N7h5Nq
	hH1As3jBby+MCCUn86l+a5Ol2wmDTa/EUHpo9Ht1z+4Cms+cfwBqZUPsI05dmpbDeqYteLFo3ZNL2
	dAGKEAhA==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtcb6-000000007kZ-2wGb;
	Mon, 10 Aug 2026 22:52:12 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 7/8] mm/gup: walk multiple PTEs per follow_page_pte() call
Date: Mon, 10 Aug 2026 22:51:56 -0400
Message-ID: <20260811025157.1632867-8-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1B777140004
X-Stat-Signature: so7x54ny4cyufts1dywkkz3k4bao1trz
X-Rspam-User: 
X-HE-Tag: 1786417631-984219
X-HE-Meta: U2FsdGVkX18rjABKJQUYGelR/EFfr6rUGAvl/MwW0wTrJVILIMyrxCniUvPWV8nWGYoT6NsF1Sg/jF82O4Nh+v3BmvucwcE6JZlGzgq7CRxP8QwpzlKt1ZdE4aBB9zRVxdKVROcMIaq5ZXiNvni7yf/whCix8MY8JkDxZJOvrWvkg/k95mReT53mQNb8zce2fH7oxQ15AK6RwXsO8WESlE8tY55CC9D8/tFdofVFzBuSAbXb2Gk6GnybiWbqZbqt4yPNwFxdSk5kBjV7YOpALXrSjNOLmsrok+RQ14C07xOGkLyMZzL5rDP5KA57TSWzCbfokbhi45o9i68OtHgQoRgt/xqHrQKwvX0tZ0xvZ8BwwUTa/g+P55Xm6VD2KR1kTyCja65d3UjR4VTlSUBSVyMLTfzYWgl8i9li60x4M25gAiHUNRMeqrPmHcV4ZuUHQHvgPRjxyd4yHrDedttlQdJlJwSbcDr2mYZcPIwdAF2YmZt4GgRa4f6ZX7vbCsk1uQMagIDW6C37r8bgmlcgrcBUX1Zi3LvBI5GNps0YJqArCVTfOVBVbbBmmdZmeFQZhTmAR24HFNkv7BgkpRLlqmpCDrymmZM7vWyVKKykRAUDHjL70rrSRqe1HK798CT+CSFHH9lAJYqt4ilb9SJtXwxStfMNseKcXvN+negYlxXnesaJxEEZ0ckqS4FC+F9XhtmU+PqdWQxCbSO+46Exoob4vmuggdVsQQIzC8Sc20pok2qRST7isyVuJM8ylnf8mxJf7b0ORUXzjS+15Vh6V4V2YNsvEtjXKijAnt4tfjgHfi5evvXpTUW5n48eXFsf8Dd+W/s70Ug6+sf/jmQv0sLiXCZoOALCYdBxFfjsla1IDup+z/X3PT62TZew7NQhvaDOXSeOYwfxl9KNNq0H+95svoFsUOfGHy19ECu/GPO2h2kpi3cWW920y6zN+2V8biSl9fOWBCw6VTL+naW
 b6dw1a4I
 5v+QExMHlcIzKANX4wHYLceAmW6otFHMxWNvKpMnLx4+PGb/Pc9oOjWmzrkoF7CY31qdAGY2D9pDrezbXVRse7Kk2M8hGUl9WsMi/Dl2HTt2LJ7ve+n8l+H6zypOosvd1MNujjKt1laJCYyT1LKUFoIw2yZEIL9fp4nTG8tFSETUoGUyI0o/29TI8MHXFUL1vvDpuDmDDe4Zr/ulksEJCPyJcYfbjxeab4o+gO7X0lNsfKYhZfmJutmP90BAMtRDZseZHfRZbrsDTnmcKxhGFIeP6W+vvY9Ad/e6LvOOdzfiVtCC3SCrz5vncPU+vRB+eatYF1sJs63ySjeeFPGb7M76VHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_pte() looks at one PTE per call, so __get_user_pages() calls
it once per page, restarting the pgd/p4d/pud/pmd descent and retaking the
PTE lock each time.

Walk every PTE from @address to the page-table/VMA/@end boundary in one
call instead. Adjacent pages from different folios, or plain base pages
with no folio relationship at all, are covered by the same call under one
lock.

A failure on the first PTE is returned as before. A failure after that
ends the walk, and __get_user_pages() retrying the read gets the error.

Measured with mm/gup_test.c, median get time over 16 iterations on a
256 MB MADV_HUGEPAGE region in a 4 CPU VM. Folio size was confirmed
through the per-size anon_fault_alloc counters, 4100 folios for 64 kB
and 128 for 2 MB:

  gup_test -L -m 256 -n 65536 -r 16 -t
                        before      after
  4 kB base pages      2753 us     1178 us   (2.3x)
  64 kB mTHP           2946 us     1361 us   (2.2x)
  2 MB THP (control)     72 us       70 us

Base pages and mTHP gain about the same amount, because what is saved is
the page-table descent that no longer restarts per page, not anything
folio-specific. 2 MB THP does not reach follow_page_pte(), so it stays
flat.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 62 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index ea2bb379183e..c4233a7b8a48 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -916,38 +916,60 @@ static long follow_one_pte(struct vm_area_struct *vma, unsigned long address,
 	return 0;
 }
 
+/*
+ * Walk the PTEs from the start address to the end of this page table or VMA,
+ * whichever comes first, and commit every page found.
+ *
+ * A failure on the first PTE is returned to the caller. A failure after that
+ * is a short read; __get_user_pages() retrying the read will get the error.
+ */
 static long follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags,
-		struct page **pages)
+		unsigned long address, unsigned long end, pmd_t *pmd,
+		unsigned int flags, struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	bool need_no_page_table = false;
-	struct page *page;
+	pte_t *ptep, *orig_ptep;
+	unsigned long walk_end;
+	unsigned long nr = 0;
 	spinlock_t *ptl;
-	pte_t *ptep, pte;
-	long ret;
+	long ret = 0;
 
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	orig_ptep = ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
 		return no_page_table(vma, flags, address);
-	pte = ptep_get(ptep);
-
-	ret = follow_one_pte(vma, address, ptep, pte, flags, &page);
-	if (!ret && page) {
-		ret = follow_page_pte_commit(vma, address, page_folio(page),
-					     page, pte, flags, pages);
-		if (!ret)
-			ret = 1;
-	} else if (!ret && pte_none(pte)) {
+
+	walk_end = min(pmd_addr_end(address, end), vma->vm_end);
+
+	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
+		pte_t pte = ptep_get(ptep);
+		struct page *page;
+
+		ret = follow_one_pte(vma, address, ptep, pte, flags, &page);
+		if (!ret && page) {
+			ret = follow_page_pte_commit(vma, address,
+						     page_folio(page), page,
+						     pte, flags,
+						     pages ? pages + nr : NULL);
+			if (!ret) {
+				nr++;
+				continue;
+			}
+		}
+
 		/*
 		 * no_page_table() may look up the page cache, so it cannot run
 		 * under the PTE lock.
 		 */
-		need_no_page_table = true;
+		if (!ret && pte_none(pte))
+			need_no_page_table = true;
+		break;
 	}
 
-	pte_unmap_unlock(ptep, ptl);
+	pte_unmap_unlock(orig_ptep, ptl);
 
+	if (nr)
+		return nr;
 	if (need_no_page_table)
 		return no_page_table(vma, flags, address);
 	return ret;
@@ -969,7 +991,7 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -982,14 +1004,14 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
 		return pte_alloc(mm, pmd) ? -ENOMEM :
-			follow_page_pte(vma, address, pmd, flags, pages);
+			follow_page_pte(vma, address, end, pmd, flags, pages);
 	}
 	ret = follow_huge_pmd(vma, address, end, pmd, flags, pages);
 	spin_unlock(ptl);
-- 
2.55.0


