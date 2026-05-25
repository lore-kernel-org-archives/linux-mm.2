Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C3B3CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F6C6B009B; Mon, 25 May 2026 12:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7306B009D; Mon, 25 May 2026 12:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90D316B009E; Mon, 25 May 2026 12:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA696B009B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:56:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39D9C4019A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:56:23 +0000 (UTC)
X-FDA: 84806545446.30.9D32FA4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 33221180004
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:56:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iE1hjCH0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xYwfvlGy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iE1hjCH0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xYwfvlGy;
	spf=pass (imf06.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AWqlJ53Y4jJx9FgEpNOKN4WEbvz8ryM9BZb3tsdED0=;
	b=MT/9RaEqvyhcMkgh2hrQNcxqdu70kM+nDfcihoZSj8Q5WgTp43bW/VRfcL7nVOb/U0zoGe
	3LqulkwhG6ZlDl+JUmsI3Rbtd0H/eaoi6avYrnhvJDyeIMtpUggP9So+hXvxR0OEfIXPCM
	3Jm1Oeuy338xIDbTppSjknOYW0O6s+c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iE1hjCH0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xYwfvlGy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iE1hjCH0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xYwfvlGy;
	spf=pass (imf06.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728181; a=rsa-sha256;
	cv=none;
	b=WT4P7xogP29sK2CaEFPoyHhGJfsGtpWIbbhwr9cXiN9ITKYBrSChsrXRJ2O3F/pRoig4G3
	pV2SXlvdHwjTCzPpIPzA2KImf3b4iWwBA9KOvGTmQDcqANTIVd7Ko0FyoyO1B8Y0wEbst2
	qSPpCjlJ5Gz3pHSfICY2H7bk85nzm2o=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C7E1664DF8;
	Mon, 25 May 2026 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779728148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/AWqlJ53Y4jJx9FgEpNOKN4WEbvz8ryM9BZb3tsdED0=;
	b=iE1hjCH0NiH0vRWm0+J+8piqVnBh2VUvbYSqFJDMLTbCu10LBLcdEvL41L2ST9gy8+JlwV
	eB1K/Mh7YqxPsgItQ9q/vh9iCo0TTlMC79l2Ez8fuoI6swL2iK24LpV+mri1QMFYdGnpFa
	aiblaxH+E776TxsCGV48jCw6q1GOttY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779728148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/AWqlJ53Y4jJx9FgEpNOKN4WEbvz8ryM9BZb3tsdED0=;
	b=xYwfvlGybss6iC8IZF5rrBVbt5TVIGHvLvhcw2nTp1lTKWb6YrPljp/w51mgVIg4NG70dK
	OUa2yPqclX+UWRDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779728148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/AWqlJ53Y4jJx9FgEpNOKN4WEbvz8ryM9BZb3tsdED0=;
	b=iE1hjCH0NiH0vRWm0+J+8piqVnBh2VUvbYSqFJDMLTbCu10LBLcdEvL41L2ST9gy8+JlwV
	eB1K/Mh7YqxPsgItQ9q/vh9iCo0TTlMC79l2Ez8fuoI6swL2iK24LpV+mri1QMFYdGnpFa
	aiblaxH+E776TxsCGV48jCw6q1GOttY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779728148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/AWqlJ53Y4jJx9FgEpNOKN4WEbvz8ryM9BZb3tsdED0=;
	b=xYwfvlGybss6iC8IZF5rrBVbt5TVIGHvLvhcw2nTp1lTKWb6YrPljp/w51mgVIg4NG70dK
	OUa2yPqclX+UWRDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6385659D4B;
	Mon, 25 May 2026 16:55:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iC4zFhR/FGrlRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 25 May 2026 16:55:48 +0000
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
Subject: [RFC PATCH v3 8/8] mm: Make /proc/pid/clear_refs use the new generic pagewalk API
Date: Mon, 25 May 2026 18:55:28 +0200
Message-ID: <20260525165528.184397-9-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
References: <20260525165528.184397-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i6wfcfumweqqda71pwebnt4xhosyzon9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 33221180004
X-HE-Tag: 1779728180-155658
X-HE-Meta: U2FsdGVkX18zv5Ly8KzM0B1TS59k+FPKc3ILw9X3lRVNnfMwm0ncUCysV8l62hVFefLEREyDlqYNoJeNsbO233GHX9KaB+VkiuroxopxwF1ZlaNUFt4L49kjGR1cyjcQFDhhUTseRFTwHlkcLzK0X2Bg9daUh1XPzywwHsmr1ZIIrniMAqVKYT4A+f+GLyk31+R3AWOpPBBkGMDNs8zJOdSEr3zM88iXDNEOAZJsM6AbSUgN6j0zCBOAN2n/WX+hWOUw/0LrhaLf4ErxwRSkvFOZEFw7gKycpF9iSZes/F+MRWRspbenio+vwU+T3abVkpwTISXTIf1gFN9uMMW4/WF4buyACB7FbqR5abuzwgGbU/ESHUip2RyGZZF00Nso/LJDOa0glD2jDZCR2Tqdwc6W1HhFLfePB3AsH81/OVFkusbMa/pvz+OMlGc2s6l7wqtwOErXoHk7aXSQ4X8dNeH3v2sORSpI9gp+D4tcWu9Ek1t+7NNLd5aDL2DIlqIjH9C4w3MW952t2UcqMsT7WSOHUEKit9ShygXpV5We8N6wYubZiu8T83ZAaTg8f+QcG5ETHwUdXmjxlZf0DPRzxORHNzpNiO0B7RRCtu+7mw/u2M/iw2OAUHcJVQesT4kmhL/8Sh/whTFdw5a9QtaYl+uaS4i/sHCUQ5mhZ8o9H3IdUHFQrQDpbMhrbJk3gofDR/yJul5MOCwKd3+gQB0SGxQR9t7GF/U3ggSgYwEFndgen6AWyJYHQZl3IS17tNVggPhM/BT5lmfL70LJIHTLYklybS6tEV4GAEyqgCcN1s57IjOTsYeH5Iv6QJxD/KLLgacdHaf9NTByUA396D4VtgjIFvQrQRXL76DZGzzUArKx3IZltjlOw4Q8Tm6DaHPAGtZ7oVsIJZvLQaqpX70MqBruJhLnByKlpDyaDNAPqgGyyhYcn0Kf3b0oBYS02BSrLpLQc4qQ3emGJsMp1Jo
 7pSO2hQx
 jJfpgIvVD83oVviskobp2VmegTZXYnLOe/T78pzSKSgfX3xUAgCIHel4cVxelMECZQNt5rD+eYz5axbQlZK13zOeyY2kwhElekrxif7vdmB8IJC+GGYpIsfDyb1vmQUI5ZR83DMpVRpz/EZzT7+zE8yNBX3mUxxCuStl3xWYJtoylQKzNseoG9cd4zNstYxpBzwsfzrPWNTVWMVrV0CiKklDsU6Or5hrVLuk2ufjVHO40ShiGZE7yv+EtcBL+O3TQha17eQYYxdUG/q/wnpmdDXwdrpkl1NiJCg6nMixvTzcIK6A/XR1YnCdqZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Have /proc/pid/clear_refs make use of the new generic API, and remove
the code which was using the old one.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 fs/proc/task_mmu.c | 133 ++++++++++++++++++++++++---------------------
 1 file changed, 70 insertions(+), 63 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 20ffb26692cc..5f09a5b26b61 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1571,72 +1571,54 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 }
 #endif
 
-static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
-				unsigned long end, struct mm_walk *walk)
+static void clear_refs_pmd_range(struct pt_range_walk *ptw,
+				 enum clear_refs_types type)
 {
-	struct clear_refs_private *cp = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	pte_t *pte, ptent;
-	spinlock_t *ptl;
-	struct folio *folio;
+	struct vm_area_struct *vma = ptw->vma;
+	unsigned long addr = ptw->curr_addr;
 
-	ptl = pmd_trans_huge_lock(pmd, vma);
-	if (ptl) {
-		if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
-			clear_soft_dirty_pmd(vma, addr, pmd);
-			goto out;
-		}
-
-		if (!pmd_present(*pmd))
-			goto out;
+	if (type == CLEAR_REFS_SOFT_DIRTY) {
+		clear_soft_dirty_pmd(vma, addr, ptw->pmdp);
+		return;
+	}
 
-		folio = pmd_folio(*pmd);
+	if (!pmd_present(ptw->pmd) || !ptw->folio)
+		return;
 
-		/* Clear accessed and referenced bits. */
-		pmdp_test_and_clear_young(vma, addr, pmd);
-		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
-out:
-		spin_unlock(ptl);
-		return 0;
-	}
+	pmdp_test_and_clear_young(vma, addr, ptw->pmdp);
+	folio_test_clear_young(ptw->folio);
+	folio_clear_referenced(ptw->folio);
+}
 
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
-		return 0;
-	}
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		ptent = ptep_get(pte);
+static void clear_refs_pte_range(struct pt_range_walk *ptw,
+				enum clear_refs_types type)
+{
+	struct vm_area_struct *vma = ptw->vma;
+	unsigned long addr = ptw->curr_addr;
+	unsigned long end = pmd_addr_end(addr, vma->vm_end);
+	pte_t *ptep = ptw->ptep;
 
-		if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
-			clear_soft_dirty(vma, addr, pte);
+	for (; addr != end; ptep++, addr += PAGE_SIZE) {
+		if (type == CLEAR_REFS_SOFT_DIRTY) {
+			clear_soft_dirty(vma, addr, ptep);
 			continue;
 		}
 
-		if (!pte_present(ptent))
-			continue;
-
-		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio)
+		if (!ptw->present || !ptw->folio)
 			continue;
 
 		/* Clear accessed and referenced bits. */
-		ptep_test_and_clear_young(vma, addr, pte);
-		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		ptep_test_and_clear_young(vma, addr, ptep);
+		folio_test_clear_young(ptw->folio);
+		folio_clear_referenced(ptw->folio);
 	}
