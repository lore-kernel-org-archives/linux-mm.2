Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B18606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=lYmZFk3+
Received: by kanga.kvack.org (Postfix)
	id 5D1276B05B0; Mon, 16 Nov 2026 17:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7B76B05B3; Mon, 16 Nov 2026 17:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E55B6B05B4; Mon, 16 Nov 2026 17:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24E9E6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:01:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0520801C9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:01:15 +0000 (UTC)
X-FDA: 85442353710.01.4E69E95
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id EEACB40015
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:01:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="lYmZFk 3";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794866474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJQuUBoaJBHanZqDKmQDkjj57N3JJQjULxFAMds5hrE=;
	b=CR1QnFc7qeNRvbtCABSSycwGKiza8QVZBXhsjfCZ/U1EONfixFI3a4mALinVAwdW4XFq68
	Hgf5M/EJUFv6yWl9Q3n5nKHnioKNYZMW3AOIAbc3EEjPNcFsmkkMNBHbof3GEbf2K67sVY
	O4lpnJ7vaqzRFVloDkq0etvoWPwPMwk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="lYmZFk 3";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794866474;
	b=ibmdj7WzfxNlewL6NuwiVIkpoJNx23u9jhqmS3vAp7FKBoyQVORSegcvJek6PfW9FpSaiW
	Vg8Tx4lgTZ73Sh++P0qpBVPzSyhWzoKHVlmTH0ISWgtxRnxu9eMwCX+vYAGqIxH3zrg9wZ
	qVBqoxcLDN5CqpMlwvqdQtle9aFZWpU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=BJQuUBoaJBHanZqDKmQDkjj57N3JJQjULxFAMds5hrE=; b=lYmZFk
	3+2yX42Q4t9r62FIFYwYD4LLTv1CHdEttkgZFvWh3RtTNraH+GiXnFzpNOkAKs0rKEPipis2BjNyR
	H/D/s5SpvKcwqgOunMbYhw1+qwp1gmM56s6roqibaiSVi0bJ9m3Pdh9jFRwIjP0+OvgsBYqyAZkOf
	GxGjXCPl/XZvqYJwoiRWLu+k6IyXpjtIl2FPoTzW+10bD5TNS+xQbGXukkm9VoxPv7HHIf52YCvhZ
	/70hRkwENbfonq+rN3/dyy5kSxg9UDDK4mdGvNVRfKQ3h51GLTLDmFxukxl1AfA0LWRI0ht3zVORB
	yFxzty/386fAf0D/sv92ujZyqRmw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT3pS-00000007LIv-2JX4;
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
Subject: [PATCH v5 6/8] mm/gup: return a huge page's full count from follow_page_mask()
Date: Mon, 16 Nov 2026 16:01:25 -0500
Message-ID: <20261116210127.3837898-7-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116210127.3837898-1-riel@surriel.com>
References: <20261116210127.3837898-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EEACB40015
X-Stat-Signature: hijx44qpea8gb944oqru3d5kt7h7k6ng
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794866473-428741
X-HE-Meta: U2FsdGVkX1+DAc9Rpa8O72jXRTehuDv7Q5Cuw3CdwaZd4TYbu1tYRpjCCAny7h4Z78PnyxIkG6RS6SQ2opLGQfHtuNvWDXp1LcH1FhGu+ZGdNX+P2RgMZYuWpk4bJ0yzjbcRAN+rdm+ghzfejmVFcxMW/z5kgkmfgsSFOCIq73CcqO7i7d2tfwIEthdr9eXWfrgESeubJriy+UOCW11vUJCkWLjUT9x1jYXAygRYt01jrDAWSG7djIu5I8T+P14OfIYw9TPFzriSxIdCQ8XDCjMsqdp2Xx55uWalCbTYBNfkj8BM9cHQDUzU76IJCQPvVOAd3EHYULaT/xpF5xruqMbFH0LLLTeEzdwX9fXbrc20m15A2w4xn6xuzuO+h4fnrgnn6Jb86zT6TTJr4F0G2fNVNAgsGgLiP2tpBTXq0j7AKIFP07Z5m/Fxv3dQSF0pkyZXhycmDgYowD+w0ut2IKxH71sUR4vHbm3a2g2/OfUo4SzAEijp636lJiE1mIAqEGDTbb8R47eMK4FyHOCy+dczDA5yM7ROtHs7suepzEu720LfEc4IxSEEvVlFlP6SmKldOj81BLQCdCX4ExNT8SeLBK+GABsEYjmbsoJ4ye4AOM6hP3LfkkdoSN0VW4+3KjeEdhc5Y/s9VEOHQIIwmvopJMkIKrt70h0dDV6L0WTVa+WGR8jGnaGs7rh/gpjsTL0Lnfl+UPQWdHQ7yDZ6pF3G3Tui/u6nzknSPdCqNmyeYetuLdrL+cNMWxYhxq2Wzr2BxjbazfYD1gTl00fsF83A5Bt02Va2T4kY9ymIUKBd9ULa+cJbisTlIITq311N2lvgQATxIgu7nxPWy/KJYwk+PFjjYtXQiOfnzXyjfgtvXa/QpFhXJneyDtISHd3FhC5hZjJRFZWMfQfIVahPCwI8+Oat5vvJFDnzo4qzeACdSfUx+TW93m/1ncylIUEYhQDBkyYFTVLCfJzAUU9
 c1SyXv8n
 IxCGZnOxE4JYLjRHP8hQh6SoL/KrnI3fJkKIYwBchz88x8A6kPJgashXkYWE2V5o/IkllOzAJI2OQ2PHFvhZyLb99WfTDNmkZzPIgUCqM4dmfvBULwBn3CGMtcXpVkunrXcJw3QNhQTDe7/SEc7pCzcGpcjKqUf+R3qywmEAYVl4ajUbCbHaAfV5NrosJehz5SSPnhcJ4YXqVHBYlVspkyFwBKRijnV/Ab47cqdUeGLdRdaYGOUCf2/V1J2lMowm125qaoOz6tyiMbFRYlriDxgswHbKm4GcOkxeDieAuP+ci772OcjMl1YARLYvqJRIKAA547mtPoqizq378Ud8GdQzbuTkPvIPlr+GTotKMBZWGqiKt5JS/E0LXbfIpxNYP5Em5cjo6dEoaT8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_huge_pud()/follow_huge_pmd() already know the huge page's full
