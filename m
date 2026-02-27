Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C786FFD5323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371926B00A5; Fri, 27 Feb 2026 04:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328AF6B00A6; Fri, 27 Feb 2026 04:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C326B00A7; Fri, 27 Feb 2026 04:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FDE66B00A5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:45:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1D021C59D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:45:05 +0000 (UTC)
X-FDA: 84489752970.29.C52537D
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36476C000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:45:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q408KtSU;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772185504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wgDGH7YrsjBc++BlCR5vPH+I+CcHMW2c+p9i33Zw9Q=;
	b=IzeW/bqX1V2o5JbI1NznpUqX2fpLcZJCm3TmuamSJjqY+MzN+4JBztvrslpwgZDjzo5Xj3
	gWpY+3kYuoB8QhogUm5IyDlR+KE4GZ/Dum2+68lOWPvqmejh0SNMaFoSiaWn64gcqPO9U5
	LXaHJs3fpy0h3cifJaqc+CHxC4Rdx/Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q408KtSU;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772185504; a=rsa-sha256;
	cv=none;
	b=4pEB9DwXb7gkW9Jo8lw9KpBinUwRg8+BXYfq5cTsbeeDPyPqO/M9PJlidGcDtuTofTe3Nz
	Q8UjzUjbktshyHQLN9dc6ZDm7dFHOfJcsuTaqFMGjlrCwn/y9kxyGaWb3NnTPIQfKsT4cG
	g3zxgHnfbW42Ziy2BbFO3pYTDPKAa8g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772185497; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=1wgDGH7YrsjBc++BlCR5vPH+I+CcHMW2c+p9i33Zw9Q=;
	b=q408KtSUcoRrwzu6NXo3fdKbd6GpW5/m2yRyfpP/XvxcuvswAMTIMGHDwQ07cjrNgB5wRE5cFriZh+tZBeQk77B1BkBB+akHun46AS4LisrGYKzvhGpk790XIBQ1IoteNSH1SRap4wlr7CBJm0Fa4bhemnYlsMPrUXhDXbFC7MY=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzu12u4_1772185495 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Feb 2026 17:44:56 +0800
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
Subject: [PATCH v2 4/6] mm: add a batched helper to clear the young flag for large folios
Date: Fri, 27 Feb 2026 17:44:38 +0800
Message-ID: <589d743f4e048dc749002a7e1a1aec5d511c406b.1772185080.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36476C000C
X-Stat-Signature: nq38ecyo7465977tnejmdtidmoya4xim
X-HE-Tag: 1772185502-816623
X-HE-Meta: U2FsdGVkX19q9ymkHXWtMCS+2QE+E9p6ZDQByU/gQRonwU0Zqv6dF9t4BzyUTmQYGSg4Dopk1+Tt+o/2gVNdRrpQa6paZWs9sGsGOzrkcCL5zKVge5BryPgQlwkSLHglC90FNhNXvZgltoeH6zkqmWII84IHKAzvM2aB3I+pRHeSVZxVE5/nmSM9u6Ez/1scwIQtG6gRYCTrJcEtZTKFfbAOf2r4EwjSVx1EwMeo91uE8+Ke8HdSrE8QU3CyTBuZ+GI4u/wSVL2YMHsgJGjWPYkxteKrBl/gGVYz0wT4mayJAdWfVncHBWVzE1ul1h+cMZsc6aQgay88HkXfSTRL/3aP31sAzH0cv3zNsPsDLojb5Nfj3I5Ad/wW+tiTua5NwEuEExiRBcGQtsUb+VjlbBhQSn7XwJKuIm/x9Wyaz6PRyk67Euf6M9aOXu0b5mKhYbljxy61GGLGuJR5dYwfE2dS7bF9JQrgwSUvGrsOKaq5CB2d5KmximBiGHtqfkr8t2IQ3WfY4ldHABGmo1bbnKpu9bzdhLUYFvwTwwrFov3gequP/B58Lm3emHi6X8E4dPlHLL/4m416EMXKadV6CH11thUYJ9nJxcrWREpxBG3atADnlcZkr+3fqdigDDKvmPwBzBZ+S2P5kAyya9Py+jnoVfalb15yCfxzQkJcxKEk8O2/mHyJC8YFinX28S2yoiGvAmMrzzJhtkSTuHlUCl5SepNQKk9rpr0jFpq3z8fUt4vRz3n/fQ6XDY9KaXtKxoaqbyE5PGnc7K6FbANqn5nEyLDthZWjEuRF+zVkiib+sXTEbi1LoTuEXc28WmxS/m6On9phCpqZZfOjdlBc+234Kn5t5WJRnMwJchEFKr3gJlg5Mrq+09En2XgOOFb69J5LjmQ0ADeb38Q/rCTa6qlii6mUNf4hjelbvDdZ/G/uWsxBNbGli1GkL3Aw6PRGDkvypNVbmm30gQ/ziWL
 FUsnvcH2
 79pnaz/J4EtBlv5/Huc4wBjMURQJ5Z+ujwQ/QB6RBdwlB4mDFxYV8s2zEEVc1nRgCRPg0oAM3BVvxjiHYQCXhxOEvy2HLbEHXYsTlSdTzaw6bMwbd6pW7Fp64jIjLTh126Ckq55zP9EpBaxcUL0NHqMLx69Gl+fYvADiPjmWgiOi0gZYWdPQCwbmAMRN/dWlgjBWY9IoNpd0bH5ZgKokroDkz9knBQXNfO8cYBwxl9nx2Ov3ggXhpwdCvzOcTjwRvec5p6+/b3iuK88u80GKCOiuXCzXh5gUjNQ4gJkMV4hI+pIF8ZW2/lYvB9XB4UkvWbQ1t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, MGLRU will call ptep_test_and_clear_young_notify() to check and
