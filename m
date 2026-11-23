Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C4E1606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=QkrF3T6H
Received: by kanga.kvack.org (Postfix)
	id B5DAB6B05BE; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA5F6B05BD; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C356B05BE; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 760826B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5935640968
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:29 +0000 (UTC)
X-FDA: 85467440898.08.0A5FC8C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id BF8EC4000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="QkrF3T 6";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463787;
	b=LtRvv8/882KnAK02oPEeQGzc2e2+7G7BzwgfWYKJOb3qhAALPatnHUBKoc3JzXU4R0RUoz
	h3AkwzYVhR/K6LriKFqp7hhMsgeEiFib76+ZcfqVhWAw3fyNUhNTV7WKvtb3upOPRpyUt5
	PfqOJHjMfFT299OKJE4ALFGjucmca+U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09Qoe43PT4Iegq/2tV6EDeu/7nFFELs7zlPH6GSP538=;
	b=kqwoxMqOtka6THaqTQNFafAFqRIZsxz8Zfrjs8MHWP2yTPllfMlXK8L2JLIAWh2bqKPr7n
	5yDye9CQwqLe/VSeoPzJHA1BIFDH2JXb6V5wWbEKt9fscmHdOPCtc02QZ+OFXR4s6gvzSH
	5agm/rseKgKZCZ0fKsYz8thaH4eJ5SA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="QkrF3T 6";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=09Qoe43PT4Iegq/2tV6EDeu/7nFFELs7zlPH6GSP538=; b=QkrF3T
	6HtDiNETIOIWuNnNM+k2VV+lrscYx8EBpB8UbzgK2LkJMNLscxpwc8shZjJGh6FqgwRd3e4UggVET
	L/ferf0OlEwqveWg/SHG6gHVp3nSbUSn85IEr4m7B2uITaWwVCGbpUIXOEb/NnOQY7/g94VTz8WDZ
	ARCr6/+FPy7P6eh44Nj3swzrIEJH6Z88KV+wnxq4fnQFYrbVIBSZ6C/qmtia34ZAkH/rRlKEmZ7hV
	83oF7bV1jyR/6HhTZFNKVCBnkGKeE6Vo2y0nul6jx+mNwMc03p9YoYPzj1FqDPGUXJY7+dlgENgsy
	JPgtnHM3PVw5kvFWwbACoFuJrV4A==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xVa99-00000006IU7-1zAH;
	Mon, 23 Nov 2026 19:56:15 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peter Xu <peterx@redhat.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 7/9] mm/gup: walk multiple PTEs per follow_page_pte() call
