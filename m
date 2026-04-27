Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1214EFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CFB6B009F; Mon, 27 Apr 2026 11:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774356B00A0; Mon, 27 Apr 2026 11:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0DB6B00A1; Mon, 27 Apr 2026 11:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9456B009F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:57:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94CC28CBA2
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:54 +0000 (UTC)
X-FDA: 84704736228.11.EE141B5
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 97461C0013
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NO3lwGkq;
	spf=pass (imf10.hostedemail.com: domain of 3VoLvaQgKCG8NeQO+TVgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VoLvaQgKCG8NeQO+TVgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DT4zvpGacxHRk/WPHA3P347efnejtMNVhL3FmZpnqUQ=;
	b=Qlqit/5nToZTbpHFDzYQWc26mBTErCPGmDKsVbnwakR8Ty3r2pK/6B2Myd+AyMx6wNoEku
	Bn+0aHQBdDSrpGeKQJ1o6xAPjJG7cKXkWL0tdin2La7fJT3M7qAai0UPayKHBOUzYGPLhz
	5HRrEXuV24DagKOB5Fo9WJHnJiuiFGc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NO3lwGkq;
	spf=pass (imf10.hostedemail.com: domain of 3VoLvaQgKCG8NeQO+TVgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VoLvaQgKCG8NeQO+TVgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304152; a=rsa-sha256;
	cv=none;
	b=rxCKwR2LjBLwvYdVyZq1gVwCsrKMnMgNbjAR8CKD4jNStK0vgz5VF+0hRe+ZDT4KBuzut3
	XP95RVSzd7lY3C0L4+lTwTwkk5nMmYmmH0rE4I1p/Eb6MQ6w/rI4dAnaBxmAANpiXr+dGD
	OPhXfnpPA+4GkR6Pekic8JxHrEmtOeA=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-486fa07f2bbso72564655e9.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304151; x=1777908951; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DT4zvpGacxHRk/WPHA3P347efnejtMNVhL3FmZpnqUQ=;
        b=NO3lwGkqmTtvETZ1zkKn292ZtWKzZch0EVieicY5lBBJHIOhKYhPInB3MENQHoDoUJ
         Ux/BsDGGNvf2fOYxsHHVEaFruYsgdj8Mxr+zf57uLXH7QsfcDF/S1lGK1cQ+xJ7+p8sg
         NbkGruH3peHAzWaf4hQ1Aj+FxS09xJdceSyQqDfcLiQpgWqD1B7JPf8N4nkD2ZHe1jxe
         9fl0ZDwbjiFnoyc2gAvnOFUW4+1mu58K5X8DgTSZMM7K3rq//WoNJszmkTrhiKFVlIap
         SY0GKpN2ZAOxqqPjbvYgX1E9AeoF5+tXxqbyN7vmgP/hjhZWeqZJld04BtpdDQK8w3Gs
         GgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304151; x=1777908951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DT4zvpGacxHRk/WPHA3P347efnejtMNVhL3FmZpnqUQ=;
        b=goSzO7pm8nXC6YhbFmN+ZCWnOe+LoBqnIPRbmePnJNShFMaa4pwJV272OU8g6M2Uvk
         s8CQRVQ9stPhoDrZdFZyb/B/yA9eCsNaV2I10qeTsCtPoRHcKpTXo8JYmtkEeiTVzQOh
         P9jZA2rRtX/m3eEHwR8lidrKDNf3XUxTQ0VNRFSaWyoJKUzAa9eICa6ExT/PLdjAEyAX
         r4G4X0/abAUzr6Q6DvnHhoFnEaYbxU5tQRmFL0D60MVWmvTVpppdwzfov3DBS+60TaFU
         tjFXmjWjgtUrzNMQkCrqeWBfKzqH+6B6jColjJM4Xw/hUCNdAbxtmsdM/U2qAWgoKj/k
         Q/6g==
X-Forwarded-Encrypted: i=1; AFNElJ+JJ1Vcxdogvaavk/quv2Ne06T8D2+NKTFMxf/ra3eozPeefJVKFg6jTDAcgl9ieqZb9jpraxz4ZQ==@kvack.org
X-Gm-Message-State: AOJu0YxJVFR3xY5wmW1Y854AYQOvR0yLoi4lC51HXkDqh57/LvS2syiQ
	+jRhgcNKd9K2b7dPlnQzvTVCDKVA/+ww3seX7Bt1v3c0NphPNrDH6cRAcqwQlxQ0eKyOE9R1ng=
	=
X-Received: from wmbdn19.prod.google.com ([2002:a05:600c:6553:b0:48a:55e6:d5c4])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:888b:b0:488:c40b:c8bf
 with SMTP id 5b1f17b1804b1-488fb73d234mr529149015e9.2.1777304150888; Mon, 27
 Apr 2026 08:35:50 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:32 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3660; i=ardb@kernel.org;
 h=from:subject; bh=5/WaFTKUieGOECS5oMgCFK1ktF6MkiLzxXcp+K6DIKQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E3/1lYfbJ77dJSXx5Ty7SW+1FL9kwrFd8h9mz9lz8
 P9LxbYTHaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAibycx/M9OuztxTuOemrh5
 3P/U/VdeN3wn/f+WxmsXu7Ztgtv4VhYz/HfpvK1unhEare1hsj3hZmaG3YWulTsrSjxvCd3xnTH xNxMA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-32-ardb+git@google.com>
Subject: [PATCH v4 15/15] arm64: mm: Remap linear aliases of the fixmap page
 tables read-only
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 97461C0013
X-Stat-Signature: kt4az6bmzmarzxcfi8dbtyru198sdgnj
X-HE-Tag: 1777304152-538474
X-HE-Meta: U2FsdGVkX1/sPctF6El/nGWz+vtn56b9ZiSs8O87uVCrmu5cU/YUo+S0/Ao+eYSTPoWCfzKVI5wor73imodHUuaFtv2KryPgSaSKxdrA6G2KybrR93kTb0DYLjw7xyatydl5vVJDV4m75mwGDthb3jt/jVZGWaqGs894N7+hTy51Zqubr1ckKWluDqz0/IhxWTrI4hMMcTbv0VeRWBjY+s+sSVHBCIKAeFlbalFTGFt8CK2mHyZwTbL0GOFXvjDnsAjUYX7n3lz7PRP/Gr6QEbF0davLmb0ZxZwsfPWubCqaNWdFTim/wZLk3ChyUYvhwIjsk95CsJsIopn9iUyjm8oK2dspJ+oy2v/VZF6w4TCzmvW1cGruF7PgLtQHTYvPFHq/+Eju0L2rANLAXAKn+KZIYgIQzFre9C0z1fXD+If4zEDPIBIC7dtxc2h15PmtYB+rp8f2G1H36E9I1NbClVcn2ynd5K4qIy6rvR/C3imPAc0sjnIucIU4gLso6ClgaH9c6T8AVQ022WPMLVdtIxcuXgXVjPnq5vU0UFEON30AmlXfq3jb8SLrspNm0cSTszctrjiiXcABOJkIM+2VdMD15TI7+1Sp76FTflqmP6w0QkNtYqjzSlBMjSHZlu6Ns5yOnQ1VKoyTsi57bx2Fq3aXZPNsGZgFcyPA8prv7VuBaQCaO7kvgq57rrW3Q0NCs5XtKyLwLH9rKgufVvsnVApT6hGsNssdiEdB9mFijOFyVkOlf83DC1ebM5VgzXibn5nRLcG+RuL8iXgsCjUx5A9qiCEHEtDfmxJWkfD4411fRxWY+PqcX4LN0VpW7VdEpdrC9HYdBifZjnkqbE7kECHVHMTjL9DHBR82EJGvxKRlk7Z/lBrEVDNCcv8GRpAFDwJsvcaP/vhnjQTyDOQ1B9M4T+IYEoKK2UBAPArWJPinEWVLkv+hXACErHro/+LdZhPrrQGxFeHqxOtSzye
 fLz+qdRl
 76VSTz8o8OmGxKOZ7efUWF3HpBOhO4TgrVC4Ta5PSm40IACOYH4uTQC6nL34u3RdImqO5iRtQo1qBPS1IMtyv3ZVyyp9vwk7s5/WMmEQicESbCmo5JkEy3/IZDPQm0M3NpchJ+5CLDVe4qcYLcajZnoD9Z9KSHzH6UwEidn0dzVdhpXZvD1UpmoCFZzCcSeiLkJE3TBr2GnjorkjXfp+maNdGZum6RMwc3H8db9ZEA4tSMGe7C1OebvlkS4wuZvPBVNZiYnGznIbMmb2/aZXWOoZMJnSm2ABPOdi7d/oW0aMPDv6DvmoZIphQUjv9pRw57AgW+Y3TL625K1rpmiuYgI2umb9or8TMdkLAGITmfR/itDeG3JdppJvPG4MLuUU10ppzNjIB5AW6Bi/gSJF8RAOcHMSIYNI+PCQSFd21isWsGl+YZ/iNmccp8TTimMiQvKDEEv+BsS9PszCpJVP0d5/FTOXgJcBU+vhpqUjU3BihXTDpMoTWxaE5FBPP3h/ueObx+F3M+hpq9TooZobTcymFD3wfPKwXKEPX2DXAyVrsDI59EWydbupRmvM22PeuR06F7KLbRKynAp+76HG2XIIck78h5gq8OpxUNE91t9odjIPuC/sZVtcj6mKpdkE370CmMe6AlLrpmRVPfJ4tYq/+Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The fixmap page tables are statically allocated, and are currently
mapped read-write both in the kernel mapping as well as its linear
alias. Due to lack of randomization of the linear map, these tables will
appear at a priori known offsets in the virtual address space when
booting without physical randomization, which means that a single kernel
write primitive is sufficient for an attacker to map memory of their own
choosing with any permissions at a known virtual address in the kernel's
address space.

To harden against this, move the fixmap PUD and PMD tables to
.pgdir_rodata, so that both their kernel mappings as well as their
linear aliases are mapped read-only during ordinary execution.
The PTE table needs to remain read-write accessible via the kernel
mapping, but its linear alias can be remapped read-only as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 6 ++++--
 arch/arm64/kernel/vmlinux.lds.S  | 1 +
 arch/arm64/mm/fixmap.c           | 5 +++--
 arch/arm64/mm/mmu.c              | 5 +++++
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 94235dd428be..21afe923cd71 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -822,8 +822,10 @@ extern void set_rodata_pte(pte_t *ptep, pte_t pte);
 
 static inline bool in_pgdir_rodata(void *addr)
 {
-	return addr >= (void *)__pgdir_rodata_start &&
-	       addr < (void *)__pgdir_rodata_end;
+	phys_addr_t pa = __pa_nodebug(addr);
+
+	return pa >= __pa_symbol_nodebug(__pgdir_rodata_start) &&
+	       pa < __pa_symbol_nodebug(__pgdir_rodata_end);
 }
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index e5e1d0fd7f27..9b346dd24d1c 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -247,6 +247,7 @@ SECTIONS
 		__pgdir_rodata_start = .;
 		swapper_pg_dir = .;
 		. += PAGE_SIZE;
+		*(.fixmap_rodata)
 		__pgdir_rodata_end = .;
 	}
 
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index b649ea1a46e4..ad6d46e5c23e 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -32,9 +32,10 @@ static_assert(NR_BM_PMD_TABLES == 1);
 #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
 
 #define __fixmap_bss	__section(".fixmap_bss") __aligned(PAGE_SIZE)
+#define __fixmap_rodata	__section(".fixmap_rodata") __aligned(PAGE_SIZE)
 static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __fixmap_bss;
-static pmd_t bm_pmd[PTRS_PER_PMD] __fixmap_bss __maybe_unused;
-static pud_t bm_pud[PTRS_PER_PUD] __fixmap_bss __maybe_unused;
+static pmd_t bm_pmd[PTRS_PER_PMD] __fixmap_rodata __maybe_unused;
+static pud_t bm_pud[PTRS_PER_PUD] __fixmap_rodata __maybe_unused;
 
 static inline pte_t *fixmap_pte(unsigned long addr)
 {
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 84d81bae07a7..e76fe5b0c5fe 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1076,6 +1076,11 @@ void __init mark_linear_text_alias_ro(void)
 			    (unsigned long)__init_begin - (unsigned long)_text,
 			    pgprot_tagged(PAGE_KERNEL_RO));
 
+	/* Map the fixmap PTE table at __fixmap_pgdir_start R/O in linear map too */
+	update_mapping_prot(__pa_symbol(__fixmap_pgdir_start),
+			    (unsigned long)lm_alias(__fixmap_pgdir_start),
+			    PAGE_SIZE, pgprot_tagged(PAGE_KERNEL_RO));
+
 	remap_linear_data_alias(true);
 
 	if (IS_ENABLED(CONFIG_HIBERNATION)) {
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