-	pte_unmap_unlock(pte - 1, ptl);
-	cond_resched();
-	return 0;
+
+	ptw->next_addr = end;
 }
 
-static int clear_refs_test_walk(unsigned long start, unsigned long end,
-				struct mm_walk *walk)
+static int clear_refs_test_vma(struct vm_area_struct *vma,
+			       enum clear_refs_types type)
 {
-	struct clear_refs_private *cp = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-
 	if (vma->vm_flags & VM_PFNMAP)
 		return 1;
 
@@ -1646,19 +1628,13 @@ static int clear_refs_test_walk(unsigned long start, unsigned long end,
 	 * Writing 3 to /proc/pid/clear_refs only affects file mapped pages.
 	 * Writing 4 to /proc/pid/clear_refs affects all pages.
 	 */
-	if (cp->type == CLEAR_REFS_ANON && vma->vm_file)
+	if (type == CLEAR_REFS_ANON && vma->vm_file)
 		return 1;
-	if (cp->type == CLEAR_REFS_MAPPED && !vma->vm_file)
+	if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
 		return 1;
 	return 0;
 }
 
-static const struct mm_walk_ops clear_refs_walk_ops = {
-	.pmd_entry		= clear_refs_pte_range,
-	.test_walk		= clear_refs_test_walk,
-	.walk_lock		= PGWALK_WRLOCK,
-};
-
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -1688,9 +1664,6 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	if (mm) {
 		VMA_ITERATOR(vmi, mm, 0);
 		struct mmu_notifier_range range;
-		struct clear_refs_private cp = {
-			.type = type,
-		};
 
 		if (mmap_write_lock_killable(mm)) {
 			count = -EINTR;
@@ -1712,13 +1685,47 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				vm_flags_clear(vma, VM_SOFTDIRTY);
 				vma_set_page_prot(vma);
 			}
-
+			vma_iter_init(&vmi, mm, 0);
 			inc_tlb_flush_pending(mm);
 			mmu_notifier_range_init(&range, MMU_NOTIFY_SOFT_DIRTY,
 						0, mm, 0, -1UL);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
+
+		for_each_vma(vmi, vma) {
+			struct pt_range_walk ptw = {
+				.mm = mm,
+			};
+			enum pt_range_walk_type pt_type;
+			pt_type_flags_t flags = PT_TYPE_ALL;
+			int ret;
+
+			/* We ignore hugetlb vmas */
+			if (is_vm_hugetlb_page(vma))
+				continue;
+
+			ret = clear_refs_test_vma(vma, type);
+			if (ret > 0)
+				continue;
+			else if (ret < 0)
+				break;
+
+			pt_type = pt_range_walk_start(&ptw, vma, vma->vm_start, vma->vm_end, flags);
+			while (pt_type != PTW_DONE) {
+
+				/*
+				 * Since we ignore hugetlb vmas, we just care for PMD
+				 * or PTE mapped pages.
+				 */
+				if (ptw.level == PTW_PMD_LEVEL)
+					clear_refs_pmd_range(&ptw, type);
+				else if (ptw.level == PTW_PTE_LEVEL)
+					clear_refs_pte_range(&ptw, type);
+
+				pt_type = pt_range_walk_next(&ptw, vma, vma->vm_start, vma->vm_end, flags);
+			}
+			pt_range_walk_done(&ptw);
+		}
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			mmu_notifier_invalidate_range_end(&range);
 			flush_tlb_mm(mm);
-- 
2.53.0


