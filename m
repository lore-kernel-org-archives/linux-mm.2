Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 424CBD339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66EA6B002D; Fri,  5 Dec 2025 13:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07F66B0031; Fri,  5 Dec 2025 13:41:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9B46B002F; Fri,  5 Dec 2025 13:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93E726B028D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DE1E1A026F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:59 +0000 (UTC)
X-FDA: 84186286758.22.813AA2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 52F624000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qHf2Fs9H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960117;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYQCaogP1Esx6vaJsC/4o2UG7lEx16aXFTaBTkgr6JM=;
	b=Oz/uOhlS8pWZPcvAQQ/V9d3fru8Lo7a/mJkWyL8wXEzdpjJ3LZgdyTvpFQdnTA+wcG/G2c
	CK5HqpOE6+3fdgdvDEoyvFlhg+iF5h7pqtvCRUxwmhiuD/dNJLsqJjDvEi6+2viXOqjxzQ
	jNiv1Dw5oQokhPrFmDHeeMAeGx58pMw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qHf2Fs9H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960117; a=rsa-sha256;
	cv=none;
	b=w58Wtlp54MdV5o3REz/YSY77OZNwZwTdPromjHiyf2xKiMqWHH2YC6JkLCLo0Rvi3uecbw
	k2KZZSQ2z2j9pcDh3W18SJUM1X/Nm1yNEE0CBIZhLrAEIfSdNtbMB+JqxXqyAPEEgesmFg
	cQ91ebXBx2cGW2Qvcfu+F0qFn9dA27I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C57744562;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11A04C4DDE9;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960111;
	bh=YQg+XVHKEI/+k3SQ8JtN+2+b+t7JDDMJ08bQo4q+FJs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qHf2Fs9HeKiYvgNirXB8qle6VBZDbivLzqGw08CCA9ObjrDSP3VX8dR0xOZ88I+zi
	 olpiool2K8FtajiAuIlifALoXiHHLJQyyVUI82VIDf0RU3H8pY7RAotgrdULChCtIp
	 W31bsghz2Lo6g+ISIQXBL/xYO74cq3uRYBj2FLJa6BWtYXejQCR/pSLr8JyLbMM9E4
	 4L+/njrEjelaJ9WTf7tEZHBqvqquB+5ZvvV0uXMo4HNqIMzMr1J6fArX7Ix03w/DXT
	 SE1HXyhCHitL8krzHcoy9rW2S+d8A044wrnLXa23hEdiOcSOG85G5evWs7NqFm8Svz
	 lYc4oL6K1x+wQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE88BD339B7;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:50 -0800
