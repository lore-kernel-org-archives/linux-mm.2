Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81308E937F6
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 17:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D9C6B0095; Sun, 12 Apr 2026 13:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04D46B009B; Sun, 12 Apr 2026 13:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AD06B009D; Sun, 12 Apr 2026 13:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB0886B0095
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:43:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A0A2E3A0B
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:07 +0000 (UTC)
X-FDA: 84650624814.20.0438C82
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4DED440008
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wuvo7ilM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OHh8wmKt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wuvo7ilM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OHh8wmKt;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776015785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBbANHRonp7Gey8phh5lpLom/zoIGcl2OxsXcSKEgng=;
	b=mRmvb3wIPXo4lrenIqFQeEgKtGv68iU/2J7EzjTrnBwp90JUWt9Y7+yJl5YogrqdemNLbn
	6l1H8qL9AA95ko0zlKcT3IzJusTQiBjoeqMFjmVEX4zp/TMZWHuE66CV7XfDJWqxU605IQ
	aOA639NEbjSSzJu5JhTKLuP6fTfC26U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wuvo7ilM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OHh8wmKt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wuvo7ilM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OHh8wmKt;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776015785; a=rsa-sha256;
	cv=none;
	b=lyb9Ib+VnEVdF4HSj6rXsBP4SF+dgHzKY1RlDobx6SSOS92Qi7vc0OSfsc9OyTyqB+CNYc
	XGZiMrmOrUx+z1R95g58Qdxzebci4mKoap44w1IaR81/0lxje4WWkahIh/jwvAm69Ww2cU
	wRmsLigyXTR5gz20rm5zvUy/Id7+qro=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D65036A851;
	Sun, 12 Apr 2026 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBbANHRonp7Gey8phh5lpLom/zoIGcl2OxsXcSKEgng=;
	b=wuvo7ilM/mAIP444FSEDE9Lq9V6cvn43YPU1/eEsHkYF9e4hVwqqA5mPwBlH3DMywAouOS
	4w1yyt4biDf3atzwZTJUn0ljlYjnG5DUkHXulfLD7M/MK33VCQgvDVPoTtzGvX8obPCI1+
	+SOYnroavRBCHA8f/xIhiWBZk0NGDmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBbANHRonp7Gey8phh5lpLom/zoIGcl2OxsXcSKEgng=;
	b=OHh8wmKtuaEOmva08p2CCnWEuCU/BiE0rP5xmFoYMdPknJc+DbwBpRM179KMCxpakRFVv9
	LLjkd0HhBuM5/ABA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBbANHRonp7Gey8phh5lpLom/zoIGcl2OxsXcSKEgng=;
	b=wuvo7ilM/mAIP444FSEDE9Lq9V6cvn43YPU1/eEsHkYF9e4hVwqqA5mPwBlH3DMywAouOS
	4w1yyt4biDf3atzwZTJUn0ljlYjnG5DUkHXulfLD7M/MK33VCQgvDVPoTtzGvX8obPCI1+
	+SOYnroavRBCHA8f/xIhiWBZk0NGDmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBbANHRonp7Gey8phh5lpLom/zoIGcl2OxsXcSKEgng=;
	b=OHh8wmKtuaEOmva08p2CCnWEuCU/BiE0rP5xmFoYMdPknJc+DbwBpRM179KMCxpakRFVv9
	LLjkd0HhBuM5/ABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E2964AA4A;
	Sun, 12 Apr 2026 17:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cDt8FKfZ22miRQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 12 Apr 2026 17:43:03 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH 5/7] mm: Make /proc/pid/smaps use the new generic pagewalk API
