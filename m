Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63EDD41D6B
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F116B0031; Thu, 11 Dec 2025 12:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C1C6B0032; Thu, 11 Dec 2025 12:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260E36B0062; Thu, 11 Dec 2025 12:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F372C6B0031
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1882134907
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:21 +0000 (UTC)
X-FDA: 84207856362.22.2730D94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A151816000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pl1Y/0L3";
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473679;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mP+6VCtzEYRO6NAVXMqOpHgl80OGcY4qu8jLJtqpfqk=;
	b=f485sFlfI7VwNTwPsVtCeE8uqv6NaFkhdNGtWuJUhMSkaxqqcp/WWwpfPevC1WCiU8hDRm
	yTJTbziAwTChw/tx4FSrtViiK/ZgCdRBqfDs8heXKgKzPkBjLQQxeGFTMXrKdoag1BMIfb
	RHRqE8UCm//R9iwSXlbuzIVyhTkJRRo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pl1Y/0L3";
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473679; a=rsa-sha256;
	cv=none;
	b=71Aj5Gl/V8hArHuWONM/WaDxVLno2dm2znIJMbLkQmBLEkQFkQDqmgufcx3Oa2NCMJB5UG
	zb2EmE/CRIrGvYosM89jDFHvFhJT22dHtuJ8/X0yWmu8HoUIqUqPs+Svi46I5+doCfCc/O
	Dpmn8A+oY4aGx7wYelBHfIHnGBEBog8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47A3E4446F;
	Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20D5CC19423;
	Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473669;
	bh=Gik5Ne1eWFaL8sJvPEFgazq3pfqJqZjDQJJ5q2/JRd0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pl1Y/0L3PfF2gcDWKTotx1/R1pdvD6hWQmSZf6EFJupMwSMbvvLB2+5msMJ0V7UkW
	 HhyAe0DmZ1p5xR+pceCei1ySul7ViINw0riJGLe6itDkmUNCLBxqpUpmBbh6UTQu/y
	 qTnWbWV6/ttOm5GH/WapDCbJsBCdZQlIfnzNcCYS1RLMr/lW+TLuGLuzIvfb3318oc
	 l3SRjvK/ss7u74N4rV2CPq7smZuxclpw5pMHH4yezKaPRrgtNC0HGuvopXYV4O/y9U
	 Y1iBIqGoSBuSQz01ysC7pWbDFFA7PPLjhKK1OFF5TAtAkmnGmxTtOgMeVhQXvpOPPp
	 B5GwVEncQnAgA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11445D41D74;
	Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:57 -0800
