Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE4C606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N35wPGsJ
Received: by kanga.kvack.org (Postfix)
	id 294766B05BA; Mon,  9 Nov 2026 07:05:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C156B05BB; Mon,  9 Nov 2026 07:05:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9F06B05BC; Mon,  9 Nov 2026 07:05:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9F386B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:05:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71F1CA069A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:22 +0000 (UTC)
X-FDA: 85415450484.20.E878467
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CFC2BA0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N35wPGsJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225920;
	b=liwz2YF/Eb/QiyFOY0w6JojzQCDxG58456NCVgVZvJv3qJL62VlXgtod8NpvklH2fwuANP
	TXQ+BtkhxDYYdFWQZEc6WTYqWhU30t3/FU9H7a+U1dFdo2Ij86DjGh3kXa7hSsa/i13f18
	Yw138cQfVREFrpr5f+s4dooCrTL76Yk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KskkUGty1iNE6UcXC+HDPavjLCWymN3yFFfBa9g833A=;
	b=HT53jfMfm/BXNft4mm/bJF6yzAPxZUlUr/BJMKGoZOqZNoeEIid0SE40sIwBuhRheKYXpq
	gZ2Zsov0vsS76bmCbdaKIqur+FG8eGhwRGf/WfAwSAhchAAvtf6LgaP8k0GW3BmVLUSVp9
	220Iv7oh5iI8rMYAdZVz+O1It2AA20o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N35wPGsJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7166763175;
	Mon,  9 Nov 2026 12:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C9E1F008A3;
	Mon,  9 Nov 2026 12:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225920;
	bh=KskkUGty1iNE6UcXC+HDPavjLCWymN3yFFfBa9g833A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N35wPGsJeoWxIpoO2dJegT1A+/siw7F+lbw9O6kSfXRd8gTt3+YU2u7TBAAugmZZ4
	 EpzNTiU1BYgnv1CkT4VxnMEuENCH/Xqm1/ZffZGSzbHea/e3a2QxXTt7/L7o88CHR8
	 F7eH0ry+5GU2+UESUSIAmxBfG7gGLwwfd7eFKSmTbKZuZSNRCwLZTJ7GCW4Sj2zsv4
	 b4sTpXn1ihwfIArihA+4swEoa1Kabiirwa/SRtMXCHZwuJX46cL1d3a9lTgpHuZxPg
	 P8fNaPHNMnaZPhLsQEwJPkbRZFsjM7RD4CQ/QsStaCRpJmKK2aHLJWSHULGvVdzRUJ
	 G5dPd1AnGBTXg==
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
Subject: [PATCH v2 2/6] arm64: entry: Always inline helpers used by non-instrumentable paths
Date: Mon,  9 Nov 2026 19:44:55 +0800
Message-ID: <20261109114500.20298-3-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261109114500.20298-1-jszhang@kernel.org>
References: <20261109114500.20298-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CFC2BA0003
X-Rspamd-Server: rspam12
X-Stat-Signature: zohsh79ectpi5kni5w19cgpcn7fry3gn
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794225920-820336
X-HE-Meta: U2FsdGVkX19UwO70Bl6Ce7NtZeSCFsejVZdDkGE+rYDVkJMceFWjaKL5NXY2TF7BsZUtCz3g6dVqnvtTdRu4rBRkritOgDVHTv5ewdVCZEd4NTOay3aqRq/C8Y0rnlJuIlZQ4N1YBM5KdGAEE1ZBzN8sUWRnlPQpg+stsfZ9a7/P54t+bBmZti9AG7dQ2x5I1vt+4X9m2OG6M7XW2TUT8BgaBYPwu7ljE4mCgA5/nGeZ4EkV3OV4AW/bCSztf7x+cZ7sIrLc1vAOkWQWnNuBFKvIuOQHLmGYmGhhuUwgKyjQ750vmouN0Rea+z4W1PEam/J9Zetu5A7vNip96viLc2XGPa59j2lSd81/1Irv+ecNTcMHyJhuJsivo93AgddRDaiqH9qpTTcR0yKPU2NsVbaFai58g1OvWbMmJa/T7TG+AeniJroklMGV1E+B2PU+VSjANiRNBMi/c4Clmf4c8WoSNqvuVv8bNZnBx20Vu1YJGxWa4boR75QRw/rzl6XvCvsrrVuN4r6QwYGAnF24k4QU4eT6aX58LMvqBUKRUZJYANvdkikU2Hs/mn7dGGPL9jXd0yUikz+4hqGrpVKItkO6KcJLkmG5gQ4z3zrWzAqC9tIfSm0Lc7agoZWXgILzENerq3jadl+EfGtGYp6RGOd32OuQBeqtHPnLQGk7xvTGxjeLSfg/ktqt3nMSpdAvY80qMuK0LvBkjRLIa0PUiJQtfOikOMO8u5x9UNqsa7c5bL6j5vDhotUziUttQ60s9rxhVYits55wwybi9wdywEtXhJsrn4JI3danEpcd6VvvSbsTsien5S9at054CAGmUYpXkZM7okX8duSNPX+wKlAe5JDZsaGynppkxzkVSfgNVQmRgF3r0hZ0GaU3NLQ9wMAezqFw9Q3DfoF+1ZEwgwpzhA+zMPlVjkNusUwOvubJ6rUf3zEy55+MUva84Ys/27bjxVEPOGJX9Q7/U+4
 nDCb8oT8
 poUzxeoW3HPoiwOk2XYt7tjSw0dGmf5vhta9H3CihvVKqYH8RBfxVVPN1a3TG7zE+4QfW5IUe5pixsiVIVZe42Jl4FRq8pZ+jU/KWj5NNi8R1RpEVymLzWbMXTdMlf1quMr6zMWhAOsUhUeWE0++5SIB2RIOo8exM6O8hwZvGZ6UVoZT00gqlFPT4GqM4MWPfQjOgO6sCDQEeFVSKUgkTlOfqa4eoGkJMw2klcfDi4Zh32OVpn5x0BKYoTiw4fMR+mk/sP03+doYIVkdjjvMGjRicWYFJvsOSgqp1gv9x80ziX5vrJt95XFKe8qEEHzN26HtuJ4wyhAkFDQHxVdNWyJZm7ruHFrqFGztmY4qusOQM434moU3hyKUDdyfgZGh+8ERhmfqlXrAmDjO0XxPqQ9SpJHtyXT6elA8sg8YxynhCufw=
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

