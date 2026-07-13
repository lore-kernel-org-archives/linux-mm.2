Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C0F6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC846B0098; Mon, 13 Jul 2026 01:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD506B009B; Mon, 13 Jul 2026 01:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BCC6B009D; Mon, 13 Jul 2026 01:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6746B0098
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:01:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB7AB1A0A73
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:27 +0000 (UTC)
X-FDA: 84982555014.22.F67F224
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id C2CBA1C0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DFdwqHfF;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783918886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRaVXeImLxe2NMgnMf0IGNXX6dR5mFynu54x4W3YXXQ=;
	b=4wz+9mSNY0P+BAohNQM3jeiMquwXN4qTwCdER8d8yRNcPl6J+IV760i5JnlvdZLAYiXlt7
	8EJn974w6AyMUsd0pY3ewAq31VEpHRWC2nvYDFb3QB0OQwN2plBpb6Mn2iesXBosmGWCfq
	JCxXrFvF7LEWudXeqNTT6ncaL+ITGZs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DFdwqHfF;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783918886;
	b=WxN7un6DeMi56zIttAMG5esmbqtpIZUB+/4ReG/mXvoTSlVRSiLopAnhCKB3UOGT9ArL+k
	fYPt2kUXKO6XsmCTTBI3qudm0zwMeLAmsNAXRdm8KDPNu+Hwpxa24RzR94mcdNqJJ74nXj
	AeN20zAytWWHBn4c9Jx3PkprXHyHeLA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00AE0165C;
	Sun, 12 Jul 2026 22:01:20 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F14C43F93E;
	Sun, 12 Jul 2026 22:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783918884; bh=2tuAypSOUoMtv+0uqE76bfgNGfGZZgqedDGetxR7zmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFdwqHfF5ity3M0SjHqgtJRiKIgc8ppCAzieiQcwDH1vlKJFI7TYBN37Q8C/38lrY
	 4M2teU53an0hvPU3Ryp894f9pUvVV9Ej3PSEHzi51qTq+7uGPKr1MIi0I2dUoeDkzw
	 +F6qXHZiJm7hnBmysf8Zsq4rTxUWEnk5vOHQEVOQ=
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
Subject: [PATCH v3 4/5] mm/rmap: refactor anon folio unmap in try_to_unmap_one
Date: Mon, 13 Jul 2026 05:00:47 +0000
Message-ID: <20260713050050.1017741-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713050050.1017741-1-dev.jain@arm.com>
References: <20260713050050.1017741-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C2CBA1C0004
X-Stat-Signature: cbkt9semgzo37fnrf9i3imxrqk8ephdr
X-HE-Tag: 1783918885-387202
X-HE-Meta: U2FsdGVkX18IptdCPV81GY9uirHVlGVGqmi2yhBdd0V9RrYjPSNHg2zyCiV2HHVMxE2eu1evDCSdR2xUZvryrmPld2U6/9z8HHU8yxUC1WGhe110E9lOc7taRM+u8Tga3RoNevRHWTbj6hxaUMYuWRZuqnjy0mMQJH63MaBTI+SS9ezBTo+HGDR00+FqMAVWTCOn2jzAx0s9DBAdD95bvSej0iB8K4jPBhgxkFY2+GBrOMXOB+k8BGugSjlwyeV5tG1Eep+aL/0bJ1gPunW7Aff2Q4LN4TsMb9Kx+6rtAN0zJTD7zdPz+8CPdi6tTpZVB8a9x1VF316qh6BqcYKnfo0btFW4jZ70AponceS2Z/SOSJ1s0NtdnRadLp/H4zFTOiH/2++iE9ce7Jfbge+RZUeHcw+h8OCHJFFw4j12Qp/CBDjKEHho1XqExnhqZlJhgTbLrNNUrH8UGdYGq30IJRm+t4Vq5Pcf+/RhHE35I33Sr4Q85/M5AMF3vG3llQliPuGEBi+Sbmivenr36E2RSNTJz59YwE2ltGljO8kyWYqiLHAPmq2C1z7JmrAh2FHsCzhtY06S3lJopXKXgNFzHkGytz/EtI+U2KooqFF2MOkkPcRBuRWyaj41flSM7RD8nwA7autkMxXiw16NbqJivNrvjsVygVeV0Q/gbupoyYtgWwcZBdvulQWGwtm42KKtu6+kumD79+WbPMPhw98Q5siChCFLqPhHsa/6UDRKZ229UAO0huPL5mwwZTZNvAe+U66flh+FB7Tu99v9U+Rg8JReklnY7eTLX3Pm+eewYw+PYWbpdgutG41H2Y7fJaeiD5v84Tj1U+GdArELtS+Df4zEjbF71kn5xJjyFlmt04EblhoEUfKFO8fUJsbrSZbQwHq1u3xFV/sa8aFJQd03xREFaFk245fd4Fbv77VfTfrnZcyjFtMcspe/DazpypYQu/tpn27XodnmVSsVUgQ
 eb+KVXN7
 I9nePrdmVBxJ/193bOEBDC9pkfwzPSpw1eLEdWk5Fy9FZEXJHy61SrEkwkGO6bPj8USW9FG6gDXDGFcU3XvPApcomGRkIc+IyVOvODSCwEYkZ2H9YWOASTuukSEG2VBc8zEBasvsY/A3U6WouNUjHQZTmw/RptgHsUy0O/9eX243oEOckvScwX+aoXV8Ssu4SDQoQ4V4fob/tnpvPzD63Kf+hceoeIGGJ3kvyjaipIYZlt0bHZuZxw3LsB3ngc8mO5tpSFZ80GW85nZVR9MYwpQJhd7/KNZw5YeJ2Mikw/ENMpkw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor anonymous swapbacked folio unmap to ttu_anon_swapbacked_folio().
