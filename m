Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E7ECCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE528E0076; Wed, 15 Oct 2025 14:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8DC38E006F; Wed, 15 Oct 2025 14:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55DC8E0076; Wed, 15 Oct 2025 14:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A582B8E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FB141190AD
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:30 +0000 (UTC)
X-FDA: 84001148700.11.B4731F7
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7C79840010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Dg0s4aH2;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orzOOXGj405YiK6przhe0GQbSZ5JqsOFQ3WhV+5/r+M=;
	b=kZf/H/AOPo2UVcNrT/3Gzyd+eRG5RZXJJF6DFygtZnOP7eKyR32D+ntOytP6SGAgMKmx63
	5Jl/PnxNFzDuG52fR6aIlS/CfXOJc0w3zsDOT10FVjEIBUbFGduyU8r5yImggy02K4OIcH
	OFY4fYwq+B/Hixq2W+GM4wtWum/g8Ng=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Dg0s4aH2;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552068; a=rsa-sha256;
	cv=none;
	b=rvQ5cfYzJisBRR85PpzrmummbwhDSxYulV2WQQVIU5Uf9lQPtiN45oWuwTdMYuNf1zER7j
	3MqFOi33KbftJO32B2RgInFGLD2OR7LskrHDJaFmASK0xuDiNiwC3j+iL5DSJxToH4ZUpB
	Ls2KVjBm+VRzkaIHpm21wv5Wwv5qjmo=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b5a631b9c82so4254618a12.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552067; x=1761156867; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=orzOOXGj405YiK6przhe0GQbSZ5JqsOFQ3WhV+5/r+M=;
        b=Dg0s4aH2W/KcarZSMqK6nYPqV2gB0aLi4iSa9prt44h7OyPvO5XqQowMkKPnpQ9lB7
         YzwXTjjFktPIxVGYd91SDPSemPJNDeycoWnkJvee60LnrVEzloyJHVAPMOknnA5+IAL/
         SXQwMTnHXFhE8M0a3WO+Bqq5IkvJKutScMPwP4/y8usFiun0QYaet5s+HH29iwWufnKg
         xqDN/LO1Fd3AZK6f+5lClBjz1ZTmBVNBba78P2xmf4Pm6NM0+oa+lTWaLUlzwpehybEw
         FlGV1tq9WCacQviW/01GPT0WlqFuHRb3EicVYTfr31a1qjYZAsTNGw3wjq7HXTUsmOrd
         w5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552067; x=1761156867;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=orzOOXGj405YiK6przhe0GQbSZ5JqsOFQ3WhV+5/r+M=;
        b=oZYEIBWAWpGdgYsT9fH62YJ8ilTuZt3/ex3Nc4iTrxkG4rsqSmNrHggO7FtwiCDI8W
         wyZlM0DSI651jyAIUKEEM+lX+uAB4Zi9TV6XMzP9q7VkWzdw4Vyjgk8DGVaXFEWTMeHO
         U4omfHRfAXjv4bGFvwvZFG+CZ5LMblI6EBMi5aznK9fQYCspxmAXEjrl9pR4XAdYold8
         9N9f2rReVKInuSYnh/2wEVHdoAfvImul1ZenpyavUPUAM1J10gsMlSSjpFXK4iYM2q7c
         D7iwT2fpiY4/OC6nrTNY6zVppzYKMxh6LrgxTV7RE76u2HUZmyYZv0Lydk4/SoRKR1+F
         6y7g==
X-Forwarded-Encrypted: i=1; AJvYcCXn6QvStjlUUN7GW182w8wEIUA1Z5ARoOyJRM+QQYQkl5XkicdrWQ7iHxpJBQAZRc2Sv5jfln8mzw==@kvack.org
X-Gm-Message-State: AOJu0Ywsu+MOGPcG3NhfxppA9DAZV9q9BU/Wm74U+gLKlOse1Xz4O90U
	98limWc54uzzop0MGAAwt9QQDRUJQB6aY7pvcNAnXOHoQ38xsf7Z/mxpgHR3mwmJL5ekGt1yM8g
	G5J28
