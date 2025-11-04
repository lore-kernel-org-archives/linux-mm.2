Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FBFECCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 08:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9114E8E0100; Tue,  4 Nov 2025 03:57:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2DA8E00E7; Tue,  4 Nov 2025 03:57:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE468E0100; Tue,  4 Nov 2025 03:57:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9CA8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:57:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F39912B925
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:57:31 +0000 (UTC)
X-FDA: 84072321102.07.BE617A9
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf21.hostedemail.com (Postfix) with ESMTP id 77BFC1C000A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:57:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=20PiZ8oN;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762246649; a=rsa-sha256;
	cv=none;
	b=TAKVYyXUPr29ta2CKLK9Gr2GZFOKy0XLYjY7xsK4+7FpBT7nKExkRt8ZiF4ME02/uVrNyh
	At+1Bmz02vmutLm6zNJ2u7555qh5RDSgw5zxFsEj012dyGjsCGE2F0Sw3bJZnIqyQUxQUP
	TMkDUPYDEVpjJ1Xbr6fZ3sFBFiCki1o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=20PiZ8oN;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762246649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6uA4RnHTBZED1WXfmm1fAhiBpv74dGlrzIUuR9tJ4ds=;
	b=KJbsJ7WaUYdxGUePgwTpABFQhdBIKPxbx9uwH17UKOCrb1C7C76PnaMD0keym7hnOEWeZx
	xbGflkLCUvj0CXt2YbwkO3GZfg5fEsqPRecg7UiZW68IzU8VbL3QoEotQZZQd0x2E2PdbM
	RQXNWaSu53qD3pPTOl6grjGK94j+Ucw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6uA4RnHTBZED1WXfmm1fAhiBpv74dGlrzIUuR9tJ4ds=;
	b=20PiZ8oNBoUlKXElCF4Qa4hnhlQzp1BjbLx7zrIVKqVM2jBOHUvT4DnHWiiLy9wRO4MGubTHx
	shM0lf47mf4wacFxcbXLmhBq423n6QrU31+StyXpCSXxtnH5JDBa+wcBZcjPRr+0PwKdMUi7q/e
	t+2GHydZV8VYemtF1CgNKgM=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d12Nh1GKnzKmSt;
	Tue,  4 Nov 2025 16:55:48 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 63F43140230;
	Tue,  4 Nov 2025 16:57:23 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 16:57:22 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] mm: kill mm_wr_locked from unmap_vmas() and unmap_single_vma()
Date: Tue, 4 Nov 2025 16:57:09 +0800
Message-ID: <20251104085709.2688433-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77BFC1C000A
X-Stat-Signature: 5cb1nsb97zgfh3y3c3ygmth87aaquwsa
X-HE-Tag: 1762246648-508634
X-HE-Meta: U2FsdGVkX1/BWKMQ8TxFYivlBzG+8CknVOryG7SPyjUMMftZnHDrDxI6NKxuaP/ndEkPw9RzR/JzDWdQMRFnbZXhizbpWy7cqLFrQVTLdPTj3HazqfvSB86gAE9ysFg8fGDDsSQaujvc3WomJqzAFt3NbNUmBSD+bU0fGG9NEznRgT5vWGgeRsZtIZfY2PxHiodri5QFaIwXDeG5q+ae7nZ/ZbvYyVnLMJVGPhntyfKDhMD0xhdKA+iXqGQeegF0bVYfDEgmEiHUSeMPBz/CiEKoAo/Qu4k5DUpuqZ0PAaUfV2D/Hs5lBACjCD8x60mHAlUZ14CGreD5mFYYzq2fRBjxItM27nBXP2orJ3KXJ+XFpElu8hob+Caxa29bwR2YlmKx3sVk2Ly12qoRaURlVJc7CQBaxgPHht1DzQs/zpJ3u+YioXkC24dlVgjTkvfrXgFTX+7CYz2KXlE5DRaiwQh/3ZsMdPr0YPOobYJFrgAyK7W9FPG/Z2eV3m5uVAxxhMdktVR++XBXunRL5kJeMW21K1t6im3pb3ICjdmx0+u3ChApjmpNeUM/AWmTa/3gZTA3srqpOv46+o3OhcaJ3anfM54ale/V9HxEj359GrwnibisWQ+xw4GBi8Jzpw15fXq+9eEMB+lcuK/3wP51uIbigQpP6SuSol1Qx4GHFAJTgLoDXQeLcHpFAygnd6CkovGa0DPh5GQ4rFdnjliO/4Btb9J5AOr0o2XuEUErcy44gGQj+3800CLXh0SIhKepWlyXMQk9UAdqiGpw1owcPRsTbyyRfheVtOZ9e4SlJX+jXLhEqgvrKNZU1wFAWfkvYuDVBRQ58aIuvOiUu2vJUrLmohRZqO9JXnWaQzfYpg+UxoEdQg2qou7DSdjqoN9iaTEnKEOAlOGWDGwrssOpw7O/5/s2JJJ9Sg+6J6nFZ1h+PnVseys4Ow82OyOx/Vh7Uj5X6+byNYBoCpYOFIK
 ax5/Jbl+
 f1lJp7EujMgTgCYCrfFUtBt/tj7kzKX/UjvuKN2XR7S4UwLydE6te+HrnCCxnujB5KBTAxB6Qul544i+yxD2aQ/yeQ+j7nLy2DWhXU3haQGx1G/5k9DLI/hAsDNR9WRb5MgDPppfNoZG9xBst6l5iOUc6YUUCOalQcl3IPsalky5/ilkuPv6wgoHZXYgDH/5QgLLRAbqYqXsvwSZtzu+g4aiAx/las6BYvOXS1HLAW6QN6YaD3mnz10k+CwUVxqfIHmPF9mL738+qvAOZRqSHh984m8oPh1qAMsVOC9J7MSvOPwl7HwQiLc2RaDFo4SIQTG8Irp6vf2tzCLGjkesGwlgrZw9kgwPyGFdUZzetvBXh2bSx66i5UIo0+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kill mm_wr_locked since commit f8e97613fed2 ("mm: convert VM_PFNMAP
tracking to pfnmap_track() + pfnmap_untrack()") remove the user.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/mm.h               |  2 +-
 mm/memory.c                      | 12 ++++--------
 mm/mmap.c                        |  2 +-
 mm/vma.c                         |  5 ++---
 tools/testing/vma/vma_internal.h |  3 +--
 5 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f27c3687ea43..9909e35ebb8d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2471,7 +2471,7 @@ static inline void zap_vma_pages(struct vm_area_struct *vma)
 }
 void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *start_vma, unsigned long start,
