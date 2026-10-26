Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C08606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=isKtS/2A
Received: by kanga.kvack.org (Postfix)
	id A68C86B05C4; Mon, 26 Oct 2026 19:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19D46B05C5; Mon, 26 Oct 2026 19:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909046B05C6; Mon, 26 Oct 2026 19:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65BE96B05C4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:21:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 019D21408AF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:21:22 +0000 (UTC)
X-FDA: 85366350846.05.08662F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C0DF100005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:21:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="isKtS/2A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sa8tfvVw1l57KNfiSIe1Yios+sToK3uLi/AwjZJQ8/k=;
	b=w6qmd5HzvP55HnuRCLjbfimGpMT3pFJg8UcQLWmEN/ltbHBbpi+xsEpxOTRPD4WcwEQJCb
	G6ktl5oB9Q8gra87vZhqaJjUCHr4cOCPV48kZ01nT3AprtNTJo3NwPBohYEjsszVjumTrv
	fXgzuQb61wQ3gFYcF20RqonQLkWZoLw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="isKtS/2A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056881;
	b=obXAkKzlwlPhORh3yNeslBHp55N6H1sP/sU7W8LhQEXs3AL76Em5dkyPN4uXnkJKTbOaQG
	pjyNodVhjviFsZAic0S2Eon8jThixUTYQD2ZvZIaKsbjybU/54Rv3e41GbjYNNc34hVtHX
	yzvXpZVjCFCJkG0MorwYMNwghZobfOQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2761601EF;
	Mon, 26 Oct 2026 23:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214011F01825;
	Mon, 26 Oct 2026 23:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056880;
	bh=Sa8tfvVw1l57KNfiSIe1Yios+sToK3uLi/AwjZJQ8/k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=isKtS/2A5NeaRQguaTYvUDnrgIFDJ17wHL59PMobMO6g7ZHpMetE7kei1Ps/bb1A8
	 xu8Kim7UlEZy2SixWOhdZcUGjChz41ApzfH4YoyAhImQGE0gAIm7Ih+fV60o4n0lO4
	 au5Viyp2kQyAhWJ8Vf1IKb58qD8iTw3kTdFjKBT8sR2Qn0B1S5PGt7goGve+sPNjtw
	 PJ4vGRk87GzyiEoh+gCcqdKSkFh9uR9s0cjDeyAORlo3WZL+RRCPtskfA+aeNUSg9k
	 AVucltVdLCDF9pjdvNZU4izy3JOQFzSQyCkg23um0pmIDKdbJ5Pyi5i+GSDV1lXIV7
	 ryNKJIL0dRfkw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:31 +0100
Subject: [PATCH 11/46] mm/huge_memory: properly handle refcounted PUD
 mappings on fork
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-11-6f74bec9a5bb@kernel.org>
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
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4336; i=david@kernel.org;
 h=from:subject:message-id; bh=f7xOz6s1fqGaUW9pRJrQ/Dq0ncEqYAqNRmBLRgpR3rQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35+ikxnOfLW3cJ+r9Kcba3b/iP8n/sGm/rpQsk3ZI
 v3uKs/wjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACYSuZuR4UfI7J7vjVFP2mQ9
 Cr6e0DVaf80t323DefHZLZ6r7B+c3MjI8G7LP29Dx6glK793rG9a7879mFXy//+1eikfq5jXXZk
 YyQoA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4C0DF100005
