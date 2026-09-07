Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36AFFC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900616B009F; Sun,  6 Sep 2026 23:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B18D6B00A0; Sun,  6 Sep 2026 23:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7516B00A1; Sun,  6 Sep 2026 23:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 504906B009F
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:50:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1C46A4B79
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:44 +0000 (UTC)
X-FDA: 85185589608.17.D7A6DE6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 13AB81C0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hsxe98q8;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753043;
	b=NTXSSa+4CGJSN081VUjJPJs/7vMzfuFIlzJ+vypTtXhU+NRqgmje00On8kH7hIY8JeP987
	zpMveEW/Mb+fWakTI6g2ukG/4QqM2rLekITgUWUz1prHznnPk5yPLWuqAYJ9buvGf514Wf
	ExFwU7fC9Yyh7HcFvq38K8IYnJ23xWI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hsxe98q8;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kav8SCaGbCs1j4nwYaOf/+IUPZFPd0Y45jTgLNUaGhA=;
	b=pmhio/a+Ntw60XnD4s+LE8qWb1VYNn+lZBMORYqQIDSppiqxjBZxp/pyGPouzlfCvp8n3O
	uBGZF11Q7l98Lz1+7/pZKj/VjYrPc3c2Dqn+mZ8/m68zPL6dhsqxObYQGoSjxK5Jba96Fg
	op2UGWQrcBTn5SXVuP4/5Gq2vcrd8e0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64D0D1BA8;
	Sun,  6 Sep 2026 20:50:38 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CCC43F7B4;
	Sun,  6 Sep 2026 20:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753042; bh=u0NC425vYyHxLP7hQ6qnyzz+8iyaNNOtn3y2ra/8hTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hsxe98q84/3K+kWyhkJqja1wgsnGC3YeYfKTHgB+lv+0kg19pwmcx4WqvGbsmzzic
	 7c+COfU5ZnvixdveYZQPHnggpyxcqQm5iVzOhATDAyQ75LDL7OrBLrYkwvkpo89Pje
	 x638FHhR/9el/45Wd5MBVq7S0rfhZ5JXSoFkoHw4=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 02/14] arm64/mm: Route all pgtable reads via ptval_get()
Date: Mon,  7 Sep 2026 09:20:17 +0530
Message-ID: <20260907035030.2839978-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13AB81C0006
X-Stat-Signature: 96cf9fmyhk8ejyn47xt44m6ehucff5kb
X-HE-Tag: 1788753042-919188
X-HE-Meta: U2FsdGVkX1+5sWtwZsb+qE0MLAtxcogN4a9bYbTUdgYDWrUDlwO9fHpdl99rdOsvyylDIZwQDhnUAS78Ev6kL62GFxtmDHunKrYLsbhczyMg+JLHfqxmfKVryEu4fISMeCo289GnCWNeJlnz41gPAFFM7JkANvVIiasa/5yIC+It27mYK6rdKTj9qWzHzoXaoUxUo+PjsFcSNREs7kDt3ZR2yO+3RdDWLf+pLxASezKWwJrfwYmZExTQU21FuOPQTwluvVPtFsCizhGmf0uaP2Iq1239dZjnDPcLW/7aI292HKIkDgx7A8UFWs1/DkPf52SlRZRYjfHoEkyTaUk3pw0kyxiOKnifRangoikjfgszO7UdByJszJ36mvCyQ6rvu5KhJK5NOTAp0Xszv4K8V9b3sSjCLM6H69nFWKBsKEfQyGrCMKZOZkFfoFZHy0uRLx2As7iqm3sOr5dTJkeFu6J2hpBBaAp9yk6XiE1vRcDvZN8I8K50DGFrzdgLjNDaovC3MB+NV9fR/9G/b6vSMI69SWuVQrmrXWDDgMENdlvhYIZHghji7oqrvyQM8N6oriRQ4Q18qGdVSzkUG3Np2AxvpdaUTBqBc4FWv01W+8IGODRbcEVB9vLwCVtuqXClI4gjkUKSkc0qLnDrH7Rw4G2CJbgfG/ObtR62GvimNu+IRchgQsO1blNDaAvKy4AfHP3jY0XILwXaLSLXdDlDTCdxiLqMgIIzqTyct83Hr7yKZa6eS+aKQFf77aDV6nElLK/XL7CaEsO2YKSFaZIp3OvblX5VNPfUOisW85P745gXm4TsB/8r0eDLtewIW+YC7p1FZwmh3yEPNN97j5gSk9oEoA5MaUHdrvsxQe/EKUgQJJ9AvaVDct5MUsToyCkjDvMj637x6NiFS+v3C95PlO+dfqCFdTYwP8Ley19rKUwhCYHtE9M4s8lV1t4/Sn0RVhf2eY+RoUanMdsBMCE
 tESCQgxI
 fRHYw+Ox8eErdteGBr1ALDJ3nK2IHoor/KKt25ZIJHJrp6XbUEq1+FwyDtpolX5v5sKFvaTrEqgbJiG2EViw+mHzuOm/pBNvYaRCWu1uGTrJO/Xq53u4e1OACai369xJ0W6Ftu2CTcZo+wI+HhU7rQnILZZtI8m1JPxAwJpICh14nuTvFcEu2CSXrIY0TOz6M5Uj3TM7jG6YhYUZitCau38wdhv/NWQff44+BdRBiEESZXXpgAUYokjwti33nJcoCdLZhAWPM4I5QBrotvuXp3WAHmiuIn2uAXzoNbC9MknAkH++mVBUcoWxU9bZoj4c0j2CY/Zz5Fz6vtbpdZipWGs8H/lqw+ef2pBBo9B4jsb17C92ryg9QNwRQTO4hvFN/YODBCbNhGDHGDP/wiuS5XEQU+l7Mjj3qfa3h2X5yXfrgV5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define arm64 platform specific implementations for new pxdp_get() helpers.
