Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E7BD711CA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E64D6B008C; Fri, 19 Dec 2025 01:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2906B0092; Fri, 19 Dec 2025 01:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5557A6B0093; Fri, 19 Dec 2025 01:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 417F76B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:03:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05DFE60207
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:13 +0000 (UTC)
X-FDA: 84235177866.08.F6BDC9B
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9BCF4C0016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MPrmVe2s;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766124191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Umqy+CieAvau1WCrcGlezOzuDWrvWtrJZghCjmaOXp0=;
	b=nOnqrAY660HSd6virqvXi+ScMZFRY2RVpW30LCWPyeqfX0ol1AvzLN5q5SfyMyXEP3pujO
	uXU3eS8ULVJ0YAU93Z3/R90X9CV6sWJAG3ZAcX2U7RGq4oRjAeXJK7mCqIY1xDX2r6jRq8
	B7UsNgXPCiegESSYPBOKC/KPleBvJN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766124191; a=rsa-sha256;
	cv=none;
	b=Q86ihFtYf0T2/aGy6M7Q6+sVy07WF3qRWYSURQkoSDFoGMVBi/KYwNZXXyVFKtY7hBfo2m
	pCqQK/g5eZuLz+o4xYaRDQRRd45VK703yplXsx5G55KuJHSGwfQzXYFXf/e8xF6lhL/kPT
	gUvFCbRa8M4FkQXGN1WmDZGk2sAG72g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MPrmVe2s;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766124188; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Umqy+CieAvau1WCrcGlezOzuDWrvWtrJZghCjmaOXp0=;
	b=MPrmVe2swWEM/mWhhjQll5XSLRICHgZyd9ABTLim93PaNFPizxY/CVk2uxuA9PZyQOWbkUB47DFfG9qW6K2N5P5b9MYqKH+x8cBaaL8FdjHSGYg1HEO5o5Gj/65fV376BfAKGQD3DD59BSqc6mHkMzN+8GeH6ICwcs12c3ExERA=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvBV0.x_1766124186 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Dec 2025 14:03:06 +0800
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
Subject: [PATCH v3 3/5] arm64: mm: support batch clearing of the young flag for large folios
Date: Fri, 19 Dec 2025 14:02:53 +0800
Message-ID: <0fc85ceb11b26e2fd0bc164df0391c7117881c61.1766121341.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
References: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hyifmmbmofmkeuxc4p1xmq4rbiqo5zko
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9BCF4C0016
X-Rspam-User: 
X-HE-Tag: 1766124190-732663
X-HE-Meta: U2FsdGVkX1+5fhJRQj7jI8VhpUbhdJLBj8ULiE5KGAN9koGlCyzsfOXvdPdv1v4f/oOa0y9dchUWc4t+FwEmd7scP6k1puPCjoaJDL9x4pDePB7t0eoDr6FcNGqOz6gA0pqyqze5flfR+lS/+5axXy8ahxX9XJPCO5uO01BmrhdIY3F5I2j+weGLibUd/+/rWiDkGlca0NzT7Y7lC9j3Gpke+1v/JHj1akJGZONtx/EdLKPW12eUB1l3g6Rtemh86wDshpIoCmNgQ49ZuMy2hkEVJHSl4WLen7xeoIAIPGKCNjcys60UwfiE0QXUrjFEQg8dyOM0baWfIpM8X6WftKgxqjiX4A8mJf474qJfjU4l3lekVeGYmJDh6O0Y8jwuEaLV37pUtBejVCziI9z9hlPLvHDJ3boxxJDO2gz3kmu3tutEMSpqngmcHZ012FQIIuLpHRQpT+vLURE5X1vhXOuTdG5orm4KzQXzSaBc7DWnrShrFKlUKoXUJJzwQPd+9T4Gjbfn7duFvRRXaRQSkcUICXJv5u/I2reEqCixhhWpiSrRcvRPCtkPgktNsE8ia73RcBvumlCxoZQHfOCaBUuZL74UVJY5Ely28J3beA/oHNL6odRIbpqyYcoJOO9k7L6HwIpZq5infq/ZWC+gv4bDhHwuVHE/7ZJVbbuqZQ8umpusBHw3tOdi8qIcQNmLOiABjpTN3a2Svbmlsm2W4hq9nt50v7dRFMQYVEEwAV+y3zJzwu8Y6BFD9jLyTZxtwTr+vZedlAUvvGZcJx4iMtrplMNJGc2+lgWGlF7aOWoQqoe247CxgG0YqB5tk4Sphl0YmtmYQKEKsGy3ZuSgtC3K3558vdmEy8INqVgrTYWyjtPNOqOer85EpU+07w7460iuywwVY5yQ44cN1Ar4iuk9VdB/ohh5eQDhrnrdiXLM1c6Qlv/x+Yz5umD4RSkXDcgOAVoirvGGHSs0bQM
 vGz9qWhc
 KE0Uz3VWJ6/2v/jWH+sAMxKGC7s0xzsTrvf8RgaYiXa4N+CehmfVuis5p53u7EGhmEcCIYZGaMObFS0llV/gyi+kw9WANh2GIx917pF/YwIpvzlMBCZQQNGwfyAO8kmVeb8bhANhpJZt2qvOIFpy50noZXPfxb9h0RfUgOrDGx9wZrIlI6QhLcnJ366rFbjSzSRpFswW1V5POSSTo1Pxjr9R9AF6EjdO6bDdyaCBT3PMVUHatiN3T6DdBgXyV7zworfrD
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
index 0944e296dd4a..9086753f68b4 100644
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
+int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep, unsigned int nr);
+int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
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
index c73e77207584..c0f89af605e0 100644
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


