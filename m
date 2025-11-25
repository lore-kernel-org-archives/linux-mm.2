Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB6CCFD36E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 00:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A50E6B002C; Mon, 24 Nov 2025 19:57:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655E26B002D; Mon, 24 Nov 2025 19:57:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DC06B002F; Mon, 24 Nov 2025 19:57:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8FC6B002C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:57:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 540DB160656
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:57:08 +0000 (UTC)
X-FDA: 84147315336.12.5C40076
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf27.hostedemail.com (Postfix) with ESMTP id 743EF4000A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:57:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=egCjUtvq;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764032226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ea6etQCpReM0Dd5R3qfwP463Goog5MVH76oxL1v2kk=;
	b=sXAM+SuoED7yZkURpuEmNP5Ib3fxg0dWSCd2WLMupeGzCE9JPLe/2v3xjHJxXqG+a3X6Mk
	REUXqUsi1cL1s7QItY9b49JTCR8CibgRKcwWXSgB31abXX82+uotO65kQwNE+MezW8wvUQ
	pwAwQ2zXrjcU7D1mupxlSzegDie2Qbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764032226; a=rsa-sha256;
	cv=none;
	b=u1FeohlA1NrQ+CFesqnJEPSsKT1vZW19BLOrPYao4anvnBGq9hnFx1NKC2YLH9vqQC5/zS
	H6JTlYIGYo5E/CP0MT6aA/6+3W2GL7zG593HlY2W3bjWbGBNvocD3IJgHbrxMXnyYOrYzm
	+y5dBmXNM9ceQQa8+Woy3QwoqwuvEYE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=egCjUtvq;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764032221; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/ea6etQCpReM0Dd5R3qfwP463Goog5MVH76oxL1v2kk=;
	b=egCjUtvqAvX9qvvEpsZTTuumyfx+fx/5gdtMtb9hbiqUvp63Z73BlnmVem06JngLYlBofR19l80RjzZiQC/ISVR7SERlXWbBjlm8AnqaApDo2q4W4uvT/MchIPyR+fvP2dbdITprjYGRPNmMspzZBILOSUNOkLHdruYLECl89uw=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WtL1wub_1764032219 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Nov 2025 08:56:59 +0800
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
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] arm64: mm: support batch clearing of the young flag for large folios
Date: Tue, 25 Nov 2025 08:56:50 +0800
Message-ID: <1d71cf419726188dfc41c292dfac066be5cb1e33.1763976541.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
References: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 743EF4000A
X-Stat-Signature: 75zf1rwpaptk48rjzdggxemdc5wskrfk
X-HE-Tag: 1764032224-226508
X-HE-Meta: U2FsdGVkX192Oek3MSTFYZeXGim5RQZhLluWMxz7rqAnQYCVHCrSq9nioTmT2QEpHpTF3bW6Y+i23YW69V4Mg7Qbjdf5FKAT685i5/D4g2exQRGx2RMo3u6zwCtIMfIfh6KhrVy8980in7FVicnFlRD8tyrnmazzrPT+bE0J1CPixWDdrNIr/aCNXzkO7mY7Xe3ADbGBHPS/UxO0R39GgbN3quOzAJ/wEAj8rT79GQi1KkkY8a2QYJJZNMcQ0NNfKoGtwSZcUXGvqaAPfvT21ZSvcWVSmnKzL/Nw9K0Ambw5CEl1aljK2Gv+DBNJnTgQGDRWp+1FcqVYyHnt2UyCPJY/rb6sESeX2cJHi5+C8Rx8Atwbh+3DdIFTUS0U73mu0C59i2JqC0I7mxw+U07GR+0dunbCyAjlsMC7D8eqsMZlmDbARg7uFOTiu78UsflrtyQ6jFxuzFZCS+6Txaz/gkZyXW7WF1MnaTblEJEfaaPggooWgpKtRFmL3kg/4pyn52sJapJs8eQhqkREGNxWYj+BEG2lsz12K5T4mCOdSqbNP6AI12+yiEPIhXo4n7Lg2yJez2fws+CrfdxpHrhLcV/VDOG1Q0d7tkyJkKz54EpPKLJlQC1PhtWw5NTTLp5+MnKtdpcmiJXCM6SPqY7U3JSIzPQ0ezSy6YH0iFtR33LckWYK0e5rPnlSrssOyhLMUrwlmFA3k13S9ZbmXjgWklosiUmNwUQBHTppOzm9kcodSMsh5CLFrCvD+Z9bONGYQ272WwG0p+qGu+HCAS/zpwDDFcT/+yaTA8u1aXa0GWJCvKCHfJZ04k0sgF1X6lhUkpoI8/k/Oxv5vWrcYEoLcNQnNV1f+p84evdwU/QQSvtv8W9Tv23EzFo3+n9ekijLElFVAZWxKkcSxP8LIjvTQIJCrnMC8/6MerwL569GLIeUlJ44rYZdKBJOFJgjX9bfpIdDnzT0zhbUipTIV+T
 6BDYbQzR
 p1VnbZZ6Oc3KGoK4OoNzFjjwAiHxVGUInD+wL70Ffkar3FUvC/hLd1DvULsTRibXGOy9AUECwiYTLw+xY3Z1NZIG//hC1ipLjZf5CQkO7xLAMG0FqATUXTGry/vN50YB+XmhugNmEpk8j/Cisw5Xb0YLFrSHiAgb33VgEepW3RZRSYTN6R6cI2TDBiQ49OcN+5ngyIdq0uYDuhvve0SiCV1yYOUdjQ+yLNc5zzVccILhRDd5HSMCsQR9NshoL2V9JKulK
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
patches, adding a new parameter to specify the number of PTEs.

