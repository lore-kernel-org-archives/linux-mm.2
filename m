Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A18EC624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3066B00D1; Thu,  3 Sep 2026 05:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAC56B00D2; Thu,  3 Sep 2026 05:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA7C6B00D3; Thu,  3 Sep 2026 05:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2B16B00D1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:29:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E52CD120470
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:39 +0000 (UTC)
X-FDA: 85171928478.15.AFF6E1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 37008140007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyx41bCy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVNYAsUg3Uzsw7ua/7010sgVgW9MJba5r2WRrq69ciI=;
	b=3kWBuz8Cn7ceGOmE2aNrqpFwAqPUoghJXuTq61AeNdVhy+FWkzTmjsX9EfOrymoHDYuNtw
	RWC/q38mZnALm4pi0uWSopsXqvshX78kgIDdGo4FvqIu7ZfpV2YnByjUPdMOINIRpJFoK1
	/RylpTUPMHPQrowyhPMtGRbvcOLQ/1E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyx41bCy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427778;
	b=McX2MvChw3XOTjKpB9jBWQoPaKPDq20+P3BIs8c0QuQEmAckVggNTF+unJW5NkvR+IZL5z
	IoCcicbwRhKgG/jFfRgYJjyRfRGAWwXVm9RHhn6JTvS7cXJI02X0jQyvggDZNvX1kJsUO/
	0ZEAGdepbfl3ck0vgv6HHVjhMCdqvIg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BE6E41FCA;
	Thu,  3 Sep 2026 09:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3211F000E9;
	Thu,  3 Sep 2026 09:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788427777;
	bh=hVNYAsUg3Uzsw7ua/7010sgVgW9MJba5r2WRrq69ciI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iyx41bCy5dQ4LSeFNP+EncH+yzkWTUkTPAroL8i6hF89wyjNLH51ihhyLVZSqDdkt
	 IvNX4CGSXdgjtpkQiSWLRlFJKOfY6uPhBeRWjJLNTQxv7Vy9DliMl6L4G+gSO/8bZ0
	 HYXjTfiU6oR9z5tq8Bkb/5fLlnOy+m5f+w8cxUaX77eCl5KTmBDUxrp1iIrF57H2RB
	 KrAunxsylBBDWR/0sAstDnjzER1/D9UVeck2aFe0q0+3LEQOqXrZHNJ0OiA+N3nFoc
	 aF+fGkstZDs2r+rErVCTiyRFIURVeeDuyFNAhuJsx5j+QEyxRwOUPNR7hxg8BL1mI/
	 dXgYLX3nmANDw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 12:28:32 +0300
Subject: [PATCH v3 6/6] Revert "arch: introduce
 set_direct_map_valid_noflush()"
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-set-vm-perms-v0-2-v3-6-949b64a9f755@kernel.org>
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, 
 Will Deacon <will@kernel.org>, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 loongarch@lists.linux.dev
