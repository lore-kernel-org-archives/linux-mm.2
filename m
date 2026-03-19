Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9491088E70
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E57E6B03C0; Wed, 18 Mar 2026 23:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE6E6B03C2; Wed, 18 Mar 2026 23:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9FF6B03C3; Wed, 18 Mar 2026 23:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E20D6B03C0
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:24:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EB741C31B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:26 +0000 (UTC)
X-FDA: 84561369732.21.BB2602B
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf25.hostedemail.com (Postfix) with ESMTP id AC04AA000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=noBdGfc4;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZvFasi/0Yj+erdMhL0ZepZHbRAvJJtjAuaFua/OpdM=;
	b=4l0CeuZENtuikfAC2+9Tja2YiAUYHTOmzbUyPpG2iEaSeTlxKrugCH+ytVuWHFXaqb6Tzl
	6V2kSSuF36aXcjXZLJfqsbLUL/fMfHcM/wD7siTr9deyraeS0BBkWqcJsgV5bIZzVkAbp8
	ycS1xCFCkHm0DOO/YxJ7b1evngfTkPs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=noBdGfc4;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890664; a=rsa-sha256;
	cv=none;
	b=rddH3m02EiTzzuecfWhCBFHKGAqqFjzxzX9eQEc67On1jAJN1rEhfmnWtHRbhHtDHDhOqP
	Pfkuv2EdPKmxgIRQnXxGA+uCfefliP/Sp6gDCJgfHsh7diKj0/WyTdNFbPSEe7oF6ySvpx
	Sm9vT0ADcB12zBJ/9fKy1uWG2ffdv5k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773890660; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=9ZvFasi/0Yj+erdMhL0ZepZHbRAvJJtjAuaFua/OpdM=;
	b=noBdGfc446aQrWhX3y8LbsoHFo4xk12GZnwtkJAESGTmb/aW6tWhJlB3Zj8cGrUM27jLf5oQujiv3O/fgbhhAgcnO7Q/RWTr94tyYu5SLb9jkD/BQQKJ03DT7mo1P4rDEx49aE2WPnCmPEQO5PAMvBowM8G0z8l67lFx1nkHw5o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.GtLOR_1773890657;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.GtLOR_1773890657 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 11:24:18 +0800
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
Subject: [PATCH 1/6] mm: change to return bool for ptep_test_and_clear_young()
Date: Thu, 19 Mar 2026 11:24:00 +0800
Message-ID: <3fa94c3c89fd93fe22c8cb59967f064787d686aa.1773890510.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC04AA000E
X-Stat-Signature: 7k3x9hsgoqqqjisrniwcetw6cmycpuxp
X-Rspam-User: 
X-HE-Tag: 1773890663-595385
X-HE-Meta: U2FsdGVkX1/EcSbj+4CAdnkwLCqKdKuIhKPXvo3KybLXvNbH+SAOom76yVccmUmWSquJ+Hfyqz3c5lEdx1SJULGCH6PaoidJNZnwo2+DNU0D7mGzA7psqT/TpFVTUaO9Ev1RGHnyLbPY5pfUkkTkZKD/7EwiVPTW/BO9282tEagRO2raLTzFKQPCht0wp5OVp2WqVyNH26Wq53ClOscgSNVhLG1SMjup/oSVVhF411k+PsRHxk2M9jTVVUrtw98JQpXMBTsep0OVYs0R6GJOC2x1r08r21rKPr7a6pchFRxyu5m4ilAv4uJFRkw0uaZrbsmNzJ7DIlv3Iwq4T3BORuxLoQQj0bdFToV5zH2Ll86PFWniK9541w4heWzvZgeqZt2OfVSoBRfnHF71/3WY/7QNrFN6E83WNcuGVKVlsGv0BImgIsPHeQKZHLqwkoVkzICJYTbEjV0NDizZDfqBwFp8XCMY1rvumvrk2NsgS+DFLJp8QvW/65OJ/ICYM/EuUE6yEPTnle7kAZLszhxvWVjA++2a/OWkOghk6vhAzYwNjehb+sMFsaFEWeGIq4geWT8ThZBoGyZzHapLO+kbL3yHCFUiPHVP79CfFyqdXJDWxMHKlUi13ymM6BV+qUwtA3J/SAEBcPbX2MHTYO3dpZzL1rGheVVBpisRbSedvCtGFgaCV1TmYYYwKKsDiy3TbBYI+pYOus8G66BCAr9UYKhcFxh3qsyflpTmt3psAI5/E2dxJjXK3Hn3x3+6y0qLkCNpboJ8PfRqAfTfdcOyLAOs3qFNsoFbTqzuc3cQAZNel2QmUo6U9J2RzczMw1NTPkrkoscUHMVP6kU/YHoD7CvELXcCUNy9+TIb1DlKxn4Jcxb+EYU5lOQsYPcONP7jkcf23wEl/mZuUmndRO6B9ugAoXeVbLXCIJENPLq8uc+zoTkoplU6A+y47/29SGs6lZpdnha0xkafSmfHCuw
 /abo9c0m
 gOFErGhTT1yJvVtlnnCEjgq/vM8r0XjMMqJU/MDIJF/JdCm6DV9J9JGJYtU6ZrPrNGDumOVRxBpu82Me1qoH12UPc9GnM1l0M3Rh6sw1kkQWSCEfe6xyNeuqks0xPJRoCdRAd3bI+2L9kYpyNo/BPgpYh0qZqkplIQkAjmTtsPjeEL5dhI05BGYx2SXvffb9ZbGNx8iWKWqbZNA4j77MvB1OyJXdVzUsAxVR/gjN9NU18wk+RCnTByx19rRwVNARJpkx3AdXQ2Vi0kJg3LGAB8tdoBpBrmtO2lWB3ZkrXS6daXlFoQRcqQY4e39OWGBwSjiMcpNEmqF/E02J9vV8tqV7qig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers use ptep_test_and_clear_young() to clear the young flag and check
