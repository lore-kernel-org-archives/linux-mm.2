Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91171125857
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E1A6B008A; Wed, 11 Mar 2026 13:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF276B008C; Wed, 11 Mar 2026 13:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4136B0092; Wed, 11 Mar 2026 13:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D6CAF6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:26:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83ADD1602ED
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:26:03 +0000 (UTC)
X-FDA: 84534460206.20.010FE69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E832C1C0015
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:26:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qW//qMDT";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773249961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/cRHyJtfRWf7YnVaFKmedKspUK4vT2FISal727S5Kuo=;
	b=04k4qbZegb0W/eAp3AojrULRfwlPovOAFe/g4rWoL1X0wGsxF156D9g9noTQdMPJ1Rr2ib
	6QOMZoYAboHla3p0j57VdQrBHQI6xAYOYD/7RgxjxQeWi23VGFFY1iuOCsb7w0UVe6xwyu
	EuZBEJcG4snNGgR5MjvfX+X4JcRnqwA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qW//qMDT";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773249961; a=rsa-sha256;
	cv=none;
	b=AOLVlLpVS02FU2qZnpUmI1wfUeNiOlKiIUoOqCleKGnTpvVqdVv9nGJmtoO7Pqp7jxmfRJ
	uqOuCeVqS9qm8z9ijODKr3bpBRNLcodfo52Xw5E5X4BRS1FDr1mqLksS0R3+uJxpjZS3rK
	F5tri2j3pRe0A1b7FJ8EYo3nWj317G4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5869361420;
	Wed, 11 Mar 2026 17:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE2CC19424;
	Wed, 11 Mar 2026 17:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773249961;
	bh=VxzFdwK5BomklsvpZZhqobXHAFHf//CC8QYNa1lC21M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qW//qMDTN9l3K4RFZ4aKjbmKRIzEVbcsxU+DjhapouOY/hCn4xpJuchd3euhDk4gF
	 2FvEXorHzo0aLS5ruc2Q5U8dl2EfIMn3R7dGo4U/hVobzG4HDIuNRlNOYG880GL8cR
	 aHVzw0E8Rt9LPK064RAU8+cxVjnXtiuzPB1A9nLGHicvrhCVUTNLzerw/rxhOIyQdI
	 XOz4RmL6naN+xwarzFTeoiST9dBbehmvGNtID+wgeBjen72bQBsVE8z2cmwlkSxSvT
	 8uhlveZEHd7sUU2ToBjw7QcSi6+6GvGV+gFK4a3z/3w9i3M4H+5Zxq1u/NK8/jkFhs
	 boSwzuBbrngjg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jianzhou Zhao <luckd0g@163.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 2/3] mm: abstract reading sysctl_max_map_count, and READ_ONCE()
Date: Wed, 11 Mar 2026 17:24:37 +0000
Message-ID: <0715259eb37cbdfde4f9e5db92a20ec7110a1ce5.1773249037.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773249037.git.ljs@kernel.org>
References: <cover.1773249037.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E832C1C0015
X-Rspamd-Server: rspam08
X-Stat-Signature: ydgf617smbm8b475e4zbumt4mgwxj6x8
X-HE-Tag: 1773249961-47983
X-HE-Meta: U2FsdGVkX1/9mFN/dIyrLcnOIUcBWmAoaMJgkv0TZIJZ8MgQqOMhSChsLHr2SYfE6MNiVBN1IBqn6ZrYoPE1QJ9C12iLFFpq74vDDQ7PTnlwihR/aScWJekyoZ6S9tv9NVKe1Q1cuRq3G4QcvGrMhZkFV083aI7MXItx7GFEV6kqvrS2LtDWyKqGO5yncLzv4pUVkVtxWEmimuyt1Z1z4zH5CWzY/NY4uKaoTa2TOKYOC+/jgBAyu1CRb188LGTLjQvLRulYc2hXonPhYG4unGgfQUQ8E5gHnonx7hn17venThvLIdj7ybpPW3hi7FyhgF3Rq1qAI9NrYlJJpEE1YLLT/BnQYASlh32cPUP72L0oP8/youvyrn+utAUlXW05sHNlwYVSH1R2/GL8E1p+Dcxw+2tMgl8M/mbtOV6QnhwBzD+b6HrsJZREbVbdgvVEKDINw9tD/UiRKarVgJs0Cqa31JA2r/vPiXcFXPLFD8oKKbCEHQEMpuL0DbtzfGzIhdd+1NSigCvzMyK+dIlnx8Qkm4r9LU+b9jZ3pD395lkyCRcsN49jfZyNCgaBnfPJcvUavh0/MyjsHaC7YoTRq6+BW/vm2H4yzAYD7nAwcz5QC78mYsJ7/z1qQAJh/uVplHX6ldaM/hEA6cLARgnKgct2sw2sHIeDMUJqFZ+G1/twdCXtVyF2LwdfJSzQqFMU23PLLqd8WUEXgCOtQ/QjI/lkj4y7kMq6DiBYu5sLkracDUBI8rsYqo+JxApOE3TS/QX9sP9ZtomoU3lf0MqX50Qyxeoba/jbR4zEHOYSK//9xi6BQnrHM7JO9GA4po/UeJxHy1oxRsyIX1Iw5XviBZ0V3o+euFceOnknekT0xUxNDFYFWF0ZGzf+7SfRm8P593nxfk9PchQ80jvHxGVg2Tl6x6mQEsGoeUp8m4XUpEroMGteOjn2Ud3SmfPRpAzWV/zrSsz3ofWEWDUrUHn
 saJMbZx+
 dqNFx2tY6bzzAIFLGtDGKiVmRemFBT7w8+0DJmS1nU8FG7T3pDiGstG+58U/vZ8D+IX/fJVnAbuUOa438UoS2BVKXXIPVIY0JG/2GFa7UDp4BU1tgRjJi/oxTBQpFx+sEWACj+zUSkKDN2jF8ncTl44K5tubDIyI0Zo4JydMoe+alydsN83DYCSCEeTpnQQSw9bt0+kBlZc0E8xu3dda9ITBOzNZIhbKNOrVlyJmbOih3DV33T+CK41RPrmHyYPNiPuz80TP2iGF1j8JRBODL1pfMpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Concurrent reads and writes of sysctl_max_map_count are possible, so we
