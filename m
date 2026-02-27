Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E237FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01DC6B00CB; Fri, 27 Feb 2026 12:57:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD92A6B00CD; Fri, 27 Feb 2026 12:57:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2396B00CE; Fri, 27 Feb 2026 12:57:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA7A86B00CB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83F43BB774
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:57 +0000 (UTC)
X-FDA: 84490994994.10.408A47A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id D12BF40010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFDuZrBEYUf6hXbfFPQiqP12kFEqpv3OcuBBYDHYqYg=;
	b=IPkDsaNhAlCkLnyIVFuO7As/V8kRgwC/DmQH8L9ZQD3d9FfSSUqjntys/IUy05L7egt2vB
	93WtMkYHLhj8ngJk5sUMyjgIDI/V/hPv6XaNbuaoBW1fxhIhTIORhRtXux5TKqsmi8pb3G
	ZP5dYJ9NHjBolAZeX1w073CoTtsjO2w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215076; a=rsa-sha256;
	cv=none;
	b=RYqisKcIRsyP2yKGlceEsS/Xo+YHD2ohmS0lDF/MgkRaO9P9UWnVrMwq6S3pmTsTIBAx80
	5bErHO7s3rEKIAiRnTnBzM/GFquvEbht0El7WfM35Y2eX6Tv3WCyFe7T3csGtynGAlOvk3
	JMxW1dZYE4vO43q9QkfwhgkbpRAIiJ0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9017019F0;
	Fri, 27 Feb 2026 09:57:48 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7AB023F73B;
	Fri, 27 Feb 2026 09:57:50 -0800 (PST)
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
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 28/30] arm64: kpkeys: Batch KPKEYS_LVL_PGTABLES switches
Date: Fri, 27 Feb 2026 17:55:16 +0000
Message-ID: <20260227175518.3728055-29-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D12BF40010
X-Stat-Signature: q655kxuu6r3qpmxzfguqradi9ng8c1nz
X-Rspam-User: 
X-HE-Tag: 1772215075-709926
X-HE-Meta: U2FsdGVkX19VoXPQExbthyy79nxrafUgdy2XXzjfRIo5LtsCHupIyDVxlMRCeRh/vjJRCM4sX/Wx9N4UU338V899mmiEcTnV8qgFezgn7xfODmrwkceonKddXeoTjzO2AQ8qpdLsx4qBQmpp+bEQVeOA4DZ8y7fczEczM/Yqy5FX7ADiDijn4/pgZ60QcMi3eew9cVfpttNXcoOA8EZkfN1LwYuqGuVTcrGB0W5tytHVZpd7TAuwp8Evx1znckeztcVMNd+ZaU2a2J16OHYu/b4jLPDBbijbkPXfNX1RDKIB7fP2HPUnTxqzozbT1/qQJteYMMp2r+s4PWoWNx1sb0QAmnhg6ScNtTztPDk5Nxi6/AaylGp5QSLPq3HYPIWjFnVv7sidF/FF3qIJvivu7xJqbD4yqd7KIFOvWKTIeT4sfuCFTQVyBiuQX4eFVQmvVtDr5G4PJpNyH4XU/TTvSToimIA2x3c43xRoZplW5kNRI203rLziaX0JoLvYD1P4LmspQV164QpXqO1j11mn3JMKbAlypJjYn/7dzv0ddoFpfj6YugptHYegxlAAFhVJgjVGrW4EApYTc8zERvdtdn9cFrOt5ocAsBwBML74GRMsXiegHh/GNDv24lRoc7LsM/C+AIDhCWmcNPnOMuTqGWeh0meJ+d36gKN1NvjJHu1ONAY903Kor1na2Zo3Wfqbtdc/PtgZzkewhRiKTlBsN+IZ1LmzC0Mq0+kBb6fO3HUIWwyJnkXKaFYHY8EkspEJMHyojM1S0HyvDLfWCL6K3/8gLYTbE0AsvoYeM+zLWLl2UDClIXCqpkAKM1tiHJBvxY8c3SUsX+J1k6e6w44rscEvq1e/+piQ4xefNd0thJaAJp3mSpUfvvVA4VFTZAPfhnBOal9XkzukVHK8QLF8ndOuioduw6GM+9fjquE5nKcjiZIgxmD4G7yJbADriDL8ekJfFf2WQnPiuLNGM/2
 tct9xA4V
 Jhx871DoCOOWITQT2wahtZu40AUhn7S30sbcr1m8G6XGeom9ExgIumHJrE2QlekiM+dGicidXGZrRrjhl+seT0pnYbS+cG/JYDaJSvp57mkRsGEA43IptlwjxoS8mIKei0alQsR7Mr3qNapNk59AYfryfrl+7K7sSz6By
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