These resolve into READ_ONCE(), thus ensuring required single copy atomic
semantics for the page table entry reads.

In future this infrastructure can be used for D128 to maintain single copy
atomicity semantics with inline asm blocks.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 38 +++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 83087b70f192..f764132ca34e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	arch_flush_lazy_mmu_mode();
 }
 
+#define ptval_get(x)		READ_ONCE(x)
+
+#define pmdp_get pmdp_get
+static inline pmd_t pmdp_get(pmd_t *pmdp)
+{
+	return ptval_get(*pmdp);
+}
+
+#define pudp_get pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	return ptval_get(*pudp);
+}
+
+#define p4dp_get p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	return ptval_get(*p4dp);
+}
+
+#define pgdp_get pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	return ptval_get(*pgdp);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
@@ -381,7 +407,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
 
 static inline pte_t __ptep_get(pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return ptval_get(*ptep);
 }
 
 extern void __sync_icache_dcache(pte_t pteval);
@@ -958,7 +984,7 @@ static inline phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
 {
 	VM_WARN_ON_ONCE(!pgtable_l4_enabled());
 
-	return p4d_page_paddr(READ_ONCE(*p4dp)) + pud_index(addr) * sizeof(pud_t);
+	return p4d_page_paddr(p4dp_get(p4dp)) + pud_index(addr) * sizeof(pud_t);
 }
 
 static inline
@@ -972,7 +998,7 @@ pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d, unsigned long addr)
 
 static inline pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
 {
-	return pud_offset_lockless(p4dp, READ_ONCE(*p4dp), addr);
+	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
 }
 #define pud_offset	pud_offset
 
@@ -1078,7 +1104,7 @@ static inline phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
 {
 	VM_WARN_ON_ONCE(!pgtable_l5_enabled());
 
-	return pgd_page_paddr(READ_ONCE(*pgdp)) + p4d_index(addr) * sizeof(p4d_t);
+	return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
 }
 
 static inline
@@ -1092,7 +1118,7 @@ p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
 
 static inline p4d_t *p4d_offset(pgd_t *pgdp, unsigned long addr)
 {
-	return p4d_offset_lockless(pgdp, READ_ONCE(*pgdp), addr);
+	return p4d_offset_lockless(pgdp, pgdp_get(pgdp), addr);
 }
 
 static inline p4d_t *p4d_set_fixmap(unsigned long addr)
@@ -1287,7 +1313,7 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp)
 {
 	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
-	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
+	VM_WARN_ON(pmd_table(pmdp_get(pmdp)) && !system_supports_haft());
 	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
-- 
2.43.0


