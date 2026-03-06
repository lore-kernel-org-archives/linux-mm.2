Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA11EF5140A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48686B0092; Fri,  6 Mar 2026 01:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D326B0093; Fri,  6 Mar 2026 01:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6590E6B0095; Fri,  6 Mar 2026 01:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4606B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:44:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1D3E1C33A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:12 +0000 (UTC)
X-FDA: 84514698744.17.269DFE8
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id E7ED512000C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v49bVuO1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772779451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySLYC5/cF8hmf06ne/L2kgOPFMnQM58WLWXLfygl3cs=;
	b=ESbhZzGbtvPLjGqhoFt1L1r4RiYBkzDRct8zWN7DwcZUzTbNMmQ07nV3qC+5g6OjiYGeoa
	K7qpSuTbJ5UNYTwtO3KMGaXjUKQHfuEOueeEFU7RDEB5M7dORTTzZSJ6DOp73uulbr4Wj0
	pId52xsrjsEJFEs5WkRq3kuZ47XgUcE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772779451; a=rsa-sha256;
	cv=none;
	b=s5mg5XzAMdPtaeXn8axwrQ867lssUQJgLBxE7ahZeHa0nOiGr/+1PSVC34+y2sp3Qe5zeH
	2F1mATiEvF8HLhZETAmG5DKpF3i0vsEqqR0jprNjRhbvlh54W5C2pNByT8MaFEEYACM69T
	DJzArDoGpA+qunRaB2MicNW1VOhpnr0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v49bVuO1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772779445; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ySLYC5/cF8hmf06ne/L2kgOPFMnQM58WLWXLfygl3cs=;
	b=v49bVuO1fkFqiM6ScJNP13gRf2ev7Ccb9klhcYlXe0tYjbiXo3RqMpSIp1L3xn+Ohp/GyR1t+f1NZ8pHV44RD4p7FzMfXR0p1kkRg/Y3jmlmkKa8FCL4XVuCH/H2LsmmTbHJtn7EaZLPdWl/EOsmol52glplSnsiVIyIueoBzYQ=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-MLoqO_1772779443 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 14:44:04 +0800
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
Subject: [PATCH v3 4/6] mm: add a batched helper to clear the young flag for large folios
Date: Fri,  6 Mar 2026 14:43:40 +0800
Message-ID: <23ec671bfcc06cd24ee0fbff8e329402742274a0.1772778858.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E7ED512000C
X-Stat-Signature: q5rktzd8x9nq6m1wkmnorok4eggpzmye
X-Rspam-User: 
X-HE-Tag: 1772779450-510230
X-HE-Meta: U2FsdGVkX19r6qB0tx7IsDdPF+1UGcb2qxcOgnD5febv0l1v087Te/Om+GaevWDB32lJ4eD7eQ7+Fm70ERw+tNDIyO8qBkHiEYELhS0D/zfqT2/KDKpLgfollbP/geAp8h4fGLPep7EFpgYuzobS7YdH5YHuwmPGQ0CzJ4zHkyO0ACH6Z+oj33VBBrs6kVJjTD+Af2EXkSgmr5Pv7ucfN0MIwZruNOzvKhISk3ew/ybU/VT0Y5wIzPZqxO00j7yMkjrQuT4P4USob7wWoBhXy+Ly2nPmvqnNpZMvwm1NHKxzrkCsEh56Sd5C+41zaAtZGqy+K0ye+YoB9Wnn7gZ6PTsZ7nTzPlSky1iMYlGqsk5NUGMCMSYL//yx6F0an2xYJ78Gg7PfsPpaPNWXJYZr62248l0kJ0RilpaRHSxIRCi33fYe6nwlrQEpLK1u6QP0qmWnCBAaKYj7oAswkvMBcAP7lTQTCnfR5LkqX5aa52/2G5F+HnN9TXwnxXxSBaMlVvChAbXH/W897FdpPPDgn6IHh20mAnf8jwv0bzs46d3VqbaH5PSC88Q2GaIHUVzYVZmkTe4+WUMGRMJBSBAe8kK55CjGKZ8f+C2of0WSa16n2War8sZKrqy1+3LFmatFCr6CPI2ObcmfH63s6PIXPXuqh7t7H2XtDOVSg7yNwXDa3HpkUjoP/Tn9fwIoiO+5sNFOV7FhSo9BFUjck+VCFBSkNYxWwVYalFpNZ65I6lLF2izvhb3unQ7FSVjAPUOWhRqur3+YRJCwq4xhawYqtNsDAKkVMeIzrJp85c7kt59OOpM9s9VpUoAPo1/4smwU66tZY50Z3b9JacEzou43yZbG9dGuWouBhbFuVR9FxITUebCUSq3diDbh0XGpFJrG5vtqb2xvhkOJrZ297I+PIGDYxFz2gmioGiWBTcueqoqmjc8MlWfJi3FjImtcE5oFQPAxIyITtLtIVw1LmHB
 Q6jOS5xf
 zEksKS8wACVJwj7ZC0hJUI8A0PCOwH9bI2sA5uyHMc1rcL0zso21IHWs/Kqpxv0W9WAsztni4gyXmVmu+CChmPfbkJGU0BhZQ0ap+oTaFwxJHlQrLnShvppEAwIEky4AuUWOguiswkxXv/Wtu18tktnTdBEp2nV88mdLMondShlo/grbstcb0S1TmE6dcA0Z46Tdcld5Jo+iRAJM78rTIKyWGbHBLouqhDAYcsmoI7I1xYKsWXwbDkKtY3v9vWMB8IDMy+8MVr294ofQ1s2BAZIz2RJwgH3BdrBChkUJjFZE5L7qbRmuVKJJ/5j669OGcR807
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
 include/linux/pgtable.h | 37 +++++++++++++++++++++++++++++++++++++
 mm/internal.h           | 16 +++++++++++-----
 2 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index d2767a4c027b..17d961c612fc 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1103,6 +1103,43 @@ static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
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
+		unsigned long addr, pte_t *ptep, unsigned int nr)
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
index f45f97df0d28..8cdd5d8e43fb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1819,13 +1819,13 @@ static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
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
 
@@ -1843,9 +1843,15 @@ static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 
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


