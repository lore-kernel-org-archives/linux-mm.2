Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D348D2A524
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCFD96B00FC; Thu,  4 Dec 2025 15:04:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6CF6B00FE; Thu,  4 Dec 2025 15:04:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B841B6B00FD; Thu,  4 Dec 2025 15:04:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB146B00F4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D8D0B8172
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:56 +0000 (UTC)
X-FDA: 84182866992.14.7BE2BA8
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3963B8000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=eSho2ggg;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNLwG4v2L1DyoJKfQ+mNc2uWAgHqP8MU2WLVeU0Gun0=;
	b=u1Es/NLmEJbaCVx+Eo5c+42VieqU3P1IB9i713aUo3BgjN+8WkR2GLOzTrOJSf87sbG8hl
	WulnDJUeSxtDSuqBj2CpUd0cFbTKxeDk2b1Xf82qcet2QAPxnbI5QPC96jlac3fXsDpJ5L
	iyIXFvxMR8zCr9SsnDOzUAKxGQJpsG4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=eSho2ggg;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878694; a=rsa-sha256;
	cv=none;
	b=QT1mNgbpepJm5et/qfLKQ1Ptu07G+Sns7YsSerJoIJ/i0H0BEeuAEkHv9kBXiN39As8RJs
	s2W9ko3Io+yKsM3qv8cqANRgM8xvI+Neavwo1crjVyWoXLYUXHnbU6EAf4VDiLznPnwjl7
	757dDZGFsay8sAq8uTM6QGQ9b9hNGEM=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-bde0f62464cso1138086a12.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878693; x=1765483493; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNLwG4v2L1DyoJKfQ+mNc2uWAgHqP8MU2WLVeU0Gun0=;
        b=eSho2gggCcaIO61t+WY1peqgJjCZdfhS01HomT/UoLSYHXWQoRaIGqFao8O0XqOqFJ
         6kvFqMsRzNH6T8CxauoORKzMxGmIzEdK4qi/wJCQQHkqGGhFtICLJ+VOns3oU7L3Z2dq
         tth8t/QuJXQyP8D0Kf3iIYOeBNTM0IL0h+S4B2wrNWQl3Z8RwgS2J2ZrdNIF2MPtiI5y
         QVf4UBE/k5pih5ezNU+BevbCUGza/rKi6LyQxLSz1JWIWqOllF69GIJC5tCrCCRSwV1Y
         b5vVryOR4vlYfAi+77a+ouhONWs6Y9owJeEY4WfB2OUkQOeD3M+G15U5Z0IEcm4GD0BO
         9ceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878693; x=1765483493;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rNLwG4v2L1DyoJKfQ+mNc2uWAgHqP8MU2WLVeU0Gun0=;
        b=jTZp53PT+sFpf6LhMfXfxgKHBz275g5+HmlemTWXY/+AMNncXwowFkZehFUuH+8G6C
         R3057CNG/sHnbuM39UdQFErDi1pPHnSaZ3nO+Gfg+EbBjOgKb66RCsfvuszsG+yhbG86
         ftxFbISFYKiihRjlA+CrUBX0UEQN2abFZXpmHgHjYG72VtWVCE8Q1O6PAaymN5hcsRX0
         b3kSOppc5U8HPwl9U9IQshvselEyVdmSkb00s0HMw9DLXETgX9KV9h0SAzYeH5GRcRPT
         OchKBOblDhVuVEEXXJPlHrjtcly6BuXmKCppUGz9Myl5hze8XUJ06AgTIok98132t3Uz
         kWnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoKBhXKkm6ir2wMZSTOM1H6W9GhE6iGAOcqt3BtSqlQsmSgQjI0TlJ4scp8xKZsFaXHmyz3wpAhA==@kvack.org
X-Gm-Message-State: AOJu0YyLCJ1ven4nje3qiBqaZ0WnaKCFbOvMBSRWXC1sQwUrIqHY0Etc
	yBB9vTAarzKwIjvqQPZyyLIMp6xVtiJR7vHjmyAgCW87V4Kgzyl3EOpmGOUTLIEuSe4=
X-Gm-Gg: ASbGnctLGlihVlxNLb1H0MmFQuvJ7DrAryZPQKXk2BaMASLkGQAxAFrXDqYk1q6Q7zE
	pHfLYxQNxzWQYeflVW9pkGYvYsWh1h8yQE5r4uqm/466qzwB2YJ8uXpuGQJ7B8JyzxPKZIGTzsM
	BNDfEdn48x89wB8LDmCi9PmfFLzTsFvMIUl3T7tgQZUDjgxYAMWhlK3kZb5aUsPhDZG0tbLN5Fl
	yDtvTHxkkUel77/t19ar0rbbONTRUTSofe9K0P37m2rn+JETNicYsfveygiFuC/3ViIraSELwyZ
	h0W7hiNhp+cItHDV/CVSfpO/3gTZfokJcKdN3hqkJ7hRdYUyQxtW9GKGeDf2FzmdYO1YZHXjrrz
	H2IZuACv2aNTLRgMWEBwMVPCTRju50YkVgU0Jbc5nzHXsCSq0x3UixnSDGSG8Hic4Cb0VFZFHel
	RZTiBVDMeNiQby7zwqerOy
