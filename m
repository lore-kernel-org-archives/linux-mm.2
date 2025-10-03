Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402B2CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1348E000D; Fri,  3 Oct 2025 13:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978298E000A; Fri,  3 Oct 2025 13:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D618E000D; Fri,  3 Oct 2025 13:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74F998E000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:46:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2922211B02C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:46:17 +0000 (UTC)
X-FDA: 83957531994.10.4010CCE
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8014B1C0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:46:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UTYASEQM;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759513575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oNWiu2+oUY794rWhMeFavwyt00FjZeL072iyEDl7YH0=;
	b=ahwN5n62AMYlRWtaZBKNJ/H37ixz5N3rmbq0eHBz3T2yLvw6dBISz/IVuQJpCaAZFROxzr
	c7KcVYMwr7kJzBxi5q+rcZ6Lm2oh6w+CHJTOdRCz+ta9ty2gFnWxr2zrXH/y3rcIC9gJDk
	41l0TbcfsgQy1MwIg4zVAph/Jc6Ukeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759513575; a=rsa-sha256;
	cv=none;
	b=Khn7M0J/YepCFLe0M5IiMkOWyrYA6AURytGCkeNzNURsT/ZN8dmHZTDijMfd4xDNQgW57w
	rNFEYw6/n1QYAjbD6NzoeUf/LiBJXf/S0AnqsEMk+FIc17sHCyvlWSMo2aKg3VoD/OsWOm
	1uDE70jLzcMlemlOTP4X7x2KaGV2Les=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UTYASEQM;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-33255011eafso2543404a91.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 10:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759513574; x=1760118374; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oNWiu2+oUY794rWhMeFavwyt00FjZeL072iyEDl7YH0=;
        b=UTYASEQM+IeZdkrxb2x6X4OuiS9fGK9LrRfMNSEvSGVm8jTfnnUgrf+MATusQ3/I+Q
         NREkMKCRJG9+LROygTzdKS40aSQiN3j1RAvxV7TDFXnnmIp9Y2LiXvb/SiYqnnC3UW70
         rdDcTF0KVSjgTNar4YusIS0iJvZFz19HJXNFt/34qtLnVAVLWHylbJDrQaWUbZFYBGxS
         Ef5NqNKJmdAsQ1p/EoYE/MGdUZ3nXJeqzZvNpLtVApeGR4ZJsSDdoJPkXnFdmOnqHVyi
         gkmEsRodV+Bnh4Y2sksMiSBWya4AtIpfDzq1i5Bc9EzIZVTq6elm88+16K+kLqeApsfp
         L+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759513574; x=1760118374;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oNWiu2+oUY794rWhMeFavwyt00FjZeL072iyEDl7YH0=;
        b=QWkHdU3fqZm3oegUffJtctQ4temG1DtW8moGvdvyx8puOC+5SP/DVjG+yVucf7JGB8
         0MSUNRPZYJxAfFfEPD0CN3qnRglZm7M7WNXbZCbA7H5L1mR+8VdMP8B42hK7ogP67UBW
         cV9A+ZDm6yh3DKa04sHmMlu37OPCNNDz8DFbp5TMNwBrH1+JjX88S++HXpFg2kH8XXk4
         MV5DzRhz/gSvwXBj+XFVVS7zvDOQrkdqESikHcQKSA2L8n+qQ9dkpSISTCKVKSXYNiqF
         1ZJdj7AofswukPKTxoe6oHIQ5DuKzgiAniEdoN/v3XmbHJevJJPDC3prM5LszqC1gy0k
         lJug==
X-Gm-Message-State: AOJu0Yy/yrlP0NYM7yCv3lMXVDePsPchn38s7mM4khXImHJlRDm3Pn28
	Qo8edWC2NBROaXTcn1sA81Bc2djp5exa2WsbUfHUiUNE+UGiXpG8QeOx
X-Gm-Gg: ASbGncsSme15glluf4h6aFB+PXseYMLnxVNovKank3Hbsb5OMIqbBIRrE2F6sEFcNa6
	Du4ddd93hhjSv/WX/cCLAsAlVqkXT48ueXwTMGPEi8FG2IU/rD14i650CPXtNpxdpA4APlcFlCf
	Isyfl4uv29NWO/f3VJ79A6ej+eWbo8x0z7GVKqe0VjxutMKzJaNSncCRFepA53+xfnEuSRwGg/s
	+2+/SVkFA9KH2vRmGUMJZzQnIaItc+pB6VcDmP0tVGlseXwUe4hYayWKxuUTIPtw/zhMTXxJ5aD
	ehtKEUthRy+lCOnSo10GDYlWwI1Cp/3dvlYe5kG89m77tZKJ/DWfjR/ZM1rMEwki3zCWqwjAlEo
	wHtrDewMVZhTHzPRDCiT6MRLuBeCqdBN2K/KfceW+4mkGmcNY0m+qHG9FlEVPM5+GfKHYuqkjX5
	BpsLvbTz/8pchXo5/kg646EqHEww==