Date: Mon, 23 Nov 2026 14:56:07 -0500
Message-ID: <20261123195609.4115244-8-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261123195609.4115244-1-riel@surriel.com>
References: <20261123195609.4115244-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: BF8EC4000C
X-Stat-Signature: 7pewfwsfyr3f7cbxwsdr4fidt7ru581o
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795463787-568241
X-HE-Meta: U2FsdGVkX181Txu3oAt5sXJcoB3NMuHiHJWgrFFuZA0808Ounr9t63CsE9b8y1kYjTLzcnOacXxLuT9puAkCBUiOqmcUnKA82ruXxKR1HttlEoanSbCzsU8qtlHaTZdxz0AViQA6n0Uoh2Pdx/kmCu1QC5rXWIfJAbvi4UvGqHkNGaaThAhFEwKz+waHT3lgk7ZRJeZ6pOvTDMFVn1X9aOLrAYACyo2WLoB0E0sG7MRXMkuKLEp5Xl8Q+rZGKOctjtzp0zEiee8+v74twEodtn+6IsfPfQUC9TFaIza8MwswX9PJ0Pd5MCzM7UGgkSssDaEKUHOv53A5KM4GXZT/eAjxQGAwrsCdcZztfu8l72n4oYTsE/G/OFkdXT6IKeoxQ7UbR4qO4gJr9X7kDz0h53ecA4AyLyn/gWFgI3Av1Vt45kfdYUal3q/RNXa/E9bcNQ6Xn5yfZP0jiDW7F4Yw1rU3cpY1M4Bfkoynq6rtFnvIU5onNu3FDiUcOVpJaudPKqTIW8VPdcXeka8rPqqN7vlog2jUiOEcxWBsTbRXESwlMdJ9teoFBVrAJU6/a+KoTXGeXYMHiHXHo4xc/y+FRqRI/liS9Cm5VDt40fo4ihdJQ3vljZ+e0gB+EM+wA+NOE+bpgORf73cwC7AbedZ1VANU4fBo46iQ5+t+8GCmZzV5sJaOQIcZTOZYYkUEfbWaqbaBkeNlYVymlL5+ywV25h+x6jfGj6OIwPT4thzIa1WysNGyYILlQf3y8+6Kk7G6ktYdqYbNchdv/lLFEcQiwk5MXksGHPdvFosWPKw8IoEN8N44olyiM/cTECSdU/TeKlyDbWVxTQ65wSwnuXuQ1lQxOqr9K1eiG62ff9KLyU4EzDlkFfZZz0fYpOrFdeQyN5maZPRIR/4aUIv09WIkAAcrhaA/id3LlWimR7dW2/edMcc5eZGoeMQRs19NnNIFjMQ9LOCXJEk5gNZO19E
 XjPTauo1
 76q/YFUwkHDrQpoLLsdJLtoQhlM4zsZwlacyzRpSbWFC1tH5zINSTChkwBHaWhmn5ZA0StKTW4Cwhem4mrGJTQH3su/z9fNt++hQqO0obj3Twz/gpImDqClMB9DOieCTPJm6qryv94DYk+mO5EBQaA9ClLrRnTJZtktC+MiwvIl8R1TG5EKICW3c/CCyvBqrN12VgIAQtM58BByjFRBGKHsXbB7+agJChyuEv0fpzLiBM1O2NttDJYtP9G4M4R1E3Q8iQ7+AE5mDr8KXM+2rH0ykXd+LdvJJ18Ycutq8aRyYcf8aQImmn+7MVIz37vGykZbvmiyUn2k7qv0Gxa7dYehp+pvH+tjEh/73sv5rEEIVQ+I9EcMyWUgfKsnfq6ZGQ0lmR3z+Z7yUPHOJG3brJzoMdxobP+AjqPYgM6mt6s+WIH+5Xu9KJigIx7kfvHLi+Anf3ifXCTNnaWHzNvDpKBJTT20/k5mWQ1pB/25t8xGLTrbiUn2NF2nmi0SXHPjso87ClhuXtr/eZmIWXIOrW8ynYw7W1Li56lZ55go5wP++vkfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Slow GUP resolves and commits one PTE per follow_page_pte() call, so
__get_user_pages() restarts the pgd/p4d/pud/pmd descent and retakes
the PTE lock for every page.

Walk the PTEs from the start address to the end of this page table or
VMA, whichever comes first, and commit every page found. The walk end
is computed from the inclusive end like folio_pte_range() does, not
via pmd_addr_end(), which does not clamp on 2-level page tables and
can wrap on unsigned-long overflow. A none PTE in a hugetlbfs VMA can
only be resolved to the page cache outside the PTE lock, so it is
deferred until after unlock.

A failure on the first PTE is returned to the caller. A failure after
that is a short read; __get_user_pages() retrying the read gets the
error.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 95 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 34 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 57faf0165385..b5747f2c2ca3 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -792,7 +792,7 @@ static long follow_huge_pud(struct vm_area_struct *vma,
 	if (ret)
 		return ret;
 
-	gup_fill_pages(pages, page, 1);
+	gup_fill_pages(pages, page, nr);
 	return nr;
 }
 
