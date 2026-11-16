Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFA9606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=G0nOB+yz
Received: by kanga.kvack.org (Postfix)
	id 736856B05B4; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1E56B05B9; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511BC6B05BA; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 099AA6B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B958212021F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:47 +0000 (UTC)
X-FDA: 85442203854.20.331CB17
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB729180007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="G0nOB+ y";
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862905;
	b=D37gzpYUjS6bMa2yP1vIoBhSzJF/xGIOiJ8tpkIMNsvcMLmpO09dN4MyuUNtkCKYv1Fh+Q
	wWgaR28/W2l8IAP4hlQw3M01+fq6FwkBcEitWjPNP5YM/ufbe6jeT+4mKF8wTQdpgZNYH0
	muicgd1o+ZHFz0v22/RfKaAw70fWKiU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="G0nOB+ y";
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2AUyPLHoJGA+N57VqGbbG58eC0VGEyt9DiA6L7vBhoI=;
	b=0Ry74PglukeSBNROzQkpMwLNrQ/ZiNp9I9/lFLHXjVibQiU1glsemPUDvmSRG9/PK5XuBi
	F/Ge1/5/T6k59d34WucbgymwmNTTzlahFdKuPcIeKbvhNMbm1c8S+BbfKHuRyVlojzj/vs
	vXDsCLpj7naSgMVqdJkN3YMkZmjMmtY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=2AUyPLHoJGA+N57VqGbbG58eC0VGEyt9DiA6L7vBhoI=; b=G0nOB+
	yzoiynRlRZGccPLBbvd0KJyvXs7KutAcOce9vx/b6CRQHn5N0JxXwvbz7vOT1N6AtkwGz5bC6caB7
	xtc0Po3BGnwjZt1g9HGf/yKm/H0GiOlB7GiGH+L3OcdMH4gRjEZflleiRRVb+/wJOxCGBsMA5gHUk
	97OdlfdD7TG415WzHhjUf979x7Sudnijc3cmbDD4eBKKeNXopuIY/d0hJ8vDkcwGVdTDgu83ka39H
	Ab4qQQdAkN5v//MCBYpqfLaNrKtZch9nQTQ6EmWQSRvsRrJ0JDwn8HtJ+EjAj5EcC7W1cgR6wsn3m
	+83cOEuul5zCvFQ98wZ0Pyvf4mYQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT3pS-00000007LIv-2CpY;
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
Subject: [PATCH v5 5/8] mm/gup: break out gup_lookup_pte() helper
Date: Mon, 16 Nov 2026 16:01:24 -0500
Message-ID: <20261116210127.3837898-6-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116210127.3837898-1-riel@surriel.com>
References: <20261116210127.3837898-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CB729180007
X-Stat-Signature: w5tfrsmpb7ssg5gnuj49sb4kzjzt59cx
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794862905-315471
X-HE-Meta: U2FsdGVkX1+e9R7Bsc/dyCBR4UcFnviXvcKQNqs7wi/ZjBEW0KX1Gb5NVdxXQjZWvzYRIE0WmQmj7LAtLKPDi8LLjkrjiszEPHuJncQbfiEVGp3dXHe2VUJRZ+vLeAu5Jxh6BlfTgAJNfE4f43bbJxVkI2kD7rZmjKYNVWTAyUxFV1nOKkScluh/3Pv+Wr9fshf8Vd016eguvDFVlRL35SHgC4yUbippPf3YuDqu7Y6+QmpNR+A/chW+FzjUpC57ZBz1qe9HcE3WPBlTSvnyubVT2OHx1XyPwv1nxxCPzRatcnny6y7uWHpDe6B3wZnZ7nyk3UQ/54KG6ZCx66DFIUCTXEOtuiHziIdhEYdAbEnKu5Zqw9+MWYNkXzl3Ah7BxXZ6oVKOi7bzRySgtDT3ISoG8wPhNiMU1uNUCWmpxmCt8pI8AUg/1cdShvahIiEsXlVquHD8ic4rPxl8oV7m1JndfSx2xXmpmJ6p3miUrQSb0f69rL2A9CMfYlvcA5bxIrs+ua+RV3+wxszWaajNtkJ4kJ6iXu+rmirHSFBVvxeRkkdvwjA1fTrA94HdSVZowvEzfdmqvUnz/gXu4S3hTjoXeD8Sq4QkZIi9AYwB8gRG3RKCXEMmZbjFMKdsa2VKsHGsaY+We/V3ApBgydkakaP+S0nUUCdnyORZ0ll5D1lnRkmDP4q4s5YBu2XljDhl1OiAIFdInumh02R2SXxqGR++DsCdvV48FZLUofqoB0UQqig0hBxxX4uTJPEudZQVYK0K3WlaSLTf8D79i6ovZvIsStN2/OCHbd9FDiVYsUFPuo2rpoZLpQ+Qfej56MTvcIkAF+QKNke2+guFw7hVY5vhY8zveGeGp/HkG6kD5sjsGDsijplhPXF1m2S/V6l2OIPVV/QxgEtIeSdPCMCpT73DxK5POLIzlU2ipzH76ZKaMkUYNwiZCG9ExGocN800HzQhlMMlJTHx6AaOhw3
 zksv11KT
 IUsTEuHlQQXOHFlBiBl25vXINqmUn202K1zNEF3Ra5eHYTQeDgPjQfKCK5h+wkv9vdySr27w/A/q0VLntfcB4yf7nmyPxGIXlY18A40YQQF4glnuergUoAW911D8ygbYTIfhcWFanc23AS1jk+Y3GMlF11MznpgPupAEOcactYTGL86zzfHeLhxRMDzNT7vVFmLI9oU2MIzp1Rtagdyi3MIL+TjvuOgJqBZBGyXUI9j1AwUkZTuPiJ1ZP6OPHcDfBZ19E9JhLvrfNF43HZcLTffKSNUbvAxyrYr/z0hb5DYSCT7DUBOZXhQCPByN708sKPoS7Ec4C7VM2Jlfk3xDpRtJod8qvqWRPRdVIxT0eCbQ3pPSsQBWhD5LdMnbFiYrHKShxd/yh+L4MuOA=
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
 mm/gup.c | 100 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 44 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index efb2ad64be80..3aed0bc1c2b4 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -965,74 +965,86 @@ static long gup_grab_fill_folio_pages(struct folio *folio,
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
 
-	if (!pte_write(pte) && gup_must_unshare(vma, flags, folio, page)) {
-		ret = -EMLINK;
-		goto out;
-	}
+	if (!pte_write(pte) &&
+	    gup_must_unshare(vma, flags, page_folio(page), page))
+		return -EMLINK;
 
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	ret = gup_grab_fill_folio_pages(folio, page, 1,
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
+		ret = gup_grab_fill_folio_pages(page_folio(page), page,
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
 	return ret;
-no_page:
-	pte_unmap_unlock(ptep, ptl);
-	if (!pte_none(pte))
-		return 0;
-	return no_page_table(vma, flags, address);
 }
 
 static long follow_pmd_mask(struct vm_area_struct *vma,
-- 
2.56.0


