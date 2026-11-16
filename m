Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72CA0606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=W2VYBnIx
Received: by kanga.kvack.org (Postfix)
	id 234386B05B5; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8236B05B6; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4AB6B05B8; Mon, 16 Nov 2026 16:01:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1ADB6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B59371A0239
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:46 +0000 (UTC)
X-FDA: 85442203812.11.F9A3B17
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id EB13C140006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="W2VYBn I";
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862905;
	b=1BuFaX349mAET/Cti7l2DeyNGpPY4+s/s6N0IcAzJjO5W0W4Jqad8HEEkWE0dp28ZC60/Z
	3pE9//xxaBeAtR1VxNwbdmPmDqq0l1M1OoSO+qDPROG+2b/W1AMTU/9HJzy5DW192uaH0E
	AW9Shbl9JJFn7mhx+ZNleHFqyURGjtE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wUjTLC+I98xj5eiauRNGn05qBeBbFhpTB4tAXdmLhU=;
	b=7rwmEVzJyWnUo7QIYpdP3gfyiInO26Q8O7cY5D79ADhTMDg6Q54/HOLSsR6ZqxSFxpkxbL
	ObiEcmjqobQPjqF787EufWMzH6cz5Qq/Fomw/sMGhauiCYzW2VOCIZDUpFVxrziCRg+RD5
	2ZCFPdjSi6SsIntBuvXPaTGEzzJKuxU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="W2VYBn I";
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=9wUjTLC+I98xj5eiauRNGn05qBeBbFhpTB4tAXdmLhU=; b=W2VYBn
	Ixu27IFyHHF6q8fUoXkMsbvmVCWGjQep2IOwES+iFkhLaSuKkW3cKnFS3vc7wPGrmxobEfKMWC+re
	24vAAbz5OLBW6qJAKYEnUCZnIchw4Ip8jFlD1s/i0nnh6AD8BxvbQ2/d/HlZFp++z8OQ6ONe6rZEt
	jejftvSyZtbAM4ldhzmtyKYKKRyLl5se8JBJVtVx2UrZ+VRuIEqy46jb91XuPLAL4IMBIXL0c+HZw
	rm6+JkOWA6cGEEmWDVmc54N0MXvkf2z3CKS8sHmmv4C+IknNhHCnYsjGpvTgQYMGqFDc7lVaXhmvD
	SOtRQ1xlDLZPm2JpXHwJBk7dN8Qw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT3pS-00000007LIv-2QXc;
	Mon, 16 Nov 2026 21:01:30 +0000
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
Subject: [PATCH v5 7/8] mm/gup: walk multiple PTEs per follow_page_pte() call
Date: Mon, 16 Nov 2026 16:01:26 -0500
Message-ID: <20261116210127.3837898-8-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116210127.3837898-1-riel@surriel.com>
References: <20261116210127.3837898-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB13C140006
X-Rspam-User:
X-Stat-Signature: x1xw96ro37wbgzcenriqppmag98mwf6f
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794862904-680647
X-HE-Meta: U2FsdGVkX18PSNmr0wBHdel4Uoz4n0Z5iqDDf9XRvSHiwqbjfZvNpv+uj01vn2zyuridB/1gJGn15TZym6RV/cmdiJfyoAtH9Xh1jaURMLwJthAS9VTeydtWE5Vj9or5wIPmJuK8p1WaEJtH3bJKVfNMsg8hcu6cKM0It7pKpyWZD8OXWoBSPR9zqqmbyGW+zoUEZ37R/wjFMrQTXMHruzk3ZCBbsz7TH5t0q9c1jRqixkBoEUFkXohdGQ6AteP0ATrLmfYzAOq1vM/2scwJxNiASd8JkuU2KfOzxzbwhJRG08p3JEsi7vAsrYuF5Leok0GeS62jp17D0TNEdpDuQtNzHn2MEeGWF/VavreRZ2w2k8IlE/zbJzU4YJHsQNKQgkuHoMziKgaxxsVvUI+XZftzIk+8OvETVJNet3N8r2W59JJyKDCbTGb6DmuEjlci+6VzickXaO5mJIAGycn9s5lcBdEyLOpErcfEeDRw0qAMwdNleaBNS3W3VxnE1gOSCHdtlTb4J/VjGxAa1ikL1VoNbHYO0qCwrjGBzZ3ZmZLjKMuOfuvYlyGNAxMpDvwtn7/BY5BlozIlo0ZjpP4BlUoLzvFIHGKpUPC6A4bRhZtXc6sQIl9GekKu12Q51Yu3DZc7z3SjpWr48LPMj7RU+7O0tVEVlDwtEeEqVUo7R2YzxMYCjV7hd71W+lNKMAogq5e58TBcmMCX7WulfISxryxncdrr2yYkaaV2jGNQTczs+mZ7DU80zp2d4GbnSsx4aGGptaYfwv/hupgj9tV/Ivcuu2KimLuAHChatAQF1GoOjCamC/lq2QBC7OnGwGuN0iKbEmSLEFFtPyv4VPwws7XrqGSozLcQfpB2pYGd0vB/P259Q0hAs7ingjc8ZpTc7zULhrchxoaeBh7xUyVVpd1FQxzsV+QsHjZwmlXd4NqdKOVyIA0O60f5bm+R6JHZT3+uzLTMGv1WWpm+6N1
 FwCLn0Fo
 Er1iyJcASr1X3Y8zl7IfZPkW9+dbZZbra15gnVS7cZBpRRDdDmMplokV3+aN2mMJTWp1y8V+0vp2qHheR6N43K9BSt8+oLlrp3uU/lkVcyFWws65BhEe6eSB6XE6mP7R9UOTKqJy/3HzAtBaLKFdSokKob0LjmRZeHdBK+0WeavqOLXVvC11l/x9mQrpvEu4oZIG40bMbvnxQSGxsrQNbVtZHwgb5kHldB0WNwQP28XDxbd21M9lv5lVylHLBcWPAslM8MjwkJ5Zbeyd6HtInKIVrXA9YAh4vA3F9M6ZBewl4VhaogLgR4VvvctNozTW2WYpmTXfdaRtG43yBphvngxTB2xTZSLtcPxbyorGcafbCESVrJsW4gtk5+gSUn2QNYxFC8ur1j6sGB0oibmPTs6fZ7AcK6kJAVwqLHt4gNCQVjzXZwNsS7BtZdvl1gFBB15df6hcUsQ3EYFDlwRZBcEN6XqTZQDSNsOaMljWMdLAVEmgG2EnKLT8hqj4HznjaG/Gf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_page_pte() looks at one PTE per call, so __get_user_pages() calls
