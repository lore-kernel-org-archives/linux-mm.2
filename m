Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917E4606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Idfp5FdH
Received: by kanga.kvack.org (Postfix)
	id 8CD046B05F9; Mon, 26 Oct 2026 19:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A46E6B05FA; Mon, 26 Oct 2026 19:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793EA6B05FB; Mon, 26 Oct 2026 19:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 510826B05F9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:30:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCBE6A06AD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:30:36 +0000 (UTC)
X-FDA: 85366374072.16.DB1F65D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EC473180008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:30:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Idfp5FdH;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QD80RIB+y4ufuur+YyQBCtVBuNIRW9PI0dOqkUCl6r4=;
	b=EmgpbQXE5cj2mXSEVNl1+hhB8HsgT33+TO4Pyv7QP95q2k3Q41xVkS1VNL+LQu8sf0Zdi0
	ODFSAr8ByOIO7CSqVVJtGXzQO/smiiKe+m895foX3ri1+cb9t1472ZVEXXeAMN+3/uB70A
	qWeDpI7X/JcwmDnvEmE53ZoVcw0wz5M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057435;
	b=fEjjFmuZugxa11bSp2fXntuHEexqt0EYfQuI/lrgzkgQQhEIHjrD5yKTYB4FR27k1xtKb5
	mY98IoLpG3CmVwdDFpWUxh1AzXfNKk8+WPK36CKyAn1zwZGOq2xaA+6jjbLdcuQV3s/F7r
	C32b09TvoAwtCvJpC7GK8ijIbXmgYyw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Idfp5FdH;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3801B41B73;
	Mon, 26 Oct 2026 23:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699E61F031E4;
	Mon, 26 Oct 2026 23:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057434;
	bh=QD80RIB+y4ufuur+YyQBCtVBuNIRW9PI0dOqkUCl6r4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Idfp5FdHu05jmgG2gxrdPm9pJx1n3xB1zoPEfEOUq9+fiGYk98OuHmK/JnwLyctpJ
	 5/yyl6bqnxBDnMBMUJZuD+2fPDwfAmFHhQ4wS6AYY9RVV8oYlRAzYfMbteM5kb4BvA
	 tcLdxABufX1OTiZA/39+6NKUjEbIDyPAjBkWNRfNoNk/GFP8kQDXlHHt3Vy5+deFdu
	 9An1+YVChNv4Y8ZrFy7+/OQeyjP8Hn4HTV/BtEwa20A559hfO3FvjhnpGrlzvbgJAy
	 aiAMr0KsMDnT2wNRSCDWYgsCnM5+Kg5iaAPY3I23sM+oY4B8yPtRWlDPSi8Z/DrGd2
	 jOboFyyDzd0SA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:18:00 +0100
Subject: [PATCH 40/46] mm/ksm: check large swap-cache folios before mapping
 them
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-40-6f74bec9a5bb@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5706; i=david@kernel.org;
 h=from:subject:message-id; bh=NNztKZDxEKa7XxQhow2LeYex7WrWA250Qi1z9GReFZc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/h0hqzoXUNzwMtNbOlZv7sCk5VsXdDvmzqXSypY
 1ovP7G/o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIm8zWJk+CR7I3FP9F7DR0sz
 m5emXImYV6B0b7O1X4VgdPHFFW++lzAyHFR8+yHg7uTiCdsPst/rZti0qS5cdbtf0FLH5xq1vy9
 MYQMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC473180008
X-Stat-Signature: 435y1herwguoj5yuenrd9u67d34jzszt
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057434-599588
X-HE-Meta: U2FsdGVkX19fOowCeDIB/XN3u7eF8hOD4UggKgu4QC/cuL7bzhyHHae6ZK9csSkaiWKo+1UpJuUyGeTvAtVBWmz+M1oPm06xZYIumQTUaxovHZhfF8Hf4yBFsjxO5H1hIbELus8/JPvRl0ffgrC/kZmzfs0F83AYKCBAmvN/k01b0YX+alQ3b3gLrV7/ea/Z0tCO+yqGiH9fN3wqH5nzslxboiNTcWg6Nu/YSapfbrOLMKLK4bGUiFj05/t0fj3lHA0DAHReqCgNAdk2rPoN6psuDpU1YIOKc28vepBdCCZ/C/fTusjG48ZhSFgp/bQ6eAInjjZhFvmUIp4i043T6JBqFftqEyL+nsj9wPBvZ0lnR+oW+tW06A610PicHY3kfKMeWgWft0zduvTRRqwqKlrd3WoQFG7FXB1dFQ3Str/rNIZ0ARhgH9YBlmO1fJw+xLjc6CekBgnMG0kPZjMRz7ug2kaM/OaYRI/sWVSMvVEv0vnhwGdQSVDYO0ZDo976SEpttPGSXo5faOkcLjNgLScw2WbOTebTQ016X+iYSxbZjgsDG9U5eLwXBeJhPQTMav3NR6NDm0JufMm+N08jB0duHb07JXgNkcXRG631AppUjp7bGY4gFhP2s5chQ/vFjRp9fpIjpxLDvDAb8D8ZjJ1d4BpfitmkaiMDMzq701YTzHhGfi606XpANIRwtRI1oJCgmiwJ418wbsuDoClz2UHic+gHkpUBThGwJ4DMXbBg3sgzLfJkxLLjZvNWxkZWNaG1LY+PxJ1jPayol9arYD2hX0/WQxmI9pbptgaqEi5H7pB+OR6J2aGhXaU+hziS53AhTtRVO84+6Z8uXhjQYXFVZNO5Nka+iZV+y7ZeSspn6wiel4bDSd/mXyOwl+8JQm8Tg/DGo8XkxpYnyCmHceY0gKrYjNaQNYuH3CNkZT2K6DjGrtEzLTtz7DF6o449HECxZ/Pp70RwKZAXJEc
 jgDixwRJ
 WiQFXUuq6jH03Mziy9iBxJPG0Z8MHfsmfgqpU4Gy4KBqWfKJps8+jNN8OW4yu+FwSy/zRh2/0+NMjoL5KjjCemczK86vawYd8RspQGehH6lIPAFK+fg4ajwHUbyXEi1CA1ON6y38D3mL+TNu/LLwcCdPwymeSCZnH9CJwbZnjmHI/4W+++WAkYVaQe9UXnmZl3D2EWwS3xWCCEpfMBJYcoL1TSCW4+zYzyZlHeoVCI8sRC1manpZj1eUqu4U2U4f3aEHgdR6rTFas7t1yBJb+0aUzHXLtqXi33IkIM4N1Gtp/qndovI+Y8rK3F/fklydk4dEr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

