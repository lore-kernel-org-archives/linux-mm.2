Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04E2C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55626B00A1; Wed, 29 Jul 2026 12:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2CF16B00A2; Wed, 29 Jul 2026 12:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B296B00A3; Wed, 29 Jul 2026 12:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 659F66B00A1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:50:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03BEE160720
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:18 +0000 (UTC)
X-FDA: 85042402158.10.53DBE88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 47471A000F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nK/axHco";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRSww5Qg30YQCZbAx3SNrNZapKTkou0L0P9ImtT0p7Y=;
	b=HhqV8JMMpWDzoY549/Hvw4eLfPJNt8puOsPnAkcFm6A6bMa3eMlh6xA09EghjYBxMY7psP
	tzHm0KDBGPtpzpbjp5HouMQNFyx+0Y7DFgmHTFHyHULzY0F+iFgiNBTQo/rgtZFmjYzb90
	84HwgKLTkQJ2ZDpw+65EvWnMSnV8ssI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nK/axHco";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343817;
	b=jgg859IyEfLLqTd+09de5SaAd1dxfkCcRQI//nQyOJG6Lu9o8TjcDci9IkL7kTe1maBXtq
	8sXWlojNHsVfaaVU/2EkY+rhxL0KuClXxExO+hpAAugXnOUkgrZfRjwTcM8JI1oqjCiRCt
	/pZ3zSO14dtjQ5zqcJN7uYNi4W22l8A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAD6C6011F;
	Wed, 29 Jul 2026 16:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493641F00A3F;
	Wed, 29 Jul 2026 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343816;
	bh=nRSww5Qg30YQCZbAx3SNrNZapKTkou0L0P9ImtT0p7Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nK/axHcoXCIKOfwVrGUDiFrahCgX5ZudQAG/9s+NRu53VtKMR0F//i58ksmuFsBCV
	 RHimzRyCXS+Y5mJaK+i2tgO+/EhhrscbgvqsMi/uZ+NeuiNGBfZbT/QI4uCsJ/4mox
	 E71Xb5Cmk6aUEYLOtpgMm4awVtosJ/zmDK8D10OazjykaBVSFNgdJyTNzPjqQcQMzw
	 Ms+LprVXkwFFH8lYOu8N1aDOIM7MmC9SZQM/FaHi+B+tdtZMEho5jfnKZIr+Mk85sc
	 2HRHNNGfG9y7Vnk4KUuzlLWvJ8AY/e8p+/IOB11VZhPxW+8U3BBcAGiJyUCjzUHQwo
	 ijalC6kTPEHsQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:44 +0100
Subject: [PATCH v3 09/15] mm/rmap: use anon pgoff to track MAP_PRIVATE
 file-backed anon folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-9-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13594; i=ljs@kernel.org;
 h=from:subject:message-id; bh=YOxOTVAE1Y17Ds9xq4xtjYnVmtp/Ag2j4OHAl5AJnwQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H7mfbOYf/bHr52ve+tSZ52ckKnNVXfIt7lZ+eLMK
 RyGZXcCO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRY2cZGX7fsdJJlLvZe3Tv
 1cuXvi3uLTNevLbfQelMp5aR2c+XR94xMlyfaXppn/VK7q6o55e5Tyw7abA373j49PeXCu7u+fX
 gaRI7AA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 47471A000F
