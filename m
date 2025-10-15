Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADEFFCCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B453A8E007A; Wed, 15 Oct 2025 14:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD678E006F; Wed, 15 Oct 2025 14:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BEF18E007A; Wed, 15 Oct 2025 14:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 860C58E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49375160232
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:39 +0000 (UTC)
X-FDA: 84001149078.07.8D4BE7D
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 703F12000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=B48ThijZ;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8k5T56kkRu9YK1F4LXF8NdMzANSX1RtLRjBKJZN/CnI=;
	b=X/XNG31Ifjo0wGN6W2iuIhCDt/IkKaLW4dgfzZcF4yCQHIr2630/0XqwZ3W+sypIqpIW4T
	kqQVBKclfxQh+CxmRrsrbsUWGrBPJBszkkjoMzHknx5FZemuTSBUvkPNnxfLx6wHNtKhHk
	eTQWS9leJxx9ggBk6tIBmqELjO1BcLc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552077; a=rsa-sha256;
	cv=none;
	b=XmwZD4ygJxKQpwxR5vhV7KvfErMgTU7AorxlxoZViAQ++x+T2Ju6E4F4ewSs6Vu78R8cVG
	PwRB/hAC90wtqaVVfRlFT5KSDBJw3gz505bvcALeP+LUetcea2cc2HrFovqp9lasV130zn
	FU/ang/fHF/YjIm8tTkH1+bLKZF6b5M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=B48ThijZ;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2907ba47f71so23410825ad.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552076; x=1761156876; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8k5T56kkRu9YK1F4LXF8NdMzANSX1RtLRjBKJZN/CnI=;
        b=B48ThijZYYvhQRWQ5MxUqUM79OCMerOAYS/9JebeckQW0N2MN/b9w0sXjgU3mfbquv
         CObX9tc0KUQ0z3caMMublU8/IfHva3R59U7OUeytGWOgT4QJ9B7DRgvkrEazRt9CasWH
         UNOc04K13XZ2wDe3uo5HTNekE1rc4kElTLscF7pX0h51LqNobybq+nyOcGKEUaN/zw1m
         vKtZ9eupJt2n/Ne73ZTg1R6SUOsQRBEeO3ESZ69NIit5eo1/P5XhUSewxzMq7I6gBbwK
         QvzFjPpcxF+7UWYbXAUhLgejlZgZbcEKHIjGv1qqi3SAsY4AujRj8pKAEyYB/QljrzjS
         YDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552076; x=1761156876;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8k5T56kkRu9YK1F4LXF8NdMzANSX1RtLRjBKJZN/CnI=;
        b=DzMSpQ6AYDF8df7hTvCDEFXvFi1cBdgRI8/YkclraeBZCWJe4RXfM23RrjwLfE6ble
         b5MbL+BG9Gh3JvZWAOXab3u0DPV3rPzYHRWR20sfPwtoB/ts7C6zUrFFmXuOSdApHhZm
         l2ktUnOMD2oEbinaxF3N2IOJ7wUaX7h2e9jKkRH8ZyLK2/K5sWrsz0ubjt3AB2UK+cJd
         KpCZUaNOvy4JWlMG51WjidDraDkmuMXnaequiW0N5S1qc/t0F++LPyKIXf6CCrF8uxGI
         uxe2RioucwYynrJjfl/E2wC2b7myYR5OH9GVDsOqkekEv4vy6QYgRwjIMYqYb3X6z/zR
         X3qA==
X-Forwarded-Encrypted: i=1; AJvYcCUkDc8yhE9liIyPwtauTBa58Hq3Fe2hRaNJ8GvXge2gclCcOsxlEQTH8YyQ4lBOisPzjiuxGWnSiA==@kvack.org
X-Gm-Message-State: AOJu0YySuD6DLq+55L29dz2VlZLTPdmj2b8YBaedoQVXE0B6nzsOykWw
	o551xhPXc1A6hwZJ7cBCeWAQM+We3hTBJW0mqMdtfWLmTQ37O4kSxOfnML8SdrWZRutkz5hunFf
	bTaSP
