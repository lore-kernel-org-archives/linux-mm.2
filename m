Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEA9606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOnwfVzT
Received: by kanga.kvack.org (Postfix)
	id 110026B05B3; Sat,  7 Nov 2026 02:43:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C17B6B05B5; Sat,  7 Nov 2026 02:43:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBD36B05B9; Sat,  7 Nov 2026 02:43:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C95D96B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:43:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89598402FE
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:43:40 +0000 (UTC)
X-FDA: 85407533400.17.E1586FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D13B4140005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:43:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOnwfVzT;
	spf=pass (imf23.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794037419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbGBm47tNYc92nP6La+c3CzQA70ZHrCkA+HjF/TETiY=;
	b=dbY4BFaYZKZ3rtikvL3fESRDuOkpqnKJ31KeWtjmf5CMESD4wQbD/BZj3fcOTf2+rCb8/J
	vda7IqrmTZE0QVEggKPckmgreQMWckOukWlyMZdOxlVunqIMTaQt/pSazbLR+GlX+hlxhh
	IF0Exg82kCMTxVhTx1uFec+eH+dy5YM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794037419;
	b=jo+QeAWIBOD6tdNQdmz9XaQ+n1Njya32m6vwFJME9Hw83Kv9AASmp/BT7nNbZneZ2FXYR1
	V7Zu7TIFvsiFBF+VVUB2akHCrjVNLGM4gxFx15WrI1soXgkjS4lllq2q1Nnp1Sf+kdCsWT
	GoVHWRNtJnbblwa9Fp5oyvczXnX1NeU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOnwfVzT;
	spf=pass (imf23.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE48742AC5;
	Sat,  7 Nov 2026 07:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC3D1F008A2;
	Sat,  7 Nov 2026 07:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036837;
	bh=FbGBm47tNYc92nP6La+c3CzQA70ZHrCkA+HjF/TETiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOnwfVzTCtL7gDM+PcYpKoyrqSGazZYg27t906AkpBaSua7ooa60wGklHbYfhqBkx
	 7Xzf6MQzApazvD16Apns/+ug3yMR/DwyLOdVSW4KEKCht5DhHQfkc2fzmGCk9Ov1EQ
	 OWgR5yC4pCufnYQNWsBwq9K6shFHcE5dpgO6V2T9KX9TYcPKN34QBnp1T5ZDGUtpRm
	 XKO8CUC5tOPEdXFHhrYL0TIPSDQR5PCRXjqA5X4rYKNtcGx/FefwhleDbuIpbtcpvO
	 ctcbl3/9Kqdh7yxsgBcNIHFyuRxTWhtaYtOmAg7XLSaKCLQsEnEUrimaZz5blVRZlF
	 wbTghD6QyeLwQ==
From: Jisheng Zhang <jszhang@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH 2/4] arm64: entry: Always inline helpers used by non-instrumentable paths
Date: Sat,  7 Nov 2026 15:13:37 +0800
Message-ID: <20261107071339.17467-3-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261107071339.17467-1-jszhang@kernel.org>
References: <20261107071339.17467-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4d7g5r7xao8fkhchruo7ybcyxhmygege
X-Rspamd-Queue-Id: D13B4140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794037418-864600
X-HE-Meta: U2FsdGVkX1+AAl5uCl3DXRvSjCb13gQ6MOe3mp8OFInYyUufsj63FOPviIowNQTpHrVtgwmMzQPfmTEGT/RikEK3BUUv1tvuHtFfbLeHVByQg50/JOHzS8UhfdECR5Ie3MFw8//0XH7+vzWvG+ZDTMX+CxhceUUbtVify5REtu5caUmRd0fdarYh3DlyAQlSY99YcGeLYT/5djn1RoQF4kW6aLDjSg3tmp2pGwmdcf3R6XH8RgdnNoGocDxPGWuqpraoY87E/BBxhEWaKpJrPRjuSYe/pKX2W8PA9oO+PaeMbEzf6UjfCf7PRRO1lJDxn/biJiE8v3+fYGCDBFkg2GYY1L91BQtLuEMfpJ7bn6cm18h0kbfFqFpq8RKmVCfFgB080RG/BjnXEqWS7KHX6gfGOofcPPT2VDEXumcyLzxwN+UT4KN9MS50hQtiO22aru9lzCfL2Yo9HK2BJjHkufgmszJKi3QP7ct1lx/ZTublIT+fnylD4fi0ShKJBb72/IBMaOU3UlQiAO7HSUDwzSY1+ePpbEWUSQ/mM4Gj64wG5vtO/UTzZS35EvVw1N/AiZ+NQC74SLCSrddaokM5U+fAnVCtI5Ub/VdXCo19V9Jf2UjkxYSVjK/9tVb2j0hU6COstYmGMAEiwwHzOnW948X7/RddJ+jQfmf2LWdP4xLaUhUTGJziN5P0inuAJUrQvs7Pi1tPDtsvPBVYv68twouHITNZYHJJw7+JY1dUIfevWPz3JH+hLXUgp9NIBYYTHRI8ofZvQ467Ac1658pcwO68lbaMjNRPX23C/mDXiDXNf6uuSTVapoFuT5l8VZoGHp11/neCO5XzPK5ctpSGDQ8McbEnv1z4kpah3s35+SPuirLNO2j5j2Bnn4YvY8WY6/DjfV0JDx80iEWTaLaCKS79g7kcKvHYLDjOuBmtsviHMgNSjE+sYDGpOTGBNh9ioht71eVRj5zBQ65seor
 kyCpr36U
 Pi9PqFsCwDJ+WekX8c3REXs/6f+BgBCUUlo57TwIlN87BcgtLEbInul02ZnulzEonOOl8imTf73ZymZA5d/sYETDrYFfjiN0+m+cJaR/N/gG2EXUmpyPlJY7uhwwI9vgaXaXvanvCqW4ReA4nX4t8V8jbzNuYb5n6+d1cDgNKzFc+Rzn9dqJssbZqVQxAbAMXTDw7tlJ1zo5ildoCxyqAn6l9NrL1HfEScrtbFAeD+rjtv+OZFYeyxVihCf1qUYblKbGUcr8oXkOTl0q8SjXwqMfduC0epD5kYQYKpEtEQXGFny4KilDFw4+YKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The noinstr entry and exit paths call MTE and SME helpers, CPU feature
checks, and the architecture-specific rescheduling check. Several of
these helpers use plain inline, which permits the compiler to emit
instrumentable out-of-line copies.

A GCC build with CONFIG_CC_OPTIMIZE_FOR_SIZE=y emitted
mte_disable_tco_entry(), sme_enter_from_user_mode() and
sme_exit_to_user_mode() in .text.

Use __always_inline for these helpers and their nested feature checks
so they inherit the instrumentation restrictions of their callers

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Assisted-by: LLM
---
 arch/arm64/include/asm/cpufeature.h   | 8 ++++----
 arch/arm64/include/asm/entry-common.h | 2 +-
 arch/arm64/include/asm/fpsimd.h       | 4 ++--
 arch/arm64/include/asm/mte-kasan.h    | 4 ++--
 arch/arm64/include/asm/mte.h          | 6 +++---
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e3c8a1493dc8..c62949693b92 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -774,7 +774,7 @@ static __always_inline bool system_supports_fpsimd(void)
 	return alternative_has_cap_likely(ARM64_HAS_FPSIMD);
 }
 
