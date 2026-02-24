Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EDDEFB7FD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F5A6B00AD; Tue, 24 Feb 2026 00:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CEE6B00AF; Tue, 24 Feb 2026 00:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BB26B00B0; Tue, 24 Feb 2026 00:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC2A6B00AD
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:13:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51F1913A23B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:42 +0000 (UTC)
X-FDA: 84478182684.15.0F45686
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9E0ACC000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771910020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iOfJKZ9DGB+oMBxnGCCCl/YVTRiM1fzTpfqUHgJRSGs=;
	b=Tv16RemXSAL3OW9zOGbrnpXuNr2Q2olqGNqcW7WyfAC+E/fnRF8AFvX3XJWq21N1TOvlup
	GaxkNgwii8egY9tJNeKVu2nXI+mgHcWyW5WhnzmuD/gWTVAclKo38ZUp3num/wUm6cROE6
	bycvgzE7mQqtivaj5So7L9k1svicf0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771910020; a=rsa-sha256;
	cv=none;
	b=kuLEtO5yJNW38RbwJc18k2u8nmTyCwlM3qiF69ivC+hD1Vr45zq8X6V9Uwj1yaCm0zzizf
	8w9FmK4Qp7Hc7xIxLuMsq5OrkgZCVmGFHdlwc7I8QBgDI4fJgxr/6eTne6Y6JCi8sXSJc+
	LLE+TR+4Tfy+y7PHu6cdcxeoOE+APUg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B1881570;
	Mon, 23 Feb 2026 21:13:33 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 98A843F7BD;
	Mon, 23 Feb 2026 21:13:35 -0800 (PST)
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
Subject: [RFC V1 15/16] arm64/mm: Add macros __tlb_asid_level and __tlb_range
Date: Tue, 24 Feb 2026 10:41:52 +0530
Message-ID: <20260224051153.3150613-16-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: x5iwxsz3i3hec44wfy9k7rj78ssjcytk
X-Rspamd-Queue-Id: 9E0ACC000A
X-Rspam-User: 
X-HE-Tag: 1771910020-238491
X-HE-Meta: U2FsdGVkX1+EkstAzI81CxaA8/s/qqotj1RgS38oElWcx1Kh8QShEbhJz3xd7csD5cuByWjbpxx9DLBhXIHMwDBGT3vVKK6QeUjsa2QYSlQYUsTka912uD/YhF5W+V/AkFjWOC2g9abSvyzjmGvrZbjnTPRaMBVn2lW066psEMLg084LnUDZnvx395l9rJvCDvyf+WtL6o76H8VDFUPSsxqWLi/NsACEqmsfAnCrLDn8Mo5tXktddBkMDax3+s169i4Qz8AduXXSMk9iX6YQcprZDbUJhHq0oP3JFbsobNcESNWkStK4tVJ7bto5uPbX9i+rYktImUc0WZRSeWAQqmtkfSPqV8Uhhs8PKgbnZ2y/d6lZnFqekJadakVZ2WLBRgWCD79xq26t/WLW5c7Zi/5mNs74IZZ0MJ0o2P68vNNV3D4zYg9WL3xFwd+G3AmQfGm9cMGj7bmK68L256shQDWBj9pV47phWz361/JFPx+hWlERaSs1FUFyLcmeSPrul31EPGAAbV5GMej51joeBjfRmFUwh1Gby5h5XHMi4s9a37cq6Vk3uQvdcTdpo18WyQiSEfg2PFXGNqB0APZjcnviDlsG6tr9zK7Nl+d7d5JcpHET2yJsERCEMExGiydqMGZ/f7mX9TaE6BsbfAY3crWQ+w7BCAB8WdJFRgxpQ1P0F+5d5J0jLX8Kk8lLpz72r3ZPNnsUH49R9JwEG+VLYFD0DxL0OO4Go5sbfs2RiBM8fDyxShWJUfgaMsgDdu5E3eFUh39Ms2exbH//JFRc8Bjs1lnLF9Q+DuZAfHC9S9uGE74W0xMw6LBYKyPIRMkTtFe7/0TEZfxGC8656czcarDvHNkSx19ufSvai+qsWH29s0As5hN2zh70GA/u7kOW5n1v0QRin2rVycV71IuVWIEQMhreCDU+JnpmMV5e1LVgippn714R/ElSeLsQRWw1gDCe7kKGPP/yQ/+Hfa5
 8qtwGro5
 PWwCLMG3j312Ta2pOAJ0fMIezxLqkU7+3+kLgv8PE4H+WBzRhh7VrWR6TYEmlLHNEspVrwjkP7CavP5LVGVfRevgbx7xP7ogoAynLiJOrcoi75nDLr/mQVfUTlFJRfb/rDEfSmXNDw4XBUmkHYNjaGAdGbknHNBdhBi5LPykpHYaT0jo5i9MHXWCeoqqjrmuSBd2oYHsQ/XerQYaE/AsiAG6LH4QARu2xQkSiqwGfKdiHydKOu8wsS09pE6JkY6DVdzLAt2hB0nZrzKJtzi6eCackAMo9HFIDHpq9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linu Cherian <linu.cherian@arm.com>

Existing __tlb_level macro uses encoded arguments for TLBI instructions
which is not compatible with TLBIP instructions required with FEAT_D128
both for level hint and range based operations.

Add two new macros __tlb_asid_level and __tlb_range that will work both
with existing TLBI and upcoming TLBIP instructions. __tlb_asid_level is
used for non range operations with level hints, where as __tlb_range is
used for range operations with level hints. Subsequently update the macro
__flush_tlb_range_op as required.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Linu Cherian <linu.cherian@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 47 ++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index a2d65d7d6aae..9c93ffbcc1e0 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -54,6 +54,8 @@
 		__tlbi(op, (arg) | USER_ASID_FLAG);				\
 } while (0)
 
