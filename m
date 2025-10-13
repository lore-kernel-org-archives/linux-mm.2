Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D34A5CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6DE48E009E; Mon, 13 Oct 2025 17:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20658E00A1; Mon, 13 Oct 2025 17:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CD78E009E; Mon, 13 Oct 2025 17:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4D58E009E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62CB01A05F0
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:40 +0000 (UTC)
X-FDA: 83994450960.12.109F977
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1A11610000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="S3uX4K/o";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+hioWfUWF0s+MiuUM+GlCDJCZ5YXjJVkBV4mURgf5Q=;
	b=H+S/VZ2L6to/vD2jyDVXoIo42+u1OCemxOYyhJzdDopE4YXx9oW+te74tk1aXCzZ4C0IIA
	Q/95p6ybgaw9iIUMCGIQM5clUlrlxtvU2+f885Lf8juZCwGbNelxOlGQ6oktN9nsU5S3tj
	LHfq9iVg25V4U2o9Q1ZA0K8OkomNjh4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="S3uX4K/o";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392598; a=rsa-sha256;
	cv=none;
	b=p8HLRsJLCyLSuA5wULmvVBPMI7WeT9v703Vrd8JRMUk9HgcsLSSRbldJcwB8hrQwHnj8Ax
	W8yMLbWKglyKeQ8rG+eS4jiq7cCxxsO8vQTpWV2NxBo+6ZF2Fu0R2jtiQRHH2+nD8Bk6Oa
	baD3PnF4QY5T2GQP7HKuX3B/A0/bmtk=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-339d53f4960so4857639a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392597; x=1760997397; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l+hioWfUWF0s+MiuUM+GlCDJCZ5YXjJVkBV4mURgf5Q=;
        b=S3uX4K/oATZzLhiJRlsZfOQ3YaicKe/RQcxilqJikl5pa45nyYdhjmpzFc0bUXb4Wh
         zAlagsXk+v0rhRG6LMf7c5iLt88D9Ycaz7Z2eWXLnv2X2QLwIij9+O7VpePBXu46SZGF
         yCQ7ylcSasol6VWqm11N375mKLVlI0An3INH65xa2hz0R3IMJidjSX8vhzDwovhXZLyC
         if6GlseY9bdfwVDB5t49rcVNyTQ0OThaZwCbnOAVevvf6dA1EpQjIm4eH6IkIfjNRK7D
         hN7BukjZWqRd/3sreeY0xL+zxXWCFal1GaYwLpJuxehnx5FBDRwT/g+IJplUsVmqxE86
         LYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392597; x=1760997397;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l+hioWfUWF0s+MiuUM+GlCDJCZ5YXjJVkBV4mURgf5Q=;
        b=VdI4ky66yms7rY4qIPPRm5vMgh0t75QEPpDNEZMR5LaRoi7RUGiwAGfJWCHx0whDqr
         UMfnXjn0Ppnrt6MfF9YuBok/CYIG95wpq7f7HRF1SxdthNb4uMd3ITGYScmRbqrGONdt
         wu08GiCoMOq9nbxqnJ6Y3AFftE0aYl6X7nJpbTUMQrLNPvxGLoDBMj8+Nxvj7aLwZmHH
         mk1fCVpanfd6erGezfaKC6VfNhkLPDvD6c/tLaPr+KFBMnov1/dD2jCh07EQPsEzFW06
         YOwQnXvOi1FH9ztoJ9JoAIrog8PpXdxoH6UTXRScCJOcLWc8yhb9ME9alIGrPsqW1rPn
         0ynA==
X-Forwarded-Encrypted: i=1; AJvYcCU4l+2hVDXbwQzY7Uy0FOuNtGdjLL1h89eV0ysZRDCIf8yO7E4HLKJ1YWNybLuGOPyo+5W3VBxMxw==@kvack.org
X-Gm-Message-State: AOJu0YxjaSyzqHbsFn8nbljl5B4Eb9eHiJwUV1T5JSzYGvjzrpqd2C7G
	5YheTbUpgePEZmUSCRT3Dwq/w6WQ6r3YPk6Vsp72CS05IHEhljEj+zIV0dhceMur32Q=