X-Gm-Gg: ASbGnctdVx5CzSZY/y93iaMz31Lq5FNoVF9LotiVIbEoBYYDx2WYOE9iy8AOxNjfsjM
	6sqRc2dB22meDYGINEuC4XR0ekwk16DJh1oMub16xRCyo3+IPUcae3f+JH0ybMBNVr+ZHVUMh+7
	CTGg8N4kKKaxzPbcXmNT9m+sFclZYFTdVVTfhHGqM9Ple5TGCYBhITrBlV1Bn+nM4EwnMRCP47K
	KRACIaqFxMZ5knSzS57hhvFRO/Yh0xIHs0O2EsAigGcXukSBbRLeZ0KA+fy5tUpulghek8yvAl8
	6vRxYZkTom5NvpI60Oie1Eh+TEk0+jJU5zXfS3xyth0iYZHu0fR3/6muS2atDKUdnJwxPJ71wOe
	ZEeHkzwv/f+90nZct+pXYcj7ANwMtVNeyJsiwV6Iylkk5xRv89GR+7TIg9MYRYg==
X-Google-Smtp-Source: AGHT+IGp8dmOujqeHT5ky5r4JSw2mUnM+dUHBRmklFJcUmcq0u1vTX9Vh99gqlmXdW6iH8dJGBpruQ==
X-Received: by 2002:a17:903:4b46:b0:27e:ec72:f6d with SMTP id d9443c01a7336-2902721325emr357480185ad.11.1760552067036;
        Wed, 15 Oct 2025 11:14:27 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:26 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:51 -0700
Subject: [PATCH v21 19/28] riscv/ptrace: riscv cfi status and state via
 ptrace and in core files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-19-6a07856e90e7@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 7C79840010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9uprfdfz4aucbgiay1b7nc5cwsbebcgt
X-HE-Tag: 1760552068-462992
X-HE-Meta: U2FsdGVkX1+3ZjxX1smOVt1WkjE3YNEdXXH6cr6mnA85QYWfecAMXvVPdWhNffK9qtgWkExhWKAL7xh5jJulvQf8/VLTzgRtvoy3vNzNnc1l/XY16aj8EYLV5OVdPvDIoerQFWlzSfPyaBujuWb6Br+bMZtWzoULtgam/sXKhgM6MBFkLuLFuTwu/5A26tGfB5I9apPFGzo+s9ZsUHJ9NL84Yx6zjF77OsCoO9F5TyRSNWkLb30Hs4CdufLqCwBzbXPZ+Uf4Q/gUCCGmwUuHZWkl+ns+f5wYHwkUCIst3d+uv4Z02NkLTI8VkJF8V//ULjjFGw5tcpKBMC1dmSV2TaQPcuzpMg3sJsXBaVFjVTPD8fncV6KfPnc+A0CoSM2VqhMPVH65ljhmfnOzuj90ZMb3Dd4C1WlXCfALuzBqKIg43IfZOmuha5DfYVOCHeD8G3CsTrtoKQCfCw+6zm0zDABa+iBHIgMtQIRdHDy63dJ+knBudSEGiob8fD/rTw4gnpTenrNTyuL/y7Zp9MG4eA6bN+Sdr9SeUMOQs5Y2A+OjxdS6NQKYTtf8H37UIR4qpVtbk4Lb4e4QOvCWjiRuyhkTjemi6PWSXCA2xQ3wqKNIkZiuRah0GkW+TRIOw2PvYD19eFUIbmhcXwpjDw+dkhwWyXs6C5cBXvwYo4wXpNhukrge8feCKS/9jClyAR52sb64LkIOxgHKeZJ9D59ETQMvm8WDbJlR4rz54QZB0Qp1dQWdmrrLPANtEWTISa8OnWdvjft+ZaR4WMJq5xr/NSv4F1HZbCxdFDEywjqixdVJMwem3arhVABkIbMFFb84Yrjsd8C1+8JDjRqJULCVV3T/AMweZ3NNc9zSZaTO0UpJNiuQXVInsNB3wVRqjA9BIs403So2jNpK8wJDh2+iSd+q3BYHuw8T6z4RXuR1pMydWslpmgRYjsqviWiSg4HRN5G5vFNg5qOLEpMzdxp
 J+bsmFBl
 Mo7wiuiLDH3TB2Bh+qMMc/hrwmJz9ZGa+ZVT0pBGnsM6mQ98Tac9eVwPumrp1vFmsbsIuHOIGm3SxETsI8SS10rb42jqMpMFxta4ZV/z5cAlv6hWWCJLCyynKrO+rmR7hHVklkDtM2XGBCOyAuMwZ5EuUXZzfK0s0LAY53qCy8kqFb3kLHwDvoaalft00uJCAKAH3w7BKYfj1IwWhRtucwuQ+xbV2NtR5AYXANUHASh9CKRr/IMWgnp5D2kJTxYDYTHtD2OAJtCtWx4WC2kIxFI/nlKnjrUcSOooV8FyIFvn9CN7KmbPv+5JJVRXezDfnziZbygRo94btqC+vbFGB9mpkdHqOY+7ueP25RV78NL2pNjLWG9gMr7OC/tFtdVECY1W6YaIz+ZndPRDK+eIYuph6/SVyJjcxqRAr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose a new register type NT_RISCV_USER_CFI for risc-v cfi status and
