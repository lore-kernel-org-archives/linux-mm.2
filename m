Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C013B1093170
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 06:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F906B0088; Sat, 21 Mar 2026 02:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F91A6B0089; Sat, 21 Mar 2026 02:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F796B008A; Sat, 21 Mar 2026 02:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12CC86B0088
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:43:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99F9C1604F7
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:16 +0000 (UTC)
X-FDA: 84569128392.10.9156B10
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3C99180009
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aEF7TA7g;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774075394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EB0hZwtUcZswaQsGgDirN1WuGzTF+UsTmqEkmKQ0NBQ=;
	b=rbhtkRSB+IHXwx7q2HmXdgHKBUyTQLZBP4L0tBsx7B3mt4AmSr77yi+GZHb9gdMUyTDoBE
	UHycDNqTZ5cjpq+Ko5cOsjKluPBjVgGINSMr+E+bQAEtxyoKZFtVeek6/8pocj9avthgtC
	RD1dvCVVVEA3mpP2chOSMyCkersCivs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774075394; a=rsa-sha256;
	cv=none;
	b=5Rmp/0HLkCTG/13xLPofNxAYyuvUvATzhMke0ntBPj+pskAb/qJr/m58F7wdcpsPO0/xDB
	L68c4RekHT7VnXLKA+etOeQRbTBClEX85vUfeYimAP1wDoa/NGovtrPRcctYPHiT8hlykC
	cZJ3MJYlLa70OuSwQFeHwgvWJLX1gYw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aEF7TA7g;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774075389; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=EB0hZwtUcZswaQsGgDirN1WuGzTF+UsTmqEkmKQ0NBQ=;
	b=aEF7TA7gJxgUvHlppxiJTO7NxX4XJ+D5gexKEllA4k7fKaYeSSsJUewl8bh6mQtyyWga415ESA7lpy33BB1i7vbuUGg0ZUDFp/8R9MftG4O9yxmcFtGRhOUR7nbT7PGitU9fx5Fhddv7Q6TSOZFKBRqSuFE9ipfEyk4ASZlo59Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.O5tHl_1774075386;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O5tHl_1774075386 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 14:43:07 +0800
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
Subject: [PATCH v2 1/6] mm: change to return bool for ptep_test_and_clear_young()
Date: Sat, 21 Mar 2026 14:42:49 +0800
Message-ID: <57e70efa9703d43959aa645246ea3cbdba14fa17.1774075004.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
References: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d6tszbwwxdmcr6c6fczwttm3xmhp7afd
X-Rspamd-Queue-Id: C3C99180009
X-Rspamd-Server: rspam03
X-HE-Tag: 1774075393-204240
X-HE-Meta: U2FsdGVkX18WjF4RZRmg3R2JFsL2TD6Gfrp2eUtc8EngIYu3+TDHk6B9CdRbzReGn29H/HkBge0LAhcBKszloMpf1odXVOo9Qv36z3wgSoBdR8MZZyeYXbxS+L9HMV+TTYWqHYAOpxH9uZlxUSDszqQHZxxGZyy0Ehy0jmaR5iWZll/TMswy+c8PN2EBGuYXGlZF3VCwPb+ba2472K8uFp10LPpX1LSSkvbl9gyCpGll4lENJzPnPCoNIDKwi08+qcITYeM5zkmdTzvSzbp7ZuBosj9B55scf+E1LZfd1sTSA6CRsFi3bK62h2P1+0f6g8rob4lZxC1ieGtNFAFZCqQ0icDiLK02NnjM4qsZ8rbRqMRZpNSxmm84DCT0z1zXiHX5XzMQdWcA3lSFOYDqkrREnK0ycpy0eevxkBhi7LcLoLq8chggXKWrEAG5+AX6VD1nJpurYx4d0pHS361SAw6n930/o/vqytDAcFlMLkn3nS/LQi9+ii0Ew8lYKe8HMaKc/rZCQb6NbBauePaJ6Q215k1wju85JAKANauP0mvvR4QPV7E8JlTcWAJSTu2bzO3m5uTcBsZ/HQx1NPugs3bZYjE4JCANT7vyWlpFwFr9W2TSMQRuXGrqDamEQ9yUXoLnyTSia3/7U9W6JIEIaeo2l4g+CkOV/ytFRt35lHuodCL3MVP5L95uRK9jmJnI/ykJGxfRp8dUJg1yobtPxkCWdQm8OMKW0LkqPEQH7SN+nWfSehXOsEGM+hP44gnpz2ky/SYA/RGuCIYQk5HhD6jayyDDqeBJuKubKxATHF+Ls9diClX8LyZGO7W2wIdBc7fIGCHx5NLhiaGBHHtBp8U5fv5uDZx9hdC7etY19evyRi9bLaeEOGfqfdDzsN/vNVe0aEGAHympVHtr7FpYUP+NAIVa7pVS61/OMAD8DNT83S77SCrt0AIZUXZZvRUjrM8+Fi/yDDQKGWHbPV5
 fyBFbqnP
 1Z3qf9G2x94B0TaXxx7cLDgBEi4ZMuk7OBTkTsBiNra0d4V0l1nV0uD65ccZRgSJ98NK4z4rYx7c7lycerA9io6ZmVFWcjFzcVgwZvlkleGQA1g2i8OZ9R5tG1lSc6mLrPlZgOhYj/kwan349dZ20xlBG7omTe4cRIeIX9dUYxpFLrMCECK2x6xaaIyU25cPbk/7VoqbyO+qBWzAAwn3SrfkktORw9jSKDK2bBK00qxoIXRFNiE0X/CnLp1J5Q14zi/Rcn99uuDI4P4sQISvg93UyV/5Bt8rPjL5+8MYDQLmEWLhjuNb+kXa6p6dHDLne3B/m6WQ3IJWd10I3tShrtPlTa6NYl2GbmF2vOzfdSjc9X8OFgVp7mvqolJbKo6U3Rptw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers use ptep_test_and_clear_young() to clear the young flag and check
