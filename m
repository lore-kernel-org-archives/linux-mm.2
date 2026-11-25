Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11F5E606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jI5dNcyg
Received: by kanga.kvack.org (Postfix)
	id 312C16B0AF7; Wed, 25 Nov 2026 17:34:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA5D6B0AF9; Wed, 25 Nov 2026 17:34:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200716B0AFA; Wed, 25 Nov 2026 17:34:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1A1C6B0AF7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:34:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 618B41A016F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:34:18 +0000 (UTC)
X-FDA: 85475096196.26.5525AFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A4BE640004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:34:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jI5dNcyg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646056;
	b=k66cb4cLPeiCN7bbSkoIvplqMlT+p+lecFU9F5/7Qk7foUkjw6QK/9ka+Nx0Mbje6on5WV
	1o9B5lVsspnheakPl59XZzN1pxrCEnqwR97MgaVuJj/0gc41NJjhRowQ2yEdyVoxYo21AW
	XuoxSrAryzlDryJDdqYHUUyrI0wBt0o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5KTQLxud4MM88RXDo3FqSzAoKZXRdMPuy6ADShQWPo=;
	b=SpA3ALDDLM3hosEcE8Dw1FwF+KDOVHTIa2GPTIOS8A6xUkDK8SJibGBpTfOFTHUuVkUndq
	22M5gWjjftO5cfvdl82AsDJ3DcIA76Vs6TanEmjbtm8LciLJVs5rBjGCt9K5zGTX7WBbH5
	I5e3O4Z/5P9ZNo34ceZEleCfThnNBrA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jI5dNcyg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 420EB62412;
	Wed, 25 Nov 2026 22:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1366B1F000C0;
	Wed, 25 Nov 2026 22:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646055;
	bh=g5KTQLxud4MM88RXDo3FqSzAoKZXRdMPuy6ADShQWPo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jI5dNcygw5JoHLVr+WCQDJKd7cjgATNHsuB047VXIQSwE5Wroaou0wH/Y06E6IWmf
	 2C8yqmvQhouk22jdODytR75khiQ+WYidt1INQOlwmiLiO7Va1wZqNdCDzWXXGnr6ke
	 8xz4ms0wuo7Ahslp5Su/GBkhg/qgHWFgUDgWXlmJGlW9S0gGQJpPgtG1bxdm0pjhcW
	 MVJ62H52VxGvieCjbr8SgQjk3dYZ1tTM18QI+x5G0gKJ0UT8d1IRdlS7BuqKOzMaG2
	 x1O2md1lea8SQSF/54d4BjiDSXMhDQCPiKM6GFk3hI2UJLZztiOxN38Kb15mum01Rl
	 U3EBQoj312yJg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:01 +0100
Subject: [PATCH 03/21] mm/hugetlb: always mark new page cache folios
 migratable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-3-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3980; i=david@kernel.org;
 h=from:subject:message-id; bh=rib6Mtfo04qKbnTXQh7KiSe8aQC79Zys4RDoI0uBy/0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk5TnOi/oVNpx+3aUwfZlJe2+7C4RFkts3KdrLwh6y
 DDLZdaLjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbinMXIMG2NX7nPvVc2M9j7
 Fad17/3Yr/jyP0u/pNv/E9OtxcuvlDD8dyl6myodaaiTtn9mtWj6f5dg1fyDc82qn0/V2RG4/8E
 XZgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4BE640004
