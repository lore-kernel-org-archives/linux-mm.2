Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CCF1088E73
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6263C6B03C9; Wed, 18 Mar 2026 23:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401636B03C8; Wed, 18 Mar 2026 23:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253B16B03C9; Wed, 18 Mar 2026 23:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03CCD6B03C6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:24:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0E09140347
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:30 +0000 (UTC)
X-FDA: 84561369900.29.D05AEAB
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7A0D210000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="RReSa4/D";
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZ0qad0Pm6XxHYmd2R3Uz8rTNICSFBFKR16MZOCoaNo=;
	b=5h33OqbSWFvQv0MORcOJg06IQrpQRQGwQ3fdjz/xikgcWRO/cXYbuG6Vg5FnzmfEucN9GI
	ziV+Fx3mMsYhdiFzB/PaGSPVe/VHRU1yKJmvSDSvghkp8ODBUXnw8WMrODkxaMj1xsbika
	6pdv+tGF+Cl+mggPfYMCNmPbKfY9pVo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="RReSa4/D";
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890668; a=rsa-sha256;
	cv=none;
	b=LVSM4Oi3/PqzHKJoGCLqRPOQP/GsldvRKIxQAHXLHKW9cGkEaLJaI6eFSDyIgTuKMmYf52
	S85BmnGKHmHYafdMfEMpi8ucisJnaHvYXxffYc1ZLC9+AL4MbvhAsx456LEeWoTklidUts
	uoKcaIVsZD6q3xGB5gZpIzsBOgHlBhs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773890663; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=wZ0qad0Pm6XxHYmd2R3Uz8rTNICSFBFKR16MZOCoaNo=;
	b=RReSa4/D4qAiZLUALt4pgzPc1AW+fu/yDbF6zaeoD5dxv8YfbWgLj76TLNnIFgRIXXMM1hohNRMQjh5J+KRIlntl3pRHnNvcHSgoqdI72yn+At3wRnrw/ApxnFO+5q66kf0DXEvI748nAg5C4gkT0Ro8twSQBTA//CElk7ACFao=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.Gt-CL_1773890660;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.Gt-CL_1773890660 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 11:24:21 +0800
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
Subject: [PATCH 3/6] mm: change to return bool for pmdp_test_and_clear_young()
Date: Thu, 19 Mar 2026 11:24:02 +0800
Message-ID: <8025b898d0841a4bcbd766998959b4e2ae4d4abc.1773890510.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A0D210000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 5auwe8b13w7c1ocz4m9i74qdyb3ygzg5
X-Rspam-User: 
X-HE-Tag: 1773890668-946478
X-HE-Meta: U2FsdGVkX1+b+zfuZ2SLRCcUSZ9kz3vEu5YYarXHbbGsaVtpNPfHecYRrQ8oFq/aQEAf2aFynRjgy/RrRf/UcSpBIdnPDicR5JX5XJC37MG8R2A7S9BHWk7etu8HAmuE6b98SnmPSjwLym3fcHfHN1yWtZuWEphd6Ybkn4LEW6lMCn5E4N02L06pQZ6UuuPilWyNIRRu7ChhdgENqnZS/ren9f6ujLLR74tQ4qgwmLUyXImAW0duMiZPwaUZ28eJK5R9pg+zcoh45EVI5Gq01Xmz4DxQoTqD6DfCG9W2c16LStlqFkjxZ2mTuC6q6Yv0nAHz5iAk8NMUqwhdGgQDzyj5zxATgr3wmYTaCCGMpgh+/lsxq2IqhdvUiBuI4BSNYSLJb/1KRkNipMEGO+HeJhAehKJiAtkQSGjKpGW7+JUixnB6/Usm8q7duC57ltLGSx5cIoszA/YmHLubHCe/uDWC+h8G27nsy3Ckker+yUJmBb65wveRWDisXoEx6pkyKt3orfNWD32YOFuDa2fiC7aRu2BZWpBgFUCXLGxb2vrVKbz5BD2Pb9LPm2XPqcxJTVAKRd8KOsi/sYKivsARm4jPA0TGaksqHwKhp+FFabo7qhFhq1a9Ulyh7zfMTTxF0HY++RT9hHHkO2BWzAOVggqFS5u6/gYq3QboMhxKMNlZ2UXsbQHsZSu45icm0JHwhpN/2UwdAfyJxmmgpP9XUjBp/yLu8dsBPygG3UjyLlQLiuNLvotWw5TiM2V5rRizM52CFx956cEjuUNshO2UUzIbWtf/j4itDQfpPe42fBvxE1OkxI2sieWtznFon62CslefJoqFvAvS6BE+/cS3DtmGRRl+yP1r1aG1J0WRGQtPfpZS7m3cTDdBrbrj8w3BFMRh/PLa6ODTBVr3aMO24aPgGW78PDUc2nU1JaBnYywZsWEoT+QqjjNXdzRLmsGg+nXCUmJmtvGqJkP/fIw
 u0Pk3jr3
 +EkBjvmYkL24klV5r13ZsPR/EzVIw3mmBNcWymD1ph7suQ0r0HeU33SKLAB3U3ZAqtUVMWU1UDu/QSMV3gLvM85MsvZliy5MQc+1ybU3ga21z1GuvO91Hwy0eHec7jn3OtGK0capm85m9qRyD3QOM+0ja6amcOikrXsPmXyNZzfjGrKptucyqdE5FqLyfuI6xRwTpRhdbA0tt+XcrqaiaheWEHVn4ZNnD+74W5pTZIsGkGOwKymHX+/gDQn7ly4r1YtHqJb5p2pNAmh3/KgcmNQr+K7dOvjhyrMbJTYl15dlN0WHrZoNoe6j56x6ZInt+Em3ks7PRskgm04HWffkPdG0NAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers use pmdp_test_and_clear_young() to clear the young flag and check
