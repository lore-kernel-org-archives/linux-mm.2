Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3583FEFB7FA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92DA86B00A6; Tue, 24 Feb 2026 00:13:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6AE6B00A8; Tue, 24 Feb 2026 00:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821816B00A9; Tue, 24 Feb 2026 00:13:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6456B00A6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:13:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CE571B5D5B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:23 +0000 (UTC)
X-FDA: 84478181886.20.97C775C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 815001C000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771910001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ayvpnHYj4EbJddjYMjzafBC+RiccfjiA2UiMgNEX2Q=;
	b=bmK4Al+6cTh37q5fwVzVNQhvtIs4y4/qnZiFTXaAq3EHCjiISjnhcoCa2qIxz9dCSMSkej
	spBNywsc2pMY2+Y0V3d4dMdQQj4Pe6VcnzHD/82vwCClok9e1bc4/qRhzZGy/ASW2TZonW
	Kd4Qkgi92uAHlpMYkApickb6Uz+hiWM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771910001; a=rsa-sha256;
	cv=none;
	b=mVeRgYzU7H1n4+O5jH+POg5AELUvv9Up/tmpSs5dmV9dG2idLQ9ZXrJMDwpSnfWe5wiNCD
	VyNhuzBxvYpUnQ88npojjQlfIM7poQ161R8TAsSnEIByamZ4/eu7KJ5zRknyUpRLwuxBMd
	fkuAbqFZ1ETAC1isilYyGsTx4H37kos=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EF02497;
	Mon, 23 Feb 2026 21:13:14 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6C87D3F7BD;
	Mon, 23 Feb 2026 21:13:16 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V1 11/16] arm64/mm: Route all pgtable atomics to central helpers
Date: Tue, 24 Feb 2026 10:41:48 +0530
Message-ID: <20260224051153.3150613-12-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 815001C000E
X-Rspamd-Server: rspam02
X-Stat-Signature: 4tn4gyr45ejhq9oufuer3nj7r5h1icq7
X-HE-Tag: 1771910001-282268
X-HE-Meta: U2FsdGVkX1+6LoZkN6hcCFxTWrqEGc9198HZJ97OhRpQBsPpK2LCjajhu4CjuARHhHdKn9/JmgLmGGBp+g0XCugFYQpIFyxN5NwXapbvlufJ63Z9vSIRGNzlSynGyIMo2/o6sgaACSBpQauw6H+oT2BflkFL79s+JbgYiHVDie9Oc7/BqJ0WZbRxJnCZ0VNorX+yr7o+hAuFEkEAORMcOGPf5LBNrJ34U0egC2FCSvgrZWrpNpjuT9jNFrDCjXKnxt6VoecnX1r7KrLcf7ub/WP2O1qoCnMAS+EavAaatKkaAR29daN0FkR34Bh3Bm+W5A8YL8jfgVj6jPKu63FeWaT0ipw9FLoEUc8hd+2aVJbPeKVTxU/jo54gp9+VYBX4RoO0fbYc80+NToawqPWrChG1QO2/I4UHhqcSbvr4X6c36vhNoIDOVOpKJi4WFbzOFZKM917W6kJljPM+OrpxtF/Nz3iNbBqO2ygfZtxp0bjg6zO7GksM/iweA5uBHE+cLctUNmaOnwpqGQ9cmTF9Iq1XNHmNf/ac9+LS/FtZRPmTZDXwwC3ii1m/kLGxPfOSwruS50j5mmOsMby5UXZxQg2LaXrsayJT0rsNKV18fD9FD+x0TE/FYO22KNgwHVp1AXpZvNUXqWTUCdkjHb2j3Qzk9XTjcLJ/wef/77B5szJVWLJUVRfTK8vO1pXaxZzn3QKhtV/PU+tiIqrdtmHbNm2+z+PL+ISKGluUqaZxYKZiXTRwyCkrDF7TTaqHRdgxAX+n1Cq2j4A7NnEcloeke32CEOEsqYG49aT1aQMe3kHO0bzkqypOjp/C2hTeUxyHEG30BOhRb6A6b0U2ne9O86+3UlV4AEiBNr3rF1e23nwGH53GvRyfbebNRiBHrpVyH9hYQQm24beIonUE3AJbvsPLVlyE5C3DpLyo9XayJbwqa2iy6tbFKlwXV0JPAF4iOEkxfzm0ZiOSQZ/2kQs
 mTyb7pna
 ga6CrqlSkLLWaqel/Spg9yZdaLmHFbJ/Oh7oOnwj5MFTJ9odWl5ZiB6VO/vq0xFAHFs9QjgCIp7frdQXFiUMorezq5WbcD9tMu4J/DmxNxPp9DE86ePzDQc3IrYkqWvehwR5LjjfW73TPzyqOtyFBW9QTLpbvccM+ApaGyBM+kyZZ4wTz7KF1Lh/XWogUcDAC0vpV3Dz9X9aLhFYPmZEvjH2kcNmkd/bF5pRbtIJrmbafb10=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Route all cmpxchg() operations performed on various page table entries to a
new ptdesc_cmpxchg_relaxed() helper. Similarly route all xchg() operations
performed on page table entries to a new ptdesc_xchg_relaxed() helper.

Currently these helpers just forward to the same APIs that were previously
called direct, but in future we will change the routing for D128 which is
too long to use the standard APIs.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 23 +++++++++++++++++------
 arch/arm64/mm/fault.c            |  2 +-
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 42124d2f323d..cf69ce68f951 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -87,6 +87,17 @@ static inline void arch_leave_lazy_mmu_mode(void)
 #define ptdesc_get(x)		READ_ONCE(x)
 #define ptdesc_set(x, val)	WRITE_ONCE(x, val)
 
+static inline ptdesc_t ptdesc_cmpxchg_relaxed(ptdesc_t *ptep, ptdesc_t old,
+					      ptdesc_t new)
+{
+	return cmpxchg_relaxed(ptep, old, new);
+}
+
+static inline ptdesc_t ptdesc_xchg_relaxed(ptdesc_t *ptep, ptdesc_t new)
+{
+	return xchg_relaxed(ptep, new);
+}
+
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(pmd_t *pmdp)
 {
@@ -1313,8 +1324,8 @@ static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
 	do {
 		old_pte = pte;
 		pte = pte_mkold(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
-					       pte_val(old_pte), pte_val(pte));
+		pte_val(pte) = ptdesc_cmpxchg_relaxed(&pte_val(*ptep),
+						      pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 
 	return pte_young(pte);
@@ -1350,7 +1361,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
-	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
+	pte_t pte = __pte(ptdesc_xchg_relaxed(&pte_val(*ptep), 0));
 
 	switch (pgsize) {
 	case PAGE_SIZE:
@@ -1426,7 +1437,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = ptdesc_cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1464,7 +1475,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 		if (flags & CYDP_CLEAR_DIRTY)
 			pte = pte_mkclean(pte);
 
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = ptdesc_cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1503,7 +1514,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
-	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
+	return __pmd(ptdesc_xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 7bb14765a98d..21964a387bf8 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -230,7 +230,7 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
 		pteval ^= PTE_RDONLY;
 		pteval |= pte_val(entry);
 		pteval ^= PTE_RDONLY;
-		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
+		pteval = ptdesc_cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
 	} while (pteval != old_pteval);
 
 	/*
-- 
2.43.0


