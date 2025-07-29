Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767DAC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159E46B0098; Tue, 29 Jul 2025 04:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C696B0099; Tue, 29 Jul 2025 04:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020916B009A; Tue, 29 Jul 2025 04:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E17596B0098
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:47:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADAFD1404A6
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:47:39 +0000 (UTC)
X-FDA: 83716673838.30.D422734
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7A0D7180007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:47:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=FhSkqwt0;
	spf=pass (imf24.hostedemail.com: domain of wangyuli@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=wangyuli@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753778857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VLq1PupNl4epQ/eqFgJeI/b4qy5mdRvi3g/owsVSuA0=;
	b=oX0LEFO8t+KzSWfcgIN4xO7N1Mi/uCglX8G3GliWaMKgUCtAGeYI3H5W4pW52t7i5LaMWR
	ixz2C230cKJltEc+pvYsGUl5KITNd1JB+JrIjQHtHKnSHFP2eTmjajNmUbwBoktB/Lgepm
	HnZTuGMQC6oYy4+Quw/PqfR9QVx1JiE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753778857; a=rsa-sha256;
	cv=none;
	b=BHvTBXhpeHL2V1Z2jjH0iNWnWCxxth5/YysBboj1mpzM1VFk60VXafRHm8AAqB+4ETDJgp
	aNfuiY/AENeqnq8+Mole8owkQAtHIirxuhGI+9TkdFo7dLBKMLKg/V6jRNlCfCG3vjj6qQ
	RqBZLPbBR2g5Sw02NWSsaeJjolDAZnI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=FhSkqwt0;
	spf=pass (imf24.hostedemail.com: domain of wangyuli@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=wangyuli@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753778838;
	bh=VLq1PupNl4epQ/eqFgJeI/b4qy5mdRvi3g/owsVSuA0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=FhSkqwt0nnPtAqm4q6BL39Jc3uxBS83jgcblHf5g0aqL3IzQBIZAoJIo5hkgPPTH3
	 Jh4twdN2KH0rIeM0/PXyxbIuucpH7yIUzewM7GzlAiAB7D1+vuCeHHtjDmjmjffgn2
	 seym/xN47xtjMvsj1hIbtGmwP6xnRS03ulKDDPzE=
X-QQ-mid: zesmtpip3t1753778825te45995f8
X-QQ-Originating-IP: tSCf3VyPzUnUetiPvgXt758R68S3WC3VgNrI2JAXLJI=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 29 Jul 2025 16:47:03 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3458122844410139732
EX-QQ-RecipientCnt: 12
From: WangYuli <wangyuli@uniontech.com>
To: akpm@linux-foundation.org,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz,
	jannh@google.com,
	pfalcato@suse.de
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	niecheng1@uniontech.com,
	guanwentao@uniontech.com,
	WangYuli <wangyuli@uniontech.com>,
	Jun Zhan <zhanjun@uniontech.com>
Subject: [PATCH] tools/testing/vma: Fix function parameter declarations for GCC 8.3 compatibility
Date: Tue, 29 Jul 2025 16:47:00 +0800
Message-ID: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NDxI9psdf3YV3rs/Uk6soLGD5nAjI0/HXoDZ1p+2PYOPR2S2BFwIibmh
	CsHbRkqMIPPkdWlFG5rjNvMG3WCYiXfHAj/PRqmur0tduhq9srmvTgKSRkimY4t/YPdDPF0
	aO1qB6b4KrJRZF3VethuVNe4VvoyAeugA+JOFpYXos+CpcOLNFXVz8+qCRX8bAEgPEqpeS1
	5SsFOnFWklX6AqoV+n0yFFP4MNXFmOfe1ngHweLQq7nqEZUK+hHxxU1ros2mbMFg/ARRJ8x
	7cVIbCkrkQYku9hU2+570PZUT0EYZ8SGWeFZEJEBOYtMK+N05OkIldnBdmrQ+bsMh1C8gMW
	FUCiYN1YkMX/uKRj/c/gM6D4n8JiG+06b17Mzi7TGCeduD4kyZ5mMMycXglG3hayVz9QUOd
	Ac2x1erNlzJdS6Zv3DkeuOHo6Wse6jzyKMBBg8M+j+kAr7KwQirVv0F0bzZulxcVVKa8YW9
	uesQToaiRpufzuXV1bZpWQy6vx70y/OCNy9czIJLyOYl0566tsTryX3jb0zcntJM1KueyZv
	isn0nPjvq9nUS/hfvEB7a8aQRFFSzkTl06Zrqe5UYNFC2fyQUehdiLH6KtVSkTOalofpxpG
	iSNTvTcBduH+STk51QwuvgC/ml130x8CoDRbezdTcfqgfVl/5gCWBRat7oJcW12GZVpig+r
	dr7SOkzrPU6+q7/xsnDkcpko6iApNNTChMCpMEhTO20HcXI79bqgXJromyaP6dxWQiNkYem
	YthoLCIdKm0HPHOu2X4YDDvh7ZJVP8c5aFLiGPpGPFmsZLTqTI6SjpW++QhakaCd3X5GQCl
	/9S+8vEbqhUTvpiuOG/08a8x5nrimNoaUKYgx308FKnAed4vjADTzglwlnab8WBLIJyFSTk
	/NUFeB20u8mEQcsHpwQs083W8dvHfWHJImgKyV3SFGto/9Tyhj3UkSZe2rvytmRQKpsknwC
	34o1i8rFPXvRb74CC5bLSdU0Jh693hznUYKdxyJoas1IS8uskbBxHFu01e4ulKybOI78+3Q
	m6M9ZFdYkwzHg6UTgD
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0
X-Rspamd-Queue-Id: 7A0D7180007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ux3tuuf1anizejhtm3w84j8txg1je5fz
X-HE-Tag: 1753778855-334352
X-HE-Meta: U2FsdGVkX1/8kOkEz55ArhVnsI7OrxHIXVUpiAPos0XwQb7FnpZ5/HL22hg9VbDz1zdTSenlbTUuk+ayo0KMwymkiQ6Z0NIfuF+te7CGXqacXsURoRP+P22xqEGvHEOoQzE1tFZwtipNeB7YVz02pVBPNcmTWsRLNcSCKr3NvmzWuBgiGuRoTz4KzRYEEys5Thd2eyyHvlcaTRvqZKkww5YrxOs0fWMrLdoGwUR+MEUo6RWTI9H1z5xN9xrssOMbR7HHj3M2FUoeGdIMyk3qKugO9ReAnrCAykZhoHZAW/Kb10DUuUBp0GFaP3wvr7o4IR8rOX+BLS00wsC43mQQ4i4VKJbhsivCi+DxqHS8/NgoO/1tMCBb8Jnz0GORAovgT2szoHCUHGkrRMfePE2gJ178jTGN6wqqjQWOiHHEClSXBDrcblTtBHzBYNS3iZ9u+FYIEc2zmXJVolb49XhQOd9Jv0N38/HROqLDxzz/rt0wl1ImSgCnNpCvJrITgx34FtFcZ4Isu6DJRrJw8npEM9scTKeITWWVxtnC26XSzleAZB+H/WsZ76n3YGvnk+kn4yJt7SJqk+VwarxJyWeiSVOQ2Ca1bqYMxxGVeF2dM/n1N5UrEZ3vuQgI24RlDxUy2u7gpmFb/MYNOD/Q++VC0dMpI9KZADQ9tCIJwABj68QXbdizG1H5fsRZqO7JlLpD5CEApcnjab9lW/ffnD6nsg4vuafOP5ZROK0qWhTdNfq7cal+jdMku/hLSG1qcmAupqCGutTcC3utFuPj72u+LTC/gY4Ec4k2aYqOLGLGohmUgWnvGiIGGv5DJspTmwPAuyCDuIgKgWoy6MQeXFLp4q+ITn0ATVsUiU39oBkNM2Xpi9RoZ1yEZRwPVkLZHqenorDWD3z84YcPstZu5f4pWhQWHCzJI14iTUkEcJ0xH5WimmF3CepL/CK8JyP2HOrmi/bMCmM222G+T4g73JN
 F7F1Rdwn
 yGJ9pnOOtU+um2Cciylezhxon3QdGl80OihMFkz9W2115RlQPFDWOZ6r9WwH/qDn0ApTwq/6vvRHik+EkL5IHKZ3z82L0H+DdNJqipDKCCWb4d7P18fQJ4Tm2L+mG88FPuzFXrYJJ7VLi6OpmF42f2W/3zSAi6iAPOrFzRPr3iseFLdNIRK3eJF8sMGI5fIQ/5Af+sriN1nbZJ24tHuxMXwH2bHmdhFVVkbLtvfrYVmFVo/dvxS9cznkt0O+ofEAV+0lUAKG0mxoEQ3Rq50eg7RVXTINEL8qxTUWrBHL3sXogFRuKADEYgWaYf96pFJTEFSxeDnaF408DpR/MxYDdIgZCMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Linux kernel's minimum GCC version requirement has been bumped
from 4.3 to 8.3, but this tool still fails to compile with GCC 8.3.

Older compilers would fail if did not include parameter names in
function declarations that contained parameter types; newer compilers
are more lenient about this.

Fix many errors like this:
  In file included from vma.c:10:
  vma_internal.h: In function ‘arch_validate_flags’:
  vma_internal.h:1218:40: error: parameter name omitted
   static inline bool arch_validate_flags(unsigned long)
                                        ^~~~~~~~~~~~~
  vma.c: In function ‘dummy_close’:
  vma.c:281:25: error: parameter name omitted
   static void dummy_close(struct vm_area_struct *)
                         ^~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Jun Zhan <zhanjun@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 tools/testing/vma/vma.c          |   2 +-
 tools/testing/vma/vma_internal.h | 110 +++++++++++++++----------------
 2 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/tools/testing/vma/vma.c b/tools/testing/vma/vma.c
index 2be7597a2ac2..390b6a711f97 100644
--- a/tools/testing/vma/vma.c
+++ b/tools/testing/vma/vma.c
@@ -278,7 +278,7 @@ static bool vma_write_started(struct vm_area_struct *vma)
 }
 
 /* Helper function providing a dummy vm_ops->close() method.*/
-static void dummy_close(struct vm_area_struct *)
+static void dummy_close(struct vm_area_struct *vma)
 {
 }
 
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 816e7e057585..4935460102e5 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -288,8 +288,8 @@ struct vm_area_desc {
 };
 
 struct file_operations {
-	int (*mmap)(struct file *, struct vm_area_struct *);
-	int (*mmap_prepare)(struct vm_area_desc *);
+	int (*mmap)(struct file *file, struct vm_area_struct *vma);
+	int (*mmap_prepare)(struct vm_area_desc *desc);
 };
 
 struct file {
@@ -840,11 +840,11 @@ static inline unsigned long vma_pages(struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
-static inline void fput(struct file *)
+static inline void fput(struct file *file)
 {
 }
 
-static inline void mpol_put(struct mempolicy *)
+static inline void mpol_put(struct mempolicy *policy)
 {
 }
 
@@ -852,15 +852,15 @@ static inline void lru_add_drain(void)
 {
 }
 
-static inline void tlb_gather_mmu(struct mmu_gather *, struct mm_struct *)
+static inline void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm)
 {
 }
 
-static inline void update_hiwater_rss(struct mm_struct *)
+static inline void update_hiwater_rss(struct mm_struct *mm)
 {
 }
 
-static inline void update_hiwater_vm(struct mm_struct *)
+static inline void update_hiwater_vm(struct mm_struct *mm)
 {
 }
 
@@ -890,15 +890,15 @@ static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 	(void)mm_wr_locked;
 }
 
-static inline void mapping_unmap_writable(struct address_space *)
+static inline void mapping_unmap_writable(struct address_space *mapping)
 {
 }
 
-static inline void flush_dcache_mmap_lock(struct address_space *)
+static inline void flush_dcache_mmap_lock(struct address_space *mapping)
 {
 }
 
-static inline void tlb_finish_mmu(struct mmu_gather *)
+static inline void tlb_finish_mmu(struct mmu_gather *tlb)
 {
 }
 
@@ -907,7 +907,7 @@ static inline struct file *get_file(struct file *f)
 	return f;
 }
 