Subject: [PATCH v25 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-12-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=7555;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=j8/8VvndI2qVQcHHX8TNZcByjmD2v9rRKoH3o+WjKYE=;
 b=yQo8xKfVejFOjeVogC+WjDAl+HIeSNzjrEq8DlGeKyZ1V0haFF+sZkhFWybxOwapnhbdvfCMk
 mmii7UZuUxpCNnGox14m2GjNjZxdNR65/SIONzNQGakGA912RgJLeGo
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Stat-Signature: hdx3scba5sje7cdxuerdbyyma433gpi6
X-Rspamd-Queue-Id: 52F624000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1764960117-392026
X-HE-Meta: U2FsdGVkX1/+5jfB5RHMZHyDKgte40UCBf1wuvCRqM5gUt4wDRtU/+bNE6vPrUR/yZo2VK1bA1lZhq/9Pe8iVGBvsMin0iLUAd1s0z7IyERbDJLhdc8+wohujU3gwtQRmo5zzS8snY/Jx3TSWc7G3ra0x331ewbQjL3Zn1RS0eLYjgeIN5q+vqKz6oINUwILwqS7dpa0gZAZQMtT8pOj7EUOQqv+sEdMsL1ONJVdFwqVbAK9SwhADk5jC1zRQQCyQi8qbBEOXsZUnZj1brG4y0j9s9PKI5SkpMWTUFXznDfFr1isuKEi1ANwgeAscG9KmtvOfg7O2DdcawFPRUqD3m9mGiTO6fOLZTWLDPey4y5qrn5wu6OgLhRTpamcv9CExfq86mWfLiwuRkiXU7R4nKH7Q9uEDeDzK/tpA5RPBE2dOrizdD4umIj1+dYDOe+BM7EiA2rD6pBFGEOn8Rrolb+9KSTX+7diwaVz3btrpXVx2vd9gUwLID4cCQvxW3NwDPrmUyM8/CS6sD+yvnJkrAznWDsRafbH7eZ1EuNTIHw5zKoLVUO1joVpIhJpOeNTow6wLaKx1SlUxp+oV0bVrCvcWGSk0mwYI54rftc0t5w2hph6BgdzPlA4+hbDaYsaNP0yreCDGJHVomdUpGrc9D9NZlP5p5axPfqJE+cLQuFWn6l31x8vExTYuc/bBQNsVhTIT3aqc5wARt4SC+PQDO49REsNQFD9sqLVC6Mizfewkz6PWeFR3mmticRwB9y7QcWohI6I6yFrs2BTtEDZNZp3dHUWcDbNsRw+po7PK9MDe55PHoDjlonNRUCtwotliELxH0NXVWlo8oto480gdsKmkZ66eqX7KNCyud0PnjFwze4RsWfOkrYSi2pGrnETdWEv/jau5dcGkRcCZtNTJKzVa0Ly2l5Zc4F8CzcRFBmGxda1jcgWBCB8BBbeMgFcCEUbKbTY/gYf/Tr3UE2
 WLuJyyhq
 4SE2MBOu2zN6aMo+BxAX6wOhGA6y+PODWG89hXzMZpeNYqdxOpLTQUodLYk9glVS8X93BQy1Kj00Jv7AnEfpa6esht6gcr2du4wwycdJTTXHzPsYuCyoi7KRg381Wx2egSGAS17vuCU3h7zQIePlMcMIsUHlOnCjnh22TIisuBHw0Pru2WugSy1NVAA8TQv+2IlNnMDFlT/4w+5gzApZrHedfca9n9L8AnaO1IMz0enwTZlL+ME3eXEF8XES79yoCWK06Eye5XoK034mggg+IeBnXdj/300dVmPITFySeODL07zrTqdVQk1D/LgFiHHe+VPKjaVRsDwdotGDMsNWcPA/EAKYALAYBtaaH+AePtAeEXAocZK4N7zGAgYNPIXrzsVk0fD7qte0auHC9DRml7DqMYM+hwZRfXBIPY2ixkpC728j6sovMyf7zpJ//2saAzcm5ZvjXXkZ+1alkHZeHVtvMFLRdevbPRbh4J5BvcMZSnAVBAPHqvLxZ+hbdjJNlIRnF9XCrSH2c8MWGTU3K6Slj1ULC6toFWrNiNzsmgaRjxw11f+L6W+WVnWPyAuBTFcanegpurd+/ojyH0Mk0vfCQxjEQkiKCCv8q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Implement architecture agnostic prctls() interface for setting and getting
shadow stack status.

prctls implemented are PR_GET_SHADOW_STACK_STATUS,
PR_SET_SHADOW_STACK_STATUS and PR_LOCK_SHADOW_STACK_STATUS.

As part of PR_SET_SHADOW_STACK_STATUS/PR_GET_SHADOW_STACK_STATUS, only
PR_SHADOW_STACK_ENABLE is implemented because RISCV allows each mode to
write to their own shadow stack using `sspush` or `ssamoswap`.

PR_LOCK_SHADOW_STACK_STATUS locks current configuration of shadow stack
enabling.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h |  16 ++++++
 arch/riscv/kernel/process.c      |   8 +++
 arch/riscv/kernel/usercfi.c      | 110 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index a16a5dff8b0e..d71093f414df 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -7,6 +7,7 @@
 
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
+#include <linux/prctl.h>
 
 struct task_struct;
 struct kernel_clone_args;
@@ -14,6 +15,7 @@ struct kernel_clone_args;
 #ifdef CONFIG_RISCV_USER_CFI
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
+	unsigned long ubcfi_locked : 1;
 	unsigned long user_shdw_stk; /* Current user shadow stack pointer */
 	unsigned long shdw_stk_base; /* Base address of shadow stack */
 	unsigned long shdw_stk_size; /* size of shadow stack */
@@ -26,6 +28,12 @@ void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned
 unsigned long get_shstk_base(struct task_struct *task, unsigned long *size);
 void set_active_shstk(struct task_struct *task, unsigned long shstk_addr);
 bool is_shstk_enabled(struct task_struct *task);
+bool is_shstk_locked(struct task_struct *task);
+bool is_shstk_allocated(struct task_struct *task);
+void set_shstk_lock(struct task_struct *task);
+void set_shstk_status(struct task_struct *task, bool enable);
+
+#define PR_SHADOW_STACK_SUPPORTED_STATUS_MASK (PR_SHADOW_STACK_ENABLE)
 
 #else
 
@@ -41,6 +49,14 @@ bool is_shstk_enabled(struct task_struct *task);
 
 #define is_shstk_enabled(task) false
 
+#define is_shstk_locked(task) false
+
+#define is_shstk_allocated(task) false
+
+#define set_shstk_lock(task) do {} while (0)
+
+#define set_shstk_status(task, enable) do {} while (0)
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 72d35adc6e0e..a137d3483646 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -156,6 +156,14 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->epc = pc;
 	regs->sp = sp;
 
+	/*
+	 * clear shadow stack state on exec.
+	 * libc will set it later via prctl.
+	 */
+	set_shstk_status(current, false);
+	set_shstk_base(current, 0, 0);
+	set_active_shstk(current, 0);
+
 #ifdef CONFIG_64BIT
 	regs->status &= ~SR_UXL;
 
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 872e0c52e034..0b77b812e4d7 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -24,6 +24,16 @@ bool is_shstk_enabled(struct task_struct *task)
 	return task->thread_info.user_cfi_state.ubcfi_en;
 }
 
