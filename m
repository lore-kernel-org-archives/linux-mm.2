Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378D4EFB7FA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92ACA6B00AC; Tue, 24 Feb 2026 00:13:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E84C6B00AD; Tue, 24 Feb 2026 00:13:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821DE6B00AE; Tue, 24 Feb 2026 00:13:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1F06B00AC
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:13:37 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 258EF1B66C7
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:37 +0000 (UTC)
X-FDA: 84478182474.15.AB115DB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id B1F504000F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771910015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/iOanRqAvmBZ6t7e5+d2gSDFoEw2c/cmC+d03palG3s=;
	b=nqrJPAt2M8BgokPFtF0BvpGXhuXMUv9Vcbg4nBFuISblegtbDzszZV51TODrLLzQRirNDl
	ChAUcjYyQl4zJZqml9/XKlsOVYIMa/wgyD31BwDDJD1VknSYc8urTjKolvhiwhbO1szubi
	rXFgWaqcQiMET93kpSpOFbIkrf72wVs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771910015; a=rsa-sha256;
	cv=none;
	b=dYg9K787lQT8jQX9dsIH6qhRIHMuGLprGofZvtS5jdTugg5Tmxd8/2N90jlUtdeYrAzb3z
	uY51euZtbiL7k2pNJf++WbbibxeywuWFzEAJ0V3dGshU40wfxKcrkgMfFifXxQZfW2yV+u
	8WQtBYPfdjCZic/U6L2ZHdP8MUKbyEs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0077497;
	Mon, 23 Feb 2026 21:13:28 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CC3BE3F7BD;
	Mon, 23 Feb 2026 21:13:30 -0800 (PST)
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
Subject: [RFC V1 14/16] arm64/mm: Enable fixmap with 5 level page table
Date: Tue, 24 Feb 2026 10:41:51 +0530
Message-ID: <20260224051153.3150613-15-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bmxeciq8hgyoymdro4otanffzyw39efk
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: B1F504000F
X-HE-Tag: 1771910015-88409
X-HE-Meta: U2FsdGVkX18TjDK/wjJIv5+MovSAaNDIpCOhft6vbCJTXTAwvSDPNcDq0gWRNy8hIAtMz5TRuYszetxK2pavuZXGCEsgjEhURRZj0DhGik/Xkz750bqKK1ZmvMILz8Q2YMXfHEtVaCl9Bt9wjlHDdUNW8jrIe/ijkn1bg2NMbQHFGHYmltHDMGEjFcDDkTeIGDsi9wLB1NaaWu4SfRLbaUA6Skqy/axeVWO5rKFO5dMDKRpPYmo2Qbk6KOKXywKY6ElVTtIXzXjMtrKFqcpaMqngIiRWplfIcTGV6Mu84XGXOBmCrEbj7o5jivmLIOuyBeGOrXmSkcRs4Tt4ZK4hdc4DnPqhZ507CCmw/QN7SGvZdaNEuhjV3RPh9/pkd7EYapb+d7fSAgv7wnIROm2Mh3bpGbs0W+suhkmrbjFH1OsCKi6CzMKVtzN2JGEtUOQtYX0b2xP+B9SYkO87jYIAPgWqpHbdGt6xKeSjxd+gQn0qBUPWrgvyjNWMkskYe9iKgBlJGgqHUVITnzQTjr4bD7V7+KChLXRIfXGqwKFiwdLSUOWZycHoHiKIXcxZAJhA6AHVAl3aaGYYzY9JlBO3UjDB+gO329L9XuXQmquOmbdmIkAm2uviqdxxjhXT8wjD/347I5Od88IoZFRdqf9nycmelXMoFmsxCgzKdADeinGC32p1WJt/xB9r+cWjkTauJ2XLssZuSySx6NOP01+nzODbcXrlbT5zqebtxpS8rsKrhw8Pv6O5aJUPh23PkQKZbvdrlnozYaN9hWUytpagvr84KNQ5Jgq6RvA1LHUT9a0dT/2ilF0uw7Rkff4v4BTh/DaaLWbkJjMpE7yHhofLrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable fixmap with 5 level page table when required. This creates table
entries at the PGD level. Add a fallback stub for pgd_page_paddr() when
(PGTBALE_LEVELS <= 4) which helps in intercepting any unintended usage.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h |  1 +
 arch/arm64/mm/fixmap.c           | 18 +++++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b39d3d3c5dfc..0f262a97e320 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1215,6 +1215,7 @@ static inline p4d_t *p4d_offset_kimg(pgd_t *pgdp, u64 addr)
 #else
 
 static inline bool pgtable_l5_enabled(void) { return false; }
+#define pgd_page_paddr(pgd)	({ BUILD_BUG(); 0; })
 
 #define p4d_index(addr)		(((addr) >> P4D_SHIFT) & (PTRS_PER_P4D - 1))
 
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index 4c2f71929777..d6209aff31d0 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -34,6 +34,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
 static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __page_aligned_bss;
 static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss __maybe_unused;
 static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss __maybe_unused;
+static p4d_t bm_p4d[PTRS_PER_P4D] __page_aligned_bss __maybe_unused;
 
 static inline pte_t *fixmap_pte(unsigned long addr)
 {
@@ -95,6 +96,19 @@ static void __init early_fixmap_init_pud(p4d_t *p4dp, unsigned long addr,
 	early_fixmap_init_pmd(pudp, addr, end);
 }
 
+static void __init early_fixmap_init_p4d(pgd_t *pgdp, unsigned long addr,
+					 unsigned long end)
+{
+	pgd_t pgd = pgdp_get(pgdp);
+	p4d_t *p4dp;
+
+	if (pgd_none(pgd))
+		__pgd_populate(pgdp, __pa_symbol(bm_p4d),
+			       PGD_TYPE_TABLE | PGD_TABLE_AF);
+	p4dp = p4d_offset_kimg(pgdp, addr);
+	early_fixmap_init_pud(p4dp, addr, end);
+}
+
 /*
  * The p*d_populate functions call virt_to_phys implicitly so they can't be used
  * directly on kernel symbols (bm_p*d). This function is called too early to use
@@ -107,9 +121,7 @@ void __init early_fixmap_init(void)
 	unsigned long end = FIXADDR_TOP;
 
 	pgd_t *pgdp = pgd_offset_k(addr);
-	p4d_t *p4dp = p4d_offset_kimg(pgdp, addr);
-
-	early_fixmap_init_pud(p4dp, addr, end);
+	early_fixmap_init_p4d(pgdp, addr, end);
 }
 
 /*
-- 
2.43.0