X-Google-Smtp-Source: AGHT+IGhNAhoxUdEhhWoPmYNGwknobI9JaYXWSCnKleeWR/UvDtXieXQKqYoy4C04Jsm1xwP15Ya1g==
X-Received: by 2002:a17:90b:3ec5:b0:32e:1b61:309 with SMTP id 98e67ed59e1d1-339c27865b8mr4941526a91.23.1759513574165;
        Fri, 03 Oct 2025 10:46:14 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:38c3:a5e9:d69a:7a4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339c4a0c666sm2838991a91.1.2025.10.03.10.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 10:46:13 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	broonie@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: [PATCH v3] hugetlbfs: skip PMD unsharing when shareable lock unavailable
Date: Fri,  3 Oct 2025 23:15:53 +0530
Message-ID: <20251003174553.3078839-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k7cniaoawyu5xzzad1f1rjogfrj9kjjk
X-Rspam-User: 
X-Rspamd-Queue-Id: 8014B1C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1759513575-115539
X-HE-Meta: U2FsdGVkX18AzrGuVaVf1GZtUsO2UizT9XF6jHkGcoakkaFohCb+755P/ZOyHm9/YUc3xLunCKWs7ewkCIjQvWdWucHzaTi/Tjcv70sd/7DfTyGe7hM+Mvr8B0SVD5MWHdeWIkEUt0zxsWkPZwuuPkB2udSr8TA19TD07PCiDJYowvKJ/5JZqAPCQFNw6GlJDs3RlF4YVMaqz6Wic0lNh9gUU3nyAcl3B1A12K8ITZ32tgKvATF+WT+Z7xXJp0mKzt82yhQVSfZ6M8p6SCs2xFMX8FdvSTokPsTUWYwmlIdV7uNEAE/uOXHJM5yGx7mnN66Yvn+x8gkSxuYp5eVUOiSEaTwhE+HeT+zdsA9We9GzrkeOjUL0BL+E6OHUDqgbWKpW0zFibUx4UJQafpXyTbGFNxXobABS8a5nQKxj3zln8y8Jp1jl0zl40vyiBVPs3wnuz7Wmlrr3fkqOHTrc/QcBB8jv0mcLUzvq1hCJZfiYPcz8jlLbF0Uy3Vw2WVyQ45gv34EvorkSUI8dIsqsBGH/4MdiqnqH0dCmXAxEQTQmBmkfC839cwtlKC3udMsUA/5zwbEKFNu91eNZfsYFfs9Z0qMJMRGtadUG+WV//9nNlSrl2QJ1MmgRf3seaaBJ0GCb8FQZq+EoKa/WIdclt0DiLt3S5xiujTUVTAh4w+1gIkJ3mEgEyljEY4dEdrfXqXzh5JGd6kSOcfD3nuAXq+vupeWuHkCblpNDZaY1AuGxY4bQDvyMNfjYFStTAAwAJgjprsQtifD0whcbyn2nFo5INh1IKfRhW8cMLgrnwI5iYnojBRshSbMU/cEF5RkVK1PNgIkS0MFUoLciQeNrZPW3tJDyilN3SK9tb/SYUsVXzCvse6u08Oe1leDC9VbrT2tcPeIiI++x2SkZL23qox72pEYSyMff7T3z3NUqtBvtGLWhDDtoo1UwzOpH43O/fp+Q95x3cTWLgJg5zxH
 YIXmcUKO
 4fCiorQkv5TcVjLExtBvUAadcXmEkqdHtzlszsqUCCjGZSaICb+zKGCfCl40suqwE/9LMAZJI2+DriWAUp//ny5/1gwAdquH8WeGVbP4aqzWX9fMqm2mOlze/ysEivQNYS7Rj3ChTdIi1fAupIOlIm3OR+vQXIcQv/k7on74kKZ3doG7Pl5fsq9JOgLg2WWFRm8mV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When hugetlb_vmdelete_list() cannot acquire the shareable lock for a VMA,
