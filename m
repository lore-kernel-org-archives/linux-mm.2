Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0891DC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865776B013B; Wed, 29 Jul 2026 10:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8165F6B013F; Wed, 29 Jul 2026 10:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C5D6B0140; Wed, 29 Jul 2026 10:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 421D96B013B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:52:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 41B071A068A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:57 +0000 (UTC)
X-FDA: 85041735954.25.54224A4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9EA64C0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qKHgKtfE;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQHso/JzAJHB+mUMiNahuVksEBOkpZJkGve+VReLNEQ=;
	b=b0JH5TtNkWo85z4Te0cSmJWPTBhdFs2uJ1pVgOOnI4UlmdMi0Huq4fjgC85g2LXTF4Tb/3
	HiQBh7uArGn2v6s26sX30PAbceJrC3e+h1J4W27wJOnzEi2zRelyYSDPL2UvbCXpPhXSYp
	wP5m3paF+1qhTVXORmRt9qf/abWnE9M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327955;
	b=kUT3U4ePzXY+xZ51V+z1bm/CyjKVFqcfJxQzgH0I4lHG431mkkiPHpul+uyXpBoSG7OIT4
	jRAhlT351TKtW/lj3s1F6JNHPEO93iKqJ6pNtdDfRAGkKuwJvouEdpX7G7JhN1yg3hwJA3
	wYZxEN+CMfBdTzzPjMgYzY4YIbT2r24=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qKHgKtfE;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEBF31688;
	Wed, 29 Jul 2026 05:25:50 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 341423F66F;
	Wed, 29 Jul 2026 05:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327954; bh=ZSU1qD/xdKoUglWGdMm1G3OWTBhkOp/K5aayHoi+YUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKHgKtfEJ0/ufKbFIh+X8HztvsiUuDvew2Ymb3Tnzga1Dmz6p1EkcNK4ggFUPjzhX
	 xgokij30w9ldYZCcemBYhwOILeib4Q5bjE7fBXk/OkuPsscSvAoEDhehJhYh0AKZiz
	 vY1H3YjiuHf7bZoBCkpd44vgOkvAkLQ+eLr9fWdk=
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
Subject: [PATCH 11/17] arm64/mm: Enable fixmap with 5 level page table
Date: Wed, 29 Jul 2026 17:54:46 +0530
Message-ID: <20260729122452.3797443-12-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9EA64C0002
X-Stat-Signature: w1tb6wj58sa8pz5i5jng8y1kq4trb59d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785327955-32069
X-HE-Meta: U2FsdGVkX1+6yx1A7g99QNuzmGGGRNcjzHXY/2gHRUIMp3G/AJJeEPjbHfrr8MbPaurEEvE/+bqGfrSmzdVjzuNrWT1aFKHT4ks57Jfki/qe5IL1pxoGyfjjDQVjbNJiCZ5zAQWQCtkG0pYYGjRVPOhplL/kljmbduAWgYsP4aQVRmijiXAXNafrgeDLS+l4Yz6/GFaycsKo26+Ya6MTo91vhWAL4KdiTldA4gQkTULpY4zi883Sq+vtoRP9F9RHWbe30GvpHLy/ViVSVkixBiovprBeuHcp6Tgs0izwf3j5nwUQcTbx20VE3t4N32aYSlwxvv0Ohze59utHznZ6Q81U9jUE2Uku3CTC8vCDWTJD1vvbheSlkvfSfJu3HCwuRiL1B+CHMZ0b0yBLrxnoGCurrHpBp42rOiLuDkgPINX2FXOgikDB6V7WNc3OvyACx20N43z/D95tGGHpc21YUgaTJX42QXVCquhGuvrsH4lFiD6lbhMj3+wCZu9M+L+d+0ZAG60omCX//jvE1tDOmZwkVO4Ubi5FHVboV2gyUCgFh6E7AUlbEWkJJsQYKn44aRQB+Y7H/iStG7wbiP2Mc2X500k0yNCZ7kHXF3y7RE7WRY8hwh45/e+xupDmxzfEO1VKkSPuLe+W5raWOBpYqzzRPC7CkfPHWpNeSfMMZz6UCjwzoorenF/Q+YNJ5lB3kJknrPWrMlrM1NdcShVj6/G4hqYO8LoNRGqEYF85uY+iUVd32I+JQNhBYGx6lWnlU9bN8r1KO4yJRwMEEtQm374MaBJAqRk/ur4XBv93jVVXENBTs4ecnAU/Hhw6DxnxX1hcQ2rRKZv1S3BcMM9Yh7QK80yYwycS8b8Hc5ew0csLa5pxaS70jZYLYdRAH9yajdS4pROAkJ0FSvjShXOEGiJdTZLZAqmhdfCVfzaKQ52nBGHFYL/qhLssTpNi6uF5PPJLxbS0Mr1oqldK/Sp
 GWShXoYU
 VJAart5c8dZj9Fcs0oF0BNlzPBOZiLL4st2NoRdnzxlmzMbMamqSpwcA+JaeBjlafMLT2QH0tIZFAEv4bYGCZKuB3Rb8tg10+3DUBABP8Gu9bs36ZuO+RvOAnIgw1KhuONL1rfq49/0aEBIFaKo52AfrNTObV1xTMy7rTx+JuV1HverbZeQWJAQ2OAF2DUIELcvQhWHAkOjJNq/kuqrLtLO2SobmHR1R0hvARKKfGHfKmKZqHUW0EUNtBtz28s1WwzcVSQb5oDpIJ5hKdPJpjf+v6fyYqKSH5B5vx/e4Mf7tISY0lUC80uRqizdK3FPj8un28PttQzp7aCFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FEAT_D128 halves PTRS_PER_PXX thus shrinking the VA range coverage
for each page table level. Hence in order to preserve all existing
VA range configurations, some geometry now need to become 5-level.

Since fixmap is used to build and manipulate page tables early on
during boot the mapping must also gain that additional level which
was not required earlier.

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
index 2270a3e4cc13..50d673474f47 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1232,6 +1232,7 @@ static inline p4d_t *p4d_offset_kimg(pgd_t *pgdp, u64 addr)
 #else
 
 static inline bool pgtable_l5_enabled(void) { return false; }
+#define pgd_page_paddr(pgd)	({ BUILD_BUG(); 0; })
 
 #define p4d_index(addr)		(((addr) >> P4D_SHIFT) & (PTRS_PER_P4D - 1))
 
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index 2a0fe0b0f771..5512521fef8f 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -34,6 +34,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
 static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
 static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
 static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
+static p4d_t bm_p4d[PTRS_PER_P4D] __bss_pgtbl __maybe_unused;
 
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


