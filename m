Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22027C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFE66B0098; Thu, 24 Sep 2026 09:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397206B0099; Thu, 24 Sep 2026 09:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2865D6B009B; Thu, 24 Sep 2026 09:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F341B6B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:12:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BDF814033B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:12:07 +0000 (UTC)
X-FDA: 85248693894.27.8030CD4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7B5318000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:12:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cfo1n7cK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nL7pu8RqTUsFs3IQuHT027+8Fz9qYbULyNwk8hHiXZ4=;
	b=2H3Ku7DYals/xPcWyWSyjgrZmWdPcKeEohbWj/TncPCzILPAr87Ckrw6WPY94MomSIRScK
	en59BiXbqHfNLx/E3zbqdGrOxJJEvYJrTT/Ee7/mJ2WA3iVmvft/f7YqintXZaPqpfqCdf
	loZ7cJGwdL01h7TyLs5Ov4W2oodiUfE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cfo1n7cK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255525;
	b=XT4ogU6wPFR2AL6xuXys7AFHKKrEybfiWvcwhrO+bmu/OQyTjjlrRjgPvrtdmCUJlU8EPI
	7qbI/dPqhCEYdK7Py+WYs+9cB4vnaCKGjGTwLJay7Q+++IaieX2C1rMX26tRynAaxv+4Bd
	PdtRI9z4vsQHiPsrO/OJVsAD0Y72T+E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 843B41A25;
	Thu, 24 Sep 2026 06:12:01 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E32D13F86F;
	Thu, 24 Sep 2026 06:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790255525; bh=g7Rf1C/r+3UV9DV7BimkhOjVMuui/avyxCs3Ib9oOag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cfo1n7cKqSBF0J1b7mKA4hCNrsqXwIm1Qrks7/DPrg9wW4WneiyYMlggjNGGcY5bb
	 9py0RdAWMFugivPBGE7o73xWnJ4s+Dgb1tRRt6NeU2m9uIE6O6IY2Wvbfi9OSN4xnZ
	 IYN0VSofbPnDP8Tn90KOQ49+T4AcqGb26KIDc4lQ=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	jgg@ziepe.ca,
	thuth@redhat.com,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 5/9] mm/internal: rename swap offset helpers to softleaf offset
Date: Thu, 24 Sep 2026 13:09:33 +0000
Message-ID: <20260924131106.1730494-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924131106.1730494-1-dev.jain@arm.com>
References: <20260924131106.1730494-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nwu1jitszeokfygua9mbszhk1xcfw9o5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C7B5318000B
X-HE-Tag: 1790255525-842860
X-HE-Meta: U2FsdGVkX18j3Ps3MPM0ncZZuwrYFwei97uopTR0cWPNiQnkzI90fm2oJ2+QcXP+hr6bZZFxdQUjIGirn5ZQsHNL75yJlKNpxdO0L2naw6qFc3T8zPoN6Je67n72WMHi3k34Esb8Siqk1puB/RHgi9sq6lIqHMZ4L5T99Lklj4glgm5EGBjN2FYC/lJqMJTMNO5sTnY9MKvXp2IRPsabpNXPJb6bWbD7E6aUNUaWMYGu0i1ME0B7UJB7Ri3cMTTgfdAZZq8afXzGwrDE2ngG4gD4HB8LJFkkjsF1ENSJXZTVK3i3FdlkwOkbQRWeJPVu7kp0ss4wAT08LEN9GR3AGdVkIBgLaVy0KLVA89h0fw+c50uxGSngD3dOkHsk/qdHU8i7EJW8s6WYOX1jtOyzYTYRErzoPFFshmncFTbpfgXM1S2ytxEaO8fsyRF7PqzSDdRTibs3swocCYgV3/TU4DKa0DhbfWA4EAT1SEW3Yft3XDsxUG6pmTytFmPMubgWwstwnewpCbZuxKZMIzrjCpZokEJccl2EONAyQcuB65oCloKtTbvJ0Cby/NghPypQFGTdxLtwtv9sFOC9W5qNw0NJ357/h30sYKeTNoCl70UmJM+6W63DHCIKPxyr3hSPh75IYxgP8z6I2pPm9TMUbbiDli9eL2Lxl49zNsMDF5DeCaqscfbkG2DawbAU4dmhsvGU1D9giGQlyhY+EWgi8+vE+i2KTLH073XtjBQsBGxHcuW9vnaMKqvCPY4a+903cdm3J3NCSHA9r07XCdIPi/aChdln/7lG+dLWLzY9QJl0O1CKx4E9V/5uZiXe9xnwj8uJANreiM+QHSVzj33z8ZriqcKNqymTO91BGpnT3K5P/ySHU7QU8kV8HsIkHu3UvB86ldhzpkA6hB3/RoBGkf5oh83KB7qpZMM77n/mZaRjptfdM8aGVDDE85W9tj9/syA5KM36fbDS2mOLavD
 UOCFSZbg
 376mzV0nutxGOrqmvoWorL3FgmtbbQdZMLYG6yoZxmFy3TAU4XoFiemFtoZImW0OXPc9gVuuhAFFvQ9nLJlOlMoZdZZT9vQi0mvuHmdWQMJ1u1lc2CDYeDplVGXWYNtFk61VDSUixQ/RZCIXwdlFUSKCgHla84v2/m3aQQ20OfnYVzXI9S8p1rMPlxlqj3QLtb6EtZ8Tbw/4cJjrxFwvDqShkH8UtJa1Vh4cUcw//PfmH416d2PUuCYUgoqcRW0JovNhaXUbrVxa7MxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for adding a helper to set softleaf PTEs in one go,