A simple way to reduce this overhead is to make use of the lazy MMU
mode. We amend the kpkeys_hardened_pgtables guard so that no level
switch (i.e. POR_EL1 update) is issued while the lazy MMU mode is
active. Instead, we switch to KPKEYS_LVL_PGTABLES when entering the
lazy MMU mode, and restore the previous level when exiting it.

Restoring the previous kpkeys level requires storing the original
value of POR_EL1 somewhere. This is a full 64-bit value so we cannot
simply use a TIF flag. There is no straightforward way to reuse
current->thread.por_el1 for that purpose - this is where the current
value of POR_EL1 is stored on a context switch, i.e. the value
corresponding to KPKEYS_LVL_PGTABLES inside a lazy_mmu section.
Instead, we add a new member to thread_struct to hold that value
temporarily. This isn't optimal as that member is unused outside of
lazy MMU sections, but it is the simplest option. Nesting of
sections is not a concern as arch_{enter,leave}_lazy_mmu_mode() are
not called in inner sections (nor do we need to do anything there).

A further optimisation this patch makes is to merge the ISBs when
exiting lazy_mmu mode. That is, if an ISB is going to be issued by
emit_pte_barriers() because kernel pgtables were modified in the
lazy MMU section, we skip the ISB after restoring POR_EL1. This is
done by checking TIF_LAZY_MMU_PENDING and ensuring that POR_EL1 is
restored before emit_pte_barriers() is called.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h   | 50 +++++++++++++++++++++++++++---
 arch/arm64/include/asm/processor.h |  1 +
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 8c85e23223da..556de0a4537e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -43,10 +43,44 @@
 
 #ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
 KPKEYS_GUARD_COND(kpkeys_hardened_pgtables, KPKEYS_LVL_PGTABLES,
-		  kpkeys_hardened_pgtables_enabled())
-#else
+		  kpkeys_hardened_pgtables_enabled() &&
+		  !is_lazy_mmu_mode_active())
+
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
+#else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 KPKEYS_GUARD_NOOP(kpkeys_hardened_pgtables)
-#endif
+
+static void kpkeys_lazy_mmu_enter(void) {}
+static void kpkeys_lazy_mmu_exit(void) {}
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
+
 
 static inline void emit_pte_barriers(void)
 {
@@ -79,7 +113,10 @@ static inline void queue_pte_barriers(void)
 	}
 }
 
-static inline void arch_enter_lazy_mmu_mode(void) {}
+static inline void arch_enter_lazy_mmu_mode(void)
+{
+	kpkeys_lazy_mmu_enter();
+}
 
 static inline void arch_flush_lazy_mmu_mode(void)
 {
@@ -89,6 +126,11 @@ static inline void arch_flush_lazy_mmu_mode(void)
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
+	/*
+	 * The ordering should be preserved to allow kpkeys_lazy_mmu_exit()
+	 * to skip any barrier when TIF_LAZY_MMU_PENDING is set.
+	 */
+	kpkeys_lazy_mmu_exit();
 	arch_flush_lazy_mmu_mode();
 }
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 6095322343fc..c3a86ddce637 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -193,6 +193,7 @@ struct thread_struct {
 	u64			tpidr2_el0;
 	u64			por_el0;
 	u64			por_el1;
+	u64			por_el1_lazy_mmu;
 #ifdef CONFIG_ARM64_GCS
 	unsigned int		gcs_el0_mode;
 	unsigned int		gcs_el0_locked;
-- 
2.51.2


