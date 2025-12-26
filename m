Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49926E8FDA1
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 06:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30DA6B008C; Fri, 26 Dec 2025 01:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18516B0092; Fri, 26 Dec 2025 01:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9714B6B0093; Fri, 26 Dec 2025 01:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82D356B008C
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:08:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43286C1F0E
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:17 +0000 (UTC)
X-FDA: 84260592234.25.56B55C5
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf28.hostedemail.com (Postfix) with ESMTP id 29200C0002
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LwSc93gJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766729295; a=rsa-sha256;
	cv=none;
	b=Jz0Y5+TZuP6XG/0DqDgsGfGdLJwN/GBaFpEf2Hp4BkzQprNPOkW0MQajygkJrRZu6TTuDB
	6S+pNfcZa2HtBU5MPQUymBHtemeVeXvKbMx55qOTBvY6N6poLGeghyQEjuVTgmL0zvxkeS
	nm2rpszhKgOuqE+Q4///B7qtWc12L94=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LwSc93gJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766729295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BRmmCFNmICp36tUrVWzeWlSSPOKZXfw//kjlU0BodFE=;
	b=zLK1veoLNzLMOM9IQA7tC6Gn0WWRmKvtFPIdZTwcZ0o4Ot/4ajpcUeEkOS1muOTrzDSmlx
	pRiBI4N9qEX2zjps2BISFlyA/MZRsbBDM7Bd/edfS+00CI4m492Z2bEOrzpTdnIWH1GOet
	fU0qZJTgR7fVl8MC0ZzT1vdMtRQzjNc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766729291; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=BRmmCFNmICp36tUrVWzeWlSSPOKZXfw//kjlU0BodFE=;
	b=LwSc93gJF9e1k456bYfZeY//l7VL5Ls9116whIqF8WxFAMcT4zTTa39hzv+QRrBQta6JnTUILOOBmYrPyUgPjMPeIHmuWbrpAmALUIqmM+yjNxaXd6DBVPNO04NCC5Ih66+lbZvEScYWBLZ6AuhXgj9zEbVr8YD7YMCE4aS3xJE=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wvgbcyw_1766729289 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 14:08:10 +0800
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
Subject: [PATCH v5 3/5] arm64: mm: support batch clearing of the young flag for large folios
Date: Fri, 26 Dec 2025 14:07:57 +0800
Message-ID: <a5138065a70a7588904d0bcfc569a5d856dcc65e.1766631066.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 29200C0002
X-Stat-Signature: wdm4oarzzc3hnydoqrnam8w6ye3dzunf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766729294-321287
X-HE-Meta: U2FsdGVkX1+DJR6TPX+xEWgeJ/fg7JUxh/eqt1Sn72CaZUaB9/RHXOsibGPb+8ttuQvbDFWPy5b4fDddvPuOg1+JjxuLocbILZs4jGIThvI7lzHSLbw79VEr+5nquoKfYMkkUGP1BI/fPTuW93d1D+gNx4LpoiSYE8hZ9ESEdtgFcuDQy0qTvafCLQHPsn8c5x/1oAYu5iLgF03gtJsZfuZlKv+h3xVDlh270feyqG/zgYqTpD8Esvo8N/Y949g8Xff/9txBvVdvQNfqgsaM9NnPjXDQF9OQL4hJVfPLnh8SNB8Fztd6OsqRnU2gEbWowRSwgLErVj3te+igMMRYlUVDu7PxH9IHUkXPg4yJsisEU5IWBBBBZlYjeAvXfLlUvKgG4b2hK1MCajxwJqUnt9LZMK+lH2Uc/bi+ivh6u5rU1RSmXxEgcn1PbO+3kgXS8IVECb36KynR4SMSZT0EiooWzq74nLqS1g3DO6HTB5yjdUFe4UmnO1oIv0EcvcCX45z0DZmtXCr/xkgozvRJ6MSKapaUYb2PR4q2ukxBzw4/kuUcTa4ByLZ20YLVkh7zOZQtzR7GZZDzy3GfhcnoZKUau9o9SeaJyxnffmybXthHrqZiAvqw484bsRyD5ln6lLwugYYqUlbjA3roR1LOpK/mOLPQmQeCEe/SHEJToFxH7FfHfhNlA6viBXVucGhEvk1U1Kjeq719uMGiycAxI8quD22gi4gRDXcD3ZbW58L5qV1+MviCH6qR6fKYtKKuA0H2FZs4n9UkDpXTxsWUtAitCOTfZvGDjKy7wWCD/T/UDvj5J87yXO9uWVUJgEF+iww3r9iqrPQYBfleMyVrJgbU9j8JYWmG4v1bMdczZyg1ecx9D8XWHSjzpoEi3NvnQZBGZJZxbAU+L607ZqE50VPtTuHikNuM
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
index 445e18e92221..5e9ff16146c3 100644
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
+	return contpte_test_and_clear_young_ptes(vma, addr, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
@@ -1835,7 +1835,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 	if (likely(!pte_valid_cont(orig_pte)))
 		return __ptep_clear_flush_young(vma, addr, ptep);
 
-	return contpte_ptep_clear_flush_young(vma, addr, ptep);
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
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


