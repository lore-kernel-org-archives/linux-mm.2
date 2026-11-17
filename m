Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20C2606A884
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DVZWanrd
Received: by kanga.kvack.org (Postfix)
	id F25826B05B8; Tue, 17 Nov 2026 02:06:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E873D6B05BA; Tue, 17 Nov 2026 02:06:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D276B6B05BB; Tue, 17 Nov 2026 02:06:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84B026B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF26C1A036F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:40 +0000 (UTC)
X-FDA: 85443728160.27.550F802
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1621180003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DVZWanrd;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899199;
	b=bpfF3b2PfMU6SG5bENnaVGaA4MUFRi2jBgRZDBSzKwc+G6TZ2FwWxHhojD0qbJ0XitYKBP
	aSURnlqGYLuclLIS2Ny/Z7A/5RlPeAHij9cPM9TQtyMz4fEGyWVJ+/GPmUzJJEwviKIErI
	KZ5OBOuPBdkWdnYRL+jjJrVJmG6hnVs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DVZWanrd;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBmhljpBm36DpauCU/FC6A+ud2fsxJbY98dDN8rTn0E=;
	b=0DSa38YtfUmjO49mwsH0P4Z+hYJ3mQ/j7GkaZvcHgJJtxS4VYzUcpQoaoYOg8+ykwFjcLv
	azHz4x9bvBbrz+1xg0aUfMupr3tRtKEnNdyWNvPxQuOt/a2BtsWiMSNHUY8d3DY9B+vZrj
	AeXB2Mwh/kBLFM2Hv4QsZyGxEKlG+Rs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 356CA1476;
	Mon, 16 Nov 2026 23:06:35 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C8DB3F763;
	Mon, 16 Nov 2026 23:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899198; bh=H9pPB228ZKcouR7EGAqs954E12//ZNJz1w9Ri3nVlDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVZWanrdeOkLWYf6DEdxSEAPF1W6DW8GvjazZk2burG4qUVfM3Wu5X70vLTHHw2Ui
	 dwYx8ZTf4NFFsPBR67TsJhxeoAx1AwQJB9UZbpc5+Vi15DqVIH1PGqFkaDPo333Zbm
	 LChHw/uwrOD0IzjBpVI1AnnF19kJX03Yp2MZjfxU=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 04/14] arm64/mm: Route all pgtable atomics to central helpers