Subject: [PATCH v26 24/28] arch/riscv: dual vdso creation logic and select
 vdso based on hw
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-24-f0f419e81ac0@rivosinc.com>
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
 Charles Mirabile <cmirabil@redhat.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=9634;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=UxHXf2zeJLK3T0z5eiQQ+giSJlpW7xe4gjeVc08sNbM=;
 b=3ebT60RvZI6ZGDFwNVwuXxsO4vRpC3o7wD9y08t26fyi6Zix1EUcjyfjY3OQhtrJxiBbK5ZPt
 ccb5Sz1PWO9ARDkuX/u0kSCPxRuqzV1jidhcZP+CWk1Osk7HnpMfjsE
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: tpdfkjapzxupadth4fyqcqojznow1sq4
X-Rspam-User: 
X-Rspamd-Queue-Id: A151816000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1765473679-447353
X-HE-Meta: U2FsdGVkX1+33pmQ8gUSYOLfBeDmPWP3SuWsCd8H8bNhCt4zlhipuxJ52CV3kBDLWgWUOd1kGJhKYpAeiAGcMBLUJkCcEr1sBXfgCL6fI3H3xSIUw2E/rzCBpJcf/wUmeeZuFgFbN6El0xy9hrgTXEc7B4oKunFcEdPJNuxiidOH+KVxVZpCz+ueOL6+fhT8q4dfao0HiN5y8YQQywerr+zpCc824aOt7ZHUJelx4b/aIDIm8k7NRubIn93hNo3mhn7hLtLp73G227m1G8E86KEdNqkJNKHYGE9AIqaU8sCRUorD2zEHpX/D7sHG3JusTx558NocpfkWFC7QTYtkhAxhEI/M1eJc5t9hiCkcYfAfqcsEQqknC6zreYLeexDfL/rUzbqcM1vXY9Dsez9ZEYBrPUwEt1Ze6zQVTTvS++lK+6Ek0DpbANDsX6KW8HqfA+FNruPhpe0w7eccLLsQ3Mws2CKWdJnE0JqENdDB9eLYpCRi1qhOGSskvyJSV5M2X3PDm5u8C9B8yi+ukT9iG0BRsujRyiq58e1c2mSoUtRUn7F6ADQCpXqic0LT1nWomDmRqfl4nWM3vuWWea6CjAjnh+anXuX4pfGhw4O0QNzgw1RTHLAJpKOMkskgsc/x+lClTy8jeZY0qh7vlNWiD80cMkD16XRxOHmbO7ml/aR2gx6xgg4NtPokrOZ6XzT1kKLTpWuNDl5GheiAgU79Qek8t59fCarvDiClHHd+5xYGcdbNGMvsNud3DH92NuemJbomk+/YbdOnZQl3lWwFvfbsfivIMssJr1ZTOCwOrrZaiQX7IHIKWXfXZfhpeyWmtjBZ7EnInTQpGokQBC0DGZ5yk/WBKXHw/PDmhrs/kT7+3SO4/cDmwrsF3njiIWeuT+hr76P0wjb+HYMwTqYGDYcz70Za5UfnZ0lIfKNySWJtUSgBrtwPPKjgFht3TsQmCrlu6ZQMK0zrk2BZRjk
 wigTUaiP
 krS/InvbOmCm9f2wqz9OIuuOkCEKZ7C36NFkXE7T9jng0HcGtUCJx2AnRjLOEDK2UNlUdIgqEpq9TbByPGEpPjv1JwewHnxpzKrQFTLhGWmrEJr4TRT31wCIWllEBgtmIVXLspRWtsS606S7SHptrW3Sb1bUmUnLNY+GgP8+KUoaDeIzqJBJKEQ08+kIQkzfgYXPz2gbnz4ktk8TCDYIYO0KhvJplfgMLW88r3B6x2/37eZStDcj84v5hwu/ka1oJ+aHMngZvY99cOhcOIM9xQDl4ADMMfIJx9Ux74mTep9K084qXf2ecscUlNLA21EDpZh7WSVH1E8mdUB4CcqrW5n+rhF/aeCtxNSU4D63aNvcnN6MAfPm9yErK6sFq7LWRye/cowzFfUT31dH5Hx24V2jeiEj4gam58bfaOVFnse34EDfoD3NLDFvXfk3RZZ7fxfWn6feWMvUUT9c2DQh+y59WtqC9AVZKswXXLDJk8aOf5j4B/82WYguEO0ff/aS95YvzMCg3frNGzhspgDV5gyQTluwOJNmJVrl+7AxdqySXdnR68jLRTJwmmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Shadow stack instructions are taken from zimop (mandated on RVA23).
Any hardware prior to RVA23 profile will fault on shadow stack instruction.
Any userspace with shadow stack instruction in it will fault on such
hardware. Thus such userspace can't be brought onto such a hardware.

It's not known how userspace will respond to such binary fragmentation.
However in order to keep kernel portable across such different hardware,
`arch/riscv/kernel/vdso_cfi` is created which has logic (Makefile) to
compile `arch/riscv/kernel/vdso` sources with cfi flags and then changes
in `arch/riscv/kernel/vdso.c` for selecting appropriate vdso depending
on whether underlying hardware(cpu) implements zimop extension. Offset
of vdso symbols will change due to having two different vdso binaries,
there is added logic to include new generated vdso offset header and
dynamically select offset (like for rt_sigreturn).

Acked-by: Charles Mirabile <cmirabil@redhat.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Makefile                        |  3 +++
 arch/riscv/include/asm/vdso.h              | 13 ++++++++++++-
 arch/riscv/kernel/Makefile                 |  1 +
 arch/riscv/kernel/vdso.c                   |  7 +++++++
 arch/riscv/kernel/vdso/Makefile            | 29 ++++++++++++++++++++---------
 arch/riscv/kernel/vdso/gen_vdso_offsets.sh |  4 +++-
 arch/riscv/kernel/vdso_cfi/Makefile        | 25 +++++++++++++++++++++++++
 arch/riscv/kernel/vdso_cfi/vdso-cfi.S      | 11 +++++++++++
 8 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index f60c2de0ca08..b74b63da16a7 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -176,6 +176,8 @@ ifeq ($(CONFIG_MMU),y)
 prepare: vdso_prepare
 vdso_prepare: prepare0
 	$(Q)$(MAKE) $(build)=arch/riscv/kernel/vdso include/generated/vdso-offsets.h
