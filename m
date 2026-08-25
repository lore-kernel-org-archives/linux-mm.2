Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DCFC5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 06:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53016B0092; Tue, 25 Aug 2026 02:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29C96B0095; Tue, 25 Aug 2026 02:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3ED76B0096; Tue, 25 Aug 2026 02:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87EC76B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:49:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40789A02BD
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:49:15 +0000 (UTC)
X-FDA: 85138865070.09.34C014B
Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7A9C720006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:49:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HZAIV6r4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787640553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfDBiHJhx/rGo/mS+Hge7byRE9FP22N0o3g+++Gqo+4=;
	b=yIxCnTWT9vTv7vI0bNgoTlwJUGe2hMsfpVLgyLe3uo9ZAG8l060EeODyjuhSXAhkGIGB3l
	7y+kgX+4hyx5TKE32QA4FwAARaMzvhvTRZcRFBs8bTOAlNbDmuVo73PIbqyLIEUrV/JPg5
	GKlAZWUUOb468At4Ir2piVB/TV4uGfU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HZAIV6r4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787640553;
	b=YyNMVLiKONtbRLs6ZONSZMoeh9TElRSx8imk4chu3b+YjpyTpZfI0q4YDZ3+TRpkmwLlvG
	X3Jvp89+IRJHuULWQwqhqbrn/ml5cWMq6nvU8EO9r8MS460GxH9GF6GEPnOT+L4Ddy9j/K
	fDm/yX+s/ikCy6/Fjzq1s90e6Vtekkg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=leFlssTWRx1UcgWYTfrxtqn2gdLNeOhJcAUCtbZrvfk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787640546; v=1; x=1788245346;
 b=HZAIV6r4+YpMCjokhMpK2yp7f008j33lP5mLnema0iFQhUpcdZGqtHRcBn1tM598Pqb+5YjV
 mIWw9Ts5TGIvZrNURrbYK0/lYtw3vs2D+EVKH/Shb87eEkSVnW/Vks23gSGA/8k2mpFEAGEyFnT
 7efi3HjJVE3DJl9Lx69mSE5U=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 47ae94857be340a8;
	Tue, 25 Aug 2026 06:48:56 +0000
X-Mizu-Trace-ID: 47ae94857be340a8
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kirill@shutemov.name
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 18/57] mm/collapse: install the destinations at PTE level
Date: Tue, 25 Aug 2026 14:48:51 +0800
Message-Id: <20260825064851.87309-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260816224609.308019-19-kirill@shutemov.name>
References: <20260816224609.308019-19-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m4ed8tof8naacpr45szas1uusojrxyr6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A9C720006
X-HE-Tag: 1787640551-667199
X-HE-Meta: U2FsdGVkX19NzDxuNuh+tShSo1taAGV1OMsqgolq4rP/3qHHxazLL19lpYdgntmZusCXtTMoqWB6Ol9NhGh89OtrymO8RFCBCZGOi7Cd9BztHVzVUpudz51RS6c3wkLsZpTTRTTzpcdd08iDjBR6CUPtV1x13M68Rmaacj+5sEZoUhBT8GrrdbbeNyZ5MhWIRLWFoKE8TEyKCkHPxHDYnJ0xQUsrhVDGl1j8dqc+r01uRrhINvMrblQVCcO3psIyZF19ijL7GFEd90oPpG5A5T+iGzOLiEPKF3Pgp60LR6GFDXkcaP1YI6zHid1Q5Mv9MWUzpxsIu189kox556ZfHRAbRf44A7a0bUY87sSj9J59eNosWJ0XefqKGd4UPLY/bQURvgw/SXNhtXG+fgGQQW9EVVBdINW6tHucUkEuTFef1hN8GWJ3gr74QF8vlOsmrcnvE07VdGTg/OcWXsBQ8dWBuUOJQ1T7ZMbmtuvctoA0qUSQuUuoeQc0/lLtpBpY7zkABkYhjd5ujTmnDBB74y0TKJ25SsQ3r/sntlTMjG+BqjwZjS5UtrdXHZBNeR0axYpX24rVkDdC1uVbPRvHZzYey62UEpnzi0GqwfSQqzYBm2VQyXlLVKL8QTYTZTeGmPHHqGjd+kfZ0mWR5G/wvGSYs6adUh86fMAskTGOyswrunetVA2WzxxamPkME1JBzeGKV/dKx4OeEbq4wf4kK9zVk2hciIrkiwFxnvAeDgSSx2GZA1j6Pg7SXlM59PKJvW8VtQKDS+w8M9dW0r/LWCikDyeEooGSsdLO9HjlIMZWHVSvcXV08iGMy2Zft3LOi+NLOcwBhkROAQnA7C28NkslA/TENvmfyF9cdb/xSN/pjJGofvZCEFXan5iNpHmpm1Un3OerKjAsH3sKKhxjQBaIfJ1z681mOhAk+ARVFe0kHgl6LqYtX39F+8APLPt3hGfu6eWKy9ruCGEXOoj
 urd10y/F
 8KfPh9fXCHQ047VDK4QxooyRn/lKDJIBCWFlhfS1wr0aIeSJA0wWYCD8bG/4mg3B11LG4wYnISnTpc6IZiPJ23t9EoYPvluOmjrkJqP07LwMdgXev8FoAUP66Ptl0iuXYvWBtI8PpVUjJCOjzsMyOjxY8H6BFDqhR2RlP8dnV2BXwOfgi4AadYQRSkyvbp0AGJQihVM6QdEBNiuML4Zewf3cYkiBc8LGkpRrdy3KIxfRv99zAdni806E7iIniyRlvLhXJ8m59u0Id5c5lGwrhcpFK35ffvspnXTbk8sVKgtGAefIwmnWWDweiEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Aug 16, 2026 at 11:45:30PM +0100, Kiryl Shutsemau wrote:
