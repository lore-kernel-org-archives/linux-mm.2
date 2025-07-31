Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F38AC87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF016B00BD; Thu, 31 Jul 2025 19:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76EE56B00BE; Thu, 31 Jul 2025 19:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636886B00BF; Thu, 31 Jul 2025 19:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE6F6B00BD
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E2638104A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:32 +0000 (UTC)
X-FDA: 83726131104.23.2AF1CC7
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34D28A0003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=T+drPMaY;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpLyoJ1ezhvR/CSc9LCArL2cYjkaZ3pfjGPey00rFYA=;
	b=bTXoFiG36Gbfl3k9EnsN6U0FNWMF3JcpRLai9yA60s+Se/xrCuKnmxG4MK2wMNU0MvZ+6f
	3lpR3TzSXNO83VG9jZXL0kJzVjO5EaQZ7XWg6/1g1gr3QPuyBDSuKlaiZs/waYJexcPs2h
	rvYOIsGbfpfuayZi99fkU5URFZrV8CI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=T+drPMaY;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004030; a=rsa-sha256;
	cv=none;
	b=AJTRqyI3BZeIO7Gn/mjO5FY0HGzVrmTyFMXvn/CprhSHdVIJ/Z1GIcSrqhhfjg/hITKybN
	HGsfBMfe8qypKJiRt7kEo3JRXWmC6gV+5z+g2Y8HUqT01J2KVMl7kQMkEV83l84evGJEeT
	3byPOrVpKtZ6bmPch6YJxEn1VJ9GUsM=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-31f3b54da19so1084047a91.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004029; x=1754608829; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wpLyoJ1ezhvR/CSc9LCArL2cYjkaZ3pfjGPey00rFYA=;
        b=T+drPMaYD/LwieKR+/jCmJik7rtzFk8j1N4lXnaXNK1webpjhphOAXwqTAC8ODPAhe
         bjFJ+IwcMSJMyrcldjBAa+/BvJ5syX9P7HfV2HVenl5WizZ4hwF8WcanxsJ4BPHOZpcJ
         yrtWq+Mr7YkH1EzYBx0QBac9j8ORnaTyqkm0GoeFvd3cBB73TL8sLoFD7Tp7HnHsHYm3
         5U9hdk0uqzYpbiafg096N1kTajaWJy3UJda5DK8sZQzQGQ2N9/tMvwGeY5iLc9KsbRYy
         20fYOQ54pn5G6t6hdR79EnhgqvPlb8cXWku6aWP7QQhcMitVqc829hWnJp0/EQl77yD/
         yg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004029; x=1754608829;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wpLyoJ1ezhvR/CSc9LCArL2cYjkaZ3pfjGPey00rFYA=;
        b=qjFQdrjl0NlU7kK9Tc4+J9v/GaZAwpi2DUMJxVrrEyoPl2S0e0WTkUTcojGof6mx3y
         2xq5I/EQV/eEwvM9y3o/cVFd3zFPMSwbOBWLdCA2+MT4dV44Z71eOIxba1CjX9rD6+e/
         tiMvGvYji5ysk9Ev493XZ+7J6lMz0A9eWUYsnXVlVegTCXounyXGFZCMm0YVrXefomhV
         DPO+YD1+MpRHvHo9mrblwyGBMQIeCOdOn7Rzej3HrNYQ+3sOWGtVAfEAF276tqw+KDP/
         C8s06tmy4XPfaFccWII/sE8Wo6EaLbo65S7AmCcpc22PTs07hnGt+4zyhv4u3j4c0LWP
         rYKQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+8FQnBlpqopxTsyQS8bbttlkHJDQmVWUZeDlFGUadUYT8oFGaUfm+XblkmYpiMDSwlQAHY3LyWA==@kvack.org