X-Stat-Signature: rens1bpfmhdbw9o7nfqb4xsyggkwb7qo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795646056-287177
X-HE-Meta: U2FsdGVkX1+Zvsb9MJjZ0o2CJb+EoQBNFRhPb1KuSAmU4SKAOgfYUAxAfcxoU7Q6maMQLRP9KpIsjl7aIZufa/tIFzOhhQgcWPx+pFmWiS5yf4ArJWnXEP9T5Cq8bt40g4s0JhdMbOxmHHPF/ickGrvgOxthg/sp9Iztrd2YPzRJ1LU6pHXSIY3MAgXRcPLFoS11CPxM9WxZ4YvRj7/OiqoU3tzzKyGkydJsxgeCVWXnK2+ayIDFrZdt1GJKm2mxLxEODV2WrQ3QxLDxjNw8vEIHliJY5NrrJ/gJFU4sqghI2/nTdizMaGe7plER0lKtU4VMsYZQzJuSEhhi5PG/U/abbZTlLtorEWB4MfBwRZ74HsO3IFl2CfBIJlG2APafIZh4ANKC0nnP++vHGcqsNqfTJ7awXp9rc+i+P/0WbKp9nC4j0MTuO7LPItcUVH8b2U7/nrbPeh7wFdIjzYOouN4qhLP/QPAKJsY8/e2dIsefgRtvCVU53V+bxcP4u28+GH61hC3sv+fzfwKx4C1BphtavRqsQx460KDWh+XkGEqBCcGL1Ef5/Js/Eh3w6wLJfBkDyXwLCYsDfBLWQ0oAmfHCa0+JYZUvcYaQ9TMGxQY+x3ysGmUzC/5Gyt4ott2ujz/NrWADbWUTvFK8kmgRw0HPso+YiZAsvHq46hdXwAkURXK8pn0hu7EcRrrEniQ/gRbJ0q98gMCtI0Hj6hf6dUeKbrHPAHyq2B3fCP+mteED/2UxAvHGX/NcjE2X3CMBBvGXIh+8sOWG9QbcJG/S6hrc1r00YK3qFExTzK8/Ip7Fdns0P4IFzqx2j58iZB+FS0PI79bi40g/fEcaw2UCBk79tl9ZrhSISlYAsqeMrNy9kH46mbQfYBiLT9itaMhLbmIBOcz+OYx3mdp6f2iy9mFkVbEE9IGmKb/dMep+G/A/XJHJJo8Ye9m9u5oufdyb94f87ZtKYAqKHPOkASo
 y94fn4mk
 xWrFO4cIgJrCcSoIgGHyWaErJ2UQXudCgFDKGNMThsZVlvu6NLvWYpscLVP9QckoWhQkztqiO86jNY2aqSVTvcetmpX0Isy5/VOl38onzuY5DLk7KqzY5J2X+f0hlprzTKNYqge1Pde5VviJPL+Oxq2GKQTseRBm8fcto3BXxSWFnbpIb2T5xmoUdAGcy6VGKt8ijW/pIETnHA4TbJEZsVhOYl+V0/R4J4LpyMcMyWm5QWE4Od8IJJK+K+/HQdAU0F0Jxx9LuAinwqLCRxfmiy18Uzpqho1IpPwhQJVbXdPFSFqanO0TqUH7oDBMh6l0vM1ELufAh0KEpDzipw9gdxBnqB531RN0S+hpxILDneak0EQYuSRyfQAOxfbmcIT9xpYjTziwHP8VDIyL/suv856+eP+8QzoPvvI3Ad9F2hR/jode1UROp+WNQNQ94ZWDeT6th4y0x6hnswy3EiQV+aTbJNSexuI3BmjkQw2CfBEm0v8PaZwXAeXm3EFlwivwpao+wVqDFcFJJO0c/+3cZag55i+7lYZ4qrDk6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlb_no_page() and hugetlb_mfill_atomic_pte() only set
hugetlb_migratable for a new folio once they installed the PTE.

If they back out after adding the new folio to the page cache, for
example because the PTE changed or is no longer empty, the folio will
stay in the page cache without the migratable flag set.

Later faults will find it as an existing folio and never reset the flag.
Such a folio can never be isolated for migration, which breaks memory
offlining, alloc_contig_range(), longterm pinning and memory failure
handling.

Worse, if the folio is not longterm pinnable, because it resides in
ZONE_MOVABLE or CMA, memfd_pin_folios() and the longterm GUP path retry
forever on -EAGAIN. memfd_pin_folios() cannot even be killed, which will
be fixed independently.

Let's fix it by setting hugetlb folios migratable whenever (1) a new
anon folio gets mapped; or (2) a new folio was added to the page cache,
like hugetlbfs_fallocate() already does.

This has low urgency.

Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d57964914e18a..c67f9bc3fa3bc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5953,12 +5953,11 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 {
 	const bool pagecache_folio = vmf->vma->vm_flags & VM_MAYSHARE;
 	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
-	bool new_folio, new_anon_folio = false;
+	bool folio_locked = true, new_anon_folio = false;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
-	bool folio_locked = true;
 	struct folio *folio;
 	pte_t new_pte;
 
@@ -5978,7 +5977,6 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	 * Use page lock to guard against racing truncation
 	 * before we get page_table_lock.
 	 */
-	new_folio = false;
 	folio = filemap_lock_hugetlb_folio(h, mapping, vmf->pgoff);
 	if (IS_ERR(folio)) {
 		if (!hugetlb_pgoff_valid(mapping, vmf->pgoff, /* partial= */ false))
@@ -6048,7 +6046,6 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 		}
 		folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
-		new_folio = true;
 
 		if (pagecache_folio) {
 			int err = hugetlb_add_to_page_cache(folio, mapping,
@@ -6069,6 +6066,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				goto out;
 			}
 			filemap_invalidate_unlock_shared(mapping);
+			folio_set_hugetlb_migratable(folio);
 		} else {
 			new_anon_folio = true;
 			folio_lock(folio);
@@ -6151,11 +6149,10 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	}
 
 	/*
-	 * Only set hugetlb_migratable in newly allocated pages.  Existing pages
-	 * found in the pagecache may not have hugetlb_migratable if they have
-	 * been isolated for migration.
+	 * We must set hugetlb folios migratable whenever (1) a new anon folio
+	 * gets mapped; or (2) a new folio was added to the pagecache.
 	 */
-	if (new_folio)
+	if (new_anon_folio)
 		folio_set_hugetlb_migratable(folio);
 
 	if (folio_locked)
@@ -6646,6 +6643,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		if (ret)
 			goto out_release_nounlock;
 		folio_in_pagecache = true;
+		folio_set_hugetlb_migratable(folio);
 	}
 
 	ptl = huge_pte_lock(h, dst_mm, dst_pte);
@@ -6694,7 +6692,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
-	if (!is_continue)
+	if (!folio_in_pagecache)
 		folio_set_hugetlb_migratable(folio);
 	if (vm_shared || is_continue)
 		folio_unlock(folio);

-- 
2.56.1