While at it, rename the remaining subpage variables to page; folios have
pages, not subpages.

No functional change intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 115 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 47 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 4465c88ddb77b..2c910d4575981 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2112,6 +2112,66 @@ static bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
 	return true;
 }
 
+static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
+		bool anon_exclusive)
+{
+	pte_t swp_pte = swp_entry_to_pte(entry);
+
+	if (anon_exclusive)
+		swp_pte = pte_swp_mkexclusive(swp_pte);
+
+	if (likely(pte_present(old_pte))) {
+		if (pte_soft_dirty(old_pte))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd(old_pte))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	} else {
+		/* Device-exclusive entry */
+		if (pte_swp_soft_dirty(old_pte))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd(old_pte))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	}
+
+	return swp_pte;
+}
+
+static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page *page, unsigned long address,
+		pte_t *ptep, pte_t pteval)
+{
+	const bool anon_exclusive = folio_test_anon(folio) &&
+				    PageAnonExclusive(page);
+	swp_entry_t entry = page_swap_entry(page);
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (folio_dup_swap(folio, page) < 0)
+		return false;
+
+	/*
+	 * arch_unmap_one() is expected to be a NOP on
+	 * architectures where we could have PFN swap PTEs,
+	 * so we'll not check/care.
+	 */
+	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+		folio_put_swap(folio, page);
+		return false;
+	}
+
+	/* See folio_try_share_anon_rmap(): clear PTE first. */
+	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page)) {
+		folio_put_swap(folio, page);
+		return false;
+	}
+
+	mm_prepare_for_swap_entries(mm);
+	dec_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter(mm, MM_SWAPENTS);
+	set_pte_at(mm, address, ptep,
+		   swp_pte_prepare(entry, pteval, anon_exclusive));
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2120,9 +2180,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	bool anon_exclusive, ret = true;
+	bool ret = true;
 	pte_t pteval;
-	struct page *subpage;
+	struct page *page;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long nr_pages = 1, end_addr;
@@ -2233,9 +2293,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			pfn = softleaf_to_pfn(entry);
 		}
 
-		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		anon_exclusive = folio_test_anon(folio) &&
-				 PageAnonExclusive(subpage);
+		page = folio_page(folio, pfn - folio_pfn(folio));
 
 		if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
@@ -2274,7 +2332,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/* With TTU_HWPOISON, we only expect small folios here. */
 		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
-			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
+			pteval = swp_entry_to_pte(make_hwpoison_entry(page));
 			dec_mm_counter(mm, mm_counter(folio));
 			set_pte_at(mm, address, pvmw.pte, pteval);
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
@@ -2291,8 +2349,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = page_swap_entry(subpage);
-			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
@@ -2313,47 +2369,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
+			if (!ttu_anon_swapbacked_folio(vma, folio, page, address,
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
-				if (pte_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			}
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			goto finish_unmap;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
@@ -2369,7 +2390,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 finish_unmap:
-		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
+		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
-- 
2.43.0


