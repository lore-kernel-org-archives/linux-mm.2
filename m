Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 148C7CCF9E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD40E8E0023; Thu, 23 Oct 2025 12:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DE08E001F; Thu, 23 Oct 2025 12:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27108E0023; Thu, 23 Oct 2025 12:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8006C8E001F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40B74129D2F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:24 +0000 (UTC)
X-FDA: 84029969688.15.B7B4B2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 20FC414000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5mNhe9v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238282;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYXyYg8INKo/ygv5Vroey3GvLXgBYFXjzn+vD0qZkAQ=;
	b=GBRI1Weq4Z4ZblF0CKpUMWlg9mV/N6f78uSzDNhgd3XU8pDhL70aR5rDStfEFOW8iPgi0v
	dLvk763f5dHc0C13iMMycMHFTLK4bAc8FejzHr7VorDRRu4Ma0KH2Cgn4oiSARLGzeOqIT
	xifQ4Y1tA+Sl84/NDq4dJjJBFkyS/NA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238282; a=rsa-sha256;
	cv=none;
	b=NzvLuMxMtwQQ4h8hDU4oeE0gtA6d5JduKLGzvNXJ+iWFmQhH/gLO7/BDCpynVQgIhEd0Ex
	wVRzNZZ24dUcOgVpMrBPyN9oeGVwOlCZWWOiBYNzrWHm0+V3fSj8bhcn+NpILcGmhDAQmG
	bj2fDiFriLk8QOgxjgzztv87m/40pag=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5mNhe9v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 395D04B100;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB52CC19422;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238272;
	bh=fKwB1yva/J6Z5A9jncT1vgZQza3VT45SHzJy2KbYGPo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=s5mNhe9v8uiG7aCHJsJXoN86gDxN2N37gOi0AxCXzWj0OzrPSc7+Vm71tM5ghlXau
	 nR56J7LqVixL76nXRs5ePaqlYVYuRhH9gz7wExNxhquHn7zMVpIP4vy97cwlEQOjXt
	 JZZzm+AAH7Z6MBo68xqPAihhnTGsgpmj6V1TZxZcPMEKzfINwcNUJ5aeYSrOtV0Y06
	 id2EhaDYKTcH0dWMk/fUgSU92USM277yGGGZsHNmPKSr9h6JHzVuqDi8S2WNzgGbRU
	 rU/tK9RZXRckZPl+xi1X9niHWr8eh8l7MLh0P4gX7z/KjeRdqvDAn5QGgUj+HBbJ1k
	 N+lCdeXsMclnQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEEECCF9E3;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:24 -0700
Subject: [PATCH v22 19/28] riscv/ptrace: riscv cfi status and state via
 ptrace and in core files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-19-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=6909;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=Lgv2+2JEKJz8I+eOPU23ZhagSpES8G7xWPFmmF1jXYI=;
 b=MrU2NaznLxQUGXOIjrN5xwuNy8InrpDiQl1fcqxJb223wyqsz/U/NbY2l/rcPyAoSILgdkaNi
 Wj2wsJu/lV3B8svilZf13UnaT8h4Ub7C14JOoVPnSOHwNLU6IAzciYy
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 20FC414000A
X-Rspamd-Server: rspam02
X-Stat-Signature: 6zu79k199qz14k5x7e3tidbbxgwgr7hy
X-HE-Tag: 1761238281-750370
X-HE-Meta: U2FsdGVkX185k3llwbCiS3pfCFRfMKUsCAM9myE9E5cw7jE1HyMJnTlfTbLHOb6MqJ1ILzFliO0VB3/UINBy2zXKyRwOY5GoEyrVM5u4GTfC+fPQHLtDWFprnqRVnCjgUIgHqdEDtAjIsTrytXHYZ7egONbecEkKdyezNm2LkaXOwHhUhlNx2XQa0gQAZ281qfjkHRz3aqYUzlVPUXrCzdhrealv2N5240BVCvdFgI0DJBiKMMH0/uR8rIVCHa6X2YBOSvln2m9Ka0NJHDmOAGTc+3AaVa7WZ2H9HRgly8BclO8xLOwc/qoucARyqA/C+x8N/0Msd/YJYXrtgRvXaStwVea16rCrtW5WjkXtON8VnwsPIRrbpL1pzMgqJAwggExv6QkS3BV4zSrZCL45MJUnUvIQf7kIYI2+fVmcVQN5t051oQlFDLBZX+apesVf/G3HUaUTCR1G3RFjEKnH3ZY9lhg0zR4r4/msallOP7/r3X+0TD/57fvmGykxiwXAARPIvc+P9J6Nxx9QPCC4FTtUgunC/uHwr1OUUn8TjtKYKUyfsOMvh6nibhfhhQWTvMh1zoEPDeYJcCivGcCpAIu/BtjlqF3/ucCnSmMZmUm8Ak4UyFvCXi8QpwXCuSod5Z1VAI+Z3r0uuo076NYjepuxs94AUy144PEd8svGGXTepJTBetWL3W5a/AaQgB6KN1dbPd2SB7SZ0lnWOaHFfUz7XMkFUZi8+HHSlsPU4iJ1DoxqLW+NjCUw9JZZQX+QdFH1+x3NsnNjeJpSz5fkf2VYwKUSqU+ihafYsNTIY2wraRfm4wBqQ9YY9IdmDTNvXKzi90hZ4mseoN2kSwSEh3SVXlzGOsZwM9kWsQxhP7YaMkyhXsTPHvY90O67R3qBzN7Cs2NXgPoMLlepHBVUJUprWXq6fhsT4fjRHx80ur34bAtweboWZsqRHN2uS6Op3zn42ZPefuWn4oFgdfM
 C5qrajJ8
 FvUywiTUtlmQjcuN3EuvsvZMYxMI6MI1X3/ny7RVdXH0btVbBbB/SPQpPZfJ/FwBICWtbdo3p/H6t7beGO692Mb8MUM+T4HYd6mPU2qd76ImlpztvbHkPKho85GqG3yA95NVwV0zOPd8tk2vYY1+Th1IizocECWR6/PfFdHzlHfCgzoDhHdY9PoZuyFVWFWxzhA6pXzgYXocfbM7k4BoHWLXQv2J3gF7kToKW8qGNWmV4b4pPmsYXejrCCzg5UsYvpumdvWgWHexIDAYDXu5aeqcxLQjttTqo16ltEk+EHNk3JG57BkgQ3P5pBzI3wlS2XYVmUWzLjjktneK2DmyNO0bv1uv5H8v465RFWvxCHMqfCQ/8eiTVByhTjPuj5JRmVQd7zCF6Cv8PeEBhSCYl7hJWZdHDUFXMmWnzsssjweAiLmTrQljrVIIGLwgeQGHXqr4RVtSOwb521ztNaeOQz3YjXlWas9/dz19J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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