X-Gm-Message-State: AOJu0Ywz0p3hw1mfZDkfiY/8wtMuAex+Xm/79RePKOOXIbd3EeiGdLpB
	Z90O0tdu7P4ZgreIhnwZaNydzCNUq52ZSiLkJ3Qcsp1sqkt9OPtttbVIKBpsKoxIo0c=
X-Gm-Gg: ASbGncslrvUwccFVB4u6vHi/q+bMVSAm+NRNrUsQKr8RIX99akVF8VBt+N01hiZ+ymf
	eA7BzYSoA7ko4yKhJEKByhgrDAAsgMdRv55enph4u/8GAfMyMLm1G+NTyXhdOs75+MfN/1GmeGg
	qtzyxoXWy2AJZpOCAxt2tYFPTLbzdcaMrJGkkAuch+ZczCkcVGYxHPKbQbzbSk6i1m6RkwF311f
	KqWCZzM3cyIlcp4WIuxvQBu1rU3wQP1FscxbwXYIos50+negVIYgAzS0DCqA/HXCLmuIVLgrOoe
	famg2rAsWXx+dCcnuJPFrzTqnAeowL8qPo0VoKPzRFme5LXKeCgMHomqqxii8Q6EEsbC9gKYWXI
	2oghxPEhDmCR8YPcT+n0UcxX9tGIjL89RmOZQ0htYNM8=
X-Google-Smtp-Source: AGHT+IEQ3LOjfLNzN10VZXNqdHqHjL6AQlIw2qP6z9EYc6XnZGg8Ord/xxC2r8z083oDxgzsJRWF4Q==
X-Received: by 2002:a17:90b:4c49:b0:31f:4aab:3b25 with SMTP id 98e67ed59e1d1-31f5dd88fd8mr10331872a91.1.1754004028899;
        Thu, 31 Jul 2025 16:20:28 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:28 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:33 -0700
Subject: [PATCH v19 23/27] arch/riscv: compile vdso with landing pad and
 shadow stack note
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-23-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Stat-Signature: di91zafozhcbju8k441mytbwhbinrxf1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 34D28A0003
X-Rspam-User: 
X-HE-Tag: 1754004030-341165
X-HE-Meta: U2FsdGVkX182RJOPUQOeNo3srOo5wm4WxMrysFL0Avre4HbOrb8E/STaL6YV1aiPjEAU3Z4F9V3PIWRPldf6cweS1/ctDEyYFdItt7U4olj6Bs7/vZIKH1/Zem6x3RuPrl4DXCZqNyFCcWdC017i34eZb+5k7mJOkl9372SZ+Y4BIJ1jHbk3NQAVmCItMaamCnykJZvVhYyeeGkXZgv32BNhWZmcD2/fjBlI+EXH4N9Qe9osGGDKaiUr6EXpCXa4UtdEiyyUd7g34ibCn/ziWnOsRcnybmw/tp5m2T3UXe1j3R9yhIy2FqTUPvCzbXXPppMlG1EMrh8aFX3gltIb3R/wZzZ2De5DFtQTWNTtk+V81Uz96WMtH1CJUzopW0JqiljqQ/XvgTp/SeORKVpPNSb4Igg6XrkgnddyZIyw1Febr5nRKTUa8v4n42SXx7qkn9a6BL1yYq0nR2449b5KN3q7oB0MyOfOug4QnR0gR5j2dTUBiWxCx3jXKHOalMH+mhaXJeloRbrR8YtqTWMqEy+TcX8z1cTX0h49FXir1DxeF5s1kestPfTcCdnfJmmTGvIZdCXsW5WsgS6AWOCWdlGopem8aM65XDavG36GTotbWjNfkyVON/Uc7NlkqDdeQ4ALbx1AEUH+zdNdlt2VlKZCdrwChcuoZftMk0gj4KwK14CH4eofc/6WXzfivwpowmMp4aPl3lHzRa+swHWnTMbx7ZPUYJ89txIkvdIjO3/o1bswQnTRc3ZfTHgowizGc8hRkjelRP94tzWi44XR6S7d0DsL/BMFiUm66RhzMi0FXhIxysUaa9/pFVqxknpuj23yjVuWMZ3ElId6UKFrGMb9h4ggvAS43OiEDNun0WkGLXZGEXPAcvvfgDFkcnEKoNgPIbVtagN1Qb7s48wH3H3qj2wksfL9cRKoloihlayCvKJyJoZ1xXS/5wzfOUAcbfDeLCja4ZrEHAx+5AE
 1lhoEOmD
 2+tEpRw8Geyp3fdWUk9YtZ4G/b8OQvifpodA2Jf6A4C7goKavSzty/SMQ1cinLLa6068C6cdT9FMzujFHoiEWO1va0etXbSgdLmGfiugPVhTvWiY5D9VZjXYVcuL8ig1+qfoYTm+8dbIykr9lNzXBuDKzJEPTWeV/iqvwbV8u5tE8cWPxRu8STFRfj96L8E0d+wB2Kq/0QZkYOJjRQ+NBqAoGJAZio7qFpVO0xKPFAMEQO2OJHy3Mh0VihTEUwG32VP5lqzWWkSWfppsKYxq2Mq0am1afJSkFIuVrgHpcq3rl0rt1PFvSiJsahl/wnLAAOjMSaRuWPC/gJlLZudKE0GtlHwm85gFIdMuAUrPEUkWjfx3qMEOlRWPFS0lxt/AZ4qIM+J/6VMj/Gowldw0jmjqes5fHGEyWloJT+ej44f2MTtzKeX3ohTS1cVLoVXBCmwiURy4vFGwFSziYsgqrmtgtPTEABptjX3lcTekRn2CV+WsGOZKukp2hLPH748A0l6gDJA9bh1YNO30AOt0GInEr0/LtpKoaD5PasC67BRgxafotfJyuaSEILw==
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
landing pad.
This patch allows to run user mode tasks with cfi eanbled and do no harm.

