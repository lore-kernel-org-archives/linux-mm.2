Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A33BDD41D6B
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96306B007B; Thu, 11 Dec 2025 12:21:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49EA6B0088; Thu, 11 Dec 2025 12:21:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B113A6B0089; Thu, 11 Dec 2025 12:21:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9F16B007B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73F7A1A027B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:23 +0000 (UTC)
X-FDA: 84207856446.07.676E761
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7502840019
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I5KNOxZl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473681; a=rsa-sha256;
	cv=none;
	b=F96nGbvuaXXVtTtloh6bRpd20HgDpml8pR8jvCX6VVoxL3c9L4FXQYiX/nEmIWLxUnC6sq
	d6mpU7vywpGnHiPjJ5JwxYBEyD1IYpMfLsfrFCVY8xGD6MASne42HEaBQPnt4LAuD1cRay
	/xxr12g9Q1BD9tb9FvpDDIGvU5jBI28=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I5KNOxZl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473681;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUyu0Bsvs+ejfvbMVuIeKEoFBGMTpbE4PscppAJYZ/A=;
	b=zoWW6yzx2e0p/BB6ydOa6+Wsc9DgwLVgf8LkefUxF0yMzfOOu37LQT+6wwb/Wieb2n/E2T
	r3242LtVMcDVU9bPTRWoJw2qfvMDo62ZxycFRt9MXoj8s6kqgAD7l2Gm0k1hkL7JHmu8nB
	np4VQlexCeSBjN0kVK6yHJKJAtEzGuE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DE7B4459C;
	Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7455EC4CEFB;
	Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473669;
	bh=SRDdTPo45Eh4KAhtLdSMyTcxO3kIazO1CNVPlhVQPIY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=I5KNOxZldRxvxNhWF3bf0fPuyn7Qy3/mBAfHAhZVevE86GDlX4BfmfgVJCW85itco
	 KaHGPPOQ0DZ+bkQR+TM3UYR7ySqR8k226h/aJrC9Hx1UIKrtE6pzr7TBx9UnbSxRRp
	 eS6e5rNYmlPPomXWoImoDvVQj0GTnITTnIiL3N8TPzO4Hq9HwMjRcPM4VAWHcuV2r/
	 VpAz63zYiwiHI2PPxUzAgHXnXreAJZiX2HGJgZIcgSZx3RL15canZTWgK0H8r8FAnc
	 ruO/jGhFPkyQGCvm7MF9KnsPBPivJ14I+I7EjPMJgVxN6aVfjXydGCT8K97iWPsbaW
	 3Vzmiuqah2WOQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686EFD41D6B;
	Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:21:00 -0800