Date: Tue, 17 Nov 2026 12:36:03 +0530
Message-ID: <20261117070613.1183243-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1621180003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ezmusdrattadpfqnrgrj8hrpyabjw6t6
X-Rspam-User: 
X-HE-Tag: 1794899198-830020
X-HE-Meta: U2FsdGVkX1+zJUDCWeRICwrcTugId/gUhlMfJWvk9nEMjASLncmaROrwtKgQ4C+QNFXGflHjCjv7HQ5s4lIQhYrAgSjV0smZpkMWIL+fo3xArx2bTanYzlITLBkQ0TUlwHTj6wJlkFLgrEK5j85trCwb+9Xsn3oLo83SJsvqZnh9CFc/fgZ0pn7yBMZlphJ8YfY7f1aPjJfp736W2TTRdomi6yiC1+Kprbqn4CYSZlBMzxI/AH/VAc+bvxk99+gMZHIsN83LJzaGEkTW6k30ZacPLQt2oMg68O478ElN+1BEtROfTMqM41aCbY3vOivQAHnuRF5G8ujVDzzcitFrQySi5Z484QwefNIWkNRkMlNmyO0qSwTYEsYMYPj8sQPMkh4EsoSsGSXv6PJ3TqxBaoDO6ou1RhyeG8SoCpFYdxqA6itcChw5j+oi0IJ+7xTtbFt/deSfH7xt6xRD2NZyFYsOy1BOuOEpg++BCoF7stZmq1gpe7bly+HlT/r0tJSvXntvCVqiYFhpQnEgFXXZU6E1P3e/50k1kwbFPgGTzkPswxFRR971epI/LwuY+kWyBkeOKW8FjWFpd9I2MjFTfvBsmuwvnZ1SZkIxzrEic0sdq0v79imexm1gz7PK/IILT+PN7a8pnYeqAAlzwBLuiRe2qgQUX88RbhYIb8b1twfzPY2kN3tkmNNhEC8OBCVU1un1PPTd1tAqsRhjBAKm0kbl2Ix+/DuApcTy1Wl1FkoPA8WSE/7suRsV5uUeMi+YWxlR8Tdbit0fLvbnLgWem4Jn8K11uqh6UNFvYrCsWpH+hmZUqqRkfOPJbVxlROpOx6oQVqeoLnEHNEwduYwO+WoA3EKkbutfzLV8Hq/zqpAmdfWB9Qi8l47e1N/HQ4a+rkPT8hc53RgrS/ssfiwPtkjKK9WZ7bo2VOnV3D8qOK5gxlH9EBnfpIpsKhsR1vpfaao9bfT1YDdEuJAzDAH
 CIuueypk
 2H1XGM84QyH8qh7uCB09ahYKzk/TWiclH3SLW4N2UorXPGortIbhLRFqu8XVDBe+faM8bHff982S+tKdEjNO0ZUe2vqNHhzz8oRSFLWU0CBcbsPxTffRrpOx1HFjUVpNvvrXbn0nHokJxebOazKVcvUkf5Fc+19O2IHAE22AqbCuCgsBIQsIAyeB2vcDUOeHI8fcjxQzSsylrOxkAnR8n2nSMBvq+s0ZauLSnRqT90v60G0W4/7W0XrAtS6XmZV6QCIPK2uZLDDAwszY6Tj2dUL9SN0ZNVs51r8zv/jBIhST65PB/C29m4SMoSiaIBHURBoCA1OmbLjfjthit2upeB7kYFBKVSOoYS1Mn6r7k6pdZkFm39Mrrbx1sqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V3:

- Fixed indent problems in ___ptep_set_wrprotect() and __clear_young_dirty_pte()

 arch/arm64/include/asm/pgtable.h | 30 +++++++++++++++++++++---------
 arch/arm64/mm/fault.c            |  2 +-
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0ce2e59e09198..d3a50d35fd017 100644
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
 static inline pmd_t pmdp_get(const pmd_t *pmdp)
 {
@@ -1287,8 +1298,8 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 	do {
 		old_pte = pte;
 		pte = pte_mkold(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
-					       pte_val(old_pte), pte_val(pte));
+		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
+						      pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 
 	return pte_young(pte);
@@ -1330,7 +1341,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
-	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
+	pte_t pte = __pte(ptval_xchg_relaxed(&pte_val(*ptep), 0));
 
 	switch (pgsize) {
 	case PAGE_SIZE:
@@ -1406,8 +1417,8 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
-					       pte_val(old_pte), pte_val(pte));
+		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
+						     pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
 
@@ -1444,8 +1455,8 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 		if (flags & CYDP_CLEAR_DIRTY)
 			pte = pte_mkclean(pte);
 
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
-					       pte_val(old_pte), pte_val(pte));
+		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
+						     pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
 
@@ -1483,7 +1494,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
-	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
+	return __pmd(ptval_xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
 
@@ -1813,7 +1824,8 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
-	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
+	old = ptval_cmpxchg_relaxed(&pte_val(*ptep), old, pte_val(new_pte));
+	if (old != 0)
 		return false;
 
 	/*
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0b489fbeeb070..74bbcd49f52fc 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -244,7 +244,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 		pteval ^= PTE_RDONLY;
 		pteval |= pte_val(entry);
 		pteval ^= PTE_RDONLY;
-		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
+		pteval = ptval_cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
 	} while (pteval != old_pteval);
 
 	/*
-- 
2.43.0