X-Gm-Gg: ASbGncv5wZwoX3c0UWiHrGkMZ/r2F7GSeTt6bXyE8yOrB0NUip4d0k62eG1U/B4n9Ou
	TLCBu1x7asfqr7Qra7WKDVw9Uu5HqKa+QTy0rUGVgKz/bSiLFbcNKd5n8Bf4UO1HzfZPKpQYZ7q
	JCInV1zJO18nLdroQT4iwlaxSD+pUBA7nmOMg/qX9W91PPHIajTi7vH6q9TMsz8td0QpDbEf3rF
	ciBj1HGPkTiU6h80sgTbBXn4Fv5vk2GFobK0lu0NLcBF4ZbNE7MVhkrHfX/OUTsNIjigpOBTras
	ow9231qI+R92tbY6FK+GW6UKmyDfNkCfLhbe5QVdhk2bVCADVn8AeNw1oGTCGsVV2wsQCO7vhUq
	mTGd5rkyaRrUNrUfdGMZ8RwfCzDG35jcmtoCYjtH+tdy1hwwV/oo=
X-Google-Smtp-Source: AGHT+IEPnKgRa6svNPQgCg+wz58pf0oHGIGSvZEG6ncGw/5nT9osK7zpkmp5DGwFi5m8wyRMIxv0uA==
X-Received: by 2002:a17:90b:33c9:b0:32e:e18a:3691 with SMTP id 98e67ed59e1d1-33b513ebbc0mr31955673a91.35.1760392596863;
        Mon, 13 Oct 2025 14:56:36 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:36 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:09 -0700
Subject: [PATCH v20 17/28] riscv/signal: save and restore of shadow stack
 for signal
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-17-b9de4be9912e@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>, Andy Chiu <andybnac@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A11610000A
X-Rspamd-Server: rspam03
X-Stat-Signature: hkytnnddjmkrefac47ob6mxyxz4ujxim
X-HE-Tag: 1760392597-388417
X-HE-Meta: U2FsdGVkX19GaleXkVAIjeSW9eRlMm20+fLjuZ/OxOVVh9uRrFJ//bCp/rleEFWlz2OLoqoHfxc3ZCwylu4BooypgVwImDcua3e8SBSbR2jyGeKX3dSyULjetyg4SL3y/RME0zPvvfF7QFtUhWZlMj5n2qH/7JXcyKBU6Akc01dXDlieLGgU/rs63uayDAvcm+zPCr0z+fxXuXN/FY+554GITq1e+F4aPXN6hr+1v3/mnfL4Jd8sL7QPUWjK3LMj6dPnjetjgerlEi4/NTcsXVLN7eti443WFa/TcmWcPSlc1vCQxwbRYY8iustA6a+4gey1DsE79+zX4IFbp/nSqL305Sh+cAfeHfhWuwYaN9LHDnKVA7FoE1aCwUWFWPjrLYTXwJhysjF38uA5AohmtpcoIRFNX9dD0DG40xI5tiHoIB0Qsi8+E5ztBURQ+7OzPgf9KkuCDHI7n09oQlrlz94e6uDPB5EnvjwKQrTFqeVYGnV8s8L6/CIO1S5WJW3OLsGN4iSdwH14gSjrTxJ5YHHmkQxwIQjlASVwhgsN/A6r78Fz9PXb6l7qmdLeYNba2oOP2UXpIkypt6C8dcQkkjIlloa+6nNZoNSCbvLOODMC/MtQCD3ffjJbYZ/ZSIxpC3k6uaAY2RK1IetHDPRR598oUjLlkyltS2dlUsDDEg+fqaAYGNdQXQaABHWtpMmIa4JNgrErYjQnX7olaycks7tU2edSVdPHGsefGVUif5n4t6MjlkOg2RzIPXxgrCIHnmg4c3LBESf0fYYOMV6NMi/+Sj3b9FY052534MSdFGjVKL25ai9AdjpA4VsYFeClJWyoLS4qTCvoVl5VUPBi9xyi8IhgkvM+S0w8X0B3z+eDtjcccFSBBQLNd9230hvoTToyrhiu3Jt3+oCADRVVxICaE8VmpjtjB02gtzqyWoepfFfSqtCZCA7dbHw+EqRXOaodOeKdIud0jRUudce
 rdKyablH
 666yL/Cs9ZB3z/ekg6CbLAgMmPdW8IjzKHRWNHOC46ahm5wjFoT34AwBMBclJ+2vNF9mQEvl//ARbrhbt3MFL5ZQHksEBq5IjeEoEW92ljSxurUuibz6xsZZ9blfI+7iOVds3w1bWGi2K/xm1O/rSE6XcnnZy2GAw1SQ7CI5yMKIWaKlttMyWIjdjTwmTfHA+aJYaDLV4tK8zaQwQUhIOGxOQMf62IY8tXwzzSYpfG3may5Rf0LiNqPy/I6w4EQcsNMn8CZJw/z5xIC7RTNIhiYUNp5uwN1hUn6Y8wBmVDxAS4jsiWtQzg4CA/41KP/ZNKg7NwpbMr3uh4ijqW+w6U27wZgXxTL5SBtHQP6ZuLHdlq9IxczlJ5fOB0AJVf7kPCOkyytTK0MrpdJRljTQ4Vh1WSYwQo4aBodr2YU0xReCHDOL92tPbnHayIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Save shadow stack pointer in sigcontext structure while delivering signal.