Subject: [PATCH v26 27/28] riscv: Documentation for shadow stack on riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-27-f0f419e81ac0@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=9746;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=dl8IGrDyRpX9wV0qapA7pYJaY0jITlk53J3uwRpcyyU=;
 b=Iqbj+tLJFOqD3MYKns4h2eq1JCMKgH+UoLdiHY9gKCgVu1wqxL0pIUFnkNxw1riIeos5Z7Qnt
 w7soBvJLz88COmFNczKaq37vHjuDajQb8YpbfHHaeXOJzMJIrMPp/aK
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: s8a7cquhwg1gu73kur5w11dekcmpr7uk
X-Rspamd-Queue-Id: 7502840019
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1765473681-929241
X-HE-Meta: U2FsdGVkX1/4+LhO/9C7m7jPWmJw2W0G5Gk+/gnCSjrUDL9COtIqKiRYxt0qQqh8+Vh5iF0WFRPgmWWJSIWsDhZSQXLmB/bfSlPalH2tqG7K7FoH5tVcyw5GPgMYD8Ekvh4sca137c3h7dA9kU/oPNTd0sDGtE87uNgG+k6phTlobE2aJ/odydN+izRHXX+PoNjZ6Ivydz0ueTs1hVVRGUYaQe3/ut22vZrCe+QMRy9OkTHVQqbpbLwSitghmRFvsdG5oDTEnC2RNjRZL58N7jlPcou66mzV3PTAxohYCVINwVen4LAC4qTj+7aBl4EDlRETk0Blrt6dk32CE/V35AMAaqKFbEnDnJoUa1qltGnU4IhbyGTv4VbB3xKhTHdZx3T0MgI9yt6LdmBbjpEZNDlSfWvGmmk37i9KTgBQ9M3zT+Ni/sPqOi43WeOSFPudyHSE+kXITdM3nOvHmN06KP7PUyZLtVz65YO3kJbTZ298Ql7dCjricFNiC50ScYZANRM/BYfTuBMaa3YRtNFu6bNPZ7pl1V/wcoxjdpCFQUn0dT6pfx8GvRToVXVHvsyibzuN1vlm453CYTEAtJsOoqItBmJemSZXkSJJj5L/TQ9xYcSW4bJnTzP7iRPP5jtlVejb3UHpN32iKJ3Kbp1r5EGEtNDVkYwKv8J1ylbmtigr8/h2RRwDeZetwQD0A0USU5EflFHk+0nB5JRLDpUxNCXxUUmxda+6EndELJarFU3/DSaEYXseWp0vlDpynHBlRc/gqzfoBO0Jq1mF6ESQpWcO8mdWRLEOSUhuEedrgZCqrVyVQRAz3B9J6oJ9vpiUSeqtk8jzMgEjVfvkgRsBthcZSnVpVSKlWsR3t72P6ii3FnThOYxTHnzjnDrDtwAi8CSpjCVpuEUxdy+tnG2nhLR/nWZEdnt3jAp1JpQQiDr3NwrF416K/BiphJWS1VNqQsm9zLK5sKNCHahgE0V
 Ho11/Shj
 EJ+ovYg/LDw9ilO2q64mCku7/khwKMB3/DO1I74lEfhQaS06AZ+oPyOJ1L8uPmB8oz1NOGBCd6zjI/N+iQJoS79EgPDxXj5lqWXeFdeR5EFcHzORO82rl4eQ/weVIfPOprcEHOCVCf2JuVCOzK0fUlAyGxE0ouHyOaf+wfPith1NfCCZ7dV3qKe1rrRkMgy0AFAJPFdOIvcPz68xdv/55cnBA2OrJ7WsogL5dVxhTJQ4tO7JdxI3Wos9KAQOMxXkkezSUXgJgC5OYu1knBglMY1UgNvdiI4NqwReUUU4b6GIh1onZskVv3oSmlPY63fpce1VpbkuVW0mVUyekoqfFo0ViUxCF/pmbPceoftrkk+3dW3O4gcR/p952dYKecMC7uvC630W4U++yHoKq0jvDbl5Jd1UErmKGl1BginnNyyHshAfl8sU1Y1gXJ1eqrVC709aPsxg+qbnRofnRP+5DodXPnlmbVEXXpH3DxOnHyH6iOOF/HYvbfYj2VMCb43dbkxStv4/+7eCt7Su986+dcrstocdzhhG4P/Q9YpYUTEDz9p0RHrRXpW3PwLAV1RXnN+6qUMwHyUwccuT7WDhr68EZRexMRWiSC0Gt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Adding documentation on shadow stack for user mode on riscv and kernel
interfaces exposed so that user tasks can enable it.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 Documentation/arch/riscv/index.rst   |   1 +
 Documentation/arch/riscv/zicfiss.rst | 179 +++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+)

diff --git a/Documentation/arch/riscv/index.rst b/Documentation/arch/riscv/index.rst
index be7237b69682..e240eb0ceb70 100644
--- a/Documentation/arch/riscv/index.rst
+++ b/Documentation/arch/riscv/index.rst
@@ -15,6 +15,7 @@ RISC-V architecture
     vector
     cmodx
     zicfilp
+    zicfiss
 
     features
 
