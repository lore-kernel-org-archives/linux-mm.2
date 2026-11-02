Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A16606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=g/LISk21
Received: by kanga.kvack.org (Postfix)
	id BE9DC6B05BC; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A946B05BD; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92006B05C1; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DCA46B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BECDEC0231
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:13 +0000 (UTC)
X-FDA: 85391172426.27.CA29C28
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3CA4340003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="g/LISk 2";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793647872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqtQjtwRGczt9exEK3FM/tKADo6f8acL9nbyk9FwQT8=;
	b=4hm0uw9ZPIGHZFmZsm7rAYiSwPgOiFgkE4omJVPut9QhqwnW7PZ2eMtqAFYsGwBPJLRvK5
	Io+vpbxawFZ5wxKRUzBG1hUs375szCvvK2SuV1rdkOHOL5YBmb0q9b9Mycb5VF9rD4iz2J
	LNIDbi/LRFCoptMqYe/vOg91O/fo6j4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="g/LISk 2";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793647872;
	b=k8zlZYx6abFNvUJpeW49aMsBllML8MghSdqUKL6fYo1NcnpFBEdcnu2wQneiITwOryKaQR
	iP7qc/wtMXb0BHM6jNV8zTeH7riXRNUrn+COsmcSCeQXuZIsvQZPsYDSAVh5TYH7R9z4P9
	HjPrDQirCvcIKogawfwJbqTIVWwMbYQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=UqtQjtwRGczt9exEK3FM/tKADo6f8acL9nbyk9FwQT8=; b=g/LISk
	21VNtOyAiFe/r7BNdHoYLlMCqhBAJIKz3QA1YTIjLR9x4cSI9YFeiinf2UHYxEdLDe6dhjV7hiq0z
	L3zxV7v6wW5SK7vRaH8JnHbbuv8W8ITgfu+F+w7qIDiZoWUSmBn27VzEdeDArSKVnygp7xzHHGYx2
	wmRE4iRsGpe0zpxgQo3IPAKQ0XCckqh0wki2DFnbMLKcDdjjiph8LG61hB0tH2C4JNyC1zhEnqlzI
	9VjLA4SWc54pncm5QGWHPch8ChRt2mvz2txEHaBXixnjJNdiyRzLEcjF7H0L5ORv5e61y2dguwFxn
	1f2ZQwQOSXMgEIarVH7W748MP4lA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xNxjk-00000001W8x-0Yqw;
	Mon, 02 Nov 2026 19:30:32 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 4/8] mm/gup: break out gup_lookup_pte() helper
