Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6CDAEC112B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 01:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F08D6B008A; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7696B0092; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FBD6B008C; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 157316B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B43C01C39B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:33 +0000 (UTC)
X-FDA: 84477685866.19.FF3A15F
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8C9EC80003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r2dEz0LG;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/IX7vo5n7nkNpK4VJsc92/3nwHLcPZ/ZOCy2a+g4eA=;
	b=007OP2/SexNBcA8PTVYHxlfq5Fsi3trtc65tVyM3yPaWRNmMgV7O9a87LwKg4AfMse890Y
	os0QC05Y2gEvkIaPVzgesemfnIHyxsdgmddOKGyLUbu2M6uakflWXGe6HbTa2ecxwtMahr
	n7p3iqULxeKbSLaCNZuXpIOhRmuJclU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r2dEz0LG;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898192; a=rsa-sha256;
	cv=none;
	b=fy/IvmQM2/qIwS3oM5y6hOxYPxX4dhWMbKNdRU1FGYP0wLBnrK2bjnbrcIXkNiOWPKO5Of
	F+0EVAdAXXZ3BjxF4ZK2QvsK5bu9RqpWotvWLG1jBpYFrl7p9xlRwa1uX0VgNltJYGwxpd
	n5MuC7h0QW46480R9qZnq9lsR8ieOpM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771898186; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=5/IX7vo5n7nkNpK4VJsc92/3nwHLcPZ/ZOCy2a+g4eA=;
	b=r2dEz0LGrR0beWHBtnVONVfP/E+jM/7OPxe/jK8TAbPv5oVjr1HgeSbsR+rhOn13XMB7vFyOvrPb8wF3Q7xe+8TaSa11t0xdLDAUCzNHNyEoHiWlwPdOIvmn9/pULvKVl8x79WA3YnfK6AAQl88qcvMQMFAW6TbAXbCEvzj+HAs=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzhrds-_1771898183 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 09:56:23 +0800
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
Subject: [PATCH 1/5] mm: use inline helper functions instead of ugly macros
Date: Tue, 24 Feb 2026 09:56:04 +0800
Message-ID: <dc94552605926f9ce84f9fc2ddfe5f7d1319e41c.1771897150.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C9EC80003
X-Stat-Signature: niqweue83ph4hmrk83bbhk1hdijmjz35
X-HE-Tag: 1771898191-636010
X-HE-Meta: U2FsdGVkX19/f7A5YEhFP55QA1jbyJ2gRsYG74udYkHPb5ueAFE9u4cBGu8tT94Z5qEsfyivRKZGHJ/UFWcmeAUEDbahTvhYA5BHU0kvHTn3La/W8xj/CBNyuOU27gsVtwQ7G+NMYue5dq3ysZe40xo2TS95hS056DZX92hTjqAFnZ5yi06jzItIDi8SKCGSU6Zsopa4vCxwEYhabDa6it+4++EVkAkEBWvlwJc8aPS1ssa0V1NGAR3f5iksjvQgDqcmYYbuyKSvcBF9e+299M2uU5n+t16ALOhGDIl7oYEhJ4eddTqE+JQjxvR4XGQJ/FyZT+uDaGV+X58hxfE3hFF2LrN5fTwORunlFv7mO3aB956+hbrEzSB45Id5EDu2ZZtnbxWEHb0IBXCcVZMTMKc/WX+PwHoqUuOH27LbIaV/9VezymoLEC0B4Nn8xqmPKfr4ceXHOqPBJWaF4zK2e1FWC4TMWkUoj4+yg+WUljCSIKPARXrUp23g6jPat3ARg4BdYXYAC5ZPlkjOZeoaNTyjRbcYPH6CVk4CEI8wfP7yiW9kaCDo3JzWic3xr4XJLmuVq69TMAGG3dou4/DHScMQ4VnNJH6jCgY7imSyvwt7t8t69L33gdNScn1saLX6qR2xKl6/9gX/7z+hmYS9X1bE2GtANu0Nk+Bp0uL3/yO2ghMHqXudo7w4927i0UDDxIm/3Hbzy7abYWJelRCga6TkSd46irbdrqqJJODtMiZ29Rnv4nuGvfPhjw4sMx/ogK4gR8KTAFfs8A4wU0v2tBgt5nBFS29qVuumFPRVTyAjv0DhEGIri3nak+0iDwdR+QkSjbdmHkiIRj+4sqjW3MVXCKLG6pxA/4w/f4S9poCGX0Tr9VXvvB8aFMKqNqx3bw073JJeoxr217tNncY0nLSqrIxyEJ68QElbiVjbG10IqB3zfTBzs6zWqCc8/uSV0Jj2UMfPzOHd/V9YdIo
 OIt6Iv95
 UzZitNzRDo2tHi3QkFa08kv96w+o1YpeKxsQLTZ3OMeQrcYtlb5ob75oxvYZe7xS3N80PjoKJt+DvnNhaATGr4mQjdyZ6MkQSqRoC72OQgvDtvAWVQ+Y5dp5tcIgQ3cW2RFsBUS8UEl6wCPCMsX//z45l1sZK8vZOiw0Nkh2sAgf185V7VjIOkV5nXVdVVobxmbK+6M53VpTL6wvPrMruxiKQEbuy7vudbqZvlF1rwvcvAQYvHlT0IcOkrpMEE8zUXv5PoD7fwQWSS5eRC3y9t/rc+HybRVFz9wVOMoZqTAa6RVZ9+ygKUDaTjmiMrFYiPXQN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

People have already complained that these *_clear_young_notify() related
macros are very ugly, so let's use inline helpers to make them more readable.

In addition, I cannot implement these inline helper functions in the
mmu_notifier.h file, because some arch-specific files will include the
mmu_notifier.h, which introduces header compilation dependencies and causes
build errors (e.g., arch/arm64/include/asm/tlbflush.h). Moreover, since
these functions are only used in the mm, implementing these inline helpers
in the mm/internal.h header seems reasonable.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmu_notifier.h | 54 ------------------------------------
 mm/internal.h                | 53 +++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 54 deletions(-)

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
index e0ef192b0be3..1ba175b8d4f1 100644
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
@@ -1789,4 +1790,56 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
 
+#ifdef CONFIG_MMU_NOTIFIER
+static inline int clear_flush_young_ptes_notify(struct vm_area_struct *vma,
+						unsigned long addr, pte_t *ptep,
+						unsigned int nr)
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
+						unsigned long addr, pmd_t *pmdp)
+{
+	int young;
+
+	young = pmdp_clear_flush_young(vma, addr, pmdp);
+	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr, addr + PMD_SIZE);
+	return young;
+}
+
+static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
+{
+	int young;
+
+	young = ptep_test_and_clear_young(vma, addr, ptep);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
+	return young;
+}
+
+static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
+					  unsigned long addr, pmd_t *pmdp)
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


