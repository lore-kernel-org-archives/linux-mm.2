Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C58FD5327
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94BBE6B00A2; Fri, 27 Feb 2026 04:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CEE06B00A3; Fri, 27 Feb 2026 04:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5586B00A4; Fri, 27 Feb 2026 04:44:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FDF16B00A2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:44:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F02308BFEF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:44:58 +0000 (UTC)
X-FDA: 84489752676.06.5F95862
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5AB7940011
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:44:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jbzGkk9E;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772185497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGeaEqvp4zEvzyk67BVba1jL/iSgAiyyvsTj8YvMr1U=;
	b=kxLk7EHVTcvDAJY+LiFnjC0EkjKeYc8P0D+ojb/i8JLwGyjLRV4DZ1j5S1TmeSrdVnvvo2
	cNY4hPLRIYB49ZNeMoWExKIafYzgp9Bj3X0kPxS4TthdJZ0267V4/j1Cpz1k30K0fzQ/5c
	xF8NHBVdsiN8CenMxyXTTWfL7DK3DU4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772185497; a=rsa-sha256;
	cv=none;
	b=4IJHgRZ7DlIlLOEMibFYIFVFtLJfH1NDmJUusFGUpLbCGOxo5R1DqPB64jmrxYxa7hDlzt
	U64sovHO3I3WtFqHA03ROBr5Q+LgzgZwrE3VRM/nTMFQ6Y9QsKc68xLj97X7Mzb4hyiP14
	v6NLYDPfipXGnBVzOxahr4N6OiVri6E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jbzGkk9E;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772185492; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=QGeaEqvp4zEvzyk67BVba1jL/iSgAiyyvsTj8YvMr1U=;
	b=jbzGkk9E8P9rHc6wjKSYE81ZCt13RD7iVGWpKYxdZHNwL0gDJuGpdrvn24MnP9P6wOJiZYIxHoI4IXYrSj2ZLP8ZhQ/s3qGC7Uv1H/g3UN6z1I7a3qoQGjY5eAj5fEszfJNEfUhzxVgafxGDLSPi8R1vBOQRZ/j++flbWl/rA1g=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wztvd.X_1772185491 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Feb 2026 17:44:51 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] mm: use inline helper functions instead of ugly macros
Date: Fri, 27 Feb 2026 17:44:35 +0800
Message-ID: <4ffb2946062b9452be53d6b2fa3e359ba6446a93.1772185080.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5AB7940011
X-Stat-Signature: 8f9pr1ejjxadjtnpdyk5etj86rnykxtn
X-Rspam-User: 
X-HE-Tag: 1772185495-651507
X-HE-Meta: U2FsdGVkX1+CjLcY3sOzJ8E6TMykp0DjCLx3wkyihY9YsjltF8IqfEJ+LlkASq3mJsw+kj/3Ch8R8GzGFV9gfJMFH8sGgnLUMcbkrmem9KYDF7VfAwernnOGapLpkq9fxpZFfzuXUdWxMjbvO/96YYWkKDclVILCLst+CtlWCAp9REU/klYc20gP1XX4eqG41qJUyrWR1bdlhtcyxglHQQ6FGPIt23v5qXnWn95iMElRUxFUfy6lj7xF05YPIhZF0qTjOi6827NvC1qptRav3JpMNRw6R78j8oM7tMQ6xIQaQg3D+z1tNEvHIqS9PH41d4qpD4Y9P1WTmXUVFG08AcT1U3yuExNkkvLyUG6pYj4yXilXVETniSM9t5Y4ljNOCH3lujY5opizr2Y4buLGnfJNWX3ctn15NDLTtxjfr/MuOme3vB/b0OpmEZxeElug6R8GazJTPLOg7QCyVLtv4nB+soUN1irERuPGiSHEP3WFDhiCnot8W7dpG4KVAzg75NxZv6pKtBBAkvRv3tIjADbXrMtJM8z+y7ZNw3ogdhah1BBzFZN8czDm+IXwja2CH6sXwpnFwn4hFNE9hE2TWPPhiY+2fFnx6dNRb/0+2UBZ0nsSs51dat5xEnxoRZ+3al0lMsbvHE/O7flR+w58AeLjxPJCalXOf0J3MTjS3FXADINZ8ZsaVmCum0ovANnhRZ+8pOgrny2Jh+7NCdpIT100J0DmcIIQ3FTlEUH/WogxnZ81eAxOPI2z7dgF4oHTSFAviPIW99xe3J30teTjOdunYkDUIxrOPvR7ai2Rbjt1ApjSEShIY19bLfCJNPAg/YEW1LYZagU7p5zZmzmILc6ZIrgQCDbWvmke5TWHcKuOaP9F0PvxW6RJP6jcQoSwHEmnxPIH5kd0S7ztlg8XappQ0XSreBd2frxqVdk+QLUZDBrJKwIpzjtr66RRDcMoseJ+8QBI/ttCZgAutGs
 VEmxL/fH
 7+Hs1OTzpdNYSqoiWkMHu3f4WqWm1SeZDNVe+us3SWFz3KMuJPDai8xzhPkYf52mjbp8O+MldvEmobTzN6tcoVE2oLe9OLxfDzJFKviWmz6I7vCQLCO+yILAgN7cICKFzvZS+Ax0QRe55HlJMitH/YJSWCL2vQfg+Tl3Q3qYkGFPA8ONF42M7yhSJiGgEkJk4PEcmK1of09WZ/3jnO5j1i14WngkKUCA2Uji1il/E7dZqOCz/WJZ3Es9ZY8xqVruX3ZkBRpfWH7rTmCgMEaEyl83pbd4fQOrItIdOaEtuiW6qHGu10sAAgTrAzzuuhW36K+3s1lAuRCpEiIE2zY4paMG1+OVpwKb06Jlxp/4TpDonmzsSsrW6vKqRPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

