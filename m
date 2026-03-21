Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2991099B54
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 06:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE5616B0093; Sat, 21 Mar 2026 02:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96186B0095; Sat, 21 Mar 2026 02:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B7C6B0096; Sat, 21 Mar 2026 02:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 908DB6B0093
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:43:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1825E13AFCD
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:26 +0000 (UTC)
X-FDA: 84569128812.02.A02FD8E
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf02.hostedemail.com (Postfix) with ESMTP id 334C780008
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=u+lJBboI;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774075404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmudzNicNUiCl0daaMXprBQaBaWvZIMFkUgBsUIOa+M=;
	b=TQZhET09uvqvqsK4dOah1C+ddosdOcuMS7tfIFP5rQh5qRAT9DtnBNEKMN9KJdxHXUDhAJ
	W+gU20nRemqRQyqwt12xmMYumO6oUgwDUa/H7Asp+5jQm4DiRhHOJqIeJoUbyQDJeR7wv5
	Jf7XLXyjE5SllvcGtf75ANbkzCx6gUo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774075404; a=rsa-sha256;
	cv=none;
	b=ZJAIXfkDiEZKUrC1+TGL9K86vSPixVCQ9GFUSNY8e4Bk0pRYt59GOOF6yPgWC2nPDBUElD
	il2DqK8H84Y81hre80J/I9aCAbfFtSYntyY3Wk88M2osLcIm6q0l/WctPxlj4LcNphGih1
	vYYp5FpnTaDxh9xBMbrix5nzVts54NA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=u+lJBboI;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774075397; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=TmudzNicNUiCl0daaMXprBQaBaWvZIMFkUgBsUIOa+M=;
	b=u+lJBboITHxBZ0tkduExEewbnTaDUMk/qmkqIPyRWzcVsrD1lje6RDb449t2GWlJzOZ4rW3vi6VGie9Uy0YN/M1we5N7dJB1prrhcGr5dpSqa2jcF/2gliCCamXQFig9NFp+zQLweIMfaLwYxX9KUyMPVFPQFRVmuCXSjKkrBAw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.ODaLu_1774075394;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.ODaLu_1774075394 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 14:43:15 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org (open),
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] mm: change to return bool for the MMU notifier's young flag check
Date: Sat, 21 Mar 2026 14:42:54 +0800
Message-ID: <a9ad3fe938002d87358e7bfca264f753ab602561.1774075004.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
References: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 334C780008
X-Stat-Signature: 46tzstwdnb9yo7jjpcu5zhkop6tn4awi
X-HE-Tag: 1774075402-215585
X-HE-Meta: U2FsdGVkX1+W8v2DZm7PzwrxtvK1EnFTxKs+btm7iv2CkKqiBfl8QsyaqCeDuoaQVaRiZnJU3X3HojKZLuuX0l60HXz7ezeWQKJ4iUAbhsVwQ4xeG578vfmX7PWPdtLi7BMe3NdMJARrq+80tXCgoIZRtzTCR1UUS0M6AIchDRdFUOUo02xzmSBmn4rY4n4SiZMrFAck5fWwza6Ymerj/zEFvMEjTugSxFGFdVLbAgTlz5L3G+9BKibY1D/qflJEb8iqW/AXzR+AyKOFOgtONG3Vz7cdM1L2S61b3VQob0SmMaim4fvQdRJPzh18nPWk11aFoJdBbnN/49rFcSGbbrglM8Afrt1I8Vbv09UolTK5PCCOLjyRDSR7hoPP+SkbTbCHtCYafdCHKJDigNQ4rtJxWkjnKv2sTnpBAr7gqDcoFSSteDgCObjHKjdBpQzR0UlCxr8ozeBgTSHS8rkaKpazIgakwfQ87/7idFtjAJu91dtzNn3SJY+6B7gniR78uC3bk3OEmVmVdQA65rLGUuc/88qPWEwGwPhsZyqUQK2QrRFtZ/dLHNfoqKZeXD+HFF10Rrz0DWLVlZnqCBywbuUc3YsVPil5AB6CBWjzWnTNd/bTiigbTonvpV/WZw1Ov2BObDbsda0ItysGwVT3bxV2g7+uq3I7MflvE+U/PQ/n83Kgyr+2w9x+VnFQSo0kPYrEXkfI+yRXKRRgi2G2sZIBzgvBNLIThp9UagKzSOpLv5lpjQn4tGqlSV1HVK/9Fzny8l7T+PbWCcoDF61cAFWYJw1DWMKk9BxelT5dS3dlEg9zCAFszzt0eyvCYHBh//oBhvS3sFMkEqXilgdceNhDJskUxDX6m3qv9EoPTQy2cidvJlj2+N87fJW1tlqi9VS7fJ/kNEGbJcTDIpy8oWhcBqkyHaPszARH361NlVeQhwDTZw7RHF32wbDiM7k06NrkfhHCZvjIQrrjfkQ
 7IlJGDe5
 8SEVdDtz+4PRN6dyY740oO9bfJ/cEKku+lopMKVr54hLg/vrUDeJC1ziU7L7DMadklTCpNw69tv7l8zZUvxJ3N7vtvvy1YBawvvNhLiXMsP22nRPTGKSdOC8yZUGkSudRUQldu0R7DEX8Yb/2KiKbpbjnHSqZ07JsV4xprfDpRpzanTQISAYzM/j5n9NSU5EogNh5GFYoDVy+oeqbHlvWaLU8Jum7LagAE8FoXN8U5u4Q835xYqBnc3dW2KjLwpfjqPfTahVyFYUWg8CaWDJKOVVATcVNRf+E4nDs8UrAWZEgcixMrVlwI8gpwiCGU40vpOkZSaFMGfgI6dfnm2nzMf41JTxpsv77EzPm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MMU notifier young flag check related functions only return whether