Restore shadow stack pointer from sigcontext on sigreturn.

As part of save operation, kernel uses `ssamoswap` to save snapshot of
current shadow stack on shadow stack itself (can be called as a save
token). During restore on sigreturn, kernel retrieves token from top of
shadow stack and validates it. This allows that user mode can't arbitrary
pivot to any shadow stack address without having a token and thus provide
strong security assurance between signaly delivery and sigreturn window.

Use ABI compatible way of saving/restoring shadow stack pointer into
signal stack. This follows what Vector extension, where extra registers
are placed in a form of extension header + extension body in the stack.
The extension header indicates the size of the extra architectural
states plus the size of header itself, and a magic identifier of the
extension. Then, the extensions body contains the new architectural
states in the form defined by uapi.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h         | 10 ++++
 arch/riscv/include/uapi/asm/ptrace.h     |  4 ++
 arch/riscv/include/uapi/asm/sigcontext.h |  1 +
 arch/riscv/kernel/signal.c               | 86 ++++++++++++++++++++++++++++++++
 arch/riscv/kernel/usercfi.c              | 56 +++++++++++++++++++++
 5 files changed, 157 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index 4501d741a609..ec4b8a53eb74 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -8,6 +8,7 @@
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 #include <linux/prctl.h>
+#include <linux/errno.h>
 
 struct task_struct;
 struct kernel_clone_args;
@@ -34,6 +35,9 @@ bool is_shstk_locked(struct task_struct *task);
 bool is_shstk_allocated(struct task_struct *task);
 void set_shstk_lock(struct task_struct *task);
 void set_shstk_status(struct task_struct *task, bool enable);
+unsigned long get_active_shstk(struct task_struct *task);
+int restore_user_shstk(struct task_struct *tsk, unsigned long shstk_ptr);
+int save_user_shstk(struct task_struct *tsk, unsigned long *saved_shstk_ptr);
 bool is_indir_lp_enabled(struct task_struct *task);
 bool is_indir_lp_locked(struct task_struct *task);
 void set_indir_lp_status(struct task_struct *task, bool enable);
@@ -71,6 +75,12 @@ void set_indir_lp_lock(struct task_struct *task);
 
 #define set_indir_lp_lock(task) do {} while (0)
 
+#define restore_user_shstk(tsk, shstk_ptr) -EINVAL
+
+#define save_user_shstk(tsk, saved_shstk_ptr) -EINVAL
+
+#define get_active_shstk(task) 0UL
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index beff8df80ac9..261bfe70f60a 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -127,6 +127,10 @@ struct __riscv_v_regset_state {
  */
 #define RISCV_MAX_VLENB (8192)
 
+struct __sc_riscv_cfi_state {
+	unsigned long ss_ptr;   /* shadow stack pointer */
+};
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
diff --git a/arch/riscv/include/uapi/asm/sigcontext.h b/arch/riscv/include/uapi/asm/sigcontext.h
index 748dffc9ae19..d22d0815d605 100644
--- a/arch/riscv/include/uapi/asm/sigcontext.h
+++ b/arch/riscv/include/uapi/asm/sigcontext.h
@@ -10,6 +10,7 @@
 
 /* The Magic number for signal context frame header. */
 #define RISCV_V_MAGIC	0x53465457
+#define RISCV_ZICFISS_MAGIC		0x9487
 #define END_MAGIC	0x0
 
 /* The size of END signal context header. */
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index a5e3d54fe54b..1bcda11e0680 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -22,11 +22,13 @@
 #include <asm/vector.h>
 #include <asm/csr.h>
 #include <asm/cacheflush.h>
+#include <asm/usercfi.h>
 
 unsigned long signal_minsigstksz __ro_after_init;
 
 extern u32 __user_rt_sigreturn[2];
 static size_t riscv_v_sc_size __ro_after_init;
+static size_t riscv_zicfiss_sc_size __ro_after_init;
 
 #define DEBUG_SIG 0
 
@@ -140,6 +142,62 @@ static long __restore_v_state(struct pt_regs *regs, void __user *sc_vec)
 	return copy_from_user(current->thread.vstate.datap, datap, riscv_v_vsize);
 }
 