whether it was set for this PMD entry. Change the return type to bool to
make the intention clearer.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h             |  6 +++---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
 arch/powerpc/mm/book3s64/pgtable.c           |  4 ++--
 arch/riscv/include/asm/pgtable.h             |  2 +-
 arch/s390/include/asm/pgtable.h              |  4 ++--
 arch/x86/include/asm/pgtable.h               |  4 ++--
 arch/x86/mm/pgtable.c                        |  6 +++---
 include/linux/pgtable.h                      | 19 +++++++++----------
 8 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 393a9d1873f6..7ea16f6ad564 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1321,9 +1321,9 @@ static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+					     unsigned long address,
+					     pmd_t *pmdp)
 {
 	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
 	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 25e3a86943e2..0f34011665a6 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1161,13 +1161,13 @@ pud_hugepage_update(struct mm_struct *mm, unsigned long addr, pud_t *pudp,
  * For radix we should always find H_PAGE_HASHPTE zero. Hence
  * the below will work for radix too
  */
-static inline int __pmdp_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pmd_t *pmdp)
+static inline bool __pmdp_test_and_clear_young(struct mm_struct *mm,
+					       unsigned long addr, pmd_t *pmdp)
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
+extern bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+				      unsigned long address, pmd_t *pmdp);
 #define __HAVE_ARCH_PUDP_TEST_AND_CLEAR_YOUNG
 extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long address, pud_t *pudp);
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 4b09c04654a8..aed39bba891e 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -98,8 +98,8 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 }
 
 
-int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address, pmd_t *pmdp)
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+			       unsigned long address, pmd_t *pmdp)
 {
 	return __pmdp_test_and_clear_young(vma->vm_mm, address, pmdp);
 }
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 11f57ccf6dc9..bac559d29036 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1015,7 +1015,7 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 }
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 					unsigned long address, pmd_t *pmdp)
 {
 	return ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index c9ab81caaf75..1f5efb7be71d 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1683,8 +1683,8 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 }
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pmd_t *pmdp)
+static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+					     unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 554dea93eb99..bd02ee730a23 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1295,8 +1295,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
 				 pud_t entry, int dirty);
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pmd_t *pmdp);
+extern bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+				      unsigned long addr, pmd_t *pmdp);
 extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long addr, pud_t *pudp);
 
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 0007dc3d739e..10a5e0b2be36 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -456,10 +456,10 @@ bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG)
-int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pmd_t *pmdp)
+bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
+			       unsigned long addr, pmd_t *pmdp)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pmd_young(*pmdp))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 1198e216fde3..e53220b0a9a3 100644
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