it once per page, restarting the pgd/p4d/pud/pmd descent and retaking the
PTE lock each time.

Walk every PTE from @address to the page-table/VMA/@end boundary in one
call instead. Adjacent pages from different folios, or plain base pages
with no folio relationship at all, are covered by the same call under one
lock.

A failure on the first PTE is returned as before. A failure after that
ends the walk, and __get_user_pages() retrying the read gets the error.

The pages[] slots are stored under the lock, but the cache flushes run
after it is dropped, over the pages the walk stored: holding one page
table can cover up to PTRS_PER_PTE pages, and the flush helpers need no
lock once the folio references are held.

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
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 92 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 58 insertions(+), 34 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 691d83cb702b..a8e8416b299c 100644
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
@@ -1011,39 +1011,64 @@ static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
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
-	ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
-	if (!ret && page) {
-		ret = gup_grab_fill_folio_pages(page_folio(page), page,
-						     1, pte_dirty(pte), flags, pages);
-		if (!ret)
-			ret = 1;
-	} else if (!ret && pte_none(pte)) {
-		/*
-		 * no_page_table() may look up the page cache, so it cannot run
-		 * under the PTE lock. A none PTE returns from gup_lookup_pte()
-		 * before any write check runs, so this is the same call the old
-		 * code made -- not a new failure mode for FOLL_WRITE.
-		 */
-		need_no_page_table = true;
+
+	walk_end = min(pmd_addr_end(address, end), vma->vm_end);
+
+	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
+		pte_t pte = ptep_get(ptep);
+		struct page *page;
+
+		ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
+		if (ret || !page) {
+			/*
+			 * no_page_table() may look up the page cache, so it
+			 * cannot run under the PTE lock. A none PTE returns
+			 * from gup_lookup_pte() before any write check runs,
+			 * so this is the same call the old code made -- not a
+			 * new failure mode for FOLL_WRITE.
+			 */
+			if (!ret && pte_none(pte))
+				need_no_page_table = true;
+			break;
+		}
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
+	if (need_no_page_table)
+		return no_page_table(vma, flags, address);
 	return ret;
 }
 
@@ -1066,7 +1091,7 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -1079,14 +1104,14 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
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
@@ -1624,14 +1649,13 @@ static long __get_user_pages(struct mm_struct *mm,
 
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


