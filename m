Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDB1C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD796B00B7; Fri,  3 Jul 2026 13:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DADC06B00B8; Fri,  3 Jul 2026 13:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB466B00B9; Fri,  3 Jul 2026 13:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E61F6B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CFF5C1614
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:29 +0000 (UTC)
X-FDA: 84948177258.09.C940EBC
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id 46C72C0005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zo7f1ThA;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100367;
	b=atZ57JZ5qEatWK3UsjDhU0URITY21NgiPjRPmUaa7tvzx2sMk8h0lM02dq1iGKzGXvrLcp
	aUsEr/4g0d6O0fVsDYR1QM2wD6ch9R+1k1kGFBIrhy29/tTl3H9vySvMMGU0Crh3DRbr9C
	cV+KxWcKg1/lNWM8UxY/Zud9WY7CLeU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pW9EcWBKiEFzIBYCM/zNKeXrU1lf4J5AtLZufC1tyqQ=;
	b=HaqUbXJHmlyeWb8n8D1j96lN8dsO/Q8pgER6HpA3W72WoiFRcUJ7Ng1ao+Sx1/mGJTldnj
	8p59+b9sHv5IY4wXSHHVjbAK9imKrk459JcTRNwM370lvC6nmjyCJGfmXzs8eLvJ08hcSA
	DQsEF66WQxhEtYS4OMahSrcSDgmfKfc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zo7f1ThA;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pW9EcWBKiEFzIBYCM/zNKeXrU1lf4J5AtLZufC1tyqQ=;
	b=Zo7f1ThAcBbnyAQcXO/+plrAKEWiMXLaHnHmVuh3SXDXEDzJGc//Sy6CgoxXQ+iA19wdg+
	3es40LfRIQipUlY5UXU+OE6aIFzrxbnIBpxGZl0rfwwQ6j7zvrYWyyrP/pmwh5ivfCF38u
	fRXOObVQrj01VAiPzupLfzQvgHqhu5g=
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
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 02/11] mm: add PMD swap entry splitting support
Date: Fri,  3 Jul 2026 10:38:19 -0700
Message-ID: <20260703173903.3789516-3-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8t5do67wnbtisqw543cduhy6kmxk87gg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 46C72C0005
X-HE-Tag: 1783100367-194129
X-HE-Meta: U2FsdGVkX19GJFPuLqi2wYbVVl+aZ84/iljaFyHnPbjrMgbQE2v1eYRgEO3cy14NPAkidy0HQhD+K81p0rp6doc4FPA7gCMQ+JperINP2K3ebPgSYpyX7YmrMiSmYE7S+5zO1rvcdu3LUsNpwP+S/Ar5D8jK+rTpVcw0qmOx0eul3Tii1ejicEejkQONIDeUnkr1Bon6r4w3Gi694G73LRgSX4fn2DOyjv7C6fo1wyBrxw3pZHWDmLJUKGn/Hadud2mo1ejFdeBwk7RduIUpgQj/mExJQ7pxat/wOGTeZSyj3CdVZF1ZIXxSY9PYIpRpCbETyGu6IFJdaFylh/YselVH1hZmeLdp8djgWN9UsyLUiH0ZcY0JGv+CHcyUNkNAddiPJvU5mVkN3a5u27Zk5YBPakQQWE9QYcnShlhbvlcBfDmhXK4CGSHtUCOHC4gp/g8TZ7GLTpWLfgh/6l6Qnbp6lh094EZuJ7J8sG4UbZXZ+4v039w5wJJ7WSKiABXLy/XGez42BqM6Y7fMhAB6yaMCQI3tcfZvCO+lkyMqU6Cp1EOH+TKUF4mHUvWpRIe219vbwPHPV/ASOZ48AkPss44+5R04XWJxQGc6Lquz6IUybi8YZEimjZDRY/dPF0yCO/YZHNKyAFzfzmQad8/cWaV2rOAaIbirQqcL+w3vmh+I8oFfUtvPNcC6RlfWUsmbZrBdhBtrCxPvhxWZ3Unol05VAz1LFKUXcq53CBrBHZwgIEU0fEKsBQ/uxuaL6l2+yf0JZpZxcHM6vY/g0P0McZsZG8nVpcDqUptcTm4O8zrGv5vgV2yE+doXzBG3/PKag05o0OfDVL4z6mAC1h3JUvNW2dlAhLe9eABF7NRCpjauR00ndnHpiBZoXtNCF2HtLnTaAUNNCmSlDUIFcESdzn0s1RoRnx3TcyNKLc6fxQdI99O3Z5NlARx9sDO3fNmfK7kA5T0ZYnYvAMqyUlN
 M87ffbaw
 VlBe4xB2wd9VZerSM4ZLX8La9c/71nOP1/0qydMmg3nTZL3g4e1OuQ+9WR38TEU+BFDu1xm4daXQjqmnPUnsgo2daATJQEkgFlEOlWvwqpzfwf9BhCi2p3Lo/mc0vIeakDjE5yRBLDxRbaHNo5M7xGm/YxBZ6Oo5yX2Ir0VLsTRpEuxaz3ROZuUE1CVynFrjiVP0MCBIMZUhOq5M=
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
 mm/huge_memory.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bdd8635922f9..201193ce0373 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3143,6 +3143,12 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
 						 vma, haddr, rmap_flags);
 		}
+	} else if (pmd_is_swap_entry(*pmd)) {
+		VM_WARN_ON_ONCE(freeze);
+		old_pmd = *pmd;
+		soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+		anon_exclusive = pmd_swp_exclusive(old_pmd);
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3279,6 +3285,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
+				swp_pte = pte_swp_mkuffd_wp(swp_pte);
+			if (anon_exclusive)
+				swp_pte = pte_swp_mkexclusive(swp_pte);
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, swp_pte);
+		}
 	} else {
 		pte_t entry;
 
@@ -3302,7 +3327,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(*pmd))
+	if (!pmd_is_migration_entry(*pmd) && !pmd_is_swap_entry(*pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
-- 
2.53.0-Meta


