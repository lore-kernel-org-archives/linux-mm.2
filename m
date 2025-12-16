Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253EBD637B5
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08F166B0095; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFCE86B0089; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE1E6B0095; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB226B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33F1A13690E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:57 +0000 (UTC)
X-FDA: 84226619274.19.9823578
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1A8FC0013
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=msI+cdJX;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765920415; a=rsa-sha256;
	cv=none;
	b=ug6phjny7BDHudswUKUV0HEESpjmytehLPwi3Czi0BWq+XQsSgjcR5VtfvGZuU6aE1TuRj
	2Jg4EuVZ3uvrf6Ww4V/g5kzYxfTXoPYrjEt9nS62y0HP8mj17pocxi7oly5GNsxf69lVlX
	8hkfdpjh/d6Gor6wYO/6Q0qqQvWnnlY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=msI+cdJX;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765920415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0H6Hb1SNFV2MzYNq0MIPEdNZM15rFuDuoHIHPxAZ1Q4=;
	b=KbcQGXELaj9ZhNrdiQ40Jq0M/lVOjj6R0sDD9jbBr7kXA/UcQU7SjfpHHKI1wJHy3B/q95
	pm68IZenwmpAo8ATSH/6CEzJ1UX0Ssgbox0uaXudQSwhXRDX0dIfd6qNyghKCA3BwVk4pf
	6/AhS9Jc81blJ3VorEIbRZFWhBLkLRM=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC202563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:15 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC202563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920377;
	bh=0H6Hb1SNFV2MzYNq0MIPEdNZM15rFuDuoHIHPxAZ1Q4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=msI+cdJXzUNlR/eoMy2do2LDy33CiT4AkWQnbNT4gvIbk9NWGbm+/kelJk6lDm0af
	 IRawxKGGMx2XhsNeQkzk7CsTrTzCecznGu/P98YSqoGMeFCPg5xUL+SXVBnr52uENF
	 mPue3LYDtdGhIb0WovpF7PNq6pDtL7qFy1JtOxUnXPNQDvkZ2WCWNIKqGaBdCanBCm
	 mobWWh0unykhcBK5UYYOfEQYT6cxpizs86NAebcTPoN74pg9BHAdSjay3EVrXqJ+gF
	 8N+H+rp4lK5q+mX7jocMWVm/qGh7p1O8Ae2RQSwXvWNlFgmeXHjZ9AsUZhCp1xKHQd
	 JtI/OOF7LuQoA==
From: "H. Peter Anvin" <hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: [PATCH v4 01/10] x86/entry/vdso: rename vdso_image_* to vdso*_image
Date: Tue, 16 Dec 2025 13:25:55 -0800
Message-ID: <20251216212606.1325678-2-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: <20251216212606.1325678-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1A8FC0013
X-Rspamd-Server: rspam03
X-Stat-Signature: z8cxyd8to5ioeay88o9zieuyynq37t7h
X-Rspam-User: 
X-HE-Tag: 1765920414-678783
X-HE-Meta: U2FsdGVkX18qaUS8fRI1VVAHddcwu+yVZLJHzYSUFkZr5LX9sQSIUEWycvP+hIv8FZUs4KnV2eEFZK4f4TCT4Rnd8nrY0yiYJhxfPFk4kEvQKGfHhG4jHaixLdaNG11cgfvqV8xeio5/JlpSH20F0ezmtnxn4EcksHxs7UOe+Gv105HpL07VB8R2dOZCrZRpfCqVkoBPkblwdDv176nTG6T2+AvZUeAoBv81SKbeuXkY5AWM+AvMKOR3mrhZij0Jj8ZcDExBqxSOHZwczNMAB3QknttorgY5LvrEmu9GNgqLLfF8W2o8ZBQfSB6A1JZA2RFeBWAhgQ8fTiHppY0TAg7ikzHJiGfSpb/keKuztLHoEYmkwEz8VjbsLJ//m8UgnPRkznMvBTqWQaQSIz6lArC5swzI/2ZR/wFBc/NUiCLm6FrqVMWAitNrPLmh477Aij40SecTEwSOBVDlYwcxCeqT7Q73tH/9Ry10FKheAXirNktKXUBQfHNCy4OJGL8uliHcVGj/xbOZke/y1J/BkEiBN+BPBABmOrJw3goFPuhNHlORwTx5OmFhJxdtAM+Kc0ga4ZrPy6Z2ZYE2VEjjtC7EURTJ+EQgeSRZqL1YGnkd+QZfcgoYBMEJ5RyTqYOE+ZdcLFXQrmKNmG9/j/Tngs6sIWblUbirVFmy7GoNQnbkbRuPA/K0oK6R14gCRh9Ie0Wi4XQhvYt+JW3cpFb6ozTnKLfya5ZkDWInhwzjclvuYAGyI+1rWyF1NtXcjaQKH7MpAKJH1xLeaO904ngH/Ob2pJLD4n8gnKTgIFwmeGPCeJsy6MJa7l7h2xRcFlXbUQvocr/Pbu48C/CVEsDHvmVwT8BlkjCODWThmmrG7BUsKjn1VSdi7fnfoDTmczTG9N1L6R6x8NqGqT0qahaMMGg0UH3jzRxQAxa7R4emiXekeDjRdcws3YpoIdMK05MiglJBYRG3mN1RL+4sjOA
 q4S98Tnd
 xkNprv05hP+VH4gFp39E1SddxwcSLRz83j++R5NiI5+laX5X/pM1c0AysJvcyohPk/Jggo+G/Hz8cBwz3z/JVDLQgu1p2udKQ6ZuAUJaOfVKHCj/EGGwtsVX2EvDs2ZQ6mXt7icZwgxwGBRJ+SaH5oj1v/EF7D//CiVCjVcv5bYuYl1nmpSJWJ5JshdQEjZLpKY7L3nUr9ioMe8VFR5ZLX6osXDIJnr7nK8DSgvSpkojsonEhBbSB1lnHQc8FB6F5IoAv4NoRHxz3yBSU50txrjZdUykoZfyCsU119n+9kq52pbk+wdZMc3KoqepO/ZrnQriuDB9pjqLMOG3cIc349oX0AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vdso .so files are named vdso*.so. These structures are binary