state. Intentionally both landing pad and shadow stack status and state
are rolled into cfi state. Creating two different NT_RISCV_USER_XXX would
not be useful and wastage of a note type. Enabling, disabling and locking
of feature is not allowed via ptrace set interface. However setting `elp`
state or setting shadow stack pointer are allowed via ptrace set interface
. It is expected `gdb` might have use to fixup `elp` state or `shadow
stack` pointer.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/uapi/asm/ptrace.h | 30 ++++++++++++
 arch/riscv/kernel/ptrace.c           | 95 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h             |  2 +
 3 files changed, 127 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index 261bfe70f60a..b2a18dfeb2fb 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -131,6 +131,36 @@ struct __sc_riscv_cfi_state {
 	unsigned long ss_ptr;   /* shadow stack pointer */
 };
 
+#define PTRACE_CFI_LP_EN_BIT	0
+#define PTRACE_CFI_LP_LOCK_BIT	1
+#define PTRACE_CFI_ELP_BIT	2
+#define PTRACE_CFI_SS_EN_BIT	3
+#define PTRACE_CFI_SS_LOCK_BIT	4
+#define PTRACE_CFI_SS_PTR_BIT	5
+
+#define PTRACE_CFI_LP_EN_STATE		(1 << PTRACE_CFI_LP_EN_BIT)
+#define PTRACE_CFI_LP_LOCK_STATE	(1 << PTRACE_CFI_LP_LOCK_BIT)
+#define PTRACE_CFI_ELP_STATE		(1 << PTRACE_CFI_ELP_BIT)
+#define PTRACE_CFI_SS_EN_STATE		(1 << PTRACE_CFI_SS_EN_BIT)
+#define PTRACE_CFI_SS_LOCK_STATE	(1 << PTRACE_CFI_SS_LOCK_BIT)
+#define PTRACE_CFI_SS_PTR_STATE	(1 << PTRACE_CFI_SS_PTR_BIT)
+
+#define PRACE_CFI_STATE_INVALID_MASK	~(PTRACE_CFI_LP_EN_STATE | \
+					  PTRACE_CFI_LP_LOCK_STATE | \
+					  PTRACE_CFI_ELP_STATE | \
+					  PTRACE_CFI_SS_EN_STATE | \
+					  PTRACE_CFI_SS_LOCK_STATE | \
+					  PTRACE_CFI_SS_PTR_STATE)
+
+struct __cfi_status {
+	__u64 cfi_state;
+};
+
+struct user_cfi_state {
+	struct __cfi_status	cfi_status;
+	__u64 shstk_ptr;
+};
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 8e86305831ea..56b9e3871862 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -19,6 +19,7 @@
 #include <linux/regset.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
