Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CFF7C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1E26B00A6; Mon, 14 Sep 2026 08:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653606B00A7; Mon, 14 Sep 2026 08:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594526B00A9; Mon, 14 Sep 2026 08:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 322486B00A6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2D701C2359
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:29 +0000 (UTC)
X-FDA: 85212303498.20.8F80A0A
Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id BBF8920015
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z5GhJrBL;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DvdwuXmnrij3AhWASYk7KfEwJQYZzcV8qjJX7HOE8o=;
	b=oYiWne3Z0u2VOKbT/uUe1F7QaXSDClLB41uJdIGCMdQDgFoKl+ly33H+5paGRqfMWX1CJW
	RuniPFu7WRghnwgBzwgMUrz9zCPLrQXe6hRuqNEpiyhSVJOb55vwhE+sEn5k5Z5a7+5Nvb
	jmzENCydNDxtmoe1V+PMajplwha+emo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389088;
	b=4LBdn471Nh9gAKK1G0jPR2GQZyPILsOL5fh+8r0DKf3u5smlYIkrN16z8U1k1/JAj6zJXW
	Vu41E8BRELLhbncKCyhj11qxblDAnxm9D9+ZfMog5q2hkXqvZLp0LSMCn+DPrw7TM/NV8F
	ANCivWRBZG8DutTqcmbrvxY7K08ul18=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z5GhJrBL;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q7Vo+oMZWSnoi9kpct14wrtvWt95QszpUVVNkFyr/6c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389086; v=1; x=1789993886;
 b=Z5GhJrBLiU2mFJd2D90uchgd529Y/fai1OvFUV9kqOBTIdFvKQ0Q6ePS/l9kPiszDgm6pNsb
 8DvDCL7/SaRToSr+wmIf4qNysI19355EWN4HBhqZiJyPz/YplWoUDECQmwCxOWMporw7/UMe3cI
 d/6uRIU5A+MsstqisGYQ1IjY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 56156af8bd9f1fa3;
	Mon, 14 Sep 2026 12:31:26 +0000
X-Mizu-Trace-ID: 56156af8bd9f1fa3
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
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 11/29] mm: split PMD swap entries into PTE swap entries
Date: Mon, 14 Sep 2026 05:28:01 -0700
Message-ID: <20260914122950.3283997-12-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bhs9eay8ppomnipzxkq8rsqxsk5dsfhc
X-Rspam-User: 
X-Rspamd-Queue-Id: BBF8920015
X-Rspamd-Server: rspam03
X-HE-Tag: 1789389087-343624
X-HE-Meta: U2FsdGVkX1+PEFO8ye4zBtRMFGNi/UJSjfsFk2hkojv+k80pagoZXoZikzgGQRIr0FeHti8af2Q7VJO6e8E+3M2yLtKJ6zuNY+DH4nhSR0tc5K53qdzCKoYEJVtBedpQMMhXLdAp2Ai658tZwoxNwBolXxEhYxzIgvh6l/JpG/YfXv/9AnvSgJrTq7A6RRayVjQwYwMkyGv2gcqrHuDeiincLO57Zno7xBws0uBXO4Mdo8pv4Ei8CdKS7gdwEYIMkeFeHdwAHTVXJZgB5hH2zWhxtC5+qd8YZmXJkx+Eh5vKddVpPY6Zq8TmaURlEWBrg+MG5wjJMRMsnOtFpzReZpa/JlMfUGn6hb2hV0yzwvbyL84vC62CzxW26OgTSHNSDIOpNrW47wCdWm0974JPHEjw3dc3vKD0wYfe+50RTyVeyQhoHqWZlNS6P0DMAoXeE5vo3DU6Y24sjAR1CMAx5ueTkyxXF+Ng3h5rf9rt36o9QxPdoXYx3AQr5ygXtyGHdh9vI9GACk71bcpB82+ZM/c0gg935+JUXPUIdqKRlQkFGuTOf12w9i+hIyhL03DidwOihrsGNoQCv+A28MWtvbuILGRbczej4leqs/AkAUvb+KscivuMcNJxidN+Yh9Rzc7Xz3QURqKhD8HPdeLvBo6xuVQxrX1qMnW5XWh7kRNEe8FrcNLHgPVExcWiEGE5Dai5o/3MJqN4GEI0TBLgc0nI5GL0W2ojzZEAZpJ/tKtVX/8JNQXf8cXh0B7HTSmEghcrxpG7i+Q7rKfqT0sFP7yZUFonSh7zup6p5wIvE3+uhbcOnnIbCOXOdgCQUs9PC1wZY7QE5APrvqRxYj+5W8gryxkwgIYJKRMvX5aMuILaIpwSGr5wD8cP5ZfjwRGHWyPsgQGsfSbj8WHO91Ue801u5rMPAmn7/d062I1rKC80OBdDgM6Q+gpcjhD0WUGmHrShGRRWzNJWJZuDW6r
 dz28wOOf
 X7tPMb8orYVs8ZujWWFcAmpMpXPf85Xxf8QazPoeHurZo4Hb3JxH4YdTg93xIoV15JbYSURZ0FquDGtrBCk2fPWzuQBPyhlpw7DFPlQJk0TmJgYBWo7dzntPveNYpyPqbkf95xZsduivlMwqlP/C5vjNQLBx8pyq5BmBmUD37RVBnuWMe9Kdr3uBNBZqNDs6AGb1Dloxh58DxAcuNlMM3sRuqS6IBHyuhyNaEvxyFL/FOZ3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once a PMD can hold a swap entry, everything that splits a PMD - mprotect()
