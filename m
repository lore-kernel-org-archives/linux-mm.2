Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9BAC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A256B07EF; Tue, 18 Aug 2026 10:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931E56B07F0; Tue, 18 Aug 2026 10:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8481F6B07F1; Tue, 18 Aug 2026 10:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 603F66B07EF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:13:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12C0DA0266
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:19 +0000 (UTC)
X-FDA: 85114582518.23.948CF4B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 51DD31C0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PaEKXgo2;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGH5o20XlYNdJqh4RwaRs3CkSM3LsDiBgQWanQ/PwpM=;
	b=sUSuml7TE+CoIlZ3Co64Xuuq0WIr6WnkdFVCjeIHaPEcB/AqoWQeYpnvnoUQBRZe6qXQbm
	YjUduzJeo5FB22mH2LqC4G/FZ/15ESZdENGLptYL7jkSBbhzAxdmLwzm7LgaoqlkTGNQXg
	39H3wm07qpHJACqsbYHWVOwT61g/ADE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062397;
	b=jPfjB0FGuGvTr/LAysP1hL84TC8V+afQCRaOZ7WUDZPH7cFgsbcM8mY60nN/mvcYz1ogGj
	/PjzsQotePNMimPYGDK24JlcQDRIdxhQaws7VPJxvQCOrGjK+J74XGCgZBCP2iViMhQktT
	5X4tVjd+NhlkYqOgpaxKoI6ETRfWkAw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PaEKXgo2;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B02DB19F0;
	Tue, 18 Aug 2026 07:13:12 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC0423F85F;
	Tue, 18 Aug 2026 07:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062396; bh=xA0rE/FT+Rw5RceGcBEctNQLfvdtoipNdnlahnAV9wI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PaEKXgo2a1atscVqobA5We4qNxf3yVi5ZG5FeobOlPIHto7A3/fW8fx7aV9/rhYPm
	 NnNNbvcMY+3WSn6Qqk7VMrXlQvptFqtKrh2B8Lohqzu2+kdIK9sX20SjiqrJACpnSB
	 FG3ey81Jp9eVVlBZfnZtPXW3Hrv7qjmIK5L04TYg=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:09:05 +0100
Subject: [PATCH RFC v9 23/25] arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES
 switches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-23-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062277; l=4826;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=xA0rE/FT+Rw5RceGcBEctNQLfvdtoipNdnlahnAV9wI=;
 b=Lj0nrpoaI7njErVNUrG7scYHM7h+9q61FBZRj/CpRoG9vuWSBD3xy7JUED6CAcJU18tF1mcjK
 Cv+Trxvp1aLBxgvRj358Rq8G9Q3EbaKAkgUl60F7XAlpBgJI9m5Qhzn
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Stat-Signature: yeyx8w43aicnwnm39tt1bqem4mtsr75a
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51DD31C0009
X-HE-Tag: 1787062397-122965
X-HE-Meta: U2FsdGVkX1/99VjymfrCj/f0G5NQ1Z1ZODnaLgQsvu+yDFN42WXDqwzoviXoTpfQpm89CCw/a9sU+Wze0su9BpMngm9vbIYIX+MSPs8egJ0q6kFa2LFxvoN4Kji58gDeZSBBHz3hm6FLbAguqYSlWxiJnQ/P1CePOCk3vIEqKG/GLLxeZzgINxdffJMg5+fmkpOQp60V8O9PlYsZNWsj5lh2RIXztUuWDyEXNrHCA2a4GNFd/sXWCbcgZy0Z7lCVFPfT/00K7Ixr1PquhgrfVjDl/PvoznHmF0YzpJIs9KccYb15t7xxJV+wdidgoG7UKGladYl0dZVGdiZsiDySZrgyg0f7p2hlODt8Hc8jLCqRgtPtPBARUgYAm01jRDg5iNGfk/jCZvW89/ogdxNy88kQMFK3uTPq44BKx4TS1scDUFwCfM8XUhwwJjJRDqCME/REd2dQvisd+fsGWbCAsKV5rIk7+GDho7OkbE3HyHWJv28PPDgGuNvA3mHe0XP8w5H6pHiDmpv1HLZLMp4V5TMUnTo3RC84XMInO8eFgU8x8GQjABXO0++mhh+oZ+GoN0FLglKRK99caHz1gnn3w2p5XwGQebyXyKOKwdcFF+d5TKJXxpDAe7Hw5ukbeg0zb9cDsfGT5BhCfUiuYGX9+34EJdfR0HPP5wf/eEj5O3vp93wPcj9AxknImQJYL6bsmmzeY4QFQgYTX9P4dnHVd6y4gNEtI1sO+FGf4ftgw0wad/4ZuamrQ4+6zjN775C0ja5s7ms9SRTZDUCWCo1vZSfLeb3Ca4f6UAg5WUWPvo94FttzMErL4LZ7ZjrBBMIwD6ocCYC7ZGTgla+IsswGQQEE7p4MK+3OldpsH56/KJsGcdXnBHoktneYp3E4l1QZwbO7ZctokiqwrcdMrXAQmbX1XGdKjxr34C5EeaOLbHf5kYD36VZYd4UKdqZHxor7qsa1mtbOvlvnXTAJlda
 UEtQVhO7
 wtcEP6gfoTbczlYYde3+dq/4WmSmWKTM5B1+EoLX1zzuOYtRk3bDnzK7RP4Tkt+yIw39cS6QIaODGbG9uUHj+JXuw1KE36ADyZnLbaeqghc0EBnpUwbxBVmWFJOXGjScBtkY9IGM+ktkkCLBM6Lf6fbTQZJx91rggg2NZkoHK8zVkpPiGSV324QzQUBY3BYW0tnJo/xscptIfb+KllRktgrYis+4hXvJtu6LwAGWEkYa0sLVJ69OA0GfcgVNxRLQRjJFlmPYGzZLFJJtoXsl01P4E/bRT4YF/qXujshFNGq8HMesrIM5C6d64eQvJCPpYxCNrkpgVx+ofIj1U2Nld/nN3rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables feature currently switches kpkeys
