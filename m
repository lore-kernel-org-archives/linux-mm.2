Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D53C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CAD6B0093; Mon, 10 Aug 2026 23:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A650F6B0095; Mon, 10 Aug 2026 23:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1526B0096; Mon, 10 Aug 2026 23:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0E06B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:07:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D331340334
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:25 +0000 (UTC)
X-FDA: 85087502850.03.5B26398
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5E98C180009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Fe3qezAr;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786417644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cng7GWmuH0afMBNJaOnPoRqJa9xaiwRqJYVnLxI+0+w=;
	b=X2DkDcINNwJuahhnZlbg0aJ/CkpzMu/JMFMZJDRmRPB0dsjIIph+IRGtJPj1Js0gS81Zgw
	U/KE8bBX10Gln2AUqst6fL1LsP03dcBwSHSDKRG7rhHBBfLRtBhVLXCXbPluSPMksEYfdM
	Ltvq0q/mbx1pB4zuDqPZPfajYxsUeHY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Fe3qezAr;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786417644;
	b=6XUl2nVogQ8iVahI0tmy15VV32JW3TJ1rgAL1hD0EsI6+iTxr6SxG/AIJ40h4K3YCjkybg
	f1NOCaX4yMghSh5bshV37c7k+9GFGwlDuHGsY1FIeb3JXoVK5dhT4TzFboDhF8d8i68AoR
	2EPfitCsn0+Yo4VVXK4VpZ8mpGXEXzw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cng7GWmuH0afMBNJaOnPoRqJa9xaiwRqJYVnLxI+0+w=; b=Fe3qezArnzVz1Pb+5pmpOAIgcB
	UW4WK1nDwE9bLqjp7C3Jj5yV5sXselN+PwuUh0zTTGkmfN6t4kesgCEezvcAsF8IYx4uLZ6OSpGU3
	GLrDNS4XVzS4vR7Td68MCOqoOXPryHSP9IWYuQ7oQRVQemVnJycOy1DTPYVd5fx7tbAwNPIdK84Em
	ztZG/gBdtb41/ZzHoNEcRbKNafwo1897lrhZYSOJNO9gAv10xQJw25N/QbQzhDqvGw/3YNdwwwcJu
	ef7QHar4jrMtViZK9BuCZdT5REoBM/bAOn2ZnsFIziLSRo5aF6CFwgZ2VhIpesOb+DYeR0MhFoEU5
	zDLAwYyg==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtcb6-000000007kZ-2dKV;
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
Subject: [RFC PATCH v3 4/8] mm/gup: break out follow_one_pte() helper
Date: Mon, 10 Aug 2026 22:51:53 -0400
Message-ID: <20260811025157.1632867-5-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E98C180009
X-Stat-Signature: g1idmngnhysiqhzmxp89cks5ifo947qz
X-HE-Tag: 1786417644-527136
X-HE-Meta: U2FsdGVkX18dNggvqIP72UODu9qjMbBYwPYFgOc16xkAjppKyEunZdjpqsDl5147j+Rja7YYHsPkp5C6hxe8Xqzin8ugXLtvIVVk74tuT76ImQrdBKAs8fOQBAtmCH6Ds2luZrEZ4Y77Pp4CtryOf1iWZkCfGG1vJA3LVFGPtMvmi9eDdx4i+J0B7naf6fFBjy3UqdQC453+QKqrlJaskZ8IctJ/k47TEG5VszqWtU8buOtJ7I1pZj5DDsSowb6DxjcQaMSMhqDD54SUJTvhdudWa9SZhe8G34+SciR5Vqth86NUsWVFpwHBNLO4iiUOZ6pGnb6gT9O/3PorvlabObYb8TuO5h3Ho7s870Oc/Hhtz8ruiO0LUvhXKdHUdx5fXGe/DajwQqCoOWPZFbF3WOqPa4EmwYdf9n62j4zagdO+ccGPf9As35NTstn40cvf7YDYuK1KeubAT6Hb0PiHTis976Wyx3OYaA1inhOgptoT1gv78UbmU2MinUvTmBqzT9KRY932zaW9aTkviczQpe9eVpDl5OI9IlYgcecfZxwXeAwDdZrPN5+wp0U1hexFsB30Ag3wV9ys/B86txWQsPIL2XA2n5cLkmwvYZwHbh2DcsRi3BxBPLcPMF+AawGtfSN/+c6bc1PsGT/BFQgmWP8RjdwRjM1xv6LFHEgzueAPymUYWRXyqiXeDUA5HoHNZgFjAeSWWGWtc2Dv5DVNjorGbo1KTwbGOUTyoCmTVL0cqZ9mA7+VoNLpOY2BDga8TnaJ09tkdUKQK84K6W5iksmXhbhSUSYOGSvmeKvJu/Dl+s3vAwO+HoYl9LgHQp0TA79Mo2nUMJB7JRmVOs8qpbKeLTAI/l8RNFilGdMWx7uNVfQdPb/Odix4l5O/7IW5wqLmG4MHsIOvOM/iusPi3fv+WCD9EYHpSk19ptyaLBK5sUBOd+J36TNNQBin8YwhGKpPV13SJ5JkA6tsk0J
 jFA+X6mS
 D0Vc2Uq1xoPuahzeaFHo5YWiYCabLEOagudV2q0T68Abe9OgjOOOGcFlyL3Mu4Cz2ea0TZzJZOcprPQmbnKO2eoJAVAbWh4yzJAdsjjZcpaPB1YrHkDwRnDYzvYdHEyEWTUtDXciLRnjQxdxtK92UEREmrqa8Z00aiS0BK2XyEkmah1+9FItHXomXhy5yIcKlXwBKSXffOr3SyI5+KPOBmFhyW4Icm/TKQptEEY/u//yOKEpm24TUCddZ2+GJz6lADCte9+xNYjEudYARRcWBEYGGZawsqewrNzPvD9v4mDJzvbZhqYpbFpaf2xjexbRhKDyoY8vftHvuDYJW31c/sYqEVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_pte() is 92 lines and does two separate things: work out
