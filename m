Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C5F71099B54
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 06:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25DDB6B0092; Sat, 21 Mar 2026 02:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20EDB6B0093; Sat, 21 Mar 2026 02:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C3C6B0095; Sat, 21 Mar 2026 02:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 04C006B0092
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:43:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B00CC1404BD
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:20 +0000 (UTC)
X-FDA: 84569128560.12.53F1DFF
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4DA81A0002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pg7mtxHm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774075399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geANMdd5vMUOFn3a4OVwvlZ4St3DjzF/8lMKgupwtPE=;
	b=D7lPOUzQPi0cDW2G4ixyXqPMYZH28KpuGjf91Iv3BhTi/KGNOL+j+mz6cPcOyXtYPSXoF2
	HIa4aIO782y6eQhItopjiuJAAUY0HwtZ+YF0Se/r5UgI4iq29kBBnUQWA+5wf9bDXcuykd
	nXV24v8h/C6DlQc/sMgvdJIonAeZ0wg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pg7mtxHm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774075399; a=rsa-sha256;
	cv=none;
	b=AESEVFoiJ3AilIZ5Iu3xAD7ScNv6kM1ATkO2usK9Vb/mT9osLFyXQ+aUxbMN5oEDUCHUMC
	Vfzbkimr2vUC0Ibka07ubjNRrDO2Nwwvehf+znFW5EvSIdeGAqBoElInLFb2h97eO4xo5E
	fMdAAyiBCpRHNcH3Z/PTJ1pR2ioaz34=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774075394; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=geANMdd5vMUOFn3a4OVwvlZ4St3DjzF/8lMKgupwtPE=;
	b=pg7mtxHmNo9TlEnmWtuxA6WMOdcw+GwfwTUDLE/zRBhcXG+CPBalWGHDRGgTbND1mJNOyKpm5xaYafImjw9/0ThTToPU6NHUJP6dlm2ckE19L1rU9fUq0zJPOWmsyrZv/PBXmc31csWwBwk7vy6bhBZc1Ja2IqeUZUi16658L7Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.O5tJb_1774075393;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O5tJb_1774075393 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 14:43:13 +0800
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
Subject: [PATCH v2 5/6] mm: change to return bool for pudp_test_and_clear_young()
Date: Sat, 21 Mar 2026 14:42:53 +0800
Message-ID: <2c56fe52c1bf9404145274d7e91d4a65060f6c7c.1774075004.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
References: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4DA81A0002
X-Stat-Signature: 5k5nb8qiqzc1usqyhgrcgp7faadnzwet
X-Rspam-User: 
X-HE-Tag: 1774075397-39704
X-HE-Meta: U2FsdGVkX1/R0Xsz1ZXxOWQIDPeAQ/hHWRUVzLM93J6eVZcvuzhxP4ri6lUZ+MNbcw6c1P+H5TyJuVUDerzciqonXnvAxqGBWuIkLK9faAkEc8nQfOMOlmcWfWJJa4MAbCSWhw0qNrmXhSop2r0FzUqRF5+tetj1MDFOQ8L4zlJBVVNinYXl4nF3RCF2iVL6zvI+wNBpX6Y6gNg82a5HfSNq9SZxyHjgLrIjHkNvrcIbi+zTJ8cJtPZMib6vkIapuzYc4j9Wwny/hZUs9ZEHee7EbkRucJxtX8zaMGp5stYPUcrEyptMX6jlefcCejEOGKtpEleJLoE0yz6qwxsDuAfzuVcDN5KiGsVPa7sFW4kqM1Js8fU61b81CL7clGrGOKEeYKIpjT7kp0YeLiADKPSxii3Dul2icptZontzTe0rocCu4SbJuH7LrlJKDlAizPtDIy9GDsdEK/BQdOsqkou2QjoDNtjWteAZkiBIxeH3yzSg8ZSmTvPQgkGJbqwDrnzOkOoQA2kPrgnG9UhowbbIloQ5x7/SYM9arX5PPTrLKdRgWrATtn6l/uIvBNWwoQydLJpPko5yq5sOu295emsQ6iEJ4vN+P6mKSHkUqCJOTrtI2LaFzS4Wc6Kwgr+EC53ll0i4ccXfTtYVn7DflIIUJiLefOMKQvkG6yOx4ikLkoz+ee7K+pfHnw12o4E8LyRPeYa1ObjJPU8VGQoxTcqBIAdTCUmKtit3abAPHE0m9Yo5Wm3SfWVEYeUgpJKgs1tJ+UANsLHSp8ccFBn20+QcxZZIcoSGYLJZOL0LUQylLai35CDCHHYm+U2AsqnysVYkJiFGKQa9zUnDlSbfwq0jrcUeaTEafBOoMYtG6nJMZM3AmTNiJai2cnxScAtEMwZ+08uOd5cbjqvZ1dbMML/coUW1oiWH5ujEeeyFjfx8JRN5a77lAr3z2DxExTV9vHPcrcYln8Ve8JPTBeF
 4uEzhPlB
 cv9l5bmUInlYtB9IesU9x8rpea9q7EcJBp1acODg2dC8cp0oEeksrRNCOm+rE78+bkfSHaGvvsbzN4nHVxOkPhbmO5H7qhZzX5t10RW7jQH+oJSgkxD8JHE8NI/MdLkCU9uyURTBEseluQkJ67W2LQ6Y86BCAYMMbOQvfg+ag2WuGAYUXsQjl7mror7YAheqkMhjynwSnHLtFf3LZHOdajVPuxrJ3eKE9Rvt8y2P2rjGhdS2bDAKDsLBpi2UfNCQEV0hshgj6Op6j0I/k8VxWi8geTuu5h/X4TctX3IkNDb+tPHqIpEsdbEOkBywdjsAXPqeLFBhr9bQ4SdLdJga7TCUvKkMHY7DGNQ7kcZEOS5LMxkAmNkgSz/ESeUY+OAi3ezsn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pudp_test_and_clear_young() is used to clear the young flag,