-static inline int vma_dup_policy(struct vm_area_struct *, struct vm_area_struct *)
+static inline int vma_dup_policy(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	return 0;
 }
@@ -940,7 +940,7 @@ static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 	(void)next;
 }
 
-static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
+static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr) {}
 
 static inline void vma_iter_free(struct vma_iterator *vmi)
 {
@@ -957,31 +957,31 @@ static inline void vm_acct_memory(long pages)
 {
 }
 
-static inline void vma_interval_tree_insert(struct vm_area_struct *,
-					    struct rb_root_cached *)
+static inline void vma_interval_tree_insert(struct vm_area_struct *vma,
+					    struct rb_root_cached *root)
 {
 }
 
-static inline void vma_interval_tree_remove(struct vm_area_struct *,
-					    struct rb_root_cached *)
+static inline void vma_interval_tree_remove(struct vm_area_struct *vma,
+					    struct rb_root_cached *root)
 {
 }
 
-static inline void flush_dcache_mmap_unlock(struct address_space *)
+static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 {
 }
 
-static inline void anon_vma_interval_tree_insert(struct anon_vma_chain*,
-						 struct rb_root_cached *)
+static inline void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
+						 struct rb_root_cached *root)
 {
 }
 
-static inline void anon_vma_interval_tree_remove(struct anon_vma_chain*,
-						 struct rb_root_cached *)
+static inline void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
+						 struct rb_root_cached *root)
 {
 }
 
