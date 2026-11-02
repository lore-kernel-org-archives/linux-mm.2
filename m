Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62CCD60A2608
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AJZOw0wL
Received: by kanga.kvack.org (Postfix)
	id 865C56B05B3; Mon,  2 Nov 2026 07:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E446B05B4; Mon,  2 Nov 2026 07:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753F26B05B5; Mon,  2 Nov 2026 07:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55C306B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:32:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4EC89140C35
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:32:33 +0000 (UTC)
X-FDA: 85390117386.10.8997C07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 90C2580005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:32:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJZOw0wL;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622751;
	b=mUFsPXvWZmSVfSGu/BR6U5xUFizzYj0bkwIGf+K8JRptSFkh436pP7yTFvnYR3vSR10eF7
	CtNx/ml8bWfqtRvw2aK8YrhJiZjVNXUq5D9nXOLiU0PBrs7VP+zF4jj+3srd7yXDdKwvXW
	+bD00lmbLI5fCVZaUlzR5W9BqiGY1Xo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJZOw0wL;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3fFBdd/pflWkvdBJFw0jTNoMwa2gmB9NEbXxJt+oA4Q=;
	b=LIRt0+9Tqvrre1O/b3YhTFo5s50BWdNraOLU2abQEb5/Ek8KjjhrRIO7Jobl4+pewR9Ii2
	WbUfIzJP0Sw6HfTD5uvVw3lwaSB3eAvko+mgqHPvvmNJLrNpgTHxyJ7FLGxP+ZnE2Fy5EE
	XX7nhY+lCmaKNHGTrQmyO+eEonpc+QQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 280CE60DB6;
	Mon,  2 Nov 2026 12:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBB91F00A16;
	Mon,  2 Nov 2026 12:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793622751;
	bh=3fFBdd/pflWkvdBJFw0jTNoMwa2gmB9NEbXxJt+oA4Q=;
	h=From:Date:Subject:To:Cc;
	b=AJZOw0wLqQlm1wmFt2sNAXpkX+xko/eWhjQ+IDeSG3CVbL9zNbCAiq4x71xmL6MD4
	 tXSecn/VOXoUvsYfvsBmhEo5MHLm/R8ps7Qp2Ng9GmRpiiIxFqwijHam92V5/KUEfV
	 FXfoI4ZlU1dyiM7LCYUpsI1WN16pqUk7dbDHGNfvhuZh08ToTpWxEXBNB+PXO34+jq
	 K/iNajjan+VDageqiLqPHp3rU7tsIY/J6NrqJDZk50tlA9GueF5nlTNE8iUTgmJhke
	 +jG/QOx92nJNatlYBpDWruwhb4O2ey5rtuC/z0CPSvAQmLYvdPy6R8W/qVPzXCKoBg
	 Pdx4CmAtN+4CA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 02 Nov 2026 12:32:25 +0000
Subject: [PATCH] mm/ksm: avoid unsafe anon rmap dereference in KSM merge
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvxJ7bkGlJPpKdNBca4lUFCKQ/p50n
 IGZCoUyU4G5q5Dp5sIxNJB9B9thwk7IrjEoobSUQuFZLjQhBsyXSej5QTsO1urJeU0btC5lavp
 /Luv7fvUgtmNjAAAA
X-Change-ID: 20261102-ksm-anon-rmap-fix-b54bb68df6ec
To: David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
 Zhao Gongyi <zhaogongyi@bytedance.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9612; i=ljs@kernel.org;
 h=from:subject:message-id; bh=PxH75+4aFrWwzd9qYlqB6yGrtWWv8reB5ZjtMdlVQR0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJeNN1Ztmxa4ULvC0a6sbalNquWVTeYdc55YbbOxeqx0
 onLEaVJHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIniUjQ4vST+5V6u1r7hXs
 /7jW91lcoYTyWfMF3cc5H8q4q/zbc52RoeuBwHejCbf2P4noSuTZcLbnSUPwNJ9IJh9+t3MJn6z
 MOAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 90C2580005