X-Mailer: b4 0.17-dev
X-Stat-Signature: jeiu7r9b7aqm3y94kpjuddk9aq6acowu
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37008140007
X-Rspam-User: 
X-HE-Tag: 1788427778-954380
X-HE-Meta: U2FsdGVkX1/HW4o4kRLGjZcPqtl6gMpYRQYojPuew1jGUpYltJ6GyXwSD6n6lv4WWmvbZymsBlXoA9p8e7Cr/IiYyj1vHtXbBooQr1+mimPbzmhTksKqdr00iKSnlz04fp4RByafTQXvSSNSNpUpRGdgUePcHqPYXt5KHjkth9i442NNywmykXy6uMTMqGVeVBr9PTaSC0L6EfYgb+ulPQ5lnAXL1wmVnBo6tcli2cZD2+9q9StgA4K0d4VHqF14hLCxWRTzdWMW53/xhUpC6hcwg35t0v2UyccRrHBLbzltVhEU5LRvOtMqSdVOH7Meed6jLx+2dgLA/i86+GIfLEj2W0kGL27a/1591W7kYbUiiCh7TrnEtZnsugSg5bgTLiyQBfJmvmkpkiA4BuE/wlLom8XfuaIsj71eINyoAO6Vdcg+s0xX96y0DHX/Iz4pnV8fi7f8F0/Yr+ZhQj6xPVsLQJzIMxUqcxneq35AkrgjHZggMT60V/TOD/hiQOukDvs3z8ZD1Xa6Kd/qzlafw9NSlOZTVdHOVcSzMe1J3Jn1OHarlajzyWPNNoelFLcCsWJGsGz/hQa81sE5AWnL4XtfnlCRm7sBX7pO8aCTsnbdXf/g1VgWNg6xkV/awj4XZLDKayOGeXURu6kS9W64GHR7S1z5q4KjMnGrHTbb76y1r16wARAAVQeXvkTP/P/1HjLmQu6O0/yZErqe+ptq4GMvU3ElqBTzrDQuGKVFLlj5r4HWEkcbD7mfVCmp+6CLiEYQ+4R2cm8LoV/IBWwwf9Qw4BfuPBRJlR7J1HVYI/3V2+O2mwXvszNzIjlTJmNcjkKLYwSbAA15n66ojIDeMqe9162nALCoKF3O51WdIWvK8omiAdODzJSWq2Yjzg8QXamRGdm5ifC706djO3MXP/ma9zuwKgsqmLivUzNCn+9d5DjmS7auZ+y+9nUdzXe9DRfQzS2YjKB3u/HAPOX
 qbqe8DB+
 64MP5beDx8TwvkoVNDHFp+Iwy6R3O0GAf3PH5/FUcJFyp2wmAkd8rrzTGU1UzYAFPEMwsIqaTe8M7gNrXkf9zoZrQliVTdWsaIJ93bBNCOujOGHIX2b7B+pgaz55byv5nQSgm+wQJQsu3oRGc89iD3Rar7hBCloKSoUtzoPeAx9B5e1yZn0lObzzsVPAfVrzAu/iFkofJHXY47GYRyGsuywhkkosCwUHgIFhSvM49dFVjIxcFeofoLnDw7UMbacIq1NJL+Gv35cT2cZViV/Nps04hdp1lJ2QGy38kiz8/l3QuX4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0c6378a71574 ("arch: introduce set_direct_map_valid_noflush()")
added set_direct_map_valid_noflush() to allow updating the direct map
for a physically contiguous range in execmem.

As Brendan recently pointed out [1], this API is confusing because on
arm64 it means that is sets VALID bit in ptes, while on other
architectures it is an analog of set_direct_map_default_noflush().

The only user of set_direct_map_valid_noflush() was execmem's ROX cache
freeing path and it was switched to utilize VM_FLUSH_RESET_PERMS for
resetting permissions of the direct map alias.

With the last user gone and with set_direct_map_{invalid,default}_noflush()
accepting number of pages as a parameter, set_direct_map_valid_noflush()
become a copy of set_memory_valid() on arm64 and a duplicate of
set_direct_map_{invalid,default}_noflush() on other architecture, it is
safe to remove set_direct_map_valid_noflush().

Also drop a stale comment in arm64::__kernel_map_pages() that Linus
bothered to add when merging changes containing set_direct_map_valid_noflush()
to his tree.

This reverts commit 0c6378a71574daa6cd1534ad42a956e3262756c7.

[1] https://lore.kernel.org/all/DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev

Reviewed-by: Brendan Jackman <brendan.jackman@linux.dev>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/include/asm/set_memory.h     |  1 -
 arch/arm64/mm/pageattr.c                | 16 ----------------
 arch/loongarch/include/asm/set_memory.h |  1 -
 arch/loongarch/mm/pageattr.c            | 19 -------------------
 arch/riscv/include/asm/set_memory.h     |  1 -
 arch/riscv/mm/pageattr.c                | 15 ---------------
 arch/s390/include/asm/set_memory.h      |  1 -
 arch/s390/mm/pageattr.c                 | 12 ------------
 arch/x86/include/asm/set_memory.h       |  1 -
 arch/x86/mm/pat/set_memory.c            |  8 --------
 include/linux/set_memory.h              |  6 ------
 11 files changed, 81 deletions(-)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index b07fd4e026eac..0091ba12200e6 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -13,7 +13,6 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
 int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index db8d60a84d144..132938b32eb16 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -355,23 +355,7 @@ int realm_register_memory_enc_ops(void)
 	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-
