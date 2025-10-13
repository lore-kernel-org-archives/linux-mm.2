Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEF15CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DB88E00A4; Mon, 13 Oct 2025 17:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EC88E00A2; Mon, 13 Oct 2025 17:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A608C8E00A4; Mon, 13 Oct 2025 17:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAE58E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 450751A04FA
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:44 +0000 (UTC)
X-FDA: 83994451128.27.1EEA158
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BD081C0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Gs9ad5D5;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392602; a=rsa-sha256;
	cv=none;
	b=YfjuQi+FFI1jCf3wYFtfXNu8tGL9d5uvwEfOj+crY9z+X9syp2nsM5J7/SGvlBhgMf0dKG
	tyNye+rauD0ob/EcePFUeR+GRuoZ20EOwWY94SdW5kmq1BhXqVbJZw/sOCFTEfdBXWF7Xl
	N4XPdshoSaVxmPC9+yck7CedAR4LGHE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Gs9ad5D5;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orzOOXGj405YiK6przhe0GQbSZ5JqsOFQ3WhV+5/r+M=;
	b=O7i8bKZDhjykbODmPAL07y+Oz9kVJsyPpj3hjxIjhQMMiVbQoIeeW8R0dhr4LVsOHeGbTK
	hRgY/kezd6oVRAMEDGmI6D8EAfP7nHCJtZFkPxJIExWQVvvjmYEa0WV3kQmSdbonk8GBlA
	hpRBkILlv5uvxG6H/S2S04hU/ilysM8=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3324523dfb2so4536857a91.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392601; x=1760997401; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=orzOOXGj405YiK6przhe0GQbSZ5JqsOFQ3WhV+5/r+M=;
        b=Gs9ad5D5Qo4+DC3s43Ty1qqp1ZPtKImCVC4MH0mW0lZludyREo/7vqLIjPoKUvEt8k
         2HwxP22dljd+Nfjkc4qatrwVM+nw5wEPBcaxVG4kIla/EWyjmXMEg2QQZWF/ic+JD5vU
         kzgxh+AZaYGeX5REUVwxqq7w/9lNp4Eu9Klo4qWB9ehpGIbu+jFGR0PEWz12f7VLsqm8
         i8Xa0QtmlXiOOEqRHnnemTRr1ZAAMjv56mHEB5LN0gW/ynA/YGwe0Fl+GAVWCHx6ty9A
         fUpQ2Lh1mfkkORpYLtWtSXTD5FPt4nQ3nwGCDIgu+x3uKrVIB3HqX0S6crk71pxlqkK2
         Eecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392601; x=1760997401;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=orzOOXGj405YiK6przhe0GQbSZ5JqsOFQ3WhV+5/r+M=;
        b=IBqGIBuwVUTqMLGvK9yNLWmyyZcnOOuVab71MDb3o3lTS4LzclDFJoOObKP/er/bdl
         5jzPWakyyfGtnBh7AvlbB6g+m59mwwZ2aLn7IofOvodh8rbeTLYsKydRbyY+vjAcHJ81
         snMVtpTiWIJU3V4LbFxJowBXBSynMqOFhgCBD5D+BKmgZRZVcphxzC1dxT2TACNgZzA0
         vis955WYJiXep3ESl4tBofs1jJ5TdRyuepfvxgojuuIVlvxS74sAPjg+bZWrbR4y3PIZ
         o9FLQdfPmpv1fKbrSBRK4pO8s/LONmDALufkGhjLC2B8qpY2AZhZ32p+6COmYZbyimhX
         NISA==
X-Forwarded-Encrypted: i=1; AJvYcCXD+Gm0WFzSWjwjqPZg/+JIre3ex5yiQdID9t4008So6M3zNewLj5zo7jtcZ2vBdjqVSnCw+3HbKw==@kvack.org
X-Gm-Message-State: AOJu0YzDcndH5iVmsUadzbYjEfkmXWQQJ42mQIjT3gT9/q2Z9I9NOvfx
	3ZsfSsTyL8V56VV7wI3E4uq1/g9JhjxUwXcgw+P2TTIX22NGn0xQ21RgrEJLpgQUZKI=
