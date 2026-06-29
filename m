Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F14C43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B336B6B0130; Mon, 29 Jun 2026 11:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3986B0131; Mon, 29 Jun 2026 11:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95D996B0132; Mon, 29 Jun 2026 11:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 492F26B0130
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 953BE40196
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:29 +0000 (UTC)
X-FDA: 84933271458.16.CAFD5D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id EC76C40007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoGI6DWi;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745467;
	b=KhGcdYXO0F00ERAiQmkWPX78r2+muHxcO87K6yfeQiU1AbRg/Uyf1WtIUzo28n29vP5HrJ
	G3ApsgLbAFKNSzx8qem8gCz1aRg36mjdUkd5hJjZpet1NyrTGRtOHGYXKttGe5DWp0zeSj
	i14VGY4VzC9p4kktu3NlbvG1zFhcY3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=taPyrk/BsBLxrMM8Vq+2u1dZ7vtlSS8gqzItOjGvO1c=;
	b=EO7YprlYeE1Nkg0JSI6deIbpojTTmGod2EISWzUa4iy3MI91JUhv3vUSmqo40GJNotKNpd
	UPOmOUIgBhU6wnX1vu8pDg4Soky9YCO0yG5Hh+dDMqwdy5Y7BaQ55dBCWaUmDAEiVhDx93
	Qwa9sXg4L1rCBA9wxgQiKKsE9ZoKqok=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoGI6DWi;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82863600AF;
	Mon, 29 Jun 2026 15:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B721F000E9;
	Mon, 29 Jun 2026 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745467;
	bh=taPyrk/BsBLxrMM8Vq+2u1dZ7vtlSS8gqzItOjGvO1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoGI6DWi6H0hXBMb9HUmE+Atw+ySp392K4B92QjygVVmkdeKnyFz1T7GaQCK/2wxA
	 ccaGK81wZmQYhGzIy+k1FIXn7CYv42WG9soK5NP90jFJsmLh3QdruWdF+8I7zfSkCu
	 fzYyfeGRFdAx8RtJgLsTsIRJBC+z19EXD0zh9syqkTSJ56s3cQZQcWvJp3hwO3uLLx
	 vyeOAME//Y8klygE+0enGqAdt1f/5vdIe6Bj/RVEhWN4c3ZhOFdnnMCD+MnUXwUAZA
	 VLlR1QWj67mxG5lI5WPleKvC24E+Ehu3oehLxwQrIUNuU8oJ6MYzGctO+GhhSJwqRx
	 lEzYpYWd6aJzA==
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
Subject: [RFC PATCH 09/10] mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon folios
Date: Mon, 29 Jun 2026 16:03:49 +0100
Message-ID: <ce13af1add004c5b50c1ee9d920eeae41344b32c.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782745153.git.ljs@kernel.org>
References: <cover.1782745153.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zzghkrwbfen1pisux6qnfm4tbkwztajf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC76C40007
X-HE-Tag: 1782745467-487720
X-HE-Meta: U2FsdGVkX1+a0y9gpG2Gt/zfYmv/Gprlw8UKmKEoXSrHT4R5SPlMJsltp/zSBNUsD4gxBeAkr/fGbLqKmyEz2NmE72U6+OIX/1HRhDKlLpI7NWEQICEp+5mpKf27/Iu10Z3v9mLgtfar3G2FME3IuNWzAXvyKaEKmySSW3Dt2NoR6693ETLx2ynJOLs2lQ434McxjtkAlNDFBG+ZDdWfXupBMgFNE7HlJF5SyYXYx/i/iVwuC0ibZLdunzYg0t4tVam8PdTu+ocMpAh1rIbxCfggoZVcAPyZtGdWuDisAsN29389J7CQbhq58KxWA9frikA35joNAVp4slMrpIUWLUQfAvqs+qy33QGQ6Lyotk1m9irniErm8IQ7ilQlH3giAXq2bjOCKS255i9GwTIFEkibE0msiVWpY73SPMS6gk8akMdjxvYPZch7bJU1C7SefaUuu7P+8F+wrxFash+eRa2IeEZtEqbrUvRAZCFSvA4z0I7tLPq3dtIpT2xW37h/T/CP30wHQD1cqoH4fHJ0jY8bNhggtDj/fyLDheuQqk3wGK8zZzvXoOKKfF2IlT5Smwba4Aqyl7PEXYheVhRlktw+iHXBLUrtF0SyKxEMxPMrZUYitDSib2hh17hQt+5O0ElXbXEEfMbezA2YgRZ2Z8oaZiy/QD4kpMQUk6UWRExqSh9D186A1fCikQJSJA9K9Fliw8TfHcTFZT3ROHGLSnkvZ1I0ZSfuM934AlXJ84WWj6MrcrkLrGWAfu9T+at86fKNAvC13C2PlLNcpjLM5txHiHZIzWVm3lW/6pVuIJl6bGasek4GZKlqNU17kilMvojVBcymQkKZS9lCcFJCrheOxZFPWeoacI3KSte1feBdGjHhoU5kpIDd+rU3PBaNCQF1gdgNUgeePy1L8UexJlIsaSgnlYoPg51z6i/7GrLtcLdIrN8WUSe81NQvf3YtIROj9Jjz9E3KQeqz8os
 kLZjGrzh
 1kwIYr3UlZFsO8MUDrE2+jUNn0ZaQZHj0tatxUmHSWMipGqebTAkiZ3f+2rcmqJKkqoO96MYBagrw721pwebNxrFS3enH7EY88fZv/CRjuq7xV1vhp+sc0JXfAvjZv+kIJLUfEOOC521RyVO9zcFByC0X5K38JsPfU9bEBirfVKwEs6qgWgZSk8TICQwliGKcqpMgxZRomZV+T0VStfugDXYZdEpK8WDLcp2WDm53yHhJ/5/kcGo/wZZqU3qelExIinjTl4tmHQKe5DFHNDHuWhQeLoGPeMVJ4QYAzUtzQwymhESaZCpk506Qjn1BzbfuOqgKFV/omWW/BEOJyljCV5pRZY3ZlA5QBbXxyrPrGSS+oUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, anonymous folios belonging to CoW'd MAP_PRIVATE file-backed