>From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
[...]
> /* Publish each destination folio in place of the sources it replaces */
> static void collapse_install(struct vm_area_struct *vma,
> 			     struct collapse_control *cc, pmd_t *pmd)
> {
>+	struct mm_struct *mm = vma->vm_mm;
>+	pte_t *pte, *table;
>+	spinlock_t *ptl;
>+	unsigned int i;
>+
>+	if (is_pmd_order(cc->candidates[0].order)) {
>+		/* A PMD candidate fills the slot pool: always alone */
>+		VM_WARN_ON_ONCE(cc->nr_candidates != 1);
>+		collapse_install_pmd(vma, cc, pmd);
>+		return;
>+	}
>+
>+	pte = pte_offset_map_lock(mm, pmd, cc->candidates[0].addr, &ptl);
>+	if (!pte) {
>+		/*
>+		 * Table gone under us (see collapse_abort_candidate() on @pte).
>+		 * Tear down every frozen candidate -- stranding them would leak
>+		 * frozen, locked sources.
>+		 */
>+		for (i = 0; i < cc->nr_candidates; i++) {
>+			struct collapse_candidate *cand = &cc->candidates[i];
>+
>+			if (cand->state != CAND_FROZEN)
>+				continue;
>+
>+			cand->result = SCAN_NO_PTE_TABLE;
>+			collapse_abort_candidate(vma, cand, NULL);
>+		}
>+		return;
>+	}
>+	table = pte - pte_index(cc->candidates[0].addr);
>+
>+	for (i = 0; i < cc->nr_candidates; i++) {
>+		struct collapse_candidate *cand = &cc->candidates[i];
>+		pte_t *cand_pte = table + pte_index(cand->addr);
>+		unsigned int nr_populated;
>+
>+		if (cand->state != CAND_FROZEN)
>+			continue;
>+
>+		if (cand->result != SCAN_SUCCEED) {
>+			/* Machine check during the copy */
>+			collapse_abort_candidate(vma, cand, cand_pte);
>+			continue;
>+		}
>+
>+		/* No destination: the provision pass could not spare one */
>+		if (!cand->new_folio) {
>+			collapse_abort_candidate(vma, cand, cand_pte);
>+			continue;
>+		}
>+
>+		if (!collapse_verify_candidate(cand, cand_pte, &nr_populated)) {
>+			cand->result = SCAN_PTE_NON_PRESENT;
>+			collapse_abort_candidate(vma, cand, cand_pte);
>+			continue;
>+		}
>+
>+		/*
>+		 * The smp_wmb() in __folio_mark_uptodate() orders the copied
>+		 * data before the set_ptes() that publishes it.
>+		 */
>+		__folio_mark_uptodate(cand->new_folio);
>+		map_anon_folio_pte_nopf(cand->new_folio, cand_pte, vma,
>+					cand->addr, /*uffd_wp=*/ false);
>+
>+		/* Slots with no source gain anon memory that no zap accounted */
>+		if (nr_populated)
>+			add_mm_counter(mm, MM_ANONPAGES, nr_populated);

Well ... KSM zero-page accounting gets out of sync here.

Say a saved zero PTE came from KSM. ksm_map_zero_page() has already
bumped global + per-mm counters. ksm_might_unmap_zero_page() uses its|
dirty bit to drop them again later:

#define is_ksm_zero_pte(pte)	(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte))

static inline void ksm_map_zero_page(struct mm_struct *mm)
{
	atomic_long_inc(&ksm_zero_pages);
	atomic_long_inc(&mm->ksm_zero_pages);
}

static inline void ksm_might_unmap_zero_page(struct mm_struct *mm, pte_t pte)
{
	if (is_ksm_zero_pte(pte)) {
		atomic_long_dec(&ksm_zero_pages);
		atomic_long_dec(&mm->ksm_zero_pages);
	}
}

Right, once a candidate reaches install, those counters stay valid only
if collapse_abort_candidate() restores the saved PTE. A successful PTE
install doesn't restore it. Neither does an abort after the slot was
refilled or the PTE table disappeared. Patch #19 has the same
successful-install case in collapse_install_pmd() ...

I was thinking of something like this:

---8<---
diff --git a/mm/collapse.c b/mm/collapse.c
index 7c10888031f7..68b37e706341 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -8,6 +8,7 @@
 #include <linux/highmem.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>	/* x86 flush_tlb_range() uses hstate_vma() */
+#include <linux/ksm.h>
 #include <linux/leafops.h>
 #include <linux/math64.h>
 #include <linux/memcontrol.h>
@@ -1430,6 +1431,8 @@ static void collapse_abort_candidate(struct vm_area_struct *vma,
 		if (is_zero_pfn(pte_pfn(saved))) {
 			if (pte && pte_none(ptep_get(pte + i)))
 				set_pte_at(mm, addr, pte + i, saved);
+			else
+				ksm_might_unmap_zero_page(mm, saved);
 			continue;
 		}

@@ -1499,6 +1502,16 @@ static bool collapse_verify_candidate(struct collapse_candidate *cand,
 	return true;
 }

+static void collapse_unmap_zero_pages(struct mm_struct *mm,
+				      struct collapse_candidate *cand)
+{
+	const unsigned int nr_pages = candidate_nr_pages(cand);
+	unsigned int i;
+
+	for (i = 0; i < nr_pages; i++)
+		ksm_might_unmap_zero_page(mm, cand->saved_ptes[i]);
+}
+
 /*
  * The PMD terminal layer: verify, detach the table, deposit a fresh one and
  * install the leaf, as one atomic section under the pmd lock.  A pmd_none window
@@ -1616,6 +1629,7 @@ static void collapse_install_pmd(struct vm_area_struct *vma,
 	/* Slots with no source gain anon memory that no zap accounted */
 	if (nr_populated)
 		add_mm_counter(mm, MM_ANONPAGES, nr_populated);
+	collapse_unmap_zero_pages(mm, cand);
 	cand->deposit = NULL;
 	cand->new_folio = NULL;	/* ownership: the mapping */
 	cand->state = CAND_INSTALLED;
@@ -1708,6 +1722,7 @@ static void collapse_install(struct vm_area_struct *vma,
 		/* Slots with no source gain anon memory that no zap accounted */
 		if (nr_populated)
 			add_mm_counter(mm, MM_ANONPAGES, nr_populated);
+		collapse_unmap_zero_pages(mm, cand);
 		cand->new_folio = NULL;	/* ownership: the mappings */
 		cand->state = CAND_INSTALLED;
 	}
---

Cheers, Lance

>+		cand->new_folio = NULL;	/* ownership: the mappings */
>+		cand->state = CAND_INSTALLED;
>+	}
>+
>+	pte_unmap_unlock(pte, ptl);
> }
> 
> /*
>-- 
>2.54.0
>
>