X-Gm-Gg: ASbGncsFFTmXnUXGFxmvnnAtVmKMFqpEy5KNxpBHfaoj2iMKaUiWfjM6MWSbayGDDkD
	7BXWQaDcYe26/cwgKFfu3vnbIo61hVltz3BnH684PrywJW5Q3E8BfmJEazyEBn2NtpEEmvZtX9n
	BtrvSXGh1bSjMLOnuvbGy27K93nmZfWypcSMn2eItsdsTke92/hkmu1DDTI3Om41dzfB28qIY2v
	LvPJCBY0XBej/vXgJ5/6BFqyHszr7lJDc3TZlo+QKwVbDXOql2A3Z9pyH8tQDfAfXv7f857w1IL
	B20VxomRQ4p22o7n9AAjD29Be4QTm8/9oFrub0YMZBymdMPkvzc1VsSIBVY39o6jclBmT8Pks7a
	fNqCcQ51r2a8s2mebgVS7QTsUaKHg1s1eWmaHfFqk6nQeEJ3Dm29CXTtlDh5jPg==
X-Google-Smtp-Source: AGHT+IFXIjCgVe+iPpZHDAimXPS0S6OzXaRZdMT1KbxRB2iNFRf26pwMaw595QqzXQcdzmq5wyfjiA==
X-Received: by 2002:a17:90b:1c81:b0:330:7a11:f111 with SMTP id 98e67ed59e1d1-33b513be2c9mr30305717a91.35.1760392601215;
        Mon, 13 Oct 2025 14:56:41 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:40 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:11 -0700
Subject: [PATCH v20 19/28] riscv/ptrace: riscv cfi status and state via
 ptrace and in core files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-19-b9de4be9912e@rivosinc.com>
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
X-Rspam-User: 
X-Stat-Signature: sge6j4e9yj1mu9b3y7mpq84y9kx7fj6f
X-Rspamd-Queue-Id: 7BD081C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760392602-565949
X-HE-Meta: U2FsdGVkX1/CFUYXr9MTMIx4KW9qsePjZS8m6PJHTelGdTbcSmgBeKB10ukagSWyYg8BOLXs3v7KLC3qDhNUM9XTKOsjhtFTzoksXo+46DVII2KwA7+GAaSm9r3v3cerPuf7mqXMupydSHrguFqu78XQ+56Bh3yuMqljBHiqF8n9mGBQ4YqJZhq9pK1LvkRWG/zwePKNDPG/8qTDRLBxHWgjOwAGY0WH9jafJ9gLQIJCTfwADQI75ZMpZjWY2Kj1Ys7X/UyVv6TSP9Q2ey20rIqyAjUBMJtAfO78JNGN9/q+JIs68CaSfpwlMQJqz9cDmV1AjhOUKIeGm1CMrPpGBEk7mua+43Upd3Yh3Bh04/bFVsZYJuYZRwHAl2XlIHMYOqYNacUpkqrn9WRWbjcgY71Ctqj+r2qLX47cMVsA2h3jjbNkC9xzIkc4J325eEzxomYoM4cS4ATAjuevwrY4ODzxWbMyy8Qwj0C0sIzOhwl57tzIpdj3d+/1lQkcdSsq9ukKRp/z3WJvDIehSbfcpBJMvNyiAXyTFbmwQHhWpkhmh5FDl0Q9eZCJm460nPZZBykuBn06MY+lgFHKh+UR0ixSN9HnrC7M1F+yPBPtPjUXjQse6cRBrVXiPXVAhhAxwmwjdcwqwHHhdtWgEm4ApINW13HRpMj4Fo4fayps8pS9U3AloaMCy+0C4Q8lU5lZD5/EX6+GEaZ58Hpsumn5+7oYNYnEAskjK3WCboZqCxRO+Msbk1HSi8Tty3+9WcQt5evzm294nVYhdcxtD8aJoh+gYN4xgqSRy0nIspufb1mkx+lCs4r8ALOzg6w/sbZQ2TpfisClZUgh27puDMk+6XFAElYxRd3Wp79C3+eaJ7q9imO1bX2Af+bb7dSy2j7z5TrO+ejDLPR/MxhujUR9E1hHE88yyRdfrfXlPUQ6nRB6fvDXhEktaDbtub2jdo1h2F/hSU6d3Qvcfo0SNu0
 K5PWefCG
 c0Tqod6P8MevSSZ/+CpK1ctDfnCqwtndbAptyYhUZooXX9xSeGY0Q/+4CK9zEIUPU0cJ/
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


