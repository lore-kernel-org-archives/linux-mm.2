Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2DEC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6006B012D; Mon, 29 Jun 2026 11:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD0B6B012E; Mon, 29 Jun 2026 11:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986056B012F; Mon, 29 Jun 2026 11:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD186B012D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D0888B4F6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:20 +0000 (UTC)
X-FDA: 84933271080.01.C449447
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0CA91C0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJf0ENO6;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745459;
	b=YC/Gr6Dk2zqvBcTAlH4wNo5ucK4Yx2W/+sA2+pits+dg+YUOqA6ijq3Iswn+LAX70QIt4+
	Q2G9HX5tc2hVMNMcxUug0BlOyTjFLgELEXe11imDXHGXQ+ogzfQ2RNxHtWH671W+EyP2v2
	Iq3dRzt9LtelIdeOnnceOUVm4VfUQ9g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZ8GNEZCrdROcAhUDbdNpJ0boDWb6oFjwNmBPq06FqA=;
	b=IpBSOkXXruKlZ2bDS05v5r4Lvfb3xVDtHhu5+Pn7L8frGXIVlLAa5T3dUlNd+SZwnEosjo
	8PgeEUsrg3MYxxDhO8XWl4XFjOTt+dmguzxmLZWKoSXbEY51FccdQZ7S45GvYFviRWbb0q
	au/qaoTG4RrR+rOLPHpiSwaWl9VK15U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJf0ENO6;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9040560126;
	Mon, 29 Jun 2026 15:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469921F00A3A;
	Mon, 29 Jun 2026 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745458;
	bh=eZ8GNEZCrdROcAhUDbdNpJ0boDWb6oFjwNmBPq06FqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJf0ENO6ZzvvnGDdNae7w4yVdftZCZAwWXVU3XC4/glMvPNw3u1SlxQNuOdQbi4Hn
	 EyMcI3EOEX/m+YmLMeb5dGciGuAas9GGBZygJFVywNcG/9vgUZ1FBQq0231+TWLeE0
	 4b4CQ+ao5lPKJk0wAe/OJGT84bQDklkPereHpTEvlSBuMO4z6HPMsLJDIyMdWY+Rj5
	 Oec/tlIviz7vbMzF5+DYeemqaHQrh1WkB9PCqZ4syBBx2q+WrwM3jH+pfVFxxu6aHp
	 bmw343BZxiYt5Wf86Zhh9cAvqCuOLaQeo3VISnBp/AXSJMg9aoFxE8tmwsTNJNSBhj
	 mkp6KyNo45+pg==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 06/10] mm: propagate VMA virtual page offset on map, remap, split + merge
