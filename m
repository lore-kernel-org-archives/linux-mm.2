Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC66606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=bkafn7af
Received: by kanga.kvack.org (Postfix)
	id CE6236B05BF; Mon, 23 Nov 2026 14:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98836B05C0; Mon, 23 Nov 2026 14:56:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3F46B05C1; Mon, 23 Nov 2026 14:56:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0DD6B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF4221409B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:29 +0000 (UTC)
X-FDA: 85467440898.30.CC3AB11
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4AF9A20008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="bkafn7 a";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463788;
	b=dL+q8Aj1US32T6LBH7v+/YcFlEQAxR19UIyTziCnKhF2YtGxdZ9QotB4OZaEIeqHEGS/kD
	Nzw09aHnxKpm1cKH7+d5AdSSAMZ6eMaqWgmby4eg4jgXP6EH6aInBL7Ewg7/WCrq0MdsLw
	LpX34m8boftkAkLh7T8Uqsv0pQSExxU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QebCm/HdUJNQJhaYSYkTX5nopMX74EmzXUpwCg5l4wY=;
	b=xhZyCZUrLP19f4E8XuKAN5IkTTs4gWawmLJQjprGOtlOnFdo6Z0iwWKQJYsiz2yU8m03DA
	qKbYvk0KJBCPc5Uf+ftSFwSFQNLrapIkdUBTEGrqj6TF+vM0N+QWnlI50TQ0r694fMHlHF
	V7lZv2a1VBPin/mogXh6oJAImQpYteA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="bkafn7 a";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=QebCm/HdUJNQJhaYSYkTX5nopMX74EmzXUpwCg5l4wY=; b=bkafn7
	af9RQSHz5YgQbHnMTZD9q0cKlfKPKAnwgQ471p68km6500ZobrP4S414IUZh+r27gnbglITiixfw8
	mgYwUoAYj/QiovpNkNf0Mm2WN1qvSHWCCZKhQNlecy/Xg9bLL5Hx21V2jfKYAWM4uqviFbj2XVcSE
	9U4mS19uPDjWHvwOkFuqhXmDzsHmMjdBnI7Bp0h4RMDIAb65eBm3YsIAvjHD4Gt78LIayOJGNP2ao
	p0xpq6OflBp0V8fEmFL3rdfVPnRVr//vYZugZhhlHf6qSdqJogzX/VWevIfwobtIkQfX2nt1dQLz5
	8ZHk+ncKqGWhRAegzfXO/0ebBqhQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xVa99-00000006IU7-1Cs1;
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
Subject: [PATCH 1/9] mm/gup: break out gup_fill_pages() helper
Date: Mon, 23 Nov 2026 14:56:01 -0500
Message-ID: <20261123195609.4115244-2-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261123195609.4115244-1-riel@surriel.com>
References: <20261123195609.4115244-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4AF9A20008
X-Stat-Signature: j1mce8gbkuqs8jxomwtzeqoactgrqitt
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795463788-174900
X-HE-Meta: U2FsdGVkX1/ErsB2LZ7P6uBnEAkXvXszjy4LNCmvwTaelFASvi0F/sRBsM1fqM0QcD2AFKoQ5N/RRHBnGQZWrPeXAnqhK+jK4SwWpjIJSCDKqoOIjXOK99rybK5sBwNHx0yIj7zaG10Gc667FSaWVWL9G9pIrSEqnFd4meSXggjTACRwgfXmraPx8cJkr/rgnOIw8xARKf0YLrGjHLVVD1Cr6vV7FaBiWd34rsipGH8RXSeICAyeFbIKUaPpGMfGM/XtUeYWIXv+yfxKcHJ6BC1sf3a5i029PNJSzpJ0SZTamUj1/sLUFWVgDKThng07PGL+8r2PoJvuhVPIpAIOAdYHA2TTJSJK5jg29XuTT9yROI1gtu9TEMuHXybHoRiRJBsNBUwuOHFxw/HJ21+YXmKFCUhGizx8tL6fyAXYtVeEkXL3xTWYu4F2BnE9CABYCoLM1V/3KAiBrYoNSAU5WRnt74QHILAwlxOcE3qOu9cTJeWXQLyMut+b2bTFCTP4XzI52ZnVrmoY3EEJlsbVfzQ9X3URP7u78uf2321bKV86lP7mVCZN7bJoTT+GmAmKxEEC6ub32gjbNoIjdaIioitx1CVvP3JSXQOHFQ2FDyKjZiFjEFeqXlijHhsddGD3pbSdGbpr4w5H9h3JyEzmc7kTiBXHxGBdL5AHVnxD9uJjmEalcE+0SbW+omUQfEVgfnw/zNhVk+6GqyqNi74mKKBlpuUyAyqPvFP+eUDOpyoDzfSYs5JxIDl62g0T89Z8MbcofgSJ44JVif56aVGVR4rEpD9xSX09WlWiRcHUZ1vPKScvlVubIxzMAcnPMLWFaUkMaP02isIRSrQnVlfkAH5Uzc70Y/GCOxVRnhWuxkFkkXvSeD97LW2X6eP6kOJWyHJWJxdB2d2+GEA53xCgT9OFo0Hg19WWlEMDKM8UHFGIEkuOYobHwpzj5S/UAoetXPLPdgc3NUROVd5Hu6y
 ENltJZJn
 AkD5IpCQWQzHuIl8UXG/2YL40IiDONloW/u2SkHkcI/pfj4Gdbv1Sljm0H9nnUbuAXSQDu9OxDytVHJGFrmV5YkjccmlEetaFwy1vEo23b9YEr7Wem5xIPhL1rrJ17pzqPaoTBmr0IDnbwLNrtiRLCGx6HZ5KRTWgT4VcsfsvEqjNsz24OdaIQvOFAVec190zRBzQy8mvDXpRz6O9yE8M6uLhLQL+4pWJyK9jJ1kZceQYvYI1MU3kW6dJRzWzLkGmM2KnMTbAb9UECSXnu1wpKmoXlPvufj801DWwwutb9udmOAULFNC34zSKieNUl69xkLwMmF0t42uVLnCOOuyUQrbc3/Ocwt6r7F5YKNQk8SscPpWJ/9xBLOmJIrRrQTP7qtm3NYeMgO2WJC5qLQGvAaYjg7we1qE/ZpgMHI9m3yAg1g95QdSMsx3p9nEBEHDYo38NvMlZDUdzMukLKIQmUbXrUI8ixFVTudXosTmt0Ah5rComSj06vLmi0TuUTroI6HR1UB/8K+pmwvQtTUqIN3NDxHeN8sT01Fmujl5QyBrHloc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__get_user_pages() fills pages[] in an open-coded loop, and the