Date: Sun, 12 Apr 2026 19:42:42 +0200
Message-ID: <20260412174244.133715-6-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260412174244.133715-1-osalvador@suse.de>
References: <20260412174244.133715-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: y1cue6iwff8afmb9pnnjq3x1kgqm55ok
X-Rspamd-Queue-Id: 4DED440008
X-Rspamd-Server: rspam09
X-HE-Tag: 1776015785-545100
X-HE-Meta: U2FsdGVkX18lZ5/dww8Q6Tmi0caTVK22Bh/4piLahVUQmrcksM/8M4/VUZcVJI/RIgZxZjquLZJwpfzuI8P3521rlcxF2qCSpd0riQ5TpUUZmXNPW/pb7Qn95Q1VOmZVogUIl3uhmFO1Rlk9APYujsAcCpqSa/06G/UujT9zslAAy7YH4jbU+pP5M0nNeWgzzStep9mN4q87uS9hSHjv4duL+XuOZnTEHEz9YqlZwWyFMlxRzDJyU9d3zqc2GCGv7fdG0LHEAijFck3p0hXCuqWWOKL9FgKEy+hs/9clEJXsCskEi+EdgDpimG70speMRN9Rp+txriX8rEtfqMFruChCpgVoDgD8SH4VI2IL8Q2GZfXgN2uKOypNH/jQkmnw65fa1xVJ5xaDiyFuGDGcPLDhga67N/WqIGEAQ7RvFiq5Y3wVKgvUoyCIp9yuux8QJ2CIFv+efqVMNYR5ikK3HdYLRHRDcrQKzTmm2p9/+Bt7CMmU9n1EhiJXEVFTXugRDMmYDansr+lVtq62Q0MM22ebLjwoTYU87M3g5sYD6l0heuAb2XibLFAhKhMWTtz4TKXZWwQ05rnbgiAfsRNepTfvcoK/MUtDE3MFP0NlOqJYUeBo4AVvqBVI/ReHOapLKooEpeUa5Xii5IIiuFzuC4sH20DFztKt/d4p/QtbQh54WCCUfNUmRmVZtc8usfuX0yWq1MIlge60Vf428tVWefAUg7VUvOIzGiYsOzkAeYMahIwfKja4aSH0wjUNXJX1TUQoFfHgzHe6Kvr3QCPC2cFe3Y7IQEOjbXD4KhCFCgUzpHWXXg9J9A2d1Ld026hmcbw3Zp1OkybewcT1nl/kfXZe/J34wvNIWayq8iWiMhsS7QSZDKxuayPpReC843sE8gRa7y+7rWByRFqhwB8g7KFjziZZPNmyDeadglxso0kFpcAVXmmUbFg65+JCyveeXQH8LH2MjtKAxaCe4m+
 x4A30wTI
 a8Tb0JrSN2rZ/OthxmfpJqqi8A31MfOW6xDW66PME3nmO0Ovv6b3Np1AsSSq7hyOE3uAQPH0snL+zJC5pO76J8duyhvRots8hIUtUwKhgl/bQbMTcUqXeriozxNdw17HtizQpi/9kWSZzXIlecHn1qbHYmEKB5ehYTnlGp6QA8XdTKpJLclYMK2qn2wfXKrCwwnAM/8RPTXwE7dcZPblU9I67eKg473+o3T9xP3QNvVVk4Vd4KoHwUrYGZXhXyma167XQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Have /proc/pid/smaps make use of the new generic API, and remove
the code which was using the old one.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 fs/proc/task_mmu.c | 309 ++++++++++++---------------------------------
 1 file changed, 84 insertions(+), 225 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..afbcdb11ad80 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -915,7 +915,7 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