-static inline void uprobe_mmap(struct vm_area_struct *)
+static inline void uprobe_mmap(struct vm_area_struct *vma)
 {
 }
 
@@ -993,15 +993,15 @@ static inline void uprobe_munmap(struct vm_area_struct *vma,
 	(void)end;
 }
 
-static inline void i_mmap_lock_write(struct address_space *)
+static inline void i_mmap_lock_write(struct address_space *mapping)
 {
 }
 
-static inline void anon_vma_lock_write(struct anon_vma *)
+static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
 {
 }
 
-static inline void vma_assert_write_locked(struct vm_area_struct *)
+static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 }
 
@@ -1011,16 +1011,16 @@ static inline void unlink_anon_vmas(struct vm_area_struct *vma)
 	vma->anon_vma->was_unlinked = true;
 }
 
-static inline void anon_vma_unlock_write(struct anon_vma *)
+static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
 {
 }
 
-static inline void i_mmap_unlock_write(struct address_space *)
+static inline void i_mmap_unlock_write(struct address_space *mapping)
 {
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *,
-				  struct vm_area_struct *)
+static inline void anon_vma_merge(struct vm_area_struct *vma,
+				  struct vm_area_struct *prev)
 {
 }
 
@@ -1037,19 +1037,19 @@ static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 	return 0;
 }
 
