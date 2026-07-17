Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4818C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E275B6B00D0; Fri, 17 Jul 2026 14:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF60A6B00D2; Fri, 17 Jul 2026 14:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5AE6B00D3; Fri, 17 Jul 2026 14:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97E246B00D0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:23:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 282AF40208
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:37 +0000 (UTC)
X-FDA: 84999091674.20.068D8BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 705D940004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmE5lYer;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312615;
	b=OzF7gcwUmsgtgVcYNrS07Y67NGq38caylqw9zzh37LURH4Tt3tIWhpZ1utXfbMm+0PO+9U
	0L7jrlshKJWRNL2MUypZ4jXqJmLihvkJsVoFymL59VVcKWNTaUrNdEQ+iqvK3xFn6Rc0z3
	5Gkss9Ab+Rd06uHQeESTMA3GYmxKdQY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmE5lYer;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THcSTCW+eH3M326ttZSOcln1sIFibD7ABxlX6LgmtOs=;
	b=3lLwJIbRIolMW+lim5CLzLZUJ+O1ZNPbTNA55gyIx3ZhiE/4UyOj93khWY9ZomZX+NnYgV
	DvtGrXyEO9+PzeeCMbmEq+0yA9jSRwmQs07bELH81H24ovyuFpLw1q6Hcox2G3dQpTiR+X
	M6UCTVZ7tZarRUSb/NCjXxsLnyx/TkU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C246B60A74;
	Fri, 17 Jul 2026 18:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2201F000E9;
	Fri, 17 Jul 2026 18:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312614;
	bh=THcSTCW+eH3M326ttZSOcln1sIFibD7ABxlX6LgmtOs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dmE5lYerIgZlq5rUsfess6SgtAzDQjiz+vmhBsj9u0sgXzson+piHCvZjmwwkCIry
	 rpM6SwHqZiqpHrN9sIx83cI60ZK1oPD6oX/pzpFtMc4W4yNFtjEV1HG3ai3WJQZbw/
	 lsL2av1Yu6aUVFzs6xrCndBa0FTTIulWTrXCq6GjbeOkl6OTreNYCjFndDGxhsZXGD
	 CPwcvnY+ezL2LQh+u1QclXrR6QF2NkIn0bnquRAUxmW6DS4ukP2HnLO/fXqMO/BzKL
	 oOfxBZCo+iQeS3kdRVLPbSV7Ail+2aHQN1d2pxplUOCBmUJPEUnKmp1z0O5yQmy9Vy
	 OQgE1nxOhqMXg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:47 +0100
Subject: [PATCH 09/15] mm/rmap: use virt pgoff for MAP_PRIVATE file-backed
 anon folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-9-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=11839; i=ljs@kernel.org;
 h=from:subject:message-id; bh=trcZDCZGb1+fFeGFvg3327sbE4yWDvlmUSh3MOsJRQI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivZ57q9ZtbpYadn2wNNMB1ZMz+gWNhc8INM87cKPl
 q2ncrw3dpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiwocY/lmJpbyIu7O3NePD
 9kOTl6ekpsWse60rU5g/bV++GWNX2DaGfyZR10XCerSXrp0T+0I9QNix8K6rX6Ko6rr9amsEN0/
 y4gEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 705D940004