returning whether the young flag was set for this PUD entry. Change
the return type to bool to make the intention clearer.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
 arch/powerpc/mm/book3s64/pgtable.c           |  4 ++--
 arch/riscv/include/asm/pgtable.h             |  4 ++--
 arch/x86/include/asm/pgtable.h               |  4 ++--
 arch/x86/mm/pgtable.c                        |  6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 8b354e81ab22..60e283cf22be 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1172,13 +1172,13 @@ static inline bool __pmdp_test_and_clear_young(struct mm_struct *mm,
 	return ((old & _PAGE_ACCESSED) != 0);
 }
 
-static inline int __pudp_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pud_t *pudp)
+static inline bool __pudp_test_and_clear_young(struct mm_struct *mm,
+		unsigned long addr, pud_t *pudp)
 {
 	unsigned long old;
 
 	if ((pud_raw(*pudp) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
-		return 0;
+		return false;
 	old = pud_hugepage_update(mm, addr, pudp, _PAGE_ACCESSED, 0);
 	return ((old & _PAGE_ACCESSED) != 0);
 }
@@ -1303,8 +1303,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
 bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp);
 #define __HAVE_ARCH_PUDP_TEST_AND_CLEAR_YOUNG
-extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long address, pud_t *pudp);
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp);
 
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index c584321e3d41..ddc766e95855 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -104,8 +104,8 @@ bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 	return __pmdp_test_and_clear_young(vma->vm_mm, address, pmdp);
 }
 
-int pudp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address, pud_t *pudp)
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp)
 {
 	return __pudp_test_and_clear_young(vma->vm_mm, address, pudp);
 }
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 67e7746e3fbe..a6e0eaba2653 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1109,8 +1109,8 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 	return ptep_set_access_flags(vma, address, (pte_t *)pudp, pud_pte(entry), dirty);
 }
 
-static inline int pudp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address, pud_t *pudp)
+static inline bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp)
 {
 	return ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 6c8f2b17d3f9..13e3e9a054cb 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1297,8 +1297,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp);
-extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pud_t *pudp);
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp);
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 bool pmdp_clear_flush_young(struct vm_area_struct *vma,
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index fc1c996c5b2d..da7f0a03cf90 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -470,10 +470,10 @@ bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-int pudp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pud_t *pudp)
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pud_young(*pudp))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
-- 
2.47.3


