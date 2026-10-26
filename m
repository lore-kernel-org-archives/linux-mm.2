Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA8A606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PbgM5nER
Received: by kanga.kvack.org (Postfix)
	id C1B976B05CF; Mon, 26 Oct 2026 19:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC256B05D0; Mon, 26 Oct 2026 19:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB486B05D1; Mon, 26 Oct 2026 19:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3566B05CF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:23:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F35641A089A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:23:35 +0000 (UTC)
X-FDA: 85366356390.26.857B7E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D2381A000E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:23:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PbgM5nER;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057014;
	b=3aHtq7rD8vJgFcdWmBcg25+UzOjGOhPWjRMozB6koBfmlnNXQ4pQUjgEPiAHyA0vK6XMP1
	Arg8sTzJHZbTY4EYZ+dkqMOkE3dWRdsYktVImv8BUmtYeAEoIHfKkxMO3a+md0m5QQJidk
	DcojHgyszADSFX/3WvKPf6CAjd2+aYk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PbgM5nER;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ghLBkppx9o1pzNOIkyHYAlxKpBzprLGe09MAo7VESI=;
	b=2wVaozU0qsD8Q6CAMal7aY3yVONKG6Wv0kv44T9P6STDEatU7Y5mGT46K70EjVZoofzJY0
	408pi22DGnF9QGjpEFvKenGNCIcqyBWozxygaC6ys26V3wo6SUy15BQ4L4c0nTx6fBDE9a
	avsMctrxaqunH3XnFwusnEO4SmJjIaM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B530B601F9;
	Mon, 26 Oct 2026 23:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541741F01825;
	Mon, 26 Oct 2026 23:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057013;
	bh=9ghLBkppx9o1pzNOIkyHYAlxKpBzprLGe09MAo7VESI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PbgM5nERw3dhz4H5Dx9e87PKvv2YyQhWlLTY9OxNjtJYEM7nn/ZuhTcjU1MrcHIWN
	 pBgbrO56mec/pIE1fyAZvH7HrvAsbuNqo5qh6M5tzowYd7p3y1G8xKRoQtb8GfBVgM
	 ByI1GHKBu5k+ZDRBHK1UHKKIxpwPSGQjhlfkyBo34U9jhKg8+vy2oMjz62tFqrACPf
	 3wMlXWWaPRJ3wV0jHp9+Dhd/GGIWNfjqPUIJonptqBAEZBWNkQcK5j8U7qWgxJI6xW
	 FgzdNPHCIsrQz00H2YKv8v6WJQt9/0htHvZYhLqRX3YAQDIHHu71V0h2hBW7HuorAG
	 jELF3w+ixIuxQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:38 +0100