+	$(if $(CONFIG_RISCV_USER_CFI),$(Q)$(MAKE) \
+		$(build)=arch/riscv/kernel/vdso_cfi include/generated/vdso-cfi-offsets.h)
 	$(if $(CONFIG_COMPAT),$(Q)$(MAKE) \
 		$(build)=arch/riscv/kernel/compat_vdso include/generated/compat_vdso-offsets.h)
 
@@ -183,6 +185,7 @@ endif
 endif
 
 vdso-install-y			+= arch/riscv/kernel/vdso/vdso.so.dbg
+vdso-install-$(CONFIG_RISCV_USER_CFI)	+= arch/riscv/kernel/vdso_cfi/vdso-cfi.so.dbg
 vdso-install-$(CONFIG_COMPAT)	+= arch/riscv/kernel/compat_vdso/compat_vdso.so.dbg
 
 BOOT_TARGETS := Image Image.gz Image.bz2 Image.lz4 Image.lzma Image.lzo Image.zst Image.xz loader loader.bin xipImage vmlinuz.efi
diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
index f80357fe24d1..35bf830a5576 100644
--- a/arch/riscv/include/asm/vdso.h
+++ b/arch/riscv/include/asm/vdso.h
@@ -18,9 +18,19 @@
 
 #ifndef __ASSEMBLER__
 #include <generated/vdso-offsets.h>
+#ifdef CONFIG_RISCV_USER_CFI
+#include <generated/vdso-cfi-offsets.h>
+#endif
 
+#ifdef CONFIG_RISCV_USER_CFI
 #define VDSO_SYMBOL(base, name)							\
