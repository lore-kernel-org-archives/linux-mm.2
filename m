Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB4CCCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32A38E00A9; Mon, 13 Oct 2025 17:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE56D8E00A2; Mon, 13 Oct 2025 17:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61F48E00A9; Mon, 13 Oct 2025 17:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF6918E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73778471AE
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:55 +0000 (UTC)
X-FDA: 83994451590.05.A36BF5D
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 883F3A0005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=eefLpQ3J;
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Aut4LXJuVcEsRFytitP3cDaWMqSMXRf04hYtEkTfh4=;
	b=pd8hg6Q0R/Ny1feuu5RNpukXij99YccQUhMf6jtnvEYGgpmD9iTxmsDOkhOQXnUtcJRG9k
	fIEfA28mCzY2VGv7bp+pOtTi4oh78bmDfO13ylVdNgbbPvnqwJf1Wt7HHz7hIRMrbqGFV9
	U3840T17cKD05979biSgv1S6qB/+4iw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392613; a=rsa-sha256;
	cv=none;
	b=EjCmpUTlKBusMKhBv97IFvICnJSDywwuGzGoQMgEi8wGhCrbzAGk3b/2dp35Q6b3wikHyH
	J0nHpLoeXXF0OArOLB5AU24ym3ZdOm6Kod+3vBOUJSnxo0gdRFV/8Z/QcyAvMaYont9J1j
	HZ/l3hmkwjcYJ2wbiz6RBPQ5sm/dDSQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=eefLpQ3J;
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-339e71ccf48so6605196a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392612; x=1760997412; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Aut4LXJuVcEsRFytitP3cDaWMqSMXRf04hYtEkTfh4=;
        b=eefLpQ3J3Bv8nKl2wUapsam679tu5phZIeEWtMJB5m3X4PHPEWt4UPJtUWRPxCcz+V
         FEjSB/DirmW37Z6TxSpbj3rMtexeU3HCmBq9c1o47kD3IToS7LyHVZvhAuqcM8IXfLQU
         ZmimfkAJ7JlzJUWI8LLvblQakAOmT9HMAbm/9s72Ql2L+PCJI1R/D3r8aEvQJyO25KOL
         eCEptBAfNVgg5jdUaB7yFRaQDiy7C3ak0k6Ox54tivM0fXxdxSCslZoO+uRG9Ne5PilE
         M6hggWX+tfWjM1atkA/1CZUfq+lHka8NMIkb3qDOwd0rz1xm30Z4fmA/xeR3nCjqiC8j
         6SwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392612; x=1760997412;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Aut4LXJuVcEsRFytitP3cDaWMqSMXRf04hYtEkTfh4=;
        b=oFfkjTFE6Ijxzq2GaZnRYc8/w8zc8DmFZvswqybSJhFCQ9rsSV7NJRaj6CW6rdQDSH
         Szlm5aBSzkY5piE0s/7ops4X5UJVN419mg2ulTh+LX9q/jiYmqoXG3KZP2oNdErNh3nr
         3DTjrO6EZtHvm9LWHO8c4RKtquDPgyGaPMeU7pthEZtZJFeRQYP3xpIGV0gZ1ELEZJpu
         uyCTTZIt4F1EO/6LYIlWkOSIaoal+wgXsyXKRaRKCMCSNkVDlXOKo8XVoQPtGl3xO24k
         i6ldomx8w0rZAX1dHwHt6cFU3ZfPsl0bNi773cbWjZPNWH3daNitHDs7OSVjSUAd8Gmy
         QQrA==
X-Forwarded-Encrypted: i=1; AJvYcCVVEB97+3LVFJePWhNAHwsmVqc7JJb+Dn8BUYFiW1H9zrKudJqGz6FC1bB4LUi1LbuSVjmG/1kyCA==@kvack.org
X-Gm-Message-State: AOJu0YygQufuSAgGpsXkfJPqd88K3NA1lZ4/v7hCDALPYVcM2Wq6BrZq
	tWBq1X+cgDOQ/Uwpw/mRhNm7OySbckwvPkgl6+HWgJlVE/lgz1y7S2wMo5Y1I58P4Xs=