+#define TLBI_ASID_MASK		GENMASK_ULL(63, 48)
+
 /* This macro creates a properly formatted VA operand for the TLBI */
 #define __TLBI_VADDR(addr, asid)				\
 	({							\
@@ -102,6 +104,8 @@ static inline unsigned long get_trans_granule(void)
  * in asm/stage2_pgtable.h.
  */
 #define TLBI_TTL_MASK		GENMASK_ULL(47, 44)
+#define TLBI_TG_MASK		GENMASK_ULL(47, 46)
+#define TLBI_LVL_MASK		GENMASK_ULL(45, 44)
 
 #define TLBI_TTL_UNKNOWN	INT_MAX
 
@@ -124,6 +128,15 @@ static inline unsigned long get_trans_granule(void)
 		__tlbi_level(op, (arg | USER_ASID_FLAG), level);	\
 } while (0)
 
+#define __tlb_asid_level(op, addr, asid, level, tlb_user) do {		\
+	u64 arg1;							\
+									\
+	arg1 = __TLBI_VADDR(addr, asid);				\
+	__tlbi_level(op, arg1, level);					\
+	if (tlb_user)							\
+		__tlbi_user_level(op, arg1, level);			\
+} while (0)
+
 /*
  * This macro creates a properly formatted VA operand for the TLB RANGE. The
  * value bit assignments are:
@@ -149,11 +162,10 @@ static inline unsigned long get_trans_granule(void)
 #define TLBIR_TTL_MASK		GENMASK_ULL(38, 37)
 #define TLBIR_BADDR_MASK	GENMASK_ULL(36,  0)
 
-#define __TLBI_VADDR_RANGE(baddr, asid, scale, num, ttl)		\
+#define __TLB_RANGE_ARGS(asid, scale, num, ttl)			\
 	({								\
 		unsigned long __ta = 0;					\
 		unsigned long __ttl = (ttl >= 1 && ttl <= 3) ? ttl : 0;	\
-		__ta |= FIELD_PREP(TLBIR_BADDR_MASK, baddr);		\
 		__ta |= FIELD_PREP(TLBIR_TTL_MASK, __ttl);		\
 		__ta |= FIELD_PREP(TLBIR_NUM_MASK, num);		\
 		__ta |= FIELD_PREP(TLBIR_SCALE_MASK, scale);		\
@@ -162,6 +174,13 @@ static inline unsigned long get_trans_granule(void)
 		__ta;							\
 	})
 
+#define __TLBI_VADDR_RANGE(baddr, args)					\
+	({								\
+		unsigned long __ta = args;				\
+		__ta |= FIELD_PREP(TLBIR_BADDR_MASK, baddr);		\
+		__ta;							\
+	})
+
 /* These macros are used by the TLBI RANGE feature. */
 #define __TLBI_RANGE_PAGES(num, scale)	\
 	((unsigned long)((num) + 1) << (5 * (scale) + 1))
@@ -181,6 +200,16 @@ static inline unsigned long get_trans_granule(void)
 		(__pages >> (5 * (scale) + 1)) - 1;			\
 	})
 
+#define __tlb_range(op, addr, lpa2, range_args, tlb_user) do {		\
+	u64 arg1;							\
+	int shift = lpa2 ? 16 : PAGE_SHIFT;				\
+									\
+	arg1 = __TLBI_VADDR_RANGE((addr) >> shift,  range_args);	\
+	__tlbi(r##op, arg1);						\
+	if (tlb_user)							\
+		__tlbi_user(r##op, arg1);				\
+} while (0)
+
 /*
  *	TLB Invalidation
  *	================
@@ -423,17 +452,12 @@ do {									\
 	typeof(pages) __flush_pages = pages;				\
 	int num = 0;							\
 	int scale = 3;							\
-	int shift = lpa2 ? 16 : PAGE_SHIFT;				\
-	unsigned long addr;						\
 									\
 	while (__flush_pages > 0) {					\
 		if (!system_supports_tlb_range() ||			\
 		    __flush_pages == 1 ||				\
 		    (lpa2 && __flush_start != ALIGN(__flush_start, SZ_64K))) {	\
-			addr = __TLBI_VADDR(__flush_start, asid);	\
-			__tlbi_level(op, addr, tlb_level);		\
-			if (tlbi_user)					\
-				__tlbi_user_level(op, addr, tlb_level);	\
+			__tlb_asid_level(op, __flush_start, asid, tlb_level, tlbi_user);	\
 			__flush_start += stride;			\
 			__flush_pages -= stride >> PAGE_SHIFT;		\
 			continue;					\
@@ -441,11 +465,8 @@ do {									\
 									\
 		num = __TLBI_RANGE_NUM(__flush_pages, scale);		\
 		if (num >= 0) {						\
-			addr = __TLBI_VADDR_RANGE(__flush_start >> shift, asid, \
-						scale, num, tlb_level);	\
-			__tlbi(r##op, addr);				\
-			if (tlbi_user)					\
-				__tlbi_user(r##op, addr);		\
+			u64 args = __TLB_RANGE_ARGS(asid, scale, num, tlb_level);	\
+			__tlb_range(op, __flush_start, lpa2, args, tlbi_user); \
 			__flush_start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT; \
 			__flush_pages -= __TLBI_RANGE_PAGES(num, scale);\
 		}							\
-- 
2.43.0


