Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9CA4D41D74
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2446B002E; Thu, 11 Dec 2025 12:21:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92886B0030; Thu, 11 Dec 2025 12:21:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A606B0031; Thu, 11 Dec 2025 12:21:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B70CE6B002E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E3621A0283
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:20 +0000 (UTC)
X-FDA: 84207856320.22.588167E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5840580007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqXoLNZR;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473678;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFaxxej3Z8k0cOHBoLo4NFZJe4jMwCEz+NNSynx7iNk=;
	b=akgGz6U8qbIcvmNbmVQBlh5voqAyKQMlXYJXqhfUQ0tevvswH1GFW5Xlh/t5qsbOyEIfsz
	F2oSqbd/mQPniwhleaufF9o524k3WyiW/7AwRanZVoIn3xP6IsiF75A0MIs6iw2U0rCTyK
	tc5He9nIreQYvaDwDakfca0dX8aceLM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqXoLNZR;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473678; a=rsa-sha256;
	cv=none;
	b=8pzqdSNTFfpsDy51rpNLTVytF3Pz9Izlyx3BRJyrB6/z4zYn7osyxJEUjn3K+Cw/ogCbbH
	oJS3oemPXtj4Ljeu3jImmpmrkmRL0GOyDNRl6Wwu03smbXVHsdFjoVAENaYayEGVPn+c7W
	OlFgxmayw7KFbpCESbAjgvs3tHFsPiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EDF8544466;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1A19C4AF11;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473668;
	bh=N3d4HTTMI9+zcdoji1/AM7ABunMHm9Tfk/j4/k5XLbY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gqXoLNZRnPXb7EIKBpIO77raJBDLqLuyl/l2VA69/AGR0iuwSrHswjjtjcrYd4wlm
	 W1Za4Juh6wIa9mU5su5HvAxDwO/7RmS7rLgGVRK9SnUNgETpJtnLbH/hHnQeDn1qXL
	 Uz/FKJ4b3xLg8T7lf49KggiGM/WsulBXFvCO7noMnFY6fO8/Tko2/uM3l2hKoKcsqS
	 Hbaz8QPxhF2N+EUTAeXTLeZIcGhnETQeyM+Vxg8sgL1ZKPhuAvV3f9cuWLR0XALqsC
	 Cuwly1MUNG0beLAsoVVTEh6q13FGzJWFItnDtfMl3xMbxuwTDoXPzGncGZM047Uhq6
	 qgPVKH+cQHGlw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB151D41D6B;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:55 -0800
Subject: [PATCH v26 22/28] riscv: enable kernel access to shadow stack
 memory via FWFT sbi call
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-22-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=2983;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=/lrmV/FeWp9K1npGhndX90MYhj+E9a3zmaWQOvWF4as=;
 b=9GpF+uL3hl5yLV8VePY/xGjTcAci06ofRDsz9+WiY5MKJDtfTLDa0TPOl+e/9aQtllYFRkaE4
 OZ7g//oqGdxCMyEhbG/svQe1wrIk5eEoCEr2RgTUg69rY6kqeCtbo/R
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5840580007
X-Stat-Signature: zcqpdepk6n36zfhyy5bcjh5krz3154zm
X-Rspam-User: 
X-HE-Tag: 1765473678-180816
X-HE-Meta: U2FsdGVkX1+gzlj+o5HvWNdvSAIeiOmKCa7VitZu0BEJlWqopqT6Kh2vzxgENmnDLtbdtdbin21lbJ0Vys3gh8yWFfKA3dIkXZZ2FqrxDLY/VqZR8Qchur053h+F6dGXfP9vPO8vIuK+2wDOknO4jbZtP6NJgUE9mlK6xgNzNTGcScTCM/8ZQEczQdgpMLCezGzRbfEupM8m8TNFS+qOXK5Plxor+fX/SHyiWd9KfeMkgaHkbTIT0FttH69rj+RwJzMuT7S9W1mmOZc4XuGB5zjl/pegIzFWYg422Mz+SKZiwhAra0Zfg+SojL0ApXACSScNr0weGyERJKxkpbsIZoKnD9s2qdU0a4cIpSk970TREcOzhNIwZLhmxrDfhq6mhSWFMBkET28/u+A9mykKMovSRJQFafPN+D0xi6l27eLK9hZGo8O95r6boSDLLc4OAJbXybIuVsTS+JMQvRA8KUnmhh1c2NfSCpYYPYTND92xS7M/UAad0nBfmtmZCdlnIM3jeE3YNh+X/jOCMTe5oyJdMwLDZw/mxqLUn7+AKs5VbXTkxvnEeZQl0rNexR/a7sYWC0dM2LJrK/51lpbTjGQszfj0urA7CQnPXHSBenWCS7VlAaedaWcHyk3pqRwcHlz9rHzzkRfQwm5GMMYbY3+ofz5yaRgUmoZR3YW4cJxsmd+I9gjaJJGYoUP0HxmGPMNROxpCJTTO7kyjVXfXh+aa2Zs4GXiVrJIZjsF5vWE+yGxCmmxeZBBGTT7QZhOMHR253HzMXMYWggu/42cd+MB+dOZIFVCfMVJUrY0FJUpn88qXOUthwjHK7boRcPXMK25unB4Azy78m+SBOWZr4m1adIQJuuXMs9T/PF1mzj+ouCBaqMoHpqb5vyh4OOULY6ngHBD6NS33O9E18XsDLP32YwiL1uoGJhLhUVeZrH2H2y7oZhNd864DRq4bSFcFuekUgEj3b8usfSkhV74
 M7Aqc+Hj
 rmOP5SSHP5MkySi5DCbe+8osgioSfKUWWRJpYCbQnX6kP6KFyK/2MFyyw/RWk7Ehi6r3HQpjGXI14q4IGd3nb3yzTzyW87yh934aY46BD3ZrNNQk/OqluJZirfL6s7ei0SsPjVk2vAw4T8O97Q2o5PY5WbKyppagi8mUVzNum98aleGm96XmU1BkXN9kljAbHQyyDlIhCD9ltSDkZHNvvHenznG8Ky0AyInRPDoq/9D44ACeFq1oWM+GW00SeK7KLR0UhrN/rB4EpeCzhtKx4tiTHUbkwK2jUYIxkWc0EcEV0del5aP8uyEK+dDpiLh6BTOFbPOYNUNA4rpyeTNRjZe5l5//W/LwyTQuAkClxib1nzokPu5f4/4K8s4TE7nDM9gsnBlzVZlGuVL5ag3xHPbDIYz/6InJRArbpEENFD+yWkMqxZj72AM9je+OHV9RRVi030/n+KNbhyCtZAtEskkwMrhs15aZDCZT/bWxLr3FHf6o9RPBB8+yeFlvhVCZwu4q/lmUX9Ag5FCUeeCEMQB2ZyK1/sW1un+ZFltAQWI8V83c8pq3mWwfv4BnKO5isbOmXNA2cGeXXqM1PE3c032NXpjHYX7Fprbxv
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