-		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
+		unsigned long end, unsigned long tree_end);
 
 struct mmu_notifier_range;
 
diff --git a/mm/memory.c b/mm/memory.c
index 4c3a7e09a159..1a1626bba55a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2023,8 +2023,7 @@ void unmap_page_range(struct mmu_gather *tlb,
 
 static void unmap_single_vma(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr,
-		struct zap_details *details, bool mm_wr_locked)
+		unsigned long end_addr, struct zap_details *details)
 {
 	unsigned long start = max(vma->vm_start, start_addr);
 	unsigned long end;
@@ -2070,7 +2069,6 @@ static void unmap_single_vma(struct mmu_gather *tlb,
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
  * @tree_end: The maximum index to check
- * @mm_wr_locked: lock flag
  *
  * Unmap all pages in the vma list.
  *
@@ -2085,8 +2083,7 @@ static void unmap_single_vma(struct mmu_gather *tlb,
  */
 void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, unsigned long tree_end,
-		bool mm_wr_locked)
+		unsigned long end_addr, unsigned long tree_end)
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
@@ -2102,8 +2099,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		unsigned long start = start_addr;
 		unsigned long end = end_addr;
 		hugetlb_zap_begin(vma, &start, &end);
-		unmap_single_vma(tlb, vma, start, end, &details,
-				 mm_wr_locked);
+		unmap_single_vma(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(mas, tree_end - 1);
 	} while (vma && likely(!xa_is_zero(vma)));
@@ -2139,7 +2135,7 @@ void zap_page_range_single_batched(struct mmu_gather *tlb,
 	 * unmap 'address-end' not 'range.start-range.end' as range
 	 * could have been expanded for hugetlb pmd sharing.
 	 */
-	unmap_single_vma(tlb, vma, address, end, details, false);
+	unmap_single_vma(tlb, vma, address, end, details);
 	mmu_notifier_invalidate_range_end(&range);
 	if (is_vm_hugetlb_page(vma)) {
 		/*
diff --git a/mm/mmap.c b/mm/mmap.c
index 644f02071a41..4f51ca644903 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1274,7 +1274,7 @@ void exit_mmap(struct mm_struct *mm)
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
-	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
+	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX);
 	mmap_read_unlock(mm);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index 919d1fc63a52..0c5e391fe2e2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -483,8 +483,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
-		   /* mm_wr_locked = */ true);
+	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
@@ -1228,7 +1227,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
 	update_hiwater_rss(vms->vma->vm_mm);
 	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
-		   vms->vma_count, mm_wr_locked);
+		   vms->vma_count);
 
 	mas_set(mas_detach, 1);
 	/* start and end may be different if there is no prev or next vma. */
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index d873667704e8..c68d382dac81 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -848,8 +848,7 @@ static inline void update_hiwater_vm(struct mm_struct *mm)
 
 static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		      struct vm_area_struct *vma, unsigned long start_addr,
-		      unsigned long end_addr, unsigned long tree_end,
-		      bool mm_wr_locked)
+		      unsigned long end_addr, unsigned long tree_end)
 {
 }
 
-- 
2.27.0