X-Stat-Signature: q14ugo5kj8sfkns6a4uoi9pu6i19ac3x
X-HE-Tag: 1785343817-590873
X-HE-Meta: U2FsdGVkX1+CQ7saUw78QD5M1k9EF4D7nIjMSinBbT/yDgOXDqWwhnYYtE1OD0mfZSqaHqiLqp5GFazCkySUaqMgBRnr9tZO+/dn5jTrjp8gk9unf3I9pLdfW5tpKBFs8xlDnEqWFjqi33lIHyvmxsJgSP0O50VGER4N/Yk9eliCFyv6sn+RoIXMopEJHQIZzepWugr1dQTZ3b9cpwOa3u7eo8Fxo1Ny8rsD0NGGO8JrwrR4kJLlJxuOSqiZpPUDc/W+8UjvxBfTfewUD7qKElSSeYOPSU3Y9YysQAGJJsDgfo6VpvTyWmXlg9C3zfA0bc2ZW5zqmT7MEFDSYNihoAVEiHSDmr2qAeFjPdqJXDfiv4Z6E854w444Ok/TFZOHBHbluP1Arxxqd5c72GmAclYf7Tw/w4CfxA0kClyJ8LsIM55wJI4M0SM3CQdTJP99rRfagxs0LxOMDewETzJknMidNeLngKiKeGnJ2PvbmxfrQtccfs+sP9xfsU9T539WYdclN0iNZUpo5kyg0+F1VPNShisbvWNat5kveiVteagfdatSHogFbR9QYenJqRWONFXhcQgvA2s5Gn7b0Lzd3p4h60tKOwj5Me/mZ/JZXhGQOcylH9ILTj0M3RLprnBek+jGo4NSDd0EuQ6glNrHakm5+OilkufytGrW5YJ1Y1Q05tZiqnkMagBav/rz/jJYM/sFMRHqcBWAPbPL7Xf40SanhZy8umated2F/t+wyh5GF7DcCpQBFjy74LkFdPVuKzVHwu/B1HrbZXtAt5A3HFE/4vN8+UZ2yD4OdoXLJbBF1yiWH7xpvwfyR4BxNGnF/U4MlkMIfdKb5jGatcCovkHQML/p7mRJ/9uFn3UL1viQO6xTojWi2ubGNeBfPj6OrPPIegT+Hc4OnoqE12kLY1iSUir51lBtPEQYwPnWm4oAEyvHpmU7SLjF6/Ydyd6YzgWfGaZOy1U3X2L9nef
 rFOZr/0Z
 aU85Bxi0nUgfG/L21KDc6CJAYPVxqvt/WCtB4+MZuFu2vaxjW3/cuE1igF1kyO2pWfxEWo4SrUXVMdYSNhQsgRbI3FGNNHeVUzy4544owj1rCvWfXUo7HVgHyMzJ/fzu2voaZHolmmvKZraT1eSJZPN1S/GcHoqkwYd6vRvrn5qjeceAXw0Pod44S60KkW+mqDo/MbAFyZubRCtsusDYWTvHu2NUInFO2/F62LcCOEURE2IwsfGhfHtumk3wvENPy96/J7lVSue6fD6N9hZi9rKN/l5xOAqHASEMBaU2VJuSfLTyuzb9FYgtlEu/qTw+U7Cc+GCNyEZMJnqvHZxz8R8CzNluArSOOtt5nQCN8AhhfzeQ66OA+Rk8BmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently anonymous folios belonging to CoW'd MAP_PRIVATE file-backed
mappings are indexed by their page offset within the file in which they
were originally mapped.

This differs from anonymous folios belonging to pure anon mappings which
are indexed by their anonymous page offset (the address at which they'd
belong in the VMA when first faulted).

This change fixes this inconsistency, always indexing anonymous folios by
their anonymous page offset regardless of the VMA to which they belong.

The foundations have been laid such that we need only switch this
functionality on such by:

* Using linear_anon_page_index() in __folio_set_anon() to assign the
  folio's index to the anonymous linear index rather than the file-backed
  one.

* Otherwise using linear_anon_page_index() in all instances where
  anonymous folios are being referenced or manipulated.

* Replacing vma_address() with vma_filebacked_address() or
  vma_anon_address() as appropriate.

* Updating the merging logic to check that anonymous page offsets are
  aligned as well as filebacked ones for MAP_PRIVATE file-backed VMAs,
  introducing needs_adjacent_anon_pgoff() to figure out when this is
  required.

* Updating linear_folio_page_index() to invoke linear_anon_page_index()
  if the folio is anonymous.

* Updating vma_address_end() to use the VMA's anonymous page offset when
  pvmw->pgoff is anonymous.

* Correcting folio_within_range() to use anonymous page offset for
  anonymous folios.

This will have no impact on merging of anonymous VMAs, whose page offset
and anonymous page offset are identical, nor will it impact shared
file-backed VMAs, which will continue to be merged based on the file-backed
page offset.

However, MAP_PRIVATE file-backed mappings must now be aligned on anonymous
page offset as well.

In most instances this should have no impact on merging of file-backed
mappings, which are usually not merged all that often, let alone
MAP_PRIVATE mapped ones, and rarely remapped and faulted before being moved
back in place (the case in which a merge may now fail).