Date: Mon,  2 Nov 2026 14:30:22 -0500
Message-ID: <20261102193026.3860700-5-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102193026.3860700-1-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3CA4340003
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4i7uzhm99zdhgdxwt9fxnb5oyme4hfez
X-HE-Tag: 1793647872-448251
X-HE-Meta: U2FsdGVkX18Wjj/cXzvl/SxLF5tUW+pdnju/ljaIidCAO34mwQRmY/PuDmZmOX8yLzR6Yp0VpouK0Mz2i4zc9UVdbp6ecPFsSJLm9cbrD2sK2U3pBCqtjiumddY34WMOtUOyMSsbQmLIorbZJ6IhNmKaSi67Oukt56UwSM92+5yccM60b1k8lgR3J4Y+1c44me0Jt95f+JhYD5kM68apx/BOepRB4ZKnd1MgH1pPgSCoHEZOdvH0PtO9ItGBUjTo9bNV926gmdN+EWv/L7nWbvLuW8vGm1x3SowLFKyRf25hDHCACcqQCIrBMJKGqES8ABFoUcprxbADvwMlJ4ADcmz4mzZG0wjK+X5scGpQQNaTbkjxzvuPdbPIBmaieffbB3UrA5oxJGaMJK+vLfzhIB5KtvB69wjfJkn0duTE0UyuKJqPME1WM1/DhF31RrjilEWMRk2HO60ybVy7n7P11pJMJsI0IgsH3BqTIP2NpYb260dJau/GY0VrlPU2Xb6hd3bVouOYfmN5mO0n8hwhM0L7C/LJaPo4shlpNyaJUCVR8Uwo5x4uLAFTIFYsN5Dha3ltgI3dDkYswQZ6zTiaUuZynJlKJ7/hR/WTcrHs/VFT6S/rAu7BGu691sigIn4LzRRIzA6lkNCA7368T3MZJqKiafgrYaJIc6XKRkCM+HvNA08ucDj8Mxs4y7cf9P+/cfGJ11uUNk2/YFvSFEL9JGgr8k4D8sWqMAjBn1qzdnD3JHheF/hYf12N+2/6JYmfaPaX3Ql96Z3rWBmQTI+f6+h+phIodKpbXmNC6h+fTI3V43+65KTcrrbDwmYpr5sfcRBfjsJB/ExCEOPsbUbIt761WMU889+YYClyHBmo9f4z5QiL4G0N20J96pCCMdgahl6D++YrVFuSbOmHZSN4tLuECrmV3gbAFSt4w+DfYVPJbI7E4ku7nBUkNaExljD4Pa7qvCqj5BYGnELUkxg
 nyV++m2J
 6aHnSSuPL3PDN2N0jhg3z1Emw218ysUYFxa4HNPO/HyWc1uRtkb7YKVMt2svd1/pGd0rQqrcxzrZ1NNxpRFTFjeYVnKKz1PYTc8ZEZpBNSL7ljSbd51j2z4e4NGq9Mk353cheNerNav8425RahLx1LOzuILGWvq3Z07OhbpHs2Th+cn/PWZnfEmXRIICOhGzR6FBPJxjnX0autAPQBKu6dPKcrWwtqSAksHfisOpkUP+UcrGErqSsd63cAvdFo1ed/trHbVAJFCMXwwtuBQ3nLw+srgka/xTu8jTUKDK2t9/yntZpS+y1uH/WukvPN9bX407nOs4XSs8uJ6Lw3aDtZPDPrz4tFEAEDcWYcCXZALrVx9X+iX5bNux77wLQsIQqDGs1jlBzq7arZL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_page_pte() is 92 lines and does two separate things: work out
which page a PTE maps, if any, and commit to the page it found. The
first half reaches the second through five exit paths, two of which
unwind the PTE lock in different ways.

Split the resolve half into gup_lookup_pte(), which returns the page it
resolved, NULL when the PTE cannot be followed, or the errno the caller
must report. follow_page_pte() is left with one unlock and one exit.

no_page_table() can look up the page cache, so the case that needs it is
recorded and the call made after dropping the PTE lock, as before.

A none PTE still returns before any write check runs, so a FOLL_WRITE
failure can never reach the recorded call: the caller consults
no_page_table() for exactly the same PTEs the old code did.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 102 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 58 insertions(+), 44 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 27ae2a1d7c36d..c2a4f5b987ced 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -889,76 +889,90 @@ static long gup_grab_folio_pages(struct folio *folio,
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
+static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
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
 
-	ret = gup_grab_folio_pages(folio, page, 1,
-			pte_dirty(pte), flags, pages);
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
+	ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
+	if (!ret && page) {
+		ret = gup_grab_folio_pages(page_folio(page), page,
+						     1, pte_dirty(pte), flags, pages);
+		if (!ret)
+			ret = 1;
+	} else if (!ret && pte_none(pte)) {
+		/*
+		 * no_page_table() may look up the page cache, so it cannot run
+		 * under the PTE lock. A none PTE returns from gup_lookup_pte()
+		 * before any write check runs, so this is the same call the old
+		 * code made -- not a new failure mode for FOLL_WRITE.
+		 */
+		need_no_page_table = true;
+	}
+
 	pte_unmap_unlock(ptep, ptl);
+
+	if (need_no_page_table)
+		return no_page_table(vma, flags, address);
 	if (ret > 0)
 		gup_flush_pages(vma, address, pages, ret);
 	return ret;
-no_page:
-	pte_unmap_unlock(ptep, ptl);
-	if (!pte_none(pte))
-		return 0;
-	return no_page_table(vma, flags, address);
 }
 
 static long follow_pmd_mask(struct vm_area_struct *vma,
-- 
2.53.0-Meta


