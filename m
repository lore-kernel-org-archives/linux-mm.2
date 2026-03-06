Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B430CF5140F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50166B0005; Fri,  6 Mar 2026 01:44:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA116B0089; Fri,  6 Mar 2026 01:44:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05EE6B008A; Fri,  6 Mar 2026 01:44:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2D56B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:44:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48FB514045D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:08 +0000 (UTC)
X-FDA: 84514698576.26.9B01476
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf25.hostedemail.com (Postfix) with ESMTP id 60DF1A000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="uVSmX/7M";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772779446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ecy1vzScZYswnEb3G5QPIiR13hJr9V0CgwG6PHTVyyM=;
	b=N9CL8URKe0wcKMs7mbSTkhpXvXFsjJBGaR0hh8Uq0jQifO7gzqK8eg6s2XotC7Q8LIIjjH
	mH4Fedbb6YYQhnVkGbPlfr2MuJvT/SgcT5khp2sNjZNlcUWDpzw4YtbvUnVUC71IrdSVMF
	lptUys3p6ONWTQlW/IlO4KJlRdLO5G8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772779446; a=rsa-sha256;
	cv=none;
	b=i8OVSsYC7UBJ7RnG90QbWBe8oeGHV64fWDb+EiA/cxkW4o0V62/SE6cJH/jGQu3ZFwoEgK
	khUS9gBNnSGqKsi6VaL2Lf/AI6h8MkwDGdksDGxuCpJ3idy/wOJYGA0yWjubaWO0wJmoJe
	A6lrck052s2I2r0qi067zlQkovFCtSQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="uVSmX/7M";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772779442; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Ecy1vzScZYswnEb3G5QPIiR13hJr9V0CgwG6PHTVyyM=;
	b=uVSmX/7MBgJwkR+oy5OjfYmfw+713OxTfFxAfFPN+u2q5Ig55SpaiAdkvqRggSL75lVQ/LqfOXVX//2nCzJ4yR+84NaZde6sRx9sUkRQbOUTihQddPNk2dWZJjUXxDOG5j5X/79zfeWfJyHBx9MX3xF2mBj1RFoWoIzS3nbmKbk=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-MLooA_1772779438 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 14:43:59 +0800
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
Subject: [PATCH v3 1/6] mm: use inline helper functions instead of ugly macros
Date: Fri,  6 Mar 2026 14:43:37 +0800
Message-ID: <ea14af84e7967ccebb25082c28a8669d6da8fe57.1772778858.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60DF1A000B
X-Stat-Signature: rqhys63tkiq5ji6nwzshejof4ppsjtrj
X-Rspam-User: 
X-HE-Tag: 1772779445-173728
X-HE-Meta: U2FsdGVkX1/VZDtgUiMSePMhJQHtEFLRwa3+47bDQSqUKFl+ineEZk6IJSGHSDQZY+NoHZnjUCxkNqprjKILh6zNFFhklSdaIdYn5r3kru+96LPGrgTsEcn7lHzMfsn1+r20Ff5sVYfTGV3E7LeIYg7GTO1rJTBwqFwU4X4r1NoWZm5oCVEaFuEKoo4py70m6olTt4VUl+UNV0noH/hu2zdpduXydZjIztRLhr483vRnhLRmuoUVyLuAkezsEWkWweNAWaTv4rrZXAHW/uYhh3ayTzT6BMwRSpm6yje8TLJz2atDMNsZR7gdJaGbz2h8nr/ZOT/UfhiHd0psqGvLt2W9sLW15x05MFbxJtLmjRT/sjN8PgOcrizb1m4GUIiwON93ZrL9yLY76QxI45BZ7Ui1y5T3Jg+Da+C/74m1V6C/x1zH869+Qfi5dVuG1ZbdIDeoDIFnDSxoBzzDCHwTC76BAoaH8OFJP4F2Rzp3bHaMi2crDFk7E8FFsTCebol0IsGrrbqtzup6yC7KzWKPy9NxBTBxQ4X+jfhR3uWxKWThQp04gkhd1Xk1NRCBkU1ecXfbB5R5ne1bjAM+koQyjzYp3HGvxzloKYhca53zmgJi19vNFZ/ehYHt7WSn75wmNlB/dky6nm8Rme+X6jYTUetohXaj0XG2ZBLK0A52r9tuXSlIhv2bR6GO7hg2wVYuNoblQc0EJRsV8/7ipJYLrKBL7PgDkZs76nkf/b++zF7MjTZTp3MxdVNEU95mHXTkdun89SDFbHVoknpmIz4e3IekeiSOvLn7SWW7m7ThQ4Z//gk82CAo18HJ8gBYBMTJqpPUOAOz3JhTrBDMheelwiwqAxni7FFfwXOwsS1P0W31uXKaaZNW5Z/FibREvIyKEEILPYYY+ajkDAgmnD539qQH8VfQWQewEL3BhR8UtA3vgCY9YK8cBDjf9eXN+yRmqKwKiqCavrsOXyCKBIp
 IvYmieSt
 xQVkw8gRo9Q6khNcTxc2UX/EtGl8zzSctkNMwcm8QKtYB+VKuxvC8ZnlBeL7TDgANSmcOPO9JBNNkHkHHPSfGzxHk8cFunka/BQTNS7E4RMRPn4jsY8/ayP6cYOF1oADMRNkiPg7TtltGHXVljklNGbH4bAqMTxhxXIApMqSfwFYj4+OIX8IsynECAT31nzFgQh9tUtgEI8l4kxVdZJpM1Pb4jWpHFDWDrnBs5vdQot7eAf4qREeliH7qRtYPkbm90jmBi3lUa6x42Gf4xhgOvQhEnAso4VbEyebsjk5JWdrc3orNJ7UQhLj+xbiUh/GeXvBE5F11/t+OT5nLzbKzNjzJq9g2xCQSEaCOnlSgT7942A8R6ic6SCeZIQ==
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
index 8450e18a87c2..3705d350c863 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -516,55 +516,6 @@ static inline void mmu_notifier_range_init_owner(
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
@@ -652,11 +603,6 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
 
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
index 0d5208101762..05eb0303f277 100644
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
@@ -1796,4 +1797,55 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
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


