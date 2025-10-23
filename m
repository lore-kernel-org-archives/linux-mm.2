Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F798CCF9E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97BA8E0026; Thu, 23 Oct 2025 12:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3508E001F; Thu, 23 Oct 2025 12:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A9C8E0026; Thu, 23 Oct 2025 12:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 891298E001F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55ED8129D5D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:26 +0000 (UTC)
X-FDA: 84029969772.15.78CE48E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3DEDC40013
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mWIpyM8H;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238284;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIsTC5uQoOK0hv1ICUolJmsr+FfyaYbLB74q/hx33bM=;
	b=ZXrmX6BfNe1klqG3EgHpFV53oyU8pFWoE+fKkyPUvdjIIyhPO8jCj0NjOKXfKMndubhjgQ
	QarELr1nkwBkNlMQLq5vrPZgMTYEa5wEgSlni0utU+BK/xPqOIdYp6lXtf0mO2DwVa+Udl
	XZYhAlYr7/7qqjQHDZd4SfebLy8yqR8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mWIpyM8H;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238284; a=rsa-sha256;
	cv=none;
	b=HB0Qq34ufOishG2K9NgEvd+pPObO+ewTUd2SkKdG1wXqKIMHa/LTL7BGKnQ3EV3arGskSY
	nSe10iQPyPikfx0vNmwMheRONmIf4e37SwDF+93JZL/XvV/GJu7/s8GQkCc36CUL6mC9+5
	CPGPyA8R9iWVxEN6rpqYwplSoJ67Rvk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CC0A4B143;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5262AC4AF52;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238272;
	bh=IWV/cc7nU5utSG71ajaBhItrAAJIoLJKysavG0licH4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mWIpyM8H6bWoKpo5Rli7eZRDm9XlJqRXSgXRdz5a+qhrrYbvKqfI1bKyIozDXv+jS
	 5OBnO3v8jU8NP/rE8vRlie8cfTGUht76VUJrrurG4qtRBOBJjhIkiPn3ojTxHioaeF
	 UwMihFXkEZhqczkHLBHLoteXL45MY6EctdcynmjcjdD8izCkoptgPNvm6v9XF4Maxe
	 c1xGvzFMleFMLi+Qd8TnAWiYrmeWhaGNGrS7/8iLNAgwNHyjPeG60/7O/pqK65a18u
	 eADdOQq8R4AiXScbBop0qk+EiumO+BotOUJiPoY29sZX9P4bz6LssGwftemmi+QZsi
	 tpqSC80u/RJ6A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400AACCD193;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:27 -0700
Subject: [PATCH v22 22/28] riscv: enable kernel access to shadow stack
 memory via FWFT sbi call
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-22-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=2857;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=6jhZAX7qSjG5giCOVCgCSSpmySXxQ3X5SeSFJU/GKzQ=;
 b=ZCaVgmPZIW7VK3LK8GgkkQBvDVa+uyflBrrczukk04MC55+npWLHhbPfAbtwExQcSkFtFpdbS
 +BKAHlfx6IJBt1jeqE2Z4QqW8yNdtteCLrx4EJUxKVKoSV6HcH1Va+f
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: xdcon7nk6ssbrthbmyrmizab7tjru6tb
X-Rspamd-Queue-Id: 3DEDC40013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238284-485068
X-HE-Meta: U2FsdGVkX1+SL1ZVxsX0+ihuZjGouQBAOjDXHPLMPFXPPtl51ckCulcU4vnkBoWgADNj9WYslgOnt1wBi7++NrGFcDpDrFN7vHs9BlWEONP24IefGjfVXNJ04CGVxUjGoWZZpHCTz9/bvTaIKGnQcrQLdbxebUuGd63/TXHy1YLNqI7EixSa7+SeJRrr1BHFFXJ13R5Aar4eFx07qbcOlpz74vyMdgpb9/98rf3ONcGEiuix5LGQnChj7NMP6w/+ee9xlC0QWViXzm9Pv2A2FnV5XRfgsVfxTHlLoNc/LozSFXi8DcqiQtZCxqVqp59peMiEgYXGPHBtLO5dRABhdUklSI0+y24XF802OHnJY2IXEFl4YiAijD4r1cFWhKu6W5DTtNxuxTbpcNSs9MMionxJMsRcSiOoKuJzV6NhDmtuV5tMXR+XASQnbvbf8CaVpBn9f7uFK3C29LW2Y/f3fjhq3Qcsvgg7TYAUQwV8+g/6sOyGdo63zPgXPA40huHFbwtWLxaepzmNxIgwV0IIp05Wn39fkfV28F6QH9uFoGOx1wiETt8iKwiZPa9WXcOzWwWwHjYrexBk1mmgwBsAy5Ct3fL2denbgost9KkOow+AZlTCr1pez1/WnDvVLHN9byG3dhR3hTSdvNegRgpzqccq4EtGJ1giReAZuGU0jSg2Bivt088Bldsdf3agMuSIG1BHmKdpfoKlt1W4ftZyejD+dAIlIZQRE7WGIdmme0f5nmxcre7ex++nuz+VFKFv4lEp/ObVzITqRbuM4mWvWcBmnsOve8F4lHT7y0JGDddes6tQ+BXVLo9FxA+y9L92XeyKJWOYQOuW8G700DMc2huTWFV7Gij5kPVubhAjwTIon3DT5jPtroijbCHj7EjE9zSvuoP68fTx8y+OmAbU6YCx7ZmY6cWrAFbltGH2KRr4UwKD1IE8Li46mLCAaBbdb8zpLZHGGlS/ocdsWxM
 bhwRJIIi
 m90GeG6O6BWpocTsZmE8WuXY81zSnyOn5QoG99epbleOLuWPvCtcHA1h4CFej7W92uPqEsKADheY00LPeB7xBS4/FYPdDNYqC1pghm8kNhYMRF/IK4qCzypOmJZLivE3Qh9M+U0JmclmSTW0l+eoufwsJQWlZwDgqcSzIfFcVADevfLldbEkA1Di86BFiTkRr1kishbWVLLqx9snineS+H+h+eWubo6rVj7Z7/vVFA+5QwDvYM/YodYgvdAoDXjP++iEjGXrWtPDiKeZZS1abfZZfgs8G3E2w39EUsxhA24JYQlAQ+VDaNUY7ZhKYqr6oD3gr2uuxVjlbyGlf702Kfsv+dVa4rjD8mA3AWx0pI7Ztt8tFPrCVBVUa1EQVhQpRQ1qlZfJkNA1lpU+PkWOUUWgRlXWeGDdhFqQ+mzL0mvejRj7jvsUoUG+QP5K3PzvClLOe0qyZMxYXx2SfSfupLM32GtdHFnPdYmNI9dyH4wo0oyko9UiLQoy0ldPJtOxVJEtH+teWeLRo6Lg/N634AQAsNF4P4dPQs0k3
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