which page a PTE maps, if any, and commit to the page it found. The
first half reaches the second through five exit paths, two of which
unwind the PTE lock in different ways.

Split the resolve half into follow_one_pte(), which returns the page it
resolved, NULL when the PTE cannot be followed, or the errno the caller
must report. follow_page_pte() is left with one unlock and one exit.

no_page_table() can look up the page cache, so the case that needs it is
recorded and the call made after dropping the PTE lock, as before.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 100 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 44 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b755ceaac0f5..5af6a23285de 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -868,74 +868,86 @@ static long follow_page_pte_commit(struct vm_area_struct *vma,
 	return 0;
 }
 
-static long follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags,
-		struct page **pages)
+/*
+ * Resolve one present PTE to the page it maps. Returns no page and no error
+ * when the PTE cannot be followed but the caller may fault it in, and a
+ * negative errno when the caller must report the failure.
+ */
+static long follow_one_pte(struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep, pte_t pte, unsigned int flags, struct page **pagep)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	struct folio *folio;
 	struct page *page;
-	spinlock_t *ptl;
-	pte_t *ptep, pte;
-	long ret;
 
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (!ptep)
-		return no_page_table(vma, flags, address);
-	pte = ptep_get(ptep);
+	*pagep = NULL;
+
 	if (!pte_present(pte))
-		goto no_page;
+		return 0;
 	if (pte_protnone(pte) && !gup_can_follow_protnone(vma, flags))
-		goto no_page;
+		return 0;
 
 	page = vm_normal_page(vma, address, pte);
 
 	/*
 	 * We only care about anon pages in can_follow_write_pte().
 	 */
-	if ((flags & FOLL_WRITE) &&
-	    !can_follow_write_pte(pte, page, vma, flags)) {
-		ret = 0;
-		goto out;
-	}
+	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, page, vma, flags))
+		return 0;
 
 	if (unlikely(!page)) {
 		if (flags & FOLL_DUMP) {
 			/* Avoid special (like zero) pages in core dumps */
-			ret = -EFAULT;
-			goto out;
-		}
-
-		if (is_zero_pfn(pte_pfn(pte))) {
-			page = pte_page(pte);
-		} else {
-			ret = follow_pfn_pte(vma, address, ptep, flags);
-			goto out;
+			return -EFAULT;
 		}
+		if (!is_zero_pfn(pte_pfn(pte)))
+			return follow_pfn_pte(vma, address, ptep, flags);
+		page = pte_page(pte);
 	}
-	folio = page_folio(page);
 
-	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
-		ret = -EMLINK;
-		goto out;
-	}
+	if (!pte_write(pte) && gup_must_unshare(vma, flags, page))
+		return -EMLINK;
 
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	ret = follow_page_pte_commit(vma, address, folio, page, pte, flags,
-				     pages);
-	if (ret)
-		goto out;
-	ret = 1;
-out:
+	*pagep = page;
+	return 0;
+}
+
+static long follow_page_pte(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd, unsigned int flags,
+		struct page **pages)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	bool need_no_page_table = false;
+	struct page *page;
+	spinlock_t *ptl;
+	pte_t *ptep, pte;
+	long ret;
+
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!ptep)
+		return no_page_table(vma, flags, address);
+	pte = ptep_get(ptep);
+
+	ret = follow_one_pte(vma, address, ptep, pte, flags, &page);
+	if (!ret && page) {
+		ret = follow_page_pte_commit(vma, address, page_folio(page),
+					     page, pte, flags, pages);
+		if (!ret)
+			ret = 1;
+	} else if (!ret && pte_none(pte)) {
+		/*
+		 * no_page_table() may look up the page cache, so it cannot run
+		 * under the PTE lock.
+		 */
+		need_no_page_table = true;
+	}
+
 	pte_unmap_unlock(ptep, ptl);
+
+	if (need_no_page_table)
+		return no_page_table(vma, flags, address);
 	return ret;
-no_page:
-	pte_unmap_unlock(ptep, ptl);
-	if (!pte_none(pte))
-		return 0;
-	return no_page_table(vma, flags, address);
 }
 
 static long follow_pmd_mask(struct vm_area_struct *vma,
-- 
2.55.0


