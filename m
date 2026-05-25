Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AF5CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2CFE6B008C; Mon, 25 May 2026 12:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03706B0093; Mon, 25 May 2026 12:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF31B6B0095; Mon, 25 May 2026 12:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A85366B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:55:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7340014018B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:54 +0000 (UTC)
X-FDA: 84806544228.03.E0CC662
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6EA6380005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9UtPK8ZySRCwCPokAYheIk0fS8huLR0i1NKEL6uib3g=;
	b=eQCXjinPj+vZgBLrz+fCcxuGMrpwktmC1WRDVdhpryAFZe1OQG5pbmz3GnGZ4jRSXA7vy6
	RgFz4CLBoUFEZ9IUimSewN5c8ea2hJWuwNv7ZP5kWwinmom1M6aqoV0cCwh9TXzNK8z8qG
	EON7UqurRof1GYt0sLln8CDkCzP1Xss=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728152; a=rsa-sha256;
	cv=none;
	b=6uAsRclx1Nx/N6cGRpORvofVwRzYUYkKC0Z/HhRIoK4q1IJczI1GZVdcmjcj/6qFJv3Q6H
	oA560wIKFAIuiOxdvWeP1KjN/VUVMa0ScDq4qu5azr/857cgafhX6nov7QIeWnG4xh/g5M
	w2ipqPXAuTToXbP9oKANCBOAAf47sX0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D4C0567D58;
	Mon, 25 May 2026 16:55:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 707F059D4D;
	Mon, 25 May 2026 16:55:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6KpdGRN/FGrlRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 25 May 2026 16:55:47 +0000
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
Subject: [RFC PATCH v3 6/8] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
Date: Mon, 25 May 2026 18:55:26 +0200
Message-ID: <20260525165528.184397-7-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
References: <20260525165528.184397-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: bt64feis3yeot9a8k8aiytxg4c78p6zb
X-Rspamd-Queue-Id: 6EA6380005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779728152-153646
X-HE-Meta: U2FsdGVkX1+EYBZA+lXGkUkhtTWqq5mOc2deyGVcTL6ZQRT7EdHm6UiYRrzJWkdg5QVoY8DXlOvRAt8FzU9qNtzUkF7GeiD5zSQdnXlfpr0HeriB6kVfWaVFVJGIAg62bRZdVU8XKZgzipBB7bZLm3Wv/Zq+ljUe8RdKZaJ1gFJqeypvJALqiBT0XFCb5W+9vlt3H909aZ6orCB8faJszOtx+awDtZNrquvtjQzbKJ/EXUIectayQufTDNd+zXu2DUsifXfMdF5xuY+rwX3MwuDG70ofGoplx9V86Xz7S02n6HXIAexvkGhUfSeVoapCoBVY5qzZah4aYbgTlokoHMRGcRla3Or00p9EahUWgWMPpC56GnQiHmoPMHczOFAOo2RQ1Sisbxs3u7lgYETRjoyoED6lU6Fs6tUrh3lZTZcvuKkcywYQXuYrfOe8Nf2YmesYwqkGLIBSQ2y+IlXwKk1jX0qkSRXRpf8RORHCgE2dJJaFmr4OlljePYFOp944osb0oqvR8Nl3np7dQyAJ2DrNsWhhQ/FD5Jmi9R0KC3WjYLPresaa+o/sBHa9HEk6IanEktziXKqD8FHRCniFmYqtbPHkOdpcKV/xqa4Jz0KMegXIrphZvcw21Kq/HYQg1PUJutBCTZUdIaLbab/4XqWaEnl1dDTBz0f5lEaG/AMOYnKoO7IvDzSoWBmR0tyqDVwq4z3UHHQ8emRCwhTc2QZt0mDd+arAxF0/0gAnSXZXePOgDzk9/J6Y5VxDtFiRqadYsM5WHaWmKqtfb/6Gelzq+UndcFtnyrjiU165LulFTbEj9ogc7LHshzXdhbZiTRiYYRS5t8I89Sw4NR1GrawI1kEyDwSHq8NLnhYLABlnFdetco3CbLFyhmxlXXjRdWtiZBma3B/dvAbSM8M4QOeYy5GRsL5mli0WTGGRlXxI6zezfPS+ME7hEqm39soH5Dwu5RvAS7waBnQZhQ3
 kf5760Xn
 1gc8QmMraUJMFnKfFAso/xSd0O1CQYO8kiWqI8p6KeFuteprispWYzw9zZ3YBq421BuPV2BD9uSiIbPeaBn3YCfo34XYHETD5UT5vdU7GyAaltbQqAoqebauVah/krUJg/Tx8EIRmM/YpJALrwjrXxitictBLi+n5ikg4H/chknQtUSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Have /proc/pid/numa_maps make use of the new generic API, and remove
the code which was using the old one

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 fs/proc/task_mmu.c | 159 +++++++++------------------------------------
 1 file changed, 32 insertions(+), 127 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ce958f208b5e..b9ca47f0bc18 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3060,131 +3060,6 @@ static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty,
 	md->node[folio_nid(folio)] += nr_pages;
 }
 