diff --git a/Documentation/arch/riscv/zicfiss.rst b/Documentation/arch/riscv/zicfiss.rst
new file mode 100644
index 000000000000..7fb86d5ba120
--- /dev/null
+++ b/Documentation/arch/riscv/zicfiss.rst
@@ -0,0 +1,179 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+:Author: Deepak Gupta <debug@rivosinc.com>
+:Date:   12 January 2024
+
+=========================================================
+Shadow stack to protect function returns on RISC-V Linux
+=========================================================
+
+This document briefly describes the interface provided to userspace by Linux
+to enable shadow stack for user mode applications on RISC-V
+
+1. Feature Overview
+--------------------
+
+Memory corruption issues usually result into crashes, however when in hands of
+an adversary and if used creatively can result into a variety security issues.
+
+One of those security issues can be code re-use attacks on program where
+adversary can use corrupt return addresses present on stack and chain them
+together to perform return oriented programming (ROP) and thus compromising
+control flow integrity (CFI) of the program.
+
+Return addresses live on stack and thus in read-write memory and thus are
+susceptible to corruption and which allows an adversary to reach any program
+counter (PC) in address space. On RISC-V ``zicfiss`` extension provides an
+alternate stack termed as shadow stack on which return addresses can be safely
+placed in prolog of the function and retrieved in epilog. ``zicfiss`` extension
+makes following changes:
+
+- PTE encodings for shadow stack virtual memory
+  An earlier reserved encoding in first stage translation i.e.
+  PTE.R=0, PTE.W=1, PTE.X=0  becomes PTE encoding for shadow stack pages.
+
+- ``sspush x1/x5`` instruction pushes (stores) ``x1/x5`` to shadow stack.
+
+- ``sspopchk x1/x5`` instruction pops (loads) from shadow stack and compares
+  with ``x1/x5`` and if un-equal, CPU raises ``software check exception`` with
+  ``*tval = 3``
+
+Compiler toolchain makes sure that function prologue have ``sspush x1/x5`` to
+save return address on shadow stack in addition to regular stack. Similarly
+function epilogs have ``ld x5, offset(x2)`` followed by ``sspopchk x5`` to
+ensure that popped value from regular stack matches with popped value from
+shadow stack.
+
+2. Shadow stack protections and linux memory manager
+-----------------------------------------------------
+
+As mentioned earlier, shadow stacks get new page table encodings and thus have
+some special properties assigned to them and instructions that operate on them
+as below:
+
+- Regular stores to shadow stack memory raises access store faults. This way
+  shadow stack memory is protected from stray inadvertent writes.
+
+- Regular loads to shadow stack memory are allowed. This allows stack trace
+  utilities or backtrace functions to read true callstack (not tampered).
+
+- Only shadow stack instructions can generate shadow stack load or shadow stack
+  store.
+
+- Shadow stack load / shadow stack store on read-only memory raises AMO/store
+  page fault. Thus both ``sspush x1/x5`` and ``sspopchk x1/x5`` will raise AMO/
+  store page fault. This simplies COW handling in kernel during fork, kernel
+  can convert shadow stack pages into read-only memory (as it does for regular
+  read-write memory) and as soon as subsequent ``sspush`` or ``sspopchk`` in
+  userspace is encountered, then kernel can perform COW.
+
+- Shadow stack load / shadow stack store on read-write, read-write-execute
+  memory raises an access fault. This is a fatal condition because shadow stack
+  should never be operating on read-write, read-write-execute memory.
+
+3. ELF and psABI
+-----------------
+
+Toolchain sets up :c:macro:`GNU_PROPERTY_RISCV_FEATURE_1_BCFI` for property
+:c:macro:`GNU_PROPERTY_RISCV_FEATURE_1_AND` in notes section of the object file.
+
+4. Linux enabling
+------------------
+
+User space programs can have multiple shared objects loaded in its address space
+and it's a difficult task to make sure all the dependencies have been compiled
+with support of shadow stack. Thus it's left to dynamic loader to enable
+shadow stack for the program.
+
+5. prctl() enabling
+--------------------
+
+:c:macro:`PR_SET_SHADOW_STACK_STATUS` / :c:macro:`PR_GET_SHADOW_STACK_STATUS` /
+:c:macro:`PR_LOCK_SHADOW_STACK_STATUS` are three prctls added to manage shadow
+stack enabling for tasks. prctls are arch agnostic and returns -EINVAL on other
+arches.
+
+* prctl(PR_SET_SHADOW_STACK_STATUS, unsigned long arg)
+
+If arg1 :c:macro:`PR_SHADOW_STACK_ENABLE` and if CPU supports ``zicfiss`` then
+kernel will enable shadow stack for the task. Dynamic loader can issue this
+:c:macro:`prctl` once it has determined that all the objects loaded in address
+space have support for shadow stack. Additionally if there is a
+:c:macro:`dlopen` to an object which wasn't compiled with ``zicfiss``, dynamic
+loader can issue this prctl with arg1 set to 0 (i.e.
+:c:macro:`PR_SHADOW_STACK_ENABLE` being clear)
+
+* prctl(PR_GET_SHADOW_STACK_STATUS, unsigned long * arg)
+
+Returns current status of indirect branch tracking. If enabled it'll return
+:c:macro:`PR_SHADOW_STACK_ENABLE`.
+
+* prctl(PR_LOCK_SHADOW_STACK_STATUS, unsigned long arg)
+
+Locks current status of shadow stack enabling on the task. User space may want
+to run with strict security posture and wouldn't want loading of objects
+without ``zicfiss`` support in it and thus would want to disallow disabling of
+shadow stack on current task. In that case user space can use this prctl to
+lock current settings.
+
+5. violations related to returns with shadow stack enabled
+-----------------------------------------------------------
+
+Pertaining to shadow stack, CPU raises software check exception in following
+condition:
+
+- On execution of ``sspopchk x1/x5``, ``x1/x5`` didn't match top of shadow
+  stack. If mismatch happens then cpu does ``*tval = 3`` and raise software
+  check exception.
+
+Linux kernel will treat this as :c:macro:`SIGSEGV` with code =
+:c:macro:`SEGV_CPERR` and follow normal course of signal delivery.
+
+6. Shadow stack tokens
+-----------------------
+Regular stores on shadow stacks are not allowed and thus can't be tampered
+with via arbitrary stray writes due to bugs. However method of pivoting /
+switching to shadow stack is simply writing to csr ``CSR_SSP`` and that will
+change active shadow stack for the program. Instances of writes to ``CSR_SSP``
+in the address space of the program should be mostly limited to context
+switching, stack unwind, longjmp or similar mechanisms (like context switching
+of green threads) in languages like go, rust. This can be problematic because
+an attacker can use memory corruption bugs and eventually use such context
+switching routines to pivot to any shadow stack. Shadow stack tokens can help
+mitigate this problem by making sure that:
+
+- When software is switching away from a shadow stack, shadow stack pointer
+  should be saved on shadow stack itself and call it ``shadow stack token``
+
+- When software is switching to a shadow stack, it should read the
+  ``shadow stack token`` from shadow stack pointer and verify that
+  ``shadow stack token`` itself is pointer to shadow stack itself.
+
+- Once the token verification is done, software can perform the write to
+  ``CSR_SSP`` to switch shadow stack.
+
+Here software can be user mode task runtime itself which is managing various
+contexts as part of single thread. Software can be kernel as well when kernel
+has to deliver a signal to user task and must save shadow stack pointer. Kernel
+can perform similar procedure by saving a token on user shadow stack itself.
+This way whenever :c:macro:`sigreturn` happens, kernel can read the token and
+verify the token and then switch to shadow stack. Using this mechanism, kernel
+helps user task so that any corruption issue in user task is not exploited by
+adversary by arbitrarily using :c:macro:`sigreturn`. Adversary will have to
+make sure that there is a ``shadow stack token`` in addition to invoking
+:c:macro:`sigreturn`
+
+7. Signal shadow stack
+-----------------------
+Following structure has been added to sigcontext for RISC-V::
+
+    struct __sc_riscv_cfi_state {
+        unsigned long ss_ptr;
+    };
+
+As part of signal delivery, shadow stack token is saved on current shadow stack
+itself and updated pointer is saved away in :c:macro:`ss_ptr` field in
+:c:macro:`__sc_riscv_cfi_state` under :c:macro:`sigcontext`. Existing shadow
+stack allocation is used for signal delivery. During :c:macro:`sigreturn`,
+kernel will obtain :c:macro:`ss_ptr` from :c:macro:`sigcontext` and verify the
+saved token on shadow stack itself and switch shadow stack.

-- 
2.43.0



