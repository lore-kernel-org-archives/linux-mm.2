Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F038CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4D716B00A4; Tue, 26 May 2026 02:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24EC6B00A6; Tue, 26 May 2026 02:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B3D6B00A7; Tue, 26 May 2026 02:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C32E16B00A4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:38:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7351B1C069C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:39 +0000 (UTC)
X-FDA: 84808617558.03.E514A0F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2999180005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="iMy8o/yy";
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCWqE2KZKcS3qocLTiNkm2saleazZgf06tanuFu3OLc=;
	b=7vghvHWnFrNZ2A3afjHLwdsmDJFWUqwTBTWGb3ypuNOKujKnOzP4582MNlx1Dk6A/waJTx
	kgdQwJbrpSbMxoSBMVvAPchr+B5VQ2lZ9a9iJMCp5wtR12dW04N2F23Qnrk50cHSKUkjta
	TFXXEXojY+MPKGaQq+jlRu9IxsIXHL4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="iMy8o/yy";
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777517; a=rsa-sha256;
	cv=none;
	b=79ZeqvaZ5BlRQSPOIk7yXtXP795NGyq0rEDUyU/0lCMYlQIPq9qm5vYVILW7KZTQbw0y2G
	d7eg50auAgZSl+Lq6jvx9FyNO/SgLt8ZFsjjCGuQ1LSlcl+IAU17t/ZIoLoreFfoc39KO+
	YRlY84nm3KM5tDuaYXFIGKOdT5DuFZc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C384A2880;
	Mon, 25 May 2026 23:38:31 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 337D43F7D8;
	Mon, 25 May 2026 23:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777516; bh=CaxioxUJ9FXPtxe0BuhQL/CvxhULhorYKlJB4+eUr8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMy8o/yyWJ25zxzQeLC36UXRLe3vh7LSA2jH0VG5IxJWW6PmXQ1tRwePBtqzGTZ96
	 IJ9CuyATqgUmSwnJgXjVxNLxNYZsU4uaXet0UNRHmHU5Pg7ifsLkUYYdoYYBFIt2nT
	 bxOy6P+U/6wx8AMn5XUozOTBcTeXCGNYuncj6Lh0=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 10/12] mm/rmap: refactor anon folio unmap in try_to_unmap_one
Date: Tue, 26 May 2026 12:06:33 +0530
Message-Id: <20260526063635.61721-11-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2999180005
X-Stat-Signature: yq8pfa94daei59sdt1rn4b3s3cs3xi1s
X-HE-Tag: 1779777517-108191
X-HE-Meta: U2FsdGVkX1/MgYqPguI+AjR6fI9/s23N2I3LhKI0qycFN6iL9nxArKc4STc/i3lEjMTpzmGJQFifG6ckJJbApD3ZEh2JnYe7Ccdi2aGh0CENwOgBgbcx5QQFfde5USKwYuxygDlbrY4Q3ay0GpARubBhx7P/NmkUwEH2MObDR69jl1/ew7VXijaGCULKewYV4cwlTzzG/zT5Bp2y4fZFH+y17yqB2zLJfQlk8Xt9X02+NP1XPzvxpBeRXAmAMMWVopOwZwBx1cd5OxS/VSbRLTr3Cow7Ds8WogebPfL/epiesVba9c2QHYYk8MqAmFMu/GPo5QJbYB6GbOyz+kIseMcvRfBmtUurwguIBpmgM4hQ/kbKaDVk+Au2MVAywWZL/N4iDjUc/KcBnNtzsLkNptzDG4OuMo7UTiBa/hPoQJ90t8w8I0qTHjrPgLyArpRm4SN6Vm0oNAWf0RuAG/sqhSjYkgbuyOv6EmmslUu4YjFjt8RKk2HGJVQhnl5EyKErqmMbKiK4UFQj7S67tQHcOm4Wjm/2TNjPsvFnDwOO3t90IP8szEfWlXa1WFMZk9Gnedofc+rl7EucD8LZYQO0Mxa6a4ePkNFBCgHOCs5fdrTL0aMKGMH0rO/3W0WyUsbJbXkFbKq5MzrodU/DbFoX8TPW9gjvr1FoTrKBVwmXj7at/uojNaEwdjVQPenzxl/5jKRdcTiDnPBpY29GGhqWL5YkJMydYrdAp4oy2Mo+EjZQGYHXKD8NdqkMcd4dPFenOWa3mnQScCNDj8U9eTt8vEre/tx5XeSoGjSrdGD0gs/7ktuE6GjfX3PxKD8UzURYcGHnjIjgUw3AKxeolzrOfuMoJOHvYP14xJ4Tia3ZQdKiH7SioEABsE1i6agogJ3MOAoUhBS6pqjvXa0dTDZ/G5lfkd+uFpE67Dey1RpvRKFrNEuTz05qWMJIImJJlG1qDeIpVTxE4qSC6B1mKRf
 2ZktZOBT
 nLDB3oHEnQPrgpJbvvOFwjGneYmCMP/HqbqdEa0DcLbuWSi5VpA+8hnijCE0VwR2TyKsbgLYX+hLE8LYoVjxjZwMTGIctV7OpLuCB0ToRlAKj8HpViXiqrGLxhGEW2pW4iF/bb8ZKk4nEjbv6+uRyLizVgfjn2QQNQK2fl1twcVdzC4aS6d5hszvTXG7Yqq37NG0y0QJBZ+sednXWEkSpq83Duqf0u2lBiSo5ePgQPucUK6tSb9+tFOo//pX9IivZVIB7U/8x5NniMLWTC0sQS6LgIooaMTrOcUcJNoY1TpRNGE0WJ7eLTa0tX5twTJsVYjOoL6wB1/3s8bs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor anonymous folio unmap to ttu_anon_folio.

