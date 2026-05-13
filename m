Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27094CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8D76B00A0; Wed, 13 May 2026 00:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0696B00A2; Wed, 13 May 2026 00:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6796B00A3; Wed, 13 May 2026 00:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB3B6B00A0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:47:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31240A06DA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:10 +0000 (UTC)
X-FDA: 84761162220.21.C9CCE19
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7834A8000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QGn34Wxt;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QDcgzumhDt2nz+idNPa3qv9R9TQ37j8+PD3HBILfng=;
	b=0v674uu6ceeYegrzM0XjtMMOLSVeZ0RSZDap0cqaAhZWA8gipHUyjpcsWJfj8t2YifEE1G
	2P8coD1aEy3Nr1UhVNrSE8iomCfIPS1feGgCwa/hfdwPLfnIylGHRe5UIFnoebE8kV2rRl
	pPJVDGfLzykn3LgmN9voyLL7Vi7T+Ts=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QGn34Wxt;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647628; a=rsa-sha256;
	cv=none;
	b=St6XWZKcHDP52ovQqfz8dHaz7OfDaoZiSgYQpT/w+T8CV6q0TtfcoPMH0GhI9MUoikU9QI
	YVRXPJTkzQ5h+1HeDMD5wbe+T3p8c3udW9eDdXXmKzlWURv8/nei7fqBlHlPeIWXd5S8aC
	zUGbU2tad1OKE2cIkBecy8W52fmjg3Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6666A1595;
	Tue, 12 May 2026 21:47:02 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B4A2D3F7B4;
	Tue, 12 May 2026 21:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647627; bh=qZRT11Pcv3c1+xfoRpChjOYyIamlquzWNvdlouCB9wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGn34WxtPycq4tT82I1IUAG/h7SpF+s9fFU7N/NJJ7lJQdfkJqw6iN9OQb6AnD9Lw
	 KFs0rYW+3MW2dTxrceVMe00MeR9+1xEAfsG0fsgGJwR2tkzTDRM4ampq4A1MKI6xXl
	 wU/BUJckEE0ESfiW6jr4WvKjWt/mgSRaiVRofib8=
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
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V2 08/14] arm64/mm: Route all pgtable writes via pxxval_set()
Date: Wed, 13 May 2026 10:15:41 +0530
Message-ID: <20260513044547.4128549-9-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7834A8000F
X-Stat-Signature: wbc4g6mtjgxm71bb6g5aouu57hyzf19h
X-HE-Tag: 1778647628-401057
X-HE-Meta: U2FsdGVkX19qqOnGcVpOfWSTG2kCHgUEbGUWEmgfA4PPCDzFHJnMv2+pX0ntGKvqTwmbg5baxfhzglihI3OA0hqGGj+hTGabd7MhWSwmJX1wggGw+4XM1ATxKlgOjWLxoE67dYmRjtbZ4vVdYGTJ1z1dQsepNYWr83BS6Ex19O+gTR4Mu0fwlSq2ocv4davuB0H+CGpiQsJibCqHLogO63lb/n3PxxLdgg5l3bFIEiw8sToyrD8gJB/OOGqKofC1z3Rfjvuboe7t50+n/Pyg8Bv/k4VrnssnfEZRq0k4YdcxF8f8w+CWfUPG9wxkv6g7BSlvCIDfJ0zWGi40gqQJs1kpEqCEf7b0kbNIzEKhQwYy10I/TjoaxnxsEh/IrXWA5XvlX/vnKp708zOl+fgR/FmxbDzmOSiyqmyJmgJMGa6nmMtu/zTKqHrOVpeTvOAnBadF3AkUdVyTdUJpr+R6W3ozstqEwJum9ET+lPorfsE65HNPbedIy146JKi8kwGCTMRe03NvOPeOWIfPO2CjSeNXtbQXXd+iE22/gSCxPlo4zNZU1iQsTAmZ/bvI3ajwYd/zrIup33GmSoGq5Cze0DWfsrBddB0PIudjG0Uj+uM4+QF6BRQ0uCXKRtX+5RkW1i8JeFVmw1E121mKhYR2f63xe9QOMabjooUxivNZvy8f48vaMeZzxGpjuZWw7XAn8W2lHM5r4iuMI+RaOhobaLp6dXvLLIEa/O3wjtwH0bqU4nDlylK6WH9BOAj6UlAQWkMg+8/K8126LyVNp3Umr8n1ytBeBDjZG5GrF9p5orAiBm1puAmN5lZ3gJPa/gugUiFn4GwHlkCoNFsWRPAM00taOpWEuAkghQ9FSuL3MiD6Dy590FuPS8yoO1ECthO4FBT4I6yrAU6gTl+KiQ+vhc+apy1FIsDlqVGheyjgmGM5MM9m4UKlV1G6yqXJCsKDtcXiA6V7bWy6soH+Mfe
 Hxes46zw
 Nnijm5A7xsLEGqLR5sdNdA7sC394s5lE7YLSSphSPZMCEURsy0KG6jxdN033sNuPOSNBuNQ5MhggA3Iq+/VhZ0yWXmIq9tLjhoK1BLjqaE6lXyWiOhApgu4OgMRi8V50GlLZJuSdeGGnaPxwFxJlEAZprU/+fLZ9CYsytHWMwSW45/GJD2cK0/A6ZfBLqTxUyyQTd4Q6xJHPdS/ygaxnv9XwDi6ReKE21yojnbLiCrVuq0X/mCQ5GprbtuVRdR0ODLe05e9WGjvGHHDN59Iwof+CYW4xhbxol6ZYD8ZqNxzsX89HKU1gDZhpjvbpQFT06oBOIr5FzgZrACm4lX3uoR70K7ZzcXuznyIbwlFsbIFJWxQrKI6ph6LiCZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently pxxval_set() is defined as WRITE_ONCE() but this will change for