context in every helper that writes to page tables, such as
set_pte(). With kpkeys implemented using POE, this entails a pair of
ISBs whenever such helper is called.

A simple way to reduce this overhead is to make use of the lazy MMU
mode. We amend the kpkeys_hardened_pgtables guard so that no kpkeys
context switch (i.e. POR_EL1 update) is issued while the lazy MMU
mode is active. Instead, we switch to KPKEYS_CTX_PGTABLES when
entering the lazy MMU mode, and restore the previous context when
exiting it.

Restoring the previous kpkeys context requires storing struct
kpkeys_state somewhere. POR_EL1 is a full 64-bit value so we cannot
simply use a TIF flag. There is no straightforward way to reuse
current->thread.por_el1 for that purpose - this is where the current
value of POR_EL1 is stored on a context switch, i.e. the value
corresponding to KPKEYS_CTX_PGTABLES inside a lazy_mmu section.
Instead, we add a new member to thread_struct to hold that state
temporarily. This isn't optimal as that member is unused outside of
lazy MMU sections, but it is the simplest option. Nesting of
sections is not a concern as arch_{enter,leave}_lazy_mmu_mode() are
not called in inner lazy MMU sections (nor do we need to do anything
there).

A further optimisation this patch makes is to merge the ISBs when
exiting lazy_mmu mode. That is, if an ISB is going to be issued by
emit_pte_barriers() because kernel pgtables were modified in the
lazy MMU section, we skip the ISB after restoring POR_EL1. This is
done by checking TIF_LAZY_MMU_PENDING and ensuring that POR_EL1 is
restored before emit_pte_barriers() is called.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h   | 50 +++++++++++++++++++++++++++++++++++---
 arch/arm64/include/asm/processor.h |  4 +++
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b4e52d6bb6ba..6e5d14c7e8b8 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -43,10 +43,44 @@
 
 #ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
 KPKEYS_GUARD_COND(kpkeys_hardened_pgtables, KPKEYS_CTX_PGTABLES,
-		  kpkeys_hardened_pgtables_enabled())
-#else
+		  kpkeys_hardened_pgtables_enabled() &&
+		  !is_lazy_mmu_mode_active())
+
+static inline void kpkeys_lazy_mmu_enter(void)
+{
+	if (!kpkeys_hardened_pgtables_enabled())
+		return;
+
+	current->thread.kpkeys_state_lazy_mmu =
+		kpkeys_enter_context(KPKEYS_CTX_PGTABLES);
+}
+
+static inline void kpkeys_lazy_mmu_exit(void)
+{
+	const struct kpkeys_state *state =
+		&current->thread.kpkeys_state_lazy_mmu;
+
+	if (!kpkeys_hardened_pgtables_enabled())
+		return;
+
+	/*
+	 * We skip any barrier if TIF_LAZY_MMU_PENDING is set:
+	 * emit_pte_barriers() will issue an ISB just after this function
+	 * returns.
+	 */
+	if (test_thread_flag(TIF_LAZY_MMU_PENDING) && state->entered_context)
+		__kpkeys_set_pkey_reg_nosync(state->arch_state.por);
+	else
+		kpkeys_leave_context(state);
+}
+#else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 KPKEYS_GUARD_NOOP(kpkeys_hardened_pgtables)
-#endif
+
+static inline void kpkeys_lazy_mmu_enter(void) {}
+static inline void kpkeys_lazy_mmu_exit(void) {}
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
index 8d7fa479cd36..23660a233da2 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -30,6 +30,7 @@
 #include <linux/build_bug.h>
 #include <linux/cache.h>
 #include <linux/init.h>
+#include <linux/kpkeys_types.h>
 #include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/thread_info.h>
@@ -196,6 +197,9 @@ struct thread_struct {
 	u64			tpidr2_el0;
 	u64			por_el0;
 	u64			por_el1;
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+	struct kpkeys_state	kpkeys_state_lazy_mmu;
+#endif
 #ifdef CONFIG_ARM64_GCS
 	unsigned int		gcs_el0_mode;
 	unsigned int		gcs_el0_locked;

-- 
2.51.2