Date: Mon, 29 Jun 2026 16:03:46 +0100
Message-ID: <259d6d8f1aec1f70665dfc93bed6f75d2070e692.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782745153.git.ljs@kernel.org>
References: <cover.1782745153.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a1fro7iaspifmxonhhbab7dm9ugdfnno
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0CA91C0009
X-HE-Tag: 1782745458-987595
X-HE-Meta: U2FsdGVkX1+gJk+6wY+E27pVpNY5vb0OJPhDmDMk7jnei5r9PwOKaljgoGU07k1mYLsBUwGkgqm7m6h/JaZ52hD22Iz9KlT/AgvpkPIOgrcq1R2o8kqUWlT99KMILB/bcw2mBUjR6O7/E5z0NGshzvdJHnk6XQmu6cZ3a0Ecf9jq9C7ZqkMQDFlu7McghtdBaTh4Mt5NmKUT8g8sk/tvhfaQD79Z/zawNWH1eawd1Fhc9bFZ7jFHgveGvbkEy8JN2JP88d3wA93oUCS/cqDbcfy1GXBILha0lXgjQBagipJv+ODiwLWS0n3RIEX1Mw2HrAwlEJ9ZpnwzNwzXEpEdmS36HayOY3lcpFE8STPXq0eg4j02kMkLAum5Y7hgkc77lkCm3R7V1GUi6DnJqbxToMnCUiD6rO0hyntvPqEvRYAlZ0bXHuPPV9Dxd88vSkXLyHqyVYdyryP0sTur6f4sq42Vk3y5AQymmBphb/dzgrFtw+lzfCnyHAbLYxhoru4k8yTJw2DBaJtKNUXRNskF21VywrHa7QDH+b+sXVXQR76q1EMUe3K1s9uaj7wbXY5SiT70XBEpa8YljenU0dVkU+zXXL8VmtI2KYDH9l407LDlHU8fRmUrF1weiK7zwWU1KXWg5e3IsGWHly9k9kFgc8xdKhlnLRrxLPGV3Zay8kAs7r/cKucZnzHLMc+dNUTJSq2wmvENLwebH3sKDQnvPnaKZzGU4+AGIePbSNLyo4TyO0wRIj3NoJp1R/ZS/Bm4JER4LVyx9H80wDgfSuMEli3WR6fHSW+h9WiOooqdakeLOfyjQHj+YZTvixdaTJaUxBIbbuocGad/JjdEHAGkMSkOm/XYkml04m2RwYIld0HN+nHDhJwwdrHtXrZjABQZzyrhBLB09QMyNjBhbrvOq+Q0UPqbxse20KmG4u6dpyjgvBJKLjyurZb4MIsshPQEh8uJyyavFQ+q8eOcKFw
 8o8VIYi4
 Dw2U/jFtQ9Efpdq3lcd2L3xC3q4BS+oib/RcAnWcnL1POqZo/0ZF61KR3eH4hRa1RzJSmufaVYYohE5k8hGt8ZwqKI65MtP62V18B7ZPOurzpfVa+GlDv8H5DkvC599hru8xbKKPKgf75vhI8bYol/LH3LiziUkXNjWFB3iXsn2z/P+9j6vOkOAf72CnyZ7PLLI+Vu7lR0mrMlIt98S2ZiDepgCxZj4lXd58UnS2gk0ZQm6/gU/qKjMZqgPICEm1NUFxPB9iSaBK+NX9EXxL1i6HsDjnvhbiQlUg34JVbrwDvVBh9s+E+I8Z2VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We must correctly update VMA virtual page offset state on all VMA
operations that would result in it changing, with special attention given
to remapping.

We cover most cases by simply updating vma_set_range() to do so (with a new
virtual page offset parameter), but also notably must update the merging
and mapping logic to propagate this parameter correctly.

The remap logic remains the same - we may update the virtual page offset if
the VMA is unfaulted, but now this applies to MAP_PRIVATE file-backed
mappings too, so we update the code to reflect this.

Note that we use __linear_virt_page_index() upon remap as the VMA may be
shared, in order that we update the field consistently regardless of VMA
type.

Also while we're here, replace a VMA_BUG_ON_VMA() with a
VMA_WARN_ON_ONCE_VMA().

We also introduce vma_anon_pgoff_addr(), vma_start_anon_pgoff(), and
vma_end_anon_pgoff() which differ from their virtual page offset
equivalents in that a shared file-backed mapping returns its file page
offset otherwise the virtual page offset is used.

This means we don't predicate merges for shared file-backed mappings on
virtual page offset.

We simply ensure state is correctly propagated here, so no functional
changes are intended.

Finally, we update insert_vm_struct() to correctly set the virtual page
offset on insertion of a VMA.