-static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
-		unsigned long addr)
-{
-	struct page *page;
-	int nid;
-
-	if (!pte_present(pte))
-		return NULL;
-
-	page = vm_normal_page(vma, addr, pte);
-	if (!page || is_zone_device_page(page))
-		return NULL;
-
-	if (PageReserved(page))
-		return NULL;
-
-	nid = page_to_nid(page);
-	if (!node_isset(nid, node_states[N_MEMORY]))
-		return NULL;
-
-	return page;
-}
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static struct page *can_gather_numa_stats_pmd(pmd_t pmd,
-					      struct vm_area_struct *vma,
-					      unsigned long addr)
-{
-	struct page *page;
-	int nid;
-
-	if (!pmd_present(pmd))
-		return NULL;
-
-	page = vm_normal_page_pmd(vma, addr, pmd);
-	if (!page)
-		return NULL;
-
-	if (PageReserved(page))
-		return NULL;
-
-	nid = page_to_nid(page);
-	if (!node_isset(nid, node_states[N_MEMORY]))
-		return NULL;
-
-	return page;
-}
-#endif
-
-static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
-		unsigned long end, struct mm_walk *walk)
-{
-	struct numa_maps *md = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	spinlock_t *ptl;
-	pte_t *orig_pte;
-	pte_t *pte;
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	ptl = pmd_trans_huge_lock(pmd, vma);
-	if (ptl) {
-		struct page *page;
-
-		page = can_gather_numa_stats_pmd(*pmd, vma, addr);
-		if (page)
-			gather_stats(page, md, pmd_dirty(*pmd),
-				     HPAGE_PMD_SIZE/PAGE_SIZE);
-		spin_unlock(ptl);
-		return 0;
-	}
-#endif
-	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
-		return 0;
-	}
-	do {
-		pte_t ptent = ptep_get(pte);
-		struct page *page = can_gather_numa_stats(ptent, vma, addr);
-		if (!page)
-			continue;
-		gather_stats(page, md, pte_dirty(ptent), 1);
-
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap_unlock(orig_pte, ptl);
-	cond_resched();
-	return 0;
-}
-#ifdef CONFIG_HUGETLB_PAGE
-static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
-		unsigned long addr, unsigned long end, struct mm_walk *walk)
-{
-	pte_t huge_pte;
-	struct numa_maps *md;
-	struct page *page;
-	spinlock_t *ptl;
-
-	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
-	huge_pte = huge_ptep_get(walk->mm, addr, pte);
-	if (!pte_present(huge_pte))
-		goto out;
-
-	page = pte_page(huge_pte);
-
-	md = walk->private;
-	gather_stats(page, md, pte_dirty(huge_pte), 1);
-out:
-	spin_unlock(ptl);
-	return 0;
-}
-
-#else
-static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
-		unsigned long addr, unsigned long end, struct mm_walk *walk)
-{
-	return 0;
-}
-#endif
-
-static const struct mm_walk_ops show_numa_ops = {
-	.hugetlb_entry = gather_hugetlb_stats,
-	.pmd_entry = gather_pte_stats,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
 /*
  * Display pages allocated per node and memory policy via /proc.
  */
@@ -3196,9 +3071,15 @@ static int show_numa_map(struct seq_file *m, void *v)
 	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
+	struct pt_range_walk ptw = {
+		.mm = mm
+	};
+	enum pt_range_walk_type type;
+	pt_type_flags_t flags;
 	char buffer[64];
 	struct mempolicy *pol;
 	pgoff_t ilx;
+	int nr_pages;
 	int nid;
 
 	if (!mm)
@@ -3229,8 +3110,32 @@ static int show_numa_map(struct seq_file *m, void *v)
 	if (is_vm_hugetlb_page(vma))
 		seq_puts(m, " huge");
 
-	/* mmap_lock is held by m_start */
-	walk_page_vma(vma, &show_numa_ops, md);
+	flags = PT_TYPE_FOLIO;
+	type = pt_range_walk_start(&ptw, vma, vma->vm_start, vma->vm_end, flags);
+	while (type != PTW_DONE) {
+
+		if (!ptw.folio || !ptw.page || PageReserved(ptw.page))
+			goto not_found;
+
+		nid = page_to_nid(ptw.page);
+		if (!node_isset(nid, node_states[N_MEMORY]))
+			goto not_found;
+
+		if (is_vm_hugetlb_page(vma))
+			/*
+			 * As opposed to THP, HugeTLB counts the entire huge
+			 * page as one unit size.
+			 */
+			nr_pages = 1;
+		else
+			nr_pages = ptw.size / PAGE_SIZE;
+
+		gather_stats(ptw.page, md, ptw.dirty, nr_pages);
+not_found:
+		type = pt_range_walk_next(&ptw, vma, vma->vm_start, vma->vm_end, flags);
+
+	}
+	pt_range_walk_done(&ptw);
 
 	if (!md->pages)
 		goto out;
-- 
2.53.0


