Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 814BCC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7386B0092; Mon, 31 Aug 2026 05:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987A26B0095; Mon, 31 Aug 2026 05:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8B96B0096; Mon, 31 Aug 2026 05:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3266B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:10:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1475B8042C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:10:57 +0000 (UTC)
X-FDA: 85160994954.14.2E28482
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf24.hostedemail.com (Postfix) with ESMTP id 72DE7180009
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:10:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QGVSyqsm;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788167453;
	b=A6NP0+G5/ZSwdLDCMGj++KuZSJTo3104/895wGMR+OKSF8i9ImrwavE8BQ9+A/JB+KL65a
	JCSfEdbDtVUpiLsrTTrJgRjpCCMos8WUPeh7B2XSm4ttgU9ExNmBhPbwCS3KxRfPYmEDtN
	H9kx/iB0WcnujT2aXQYkhfgozrZHq7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788167453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8Eo7QMhdQ3M9V1QnYKplCQa1xPwiIVALWEZ6TYtEi2g=;
	b=PecRdZbLSL276tqwYrhuvoCMGOe2QTTGq6rz6IGaLyVPBvtFOls0yGnX/tkDyA0Yp9wBNc
	W/KP0byHvg6Wqefml59B81dlgfYES/SBJIP48qyYU7+GW2eNPFat2iaonta5DFH1JuJVJz
	sIai8CclTqjKdngWatgq26x5qaZ3Swk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QGVSyqsm;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788167447; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=8Eo7QMhdQ3M9V1QnYKplCQa1xPwiIVALWEZ6TYtEi2g=;
 b=QGVSyqsmZrBEHDNvJp+AAGgtVckvxUKBqOqUV7QYqMBeDqNioBnXhuf15krYgyDG/6iqzZ
 Rp17Dz5lGwrLvd7owblUUj78X/Cwrm/x/OJhIXdfFKyW/PLXgM4EfpMVlvFXC3MMaV4ypw
 PteHnKmc8Pqdtsaxg63wRDOrJevCocaGd3nOz59o9OpDAV3neAbWUsXfeeE9Nr95URmlll
 gNEFV2ygHO0I1PADWlf70XuOLb5R4lldiTsOx9lKQ9vrYzuIp5j3wDOvp75OLh1yB8r76F
 Ci3tEcWfbZ22MCEOnjfMP7XssdoXqyR00i4ZLc6+zN84LQIXlI+ZDjJnGOOLpQ==
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>, <aiqi.i7@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH] mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
X-Lms-Return-Path: <lba+26a954515+ea7c3c+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>
Date: Mon, 31 Aug 2026 17:10:23 +0800
Message-Id: <20260831091023.66581-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 72DE7180009
X-Stat-Signature: j4aq8ynwnke56aeefkhc36hzipahikyc
X-HE-Tag: 1788167452-200249
X-HE-Meta: U2FsdGVkX1+r6R2sI8VlH+AlJfHT9aD7SZXr7SQ0TKQsvJdYD4bRUPPfoadwRnXBGHoIeAiA+jqDG0OcmKCmhx5cuwkkF83HQCFB/Ihg4KJ6fKzNEFe04iftPx9fnAQ3OY3Q2dIl8X8ZP4pKJn+gWjP/LR/PGaOyYWMdYfVG7CDCazPl09sOPWJrIV5nK1t8NW+criyMMAfyXHf1keBVFk1hzjeFoH8s9r/Li33nRBKMIvmdLY4VhcfoA9XkGRj+Lp4rOeMk2JkWgFFf0lRH4mO9pAV07bU6AZGuqz99Rm3pPCMSt33ZeXSjAWUvnJJHSxJKOianBgB7JCtY1fCzASp+iljCWghV7Rf9scOUlLYNEwHwgJT7QWCUX+caVBlB3VT06Gh6nrL/vKtO8nROswGLkyqnL/HaDl9nUDFJVVaKb4cqqWvwGYv6wFwamonNoKvnnKcFSsdgBgfGkx6PfA39ozArEnWTSfgVqLce8xjDJil4Dq7K2Jg7BULBq07lMeLVYCunz7K28FY/YSvm9ZfsUWcV1O91m+2GyQjynoyuP7RZJIW9z0w2YityvGUJdPkHPnYgy7Hyht7uHFGU1PyEr3dFswlAcUGqnMpUJxUY1/tZ0CP7bMfA9lrrdf7oXMROws9uRYeCoflGWOgtn3suNXvGaf0LAAD2cTBec5DsTYL5BptQfFOPTF1DAwLZZ1tbmEPtG/cJvF8b9+UZW2DOSQOzN5dwFL5dL6lySbIFq0L+N5DfTr/O1rbVYTGkHyB4oqcHa6tuu0wCP74RYYOVUKAb7Dq4oCk/fpN0ncjarTt2RNuYiw51I5ubeZuzYHsat4Etz7r8+LUl+pYFyHK4i3ilwgP9AW1OBmNy7LhyO2ECD7QrfzsvWQL6PuXrNjSuC9L/fnQLQ+MIUTn5Sc0orYU4wN+P6cr+w7tHYhdX6UyhxIHySDgqWUMeme6vqsSXY2nUDCVSZ39NdpI
 BmSPh0xt
 USjDDTadW/MuXXEN31tcLcjhZXvdT7HPLyxobzH0LYVlruxs6O4Xs1eAY0N7riUJHrNJEIvq1rBVLIUBUBeOYTPUOeZ++G4Z9ZP4kX73McNoMMNmz6DsOHOIsmE4LZc4X22o+6aIlfxDbB4v9KfvfrYjuZQSYOhZ7s5AuYXSHbqKDpOgk+ti2o/b2+MzYcISPUC5xuMoicuq6N7VaZFlPnThAqPE2pPsRQlDfrOk46eBeBDFvvVselpKIdtB78o1rf3p1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
