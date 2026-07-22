Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73B5CC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C646B00B6; Wed, 22 Jul 2026 11:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735176B00B8; Wed, 22 Jul 2026 11:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622FB6B00B9; Wed, 22 Jul 2026 11:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 428696B00B6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:21:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAEB1120217
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:12 +0000 (UTC)
X-FDA: 85016775984.06.AA78540
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id EAA654000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ub0asZ7i;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYmQXFRqmB3+HrRfWPLCBmtO0rLtvR3QFdlIkLz0Dt0=;
	b=LDWKywuz/FYFEIgXVwv1jRZvapvAjii2k4Vf0u5e+PnktoMjy8F4VeJ86lEurQ3Q8GaezH
	5ap9KduCPMFTXZEl5QuTiJPZovU43EkUtg9nvrP+oXgm44KSZFhrvBlLuKelaK+sF5bpRZ
	cX4h/ZUbxuGIheU3wpfZFuMPOXaFcmI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ub0asZ7i;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733671;
	b=AZy1BCR2AtrF5WKA0aDxCl+CsLwTQq5E6rnkLimsihcb6d8uWJK3uFH63INZ1Wmv4Uj7g7
	jdWVD21PMqwV9r/aF8mgJjKrckgSoKpPn5o/dU5aT/UlI1b7sNyA92rIOt2eHPWXQfpiCC
	zNjEsUlFyLz1mV+DwTnpoFhBLF/2NEA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vYmQXFRqmB3+HrRfWPLCBmtO0rLtvR3QFdlIkLz0Dt0=;
	b=ub0asZ7iNuT40Hgp3crtxIeik0BLX2fWE84tzURrwqV3NneVJBVohNOSMEX++oc+wmEOmX
	uK22YjLAInYHsQTSrwnrz3xEdG1SUdq+JzQ2DSTxqJDkngq6LONumIZNjoHTIlca/0jrNP
	wr1F97KxoydDEIcc1uK6sd1vEzPlyo8=
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
Subject: [PATCH v5 02/11] mm: add PMD swap entry splitting support
Date: Wed, 22 Jul 2026 08:19:33 -0700
Message-ID: <20260722152043.2273289-3-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: EAA654000D
X-Rspamd-Server: rspam01
X-Stat-Signature: mk5hh9bf94f3zeum8rqu1eqf93z4t3hk
X-HE-Tag: 1784733670-361056
X-HE-Meta: U2FsdGVkX19L0tVcPbbIYbNt75xBTzlOIVS1CLeNTeV5HKYQYt6wwnh07mE4WEg4c3va9EhXE/DQ6Hm3DB6Hn9RsejpouXYE18LIc16l85JsnrBrgMdFhvKpgBl7IWUrmJwZl1Ai74Efmeya22bcxoeh67H8wjC2D44inPVlECSV4yMlXW3TQdX+V3YzmOOJbgKmQlwSaXUBGeYzCVbFb+xiX3VE9x2Qjb26LtMiVrIlvQNlyBkxQZHoFeyzhBKaGe72uN8mJ5EhabsqxsjM1Ukn0/DBJR/9XtOUCnnSZfnfrJmVhQr2CLUKYyQg2kwrd3E/m4S9C0nWD9DrLyO5NZAbsaFomCHt+IR33vMBq7XEu7QAYT1v1+yTGaj88RZpMJbNVnFjbWzZ3JMY3PA9gLj5pbY9I4TuNTjFxGYgg8hqAvwQN5esKTks4ysi00tbhn8W5ULX5RAj4PuQe9RuOzy7R7TuPOP35ZXtiBEuS2Juto/PzNQxN0/GjoQWMl0x1/Ey5iZcHTeD9JotrKgm2E98COQcIqICo+tT/7OMTWYSn+DNRf5UVMHSqHsfKxosXeoRw+JAwpy65Fd2AyZs78E/tbNnakX7toII9CAMXrIMtGo2AeSSUjR6dlghIHlZHhogiOCX4KcKw1nWlpByxfqRS/d8e/q2KEN0VHvIy4EisZ8/ytoRwmEeDFcXDGK101oEuzOTDotR/e/iEpJj/BPOLokXDCelVocZAtTSH7RQ6AsbdYcHWgLYa3ZCsljz15ldy/nH7fFflOivzKiGILHFHp0xr5jj/E93XwkBRI2KkGGR0IXDxKTMZTiqfFZj8Zodw3rDhcaoD3wenowOvZE7kakLberv5TUlWXsPGnnxpEfpaEwZLev3cENDn09c9q6q2KtkPt6Ltwxu6AOJ0WuL10IlBxtQHdijdicWuevYfK0M1V4Xza3Zuhh+UXONJZSwe/tfziPF5eeBmp3
 rEhMq27m
 UD+SQqsrbDmwvk3EmRyf8IuNvCtMb5Ul2Ym/OxLzf1/4iQ3zGuALpmQ29Dwt4NGSwX8Myzvzdm4V+oP+2zo20iTlxm1clr0m6KyAxS0BtEltS1mZQphfv6dFEsnPriVpREGcCWPbapwumWU681AA2Or0UunG75ElCIJ3fDiX2YjGIPqsGNrdRgR2pZwqy1byTrCZCsYEbQju+n/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a swap branch in __split_huge_pmd_locked() that splits a PMD swap
entry into 512 PTE swap entries.  Unlike migration splits, no folio
reference is needed because swap entries point to swap slots, not
pages.  Each PTE inherits the correct sub-slot offset and preserves
soft_dirty, uffd_wp, and exclusive flags.

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
index 04e8a6b55343..9819c0ae228a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3210,6 +3210,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3346,6 +3354,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
 
@@ -3373,7 +3400,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(*pmd))
+	if (!pmd_is_migration_entry(old_pmd) && !pmd_is_swap_entry(old_pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
-- 
2.53.0-Meta


