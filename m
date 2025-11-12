Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD92CD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 04:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE278E0008; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4AB18E000F; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BEB8E0008; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60D608E000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8389585E1
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:26 +0000 (UTC)
X-FDA: 84100698612.12.4F16D5A
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf17.hostedemail.com (Postfix) with ESMTP id 22B8740008
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=s+fGZ3t4;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf17.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762922305; a=rsa-sha256;
	cv=none;
	b=7bSpQrzBcPtJhQU4elXJtvPDt0TVG/14zM/NRogVBCkwV4OfRgaEN/yVKDKN71v2Con7jW
	j9gyLUDuqHKzZ6L9ofyupiJvHVxgEawBqN8OdOnozGkA15M1CFigmKXLfV7Hhoh0OsaPhz
	TxNIAd6f94YEtCL9qQJ9YlYSo9XinJU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=s+fGZ3t4;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf17.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762922305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MH27EeqDLw8amuPQokZD4InT1d5GPZPkd9MxbYgWsE=;
	b=hAx0TxwFOa6OIZkMyF5CDnwKChLsGUJH/spvXKeqmi/m6u+0qiqhrH5h/Ppo+hxiIdZQoY
	wTJBHTfIm/qrDL/Oxdi5eZDL/XUVodwwgtLzhlFjadT4ZoTMFntUBFhAikdnPzSYCA0Iab
	o5gfuKAaI459G0l2hfbbrQOKFrtHFpg=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AC4bYDN542538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 11 Nov 2025 20:37:37 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AC4bYDN542538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762922258;
	bh=6MH27EeqDLw8amuPQokZD4InT1d5GPZPkd9MxbYgWsE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=s+fGZ3t4gki2X6Sbnya+Cx/l6bOyNBGorj6Z2ON1nO6q6VRgRkoLlPP4wZOCrLCeS
	 0/t7y0taJIdulak/qbl9bKZr/IXA7QSiLvVe+zjLKj12HfbGxX4t9hH9JzccerkGDq
	 U7ggsgftvstJN9z+Y7HgauhSzL3R7IUicWeDy979p58hJlEgrqLfocse7CHQzv8rEe
	 /Lydfry1pCj4wBQST55T08MlI4CNXkIOhji1BhuhEfuZwiOc1c06MpiHI8m6JmwRKo
	 uJkyRK+9Ed7hdnhltJFsIguT9t7eQ6pvSpiIMUrdEkZ0WwDMJJk9q+qAIFT2426Y6B
	 OXUbliMu500EQ==
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
Subject: [PATCH v2 1/9] x86/entry/vdso: rename vdso_image_* to vdso*_image
Date: Tue, 11 Nov 2025 20:37:19 -0800
Message-ID: <20251112043730.992152-2-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112043730.992152-1-hpa@zytor.com>
References: <20251112043730.992152-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 22B8740008
X-Stat-Signature: ciy78fzzgy87u4muer8gfh8w6twuarfu
X-HE-Tag: 1762922304-731858
X-HE-Meta: U2FsdGVkX1+gAOCk9B979Sbg7plsccDUgV0DifZ4afa3Jfavy7KfNUicybWBvUa4oZdZi4v9VMCDg3Ha17UQbxgOyuYfm02F341wGikRzS0u7q/duHDkJpqyAJVkRs27EseL/F9orZhuZg0q2c6nCw9b793WIGWIbKgn85j1RsjEt83K7QWLFMhI/+s4c4ktQ+iWkAeWBe5u+UGOajYedW993zyK7fKgcMgxI8K3Ne5Ebc2DBFF07aI8c2bCrNpdZ4gqaHkfLpVqFaijSYLDpT6EFve9jhNUqje2b6rUbZDsx9kS2l0/Ib+Wm5u0+7G4uUrn6pawHYakTy7+tdLoLfOjsKwtAZxwXEcMLAw/dbOBZl2OcMDzzbFotaT+iFsC8knuc3D9EEc7OVbKgBcq5jBiavcL+KDJYsIRqDEHDyDcuA4zbjBam9kMNepzDzNMR2GhSMYBuOdqrrNVoHijKOWLRrVIII16gvu185r6FYYPZcSeDlyYtCLKcNFIOy5FMuw/EaVJwKLx00hbMsFJ1J7IhA9mLa71j1mGBVTNp8hO1IZbLppZODcMG56bZ30VSr2rMKDrSTNdP4Rss7XO8XWSeGIrNvSkss8Ts+eeC63dtOmezG1QTa3jMgRzKWbBofa/ly60ifkgBeeKfd5ApQ6lPw6J38/jTAWYnKcV7hDEdhKmiKOmd5f7+sEuYovlIUtL88dA7Qjv0j4tOU04DQdi588B0jA3IAGSXKNYIJe1gLlMjNuMBiq/v3VheNs8pG1k7D0BO77Q07+wxM/hW4Ruk758xcswsOZpJ4DrqrDX5E2OCJkhtQ+TtbDxBkLBoxfkUDpdx4bQ/IcfDJ/uNKr8+mnIKTtaSTMyW/vBqda7RGtlO0mhY8Qq9MqgzsgnulZXj+aRjKmPzG38HITttqwpmbIZ6Iia7Rjh0PbgYC3Pk+6NNXhG2eEHI57vhpnx9+9uemUm1SFj4xNxriP
 E3oivwwZ
 LgALBQYIArDvzoZ/OeGEbnw+Ip6DnNqGUoT5LqvAasMx8Tdlspgwm5vH4Xq65k4InFiqT0+Mm1+bWb6awSMTmGDNy32elexuWzYanzSfbTp0zUlEYIhgYerJqYMJ7DJhIEhHDSnDIT8hZS91dm3FfSnmr/dVTHaR/BBtils+cnt04hBt5OPs6BeTPYdfvyiBrNFfiB7ru1ilHSLEFt++0s/6Ff+A7IC0LXTXSGHJF6PTOI4XJQZR2VrQ7+WX8qaQARejGSNX8Q41iAwmwJGR2YhlacsspriStnf4yDSCNkLcKWuvg9GDOeDNZhHbi1AGD9BTYKRjsR0TIA0Fx8Vl2nLZ1Jg==
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


