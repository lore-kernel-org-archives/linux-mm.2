Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFFCCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1CD8E002B; Thu, 23 Oct 2025 12:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23CA8E0029; Thu, 23 Oct 2025 12:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00AD8E002B; Thu, 23 Oct 2025 12:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8742A8E0029
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4794C5CE31
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:30 +0000 (UTC)
X-FDA: 84029969940.13.F1DD3BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 318B9140007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qBrhla9v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238288;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8HHWeslD6xj1zXPNREJHWqOHG32Xr/Ks3wLJ2rR7NA=;
	b=0wemo2awjqMpgwCn+ntTTT+zvpSs+r0ej0hoi6fGi3hz5x44QSymtlA4qjNrcDRvtg+GcQ
	61nuE0RQ1v4czgKBzIZRHi44Y0eQgIGjV1haw2pjCQsYVcxqMLTev6ky/T0b+Kz5LcgPkv
	QtgwNfNv2YbYSMfOBYDqxBfyAdz2bxI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238288; a=rsa-sha256;
	cv=none;
	b=REFFPpv2TQRXiPzLbQns+ZCuyIsJxJZKQyx38b4eODBlHCNLHfu/gj4Mp3GMc0GoUuDEXO
	Y2KwoRMHjgwN7LgR4b19wKk+yWZqZeLbpQY7oifMcPKu5u/rK00+zrYnD+cY/X/lDKquYB
	Dtfcow2xH7FWpJ1FcmzMg+lBkBK+Z6w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qBrhla9v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 438284B1B7;
	Thu, 23 Oct 2025 16:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0ED45C116D0;
	Thu, 23 Oct 2025 16:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238273;
	bh=vz6N485yPKrgHZ+kKlWiFl6fZ4uLMzOsy4Z4Okbzjvo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qBrhla9vf2itJ6lTFhT0ci8evKqspCL7++33zzK1hSSba0wvUaWZZbPeQEWPyMvGI
	 InpklbZDgDXBMinPeetEYupksouiJ++79Q3WaEjv55PDs+WrvSSq9fPusCiy47NTZ1
	 Uztor4gQXgsOu6s/U+jVj2smXLu0yvkCGtKrEP8Qn/tyHduc/z3uAoDV0IdkEGzN70
	 W22gf5A3LMNubFYu6TW2W1vaLbD06QKvETD/Mc6AzxvDkr9K+xhxsXqUra/IYn8mgH
	 mLvngUDwEhu2aLb62XTkboP7JSENAZ5NIVCez4Yd+h7V1bLAyVkufe34dW4AwLnMi2
	 +ulN9Pj1QW7lA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C08CCF9E3;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:32 -0700
Subject: [PATCH v22 27/28] riscv: Documentation for shadow stack on riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-27-1935270f7636@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=9680;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=B2WSexk3yw/VKkukKcshyN9jkOKoLBIyBUeyBharWo4=;
 b=+ehqElqPyQ0Y1aOWPBKaB8Z0//2cF5vou6U3f395wZ9tPB9EVerbePx+WtLlZ03UCVCXTk56e
 NK7efVRmmfqBMxx+vBuY6NhxUoA1VrQxQbmzty6qltKrY60enzOTaCH
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 318B9140007
X-Rspamd-Server: rspam02
X-Stat-Signature: rnhsnp9hbx3ns5redwa15gm7azfhoj8t
X-HE-Tag: 1761238288-859355
X-HE-Meta: U2FsdGVkX1/I0J0r6ub4KQkGPiIgyXIzAKk55RugFU28wpWVPAz7tU0+NMNd2X6wsj39uySlAz77+7N6Txl9H7MpSkq0F9Z2hG9m28EmjNSwwCA4F4zgb9VLRUPKuyU0yyiijSlhSAjkMr//ProI4CYo0CBwi/g3jRzMGu6v8NugaA3bvuWhlfssuc+B3KkTuoKkIkGKEkZUhoPX+/ip6Bu5ISbHY7FqzSbS6Fu3cdsa8E9aqyUenMroPcyv5weGW0hfuQivmPytm6FvLkko+MB1YnnSEHQkIWAICP8dgArHK9JMBrHw3yme1tq7tOsf2h1PbZnTeziPkpnaTaJUb+RftulqpHaeM8fsZdhGbEFqIZdMrgyqZf/EuPDLiHWGJHSTuDixQ1qG799U/9cyqgEZBdOS++nlkijZnhncIOex0b9fhK5NpJO/WZbE3b1FfJl+1MZ1sp+CsfQwKDnBqS+W+XjocvCwIFxxSXlDzdMT9ycjIHRYyPJj113nKeDkuhe7CHIP5kdMeyvJoJBIlPi7DLanZhp84AH185XEtU4OqZhMldQWmhe6vwuKhV0uvvpTVWjoD0TCih3CziP0qW0B9CcfsSAIGgUooQZmzls/qRQK0qpjdsgHKLm+G974TR5VvYyyVE0zDggaGQZVIN6Be6Z2zV8pfb5+qRpSiGlwlx1Zoapq0Te/j6O7fxAhFtPahQz9WzMO9gFzN5oWd7tH3p1yi+/jbYZlF7zZjypsGdVFD3Raskmh/uoT2wwijvXaBjxGS+p91rMI41XBstDFcvy/cHO8K++RVpR71atJH2m9osfemTzGN2Jv/pfhMQR81uU57GKt3PKrhlxL1AsbsDzFtAVXGBOTLsFFfshZov/jk9rqdOUsjaf5lg1uzhHaSdu7TV5bGy2+CF6pZX57m8T/ClHnJQG2nAXjzhO4BGx0ZYE3YWav+fC3feC8+0rw/oCoAYGqh1hJwzD
 Dl720iwW
 nK5+vZZpqIS5TQAvtCwv7L+vzYqibSNONm5Psv7Tuh8cBN5H4/1UWMsIA8jDqkWwT9whP09tNnD57jkESAGR1q7SZdpBvzElgGj8gyqcwG5ZZ6FnyodzuOE5LEWydAeG3tXLSjiCqDoGJpkZoHy+QEd/QUlloBn5CfIknJsLUYRB+YVQ6a/hEKAtu8dGXb8M41I09OnAOIuFpxpvOOeuN7JJ3VByshUCboO4nM+GJsPVNDvJNQaN9DKg+aPEUxoIvXVl4z4xLHEva3SJBce6Txc9MiCCP8PpDQWeOGwCv6ZGG6fRbN+8AwJNR9dCetpXy8+mrkcUBWjpWeuUvPhUFSL3O/oT42tThzMsR2tAvXcHqy4Bl9ElTmGpDMYrAFFR1ypG/3mJx66uvnWYw6wusaeW8IZ8NyUCE6HLTUEKbiSKdF5xyOWNRNkxYmPw5OJZXaluqJ0mmHWlYcC7etD/Lmq8OtErIkX+ug4a3qQMsRUpnEKoI1yAu+zgMUBPv3qlSSqNaN4ENwWwipIhMq+F2CLbfVCzLXstCC1qB
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