whether it was set. Change the return type to bool to make the intention
clearer.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h             | 16 +++++++---------
 arch/arm64/mm/contpte.c                      |  7 +++----
 arch/microblaze/include/asm/pgtable.h        |  2 +-
 arch/parisc/include/asm/pgtable.h            |  7 ++++---
 arch/powerpc/include/asm/book3s/32/pgtable.h |  4 ++--
 arch/powerpc/include/asm/book3s/64/pgtable.h |  6 +++---
 arch/powerpc/include/asm/nohash/pgtable.h    |  4 ++--
 arch/riscv/include/asm/pgtable.h             |  4 ++--
 arch/riscv/mm/pgtable.c                      |  7 +++----
 arch/s390/include/asm/pgtable.h              |  4 ++--
 arch/x86/include/asm/pgtable.h               |  4 ++--
 arch/x86/mm/pgtable.c                        |  6 +++---
 arch/xtensa/include/asm/pgtable.h            |  9 ++++-----
 include/linux/pgtable.h                      | 16 ++++++++--------
 14 files changed, 46 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ab451d20e4c5..79596cc05dcb 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1282,9 +1282,8 @@ static inline void __pte_clear(struct mm_struct *mm,
 	__set_pte(ptep, __pte(0));
 }
 
-static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
-					      unsigned long address,
-					      pte_t *ptep)
+static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
 	pte_t old_pte, pte;
 
@@ -1646,7 +1645,7 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep,
 				unsigned int nr, int full);
-int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep, unsigned int nr);
 int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep, unsigned int nr);
@@ -1813,9 +1812,8 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 }
 
 #define test_and_clear_young_ptes test_and_clear_young_ptes
-static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep,
-					    unsigned int nr)
+static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
 		return __ptep_test_and_clear_young(vma, addr, ptep);
@@ -1824,8 +1822,8 @@ static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
 }
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	return test_and_clear_young_ptes(vma, addr, ptep, 1);
 }
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 1519d090d5ea..a31cae78f712 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -508,9 +508,8 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 }
 EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
 
-int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep,
-					unsigned int nr)
+bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	/*
 	 * ptep_clear_flush_young() technically requires us to clear the access
@@ -525,7 +524,7 @@ int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
 	 */
 
 	unsigned long end = addr + nr * PAGE_SIZE;
-	int young = 0;
+	bool young = false;
 
 	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
 	for (; addr != end; ptep++, addr += PAGE_SIZE)
