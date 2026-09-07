Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71F29C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2984D6B00A0; Sun,  6 Sep 2026 23:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248646B00A1; Sun,  6 Sep 2026 23:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C25A6B00A2; Sun,  6 Sep 2026 23:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB1F26B00A0
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:50:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72CCBC061F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:48 +0000 (UTC)
X-FDA: 85185589776.02.C021FCB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD21E40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="FY/dl/yz";
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Gff50M7zYdscsWYfsnsm1wAFaMMgxQOx/NawG0OhdA=;
	b=AHaI8A2Yg0w4AH6EFqUWSbZzI06jUnxwuu6LQqfP8Ex+qLyW8XXd9LVbBThlAEgW3Pd7Z8
	eKnjkftAi7cYnCsbl8VEOLCGbUfYx61nP/MmVrk/E/0sLrCEbTXVd7aRpLyH5WTPXAf5u0
	ofs3Myt1GpeaddoVhVR+JWlEd5ajHZc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="FY/dl/yz";
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753046;
	b=7oPrURAbmnu7T/EU6XELP7fDYkYORmToqTIeFg7T+9/zCTiCwPOw/zpvEiFPWFEbEQtgEB
	/Z8NNk4HDFaCM0HYXauUna6p2souYYv/w4Uqe6WNEr3ztlJDuZxmR0h7/KQdQTXoQ2Of4a
	cHT4C8PgDsLRXMuOVwwUBWsZJv/j/Bw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 397EC1477;
	Sun,  6 Sep 2026 20:50:42 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2FA7E3F7B4;
	Sun,  6 Sep 2026 20:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753045; bh=mxuT7trp1ApTgSVX4oHgcsRIN1m6b9BgozIHOrKR1EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FY/dl/yzk9KpGi6X+UbeUc4pMhX7cBqWiiGAe7E7rqPNhPI2JJmNjvO4oJOoANJwi
	 e4/vDeO1cADKeq983cahV1Vwor9bXY8kPPJOPael7133LRm23AJ2le9iagrrKEuS4P
	 J7Rt3c7sXHcfdFyA34V4X+bqRHvRLaq+iDaMtY14=
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
Subject: [PATCH V2 03/14] arm64/mm: Route all pgtable writes via ptval_set()
Date: Mon,  7 Sep 2026 09:20:18 +0530
Message-ID: <20260907035030.2839978-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mbpjwrk8uz5jredwkikpj9oacu7i7te3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD21E40006
X-Rspam-User: 
X-HE-Tag: 1788753046-992315
X-HE-Meta: U2FsdGVkX1/4paBlUVgCRMs1evpTyOXpnzDFAN81yRkuHR4FAc3G6gcmxInVl6yccpqR11kSpxoYFPqw7S5mQJlVtsf6y0ZLu5yVR736BPmgxzNFw7qHkht4WNHj1zsqbMNuixfIc+8zqxS4slRNE681NaVpXYfUKGwwuPXm7JuqpL8erHCdzql2U1ZMtJvGlqwiPXUxFalTT9J3mvV0sjQnSBPw9tqXwVLIqFq6QXXW2nY6iKPicbQ5k154fOuhuvkJyuYeCLIKrjp3/Gay62As50w+PT0XurDAR+nhjIS8HnfnDx/ByYR0Bz6bYObuixfnX2Ulfv+EroA2ZsFFML+il8mH5PVxxHLdeA/8nxYVJb4mTIxM6N+e+nV/YZXR4D3/rv+3qBhBh5bVA7L1tD/VsfGDz+YgHoc9oJqnsqMoA0li56FsM4dP0fNVkDc2R8jWrxgC+eq0I1VQcr8jm1BGIsow89KHYxXOn0wRm5GsLfj/ZNXYCoIFaGFIIQPDzS+kvzepn9654rnn8Zr6lqxj8BvgPpSjaw22tJNe+t2+9j+VOi/dqa5myVjNZCfNV04DriKEMfqJhx+wEbJRfuW2jcav19OQusPGeEZAZbcrZ+HsJz86LUescMjaTKLuxo4p+l4355v8pqXvFyRa6BWHL5GnTk44ZI/oBUWHs9lQEroIHfQZYefco9ScDF8G1806YUz/10MVvZTk4QG+1ARwwWgAdykkZt0Wj9jHGGe1HE7sxrVLYmrR6CJHO29eUKz35rFEzy6A7kAUJfNXovkLiWIs+kD/KgTwhkKDRvnm25sSfd1HzW4vHaVer1DtA8VJ7OgG7vGZTr+d8jGTa3IbF8Ql6tdjC2rn8a3/UURaX3QS/48mYWte8Dteo0rlYcSp/wUjwF+d8I+L5P+sw7xDkU8cr0ASf74mmn1RA1aJeb3qhCDgkHykYRaERCeUSL7S5dmExcgG2rz/NSB
 z31foG2I
 Ix3W63uLz2e1cMNErZTWysvkUQ6UQmGafcaVIV4DnI4jNLfJXZ2X6JnVCDdhO6I2hqnAU1kw8ZQmqqxvorTTt4X3g/cgzXGE+PAXhCMuyhAx9GKPLZHfD59FiiidWRoJlwIXsIAPInB4buXfUyINBaymNlrNfnyph06SjiKxOZouLrXZYtwyLJGOKsWWgiZnxJautPR9vZfxvpjadoykcBhu9fGaACgY3OirvbwaM+jrTTdgnqjHF5utRziImiPYHDdktvez7pGJe6VcRUYfv8ayW0TX74hejMrevV46Aqv4Zv7soRQtgbHyv6ICcleoNs5omrByGMe3nHabCICJu42b5JSx8XAnYh0oPIcQT2Ajj9MQ0Atll2SKpSkIjxXFnEkckX/IJH4f+hvrb0HvBfOms3JZ3RkZDGMiNHrTFx0GUQss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently ptval_set() is defined as WRITE_ONCE() but this will change for
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
 arch/arm64/include/asm/pgtable.h | 11 ++++++-----
 arch/arm64/mm/mmu.c              |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f764132ca34e..692669ea2d29 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 }
 
 #define ptval_get(x)		READ_ONCE(x)