-static inline void mmap_write_downgrade(struct mm_struct *)
+static inline void mmap_write_downgrade(struct mm_struct *mm)
 {
 }
 
-static inline void mmap_read_unlock(struct mm_struct *)
+static inline void mmap_read_unlock(struct mm_struct *mm)
 {
 }
 
-static inline void mmap_write_unlock(struct mm_struct *)
+static inline void mmap_write_unlock(struct mm_struct *mm)
 {
 }
 
-static inline int mmap_write_lock_killable(struct mm_struct *)
+static inline int mmap_write_lock_killable(struct mm_struct *mm)
 {
 	return 0;
 }
@@ -1074,11 +1074,11 @@ static inline void arch_unmap(struct mm_struct *mm,
 	(void)end;
 }
 
-static inline void mmap_assert_locked(struct mm_struct *)
+static inline void mmap_assert_locked(struct mm_struct *mm)
 {
 }
 
-static inline bool mpol_equal(struct mempolicy *, struct mempolicy *)
+static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
 	return true;
 }
@@ -1090,59 +1090,59 @@ static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
 	(void)vm_flags;
 }
 
-static inline bool mapping_can_writeback(struct address_space *)
+static inline bool mapping_can_writeback(struct address_space *mapping)
 {
 	return true;
 }
 