Subject: [PATCH 18/46] mm/khugepaged: check if PTE table is empty in
 try_collapse_pte_mapped_thp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-18-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5530; i=david@kernel.org;
 h=from:subject:message-id; bh=EsD8ZlRQvAEJtfiiEkh+iJ41o7HnIWnYdXqeUX1m2uE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/68IKvRf+nzZv6FtVNl2nVTRT+UcG1Jp3v/B73r
 C+ZhcWpHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzE/Tkjw+tLZfx3W3S8Hvkq
 7b+tY61bdOaqpYfRYo//2zaYBpoo+zEyHHsUVaK369iafwXRBzUMmhcGfHm9LM3JXrly+/vCwrh
 6fgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: nmk1atk1hawt1s9ktihag315qiizwos1
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3D2381A000E
X-Rspam-User: 
X-HE-Tag: 1793057014-398277
X-HE-Meta: U2FsdGVkX19/m3sZIioxvotyTSqItznla5vcTu58tTDK8CO4iBg3+1LA3eXIZrkvjK45ZYCh1g3s/AGNTbV9GYG0o6MKW71A7sgdMFoM3ZmZZFMY5Blbaz/ZyvGQvSU/6IqCGJB27GrzX9NwmrGRPt6BsebNoFRZZ61yBSrzdfyvXj6fIlAl7WrjqXX2Nv8e2N+/0B/94U1iaJbiU0iAhRkiMrtwP3htdOADnmYxPbA8z8HKz6XDAafujc4BZYs4gRClQt0MMVsTLzxPBvZEEXRBkSp7Okb6kS3sdU9SpY1SE/gFAm8LetU7BFJHEhvRZ6qp2CuOsLIXCY7vtK0U9bWagbCmjjzCtGs7MmctjK2kk7OmnUslmlvAwwCx9EFXuVGyk1R7rFpupNmTCPxtFHwYHnMm8KbxzxlB7xJKP1Y7qHYwWnpGYIgeVbK6baqhlp/QmI2r5840z04/qJ8SMZdz+UTCu93JlvPsEV34m/GP8HxA5P4HA8GqkXQPj6AhBJbFiOFF+WKwI43k9ViuPTk4QKz0GqSaivQVkf30vNUXB7YA6eXmPoxtlNLJAKBGE+r+0UEcu7qxmkuDuN0OnqGbSI/9isE0VkLWc8KBC/I8HbVmVPh9uhqNL2w84SrgU8H47/wJ64bDQQH6SOINLHT+PgXJwfINj/NxFvygKTWV1As26Le2gFhOg5zGsTcnfEBGKRjP0w7rqIC8ESgEBFZJF8NIY1k9fytBLizb/WpcFMhuXLz8/nHMmj8+Ng9zZfhmvPzdplXLLu52MJhY4vQGoWKEh7y/ONXiZ6QkNNEobDlm7s8p1wa20bGoH+PkoMry753hcuje4WsReJN3enIb8pRGjsNX/Ly7B1h2wuPoKSrhn5v/dB3wlm6wtJr+Ln5bwHnq9bHZmaj+r5znf/mHryFeChuUn3pFNROslaNp2nHxqhWgYJoRR7FZyBjnaUGMX0ZG+lGx7RbOVBw
 eFGdZLMa
 S7dKrpyEtPL3WgvavNnYh2CyE8oNBu0I/QnQxPg0w2q3AwHitBdHCsfUe5QovvYy9vwalFSWLHyg3U9zLZ6yw+kpaPN8YnH8IlfsByD0uCt+QiC6e++3IX/q/6pdAGws59rnPJc63Xam7DAImdbF6fJRry5HLE4W1f3lIjy0pM2yiFWiI0OfA4D8Ip08FeoxH4oe7FzkB7fZgLFtr4tWGzszxLUSw/WMRzv1X8Cb5ftX90xwoNtQfLtETY92fqqS4YW+BiIJJ9xNmKDX8+5WEqku9/UN2P9Pdg8eGPimB0UuS5S8TxGU3ZyNwsSF5NgLpdedzfl+piHABuaZe1n/t7f4f8GUoABcbveGjW3gkCbCAY14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The existing code is rather horrible and already resulted in bugs in the
past: we special-case UFFD inserting anonymous folios by grabbing the PMD
lock early, but ignore any other markers (guard, poison through uffd) that
could have been inserted into the page table in the meantime, effectively
dropping them.

Let's just unify and simplify the locking: try to grab the PMD table
lock and if that fails, flush the TLB, drop the PTE lock, take PT locks in
the right order and check if the page table is still empty.

We still perform the heavy lifting (zapping the folio ptes) under PTE table
lock only.

Include <linux/hugetlb.h> for now, as x86's flush_tlb_range() macro
depends on hugetlb helpers. This dependency needs a separate cleanup.

Both issues this fixes are rather corner cases. Let's not CC stable for
now.

Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 64 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index dd17c3dae8006..4313abf9cfcb9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -10,6 +10,7 @@
 #include <linux/mm_inline.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
+#include <linux/hugetlb.h>
 #include <linux/freezer.h>
 #include <linux/mman.h>
 #include <linux/hashtable.h>
@@ -1832,6 +1833,17 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
 	return SCAN_SUCCEED;
 }
 