mappings are indexed by their page offset within the file in which their
were originally mapped.

This differs from anonymous foios belonging to pure anon mappings which are
indexed by their virtual page offset (the address at which they'd belong in
the VMA when first faulted).

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

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/pagemap.h |  9 ++++++++-
 mm/internal.h           | 25 +++++++------------------
 mm/interval_tree.c      |  4 ++--
 mm/ksm.c                |  2 +-
 mm/page_vma_mapped.c    |  2 +-
 mm/rmap.c               | 12 ++++++------
 mm/vma.c                | 14 ++++++++++++--
 7 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e2affa57dadd..079a08fa83f5 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1153,7 +1153,11 @@ static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
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
@@ -1161,6 +1165,9 @@ static inline pgoff_t linear_folio_page_index(const struct folio *folio,
 					      const struct vm_area_struct *vma,
 					      const unsigned long address)
 {
+	if (folio_test_anon(folio))
+		return linear_virt_page_index(vma, address);
+
 	return linear_page_index(vma, address);
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 120957a7850c..0a395801bbe2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1263,23 +1263,8 @@ static inline unsigned long vma_filebacked_address(const struct vm_area_struct *
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
@@ -1313,7 +1298,11 @@ static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
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
index d90e962b28f7..350838dcfba5 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -83,12 +83,12 @@ mapping_interval_tree_iter_next(struct vm_area_struct *vma,
 
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
index c6a6e1ef581d..b499f3240fc6 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3120,7 +3120,7 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
 			return folio;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return folio;		/* no need to copy it */
-	} else if (folio->index == linear_page_index(vma, addr) &&
+	} else if (folio->index == linear_virt_page_index(vma, addr) &&
 			anon_vma->root == vma->anon_vma->root) {
 		return folio;		/* still no need to copy it */
 	}
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index eff619180e84..3d90fd4178d2 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -356,7 +356,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
 	};
 
 	if (folio_test_anon(folio))
-		pvmw.address = vma_address(vma, pgoff, 1);
+		pvmw.address = vma_anon_address(vma, pgoff, 1);
 	else
 		pvmw.address = vma_filebacked_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
diff --git a/mm/rmap.c b/mm/rmap.c
index a3e926a708b1..03c9ee92acc0 100644
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
@@ -2992,10 +2992,10 @@ static void rmap_walk_anon(struct folio *folio,
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
 	anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
-		unsigned long address = vma_address(vma, pgoff_start,
+		const unsigned long address = vma_anon_address(vma, pgoff_start,
 				folio_nr_pages(folio));
 
-		VM_BUG_ON_VMA(address == -EFAULT, vma);
+		VM_WARN_ON_ONCE_VMA(address == -EFAULT, vma);
 		cond_resched();
 
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
diff --git a/mm/vma.c b/mm/vma.c
index c4bb41400751..cda263d92694 100644
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
 
@@ -1991,7 +1995,8 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 			*vmap = vma = new_vma;
 		}
 		*need_rmap_locks =
-			(vma_start_pgoff(new_vma) <= vma_start_pgoff(vma));
+			(vma_start_pgoff(new_vma) <= vma_start_pgoff(vma)) ||
+			(vma_start_anon_pgoff(new_vma) <= vma_start_anon_pgoff(vma));
 	} else {
 		new_vma = vm_area_dup(vma);
 		if (!new_vma)
@@ -2062,7 +2067,12 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
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
2.54.0


