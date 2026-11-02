Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE011606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=MKnnxfMi
Received: by kanga.kvack.org (Postfix)
	id C11D36B05B3; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B539D6B05B6; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BF36B05B6; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7059E6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E877040205
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:13 +0000 (UTC)
X-FDA: 85391172426.16.10C593C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id 67CB840008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="MKnnxf M";
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793647872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=raRdFfKQG3ctF9Rx/PRY8SMQGHRdhOgJO6NWXsk2doQ=;
	b=PjJNdy0AQsgSiUSgPoO6wHk/emS8gjCTzJX5cf/w4T+XvR2+CI9hg/fEmxtdBbO5H17kzy
	573G12pZoPDvjZ6aaXXr7SoYDCvKNNgJ33lyb7CEqCbuPaHCEy6QKHoMz8GPBhFrzPgLzB
	ozZca+q5/0QbDeXQ/TOzoQqW5I4UJWU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793647872;
	b=SAoquFCtW3KKaSKE/7Y9crgsnyoaJKBV8B9NmjpY90WS0Sgu6BiIUggotF4bsbKwg3JzQW
	j17vOH3iia9toSQIuEZ04VnM2qW8Tkz5gWpaPCNBAFBEdZiLnyJN/aaPGgRBSDor6/bAsK
	ZhhiAHRcNJvx0Yg/BXeujSPYaMpcGA8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="MKnnxf M";
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=raRdFfKQG3ctF9Rx/PRY8SMQGHRdhOgJO6NWXsk2doQ=; b=MKnnxf
	MibGczrzkmbcauZqJ6WSN2EtKBURVekAiOKKVnCxjQUcjc2UszWqQcgXztGvyiK+TdJ7gyTd+fbRX
	ygT+a64vCOF3oG3IGXNzXQJTTm6uF7ACusqHYdaCdIr7oQmkGzlCiQGjjEzsYVHmxemMDoqdPQwhQ
	mlpTwBKtZBIau721Z4G4sISRKr8Z/O8tjv39S7sBQS9t3wo4KHUF+d3yJaUrwGPbY/RQcaQ8AZY7e
	FhvZruzPODFN0wHznsEHp/3RtKpdCa2kQRF+khjt/mo8b7xUx8fKys19LisUqMCy2Va8eEwCTfQyS
	wRxgMy7smnxjDf6CIn/Bm1s8nPGQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xNxjk-00000001W8x-0RGy;
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
Subject: [PATCH 3/8] mm/gup: split out folio grab-and-store helper
Date: Mon,  2 Nov 2026 14:30:21 -0500
Message-ID: <20261102193026.3860700-4-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102193026.3860700-1-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1r483dzjtq4jqo7j7ut5ui5h4b3imywf
X-Rspamd-Queue-Id: 67CB840008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793647872-725542
X-HE-Meta: U2FsdGVkX19kRANjTifhL7iai6Z8g3CA3gtUUEpm5/6JQqubPFJUr+Pk4YOsqJ66gSfzOnpLKe6Czt5eyeU46BO++r4Ela1O+a7ad+AufZAOpauNzIpUnYGfxQXz3jzZYxSbofcIIq/HC2d5m7jEvDsIKiEm4Sk/jJUlLFny0Dqf7YzQ2u0It7fHQ6Joj9uNunX63UyIUkBv3IRfhQ/zgM0Qzu/LGGGlu30Sn57CHWxqgaWNi/vFGAIPGIVh6M+XsRbW7USzSOqnY8I7GQA8FfU0bsV8isJWZFqpb/2nqR5iMLQg40trX1dVUAj5alLZGh2DhAe9/fczzcPNRtZv6i3Ok9J1mPvyTS028BDwOGCtrcTEVsKzPB2iZOsLTLAOp7diQ0qnhSNbcu7TAIy2TRk7UzV8pnY3QfGOnfUKV7Psopd4TxoUZCa9eqXEwX2tu4oQMhRhqMzeHMVjZNk24sN4clERT1NFdasJ9PRz3uxyVq3a/Wa9h3FsRJ9px5Tfj7HWn3XF1Uo0t5V7AayJdca+v+Pp/zScAUa4VHYNKb3tNHR8z2sZ5uFdTF/VIcH1QpS7/MH3d2SEDhhn975TPIWdEvwoD88qfW3OGWooJirQ1W26jQMAt/d/yW+LzbpZNMBjAcyOtHd6mUfz+yO4kKlL/eI4cW+2AphI7tSZDkh3VLz/QtvmhancOmfBmj1Ag7br7AAMnOSsYbRuItYqjEjggLpMXHy3UqttPsYH4TJ6Aok+XXOQ3sqsKa0RJJb+WhDEXelqhHHjqcU72VtCSrbs46skEgFiklOANSidxxSbD6vtb8TSXlSDdBCzuQ1nh+z2whe1yOYN+/7ZVjx6+Z+LYHDdOFENowtW2bct4PZlgNE7KZEcyI2GRvpsS5bglnodv8B7MDThn5N0iiJsrRC2bWZ/Js4lXKxoKmgimBO+ux5gkrbSnD8LVl2JYuRhwhZBlANVdlXYnPbQV28
 9CoXHupa
 j+W4++Fl412WaZMom9gKBdu3Iva6aK1fJfwtusug0tRTqZv0Ra6G08ZVHyGEvr/c7pepogRm7VtPwRUVwcWObA8vnAqnzh0qbO6Vtyg+41VHGfJsX28TxzHMCKdqwAq5eqHl0rtHu5vKOX2f/Ok6FLUBkAO+qQRCNYN0peaiPizByOulXOfOZr4IPkVHAlKKK6dadGLtOCJKVKRnxDSCe/yNEzQ6K+uYheSb5sfI1kVZ8Rbd8trpY/JoNt8JTJkabD35mY2Mq5OKnQJFxGebUt7yu/tZYo97rq3w4JO0Gmq6FPQLumQl5JtSb7zfVXBlUD+ZCbdn26//hf37PUkmZbcCyT4GOoxz2PRn2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_page_pte() does two things once it has resolved a present PTE
