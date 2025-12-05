Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D210D339B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A9F6B0095; Fri,  5 Dec 2025 13:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04CA6B0096; Fri,  5 Dec 2025 13:42:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A8E6B0098; Fri,  5 Dec 2025 13:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC5826B0095
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0344580DE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:05 +0000 (UTC)
X-FDA: 84186287010.11.6F59533
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3569F40006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Kg/d9H2k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960123;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFaxxej3Z8k0cOHBoLo4NFZJe4jMwCEz+NNSynx7iNk=;
	b=FHP8HSXWBEo/hhG0ObvcCKJFjDP2JB9EVQIryo16JCm6bGrk3cuSlcbOLZQ9zvPVlfVROL
	vzMm9KECOlJc/OLYN1plpyfW84UzRpUMCsCUw8ujaxq/vT2+wirNvjhIK/ZYIKhV5rdL6g
	wPD1EFUw2KpKxjSZxbh/y8R8/xi6/Bk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Kg/d9H2k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960123; a=rsa-sha256;
	cv=none;
	b=5XuoUu2BmFgfS9Cq6DpeyWCWxKcOSpZoeleQK1gvYeD0c56LinRL7yBmdpRrrtpOH7uZx6
	fQqkGOeB78Vu67Ce0jM4lzxgulVbbRRurhWh5+/BULrAowFopmMmSnA5koYGGOeo/RHEEx
	DEz8QqnTZIUTmpkk/3aWKsSC+scR87M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BFA7444E6;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18ED2C2BCFA;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960112;
	bh=N3d4HTTMI9+zcdoji1/AM7ABunMHm9Tfk/j4/k5XLbY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Kg/d9H2ko0EoZD5AZpjoXU9BnLjERiQngYWc75CJ5iVQGk+P3Eo9iyebOcKQIKZbN
	 7XG9OeadfkvWZPpersw3BUJt6P/vOHGqaieDkDH0zAxsdObBCf8Yr6q639xtb/k9FL
	 va3qXN07KiRzc70bEHuoUd+gzXw6IAisQGWcdulDw26LtU0g/99caCxAbDXrIospbv
	 HIdl+v5PuaT8YyfUECV4a98l+XtdC1cBhgCo10XiyNDwtIL/enfTVkcxEIxE/2G4Sv
	 tz7KGWwMe5GMbOrN8jckOhquRkUk3IzHyL9pcT02WGp5gU6Ky14AjqIQswsUgarymj
	 0+FskHdyt4cmQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3531D339B9;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:42:00 -0800
Subject: [PATCH v25 22/28] riscv: enable kernel access to shadow stack
 memory via FWFT sbi call
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-22-1a07c0127361@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=2983;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=/lrmV/FeWp9K1npGhndX90MYhj+E9a3zmaWQOvWF4as=;
 b=715gUKEOI0rCcDnf17DdkRo3iX1JDclqBzojPljSawDj/t0oBDWEehyxoOvgpYm5Cp5434zn/
 e35ATe1mMl+DwOYW8au/JtgZNVxf0V/siqVyohuWaCEKpTLIfU1lccj
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Stat-Signature: omtc5ah8uqq64owif3xujdo54z9dhpdj
X-Rspamd-Queue-Id: 3569F40006
X-Rspamd-Server: rspam06
X-HE-Tag: 1764960123-350002
X-HE-Meta: U2FsdGVkX19CL+d0M1uvs1LYaID/p50crayHsz8dpJnDV4mOq7ebfnj1ljwOheQQ0NS4B5R75rtr+ukiKl4EX5hZkBHppBIT+4skZHdDe30LDlyVjEOivRG5O2JfTcskG0hoA5tP9ctm8C2XDiWqwXXxfU/50YmEtqQIFCYjs/+P8mmrDD7Xy+UZl7Dv1gdb4r28kCPRZ8yLwt1YsxLJQU4ueQhaCgTDWt0U8QeHvm0iSBinhinI7rcIhMFVADYNfcgwHurnuHlT6UBfjoC0eOIT0CQ+79PYkrENFlEwUZAkRQI/I+sZPuBjNVMHZauQ2NnK4coxfjDLm2k3vZpVswiY/zXsk8rlB0BATXnT4rSlXWPa1dgTp37q5Dth6B/jJ4xFNHGeRAHQ6P4EKIvaV0gfiwORdc8tdYdggXepR6cXeunVw/zah+3E2V+7ybqJjV73zZCJjOwFSHmsXwcmDy5dR6ZMq0TzRJYjy8uCjEDPAtZvlLnFiraKioUO6lIJJidl1qHDZTCjpe10PnZTcr5PRJVatm3PciK5pLzx7xXin3Iss8ZgvN1YcpPZExpHnjkTWfAhGVvhP4naG+aMXpb+H1RY8cHT3jq9XJtBWHLFMdqVAFbLZQ7bKpuswylmEc69wEYBoWN+qFjCURxWS9hWHF9QX6qmXt2zun/54by0dj/cYewmbtdvnS0/8B7ZRROpgikrNTda/kUrtBErzjy3+K39rnHwJyYiWD52+CvqcfBp+wb9hU5GKjHUVgtAl2jrAyKHJ8sHF3HUoDZmH77Ek4fjy1BDL1G3Td/tZ9g5APOKTInmOdH0znvouo1V6xc/zedMKD5l74FFQJJwAPaw8iOasZpX8+t7xwIhEdqrJqlBsjEZBfL7+j8Vh04bKcMg+ZaNBRtJHyj1NkTbktMlG33832R9GAQyDr9314RzNwVQoPrvZo9ACSAEXzgzDratVU6VkLKffvf/eYz
 euEIykns
 /IqeadsqNct0WsfkWB0ub7QIQxjBcuBXMzLqk3O2Me87K0YgkK2l7MvtKWOt6HpvO3KSPcm+qLETyHUDld8UI9cNUQIREG79vIhuNm8C233YRcESQBanWOcG0pgw5njwM+e1hPDSQqv0ANERWbW6jX0J5vtc0Fz7aabWohTFc1G6RhoYUh2dTjjX6H4VzYNhS1E1erVEbcXn0V1x+8Y47t42iQ35gvL6DNph7Yed6WMn1v0aF8ayT0fbY0eYEiH5VO41UNi6zAI+KDnQTHSg4j4wi0OTxUHgH4uZ+kEZxmnrs49+czrppclZOhdg706DW0Hk7nrzxECBy49UVI4pqPOMRBIqjlLoVI6xUl5jPylCpDnkCgq1noOnCI2wetusY6CKtLRzfUCiVMWqNvss5ASZ9a5PGRC9UL2hYvUG18G+ZAHJ825H+1Ui4OV18yXQZzKNo9LpJ46dVArXUsj0Cgt1Xrjaqnv+SwvvDZRIpG8dh2/6QFDgB1UFBZc4EcCSAYeMP+VuMt5bMI7GeXuXP8CVa0a9zY0svTKPciznA1cwc+1OTkcucp6SZjw4A0dWnJDv4eSnmw+TAEo1Yjg9FGHSG+DbEo5d40syc
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