GUP-fast PTE, PMD and PUD leaf paths each have their own copy of
the same loop.

Move the store into a gup_fill_pages() helper, shared by the slow
and the fast paths. The helper keeps a pages==NULL check, so the
fault-in users that pass no pages array (faultin_page_range(),
populate_vma_page_range()) need no conditionals at their call
sites. Cache flushing stays open-coded for now; it moves into its
own helper in the next patch.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b0a0019de80a..e0698d2075b4 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -710,6 +710,25 @@ static inline bool gup_must_unshare(struct vm_area_struct *vma,
 	return gup_pages_not_requiring_unshare(vma, flags, folio, page, 1) != 1;
 }
 
+/*
+ * Store @nr_pages consecutive pages starting at @page into @pages.
+ * The caller must hold at least one reference on the folio, so it
+ * cannot go away, or get split while the array is filled.
+ *
+ * Some GUP users only fault pages in and pass no pages array.
+ */
+static void gup_fill_pages(struct page **pages, struct page *page,
+		unsigned long nr_pages)
+{
+	unsigned long i;
+
+	if (!pages)
+		return;
+
+	for (i = 0; i < nr_pages; i++)
+		pages[i] = page + i;
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,
@@ -1579,9 +1598,9 @@ static long __get_user_pages(struct mm_struct *mm,
 				}
 			}
 
+			gup_fill_pages(pages + i, page, page_increm);
 			for (j = 0; j < page_increm; j++) {
 				subpage = page + j;
-				pages[i + j] = subpage;
 				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
 			}
@@ -2946,7 +2965,6 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 	do {
 		pte_t pte = ptep_get_lockless(ptep);
 		struct page *page;
-		unsigned long i;
 
 		nr_batch = 1;
 
@@ -3017,8 +3035,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			nr_batch = 1;
 
 		folio_set_referenced(folio);
-		for (i = 0; i < nr_batch; i++)
-			pages[nr_pages + i] = page + i;
+		gup_fill_pages(pages + nr_pages, page, nr_batch);
 		nr_pages += nr_batch;
 		folio = NULL;
 	} while (ptep += nr_batch, addr += nr_batch * PAGE_SIZE, addr != end);
@@ -3054,7 +3071,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 {
 	struct page *mapped_page, *page;
 	struct folio *folio;
-	unsigned long nr_pages, i;
+	unsigned long nr_pages;
 
 	/* See gup_fast_pte_range() */
 	if (pmd_protnone(orig))
@@ -3089,8 +3106,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		return 0;
 	}
 
-	for (i = 0; i < nr_pages; i++)
-		*(pages++) = page++;
+	gup_fill_pages(pages, page, nr_pages);
 	folio_set_referenced(folio);
 	return nr_pages;
 }
@@ -3101,7 +3117,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 {
 	struct page *mapped_page, *page;
 	struct folio *folio;
-	unsigned long nr_pages, i;
+	unsigned long nr_pages;
 
 	if (!pud_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
@@ -3133,8 +3149,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		return 0;
 	}
 
-	for (i = 0; i < nr_pages; i++)
-		*(pages++) = page++;
+	gup_fill_pages(pages, page, nr_pages);
 	folio_set_referenced(folio);
 	return nr_pages;
 }
-- 
2.56.0


