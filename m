Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0957D10A3D9E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD236B008C; Thu, 26 Mar 2026 22:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E1D6B0092; Thu, 26 Mar 2026 22:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA7B6B0095; Thu, 26 Mar 2026 22:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3ADB16B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:14:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D662E13C248
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:19 +0000 (UTC)
X-FDA: 84590223438.06.9147ED8
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf15.hostedemail.com (Postfix) with ESMTP id 206FEA000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AyyvqfAT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35ZUueVWTNj5ENc9hO0kXufOV22N6/4M8lIMyGx5nWI=;
	b=G6g+ZfqoM7RPGuhEUF3bAnfeXRoaO60Ad29lndWm9ExkrKAv/IUj+WpJOOEfnVqSRNTPLr
	QF3LECHmoSQ0vsm0q81gyZC8SASQZCUEnmICaXiFfmOPRteThb0AlXKuaFb11L5qfi3hNe
	+KhC1MFwjo4lQeFcXmGZmNTF9vktlYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577658; a=rsa-sha256;
	cv=none;
	b=JXk2/s/fCsGaPS49fnD19YR0v5qGgExqjVlIRSgujibcjvX9K1tjg7SsPxiXKl65ksjn/0
	MqMqzE/iA7c3EzqtvDGBcsvL1ZetqQt8pUfU3OM4vq9ZIwnLQyPCf67HtujaQr6ARgQ57p
	luYUpWzjkH+7d3XddX/ngJO+dxUZ6DM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AyyvqfAT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35ZUueVWTNj5ENc9hO0kXufOV22N6/4M8lIMyGx5nWI=;
	b=AyyvqfATC2BCM88QS4aIPXad5Ss5lC9cHT+xptmrLSNcMLknDQOu4gCyD1sp2YYHpHTvk4
	VNJ9tKHO1z4pcHLd7iTIFFjH3tGKbBu91MSXsXrZW8sVi+XZU0uHE+BRUOx22o/9NBQ71z
	P3xX9UxGsvxqcy4J1vMbAqdE12t9QJ4=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 01/24] mm: thp: make split_huge_pmd functions return int for error propagation
Date: Thu, 26 Mar 2026 19:08:43 -0700
Message-ID: <20260327021403.214713-2-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 206FEA000D
X-Stat-Signature: yqc747t5n57j1fkx8x164cunypne5mss
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774577657-479719
X-HE-Meta: U2FsdGVkX1/1/tFLYcb3pBP9Hvq9tK8XxqdCh4ert6AymI5hFUeIInxk6vB/Rwncl6o0Ion3I4u/0/qz83TPiqnRMI3nxQ92/bN6EUVBM6pwDi3q81R9cLPPH0JnJXx9nTZzsD9sjFWKB4Ui7O9X/JYwPHxgqD7M5WU2Oim1jbTSMqGIhRNHdY4dY3cZOTftm5TuiuDCfDm0F4oVft6arFg6+kyBvpN9hjzE9wC3vJJUrWg8/jmTQ2l8H8D24AELeAXUSGMTDwJCUGAmV03TDZ5lRNLRKHTOnIcYdQZwWU9xLp1iFINAUAaP+ap4hOkrfsdK5GP+xeQZSv021wO1pBoerlXO+5okabfd5DK15M57AORO6saWOc1OxugjvQHcR6v19lpP3Lfw/DvHqxODmigZcptY1X7OT40wBr+cEvfJb+N/Zbuq/ePkhWaQJoBGMrcXiMeff+D9cGg48vI6YFtcfBKTyEcJpnQL8CLWVnTD3QaV669UgSDfq2Y6d6rsbomy41UtlwZXmprXrm8vlxkHq5aWuQBlMX71aYxWVDKeEp/6C4PHKaBdMFTSnOCpUz5BZZIMS2m7e0Y7DhUQR6KvioyZwhoJfAQleTV3QkOeGYNgzPePdbRiu6ld9Y73Xxi9g1mIRXgZPusM0L+eVjlkdMjaq+8kaCqgKi5L1lzeMelSSpS5PSLobf605nFlc4tNbMXnSd/wxwMycPpp2iBFifG5Iw19PK4DtyJzD59hb04GDYJq3iQvR4R3u4/2QAINZPbp4XVTwqE212tluGY4thGdJcxrCcXG0IwZbMy9Qx92VfcLrHlj//Px3xfGPf5D9lA3tjJX6UlnRtdWKFPUApy7bTldx819rV9jhv1p1ZZEF3yl6jPs4Hwn4dG+uVyurO2Z6Pa0RJ2WZR+uBMIfhTSRLHErcDmJekDpMTT0fjEaNOYVmAT4r0lcQRzFioJm7436Xs4AaDlvORy
 3giXZwW1
 Dh0229Gy2UMdkVnuvGGkqew1nDFOv5t/UtZtrfcUvGl3dk/1OYnwM/NaYz0ebm/BmXI3aPQp5O7ZcDHx/tJyRsT02agY2dnSF7cSh8INpeZrU5uzWHJ8rdJfBYVNSMxNEStsJMI20eKzdVZkcZh8xBpQD0o1NZJJK27N3uvA52sLOXq+5pZtIe+T+bof9r8AGZLm2O6PY0xy4+a7a4IH1rgM5sxRmaWl0TBRSdy6CfcYekUBcgg8JDE8YWM38VBJTA7biN5mPtasvLCHAx+MRl6L4fxf2PHg9kn7WDlbN1IPIEen8RkbJommMjs4G1zYSmIwmN4AMGyPho8gzaMzHCcOnsJgLUYUUloeK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently split cannot fail, but future patches will add lazy PTE page