PMD sharing is possible. That is only needed when huge_pmd_unshare()
actually detaches a shared PMD page table, because clearing the PUD
invalidates the whole PUD-sized virtual address range.

For hugetlbfs hole punch and MADV_DONTNEED, a shared mapping can pass
the "PMD sharing is possible" range test in function
adjust_range_if_pmd_sharing_possible() even when the PMD table covering
the target 2M page is not shared. KVM then receives a 1G invalidation for
a 2M operation and zaps unrelated secondary mappings, so the guest has to
fault them back in.

Fix this by using the existing cheap "sharing possible" test only as a
gate, then inspect the candidate PMD tables under the locks held by the
hugetlb unmap paths. The notifier is expanded only for PUDs whose PMD
table is actually shared, while the other callers keep the existing
conservative expansion.

On a Redis-in-VM workload that punches cold 2M hugetlb pages, this
patch improves P99 QPS stability while punching pages, reducing the QPS
degradation ratio from 7.09% to 1.45%.

Reported-by: aiqi.i7 <aiqi.i7@bytedance.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 118 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 101 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7857728457952..e80e1118385f0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5353,16 +5353,105 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	huge_pmd_unshare_flush(tlb, vma);
 }
 
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static bool
+pmd_sharing_possible_range(struct vm_area_struct *vma, unsigned long start,
+			   unsigned long end, unsigned long *range_start,
+			   unsigned long *range_end)
+{
+	unsigned long v_start = ALIGN(vma->vm_start, PUD_SIZE);
+	unsigned long v_end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
+
+	/*
+	 * vma needs to span at least one aligned PUD size, and the range
+	 * must be at least partially within it.
+	 */
+	if (!(vma->vm_flags & VM_MAYSHARE) || !(v_end > v_start) ||
+	    (end <= v_start) || (start >= v_end))
+		return false;
+
+	*range_start = max(ALIGN_DOWN(start, PUD_SIZE), v_start);
+	*range_end = min(ALIGN(end, PUD_SIZE), v_end);
+	return true;
+}
+
+static void
+adjust_range_for_pmd_sharing(unsigned long *start, unsigned long *end,
+			     unsigned long range_start, unsigned long range_end)
+{
+	/* Extend the range to be PUD aligned for a worst case scenario */
+	if (*start > range_start)
+		*start = range_start;
+
+	if (*end < range_end)
+		*end = range_end;
+}
+
+static void
+adjust_range_for_shared_pmds_in_range(struct vm_area_struct *vma,
+				      unsigned long *start, unsigned long *end,
+				      unsigned long range_start,
+				      unsigned long range_end)
+{
+	struct hstate *h = hstate_vma(vma);
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long address;
+
+	hugetlb_vma_assert_locked(vma);
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+
+	for (address = range_start; address < range_end; address += PUD_SIZE) {
+		pte_t *ptep;
+		bool shared;
+
+		ptep = hugetlb_walk(vma, address, PMD_SIZE);
+		if (!ptep)
+			continue;
+
+		spin_lock(huge_pte_lockptr(h, mm, ptep));
+		shared = ptdesc_pmd_is_shared(virt_to_ptdesc(ptep));
+		spin_unlock(huge_pte_lockptr(h, mm, ptep));
+
+		if (shared)
+			adjust_range_for_pmd_sharing(start, end, address,
+						     address + PUD_SIZE);
+	}
+}
+
+static void
+adjust_range_for_shared_pmds(struct vm_area_struct *vma, unsigned long *start,
+			     unsigned long *end)
+{
+	unsigned long range_start, range_end;
+
+	if (huge_page_size(hstate_vma(vma)) != PMD_SIZE)
+		return;
+
+	if (!pmd_sharing_possible_range(vma, *start, *end,
+					&range_start, &range_end))
+		return;
+
+	adjust_range_for_shared_pmds_in_range(vma, start, end, range_start, range_end);
+}
+#else
+static void
+adjust_range_for_shared_pmds(struct vm_area_struct *vma, unsigned long *start,
+			     unsigned long *end)
+{
+}
+#endif
+
 void __hugetlb_zap_begin(struct vm_area_struct *vma,
 			 unsigned long *start, unsigned long *end)
 {
 	if (!vma->vm_file)	/* hugetlbfs_file_mmap error */
 		return;
 
-	adjust_range_if_pmd_sharing_possible(vma, start, end);
 	hugetlb_vma_lock_write(vma);
-	if (vma->vm_file)
+	if (vma->vm_file) {
 		i_mmap_lock_write(vma->vm_file->f_mapping);
+		adjust_range_for_shared_pmds(vma, start, end);
+	}
 }
 
 void __hugetlb_zap_end(struct vm_area_struct *vma,
@@ -5401,7 +5490,12 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				start, end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	/*
+	 * Only expand for PUDs whose PMD table is actually shared. The callers
+	 * hold i_mmap_rwsem and the hugetlb VMA lock for shared mappings, so PMD
+	 * sharing state cannot change before __unmap_hugepage_range().
+	 */
+	adjust_range_for_shared_pmds(vma, &range.start, &range.end);
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
@@ -6943,23 +7037,13 @@ bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
-	unsigned long v_start = ALIGN(vma->vm_start, PUD_SIZE),
-		v_end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
+	unsigned long range_start, range_end;
 
-	/*
-	 * vma needs to span at least one aligned PUD size, and the range
-	 * must be at least partially within in.
-	 */
-	if (!(vma->vm_flags & VM_MAYSHARE) || !(v_end > v_start) ||
-		(*end <= v_start) || (*start >= v_end))
+	if (!pmd_sharing_possible_range(vma, *start, *end,
+					&range_start, &range_end))
 		return;
 
-	/* Extend the range to be PUD aligned for a worst case scenario */
-	if (*start > v_start)
-		*start = ALIGN_DOWN(*start, PUD_SIZE);
-
-	if (*end < v_end)
-		*end = ALIGN(*end, PUD_SIZE);
+	adjust_range_for_pmd_sharing(start, end, range_start, range_end);
 }
 
 /*
-- 
2.20.1

