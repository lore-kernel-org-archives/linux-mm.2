Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE9CD339B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9ED6B0096; Fri,  5 Dec 2025 13:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28F866B0098; Fri,  5 Dec 2025 13:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1989E6B009D; Fri,  5 Dec 2025 13:42:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1B6B6B0098
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B25741402D9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:05 +0000 (UTC)
X-FDA: 84186287010.03.FC2E0F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9649140006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgXeSFHj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960123;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q07HzVaHl2HDT5wlOWAd1gppDFWR0DRec4EY9P+9/Sk=;
	b=jmNwaz68AZaEag+5AvPZ/wR39v8evaJEVe3IaMBAmhYCEhqWkD/C4vL6KyBufQsnUrFNgu
	M2tA0kfOpUchXtAgo2iEt1Mgb+B1UBvslBuSxQ883l2yldkPJsOSwDRvFJ4BazS8fSHV/a
	puPXX2KiFPn5LnMRiUQ1iqSEDmuWSH8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgXeSFHj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960123; a=rsa-sha256;
	cv=none;
	b=H20YV1GWqjVTGcDRB2Xcut6t40Z3hUrP9EKGmmVwUQMUUxv3GOznRDU2qkv08AVIOgGBHv
	/Vgo1owpTPSX69IimOurxQGdkziU6Y7Y1Pq837qNBKbK35mhSr5sDuMUXqxdurgMgfjGod
	EOkgaKm5pAwQ17kH0REpFsQRpU18WWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73F3144639;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2ABE6C2BCFC;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960112;
	bh=CJIpST+fTA3ify7hs9r7AYosrPrb9QGPp8iEbbaSBmQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NgXeSFHjGkJ4ywD3D6/PQRiJhvX+/HpQxobQiO22ePSsHLCsflsi6VU2Z5A9Ds/5+
	 KjqfcKo9Xc4ZnIER400j3ONn3nnEgxE+Mn3vnD2eP4yYh6p6zDKZbc8YUdB8nFux/6
	 hsb1pIDVjKpdvMCY8zQprOkMeV0cXL4UaBoXScqC58enSr+Z/tzRcayDAeMOEmudE0
	 75T4YIuC7MNb3+I617L2Prl9dnyZcKerh9oqg+/5yImMBn49oHR+f5zK76bnR7O3IC
	 TsZxp8V3XTgGSsFy8BrdtG7allRxw29CL8fAIfwg9JxY4VwAfCr9Z1YZPVWgBfKT9L
	 pqjBbnHFuKh2A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2D2D339AE;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:42:01 -0800
