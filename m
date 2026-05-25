Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 484A2CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A186B0096; Mon, 25 May 2026 12:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2676B0098; Mon, 25 May 2026 12:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F79F6B0099; Mon, 25 May 2026 12:56:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B26B6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:56:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 565CC1C0391
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:56:11 +0000 (UTC)
X-FDA: 84806544942.24.4617034
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 25A0320013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:56:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CM3l5Lir;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2Hv4XgHv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CM3l5Lir;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2Hv4XgHv;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfkvnGWMnFduz6XN9C7dSVsfQC1CoypcMKVRfccukRA=;
	b=Wphl/QowlpqLyezTHVhwrrJbZZAkG3oLwBI2xGRDgj8GFq7eFF5flWUV52YH2ha+gXy07O
	IxEk0DffwodW87ICCgkkTOH/8be7Ewu8nfTOadqBWQ/sTA+CCBFJTvjkZwYvBEz4RNSnts
	z+rwTu26iJuXz5ppg3nCcz3KmCCg4aQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CM3l5Lir;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2Hv4XgHv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CM3l5Lir;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2Hv4XgHv;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728169; a=rsa-sha256;
	cv=none;
	b=bauP/rzm3PlXKyU9j5KahtYLQ0DJOMkzB8DFvFteZFLnv0YCbFjEoSGC40UOUOWL4JM2ho
	drjsf+Zo9QvQOWHvX+9u6LuyzyY4jbyW5/5VpJ9o7CjHKgF61nW+t8/BhfRVL4Iw913eHs
	h1GuwPDlrJ0QkmRNxXNh9T8GE59BitM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62FCF64DF5;
	Mon, 25 May 2026 16:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779728147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfkvnGWMnFduz6XN9C7dSVsfQC1CoypcMKVRfccukRA=;
	b=CM3l5Liri3t9JpTliCAaVapKeYMO357gJZf9Af6i2Du/222p5yMQfe2WiG1I9pYcdp/Btr
	G0P++3RFzK4eAAH7b7HB99Nstu6rWoPLXRKGOby4L2K9ExziUCTYR62CNiBBY3XwM2vrT7
	uXCSetqrk+NC0xqYFCEOSVhysFfBMWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779728147;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfkvnGWMnFduz6XN9C7dSVsfQC1CoypcMKVRfccukRA=;
	b=2Hv4XgHv+9cxi3fqNZJzZdas3miCeJo3b8XQHq0fMWs+1XtJ4j9fqHV5StxZH0gSl620OJ
	1MJxPG6qi/H5pHDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779728147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfkvnGWMnFduz6XN9C7dSVsfQC1CoypcMKVRfccukRA=;
	b=CM3l5Liri3t9JpTliCAaVapKeYMO357gJZf9Af6i2Du/222p5yMQfe2WiG1I9pYcdp/Btr
	G0P++3RFzK4eAAH7b7HB99Nstu6rWoPLXRKGOby4L2K9ExziUCTYR62CNiBBY3XwM2vrT7
	uXCSetqrk+NC0xqYFCEOSVhysFfBMWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779728147;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WfkvnGWMnFduz6XN9C7dSVsfQC1CoypcMKVRfccukRA=;
	b=2Hv4XgHv+9cxi3fqNZJzZdas3miCeJo3b8XQHq0fMWs+1XtJ4j9fqHV5StxZH0gSl620OJ
	1MJxPG6qi/H5pHDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F357159D4B;
	Mon, 25 May 2026 16:55:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yINSORJ/FGrlRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 25 May 2026 16:55:46 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH v3 5/8] mm: Make /proc/pid/smaps use the new generic pagewalk API