table allocation. With lazy PTE page table allocation at THP split time
__split_huge_pmd() calls pte_alloc_one() which can fail if order-0
allocation cannot be satisfied.
Split functions currently return void, so callers have no way to detect
this failure.  The PMD would remain huge, but callers assumed the split
succeeded and proceeded to operate on that basis — interpreting a huge PMD
entry as a page table pointer could result in a kernel bug.

Change __split_huge_pmd(), split_huge_pmd(), split_huge_pmd_if_needed()
and split_huge_pmd_address() to return 0 on success (-ENOMEM on
allocation failure in later patch).  Convert the split_huge_pmd macro
to a static inline function that propagates the return value. The return
values will be handled by the callers in future commits.

The CONFIG_TRANSPARENT_HUGEPAGE=n stubs are changed to return 0.

No behaviour change is expected with this patch.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h | 34 ++++++++++++++++++----------------
 mm/huge_memory.c        | 16 ++++++++++------
 2 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1258fa37e85b5..b081ce044c735 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -418,7 +418,7 @@ static inline int split_huge_page(struct page *page)
 extern struct list_lru deferred_split_lru;
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
-void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+int __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
 
 /**
@@ -447,15 +447,15 @@ static inline bool pmd_is_huge(pmd_t pmd)
 	return false;
 }
 
-#define split_huge_pmd(__vma, __pmd, __address)				\
-	do {								\
-		pmd_t *____pmd = (__pmd);				\
-		if (pmd_is_huge(*____pmd))				\
-			__split_huge_pmd(__vma, __pmd, __address,	\
-					 false);			\
-	}  while (0)
+static inline int split_huge_pmd(struct vm_area_struct *vma,
+					     pmd_t *pmd, unsigned long address)
+{
+	if (pmd_is_huge(*pmd))
+		return __split_huge_pmd(vma, pmd, address, false);
+	return 0;
+}
 
-void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
+int split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
 		bool freeze);
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
@@ -649,13 +649,15 @@ static inline int try_folio_split_to_order(struct folio *folio,
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
-#define split_huge_pmd(__vma, __pmd, __address)	\
-	do { } while (0)
-
-static inline void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long address, bool freeze) {}
-static inline void split_huge_pmd_address(struct vm_area_struct *vma,
-		unsigned long address, bool freeze) {}
+static inline int split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+				unsigned long address)
+{
+	return 0;
+}
+static inline int __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+		unsigned long address, bool freeze) { return 0; }
+static inline int split_huge_pmd_address(struct vm_area_struct *vma,
+		unsigned long address, bool freeze) { return 0; }
 static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
 					 unsigned long address, pmd_t *pmd,
 					 bool freeze) {}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b2a6060b3c202..976a1c74c0870 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3283,7 +3283,7 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 }
 
-void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+int __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze)
 {
 	spinlock_t *ptl;
@@ -3297,20 +3297,22 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 	split_huge_pmd_locked(vma, range.start, pmd, freeze);
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
+
+	return 0;
 }
 
-void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
+int split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
 		bool freeze)
 {
 	pmd_t *pmd = mm_find_pmd(vma->vm_mm, address);
 
 	if (!pmd)
-		return;
+		return 0;
 
-	__split_huge_pmd(vma, pmd, address, freeze);
+	return __split_huge_pmd(vma, pmd, address, freeze);
 }
 
-static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
+static inline int split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
 {
 	/*
 	 * If the new address isn't hpage aligned and it could previously
@@ -3319,7 +3321,9 @@ static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned
 	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
 	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
 			 ALIGN(address, HPAGE_PMD_SIZE)))
-		split_huge_pmd_address(vma, address, false);
+		return split_huge_pmd_address(vma, address, false);
+
+	return 0;
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
-- 
2.52.0