Subject: [PATCH v25 23/28] arch/riscv: compile vdso with landing pad and
 shadow stack note
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-23-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=8747;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=v6EnEuEd+ELngWM6DKYQ5pCY+fiE7cAfshtTbwH+M04=;
 b=dUzOGwStlB5gvsG8OIIYa3aOQLJgH0IjnN2zZi9D9VPS+SDHa0NCkxXSli8ucjGCztWBcZOZq
 prBPDPtmKAtDNetTdzxi1TEM3a3hnJjCht3fOqCY5XsLQeGHm1A+LgS
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Stat-Signature: 44k3bqda81o8ue8nnpqh3igk9o5saqtb
X-Rspamd-Queue-Id: 9649140006
X-Rspamd-Server: rspam06
X-HE-Tag: 1764960123-852209
X-HE-Meta: U2FsdGVkX19rIsuW5q6+JCmMJdXwZHn9OtsoDmR3iR8ulOf+zL772y0mmVbwZz8HZ83PF+OYdhbHfV8cHmgVp6d/b+Gz5BUeiBFoBYESRosYs20UrfOLQ7pF4/iCS0NOfeAIMc2VqmLBxVsqkUJNYRhsiAMA/MvpE4qo0TT0Xi27Ca+GCDXxCJXVUhmYWbdmhHLCvD0bGNS6IpRGDYuxHnV/Y+R/lhsBQYyOKaHsjYH2c/xMaLnwh+/ITTCSjprxTqXHuqrjswPobbHPoUTA/5QMFafi86Mvj+70zFU+2x2+/iIuGMtbnfP5z+o0aqrIErOzyoi2h8s8GvqrcUwNEKBLFfPk/NqeGibD7IFXRdb/dZ+2/Q/F9FQKzvQqOYNQUja4UghwUK8MQGE/GJgoV/5BHnWKGxTsa+2TeALYUfKO2gNEEpGmF/k9+mCEwMLooAJd3/dLs7GHiSAYM9qKUsR+Pstzzqscj1X2CzPG3ckBX+02y0Es1nk2DE3XkOf6EzknerfpLCoVn9vcUYPVldmsYiAtEtuPFv5sJXUyIy820pL9g5i9+j7g0/qzfwlMzmxjimiy9u2UB9a6HevT28PXnmoyGlaiQ7AAJLtJYDbTrYnw6GD70HjmE4hiN9y6m3j76VhnkLthiypJB4SRti3ghEEZDlZu89Ub7YlFVhPICHb3SnqvnkNOScVlQZBLNQKothutx0GS9DiNTgVc2DjVpiqOPeSqAWGOQ0Dyrxylx54wIPJ4tVxnG9krFexlMh/gOQ76zhnE+MUttmtdjWkKJJvnHAy2xAuHJ2oMm/2O87d9R27vtn5yHFj/188LwOxuTwIOPj7QDUhfuCYHg8DtA3RridayyFyaBVMU0RblqsJjXP2XVgsqVvYGA5+6M9xOEdjPYaxmuJVt9gNQTZaI5moIr0VlMmpDH7Gaz0//OgF10+zGStbgqNX9zTU07zhXgFq8jIJAjZHUKrx
 PE55Vlc9
 294WuKXJdYD3ZsBab3K3XztLEHWraoiySs4gpAMbWMa+Z5pt639E7kzfk6tT1zfW3PUy/PA4nZYqQCxjxyk8H8Xoe7VpBWLS7fwurz9m0cGNJOokO/OnjC2WrQdgsmSccw6lg4jalDhMP1SsugbVSxklu1pk8DAGxna4FpqbASeyx82BCb8vNMkAOVajZ53orSZ6maz3bCB5QY07+fi591EItnyebXmQt2DWxkRsq5FFdk2OajQfyFiIdxDx5iRSFe2hjbKT5PVjAhUhMbKEmIxYJfQYlWyxrrNoctb+NjGKB0qsCOdPF2eGbgKxthCdOBxU0maB2RvjwBjvVF8JSOs8ZOM+9kI5uNngXQFGq7r/auR+CWIeMnMNV6nwIqST9Viz/CzZi/RUhwdMBPDIimwwsCVgn5g/SiwUBeqkAg0TZvIKwsSXp+e7sJ2iJexUIO8ViVH4xHW/3isZjcp7Zi7hEf7rcW3zyAyuy3WzZbfcSsM5yw/jrwuQmfVpj+e0CjXGIHnenZd9pAC0qkl3mSl53mGh0UgPLJFr2+rnoBzP2l7M0EVNnHacpdc3eU2ovo/AP6hjeU2WqjYtk0sPQp3+sjLg+G9OtpE24
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Shu <jim.shu@sifive.com>

user mode tasks compiled with zicfilp may call indirectly into vdso (like
hwprobe indirect calls). Add landing pad compile support in vdso. vdso
with landing pad in it will be nop for tasks which have not enabled
landing pad. Furthermore, adding support for C sources of vdso to be
compiled with shadow stack and landing pad enabled as well.

Landing pad and shadow stack instructions are emitted only when VDSO_CFI
cflags option is defined during compile.

Signed-off-by: Jim Shu <jim.shu@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Makefile                        |  5 +++-
 arch/riscv/include/asm/assembler.h         | 44 ++++++++++++++++++++++++++++++
 arch/riscv/kernel/vdso/Makefile            | 11 +++++++-
 arch/riscv/kernel/vdso/flush_icache.S      |  4 +++
 arch/riscv/kernel/vdso/getcpu.S            |  4 +++
 arch/riscv/kernel/vdso/note.S              |  3 ++
 arch/riscv/kernel/vdso/rt_sigreturn.S      |  4 +++
 arch/riscv/kernel/vdso/sys_hwprobe.S       |  4 +++
 arch/riscv/kernel/vdso/vgetrandom-chacha.S |  5 +++-
 9 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index ecf2fcce2d92..f60c2de0ca08 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -81,9 +81,12 @@ riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZACAS) := $(riscv-march-y)_zacas
 # Check if the toolchain supports Zabha
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZABHA) := $(riscv-march-y)_zabha
 
