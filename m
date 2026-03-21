Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A141099B54
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 06:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC34D6B0089; Sat, 21 Mar 2026 02:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FE0D6B008A; Sat, 21 Mar 2026 02:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E946B008C; Sat, 21 Mar 2026 02:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73C816B0089
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:43:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BFB58B8A8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:18 +0000 (UTC)
X-FDA: 84569128476.04.CCE5CC0
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf25.hostedemail.com (Postfix) with ESMTP id 18F20A0008
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:43:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ciR8wxp1;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774075396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r38DJ++ZDt9VMP3Jb2vV9BEVsnvjTIjo6yUFQQjknaQ=;
	b=lpvkJ67BWhUTY5zO1nBd7YWbAXnylLqiehbkFfmDJ/x8C4lhlLZU357qUIjnFKyzKOHas0
	xU7o+fMFxGZE1YRqq/UQvPVO3PvjbtFIm+jdwHUM3yLecCVg4+T/OcsC9C14CGzpFieB6X
	nQH7KxL3a+BbOlu/EUt8olMgs2RBze4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ciR8wxp1;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774075396; a=rsa-sha256;
	cv=none;
	b=FhHwRiVQxZv+2B1CGi6m0zKIGHQVb5HyZ1Y++UDFCf8CpDC2LjYNU3sNyB0qLoAPJKjMi9
	UpxpvjXjfe/yuDPhz/I0KdDxON6C1CDOl7h4IKS6QX1n0Y3/e2zdQyg3A7MBBFK/3rY9n6
	8WKM0M0DdWkrJShghc2ERuaD9JmahxQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774075393; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=r38DJ++ZDt9VMP3Jb2vV9BEVsnvjTIjo6yUFQQjknaQ=;
	b=ciR8wxp1L55qp7wWKkasBB2SM5wzB/RH6BiZwovwz3tLv+pw2we/PneJsDCAxnrAlPJAP2xhgvA2WhT+BNZjytMAfMOoGfzbhsqVBrL6JeX73Ro2Tz+Dte9CMreaLTqT5lPjbeBCaqasLPRg0EpgcTzy7Kjrj8rSiVBxMQ52ijQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.O98xZ_1774075391;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O98xZ_1774075391 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 14:43:12 +0800
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
Subject: [PATCH v2 4/6] mm: change to return bool for pmdp_clear_flush_young()
Date: Sat, 21 Mar 2026 14:42:52 +0800
Message-ID: <a668b9a974c0d675e7a41f6973bcbe3336e8b373.1774075004.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
References: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18F20A0008
X-Stat-Signature: u8bagcenrrsh5p67cwrooo5khpsmwxa9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774075395-569225
X-HE-Meta: U2FsdGVkX1/M1xTWjL7HeuKFAfNUFGZJJNcXeU9Xo+CQ2CZFaz4p/9uglgWyPmcJ4MPQKL+4SIGlkZpeInTVVUk2WUpbEVod9DXBRKgZ1PqCEo9TFxpSuk3mf4NUCwycbLP52d52V3GJEuCl79r1y//icU7Qme+kOTLr5S8gSOQY6wYEm4+4toX9l64RZs8WXuY1UwFqfy6CZHSfPSOvOmDexD4KoE7XliuLln3fPTTs7aTyW28hHzkrn7KSSbZMSOF2Vs1yCmju+GLKCkztwBAnCMMOAfL/eL8gGwj0dTkjK7AnYJQp0KChZyAE16XdRBIAK7bO7/CG0HfpUZyPtjhIZ0xD97iU5siXM0/SoPFQM4mh6cHDvkfi7Zyi+9ttsPd1mCVJ0b7iEQYdvGRmjZsGayzywKfVTKBhtDTmHV8Xu/jOvoFa17/8dQuMXQhku3mAddCM+f+ad6xV1hvf/tHRBFdU7ndAzSQIi+/GspbO9ZuyXisOQeF0gxoUHPMjd7maOz2ySjZw/iaVfTKfsktOm3W19xDzzSpJF5weI0zcSzulVVcIQY4bYyEuAK4l5XHnPQ/XADpw4mQY2DpX8v17bb26lftDrMbgLgD9mnWo0AQeFCAfcvH9M7g4G61nOjsjjotiUYzoveaeoms7OQx5cEfj6wfhpzTpnFnii08j/mIGYiCrBkw4ObAp3yg6vCWPaxWedxEkbiXhhlYosMMAsllRuQI3IzO5PrZoj+kplN1EBr7op3Ok+yNeCAEfH6rSQOwBKmHWtjUOC1+Iw2WGAIsyhlPmh7NS6rwKxpDQs0ePmD5q+/HnvSgHxH3vXHbQLHohY1HDOkH0EIKdKA8dMsRwiPuXAZIG7Sxb0AO8swsKqYESpUdApRBxC0cByvRrEI0xE9f5OqulNTtHKySA0GrFJkiAq+ktKFLYAi8G8rjw2ApcyHCU3ZxlGBHp/UIxLBVRKBwKxA2gosX
 P8FGv/sx
 zkQNiRFHeLDdIgPUygU7eGg0VSO2oiVt0fuE0G2ys/z+3lr5A/rY7U7eyK7m58TxaHtb1X5uDoq7l94QpzGRLoAUSMFUjHKRDfwo7W2DC/bZf9BQogCcIUl+56qS33f9QpioD6s/uUYjltXNnhA/q9YoaGJTmfaRNy6lOl4GQbyK6zHVu9JL0cxuRnsot/47rtOFELF9VMV1Qbj7CqJyddmR+9VLSDlNppFa5W4dE+3A7174gLYgHHGGpcbB6GNze/fcCh8RJ3RZyMAGvHnXmeAwlIsLQxei3o2Ipvxe/PL0Ttj2vdc/EDfXeQHciVY7JEiUISDO7jNzM7MIeyyzycSAwmVaDTQ0uzklagwetImw22Lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pmdp_clear_flush_young() is used to clear the young flag and flush the