+#include <asm/usercfi.h>
 
 enum riscv_regset {
 	REGSET_X,
@@ -31,6 +32,9 @@ enum riscv_regset {
 #ifdef CONFIG_RISCV_ISA_SUPM
 	REGSET_TAGGED_ADDR_CTRL,
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	REGSET_CFI,
+#endif
 };
 
 static int riscv_gpr_get(struct task_struct *target,
@@ -184,6 +188,87 @@ static int tagged_addr_ctrl_set(struct task_struct *target,
 }
 #endif
 
+#ifdef CONFIG_RISCV_USER_CFI
+static int riscv_cfi_get(struct task_struct *target,
+			 const struct user_regset *regset,
+			 struct membuf to)
+{
+	struct user_cfi_state user_cfi;
+	struct pt_regs *regs;
+
+	memset(&user_cfi, 0, sizeof(user_cfi));
+	regs = task_pt_regs(target);
+
+	if (is_indir_lp_enabled(target)) {
+		user_cfi.cfi_status.cfi_state |= PTRACE_CFI_LP_EN_STATE;
+		user_cfi.cfi_status.cfi_state |= is_indir_lp_locked(target) ?
+						 PTRACE_CFI_LP_LOCK_STATE : 0;
+		user_cfi.cfi_status.cfi_state |= (regs->status & SR_ELP) ?
+						PTRACE_CFI_ELP_STATE : 0;
+	}
+
+	if (is_shstk_enabled(target)) {
+		user_cfi.cfi_status.cfi_state |= (PTRACE_CFI_SS_EN_STATE |
+						  PTRACE_CFI_SS_PTR_STATE);
+		user_cfi.cfi_status.cfi_state |= is_shstk_locked(target) ?
+						 PTRACE_CFI_SS_LOCK_STATE : 0;
+		user_cfi.shstk_ptr = get_active_shstk(target);
+	}
+
+	return membuf_write(&to, &user_cfi, sizeof(user_cfi));
+}
+
+/*
+ * Does it make sense to allowing enable / disable of cfi via ptrace?
+ * Not allowing enable / disable / locking control via ptrace for now.
+ * Setting shadow stack pointer is allowed. GDB might use it to unwind or
+ * some other fixup. Similarly gdb might want to suppress elp and may want
+ * to reset elp state.
+ */
+static int riscv_cfi_set(struct task_struct *target,
+			 const struct user_regset *regset,
+			 unsigned int pos, unsigned int count,
+			 const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	struct user_cfi_state user_cfi;
+	struct pt_regs *regs;
+
+	regs = task_pt_regs(target);
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &user_cfi, 0, -1);
+	if (ret)
+		return ret;
+
+	/*
+	 * Not allowing enabling or locking shadow stack or landing pad
+	 * There is no disabling of shadow stack or landing pad via ptrace
+	 * rsvd field should be set to zero so that if those fields are needed in future
+	 */
+	if ((user_cfi.cfi_status.cfi_state &
+	     (PTRACE_CFI_LP_EN_STATE | PTRACE_CFI_LP_LOCK_STATE |
+	      PTRACE_CFI_SS_EN_STATE | PTRACE_CFI_SS_LOCK_STATE)) ||
+	     (user_cfi.cfi_status.cfi_state & PRACE_CFI_STATE_INVALID_MASK))
+		return -EINVAL;
+
+	/* If lpad is enabled on target and ptrace requests to set / clear elp, do that */
+	if (is_indir_lp_enabled(target)) {
+		if (user_cfi.cfi_status.cfi_state &
+		    PTRACE_CFI_ELP_STATE) /* set elp state */
+			regs->status |= SR_ELP;
+		else
+			regs->status &= ~SR_ELP; /* clear elp state */
+	}
+
+	/* If shadow stack enabled on target, set new shadow stack pointer */
+	if (is_shstk_enabled(target) &&
+	    (user_cfi.cfi_status.cfi_state & PTRACE_CFI_SS_PTR_STATE))
+		set_active_shstk(target, user_cfi.shstk_ptr);
+
+	return 0;
+}
+#endif
+
 static const struct user_regset riscv_user_regset[] = {
 	[REGSET_X] = {
 		USER_REGSET_NOTE_TYPE(PRSTATUS),
@@ -224,6 +309,16 @@ static const struct user_regset riscv_user_regset[] = {
 		.set = tagged_addr_ctrl_set,
 	},
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	[REGSET_CFI] = {
+		.core_note_type = NT_RISCV_USER_CFI,
+		.align = sizeof(__u64),
+		.n = sizeof(struct user_cfi_state) / sizeof(__u64),
+		.size = sizeof(__u64),
+		.regset_get = riscv_cfi_get,
+		.set = riscv_cfi_set,
+	},
+#endif
 };
 
 static const struct user_regset_view riscv_user_native_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 819ded2d39de..ee30dcd80901 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -545,6 +545,8 @@ typedef struct elf64_shdr {
 #define NT_RISCV_VECTOR	0x901		/* RISC-V vector registers */
 #define NN_RISCV_TAGGED_ADDR_CTRL "LINUX"
 #define NT_RISCV_TAGGED_ADDR_CTRL 0x902	/* RISC-V tagged address control (prctl()) */
+#define NN_RISCV_USER_CFI	"LINUX"
+#define NT_RISCV_USER_CFI	0x903		/* RISC-V shadow stack state */
 #define NN_LOONGARCH_CPUCFG	"LINUX"
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NN_LOONGARCH_CSR	"LINUX"

-- 
2.43.0