+KBUILD_BASE_ISA = -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
+export KBUILD_BASE_ISA
+
 # Remove F,D,V from isa string for all. Keep extensions between "fd" and "v" by
 # matching non-v and non-multi-letter extensions out with the filter ([^v_]*)
-KBUILD_CFLAGS += -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
+KBUILD_CFLAGS += $(KBUILD_BASE_ISA)
 
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
diff --git a/arch/riscv/include/asm/assembler.h b/arch/riscv/include/asm/assembler.h
index 16931712beab..f449c4392c29 100644
--- a/arch/riscv/include/asm/assembler.h
+++ b/arch/riscv/include/asm/assembler.h
@@ -80,3 +80,47 @@
 	.endm
 
 #endif	/* __ASM_ASSEMBLER_H */
+
+#if defined(VDSO_CFI) && (__riscv_xlen == 64)
+.macro vdso_lpad, label = 0
+lpad \label
+.endm
+#else
+.macro vdso_lpad, label = 0
+.endm
+#endif
+
+/*
+ * This macro emits a program property note section identifying
+ * architecture features which require special handling, mainly for
+ * use in assembly files included in the VDSO.
+ */
+#define NT_GNU_PROPERTY_TYPE_0  5
+#define GNU_PROPERTY_RISCV_FEATURE_1_AND 0xc0000000
+
+#define GNU_PROPERTY_RISCV_FEATURE_1_ZICFILP      (1U << 0)
+#define GNU_PROPERTY_RISCV_FEATURE_1_ZICFISS      (1U << 1)
+
+#if defined(VDSO_CFI) && (__riscv_xlen == 64)
+#define GNU_PROPERTY_RISCV_FEATURE_1_DEFAULT \
+	(GNU_PROPERTY_RISCV_FEATURE_1_ZICFILP | GNU_PROPERTY_RISCV_FEATURE_1_ZICFISS)
+#endif
+
+#ifdef GNU_PROPERTY_RISCV_FEATURE_1_DEFAULT
+.macro emit_riscv_feature_1_and, feat = GNU_PROPERTY_RISCV_FEATURE_1_DEFAULT
+	.pushsection .note.gnu.property, "a"
+	.p2align        3
+	.word           4
+	.word           16
+	.word           NT_GNU_PROPERTY_TYPE_0
+	.asciz          "GNU"
+	.word           GNU_PROPERTY_RISCV_FEATURE_1_AND
+	.word           4
+	.word           \feat
+	.word           0
+	.popsection
+.endm
+#else
+.macro emit_riscv_feature_1_and, feat = 0
+.endm
+#endif
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 9ebb5e590f93..272f1d837a80 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -17,6 +17,11 @@ ifdef CONFIG_VDSO_GETRANDOM
 vdso-syms += getrandom
 endif
 
+ifdef VDSO_CFI_BUILD
+CFI_MARCH = _zicfilp_zicfiss
+CFI_FULL = -fcf-protection=full
+endif
+
 # Files to link into the vdso
 obj-vdso = $(patsubst %, %.o, $(vdso-syms)) note.o
 
@@ -27,6 +32,10 @@ endif
 ccflags-y := -fno-stack-protector
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 ccflags-y += -fno-builtin
+ccflags-y += $(KBUILD_BASE_ISA)$(CFI_MARCH)
+ccflags-y += $(CFI_FULL)
+asflags-y += $(KBUILD_BASE_ISA)$(CFI_MARCH)
+asflags-y += $(CFI_FULL)
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -fPIC -include $(c-gettimeofday-y)
@@ -79,7 +88,7 @@ include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
 # The DSO images are built using a special linker script
 # Make sure only to export the intended __vdso_xxx symbol offsets.
 quiet_cmd_vdsold_and_check = VDSOLD  $@
-      cmd_vdsold_and_check = $(LD) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
+      cmd_vdsold_and_check = $(LD) $(CFI_FULL) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
                    $(OBJCOPY) $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp && \
                    $(cmd_vdso_check)
