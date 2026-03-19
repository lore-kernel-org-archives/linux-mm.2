Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 688F9FB5EAA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9B06B03C6; Wed, 18 Mar 2026 23:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934FB6B03C8; Wed, 18 Mar 2026 23:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785896B03CC; Wed, 18 Mar 2026 23:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 517246B03C6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:24:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18A8A160331
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:31 +0000 (UTC)
X-FDA: 84561369942.04.104CECC
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8FCD7140008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QAweHgTY;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmTpbZpS8VOu0ETweBFTEwO9A4/EC6KlltYP5/7+63w=;
	b=hTGITPs/ouZ7JTgVEZv7f6Zy1EVljDCmScgUce6WmoTkMmktmX5A4m1/+flQZ5LNI2UYgw
	hbGtmi0lYwfy5VmSYc8aAOTku2rYwO6jGJEOjBbo7LQgeUBLg2XMs9KsopHv4htYAcbV5V
	AHEzjPlth1hs6lkwzTGuBDqtGD7adLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890669; a=rsa-sha256;
	cv=none;
	b=bbW3yVouJhkiTZM4LXdT0+BtKEc0huGUR8YLGRJLlOOsfgrJT/M55T/GdXEV+xUruhaj2p
	8LVWVUTsglnbXl0044gyP7lgmnO9MNBddDlx2UkVgk5PjTi4iA3g4HL4I+pEP8cSWIOdSN
	ZXtC3oQG643QiA7Nwbuy1pAT0UKG4T4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QAweHgTY;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773890665; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=KmTpbZpS8VOu0ETweBFTEwO9A4/EC6KlltYP5/7+63w=;
	b=QAweHgTYh72P/ndOcpVNZQEunVCgixuJLcnazB/G/g8KxTxj2wohoRdcfXrEHKe4jX5aTRt3MSgTCMJZJX8bbyjpqB0k5bO/ditDvnlbrK3odmC8+xN+NeMvQMmy1Nmb7rI9yfNgiulZqctseoGIYXHtSBda61g7Lw1OB25s23A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.GqPS6_1773890663;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.GqPS6_1773890663 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 11:24:24 +0800
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
Subject: [PATCH 5/6] mm: change to return bool for pudp_test_and_clear_young()
Date: Thu, 19 Mar 2026 11:24:04 +0800
Message-ID: <2711ec4bf6c30182004e34027fb31a2e8e24749e.1773890510.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ptzo7k1x93u8t4hcfwq1osenqnxofr8q
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FCD7140008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773890668-715760
X-HE-Meta: U2FsdGVkX1+MNMXcJQnszJW2B8Ptja2eLfCvYUsAzqUW/aOFYgzqInUisaJOJwbf6iG6HyZoD5/iO4+/oZN20emw+zyoIC8tvHc9dtT9pwTC+0MtWVotfMh2LcKuwPVWLTjWIJEJysxJX64qbi3R9sM733JpEz5h6n5of8X3o71zOyHvGyzz24fLdiCmhV00YBSg8er62ERAYOedQk0N/JbfkMx4oer9BCOVKNmj+RU8+fzut7zRuCFbokdvZVbFq1ScwaDUu3yc84RpyzhTnNd0v+ifq6U3eHzFrwURO0Qol13GdlBHUD/bZtJV/amcowH/W7Wn7kdhg/pf6wjC/g9O/Xhl1Miiu2DocI56ku5q7X/EiXMDjG1PoK+aj0kyYJdcPtEwjN77o4ea9Sqv0BYTQ08MsHm/BqJQZRDVD8o971NOTJKyBwmy0vIvdx+UZMeGr+ofS4NBeZo/orUe+ycTmNMTJecQe5Q4TK9oDJcwyacfKIN1jKW5SaMXQo5DQ8bSoavkyUygD2jl3nBmHp87/ePm1eMHJaPANXZcaPsEGmq61hYVoRQdUI7fs+uZOGLuuJ5/AcClvoe7T6SA5Uw1zTbE0D9kd175uczADjJLJqcNQg45G0pBz0ZKjFNIYh2Ka7CHDjaxg9aiKhIrbIc8HdqJdZFZ7LvORnnk3UAs2lLFtj2TwG5pZ4xuGKOQ4ccUGE4oUSafLYd7yg3y1/2D3UOOg8HUFT7OqLVoVUqEf8Nt1jAxXnMcVckd7YBGYbbfSgFs+PDCIWdYaUdY4hArRBveAwll8D1k1mw0tDlijA3rGGXTCeXmJMvIWLsb9EyIcI+QrhYLDsfLI8Ya4n+TpTDED8sbUidhe7XIDWBassnYZcI7ULRPV6NK2QzFAcXUponjiiD8PqkMEWZFgZGDdwfkkSct3kfRH45e5OyZ1gZRAInROoz8iUfJ6iUO6+xKMRAu1dFzTmBSZRe
 syXtMcE+
 or81WaLgrOSB9PKGarBc9WsoX4bK9T8I4filbBNoBC5BXHBwMd2qtaA/ChzgYLHSRoCO9tra2Tv8oLZJA4uzuteAuCrGBd2tffIZuLZCoN5vgT7B39VM0Oeb8bj0NAfTsSZQr4Drh1hSMV4VA68pzXFWb6NmiaC0/EcpB9rGC3hw9qpCKrTJPc/ZL6eK74KZ7YVloMntuyF7YmULX3VbVMfakiQV2AXr9eur+wzTbcwCWfLo5ofe40IKAtFgA79G6cjDYWjM/TJ8dIZJx7B5hJ+bMtLf+EYy1SimBXoGZArF+VpXZdCD3pmmVCCVKZ7tKj2PXU8YKqB9MT6rs60G0/Yo6Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pudp_test_and_clear_young() is used to clear the young flag,