X-Gm-Gg: ASbGncuDbhtIfYzqzjn35vS9w8NvW9cXlihI4TJvUWAHlYeW2cv1GpMdNPEalZcSM5P
	pOsbMYrl8PkLTRzaRKA8RkvyISSBZLs+0tesW30WE2eUjmW39FYzxko7GLgZZGHplgst9ELpBgc
	7w4BsB5O0SMuU3Ax27wc9rvqSklPfYomRkRQHGdN2zhpQk0IQ+cTvKc4VbbPPv7DFJQbpFMulUH
	fW6Jvgzr8PFxFFb3RmjSLGOvF0yJLNtr8xRT7e+5f8jGTJ9zG7R9d1HEerI2MSCVVcoFId13Smw
	ntiGeD1abgcMU4iZdnhXte5OPFTXdNerkRrY0k2rWdXOzLVpuKGt3WD8HRxNNF23rkakcrvXTNT
	4ChiL6/zwHPAdZ+tls8JUUt1hHTQyF9u92UsRlo0RKEXl2WmSvbIpMxGhGY4ocQ==
X-Google-Smtp-Source: AGHT+IEMYWgyiO5TT0/tJVudv2DFsiqBVIB1MUCGJw3sOwvyqmGvobR9AvfudE2otxV8d5OBGXHBKg==
X-Received: by 2002:a17:903:1b4b:b0:267:da75:e0f with SMTP id d9443c01a7336-2902721334bmr363627735ad.11.1760552075900;
        Wed, 15 Oct 2025 11:14:35 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:35 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:55 -0700
Subject: [PATCH v21 23/28] arch/riscv: compile vdso with landing pad and
 shadow stack note
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-23-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Server: rspam01
X-Stat-Signature: 7t8pr4i4s4tkcc6d9a4akszyfz7qihmq
X-Rspam-User: 
X-Rspamd-Queue-Id: 703F12000C
X-HE-Tag: 1760552077-979643
X-HE-Meta: U2FsdGVkX1/HyEprPLtEkT8pp4C5eNMoo3B9ceSsWiQs45CtLX04lFQj5XIptZ2LimkaHT4soUh5ugNnQZM+x/m3rivHrRA6nbBgV9+pjNYHJePidGp2LcLnYSct0uNdV2/MF0kikdGxp30B1fjL49ZK6QBVKXLdo7WJLIdaU7IzbJosRJVTnuPlENsgJW95/o7qOB0uoHjRwqBWGte4cW5jjk++EE8KuttwfNilzYxYp1MW2sM4tzch9zS3A7gZ0T/Q7YBoQ1PZHR/uvZXn2Ye2lUPUbvq6VKrANg2oi6bv2arfh63RetrFI3a25IMbmFYmRmm/gHuMtYGppwwBC7hGXB9MQSONxY3uh0K6ao7xnfGbcX6J+7Wqfz2jq+tasqqyZBabf8IOOtxMGvYpWqje6jA49bky8Fpym85OW8aPn+dNGsdiVmZyFjzX3ldbD/sWVk0x7aJJSEOPQGkYXDr1ZZAbxIzmccrKV7MxkW3XLbvcRON4PLCixrgFp8zLyB4j56TzHee8cmZ9Hy3qGQ+h+Wilw4z2iXz3ZXuL1LJMKwREvLHCwgv1P6eofQG+FoBPVvHXxjOA8zHKRnx59QCOiTT2wvgRxohJjtzodEVH2s7X+OZiPHPFu/heffpOmQxOY4TO3PTaM4LKHNUSMhrCeaik9yekdmQR3Fg6bI8G2R6TvmKfAYHNS0thG5rgv5DI2WfipP4AlCBvR8nzZljlLzMoqLaYYjEzArLijEljzLnYyY1HMbmFxkVPltTjia84LZMvFxw8z6OUd7hTJrswLA4xQG3PikMBcsPly+tXSjB+kA6dc2KcyLMT3zbCXQQJc7TSpzHSQERFzx2uiQ6dkhvgwsYUOmOW1NSZGPf200aBduGhKqguXB8zBpkczLC57LJcOvMJKruqYjsOboB3V+kDbdHfExYn8DDloYid3Suhx8uH6mDDQGPcvFTPYfNLgbJki30sqsddJTS
 6oI4+DGk
 iUeHYjkkFj/Kuc3mDY0tQzJdpFcQrUxv6Azc/zqxn8LXSk419koOJeZSbFyG0U7RSCygS
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


