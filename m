Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F57B606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=O/Cr/Jpc
Received: by kanga.kvack.org (Postfix)
	id D0E8F6B05B8; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5646B05BC; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E7C6B05BF; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 886286B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1886D1409E0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:30 +0000 (UTC)
X-FDA: 85467440940.28.3075781
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id 88FBD140009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="O/Cr/J p";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463788;
	b=FgsgevhlV/55ZTgcwF0bOFW9TC7KKjx/+JDImjHBABqLHVkjMcf2CVNTOjqr3RMzoXf5Pw
	jKoWKMBDtUl2CHTuVHewj0Zo7einNwpwK1ACXkxdefVM34SOWcXSo/pnaki5xLaOLU5PGG
	o7FTWSpE619lMkF4Wc796S0odAmmCic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3nyf5W47UgYpP4B9F86Yz8ZQ6TUVBJoCHj4TQFdYoU=;
	b=1RFNIJOdtLPMb8ZHfJPiIRytzQqRtBn3pcsgTGj7LYUS7KRg5YhnmwtC1Af6Hm5s0aUzTI
	y+88RxHDcQXz3aYFggiVy/62OtJOKc/pOrga+1UOWpcVYgCL+KS7yzWa3/5kjiu2J0TJ8I
	h5poE3mOjUJJniQm+kT9/oRNuji47Wk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="O/Cr/J p";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=N3nyf5W47UgYpP4B9F86Yz8ZQ6TUVBJoCHj4TQFdYoU=; b=O/Cr/J
	pcnrcCOeJU4KglvusKc3MxzjYXyI2+j2R+hIPxRRd45J/Xozq6YBmtZmjyrnVMjfCt/k64Jf5+1lF
	hyMI7GoHv7FEyf4uKFXV20bGK73x0gN/PHAI9m3nQdkSvjJlV6LZcpexVuOxuxxaGwDG2e/l089dJ
	FAZ7f5nr3cJgr2uG6fWzz9vEGRUGuE2lmOdsf076j6rsexZNVGer9sDbymGyGHHEi9aZEpq12z/96
	JjgOMQsHcRfsSTAcsx0d71OVlC01X9QExgnCTgDoByPt4UvG0ZtclHHp+cXP41TxOa+AIBZ1qaZon
	QYriNr74Pjv1WhtjMHNeBVpx/0qA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xVa99-00000006IU7-1i1D;
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
Subject: [PATCH 5/9] mm/gup: break out gup_lookup_pte() helper
Date: Mon, 23 Nov 2026 14:56:05 -0500
Message-ID: <20261123195609.4115244-6-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261123195609.4115244-1-riel@surriel.com>
References: <20261123195609.4115244-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88FBD140009
X-Stat-Signature: pyx44eqcqouk3o8jrojn3j53xnxjfa78
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795463788-9752
X-HE-Meta: U2FsdGVkX1/67jBrOvPQARuE3QnPsGmNOfqdiAQn0hTOKun8RV+m9gFWK6QjnM2Kd2AumO3566oTShitM5/i7ZpkyCnOFrO04eYwlFX5NE+2Vzdcy0Q6LurrarPwWVnWuCLLjd72MLiahRDpdwula2vizdUEmiUHD/6OLkDPv0J1alMTLJ3yUBptpNTjsc8+tXlTH7HVurYkX0KTXISesb4yErLEAfYrWYHIHRBNYmwYi3EEg/4ocFPQPP5rY/la3CNltILQTBwAW3Hqr1wqDqqcMSCL6TSBqDGnO422++tnbMW+N/RSIQR8qT2gBwoE59H+pvCCEHW4Q91WTEq9wHWuRGjyfmI8KPBg02uU5kAU6d63bgDgPBb5/lFrifk5kGzzmYJZWq/8TDzI6KAFBLacs9OHN7245iae++WZ5qdD9GsYnAHCaQPjYTq5Ky3HBp75+GW8Qz1wmANADYAp6CVqnCbJ+ufVo6tcrKV1dmndiZ4+w7TcIJmYpv1WISHWW+S77CaZmw3nxClwt2+KZFrkWcC+T982usNLQG+hA2BqQsaN2C57epS8A4aezswUHhKX+e+p/0j0reZqoG8GecbIkba/aqmjA23T4/5dfUqlUTMM1g+Gp1VWVlYr+hbn3vbmyzZEXSl7fq0xcvchUD8XE8qrJydkwYBNNFdiVLamWF4EutzoO46ioIUIGebLBRZNxYUpzI6zUnM7l1jDj5S1Bihvj1XJyVa7RPJpe15Idw/2LQywPLNTxKIgm7uEvFk3sf0dFP2JVb//IiXUelqhS+zoGdRyfom4dSvNtZAwg1G2UdaTy/qPRzgrN/v/kUpGbgexf4QSbiOuhT0g/XsFOvVS4+lb+xGq2E2GHDtzM3mmkgc/IXreUgI/eUZFswCQ73KkVdu9Iypvz3i1jqAnpybrlB0N6yxfZ7gS+Pnok2Z1zMMoDBF/be+bXhaIcN4zj0oei3WK1AQmPeB
 VBHf28sT
 2Wxhn85BIDSdwXSY6PeTPR9GZmZ7uTfc5HDGJ0WTVugfDQ5AZIzi2rrJ3/f+FXlk+uofaV1AcLsgtqnBIPRRYzw8GDArotgSWLcHzk7Jl1QKgt+wwjctlaNBVrWzc7QR7L0rk8yuYH3A8qPYtrRZ/KuNZCLfmYGLfJdBpCEzodevGWQ+Rcq1dlWlp61tWECcsQgcNfHbGufAWHzYsjIXsANpaS0VdX3xos+WgMtM4y20TX/pTX6iU3OYYWy8X034osOyeZWrhNddA3gmDQEnQBuM4YvjpQyPySxY0zlLoRKWQhKIxk+kM6uPAvqF2OI75E/w6/fOK1uJUkGDzZnp5Vdcdnr1G7SV+PxMZ52+3SMP5zhlAhfJXif8z6/kE8UWXdU1mjT6OHNGQYQVxBQrc9NAs+kcku4+yk/96OEbUf7IoKM5fQKk0kM3osWugnpmZk7jvs9V9AigieepPPlorCxDq15aNhNhtbcmCvH/7QDGAQk4c/fudemwKe9rON5nnn6wA0RJWMw2+DmhJxUqpaGbCRejRJm9LP035qhHOm9TiE7QK5nHTSLxt4Ltp558p2JUL3KA+eJHBlw8KGXf/U/xBRWrhbz/lw9ORLvRwYoIdQYCAKhezl9P02LocYR25x1m7kDXIo+2bgsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_page_pte() does two things: resolve one present PTE to the
