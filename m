Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E7160A260F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XLiXGnf0
Received: by kanga.kvack.org (Postfix)
	id 755976B05B1; Mon,  2 Nov 2026 06:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706956B05B4; Mon,  2 Nov 2026 06:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D06A6B05B5; Mon,  2 Nov 2026 06:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35D2A6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:30:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 563E840CED
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:33 +0000 (UTC)
X-FDA: 85389961146.11.D640426
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7C0E140002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XLiXGnf0;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyfI2URWEEZSUDLYtQ8leAcYbuBDAQCTWOVugCAWeV4=;
	b=5FK6TMVuYtn3P3OEWqfUQUwfXqKFBBoHnT/Q2x3f2wIjC2mnrjhBSTJVjvAaNmkWiRQCte
	YNblwxvxnOQusDuRIHr2Sus8qRGHCvlLF96EO9Sdq0kijPsjf4UBspQ4bNrbGGyQiFe7q3
	MuOKXVqQmGM0ouX1wMQ7xf2nsJgsT14=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793619031;
	b=T/eboZBcpy4gZsfSgpS6EjwDfTwifKRqo+5PHtC0p8W7PfadbixH9aIQUL3naP+7xAZ20G
	XSe+D7EZIT3cg2ROmWkIXqA0LZXjqxsvnFCZCrNUQQB1D70cgQs/6DMnqv2bznaaQsHcwb
	xIV5KUOZSj9n9iogjR+8z3XRVGaMw1A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XLiXGnf0;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F147293B;
	Mon,  2 Nov 2026 03:30:27 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C15DD3F632;
	Mon,  2 Nov 2026 03:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793619030; bh=GEgao3jfAi97/KvYK2veDWTPC1m/gdO7DW7bwurZlRM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XLiXGnf00xkvKIUafAQUeHYdENhmgL4sxUWBXisxFXljYCO44sut8T7qDwvsOxxpb
	 sIWIbr7lPBZMIZWQd2Oxk5ctUvHKihU3LQZpuyIqA1tyS/aG0FHnWFCQ3pteULiCRL
	 kZDGGQG5b9TQzqESoOpXQqrE/udOKrQKwki/Gotk=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:30:16 +0000
Subject: [PATCH v2 1/4] mm: gup: introduce gup_unshared_pages()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-refactor_gup_fast-v2-1-bc1ac018c834@arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
In-Reply-To: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6819; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=GEgao3jfAi97/KvYK2veDWTPC1m/gdO7DW7bwurZlRM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HRQmVkVyCjC+EeXYi6E21LfeXEwU749jq1po
 RzHY3/yzC+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauh0UAAKCRBt1cPRWsUx
 MyHIC/0TxjuZnMQ+FNmQwTWYDFrWseD9LL5B6jSB905GLvi/7KGxw7skPmQqkQu5xKbtNF/XJAI
 2G7Cjwouc2XmpheH3wLDURh8oiJUhTGH2h2aPbAw2WB7KVM4oeZXvXMUZILv/UkqzqOgUGOFvp7
 EWy86UIT+pV3QeESX/QQPcv14whSYkuBpbyrxB3E7pzld0cYQlIYo4riV9+ApJ82PWgkPOv+i8Q
 be4S9c77HHZ+Ekal3eeEK7Keijfm/IpHANwCT9JZBUjhX7GrczoOHP8I8u9OKi65DYvUI5FkssN
 awsXgiKUS7A9c8xdSRq3MaRLbGlxsYjn7PyFCRMBhtjQ5mzV/SKhtVEhz8Sb6PDpVcZgZ1E7To+
 n8cZXN7eOw/ZlE1ZhhoUCrHNbw3VlZGhU1OG07Cy6dOl1eOBwNYR9L8jVSZt3nrsSOHkwlYjoye
 IDlkL+b3wL3lkzaf9yI62QymzNsFauRbhlGYmoyTR+7oqT6zfA80JfLq8YgnzAXwkwhbQ=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C0E140002