or munmap() over part of the range, MADV_FREE, a pagewalk with no PMD
handler - has to be able to split that entry too, or the callers that rely
on split_huge_pmd() to hand them a PTE table would find the PMD unchanged.

No reference counting is needed: a swap entry pins no folio, and swap_map
is already one per slot, so the PTEs simply take over what the PMD held.

The migration-only entry point cannot reach the new branch, because
page_vma_mapped_walk() never hands back a swap PMD for the folio being
migrated. Warn if that ever changes, and force the regular split anyway,
since the branch leaves folio and page uninitialised.

Test the pre-split old_pmd rather than re-reading *pmd in the trailing
folio_remove_rmap_pmd() gate, so every entry-type test in the function
interrogates the same snapshot. That part is cosmetic: pmdp_invalidate()
leaves the PMD present as far as software is concerned.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 873887aed0bc2..0e347a545588c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3304,6 +3304,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
 						 vma, haddr, rmap_flags);
 		}
+	} else if (pmd_is_swap_entry(*pmd)) {
+		/*
+		 * A PMD swap entry has no page, so it cannot be turned into
+		 * PTE migration entries.  page_vma_mapped_walk() never hands
+		 * one back for the folio being migrated, so this should not
+		 * happen; warn, but also force the regular split so that a
+		 * broken invariant cannot make the code below dereference the
+		 * uninitialised folio and page.
+		 */
+		VM_WARN_ON_ONCE(use_migration_entries);
+		use_migration_entries = false;
+		old_pmd = *pmd;
+		soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		uffd_wp = pmd_swp_uffd(old_pmd);
+		anon_exclusive = pmd_swp_exclusive(old_pmd);
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3440,6 +3455,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
+	} else if (pmd_is_swap_entry(old_pmd)) {
+		const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
+		pte_t pte_swp_entry;
+		swp_entry_t entry;
+
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR;
+		     i++, addr += PAGE_SIZE) {
+			entry = swp_entry(swp_type(old_entry),
+					  swp_offset(old_entry) + i);
+			pte_swp_entry = swp_entry_to_pte(entry);
+			if (soft_dirty)
+				pte_swp_entry = pte_swp_mksoft_dirty(pte_swp_entry);
+			if (uffd_wp)
+				pte_swp_entry = pte_swp_mkuffd(pte_swp_entry);
+			if (anon_exclusive)
+				pte_swp_entry = pte_swp_mkexclusive(pte_swp_entry);
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, pte_swp_entry);
+		}
 	} else {
 		pte_t entry;
 
@@ -3467,7 +3501,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(*pmd))
+	if (!pmd_is_migration_entry(old_pmd) && !pmd_is_swap_entry(old_pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (use_migration_entries)
 		put_page(page);
-- 
2.53.0-Meta


