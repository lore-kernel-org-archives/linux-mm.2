Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E84CD37BD
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EC3F8E0007; Wed, 12 Nov 2025 15:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B5A8E0002; Wed, 12 Nov 2025 15:23:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C308E0007; Wed, 12 Nov 2025 15:23:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 59FD78E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:23:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19FAE1606B2
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:32 +0000 (UTC)
X-FDA: 84103080264.24.1C7D80B
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5522E100006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b="LgNS1/eb";
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MH27EeqDLw8amuPQokZD4InT1d5GPZPkd9MxbYgWsE=;
	b=Qaz4Okk4ItLtk3eI5DRCLSbfgEgwis3TOIQOnSvHQm/cMePVtm+Z2mYFi++JeLyrhvu1Yo
	i5HBiZz78eD7o+ntUhhINCWqbho4ejMlkglXtPOJrzXM8s3iEveLfIIfq4Y7dmCHT9PVbZ
	umex/jBQEh8E0tTj8esagKa5KtMq5rg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979010; a=rsa-sha256;
	cv=none;
	b=JpLcfUNa2lErwaTBeyaZFfo2wLGVuwei0qxJz9LMAzNBcVxEJ5Doy9GnzNsYamwqdO5sdB
	sojz1iasATme9cFhmXtQllrvbwNOLtpYqQr35fBNRd29rTgOsDVz8k5Myu1WP9jp7WXSS7
	HLmSBUF/ay2YDEmEuQcHT/lyhvw2BhM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b="LgNS1/eb";
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKN2Lx978372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:23:06 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKN2Lx978372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978987;
	bh=6MH27EeqDLw8amuPQokZD4InT1d5GPZPkd9MxbYgWsE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LgNS1/ebwUUJLI6wX04wB/UVMoHRcPurr/w7mtuCJ07Rjfrjfw8sGSu+YDE762LUv
	 Qf5qPvR1qIFGc/oh2qVTiC8MIxlvueIxWS0sWvzzrypbb91W0nMmBppERfGIwm6Rqy
	 NPtaoOQrkEYeYKHXIJBUOxfceLx/LZxUJHpsOr5lBP1GQNI7Pv0shPJgYwmf3ExWTU
	 tcmc6bxOkKs5ZCrBbWAdMvVpFzs+/bSRcfY1jCojSSJ92vON6q91cQ8jtbQThI7+i+
	 ryN8RAabdY2zAlCO2OKGnpxxgzX1NcaB0FhlWV2Rjvr95mpCEH9O9GTqSMltyH2B1a
	 0ctgt6hMkXhHA==
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
Subject: [PATCH v3 1/9] x86/entry/vdso: rename vdso_image_* to vdso*_image
Date: Wed, 12 Nov 2025 12:22:46 -0800
Message-ID: <20251112202258.1310754-2-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112202258.1310754-1-hpa@zytor.com>
References: <20251112202258.1310754-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n6stghscwifgqzuhxoof4bs88t7gqz36
X-Rspam-User: 
X-Rspamd-Queue-Id: 5522E100006
X-Rspamd-Server: rspam01
X-HE-Tag: 1762979010-954225
X-HE-Meta: U2FsdGVkX19OBGIt4EcZkyuNC+uN5NcpiThx3MKXCYBERbd8wPDkl2J6EL8drUEUEXx2ui3AqWRLmMxDLLJt/KKiAt7vkRxUF2l+G7VXu2BtDAH+aQ67jlsXE7zcRL/GtJdLLHwxYtjH3RrFxpQHjsW85BWA+AzKqdqHq50S462IrjyL2VuLG9JJCV5mZwzqIevhZhL7lBFPa4aNNMyNyUJ8YyqWkgYg18uEMK3rHvekZnbz0O+11euYkNEsAT8ZZ08wuWmGiF+mZ4HIBO12lXhIf2ZtGSasPXEWzjae1tm13GWXSGOFrbQKSPXFI7vwTtRwy/wDj/Xoxcu91S4aspM39yMLIEx26acHnpBhJpiFk4GqOTra44J9Z6h4+oeL5Od6yxVInLx+nj/VP049/WUwrHeG+lMiZnICZld9UJ0QSnoFvJOfeN13rNbOnI/M9tBCCrzeW/FqCWoOJZ/VbzksSYsgrF5v4+EWxjNROIRaNp3TO9qko+mqeJPJox/mWHqcy24tFaSBZ5kBmfG+Ez3laAI4esP2UqkdObk3saLAeJemlX9HWwVgAwtJI4P27heVWv5IrGNn7JcfJDyT33yDDVF0y/qnRGiOKqflcwfcawx4ptjyTpyeP1PY385dTqXyqteAluWrUSp7FYpRnrC0xEzssR+NYyLm8Lt1GFsXqdY25f+bfTQ1HBP2hsboZwn4RPvHB1uAxCILqILQErcXZs2mYWfpGGhb4gp+lyuSs7KuLJQm5BIvGV/pfkOOqepA4o+dQrFENBQ+8Gas+TORVWG/La8bw0jckHyZhbqVD6sgPWIDqk2j2aO4l5rMk+HzjgVlJCK7B54ttFxRBrFMjY9YcclTdGcGYAEnovSV56YHhu7FOoDK5/28NBSdKag66nqqF190xKwPdWAo0saHfy4QrqLOrTUcMwAM5VfWTxEXSmkFoSJIEV23sFFduHq2rRWEGjsU6R7OUzn
 dyXUADjV
 vcZysP21BclQpIOalpG+9vd0TAy5T/HjpQCsH06TWffPWDgdtFaU8MqPCc03ayHOqLRLmjMnHAGFspexOT+RHbJByLjBMRD9nV0ve29jMh32mybBW7SrDuzO+Xh31FxyzfIdlbiR/STzDUca9jcIOh2CO3RvpaVDDjuSttEvroAOq4S7q/H5cuXvw6hNTxSwiPewimuciyydGN5Qrgn7NgOpkrsnwYhMi29hZziJHSE/8Z6GRv4AyMOsF1hpMw/WKrEZVxt7GCYwXl9v/0VbH8+fAklruCGjiTWQiZNn03Uyy7HmLmL8CMIRm1MicZPH9dNl8YNhE0T87PlhC0R3WxYvghg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The .so files for the vdso are named vdso*.so, and these structures
