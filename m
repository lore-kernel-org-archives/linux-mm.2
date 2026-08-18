Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E221C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA606B019C; Tue, 18 Aug 2026 09:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B5A6B019D; Tue, 18 Aug 2026 09:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515A26B019E; Tue, 18 Aug 2026 09:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 285FA6B019C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC017A110F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:24 +0000 (UTC)
X-FDA: 85114429008.28.04E0799
Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	by imf18.hostedemail.com (Postfix) with ESMTP id B95E81C0013
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ePR1CsFS;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058743;
	b=62TlskqNQR/X5Y6OfRegeiQG9RroSmfVnbYs/e1wVdOiOZunx5exKjpsxgBHPJDXoEpssB
	aAf0j6Tf+lY6Qnn9bGJQy/3Fz6TgfPdCb2eSVjaPMYM7T6qQGkXdRAaAy7yRnICg3ye7da
	vTy4vktfwACj7xaRKBun7b22BhKRLDs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ePR1CsFS;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTiqSurwJpM8yj9zXglpny3E2tJwQ8ok3T+yaHWXpmU=;
	b=3Evcd0C6jHmWkx4GWjuAxUIAnG3EtKLw+4PFUAYlFP4PCOSdxaC/3YHBalhcTfh7xW1dSS
	Gq66VxImvk9NN/D0TFB5v1e6bOQuWtX+qdpqzGQWrFZqxUb86aof42C/ZX1ml8CGvXkoT1
	9AxeNkkwddubKKkD1hGG9XXPFzq5cEY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1Dz5t2k/qHsfuuzKgM9VwuvNQXNi7pjePtn1+ZkgY2I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058741; v=1; x=1787663541;
 b=ePR1CsFSfhtZnZDwdzp278rbXm8Fa/19ikhEl7qhC9YsSoeftTdy+Lf6sIPvRiKMyN1OB208
 DTU5CEAEzL+MTIT3nlp1lfEVSmD0gQu61fhKKMUP+r7SWZ4IvXz7XZVKBeflgERBPyvmBtrjFYt
 u3wJ9i5U9DwEHpNIK9QKyAXs=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:48::)
	by mta11.migadu.com with ESMTPS id 841d0e040e1652fc;
	Tue, 18 Aug 2026 13:12:21 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 03/12] mm: add PMD swap entry splitting support
Date: Tue, 18 Aug 2026 06:09:44 -0700
Message-ID: <20260818131202.494754-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B95E81C0013
X-Stat-Signature: 98sqetbtmw6pxh8ee9u79ez14a45c9rd
X-HE-Tag: 1787058742-982823
X-HE-Meta: U2FsdGVkX1+QsOJ+PIh8ZA5TbD3U5Ryo4fXfvklY6hcPT+TMf0e06lR22b3ceGmA8aQ1tE6ptLX3vTgqUfJK1nTy6vTc07UgkA1YDR+HF17YNK46iOjOMvglxxmFFs/dt+WIqO4qyXogSlRYZv43RDj5DhQjPST2f43pDc4V2LR7bR46jSbvkEZztRZdH/tYkQMg89J4VPWcajKofK7oh+aRjpH9Wd0PEpurVC5tuYRKIqPyuVCTbe6WkzmWGGCTnHRRPyu//vkCiAAjzomu46g3yymQsTs0P2W8ydo0DQQffT2eTEzeiBleIa9u7P79UJYeOWlRfF9nn2pO/PxS1TI29Iy66/qTrn2CEiqsKyZESQB85LDFHxwR1BPjzquDN6ejKacVTpjg7HAXMPAuRsAF7dQ6UtSNQ93qiSFUcOMMXOxdmabGtJ1Nmx5L2Hc5bb6QrNB2QTLd6KF6XLLUKi0oVZBKnLBnWo/csdAHab/AyFZAblazQlJd/Bjdm1iBiNPB4StJwZNUilLrZUoBehj9wb5rtDp5p1aoN7i++pSEELQ3ezKU+nUHTgtIEOiNvt+PXCSLic/xPHoqGeOzpT6smSK6kLhagJtGr4T6qmIlgB+RYUSRSgavQ0ajaqiOMK5VIkmDts5AiCYCvfxowONBP55Y7Av5dnm1wpmhgEZy1kMvkDATv8L9EBX4znkN4IQfnXYqpCHqj/0iVVrIXDMZ79f68DB5VWMRgJ5MmZ/KdcCZu7lZ90cLc+jFZAHhSwUmcGVejyzAzqpFBrX8iaj3lG8m2pFK1aTtyC7uwfMeFdGMYS8R/x8q/8jW0HmmpSzUGxS7woTyE8uVWgkaYabTneICvxCpzWauPBtdAZImslaFgqTS+FN8DDW5Y/M1GQ6PlFwTDV7HMBtAOoA6cx5C1aLjfbQJmQIyIswkEvtQA5nl7rE09R3e+PTYlBi+sHoWRfZ1H+IOhvS8kXe
 NQcuBJm5
 qSgIygZfLl1mLLfrDq5RORfZMG9vqJ9thWmn4itLJZsNmzPSo0wTdkyHO5Pna+qmS5Y7begpLBU/yMDYqOV0fKqRwAfp3+s5jE1aLrCZWG2S35OTZ3GXLVlhoj8HidFLSZtmhZGGSQhBG1/gtDh98fYQoCrj0dEgTDVIKHiP9SOXr7mXqI1ws4BhZhNUA8YgPhGvq+VCl1gHiNI1nF6EMj8bYhWk00ra2K+b8Ntnc8OlPd1eUDdkw9T2Dg78wsKwreAzjw6PGnPmGsQSZ+Z8Gi9r1Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a swap branch in __split_huge_pmd_locked() that splits a PMD swap