+#define ptval_set(x, val)	WRITE_ONCE(x, val)
 
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(pmd_t *pmdp)
@@ -386,7 +387,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
 
 static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pte);
+	ptval_set(*ptep, pte);
 }
 
 static inline void __set_pte_complete(pte_t pte)
@@ -809,7 +810,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 	}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-	WRITE_ONCE(*pmdp, pmd);
+	ptval_set(*pmdp, pmd);
 
 	if (pmd_valid(pmd))
 		queue_pte_barriers();
@@ -871,7 +872,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		return;
 	}
 
-	WRITE_ONCE(*pudp, pud);
+	ptval_set(*pudp, pud);
 
 	if (pud_valid(pud))
 		queue_pte_barriers();
@@ -950,7 +951,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
-	WRITE_ONCE(*p4dp, p4d);
+	ptval_set(*p4dp, p4d);
 	queue_pte_barriers();
 }
 
@@ -1075,7 +1076,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 		return;
 	}
 
-	WRITE_ONCE(*pgdp, pgd);
+	ptval_set(*pgdp, pgd);
 	queue_pte_barriers();
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 46ff9a92e73a..44af53dc9ba8 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -75,7 +75,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 	 * writable in the kernel mapping.
 	 */
 	if (rodata_is_rw) {
-		WRITE_ONCE(*pgdp, pgd);
+		ptval_set(*pgdp, pgd);
 		dsb(ishst);
 		isb();
 		return;
@@ -83,7 +83,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 
 	spin_lock(&swapper_pgdir_lock);
 	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
-	WRITE_ONCE(*fixmap_pgdp, pgd);
+	ptval_set(*fixmap_pgdp, pgd);
 	/*
 	 * We need dsb(ishst) here to ensure the page-table-walker sees
 	 * our new entry before set_p?d() returns. The fixmap's
-- 
2.43.0


