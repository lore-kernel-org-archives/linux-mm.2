Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33286E6B25F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 05:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741056B008C; Tue, 23 Dec 2025 00:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65EC36B0092; Tue, 23 Dec 2025 00:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5214C6B0093; Tue, 23 Dec 2025 00:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 408B56B008C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:48:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8D7D592DC
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:54 +0000 (UTC)
X-FDA: 84249656988.25.8D28479
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id BA43F80007
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GwUee+a2;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766468933; a=rsa-sha256;
	cv=none;
	b=vgUyE/mJoyokNjW6f1HaC/Q+ckdYfhuwmOP7Fwkv1NmvfsatXYQZRbnhacKWkFBHlh5ISc
	yk1ZIUlrtKY8Ms8vUepMIMWOZaGwdlB85xqEb+8W+7CoNKoUjheUSEWrpaEn/puFVMvPJ7
	8Hjs1/wjdTWM//YN5dRHiboLUat+9LA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GwUee+a2;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766468933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3h6H4IPo9TPa4nxGBVzDP5j8B0g+opv6hYHBB9XsBo=;
	b=sOpM4djG1gOkQybh5jzptxCbbXk6/ZJLwax7q/G9n6UvZeu+h1uGEFHs46JezulQmEl0y7
	qQXwYuJ6POeWECnnjEmHvbpSuGdRUG6llp+0kaKPm3ttj0QDeYALftQ6qqouxskOfrfypA
	5+tk3sURk336V42awNiYrIynoZBFan4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766468930; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=S3h6H4IPo9TPa4nxGBVzDP5j8B0g+opv6hYHBB9XsBo=;
	b=GwUee+a2lBF5qLPN/j/SxQ8zBD7DlirQrqUSAVWZf59qYii1o+ib00/ch/KRbb+lIGeQweM7njHr1DC3Qz6O/VdgiBNLk+uE5m/HQdRv/KDMnAdJqE5xyM6h821c7CxMwewK8ZLa1W7LyszwD/cxha515fLGT3iuP0M9PAiX8VY=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvWWGtH_1766468928 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Dec 2025 13:48:49 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
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
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/5] arm64: mm: support batch clearing of the young flag for large folios
Date: Tue, 23 Dec 2025 13:48:37 +0800
Message-ID: <3b427d9010a6d52f2b91342760f12be097d21cf6.1766455378.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BA43F80007
X-Stat-Signature: baka9dqqte53z8pteyfa97w3o51tc894
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766468932-244704
X-HE-Meta: U2FsdGVkX18PwTGVVRYck0lQdo7WthHwHdPFn4YmNcdVpKa9j3FGjPqqFw6URmqsvCEUvQwfe/CXM/nU4htdAEiSRXtXG326mIe9TxYKq+vuUbpagoXWLvmpMlii0E/z4QHRFLWxBSI+kC74KabdLfLRJvUZCDMzTBLc6UXWRcHi0FMRMpyM9NzNCg0htGpsSuzF/K1Tmk82A9JxlwdLMsJI2FRAXphyQXZSsx0IplUSmEFnyb87OW+y8XGR4huB9nUgksBckr6YvWVq4ldGdPUUet8NNiZujuyy77fWD0XhWX39YoeUbq/Ur7yPsR3cXJP6/66tGG7sAHSey+QyGFhW4MFvbeiPSkbZ9nH3QuLL6Na3IPieZTxmbe+FPrQ6n0I2fMVSIyav0vUoJi6dbnrImKjO537pFP9EuSwYR0LmDrrohooSOEkDbNfttM2W1ItW+vgkv8wdiZF8LTQPIJVMUGI2M1dgGf3ogkjI/B95AKcXpTOd0Oj8wGAct9ZfvcCP2ucYJqyhXTsKrRktRb41Yt0TrcDFwsFDG/VYAAJp/0oPrXBgeYWeka/XcYxYvDyCuaIlPNx2PocwSWwDFhSRm8XrPOl007RmcV982w5k3A6sfxcc4yIDI+L7LOHqK5GtfB+BVbaw8qw4NEx3YwRvTHeVr+w5vw6XI3NZavE5Ae0j8oIEx0Ur5ttHZDW8ECpFJnFS8m7naSdNvp6vyFkl/UnlzNeAkDyNumcN/SN8rvTwY4WeM/BMv3lIXb6MEym/dSLXE/9DE8mOerV1iatjGIP7py8GzEe6IR+0FHQN6dXOEQZ1JzJvT2eq96+OYIuE0dr8BkJPLaKzRxMXIVve2ZmIcnAiH20m1bxf59Zx9XJLNL+7R4tyrJ3HYH8EBiSKJAVrIaQydeB4w2FBVaggotzktU+4EXAHWjZz95FUMT9jo0drgwwOk7C+rXhSGeKzMxdCD1JnwaDTb7V
 YQZism1i
 +x7H2xshcaqHppg38M+xMXSDOnW/kNkY6Z9G/Wk7QuhVoA++k8I01B6/8+HWHY2khkDSCyqphCpbenOM3LjFP/lWqYBr3hQEVZ63484vvl2AZFqthOpQWUNi1BGEk4/RC0gJ8T/aOymkJ38rNZPi7Rlv2N+OEQfugS5vqOfD4UxhznnGWVcOB4AcoDRdf8uOLCI0bKSn8nRB37eyiWhXWkb6oJ2p6nGOXk1gzGUv5CckHvP9CDfdEDoHdv9Odtc0MaVJ4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