People have already complained that these *_clear_young_notify() related
macros are very ugly, so let's use inline helpers to make them more readable.

In addition, we cannot implement these inline helper functions in the
mmu_notifier.h file, because some arch-specific files will include the
mmu_notifier.h, which introduces header compilation dependencies and causes
build errors (e.g., arch/arm64/include/asm/tlbflush.h). Moreover, since
these functions are only used in the mm, implementing these inline helpers
in the mm/internal.h header seems reasonable.

Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmu_notifier.h | 54 ------------------------------------
 mm/internal.h                | 52 ++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 54 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 07a2bbaf86e9..93894b90c8c1 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -515,55 +515,6 @@ static inline void mmu_notifier_range_init_owner(
 	range->owner = owner;
 }
 
-#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)	\
-({									\
-	int __young;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	unsigned int ___nr = __nr;					\
-	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
-	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
-						  ___address,		\
-						  ___address +		\
-						  ___nr * PAGE_SIZE);	\
-	__young;							\
-})
-
-#define pmdp_clear_flush_young_notify(__vma, __address, __pmdp)		\
-({									\
-	int __young;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	__young = pmdp_clear_flush_young(___vma, ___address, __pmdp);	\
-	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
-						  ___address,		\
-						  ___address +		\
-							PMD_SIZE);	\
-	__young;							\
-})
-
-#define ptep_clear_young_notify(__vma, __address, __ptep)		\
-({									\
-	int __young;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	__young = ptep_test_and_clear_young(___vma, ___address, __ptep);\
-	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
-					    ___address + PAGE_SIZE);	\
-	__young;							\
-})
-
-#define pmdp_clear_young_notify(__vma, __address, __pmdp)		\
-({									\
-	int __young;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	__young = pmdp_test_and_clear_young(___vma, ___address, __pmdp);\
-	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
-					    ___address + PMD_SIZE);	\
-	__young;							\
-})
-
 #else /* CONFIG_MMU_NOTIFIER */
 
 struct mmu_notifier_range {
@@ -651,11 +602,6 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
 
 #define mmu_notifier_range_update_to_read_only(r) false
 
-#define clear_flush_young_ptes_notify clear_flush_young_ptes
-#define pmdp_clear_flush_young_notify pmdp_clear_flush_young
-#define ptep_clear_young_notify ptep_test_and_clear_young
-#define pmdp_clear_young_notify pmdp_test_and_clear_young
-
 static inline void mmu_notifier_synchronize(void)
 {
 }
diff --git a/mm/internal.h b/mm/internal.h
index f4d95e2ab799..f27cdad98c1e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -11,6 +11,7 @@
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
+#include <linux/mmu_notifier.h>
 #include <linux/pagemap.h>
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
@@ -1791,4 +1792,55 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
 
+#ifdef CONFIG_MMU_NOTIFIER
+static inline int clear_flush_young_ptes_notify(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
+{
+	int young;
+
+	young = clear_flush_young_ptes(vma, addr, ptep, nr);
+	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr,
+						addr + nr * PAGE_SIZE);
+	return young;
+}
+
+static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
+{
+	int young;
+
+	young = pmdp_clear_flush_young(vma, addr, pmdp);
+	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr, addr + PMD_SIZE);
+	return young;
+}
+
+static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
+{
+	int young;
+
+	young = ptep_test_and_clear_young(vma, addr, ptep);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
+	return young;
+}
+
+static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
+{
+	int young;
+
+	young = pmdp_test_and_clear_young(vma, addr, pmdp);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
+	return young;
+}
+
+#else /* CONFIG_MMU_NOTIFIER */
+
+#define clear_flush_young_ptes_notify	clear_flush_young_ptes
+#define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
+#define ptep_clear_young_notify	ptep_test_and_clear_young
+#define pmdp_clear_young_notify	pmdp_test_and_clear_young
+
+#endif /* CONFIG_MMU_NOTIFIER */
+
 #endif	/* __MM_INTERNAL_H */
-- 
2.47.3


