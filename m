Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC9C61093170
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 06:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432296B008C; Sat, 21 Mar 2026 02:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40AA16B0093; Sat, 21 Mar 2026 02:43:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF9F6B008C; Sat, 21 Mar 2026 02:43:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 192316B008C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:43:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D88041A0174
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:19 +0000 (UTC)
X-FDA: 84569128518.07.EC4BA6F
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id 419C9C0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZiKakgdV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774075398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKPUJMB2CvMsCVl9Ou1D+eNQe4gk5dNFjUcWcWZbm30=;
	b=hGi7gdCfA8Lcp0wasNk2IZcZcoynhts99YXU/CoNwYtlMXOlC12+NWnfAV1LBc0CuG/SsM
	R7A/VIe5XWV+iINejvryWEAoi+cJZ6SjfiKNYm7qxJRhdSc4DHXk4krDMZareuSxa1zqkz
	YjJI1sAS8tPTWJKupDxLiPfd9MHz3IQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZiKakgdV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774075398; a=rsa-sha256;
	cv=none;
	b=Bqx9tj9Ktt7GRAzuUrF6rNzGIE+bvsCNKkj+Dod3T0rWHUmCaKOoeA+9N5AGd7CXu9EaZH
	ZtnGr5UBzR+6aCW0yhFuulEpjfw2+UJe/DA4NSCAwWNzdXfWVYi1Kr3k4xXnCEmGWPVW80
	WV60g1Bgh5b+VV4S08++CZionieVuMo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774075392; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=DKPUJMB2CvMsCVl9Ou1D+eNQe4gk5dNFjUcWcWZbm30=;
	b=ZiKakgdVHPEvr+R8nnt50wmFiFYgYWnU4MnlQ29WRJ5rjxVTLr8uBp1E5kVR360c57xqByoKH3FHIKTIeUHuPOaHuKgKR3Csgzp5G9fCTxk3IWPnkZGqn1zus5/ZPrFcKrto1aUaHvLphg031UiCHsd5Ph9b3EPoxqjSBqguIp8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.O5VF6_1774075390;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O5VF6_1774075390 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 14:43:10 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org (open),
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] mm: change to return bool for pmdp_test_and_clear_young()
Date: Sat, 21 Mar 2026 14:42:51 +0800
Message-ID: <f1d31307a13365d3d0fed5809727dcc2dd59631b.1774075004.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
References: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 419C9C0005
X-Stat-Signature: mq6wcougpb8ispftsactu6muxn6gif9d
X-Rspam-User: 
X-HE-Tag: 1774075396-178008
X-HE-Meta: U2FsdGVkX19LrwP2x5me8ljCL4H7DQ/dtAHi7nO3EdyvMLHAfZiMSDMf3AIveFLef4ykKjJnOPfrozqAASSK0fo1TWaC13LTSXAy187Od2F5CARwh3BTnnrDCgYVKok8w1EmycmgDqvqqpezjQ1eL/EQ3eK+HITEnfif9lcfjemQGwVPjKxyrwJDOgzxnXB+E63oLt1JlOvQWFNBKhNuLequFmotPJ3t6rTMjkiyGm//HlouTb3DgiETDKzAEzT0y8X4fryVhcnkpIbwehf/xUgWxJ2YV8cj7DjoDDezdCDPm2US11OW6Wfgc+d4q9SDLcngL19CgwclzfCmvxTFCmZOHonwUXrmYmoEYrT6ODA/969V/Coj+1bKQmgJtl8mVy1PJn+VqADdZvYNyM+IkRnbXRrkl0b60Vbv+rSWhu4EnT8+hSv+J1yXlVVaM04Bj7A2xbfe7jju4ScyCXmlkONpz+lU2JOSksLeGm4uke/NUKuBt7Lc9WglG4nE+23LGO9d7RJ0ZwxEKSty+IPK/kp5oy2g7ItgXC27dwt/SnHH/jdGfIdB70FrHuqhXt1d+a24/pSLExeMlYLMXs6D8YpeU95A5HLVZ/U4KLEsqOvaNjutukJA9YS7VwqXAyAcOdsNkQ3bCykHOfWcipFB6fmHZqJ45p7ray9M8Cu0Bh/i9HLF8N0hJFOgU5fFseFJLKvk6YWocE1r4oLp31iJToQrDOTX7jUNVvg3I1t3Ani6cVfoDQmCDo5tN9nhcqunqDu4NRS0pVYuGEG8VvbeEuQNhj9FYnvCVDkVJltFI1ZuZF+7MFc5EJSK4UtYYcA03Pip/7Z9ImXsg3ea77ZdebdGHi9Yxnr9qPvhFpuLKa9l3UZCtCJxNHbbs7VDV/4MyYxBQxAV0oZM1/J//Oe4QPo9dIyNi0xi3CxR4i0YDIpBpMgZuJpNYpC/SyU2Sq1HJX4OCXWxP17F0XTgeR5
 8tCv4cH9
 V0jDQSGs7dK6iMb7BAGGkWyOWz8FVAdYs0h2U0N0+IF8+JKsTgJmKuq5DEXyNInn5Kc9hxSuXAAj933mJXOX8ahFMQOSHr/AwoKXSCZ4he/T4rGV0008p6rrfr8VKHw+b2FIMr31KjdNP0jx8Sp1qccCBu/kV4bRKu+tIZcbF8bb1Fjrcm8QeXzom7JyIFFTdybW8jV+4MqF4fUdJIfcgsbHBcom1IE1dSu7k7zmOBOm0UgsRH4p7D1kZO/nYHQJqqfJ5SbkGm3JFXZDGFI3d3iT7hEKPwLnmsSu7uu/WIbog8NyN+N/WcHtGpSr9f439UxxZo3/zOQ/XCiPRQkr8UYPlu9V80xc8EPSQloGJFChPV5Sr/NVK+3bpP6jGrtuCOI5J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers use pmdp_test_and_clear_young() to clear the young flag and check