Future work can be done on this to do below
 - labeled landing pad on vdso functions (whenever labeling support shows
   up in gnu-toolchain)
 - emit shadow stack instructions only in vdso compiled objects as part of
   kernel compile.

Signed-off-by: Jim Shu <jim.shu@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Makefile                        |  5 +++-
 arch/riscv/include/asm/assembler.h         | 44 ++++++++++++++++++++++++++++++
 arch/riscv/kernel/vdso/Makefile            | 11 +++++++-
 arch/riscv/kernel/vdso/flush_icache.S      |  4 +++
 arch/riscv/kernel/vdso/getcpu.S            |  4 +++
 arch/riscv/kernel/vdso/rt_sigreturn.S      |  4 +++
 arch/riscv/kernel/vdso/sys_hwprobe.S       |  4 +++
 arch/riscv/kernel/vdso/vgetrandom-chacha.S |  5 +++-
 8 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index df57654a615e..7128df832b28 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -88,9 +88,12 @@ riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZACAS) := $(riscv-march-y)_zacas
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
index 44b1457d3e95..49f31ec7d29f 100644
--- a/arch/riscv/include/asm/assembler.h
+++ b/arch/riscv/include/asm/assembler.h
@@ -80,3 +80,47 @@
 	.endm
 
 #endif	/* __ASM_ASSEMBLER_H */
+
+#if defined(CONFIG_RISCV_USER_CFI) && (__riscv_xlen == 64)
+.macro vdso_lpad
+lpad 0
+.endm
+#else
+.macro vdso_lpad
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
+#if defined(CONFIG_RISCV_USER_CFI) && (__riscv_xlen == 64)
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
index 9ebb5e590f93..2b528d82fa7d 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -17,6 +17,11 @@ ifdef CONFIG_VDSO_GETRANDOM
 vdso-syms += getrandom
 endif
 
+ifdef CONFIG_RISCV_USER_CFI
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