Also update VMA userland tests to reflect this change.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mremap.c                      |   6 +-
 mm/vma.c                         |  56 ++++++++++----
 mm/vma.h                         | 127 ++++++++++++++++++++++++-------
 mm/vma_exec.c                    |   2 +-
 tools/testing/vma/shared.c       |   3 +-
 tools/testing/vma/tests/merge.c  |   4 +-
 tools/testing/vma/tests/vma.c    |   4 +-
 tools/testing/vma/vma_internal.h |   1 +
 8 files changed, 152 insertions(+), 51 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 079a0ba0c4a7..f4cbf7d686b7 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1254,7 +1254,9 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 static int copy_vma_and_data(struct vma_remap_struct *vrm,
 			     struct vm_area_struct **new_vma_ptr)
 {
-	const unsigned long new_pgoff = linear_page_index(vrm->vma, vrm->addr);
+	const pgoff_t new_pgoff = linear_page_index(vrm->vma, vrm->addr);
+	const pgoff_t new_virt_pgoff =
+		__linear_virt_page_index(vrm->vma, vrm->addr);
 	struct vm_area_struct *vma = vrm->vma;
 	struct vm_area_struct *new_vma;
 	unsigned long moved_len;
@@ -1262,7 +1264,7 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 	PAGETABLE_MOVE(pmc, NULL, NULL, vrm->addr, vrm->new_addr, vrm->old_len);
 
 	new_vma = copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
-			   &pmc.need_rmap_locks);
+			   new_virt_pgoff, &pmc.need_rmap_locks);
 	if (!new_vma) {
 		vrm_uncharge(vrm);
 		*new_vma_ptr = NULL;
diff --git a/mm/vma.c b/mm/vma.c
index 7201199fc668..c4bb41400751 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -18,6 +18,7 @@ struct mmap_state {
 	unsigned long addr;
 	unsigned long end;
 	pgoff_t pgoff;
+	pgoff_t virt_pgoff;
 	unsigned long pglen;
 	union {
 		vm_flags_t vm_flags;
@@ -46,13 +47,22 @@ struct mmap_state {
 	bool file_doesnt_need_get :1;
 };
 
-#define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, vma_flags_, file_) \
+static inline pgoff_t map_anon_pgoff(const struct mmap_state *map)
+{
+	if (vma_flags_test(&map->vma_flags, VMA_SHARED_BIT))
+		return map->pgoff;
+
+	return map->virt_pgoff;
+}
+
+#define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, virt_pgoff_, vma_flags_, file_) \
 	struct mmap_state name = {					\
 		.mm = mm_,						\
 		.vmi = vmi_,						\
 		.addr = addr_,						\
 		.end = (addr_) + (len_),				\
 		.pgoff = pgoff_,					\
+		.virt_pgoff = virt_pgoff_,				\
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
@@ -67,6 +77,7 @@ struct mmap_state {
 		.end = (map_)->end,					\
 		.vma_flags = (map_)->vma_flags,				\
 		.pgoff = (map_)->pgoff,					\
+		.anon_pgoff = map_anon_pgoff(map_),			\
 		.file = (map_)->file,					\
 		.prev = (map_)->prev,					\
 		.middle = vma_,						\
@@ -82,10 +93,11 @@ static void __vma_set_range(struct vm_area_struct *vma, unsigned long start,
 }
 
 static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, pgoff_t pgoff)
+			  unsigned long end, pgoff_t pgoff, pgoff_t virt_pgoff)
 {
 	__vma_set_range(vma, start, end);
 	vma_set_pgoff(vma, pgoff);
+	vma_set_virt_pgoff(vma, virt_pgoff);
 }
 
 /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
@@ -812,7 +824,8 @@ static int commit_merge(struct vma_merge_struct *vmg)
 	 */
 	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
 			      vmg->__adjust_middle_start ? vmg->middle : NULL);
-	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg));
+	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg),
+		      vmg_start_anon_pgoff(vmg));
 	vmg_adjust_set_range(vmg);
 	vma_iter_store_overwrite(vmg->vmi, vmg->target);
 
@@ -982,6 +995,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		vmg->start = prev->vm_start;
 		vmg->end = next->vm_end;
 		vmg->pgoff = vma_start_pgoff(prev);
+		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		/*
 		 * We already ensured anon_vma compatibility above, so now it's
@@ -1000,6 +1014,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		 */
 		vmg->start = prev->vm_start;
 		vmg->pgoff = vma_start_pgoff(prev);
