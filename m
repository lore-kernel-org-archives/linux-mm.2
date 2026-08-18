Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BBFC5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539816B07C4; Tue, 18 Aug 2026 10:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510C26B07C5; Tue, 18 Aug 2026 10:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400126B07C6; Tue, 18 Aug 2026 10:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9476B07C4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A64631A02CF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:59 +0000 (UTC)
X-FDA: 85114579158.13.7DA68F9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id BEE311C000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qmujkZbp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEA9NK5TfxOsnwNZQQmblmBx79APSjCRINs44xj5fHU=;
	b=yThEtHBT2ZhwZ+50baZxDpbu9p+RUzbpOcKqkLIBLsn/wg0gkA7o8oh5TxYaMOpHFeMnfp
	ys2V88fZStNdCMyW4RIBYJ4y1MsWtkjRR3QyFy++zPOS9zsu52Bz9qT4bk5IC+pxZ8a4sT
	Ab4Uxr4jWbOvDpXKlkvROkjZRqSKGCo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qmujkZbp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062317;
	b=ORtWOpaOGjgCjqjZ2TNnSEAEcrOjw4vZBNgkd7Sm/kZ2kFw5eOuIYadoFUv50JrYmxUY3w
	7WvHmRqxecUFp5bXN/aqiyy6hMzXH2myD1gkHaCGQ968E10xhHvoBRhv0iF3H52Min0Gpv
	zog1xjDNLl5a8EDV/sNsBmIzeEebWhg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D6A719F0;
	Tue, 18 Aug 2026 07:11:53 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BD3C3F85F;
	Tue, 18 Aug 2026 07:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062316; bh=OUd9tIsUKUmYmJFdd7bshHjQNhEMzbzjXfpa96AJHgY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qmujkZbpTeTsmrHyAf/qaEa8Nq7dlkfqj+c/vKoIikQ0V06rSh9KrR/pRLcrW9ffA
	 z29nV5viUQ3wGoB26WNlwwpAhFgAQpOrGvK6mdY7MyQU+GKtvm2AnSUtM9lM+02aPm
	 YKHFOlZVngpDxQ3rff18JdR/LmnFYPty2cYgms/U=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:49 +0100
