Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02729607360F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GVdukjlx
Received: by kanga.kvack.org (Postfix)
	id 8B5236B05D3; Mon,  9 Nov 2026 11:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818166B05D4; Mon,  9 Nov 2026 11:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE9C6B05D6; Mon,  9 Nov 2026 11:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD9F6B05D3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:02:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4C6D1206E9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:16 +0000 (UTC)
X-FDA: 85416047472.01.36DB45F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D51191C0010
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GVdukjlx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240135;
	b=hZHuviLhm7iP1lfGbySQy6/eh0LSHfI4E0a0Loube9fVsLxIRe47RXenrfBEeHiZKYU1AJ
	cz17gJMpWzqVgOrKzcdBEKv/lw8wgVSDUptGWIsBdwywzbVweg5k+wYru2j3VpUiPOXp9V
	HFRhOArgE9KKnXX+uD8SIjv+PxWn2+o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTGmKFM4xFszxJT3yvxzfIEd2u2ou6U+2cFfGcbONdk=;
	b=cYLfWQSmwZNa5fmW+DzG3d+RCXFJLnylkz1sbK/hxiH92pglpdFxEavA16TuZpbBYxOuZD
	m4Fbp22Q5z9f1/3SL+eBeDGjP1csvTSiNqnmfcO0NIMnB1AEl0ZRF/7dXcXu01KiugpvfI
	+9AnOhq0TOkCaqMYocndpbi1vgO0dUE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GVdukjlx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF5DC2F;
	Mon,  9 Nov 2026 08:02:10 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E30A3F632;
	Mon,  9 Nov 2026 08:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240133; bh=xf4mnCbgRoC4McQQdkoE98wQ+JFumNK4YzHFaYloEOc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GVdukjlxt6BJwkZ8GSCwyaHoZsS5MHrj9UxdrQv4DpZ0VhH9HMytRJs38rarGnK4j
	 OBxKYeC/zG2+fIYLmXWZGCRbr0d0+d9CFANUIsspLIWmtRkQefPXHSzO2Eoc6PQiQV
	 tWWWmYdglDOQOBmXELlKZUa8M3SaMqzZwiKODvgc=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:44 +0000
Subject: [PATCH RFC v10 19/22] arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES
 switches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-19-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
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
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=4874;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=xf4mnCbgRoC4McQQdkoE98wQ+JFumNK4YzHFaYloEOc=;
 b=Gmrm9AOzE5rqNW6yMYk/EZ4iMTeukSeNRN048Oj3iqazwl2o/qZJ7PMOI+du48vXZZGmLoSb+
 V8grDTumbALC+mu+7PvZ5/wbybQgeL9EMYZI23gO7yjsEiiXRrkqGFI
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: D51191C0010
X-Rspamd-Server: rspam12
X-Stat-Signature: qd9mis1br83yxihebq3fjd1xkg1f6da1
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240134-463778
X-HE-Meta: U2FsdGVkX18TgMEgjSZYxr9kjKXmSaDNQezxNK58JAc5sDy9L789eQKImvl7hpaJYaNTUEKL6HS/1M6x8btmx9wWYsrva4c5+/BP+8dfH3BVx4ts2F/CgMrpaaxD62Aq9FgtKJ4StqkgoLwbeOfQgtSLNGTGYkygAuVxv5Z+XHJmnvmjsQr95rW7M1B2x0s5PgeuMSAgQl6+wQeSksr+0EZ3ZudH7wRSFkJKRqqW3g4dwhqy/TAAxUscji17DWJaeI7gq9oDZBUvzo86JmcWPqXK+DouER0unzgoahOdSLP/Qky5zQTok9/hKpwEiDGbrXhJmVT8xoHklfpMufWU9knPwy+o7fjPa9NuLqRT5H542+uciC3Qe2tlqK9Hn7tH+5nTFRJRUdmAfSCPaSLB9kPHtmr5OkNbACmBPctloicUusx6EMXmVxSyW8WJU0tj1d+e0pYIUIy6tVmqrglv5f9CvWqHHFpT93HZh2TaLRsbX7cjt6qy5yJq1MhSKuVNIEZgvRcF3pedkMNMfOoMxknmBz8FgYP3+rY+4Gdvh/LX7NYhbDmPtYWCu2TI+AE8Lx1T3my/hpJPyIP6vqEe0JvId0f44aucx3ztozXevBFg8oTfIOHATUpT6w9YLeiXy/zG7qjQ8/s6jYM+v2m+NPYgaAliVcXIW/bOxLazksW6YYyajNWQ7gad7y5O4+kDIoXT8QaAboQB2t5Qyf4NS2JHaf3o/H0jAbLVgrasfcfyFPU/1MbhzPUQoSn9WXgMHTbCjhR4YkLGXUyxCjr4dhodoIcXjhCRPt9GPwjvFL/ig/7kSNgLXX9lVKXH6SDYkMuVGPuCIT0HZcsT0bkqvM7K8tl82VBtcdDQA+hdKWZ6OnI8fMfSqv9Ktw5UNOaPrS/UIoaWFSLD5jWxMG92pr3JYNRh6BfSfaC7saov93a2xCzmVQ9dSFv79j96W9omE+PB8G1aKOjtNIYQlf7
 +8bmYHbg
 FPoSQ3M37RpahgdCCVvT6U5IqE0I3kKNDf8Nwiss/qjQFVHL0kKP2RwEJS+ZpqLCtLF1IebPNcilMnIMbW3QG+U+1EEWN6CUwdw3Y8fOIA8qsvPZg/PBeWzdnUeWoimAV34+K6xfYzxUunE7cQ3ug/3P5apItN3p5uv5/sG2J3Ugk0XWCSbgmueIFW2H2VRRJKFPtd/8NQX3Z/VQ21Jxb94YZ8wPyn0R26NVayfiyW4vQjb5PIsYtYDNS21stafrzplA6SZ0ufof8iP0ho+09m2UqeXfKt8to9KZmf5I1tJDFAsp/wyk8eCnb/Ofo5H07GsC4/bId1hCS8XbJoFderJ1bIFUrO0+swTIPs0ThH4hZI0Hc12cFz0IdNS0KyNjTKRdcI3PDwZzZHuWcTgweP4K8gDGpycXB1XehXRgLAL3n2Vah6J6ScdwhTAE+HbPQ8J/dhxsOEUEo8l4K/dgYJGUSwsmdhRgO7wsdKtqov867Aaa5Bp3yWftkJva3UTXUvShPWIQD8HgY546AlvbgJtlCPrj9dtmowlmE0WJVKoAqrTKExaIyHZzuqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h   | 50 +++++++++++++++++++++++++++++++++++---
 arch/arm64/include/asm/processor.h |  4 +++
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 5f46d4cb3882..5e958531e6ab 100644
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
index 18424d91d8b2..e96c4d57d67d 100644
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
2.56.0