+		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		if (!vmg->__remove_middle)
 			vmg->__adjust_middle_start = true;
@@ -1022,12 +1037,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		if (vmg->__remove_middle) {
 			vmg->end = next->vm_end;
 			vmg->pgoff = vma_start_pgoff(next) - pglen;
+			vmg->anon_pgoff = vma_start_anon_pgoff(next) - pglen;
 		} else {
 			/* We shrink middle and expand next. */
 			vmg->__adjust_next_start = true;
 			vmg->start = middle->vm_start;
 			vmg->end = start;
 			vmg->pgoff = vma_start_pgoff(middle);
+			vmg->anon_pgoff = vma_start_anon_pgoff(middle);
 		}
 
 		err = dup_anon_vma(next, middle, &anon_dup);
@@ -1137,6 +1154,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 		vmg->start = prev->vm_start;
 		vmg->target = prev;
 		vmg->pgoff = vma_start_pgoff(prev);
+		vmg->anon_pgoff = vma_start_anon_pgoff(prev);
 
 		/*
 		 * If this merge would result in removal of the next VMA but we
@@ -1911,9 +1929,10 @@ static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
  */
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks)
+	pgoff_t virt_pgoff, bool *need_rmap_locks)
 {
 	struct vm_area_struct *vma = *vmap;
+	const bool is_shared = vma_test(vma, VMA_SHARED_BIT);
 	unsigned long vma_start = vma->vm_start;
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -1922,11 +1941,14 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);
 
 	/*
-	 * If anonymous vma has not yet been faulted, update new pgoff
-	 * to match new location, to increase its chance of merging.
+	 * If a vma has not yet been faulted, update its virtual pgoff to match
+	 * the new location to increase its chance of merging.
 	 */
-	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
-		pgoff = addr >> PAGE_SHIFT;
+	if (!vma->anon_vma && !is_shared) {
+		virt_pgoff = addr >> PAGE_SHIFT;
+
+		if (vma_is_anonymous(vma))
+			pgoff = virt_pgoff;
 		faulted_in_anon_vma = false;
 	}
 
@@ -1943,6 +1965,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		return NULL;	/* should never get here */
 
 	vmg.pgoff = pgoff;
+	vmg.anon_pgoff = is_shared ? pgoff : virt_pgoff;
 	vmg.next = vma_iter_next_rewind(&vmi, NULL);
 	new_vma = vma_merge_copied_range(&vmg);
 
@@ -1964,7 +1987,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 			 * safe. It is only safe to keep the vm_pgoff
 			 * linear if there are no pages mapped yet.
 			 */
-			VM_BUG_ON_VMA(faulted_in_anon_vma, new_vma);
+			VM_WARN_ON_ONCE_VMA(faulted_in_anon_vma, new_vma);
 			*vmap = vma = new_vma;
 		}
 		*need_rmap_locks =
@@ -1973,7 +1996,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		new_vma = vm_area_dup(vma);
 		if (!new_vma)
 			goto out;
-		vma_set_range(new_vma, addr, addr + len, pgoff);
+		vma_set_range(new_vma, addr, addr + len, pgoff, virt_pgoff);
 		if (vma_dup_policy(vma, new_vma))
 			goto out_free_vma;
 		if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
@@ -2609,7 +2632,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 		return -ENOMEM;
 
 	vma_iter_config(vmi, map->addr, map->end);
-	vma_set_range(vma, map->addr, map->end, map->pgoff);
+	vma_set_range(vma, map->addr, map->end, map->pgoff, map->virt_pgoff);
 	vma->flags = map->vma_flags;
 	vma->vm_page_prot = map->page_prot;
 
@@ -2799,7 +2822,8 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	struct vm_area_struct *vma = NULL;
 	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