returning whether the young flag was set for this PUD entry. Change
the return type to bool to make the intention clearer.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
 arch/powerpc/mm/book3s64/pgtable.c           |  4 ++--
 arch/riscv/include/asm/pgtable.h             |  4 ++--
 arch/x86/include/asm/pgtable.h               |  4 ++--
 arch/x86/mm/pgtable.c                        |  6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 0f34011665a6..083c4b9ed5b3 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1172,13 +1172,13 @@ static inline bool __pmdp_test_and_clear_young(struct mm_struct *mm,
 	return ((old & _PAGE_ACCESSED) != 0);
 }
 
-static inline int __pudp_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pud_t *pudp)
+static inline bool __pudp_test_and_clear_young(struct mm_struct *mm,
+					       unsigned long addr, pud_t *pudp)
 {
 	unsigned long old;
 
 	if ((pud_raw(*pudp) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
-		return 0;
+		return false;
 	old = pud_hugepage_update(mm, addr, pudp, _PAGE_ACCESSED, 0);
 	return ((old & _PAGE_ACCESSED) != 0);
 }
@@ -1303,8 +1303,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
 extern bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 				      unsigned long address, pmd_t *pmdp);
 #define __HAVE_ARCH_PUDP_TEST_AND_CLEAR_YOUNG
-extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long address, pud_t *pudp);
+extern bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+				      unsigned long address, pud_t *pudp);
 
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index aed39bba891e..838cb4a8e2cf 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -104,8 +104,8 @@ bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 	return __pmdp_test_and_clear_young(vma->vm_mm, address, pmdp);
 }
 
-int pudp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address, pud_t *pudp)
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+			       unsigned long address, pud_t *pudp)
 {
 	return __pudp_test_and_clear_young(vma->vm_mm, address, pudp);
 }
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index bac559d29036..88fa63186ca5 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1109,8 +1109,8 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 	return ptep_set_access_flags(vma, address, (pte_t *)pudp, pud_pte(entry), dirty);
 }
 
-static inline int pudp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address, pud_t *pudp)
+static inline bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+					     unsigned long address, pud_t *pudp)
 {
 	return ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index f9439449c9bd..6ca1fdd25191 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1297,8 +1297,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 extern bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 				      unsigned long addr, pmd_t *pmdp);
-extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pud_t *pudp);
+extern bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+				      unsigned long addr, pud_t *pudp);
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 extern bool pmdp_clear_flush_young(struct vm_area_struct *vma,
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8c336edf0e65..2677dcf0bbce 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -470,10 +470,10 @@ bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-int pudp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pud_t *pudp)
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+			       unsigned long addr, pud_t *pudp)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pud_young(*pudp))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
-- 
2.47.3