X-Google-Smtp-Source: AGHT+IG/Agb/f0tm4aAMPWFlo/ySSJaxYhCPhkZCo4KR1UhgAl3BeS6rOUHygUmT5B4w8bw/2ZdMpQ==
X-Received: by 2002:a05:7301:1c1a:b0:2a4:3594:d552 with SMTP id 5a478bee46e88-2ab92e85aa0mr4082091eec.31.1764878692885;
        Thu, 04 Dec 2025 12:04:52 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:52 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:16 -0800
Subject: [PATCH v24 27/28] riscv: Documentation for shadow stack on riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-27-ada7a3ba14dc@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=9746;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=GiCnSZfNClKK2CdWmrXEmd0bYUvJAFoWYsKe5kSxOSY=;
 b=eQDyw+CJmQ8c/U9pzRERkDMvAnQzWr8Y70SsEWX+L7dmLV9NxaGvj9hlh1s2HlXbuuN10HFdY
 PvN8l91sndwB8TsR3iIsnmIJbjgTjYJMe3khiAqZkbNYGG5c5ebCU9S
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: 3963B8000B
X-Rspamd-Server: rspam02
X-Stat-Signature: xiowgcoo7ywo6gh5jss49zp1b35xfkkr
X-Rspam-User: 
X-HE-Tag: 1764878694-595534
X-HE-Meta: U2FsdGVkX196Gsq5elM2ZL0TObCG8nPpv1NeHC+JnY7lni37y97pzYHCQsD7uf/oAn/HAPcV5zXjv33FPNdZOQ/ruUFawT2M55WefuWbLDjUDZ+QLI1adDH5nCptyfOmGgrizHfbME5GS8ZbxD0lU7Xjpr/xkYjhiATuBCvqDubH4eGvyVi6lvzcoSsdNPse7OvHkSLXIZB76FFUG1tarTeSyVZdzo9Rb81BpK8EpmOFk+Q+NkriAKjOt8cH21Rl3wqXYTHI6sn5SZdlkYW91k6xaM02M1vGTp25loMInko2aJ9LqM3uXOsE6MSa0kr1B787zVHt3MHODHc5AV8ffQUGsazjMpknQHY5QH93U6QGpRLqG/z9e0epohSGMWdMjLXZ+sJ5RNWn7j7QB+/iA8sQWebaq99vsjPVgFUvW2crfnmWqa+rgATh1wSLDBh0bqoFzp11mooogvtPLI8/X0l8tyxOzS9/zQXBNsN5ZhOKs0ragTkcpTuIsQ+cft/dc46E0GadvoNIH7gedVUx/+C22C/XDA5j2xR29qzeIiJ/kerI8FSIKoUEaV8847g9hJdKgMJADuG1Of7Vk8UxV7Hgci9ZzO4PLJ+23T7bU0+RJjzd9Ult9CfoZpl7hh7HVzZkz/8cqBEM1mRWal/dK3K/2hKGRBKwI3pTZ6mwK+YRp3uM8jSi7yqptchqG/7UKMY+DvWHXVs/ub4+rn3YrX1HIT6CcrTsDxBCtAaIPIx9fnFcFkZKmzK4t0IudN1oxv3DlR81dmrz29sb3I0UOtPPXmqm2/7tTdAJTbuV7uCyNgFuVxGNlESZFq+MaipBHvZ5kT1Q6CM2tsuPCVinyLTKQK0swjgC3SdJAPnN1VYqQid5YjYuAJ9UOKXBE3OhkLIdMahTUHSYkNmpEBHQTyoItR+0kgQWdxkhSwbTCw4nUxlmM2zaGLOFaUk4M1DJ290Bhr+wLIJh76Lbbjm
 oi0JtW0t
 wan/uqdHxEPqWuIj4m4Jy6alRbBpX6ORVX16jmm2timdF+4jm2Fo+fP2kiTJqNbK0+0ALzyOquO8E75fORpp6p1FtMp190hX5sx6f8i2ZOj1a2Y33A9HXKqHYkcjRj1cMJW1Ecrht6pNWzuapTPYEvL7HUKKqbYpzXhEwHh9ITnF43//sDVR5yOiupNjwwEcSmUYKcvwxc5BkAzUkEZrqe0HTX70ndL5noYgpv4kqbxLP6ijqQWduBnD3iY58t8tlLvO0YPXg6T2YSvyNB4YHHOiZLvAzMcb7p9FP6+A0KG3xU9QMCAliiDqWAMEudVHA5CcqEonqTu0flOJSccjeyB6FKOqsfd6W15VY111XhFCE7ukCvB9Nw9VTU82HbtFBcIMHuMq0AmOKZsJnmXL5hogpWm4sWoKs4jLf/IoAph2j2+FVFCiqnKE7+JFr8DfAQycYAXHCcFteOSwI3trN98J5Y6AZzc1lznbsvcdMLjPSd7h9gg9/39EuMHJXdML+PSgrzZ5xMm0PbHe+hW6MWuJ1Dv9XHxbovOL7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.45.0