-	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, vma_flags, file);
+	const pgoff_t virt_pgoff = addr >> PAGE_SHIFT;
+	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, virt_pgoff, vma_flags, file);
 	struct vm_area_desc desc = {
 		.mm = mm,
 		.file = file,
@@ -2945,6 +2969,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		 unsigned long addr, unsigned long len, vma_flags_t vma_flags)
 {
 	struct mm_struct *mm = current->mm;
+	const pgoff_t pgoff = addr >> PAGE_SHIFT;
 
 	/*
 	 * Check against address space limits by the changed size
@@ -2969,7 +2994,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 * occur after forking, so the expand will only happen on new VMAs.
 	 */
 	if (vma && vma->vm_end == addr) {
-		VMG_STATE(vmg, mm, vmi, addr, addr + len, vma_flags, PHYS_PFN(addr));
+		VMG_STATE(vmg, mm, vmi, addr, addr + len, vma_flags, pgoff, pgoff);
 
 		vmg.prev = vma;
 		/* vmi is positioned at prev, which this mode expects. */
@@ -2989,7 +3014,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		goto unacct_fail;
 
 	vma_set_anonymous(vma);
-	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
+	vma_set_range(vma, addr, addr + len, pgoff, pgoff);
 	vma->flags = vma_flags;
 	vma->vm_page_prot = vm_get_page_prot(vma_flags_to_legacy(vma_flags));
 	vma_start_write(vma);
@@ -3381,6 +3406,7 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 		WARN_ON_ONCE(vma->anon_vma);
 		vma_set_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 	}
+	vma_set_virt_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 
 	if (vma_link(mm, vma)) {
 		if (vma_test(vma, VMA_ACCOUNT_BIT))
@@ -3433,7 +3459,7 @@ struct vm_area_struct *__install_special_mapping(
 
 	vma->vm_ops = ops;
 	vma->vm_private_data = priv;
-	vma_set_range(vma, addr, addr + len, 0);
+	vma_set_range(vma, addr, addr + len, 0, addr >> PAGE_SHIFT);
 
 	ret = insert_vm_struct(mm, vma);
 	if (ret)
diff --git a/mm/vma.h b/mm/vma.h
index 68fb2f49bbab..9881d105a0c4 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -104,6 +104,7 @@ struct vma_merge_struct {
 	unsigned long start;
 	unsigned long end;
 	pgoff_t pgoff;
+	pgoff_t anon_pgoff;
 
 	union {
 		/* Temporary while VMA flags are being converted. */
@@ -237,11 +238,6 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
 }
 
-static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
-{
-	return vmg->pgoff;
-}
-
 static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
 {
 	const unsigned long size = vmg->end - vmg->start;
@@ -249,6 +245,11 @@ static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
 	return size >> PAGE_SHIFT;
 }
 
+static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg->pgoff;
+}
+
 static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 {
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
@@ -263,6 +264,16 @@ static inline void vma_set_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	vma->vm_pgoff = pgoff;
 }
 
+static inline pgoff_t vmg_start_anon_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg->anon_pgoff;
+}
+
+static inline pgoff_t vmg_end_anon_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg_start_anon_pgoff(vmg) + vmg_pages(vmg);
+}
+
 static inline void __vma_set_virt_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 {
 #ifdef CONFIG_64BIT
@@ -281,44 +292,102 @@ static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
 	vma_set_pgoff(vma, vma_start_pgoff(vma) + delta);
+	vma_set_virt_pgoff(vma, vma_start_virt_pgoff(vma) + delta);
 }
 
 static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
 	vma_set_pgoff(vma, vma_start_pgoff(vma) - delta);
+	vma_set_virt_pgoff(vma, vma_start_virt_pgoff(vma) - delta);
+}
+
+/**
+ * vma_anon_pgoff_addr() - Calculates the absolute anonymous page offset of
+ * @address.
+ * @vma: The VMA whose anonymous page offset is required.
+ * @address: The address whose absolute page offset is required.
+ *
+ * If the VMA is a shared file-backed mapping, then the file-based page offset
+ * is returned.
+ *
+ * Otherwise, the virtual page offset is returned.
+ *
+ * This means that shared file-backed mappings are correctly merged based on
+ * their file page offset compatibility.
+ *
+ * Returns: The absolute anonymous page offset of @address within @vma.
+ */
+static inline pgoff_t vma_anon_pgoff_addr(const struct vm_area_struct *vma,
+					  unsigned long address)
+{
+	if (vma_test(vma, VMA_SHARED_BIT))
+		return linear_page_index(vma, address);
+
+	return linear_virt_page_index(vma, address);
+}
+
+/**
+ * vma_start_anon_pgoff() - Calculates the absolute anonymous page offset used
+ * for purposes of merge compatibility.
+ * @vma: The VMA whose anonymous page offset is required.
+ *
+ * See vma_anon_pgoff_addr().
+ *
+ * Returns: The absolute anonymous page offset of @vma for purposes of merging.
+ */
+static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_anon_pgoff_addr(vma, vma->vm_start);
 }
 