One subtle impact of this change is in NUMA interleaving - since commit
88c91dc58582 ("mempolicy: migration attempt to match interleave nodes"),
migration heuristically tries to maintain interleaving behaviour matching
the policy using folio indices.

When doing migration of CoW'd MAP_PRIVATE-file backed ranges, the 'base'
upon which the interleaving behaviour is performed will vary for these
ranges. However the commit notes that ranges spanning multiple VMAs will
already cause varying bases, and that this is an acceptable approximation.

It is very unlikely real world use-cases will be impacted by
this (MAP_PRIVATE file-backed mappings are already an edge case), and all
that will happen is that such ranges will cause interleaving to be rotated
over the CoW'd range, with little to no impact.

This commit lays the foundations for future scalable CoW work which needs
to track some remaps, meaning that most remap tracking can be avoided, and
in nearly all cases the anonymous page offset will be able to be used to
quickly find the VMA in an mm.

Note that the need_rmap_locks check doesn't need to be updated, as any
remapping will offset both the anonymous and file-backed page offset, so it
suffices to check only one.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/pagemap.h |  9 ++++++++-
 mm/internal.h           | 28 +++++++++-------------------
 mm/interval_tree.c      |  4 ++--
 mm/ksm.c                |  7 ++++---
 mm/page_vma_mapped.c    |  2 +-
 mm/rmap.c               | 12 ++++++------
 mm/vma.c                | 28 +++++++++++++++++++++++++++-
 7 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 6eb8d811ba4c..939b8850df49 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1150,7 +1150,11 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
  * @vma: The VMA in which @address resides.
  * @address: The address whose absolute page offset is required.
  *
- * For compatibility, currently identical to linear_page_index().
+ * Determines whether to obtain the anonymous linear page index based on
+ * whether @folio is anonymous or not.
+ *
+ * See the descriptions of linear_anon_page_index() and linear_page_index() for
+ * details of each.
  *
  * Returns: The absolute page offset of @address within @vma.
  */
@@ -1158,6 +1162,9 @@ static inline pgoff_t linear_folio_page_index(const struct folio *folio,
 					      const struct vm_area_struct *vma,
 					      const unsigned long address)
 {
+	if (folio_test_anon(folio))
+		return linear_anon_page_index(vma, address);
+
 	return linear_page_index(vma, address);
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index fbfa68d8ecc3..47f87a256405 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -933,7 +933,8 @@ folio_within_range(struct folio *folio, struct vm_area_struct *vma,
 		return false;
 
 	pgoff_folio = folio_pgoff(folio);
-	pgoff_vma_start = vma_start_pgoff(vma);
+	pgoff_vma_start = folio_test_anon(folio) ?
+		vma_start_anon_pgoff(vma) : vma_start_pgoff(vma);
 
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
- * vma_anon_address - Find the address an anonymous folio with index @pgoff_anon
- * is mapped at.
+ * vma_anon_address - Find the virtual address an anonymous page range is mapped
+ * at.
  * @vma: The vma which maps this object.
  * @pgoff_anon: The anonymous page index belonging to the folio.
  * @nr_pages: The number of pages to consider.
@@ -1094,7 +1080,11 @@ static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
 	if (pvmw->nr_pages == 1)
 		return pvmw->address + PAGE_SIZE;
 
-	pgoff_vma_start = vma_start_pgoff(vma);
+	if (pvmw->pgoff_is_anon)
+		pgoff_vma_start = vma_start_anon_pgoff(vma);
+	else
+		pgoff_vma_start = vma_start_pgoff(vma);
+
 	pgoff_end = pgoff + pvmw->nr_pages;
 	address = vma->vm_start +
 		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 3ae9e106d3af..7bbbf15cfbf0 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -83,12 +83,12 @@ mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 
 static pgoff_t avc_start_pgoff(struct anon_vma_chain *avc)
 {
-	return vma_start_pgoff(avc->vma);
+	return vma_start_anon_pgoff(avc->vma);
 }
 
 static pgoff_t avc_last_pgoff(struct anon_vma_chain *avc)
 {
-	return vma_last_pgoff(avc->vma);
+	return vma_last_anon_pgoff(avc->vma);
 }
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, pgoff_t, rb_subtree_last,
diff --git a/mm/ksm.c b/mm/ksm.c
index 47006f494fcb..7a3f75fc8af0 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1625,7 +1625,8 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	 * stable_tree, break_cow() will clean it up.
 	 */
 	rmap_item->anon_vma = vma->anon_vma;
-	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
+	/* The VMA is always anon/MAP_PRIVATE-file backed so use anon index. */
+	rmap_item->linear_page_index = linear_anon_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
@@ -3152,7 +3153,7 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
 			return folio;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return folio;		/* no need to copy it */
-	} else if (folio->index == linear_page_index(vma, addr) &&
+	} else if (folio->index == linear_anon_page_index(vma, addr) &&
 			anon_vma->root == vma->anon_vma->root) {
 		return folio;		/* still no need to copy it */
 	}
@@ -3222,7 +3223,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		/*
 		 * Currently, KSM folios are always small folios, so it's
 		 * sufficient to search for a single page. We can simply use
-		 * the linear_page_index of the original de-duplicate
+		 * the linear_anon_page_index of the original de-duplicate
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
index ab3f879454de..2a9ae25ae72d 100644
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
@@ -1485,7 +1485,7 @@ static void __folio_set_anon(struct folio *folio, struct vm_area_struct *vma,
 	 */
 	anon_vma = (void *) anon_vma + FOLIO_MAPPING_ANON;
 	WRITE_ONCE(folio->mapping, (struct address_space *) anon_vma);
-	folio->index = linear_page_index(vma, address);
+	folio->index = linear_anon_page_index(vma, address);
 }
 
 /**
@@ -1512,8 +1512,8 @@ static void __page_check_anon_rmap(const struct folio *folio,
 	 */
 	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
 			folio);