the young flag was set. Change the return type to bool to make the
intention clearer.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmu_notifier.h | 76 +++++++++++++++++-------------------
 mm/internal.h                | 16 ++++----
 mm/mmu_notifier.c            | 23 +++++------
 virt/kvm/kvm_main.c          | 31 ++++++---------
 4 files changed, 66 insertions(+), 80 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 3705d350c863..17f2cdc77dd5 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -97,20 +97,20 @@ struct mmu_notifier_ops {
 	 * Start-end is necessary in case the secondary MMU is mapping the page
 	 * at a smaller granularity than the primary MMU.
 	 */
-	int (*clear_flush_young)(struct mmu_notifier *subscription,
-				 struct mm_struct *mm,
-				 unsigned long start,
-				 unsigned long end);
+	bool (*clear_flush_young)(struct mmu_notifier *subscription,
+				  struct mm_struct *mm,
+				  unsigned long start,
+				  unsigned long end);
 
 	/*
 	 * clear_young is a lightweight version of clear_flush_young. Like the
 	 * latter, it is supposed to test-and-clear the young/accessed bitflag
 	 * in the secondary pte, but it may omit flushing the secondary tlb.
 	 */
-	int (*clear_young)(struct mmu_notifier *subscription,
-			   struct mm_struct *mm,
-			   unsigned long start,
-			   unsigned long end);
+	bool (*clear_young)(struct mmu_notifier *subscription,
+			    struct mm_struct *mm,
+			    unsigned long start,
+			    unsigned long end);
 
 	/*
 	 * test_young is called to check the young/accessed bitflag in
@@ -118,9 +118,9 @@ struct mmu_notifier_ops {
 	 * frequently used without actually clearing the flag or tearing
 	 * down the secondary mapping on the page.
 	 */
-	int (*test_young)(struct mmu_notifier *subscription,
-			  struct mm_struct *mm,
-			  unsigned long address);
+	bool (*test_young)(struct mmu_notifier *subscription,
+			   struct mm_struct *mm,
+			   unsigned long address);
 
 	/*
 	 * invalidate_range_start() and invalidate_range_end() must be
@@ -376,14 +376,12 @@ mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,
 
 extern void __mmu_notifier_subscriptions_destroy(struct mm_struct *mm);
 extern void __mmu_notifier_release(struct mm_struct *mm);
-extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
-					  unsigned long start,
-					  unsigned long end);
-extern int __mmu_notifier_clear_young(struct mm_struct *mm,
-				      unsigned long start,
-				      unsigned long end);
-extern int __mmu_notifier_test_young(struct mm_struct *mm,
-				     unsigned long address);
+bool __mmu_notifier_clear_flush_young(struct mm_struct *mm,
+		unsigned long start, unsigned long end);
+bool __mmu_notifier_clear_young(struct mm_struct *mm,
+		unsigned long start, unsigned long end);
+bool __mmu_notifier_test_young(struct mm_struct *mm,
+		unsigned long address);
 extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
 extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r);
 extern void __mmu_notifier_arch_invalidate_secondary_tlbs(struct mm_struct *mm,
@@ -403,30 +401,28 @@ static inline void mmu_notifier_release(struct mm_struct *mm)
 		__mmu_notifier_release(mm);
 }
 
-static inline int mmu_notifier_clear_flush_young(struct mm_struct *mm,
-					  unsigned long start,
-					  unsigned long end)
+static inline bool mmu_notifier_clear_flush_young(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
 	if (mm_has_notifiers(mm))
 		return __mmu_notifier_clear_flush_young(mm, start, end);
-	return 0;
+	return false;
 }
 
-static inline int mmu_notifier_clear_young(struct mm_struct *mm,
-					   unsigned long start,
-					   unsigned long end)
+static inline bool mmu_notifier_clear_young(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
 	if (mm_has_notifiers(mm))
 		return __mmu_notifier_clear_young(mm, start, end);
-	return 0;
+	return false;
 }
 
-static inline int mmu_notifier_test_young(struct mm_struct *mm,
-					  unsigned long address)
+static inline bool mmu_notifier_test_young(struct mm_struct *mm,
+		unsigned long address)
 {
 	if (mm_has_notifiers(mm))
 		return __mmu_notifier_test_young(mm, address);
-	return 0;
+	return false;
 }
 
 static inline void
@@ -552,24 +548,22 @@ static inline void mmu_notifier_release(struct mm_struct *mm)
 {
 }
 
-static inline int mmu_notifier_clear_flush_young(struct mm_struct *mm,
-					  unsigned long start,
-					  unsigned long end)
+static inline bool mmu_notifier_clear_flush_young(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
-	return 0;
+	return false;
 }
 
-static inline int mmu_notifier_clear_young(struct mm_struct *mm,
-					   unsigned long start,
-					   unsigned long end)
+static inline bool mmu_notifier_clear_young(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
-	return 0;
+	return false;
 }
 
-static inline int mmu_notifier_test_young(struct mm_struct *mm,
-					  unsigned long address)
+static inline bool mmu_notifier_test_young(struct mm_struct *mm,
+		unsigned long address)
 {
-	return 0;
+	return false;
 }
 
 static inline void
diff --git a/mm/internal.h b/mm/internal.h
index 0eaca2f0eb6a..3d6eba216364 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1831,10 +1831,10 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
 }
 
 #ifdef CONFIG_MMU_NOTIFIER
-static inline int clear_flush_young_ptes_notify(struct vm_area_struct *vma,
+static inline bool clear_flush_young_ptes_notify(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
-	int young;
+	bool young;
 
 	young = clear_flush_young_ptes(vma, addr, ptep, nr);
 	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr,
@@ -1842,30 +1842,30 @@ static inline int clear_flush_young_ptes_notify(struct vm_area_struct *vma,
 	return young;
 }
 
-static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
+static inline bool pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
-	int young;
+	bool young;
 
 	young = pmdp_clear_flush_young(vma, addr, pmdp);
 	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr, addr + PMD_SIZE);
 	return young;
 }
 
-static inline int test_and_clear_young_ptes_notify(struct vm_area_struct *vma,
+static inline bool test_and_clear_young_ptes_notify(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
-	int young;
+	bool young;
 
 	young = test_and_clear_young_ptes(vma, addr, ptep, nr);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + nr * PAGE_SIZE);
 	return young;
 }
 
-static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
+static inline bool pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
-	int young;
+	bool young;
 
 	young = pmdp_test_and_clear_young(vma, addr, pmdp);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 2502474b83b6..dc6f78d559f7 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -364,12 +364,12 @@ void __mmu_notifier_release(struct mm_struct *mm)
  * unmap the address and return 1 or 0 depending if the mapping previously
  * existed or not.
  */
-int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
-					unsigned long start,
-					unsigned long end)
+bool __mmu_notifier_clear_flush_young(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
 	struct mmu_notifier *subscription;
-	int young = 0, id;
+	bool young = false;
+	int id;
 
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_srcu(subscription,
@@ -384,12 +384,12 @@ int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 	return young;
 }
 
-int __mmu_notifier_clear_young(struct mm_struct *mm,
-			       unsigned long start,
-			       unsigned long end)
+bool __mmu_notifier_clear_young(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
 	struct mmu_notifier *subscription;
-	int young = 0, id;
+	bool young = false;
+	int id;
 
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_srcu(subscription,
@@ -404,11 +404,12 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
 	return young;
 }
 
-int __mmu_notifier_test_young(struct mm_struct *mm,
-			      unsigned long address)
+bool __mmu_notifier_test_young(struct mm_struct *mm,
+		unsigned long address)
 {
 	struct mmu_notifier *subscription;
-	int young = 0, id;
+	bool young = false;
+	int id;
 
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_srcu(subscription,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0ab29672c71..82433f46c438 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -646,11 +646,9 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 	return r;
 }
 
-static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
-						unsigned long start,
-						unsigned long end,
-						gfn_handler_t handler,
-						bool flush_on_ret)
+static __always_inline bool kvm_age_hva_range(struct mmu_notifier *mn,
+		unsigned long start, unsigned long end, gfn_handler_t handler,
+		bool flush_on_ret)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_mmu_notifier_range range = {
@@ -666,10 +664,8 @@ static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
 	return kvm_handle_hva_range(kvm, &range).ret;
 }
 
-static __always_inline int kvm_age_hva_range_no_flush(struct mmu_notifier *mn,
-						      unsigned long start,
-						      unsigned long end,
-						      gfn_handler_t handler)
+static __always_inline bool kvm_age_hva_range_no_flush(struct mmu_notifier *mn,
+		unsigned long start, unsigned long end, gfn_handler_t handler)
 {
 	return kvm_age_hva_range(mn, start, end, handler, false);
 }
@@ -829,10 +825,8 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
 }
 
-static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
-					      struct mm_struct *mm,
-					      unsigned long start,
-					      unsigned long end)
+static bool kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
+		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	trace_kvm_age_hva(start, end);
 
@@ -840,10 +834,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 				 !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG));
 }
 
-static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
-					struct mm_struct *mm,
-					unsigned long start,
-					unsigned long end)
+static bool kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
+		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	trace_kvm_age_hva(start, end);
 
@@ -863,9 +855,8 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	return kvm_age_hva_range_no_flush(mn, start, end, kvm_age_gfn);
 }
 
-static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
-				       struct mm_struct *mm,
-				       unsigned long address)
+static bool kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
+		struct mm_struct *mm, unsigned long address)
 {
 	trace_kvm_test_age_hva(address);
 
-- 
2.47.3