+static long save_cfiss_state(struct pt_regs *regs, void __user *sc_cfi)
+{
+	struct __sc_riscv_cfi_state __user *state = sc_cfi;
+	unsigned long ss_ptr = 0;
+	long err = 0;
+
+	if (!is_shstk_enabled(current))
+		return 0;
+
+	/*
+	 * Save a pointer to shadow stack itself on shadow stack as a form of token.
+	 * A token on shadow gives following properties
+	 * - Safe save and restore for shadow stack switching. Any save of shadow stack
+	 *   must have had saved a token on shadow stack. Similarly any restore of shadow
+	 *   stack must check the token before restore. Since writing to shadow stack with
+	 *   address of shadow stack itself is not easily allowed. A restore without a save
+	 *   is quite difficult for an attacker to perform.
+	 * - A natural break. A token in shadow stack provides a natural break in shadow stack
+	 *   So a single linear range can be bucketed into different shadow stack segments. Any
+	 *   sspopchk will detect the condition and fault to kernel as sw check exception.
+	 */
+	err |= save_user_shstk(current, &ss_ptr);
+	err |= __put_user(ss_ptr, &state->ss_ptr);
+	if (unlikely(err))
+		return -EFAULT;
+
+	return riscv_zicfiss_sc_size;
+}
+
+static long __restore_cfiss_state(struct pt_regs *regs, void __user *sc_cfi)
+{
+	struct __sc_riscv_cfi_state __user *state = sc_cfi;
+	unsigned long ss_ptr = 0;
+	long err;
+
+	/*
+	 * Restore shadow stack as a form of token stored on shadow stack itself as a safe
+	 * way to restore.
+	 * A token on shadow gives following properties
+	 * - Safe save and restore for shadow stack switching. Any save of shadow stack
+	 *   must have had saved a token on shadow stack. Similarly any restore of shadow
+	 *   stack must check the token before restore. Since writing to shadow stack with
+	 *   address of shadow stack itself is not easily allowed. A restore without a save
+	 *   is quite difficult for an attacker to perform.
+	 * - A natural break. A token in shadow stack provides a natural break in shadow stack
+	 *   So a single linear range can be bucketed into different shadow stack segments.
+	 *   sspopchk will detect the condition and fault to kernel as sw check exception.
+	 */
+	err = __copy_from_user(&ss_ptr, &state->ss_ptr, sizeof(unsigned long));
+
+	if (unlikely(err))
+		return err;
+
+	return restore_user_shstk(current, ss_ptr);
+}
+
 struct arch_ext_priv {
 	__u32 magic;
 	long (*save)(struct pt_regs *regs, void __user *sc_vec);
@@ -150,6 +208,10 @@ struct arch_ext_priv arch_ext_list[] = {
 		.magic = RISCV_V_MAGIC,
 		.save = &save_v_state,
 	},
+	{
+		.magic = RISCV_ZICFISS_MAGIC,
+		.save = &save_cfiss_state,
+	},
 };
 
 const size_t nr_arch_exts = ARRAY_SIZE(arch_ext_list);
@@ -202,6 +264,12 @@ static long restore_sigcontext(struct pt_regs *regs,
 
 			err = __restore_v_state(regs, sc_ext_ptr);
 			break;
+		case RISCV_ZICFISS_MAGIC:
+			if (!is_shstk_enabled(current) || size != riscv_zicfiss_sc_size)
+				return -EINVAL;
+
+			err = __restore_cfiss_state(regs, sc_ext_ptr);
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -223,6 +291,16 @@ static size_t get_rt_frame_size(bool cal_all)
 			total_context_size += riscv_v_sc_size;
 	}
 