-static inline bool is_vm_hugetlb_page(struct vm_area_struct *)
+static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline bool vma_soft_dirty_enabled(struct vm_area_struct *)
+static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline bool userfaultfd_wp(struct vm_area_struct *)
+static inline bool userfaultfd_wp(struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline void mmap_assert_write_locked(struct mm_struct *)
+static inline void mmap_assert_write_locked(struct mm_struct *mm)
 {
 }
 
-static inline void mutex_lock(struct mutex *)
+static inline void mutex_lock(struct mutex *lock)
 {
 }
 
-static inline void mutex_unlock(struct mutex *)
+static inline void mutex_unlock(struct mutex *lock)
 {
 }
 
-static inline bool mutex_is_locked(struct mutex *)
+static inline bool mutex_is_locked(struct mutex *lock)
 {
 	return true;
 }
 
-static inline bool signal_pending(void *)
+static inline bool signal_pending(void *task)
 {
 	return false;
 }
 
-static inline bool is_file_hugepages(struct file *)
+static inline bool is_file_hugepages(struct file *file)
 {
 	return false;
 }
 
-static inline int security_vm_enough_memory_mm(struct mm_struct *, long)
+static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
 	return 0;
 }
 
-static inline bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long)
+static inline bool may_expand_vm(struct mm_struct *mm, vm_flags_t flags, unsigned long npages)
 {
 	return true;
 }
@@ -1167,7 +1167,7 @@ static inline void vm_flags_clear(struct vm_area_struct *vma,
 	vma->__vm_flags &= ~flags;
 }
 
-static inline int shmem_zero_setup(struct vm_area_struct *)
+static inline int shmem_zero_setup(struct vm_area_struct *vma)
 {
 	return 0;
 }
@@ -1177,20 +1177,20 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
 	vma->vm_ops = NULL;
 }
 
-static inline void ksm_add_vma(struct vm_area_struct *)
+static inline void ksm_add_vma(struct vm_area_struct *vma)
 {
 }
 
-static inline void perf_event_mmap(struct vm_area_struct *)
+static inline void perf_event_mmap(struct vm_area_struct *vma)
 {
 }
 
-static inline bool vma_is_dax(struct vm_area_struct *)
+static inline bool vma_is_dax(struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline struct vm_area_struct *get_gate_vma(struct mm_struct *)
+static inline struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
 	return NULL;
 }
@@ -1215,16 +1215,16 @@ static inline void vma_set_page_prot(struct vm_area_struct *vma)
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
 }
 
-static inline bool arch_validate_flags(unsigned long)
+static inline bool arch_validate_flags(unsigned long flags)
 {
 	return true;
 }
 
-static inline void vma_close(struct vm_area_struct *)
+static inline void vma_close(struct vm_area_struct *vma)
 {
 }
 
-static inline int mmap_file(struct file *, struct vm_area_struct *)
+static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
 	return 0;
 }
-- 
2.50.0