X-Stat-Signature: w7xw4z3tx4ioi75ozhr73jb8udfgxmgq
X-HE-Tag: 1784312615-383319
X-HE-Meta: U2FsdGVkX19kLP3pY17WIy6dWTWB6oIwInj/fsW1dB6DSIaOHqCT/NHg3tZ3V3TJ5IeZaPIAi1xJ5v5TW75xdvXBRP2sgh80pzNTGiDne02zfEi7czwVzb7ig5PsGR7K+BLoJ8fYqxoAT8eBWGeY1LmrL4g3jYc0TPlougnhhmK4uCOvPrM+FYQC+mwNABjB4HbI2GlAPQ2fJleHqty5SlqKCo1P+vUqLb8NcJhmdsb/7EaKJOQo4t5uespLdGIGbBxGm3cDNXgq4HjiORT8+wJUw10CdUk4h+SU1vBSZNnVIqRxSSUOfFj+9BrLX5GOxKrc8RHlzNTk3NqYSq5WOC/HNqKWnckqdJ6BgNWBSeV5bnK9c5XvQ9Pf/fVVCqk9mxT9Mq1g6MIDI/FTKzFITMyCv54BX8Tn1gwdBDw1HFfjovc+w+NNdntyiGhgklm6M3eBuI7LqI8UzDh31xf5CbpbvQxuMtekVKzlUGcIggewO1domHCm3CM+D+faskV7NY7INCHtAvzTjyuxwLuVhFnoin8naE/O1btHWFfhHbQnkk/bXGZKpNQwoISxyPugx9sNvNGHYV0jaDXCFn3EEvbjGrs0jMr7AG03fawS/ZlMtzgHJ4b2ahEYzpGv1Qe9OpWENMsZF2diSZooMQ2rwtNXG4TouynRFDmS5Rf7HIR6ayA2Pq/kiKjmPBBkq3Uc7hw8Wmn8mkIEugoRK1tdQPc98TuiLzbELAtEfCdwkHjCB0wk6tyEKI5MHc95WMfMbOJR27GlqDxIlBY/cXSQRxZHgEQ8iEsgvycPsC4cSjA5iJ48o7rlD0tu8izE9G0G3TpuZZLhpk9TanshKTI/A5mVNY2Pm2kocz11HkX054CHNenoCs+VwoxEhCsbeH2iJEQ6vUNbxCxZZ7lIdAmdC6CzAnVRG2HIdmVKKnYDJO/C/BlA+1ocgKLecB6kp7S4KUjSMxBOv15izBH66JS
 H1kRUe/I
 ovWgO+JOYej6aU8JbyfJuL8rcNbU8t4OUHcD1JJIbT/vGc1e4ezujZML8BqLGfWGYLNL2t76nyXgk9QnAQYwJPuEa8MEDpydyyMw+4kWwq33daTXlfLCEsOWte55btg4olqQj7iwdJCeYgP9lwsKas2VfEE0OwbgQRR/tKziCso4DnMTyoGRcbknN0pDLZnICShVqRFTPlvTy/7LmCNLUnZb9r+QC0F36jFGrtsgl5aRBTMMNBSZBh7PU9vymLMh99SoNWNyZAdQlsX6GZb+nUz2lLQ82AwlmGFZ7jiVezCHnbmGM6ZzNCGjEp9IWgCS/+usgB5g/zl7S/cNMkp01ihVOQjXmAyWcHzmPmEayrXMvdptUsdOQ+tiH3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, anonymous folios belonging to CoW'd MAP_PRIVATE file-backed
mappings are indexed by their page offset within the file in which they
were originally mapped.

This differs from anonymous folios belonging to pure anon mappings which
are indexed by their virtual page offset (the address at which they'd
belong in the VMA when first faulted).

This change fixes this inconsistency, always indexing anonymous folios by
their virtual page offset regardless of the VMA to which they belong.

We have laid the foundations for making this change to the point where we
need only 'switch it on', and this patch switches it on by:

* Using linear_virt_page_index() in __folio_set_anon() to assign the
  folio's index to the anonymous linear index rather than the file-backed
  one.

* Otherwise using linear_virt_page_index() in all instances where
  anonymous folios are being referenced or manipulated.

* Replacing vma_address() with vma_filebacked_address() or
  vma_anon_address() as appropriate.

* Updating the rmap lock logic in copy_vma() to also account for virtual
  page offsets.

* Updating the merging logic to check that virtual page offsets are
  aligned as well as filebacked ones for anonymous or MAP_PRIVATE
  file-backed VMAs.

* Updating linear_folio_page_index() to invoke linear_virt_page_index()
  if the folio is anonymous.

* Correcting folio_within_range() to use virtual page offset for anonymous
  folios.

This will have no impact on merging of anonymous VMAs or shared file-backed
VMAs, whose page offset and anonymous page offset will be identical.

However, MAP_PRIVATE file-backed mappings must now be aligned on virtual
page offset as well.

In most instances this should have no impact on merging of file-backed
mappings, which are usually not merged all that often, let alone
MAP_PRIVATE mapped ones, and rarely remapped and faulted before being moved
back in place (the case in which a merge may now fail).

This change lays the foundations for future scalable CoW work which needs
to track at least some remaps.

This change means that most remap tracking can be avoided, and in nearly
all cases the anonymous page offset can be used to quickly find the VMA in
an mm.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/pagemap.h |  9 ++++++++-
 mm/internal.h           | 28 +++++++++-------------------
 mm/interval_tree.c      |  4 ++--
 mm/ksm.c                |  7 ++++---
 mm/page_vma_mapped.c    |  2 +-
 mm/rmap.c               | 12 ++++++------
 mm/vma.c                | 14 ++++++++++++--
 7 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index dab355eda0ef..90130f28e7a8 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1149,7 +1149,11 @@ static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
  * @vma: The VMA in which @address resides.
  * @address: The address whose absolute page offset is required.
  *