X-Stat-Signature: c1ocgnge8z9uh3gx8yfjkurzuh1sj96m
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793622751-37470
X-HE-Meta: U2FsdGVkX18IpR7mhN9E4d664tsK07VKSknIm+afEhlLq/tn/l8wslfmZNZqN98D72KZzw+OL8xGGCttY3EaHWC7TGemZZBN1gmj5weCBYBdgu0Lp+lY2Yy+zw4+o1pN7VvzYxSt2Rfw8nLib1r7cxiF3Vfgxkui6GQSDu+KZ5trnAS9903/ugH2txDETi5wuILwnIKU4YMhehINu1qFnEZByRY7WWjE0qKEe4j1XFOZQoKZQxPLTIO7wmjlkxq3ePu9+VoqHC11UVkrJbgiL4STKOO7Mjz0gFcH7Z7IxF7v45Gy6RLpI4IddRMmxQfIAMLGbfc7FuZzPZq/9l2/ORHBvrqYiP/FVI5Ct8HaQNROC76wfem+IXYpMlWwjuXBu2hmDXdqxo/LnzolS56GnKddlDYzqOZbl56gH9eUy+4qRBcOJdR9t3et5cD2fXlmJELrbOdq8oT9Nkj1wQ/NsJL7XVgTTWm/ztgXxtqYtIOkGRDqx2EzFMT/M7+/m6226X4cylwAQzEAfYIMNCjAFJPzj4U55Dsf2DZ3xLelXQQnXkk/vGCXSZfL/sgWizuv6hxKwm/KxMM8/vPUT0DsnLAuQI6qebCGMtbpygRjNJX9vUVBSaIRH/XeskjzJE6uhT+rRZ7heKdlxtezMTEI2un6rQYiXDdN5zl6p8GfJlCRvAjKomHCOK4XtCJDJMkBne5u1HoYx21NDmigNqu4laYI40xafBWrT4gRAULA2ucwFwWYjIjsN9IcYm//eO9pwD+lre6hDFVW1y5/EERNAaUANpVkW6JRIT6ABBd57cqZ+Qvrm7tPGjVk/lyWpZd1IqvtBgdBP6WPJxM2ZPnLhbMHP1hPIXoPKgMx7O3ftr/dZYtObnJkJ2jY2+6s4RXerubmeUXOPfnUt6T5Yuj5DvSJesoja6TrXHIZZXTU/lCKPnqJMSKNNj84ujMvhpYIpuXhuvDiWpKKVcCQUI3
 5xpbCXpY
 wzyuVslqzPHbe6GM0k6/WIxe1/N1FF2GnXw6cjzow7bP0T9QCIxDJMW3MqwaXFbfq8VPs6CfZlT7WV3grddLogeeWpO1ZK0kD5eOT4yMYjl5alJqqKezEfqYKcuvkbUWdyVkIlezjh2JpCwv5O01FsldjoUfydlVe22gwCMUugZDtuKWh2wjelkYOMOZ8p/0YNkghVmcqnyioScKOPf+JY7s0D5MYCtFALfJeM21Qgq0zawO+mDcZIvJo9jE7FOcLC2SOYTbRQg9/a8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When KSM examines candidate VMAs in scan_get_next_rmap_item(), it
accumulates (mm, address) pairs in ksm_rmap_item objects, assigning them
via get_next_rmap_item(), pinning folios via a page walk in
ksm_next_page_pmd_entry().

Throughout this operation, scan_get_next_rmap_item() holds mmap read lock,
which it drops afterwards.

After the mmap lock is dropped the VMAs might be freed and remapped where
the VMA belonging to the folio was previously mapped.

mremap()'s ability to change where anon folios are mapped is dealt with by
KSM by essentially avoiding the problem - prep_move_vma() unshares KSM
folios, and the scanning logic is tolerant of concurrent remaps, discarding
stale ksm_rmap_item objects and allocating new ones at the new address.

This doesn't account for a new VMA being mapped over an old one where a
folio was previously mapped, so KSM accounts for this by checking things at
the page table level.