-	if (!can_set_direct_map())
-		return 0;
-
-	return set_memory_valid(addr, nr, valid);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
-/*
- * This is - apart from the return value - doing the same
- * thing as the new set_direct_map_valid_noflush() function.
- *
- * Unify? Explain the conceptual differences?
- */
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (!can_set_direct_map())
diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/include/asm/set_memory.h
index 563aab92896e9..4bb01172fbc24 100644
--- a/arch/loongarch/include/asm/set_memory.h
+++ b/arch/loongarch/include/asm/set_memory.h
@@ -17,6 +17,5 @@ int set_memory_rw(unsigned long addr, int numpages);
 bool kernel_page_present(struct page *page);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index 43ad2a104f19d..a7dcff40f7598 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -217,22 +217,3 @@ int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 
 	return __set_memory(addr, nr, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
 }
-
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-	pgprot_t set, clear;
-
-	if (addr < vm_map_base)
-		return 0;
-
-	if (valid) {
-		set = PAGE_KERNEL;
-		clear = __pgprot(0);
-	} else {
-		set = __pgprot(0);
-		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
-	}
-
-	return __set_memory(addr, nr, set, clear);
-}
diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm/set_memory.h
index db1d0ed82b696..e9f9960c19477 100644
--- a/arch/riscv/include/asm/set_memory.h
+++ b/arch/riscv/include/asm/set_memory.h
@@ -42,7 +42,6 @@ static inline int set_kernel_memory(char *startp, char *endp,
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 20ef95b1d0c36..5b3cf326455db 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -386,21 +386,6 @@ int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	pgprot_t set, clear;
-
-	if (valid) {
-		set = PAGE_KERNEL;
-		clear = __pgprot(_PAGE_EXEC);
-	} else {
-		set = __pgprot(0);
-		clear = __pgprot(_PAGE_PRESENT);
-	}
-
-	return __set_memory((unsigned long)page_address(page), nr, set, clear);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *data)
 {
diff --git a/arch/s390/include/asm/set_memory.h b/arch/s390/include/asm/set_memory.h
index 6b0aa9147ed8e..e3562bf0c1aa5 100644
--- a/arch/s390/include/asm/set_memory.h
+++ b/arch/s390/include/asm/set_memory.h
@@ -62,7 +62,6 @@ __SET_MEMORY_FUNC(set_memory_4k, SET_MEMORY_4K)
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 #endif
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 7549543d62412..80e834e8b8e1b 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -392,18 +392,6 @@ int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 	return __set_memory((unsigned long)page_to_virt(page), nr, SET_MEMORY_DEF);
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	unsigned long flags;
-
-	if (valid)
-		flags = SET_MEMORY_DEF;
-	else
-		flags = SET_MEMORY_INV;
-
-	return __set_memory((unsigned long)page_to_virt(page), nr, flags);
-}
-
 bool kernel_page_present(struct page *page)
 {
 	unsigned long addr;
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 0c4235d159f48..39271a5ea9252 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -88,7 +88,6 @@ int set_pages_rw(struct page *page, int numpages);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 4d07a9fbc43a7..a1a061d995b31 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2666,14 +2666,6 @@ int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 	return __set_pages_p(page, nr, 0);
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	if (valid)
-		return __set_pages_p(page, nr, 0);
-
-	return __set_pages_np(page, nr, 0);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 0b77f1d7d8b9c..3fe293cfed8cc 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -36,12 +36,6 @@ static inline int set_direct_map_default_noflush(struct page *page,
 	return 0;
 }
 
-static inline int set_direct_map_valid_noflush(struct page *page,
-					       unsigned nr, bool valid)
-{
-	return 0;
-}
-
 static inline bool kernel_page_present(struct page *page)
 {
 	return true;

-- 
2.53.0