the previous fix (dd83609b8898) skipped the entire VMA to avoid lock
assertions in huge_pmd_unshare(). However, this prevented pages from being
unmapped and freed, causing a regression in fallocate(PUNCH_HOLE) operations
where pages were not freed immediately, as reported by Mark Brown.

The issue occurs because:
1. hugetlb_vmdelete_list() calls hugetlb_vma_trylock_write()
2. For shareable VMAs, this attempts to acquire the shareable lock
3. If successful, huge_pmd_unshare() expects the lock to be held
4. huge_pmd_unshare() asserts the lock via hugetlb_vma_assert_locked()

The v2 fix avoided calling code that requires locks, but this prevented
page unmapping entirely, breaking the expected behavior where pages are
freed during punch hole operations.

This v3 fix takes a different approach: instead of skipping the entire VMA,
we skip only the PMD unsharing operation when we don't have the required
lock, while still proceeding with page unmapping. This is safe because:

- PMD unsharing is an optimization to reduce shared page table overhead
- Page unmapping can proceed safely with just the VMA write lock
- Pages get freed immediately as expected by PUNCH_HOLE operations
- The PMD metadata will be cleaned up when the VMA is destroyed

We introduce a new ZAP_FLAG_NO_UNSHARE flag that communicates to
__unmap_hugepage_range() that it should skip huge_pmd_unshare() while
still clearing page table entries and freeing pages.

Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Reported-by: Mark Brown <broonie@kernel.org>
Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

---
Changes in v3:
- Instead of skipping entire VMAs, skip only PMD unsharing operation
- Add ZAP_FLAG_NO_UNSHARE flag to communicate lock status
- Ensure pages are still unmapped and freed immediately
- Fixes regression in fallocate PUNCH_HOLE reported by Mark Brown

Changes in v2:
- Check for shareable lock before trylock to avoid lock leaks
- Add comment explaining why non-shareable VMAs are skipped
---
 fs/hugetlbfs/inode.c | 22 ++++++++++++----------
 include/linux/mm.h   |  2 ++
 mm/hugetlb.c         |  3 ++-
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9c94ed8c3ab0..519497bc1045 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -474,29 +474,31 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 	vma_interval_tree_foreach(vma, root, start, end ? end - 1 : ULONG_MAX) {
 		unsigned long v_start;
 		unsigned long v_end;
+		bool have_shareable_lock;
+		zap_flags_t local_flags = zap_flags;
 
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
-
+
+		have_shareable_lock = __vma_shareable_lock(vma);
+
 		/*
-		 * Skip VMAs without shareable locks. Per the design in commit
-		 * 40549ba8f8e0, these will be handled by remove_inode_hugepages()
-		 * called after this function with proper locking.
+		 * If we can't get the shareable lock, set ZAP_FLAG_NO_UNSHARE
+		 * to skip PMD unsharing. We still proceed with unmapping to
+		 * ensure pages are properly freed, which is critical for punch
+		 * hole operations that expect immediate page freeing.
 		 */
-		if (!__vma_shareable_lock(vma))
-			goto skip;
-
+		if (!have_shareable_lock)
+			local_flags |= ZAP_FLAG_NO_UNSHARE;
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
-		unmap_hugepage_range(vma, v_start, v_end, NULL, zap_flags);
-
+		unmap_hugepage_range(vma, v_start, v_end, NULL, local_flags);
 		/*
 		 * Note that vma lock only exists for shared/non-private
 		 * vmas.  Therefore, lock is not held when calling
 		 * unmap_hugepage_range for private vmas.
 		 */
-skip:
 		hugetlb_vma_unlock_write(vma);
 	}
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 06978b4dbeb8..9126ab44320d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2395,6 +2395,8 @@ struct zap_details {
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
 /* Set in unmap_vmas() to indicate a final unmap call.  Only used by hugetlb */
 #define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
+/* Skip PMD unsharing when unmapping hugetlb ranges without shareable lock */
+#define  ZAP_FLAG_NO_UNSHARE         ((__force zap_flags_t) BIT(2))
 
 #ifdef CONFIG_SCHED_MM_CID
 void sched_mm_cid_before_execve(struct task_struct *t);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6cac826cb61f..c4257aa568fe 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5885,7 +5885,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		}
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, address, ptep)) {
+		if (!(zap_flags & ZAP_FLAG_NO_UNSHARE) &&
+		      huge_pmd_unshare(mm, vma, address, ptep)) {
 			spin_unlock(ptl);
 			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
 			force_flush = true;
-- 
2.43.0