However, once an anon_vma's reference count reaches zero, it is freed, but
nothing clears folio->mapping, which is where the KSM pin interacts badly
with the current KSM implementation.

page_address_in_vma() is consistently used to look up the folio's address,
but page_address_in_vma() explicitly states:

"It is the caller's responsibility to check the page is actually within the
VMA."

And KSM violates this, as it cannot know this to be true. This results in
this function performing a use-after-free:

		struct anon_vma *anon_vma = folio_anon_vma(folio);

		...

		if (!vma_has_anon_rmap(vma) || !anon_vma ||
		    vma->anon_vma->root != anon_vma->root)
			return -EFAULT;

As anon_vma->root is dereferenced when anon_vma can already have been
freed.

This is currently benign in practice, as anon_vma's are slab-allocated
objects so this will always be within the direct mapping and arbitrary
memory will be treated as if it were a pointer to be compared.

This either results in an -EFAULT or a spurious match, which will be
rejected at the page table level.

However we mustn't UAF even if it's harmless, and KASAN rightly flags this.

It turns out we don't even need to use page_address_in_vma() as we already
know the folio's address, it simply needs to be passed through.

This change therefore updates KSM to do this, sidestepping the issue
altogether.

Explicitly check for KSM folios in try_to_merge_one_page(), which are
already merged, and by definition never have an anon_vma.

This was previously handled implicitly by page_address_in_vma() as
folio_anon_vma() returns NULL for those.

In many cases cmp_and_merge_page() will reject these, but it's possible for
KSM folios to fall into the unstable tree there, so eliminate that
possibility by checking for that early.

This maintains existing behaviour.

The bug was introduced by commit 21d0d443cdc1 ("rmap: resurrect
page_address_in_vma anon_vma check") which first dereferenced
folio->mapping unsafely, but commit b8c8ba73c68b ("slub: Introduce
CONFIG_SLUB_RCU_DEBUG") made it visible with CONFIG_SLUB_RCU_DEBUG enabled.

Fixes: 21d0d443cdc1 ("rmap: resurrect page_address_in_vma anon_vma check")
Reported-by: Zhao Gongyi <zhaogongyi@bytedance.com>
Closes: https://lore.kernel.org/all/20261031182256.40205-1-zhaogongyi@bytedance.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
David - this seems benign in practice, so I'm not sure whether a backport
is required here.
---
 mm/ksm.c | 43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index d6f736a1aa2f..620455e4754a 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1294,10 +1294,10 @@ static u32 calc_checksum(struct page *page)
 }
 
 static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
-			      pte_t *orig_pte)
+			      unsigned long addr, pte_t *orig_pte)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
 	int swapped;
 	int err = -EFAULT;
 	struct mmu_notifier_range range;
@@ -1307,10 +1307,6 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 	if (WARN_ON_ONCE(folio_test_large(folio)))
 		return err;
 
-	pvmw.address = page_address_in_vma(folio, folio_page(folio, 0), vma);
-	if (pvmw.address == -EFAULT)
-		goto out;
-
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, pvmw.address,
 				pvmw.address + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1380,7 +1376,6 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 	page_vma_mapped_walk_done(&pvmw);
 out_mn:
 	mmu_notifier_invalidate_range_end(&range);
-out:
 	return err;
 }
 
@@ -1389,12 +1384,13 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
  * @vma:      vma that holds the pte pointing to page
  * @page:     the page we are replacing by kpage
  * @kpage:    the ksm page we replace page by
