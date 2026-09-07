Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D8DC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DED6B00AF; Sun,  6 Sep 2026 23:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34426B00B0; Sun,  6 Sep 2026 23:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC1E6B00B1; Sun,  6 Sep 2026 23:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86F9C6B00AF
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:51:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B5761C1E36
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:19 +0000 (UTC)
X-FDA: 85185591078.12.6B7BDD8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 60FEE14000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GDH1iVaD;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753077;
	b=ShlWG8qTfV3v4uaItC5PabcpDB3veEiuYtyJWqBUyW4TnBnYK12lVGJ32gp12TX3B53ZTy
	Psu6+HwF9X4sv82SVXbeQXM5sBn1VBDFdrcmTnVHV0c6kOGW1MiF2JeEAoaaTypL9BJziJ
	R3an/9cbmhXT0PvJYC0UqO1kOdS0sro=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GDH1iVaD;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luWlZWwBYYPwBya+o+ehXkBOxSyGbE4m07PKszzoAZs=;
	b=sCZKu9/vAJzoj3So3cAwV3QYr24FFphIKa2m/56flO408VJY+zJwiwJ1mJ92XMMt03cKLs
	8aWaaQguXCocG2Hqvt8BYyVZhPwdm0h9MooHOj4dtwTfXG1zbDsRyz9knI7c0fqHcVeWJ1
	faYREdyMDy9U/fvKK/eXKRVRJy4zaOA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD1AF1AED;
	Sun,  6 Sep 2026 20:51:12 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C28233FBF5;
	Sun,  6 Sep 2026 20:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753076; bh=LhsC0NhjKIdOi9rcgt72ehmDXHWyJcPL2hu83ddAkXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDH1iVaDTX9uj2NicaktrTaa+TO516GXCUn6g6G08VZgnHdHZUl1DRy1eGFL6TTxv
	 5QfnhHYRlF7ub/R7VFyqpPlgoON0Xu9Hhf6wHW0ROHaudZTmb5DVQB+JS16u+qgWDk
	 bTw9+mPbTyJtpWzYfQuf/x3Ux/JhZoSnBhnxP2t0=
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
Subject: [PATCH V2 11/14] arm64/mm: Enable TLBIP instruction based TLB flush
Date: Mon,  7 Sep 2026 09:20:26 +0530
Message-ID: <20260907035030.2839978-12-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: grxu47bhyxx81bfqgp6cm14djgw35w3f
X-Rspamd-Queue-Id: 60FEE14000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788753077-28056
X-HE-Meta: U2FsdGVkX1/OiqfNQf9t9LNOeRR6tVG3dz/OVOvAkgBASVWpMDCKhcRe4eMn8d/8XF6hzuXk8JRBpm7QlI0pWjXzAV8o11RjVk1wNheXP5WpbSp+KJP918Beoo6ZSESSeBDheG89iBC404PWZwTuW0rtNPfAkW58q5q7Rwk1Nu3SadXIkk1WKoDCoT2gKFTyZ0ZxbuDhF6vMMrhgQfADWFFFzuZUsW81DASIXYGREHrJw/oDUx6DFlPa34z8FtwMmuRX/pB5jmNGH+9hw0Y/OYF398A+TAKGmkn2WimMuYljwMbSsWpoMcjMhgo5HymhrkY86rvqLSJ+Tzlz8yy6j6j/v6BweqJDj2K6wHck8hyUbxILkRYL3Knpy5PZsnfjqznmj8fxnInMrjITl/FN/VnAQX7K1IQwkQiSoUg0JWRjc0dP6sWQOj/tTtl73oesFyjnmKwxaNHiPcdVAcG2x5929BqjCAFxlTPWvF7Pn77jh27Uoawjhd8YQ2Qa/xm0glpPZhaW+NJoCUtjRZFnJDOP5+91CkVgT0g+Yz2EBfnXZycrM0aqgbD6J+9IhnzpK+Tw7PUQmnhXcbfQWblo1PFl1RxSnc6y6uc53cW34A4BTPoPtCbzprWpIre8GuH7ymV3xFM6ESpMrg5lrslLIAxzbqQljRtTmHigzZDcV6/8RomLV05Wy5LO0dQaZZkapf42DAMauHM5ugP/BBqjmbJa3jL+KPzyipxPLDMegUNt2bY6FWUreHTbynAhzb7iYIpyZ1gEmgnh9jbm05gYATfscTg+hnI91deHM41uADg6aVj+1QMGMt8dJn8P29TBqqYuljXPMfUfVoB1RWPorPL9XOKnbYvU0Lj+uENb12h8QBoaFdlF6BkRgDxnkCz+tpjbvupl6SpBN8O+KsOVc9OC2nqySCsdtNbICp5zSRYyVhdmMi8rmef1E9shJ8YvJ7mTUUyapybSfj3cj93
 knemUYmM
 axJpOKaI50oZHwGQkv3vQ/5E1rIg1YU1MoVzWuMSpZw0kXJY7J9TStnnYRR0DKOMppFmHoFr5e6d6MPdXaDWd52Ct8UMiwPRg8NViiX7n3Se4umi5fiuJUdUQrQrT4iXCMl0ZPmb2kHNrbpvQf8jsf1xHy39sZK3uiOM2srUjKpK9trYKGjfRl99uz/qrtkW0/ITwmbRgWwXPA42hkBmaaYEGPsnqoiQGiKd5dPRWUnlJXrcVIrehA114uVjrw9ria18AqXQkv8RPX8cMQmUnmziFkSs1c9+U+FKTC0J6gD46k50TrqyCs97C8ngnIJYel01Q
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

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Linu Cherian <linu.cherian@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 68 +++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 88ae4e443ed6..f31a555760f0 100644
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