-#define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
+/**
+ * vma_end_anon_pgoff() - Calculates the absolute exclusive end anonymous page
+ * offset used for purposes of merge compatibility.
+ * @vma: The VMA whosse anonymous end page offset is required.
+ *
+ * See vma_start_anon_pgoff().
+ *
+ * Returns: The absolute exclusive end anonymous page offset of @vma for
+ * purposes of merging.
+ */
+static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_anon_pgoff(vma) + vma_pages(vma);
+}
+
+#define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_, anon_pgoff_) \
+	struct vma_merge_struct name = {					  \
+		.mm = mm_,							  \
+		.vmi = vmi_,							  \
+		.start = start_,						  \
+		.end = end_,							  \
+		.vma_flags = vma_flags_,					  \
+		.pgoff = pgoff_,						  \
+		.anon_pgoff = anon_pgoff_,					  \
+		.state = VMA_MERGE_START,					  \
+	}
+
+#define VMG_VMA_STATE(name, vmi_, prev_, vma_, start_, end_)		\
 	struct vma_merge_struct name = {				\
-		.mm = mm_,						\
+		.mm = vma_->vm_mm,					\
 		.vmi = vmi_,						\
+		.prev = prev_,						\
+		.middle = vma_,						\
+		.next = NULL,						\
 		.start = start_,					\
 		.end = end_,						\
-		.vma_flags = vma_flags_,				\
-		.pgoff = pgoff_,					\
+		.vm_flags = vma_->vm_flags,				\
+		.pgoff = linear_page_index(vma_, start_),		\
+		.anon_pgoff = vma_anon_pgoff_addr(vma_, start_),	\
+		.file = vma_->vm_file,					\
+		.anon_vma = vma_->anon_vma,				\
+		.policy = vma_policy(vma_),				\
+		.uffd_ctx = vma_->vm_userfaultfd_ctx,			\
+		.anon_name = anon_vma_name(vma_),			\
 		.state = VMA_MERGE_START,				\
 	}
 
-#define VMG_VMA_STATE(name, vmi_, prev_, vma_, start_, end_)	\
-	struct vma_merge_struct name = {			\
-		.mm = vma_->vm_mm,				\
-		.vmi = vmi_,					\
-		.prev = prev_,					\
-		.middle = vma_,					\
-		.next = NULL,					\
-		.start = start_,				\
-		.end = end_,					\
-		.vm_flags = vma_->vm_flags,			\
-		.pgoff = linear_page_index(vma_, start_),	\
-		.file = vma_->vm_file,				\
-		.anon_vma = vma_->anon_vma,			\
-		.policy = vma_policy(vma_),			\
-		.uffd_ctx = vma_->vm_userfaultfd_ctx,		\
-		.anon_name = anon_vma_name(vma_),		\
-		.state = VMA_MERGE_START,			\
-	}
-
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
 void validate_mm(struct mm_struct *mm);
 #else