X-Stat-Signature: kfbmk6f66ipzacdec8wo78axwgzfnhhs
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793056881-557753
X-HE-Meta: U2FsdGVkX18h7cRV8jZCPPBywAmtl/Z5DM7XVHUbBg8aeMUXBIkNciBho96wEm+vM013aLVgK1KSUAMo0whC24TTRZvdpftUEOYiYcx9g66W3DF0pLAW6UT4furJRAKgMOHknv0NA4/aZpNtJeRzthwnz8JbZuId4LGQuTK7jmYI1lW0S7Kj2DlfUnuFrktEOfXgc7/SlDsVUMkLZfruB8J0OIvNLa2+a7HfA5RM4fMtHeGHG792EqwOmNSaKof8pHHfcRIzbFuyJ1wg1nkP4Hho5QT5AzODvk8J0kEnhI1QNoFN2cEV7+OOTfFBwSTLA8J+MWJTJaMMEQPjV4UhGkwK9f8VUhfGbHN0oJ10tyr0KZXxol/vGCOg9rcVxCzOEv832gw1a1hXnj+Bec1Qrb/1HxuPzJ84V2/BKsmjm6OV6eDq2FerUPFjMrIgRt/sTtXtuhjgIIPvZGtZSnwwD2ZMkuAxrlKzy34ch2l4zdSReNiNs6AEQM8nMe0Ita5AydZH1EeEz6xGyPeJHBlS2+Bq7Itg76Wmoloylj6J4BoryuwSgD6IRNJU7dWaePR4+aLcsPKJXvuDJ5BNhoALxTUuf8kdcW15iSM7ASCydOxoQ0RTsDyu2zwe2Ndusw9DIZMKvJa777OYn0dBoULZlMOigvhdh+WWiYFQJAbD2nGJnMTmDGW3mlxOG+21zI6U3l2YS8YXdpXs6Rk4LlLrG57866QTAP+cCePJgFNUtpBh6O3ryfEZsskw39xYPzY9XQaEvL2mdcB3zVP2F6qSwS4KuLB1E0wfadfsxzqQQcrcM3zGiCGk9iv0hq2JjYqZ6Co4CIBBa4GIkXRDZlx7eSClP6nuPNPOzLAWy7cyJdModo4cozhNG3hAzvlYngqSSXb2WlRCbDbDXSRWJdpAFdVm0nkI2cG7nPAdAkaM/nDJhDHilFQ6JQXj0uAfTNHOi0Ym/Ghj0VEueIOVk+p
 1xYdKzuW
 58or31ZejcB/O+mTZcww6TYVcp0eorpg7PA0fRJP4P1aI5vDKLcDB2DIsNyY29WQNMgKCy4agSiSFK1xF6Qc3t0VoCBL6+H6SjqRIDI+6HuaEVyJPQ7on2I1EYHM0F/tq0h9pCX2FsZcQ1O0+52DE8xYZb0VJ5NxSD0ElwrlX+6EP5vdVfxqPaY90RQ187O9o2AUmnt4dTK+Bj+MMu5Yg9V0BrcY8Hp9G+E0Tj08OgaTeOaF1JZ92PKe7Pe+cRC0U2Wsou0Zjq2+6NFYjsy39muy6evv2j3LS3ClBVdKX1SPsC7ukmviUmaaG/FJO7KppriuvNkq2KIZVBTce3w+JDhwR69xp9e2yeyhdA3u7nHAwblw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_huge_pud() copies device-DAX entries without taking a folio reference
or updating mapcounts and the child's RSS.

For example, MADV_GUARD_INSTALL sets VM_MAYBE_GUARD on a device-DAX VMA,
forcing copy_page_range() to traverse the whole VMA on fork. Any remaining
huge PUDs are then copied without accounting for the new mappings.
Unmapping them in the child decrements accounting that was never added.

Use vm_normal_page_pud() to identify refcounted mappings. Take a folio
reference and add the child's PUD rmap and RSS accounting before installing
the copied entry. Pass src and dst VMAs consistently instead of src and
dst MM. Move the TODO.

Fixes: aed877c2b4257 ("device/dax: properly refcount device dax pages when mapping")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/huge_mm.h |  5 ++---
 mm/huge_memory.c        | 27 +++++++++++++++++++--------
 mm/memory.c             |  4 +---
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad22987..fac05120ab774 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -12,9 +12,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 bool huge_pmd_set_accessed(struct vm_fault *vmf);
-int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma);
+int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pud_t *dst_pud, pud_t *src_pud, unsigned long addr);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4c0194af9016d..283c4bc8b927c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2072,11 +2072,13 @@ void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 		update_mmu_cache_pud(vma, addr, pud);
 }
 
-int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma)
+int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pud_t *dst_pud, pud_t *src_pud, unsigned long addr)
 {
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
 	spinlock_t *dst_ptl, *src_ptl;
+	struct page *page;
 	pud_t pud;
 	int ret;
 
@@ -2089,11 +2091,20 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(!pud_trans_huge(pud)))
 		goto out_unlock;
 
-	/*
-	 * TODO: once we support anonymous pages, use
-	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
-	 */
-	if (vma_is_cow_mapping(vma) && pud_write(pud)) {
+	page = vm_normal_page_pud(src_vma, addr, pud);
+	if (page) {
+		struct folio *folio = page_folio(page);
+
+		folio_get(folio);
+		/*
+		 * TODO: once we support anonymous pages, use
+		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
+		 */
+		folio_add_file_rmap_pud(folio, page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
+	}
+
+	if (vma_is_cow_mapping(src_vma) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
 	}
diff --git a/mm/memory.c b/mm/memory.c
index 5d6d695675bce..0f4db5080e371 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1463,7 +1463,6 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	       unsigned long end)
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
-	struct mm_struct *src_mm = src_vma->vm_mm;
 	pud_t *src_pud, *dst_pud;
 	unsigned long next;
 
@@ -1477,8 +1476,7 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 			int err;
 
 			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, src_vma);
-			err = copy_huge_pud(dst_mm, src_mm,
-					    dst_pud, src_pud, addr, src_vma);
+			err = copy_huge_pud(dst_vma, src_vma, dst_pud, src_pud, addr);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)

-- 
2.43.0