Date: Mon, 25 May 2026 18:55:25 +0200
Message-ID: <20260525165528.184397-6-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
References: <20260525165528.184397-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1yesjz9mop48jsebz8tttjb3u4ggsrm8
X-Rspamd-Queue-Id: 25A0320013
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779728168-772569
X-HE-Meta: U2FsdGVkX1+REcLZSSsVU3khdfGEA2B7ipiBMdp6p0WZCB7rPUUOl5viOeNqUv5dEmdZMum05mxrTVNtQZWHvdpeIw0mTnEfNsP7iZllskAxMVABx+S0mxZRXZDzULxg73G09OarTosG5F/S7RSIfJVpg7LdbazhyLCzvAWSVcMMFkdOTvmo2C4Y25E60o2IJe2Iy5L9CvanNAlsfKDe5e8USsWC253aeYrCP5ou9RT4ZRZQYr0TClJauMkGUUgsnykmu6bKz3USCviGAqbqaTnyNw2DguavjvZzk08yNm+1IrAfZqUtk4w6zfMCp43hqBv7uWmWghSo/8hZD1riRJQ0piO0vTI6c9TJfYRpwkdxRaVklLib4HWPNeoJNpw9dFPWKyOKGrkaqEDf1ca4c/KlKUv6cl1bYIu7Hbo0J/B6XINo+Gw9gAeIkRxTtD1oTOaXMG8g1s/Tk6+lepalhtdJZ/npXUlAWR2ZIym6y9RYkMEzJM0oiiOe1NPLL1tWvuz4NKmGwL+CBXjPZ1eibGCuYCIfol2GrCQlO3M4BDAy6912mrGWX42azQzTK/gCmZ2i0ICXYadNUv/IAtVUDew0f4ANvJLI8onM2NY07gaF5JGezVToH/kKwRL+LXbnq9+Ukj/Np0MqSoQmBTZHMPcQfgd7Ko0W2lygi46BmFuQ2qYV4vZMJKb8IGJ0CJevo9AHiXZyNVni+7KyHEJHqEZPNBGzNwoXanme70UMLw4BmFhni9USVHhX2BkbQ1FoRoY0/kQ5h2HqpMeuUGWPbH81oKzIQyoGgMILwx6kiTguDcK3QhXXOaX8J567ET4KijrJD//HMYR3c41PLF+VJlVPc5Wt0NcKzrn/wjE2rttckimUZ8TJKuzTa4vmKG6JGNZ/dMkQGGCEYc3cCNn/6+ctF1sC/5xAlnk5atCxkfDfkm78aTZAhzbARpbdy4LWNahhnmpL5f19hj2q9NG
 aVoOyMA1
 J5hlXadvzxFbDgdmaW1gk5vHrwlzhuRCltiQ0yNCBgHM43NQAKa2jMYqTafuJYCZu8RGSZ4NMmDiQALTKK++5aSZ+tIUtDk1e+5knsn8SOKamkcZC8fhYLNOVmO69TvuFW26tY5VtUR+yF9MFiZGv0SXtU42V7Kt9pUBpx96FfVYYi13spNYp4oVIAsQHz9r2Won+Vwb2FmXHyK8WhzOYiCUsEi4d9W0XSQyKNE7Yk9Io1s3imx4uzz2jM0I0JeB1N/DX
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
 fs/proc/task_mmu.c | 306 +++++++++++++++------------------------------
 1 file changed, 100 insertions(+), 206 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 751b9ba160fb..ce958f208b5e 100644
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
@@ -1287,14 +1096,20 @@ static const struct mm_walk_ops smaps_shmem_walk_ops = {
  * Use vm_start of @vma as the beginning address if @start is 0.
  */
 static void smap_gather_stats(struct vm_area_struct *vma,
-		struct mem_size_stats *mss, unsigned long start)
+				  struct mem_size_stats *mss,
+				  unsigned long start)
 {
-	const struct mm_walk_ops *ops = &smaps_walk_ops;
+	struct pt_range_walk ptw = {
+		.mm = vma->vm_mm
+	};
+	enum pt_range_walk_type type;
+	pt_type_flags_t flags = PT_TYPE_ALL;
 
-	/* Invalid start */
 	if (start >= vma->vm_end)
 		return;
 
+	flags &= ~(PT_TYPE_NONE|PT_TYPE_PFN);
+
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
 		/*
 		 * For shared or readonly shmem mappings we know that all
@@ -1309,18 +1124,97 @@ static void smap_gather_stats(struct vm_area_struct *vma,
 		unsigned long shmem_swapped = shmem_swap_usage(vma);
 
 		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE))) {
+		    !(vma->vm_flags & VM_WRITE))) {
 			mss->swap += shmem_swapped;
 		} else {
-			ops = &smaps_shmem_walk_ops;
+			flags |= PT_TYPE_NONE;
 		}
 	}
 
-	/* mmap_lock is held in m_start */
 	if (!start)
-		walk_page_vma(vma, ops, mss);
-	else
-		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+		start = vma->vm_start;
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
+
+				do_div(pss_delta, mapcount);
+				mss->swap_pss += pss_delta;
+			} else {
+				mss->swap_pss += (u64)swap_size << PSS_SHIFT;
+			}
+			break;
+		case PTW_NONE:
+#ifdef CONFIG_SHMEM
+			unsigned long addr = ptw.curr_addr;
+			unsigned long end = ptw.next_addr;
+
+			if (ptw.level == PTW_PMD_LEVEL || ptw.level == PTW_PTE_LEVEL)
+				mss->swap += shmem_partial_swap_usage(vma->vm_file->f_mapping,
+							      linear_page_index(vma, addr),
+							      linear_page_index(vma, end));
+#endif
+			break;
+		default:
+			/* Ooops */
+			break;
+		}
+
+		if (account && ptw.folio)
+			smaps_account(mss, ptw.page, compound, ptw.young,
+				      ptw.dirty, locked, ptw.present, ptw.size);
+		type = pt_range_walk_next(&ptw, vma, start, vma->vm_end, flags);
+	}
+
+	pt_range_walk_done(&ptw);
 }
 
 #define SEQ_PUT_DEC(str, val) \
-- 
2.53.0


