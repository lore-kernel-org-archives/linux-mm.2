Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92919D2A522
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DB96B00D3; Thu,  4 Dec 2025 15:04:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6876B00D4; Thu,  4 Dec 2025 15:04:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E126B00D5; Thu,  4 Dec 2025 15:04:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 731F66B00D3
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4125814033A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:36 +0000 (UTC)
X-FDA: 84182866152.12.F559654
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 269F14000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DqCEZGoH;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8RAdnFjLZeiv0mM+uN6lpfecdUeEYifCe5h+luRUQo=;
	b=dSU72fVxLRE1I3i2iQbdLiY4fhCjSLUgZuUvQUSf4dsWkNauUhA5QLqBw5Fass+bP2P8vj
	Fxhu9cM7HzQWfE4DWuW3kGsIZfFFrWZbUPAHw5wN+fboABOIgZdraQplNUOjedUcWTQOj+
	gkfZSkRMexqPLgPtK/gcN0F0b0cOPek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878674; a=rsa-sha256;
	cv=none;
	b=febqp8DFazadrRiiZpUXM1I7VSdmifoJwOGzLLTQzCI2naKO5BUD5I35q6/++HiE/cXsES
	ksSV+Exuwi9XZcwokA0hM/PoOqtrJpURHhlG5yaRWYMLPld0LyjACQeBLWCRktXKO4N0g1
	Io+rVSlsLoHoXUvmfknxzUxVE3MG0qs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DqCEZGoH;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso2149767b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878673; x=1765483473; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m8RAdnFjLZeiv0mM+uN6lpfecdUeEYifCe5h+luRUQo=;
        b=DqCEZGoHGQNREpoe85SA364erv1ysz2QA3gxITgcB66KWxhd+hCGn7Hgj70fPPd+XE
         Zmw5v7DYHqUwEAbBg0BGP8xy5iUCspKY2jDu99aQpOEldIVRsxOfwYE9Js8zFIcwkV27
         5uuL4fjGcB13UhNG/zlSyAZWWfRTZfPJTM90KAaI3AlshNkXNIwn1/X8AGBRCT1PFwwp
         /OC0DjO5zdSgkMZRzRnJ6C0JNV3xNhbNkct3TsYujbZRZVXJ0oUb/+ixWp6aa2HZFiB/
         U5pPdFJxZUI6Gd3cnmPglQu4sx0e7CtuvPTjNIflXg49an+uxi66mmo4sazFGuyuKYrZ
         qEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878673; x=1765483473;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m8RAdnFjLZeiv0mM+uN6lpfecdUeEYifCe5h+luRUQo=;
        b=e00k4ayyi98krw5+gfRcbVdMEXMbf9Rpi0KnsDVynXshiIqWld0UHe+3f/RnlULpod
         Eh7ONxOYqeTG5r12KPN7mCiCaq9RDa85GnzVAPzDoIMOVRbW2Olpbboh3ysq6kgxp1B1
         F0dsRktJR8HlJAUnghOBEPUrtzIfX8iTcug/2eyldYGpSUGHyIfYre4E0SvVlD5AHiQh
         p/JCIuSI4AeUmXWePB7u+HFMUp2mymrwQbxNhMzd11nKRVu6kMBEtMNDKYEgl9UyRsN1
         NQUz1TekV2LSGOaoXKZ3Wh/86FfhP1w9ayQLfJYgKSLXVAghXjBI4DsAfaAtenh+LSBh
         dqWw==
X-Forwarded-Encrypted: i=1; AJvYcCUmMFt6iW20xXf5lLaFEkpa5wWypKTgOwjh56UVOdmF/4f+e/OmbiSnDECEvsG715MeMd46lo1sKw==@kvack.org
X-Gm-Message-State: AOJu0YyvbWnjghZPspVRAOPng6D1yewAo1EPbD7j5cGJP9ZfH/JagjeY
	x13rfjK6nT3CMdgfobNR2jBgxkzoA4bR0woWAlUXJYW13IirLB8B+bmoy0F1SlPyrOY=
X-Gm-Gg: ASbGncu1cxoZ6KI6+fMDVFSs+5vb2YrMKAkAvt5Z52ByTXE9a9a/cJJsyJ0XivZXLHl
	1fH79nTj3/8K6ewZraPFVcibLuwBrbRs1XJP7eY9Sl12ASmd9e2s4CNiP3od0L3z8/h82A5Zrsk
	/U28pL53WnvIDCa6ROzvcuwmuX7vnWdEp42He/eWTjbetEqXVQyn7/UMjse5Qa3tyPRn1evHk1O
	kMbtB4gu7ngcd1ddGxBrkZHuqsdj24kJiXOm+aMsBGdUQfBqlN3HQ+rs7MIbp6wTLWVUFeNpGWq
	DTV4axxoLX4qnNlZc1SkrEYbkvIzuALq/yGctP9Wngd2i0bkXXPzfcHWRst0s34YMbRChv8AU+P
	9vZDGM8ksyBOJe7gEqOkB2mEYgxyQMlMJR3K0YN+Uo3dBPhowsGuJAKXD2EC0dRUTs4xUsB3I3S
	3cRNBwh7dZi5NyuTi/3A6g
X-Google-Smtp-Source: AGHT+IF31m33+z+fanjcf2lh0S8xswVFfm3Zl1lX/wi41k0+yKnz18WWjWSVdR26OzCVdcHS7PEO8g==
X-Received: by 2002:a05:7022:692:b0:119:e56b:c74f with SMTP id a92af1059eb24-11df6469b05mr3868251c88.20.1764878672812;
        Thu, 04 Dec 2025 12:04:32 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:32 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:06 -0800
