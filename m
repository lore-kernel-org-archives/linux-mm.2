Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977F7FC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2A56B008A; Thu, 26 Feb 2026 06:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59BA6B008C; Thu, 26 Feb 2026 06:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87176B0092; Thu, 26 Feb 2026 06:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C70FF6B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6AB7E1A0B6A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:10 +0000 (UTC)
X-FDA: 84486396540.04.9B0E8A4
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9AACA140002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BFSudpBQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105588; a=rsa-sha256;
	cv=none;
	b=l9RsAGqkdbmbICQ/4EhYDkVMp+EM7JboTdUitN1WXP+RNfgAKld2QjLsI9JHtS2AhEXue2
	/6G1aYNuhko4lQOe68DznuVuwmtDznpz1UY1ue/S5Blp17W515zDTFzNuC09q8I7i/tk0a
	x6/zTzuyNnrLPQsc3IMtsEoDKNitPU0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BFSudpBQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMeF9FuOGiVcaeEE8TLIVYSd2ZWdyqQJ2YusxNRO8Vw=;
	b=JbkYuiGGJ2HGEHUi6Y/c1lM4WBrQCgRpx0wdHuNF3RAia608p0HMO+vOL96KK+IobfEe7N
	YTwOCEe/hShuqa0Eg53KS/CXkVHr+ez8FAoNKEJj7VYaLdTgpryMgLFFeT4hxCqaY/4z87
	puY0h8NIyATjPypKkUK8Ia3AgbIuj1o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rMeF9FuOGiVcaeEE8TLIVYSd2ZWdyqQJ2YusxNRO8Vw=;
	b=BFSudpBQsSSTYRqfYn30RDkrmyvD8a82qVH1sYA5NyNZ7scTnnsWMO+aILfSxqwHerqizH
	saC0LYcAFWnkoLmEVnGKpnBUc4oq6xsaL9QCJjM/OgvgRBSPnqALRaNrYVJuxt2Tse2yM9
	17DCCv6gSxumhU6zBvHKgBtRtW9lMQc=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
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
Subject: [RFC v2 01/21] mm: thp: make split_huge_pmd functions return int for error propagation
Date: Thu, 26 Feb 2026 03:23:30 -0800
Message-ID: <20260226113233.3987674-2-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qeoryi5d88rkehb9mok99ddqj4ckwemc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9AACA140002
X-HE-Tag: 1772105588-383347
X-HE-Meta: U2FsdGVkX1+dMMQe54ahEqhFanR4m0RZfL07RsAhyubUx9tOVpP+mmmyRJ4c0hSK6/QCKODz8baRMciHhVDHIgcmJTHKD5x111++9FCzY9/Z9EO+URsqjBy5eOlR4ZmCGxclb/oMqC2q3BP8nzXu9728dibEILieTf1kh3/8L4thcvsYuUlOVQvXB2J45hboKCQfPkwFUiXB/EoFWj6FWKk/1B7SlH1X9H6C5zHHVmHu9GZGw3lh3/iu5Ebn68qk6mAf3eqjUy/v0WluCoUy0EZWPeUoCYXVh35UnHID7D+DEKegCqhopclZfixBwHbpESpKG5W+RLU4f57AcTY5QoG1A3RLcGG83HMh5L2vdAhZOcADIvUPKCkwdgX7RCSlGdeRzNQ+ttLkOVlgGDD26hJiU0p3Nmq6d9gAv5YVq4AOZjUfKp4M3ms5RRYYsBdPPiXyZFWZ8A3bZbeT8SQZwqyDge0vwaLQkbpVwVY6evjJt8Rcsk8EwVuyrvXsZq6XpNDaMrhQr/x3RDQwJKorQjDqJTNWq0g46CTksN6yGRznGUuB+hiK4skTi6VA100oNyO2WzM7+g5+ARf1tNgFM/gmlVva3wawFaCv8PwAY/dBerlZDZ8QAY0zlrofMLL04+LO1T5tch533bX9Xg716xwWEOoVbk5culWUVbgy01IqrhptTeNO4uKD15oG6kZ806XUd07ZMMVAjIVc6vqcNfNTYGBpgzr5FrnvuCinHM5HFVEB9Qqv/PSgX8+HOlpOZHNt9s5uKgm31iFRQDE7qyLEfTBz6XpubqGG0+NXj7NNeaZWYJc8ZLKmy//EF07y4GmJhqEcKXEsReixQY2VTethPZnggGJUeUE9TyPWMwLPPQ3epbHUDFvuZUyAjmEvAjO0L+zdEtQj4QHBFc4Oy2O1ZiQznIfybM2ZvzUHLAoPFiISadYEjWg87UsY9KD20dc4KeDMNhylhzWXS+R
 VfeHsHst
 02xpJxzhbEAiteNm4hjaNZuy0Ohnz32wuNXXZxqgSqrnoRw0+4OpjaFp7aJzELlYbqrsy4uj0CtShxMb9V960seKPfULmOFmq2xT+2lZeLEP2ZtaWR5n/jPc6oMuAQSExdHu8QJMHiRfsZu9wDoC9DXetjUhH+PLKqLj8W/gvVUoLnJjCzb074JdzbG1OSpci/ORgXGIpi3mU2Q7IYN9WGNq6a5pJ/yRE7MbjslwLqVsv0HLa56Zz0Mitprj3YRlFZ1mZ0cejKf1kysBbxY/MHC57tvNIJZ56niwEz0jFTajISUV+neHbCZGcGHUF1/RL6OxQZb/dbPBj7QkriJLQnFjH1AAa0LpgyAFR
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
index a4d9f964dfdea..e4cbf5afdbe7e 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -419,7 +419,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped);
 void reparent_deferred_split_queue(struct mem_cgroup *memcg);
 #endif
 
-void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+int __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
 
 /**
@@ -448,15 +448,15 @@ static inline bool pmd_is_huge(pmd_t pmd)
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
@@ -651,13 +651,15 @@ static inline int try_folio_split_to_order(struct folio *folio,
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
 static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
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
index 8003d3a498220..125ff36f475de 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3273,7 +3273,7 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 }
 
-void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+int __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze)
 {
 	spinlock_t *ptl;
@@ -3287,20 +3287,22 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3309,7 +3311,9 @@ static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned
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
2.47.3