While we are at it, rename the functions to maintain consistency with other
contpte_*() functions.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h | 12 ++++-----
 arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0944e296dd4a..e03034683156 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep,
 				unsigned int nr, int full);
-extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep);
-extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep);
+extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep, unsigned int nr);
+extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep, unsigned int nr);
 extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr);
 extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
@@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 	if (likely(!pte_valid_cont(orig_pte)))
 		return __ptep_test_and_clear_young(vma, addr, ptep);
 
-	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
+	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
@@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 	if (likely(!pte_valid_cont(orig_pte)))
 		return __ptep_clear_flush_young(vma, addr, ptep);
 
-	return contpte_ptep_clear_flush_young(vma, addr, ptep);
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
 }
 
 #define wrprotect_ptes wrprotect_ptes
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index c0557945939c..19b122441be3 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
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
@@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
 	 * having to unfold.
 	 */
 
+	unsigned long start = addr;
+	unsigned long end = start + nr * PAGE_SIZE;
 	int young = 0;
 	int i;
 
-	ptep = contpte_align_down(ptep);
-	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
+	if (pte_cont(__ptep_get(ptep + nr - 1)))
+		end = ALIGN(end, CONT_PTE_SIZE);
 
-	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
-		young |= __ptep_test_and_clear_young(vma, addr, ptep);
+	if (pte_cont(__ptep_get(ptep))) {
+		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
+		ptep = contpte_align_down(ptep);
+	}
+
+	nr = (end - start) / PAGE_SIZE;
+	for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
+		young |= __ptep_test_and_clear_young(vma, start, ptep);
 
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
+		unsigned long start = addr;
+		unsigned long end = start + nr * PAGE_SIZE;
+
+		if (pte_cont(__ptep_get(ptep + nr - 1)))
+			end = ALIGN(end, CONT_PTE_SIZE);
+
+		if (pte_cont(__ptep_get(ptep)))
+			start = ALIGN_DOWN(start, CONT_PTE_SIZE);
+
 		/*
 		 * See comment in __ptep_clear_flush_young(); same rationale for
 		 * eliding the trailing DSB applies here.
 		 */
-		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
-		__flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
+		__flush_tlb_range_nosync(vma->vm_mm, start, end,
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