clear the young flag for each PTE sequentially, which is inefficient for
large folios reclamation.

Moreover, on Arm64 architecture, which supports contiguous PTEs, the Arm64-
specific ptep_test_and_clear_young() already implements an optimization to
clear the young flags for PTEs within a contiguous range. However, this is not
sufficient. Similar to the Arm64 specific clear_flush_young_ptes(), we can
extend this to perform batched operations for the entire large folio (which
might exceed the contiguous range: CONT_PTE_SIZE).

Thus, we can introduce a new batched helper: test_and_clear_young_ptes() and
its wrapper test_and_clear_young_ptes_notify() which are consistent with the
existing functions, to perform batched checking of the young flags for large
folios, which can help improve performance during large folio reclamation when
MGLRU is enabled. And it will be overridden by the architecture that implements
a more efficient batch operation in the following patches.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/pgtable.h | 38 ++++++++++++++++++++++++++++++++++++++
 mm/internal.h           | 16 +++++++++++-----
 2 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 776993d4567b..29bd9fd04e1e 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1103,6 +1103,44 @@ static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
 }
 #endif
 
+#ifndef test_and_clear_young_ptes
+/**
+ * test_and_clear_young_ptes - Mark PTEs that map consecutive pages of the same
+ *			       folio as old
+ * @vma: The virtual memory area the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to clear access bit.
+ *
+ * May be overridden by the architecture; otherwise, implemented as a simple
+ * loop over ptep_test_and_clear_young().
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ *
+ * Returns: whether any PTE was young.
+ */
+static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr)
+{
+	int young = 0;
+
+	for (;;) {
+		young |= ptep_test_and_clear_young(vma, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+
+	return young;
+}
+#endif
+
 /*
  * On some architectures hardware does not set page access bit when accessing
  * memory page, it is responsibility of software setting this bit. It brings
diff --git a/mm/internal.h b/mm/internal.h
index af04b177f21f..a5f0a264ad56 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1814,13 +1814,13 @@ static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
 	return young;
 }
 
-static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
+static inline int test_and_clear_young_ptes_notify(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	int young;
 
-	young = ptep_test_and_clear_young(vma, addr, ptep);
-	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
+	young = test_and_clear_young_ptes(vma, addr, ptep, nr);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + nr * PAGE_SIZE);
 	return young;
 }
 
@@ -1838,9 +1838,15 @@ static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 
 #define clear_flush_young_ptes_notify	clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
-#define ptep_test_and_clear_young_notify	ptep_test_and_clear_young
+#define test_and_clear_young_ptes_notify	test_and_clear_young_ptes
 #define pmdp_test_and_clear_young_notify	pmdp_test_and_clear_young
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
+static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
+{
+	return test_and_clear_young_ptes_notify(vma, addr, ptep, 1);
+}
+
 #endif	/* __MM_INTERNAL_H */
-- 
2.47.3