generalize the helpers that advance a swap-entry offset so they operate
on softleaf entries.

Softleaf entries use the same type/offset layout as swap entries, so
advancing the offset works for swap softleaves and PFN-bearing
softleaves. Preserve soft-dirty and uffd bits across the move. The
swap-exclusive bit is meaningful only for swap softleaves, so guard that
preservation with softleaf_is_swap().

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h | 31 ++++++++++++++++---------------
 mm/memory.c   |  4 ++--
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 3b9fdb826162d..b8ec379b90bb0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -469,16 +469,16 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 		unsigned int max_nr);
 
 /**
- * pte_move_swp_offset - Move the swap entry offset field of a swap pte
- *	 forward or backward by delta
- * @pte: The initial pte state; must be a swap entry
+ * pte_move_softleaf_offset - Move the softleaf entry offset field of a
+ * softleaf pte forward or backward by delta
+ * @pte: The initial pte state; must be a softleaf entry
  * @delta: The direction and the offset we are moving; forward if delta
  *	 is positive; backward if delta is negative
  *
- * Moves the swap offset, while maintaining all other fields, including
- * swap type, and any swp pte bits. The resulting pte is returned.
+ * Moves the softleaf offset, while maintaining all other fields, including
+ * softleaf type, and any softleaf pte bits. The resulting pte is returned.
  */
-static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
+static inline pte_t pte_move_softleaf_offset(pte_t pte, long delta)
 {
 	const softleaf_t entry = softleaf_from_pte(pte);
 	pte_t new = __swp_entry_to_pte(__swp_entry(swp_type(entry),
@@ -486,7 +486,7 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 
 	if (pte_swp_soft_dirty(pte))
 		new = pte_swp_mksoft_dirty(new);
-	if (pte_swp_exclusive(pte))
+	if (softleaf_is_swap(entry) && pte_swp_exclusive(pte))
 		new = pte_swp_mkexclusive(new);
 	if (pte_swp_uffd(pte))
 		new = pte_swp_mkuffd(new);
@@ -496,15 +496,16 @@ static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 
 
 /**
- * pte_next_swp_offset - Increment the swap entry offset field of a swap pte.
- * @pte: The initial pte state; must be a swap entry.
+ * pte_next_softleaf_offset - Increment the softleaf entry offset field of a
+ * non-present pte.
+ * @pte: The initial pte state; must be a softleaf entry.
  *
- * Increments the swap offset, while maintaining all other fields, including
- * swap type, and any swp pte bits. The resulting pte is returned.
+ * Increments the softleaf offset, while maintaining all other fields, including
+ * softleaf type, and any softleaf pte bits. The resulting pte is returned.
  */
-static inline pte_t pte_next_swp_offset(pte_t pte)
+static inline pte_t pte_next_softleaf_offset(pte_t pte)
 {
-	return pte_move_swp_offset(pte, 1);
+	return pte_move_softleaf_offset(pte, 1);
 }
 
 /**
@@ -524,7 +525,7 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
  */
 static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
-	pte_t expected_pte = pte_next_swp_offset(pte);
+	pte_t expected_pte = pte_next_softleaf_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
 	pte_t *ptep = start_ptep + 1;
 
@@ -536,7 +537,7 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 
 		if (!pte_same(pte, expected_pte))
 			break;
-		expected_pte = pte_next_swp_offset(expected_pte);
+		expected_pte = pte_next_softleaf_offset(expected_pte);
 		ptep++;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index a7e979bfc814b..60fd0a08b35f5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4816,7 +4816,7 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
 	idx = (vmf->address - addr) / PAGE_SIZE;
 	pte = ptep_get(ptep);
 
-	if (!pte_same(pte, pte_move_swp_offset(vmf->orig_pte, -idx)))
+	if (!pte_same(pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)))
 		return false;
 	/*
 	 * swap_read_folio() can't handle the case a large folio is hybridly
@@ -5131,7 +5131,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 		folio_ptep = vmf->pte - idx;
 		folio_pte = ptep_get(folio_ptep);
-		if (!pte_same(folio_pte, pte_move_swp_offset(vmf->orig_pte, -idx)) ||
+		if (!pte_same(folio_pte, pte_move_softleaf_offset(vmf->orig_pte, -idx)) ||
 		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
 			goto check_folio;
 
-- 
2.43.0