Subject: [PATCH RFC v9 07/25] arm64: Context-switch POR_EL1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-7-743ad31b2c8f@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=2038;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=OUd9tIsUKUmYmJFdd7bshHjQNhEMzbzjXfpa96AJHgY=;
 b=mPluEjZtRsLQjo5bC+3nVcrHgi0+Q8vudQwS8etOmxj8McFohmUhLrEF/NL095tJxHzNpqP0V
 w/2lu2NlSCGCkCU9ak+BuaVIwfPAHqw5s71plqinBt9CylKiS/K4bT0
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: w7nzqzw558mnufcbthohrme3kpo9iwoz
X-Rspamd-Queue-Id: BEE311C000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787062317-342284
X-HE-Meta: U2FsdGVkX1+faHQBSTJe61wyGjCLcdTcGux0B4mqlRIcckkf/RrBkJi8mugZoaajJvfr8ym/a+mHspfwhwEMxmJrFj/+0FGXR810Ps37bFJyHX+HOU+PxQjmrupCV+Zuj2OlirE4nS9mOSx5StpCbA/P+4JwL9gy0G/gcPLdT1q7sXsBev/YszkuUX7yPQScHbg7bn2qIJR2oyyxcBS204NtB3v23mm/6Npywt8tLYtL64K2H56TFM4wPaSO7VJFiEFFKqAxnrpmV6eun7SqmBpSrmrqIXw+GoWe0/vcTbKDjh2Fv4X/iZtWkt45FceOaroZOGz62yX1MhPFpOijXRchGkRN4R1j+BS+r4ZXUDOlmj3UV99WyUTeBPoSqqk3rhgOAOkhbfC2UNKGn7b7EYXrCQPP/VkesxTD0oz1l87q2Mxwmg6EPfZ1LF2yZX774yKzdNof35dVpDtjvvNOZo3GIrzDjLHh4zV9x8xktBwGLsu7A4wg7qQ6Hr72DcLlb3QKtz64O/FZSQdeKCLaEBOagwxThvJvnHI/Z+YdfBi5JC7wnUpTMdAr+gDBDJJKA0i+wZuAnCN0RZPMqhwXlDWIZZ3luXd9y3Sg1vOC2vXmWFOItoT01j/ieU3ZBtJTxeEJR/tWg7nWlKQbJSwEQKXHH0HPpO1ANtJiq1jDMlT53HKFoOR6TcdiH0msTdqE3lV8/onEgNZ4U64ydKDCYS1Itno+I6bxRrUkbgKV9ElFXOYkmhS4IlY5/j4rGDhDlRPxcvH1sm2gbCoX99HPeCF034Pj5bSnT8hIICUpXprBAIQ4b+MvCtWBAOFdklZ7aXqVIsuYddw8knNjUe3Xslu76nTWgW92Wn72ryIGj0gSjBELeEF7ZmRZCbHRJdOmx+djk6tsRKSDVNSUuQbfAQ14rmTIfG27xqI9wE3Lw7wFy8RJm+BS+yemOQWLwPf6zTVKNJngUGGoDPcEOCC
 dUDPMgTd
 lOokRiTzLqdKq0rEPVqBt75lENKUom9CsOEuMgkgKEsj+cCEseF5K4qFhopmzK6F5O/dYhKA8ZL7R2mQ8RUKLKEJ/0LunF3tkAZVu16FQp+z+oMnf8T0XCAbQICaQao7MmApJcuSrUaSryA8I1YgIlP5TtfAGbRGbbECCwqh4wu+JifIyK7UsRd4DrY/z4Zp/rsFCnP713icTQWi+mTXW5TBl7z5qG6PH+FBaqHRtxqUf4XiSBc7I8UyECtkiD02Yf3dUE3TTKaSVYbrTpKBzCq0zv2blvoiCYHdWqXWSgcMuj4KIE+8Osvc8qK7SnnSmevCmZIonMybS/YWjGfYkzemmPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

POR_EL1 is about to be used by the kpkeys framework, modifying it
for (typically small) sections of code. If an exception occurs
during that window and scheduling occurs, we must ensure that
POR_EL1 is context-switched as needed (saving the old value and
restoring the new one). An ISB is needed to ensure the write takes
effect, so we skip it if the new value is the same as the old, like
for POR_EL0.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/kernel/process.c        | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index c2a627f39314..8d7fa479cd36 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -195,6 +195,7 @@ struct thread_struct {
 	u64			svcr;
 	u64			tpidr2_el0;
 	u64			por_el0;
+	u64			por_el1;
 #ifdef CONFIG_ARM64_GCS
 	unsigned int		gcs_el0_mode;
 	unsigned int		gcs_el0_locked;
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 581f80e9b9b7..1dec143decf1 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -51,6 +51,7 @@
 #include <asm/exec.h>
 #include <asm/fpsimd.h>
 #include <asm/gcs.h>
+#include <asm/kpkeys.h>
 #include <asm/mmu_context.h>
 #include <asm/mpam.h>
 #include <asm/mte.h>
@@ -431,6 +432,9 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 	ptrauth_thread_init_kernel(p);
 
+	if (system_supports_poe())
+		p->thread.por_el1 = POR_EL1_INIT;
+
 	if (likely(!args->fn)) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
@@ -681,6 +685,12 @@ static void permission_overlay_switch(struct task_struct *next)
 		 * of POR_EL0.
 		 */
 	}
+
+	current->thread.por_el1 = read_sysreg_s(SYS_POR_EL1);
+	if (current->thread.por_el1 != next->thread.por_el1) {
+		write_sysreg_s(next->thread.por_el1, SYS_POR_EL1);
+		isb();
+	}
 }
 
 /*

-- 
2.51.2