+static bool pte_table_empty(pte_t *pte)
+{
+	int i;
+
+	for (i = 0; i < HPAGE_PMD_NR; i++, pte++) {
+		if (!pte_none(ptep_get(pte)))
+			return false;
+	}
+	return true;
+}
+
 static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		bool install_pmd)
 {
@@ -1935,33 +1947,14 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	}
 
 	pte_unmap_unlock(start_pte, ptl);
-	ptl = NULL;
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				haddr, haddr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	notified = true;
 
-	/*
-	 * pmd_lock covers a wider range than ptl, and (if split from mm's
-	 * page_table_lock) ptl nests inside pml. The less time we hold pml,
-	 * the better; but userfaultfd's mfill_atomic_pte() on a private VMA
-	 * inserts a valid as-if-COWed PTE without even looking up page cache.
-	 * So page lock of folio does not protect from it, so we must not drop
-	 * ptl before pgt_pmd is removed, so uffd private needs pml taken now.
-	 */
-	if (userfaultfd_armed(vma) && !(vma->vm_flags & VM_SHARED))
-		pml = pmd_lock(mm, pmd);
-
-	start_pte = pte_offset_map_rw_nolock(mm, pmd, haddr, &pgt_pmd, &ptl);
+	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
 	if (!start_pte)
 		goto abort;
-	if (!pml)
-		spin_lock(ptl);
-	else if (ptl != pml)
-		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-
-	if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd))))
-		goto abort;
 
 	/* step 2: clear page table and adjust rmap */
 	for (i = 0, addr = haddr, pte = start_pte; i < HPAGE_PMD_NR;
@@ -1992,10 +1985,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 
 		nr_batch_ptes = folio_pte_batch(folio, pte, ptent, max_nr_batch_ptes);
 
-		/*
-		 * Must clear entry, or a racing truncate may re-remove it.
-		 * TLB flush can be left until pmdp_collapse_flush() does it.
-		 */
+		/* Must clear entry, or a racing truncate may re-remove it. */
 		ptent = get_and_clear_ptes(mm, addr, pte, nr_batch_ptes);
 		if (pte_dirty(ptent))
 			folio_mark_dirty(folio);
@@ -2003,25 +1993,33 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		nr_mapped_ptes += nr_batch_ptes;
 	}
 
-	if (!pml)
-		spin_unlock(ptl);
-
 	/* step 3: set proper refcount and mm_counters. */
 	if (nr_mapped_ptes) {
 		folio_ref_sub(folio, nr_mapped_ptes);
 		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
 	}
 
-	/* step 4: remove empty page table */
-	if (!pml) {
+	/* step 4: acquire the PMD lock and remove the empty page table */
+	pml = pmd_lockptr(mm, pmd);
+	if (ptl != pml && !spin_trylock(pml)) {
+		/* We must flush before dropping the PTL. */
+		if (nr_mapped_ptes)
+			flush_tlb_range(vma, haddr, end);
+		pte_unmap_unlock(start_pte, ptl);
+		ptl = NULL;
+
 		pml = pmd_lock(mm, pmd);
+		start_pte = pte_offset_map_rw_nolock(mm, pmd, haddr, &pgt_pmd, &ptl);
+		if (!start_pte)
+			goto unlock;
 		if (ptl != pml)
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-		if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd)))) {
-			flush_tlb_mm(mm);
+
+		if (!pte_table_empty(start_pte))
 			goto unlock;
-		}
 	}
+
+	/* This also flushes the zapped folio ptes properly. */
 	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
 	pmdp_get_lockless_sync();
 	pte_unmap_unlock(start_pte, ptl);
@@ -2042,7 +2040,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	goto drop_folio;
 abort:
 	if (nr_mapped_ptes) {
-		flush_tlb_mm(mm);
+		flush_tlb_range(vma, haddr, end);
 		folio_ref_sub(folio, nr_mapped_ptes);
 		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
 	}

-- 
2.43.0


