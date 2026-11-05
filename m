Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D707D606D80F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aM/jix/m
Received: by kanga.kvack.org (Postfix)
	id C135E6B05C8; Thu,  5 Nov 2026 13:41:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC42A6B05C9; Thu,  5 Nov 2026 13:41:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01156B05CA; Thu,  5 Nov 2026 13:41:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFEE6B05C8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00F07A0BE9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:11 +0000 (UTC)
X-FDA: 85401932784.13.3105E25
Received: from mta1.migadu.com (out-145.mta1.migadu.com [95.215.58.145])
	by imf18.hostedemail.com (Postfix) with ESMTP id 031F11C0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aM/jix/m";
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.145 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7Jct9y+6ArpUxCaGk0vmeQH2/k8NYaEq0BCM+Ywj4U=;
	b=nfW2+E6W6nukMiS+7MTDrUb/8gF2g+mqv+0VNCbS9Fxv24YjSjVhHECDa+dD7R58Apmu3X
	YpqbTRDYvuJeR7nUw1WvzGe0aEb4zztBBTD2qy1crThtLJlgSKPjuKhkXlxRURktAbqIW7
	agNRRJ3Ql0S3Pf82rRUfjjIrhpGVWqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904070;
	b=P5/qg4ZPUfmWm4A4fmBSrJzl9NYWUVzfVX0y2MQ97+wRs8LM//Sz43mf9V6Bp3M0htdlT3
	72A3uKqKveVWJASFb3f2JbKrEODxNd+pDbSYWQIc3hWnpEW2pSl6l4Itlx9Cdn5dErMuIQ
	V+Ai2yaiJNZGEiWX04HNef74xrGaXeY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aM/jix/m";
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.145 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lWRNmKDZPAcDKyorsbfNDAYvamSfN3OR0hdfegr8JeU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904068; v=1; x=1794508868;
 b=aM/jix/mAdUYlmRolvqvrTbeasG6ycFiqFQu5yGyzAxe4a1T/jRism3ga8lyM+X+7sWF9HZJ
 gyTSqpxvY31Kl8vhctYaEt3NIpXIGMmQ7H8XO13PIB4kHSrS/c9eT9AklbHJo+mIGBGHfMPGoX+
 rKYYLTCSoCxb2poM3tFGlAU0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c067aed4d3f4d4a2;
	Thu, 05 Nov 2026 18:41:08 +0000
