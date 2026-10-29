Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920D360A2604
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2acdNnV
Received: by kanga.kvack.org (Postfix)
	id AD1656B05CE; Thu, 29 Oct 2026 16:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82BE6B05CF; Thu, 29 Oct 2026 16:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998746B05D0; Thu, 29 Oct 2026 16:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B03B6B05CE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:37:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10E25A808C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:37:58 +0000 (UTC)
X-FDA: 85376825436.08.290F777
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 59C06140009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:37:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2acdNnV;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tztEcWM4A0N7b+6teiPYZ27u+mDO7RxR1zwT2bOzVVo=;
	b=oCh2uJhRRFSuz3ISNtrB/UmfMifIUA0dk/NzHkHnRrBW0oTssXChwcI3qGIMW3AeoVlAjG
	kbhwY+SCNHRhZr3rC6bv31p3e0j+h1Ciq7TxR8eV/R1f4S+xvJaHPDhExZnW9RO+vMGtey
	e/TctBAPU3JI25gLVoI6xuKKWPfZlS4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2acdNnV;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306276;
	b=CC7N0juJTGlzzjgSL/aS0bV6a0TnMsn2gXja5kJNYjmiXG2H7Gpgw4Lt7zgQxQvlWW78x/
	mYv3bDMrcYJ8+eSXGrRsas7kSsw/9S92WqK2V5TLbHakp1au1aGxsLbWOBSLZbITdDyo51
	WJ/cBwjc7FRZ2MkaWeLaiB5Z9+hVfQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D05C9605C4;
	Thu, 29 Oct 2026 20:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A358F1F01816;
	Thu, 29 Oct 2026 20:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306275;
	bh=tztEcWM4A0N7b+6teiPYZ27u+mDO7RxR1zwT2bOzVVo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=o2acdNnV4CkuFKbRpEwNEOnOSL9pTT5uHY41RgahtBUOZ7qn8kMmJu1nKIihtbJfl
	 GEjozaA3IsN8l1U69dN2g6SsJAMhpcDzsMmD+nQB7WGSqybBiSHBKE005LMdfadMXD
	 4qAQYfy8Zj/9BXND3KpgaU5qwcaxk+xW7+nuT+B9gVnZpt/ddcdAquZtG3aQaa+Ya/
	 txypaW4mgwQTIX4XYZJzdsRPgQJEL5Sy3NYTNsfIBeIUA9dtjU1zhIS4E4d186vBWt
	 JxAe9i3rjiOBhKdz9CYsah0lxU97FDpI/vbqVULgw1QyIFTGx9Gfz1FxZAqmo1wTHB
	 CaoSm3PuAzuBg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:13 +0100
Subject: [PATCH v2 18/47] mm/khugepaged: check if PTE table is empty in
 try_collapse_pte_mapped_thp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-18-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5636; i=david@kernel.org;
 h=from:subject:message-id; bh=8iTA5/vUtqz9osOYx6RyePWtnzJPnHa6IV6FgiGHX/4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer20r1Knvm/L+wvJF2cwfNQ1TTWy8j7GUzk/p+BGzr
 MAtdv36jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZSv5fhn9HEh0pTZ83dL7hF
 R5Pp5FSha793iwT1xrY0RdxP0nj7/SrDP10F5TMvHH9cEz/WpeiX/1glmpElL0DWv+5iyMVQh9x
 3PAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59C06140009
X-Stat-Signature: 48g6wazxqr98guzuugkmyhrwe93udyf1
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306276-574674
X-HE-Meta: U2FsdGVkX19yBnz7dIG0NQgn+TEttf9JTHNlWnSJt3RSOT2bPsfputu1BiNJV3mDfezzPLy/FS5VDczDlxxcGGBIiI1gkclsfEDspv5qoaljaaje7aEdHl5tlEcg8w6pr6dpLhtKm0t7VU8ZOf8EItcPPTBBjaybbY08hTYz0X2DPtSR6iRU09hx52k6+iOgKF98cMtd4mN7sGyRBzHSW8LD3tZDQfbpujTS4ugiwqvpOn2uv63nYqAjwqQWjXOi2f64tROaxhYjRffkYKrPIfLCWB1nCnCObGTpirZ6ATQWTlOZ/UOkj/htPg0WakYkM/bjvbd2Sfj7B1VBRzDkQxA3gW6ljUzBY+hbmwfxhT8vRgldYp0TYvEdHu3hLGtHnfgYPbom19+gryDSVaslMSZGuFCCCZlKPveopXrZnOLYH/4+sFIRPPF7OHrx/3feVxnlr7+igUlzoWjlLGwD2pMsNoaMMGDrQ/TXbw9KdWxyCL0D5BTuo9btbU8lH0BkIVkYeWgWvzudH4iIhtAUhtcTj1pr4mQ9xwgk23vAzSxHZj1Jb7J06TBRwEi7uYHy/gruWjJjVfXsXHoNCNZI9Y65LO7sFzIl0CKiTBaES5VoQrWp2fTotH/huEeLpQXZQoxPasaXy5en0bff+Tshukq72E57/tMtKW7ubjrciiObQkjqTrDR2fTEzXYsMZ9DPchHkDZXbBtKjiDi5BZlpZDge7ji84/3JVXcxgH6xQ5/nU50OxX4BhoYsaBr+UgyWmdMTGts1KCrQXQRyXe/oAMxawtazI7HvfcOyvqq/GmcyUxl2ng6vqwWyRYLtkzKGgp27SxZlp8iWZYN38zxRi1szSiaCm47jD6JIE8s2yESI7RfmW7uyWQpLflGmJpHJJ4L1TMeXHAnoW0cmmPDg12WeCQT3NfZDYThxaXTgIMMkKpCQVg361xPIsMSKD8tuUmXhIxW9czT9PAgURD
 XizcwTtr
 1r19aRODjGwDLRNzMuUIA0kHpqyOdRZIoAUQkvVE9hIPzjNks0GZMRajMEPuePjqRAHxlgUBUeDs57VryFpJPAUm+MzpJOVPhmG+TzdxS0SvczJreoWaiVh7Uwbe4UXIp9ts4g67lEeF/sa5fOznt+rTGrfDb+Tc6XIT4amx08Bz5UniR6Kl9AAm/LgHASzWR27F/FhkRNbkvxQBFzkkQ8ETcdBvmcaAkERLBDOnUkD42dHuVmjTnzI+zzI8hBUgJdqEneataT1Y9Jve2W+7ozgY3e5hyqCl7f8SshP2DAKwRGDkatADA1qEGv/E4zLI82CmJ9En9YJ+YrWtWAGdaOemD5GWu1wvTdsZ0GKfucrFrkPzIXCmOLOm2rQ430xerg7KVOW1EVhi6RIp+6wdToMahtfynxOw+zG1pd7wTeNr+gt4=
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
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 64 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index dd17c3dae800..4313abf9cfcb 100644
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