-	VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address),
-		       page);
+	VM_BUG_ON_PAGE(page_pgoff(folio, page) !=
+		       linear_anon_page_index(vma, address), page);
 }
 
 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
@@ -3040,10 +3040,10 @@ static void rmap_walk_anon(struct folio *folio,
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
index 91bb1c6160a0..b87fb2a42530 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -204,6 +204,21 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
 		vp->skip_vma_uprobe = true;
 }
 
+/*
+ * Does this merge require that adjacent VMAs must have adjacent anonymous page
+ * offsets in addition to having adjacent vma->vm_pgoff?
+ *
+ * This is only required for MAP_PRIVATE-file backed mappings as the page offset
+ * for pure anonymous VMAs is equal to the anonymous page offset.
+ *
+ * 'Special' mappings in the sense of VDSO, VVAR etc. have !file but would in
+ * any case not be candidates for merge nor be mergeable.
+ */
+static bool needs_adjacent_anon_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg->file && !vma_flags_test(&vmg->vma_flags, VMA_SHARED_BIT);
+}
+
 /*
  * Return true if we can merge this (vma_flags,anon_vma,file,vm_pgoff)
  * in front of (at a lower virtual address and file offset than) the vma.
@@ -225,6 +240,9 @@ static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 		return false;
 	if (vmg_end_pgoff(vmg) != vma_start_pgoff(vmg->next))
 		return false;
+	if (needs_adjacent_anon_pgoff(vmg) &&
+	    vmg_end_anon_pgoff(vmg) != vma_start_anon_pgoff(vmg->next))
+		return false;
 	return true;
 }
 
@@ -245,6 +263,9 @@ static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 		return false;
 	if (vma_end_pgoff(vmg->prev) != vmg_start_pgoff(vmg))
 		return false;
+	if (needs_adjacent_anon_pgoff(vmg) &&
+	    vma_end_anon_pgoff(vmg->prev) != vmg_start_anon_pgoff(vmg))
+		return false;
 	return true;
 }
 
@@ -2050,7 +2071,12 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
 	if (!vma_flags_empty(&diff))
 		return false;
 	/* Page offset must align. */
-	return vma_end_pgoff(a) == vma_start_pgoff(b);
+	if (vma_end_pgoff(a) != vma_start_pgoff(b))
+		return false;
+	/* Only reached from anon path, so either MAP_PRIVATE file or anon. */
+	if (vma_end_anon_pgoff(a) != vma_start_anon_pgoff(b))
+		return false;
+	return true;
 }
 
 /*

-- 
2.55.0