No functional change intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 116 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 48 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index c0e385882f562..b1639bad8e27f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2136,6 +2136,70 @@ static inline bool ttu_lazyfree_folio(struct vm_area_struct *vma,
 	return true;
 }
 
+static inline void set_swp_pte_at(struct mm_struct *mm, unsigned long address,
+		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive)
+{
+	pte_t swp_pte = swp_entry_to_pte(entry);
+
+	if (anon_exclusive)
+		swp_pte = pte_swp_mkexclusive(swp_pte);
+
+	if (likely(pte_present(pteval))) {
+		if (pte_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd_wp(pteval))
+			swp_pte = pte_swp_mkuffd_wp(swp_pte);
+	} else {
+		/* Device-exclusive entry */
+		if (pte_swp_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd_wp(pteval))
+			swp_pte = pte_swp_mkuffd_wp(swp_pte);
+	}
+
+	set_pte_at(mm, address, ptep, swp_pte);
+}
+
+static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+		struct page *subpage, unsigned long address, pte_t *ptep,
+		pte_t pteval)
+{
+	bool anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(subpage);
+	swp_entry_t entry = page_swap_entry(subpage);
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (folio_dup_swap_pages(folio, subpage, 1) < 0)
+		return false;
+
+	/*
+	 * arch_unmap_one() is expected to be a NOP on
+	 * architectures where we could have PFN swap PTEs,
+	 * so we'll not check/care.
+	 */
+	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+		folio_put_swap_pages(folio, subpage, 1);
+		return false;
+	}
+
+	/* See folio_try_share_anon_rmap(): clear PTE first. */
+	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, subpage)) {
+		folio_put_swap_pages(folio, subpage, 1);
+		return false;
+	}
+
+	if (list_empty(&mm->mmlist)) {
+		spin_lock(&mmlist_lock);
+		if (list_empty(&mm->mmlist))
+			list_add(&mm->mmlist, &init_mm.mmlist);
+		spin_unlock(&mmlist_lock);
+	}
+
+	dec_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter(mm, MM_SWAPENTS);
+	set_swp_pte_at(mm, address, ptep, entry, pteval, anon_exclusive);
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2144,7 +2208,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	bool anon_exclusive, ret = true;
+	bool ret = true;
 	pte_t pteval;
 	struct page *subpage;
 	struct mmu_notifier_range range;
@@ -2252,8 +2316,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		address = pvmw.address;
-		anon_exclusive = folio_test_anon(folio) &&
-				 PageAnonExclusive(subpage);
 
 		if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
@@ -2308,8 +2370,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = page_swap_entry(subpage);
-			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
@@ -2331,52 +2391,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto finish_unmap;
 			}
 
-			if (folio_dup_swap_pages(folio, subpage, 1) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-
-			/*
-			 * arch_unmap_one() is expected to be a NOP on
-			 * architectures where we could have PFN swap PTEs,
-			 * so we'll not check/care.
-			 */
-			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap_pages(folio, subpage, 1);
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-
-			/* See folio_try_share_anon_rmap(): clear PTE first. */
-			if (anon_exclusive &&
-			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				folio_put_swap_pages(folio, subpage, 1);
+			if (!ttu_anon_folio(vma, folio, subpage, address,
+						    pvmw.pte, pteval)) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
-			if (list_empty(&mm->mmlist)) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&mm->mmlist))
-					list_add(&mm->mmlist, &init_mm.mmlist);
-				spin_unlock(&mmlist_lock);
-			}
-			dec_mm_counter(mm, MM_ANONPAGES);
-			inc_mm_counter(mm, MM_SWAPENTS);
-			swp_pte = swp_entry_to_pte(entry);
-			if (anon_exclusive)
-				swp_pte = pte_swp_mkexclusive(swp_pte);
-			if (likely(pte_present(pteval))) {
-				if (pte_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			}
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			goto finish_unmap;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
-- 
2.34.1


