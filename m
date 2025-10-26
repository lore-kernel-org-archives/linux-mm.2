Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93204CCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 22:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A910D8E018B; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F9C8E018C; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E528E018B; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C84B8000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15ABA48A52
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:12:57 +0000 (UTC)
X-FDA: 84041666394.20.28011D2
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf11.hostedemail.com (Postfix) with ESMTP id 796264000D
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:12:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=aqZr+7FY;
	spf=pass (imf11.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761516775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MH27EeqDLw8amuPQokZD4InT1d5GPZPkd9MxbYgWsE=;
	b=jAXB9bfUdg8uyhOoSZotaErZKtitkTjyYYHcgKvaKn9CAZC50EGvDphyCHqtvz8Q+xixtf
	YkTKDQng6vDj0tamBLMMifRs73gaYTRwMDD+uyOH9bCSblC3GQjOATJkIo6n2huHDzKguB
	5B3Qa1vQkDb93jAvFRcT/4FFy2Y+e88=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=aqZr+7FY;
	spf=pass (imf11.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761516775; a=rsa-sha256;
	cv=none;
	b=bqM2vUVcMlSTH6T5g8Bb2MONEmiik47Mf/fu8t2YsXciPkCuKKTvsDRG24EwAWpYGWhs1X
	aYAasCOS/9fXYzkbkmHGw8fGDnktVavtpJc/Suex5jomR4Rt84v3w5+mvR07plG1Sfc3kM
	6Ne7HpJMBkY8T1/udwd6o/E7I0tIYMo=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9484:8257:f1ab:878e:498b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QMCFpL548264
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 15:12:20 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QMCFpL548264
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761516742;
	bh=6MH27EeqDLw8amuPQokZD4InT1d5GPZPkd9MxbYgWsE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aqZr+7FYEWcq/gWL0R9KKjAIfZYqyoPvRbBpOai3XajUQOqyO7C0C0kS9FGZpi0qA
	 2k2vggxDbgecnyrxUqbkkMvs7Hxt6q4wvqJYQokr/lnP0usniKWGhvkEj0dFOR475c
	 OrcWEMr/IfIogpR/7AIQJfJ2YhJgR2NMlrj+3HgKv9/c4EQuIrQUS1zdo0r1CNxn4n
	 c1wYfflGyLJ6X7HkCOY9DKZYU7b9HHZ8Q9iw3YLJ1QUb+RF1MEOz3uJlLHi39F9qci
	 iIqgqS+O/rbADESO0/OyHypSHgY/fqh6kFnQ3az9slr4CEpOFFOmh7Au0vI17cfXKy
	 tKqDNQfgp9CNQ==
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
Subject: [PATCH 1/6] x86/entry/vdso: rename vdso_image_* to vdso*_image
Date: Sun, 26 Oct 2025 15:12:01 -0700
Message-ID: <20251026221208.1938173-2-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251026221208.1938173-1-hpa@zytor.com>
References: <20251026221208.1938173-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hco45sewuzhyhd4uk8dhdezz8qniqpaj
X-Rspamd-Queue-Id: 796264000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761516775-503276
X-HE-Meta: U2FsdGVkX1/QJ4MdoGDbejwZSOe+kWdoSP4zd7Wu5qxy8NGJzqxRDIWS5LvhBqbxUPH/BTw2Uc6SjsEBbyXP7uyOqWCBirqtCV1kJvmjOYR7X6JRaRDKRhgerzwg/re4ofDQaLeP5/t9bnQAetuKb76T8d5Ko+LezfQngxxTEeS0T/QVwJZ9qvByrV8bMUDoMBA0oh7TO/49g/BfB4h8jtI2WTdxASFinP2E1QjZ228FP3kt4dIRD0NN0a1rnWi9M8JiBokkpfYmeqA6+dzKAmBNBtS0sPMeuMezvLHsrXoIOex7WhQPponZ7gmL3unZo2fIxzIQglW0kxBEzRzDI6q2p/nlu2lhpPQz5TaKAnVfEcwpBqydrPiTMLh5Jrx9DHPuy9T7d9HAkWbcabacoO4EQdDTN0Y5Vp0WFam1F4HjoyMhFiQwp0xqB43tCfRGmBxWXS3pkoVWwPigtXoFvkoAly4Sx09V+uISdGMwk0UClQekiUkJEthya6mwwnuvkD4aSTf18b3CZHZdjDl47nR5zjPPMcVr+Jg2Gs6aphJuLiP4oNw3+z12IKxB+SSHvWKN18qTPMK4Go1OJkecK+UNwC9BoEDeghnYN+arK3DiU7l/uTP3g9kdMH0H8iXsXXsgJN1mzae0kMsGmhTNmUtb+bdY0voPdG6hKhEO5njhig2hNNu905yhIxthAVG4KktsgYdFYYxT5Z/ESxqM9nQYBBIpU1rbDIHDKVcxYKQPRyBdntkzU5wftXhT9YnDa2k/spebxe32GnneXBLLSv/XBJOA5JWdnQBOjI0IZSrkwcLk/YBpDld2vd9dbI28ERVLp2+MjpFa+2IlE2dPp1YbS0kIVNVJU6klpUYUJaW4auXPajxkCTKgW7LT+1WLeorkZq5M0jNwK9SmI7yhBRm5qQYUYG242l2NzDWnV8RENSKS4S+9kJYD+v5kgj7bjxBq37ZCdpEBMR26Oic
 DBuZk9qY
 pGtod2juxvOlHAMIMp11mUbEQknpWBhCyj1p87UD9ARJHj0pYAz4/cD+Kb3c3x5d9szj8/kO4covmG/Vwu/PzuGlL6G8oVtn6siEtBzO8qXd5/JTXj3o1S7Zwqu2ba6aMZRAbdNQ/E6QR574pitdyt/osH89Vo5F6Sg5jlje2AAUn46ENlK2T53R6/BH9LzWjOoZGRBRdHS4GOP0ydadyftkgiCBd8WZFq6sD2W3M7SQAEvyWPX0tLcEzRS2nfm7VRzB9oz1QoVHSVsB7uEZskDEa5ptb8bZ6dgaxOrpB23ScIX90mkxzxaNX61cYFVO16kZcvxOLNZy4hWaaHh7jUmUpGJuG4KMVs7G7JyXdFOg2Rig=
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