X-Stat-Signature: 3siwuz4fh1pm8gt6hn5qstaap3csoqxc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793619031-83275
X-HE-Meta: U2FsdGVkX1/mDOB57WkB3fmjlbZVkIbJYw4W0kBZrPe7aO//gBsIMB72TS3TeenJkt7jv4cFmocPsuZ8IEet07i+HsQqk4sKJY7YMsyt3nRZyBg3W9I047kIqZaj65PcMEGrFF+uHZzCc5dKChouWifk0dHQVVOrgCbNUC5AiV1gJpND3ikBUWiMhqsjOku7p9nNIUgAOyzitccEs3VbGkUdN71Vp+Xa0/xEtHxjOFs84ZesWocKYXWfYgGqBzz1bABfG3IqJeiDuqDIulGbj63LVXH2f7lm1rKYnNArzpxXo683pCR6EmJIJPeKNZTsRVsQXlJv4/FZcvymcr5Q6hWVTJ1+zVgBq8UF9XYoApfUqpNATXjV94DvpI99H7nNvcubf1brGF1jePWlqzPsFQ0Ar4+3WTYnraO9dYDcTVji6DY6Yp0NnheMCw1sgRlKitkUWnUac8mv+9ScAJnyXF2cM7DCd/bjJvraPeGEXOYSeAq3m8qpqEUUbSrMB+8EM1AEDfGHkQ2VTsSSvkihSkYVWh/SzKxiqM2K+W1ILFTfR4VREgAINlDpaQStUqB+aY4tW0qFE++BlHFA1CLZKcClOmIWhtrYRMOFPumKCBm30c0xUxxmlwY10FKjFaFT+aqlqukOO0tPBE1KzYnXRx4add0IH9KhO+j9ermw6Dh1wDH2bHrSTo4tiSzQ6mKjF01MnsH4kTkI8tCDNjJAl8SDLjhgBV0BibS0CCm85V2BCRMinueqS8IobURt0CKb3kGFfv7v5mYGsLTYm9dqlQEACdD9+tfstlUl5WSmFcmRtlcPJUjuV/s/kdcb6pjSFanxbSTGvWB1J1pNW7JVN2/r+5zt0qoyTfa3bn1qggb/6PRDOXndtH3hxonDYlgzw+n/iHfGmTKqD3b1ptTYqFCVVLIQEpiKp7VdWOa0/p07fdhH31+f95bffAhK23YNSvYstuX6nJ/Yk+h0jue
 BT9unCpy
 rsXMlZsciLK2coiNtmjo2+2CM4KeUD0avRuxjK1UAiqns+PryG+XefGtM+pK4YsA0BfAjMpTfTC6WzYWxO8KhvEQZ+BDaYpj1l+yuCSLMTB2Ax5z0V3b2djuvtxhMFrtI7eFXOt3I36+d6YxUPBrLRJ9z5O7ux7T9syPZIHumG0aU7d5XPd0uzuJxWqnxw8zaDdO8gxuRd7UnbkaR9K8nqFaCxliCV7jyyeN9ZU4c5RFUPEEYF9ZkXhjkvnoC/9O8N2B1H21S+Te/v/Ivt18iRNvhWfV3yeCVPqOHaDHE5jxj+yI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is preparatory patch to make gup_fast_pte_range() batchable.

Introduce gup_unshared_pages() to count consecutive pages within a folio
that do not require unsharing, and use it to implement gup_must_unshare().

Also add a folio argument to gup_must_unshare() so callers can reuse an
existing folio and avoid the compound_head() call implicit in PageAnon().

There is no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/gup.c      | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 mm/internal.h | 49 ++++++------------------------------------
 2 files changed, 70 insertions(+), 48 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7d43ce717b246..49681f63950ec 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -633,6 +633,59 @@ static struct page *no_page_table(struct vm_area_struct *vma,
 	return NULL;
 }
 
