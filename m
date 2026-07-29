Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B394C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338C56B0141; Wed, 29 Jul 2026 10:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9736B0143; Wed, 29 Jul 2026 10:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1633A6B0144; Wed, 29 Jul 2026 10:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBBBB6B0141
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:54:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 061B81406BB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:20 +0000 (UTC)
X-FDA: 85041736920.15.84F1D34
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 613AF14000F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:26:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DItmoeNA;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6glQyinDiG+knWCf5YuYqgT1r5WAXpU+YxPMWMH1Aw=;
	b=5Aqcw6ec2ck7cEfjblP8+7KlLVucXkmJ4R93evvSy8IupLyaneYPLdy1f+jWVKVGwn/MUm
	05mjOLJYe1HP1Sd9oQhx02k5ibycnwpdKgE3XwlzaaVHlvnewiGvxUM8H/psjV2ZtlK7dP
	qtfCaDo2peqYVXABeT4kgmLhEFnqxrQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DItmoeNA;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327978;
	b=DWTz7FWsBk1oRo5DwnFJTzcyzXr+1HH770OeKZmmXcq19fBhxS5ariIv2hjktc+lWXUld2
	yQFJp/l27gyEA5lAPZsGA/6C6ANqaEwdVDCRzQ677C+S3+HM2FFgkgWTLUdLcONQwZMBkz
	ZZZIHYxmdy5yBgpMkg9v3Zp6UkyLn2M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 630D11688;
	Wed, 29 Jul 2026 05:26:11 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DCEBE3F66F;
	Wed, 29 Jul 2026 05:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327975; bh=g9NV7nRdXqfFL3CF8X7Uv58zGdVCBUS7EOV62bO/WS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DItmoeNADsjRN4kC/vUk9pTatICCrxY30uhea8jvosirq9eKyBdxl46nh5vk+JUeK
	 NrIgHuMNJdP2tKiFSAdB4gMWzkdqaUVnEgwQpvOITIxt67Qgeslf1bg6cZLeXUwvCd
	 4FEx7FaYj9qc2uYRIStTSNKgNPRhbVHuFONaVtGo=
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
Subject: [PATCH 16/17] arm64/mm: Enable TLBIP instruction based TLB flush
Date: Wed, 29 Jul 2026 17:54:51 +0530
Message-ID: <20260729122452.3797443-17-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 613AF14000F
X-Stat-Signature: p5smf4dqbuo5cxrp7urtcwpfktm9ziio
X-HE-Tag: 1785327978-453876
X-HE-Meta: U2FsdGVkX18+Sww2v8eXOworWshd1QS5B0usoHfnk5KC+Q704b1fNGBUoZrlpGOntpxKyG3+LHAMPy92BElfem0/ccfhbb2T7c2zq9Wm0h0qaqCtFETy7WBWMabGrmKpJOD5iwpRC0VPf5dnt5qwG5RwmNeqGA3BHGF8P4fOGlxEMFTjuXr3N8BVKmdmXkj7imyvdqZrf3mO+kNflpAj3f7TjIF7No6oK2UNMH6H6EwGOGK5S9b9VK+DUQxOdu1d1ZP8S68ON33SCpxPdRhazCfiL9XjG3iFEnEwr55lox+58zIrmEZs7Xoo/jmPkB2sF7pSg7GrAgjJEBJ0k/Hs42sbtJDy5mzLt/wJw3qRHSppCsvm/dAxq1nGFzb+7yBoJitTlmuv2VA21F7s1IaKwbCU30CYdihYcEa0za7eOl0wmX22t2/4ghpPsXEEmTppSgUEZnkU31XmZ+QGIZtdW8odfwtrLerovY6QQykYVTDFVjCank5lVHNBjeCAb8mrqx+dl1sDyveqdjcfxkgE6pGBZOh+guvG10KUQDvhyjESrwhNcbT/PMf/rzRIxcL+nslJjSHqjmX5Rdjf6HyL9FunOTWWw1UHKFl4WvyAkGpjMAvwwRE4QiKG91/8oSVyU5hffOd9GXwQQ//LaYiIHxKMF+YrfqUNsA2WKm3lu/lD5xAr2ynoXZ3WT7oQwzcPGYnkcn9u775yBAjSzNQCZu6241Z1zWBM6Pm7SkzhsBOJMIabKu+YzJmJlckpvuTDiVgLyZ1/jL0dVlGPajbaVbIHZUvUY1WDgs6N+C8aNOW4sE86+bN/QA7JJ05pox+LXpE9+LUaTdzEPXIsVc9/g3eTL7OwjFW+0DHeuZ8DrUL+V1tjY6Vl44v0vzV6UV/Qy4jC2SAW1nSWXXuHZqvsSjZQIDz2E6piIyfB4IDUlXDWEcL5bcACPWr56pqwm+0OXMEwINZpw/ouoBrQ7zx
 BBfHcjbS
 Us2Dzi/rxQBKELxKX2JWwwLlO1EyS9YCU13TzkDFXHm2smcZ8eOKgEDTFeBhoSxwcF+NZffuj1KTolitMSTb4X1a2Ip5rfJf4TpbdwnRX3UGZaZ4L1g8IsNLlwcrJzkzYE/ayojrRzk2AxSUUxSOsVDOB1Z8OcZQ4iqss/LlGU+UXg3RV7zn5eR/+ZpmbCj/hMIq6Vgwxhi85lXBbS0ehiT8sT9dZnO7OsprHnCkeKBmg1FiFEyFTSl0fqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linu Cherian <linu.cherian@arm.com>