+ * @addr:     the address at which @page is mapped
  * @orig_pte: the original value of the pte
  *
  * Returns 0 on success, -EFAULT on failure.
  */
 static int replace_page(struct vm_area_struct *vma, struct page *page,
-			struct page *kpage, pte_t orig_pte)
+		struct page *kpage, unsigned long addr, pte_t orig_pte)
 {
 	struct folio *kfolio = page_folio(kpage);
 	struct mm_struct *mm = vma->vm_mm;
@@ -1404,14 +1400,9 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	pte_t *ptep;
 	pte_t newpte;
 	spinlock_t *ptl;
-	unsigned long addr;
 	int err = -EFAULT;
 	struct mmu_notifier_range range;
 
-	addr = page_address_in_vma(folio, page, vma);
-	if (addr == -EFAULT)
-		goto out;
-
 	pmd = mm_find_pmd(mm, addr);
 	if (!pmd)
 		goto out;
@@ -1499,6 +1490,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 /*
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
+ * @addr:     the address at which @page is mapped
  * @page: the PageAnon page that we want to replace with kpage
  * @kpage: the KSM page that we want to map instead of page,
  *         or NULL the first time when we want to use page as kpage.
@@ -1506,7 +1498,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
  * This function returns 0 if the pages were merged, -EFAULT otherwise.
  */
 static int try_to_merge_one_page(struct vm_area_struct *vma,
-				 struct page *page, struct page *kpage)
+		unsigned long addr, struct page *page, struct page *kpage)
 {
 	struct folio *folio = page_folio(page);
 	pte_t orig_pte = __pte(0);
@@ -1515,7 +1507,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 	if (page == kpage)			/* ksm page forked */
 		return 0;
 
-	if (!folio_test_anon(folio))
+	if (!folio_test_anon(folio) || folio_test_ksm(folio))
 		goto out;
 
 	/*
@@ -1539,7 +1531,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 	 * ptes are necessarily already write-protected.  But in either
 	 * case, we need to lock and check page_count is not raised.
 	 */
-	if (write_protect_page(vma, folio, &orig_pte) == 0) {
+	if (write_protect_page(vma, folio, addr, &orig_pte) == 0) {
 		if (!kpage) {
 			/*
 			 * While we hold folio lock, upgrade folio from
@@ -1556,7 +1548,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 				folio_mark_dirty(folio);
 			err = 0;
 		} else if (pages_identical(page, kpage))
-			err = replace_page(vma, page, kpage, orig_pte);
+			err = replace_page(vma, page, kpage, addr, orig_pte);
 	}
 
 out_unlock:
@@ -1572,6 +1564,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 				       struct page *page)
 {
+	const unsigned long addr = rmap_item->address & PAGE_MASK;
 	struct mm_struct *mm = rmap_item->mm;
 	int err = -EFAULT;
 
@@ -1583,13 +1576,12 @@ static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 		struct vm_area_struct *vma;
 
 		mmap_read_lock(mm);
-		vma = find_mergeable_vma(mm, rmap_item->address);
+		vma = find_mergeable_vma(mm, addr);
 		if (vma) {
-			err = try_to_merge_one_page(vma, page,
-					ZERO_PAGE(rmap_item->address));
-			trace_ksm_merge_one_page(
-				page_to_pfn(ZERO_PAGE(rmap_item->address)),
-				rmap_item, mm, err);
+			err = try_to_merge_one_page(vma, addr, page,
+						    ZERO_PAGE(addr));
+			trace_ksm_merge_one_page(page_to_pfn(ZERO_PAGE(addr)),
+						 rmap_item, mm, err);
 		} else {
 			/*
 			 * If the vma is out of date, we do not need to
@@ -1612,16 +1604,17 @@ static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 				      struct page *page, struct page *kpage)
 {
+	const unsigned long addr = rmap_item->address & PAGE_MASK;
 	struct mm_struct *mm = rmap_item->mm;
 	struct vm_area_struct *vma;
 	int err = -EFAULT;
 
 	mmap_read_lock(mm);
-	vma = find_mergeable_vma(mm, rmap_item->address);
+	vma = find_mergeable_vma(mm, addr);
 	if (!vma)
 		goto out;
 
-	err = try_to_merge_one_page(vma, page, kpage);
+	err = try_to_merge_one_page(vma, addr, page, kpage);
 	if (err)
 		goto out;
 

---
base-commit: 34f88a114888c9dba49e45f2b0c2a3e83c4c871c
change-id: 20261102-ksm-anon-rmap-fix-b54bb68df6ec

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