- * For compatibility, currently identical to linear_page_index().
+ * Determines whether to obtain the virtual linear page index based on whether
+ * @folio is anonymous or not.
+ *
+ * See the descriptions of linear_virt_page_index() and linear_page_index() for
+ * details of each.
  *
  * Returns: The absolute page offset of @address within @vma.
  */
@@ -1157,6 +1161,9 @@ static inline pgoff_t linear_folio_page_index(const struct folio *folio,
 					      const struct vm_area_struct *vma,
 					      const unsigned long address)
 {
+	if (folio_test_anon(folio))
+		return linear_virt_page_index(vma, address);
+
 	return linear_page_index(vma, address);
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 7ed8bde7890d..22f63cb85bd3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -933,7 +933,8 @@ folio_within_range(struct folio *folio, struct vm_area_struct *vma,
 		return false;
 
 	pgoff_folio = folio_pgoff(folio);
-	pgoff_vma_start = vma_start_pgoff(vma);
+	pgoff_vma_start = folio_test_anon(folio) ?
+		vma_start_virt_pgoff(vma) : vma_start_pgoff(vma);
 
 	if (start < vma->vm_start)
 		start = vma->vm_start;
@@ -1044,23 +1045,8 @@ static inline unsigned long vma_filebacked_address(const struct vm_area_struct *
 }
 
 /**
- * vma_address - Find the virtual address a page range is mapped at.
- * @vma: The vma which maps this object.
- * @pgoff: The page offset within its object.
- * @nr_pages: The number of pages to consider.
- *
- * If any page in this range is mapped by this VMA, return the first address
- * where any of these pages appear.  Otherwise, return -EFAULT.
- */
-static inline unsigned long vma_address(const struct vm_area_struct *vma,
-		pgoff_t pgoff, unsigned long nr_pages)
-{
-	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
-}
-
-/**
- * vma_anon_address - Find the address an anonymous folio with index @pgoff_virt
- * is mapped at.
+ * vma_anon_address - Find the virtual address an anonymous page range is mapped
+ * at.
  * @vma: The vma which maps this object.
  * @pgoff_virt: The virtual page index belonging to the folio.
  * @nr_pages: The number of pages to consider.
@@ -1094,7 +1080,11 @@ static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
 	if (pvmw->nr_pages == 1)
 		return pvmw->address + PAGE_SIZE;
 
-	pgoff_vma_start = vma_start_pgoff(vma);
+	if (pvmw->is_anon_walk)
+		pgoff_vma_start = vma_start_virt_pgoff(vma);
+	else
+		pgoff_vma_start = vma_start_pgoff(vma);
+
 	pgoff_end = pgoff + pvmw->nr_pages;
 	address = vma->vm_start +
 		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 3ae9e106d3af..26b8437e3b1b 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -83,12 +83,12 @@ mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 
 static pgoff_t avc_start_pgoff(struct anon_vma_chain *avc)
 {
-	return vma_start_pgoff(avc->vma);
+	return vma_start_virt_pgoff(avc->vma);
 }
 
 static pgoff_t avc_last_pgoff(struct anon_vma_chain *avc)
 {
-	return vma_last_pgoff(avc->vma);
+	return vma_last_virt_pgoff(avc->vma);
 }
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, pgoff_t, rb_subtree_last,
diff --git a/mm/ksm.c b/mm/ksm.c
index 47006f494fcb..b9b32f7bfb69 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1625,7 +1625,8 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	 * stable_tree, break_cow() will clean it up.
 	 */
 	rmap_item->anon_vma = vma->anon_vma;
-	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
+	/* The VMA is always anon/MAP_PRIVATE-file backed so use anon index. */
+	rmap_item->linear_page_index = linear_virt_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
@@ -3152,7 +3153,7 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
 			return folio;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return folio;		/* no need to copy it */
-	} else if (folio->index == linear_page_index(vma, addr) &&
+	} else if (folio->index == linear_virt_page_index(vma, addr) &&
 			anon_vma->root == vma->anon_vma->root) {
 		return folio;		/* still no need to copy it */
 	}
@@ -3222,7 +3223,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		/*
 		 * Currently, KSM folios are always small folios, so it's
 		 * sufficient to search for a single page. We can simply use
-		 * the linear_page_index of the original de-duplicate
+		 * the linear_virt_page_index of the original de-duplicate
 		 * anonymous page that we remembered in the rmap_item while
 		 * de-duplicating. Note that mremap() always de-duplicates KSM
 		 * folios: so if there was mremap() in our parent or our child,
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 081e483cc7bf..4e964545e5e8 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -365,7 +365,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
 	};
 
 	if (folio_test_anon(folio))
-		pvmw.address = vma_address(vma, pgoff, 1);
+		pvmw.address = vma_anon_address(vma, pgoff, 1);
 	else
 		pvmw.address = vma_filebacked_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
diff --git a/mm/rmap.c b/mm/rmap.c
index cfd4195ff1ae..6854baf4b877 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -866,7 +866,7 @@ unsigned long page_address_in_vma(const struct folio *folio,
 		    vma->anon_vma->root != anon_vma->root)
 			return -EFAULT;
 		/* KSM folios don't reach here because of the !anon_vma check */
-		return vma_address(vma, page_pgoff(folio, page), 1);
+		return vma_anon_address(vma, page_pgoff(folio, page), 1);
 	} else if (!vma->vm_file) {
 		return -EFAULT;
 	} else if (vma->vm_file->f_mapping != folio->mapping) {
@@ -1486,7 +1486,7 @@ static void __folio_set_anon(struct folio *folio, struct vm_area_struct *vma,
 	 */
 	anon_vma = (void *) anon_vma + FOLIO_MAPPING_ANON;
 	WRITE_ONCE(folio->mapping, (struct address_space *) anon_vma);
-	folio->index = linear_page_index(vma, address);
+	folio->index = linear_virt_page_index(vma, address);
 }
 
 /**
@@ -1513,8 +1513,8 @@ static void __page_check_anon_rmap(const struct folio *folio,
 	 */
 	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
 			folio);
