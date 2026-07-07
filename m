Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED38C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7D26B00A5; Tue,  7 Jul 2026 08:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABFE46B00A6; Tue,  7 Jul 2026 08:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE116B00A7; Tue,  7 Jul 2026 08:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 735E26B00A5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:12:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F09704042B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:12:05 +0000 (UTC)
X-FDA: 84961867410.03.72EDDE3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5D38940012
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:12:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WGCeZKWz;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTuSq/DBZ9+fUDrtx7MtAFWd7WTUHerzHDuYQlRAqPE=;
	b=geMz+YElvuEWsPCvi0O8wjdrqA3D1rCcSKO2CwHNGsKFTndriUXJUZ2cd3iKZUfcXbSK3i
	xcadxWx41f7DF+ScrsoqnzbHAkOhvlP8OBamxCdgntepIAqy/myM39eMJXYUIfbIZ76kF8
	f4bR4wMWqK7UbHuwslteDdLMbYJIm1M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426324;
	b=NUCNaT97HmvgfGAamw/F87WXLu3Sau7qygkZEVxBRwSlDrwCIodccX5+EX1UxMYSn3NdKd
	cbn6jY1k6LeRQMKV5/rfgZwr5lEK362sPFs1pYazX7Nm94PEmQyE3udVZWePircsTWp6hy
	jsRt8vGcRYZ3hVxcnuOvnJ9+MEGMBxg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WGCeZKWz;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A36C1E8D;
	Tue,  7 Jul 2026 05:11:59 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 617EB3F7B4;
	Tue,  7 Jul 2026 05:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783426323; bh=2GK8o4qasnLQawbaz76qEMGQ3KvGxUxUcAMZU7uCfZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGCeZKWzreSAJh46bIERTCb4XKHYKAq3N4dMnlHNuAPxmjof1N3MMEBtlR7oNAa6I
	 H/TRZQWfynEZ2/9Kv3qXxjzenKrBPrKCFDa280hBMnS5f2Jlqx60SZwSRH2FMhLk+s
	 3Yy4B5BHuLoRu/UeN+S798X2rrm92v0nSQtQm3ZY=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 4/5] mm/rmap: refactor anon swapbacked folio unmap in try_to_unmap_one
Date: Tue,  7 Jul 2026 12:11:22 +0000
Message-ID: <20260707121128.373192-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707121128.373192-1-dev.jain@arm.com>
References: <20260707121128.373192-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D38940012
X-Stat-Signature: dqa6414wgbach1kd9ewyutktdjw1sz3p
X-HE-Tag: 1783426324-556016
X-HE-Meta: U2FsdGVkX1+sYx9FIn/iKcZdnyea+HRBZHqBw1N/Dsby4eOu5ysWr7VNXk84SvgZBcm6r1JOaK3aUWAvoVbAdS8wymhYAUDFuYn79h1IxHxnBYLLgsqvWbQEmxDitHiZYgcuf6HyWUELFwGoG6/KF+lObI6EZpE0xjptRpW5r4JVmQY5EDfQU5GN2rN850U03FGMBVMIMw0RNuZdZc9Tz2Ss+NIqYdJz5TCMGMMRYUP2QF11Hq2YU3n8EuPAYF5XQnfGdEzR1xLtusK8huqhWQV4AkxuccviIzkqFgUnSbwj8UkHOvUHmDN+OTnteA+FZ0es4+7yB7SsfmNRR5Wl2yk97Jy563SyHq0vEr24fTEBoo6SUyevmaeIZu6OKws04GQXI23SdnNLoX/FWQXYdd/xXWPzDhuNjcZoRZsMeP8iiPRri5scbPzgITjoIZl5/4sJZmBwkUDzMzgu05nmBHSzXg5R0xj/yam1ROekHzpMo3aAXCsQiGfxYcf/4EnEGOjTMKGGERC9FBpHoBLgf8bLbolsjhFbhLlYvBDDT2OXtv6Gf2UaMM4HVMWrZVKLPgO2bwJJVle4QC68Xo10m14QOzLNvH3ESro0hNiQqsGg4754Rd39WbM37/5XfPibX310eDjxLbjiDtBaY/lFWd8SJ3yNNFBUhh0qeCi58qIMvGShXrlhzglVXsxR6QKZutPl6ccnFJCBfL1aexyh5xu/W8NmVJFVqp7LepyQB1LOtZCXrnNmA/ZL//JQiZwyMFHTedU5gXz66rVL+pDx0HNM5xhl9m+Y6mrm85KzyXfXML4dQFUqlUrCxRiCWVhAF5rUp1lDgClOj3gzMEHHEY1DRuEUGspinvIsqklJvnBPLMcPol7x0d1ECg+b5OY1K2YkfB5YrTI9qDfZNXBn2yO9KW5dDlgQh6xP9PvXFRssDHhl9DPKyCp8ShKDXhib1cUy9LjaPCubnbY9ec5
 xZVfrD5g
 bmfr89gOVisgB0WtBJMHv6vaawMJxJmsXdi3SasBpek4a5Wq84Pt6gqLZjYUlalIExobWmuhF5ozXUJ76dAmxUrT9TGA+DRdeyUNpy2SlYOjdP+ZbAcyxWWRRnCO7fL1EsTvtSOsJ7Ta4wAz43AXGroUlDeZ9PyzB48/oNDw4bmkUQVgUJACkeFaa5um2WTlPECje93DpBaeP3rmWal6nymzciPv0kuwlvWbBNNMkxXaUhnTX1zGvYGbveBLt1WINgLB5YB5QSu7lLpny5ILIt+2f73YLxwCz4cxNweAxlDimx3MIRt+UaDnoVt7SS9qR2WgPKzoZzb99ZnGCmgNFzWW/eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor anonymous swapbacked folio unmap to ttu_anon_swapbacked_folio().