entry into 512 PTE swap entries. No folio reference is needed because
swap entries point to swap slots rather than pages. Each PTE inherits
the correct sub-slot offset and preserves soft_dirty, uffd_wp, and
exclusive flags.

The folio_remove_rmap_pmd() gate at the end must inspect old_pmd
rather than *pmd: for a present THP split, *pmd has already been
cleared by pmdp_invalidate(), and that invalidated bit pattern can
decode as a plausible swap entry.

This branch is reached from the explicit __split_huge_pmd() callers
that hit a non-present PMD: partial-range mprotect / munmap, the
wp_huge_pmd() PMD-COW fallback, and the swap-in / swapoff fallbacks
added in later patches when the cached folio is no longer PMD-sized.
page_vma_mapped_walk() does not iterate PMD swap entries, so
try_to_unmap_one() and try_to_migrate_one() do not reach this branch
and freeze=true cannot occur in this branch today.  page and folio
are therefore left uninitialized in the swap branch; a
VM_WARN_ON_ONCE(freeze) catches any future caller that breaks this
invariant before the freeze path dereferences page_to_pfn(page + i)
or put_page(page).

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b6b0aa2baa3b..a473e85d30f51 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3252,6 +3252,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
 						 vma, haddr, rmap_flags);
 		}
+	} else if (pmd_is_swap_entry(*pmd)) {
+		VM_WARN_ON_ONCE(freeze);
+		/* Swap entries have no page for the migration freeze path. */
+		freeze = false;
+		old_pmd = *pmd;
+		soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		uffd_wp = pmd_swp_uffd(old_pmd);
+		anon_exclusive = pmd_swp_exclusive(old_pmd);
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3388,6 +3396,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
+	} else if (pmd_is_swap_entry(old_pmd)) {
+		softleaf_t sl_entry = softleaf_from_pmd(old_pmd);
+		pte_t swp_pte;
+		swp_entry_t sub_entry;
+
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR;
+		     i++, addr += PAGE_SIZE) {
+			sub_entry = swp_entry(swp_type(sl_entry),
+					      swp_offset(sl_entry) + i);
+			swp_pte = swp_entry_to_pte(sub_entry);
+			if (soft_dirty)
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (uffd_wp)
+				swp_pte = pte_swp_mkuffd(swp_pte);
+			if (anon_exclusive)
+				swp_pte = pte_swp_mkexclusive(swp_pte);
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, swp_pte);
+		}
 	} else {
 		pte_t entry;
 
@@ -3415,7 +3442,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(*pmd))
+	if (!pmd_is_migration_entry(old_pmd) && !pmd_is_swap_entry(old_pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
-- 
2.53.0-Meta