images and descriptions of these files, so it is more consistent for
them to have a naming that more directly mirrors the filenames.

It is also very slightly more compact (by one character...) and
simplifies the Makefile just a little bit.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/syscall_32.c    |  2 +-
 arch/x86/entry/vdso/.gitignore | 11 ++++-------
 arch/x86/entry/vdso/Makefile   |  8 ++++----
 arch/x86/entry/vdso/vma.c      | 10 +++++-----
 arch/x86/include/asm/elf.h     |  2 +-
 arch/x86/include/asm/vdso.h    |  6 +++---
 arch/x86/kernel/process_64.c   |  6 +++---
 arch/x86/kernel/signal_32.c    |  4 ++--
 8 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/arch/x86/entry/syscall_32.c b/arch/x86/entry/syscall_32.c
index a67a644d0cfe..8e829575e12f 100644
--- a/arch/x86/entry/syscall_32.c
+++ b/arch/x86/entry/syscall_32.c
@@ -319,7 +319,7 @@ __visible noinstr bool do_fast_syscall_32(struct pt_regs *regs)
 	 * convention.  Adjust regs so it looks like we entered using int80.
 	 */
 	unsigned long landing_pad = (unsigned long)current->mm->context.vdso +
-					vdso_image_32.sym_int80_landing_pad;
+					vdso32_image.sym_int80_landing_pad;
 
 	/*
 	 * SYSENTER loses EIP, and even SYSCALL32 needs us to skip forward
diff --git a/arch/x86/entry/vdso/.gitignore b/arch/x86/entry/vdso/.gitignore
index 37a6129d597b..eb60859dbcbf 100644
--- a/arch/x86/entry/vdso/.gitignore
+++ b/arch/x86/entry/vdso/.gitignore
@@ -1,8 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-vdso.lds
-vdsox32.lds
-vdso32-syscall-syms.lds
-vdso32-sysenter-syms.lds
-vdso32-int80-syms.lds
-vdso-image-*.c
-vdso2c
+*.lds
+*.so
+*.so.dbg
+vdso*-image.c
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index f247f5f5cb44..7f833026d5b2 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -16,9 +16,9 @@ vobjs-$(CONFIG_X86_SGX)	+= vsgx.o
 obj-y						+= vma.o extable.o
 
 # vDSO images to build:
-obj-$(CONFIG_X86_64)				+= vdso-image-64.o
-obj-$(CONFIG_X86_X32_ABI)			+= vdso-image-x32.o
-obj-$(CONFIG_COMPAT_32)				+= vdso-image-32.o vdso32-setup.o
+obj-$(CONFIG_X86_64)				+= vdso64-image.o
+obj-$(CONFIG_X86_X32_ABI)			+= vdsox32-image.o
+obj-$(CONFIG_COMPAT_32)				+= vdso32-image.o vdso32-setup.o
 
 vobjs := $(addprefix $(obj)/, $(vobjs-y))
 vobjs32 := $(addprefix $(obj)/, $(vobjs32-y))
@@ -44,7 +44,7 @@ hostprogs += vdso2c
 quiet_cmd_vdso2c = VDSO2C  $@
       cmd_vdso2c = $(obj)/vdso2c $< $(<:%.dbg=%) $@
 
-$(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
+$(obj)/vdso%-image.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
 	$(call if_changed,vdso2c)
 
 #
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index afe105b2f907..8f98c2d7c7a9 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -65,7 +65,7 @@ static vm_fault_t vdso_fault(const struct vm_special_mapping *sm,
 static void vdso_fix_landing(const struct vdso_image *image,
 		struct vm_area_struct *new_vma)
 {
-	if (in_ia32_syscall() && image == &vdso_image_32) {
+	if (in_ia32_syscall() && image == &vdso32_image) {
 		struct pt_regs *regs = current_pt_regs();
 		unsigned long vdso_land = image->sym_int80_landing_pad;
 		unsigned long old_land_addr = vdso_land +
@@ -230,7 +230,7 @@ static int load_vdso32(void)
 	if (vdso32_enabled != 1)  /* Other values all mean "disabled" */
 		return 0;
 