No functional change intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 105 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 43 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 00b571c2a1bab..ade78df5be2bd 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2113,6 +2113,64 @@ static inline bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
 	return true;
 }
 
+static inline void set_swp_pte_at(struct mm_struct *mm, unsigned long address,
+		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive)
+{
+	pte_t swp_pte = swp_entry_to_pte(entry);
+
+	if (anon_exclusive)
+		swp_pte = pte_swp_mkexclusive(swp_pte);
+
+	if (likely(pte_present(pteval))) {
+		if (pte_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd_wp(pteval))
+			swp_pte = pte_swp_mkuffd_wp(swp_pte);
+	} else {
+		/* Device-exclusive entry */
+		if (pte_swp_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd_wp(pteval))
+			swp_pte = pte_swp_mkuffd_wp(swp_pte);
+	}
+
+	set_pte_at(mm, address, ptep, swp_pte);
+}
+
+static inline bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma, struct folio *folio,
+		struct page *subpage, unsigned long address, pte_t *ptep,
+		pte_t pteval)
+{
+	bool anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(subpage);
+	swp_entry_t entry = page_swap_entry(subpage);
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (folio_dup_swap(folio, subpage) < 0)
+		return false;
+
+	/*
+	 * arch_unmap_one() is expected to be a NOP on
+	 * architectures where we could have PFN swap PTEs,
+	 * so we'll not check/care.
+	 */
+	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+		folio_put_swap(folio, subpage);
+		return false;
+	}
+
+	/* See folio_try_share_anon_rmap(): clear PTE first. */
+	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, subpage)) {
+		folio_put_swap(folio, subpage);
+		return false;
+	}
+
+	mm_prepare_for_swap_entries(mm);
+	dec_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter(mm, MM_SWAPENTS);
+	set_swp_pte_at(mm, address, ptep, entry, pteval, anon_exclusive);
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2121,7 +2179,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	bool anon_exclusive, ret = true;
+	bool ret = true;
 	pte_t pteval;
 	struct page *subpage;
 	struct mmu_notifier_range range;
@@ -2235,8 +2293,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		anon_exclusive = folio_test_anon(folio) &&
-				 PageAnonExclusive(subpage);
 
 		if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
@@ -2295,8 +2351,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = page_swap_entry(subpage);
-			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
@@ -2317,47 +2371,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto finish_unmap;
 			}
 
-			if (folio_dup_swap(folio, subpage) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-
-			/*
-			 * arch_unmap_one() is expected to be a NOP on
-			 * architectures where we could have PFN swap PTEs,
-			 * so we'll not check/care.
-			 */
-			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap(folio, subpage);
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-
-			/* See folio_try_share_anon_rmap(): clear PTE first. */
-			if (anon_exclusive &&
-			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				folio_put_swap(folio, subpage);
+			if (!ttu_anon_swapbacked_folio(vma, folio, subpage, address,
+						pvmw.pte, pteval)) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
-			mm_prepare_for_swap_entries(mm);
-			dec_mm_counter(mm, MM_ANONPAGES);
-			inc_mm_counter(mm, MM_SWAPENTS);
-			swp_pte = swp_entry_to_pte(entry);
-			if (anon_exclusive)
-				swp_pte = pte_swp_mkexclusive(swp_pte);
-			if (likely(pte_present(pteval))) {
-				if (pte_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			}
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			goto finish_unmap;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
-- 
2.43.0


