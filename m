Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74998D41D6B
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520C06B002C; Thu, 11 Dec 2025 12:21:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6D86B002D; Thu, 11 Dec 2025 12:21:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397216B002E; Thu, 11 Dec 2025 12:21:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DCA26B002C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED14EB7A0C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:18 +0000 (UTC)
X-FDA: 84207856236.08.522942A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E0940160017
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QvDTYDOa;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473677;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wb37FMLkaQXxCVMFZEwX1TVh0BV2pgaTlyUxUu1d/18=;
	b=ryTe1551Upwcp/MJTVZQ2G/2dSBAGgF5eTbUATW6MhAlaDjrQwgOiWT7ZL/L2pkousv8Yd
	AJ6K2jU/0MzBg0ljZhMdehchK4ny51W7UJ2Xbz+trXHdbIyH5hoqy/8RZ55o2VieEaueNi
	F3WNyRTNQ6cffvjEjqdjHCK4a7ftqE8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QvDTYDOa;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473677; a=rsa-sha256;
	cv=none;
	b=ta6LFGe85my8jgttKXCGjI2nYFeZKzbPYF3nLJmGSv272Gd3WQSeNiBFoPBN7qYU/OkCY/
	mdKUI/piPpiy3FEBbRllTj9os7RFEBdqep8MuctgZCF96jsL9IngI6pAxYCScJMR8JkUh7
	H2Qb07UqxyT6oGS53uITz8qmAAkh1nk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9234E44535;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64162C2BCC4;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473668;
	bh=xfwJUJCS9ahUKRHEfClfGG0LuGhQf8NoNaPkmhQ2VkA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QvDTYDOaI7TLzIL9lrMiYJ5MbMdpjTg9PuGRBnFdkKH/Xwpbu2wtz96zobaOM3qqA
	 0D/mZ9wmLxZRkHBTNiU5jhFlrsY8dT08neY7AKBMcHeTY64jK0XXVHgogurr7tg/qM
	 LA/iKs9CUPnpNLRiOKq3Z9QgOyL3Exd7Y/7E7GbZoycUPK2rncbbP+P66H3zGLDKIK
	 7TX+xJnNbPPfSJ/f/M1sGD0gZM0fYp4hITQcHZt0P6HtKgaHUSMkxZE2w9fD9SYx8f
	 3M7je/G70NfTTmbfVTOJ2p+qbjtpxJ3kxG2GJsqDsduq6r1t1UjaYrdB7wM6skGBhO
	 idX9b1gQtuq2w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547E9D41D6D;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:52 -0800
Subject: [PATCH v26 19/28] riscv/ptrace: riscv cfi status and state via
 ptrace and in core files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-19-f0f419e81ac0@rivosinc.com>
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
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=6975;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=siKwPR31oz9T4kYUtjhttp1qlTcRSvwTqe1aSlr2SaI=;
 b=QssvHjRWX1HmLdPIA1yJVYcYFoA0Cg8bgNpiHhgRTJptLS/eh0fQT2denRzzSDJuFjCp5ins2
 GIXIEIa+smXCC7SYPAaPx6ZRbk2cAYCNy9Yp1k40yKrR9O7IMe7xBXp
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: qhicndg67nczxho7ogtrynof3oxujzuh
X-Rspam-User: 
X-Rspamd-Queue-Id: E0940160017
X-Rspamd-Server: rspam07
X-HE-Tag: 1765473676-318610
X-HE-Meta: U2FsdGVkX1+aTI157vnod3kFkIkoaMBnrftrWVF51gWnr2caTOThs7NRpa4kAqTCnYV6ZTFEXzXsj/jJP1n0RDtV4S/Q3cl/GWfebOcU/lgm8qSD/qG2byIeyCs2K5gwB0H73r61Vfkq5JH3MoiKR0cis6YxrUfNwmtR24V+8/+QaFwPlEAsixHxTNabn3UtJjeLZgP5LxBv6h29B/IdiAkYyA0IJ+4E5ITfzVOTcBK4xyrJn/y/kozv3yvDWcecEwFnO35woP+myyzk8dQ7P13kXvZJIasRlA5qOiWDva70km2eXLFoOygkzP/svIYdQmCLwohRs+2fzSx91E2eZv+OVDnS2WIj4xMQTXYmj2GPdH724HtJkkb1F8B1UPzdjHFW4rjCB5AUfw6i7Ex9boQLHzes+8lQnQgDmtorlTIWfY2SFRC/vbS39vO/dK5moyTkDa9d6ktyQ4bseZlCzhMftKCm/w++slw+F1K+K60ut7WY7K1/CD0/6exb2DIm9yJsBEDsy9NWz8SMUU0A4GqyrVTImwbY+Y/sxhhv6jSzGKGZDAjcmwggTEc1qxp/HeEl6eBLYQPqRS9wDU/Ovh6Q2iaTO28/rY8mTDTwNA7z2QF/hg7XcKfNKvwp3UuAFmN1Lp5ZsagSClRdJzDdaCjVBCue0gmjiYObRS+NN7o4RBP6TR43Y/dmMEqoeNzw2t+GQ9iLC5DSpU3EK2seMdp3M71nLbMc9zk5KdQvSUywlKfzxAcuUXQ4zXvw8sQeOh6mM17rbPcaZVCb7LdRMFpwAKh86zvRFTUpQvlJqRU3L7f8vJ78DtnXY+HwCfgxOKDoRlQRL+w6pKG03g7FmR5DEDsQNI9N66hbeI7tjjgqn47DWfZXFWHgyPM71Y+Gg9/lyQrCH/BwK6SKUfcXK9tmpqpVoglRilJrKc/h4+ihsYo4Fm6FKK7oVtEA+paKMAUsEjP25vCVOB28Tpj
 TqSMgghr
 49rUdv0pGslulM6y8gQeqUV4KApyA34XzuGM0ndJTlMdHk18mbxYNYMsD2X0kTUZUCjMKndaRhp14GJQvETL3oY8bX0U7u+FxOTORD76BAUqqwFeogY+7uNVNm4nuvQWxrnqPG0HHNDgUuXG8/h16kr1UgTI/KgjuLGufjOMrIVUDXAjV1m6wQ9Z63ybt2/yrxcPhVcHy6FJpnFcq1366M3JcMZ+NXXGEv9VcaNRDdgMZwBkuCBXJYnmOSNCcveu65drf5XHbKQ/NgoPVsyxI1yfuI9JD1tiIMLrYg3Iq2wt5khhSEuWSNE39L465w708+4VSIxjzjFR2xkRnBBge2jSs9PjcqKL+OLpONYmseoepyZvvZWvzMN1tw5ZTePcpc2smYL1EgJASZXIxzkTwVYOQAp23ConbbAyu+5nA7efMefzQRXCc/DnfBVIbrf2oYZKpZkFLiGy/y3G9XfHm8VY24sv7tuRbPm6m0MpMCvJ0g8R+h/jFyYyPn2cjutKniMRx1huQBqtRQz1q5QmPL9AZi/0ycF9UGsl2
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

Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



