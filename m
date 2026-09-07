Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76151C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901A86B0096; Sun,  6 Sep 2026 23:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8C96B0098; Sun,  6 Sep 2026 23:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816006B00A5; Sun,  6 Sep 2026 23:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F60A6B0096
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:51:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F28944061C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:59 +0000 (UTC)
X-FDA: 85185590238.20.750D6B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3FE76C000D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gaU3xvQi;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWP9N7UB0joQXAJLUFHQKyDNGwC6LUah/EGUNqPDYTY=;
	b=ihS6PkoAClgig8flymUKsph5QgRfggxhCpYLaroTCqdhdRN0h011aXpR05b3GV6QboJCht
	WGQ8xncsOtn6saGFzvkwWg6ulFzZn8tnX99IAIMTNn77gw0ce9G8rd22Gfvjdl55P06JVb
	X/3wWlh2qUmlFuzQQ9E4ymIAwf1EBe0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753058;
	b=PCnwhG6sxDLotLP7RVmZIACvFaF5mReTCVWIBfWjVDI3Y/cAJqiZz1EF0X5UKUqpBFF9VB
	2JmPA5u00hV559XZRd1J/pRPqs5H9lSoGM6QDQtxlFw/j3jrUrgOsMN3mk5l/cPz7pWeaO
	FoiVWd/IJu2GmF7IbFE/8OYawG8TiDA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gaU3xvQi;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA7631AED;
	Sun,  6 Sep 2026 20:50:53 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A13643F7B4;
	Sun,  6 Sep 2026 20:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753057; bh=qFNA6gQd3R3/N1F2NlRNUpaGJ73aKIkK2svQU86ktVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaU3xvQiDu0CvOWTMdlZQxYVQh/R/CHFyGgjq84fexhBOg1L9rxB+4w8ipcOCDa1Z
	 E2Cs2eyqqBmiDulIGwNs832s30G8mh9bsgmEeCfvO6JqFbe7FWVnXIuS+NfF1Ekr8J
	 yuvc0+cRZZKX6wwRSyT/+18yuMQL5X7/LgDl8Vkg=
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
Subject: [PATCH V2 06/14] arm64/mm: Enable fixmap with 5 level page table
Date: Mon,  7 Sep 2026 09:20:21 +0530
Message-ID: <20260907035030.2839978-7-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3FE76C000D
X-Stat-Signature: njghyybktjyzb6qrdnjefppx6psmdi33
X-HE-Tag: 1788753058-433162
X-HE-Meta: U2FsdGVkX19RcJ778+nyALMtT3DxAKGC1hbzuzt6T5UPRFpDaiKCLOCZJQkpPVfHujQNZebobogSAKALcFH451znm6vGJjeLNA/uwYIGjR4ewqvw3AMHrNDSJSSpJRw1Yexjqy3tBawgcc62lh4BFmYPEgsEVVIUg8TXfXJlxAyf6a0htJxNwQyjbuJ7DlVq3ccVSSHKdwfcBJCBFrfPp2GVFvQT06TQpBjIEHJwqX0kug7Phr9/cFi2h2MZyB/Cq8pr9lKyfcTaNoRpM+pzC2VFKfjK0Ay48mA1xiBAJOL/puZJkPfbXr8JH0D+6Snk9Pd0WRA/T/Am0cHYVXa8F1rFfwDm/fsNoRXtk7ETrqRjfTe4bgcFiRmqW+EfU3h4WiQxnxYSGHftBtZ9wRccG8fXFhvh6i4q2JGKSvK+v7zJN3QRzDL8WroGUbBsM1J8rgT8JsGK5BZHAYU5TxPRc5vG9AuHx9abRqeC69f7hl/rFMkpd+toWfhqNL4Zia71Wov2hIiKrk9OJvB9iVRY6G8aKd1IQcRJ7niFPHERAGenzpSJsQTccmZpIMInz5hU7WA3IwXibaSh4BpcE6hSMwrxqzumxr7DVBZO5WFVXc4bFtKht+SzJAYf3DKrg8/Cu3IG1Qg4xBs3y+xOIgxGItpCI4IkuaHMBg24hy9eJMCVwSo8rbeNIhzTTr0rErO5ic2EwTHmYRBjzBA8hNRsM+sPjAnYHBaSuBseBgjQhM7ijwoJETIhNsK8XtBF35vSMY6Punwf9iSy1qB0OjnbUe12rpjgztAdlcvO5Jo5LCpxUQnn08s28MdRZ3jPKgZFLfmhQ4cSiopUnmUzrpAxPvjBsWMvmxXCipmb0bZqVm3b5GcUywjvJpD5TD7rmZuhf3oyg65wkRdC9OklO86Lkpxyns0NYGsLNpuwr5Eyx6Yr/uIkIYDKbPx1yGYfKzjIVI2M6kL/BkFxWsTpIB0
 IrHFnB+h
 PzlGQHqpGIgTk0XIfMn+0ghZ9/YDgvz0TlAeVAZw7QWgRvoyevzfyw1DohmQDiyrUPEGBOFiCZYBxzN+nqpbseF0YzQd4yeIT13Ot+sD1/bslEM0uHCcNZQLGSZHOomNsjr9Hwhz0GfXLV0FdD280LhjtxU3MdPSfTYLPhod6PXIafMHrrf7Aqk/kYp83ZZ1OSWGiAwbPp4k+sFmdk1e+CpWcGRIZ0qqoIJGAk2M+OU6fE/NjPGHu9abX2RneOYY2sky1TJdSg8Ms4O0b1wJw41I/yD5Y3n1BwdJZPD6jBgooqg75d0bE+l/rq1nlCaM4zD15+hJVWwLhlDm8IUEkkFmkrl6MAlbK+1ltJmxH9mlYvvc0q+druSHueQ==
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
index 2b457db19be0..7a5d6a14bb52 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1178,6 +1178,7 @@ static inline p4d_t *p4d_offset_kimg(pgd_t *pgdp, u64 addr)
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