whether it was set for this PMD entry. Change the return type to bool to
make the intention clearer.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h             |  5 ++---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
 arch/powerpc/mm/book3s64/pgtable.c           |  4 ++--
 arch/riscv/include/asm/pgtable.h             |  4 ++--
 arch/s390/include/asm/pgtable.h              |  4 ++--
 arch/x86/include/asm/pgtable.h               |  4 ++--
 arch/x86/mm/pgtable.c                        |  6 +++---
 include/linux/pgtable.h                      | 19 +++++++++----------
 8 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 1009f719b157..52bafe79c10a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1320,9 +1320,8 @@ static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
 	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index c049a2e26e25..8b354e81ab22 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1161,13 +1161,13 @@ pud_hugepage_update(struct mm_struct *mm, unsigned long addr, pud_t *pudp,
  * For radix we should always find H_PAGE_HASHPTE zero. Hence
  * the below will work for radix too
  */
-static inline int __pmdp_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pmd_t *pmdp)
+static inline bool __pmdp_test_and_clear_young(struct mm_struct *mm,
+		unsigned long addr, pmd_t *pmdp)
 {
 	unsigned long old;
 
 	if ((pmd_raw(*pmdp) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
-		return 0;
+		return false;
 	old = pmd_hugepage_update(mm, addr, pmdp, _PAGE_ACCESSED, 0);
 	return ((old & _PAGE_ACCESSED) != 0);
 }
@@ -1300,8 +1300,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
 				 pud_t entry, int dirty);
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long address, pmd_t *pmdp);
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp);
 #define __HAVE_ARCH_PUDP_TEST_AND_CLEAR_YOUNG
 extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long address, pud_t *pudp);
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 4b09c04654a8..c584321e3d41 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -98,8 +98,8 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 }
 
 
-int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address, pmd_t *pmdp)
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	return __pmdp_test_and_clear_young(vma->vm_mm, address, pmdp);
 }
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index b9dacfc280b1..67e7746e3fbe 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1015,8 +1015,8 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 }
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					unsigned long address, pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	return ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
 }
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index ac74b5076d8f..87a5082da28e 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1683,8 +1683,8 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 }
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3993657e0a35..ba867bac6096 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1295,8 +1295,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
 				 pud_t entry, int dirty);
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pmd_t *pmdp);
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp);
 extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long addr, pud_t *pudp);
 
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 1348384a3bb9..b09e8c5dadf9 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -456,10 +456,10 @@ bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
-int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pmd_t *pmdp)
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pmd_young(*pmdp))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 99450a3b0705..6db900a5d38b 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -507,25 +507,24 @@ static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 
 #ifndef __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
-	int r = 1;
+	bool young = true;
+
 	if (!pmd_young(pmd))
-		r = 0;
+		young = false;
 	else
 		set_pmd_at(vma->vm_mm, address, pmdp, pmd_mkold(pmd));
-	return r;
+	return young;
 }
 #else
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	BUILD_BUG();
-	return 0;
+	return false;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 #endif
-- 
2.47.3