should READ_ONCE() and WRITE_ONCE().

The sysctl procfs logic already enforces WRITE_ONCE(), so abstract the read
side with get_sysctl_max_map_count().

While we're here, also move the field to mm/internal.h and add the getter
there since only mm interacts with it, there's no need for anybody else to
have access.

Finally, update the VMA userland tests to reflect the change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h                 | 2 --
 mm/internal.h                      | 6 ++++++
 mm/mmap.c                          | 2 +-
 mm/mremap.c                        | 4 ++--
 mm/nommu.c                         | 2 +-
 mm/vma.c                           | 6 +++---
 tools/testing/vma/include/custom.h | 3 ---
 tools/testing/vma/include/dup.h    | 9 +++++++++
 tools/testing/vma/main.c           | 2 ++
 9 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4c4fd55fc823..1168374e2219 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -207,8 +207,6 @@ static inline void __mm_zero_struct_page(struct page *page)
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
-extern int sysctl_max_map_count;
-
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
diff --git a/mm/internal.h b/mm/internal.h
index 95b583e7e4f7..68bc509757c9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1848,4 +1848,10 @@ static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
+extern int sysctl_max_map_count;
+static inline int get_sysctl_max_map_count(void)
+{
+	return READ_ONCE(sysctl_max_map_count);
+}
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index 843160946aa5..79544d893411 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -375,7 +375,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	/*
diff --git a/mm/mremap.c b/mm/mremap.c
index e8c3021dd841..ba6c690f6c1b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1045,7 +1045,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
 	 * source, which may split, causing a net increase of 2 mappings.
 	 */
-	if (current->mm->map_count + 2 > sysctl_max_map_count)
+	if (current->mm->map_count + 2 > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1813,7 +1813,7 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	 * net increased map count of 2. In move_vma() we check for headroom of
 	 * 2 additional mappings, so check early to avoid bailing out then.
 	 */
-	if (current->mm->map_count + 4 > sysctl_max_map_count)
+	if (current->mm->map_count + 4 > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	return 0;
diff --git a/mm/nommu.c b/mm/nommu.c
index c3a23b082adb..ed3934bc2de4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1317,7 +1317,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	mm = vma->vm_mm;
-	if (mm->map_count >= sysctl_max_map_count)
+	if (mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..07882d2040b1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -590,7 +590,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
-	if (vma->vm_mm->map_count >= sysctl_max_map_count)
+	if (vma->vm_mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	return __split_vma(vmi, vma, addr, new_below);
@@ -1394,7 +1394,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
-		    vms->vma->vm_mm->map_count >= sysctl_max_map_count) {
+		    vms->vma->vm_mm->map_count >= get_sysctl_max_map_count()) {
 			error = -ENOMEM;
 			goto map_count_exceeded;
 		}
@@ -2870,7 +2870,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 833ff4d7f799..adabd732ad3a 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -21,9 +21,6 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
 
-/* We hardcode this for now. */
-#define sysctl_max_map_count 0x1000000UL
-
 #define TASK_SIZE ((1ul << 47)-PAGE_SIZE)
 
 /*
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 5eb313beb43d..8865ffe046d8 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -419,6 +419,9 @@ struct vma_iterator {
 
 #define EMPTY_VMA_FLAGS ((vma_flags_t){ })
 
+#define MAPCOUNT_ELF_CORE_MARGIN	(5)
+#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
+
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
 	MMAP_NOTHING,		/* Mapping is complete, no further action. */
@@ -1342,3 +1345,9 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
 	swap(vma->vm_file, file);
 	fput(file);
 }
+
+extern int sysctl_max_map_count;
+static inline int get_sysctl_max_map_count(void)
+{
+	return READ_ONCE(sysctl_max_map_count);
+}
diff --git a/tools/testing/vma/main.c b/tools/testing/vma/main.c
index 49b09e97a51f..18338f5d29e0 100644
--- a/tools/testing/vma/main.c
+++ b/tools/testing/vma/main.c
@@ -14,6 +14,8 @@
 #include "tests/mmap.c"
 #include "tests/vma.c"
 
+int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+
 /* Helper functions which utilise static kernel functions. */
 
 struct vm_area_struct *merge_existing(struct vma_merge_struct *vmg)
-- 
2.53.0