X-Mizu-Trace-ID: c067aed4d3f4d4a2
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 12/32] mm: split PMD swap entries into PTE swap entries
Date: Thu,  5 Nov 2026 10:38:56 -0800
Message-ID: <20261105183940.2236717-13-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aia41j5c3jcr79b8iumfzsg4b3oa51ft
X-Rspamd-Queue-Id: 031F11C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793904069-315655
X-HE-Meta: U2FsdGVkX1/USWd3CiChM+qteULs1y1IV+c6peycQLTXNJH1c4QyFQy4l4z+0HgV/FF+jtRh8HjH7mV5Ez8Q8gOUur1aq9ddZYWCPSOVHDO4mHTORNhplUOt/4kEvyg7ozO5lTLnO1vaWLgyvZAodshl118v96vjtLoj+iB/n8H+/HqxiPoD2ZIClifsYohcMSdMPk5IeYBifindZ4DPVRr5QhkyenjAEFFvOprHmt19peWQmxn8TyuWe9jlC2hJWMOkXQUK99xTrfhBugYrMJC5TmAgJu9joscvsz9mt15Jxda5bJCzrmhUhwbkiAWEajjimE+GCzKoQtFbBpzrhMFYzuMBMGkPb7znkNlLK5F1pLeE8kEcLOKHnsCL7f12UHemyOyctueYpMK3IIICdlNrK+8JHT+2UWZuRD9qf/YfhX1VvJFbgYL6DJ58jQlNzQ+k+rjSTUWFyM7iTk4G0mOap0xP64xSWkKMp65614ndTcku+8AEvk5iMywvHYm98bbH6CdUzvctjMOxJ41NYHrYcwBAihkahLnNyu6pdMBKFEb7k0Qw5dwB+hMJwzNogFAxPHwWcUGMbQlLPp0idv5G1WqclwrmfuQDUDdWx+trndS2dwHQG2kqBJsEhvvOyy6Vm/fpwLvF4ojET7tafdL+TgR0/6XOG2C4Ah+uxwgOAWffHtYe/ay7r5vYVregWOSOg1G7tPcI4KBHfvyKBj4d2yYspdMQ8HhZIRlxwIpmhi9ZEX9Pm2CxeeF0ZbghUx5g6ioQinyq9g5qWu64DdU016Qx9O9faaUKWmZPWQ7OKSYtsGbi1Ui4MdDSy4+mNswIdpJAF5u+8eWM/iHY+Hw2H1QKtBjB0wanitSgJOlYXnC/x5ybVXFDYp9kdMvRrPs+wYRfA0c5/IjCByVH+lHj7FgbXlPtDglrYaKlId95u+Wa5IrhlVoq60GWo40FbQtPaPpSQXjhbF266OT
 qbm/4iLl
 b4JySrpPf1G9BIK2ODDqiQRV2kRVbJ0qiS4VP/S6VKdugCQkFU7nSLwCjbRvO8kAZUAepEbRvvfqdBAOvSbKFJjlj7YHDQBJY3mAlZHSwBCa9V7HiN/EKW5MyO3ZToIIJFC6dIbWabPfvekR/IElK7zeMroP27z3RutCwSsSms2VoAHUDhiZuoK2tQk9bzAGgAua50WLzfeUHV/5wSnVbkrbS/y2GZo0y4NN3SeIOUEphmrR2NX9NUSYvq/TPHwmcvZEZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Once a PMD can hold a swap entry, everything that splits a PMD - mprotect()
or munmap() over part of the range, MADV_FREE, a pagewalk with no PMD
handler - has to be able to split that entry too. A swap PMD already passes
the pmd_is_valid_softleaf() gate, so without this it reaches
__split_huge_pmd_locked() and falls through to the present-PMD path, which
pmdp_invalidate()s it and calls pmd_page() on a non-present entry.

No reference counting is needed: a swap entry pins no folio, and swap_map
is already one per slot, so the PTEs simply take over what the PMD held.

The migration-only entry point cannot reach the new branch:
page_vma_mapped_walk() never hands back a swap PMD, and
__split_huge_pmd_locked() already asserts that to_migration_entries
implies a present or device-private PMD.

Test the pre-split old_pmd rather than re-reading *pmd in the trailing
folio_remove_rmap_pmd() gate, so every entry-type test in the function
interrogates the same snapshot. That part is cosmetic: pmdp_invalidate()
leaves the PMD present as far as software is concerned.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 82a4fa9342672..696813776e45d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3292,6 +3292,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
 						 vma, haddr, rmap_flags);
 		}
+	} else if (pmd_is_swap_entry(*pmd)) {
+		old_pmd = *pmd;
+		soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		uffd_wp = pmd_swp_uffd(old_pmd);
+		anon_exclusive = pmd_swp_exclusive(old_pmd);
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3429,6 +3434,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
+	} else if (pmd_is_swap_entry(old_pmd)) {
+		pte_t entry = softleaf_to_pte(softleaf_from_pmd(old_pmd));
+
+		if (soft_dirty)
+			entry = pte_swp_mksoft_dirty(entry);
+		if (uffd_wp)
+			entry = pte_swp_mkuffd(entry);
+		if (anon_exclusive)
+			entry = pte_swp_mkexclusive(entry);
+
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, entry);
+			entry = pte_next_swp_offset(entry);
+		}
 	} else {
 		pte_t entry;
 
@@ -3456,7 +3476,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(*pmd))
+	if (!pmd_is_migration_entry(old_pmd) && !pmd_is_swap_entry(old_pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (to_migration_entries)
 		put_page(page);
-- 
2.53.0-Meta