page it maps, then grab a folio reference and hand the page back.

Split the first part into gup_lookup_pte(), which returns no page
and no error when the PTE cannot be followed but the caller may
fault it in, and a negative errno when the caller must report the
failure. A none PTE in a hugetlbfs VMA can only be resolved to the
page cache outside the PTE lock, so it is deferred until after
unlock.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 102 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 58 insertions(+), 44 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index d2097ecd1576..54a710f1a843 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -965,74 +965,88 @@ static long gup_grab_fill_folio_pages(struct folio *folio,
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
+	struct page *page;
+	spinlock_t *ptl;
+	pte_t *ptep, pte;
+	long ret;
+
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	/* The PMD entry is empty. */
+	if (!ptep)
+		return no_page_table(vma, flags, address);
+	pte = ptep_get(ptep);
+
+	/*
+	 * no_page_table() may access the page cache for a hugetlb VMA,
+	 * which cannot be done under the PTL, so defer it until the
+	 * lock is dropped.
+	 */
+	if (pte_none(pte)) {
+		pte_unmap_unlock(ptep, ptl);
+		return no_page_table(vma, flags, address);
+	}
+
+	ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
+	if (!ret && page) {
+		ret = gup_grab_fill_folio_pages(page_folio(page), page,
+						     1, pte_dirty(pte), flags, pages);
+		if (!ret)
+			ret = 1;
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


