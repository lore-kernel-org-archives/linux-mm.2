Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04B5C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9EA6B0133; Wed, 29 Jul 2026 10:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333366B0135; Wed, 29 Jul 2026 10:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222E26B0136; Wed, 29 Jul 2026 10:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E59246B0133
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:52:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AED4EA0643
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:44 +0000 (UTC)
X-FDA: 85041735408.28.C23FF3F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id EB98320009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=q69ENXoq;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXfKR0nPRowkqfwng0/JqAKBUWBP6k7mh7YMBMoDUa4=;
	b=A8RC9BVeoKv6p10jCeBRxl9plcgWkx/8UN0t9/fDdNqTGb6wT1Xgn3NUEqc79XHT5Wkh8c
	qRdEivoQ6iLJtyOtTuC2ZyrFPADbYxH3wzIDU/Hv77Yl9MW6N2ArWwLLfz3x8jQD9BVfTs
	g5IJRaNAg5JhGd/hsV+TVjZOkjbpaVA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=q69ENXoq;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327943;
	b=F4ZBya6EWj9uihCvG0ddq9LSvrjJFL3SktsDFS5kMOI9p0HwmQf2sSKm/mBHwfviLw/KWV
	PemtSHUoIysBlLOq2SQtE1yMuwy8oAlKqawi0w/NsUOIGssVW/v82xl4/rqEyvC9DaGAZ8
	0+f3SVTX06uKYZo/gGniv4VVwxaQhRk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B0FC1688;
	Wed, 29 Jul 2026 05:25:38 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B7CA03F66F;
	Wed, 29 Jul 2026 05:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327942; bh=D8njUR+w2v+ndiG5KM/iOINKA++RZQNA50z7qf0KbP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q69ENXoqiIBHn6/l0E0y3VJVTEIxcaEzGpXLTpzhhxWEKiil8Yl0wkGY729L3ibAE
	 sTDaFsU7xMGX3Dm+zHJOAIH7WcqYS+s+vXMCmS28R43/go9/2y2fkWdkIKAmC5s7KO
	 Y4yezjZos5Gr+KnmpMA+33p7DaNp9fDrFTbev4xc=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/17] arm64/mm: Route all pgtable atomics to central helpers
Date: Wed, 29 Jul 2026 17:54:43 +0530
Message-ID: <20260729122452.3797443-9-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB98320009
X-Stat-Signature: rujjuzpo4ug4xazdqqskuk5fscodnc7k
X-HE-Tag: 1785327942-599298
X-HE-Meta: U2FsdGVkX1/SnBXMKEQpqgGBKbRcf4JHMMencZWS8EtrFrsJhAJmbSzJw9DCBOsa+A1B9OFyzSdwS4ecrwvT0IeJuZG1XWk0/wWYEJxSVGNbEE8LW0Zm6fjQDU0vvXGHi9MtI862LYlNJps64gJjdDhO9+XAtc2cMNTyVpGwpawL75nGFLpxqaUUFQNv5qj4wR9cg9V20XeL+PkcYxt4/Y7TWjovX5BknVxWGjqliN7oDkzsxM7oXNbiCyWAV9DxnNRuEEg8GRS395UcDT6UvbfWPvpbGGF97O3kf8kcDKhu3MS50ak5Y6qy+/cCYpDTk0zgZHgt3cY16W9aA1Llg4azclyTtHcZZlKW5cu9RkRM8L1lnWRk4vTQ6FcCOD7qV4eyVPtDgIt/l4jobUxCJwjv9EkxASW536rrT1kALLYTD5K/wJ5Wq3IcQxK2R6fpRhdp2BbHrcVYgK0LO4zHZvxB8MOfaDf7/+r7jGDZOJBi+nps6BSqXalS+w0N56yNtA7gOFqgK2neGpQzkWC8xsrNCC5w85ivBf99mNU1EG8emF2VkjzEjo5vw0HS4sJrOpURbNEqdJm2kM5BpP2AIj2sIXq2OtuZd1I3ok29U2yDrUkD31LvZHhiJhxH4+/vI7wdK91ORVG85R95f4LDFoXyys0AMbziINJgLpG/LVJiTLo22GO7QniD+WS63Gxv/nrcOivYqc11vDpojEqfRK9GQm2PyNIwel5nN7rbUg0qzQWmlN11uQ134cNp8ukn/+i87lS8SKSQ80OLdJelZrk1xTYXeu5NsaQ2WpisBAgBkCLxPgI6NFKw4oqPykHQ7SBdifZBDbieR8HEGDXAQsUn+HJwN/+ABkCgmq2Ipao40DxJLEsJ4nt7WLu9LJVDGmAkC8Ij1iOtwn8Egz2FzsQGFkqXaO8rL0gag6EUEReAcjZj/Z1xzSYTGteb6cjQB6z9JA4ensAYjhS+JGG
 WjWkM8g+
 y0fF2wYioRJjba2GHq56zZM1vX0jeR1mQ8OP8xhcAfhiWE0KH8NI+PbjqJr1Iey6JmHO5GfK3svx6qw5ekClEnZ/C8prmYdT3iJpI8XPQLntORU0jmYKsCIemhXDvfCNlTSb5S3vs1M8LE0GXtzhHsr0SypgEYo9cPrTjmTGeKUmd/Hgug3LX3gs4Sn2MS86eKWtHADN5ztxvxDL9OvIZuW6FqK4dRIkbHfnjPrb0rXyEDVQpeVIkJXQVSKWMEwOUCEo5Y/i8MSA5pxQDxQDqPWsT/UKNvbZEboGgDAUEiGfK9avEZoffNa73ugvPicMBf3rMQRNE7Sr2C0Le6lhle513JwYW2/tV5HRbWVXGFcjMLRYwRDABc648NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Route all cmpxchg() operations performed on various page table entries to a