diff --git a/arch/microblaze/include/asm/pgtable.h b/arch/microblaze/include/asm/pgtable.h
index ea72291de553..7678c040a2fd 100644
--- a/arch/microblaze/include/asm/pgtable.h
+++ b/arch/microblaze/include/asm/pgtable.h
@@ -318,7 +318,7 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 struct vm_area_struct;
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pte_t *ptep)
 {
 	return (pte_update(ptep, _PAGE_ACCESSED, 0) & _PAGE_ACCESSED) != 0;
diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index f6fb99cb94d9..7097c785f690 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -438,16 +438,17 @@ static inline pte_t ptep_get(pte_t *ptep)
 }
 #define ptep_get ptep_get
 
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	pte_t pte;
 
 	pte = ptep_get(ptep);
 	if (!pte_young(pte)) {
-		return 0;
+		return false;
 	}
 	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
-	return 1;
+	return true;
 }
 
 int ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index 001e28f9eabc..4a271318dee8 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -295,8 +295,8 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
  * for our hash-based implementation, we fix that up here.
  */
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pte_t *ptep)
+static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
+		unsigned long addr, pte_t *ptep)
 {
 	unsigned long old;
 	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 1a91762b455d..c049a2e26e25 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -349,13 +349,13 @@ static inline unsigned long pte_update(struct mm_struct *mm, unsigned long addr,
  * For radix: H_PAGE_HASHPTE should be zero. Hence we can use the same
  * function for both hash and radix.
  */
-static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pte_t *ptep)
+static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
+		unsigned long addr, pte_t *ptep)
 {
 	unsigned long old;
 
 	if ((pte_raw(*ptep) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
-		return 0;
+		return false;
 	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
 	return (old & _PAGE_ACCESSED) != 0;
 }
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index e6da5eaccff6..3a6f20a1c800 100644
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -101,8 +101,8 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
 }
 #endif
 
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	unsigned long old;
 
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index ab4ce1cc9d9c..643d12481b02 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -659,8 +659,8 @@ static inline void pte_clear(struct mm_struct *mm,
 extern int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 				 pte_t *ptep, pte_t entry, int dirty);
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG	/* defined in mm/pgtable.c */
-extern int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long address,
-				     pte_t *ptep);
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index b1ed2f14dc3a..9c4427d0b187 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -29,12 +29,11 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 	return true;
 }
 
-int ptep_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address,
-			      pte_t *ptep)
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
 	if (!pte_young(ptep_get(ptep)))
-		return 0;
+		return false;
 	return test_and_clear_bit(_PAGE_ACCESSED_OFFSET, &pte_val(*ptep));
 }
 EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 1c3c3be93be9..ef4748ee3a2b 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1164,8 +1164,8 @@ pte_t ptep_xchg_direct(struct mm_struct *, unsigned long, pte_t *, pte_t);
 pte_t ptep_xchg_lazy(struct mm_struct *, unsigned long, pte_t *, pte_t);
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 54289f4587a4..1d86fb33239f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1232,8 +1232,8 @@ extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 pte_t entry, int dirty);
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pte_t *ptep);
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 extern int ptep_clear_flush_young(struct vm_area_struct *vma,
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 2e5ecfdce73c..5ee38dda9124 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -443,10 +443,10 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 }
 #endif
 
-int ptep_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pte_t *ptep)
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pte_young(*ptep))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
index 61f07d981a94..f00a879dc298 100644
--- a/arch/xtensa/include/asm/pgtable.h
+++ b/arch/xtensa/include/asm/pgtable.h
@@ -304,15 +304,14 @@ set_pmd(pmd_t *pmdp, pmd_t pmdval)
 
 struct vm_area_struct;
 
-static inline int
-ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr,
-			  pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
 	if (!pte_young(pte))
-		return 0;
+		return false;
 	update_pte(ptep, pte_mkold(pte));
-	return 1;
+	return true;
 }
 
 static inline pte_t
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 17d961c612fc..8e75dc9f7932 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -491,17 +491,17 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
 	pte_t pte = ptep_get(ptep);
-	int r = 1;
+	bool young = true;
+
 	if (!pte_young(pte))
-		r = 0;
+		young = false;
 	else
 		set_pte_at(vma->vm_mm, address, ptep, pte_mkold(pte));
-	return r;
+	return young;
 }
 #endif
 
@@ -1123,10 +1123,10 @@ static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
  *
  * Returns: whether any PTE was young.
  */
-static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
+static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
-	int young = 0;
+	bool young = false;
 
 	for (;;) {
 		young |= ptep_test_and_clear_young(vma, addr, ptep);
-- 
2.47.3


