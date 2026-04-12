Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44578E937EF
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 17:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBD46B009E; Sun, 12 Apr 2026 13:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D3B6B00A1; Sun, 12 Apr 2026 13:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C4F6B00A2; Sun, 12 Apr 2026 13:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 869D06B009E
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:43:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 279C65BAAE
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:14 +0000 (UTC)
X-FDA: 84650625108.21.DC654B6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA0132000A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dgU1NRMv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6hljExyn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dgU1NRMv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6hljExyn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776015792; a=rsa-sha256;
	cv=none;
	b=wCKileA5dHoocuNNVB7z2zgJsWv2T4rdfT8UZSmME/MzDouOg9BS2fO68j0Zt7xbpiNKhz
	J4lKN0zRoxgiJ7wX3JeeLRtKOvthaF8vTaja61NWUTmjO0pOTorLFMYG8fWcXQwcHq/J4i
	SZMtBlD9XeGT/06+zGyhU9ZDdZjEx/Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dgU1NRMv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6hljExyn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dgU1NRMv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6hljExyn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776015792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0M6XziQ2IXEafjsL1pugEtyiZe4RP/OzEyf3hhTlfvw=;
	b=r8WlaQTPSiJiDEUSVFeM0XDe52WpMtIWn+2W9NSh5SQyAaVQEbA56NSeYllX/hvknS30l5
	X9rLXrDfiYLJA0z5MYUDHfIPX/JMmFYYTvSynneksnx0lH4JypHn3oaWc8h8koUogMwJG8
	FWqV48F96VghN8rnwAS28QkIBP9UAL4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 689BC6A86F;
	Sun, 12 Apr 2026 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0M6XziQ2IXEafjsL1pugEtyiZe4RP/OzEyf3hhTlfvw=;
	b=dgU1NRMvEc63f/Bc89kah5Wzjf0TVlp4Orq4tR2lDDIA5j6UKBuH2WJeu73Nx4WSwGq8sy
	QIRAiKDBuqn/+OH54GaIYH+YDbcvgzbaf9w9TBWeIURhiDgm4oKiFVfVRLkPAjaEFzsACu
	8vVEYUFHLdWE9Jp2SUCoAmogNwIUcxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0M6XziQ2IXEafjsL1pugEtyiZe4RP/OzEyf3hhTlfvw=;
	b=6hljExynyYqJN6CMan72X4pFgo78XwzTtblhO8UTu2wLkwG/Y0xvlv/CjZ4HRK1SqJ6qiD
	3e+rCuO8kDVQ0pAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0M6XziQ2IXEafjsL1pugEtyiZe4RP/OzEyf3hhTlfvw=;
	b=dgU1NRMvEc63f/Bc89kah5Wzjf0TVlp4Orq4tR2lDDIA5j6UKBuH2WJeu73Nx4WSwGq8sy
	QIRAiKDBuqn/+OH54GaIYH+YDbcvgzbaf9w9TBWeIURhiDgm4oKiFVfVRLkPAjaEFzsACu
	8vVEYUFHLdWE9Jp2SUCoAmogNwIUcxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0M6XziQ2IXEafjsL1pugEtyiZe4RP/OzEyf3hhTlfvw=;
	b=6hljExynyYqJN6CMan72X4pFgo78XwzTtblhO8UTu2wLkwG/Y0xvlv/CjZ4HRK1SqJ6qiD
	3e+rCuO8kDVQ0pAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E66624AA48;
	Sun, 12 Apr 2026 17:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0PW4NafZ22miRQAAD6G6ig
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
Subject: [RFC PATCH 6/7] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
Date: Sun, 12 Apr 2026 19:42:43 +0200
Message-ID: <20260412174244.133715-7-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260412174244.133715-1-osalvador@suse.de>
References: <20260412174244.133715-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: bxtjko5ucq7q7do1mimx1qqund7wchxw
X-Rspamd-Queue-Id: EA0132000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776015791-657682
X-HE-Meta: U2FsdGVkX18flYXn++miSajD8G6rTHjYUB+3FgVQKGe3biF24WMf0xy7ihQjnrFuvKz9ed+YK5tHXNndPGtPQTpmDuTkee4mioWMNA9OgnSBW5XMH2FlxCTKixrgJAn2lfFpsJ+P0eSqqw9ho+JbgM1JsSasxdaSzZ/MZpTVxNO4IPLoXtUvamqkGzNCQyCdXOnCrZWV0sryviWbNzr2XS4B9Pl6zbm3T8G1dDDC5g5NWbBtwjmizhP62idek0LQEH5FiVSDPJ5dL+7FOt/4vnIPnbLQThXMIVdZHoKF65rm5rLC9Oioec43hUZfCxmch3yHwqhZMvqquGuZ8wSl5bMjZNb3G50gcR4eJoeiEGuyIosHdq/6hSqlcCkzaApGdApmreqg9z6Tc4eYijkbr59e+fUuFG11tlsFO8yh4+tO6QBNZ8RWXp1+9KX+RXkwyc3/HwUIvT217yN8QUfhDRATcqc8G7DTJLkH6QOd97udtizSuwFovXzdYuDDc7u/QUS8vf8B4yCoSvI2mQhzK+geli1LWKVYfdrTXW7T2zkFEfP6LOfdOnQagmLDPriDP8nj3PTjyBi07P4PIT7djeXA4XJK8ae+Ma2Kc5r5PA1wL5v3N5qDaPsCiha+D7xn97MmPzFcqrT7yNEvUT9cyAI6Ds/hynyC0sdmFrFfDVVr3CzXLN9y4pYzeGFLzfIErGnFMe1amc5W6emN82Hroo9RY2lpPeitiXWnaiJFHIu8yVwt1axe9L3CzaZAx/eIQy4y1IP/zRB59q/RkCtrYFSSPuWhyugMFzPopNqFP5nEhTkyaMQF+w0t4ee/ujvStnezrymwhfiplWzU9vEXaXFDXMtrb21fDQMs+6YBc2JvhZbjw1nylNuPAWQ6geAAVCoE15mp0dqViTz4ImG//gQWN01irMP88hkwBfPfUz7o6jdXRjr/2FjAthNxpuLQr/aS7nZgWUjamprWOQI
 q4R/5DrT
 P0ZLNqn0xzgcGUiblyVS5HGr+JbJqOSAIlQ5V84hJaDjFaroUmlbstGikaKKAl5Bw6Yk4EASisBbL8xef+eV9EUaoT1sQWbP2fSzdgk9Ant5vACj4weHrMxJKQ2BTz+V7vyqRU5pZnAOSsyUx6mWLhKFz9GzwkFwnl6vd23a0M3V3xI39C1cZBs/S5GRf+oPl6x8Go/+TI4/ZTYBmZdT91txvfsHCoFB3zxc61FaQVnO2Qp4U/g2A13XkOjKNJ+EwCP1hlJP/3hDxiyk26Cm4UxVf6hk8UvldTI/KXCjOnIepZnajwAX+twbjjA==
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
 fs/proc/task_mmu.c | 136 +++++++++++----------------------------------
 1 file changed, 32 insertions(+), 104 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index afbcdb11ad80..776e7a6baf00 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3048,108 +3048,6 @@ static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
 	return page;
 }
 
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
@@ -3161,9 +3059,15 @@ static int show_numa_map(struct seq_file *m, void *v)
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
@@ -3194,8 +3098,32 @@ static int show_numa_map(struct seq_file *m, void *v)
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