diff --git a/arch/riscv/kernel/vdso/flush_icache.S b/arch/riscv/kernel/vdso/flush_icache.S
index 8f884227e8bc..e4c56970905e 100644
--- a/arch/riscv/kernel/vdso/flush_icache.S
+++ b/arch/riscv/kernel/vdso/flush_icache.S
@@ -5,11 +5,13 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 	.text
 /* int __vdso_flush_icache(void *start, void *end, unsigned long flags); */
 SYM_FUNC_START(__vdso_flush_icache)
 	.cfi_startproc
+	vdso_lpad
 #ifdef CONFIG_SMP
 	li a7, __NR_riscv_flush_icache
 	ecall
@@ -20,3 +22,5 @@ SYM_FUNC_START(__vdso_flush_icache)
 	ret
 	.cfi_endproc
 SYM_FUNC_END(__vdso_flush_icache)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/getcpu.S b/arch/riscv/kernel/vdso/getcpu.S
index 9c1bd531907f..5c1ecc4e1465 100644
--- a/arch/riscv/kernel/vdso/getcpu.S
+++ b/arch/riscv/kernel/vdso/getcpu.S
@@ -5,14 +5,18 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 	.text
 /* int __vdso_getcpu(unsigned *cpu, unsigned *node, void *unused); */
 SYM_FUNC_START(__vdso_getcpu)
 	.cfi_startproc
+	vdso_lpad
 	/* For now, just do the syscall. */
 	li a7, __NR_getcpu
 	ecall
 	ret
 	.cfi_endproc
 SYM_FUNC_END(__vdso_getcpu)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/note.S b/arch/riscv/kernel/vdso/note.S
index 2a956c942211..3d92cc956b95 100644
--- a/arch/riscv/kernel/vdso/note.S
+++ b/arch/riscv/kernel/vdso/note.S
@@ -6,7 +6,10 @@
 
 #include <linux/elfnote.h>
 #include <linux/version.h>
+#include <asm/assembler.h>
 
 ELFNOTE_START(Linux, 0, "a")
 	.long LINUX_VERSION_CODE
 ELFNOTE_END
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/rt_sigreturn.S b/arch/riscv/kernel/vdso/rt_sigreturn.S
index 3dc022aa8931..e82987dc3739 100644
--- a/arch/riscv/kernel/vdso/rt_sigreturn.S
+++ b/arch/riscv/kernel/vdso/rt_sigreturn.S
@@ -5,12 +5,16 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 	.text
 SYM_FUNC_START(__vdso_rt_sigreturn)
 	.cfi_startproc
 	.cfi_signal_frame
+	vdso_lpad
 	li a7, __NR_rt_sigreturn
 	ecall
 	.cfi_endproc
 SYM_FUNC_END(__vdso_rt_sigreturn)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/sys_hwprobe.S b/arch/riscv/kernel/vdso/sys_hwprobe.S
index 77e57f830521..f1694451a60c 100644
--- a/arch/riscv/kernel/vdso/sys_hwprobe.S
+++ b/arch/riscv/kernel/vdso/sys_hwprobe.S
@@ -3,13 +3,17 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 .text
 SYM_FUNC_START(riscv_hwprobe)
 	.cfi_startproc
+	vdso_lpad
 	li a7, __NR_riscv_hwprobe
 	ecall
 	ret
 
 	.cfi_endproc
 SYM_FUNC_END(riscv_hwprobe)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/vgetrandom-chacha.S b/arch/riscv/kernel/vdso/vgetrandom-chacha.S
index 5f0dad8f2373..916ab30a88f7 100644
--- a/arch/riscv/kernel/vdso/vgetrandom-chacha.S
+++ b/arch/riscv/kernel/vdso/vgetrandom-chacha.S
@@ -7,6 +7,7 @@
 
 #include <asm/asm.h>
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 .text
 
@@ -74,7 +75,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 #define _20		20, 20, 20, 20
 #define _24		24, 24, 24, 24
 #define _25		25, 25, 25, 25
-
+	vdso_lpad
 	/*
 	 * The ABI requires s0-s9 saved.
 	 * This does not violate the stack-less requirement: no sensitive data
@@ -247,3 +248,5 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 
 	ret
 SYM_FUNC_END(__arch_chacha20_blocks_nostack)
+
+emit_riscv_feature_1_and

-- 
2.43.0