-	return map_vdso(&vdso_image_32, 0);
+	return map_vdso(&vdso32_image, 0);
 }
 
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
@@ -239,7 +239,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		if (!vdso64_enabled)
 			return 0;
 
-		return map_vdso(&vdso_image_64, 0);
+		return map_vdso(&vdso64_image, 0);
 	}
 
 	return load_vdso32();
@@ -252,7 +252,7 @@ int compat_arch_setup_additional_pages(struct linux_binprm *bprm,
 	if (IS_ENABLED(CONFIG_X86_X32_ABI) && x32) {
 		if (!vdso64_enabled)
 			return 0;
-		return map_vdso(&vdso_image_x32, 0);
+		return map_vdso(&vdsox32_image, 0);
 	}
 
 	if (IS_ENABLED(CONFIG_IA32_EMULATION))
@@ -267,7 +267,7 @@ bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
 	const struct vdso_image *image = current->mm->context.vdso_image;
 	unsigned long vdso = (unsigned long) current->mm->context.vdso;
 
-	if (in_ia32_syscall() && image == &vdso_image_32) {
+	if (in_ia32_syscall() && image == &vdso32_image) {
 		if (regs->ip == vdso + image->sym_vdso32_sigreturn_landing_pad ||
 		    regs->ip == vdso + image->sym_vdso32_rt_sigreturn_landing_pad)
 			return true;
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 6c8fdc96be7e..2ba5f166e58f 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -361,7 +361,7 @@ else if (IS_ENABLED(CONFIG_IA32_EMULATION))				\
 
 #define VDSO_ENTRY							\
 	((unsigned long)current->mm->context.vdso +			\
-	 vdso_image_32.sym___kernel_vsyscall)
+	 vdso32_image.sym___kernel_vsyscall)
 
 struct linux_binprm;
 
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index b7253ef3205a..e8afbe9faa5b 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -27,9 +27,9 @@ struct vdso_image {
 	long sym_vdso32_rt_sigreturn_landing_pad;
 };
 
-extern const struct vdso_image vdso_image_64;
-extern const struct vdso_image vdso_image_x32;
-extern const struct vdso_image vdso_image_32;
+extern const struct vdso_image vdso64_image;
+extern const struct vdso_image vdsox32_image;
+extern const struct vdso_image vdso32_image;
 
 extern int __init init_vdso_image(const struct vdso_image *image);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 432c0a004c60..08e72f429870 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -941,14 +941,14 @@ long do_arch_prctl_64(struct task_struct *task, int option, unsigned long arg2)
 #ifdef CONFIG_CHECKPOINT_RESTORE
 # ifdef CONFIG_X86_X32_ABI
 	case ARCH_MAP_VDSO_X32:
-		return prctl_map_vdso(&vdso_image_x32, arg2);
+		return prctl_map_vdso(&vdsox32_image, arg2);
 # endif
 # ifdef CONFIG_IA32_EMULATION
 	case ARCH_MAP_VDSO_32:
-		return prctl_map_vdso(&vdso_image_32, arg2);
+		return prctl_map_vdso(&vdso32_image, arg2);
 # endif
 	case ARCH_MAP_VDSO_64:
-		return prctl_map_vdso(&vdso_image_64, arg2);
+		return prctl_map_vdso(&vdso64_image, arg2);
 #endif
 #ifdef CONFIG_ADDRESS_MASKING
 	case ARCH_GET_UNTAG_MASK:
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 42bbc42bd350..e55cf19e68fe 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -282,7 +282,7 @@ int ia32_setup_frame(struct ksignal *ksig, struct pt_regs *regs)
 		/* Return stub is in 32bit vsyscall page */
 		if (current->mm->context.vdso)
 			restorer = current->mm->context.vdso +
-				vdso_image_32.sym___kernel_sigreturn;
+				vdso32_image.sym___kernel_sigreturn;
 		else
 			restorer = &frame->retcode;
 	}
@@ -368,7 +368,7 @@ int ia32_setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
 		restorer = ksig->ka.sa.sa_restorer;
 	else
 		restorer = current->mm->context.vdso +
-			vdso_image_32.sym___kernel_rt_sigreturn;
+			vdso32_image.sym___kernel_rt_sigreturn;
 	unsafe_put_user(ptr_to_compat(restorer), &frame->pretcode, Efault);
 
 	/*
-- 
2.52.0