KSM folios are always small, but their shared swap slots can be read
back as part of a large folio in the swap cache. ksm_might_need_to_copy()
skips large folios, so another process can map a page with an incompatible
anon_vma or page index. Reverse mapping then cannot find the new
mapping, preventing migration or reclaim.

Apply the same compatibility checks to large folios as to small ones.
Pass the page corresponding to the swap entry and copy only that page
when necessary. In do_swap_page()'s copy path, decrement only that slot's
swap count, because the source swap-cache folio can now be large.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/ksm.h |  6 +++---
 mm/ksm.c            | 22 ++++++++++++----------
 mm/memory.c         |  5 +++--
 mm/swapfile.c       |  3 ++-
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index d39d0d5483a23..a0d358a1feb63 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -91,8 +91,8 @@ static inline void ksm_exit(struct mm_struct *mm)
  * We'd like to make this conditional on vma->vm_flags & VM_MERGEABLE,
  * but what if the vma was unmerged while the page was swapped out?
  */
-struct folio *ksm_might_need_to_copy(struct folio *folio,
-			struct vm_area_struct *vma, unsigned long addr);
+struct folio *ksm_might_need_to_copy(struct folio *folio, struct page *page,
+		struct vm_area_struct *vma, unsigned long addr);
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
 void folio_migrate_ksm(struct folio *newfolio, struct folio *folio);
@@ -145,7 +145,7 @@ static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 }
 
 static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
-			struct vm_area_struct *vma, unsigned long addr)
+		struct page *page, struct vm_area_struct *vma, unsigned long addr)
 {
 	return folio;
 }
diff --git a/mm/ksm.c b/mm/ksm.c
index e050b1bdf810d..e95f6b6723602 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3138,19 +3138,20 @@ void __ksm_exit(struct mm_struct *mm)
 }
 
 static bool folio_anon_rmap_compatible(const struct folio *folio,
-		struct vm_area_struct *vma, unsigned long addr)
+		const struct page *page, struct vm_area_struct *vma,
+		unsigned long addr)
 {
 	const struct anon_vma *anon_vma = folio_anon_vma(folio);
 	struct anon_vma_chain *avc;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_large(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(page_folio(page) != folio, folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_ksm(folio), folio);
 	vma_assert_stabilised(vma);
 
 	if (!anon_vma)
 		return true;
-	if (folio->index != linear_anon_page_index(vma, addr))
+	if (page_pgoff(folio, page) != linear_anon_page_index(vma, addr))
 		return false;
 
 	/*
@@ -3167,20 +3168,21 @@ static bool folio_anon_rmap_compatible(const struct folio *folio,
 	return false;
 }
 
-struct folio *ksm_might_need_to_copy(struct folio *folio,
-			struct vm_area_struct *vma, unsigned long addr)
+struct folio *ksm_might_need_to_copy(struct folio *folio, struct page *page,
+		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct page *page = folio_page(folio, 0);
 	struct folio *new_folio;
 
-	if (folio_test_large(folio))
-		return folio;
-
+	/*
+	 * A KSM folio is small, but the slot that it left behind can be swapped
+	 * in as a part of a large folio by one of the processes that shared it.
+	 * So test, and copy, the page of the slot.
+	 */
 	if (folio_test_ksm(folio)) {
 		if (folio_stable_node(folio) &&
 		    !(ksm_run & KSM_RUN_UNMERGE))
 			return folio;	/* no need to copy it */
-	} else if (folio_anon_rmap_compatible(folio, vma, addr)) {
+	} else if (folio_anon_rmap_compatible(folio, page, vma, addr)) {
 		return folio;		/* still no need to copy it */
 	}
 	if (PageHWPoison(page))
diff --git a/mm/memory.c b/mm/memory.c
index 230a2f4dafa13..be4c05db37d33 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5096,7 +5096,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 * folio->index of non-ksm folios would be nonlinear inside the
 	 * anon VMA -- the ksm flag is lost on actual swapout.
 	 */
-	folio = ksm_might_need_to_copy(folio, vma, vmf->address);
+	folio = ksm_might_need_to_copy(folio, page, vma, vmf->address);
 	if (unlikely(!folio)) {
 		ret = VM_FAULT_OOM;
 		folio = swapcache;
@@ -5278,7 +5278,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache, NULL);
+		folio_put_swap(swapcache,
+			       folio_file_page(swapcache, swp_offset(entry)));
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 254ce86fa923e..71ef9e2efb3a9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2514,7 +2514,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		return 0;
 
 	swapcache = folio;
-	folio = ksm_might_need_to_copy(folio, vma, addr);
+	folio = ksm_might_need_to_copy(folio,
+				       folio_file_page(folio, swp_offset(entry)), vma, addr);
 	if (unlikely(!folio))
 		return -ENOMEM;
 	else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {

-- 
2.43.0


