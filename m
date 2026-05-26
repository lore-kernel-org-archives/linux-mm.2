Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9290ECD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0874D6B009B; Tue, 26 May 2026 07:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F6C6B009D; Tue, 26 May 2026 07:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB86E6B009E; Tue, 26 May 2026 07:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBB5A6B009B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A21E81C0EED
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:36 +0000 (UTC)
X-FDA: 84809320512.12.6F566C6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id C88B820010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ps5oUmrv;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDW+4Ri1NbmY+LYX3d1NrZAxzpdenGqWvPzbebNhRrk=;
	b=og8JKRudxcgpEV3+NSbCtu5qGXyoLBZAQ11wPqUBS8RU5GBo2TxROFzqzoZmQI39MRBjec
	aR3e8euXxCPFadQ0D6k1gQlEv5qJPIr30C9JcN07o0kGaKnKGHWC0GctikzB7BoY3S5wEs
	6cO7E6bgokgS4SjsMCDPZo3RVXlapjg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ps5oUmrv;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794255; a=rsa-sha256;
	cv=none;
	b=Dh2cQ9uSBh/9iDmtkDWHlO9EvmCYlnw3Y8mH3PBINrSa6uS1p1XWtYJzv4q7Le9nHPm1G2
	wRQD8ykIu+3R8owwP3vwCxBQwzobR5HrpBDaiFLN7DZ9mky6rBa5PtQAoY+lE7CLABMrZH
	Ig/joF9L3LfsAts5X+31JUQ73CxRy5c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5228169C;
	Tue, 26 May 2026 04:17:28 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 252543F7D8;
	Tue, 26 May 2026 04:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794254; bh=b49mJW7u7F/HnBBk9bL+wnyupZMH+GfasgCyDZuFBY0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ps5oUmrv81CFHgOsUzGKaQPpaJZ1QR9lLYefa/2fcSTDSKhxGBm4ZxEcboZxVnQ5K
	 ewD5DwjAjkAc456GR+tlcHlRxXMJXGFXKjVXzge5VKu2EkD7NT4UHwTTMNB34CTb55
	 WTpYFcpG77lC5j6S4yUwbqhMWbuwPVwEMRC0V5+M=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:56 +0100
Subject: [PATCH RFC v8 07/24] arm64: Context-switch POR_EL1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-7-eaaacdacc67c@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=2038;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=b49mJW7u7F/HnBBk9bL+wnyupZMH+GfasgCyDZuFBY0=;
 b=DH+kk3MeFz5TjvUobbUd/xpzAlXHhmItVUn0DiI8T2JBC1c4czfPVlzjEESsGu4H7Nu7SaW3p
 bOsARiQKnNtAhgg6iYTdPiPvAgtwc5bdcCxdocAyjBp4HuYt1uVEWSM
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: uc3fgghmizxrwgdwnpfhzqwz4cycrp84
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C88B820010
X-HE-Tag: 1779794254-329414
X-HE-Meta: U2FsdGVkX185Lr7j+vkL5oADBRMY029shZ2kbA0eMlhYlnT8arSlp63mHiBRj8ps0tuxRev+/6IAKpACcsIbUGET5eRBI8tcQs4X1oVKLNIXRx2bq4T0WpxsRpjAXMmepZLxlU1Tg7d7xOaNGo6QS5miNuvbLzzZgBcXrvbGOfBJl+/hIM1tEvuD1D/BxA4fTw+/ixEtsto4HYhDRg3+B2H3FYlBm6Qoln6AzB2eP7EA1mw4EjnTKMmfkRmDLaU7yzasUNuoB2vfKbQqDcws0mHtAzPcsFsNIsucvG89yeCHXvZbELxu7aFs/Y4+EPMkD240/mReBhnylC7MykQXrIya8AMJcK+KSStkTP/JA6tJzkG4YqtWuCIRa37Siju9n/svvBcdruQs30UzfoP5VDAz2oz1ACcvxNOy3aEZ1mQ4Jx4x9qx8fiY0/0BQg11Zibw5jtCkt7KwyDgDc3ZM7uoauJlMNuSrhCnkkNIOz8L6GL4B4bgoUyeR1KejfY8TS2NKC6bylVcHoTuwa0iiyq1CaoYKgJBr87JLRNh/XX34aOi9c8A2VBc/Y91dSwLd8EKOErHr+pPJsJs3Dn1Lbf3YxCswIECuG3LOfzB2j0JwYaFF24VbfHkVdLIwDD3gPIrcCZA+xomjS88yzIV4IqWTuo7xj6eotzFtyMEF3f5hlsjL/23DQoHT4JrEDLnsxIrOtYeXI+7MXUvnazT1C3yPGZgzhCXB6dvpRL3tybr2DJgoykgXy8SiYJl0F1EivasaBLcjYu4oC88KWNFg9k/W6LAWy6uXP9Ipdh4IeYIKjLnI/Pt0s8z+mJyca4uoeM+MUEl7Ev5DDPPvvSgmkwIiN50I61ybawjdGyOWB+/At8X20/Jh3p6VdxCJJB+81SUc972m76OaWrQsmSPhU5nGrNqTCjUWXaabWtywNHHREuBHmPZDsf9xaXdyMaFBZzcxXEY8DiO65ULkcLQ
 AvSRj2rk
 aBY2WggybW1l/nC7qMsI/148afCHGJHUmx0RsxHl88aa6k+Itbn1XdnYlVOll9NZTfca1EMDtBSNa2alYWtMH26i4iRaiywdXfDdJKaHc2IpeO2kFZc5uAsYlDdCd+14yNectoE/QcPCYZBvMezStKAV+Xffn3KEdAA0N0/Qg5zjVCKT2ICSPGJISuorMZHUhZzclFnV7UHja3TpaiS/tlzAyReS4jM+TlMZJT8JGEBAeQDL87J0ZHt5Od6pxSsX5pTgubhMWziTiFDjNKm2E8bkS57NImVj7JfZSca3ou4ZrJMwH/rWa0whKByC31Hclobk+OZ5q7JSWT/CSO0RR1QUd3A==
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
index e30c4c8e3a7a..6095322343fc 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -192,6 +192,7 @@ struct thread_struct {
 	u64			svcr;
 	u64			tpidr2_el0;
 	u64			por_el0;
+	u64			por_el1;
 #ifdef CONFIG_ARM64_GCS
 	unsigned int		gcs_el0_mode;
 	unsigned int		gcs_el0_locked;
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 033643cd4e5e..e5a9c210fbde 100644
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
@@ -466,6 +467,9 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 	ptrauth_thread_init_kernel(p);
 
+	if (system_supports_poe())
+		p->thread.por_el1 = POR_EL1_INIT;
+
 	if (likely(!args->fn)) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
@@ -716,6 +720,12 @@ static void permission_overlay_switch(struct task_struct *next)
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


