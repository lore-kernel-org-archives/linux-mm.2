Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5065ACD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292D08E0028; Wed, 12 Nov 2025 19:43:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B2C8E0020; Wed, 12 Nov 2025 19:43:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B718E0028; Wed, 12 Nov 2025 19:43:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8BE28E0020
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8995389949
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:54 +0000 (UTC)
X-FDA: 84103736388.17.09FD132
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CFB210000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2yHLDT+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994632; a=rsa-sha256;
	cv=none;
	b=MWqlCLltQ81Iguw6pewupZINsxUcEpKYBmrd53L5BPuqBwl2OZA8TCH/D5gmc3u49lOBdR
	AwEkMa+qXq32q/816YylkE7CZSAt10gqd1ldIEATHMIqGUjTooOrZJkxH55ypAEMUrj02M
	//3SPVsNE/so/iHSakPfew70Q+gPkEI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2yHLDT+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994632;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIsTC5uQoOK0hv1ICUolJmsr+FfyaYbLB74q/hx33bM=;
	b=faZvcyBACG40XDFoBvkvCpH4pwg4Xn+HK+cP3XikJ9KfPVG7Q+03gxq/cc8Gg8YE32FJE/
	DzGyI9eXyz/1eHMP5Gmi+jXAXfjezq1EAeb5SA4ttTdhfJDjD12xLIWvlSUCOdjyxUVhDo
	/hJ8r/wVam1hp7efun1p9aRZlMALdWY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC5FF446DC;
	Thu, 13 Nov 2025 00:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9D7EC4DDF9;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994623;
	bh=IWV/cc7nU5utSG71ajaBhItrAAJIoLJKysavG0licH4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=r2yHLDT+Jwafzr5GXBSdNZ4ogr3Lq96wuueJGMmCdBA8qVknrhy68dBuSRIvDSRFa
	 +azpIMC+pAR20lOez4Y0z0YsLY69hR55v9aEb9Dg+aDAEkxXx3x9cScIkMzxATPbYv
	 sKSQNN+GTPpZ6lQwc20WEz7heVyrCIpiS4YqQKIIM4RQY3qVE8sT5Y2q/MQJTEdyr0
	 sZJd2MeCt+JiZfzcxmzuLWvl42b9QcacPDCw7yGqZXbj9Rbu8wWjud5oX1u6GiyGRm
	 6XMWka7LpdL26kup9HLn7ESE29w4nEgOB5TwGaRMfdljPVxTtl6jeq/G2vCtMmgLi4
	 Zot3uZw7XCDkQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33FFCD4F2D;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:20 -0800
Subject: [PATCH v23 22/28] riscv: enable kernel access to shadow stack
 memory via FWFT sbi call
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-22-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=2857;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=6jhZAX7qSjG5giCOVCgCSSpmySXxQ3X5SeSFJU/GKzQ=;
 b=W2WhBMK6sjGOyUZTeb5gCSAXF1cfuwgwZOIqRVNvDjuiNs6qTcLQ5w9yO/OAsdoS6vfmmUjI2
 R+EjdOdpYctAwC4JeIrxEwYh5NGeSSbxrTgfuHDAAh+/kJarIV8JpSb
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9CFB210000B
X-Stat-Signature: z68mb1b3rbh5wo3xu4j6r5ozdefmmefo
X-HE-Tag: 1762994632-85486
X-HE-Meta: U2FsdGVkX18UUQONi2olgzi4zmIWx8BxixjO7meh0fjCKX5DiIwssdSXlOx33WFXMKhylO8FtBcK+oN9kRPPktYWoPWhK5O3s7HDse2CYQ8GZcQZkep7AZgDDTH0ay7UOpjHJPIrha9ppF0gePuorhnp8TczKFmiPjbON4CsR5PyLFZJ3iOoJJ3hfjQ369XslDHIDWQw4mmZwbt9iRL1oTxl77UZfaWjF036zA0hFhvc/iCkGMrlORdKgbcNINa8B3Zac0KkZaj8bPYiXROyfDHl+wSA0yPvANwD9JAB+7tbpZuEXFpGQZMXKA/KCoO6btXjwwLytY4WPZJllfbRe8FK9WATQWx//qltVDPCRQjzpwiJHySluLnapyITPhSBOc6Fb5Y2JgOfoH0eMLkZmeBoVujp7nCeMfDNChHhFAowTU9xR+HaTKXV+/WzFvkyYDImKj0E85wx1RzAVVuRphDQ64f4H98kB/NAr67WjsZamK9XB3WGc50bahrBBLh19JyeUEhp6Q4W3QIis6CFmlHTuBvMjRCzde6t5bOhkW460DVNsEQ/cSJjVFvD6gAsSm6IuYFhEAYH0Y4tqOVkSzDGrf+dcZN/MMyn8/Vf+5VLNGHYDjB3GgjLKkvt9I8tcUrYTttEibl6HW45BtbyRiwtyNAfp6DF1G+kqXsRyIWsSZrpNTImgRwwPus+8cuvKQqvLT4SOO+lGbxsVjzW4+no5OrhRatH+6hhejFj9ESstEjPiCDzWW94omslnWrKrKsJbCtqMAj4UPwCj5aHpY2WPBVCZP2h9GXuFP0xqkJV0KBDgnESlXtYlQXwFw2ns1N2FeEJ35gkBMBn5EHjiaxYsomYb4r3mhKWnxNbI42y+Vp+QSmFaH6/mTDvVbSpdAFMB2KXHZame7NmAogaQlKf/8Yj6qKwaLfceNbzEBlTJE49/aqN81I7CvK4wyc3qrFa4qNMkZLRZpcFveS
 isnfMLMe
 MYLsPs0wraK1epCDJ9mSiCNrkfCuMz+HwwXnotyGL2Or37n6a2aYlNjnsgYJqPcu11qrA03AiS4yAo/Yrhf5zbnSvBbmw5IGS3XwU0Qvw7pO9KjGyaJllWSpKs61FXQ7hlB9ost0IJNyDtgEMa4Q7rWgL+tGEb/m9co0/kmn3JWKNMzFDN3zhM+BnPE73T+aNHT5+esBSRJG8Y6ypPBj/1GDBMDPSp2RWuSw/oT76OT39ebY35ttS0B6FRIJkHPrLXXcF81gZdpW5vXcZfy4GFdZ3nrKqc683YzF7RmqksDZIVWLcfYsEWlqaMgX/ZdlcxZZvKXhCVnif0UChJkSo5DuZdJ9zwnOLJ5Jnq6GtG9KrYJ6t1TTpQeyqrk/u5gz1AAkKsSzLHt2LT2JuUwlaEyWzhgMfMbkaACqagw+LeQ+l7XwNmn77lXZOvYjHw1t5FaGNdY6C0Q78deNlbIQiKSoGeqh/c0ap7NhH14W1oLZ+DFegBNpDue/ugEecNv7mtZyologKE+z0WoD3A1/LnjstXWfMu9rg7KJk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Kernel will have to perform shadow stack operations on user shadow stack.
