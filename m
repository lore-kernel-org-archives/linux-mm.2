Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9B6E81BCC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83AC66B008C; Mon,  9 Feb 2026 09:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768C06B0092; Mon,  9 Feb 2026 09:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEBE6B0093; Mon,  9 Feb 2026 09:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFFC6B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:07:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA72A160176
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:47 +0000 (UTC)
X-FDA: 84425096574.06.DEE6430
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf12.hostedemail.com (Postfix) with ESMTP id A789B40010
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qix3nvV1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770646066; a=rsa-sha256;
	cv=none;
	b=7A5txsKADzFNl56UL6GloMWUtUCj92fnV1bpuBw3g+O0qWYRPBUfWHCH5bEy3O6QikTDbj
	X0ZqymbAQHYs3mt6m+hxtSFAraFv7O+60Caqup6m+h5F+fo74hRFIuujAzmWcNApMTyXc2
	OnMKtjWqpiYvaAkrFJYvReqQ3gpejas=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qix3nvV1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770646066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUWGRaUIkWeZeuS3iAci2uAMPNQlTvUSjRkLaCjx/zg=;
	b=K2EtGJHtOs6zuNv4opsbrrLU8D9VFhU7tWheVy9epIFX497YkyLGPTH2ehLoW4eXSQCxX2
	wNsjNAlKEWQyqRtWqyq1uJ/TK2TDDIMpvSbf1EP5i2Xls8CzxYw8M+p3ClY4/ub4h3YTZ/
	XR74gYcnaGCmPSSlpOUx8YqnEoIR0g0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770646063; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zUWGRaUIkWeZeuS3iAci2uAMPNQlTvUSjRkLaCjx/zg=;
	b=qix3nvV1UKBvOnsp76pHr23NKxU8mI4sAmcs+oGi+VY6rDqcPVosRkc2kTeLHrBFhHqA/5+gti1f7joxbTuY1ZBhNPCRpTHrnWUwAGMvddoLWUlTHMdwPPiJOteho966gSHgb0I1pl2koAENaY77gKxB1Pmd2RWjzZAoSjccauc=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wyt2i5O_1770646061 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 22:07:41 +0800
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
Subject: [PATCH v6 3/5] arm64: mm: support batch clearing of the young flag for large folios
Date: Mon,  9 Feb 2026 22:07:26 +0800
Message-ID: <5644250dcc0417278c266ad37118d27f541fd052.1770645603.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A789B40010
X-Stat-Signature: 1b45u3onhca1kt5cgkpdzwedmypmsu6j
X-HE-Tag: 1770646065-97801
X-HE-Meta: U2FsdGVkX1+PnaY5KmmMmyLiT1IiWG2KDkPCZ9SkbuAqDH9/J/YlgtZ0EnhpGba1gIWryzMfv9lT/t51BZRjGDov+4CRIG+IiJyEL01gRqNQdPuX25s3Ygf3v+LVLNcCxoCsA4KknyLqyYXKW6JkMyV2HPtrRiVuolkKDuk0eE7XD0/2hysady3/jIDLsAkqr2zegFoLeOxBUtj4bK0GxXpoMP2+4ReF1QoceqJ0GhVgbeQaZQMT3eXc5gvik+RrzaCmVLaNfNIFBaZZmY1qDT7suqnmLuXzF1AZ+/Mw9iKpQtHtFXTA5iO5m+nMsYsk1dI6MPvoQ9v2CyXkNJS2E60Vt6r9Bk08z8ELllpu/I1J46gywKZkt/49RmfL07TWKUeAGpDyDOzPhV4+TDGOrmjK7ePYJpFyRmn4yVG3L/j72h0lwH5X+IfMqED/FoGuTp8NYw5E4p1wUxoCf2WLL8+0BJr77p1fWeZJ1paTWxSxed7d0ogg/iI4RBPxEkquhwQm5Y2nvU9IZVXV74mrx3CDRER2+rMf8vi0XGXDtBQjaj+hSn4+ZIfeUahQN6uNeKle67ZdoCbND1Z/LdKpRovFbN3Ei9COz5xkfwI0K7Vc+e+0J/reFSFwh4gWSvZnB9D14pbFgKBHeVCPUTbMA4iwbMDvS2UmOWS9AoE6UOYnSXlb+sfrR9TfbGBD8SQg7IQkbfyDfK9tlvy1Qe99B/kO0XQcaWjfdhFS0tkR4n871bDJN1hEUA2Iqk4fFM0H3WomOFHhfJmhW6dS0OekGeatr+z53MIbXzP8zfX13jAl2vCYyQNNEkxiSd+LqincYMcd8qS2MqSMec3wrQJKVni/fTTMOadFPddSL1okCLVkuZgOHiSmUOZR8NqQ77dqjp82uyv1h9aiZD+16MHjbxfGmvN8zvI3
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

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h | 12 ++++++------
 arch/arm64/mm/contpte.c          | 33 ++++++++++++++++++--------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index d94445b4f3df..3dabf5ea17fa 100644
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