-		bool present)
+		bool present, int ssize)
 {
 	struct folio *folio = page_folio(page);
 	int i, nr = compound ? compound_nr(page) : 1;
@@ -923,6 +923,11 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 	bool exclusive;
 	int mapcount;
 
+	if (ssize) {
+		nr = ssize / PAGE_SIZE;
+		size = ssize;
+	}
+
 	/*
 	 * First accumulate quantities that depend only on |size| and the type
 	 * of the compound page.
@@ -988,150 +993,6 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 	}
 }
 
-#ifdef CONFIG_SHMEM
-static int smaps_pte_hole(unsigned long addr, unsigned long end,
-			  __always_unused int depth, struct mm_walk *walk)
-{
-	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-
-	mss->swap += shmem_partial_swap_usage(walk->vma->vm_file->f_mapping,
-					      linear_page_index(vma, addr),
-					      linear_page_index(vma, end));
-
-	return 0;
-}
-#else
-#define smaps_pte_hole		NULL
-#endif /* CONFIG_SHMEM */
-
-static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
-{
-#ifdef CONFIG_SHMEM
-	if (walk->ops->pte_hole) {
-		/* depth is not used */
-		smaps_pte_hole(addr, addr + PAGE_SIZE, 0, walk);
-	}
-#endif
-}
-
-static void smaps_pte_entry(pte_t *pte, unsigned long addr,
-		struct mm_walk *walk)
-{
-	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	bool locked = !!(vma->vm_flags & VM_LOCKED);
-	struct page *page = NULL;
-	bool present = false, young = false, dirty = false;
-	pte_t ptent = ptep_get(pte);
-
-	if (pte_present(ptent)) {
-		page = vm_normal_page(vma, addr, ptent);
-		young = pte_young(ptent);
-		dirty = pte_dirty(ptent);
-		present = true;
-	} else if (pte_none(ptent)) {
-		smaps_pte_hole_lookup(addr, walk);
-	} else {
-		const softleaf_t entry = softleaf_from_pte(ptent);
-
-		if (softleaf_is_swap(entry)) {
-			int mapcount;
-
-			mss->swap += PAGE_SIZE;
-			mapcount = swp_swapcount(entry);
-			if (mapcount >= 2) {
-				u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
-
-				do_div(pss_delta, mapcount);
-				mss->swap_pss += pss_delta;
-			} else {
-				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
-			}
-		} else if (softleaf_has_pfn(entry)) {
-			if (softleaf_is_device_private(entry))
-				present = true;
-			page = softleaf_to_page(entry);
-		}
-	}
-
-	if (!page)
-		return;
-
-	smaps_account(mss, page, false, young, dirty, locked, present);
-}
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
-		struct mm_walk *walk)
-{
-	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	bool locked = !!(vma->vm_flags & VM_LOCKED);
-	struct page *page = NULL;
-	bool present = false;
-	struct folio *folio;
-
-	if (pmd_none(*pmd))
-		return;
-	if (pmd_present(*pmd)) {
-		page = vm_normal_page_pmd(vma, addr, *pmd);
-		present = true;
-	} else if (unlikely(thp_migration_supported())) {
-		const softleaf_t entry = softleaf_from_pmd(*pmd);
-
-		if (softleaf_has_pfn(entry))
-			page = softleaf_to_page(entry);
-	}
-	if (IS_ERR_OR_NULL(page))
-		return;
-	folio = page_folio(page);
-	if (folio_test_anon(folio))
-		mss->anonymous_thp += HPAGE_PMD_SIZE;
-	else if (folio_test_swapbacked(folio))
-		mss->shmem_thp += HPAGE_PMD_SIZE;
-	else if (folio_is_zone_device(folio))
-		/* pass */;
-	else
-		mss->file_thp += HPAGE_PMD_SIZE;
-
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
-		      locked, present);
-}
-#else
-static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
-		struct mm_walk *walk)
-{
-}
-#endif
-
-static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			   struct mm_walk *walk)
-{
-	struct vm_area_struct *vma = walk->vma;
-	pte_t *pte;
-	spinlock_t *ptl;
-
-	ptl = pmd_trans_huge_lock(pmd, vma);
-	if (ptl) {
-		smaps_pmd_entry(pmd, addr, walk);
-		spin_unlock(ptl);
-		goto out;
-	}
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
-		return 0;
-	}
-	for (; addr != end; pte++, addr += PAGE_SIZE)
-		smaps_pte_entry(pte, addr, walk);
-	pte_unmap_unlock(pte - 1, ptl);
-out:
-	cond_resched();
-	return 0;
-}
-
 static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 {
 	/*
@@ -1228,58 +1089,6 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 	seq_putc(m, '\n');
 }
 
-#ifdef CONFIG_HUGETLB_PAGE
-static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
-				 unsigned long addr, unsigned long end,
-				 struct mm_walk *walk)
-{
-	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	struct folio *folio = NULL;
-	bool present = false;
-	spinlock_t *ptl;
-	pte_t ptent;
-
-	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, pte);
-	ptent = huge_ptep_get(walk->mm, addr, pte);
-	if (pte_present(ptent)) {
-		folio = page_folio(pte_page(ptent));
-		present = true;
-	} else {
-		const softleaf_t entry = softleaf_from_pte(ptent);
-
-		if (softleaf_has_pfn(entry))
-			folio = softleaf_to_folio(entry);
-	}
-
-	if (folio) {
-		/* We treat non-present entries as "maybe shared". */
-		if (!present || folio_maybe_mapped_shared(folio) ||
-		    hugetlb_pmd_shared(pte))
-			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
-		else
-			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
-	}
-	spin_unlock(ptl);
-	return 0;
-}
-#else
-#define smaps_hugetlb_range	NULL
-#endif /* HUGETLB_PAGE */
-
-static const struct mm_walk_ops smaps_walk_ops = {
-	.pmd_entry		= smaps_pte_range,
-	.hugetlb_entry		= smaps_hugetlb_range,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
-static const struct mm_walk_ops smaps_shmem_walk_ops = {
-	.pmd_entry		= smaps_pte_range,
-	.hugetlb_entry		= smaps_hugetlb_range,
-	.pte_hole		= smaps_pte_hole,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
 /*
  * Gather mem stats from @vma with the indicated beginning
  * address @start, and keep them in @mss.
@@ -1287,40 +1096,90 @@ static const struct mm_walk_ops smaps_shmem_walk_ops = {
  * Use vm_start of @vma as the beginning address if @start is 0.
  */
 static void smap_gather_stats(struct vm_area_struct *vma,
-		struct mem_size_stats *mss, unsigned long start)
+				  struct mem_size_stats *mss,
+				  unsigned long start)
 {
-	const struct mm_walk_ops *ops = &smaps_walk_ops;
-
-	/* Invalid start */
-	if (start >= vma->vm_end)
-		return;
+	struct pt_range_walk ptw = {
+		.mm = vma->vm_mm
+	};
+	enum pt_range_walk_type type;
+	pt_type_flags_t flags = PT_TYPE_ALL;
 
-	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
-		/*
-		 * For shared or readonly shmem mappings we know that all
-		 * swapped out pages belong to the shmem object, and we can
-		 * obtain the swap value much more efficiently. For private
-		 * writable mappings, we might have COW pages that are
-		 * not affected by the parent swapped out pages of the shmem
-		 * object, so we have to distinguish them during the page walk.
-		 * Unless we know that the shmem object (or the part mapped by
-		 * our VMA) has no swapped out pages at all.
-		 */
-		unsigned long shmem_swapped = shmem_swap_usage(vma);
+	if (!start)
+		start = vma->vm_start;
+
+	flags &= ~(PT_TYPE_NONE|PT_TYPE_PFN);
+
+	type = pt_range_walk_start(&ptw, vma, start, vma->vm_end, flags);
+	while (type != PTW_DONE) {
+		bool locked = !!(vma->vm_flags & VM_LOCKED);
+		bool compound = false, account = false;
+		unsigned long swap_size;
+		int mapcount;
+
+		switch (type) {
+		case PTW_FOLIO:
+		case PTW_MIGRATION:
+		case PTW_HWPOISON:
+		case PTW_DEVICE:
+			/*
+			 * We either have a folio because vm_normal_folio was
+			 * successful, or because we had a special swap entry
+			 * and could retrieve it with softleaf_to_page.
+			 */
+			if (is_vm_hugetlb_page(vma)) {
+				/* HugeTLB */
+				unsigned long size = huge_page_size(hstate_vma(ptw.vma));
+
+				if (!ptw.present || folio_maybe_mapped_shared(ptw.folio) ||
+				    ptw.pmd_shared)
+					mss->shared_hugetlb += size;
+				else
+					mss->private_hugetlb += size;
+			} else {
+				account = true;
+				if (ptw.level == PTW_PMD_LEVEL) {
+					/* THP */
+					compound = true;
+					if (folio_test_anon(ptw.folio))
+						mss->anonymous_thp += ptw.size;
+					else if (folio_test_swapbacked(ptw.folio))
+						mss->shmem_thp += ptw.size;
+					else if (folio_is_zone_device(ptw.folio))
+						/* pass */;
+					else
+						mss->file_thp += ptw.size;
+				} else if (ptw.level == PTW_PTE_LEVEL && ptw.nr_entries > 1) {
+					compound = true;
+				}
+			}
+			break;
+		case PTW_SWAP:
+			account = true;
+			swap_size = PAGE_SIZE * ptw.nr_entries;
+			mss->swap += swap_size;
+			mapcount = swp_swapcount(ptw.softleaf_entry);
+			if (mapcount >= 2) {
+				u64 pss_delta = (u64)swap_size << PSS_SHIFT;
 
-		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE))) {
-			mss->swap += shmem_swapped;
-		} else {
-			ops = &smaps_shmem_walk_ops;
+				do_div(pss_delta, mapcount);
+				mss->swap_pss += pss_delta;
+			} else {
+				mss->swap_pss += (u64)swap_size << PSS_SHIFT;
+			}
+			break;
+		default:
+			/* Ooops */
+			break;
 		}
+
+		if (account && ptw.folio)
+			smaps_account(mss, ptw.page, compound, ptw.young,
+				      ptw.dirty, locked, ptw.present, ptw.size);
+		type = pt_range_walk_next(&ptw, vma, start, vma->vm_end, flags);
 	}
 
-	/* mmap_lock is held in m_start */
-	if (!start)
-		walk_page_vma(vma, ops, mss);
-	else
-		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+	pt_range_walk_done(&ptw);
 }
 
 #define SEQ_PUT_DEC(str, val) \
-- 
2.35.3