Like during signal delivery and sigreturn, shadow stack token must be
created and validated respectively. Thus shadow stack access for kernel
must be enabled.

In future when kernel shadow stacks are enabled for linux kernel, it must
be enabled as early as possible for better coverage and prevent imbalance
between regular stack and shadow stack. After `relocate_enable_mmu` has
been done, this is as early as possible it can enabled.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/asm-offsets.c |  6 ++++++
 arch/riscv/kernel/head.S        | 27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 8a2b2656cb2f..af827448a609 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -533,4 +533,10 @@ void asm_offsets(void)
 	DEFINE(FREGS_A6,	    offsetof(struct __arch_ftrace_regs, a6));
 	DEFINE(FREGS_A7,	    offsetof(struct __arch_ftrace_regs, a7));
 #endif
+#ifdef CONFIG_RISCV_SBI
+	DEFINE(SBI_EXT_FWFT, SBI_EXT_FWFT);
+	DEFINE(SBI_EXT_FWFT_SET, SBI_EXT_FWFT_SET);
+	DEFINE(SBI_FWFT_SHADOW_STACK, SBI_FWFT_SHADOW_STACK);
+	DEFINE(SBI_FWFT_SET_FLAG_LOCK, SBI_FWFT_SET_FLAG_LOCK);
+#endif
 }
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index bdf3352acf4c..9c99c5ad6fe8 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -15,6 +15,7 @@
 #include <asm/image.h>
 #include <asm/scs.h>
 #include <asm/xip_fixup.h>
+#include <asm/usercfi.h>
 #include "efi-header.S"
 
 __HEAD
@@ -170,6 +171,19 @@ secondary_start_sbi:
 	call relocate_enable_mmu
 #endif
 	call .Lsetup_trap_vector
+#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_USER_CFI)
+	li a7, SBI_EXT_FWFT
+	li a6, SBI_EXT_FWFT_SET
+	li a0, SBI_FWFT_SHADOW_STACK
+	li a1, 1 /* enable supervisor to access shadow stack access */
+	li a2, SBI_FWFT_SET_FLAG_LOCK
+	ecall
+	beqz a0, 1f
+	la a1, riscv_nousercfi
+	li a0, CMDLINE_DISABLE_RISCV_USERCFI_BCFI
+	REG_S a0, (a1)
+1:
+#endif
 	scs_load_current
 	call smp_callin
 #endif /* CONFIG_SMP */
@@ -330,6 +344,19 @@ SYM_CODE_START(_start_kernel)
 	la tp, init_task
 	la sp, init_thread_union + THREAD_SIZE
 	addi sp, sp, -PT_SIZE_ON_STACK
+#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_USER_CFI)
+	li a7, SBI_EXT_FWFT
+	li a6, SBI_EXT_FWFT_SET
+	li a0, SBI_FWFT_SHADOW_STACK
+	li a1, 1 /* enable supervisor to access shadow stack access */
+	li a2, SBI_FWFT_SET_FLAG_LOCK
+	ecall
+	beqz a0, 1f
+	la a1, riscv_nousercfi
+	li a0, CMDLINE_DISABLE_RISCV_USERCFI_BCFI
+	REG_S a0, (a1)
+1:
+#endif
 	scs_load_current
 
 #ifdef CONFIG_KASAN

-- 
2.43.0