@@ -501,7 +570,7 @@ void unlink_file_vma_batch_add(struct unlink_vma_file_batch *vb,
 
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	bool *need_rmap_locks);
+	pgoff_t anon_pgoff, bool *need_rmap_locks);
 
 struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma);
 
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index c0f7ba2cfb27..0b15805160fb 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -41,7 +41,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	unsigned long new_end = old_end - shift;
 	VMA_ITERATOR(vmi, mm, new_start);
 	VMG_STATE(vmg, mm, &vmi, new_start, old_end, EMPTY_VMA_FLAGS,
-		  vma_start_pgoff(vma));
+		  vma_start_pgoff(vma), vma_start_anon_pgoff(vma));
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
diff --git a/tools/testing/vma/shared.c b/tools/testing/vma/shared.c
index bea9ea6db02a..f410bb6f858e 100644
--- a/tools/testing/vma/shared.c
+++ b/tools/testing/vma/shared.c
@@ -23,7 +23,8 @@ struct vm_area_struct *alloc_vma(struct mm_struct *mm,
 
 	vma->vm_start = start;
 	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
+	vma_set_pgoff(vma, pgoff);
+	vma_set_virt_pgoff(vma, start >> PAGE_SHIFT);
 	vma->flags = vma_flags;
 	vma_assert_detached(vma);
 
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index 04704d6eb426..ed8fa0d7da97 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -45,6 +45,7 @@ void vmg_set_range(struct vma_merge_struct *vmg, unsigned long start,
 	vmg->start = start;
 	vmg->end = end;
 	vmg->pgoff = pgoff;
+	vmg->anon_pgoff = start >> PAGE_SHIFT;
 	vmg->vma_flags = vma_flags;
 
 	vmg->just_expand = false;
@@ -108,6 +109,7 @@ static bool test_simple_merge(void)
 		.end = 0x2000,
 		.vma_flags = vma_flags,
 		.pgoff = 1,
+		.anon_pgoff = 1,
 	};
 
 	ASSERT_FALSE(attach_vma(&mm, vma_left));
@@ -1431,7 +1433,7 @@ static bool test_expand_only_mode(void)
 	struct mm_struct mm = {};
 	VMA_ITERATOR(vmi, &mm, 0);
 	struct vm_area_struct *vma_prev, *vma;
-	VMG_STATE(vmg, &mm, &vmi, 0x5000, 0x9000, vma_flags, 5);
+	VMG_STATE(vmg, &mm, &vmi, 0x5000, 0x9000, vma_flags, 5, 5);
 
 	/*
 	 * Place a VMA prior to the one we're expanding so we assert that we do
diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 754a2da06321..7ca5289e0f95 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -38,7 +38,7 @@ static bool test_copy_vma(void)
 	/* Move backwards and do not merge. */
 
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x5000, 3, vma_flags);
-	vma_new = copy_vma(&vma, 0, 0x2000, 0, &need_locks);
+	vma_new = copy_vma(&vma, 0, 0x2000, 0, 3, &need_locks);
 	ASSERT_NE(vma_new, vma);
 	ASSERT_EQ(vma_new->vm_start, 0);
 	ASSERT_EQ(vma_new->vm_end, 0x2000);
@@ -51,7 +51,7 @@ static bool test_copy_vma(void)
 
 	vma = alloc_and_link_vma(&mm, 0, 0x2000, 0, vma_flags);
 	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x8000, 6, vma_flags);
-	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, &need_locks);
+	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, 4, &need_locks);
 	vma_assert_attached(vma_new);
 
 	ASSERT_EQ(vma_new, vma_next);
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index e12ab2c80f95..f197312adb77 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -53,6 +53,7 @@ typedef __bitwise unsigned int vm_fault_t;
 
 #define VM_WARN_ON(_expr) (WARN_ON(_expr))
 #define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
+#define VM_WARN_ON_ONCE_VMA(_expr, _vma) (WARN_ON_ONCE(_expr))
 #define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
-- 
2.54.0