whether it was set. Change the return type to bool to make the intention
clearer.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h             |  8 ++++----
 arch/arm64/mm/contpte.c                      |  4 ++--
 arch/microblaze/include/asm/pgtable.h        |  2 +-
 arch/parisc/include/asm/pgtable.h            |  6 +++---
 arch/powerpc/include/asm/book3s/32/pgtable.h |  4 ++--
 arch/powerpc/include/asm/book3s/64/pgtable.h |  6 +++---
 arch/powerpc/include/asm/nohash/pgtable.h    |  4 ++--
 arch/riscv/include/asm/pgtable.h             |  4 ++--
 arch/riscv/mm/pgtable.c                      |  8 ++++----
 arch/s390/include/asm/pgtable.h              |  4 ++--
 arch/x86/include/asm/pgtable.h               |  4 ++--
 arch/x86/mm/pgtable.c                        |  6 +++---
 arch/xtensa/include/asm/pgtable.h            |  6 +++---
 include/linux/pgtable.h                      | 16 ++++++++--------
 14 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ab451d20e4c5..8c651695204c 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1282,7 +1282,7 @@ static inline void __pte_clear(struct mm_struct *mm,
 	__set_pte(ptep, __pte(0));
 }
 
-static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
+static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 					      unsigned long address,
 					      pte_t *ptep)
 {
@@ -1646,7 +1646,7 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep,
 				unsigned int nr, int full);
-int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep, unsigned int nr);
 int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep, unsigned int nr);
@@ -1813,7 +1813,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 }
 
 #define test_and_clear_young_ptes test_and_clear_young_ptes
-static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
+static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
 					    unsigned long addr, pte_t *ptep,
 					    unsigned int nr)
 {
@@ -1824,7 +1824,7 @@ static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
 }
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep)
 {
 	return test_and_clear_young_ptes(vma, addr, ptep, 1);
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 1519d090d5ea..0b88278927a4 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -508,7 +508,7 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 }
 EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
 
-int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep,
 					unsigned int nr)
 {
@@ -525,7 +525,7 @@ int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
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
index f6fb99cb94d9..d5e39f2eb415 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -438,16 +438,16 @@ static inline pte_t ptep_get(pte_t *ptep)
 }
 #define ptep_get ptep_get
 
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
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
index 001e28f9eabc..2a889e2093e8 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -295,8 +295,8 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
  * for our hash-based implementation, we fix that up here.
  */
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pte_t *ptep)
+static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
+					       unsigned long addr, pte_t *ptep)
 {
 	unsigned long old;
 	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 1a91762b455d..25e3a86943e2 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -349,13 +349,13 @@ static inline unsigned long pte_update(struct mm_struct *mm, unsigned long addr,
  * For radix: H_PAGE_HASHPTE should be zero. Hence we can use the same
  * function for both hash and radix.
  */
-static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pte_t *ptep)
+static inline bool __ptep_test_and_clear_young(struct mm_struct *mm,
+					       unsigned long addr, pte_t *ptep)
 {
 	unsigned long old;
 
 	if ((pte_raw(*ptep) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
-		return 0;
+		return false;
 	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
 	return (old & _PAGE_ACCESSED) != 0;
 }
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index e6da5eaccff6..43cf52f0c7d6 100644
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -101,8 +101,8 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
 }
 #endif
 
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+					     unsigned long addr, pte_t *ptep)
 {
 	unsigned long old;
 
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index ab4ce1cc9d9c..fb010dcdf343 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -659,8 +659,8 @@ static inline void pte_clear(struct mm_struct *mm,
 extern int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 				 pte_t *ptep, pte_t entry, int dirty);
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG	/* defined in mm/pgtable.c */
-extern int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long address,
-				     pte_t *ptep);
+extern bool ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long address,
+				      pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index b1ed2f14dc3a..de24a19e8ebd 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -29,12 +29,12 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 	return true;
 }
 
-int ptep_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address,
-			      pte_t *ptep)
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+			       unsigned long address,
+			       pte_t *ptep)
 {
 	if (!pte_young(ptep_get(ptep)))
-		return 0;
+		return false;
 	return test_and_clear_bit(_PAGE_ACCESSED_OFFSET, &pte_val(*ptep));
 }
 EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 1c3c3be93be9..da1a7a31fa22 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1164,8 +1164,8 @@ pte_t ptep_xchg_direct(struct mm_struct *, unsigned long, pte_t *, pte_t);
 pte_t ptep_xchg_lazy(struct mm_struct *, unsigned long, pte_t *, pte_t);
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
+static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+					     unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 54289f4587a4..563a6289ea44 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1232,8 +1232,8 @@ extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 pte_t entry, int dirty);
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pte_t *ptep);
+extern bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+				      unsigned long addr, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 extern int ptep_clear_flush_young(struct vm_area_struct *vma,
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 2e5ecfdce73c..c594976afc5c 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -443,10 +443,10 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 }
 #endif
 
-int ptep_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pte_t *ptep)
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+			       unsigned long addr, pte_t *ptep)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pte_young(*ptep))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
index 61f07d981a94..b962ef4652f5 100644
--- a/arch/xtensa/include/asm/pgtable.h
+++ b/arch/xtensa/include/asm/pgtable.h
@@ -304,15 +304,15 @@ set_pmd(pmd_t *pmdp, pmd_t pmdval)
 
 struct vm_area_struct;
 
-static inline int
+static inline bool
 ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr,
 			  pte_t *ptep)
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