D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
copy atomicity.

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
Changes in RFC V2:

- Renamed all ptdesc_ instances as pxxval_ instead

 arch/arm64/include/asm/pgtable.h | 11 ++++++-----
 arch/arm64/mm/mmu.c              |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 72da582e8d12..c71bb829e9f1 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 }
 
 #define pxxval_get(x)		READ_ONCE(x)
+#define pxxval_set(x, val)	WRITE_ONCE(x, val)
 
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(pmd_t *pmdp)
@@ -385,7 +386,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
 
 static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pte);
+	pxxval_set(*ptep, pte);
 }
 
 static inline void __set_pte_complete(pte_t pte)
@@ -856,7 +857,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 	}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-	WRITE_ONCE(*pmdp, pmd);
+	pxxval_set(*pmdp, pmd);
 
 	if (pmd_valid(pmd))
 		queue_pte_barriers();
@@ -921,7 +922,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		return;
 	}
 
-	WRITE_ONCE(*pudp, pud);
+	pxxval_set(*pudp, pud);
 
 	if (pud_valid(pud))
 		queue_pte_barriers();
@@ -1003,7 +1004,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
-	WRITE_ONCE(*p4dp, p4d);
+	pxxval_set(*p4dp, p4d);
 	queue_pte_barriers();
 }
 
@@ -1131,7 +1132,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 		return;
 	}
 
-	WRITE_ONCE(*pgdp, pgd);
+	pxxval_set(*pgdp, pgd);
 	queue_pte_barriers();
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7fbb2ef86cfa..6eb92d8f46be 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -76,7 +76,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 	 * writable in the kernel mapping.
 	 */
 	if (rodata_is_rw) {
-		WRITE_ONCE(*pgdp, pgd);
+		pxxval_set(*pgdp, pgd);
 		dsb(ishst);
 		isb();
 		return;
@@ -84,7 +84,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 
 	spin_lock(&swapper_pgdir_lock);
 	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
-	WRITE_ONCE(*fixmap_pgdp, pgd);
+	pxxval_set(*fixmap_pgdp, pgd);
 	/*
 	 * We need dsb(ishst) here to ensure the page-table-walker sees
 	 * our new entry before set_p?d() returns. The fixmap's
-- 
2.43.0