only clear the young flag and flush TLBs for PTEs within the contiguous range.
To support batch PTE operations for other sized large folios in the following
patches, adding a new parameter to specify the number of PTEs that map consecutive
pages of the same large folio in a single VMA and a single page table.

While we are at it, rename the functions to maintain consistency with other
contpte_*() functions.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h | 12 ++++++------
 arch/arm64/mm/contpte.c          | 33 ++++++++++++++++++--------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 445e18e92221..d5fbe72e820a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1648,10 +1648,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep,
 				unsigned int nr, int full);
-extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep);
-extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep);
+int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep, unsigned int nr);
+int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep, unsigned int nr);
 extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr);
 extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
@@ -1823,7 +1823,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 	if (likely(!pte_valid_cont(orig_pte)))
 		return __ptep_test_and_clear_young(vma, addr, ptep);
 
-	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
+	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
@@ -1835,7 +1835,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 	if (likely(!pte_valid_cont(orig_pte)))
 		return __ptep_clear_flush_young(vma, addr, ptep);
 
-	return contpte_ptep_clear_flush_young(vma, addr, ptep);
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
 }
 
 #define wrprotect_ptes wrprotect_ptes
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index e4ddeb46f25d..b929a455103f 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -508,8 +508,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 }
 EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
 
-int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep)
+int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+					unsigned long addr, pte_t *ptep,
+					unsigned int nr)
 {
 	/*
 	 * ptep_clear_flush_young() technically requires us to clear the access
@@ -518,41 +519,45 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
 	 * contig range when the range is covered by a single folio, we can get
 	 * away with clearing young for the whole contig range here, so we avoid
 	 * having to unfold.
+	 *
+	 * The 'nr' means consecutive (present) PTEs that map consecutive pages
+	 * of the same large folio in a single VMA and a single page table.
 	 */
 
+	unsigned long end = addr + nr * PAGE_SIZE;
 	int young = 0;
-	int i;
 
-	ptep = contpte_align_down(ptep);
-	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
-
-	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
+	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
+	for (; addr != end; ptep++, addr += PAGE_SIZE)
 		young |= __ptep_test_and_clear_young(vma, addr, ptep);
 
 	return young;
 }
-EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
+EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
 
-int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep)
+int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep,
+				unsigned int nr)
 {
 	int young;
 
-	young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
+	young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
 
 	if (young) {
+		unsigned long end = addr + nr * PAGE_SIZE;
+
+		contpte_align_addr_ptep(&addr, &end, ptep, nr);
 		/*
 		 * See comment in __ptep_clear_flush_young(); same rationale for
 		 * eliding the trailing DSB applies here.
 		 */
-		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
-		__flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
+		__flush_tlb_range_nosync(vma->vm_mm, addr, end,
 					 PAGE_SIZE, true, 3);
 	}
 
 	return young;
 }
-EXPORT_SYMBOL_GPL(contpte_ptep_clear_flush_young);
+EXPORT_SYMBOL_GPL(contpte_clear_flush_young_ptes);
 
 void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, unsigned int nr)
-- 
2.47.3