size but report it via a separate *page_mask output; __get_user_pages()
does a second try_grab_folio() call and subpage loop for everything
past the first page.

Have the huge paths report their count as the return value instead,
clamped to the huge page's size and @end. The merged grab returns
whatever error try_grab_folio() gives, instead of forcing -EFAULT on the
second call's failure.

*page_mask and __get_user_pages()'s second-grab/subpage loop are now
dead; remove them. The old silent page_increm clamp becomes a
VM_WARN_ON_ONCE, since @end already bounds the count and refs/pages[]
are already committed by the time the caller sees it -- truncating here
would leak references, not just waste a comparison.

follow_page_pte() is unaffected, still returning at most 1 page.

The -EEXIST path needs an explicit nr = 1 when pages == NULL: it used to
get that from page_mask staying 0 for a PFN-special PTE, but nr holds
-EEXIST there, which would grow nr_pages instead of shrinking it.

mm/gup_test.c (PIN_LONGTERM_BENCHMARK) shows no measurable change; the
lock-hold-time improvement is by inspection, not measurement.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 153 +++++++++++++++++++++----------------------------------
 1 file changed, 58 insertions(+), 95 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 3aed0bc1c2b4..691d83cb702b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -761,15 +761,15 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
 }
 
 static long follow_huge_pud(struct vm_area_struct *vma,
-		unsigned long addr, pud_t *pudp,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long addr, unsigned long end, pud_t *pudp,
+		unsigned int flags, struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
 	struct folio *folio;
 	pud_t pud = *pudp;
 	unsigned long pfn = pud_pfn(pud);
+	unsigned long off, nr;
 	int ret;
 
 	assert_spin_locked(pud_lockptr(mm, pudp));
@@ -778,22 +778,22 @@ static long follow_huge_pud(struct vm_area_struct *vma,
 	    !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
 		return 0;
 
-	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
+	off = PFN_DOWN(addr & ~PUD_MASK);
+	pfn += off;
 	page = pfn_to_page(pfn);
 	folio = page_folio(page);
 
 	if (!pud_write(pud) && gup_must_unshare(vma, flags, folio, page))
 		return -EMLINK;
 
-	ret = try_grab_folio(folio, 1, flags);
+	nr = min(HPAGE_PUD_NR - off, PFN_DOWN(end - addr));
+
+	ret = try_grab_folio(folio, nr, flags);
 	if (ret)
 		return ret;
 
-	*page_mask = HPAGE_PUD_NR - 1;
-
 	gup_fill_pages(pages, page, 1);
-
-	return 1;
+	return nr;
 }
 
 /* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
@@ -815,14 +815,14 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
 }
 
 static long follow_huge_pmd(struct vm_area_struct *vma,
-		unsigned long addr, pmd_t *pmd,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long addr, unsigned long end, pmd_t *pmd,
+		unsigned int flags, struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmdval = *pmd;
 	struct page *page;
 	struct folio *folio;
+	unsigned long off, nr;
 	int ret;
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
@@ -847,7 +847,10 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	ret = try_grab_folio(folio, 1, flags);
+	off = PFN_DOWN(addr & ~HPAGE_PMD_MASK);
+	nr = min(HPAGE_PMD_NR - off, PFN_DOWN(end - addr));
+
+	ret = try_grab_folio(folio, nr, flags);
 	if (ret)
 		return ret;
 
@@ -856,27 +859,24 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
-	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
-	*page_mask = HPAGE_PMD_NR - 1;
+	page += off;
 
 	gup_fill_pages(pages, page, 1);
 
-	return 1;
+	return nr;
 }
 
 #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 static long follow_huge_pud(struct vm_area_struct *vma,
-		unsigned long addr, pud_t *pudp,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long addr, unsigned long end, pud_t *pudp,
+		unsigned int flags, struct page **pages)
 {
 	return 0;
 }
 
 static long follow_huge_pmd(struct vm_area_struct *vma,
-		unsigned long addr, pmd_t *pmd,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long addr, unsigned long end, pmd_t *pmd,
+		unsigned int flags, struct page **pages)
 {
 	return 0;
 }
@@ -1048,9 +1048,8 @@ static long follow_page_pte(struct vm_area_struct *vma,
 }
 
 static long follow_pmd_mask(struct vm_area_struct *vma,
-		unsigned long address, pud_t *pudp, pud_t pud,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long address, unsigned long end, pud_t *pudp, pud_t pud,
+		unsigned int flags, struct page **pages)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
@@ -1089,15 +1088,14 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 		return pte_alloc(mm, pmd) ? -ENOMEM :
 			follow_page_pte(vma, address, pmd, flags, pages);
 	}
-	ret = follow_huge_pmd(vma, address, pmd, flags, page_mask, pages);
+	ret = follow_huge_pmd(vma, address, end, pmd, flags, pages);
 	spin_unlock(ptl);
 	return ret;
 }
 
 static long follow_pud_mask(struct vm_area_struct *vma,
-		unsigned long address, p4d_t *p4dp,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long address, unsigned long end, p4d_t *p4dp,
+		unsigned int flags, struct page **pages)
 {
 	pud_t *pudp, pud;
 	spinlock_t *ptl;
@@ -1109,8 +1107,7 @@ static long follow_pud_mask(struct vm_area_struct *vma,
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
 	if (!pud_leaf(pud))
-		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask,
-				       pages);
+		return follow_pmd_mask(vma, address, end, pudp, pud, flags, pages);
 
 	ptl = pud_lock(mm, pudp);
 	pud = *pudp;
@@ -1120,19 +1117,17 @@ static long follow_pud_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pud_leaf(pud))) {
 		spin_unlock(ptl);
-		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask,
-				       pages);
+		return follow_pmd_mask(vma, address, end, pudp, pud, flags, pages);
 	}
 
-	ret = follow_huge_pud(vma, address, pudp, flags, page_mask, pages);
+	ret = follow_huge_pud(vma, address, end, pudp, flags, pages);
 	spin_unlock(ptl);
 	return ret;
 }
 
 static long follow_p4d_mask(struct vm_area_struct *vma,
-		unsigned long address, pgd_t *pgdp,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long address, unsigned long end, pgd_t *pgdp,
+		unsigned int flags, struct page **pages)
 {
 	p4d_t *p4dp, p4d;
 
@@ -1143,18 +1138,18 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, p4dp, flags, page_mask, pages);
+	return follow_pud_mask(vma, address, end, p4dp, flags, pages);
 }
 
 /**
- * follow_page_mask - look up a page descriptor from a user-virtual address
+ * follow_page_mask - look up pages at a user-virtual address
  * @vma: vm_area_struct mapping @address
  * @address: virtual address to look up
+ * @end: virtual address at which to stop batching contiguous pages
  * @flags: flags modifying lookup behaviour
- * @page_mask: a pointer to output page_mask
- * @pages: array to receive the page found, refcounted per @flags, or NULL
- *         to walk the page tables (e.g. to fault pages in) without
- *         collecting or refcounting them
+ * @pages: array to receive the pages, refcounted per @flags, or NULL to
+ *         walk the page tables (e.g. to fault pages in) without collecting
+ *         or refcounting them
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
@@ -1163,15 +1158,15 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
  * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
  * relevant with FOLL_PIN and !FOLL_WRITE.
  *
- * On output, @page_mask is set according to the size of the page.
- *
- * Return: 1 with @pages[0] filled in if a page was found, 0 if no mapping
- * exists at @address, or a negative errno for a mapping to something not
- * represented by a page descriptor (see also vm_normal_page()).
+ * Return: the number of contiguous pages starting at @address that were
+ * placed into @pages (if non-NULL), which may be fewer than the pages
+ * requested via @end; 0 if no mapping exists at @address; or a negative
+ * errno for a mapping to something not represented by a page descriptor
+ * (see also vm_normal_page()).
  */
 static long follow_page_mask(struct vm_area_struct *vma,
-		unsigned long address, unsigned int flags,
-		unsigned long *page_mask, struct page **pages)
+		unsigned long address, unsigned long end,
+		unsigned int flags, struct page **pages)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1179,13 +1174,12 @@ static long follow_page_mask(struct vm_area_struct *vma,
 
 	vma_pgtable_walk_begin(vma);
 
-	*page_mask = 0;
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		ret = no_page_table(vma, flags, address);
 	else
-		ret = follow_p4d_mask(vma, address, pgd, flags, page_mask, pages);
+		ret = follow_p4d_mask(vma, address, end, pgd, flags, pages);
 
 	vma_pgtable_walk_end(vma);
 
@@ -1523,7 +1517,6 @@ static long __get_user_pages(struct mm_struct *mm,
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
-	unsigned long page_mask = 0;
 
 	if (!nr_pages)
 		return 0;
@@ -1538,7 +1531,6 @@ static long __get_user_pages(struct mm_struct *mm,
 
 	do {
 		struct page *page;
-		unsigned int page_increm;
 		long nr;
 
 		/* first iteration or cross vma bound */
@@ -1591,8 +1583,8 @@ static long __get_user_pages(struct mm_struct *mm,
 		}
 		cond_resched();
 
-		nr = follow_page_mask(vma, start, gup_flags, &page_mask,
-				      pages ? &pages[i] : NULL);
+		nr = follow_page_mask(vma, start, start + nr_pages * PAGE_SIZE,
+				      gup_flags, pages ? &pages[i] : NULL);
 		if (!nr || nr == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
 					   nr == -EMLINK, locked);
@@ -1614,50 +1606,21 @@ static long __get_user_pages(struct mm_struct *mm,
 			 * Proper page table entry exists, but no corresponding
 			 * struct page. If the caller expects **pages to be
 			 * filled in, bail out now, because that can't be done
-			 * for this page.
+			 * for this page. Otherwise advance by the one page
+			 * follow_page_mask() looked at.
 			 */
 			if (pages) {
 				ret = nr;
 				goto out;
 			}
+			nr = 1;
 		} else if (nr < 0) {
 			ret = nr;
 			goto out;
 		}
 
-		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
-		if (page_increm > nr_pages)
-			page_increm = nr_pages;
-
-		/*
-		 * This must be a large folio (and doesn't need to
-		 * be the whole folio; it can be part of it), do
-		 * the refcount work for all the subpages too.
-		 *
-		 * NOTE: here the page may not be the head page
-		 * e.g. when start addr is not thp-size aligned.
-		 * try_grab_folio() should have taken care of tail
-		 * pages.
-		 */
-		if (pages && page_increm > 1) {
-			struct folio *folio = page_folio(pages[i]);
-
-			/*
-			 * Since we already hold refcount on the
-			 * large folio, this should never fail.
-			 */
-			if (try_grab_folio(folio, page_increm - 1,
-					   gup_flags)) {
-				/*
-				 * Release the 1st page ref if the
-				 * folio is problematic, fail hard.
-				 */
-				gup_put_folio(folio, 1, gup_flags);
-				ret = -EFAULT;
-				goto out;
-			}
-
-		}
+		/* Check that we didn't pin more pages than the caller will free. */
+		VM_WARN_ON_ONCE(nr > nr_pages);
 
 	fill_flush:
 		/*
@@ -1666,13 +1629,13 @@ static long __get_user_pages(struct mm_struct *mm,
 		 * the caches without any page table lock held.
 		 */
 		if (pages) {
-			gup_fill_pages(pages + i, pages[i], page_increm);
-			gup_flush_pages(vma, start, pages + i, page_increm);
+			gup_fill_pages(pages + i, pages[i], nr);
+			gup_flush_pages(vma, start, pages + i, nr);
 		}
 
-		i += page_increm;
-		start += page_increm * PAGE_SIZE;
-		nr_pages -= page_increm;
+		i += nr;
+		start += nr * PAGE_SIZE;
+		nr_pages -= nr;
 	} while (nr_pages);
 out:
 	return i ? i : ret;
-- 
2.56.0