-static inline bool system_uses_hw_pan(void)
+static __always_inline bool system_uses_hw_pan(void)
 {
 	return alternative_has_cap_unlikely(ARM64_HAS_PAN);
 }
@@ -840,12 +840,12 @@ static __always_inline bool system_uses_irq_prio_masking(void)
 	return alternative_has_cap_unlikely(ARM64_HAS_GIC_PRIO_MASKING);
 }
 
-static inline bool system_supports_mte(void)
+static __always_inline bool system_supports_mte(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MTE);
 }
 
-static inline bool system_has_prio_mask_debugging(void)
+static __always_inline bool system_has_prio_mask_debugging(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_DEBUG_PRIORITY_MASKING) &&
 	       system_uses_irq_prio_masking();
@@ -950,7 +950,7 @@ static inline bool cpu_has_hw_af(void)
 						ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
 }
 
-static inline bool cpu_has_pan(void)
+static __always_inline bool cpu_has_pan(void)
 {
 	u64 mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 	return cpuid_feature_extract_unsigned_field(mmfr1,
diff --git a/arch/arm64/include/asm/entry-common.h b/arch/arm64/include/asm/entry-common.h
index 1905765159aa..4856bc453c01 100644
--- a/arch/arm64/include/asm/entry-common.h
+++ b/arch/arm64/include/asm/entry-common.h
@@ -27,7 +27,7 @@ static __always_inline void arch_exit_to_user_mode_work(struct pt_regs *regs,
 
 #define arch_exit_to_user_mode_work arch_exit_to_user_mode_work
 
-static inline bool arch_irqentry_exit_need_resched(void)
+static __always_inline bool arch_irqentry_exit_need_resched(void)
 {
 	/*
 	 * DAIF.DA are cleared at the start of IRQ/FIQ handling, and when GIC
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index a67d5774e672..157d0551f627 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -749,14 +749,14 @@ void sme_enable_dvmsync(void);
 void sme_set_active(void);
 void sme_clear_active(void);
 
-static inline void sme_enter_from_user_mode(void)
+static __always_inline void sme_enter_from_user_mode(void)
 {
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
 	    test_thread_flag(TIF_SME))
 		sme_clear_active();
 }
 
-static inline void sme_exit_to_user_mode(void)
+static __always_inline void sme_exit_to_user_mode(void)
 {
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
 	    test_thread_flag(TIF_SME))
diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
index de910f1c19e1..cc2151325eb0 100644
--- a/arch/arm64/include/asm/mte-kasan.h
+++ b/arch/arm64/include/asm/mte-kasan.h
@@ -18,14 +18,14 @@
 /* Whether the MTE asynchronous mode is enabled. */
 DECLARE_STATIC_KEY_FALSE(mte_async_or_asymm_mode);
 
-static inline bool system_uses_mte_async_or_asymm_mode(void)
+static __always_inline bool system_uses_mte_async_or_asymm_mode(void)
 {
 	return static_branch_unlikely(&mte_async_or_asymm_mode);
 }
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
-static inline bool system_uses_mte_async_or_asymm_mode(void)
+static __always_inline bool system_uses_mte_async_or_asymm_mode(void)
 {
 	return false;
 }
diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 83f3b05fc784..b2bf2e70c9ae 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -222,7 +222,7 @@ static inline bool folio_try_hugetlb_mte_tagging(struct folio *folio)
 }
 #endif
 
-static inline void mte_disable_tco_entry(struct task_struct *task)
+static __always_inline void mte_disable_tco_entry(struct task_struct *task)
 {
 	if (!system_supports_mte())
 		return;
@@ -245,7 +245,7 @@ static inline void mte_disable_tco_entry(struct task_struct *task)
 #ifdef CONFIG_KASAN_HW_TAGS
 void mte_check_tfsr_el1(void);
 
-static inline void mte_check_tfsr_entry(void)
+static __always_inline void mte_check_tfsr_entry(void)
 {
 	if (!kasan_hw_tags_enabled())
 		return;
@@ -256,7 +256,7 @@ static inline void mte_check_tfsr_entry(void)
 	mte_check_tfsr_el1();
 }
 
-static inline void mte_check_tfsr_exit(void)
+static __always_inline void mte_check_tfsr_exit(void)
 {
 	if (!kasan_hw_tags_enabled())
 		return;
-- 
2.55.0