X-Gm-Gg: ASbGncv4Ik89vq4ut5RPMhZz7Q80y+86o9jxHM/8l6B+WPzfzmNxLYv8Gk0fU2pi7b0
	uVOWtPlXZi6SWqUOH4qt3Nv7v7SRA4hDRxkYp7CdJH2DFKymoKTD/oUSAfT5tehH7nHfa4zPIIZ
	DuxEF4Efcg2HvGFvHSLVyt/hyoP4SEmi2LZssyz0KSDGZcHYGR6k6yIzyMuULN1ZDT5hoFar9LW
	3pIM4jb+wRSpJxDmFbktnsOI2cqJApIEtAtjM0h2IUz74ftu71mdisEDct8PHD8DP3JsYNndYHa
	gskgcXHiCj1OUcaA/MkVOiuSRGsodk2fplY0OXsza1qMXvkquCATGLagsDQXpgC4Uv2WdEGvH/Z
	u7XqzhNQTa8rGVMr+OIstPOcPCNNcA5vT5VoV1av8dbfBthGazUk=
X-Google-Smtp-Source: AGHT+IHuzccMMrC6EVu8/EqtQdWnK8i4SqsIw+5vY+GOmDfbFPMT1SxK/JFxXk2QbL9stmzl/iLm6A==
X-Received: by 2002:a17:90b:3889:b0:32e:d600:4fe9 with SMTP id 98e67ed59e1d1-33b510f8ef4mr31439570a91.4.1760392612262;
        Mon, 13 Oct 2025 14:56:52 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:51 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:16 -0700
Subject: [PATCH v20 24/28] arch/riscv: dual vdso creation logic and select
 vdso based on hw
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-24-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Stat-Signature: 85dtkpuujfkb7xd8rpcbsq5qtnpxqsd6
X-Rspam-User: 
X-Rspamd-Queue-Id: 883F3A0005
X-HE-Tag: 1760392613-496246
X-HE-Meta: U2FsdGVkX19NvS3j6Ri7rkj4T3p/bueMetUrroF/xyqZw54sa8phjMjJYsLMwv/T/XWTbdGXhAVpZ3saNb4gEPo+BB2vdFRWgnX5HXAyVoJVaZ9A2eKqecyoGJYoPR4Qo3svvby7IG2XBFWTPk6mdlnOfPZekzGH2N/BwtYo3OvRIZYfQw3e24TL5guitzdCRYmzETNUm+lzq4AsKCoBV5RXgyihzP/QldF19Jo3A8eR2QBb89Jees+umSecsmVOJ3WnN3mRWpUaDe12ntZnd2M3tkUhuwAtyyQHveyd6UzCQf8jNGhpyunc0dIutNBBturlu3hk7KCndkkFRnZUUXAYXHCPnwntRq6R+xYu8izWE2pxrzV2MeRd2Sh7FpjGZdRI66GrKHsq2kpnVl8dN4x6ujrveHqcqN17Lyu+LHJqWoPmqs9IaTn2lNjJwXcTAYU2bQUe8kdnluAWl2JmkDWnqgHNZHsc4/F2cnmk16M7J7bGdx4aT+hcWPMF3GCV5+7qm6TwlEV5AW2ORfnGQ2iIAQK7JDuCnCXv/ZcMWKxMXnc3y2NA7bFNPbanJdv3J9G91P6JMgbrPBRCCOhq3LKoLKiO05/HDpb7ZbvwdVMGNH31DhQuA7V6GiJrWks126xJn2BbS+JXuL1cuoQwfp81viYXxVieteWXMBdFlI+h9jdAZ9iPN8WUf5KZpQvX4lbXg4nCqFKpMdTcxgcHBSGB4bDdcmavuAvSosJq+rqACgzfldSH/IzUurCFjNEDX6UTgPIPt4HS+EuNsXuldKyHpk/HuEKnenT40TyRyFoma9ZLi/L7JYHaOgr7pCXmJ35u2xn8f4JwoX9UfR3fBGSXWakTN11TwQVNW6zHg68AYrfLLejsmRyhEzmw6rQHKMxhcCF9FB/ma5Lq75OdcxYkCzg562zhILrOalPH6SHKKWpMAFBGnDFdswuLw6MDIbE0lcXk3TX1GATGaJg
 Ybk3w6zm
 iZ3WchYle4TTsoAhLWWhQF8Zanteq0aOvqmyPuxTahrnNimVPMO3VIa8UzTUPfBRRZJVyBqe6VJAaqVQkHB8eeTJrpZQrFcz+OzA1F+kAR1Pl2MQCaxVr+Mf5stc24S1k5gLliePxUdHMKLeM0a+GgYT8f4WlGRo/l7yCRoBczXw/SUkNI6Qq+Q0NFNsd21j7RanV52bAC8Iz5MCTBn83TZZMDiU5DVuUTi8aGCMQI4crDikFTriCODLBa6MfExb1USyYoZ1On3JoboX28TX+RvtEsbcVOQtO99RqvG9i3mVWao4t+j+CNUv/uxn5Fqy36RxHLs/G5C8fn719Nl6h15EpwwhU+2Fyy2orpS7BksEfhu44wQDsYAKlhWcHo90XQY6JBCzbjGsn8gghHJSTb4YeqnkC9IfEvdTEuremVSWh47M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shadow stack instructions are taken from zimop (mandated on RVA23).