new ptval_cmpxchg_relaxed() helper. Similarly route all xchg() operations
performed on page table entries to a new ptval_xchg_relaxed() helper.

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
 arch/arm64/include/asm/pgtable.h | 26 +++++++++++++++++++-------
 arch/arm64/mm/fault.c            |  2 +-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 1106977e0ef0..4efcacec6f01 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -87,6 +87,17 @@ static inline void arch_leave_lazy_mmu_mode(void)
 #define ptval_get(x)		READ_ONCE(x)
 #define ptval_set(x, val)	WRITE_ONCE(x, val)
 
+static inline ptval_t ptval_cmpxchg_relaxed(ptval_t *ptep, ptval_t old,
+					      ptval_t new)
+{
+	return cmpxchg_relaxed(ptep, old, new);
+}
+
+static inline ptval_t ptval_xchg_relaxed(ptval_t *ptep, ptval_t new)
+{
+	return xchg_relaxed(ptep, new);
+}
+
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(pmd_t *pmdp)
 {
@@ -1340,8 +1351,8 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 	do {
 		old_pte = pte;
 		pte = pte_mkold(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
-					       pte_val(old_pte), pte_val(pte));
+		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
+						      pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 
 	return pte_young(pte);
@@ -1383,7 +1394,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
-	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
+	pte_t pte = __pte(ptval_xchg_relaxed(&pte_val(*ptep), 0));
 
 	switch (pgsize) {
 	case PAGE_SIZE:
@@ -1459,7 +1470,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1497,7 +1508,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 		if (flags & CYDP_CLEAR_DIRTY)
 			pte = pte_mkclean(pte);
 
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1536,7 +1547,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
-	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
+	return __pmd(ptval_xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
 
@@ -1863,7 +1874,8 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
-	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
+	old = ptval_cmpxchg_relaxed(&pte_val(*ptep), old, pte_val(new_pte));
+	if (old != 0)
 		return false;
 
 	/*
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index fca716ed4513..7aff70c5479e 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -234,7 +234,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 		pteval ^= PTE_RDONLY;
 		pteval |= pte_val(entry);
 		pteval ^= PTE_RDONLY;
-		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
+		pteval = ptval_cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
 	} while (pteval != old_pteval);
 
 	/*
-- 
2.43.0