-	VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address),
-		       page);
+	VM_BUG_ON_PAGE(page_pgoff(folio, page) !=
+		       linear_virt_page_index(vma, address), page);
 }
 
 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
@@ -3041,10 +3041,10 @@ static void rmap_walk_anon(struct folio *folio,
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
 	anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
-		unsigned long address = vma_address(vma, pgoff_start,
+		const unsigned long address = vma_anon_address(vma, pgoff_start,
 				folio_nr_pages(folio));
 
-		VM_BUG_ON_VMA(address == -EFAULT, vma);
+		VM_WARN_ON_ONCE_VMA(address == -EFAULT, vma);
 		cond_resched();
 
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
diff --git a/mm/vma.c b/mm/vma.c
index e45d43493446..6dc095d03382 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -233,6 +233,8 @@ static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 		return false;
 	if (vmg_end_pgoff(vmg) != vma_start_pgoff(vmg->next))
 		return false;
+	if (vmg_end_anon_pgoff(vmg) != vma_start_anon_pgoff(vmg->next))
+		return false;
 	return true;
 }
 
@@ -253,6 +255,8 @@ static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 		return false;
 	if (vma_end_pgoff(vmg->prev) != vmg_start_pgoff(vmg))
 		return false;
+	if (vma_end_anon_pgoff(vmg->prev) != vmg_start_anon_pgoff(vmg))
+		return false;
 	return true;
 }
 
@@ -1988,7 +1992,8 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 			*vmap = vma = new_vma;
 		}
 		*need_rmap_locks =
-			(vma_start_pgoff(new_vma) <= vma_start_pgoff(vma));
+			(vma_start_pgoff(new_vma) <= vma_start_pgoff(vma)) ||
+			(vma_start_anon_pgoff(new_vma) <= vma_start_anon_pgoff(vma));
 	} else {
 		new_vma = vm_area_dup(vma);
 		if (!new_vma)
@@ -2059,7 +2064,12 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
 	if (!vma_flags_empty(&diff))
 		return false;
 	/* Page offset must align. */
-	return vma_end_pgoff(a) == vma_start_pgoff(b);
+	if (vma_end_pgoff(a) != vma_start_pgoff(b))
+		return false;
+	/* Anon page offset must align. */
+	if (vma_end_anon_pgoff(a) != vma_start_anon_pgoff(b))
+		return false;
+	return true;
 }
 
 /*

-- 
2.55.0


