Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178B4606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DqgnpMrn
Received: by kanga.kvack.org (Postfix)
	id 2A0746B05EE; Sat, 31 Oct 2026 05:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251BA6B05EF; Sat, 31 Oct 2026 05:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141076B05F0; Sat, 31 Oct 2026 05:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D87026B05EE
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:50:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 655B11606D6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:50:58 +0000 (UTC)
X-FDA: 85382452596.02.617035D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7E6CAA0003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:50:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqgnpMrn;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q043eEJ1pWwwcrq6F+Si2YyNT+O/hsof2CWT9VaJanA=;
	b=lqiQProjgebXfkMbM9GP+CTeZoS50y5V2Fu8db/ZUVxQgTRPx8nnMXyqJzbV1Dp/QyTRjw
	fcJSethr4lZQrtq6UMkE+dhFUN7d+6nBysCx2YbdHzcQHKtKpCw0goCqwLxN7hyjSZ4rkQ
	way8xLHCaYn5aXFlaek5W2jz6CUYKCg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440256;
	b=iavoPV60FJzybcv3GHY05QBImYgPX0gjQC3beSeezTHPkHlBkkaEGHSP/3tysDNxV08XMN
	lBH44GqlpsOcx3eLsno4WzHSP29zklp9aFmZpLXSCOSt9NGit3dGf1EoeI6JCcjEIRPjf+
	aO8+m9m+1lYKBKohma46+oQ3SVWOWV8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqgnpMrn;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B662143AB7;
	Sat, 31 Oct 2026 09:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5501F000C1;
	Sat, 31 Oct 2026 09:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440255;
	bh=q043eEJ1pWwwcrq6F+Si2YyNT+O/hsof2CWT9VaJanA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DqgnpMrnrm2+UGtFJyEBUvP3Y2VTNf6hsqI2ug7ZLJQBbOqzgdnuAOQMYRRb/VkS2
	 NL6ZVrsOv3ah4WcrNi+N4mYjkwrG07YPlpnWxMNPUWhPt1mOCHM/bUBpmm8SdZK55P
	 f94MkkEAZ3IrswabSvR23HL4i602Pz0gw7QOmIxiR4a0AA14MarlbWwkOu9IldykkH
	 TUcNZjwUnDpQJ9e59udXl8y9SYnAoS6Gc1ogy9uEeRKAXv9mA7s7CwofGEWHSIW9Tb
	 c43670w5CI8QrOTtOzSDi2W1DVb2bgb16ACZtv1B6M5vcG5UGasIHvBoLGGYwNtUXi
	 vrit+y8AdbnAw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:10 +0100
Subject: [PATCH v3 41/47] mm/ksm: check large swap-cache folios before
 mapping them
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-41-d6437171ecc3@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5814; i=david@kernel.org;
 h=from:subject:message-id; bh=u2/TMS12ldsBZ8ojUAVeND05nd9SfVmRdy0kHuMwa40=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+SbbSSYp2bWbHzhE1F2H0RC81bnGps3pwNCx+kP
 +jQzLzRUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwETuTWX4p7X1zDWx4PZXuz/f
 M27mykr9dkPkVQrvzPiIDQf33utstGb4w9l5Z9JSvu9srhl7L/5pF12RcPJIc33jr8lPDj/TXcl
 UyQcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E6CAA0003
X-Stat-Signature: txife5fcjw3mpmyjxkufhzw3qe9k7dte
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793440256-262676
X-HE-Meta: U2FsdGVkX1/7sw2aVK6GypJwhK0wX8JSdSlRgEmhEXXyyuNDwF0S8bYTiqOCHw8ww+0Clfae12MYtFDIvzIKF0yRmaMkOTgUdmmyXYooc0lOD4o5dsitPYDx6JKC1jT2ARAe5nl7wP4+3noauNVgAr1XO4nXU3RaqSYlME8kM6FxcF1oSy2jyDtJA1YsL2WXEmtJ86oRoBQE1pLTtikektj8SVx3G5NB8PlyAAFYB4KTZAT6/+e7S46rWR95rzw9r3cLW5de9NzDNCLZIfyM7M7MEffGwjxxIqsoqfEpPyrq/p387XSqnASS3IAxxPq/ZCRfsOy5SDDyZqZp0kuBSHeYQJa6svdC9aSZv+93itmFde9pN099pKhbRJXjbClblNfYfGMitFcZ+z16wyVBX7uXIE/41JxN2LxjwrZ9/xTm95X9VuJQ8ZTKCMhY05d8Yey+6yoUicdsMdF2YW1eJ8XuIGhSY9Pfppjirev0Fcjzi2BW37eehUU7K762MfWQ2QGd+CbpOqR8/W5vHb9ezRcuarYJKd0pkVJs908kR6UzeILZPqrgcTY/0mtRQF3LZXVVAwOEjWaCP96OWfRdkSyuj+sAgOpJHrnQ7bTZQE3GqZRpKcvcIbIFiz09dpmJa9OcXQiWmKN0dePXtd2m2b7PtRmCIBst+SMZiP6XIrVB5DF6ruiRDxItAyCUT+7u6EOnTjp5FwJXfycyNfdNlWTVy4W3RowkgBT8OG25PA8z7fkbF1kXUvr9CvhJViBvcuycJXOOdmx5DJZuzMrniom4XcbhvOiOToL/Us5ANobJ5HnkT5TvUq0aXGYZ9+fwHayyUCLPH1L6ewUddy+qOBQDJKNlNls23ckEawP4TQ0Sa6TWlNOmXY7OKdnZTY5Vt0zAKfwYmGC4V3PN3zTpRa31jQJjJkLK/ISkYb0u7nXo9nzBpFmc50keV6p6BC8yGp0n242/Ntr7QEzau0K
 hvZWgM3y
 y5kMCrILJhOZjhdmVf1gH11/v7IZkq1vzmPUmmxgjqZoUtTIudk9CKmr3ZfLt8NJ6K90MjSpFkWwc/z+etLCI4IhUiN86YGHp346Di8o6uP8kt7k6pY6U6W7B6Z2pB3gHhhHMumdtODb7wnRWes/gpvg1LcmEH04E2m1ypVAWJmTpTXYvXcN/xKhsTpPyuYFUt+FoqZEbFA+AA8VRLb/SNeKNXIJjUyVDgL0wzeACGePUw6xTQ7AS6eArGwL9xW4ST/kAbVRGgAXVsV4Vv6vPgDcxDA4IQ1+bCoUxr785zVW1d+zmoax9yER3tMmeZRLOBoqIcj0Fwau1hV3OiKblC2+r3ME9+2Pa49+klQAWf8022D8PGf2cUMhAhEEaWM3PAZyy
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
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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
index 77d4bbf444bc2..91836d217d25d 100644
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


