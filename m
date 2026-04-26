Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D470FF8862
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0421A6B0098; Sun, 26 Apr 2026 08:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35EE6B0099; Sun, 26 Apr 2026 08:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72A26B009B; Sun, 26 Apr 2026 08:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D62866B0098
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:58:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B03C1602EB
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:58:02 +0000 (UTC)
X-FDA: 84700709604.16.FF22FD8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8758F20006
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:58:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777208280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tl8UwLNXnp3rOkzAfxH2F15eArPJ2lFSIvX4yekdjKs=;
	b=7SKowv2OYo+pA2pm58i8a34qZ4XYqOIpb0ksfWQvH7E8ePHHv20wxbP/NZgBInoRzwJHHB
	0hwlVQIiby1fXkUfUrDJJtmyJR9y0lIBvKbSueRYF3g062UX2iD7kejVR10D9woz7E+a+k
	7IE84WIzmUwI8EEz5zjI+BecmeOcwz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777208280; a=rsa-sha256;
	cv=none;
	b=iTHd6+TuyeOkDDnCAqYQvEzt5iWWZikeO1QWzWNMfkuCU4Gw5CX6pk+91mpJ5qeQysGbOm
	F8XnTC3GWEKGRmGBJvtfbjqaNCfMISbqEBHpVdOvSwbOU+HVVawN/PopeUkZdB/MLDH6fO
	aELAcQ/ZbhcUPs+C59CffaGyxPgA0xM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 751B35BD0A;
	Sun, 26 Apr 2026 12:57:42 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14739593B1;
	Sun, 26 Apr 2026 12:57:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kGzYAsYL7mmtRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 26 Apr 2026 12:57:42 +0000
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
Subject: [RFC PATCH v2 6/7] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
Date: Sun, 26 Apr 2026 14:57:18 +0200
Message-ID: <20260426125719.24698-7-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260426125719.24698-1-osalvador@suse.de>
References: <20260426125719.24698-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8758F20006
X-Stat-Signature: zw7wxwfiwmfjnchzjzokxmxq8r4cqqmw
X-Rspam-User: 
X-HE-Tag: 1777208280-749249
X-HE-Meta: U2FsdGVkX1/NvH50n/oXwdPKkSDEDeCTpVWI5DZMrr0G6GlO2xNCuGd2kA9iXCS/pOHfhBnR6LQ8aDan3Q5UMaL4wwYeqABDp5SpH1DihhmXW70IXpsQcbcgcPAUE/OTsbqRhzgm89CdUTPusWvGRbZ6HXoh4nNoPs6XwQZTIxhnsRKkURk5KCDb3qAg4uqco6wD4L3MfOXfrkrcBZE4EiuOWtLjkF3Uof3K7TQXrvBrN1+UlapzwSDoJT8jWxi3rf4QOvM6rfi5uAEWJz6U/dx2vJGrtzWcEcYoa3LN/8Eb/kiEr5ftVpG6yXMbXeFePH93KHmQ99NOokvUq3c351vAxlyb81J8UwdubqiS8hoWEQ8qFcu1ihJYUwqEkUZ/OjmoF7I5cKoRlJJ303vfWvG+P41ixo7eIoJ19IZ+tQnuxAFUtl4/0KNEpQp/RPG2fBP7NulTZlcUMV9poDRMOnyjW1GbwjutPgAGoVDSDy74JPdk69mF81tCvgb2WD+pW8abRuJEdQvkOfW5EeBuf06BBTFV5NaB1Io4TO6iDGx2O1RiXj3MmTAFFCp+OMFbIjtsqIS85ZkdPtUwLX997B+lITKb7QdA1sOK8j8XQmd/pWHdW1pbOJ3eH4xIKTNlcjO93cLEU9/h96LH9or25v/NFhB+FkSxTaUSxfA3SXMP0rgk1eYaAQEiTKGVdkpJjZLF8+/MURQpVLm+OK+ae4A4QU3/yv4PTmb7xJ1zvrH+GF4+6KcvM8cBbvdqQ62Grq7bA4ITvLJpO8NJ1tVENOgZNqZpBuh6lsizLJRgjuf2M3oeVoR8EAGDpF0mtmGz1pJZqgJOklunT8FtdrOW3foq2LxZxY3IPU9IutIACRtSXmsof8IE82po96atweVcJ4vbPB1qW0YKg8lQ9Zoua/sqjUq1aDaTpB6LtY+gPqFFCoDGgc4GvNeljLS0BfOYKx9yn29FsMHe/uD/SrI
 d+lSK4Yj
 HJRY/4nSuqX5ysaMtTFAXRQx414UYWILh2b/REIcZoK3KNosxHxrKsfXb0WqBG6myTUQzQSjX79e45RtHws5lyzJmtEmHFkrTVJkwXYFWSiV7eUGQuvOHUdGsfghCCY28kT71DCvwmrYnlzjKLXUM4zq7WxjNVtS086eVsyFzG56P4W0=
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
index 382c6b02d0e1..5c8a4b5250a1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3061,131 +3061,6 @@ static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty,
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
@@ -3197,9 +3072,15 @@ static int show_numa_map(struct seq_file *m, void *v)
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
@@ -3230,8 +3111,32 @@ static int show_numa_map(struct seq_file *m, void *v)
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
+			nr_pages = ptw.nr_entries;
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
2.35.3