Also update sme_enter_from_user_mode() and sme_exit_to_user_mode() to
use tif_test_bit(TIF_SME) instead of test_thread_flag(TIF_SME)

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Assisted-by: LLM
---
 arch/arm64/include/asm/cpufeature.h   |  8 ++++----
 arch/arm64/include/asm/entry-common.h |  2 +-
 arch/arm64/include/asm/fpsimd.h       |  8 ++++----
 arch/arm64/include/asm/mte-kasan.h    |  4 ++--
 arch/arm64/include/asm/mte.h          | 10 +++++-----
 5 files changed, 16 insertions(+), 16 deletions(-)

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
index a67d5774e672..e7c881c1c1f7 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -749,17 +749,17 @@ void sme_enable_dvmsync(void);
 void sme_set_active(void);
 void sme_clear_active(void);
 
-static inline void sme_enter_from_user_mode(void)
+static __always_inline void sme_enter_from_user_mode(void)
 {
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
-	    test_thread_flag(TIF_SME))
+	    tif_test_bit(TIF_SME))
 		sme_clear_active();
 }
 
-static inline void sme_exit_to_user_mode(void)
+static __always_inline void sme_exit_to_user_mode(void)
 {
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
-	    test_thread_flag(TIF_SME))
+	    tif_test_bit(TIF_SME))
 		sme_set_active();
 }
 
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
index 83f3b05fc784..de71d3449064 100644
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
@@ -278,10 +278,10 @@ static inline void mte_check_tfsr_exit(void)
 static inline void mte_check_tfsr_el1(void)
 {
 }
-static inline void mte_check_tfsr_entry(void)
+static __always_inline void mte_check_tfsr_entry(void)
 {
 }
-static inline void mte_check_tfsr_exit(void)
+static __always_inline void mte_check_tfsr_exit(void)
 {
 }
 #endif /* CONFIG_KASAN_HW_TAGS */
-- 
2.55.0