-	(void __user *)((unsigned long)(base) + __vdso_##name##_offset)
+	  (riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP) ?			\
+	  (void __user *)((unsigned long)(base) + __vdso_##name##_cfi_offset) :	\
+	  (void __user *)((unsigned long)(base) + __vdso_##name##_offset))
+#else
+#define VDSO_SYMBOL(base, name)							\
+	  ((void __user *)((unsigned long)(base) + __vdso_##name##_offset))
+#endif
 
 #ifdef CONFIG_COMPAT
 #include <generated/compat_vdso-offsets.h>
@@ -33,6 +43,7 @@ extern char compat_vdso_start[], compat_vdso_end[];
 #endif /* CONFIG_COMPAT */
 
 extern char vdso_start[], vdso_end[];
+extern char vdso_cfi_start[], vdso_cfi_end[];
 
 #endif /* !__ASSEMBLER__ */
 
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 2d0e0dcedbd3..9026400cba10 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -72,6 +72,7 @@ obj-y	+= vendor_extensions/
 obj-y	+= probes/
 obj-y	+= tests/
 obj-$(CONFIG_MMU) += vdso.o vdso/
+obj-$(CONFIG_RISCV_USER_CFI) += vdso_cfi/
 
 obj-$(CONFIG_RISCV_MISALIGNED)	+= traps_misaligned.o
 obj-$(CONFIG_RISCV_MISALIGNED)	+= unaligned_access_speed.o
diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
index 3a8e038b10a2..43f70198ac3c 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -98,6 +98,13 @@ static struct __vdso_info compat_vdso_info __ro_after_init = {
 
 static int __init vdso_init(void)
 {
+	/* Hart implements zimop, expose cfi compiled vdso */
+	if (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) {
+		vdso_info.vdso_code_start = vdso_cfi_start;
+		vdso_info.vdso_code_end = vdso_cfi_end;
+	}
+
 	__vdso_init(&vdso_info);
 #ifdef CONFIG_COMPAT
 	__vdso_init(&compat_vdso_info);
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 272f1d837a80..a842dc034571 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -20,6 +20,10 @@ endif
 ifdef VDSO_CFI_BUILD
 CFI_MARCH = _zicfilp_zicfiss
 CFI_FULL = -fcf-protection=full
+CFI_SUFFIX = -cfi
+OFFSET_SUFFIX = _cfi
+ccflags-y += -DVDSO_CFI=1
+asflags-y += -DVDSO_CFI=1
 endif
 
 # Files to link into the vdso
@@ -48,13 +52,20 @@ endif
 CFLAGS_hwprobe.o += -fPIC
 
 # Build rules
-targets := $(obj-vdso) vdso.so vdso.so.dbg vdso.lds
+vdso_offsets := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),)-offsets.h
+vdso_o := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).o
+vdso_so := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).so
+vdso_so_dbg := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).so.dbg
+vdso_lds := vdso.lds
+
+targets := $(obj-vdso) $(vdso_so) $(vdso_so_dbg) $(vdso_lds)
+
 obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 
-obj-y += vdso.o
-CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+obj-y += vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).o
+CPPFLAGS_$(vdso_lds) += -P -C -U$(ARCH)
 ifneq ($(filter vgettimeofday, $(vdso-syms)),)
-CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
+CPPFLAGS_$(vdso_lds) += -DHAS_VGETTIMEOFDAY
 endif
 
 # Disable -pg to prevent insert call site
@@ -63,12 +74,12 @@ CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
 CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
 
 # Force dependency
-$(obj)/vdso.o: $(obj)/vdso.so
+$(obj)/$(vdso_o): $(obj)/$(vdso_so)
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/$(vdso_so_dbg): $(obj)/$(vdso_lds) $(obj-vdso) FORCE
 	$(call if_changed,vdsold_and_check)
-LDFLAGS_vdso.so.dbg = -shared -soname=linux-vdso.so.1 \
+LDFLAGS_$(vdso_so_dbg) = -shared -soname=linux-vdso.so.1 \
 	--build-id=sha1 --eh-frame-hdr
 
 # strip rule for the .so file
@@ -79,9 +90,9 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 # Generate VDSO offsets using helper script
 gen-vdsosym := $(src)/gen_vdso_offsets.sh
 quiet_cmd_vdsosym = VDSOSYM $@
-	cmd_vdsosym = $(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@
+	cmd_vdsosym = $(NM) $< | $(gen-vdsosym) $(OFFSET_SUFFIX) | LC_ALL=C sort > $@
 
-include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
+include/generated/$(vdso_offsets): $(obj)/$(vdso_so_dbg) FORCE
 	$(call if_changed,vdsosym)
 
 # actual build commands
diff --git a/arch/riscv/kernel/vdso/gen_vdso_offsets.sh b/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
index c2e5613f3495..bd5d5afaaa14 100755
--- a/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
+++ b/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
@@ -2,4 +2,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 LC_ALL=C
-sed -n -e 's/^[0]\+\(0[0-9a-fA-F]*\) . \(__vdso_[a-zA-Z0-9_]*\)$/\#define \2_offset\t0x\1/p'
+SUFFIX=${1:-""}
+sed -n -e \
+'s/^[0]\+\(0[0-9a-fA-F]*\) . \(__vdso_[a-zA-Z0-9_]*\)$/\#define \2'$SUFFIX'_offset\t0x\1/p'
diff --git a/arch/riscv/kernel/vdso_cfi/Makefile b/arch/riscv/kernel/vdso_cfi/Makefile
new file mode 100644
index 000000000000..8ebd190782b0
--- /dev/null
+++ b/arch/riscv/kernel/vdso_cfi/Makefile
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# RISC-V VDSO CFI Makefile
+# This Makefile builds the VDSO with CFI support when CONFIG_RISCV_USER_CFI is enabled
+
+# setting VDSO_CFI_BUILD triggers build for vdso differently
+VDSO_CFI_BUILD := 1
+
+# Set the source directory to the main vdso directory
+src := $(srctree)/arch/riscv/kernel/vdso
+
+# Copy all .S and .c files from vdso directory to vdso_cfi object build directory
+vdso_c_sources := $(wildcard $(src)/*.c)
+vdso_S_sources := $(wildcard $(src)/*.S)
+vdso_c_objects := $(addprefix $(obj)/, $(notdir $(vdso_c_sources)))
+vdso_S_objects := $(addprefix $(obj)/, $(notdir $(vdso_S_sources)))
+
+$(vdso_S_objects): $(obj)/%.S: $(src)/%.S
+	$(Q)cp $< $@
+
+$(vdso_c_objects): $(obj)/%.c: $(src)/%.c
+	$(Q)cp $< $@
+
+# Include the main VDSO Makefile which contains all the build rules and sources
+# The VDSO_CFI_BUILD variable will be passed to it to enable CFI compilation
+include $(src)/Makefile
diff --git a/arch/riscv/kernel/vdso_cfi/vdso-cfi.S b/arch/riscv/kernel/vdso_cfi/vdso-cfi.S
new file mode 100644
index 000000000000..d426f6accb35
--- /dev/null
+++ b/arch/riscv/kernel/vdso_cfi/vdso-cfi.S
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2025 Rivos, Inc
+ */
+
+#define	vdso_start	vdso_cfi_start
+#define	vdso_end	vdso_cfi_end
+
+#define __VDSO_PATH "arch/riscv/kernel/vdso_cfi/vdso-cfi.so"
+
+#include "../vdso/vdso.S"

-- 
2.43.0