Add TLBIP instruction support for TLB flush operation updating all relevant
macros as necessary. This enables back pgtable level hint and address range
support during TLB flush operation for D128 translation.

Signed-off-by: Linu Cherian <linu.cherian@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 68 +++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index c103380ec87e..3b6384b9c200 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -41,6 +41,25 @@
 
 #define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
 
+#ifdef CONFIG_ARM64_D128
+#define __tlbip(op, arg) do {		\
+	asm (ARM64_ASM_PREAMBLE		\
+	".arch_extension d128\n\t"	\
+	"tlbip " #op ", %0, %H0\n"	\
+	: : "r" (arg.full));		\
+} while (0)
+
+#define __tlbip_user(op, arg) do {		\
+	if (arm64_kernel_unmapped_at_el0()) {	\
+		arg.low |= USER_ASID_FLAG;	\
+		__tlbip(op, (arg));		\
+	}					\
+} while (0)
+
+#endif
+
+#define TLBI_ASID_MASK		GENMASK_ULL(63, 48)
+
 #define __tlbi_user(op, arg) do {						\
 	if (arm64_kernel_unmapped_at_el0())					\
 		__tlbi(op, (arg) | USER_ASID_FLAG);				\
@@ -130,9 +149,15 @@ static inline void sme_dvmsync_batch(void)
 
 #define TLBI_TTL_UNKNOWN	INT_MAX
 
+#ifdef CONFIG_ARM64_D128
+typedef union __u128_halves tlbi_arg_t;
+#define __tlbi_wrapper(op, arg)		__tlbip(op, arg)
+#define __tlbi_user_wrapper(op, arg)	__tlbip_user(op, arg)
+#else
 typedef u64 tlbi_arg_t;
 #define __tlbi_wrapper(op, arg)		__tlbi(op, arg)
 #define __tlbi_user_wrapper(op, arg)	__tlbi_user(op, arg)
+#endif
 
 typedef void (*tlbi_op)(tlbi_arg_t arg);
 
@@ -179,17 +204,28 @@ static __always_inline void ipas2e1is(tlbi_arg_t arg)
 	__tlbi_wrapper(ipas2e1is, arg);
 }
 
-static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
-					      u16 asid)
+static __always_inline void __tlbi_update_level(u32 level, u64 *arg)
 {
-	u64 arg = __TLBI_VADDR(addr, asid);
-
 	if (alternative_has_cap_unlikely(ARM64_HAS_ARMv8_4_TTL) && level <= 3) {
 		u64 ttl = level | (get_trans_granule() << 2);
 
-		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);
+		FIELD_MODIFY(TLBI_TTL_MASK, arg, ttl);
 	}
+}
+
+static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level, u16 asid)
+{
+#ifdef CONFIG_ARM64_D128
+	union __u128_halves arg;
+
+	arg.low = FIELD_PREP(TLBI_ASID_MASK, asid);
+	__tlbi_update_level(level, &arg.low);
+	arg.high = addr >> 12;
+#else
+	u64 arg = __TLBI_VADDR(addr, asid);
 
+	__tlbi_update_level(level, &arg);
+#endif
 	op(arg);
 }
 
@@ -475,19 +511,33 @@ static __always_inline void ripas2e1is(tlbi_arg_t arg)
 	__tlbi_wrapper(ripas2e1is, arg);
 }
 
-static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
-					 u16 asid, int scale, int num,
-					 u32 level, bool lpa2)
+static __always_inline u64 __tlbi_range_args_encode_comm(u16 asid, int scale, int num, u32 level)
 {
 	u64 arg = 0;
 
-	arg |= FIELD_PREP(TLBIR_BADDR_MASK, addr >> (lpa2 ? 16 : PAGE_SHIFT));
 	arg |= FIELD_PREP(TLBIR_TTL_MASK, level > 3 ? 0 : level);
 	arg |= FIELD_PREP(TLBIR_NUM_MASK, num);
 	arg |= FIELD_PREP(TLBIR_SCALE_MASK, scale);
 	arg |= FIELD_PREP(TLBIR_TG_MASK, get_trans_granule());
 	arg |= FIELD_PREP(TLBIR_ASID_MASK, asid);
 
+	return arg;
+}
+
+static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
+					 u16 asid, int scale, int num,
+					 u32 level, bool lpa2)
+{
+#ifdef CONFIG_ARM64_D128
+	union __u128_halves arg;
+
+	arg.low = __tlbi_range_args_encode_comm(asid, scale, num, level);
+	arg.high = addr >> 12;
+#else
+	u64 arg = __tlbi_range_args_encode_comm(asid, scale, num, level);
+
+	arg |= FIELD_PREP(TLBIR_BADDR_MASK, addr >> (lpa2 ? 16 : PAGE_SHIFT));
+#endif
 	op(arg);
 }
 
-- 
2.43.0