+	if (is_shstk_enabled(current))
+		total_context_size += riscv_zicfiss_sc_size;
+
+	/*
+	 * Preserved a __riscv_ctx_hdr for END signal context header if an
+	 * extension uses __riscv_extra_ext_header
+	 */
+	if (total_context_size)
+		total_context_size += sizeof(struct __riscv_ctx_hdr);
+
 	frame_size += total_context_size;
 
 	frame_size = round_up(frame_size, 16);
@@ -359,6 +437,11 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 #ifdef CONFIG_MMU
 	regs->ra = (unsigned long)VDSO_SYMBOL(
 		current->mm->context.vdso, rt_sigreturn);
+
+	/* if bcfi is enabled x1 (ra) and x5 (t0) must match. not sure if we need this? */
+	if (is_shstk_enabled(current))
+		regs->t0 = regs->ra;
+
 #else
 	/*
 	 * For the nommu case we don't have a VDSO.  Instead we push two
@@ -487,6 +570,9 @@ void __init init_rt_signal_env(void)
 {
 	riscv_v_sc_size = sizeof(struct __riscv_ctx_hdr) +
 			  sizeof(struct __sc_riscv_v_state) + riscv_v_vsize;
+
+	riscv_zicfiss_sc_size = sizeof(struct __riscv_ctx_hdr) +
+			  sizeof(struct __sc_riscv_cfi_state);
 	/*
 	 * Determine the stack space required for guaranteed signal delivery.
 	 * The signal_minsigstksz will be populated into the AT_MINSIGSTKSZ entry
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 2ebe789caa6b..8bc3e1e3f712 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -52,6 +52,11 @@ void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
 	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
 }
 
+unsigned long get_active_shstk(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.user_shdw_stk;
+}
+
 void set_shstk_status(struct task_struct *task, bool enable)
 {
 	if (!cpu_supports_shadow_stack())
@@ -169,6 +174,57 @@ static int create_rstor_token(unsigned long ssp, unsigned long *token_addr)
 	return 0;
 }
 
+/*
+ * Save user shadow stack pointer on shadow stack itself and return pointer to saved location
+ * returns -EFAULT if operation was unsuccessful
+ */
+int save_user_shstk(struct task_struct *tsk, unsigned long *saved_shstk_ptr)
+{
+	unsigned long ss_ptr = 0;
+	unsigned long token_loc = 0;
+	int ret = 0;
+
+	if (saved_shstk_ptr == NULL)
+		return -EINVAL;
+
+	ss_ptr = get_active_shstk(tsk);
+	ret = create_rstor_token(ss_ptr, &token_loc);
+
+	if (!ret) {
+		*saved_shstk_ptr = token_loc;
+		set_active_shstk(tsk, token_loc);
+	}
+
+	return ret;
+}
+
+/*
+ * Restores user shadow stack pointer from token on shadow stack for task `tsk`
+ * returns -EFAULT if operation was unsuccessful
+ */
+int restore_user_shstk(struct task_struct *tsk, unsigned long shstk_ptr)
+{
+	unsigned long token = 0;
+
+	token = amo_user_shstk((unsigned long __user *)shstk_ptr, 0);
+
+	if (token == -1)
+		return -EFAULT;
+
+	/* invalid token, return EINVAL */
+	if ((token - shstk_ptr) != SHSTK_ENTRY_SIZE) {
+		pr_info_ratelimited(
+			"%s[%d]: bad restore token in %s: pc=%p sp=%p, token=%p, shstk_ptr=%p\n",
+			tsk->comm, task_pid_nr(tsk), __func__, (void *)(task_pt_regs(tsk)->epc),
+			(void *)(task_pt_regs(tsk)->sp), (void *)token, (void *)shstk_ptr);
+		return -EINVAL;
+	}
+
+	/* all checks passed, set active shstk and return success */
+	set_active_shstk(tsk, token);
+	return 0;
+}
+
 static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
 					   unsigned long token_offset, bool set_tok)
 {

-- 
2.43.0


