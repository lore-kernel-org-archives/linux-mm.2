Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464DE606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sh0MlkhJ
Received: by kanga.kvack.org (Postfix)
	id 254A96B05C3; Tue, 17 Nov 2026 02:07:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BD96B05C4; Tue, 17 Nov 2026 02:07:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F066B05C5; Tue, 17 Nov 2026 02:07:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D23A56B05C3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:07:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3778CA035C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:07 +0000 (UTC)
X-FDA: 85443729294.27.FF798B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E4C01C0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sh0MlkhJ;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899225;
	b=dEJRXzS7+V/lPXX7FRBtyhDjPxnuAaEDuPNzfaNPeZfxy3bxZdqIyiS8WbAEloa6frsS2C
	MW15LFS5w0zi1nIBpkRRn134mc6vAlpq++Pu3JG6ovfEp+avF3aWRXE00zgsHW7fcHayY6
	+h9MV0tXQDuDazIYh824TO/m36h0r1Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sh0MlkhJ;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iv8DY4asFhTjzipaQVYQqam4Cbb+8XuirWHT+xFO2vo=;
	b=W3nfCaqGU8e8aXQvAV7E7/ZB8Or2N2WQOusb6SIuh2k05EOkaWyN1v0frvwEo/mbyWz5Ro
	fwAedR/8XewRiBw6Hulg6Bz7XIEUDzXrX0Hmu60FeR9aUPM8pwNojZHZZXnfT84yquiOMS
	BvTmtmIbujMrMr2KWKXAdfa39eMuYPc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA4C01476;
	Mon, 16 Nov 2026 23:07:01 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F4733F763;
	Mon, 16 Nov 2026 23:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899224; bh=gWd3VSKQGcmDL0rND+7miFz0510CU52wEGtyXPxoBxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sh0MlkhJYda5X1jALRTVT5SvRmycezCCIhbm8p177NP2BlcMJjCiUDiC4RBhdFhfe
	 VkiqnTrU0lsjjF/kIqlsHyjzifa5Amj9xoyY8Ft6CFOG6m/Eg88bOG3jhBVJH3vB0a
	 WDX0Jg+x0cp1/3EkuDCW+AWpbPGMvxOqWZ9VMtHM=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Linu Cherian <linu.cherian@arm.com>
Subject: [PATCH V3 11/14] arm64/mm: Enable TLBIP instruction based TLB flush
Date: Tue, 17 Nov 2026 12:36:10 +0530
Message-ID: <20261117070613.1183243-12-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E4C01C0006
X-Stat-Signature: y46wq6pfs9p8d3f9ghs6ty6jm5tp3o63
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794899225-418912
X-HE-Meta: U2FsdGVkX18Un/Kd0QdDOqwkt9lxse87tSe72sa+XgyFNx1DFKRTxuDS/ST/emel/CAZ5wIuqQSV6EmFw7ai0MQH2XNuFgqdcYZPwaXpaulvmc/D5ovOjrHSE3bb4eSL1b07t9Uy6gBeqQoHFF9QVREBl9d9SAALageIInUdATX2FueISWQuccFPxEaMgHomLBFj8MgXCF6OJjHtiD6RhdlK0/b3tKbJWl+RlnmG1EjjaJOgqlsvJD4QwFVj8YVXWn+xSPkrJNIYAEJ9LkIIVijK/bZNjKlo+SQE/Ajw3oOtY16jlUp/QLna0rD6i6pMaul15oRDRGfrl3ZMinBqF0H/c/M0sYa2jBRTDSXftvoE8yvwklSrWSDppQs8DUPjXUBVlG91hShBGpI5jDrW++efhlCP9f9oAtVloPLTETQ9s+STChwbQB7OCy4o3bewuQikhIAf1t2ROZEdgUq54geS8shdsycNrYqMhidCFFbfquCArxFRLZyDbtZKp295DFMHRJMA1v869eocQE2kOYxM6n4WvGqEEt2uVmG3NUZWOgiGx21jDTpIxQFZTc/KB3MY1EOW7bI/shMoI7mqc3q7iyiPj6hC2ipiIiaoH8Dor5gyB5RYnKug3RujrPKspTRKHvd1tRrhu8nWaK7GiFaAvrZkUQMIu7rEx9O+BxSYZ1gGKmAXfhAe+KwjjwBghvZ1qiHS8py+qJsy4aWhVENa6q40aevucBCbTnerpZ5YuMljLutItjgQsFNn4PSjfsuYbgSWPCNtLc4fgu9/LzufAvFOMW7SzF1q1cKP3E7o5IT0nRm7m9q+aTJ6fvk7RdMIV+QjK1QLidV9KlF6P1y3y5mJ8i+VLmCkmuxlF8QQ7L3tN7DkIV4mC77EzovxPQcSr0WxBOO22ErLU0yWIbyCWDGhcbTvR2bZJmRb0xfaiKQLm7q5wePnxYBBl+/Lffst/dXP8xNCFrKecLb
 jZ2X3uoR
 tRnzrAGR2GwPBijt6YIDpiDbqscOXfalERuN5Lmy0Td9ZbfOL5USVerNRC3fvoKJRpWwzedGBjxYpifwbkGd6zKme14V1lnUbo++UooOzb0tBmwrwuvL7wlptxhgi7KZk6uNDv1NKPp83A0UayPGpzhtxW2d0qPFD+eWT6uAdiK2zhu5gCFcf2YbC7YFKEccEJtCRO7JRf6YCuO9QzjCfq63WjNzODaYLRj4PMB7Hk1G4wyu868p4jvg1Fm7OBwldToaHXHVMGLLKulPJIffh1rfXLsfBtNK6KyeKBUGqPzZaCnBmCsiXRPZ+sZrEQPpLTDuD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index e46bebeb230d6..a440a8fd0ebcf 100644
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
 
@@ -479,19 +515,33 @@ static __always_inline void ripas2e1is(tlbi_arg_t arg)
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


