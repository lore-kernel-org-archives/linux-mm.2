Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD73CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2458900223; Fri, 15 Aug 2025 04:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD47C8E0002; Fri, 15 Aug 2025 04:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9BE9900223; Fri, 15 Aug 2025 04:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A61A08E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7042B138B83
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:56 +0000 (UTC)
X-FDA: 83778386832.13.4A5BD5A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id D41F140004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVo+LMeXy5hXM+ZwYD+5aH17rWprZXkR1ZR00HmTfjo=;
	b=rrxDepiFgse8k0Oeo4zyjJm+qPAMcW5K/bjcre/nA0z6pyyEbAl571g+qZQzP+R/Sj4xf/
	cs9h770TKC8EBoDF5o2SbWv0L/WJizeCZs2bIQav08kMqtRGMX5y6Wg5GbcxnTUOH12TXU
	vI21fej/g0aYo4+UYsObRkfLKcTY4ww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248215; a=rsa-sha256;
	cv=none;
	b=5i+4on6OSFJraolJYnBKkLCIvukRpZLkexMhW1GKXDGFI+ZPYM+luzNImdrT5mfboQzNDj
	pk+OWS4wGnqfJOslXeg0QYhlpdg2gfGHCS6pDrTgz63e9f3ugx2k19ZR3RJqLNicHWt7Y/
	gIZzYnKYWM5IA1Jfv3oJOfv0wZaPPCg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0891F497;
	Fri, 15 Aug 2025 01:56:46 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A20AA3F63F;
	Fri, 15 Aug 2025 01:56:49 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 18/18] arm64: mm: Batch kpkeys level switches
Date: Fri, 15 Aug 2025 09:55:12 +0100
Message-ID: <20250815085512.2182322-19-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D41F140004
X-Stat-Signature: jjhezy1xfk6umfpecs69mxud9aay1hot
X-Rspam-User: 
X-HE-Tag: 1755248214-3688
X-HE-Meta: U2FsdGVkX181atqyo7l1rHAtotQS5ir4Yk55Q/kFK/2YE9jKy2/N1QkImebum+3+aRKWTLeI2hznMF/USCqW6+jSla5EN7nQCr+lR87ClrbdveHUlXomIUNIS5Kye8Q/hfCdMrQAf8+uG+YNrqvi/J/pSszZugzfyLXgUK4MOdEDipPXxjL4lUr/KQv3vG3w90yptzjgXw7Iqh/N/9MwXkE3HuCq1oPykQWhclvIkRlkIwbfebPv93GuPQrpRkH2p6aDj5fU+WZlM9ETafWa0hqGXv6Ri5W8VYEf/q1fXbOTk85PGTC6k4NXAhU8vcbLRUot1JFwf8qPsT//PRet+kLHmwll+GTJDSvAydjynIYoigPMBnNOam9XKur82V6k7LN0vikgBR30yhAnclrFMaeWJRXyoiU8WDj+xqWOgl6wu4JLE3IooPtngSRIRcXX5YlJvufiAG7DzR/LjhjqD4JdZqcOT1rN6mxebt0QdHsTawGsRjflchT+O5JuUyNxpJ7duYWDAtOxu/+0+o6w/buYyesspwHKKRfzdigBHEHXD/Gm7fbtI0+/7LHScDIXwKkN8Ud5Kv2F52aeMPdfc7o/aM55BrlViTB8PcK6TuW02KZKyAFC6AlTNR5x3KMiBMBYa0bc9QP2NAU3ybcgzVXeqC44aCcQIrA1dOYn7niCJQIqJj36y5WfVJsu/FU3m+IiVT7Yf9Bt6dhHogjCjN+IqjyYglilOyW29qQ5cBUFBKztuXsL57QxQs8j1uKfgqocPUkByMWW6IjfmaKRuuHSp/cn4dmSwBcFFfmRz0LwW9DJYEd9wFTuDE5nRW4aSx8VfOWNvopqkUAvijox916uOj2DsEi8qwurdVQqyvT7Hu0s/zPKM2bBxTh3/PoR7VLS6ad6cKd84Zl/gzrHLjA3d02a9Hwuf63tY8gjpX1fGHAy2D73QGoPQbfPxrDORwAzBMtcn3Ur2liATgs
 8gTcb7B7
 2BPKcUXPDy/le5nB1shCXRkl7aEVjrTwSzllOX19/rMB0auCKBaduCAK74Y53Nieni/u3B+Lor+2x4ezBwGYeC7KVbLuIUHWjQgOrLGYzZunAFIG+U+fGrAWDEzVkl1XpeSlKdeurVV/e/2yeXI6L8GDvc/OO2WHy7egRMrxpZZQVeqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables feature currently switches kpkeys level
in every helper that writes to page tables, such as set_pte(). With
kpkeys implemented using POE, this entails a pair of ISBs whenever
such helper is called.

