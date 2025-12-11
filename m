Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01495D3E79C
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9312D6B000A; Thu, 11 Dec 2025 03:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BAFF6B000C; Thu, 11 Dec 2025 03:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0F26B000D; Thu, 11 Dec 2025 03:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E19A6B000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:17:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F34C605F5
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:17:17 +0000 (UTC)
X-FDA: 84206485314.02.A5D2F82
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf09.hostedemail.com (Postfix) with ESMTP id 36CAF14000B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:17:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cbOqi1Bm;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765441035; a=rsa-sha256;
	cv=none;
	b=VxG1vm4S+exSGZJWog2odNtx5PB9VIlG5ji10ZjPaZJ/8VO1zhbaGwVyFNxQo8/72Q4MNV
	rIk7Bp5RmkPlMwIcSddBKHAvKNdBdERT6E3XVpbyNIccnMzPi+FsEsMNKRMY8ynsawTr3q
	sgXI7Ps5PgjxsR14bYlojVncdztO4/M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cbOqi1Bm;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765441035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ea6etQCpReM0Dd5R3qfwP463Goog5MVH76oxL1v2kk=;
	b=H9mgcvu1YTb4XZ8Tw3otLh21D3CTIoCQ1+1qG9I6vSKLRWBy4VLi3vyNs8vq7fKmXRR/iW
	IlB5TtVwl9Z5CC4vgzxQJU1l6pRcvsptJA+5++9jIHENwi3p89j7fj3blyND4wSxb7DLjP
	rDGxTlZ8RrYggdFjnTn8V7NYKVeOfgs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765441032; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/ea6etQCpReM0Dd5R3qfwP463Goog5MVH76oxL1v2kk=;
	b=cbOqi1BmJlR3HeCWfRata3dM8PlfIC8sss/Oz9J9NrF8666xT8cH8zu5mEMSH6/k0NMTZWL1dNHWUX0yD2GZIzaFSVcjmZWMsmENwumzxS03lgFOnicbPHW8IwpLArzqc3tNVi7/b0UtHgMtB21urPYtnlLaimHfUOeWfv0GNhk=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuZnGbv_1765441030 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Dec 2025 16:17:11 +0800
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
Subject: [PATCH v2 1/3] arm64: mm: support batch clearing of the young flag for large folios
Date: Thu, 11 Dec 2025 16:16:54 +0800
Message-ID: <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36CAF14000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 55fhrs6zrsupqnm8ay8iuh495e411jfs
X-HE-Tag: 1765441034-966537
X-HE-Meta: U2FsdGVkX1/fu3ogJr9Z0GFYD6lFuPWHc3H/4p4wJW6pwz4wuW3U8bvXW9b3CI9/ji0GcUO3TZKi9sQHtDbISMvD1Z+2R38oLgWoOc3JKxDB3GBmJWkVry5gSBRnr09E2ejQvzj8uA1P/tz/MwMtjBzI6Wv7HHQW4AUGv9Di//usycJyjRpJ48MPZ+QXKONIpCx03TKHFqellL4EDSHfo3h71ORoSzO3m96tbPm7BNt0eFTnbLoHWqxpFEjegwDn/mzE7ngYSWqFR7+280I2+Zu8wVzNofX7Rmvqgnr0GN3OhgSUfcvh1CD+Ic9IZQc3CWpV4HSQeMUh1hHDM5oJb6dEPHMaFswvKtHbw8WSlQjIERl2w/d7fJgBsnawR0lpiss6531PP7ufvgYoblsDQZFV9+rkLDo8yTenCJK6ubf/2bgYDL+cG0dboyQaV7Y04is55y/b3cV8unNGJZZPZcq+XfKzzPyKC5ej1c+Yt/r0hdI8nmwpxfMJoUyyJASr4RVxBvzU/HN0Vr9OyU764LdC0e9xRxLrF6EYFba9lftcBd0TWF5VD1fx8TBJUQbd5aHec/hXZHM8Vszz3XUBK3EiotvIDrh+Or6Adks302vXVv26TilucRN4W1xE4yU55QQUVRGoSihzkrS+guEtxmX5uGYNd0Kv2LMDKE3yMuGvXqvCHQ6puxSyeCVjDVohEQ05qcTJcywYChpqnMF81zWxpCBGkZBGMW/ElwjFRnNrGb3qjwgClI/33WhsCoZuVlnqBibJPiTA0I2z1xMpUYW09Ro6/ap4GXYLpjRWQmazrAivqNqNVhxO2FhUtgIII8wcFWLRNCiu+CdcI+q8ghhqPMCkDTXuK4QrnLAcjj9Oq+1BLWvEhx6LrW1l+u3cSqZGPBBsLxVoDBgpI9xXNOeGenKsO1h4O2N+uqs59L16KIqHCEgZAeua6G3wBFnVH6zTHNTcBmHuvLvhDrH
 EwvJ8dZV
 r4w6nHLezKYyPvBmBHroO5ejQTQ//mVuxyk0MLtwu6EMkg2qfarD227uQL7hD6Bc7oErcUZITwF4ojjFCIgO5LxzFHlYUCwphfYFg6ofBYF4M5P9VZg8rQskDTEcoiYGtqvLxaLoFSqH9E/4g6dfW76gccNf9D28V4oF+kPoadfdtGpbqwtDuBdVjI8EuQAE7YbS4JEOMNoa0u1VVWjrBFU2JX8+Q//jNIvBt3hYlGaLLS5/nmSenDRcW8kpQoAr+VGg1
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