@@ -861,7 +861,7 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 
 	page += off;
 
-	gup_fill_pages(pages, page, 1);
+	gup_fill_pages(pages, page, nr);
 
 	return nr;
 }
@@ -1011,41 +1011,69 @@ static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
 	return 0;
 }
 
+/*
+ * Walk the PTEs from the start address to the end of this page table or VMA,
+ * whichever comes first, and commit every page found.
+ *
+ * A failure on the first PTE is returned to the caller. A failure after that
+ * is a short read; __get_user_pages() retrying the read will get the error.
+ *
+ * Return: the number of pages stored in @pages, 0 when no mapping exists at
+ * the start address, or a negative errno for a failure on the first PTE.
+ */
 static long follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags,
-		struct page **pages)
+		unsigned long address, unsigned long end, pmd_t *pmd,
+		unsigned int flags, struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct page *page;
+	bool pte_is_none = false;
+	pte_t *ptep, *orig_ptep;
+	unsigned long walk_end;
+	unsigned long nr = 0;
 	spinlock_t *ptl;
-	pte_t *ptep, pte;
-	long ret;
+	long ret = 0;
 
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	orig_ptep = ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	/* The PMD entry is empty. */
 	if (!ptep)
 		return no_page_table(vma, flags, address);
-	pte = ptep_get(ptep);
 
-	/*
-	 * no_page_table() may access the page cache for a hugetlb VMA,
-	 * which cannot be done under the PTL, so defer it until the
-	 * lock is dropped.
-	 */
-	if (pte_none(pte)) {
-		pte_unmap_unlock(ptep, ptl);
-		return no_page_table(vma, flags, address);
-	}
+	/* Clamp the walk to the VMA end or PMD boundary. */
+	walk_end = min((address & PMD_MASK) + PTRS_PER_PTE * PAGE_SIZE,
+		       vma->vm_end);
+	if (end > address && walk_end > end)
+		walk_end = end;
+
+	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
+		pte_t pte = ptep_get(ptep);
+		struct page *page;
 
-	ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
-	if (!ret && page) {
-		ret = gup_grab_fill_folio_pages(page_folio(page), page,
-						     1, pte_dirty(pte), flags, pages);
-		if (!ret)
-			ret = 1;
+		/*
+		 * no_page_table() may access the page cache for a
+		 * hugetlb VMA, which cannot be done under the PTL,
+		 * so defer it until the lock is dropped.
+		 */
+		if (pte_none(pte)) {
+			pte_is_none = true;
+			break;
+		}
+
+		ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
+		if (ret || !page)
+			break;
+		ret = gup_grab_fill_folio_pages(page_folio(page), page, 1,
+					     pte_dirty(pte), flags,
+					     pages ? pages + nr : NULL);
+		if (ret)
+			break;
+		nr++;
 	}
+	pte_unmap_unlock(orig_ptep, ptl);
 
-	pte_unmap_unlock(ptep, ptl);
+	if (nr)
+		return nr;
+	if (pte_is_none)
+		return no_page_table(vma, flags, address);
 	return ret;
 }
 
@@ -1068,7 +1096,7 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -1081,14 +1109,14 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
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
@@ -1625,14 +1653,13 @@ static long __get_user_pages(struct mm_struct *mm,
 
 	fill_flush:
 		/*
-		 * The first page is already stored and references on the
-		 * whole run are held; fill the rest of the array and flush
-		 * the caches without any page table lock held.
+		 * The run is already stored and references on all of it are
+		 * held; the array may span several folios, so it cannot be
+		 * re-derived from the first page here. Only flush the caches
+		 * without any page table lock held.
 		 */
-		if (pages) {
-			gup_fill_pages(pages + i, pages[i], nr);
+		if (pages)
 			gup_flush_pages(vma, start, pages + i, nr);
-		}
 
 		i += nr;
 		start += nr * PAGE_SIZE;
-- 
2.56.0