Any hardware prior to RVA23 profile will fault on shado stack instruction.
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

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Makefile                        |  3 +++
 arch/riscv/include/asm/vdso.h              |  7 ++++++-
 arch/riscv/kernel/Makefile                 |  1 +
 arch/riscv/kernel/vdso.c                   |  7 +++++++
 arch/riscv/kernel/vdso/Makefile            | 29 ++++++++++++++++++++---------
 arch/riscv/kernel/vdso/gen_vdso_offsets.sh |  4 +++-
 arch/riscv/kernel/vdso_cfi/Makefile        | 25 +++++++++++++++++++++++++
 arch/riscv/kernel/vdso_cfi/vdso-cfi.S      | 11 +++++++++++
 8 files changed, 76 insertions(+), 11 deletions(-)

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
index f80357fe24d1..3fc8f72b8bfb 100644
--- a/arch/riscv/include/asm/vdso.h
+++ b/arch/riscv/include/asm/vdso.h
@@ -18,9 +18,13 @@
 
 #ifndef __ASSEMBLER__
 #include <generated/vdso-offsets.h>
+#include <generated/vdso-cfi-offsets.h>
 
 #define VDSO_SYMBOL(base, name)							\
-	(void __user *)((unsigned long)(base) + __vdso_##name##_offset)
+	((IS_ENABLED(CONFIG_RISCV_USER_CFI) &&					\
+	  riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) ?			\
+	  (void __user *)((unsigned long)(base) + __vdso_##name##_cfi_offset) :	\
+	  (void __user *)((unsigned long)(base) + __vdso_##name##_offset))
 
 #ifdef CONFIG_COMPAT
 #include <generated/compat_vdso-offsets.h>
@@ -33,6 +37,7 @@ extern char compat_vdso_start[], compat_vdso_end[];
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
index 3a8e038b10a2..bf080e519101 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -98,6 +98,13 @@ static struct __vdso_info compat_vdso_info __ro_after_init = {
 
 static int __init vdso_init(void)
 {
+	/* Hart implements zimop, expose cfi compiled vdso */
+	if (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) {
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