to a page: run the per-PTE safety checks (write-fault, unshare), then
grab a folio reference and hand the page back: fault it in if pinning,
mark it dirty/accessed, and fill the caller's array slot.

Split the second part into gup_grab_folio_pages(), which
takes its inputs as parameters, so the checks and the grab-and-store
can be applied at different granularities. The name states what the
helper does, not 'commit', and it takes the PTE's dirtiness as a bool.

The helper stores the pages but leaves the cache flushes to the
caller: split them into gup_flush_pages(), which follow_page_pte()
runs after dropping the PTE lock. Storing one slot under the lock is
cheap; flushing is not, and needs no lock once the folio reference
is held.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 101 +++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 72 insertions(+), 29 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index f7d940e7e5ffb..27ae2a1d7c36d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -650,6 +650,25 @@ static void gup_fill_pages(struct vm_area_struct *vma, unsigned long address,
 	}
 }
 
+/*
+ * Flush the caches for @nr pages stored in @pages. The caller already
+ * holds folio references, so the pages cannot go away; this runs
+ * without any page table lock held.
+ */
+static void gup_flush_pages(struct vm_area_struct *vma, unsigned long address,
+		struct page **pages, unsigned long nr)
+{
+	unsigned long i;
+
+	if (!pages)
+		return;
+
+	for (i = 0; i < nr; i++) {
+		flush_anon_page(vma, pages[i], address + i * PAGE_SIZE);
+		flush_dcache_page(pages[i]);
+	}
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,
@@ -822,6 +841,54 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 	return !userfaultfd_pte_wp(vma, pte);
 }
 
+/*
+ * Grab a folio reference for @nr pages starting at @page, mark the folio
+ * accessed (and dirty for FOLL_WRITE), and store the pages for the caller.
+ * The caller flushes the caches after dropping the page table lock.
+ */
+static long gup_grab_folio_pages(struct folio *folio,
+		struct page *page, unsigned long nr, bool dirty,
+		unsigned int flags, struct page **pages)
+{
+	unsigned long i;
+	long ret;
+
+	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
+	ret = try_grab_folio(folio, nr, flags);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * We need to make the page accessible if and only if we are going
+	 * to access its content (the FOLL_PIN case).  Please see
+	 * Documentation/core-api/pin_user_pages.rst for details.
+	 */
+	if (flags & FOLL_PIN) {
+		ret = arch_make_folio_accessible(folio);
+		if (ret) {
+			gup_put_folio(folio, nr, flags);
+			return ret;
+		}
+	}
+	if (flags & FOLL_TOUCH) {
+		if ((flags & FOLL_WRITE) && !dirty && !folio_test_dirty(folio))
+			folio_mark_dirty(folio);
+		/*
+		 * pte_mkyoung() would be more correct here, but atomic care
+		 * is needed to avoid losing the dirty bit: it is easier to use
+		 * folio_mark_accessed().
+		 */
+		folio_mark_accessed(folio);
+	}
+
+	if (pages) {
+		for (i = 0; i < nr; i++)
+			pages[i] = page + i;
+	}
+
+	return 0;
+}
+
 static long follow_page_pte(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd, unsigned int flags,
 		struct page **pages)
@@ -877,39 +944,15 @@ static long follow_page_pte(struct vm_area_struct *vma,
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
-	ret = try_grab_folio(folio, 1, flags);
-	if (unlikely(ret))
+	ret = gup_grab_folio_pages(folio, page, 1,
+			pte_dirty(pte), flags, pages);
+	if (ret)
 		goto out;
-
-	/*
-	 * We need to make the page accessible if and only if we are going
-	 * to access its content (the FOLL_PIN case).  Please see
-	 * Documentation/core-api/pin_user_pages.rst for details.
-	 */
-	if (flags & FOLL_PIN) {
-		ret = arch_make_folio_accessible(folio);
-		if (ret) {
-			gup_put_folio(folio, 1, flags);
-			goto out;
-		}
-	}
-	if (flags & FOLL_TOUCH) {
-		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !folio_test_dirty(folio))
-			folio_mark_dirty(folio);
-		/*
-		 * pte_mkyoung() would be more correct here, but atomic care
-		 * is needed to avoid losing the dirty bit: it is easier to use
-		 * folio_mark_accessed().
-		 */
-		folio_mark_accessed(folio);
-	}
-
-	gup_fill_pages(vma, address, page, 1, pages);
 	ret = 1;
 out:
 	pte_unmap_unlock(ptep, ptl);
+	if (ret > 0)
+		gup_flush_pages(vma, address, pages, ret);
 	return ret;
 no_page:
 	pte_unmap_unlock(ptep, ptl);
-- 
2.53.0-Meta


