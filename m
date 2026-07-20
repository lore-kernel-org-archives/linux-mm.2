Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D64C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F1F6B00CF; Mon, 20 Jul 2026 10:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06CF6B00D1; Mon, 20 Jul 2026 10:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C276B00D2; Mon, 20 Jul 2026 10:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD746B00CF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:40:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 007D8401E3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:23 +0000 (UTC)
X-FDA: 85009415568.06.01A6A81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1FA08C000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hN+w1Hkd;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxYE2UTk7+vXzgBPO46w2Ku1CD1EMMJUzZ8y+MmTdXs=;
	b=lJMKYrrfSML/vte4GT6YV9qWhkcwkDZeTzRm20ugAuFuuImdW1ucVEmN6KOcgMCObqVFxA
	qfbu9+8UZKaUdU8Qr5ggLwl8BlOWohuz5OJcwNAMeWFMdgstKBtHxpOIGHSidVl/929jqi
	957OnvT+sjAnsVu99Z2is9pHn2Wd/0Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558422;
	b=wh0yK3O28o+qHiSotJv9GolKjT4hBS0GIf3nCu0qjgNAxBfv/Lfei4Zu3Hr983Yjsube1e
	CYujBL4gepaA2Kc4JdpU1r5Bk5+/GEn/wzvUOxF2t1b+bqaEbxnRgS2V/DEukPq8cciVlc
	axVNaeLEBSAOa+yJaOcVB+BWnHx9Ofw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hN+w1Hkd;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6156740997;
	Mon, 20 Jul 2026 14:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725161F000E9;
	Mon, 20 Jul 2026 14:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558421;
	bh=sxYE2UTk7+vXzgBPO46w2Ku1CD1EMMJUzZ8y+MmTdXs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hN+w1HkdyVaVNAaoSv0NJWUKP9SRUDL9STYU9BgeXRl3kkP76UoD637G+sHWJhsso
	 zgpNWClneHtAbeJlsGrd5oL2TZJeSsnkcCFXJuyQFYdGJ2sa3o4R7akFhZDOSPOOVA
	 sbTMABavmH2w9E9CLGvr5UCUpRcFGFKjVn4CmjERlkSFyu8T3vUei0il+xIMjCXHup
	 OBsYM2s0/M80iTx+Sbrh9FoyFjnZ9ZP72qRiodjlU/LoHXteQu+cmYGajWu56rgaN9
	 tTbBkX7OZ6+I/Mw8k/LCaJmMQPJi/wpw7RnPKJSuaqxTRMe8ceCjjZtrvdasVSQN6+
	 1ceGRY17AtJyg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:35 +0100
Subject: [PATCH v2 09/15] mm/rmap: use virt pgoff for MAP_PRIVATE
 file-backed anon folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-9-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12648; i=ljs@kernel.org;
 h=from:subject:message-id; bh=B9+PG+Pwq5W8ARJZ9F5sfN/SC8XK45yd7/GXqUpO56I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN4Uciw/9WLF7shHN5kjex/rz/Ax0GuyvCxqPHnN6
 8+XT8tadJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiP78z/A9UrTwq+bu0/O1u
 x+e1R44I7ctezrQtbOlnmbYN85w25woxMtyX37jcZcnD2nINPpFwn1krNPIuLsiMja5ydl0VaLh
 yCRMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1FA08C000A
X-Stat-Signature: gehn774kznif3ymqcauiei9dakexzb48
X-HE-Tag: 1784558421-422605
X-HE-Meta: U2FsdGVkX194Et+ZKol56eeuJGyUdtOCyo+d4Ce6jX4nSIR6Su/xuBBf/0Q27a0t5PwF9l+mO2AUTJ9tJbakSK3T9xZXsJFYyLXJUZrpyTexgo0eqAC4cC7W1/vyGEOEYXrEY7H3CTLB3Lnv6jLYfUPP8QqTTubXQNzITkuoWXtaxj5tLBtYkhH0kpyhXXQSrFeINC0YBAbnC0qFZu8HcfgfMuYxhG64zyvlDKBHhoDMpWUWvvigAxqRIuaqwJSzdq4giZKs+et5jFt3K6ZK6EbSY22hH0lYEZjrwiwW3phot+ZVwfDIC8ZxKgrB552e78xiIGQVjZC3/IHnJ+hMkpGK93e2r36bKIVghxdrKuUY8mM3gbi57EpzZXUsjaNihp3M9yzI/oaUDPOuAMpePE+IakhDF/T6gc73xlVxkzv/FoTOhifM3GwMfQKVLzsrTuMYS5I8wQ1HWQjPk2LwaFAZiVJ9kdSNzbjuTpTzupGPvPWuayqDISOmA+MIh9ftz7SlVlO9/HVIPa5IjYhPgTuRf7LauQ5w4EAy7dFiEw1qdd6deEt5a6Pey8QsRo+SFz7LB7vFzH7cNQ12GHTRWKNW8DS9Ondz1gkjIUKcxzPu+FJ4pS7nqOeZ+qBZ3OwS9TwAMZOlehkdWjrdQWAm3i1H5xdUC8Ma2j2h/17HWj/gjfNPn8TtrQ2aNVsQTwfJiX3NjKYRqMkpYjUrNSf0rytNvLaEB6cyZjpP057Otw5w5Elm4cQaMiZcpTXsWkufE6HRWokMcCI6y5uyC8V1za3LtEGb0/JKmu3RDJdC3VY5OiIsMxpERXjpY+/C2lFNilUtpUV+jygst8UxV93BNkhHNTiMXq1XYVplI1/gkeFN0hz3b/JmYRa4e1aDFiEXBgCuxchfCoIwhP79u00PsfwR94VBeTwG21UP/Q18LamjSN3OgU6ZHvPWG+MHa004NZQGRDdCknBdcNHrztG
 HAZpxZ+Q
 fP81zYAD/2nBe2JAPtvgIbyOdt6Tqxbx4gQbZqDbH7fFsONgiMrq+CFadhLgtdj2b8UuTlnvLSwpEQ7XS0rxcwYMnI76MbXdDHlML02bttLrBVem0w59memIulCaz+DX9BTfYuF1oUZIW6hHltoHTPDM5k1nLHom2SrDaLT04AeeAEVgfA1Log5g8/Nt/iS4F/8BKSa3Uq9SDK+NNH054y2ZHbs1K48Hh6xOrsyvYCLuBjrLwwl4kT2k2A1L1Ieo3oYtkZsRym3IVmAzj4J5w64jEcs4mb6PJidfVwQe07uBwf7NUuK/y3foAJI6gvohZOIW7yVlYBxJC/68qAybG33zQYvd5R2HsXlAb2qqJPrTaDQJlbPptWKeM1g==
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
index c635c3237f52..3307c0551a0a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1150,7 +1150,11 @@ static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
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
@@ -1158,6 +1162,9 @@ static inline pgoff_t linear_folio_page_index(const struct folio *folio,
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
index 04b657eefb3c..5ad11ff5482b 100644
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
+	folio->index = linear_virt_page_index(vma, address);
 }
 
 /**
@@ -1512,8 +1512,8 @@ static void __page_check_anon_rmap(const struct folio *folio,
 	 */
 	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
 			folio);
-	VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address),
-		       page);
+	VM_BUG_ON_PAGE(page_pgoff(folio, page) !=
+		       linear_virt_page_index(vma, address), page);
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