are image of the corresponding vdso. Naming them accordingly is more
consistent, very slightly more compact (by one character...) and
simplifies the Makefile just a little bit.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/syscall_32.c  |  2 +-
 arch/x86/entry/vdso/Makefile |  8 ++++----
 arch/x86/entry/vdso/vma.c    | 10 +++++-----
 arch/x86/include/asm/elf.h   |  2 +-
 arch/x86/include/asm/vdso.h  |  6 +++---
 arch/x86/kernel/process_64.c |  6 +++---
 arch/x86/kernel/signal_32.c  |  4 ++--
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/entry/syscall_32.c b/arch/x86/entry/syscall_32.c
index 2b15ea17bb7c..eff33a4e0adc 100644
--- a/arch/x86/entry/syscall_32.c
+++ b/arch/x86/entry/syscall_32.c
@@ -318,7 +318,7 @@ __visible noinstr bool do_fast_syscall_32(struct pt_regs *regs)
 	 * convention.  Adjust regs so it looks like we entered using int80.
 	 */
 	unsigned long landing_pad = (unsigned long)current->mm->context.vdso +
-					vdso_image_32.sym_int80_landing_pad;
+					vdso32_image.sym_int80_landing_pad;
 
 	/*
 	 * SYSENTER loses EIP, and even SYSCALL32 needs us to skip forward
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
index 52a5c03c353c..ae00c788962a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -942,14 +942,14 @@ long do_arch_prctl_64(struct task_struct *task, int option, unsigned long arg2)
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
2.51.1