A simple way to reduce this overhead is to make use of the lazy_mmu
mode, which has recently been adopted on arm64 to batch barriers
(DSB/ISB) when updating kernel pgtables [1]. Reusing the
TIF_LAZY_MMU flag introduced by this series, we amend the
kpkeys_hardened_pgtables guard so that no level switch (i.e. POR_EL1
update) is issued while that flag is set. Instead, we switch to
KPKEYS_LVL_PGTABLES when entering lazy_mmu mode, and restore the
previous level when exiting it. The optimisation is disabled while
in interrupt as POR_EL1 is reset on exception entry, i.e. switching
is not batched in that case.

Restoring the previous kpkeys level requires storing the original
value of POR_EL1 somewhere. This is a full 64-bit value so we cannot
simply use a TIF flag, but since lazy_mmu sections cannot nest, some
sort of thread-local variable would do the trick. There is no
straightforward way to reuse current->thread.por_el1 for that
purpose - this is where the current value of POR_EL1 is stored on a
context switch, i.e. the value corresponding to KPKEYS_LVL_PGTABLES
inside a lazy_mmu section. Instead, we add a new member to
thread_struct to hold that value temporarily. This isn't optimal as
that member is unused outside of lazy_mmu sections, but it is the
simplest option.

A further optimisation this patch makes is to merge the ISBs when
exiting lazy_mmu mode. That is, if an ISB is going to be issued by
emit_pte_barriers() because kernel pgtables were modified in the
lazy_mmu section, we skip the ISB after restoring POR_EL1. This is
done by checking TIF_LAZY_MMU_PENDING and ensuring that POR_EL1 is
restored before emit_pte_barriers() is called.

[1] https://lore.kernel.org/all/20250422081822.1836315-12-ryan.roberts@arm.com/

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---

Unfortunately lazy_mmu sections can in fact nest under certain
circumstances [2], which means that storing the original value of
POR_EL1 in thread_struct is not always safe.

I am working on modifying the lazy_mmu API to handle nesting gracefully,
which should also help with restoring POR_EL1 without using
thread_struct. See also the discussion in [3].

[2] https://lore.kernel.org/all/20250512150333.5589-1-ryan.roberts@arm.com/
[3] https://lore.kernel.org/all/20250606135654.178300-1-ryan.roberts@arm.com/t/#u

 arch/arm64/include/asm/pgtable.h   | 37 +++++++++++++++++++++++++++++-
 arch/arm64/include/asm/processor.h |  1 +
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 1694fb839854..35d15b9722e4 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -43,11 +43,40 @@
 
 #ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
 KPKEYS_GUARD_COND(kpkeys_hardened_pgtables, KPKEYS_LVL_PGTABLES,
-		  kpkeys_hardened_pgtables_enabled())
+		  kpkeys_hardened_pgtables_enabled() &&
+		  (in_interrupt() || !test_thread_flag(TIF_LAZY_MMU)))
 #else
 KPKEYS_GUARD_NOOP(kpkeys_hardened_pgtables)
 #endif
 
+static void kpkeys_lazy_mmu_enter(void)
+{
+	if (!kpkeys_hardened_pgtables_enabled())
+		return;
+
+	current->thread.por_el1_lazy_mmu = kpkeys_set_level(KPKEYS_LVL_PGTABLES);
+}
+
+static void kpkeys_lazy_mmu_exit(void)
+{
+	u64 saved_por_el1;
+
+	if (!kpkeys_hardened_pgtables_enabled())
+		return;
+
+	saved_por_el1 = current->thread.por_el1_lazy_mmu;
+
+	/*
+	 * We skip any barrier if TIF_LAZY_MMU_PENDING is set:
+	 * emit_pte_barriers() will issue an ISB just after this function
+	 * returns.
+	 */
+	if (test_thread_flag(TIF_LAZY_MMU_PENDING))
+		__kpkeys_set_pkey_reg_nosync(saved_por_el1);
+	else
+		arch_kpkeys_restore_pkey_reg(saved_por_el1);
+}
+
 static inline void emit_pte_barriers(void)
 {
 	/*
@@ -107,6 +136,7 @@ static inline void arch_enter_lazy_mmu_mode(void)
 		return;
 
 	set_thread_flag(TIF_LAZY_MMU);
+	kpkeys_lazy_mmu_enter();
 }
 
 static inline void arch_flush_lazy_mmu_mode(void)
@@ -123,6 +153,11 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	if (in_interrupt())
 		return;
 
+	/*
+	 * The ordering should be preserved to allow kpkeys_lazy_mmu_exit()
+	 * to skip any barrier when TIF_LAZY_MMU_PENDING is set.
+	 */
+	kpkeys_lazy_mmu_exit();
 	arch_flush_lazy_mmu_mode();
 	clear_thread_flag(TIF_LAZY_MMU);
 }
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 9340e94a27f6..7b20eedfe2fe 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -188,6 +188,7 @@ struct thread_struct {
 	u64			tpidr2_el0;
 	u64			por_el0;
 	u64			por_el1;
+	u64			por_el1_lazy_mmu;
 #ifdef CONFIG_ARM64_GCS
 	unsigned int		gcs_el0_mode;
 	unsigned int		gcs_el0_locked;
-- 
2.47.0