+unsigned long gup_unshared_pages(struct vm_area_struct *vma, unsigned int flags,
+				 struct folio *folio, struct page *page,
+				 unsigned long nr_pages)
+{
+	unsigned int i;
+
+	/*
+	 * FOLL_WRITE is implicitly handled correctly as the page table entry
+	 * has to be writable -- and if it references (part of) an anonymous
+	 * folio, that part is required to be marked exclusive.
+	 */
+	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
+		return nr_pages;
+	/*
+	 * Note: PageAnon(page) is stable until the page is actually getting
+	 * freed.
+	 */
+	if (!folio_test_anon(folio)) {
+		/*
+		 * We only care about R/O long-term pining: R/O short-term
+		 * pinning does not have the semantics to observe successive
+		 * changes through the process page tables.
+		 */
+		if (!(flags & FOLL_LONGTERM))
+			return nr_pages;
+
+		/* We really need the vma ... */
+		if (!vma || vma_is_cow_mapping(vma))
+			return 0;
+
+		/*
+		 * ... because we only care about writable private ("COW")
+		 * mappings where we have to break COW early.
+		 */
+		return nr_pages;
+	}
+
+	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
+	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+		smp_rmb();
+
+	/*
+	 * Note that KSM pages cannot be exclusive, and consequently,
+	 * cannot get pinned.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		if (!PageAnonExclusive(page + i))
+			return i;
+	}
+
+	return nr_pages;
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,
@@ -668,7 +721,8 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
 	page = pfn_to_page(pfn);
 
-	if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
+	if (!pud_write(pud) &&
+	    gup_must_unshare(vma, flags, page_folio(page), page))
 		return ERR_PTR(-EMLINK);
 
 	ret = try_grab_folio(page_folio(page), 1, flags);
@@ -722,7 +776,8 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 	if (pmd_protnone(*pmd) && !gup_can_follow_protnone(vma, flags))
 		return NULL;
 
-	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
+	if (!pmd_write(pmdval) &&
+	    gup_must_unshare(vma, flags, page_folio(page), page))
 		return ERR_PTR(-EMLINK);
 
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
@@ -846,7 +901,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 	folio = page_folio(page);
 
-	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
+	if (!pte_write(pte) && gup_must_unshare(vma, flags, folio, page)) {
 		page = ERR_PTR(-EMLINK);
 		goto out;
 	}
@@ -2892,7 +2947,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			goto pte_unmap;
 		}
 
-		if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
+		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -2969,7 +3024,8 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
-	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
+	if (!pmd_write(orig) &&
+	    gup_must_unshare(NULL, flags, folio, &folio->page)) {
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
@@ -3011,7 +3067,8 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		return 0;
 	}
 
-	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
+	if (!pud_write(orig) &&
+	    gup_must_unshare(NULL, flags, folio, &folio->page)) {
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
diff --git a/mm/internal.h b/mm/internal.h
index c53c369bf8b5d..35016b1afc8bf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1282,6 +1282,10 @@ int migrate_device_coherent_folio(struct folio *folio);
 int __must_check try_grab_folio(struct folio *folio, int refs,
 				unsigned int flags);
 
+unsigned long gup_unshared_pages(struct vm_area_struct *vma, unsigned int flags,
+				 struct folio *folio, struct page *page,
+				 unsigned long nr_pages);
+
 /*
  * mm/huge_memory.c
  */
@@ -1354,51 +1358,12 @@ enum {
  * to fallback to the slow path just to lookup the vma.
  */
 static inline bool gup_must_unshare(struct vm_area_struct *vma,
-				    unsigned int flags, struct page *page)
+				    unsigned int flags,
+				    struct folio *folio, struct page *page)
 {
-	/*
-	 * FOLL_WRITE is implicitly handled correctly as the page table entry
-	 * has to be writable -- and if it references (part of) an anonymous
-	 * folio, that part is required to be marked exclusive.
-	 */
-	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
-		return false;
-	/*
-	 * Note: PageAnon(page) is stable until the page is actually getting
-	 * freed.
-	 */
-	if (!PageAnon(page)) {
-		/*
-		 * We only care about R/O long-term pining: R/O short-term
-		 * pinning does not have the semantics to observe successive
-		 * changes through the process page tables.
-		 */
-		if (!(flags & FOLL_LONGTERM))
-			return false;
-
-		/* We really need the vma ... */
-		if (!vma)
-			return true;
-
-		/*
-		 * ... because we only care about writable private ("COW")
-		 * mappings where we have to break COW early.
-		 */
-		return vma_is_cow_mapping(vma);
-	}
-
-	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
-		smp_rmb();
-
-	/*
-	 * Note that KSM pages cannot be exclusive, and consequently,
-	 * cannot get pinned.
-	 */
-	return !PageAnonExclusive(page);
+	return gup_unshared_pages(vma, flags, folio, page, 1) != 1;
 }
 
-
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
 	/*

-- 
2.43.0