Subject: [PATCH v24 17/28] riscv/signal: save and restore of shadow stack
 for signal
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-17-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>, Andy Chiu <andybnac@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=11354;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=wRiQCE76OkUFJOGdOcfdlVYFvkQN8WIdJisZv4rS67E=;
 b=MMJKmEe23J27hpwIeFf3/bsI8g0mqARq3jD17nDoY9tne0U60jmOPR6das5aN4eQWuWSJ8HAg
 YYS7R4vr3/xCYJwOOtJ4JV102upUdLpP98CDOo7/NIZ8sZsqd1nAaBp
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 269F14000B
X-Stat-Signature: fszpgzzin836fsrcdahm4esjdhyohhyc
X-HE-Tag: 1764878673-950107
X-HE-Meta: U2FsdGVkX18Ip4pUAFC7TngfAhbnVBLfzikLLZZ9/fxCOVUpEqJ0Ktcz4cM8eD9wFHRlra49cN8G07DrtQc8SwBa5Bc8vBeMQdTwzaveR/QMO8+pwfVxWFIhdyYuAXl1pD8vZ7se6PAW9RYVHX3PK7mPywsm2LOCOeXB1dAzd63QHvMb5tfEuRGbP5rmZW/49Gl55ghgM/EVGlXY2mjlYvDTAwG2AkV3R/H1rfIj+QZSc1x9b9x7yZqcJsN5HA+rzZR8mguXdf2Fx5GLgL9onhR7Yjy8lFqcb8nkrrYNhG/jFQhuTWKGxqaQc5YdGzzpWSFCIafebTvFptJ+WhHcK/eja846Yq6BOzwX6vEMmBGmXSfjESIO13v6Re+EKfnYN3I+Uyh9+OCMdsoiv45HuRZIMrStrY9rVta0fWJge+lLLz0cTMvXJpOmLIbCRWL6VL0gpLJHq4zUw4+sVGM0hvtcmCOTh+B7exOtSrDoxDFa3oz0/W7RNrtc9vL0yd9qQUeXJpy1QqLejMAouZpGpcYoe4FbBMKntxX89cdagqSOkp/jx0Vtq00WB5NtiPVKWTNE1ggf8hcsZRLi1ydbh7ltxVDt1htlYz2ijbMZ6Ke5t/DpXwLkAX5YaZBIIc/17DnDfeL41Xf7JI4BwTMvqxNyAA2dnuprlhSP9kB/9OYbIzocCDOWTHpj7lT8kfx2Gu1M805i5HfODPPI44TnirvtRLlIgnUyvzCWfdhtiEgy1ih+EufGqJ1dzVGda3fKbqvtSDcgEfBoe3MzEB4qL74miL4HWIEUKKK+2moDu8oz6FW7wOAwxcWvd4gbLCiR3YaU+wQ7frFpNepmsnQeB/Zke68XyCBXdAS9rWMyKe1p21okbj0By9KYKLRzc/z/UVdGJ+NJflOVw4QxsqvzsSr1ew/T8oGqhM1bcJtEuMzdAFsE5H6J/daoOA/fATZqT8yNSP2vg3yBNvfE+Vz
 1ARb3ZXM
 2goMFVhlg1bVS+loXKGZfmVdnNtdgUumUYCQC8z10Jbi0fcOyED/ivX+ut30K0+2vv2TpqZmt2wRYdThxDLHe7ZC0Rc2q88W/E6QDbUL2ApEwAUo6hT4vsVgho5ZHL0VaiBx2VqQux/AYW7nVDEg4kz+xAZb4+ghiDxXUYF9/fsjE/m2I9b+ETdpPRndAzrIRNtwixy4xhPCs7E3+Tk54eGZ/aBE4p6zmbOzhtv7VFMZf+tO6hurDOpkHGDiN4l/Z0QLhJd30I35A0UBHkUM+MknCetH5lRogFBSNInH6EZz+KKFIVXJbS6xhOoRfShEqg3kMFoS8CKHJVQEBNetx4KEqZ10s+IwvZi+2IYLbc+hSEHWqJMrLZIbbMR52FnX7orykz6qWPOP+0r8ICswnIXSkXi0Trjrs7YN54r0ULhqo2+/HF3QNhEcMBHQDkm6gIiwKgQg1p9igXiMglfHgJTQTTsuU8ZsyG8tpPXTTjeiYvE2jGc0HEBaWNTK4cphj9ZnTD3P9s54WFUxatqF45bVeBXDg6G39n1f2
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
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h         | 10 ++++
 arch/riscv/include/uapi/asm/ptrace.h     |  4 ++
 arch/riscv/include/uapi/asm/sigcontext.h |  1 +
 arch/riscv/kernel/signal.c               | 86 ++++++++++++++++++++++++++++++++
 arch/riscv/kernel/usercfi.c              | 57 +++++++++++++++++++++
 5 files changed, 158 insertions(+)

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
index a384ce9ed25c..7f01befabd11 100644
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
@@ -168,6 +173,58 @@ static int create_rstor_token(unsigned long ssp, unsigned long *token_addr)
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
+	if (!saved_shstk_ptr)
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
+		pr_info_ratelimited("%s[%d]: bad restore token in %s: pc=%p sp=%p, token=%p, "
+			"shstk_ptr=%p\n", tsk->comm, task_pid_nr(tsk), __func__,
+			(void *)(task_pt_regs(tsk)->epc),
+			(void *)(task_pt_regs(tsk)->sp),
+			(void *)token, (void *)shstk_ptr);
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
2.45.0