+bool is_shstk_allocated(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.shdw_stk_base;
+}
+
+bool is_shstk_locked(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ubcfi_locked;
+}
+
 void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size)
 {
 	task->thread_info.user_cfi_state.shdw_stk_base = shstk_addr;
@@ -42,6 +52,26 @@ void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
 	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
 }
 
+void set_shstk_status(struct task_struct *task, bool enable)
+{
+	if (!cpu_supports_shadow_stack())
+		return;
+
+	task->thread_info.user_cfi_state.ubcfi_en = enable ? 1 : 0;
+
+	if (enable)
+		task->thread.envcfg |= ENVCFG_SSE;
+	else
+		task->thread.envcfg &= ~ENVCFG_SSE;
+
+	csr_write(CSR_ENVCFG, task->thread.envcfg);
+}
+
+void set_shstk_lock(struct task_struct *task)
+{
+	task->thread_info.user_cfi_state.ubcfi_locked = 1;
+}
+
 /*
  * If size is 0, then to be compatible with regular stack we want it to be as big as
  * regular stack. Else PAGE_ALIGN it and return back
@@ -260,3 +290,83 @@ void shstk_release(struct task_struct *tsk)
 	vm_munmap(base, size);
 	set_shstk_base(tsk, 0, 0);
 }
+
+int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status)
+{
+	unsigned long bcfi_status = 0;
+
+	if (!cpu_supports_shadow_stack())
+		return -EINVAL;
+
+	/* this means shadow stack is enabled on the task */
+	bcfi_status |= (is_shstk_enabled(t) ? PR_SHADOW_STACK_ENABLE : 0);
+
+	return copy_to_user(status, &bcfi_status, sizeof(bcfi_status)) ? -EFAULT : 0;
+}
+
+int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status)
+{
+	unsigned long size = 0, addr = 0;
+	bool enable_shstk = false;
+
+	if (!cpu_supports_shadow_stack())
+		return -EINVAL;
+
+	/* Reject unknown flags */
+	if (status & ~PR_SHADOW_STACK_SUPPORTED_STATUS_MASK)
+		return -EINVAL;
+
+	/* bcfi status is locked and further can't be modified by user */
+	if (is_shstk_locked(t))
+		return -EINVAL;
+
+	enable_shstk = status & PR_SHADOW_STACK_ENABLE;
+	/* Request is to enable shadow stack and shadow stack is not enabled already */
+	if (enable_shstk && !is_shstk_enabled(t)) {
+		/* shadow stack was allocated and enable request again
+		 * no need to support such usecase and return EINVAL.
+		 */
+		if (is_shstk_allocated(t))
+			return -EINVAL;
+
+		size = calc_shstk_size(0);
+		addr = allocate_shadow_stack(0, size, 0, false);
+		if (IS_ERR_VALUE(addr))
+			return -ENOMEM;
+		set_shstk_base(t, addr, size);
+		set_active_shstk(t, addr + size);
+	}
+
+	/*
+	 * If a request to disable shadow stack happens, let's go ahead and release it
+	 * Although, if CLONE_VFORKed child did this, then in that case we will end up
+	 * not releasing the shadow stack (because it might be needed in parent). Although
+	 * we will disable it for VFORKed child. And if VFORKed child tries to enable again
+	 * then in that case, it'll get entirely new shadow stack because following condition
+	 * are true
+	 *  - shadow stack was not enabled for vforked child
+	 *  - shadow stack base was anyways pointing to 0
+	 * This shouldn't be a big issue because we want parent to have availability of shadow
+	 * stack whenever VFORKed child releases resources via exit or exec but at the same
+	 * time we want VFORKed child to break away and establish new shadow stack if it desires
+	 *
+	 */
+	if (!enable_shstk)
+		shstk_release(t);
+
+	set_shstk_status(t, enable_shstk);
+	return 0;
+}
+
+int arch_lock_shadow_stack_status(struct task_struct *task,
+				  unsigned long arg)
+{
+	/* If shtstk not supported or not enabled on task, nothing to lock here */
+	if (!cpu_supports_shadow_stack() ||
+	    !is_shstk_enabled(task) || arg != 0)
+		return -EINVAL;
+
+	set_shstk_lock(task);
+
+	return 0;
+}

-- 
2.43.0



