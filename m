Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC6A2606A321
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iBtzxhIJ
Received: by kanga.kvack.org (Postfix)
	id C80B26B05D2; Sat, 31 Oct 2026 05:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C311E6B05D3; Sat, 31 Oct 2026 05:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC126B05D4; Sat, 31 Oct 2026 05:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83E036B05D2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:44:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8EE91C42D1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:44:57 +0000 (UTC)
X-FDA: 85382437434.15.A9A468B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2833C120005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:44:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBtzxhIJ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439896;
	b=TOuSVP4Tb0gxYAH2DUtKqCV7po/kZgBsKw7exRLOXbtCGBjP6PCuCMwvgnxyARswJXqqiO
	gfgDjc5gbrMBqDVy8Zp14RzRXhg0GX4sXAnNLXK0EjYTlA6s0y2hXExnFrKhMCAIV5WjbB
	nc4VqEkrZKxxGUFuKKUFCzR/LX0H/Ng=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBtzxhIJ;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNhskX8AAxaa5M1fwAoCqUvge2t9q0zs/kkghFS30Mk=;
	b=loXXGN4MogA21F1KrDHLaZJUak06y6C9oLLmRL2ZtzK3+4yP5rhjWPn52T43d7RYrzVyy/
	e8fGk4CIRas7d6UykAiphr45edKM5aJNeEpdEr087pW1UGYIuVKlI/TOYTjguDwXsq0+dD
	CDMJNZ7Z+KFUoiwGAAPMGjIQpoPV0AI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD4AA600E4;
	Sat, 31 Oct 2026 09:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F1B1F000C1;
	Sat, 31 Oct 2026 09:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439895;
	bh=QNhskX8AAxaa5M1fwAoCqUvge2t9q0zs/kkghFS30Mk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iBtzxhIJ0CsWoL5jGThlLVtJSXfi+Jad6c/A4voYQdFAsTMOdaZi4mA4eSe0oCg2q
	 S+//+VEHuK0a+kG7Uh0zRCV3w4MEipyuoa1zhnUYhGG3J9a3T2BwE1eP6wdYcPsfcI
	 +8nTxbf0i5uqlPb+igx6Hb8Os47pk6uQmxP8WYxw1FYXXSuZQcYRuFQqh0DiBKeuV0
	 Syt0t0ndqaTLZLGsh1BSjcWBuWAqfVm2RfttK6PZxS4mBh1dbHUuyUv2/tLVOt06tI
	 8Wb/MvM2ZMg32waas3hRogrSp0AZqDaPqj/9VHe7hnktu1KBMAk47Y3zfi2LwijIcM
	 68+XyLRvIfitw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:47 +0100
Subject: [PATCH v3 18/47] mm/khugepaged: check if PTE table is empty in
 try_collapse_pte_mapped_thp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-18-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
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
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5693; i=david@kernel.org;
 h=from:subject:message-id; bh=N8E06eBkw92846cTEzxygYjVlauKxWEwZ4cBWEIgU4g=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk/vWGhsU3Fl1vx/nV+sF5XNe8h1fsNMQU2HieGGB
 XyzutwdO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjInTpGht3vN894nPY5eGah
 juQtF96fwtcuWRy5FXSm8uj5zGXXzR8x/HdvW+Rf+nuv1Nm7l0L3/6nufJtccORf6gcPkbTo0M+
 TtvMCAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 2833C120005
X-Stat-Signature: jpbnhjfc5oodmjtpdn6r5baqwgrg3rmm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439896-727156
X-HE-Meta: U2FsdGVkX1+6U6YZ+WHN5Fem1Pt9sKh9+PlLRo+1VonruugBhbt3TAtu+P485YPtAzYQXfDrphwlZ8AalNt8wfESN9p0ukeIbqYEJlqYKzNENKUq/AM+tqD2ZA6Hi/aTVu30izTp6+3JVLJAY9B/XzeMqVR0Vk1swxnTJeEsA0lbMhL58WHBMXoVpI2gYKFhDLqwiRfoWRSZ0tT0hNjiq5Bd+sb1t6PtOueHH55VD673LTzoHt2Ntz3+i7dVoUKp76MJjQ18xUE8CDoj/kcKEgqWerCd8xS6G03stW25CeaNFl6leJO2Xk8Pxd/z9NK7Y1jBQ62oM3+bv7j8NX3K1s8VXZu2ndmmVsDtkIrJLmiYgSBjmQR+fQRwhQevHNOC8VZowz43fmARotw3h0Zt/0fZ+U8QOeU1mepaVM0/sidshU8dNeaeCgyA0kXkedmuNd0U9udOjaV9I8eIjy22CrHf1hZ6qW47cgrLRvUJFx6J0VeFHqsLDZH0lx1rjTq8ezdqpPGQmAuVjrehAjjwCNZrpdq3x+YbuYk5OftCVlZf/ZDDiV93rExeUlqWcbP8mz7faLr+z0kWhJO99xtDXrvG2Vp49OFN1ove+r+SXE7CH5suI5fowbwPcGRqqG5eqWd9EkwZDmgDC+mxANwCAPOLgoBPYEe7tClJDMVLDYgL/QfKKCBM+PYJTK6QnWQV8NUUdoUn4RmdvOaD8bGswFXlccf7W0TMQrrYWoVrR/sI5K6EWlmXepVCJKmkL7ydZbjMn1yBpLIY6cEw/KoJ2EITfjrZtPmkJT/lRUVhdOPAKB3nVlU2d6ZlO+UJD2A4AilIAJefPObJtv3EzvHNXNtQiWUOUav89HFR/HyvLbqHLDVifz0y56Kvxvq/1uAsLh9Go3Cz1VWkm6Xiiz6UXjHI4rsmZMfVgq0Tkz1RLv/ZSkIrqu7LIcxEf4kwGs/MVpLt6MhT4i77wHokR40
 Qo7Y2tJy
 73okIBFsaHVtWbWusc+iSCwIacO1D4vTbzRwrksmf5WXjglmSRt+3Vuxkn2R43JWz0efvDqnQFOL0hsOsd9xquEoInsAb0Bk+OvyCLkcXu36dUNKg4syenhJeqQhFimBw0OskwOiK5iuYTH4cl58pGhJVpfV8TW0NRHHUoomxn+zQ/LHMB5/NVq8Ik1xgwPH8HSLpdEy9GMYjeJQaAPXFTacvTfP7DEMuszTqNR1xXTlCVD4KcQXml30Ju6KWfVemVSBO2D2SUCFbiRJ97oytDiaKMLDCWeygvk+v+LkICbHE1EozgMGKWIMr4Jq8jZHavXixuj7qa4DbMFjlbGrvWNu4qb9qD+cc1rhwPwxD0ZVkY48xNFENws/L7PZ5o5ZcEn0vgg5bqPSmLso9DzGGLEQhsECD1an/zkQaMKXky+AjNR4wVE1LaaE0cna/0CGntKaxm75C0JPotzkBRbPi2OYXN1VMGz+AhKG6qv/QG3p6PxA=
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 64 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ce794d9760a87..ad07c8caa3bd9 100644
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


