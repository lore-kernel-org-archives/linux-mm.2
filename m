Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2137CD5BD2
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321416B00BF; Tue, 26 May 2026 07:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9A46B00C1; Tue, 26 May 2026 07:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F9E6B00C2; Tue, 26 May 2026 07:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0CD6B00BF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5950403CD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:54 +0000 (UTC)
X-FDA: 84809323788.28.BDB663D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id E7658C0009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z2yhCO+0;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emygvYxhkWsqMuM5q9K6kqLmMjPTQyXSCWgwyuJaPJY=;
	b=w6mkpSnA9+J6o7QrWju+oum0SWw7MNyhBRFw8LIq1dipod0URTzAZ0d6LoEjyuhnrHSqb4
	1wKY0v0Ld/32V2z3OkGeeqlUmpRidHRvp6BgeU+7hPvyBocKlUqd6DbZOxibda9/zOO2SN
	/+qISQ/U6bjcfk+iy4sk7NV8QxyAA9I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Z2yhCO+0;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794333; a=rsa-sha256;
	cv=none;
	b=JOOA/54DtINl1u6eBgO+P82sxiXfCH0pdazJtDYNv0kYjxt2VbmWNMI0SK3o0MPXcfOCu6
	9eNouPVxHpRCjZvuK91Xb1bSp+0tgjR4hynXzL4KpQNIUNU4XvtapbDOJSGH/iYCMa+LKT
	Fdfi3lCgPC2K/RDBh1fpf9ZgG2xWkXo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6DEF16F2;
	Tue, 26 May 2026 04:18:46 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27F6D3F7D8;
	Tue, 26 May 2026 04:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794332; bh=f+o3e9jzGdoDfuO+adnmSdYfcmQjcKxMxDU6OWrV3wo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Z2yhCO+0glanNMpcjEtQJ/w7SiPK2pLeNqNIszMDIQnLC7FyNWkJKh+0FaNJkADVw
	 oCUknh15J4XZ9damwbiBICy8lVbhyZChQsIkvhTagh/dkWDPNAFBeqdkP6i+Q2yad/
	 QTx3llxmEHu+AFJIJ5qDvltcn5e6H3IiEsWOqkbo=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:11 +0100
Subject: [PATCH RFC v8 22/24] arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES
 switches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-22-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=4465;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=f+o3e9jzGdoDfuO+adnmSdYfcmQjcKxMxDU6OWrV3wo=;
 b=0J/grukgqVXGPI4sxKZSOOHsNw1TH6qH9g4Z8OmoH5fl1qwIvtsWZMkKtU79kvfE+eqTuxetR
 Ve2LsAYtKj3DDxCRTqrZDhEB/3G9K61ztemgjXsqj0PTVBHZkbOFaTd
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7658C0009
X-Stat-Signature: hcxeta5j9mu1kt1s3p5u9tn8c7zbtgyp
X-HE-Tag: 1779794332-637831
X-HE-Meta: U2FsdGVkX1+FBjSLDyPfTPIuMQ6nrpY4gxSfYeKH4lYPgGxVg2k+yqeiT2cQJi5YBVCZmGjhQ6kJw7T9LsiECNYM/huoJwUhDiA+mW8F+EVrh9Llw1smGgidOrIT3Ih1ES5y5IdEMRj5zL+1DMUhv2YsV7ZDHsV/3S75coyH0iWl9dOJvTQIAdvVAjsQupZwSeJRO47HEShVO5WtdUuCOZw3L7J4I4XVayBLoue33ck58y712+pQDNgNAOzuRBVAnc/MZd4ShmD0wzjDMjYqGp49avAneP+OhXNS9dLJcCU1GrBLIUAZBI6raOBYXHQuHIkCVuuMVfuM/YzeRBRaK7D5gLHjzVOpfsdcmoaNyYcFtPybT3SwPItDprQ22d9Nee9hIyL0cQx6SnqpxPQaf1VVL8/8RpixFBEFF5UsnklXwV8TbiYAvsnHjom9fgC1GXxW5+WHyUKdwRK2wfuqDDs8WfTtPemrELgGSzOGvEym1H6DEEkIy3S5f7bqKEuH+o//fcb6P25mMl6zcQVkmtY9V2gTJRnYLCKmSoprAW9Dhm03okl4T30QqZk++okgzfDq5/SuQhWxXl5KG1PkyRYdZj2SYPtBBEzMEESev12qS3AIxEYv38awuEawdLlWSjSWEpkg0tgXbVH/2BdZx+JVgrIYe+Kvd+GnUUuxBjLeofBKIUuSbEpZ2Y6T5hU7Etsa4ocj1HSa6DRWqcofRUaf18OBnj3ISaWUKaZe+bHIUvCPaXuCm4YSdz2N1Btfi5oa3Ctu8IPfn6hIZoNQ1eN0i3mu6lvgXZzpm8X57G6HDVePtZ3ryhbjqRzPHmhD1xnjlVHQN8ZKToIQ4vtxBpwAKQ9LCPDNwlKaVdTOAYw/vvH1Jjsdp2Tlnp6SynByN99hKB9ZGjBmPQrAKiGnnU1RvANYlgy23+S602iMvyiIojyz1nNJwEhROAHozGR5NJAfcR5D6c8TdbYWzDn
 YBp+Ke6+
 j73Hnll9ZZ+XJ/YGe63ZLb/YRfBhSvwYogDq37UfHU0ZqcaQF2EhanjJTBmrUT/3jrQvPxn0P4pJho6E/5OCSHuFaNeeMpcRr2kUyHlMjbQQ3J7ad1/lGy45ssQKkfcZI58CA0kJVNnTcwNlZ2dOXX2iZeDNh5hKgA6trk2oSswVVSYEWIsNEoruhhBCx43UlPnTyvRum/Bw+ClZeoZgw26Tv8oQyozUMavvPJM8CM62Hv39tp2eQaIMOzqQlYTA/PjS+JOReQkr80YKdX8HYrqnoRm0oC+5vxzZv5E0RZS0POQk=
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

Restoring the previous kpkeys context requires storing the original
value of POR_EL1 somewhere. This is a full 64-bit value so we cannot
simply use a TIF flag. There is no straightforward way to reuse
current->thread.por_el1 for that purpose - this is where the current
value of POR_EL1 is stored on a context switch, i.e. the value
corresponding to KPKEYS_CTX_PGTABLES inside a lazy_mmu section.
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
 arch/arm64/include/asm/pgtable.h   | 50 +++++++++++++++++++++++++++++++++++---
 arch/arm64/include/asm/processor.h |  1 +
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 20072f32677d..1c0dcfd14678 100644
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
+static void kpkeys_lazy_mmu_enter(void)
+{
+	if (!kpkeys_hardened_pgtables_enabled())
+		return;
+
+	current->thread.por_el1_lazy_mmu = kpkeys_set_context(KPKEYS_CTX_PGTABLES);
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