TLB, returning whether the young flag was set for this PMD entry. Change
the return type to bool to make the intention clearer.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/s390/include/asm/pgtable.h |  4 ++--
 arch/x86/include/asm/pgtable.h  |  4 ++--
 arch/x86/mm/pgtable.c           |  6 +++---
 include/linux/pgtable.h         | 10 +++++-----
 mm/pgtable-generic.c            |  7 ++++---
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 87a5082da28e..40a6fb19dd1d 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1693,8 +1693,8 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 }
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long addr, pmd_t *pmdp)
+static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
 {
 	VM_BUG_ON(addr & ~HPAGE_MASK);
 	return pmdp_test_and_clear_young(vma, addr, pmdp);
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ba867bac6096..6c8f2b17d3f9 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1301,8 +1301,8 @@ extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long addr, pud_t *pudp);
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp);
 
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index b09e8c5dadf9..fc1c996c5b2d 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -503,10 +503,10 @@ bool ptep_clear_flush_young(struct vm_area_struct *vma,
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-int pmdp_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pmd_t *pmdp)
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
-	int young;
+	bool young;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 6db900a5d38b..cdd68ed3ae1a 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -536,18 +536,18 @@ bool ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp);
 #else
 /*
  * Despite relevant to THP only, this API is called from generic rmap code
  * under PageTransHuge(), hence needs a dummy implementation for !THP
  */
-static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long address, pmd_t *pmdp)
+static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	BUILD_BUG();
-	return 0;
+	return false;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index db0ee918b08a..b91b1a98029c 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -124,10 +124,11 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-int pmdp_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pmd_t *pmdp)
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
-	int young;
+	bool young;
+
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	young = pmdp_test_and_clear_young(vma, address, pmdp);
 	if (young)
-- 
2.47.3


