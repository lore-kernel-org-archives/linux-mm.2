Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691FECA0EC5
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A156B00C3; Thu, 31 Jul 2025 19:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAFF6B00C4; Thu, 31 Jul 2025 19:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943AE6B00C5; Thu, 31 Jul 2025 19:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3E86B00C3
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09A61140C83
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:38 +0000 (UTC)
X-FDA: 83726131356.14.E087E87
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3AC2A100002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=l7i28orr;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004036; a=rsa-sha256;
	cv=none;
	b=rXI8khbh92lzUU01b4kyfa10sg+WYzIIYJSG/iYaEDj6c7xEDu0OQ2Rjt9LmVYjnDDwVvL
	yrIjggzxH2j5mmZt2M+oBqIqbq6rN4ps9RtRgTos4jkm1ktOn4/43n3ltSHDToCOnrJuZe
	DkHfzavptAdGgzkGnpqJDbq0h2E458o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=l7i28orr;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04baGaWIOcpAM10BsvDKc2YnzV44Y+9Sv7IQZJnFcq0=;
	b=7igsoiAmFl/0EGtssyaAz6xBSbbUCQAfRHSRVWIJ8kc3zFAmNXrg2DKsuEuXc2imw3WWKp
	5q1rgo13Qr2gYZ5BLfqIAL5ziqUS3E639XcTyup5HGYsN0/vCgKHfnBlEtwIy02JjEzfA1
	S35XANj6FdtPqEsdcnUpAPIUWx0Qjgg=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b421b70f986so1319594a12.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004035; x=1754608835; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=04baGaWIOcpAM10BsvDKc2YnzV44Y+9Sv7IQZJnFcq0=;
        b=l7i28orrfzkREhiQ4XJ9tuUtqmIQ60Ousy0uCUWiOAWjTjouT64+jWQNc7+RL3V3cu
         7x2UkVg8v7bS8jJnGCG6Fog8hQ67Pb5HcbFohH9BQSp4D6eO/lawPAybOHidgOHunBqj
         b2B7WQIv2XqMI3NqeUXbohVZQ0Cmo72jU0gZVmlQVHTZsv/YaV4buuDQR2qiu/u26A1F
         svYNr+9ogVWHfhl+QwRXtVDN6pwpG+CXUUJ1+hLuCAwWxuZahhenlvhXTSS+BYD8ktSi
         xsT5k6ZMH49hmQYBzBtymoRfdvBjql66KcJrSO0IJTNRXyZjedmbWwVDBmPCMQHDtari
         rnzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004035; x=1754608835;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=04baGaWIOcpAM10BsvDKc2YnzV44Y+9Sv7IQZJnFcq0=;
        b=TVoLRIjwIphZSVM5xXSshh3ZgtbXtszLlk7BpP1kY4M8lnXhk4d1PpiIzbdSg8jE1y
         /MgNVmC5BmtI17PHNOErxKgyUEpRLfyUqRumvAi6G8AOlYfPa73J8m9629w7HVvJzXoP
         AL3YvbTD75zYmzfBx3tsc3ungiSlwwkn71qx7vu6WBP/Dtbu5juEhvSjK8ZE+nRh3oue
         3NDVZGsWxpHK3J/viurc/bqQeCdfdkeyQssm0Z1mTT51oniAdlm4Umf947LdIrwNmSbm
         OVAq9HjaMXAbTL2aAmQc6GSYqynkHPZSnnTMhDW9Ky10hHqJTQ8+Ldc5CHeiEuRFEh/1
         t4Hg==
X-Forwarded-Encrypted: i=1; AJvYcCXNXaqzbfKTA5WhcICGSMuqX3TEI2fWGvTlNOc2kWvdaaJTai12C7B7Oa3WCMd/2v9NMJL4B12iUQ==@kvack.org
X-Gm-Message-State: AOJu0Yy/NBeEP7WKRXa1Eb6MFp51GRLO6cPlQdY0JSCqpF/GkmFTlCye
	PAxWUJQ+o+g4SFoHp8ov/78fiDQHRpF5e8IepEJO6xeQ8LsHQduhhBa+C5P1NMfNAzI=
X-Gm-Gg: ASbGncu6KOQx+Qbkjb2cjBe0cUecqJwzoKEv5QKev4ntJAM8Bx4rWmiiJsZrZPta2dR
	SieuzZVNT34NJE24y9fxQXByn/wF0bGxoru8BPWW0VmrZUig9XLfpAsxVam6grqkYR8SRltqcYK
	KOVYnJ0TpJ4ldd6jFw+n3SXu6dJBAi1Bx2cERtynVqrwV5FaraCxECMWLLCH+NevkUZI+2du/C4
	j8GveU4wkn/xFhnr6etbUktubAH0kaGZEaJGwnYAYNSxCI7/gSCvuLvCX/wXGRgGBMGaNvzAPDt
	sTh2YofCYg+6jWwfb1+36+f/Zs+OwJwnDt729f0E7Tu5Ggs69WpjOL1ftsEVtQxvUQRubUM0Vzg
	SfNq4tXEPhCaIZE9E24juuoQHuPeII3zQ
X-Google-Smtp-Source: AGHT+IEyDj4erId7aawGI/VqypIEWKc7AcRxtwEhlRwUvhT5Xgkct9IWPfC1WhG/YZBxwkqZsdc1Bw==
X-Received: by 2002:a17:90b:3d07:b0:31e:beae:2934 with SMTP id 98e67ed59e1d1-31f5de4b8f5mr13878801a91.18.1754004035067;
        Thu, 31 Jul 2025 16:20:35 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:34 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:35 -0700
Subject: [PATCH v19 25/27] riscv: Documentation for landing pad / indirect
 branch tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-25-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3AC2A100002
X-Stat-Signature: nrmtdtaxqppw5x1pum8qu6xgego7ntzg
X-HE-Tag: 1754004036-218251
X-HE-Meta: U2FsdGVkX18ccmyKJDn84ZWTCTlauVGpBNvU7wWHkpB5W4i6QLzAbkaiULYLiq0UHMskbQy0NULtkCL9spox7YkE17+mQQHdrSTOwFmAzjMf9qTFX4qaI8YABZY8ids81Kpi7pGQeE6CEY5hiHckclWF7VuExR+4DUsvbLDmK/VYwgloXgwsc++TEagxvmoWgOzCC5szNBtEpjb9eFeWGgyi6qs0pat/PW6YYE7l9gCpKWsf6Axdsrx2ZEJvkW/wJX/slT0ASr/DaXjWtFMXjE2S/EnQuvuHb2BgUQzI7xYn8eD/AJjxrWe1OV+r4NpSM/0XcNz0ytSnGn8O9nHlXLtzpf0wdpJdQW6C3QsjiLRJGQMYuUEJ1IaWIIo8te/2g4xQXmX0DJu6iqu0RLXzUEuUrB8b9T0QPRYRectcY7iWD580sD8jW+6kjSJNF8WsrqYXFE4Gx+qgMXcjxMkl1Gwh8BWmdx80pXBHy8902EyaZ/EPYCd+Yx/rgbT2ClVtVmjg5XUrPtxTaiqEsHPvMU16JUeBKsO3SvKgqXnaWlSkSANNFl5uZ71uNdwhiS6vO4KT8Tqsc7sGXWb5VC1d6j+V43aPTVi3OyOe2ejcO8irLXUOHXurzumN3ScRWwehHS/nufe4KFfumsRJzRYRrLvLvREO/aKDMhIC91lb7vbM3UgtdSYQFs3GbMLfmBpR8YYhm/3ppO11TdU3rPPI5KsvzWtvbVn9JzIktLJUtRvLc9LNXgDXQ8/fQ/oy8Q+8/h+vY9LVTLO36I6Lixu6rsXj5PBYc2E9TIPxN4HwCdj3lAPgXrVfI8pvGPvkrWSQkjil9qq6nyFKSkPvujTmEQpprTq91zjq5JCAsDtPXvJ4VeNg0ckrPmVKQguxex3xN9vyKAFH8Ziw0PHvm91Z2kMnDoQfTR/UWVSaRoS8CReSh43IzFPO8/ZqfxWWQcIfCjYNsYrD3Q/TgYfOAWs
 gKNLAScW
 PHgoF/AEZJCsJnZ/W1LlxaZU1xE/SBCRW11vL7DeUmBVibMzQT8ZWK19fdWTzPll2rrAHv64+OmTvEAfREP/kiHjmjHITBLPHe046sdciXoBNRZA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding documentation on landing pad aka indirect branch tracking on riscv
and kernel interfaces exposed so that user tasks can enable it.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 Documentation/arch/riscv/index.rst   |   1 +
 Documentation/arch/riscv/zicfilp.rst | 115 +++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/Documentation/arch/riscv/index.rst b/Documentation/arch/riscv/index.rst
index eecf347ce849..be7237b69682 100644
--- a/Documentation/arch/riscv/index.rst
+++ b/Documentation/arch/riscv/index.rst
@@ -14,6 +14,7 @@ RISC-V architecture
     uabi
     vector
     cmodx
+    zicfilp
 
     features
 
diff --git a/Documentation/arch/riscv/zicfilp.rst b/Documentation/arch/riscv/zicfilp.rst
new file mode 100644
index 000000000000..dcf43de73a06
--- /dev/null
+++ b/Documentation/arch/riscv/zicfilp.rst
@@ -0,0 +1,115 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+:Author: Deepak Gupta <debug@rivosinc.com>
+:Date:   12 January 2024
+
+====================================================
+Tracking indirect control transfers on RISC-V Linux
+====================================================
+
+This document briefly describes the interface provided to userspace by Linux
+to enable indirect branch tracking for user mode applications on RISC-V
+
+1. Feature Overview
+--------------------
+
+Memory corruption issues usually result into crashes, however when in hands of
+an adversary and if used creatively can result into a variety security issues.
+
+One of those security issues can be code re-use attacks on program where adversary
+can use corrupt function pointers and chain them together to perform jump oriented
+programming (JOP) or call oriented programming (COP) and thus compromising control
+flow integrity (CFI) of the program.
+
+Function pointers live in read-write memory and thus are susceptible to corruption
+and allows an adversary to reach any program counter (PC) in address space. On
+RISC-V zicfilp extension enforces a restriction on such indirect control
+transfers:
+
+- indirect control transfers must land on a landing pad instruction ``lpad``.
+  There are two exception to this rule:
+
+  - rs1 = x1 or rs1 = x5, i.e. a return from a function and returns are
+    protected using shadow stack (see zicfiss.rst)
+
+  - rs1 = x7. On RISC-V compiler usually does below to reach function
+    which is beyond the offset possible J-type instruction::
+
+      auipc x7, <imm>
+      jalr (x7)
+
+	Such form of indirect control transfer are still immutable and don't rely
+    on memory and thus rs1=x7 is exempted from tracking and considered software
+    guarded jumps.
+
+``lpad`` instruction is pseudo of ``auipc rd, <imm_20bit>`` with ``rd=x0`` and
+is a HINT nop. ``lpad`` instruction must be aligned on 4 byte boundary and
+compares 20 bit immediate with x7. If ``imm_20bit`` == 0, CPU doesn't perform
+any comparision with ``x7``. If ``imm_20bit`` != 0, then ``imm_20bit`` must
+match ``x7`` else CPU will raise ``software check exception`` (``cause=18``)
+with ``*tval = 2``.
+
+Compiler can generate a hash over function signatures and setup them (truncated
+to 20bit) in x7 at callsites and function prologues can have ``lpad`` with same
+function hash. This further reduces number of program counters a call site can
+reach.
+
+2. ELF and psABI
+-----------------
+
+Toolchain sets up :c:macro:`GNU_PROPERTY_RISCV_FEATURE_1_FCFI` for property
+:c:macro:`GNU_PROPERTY_RISCV_FEATURE_1_AND` in notes section of the object file.
+
+3. Linux enabling
+------------------
+
+User space programs can have multiple shared objects loaded in its address space
+and it's a difficult task to make sure all the dependencies have been compiled
+with support of indirect branch. Thus it's left to dynamic loader to enable
+indirect branch tracking for the program.
+
+4. prctl() enabling
+--------------------
+
+:c:macro:`PR_SET_INDIR_BR_LP_STATUS` / :c:macro:`PR_GET_INDIR_BR_LP_STATUS` /
+:c:macro:`PR_LOCK_INDIR_BR_LP_STATUS` are three prctls added to manage indirect
+branch tracking. prctls are arch agnostic and returns -EINVAL on other arches.
+
+* prctl(PR_SET_INDIR_BR_LP_STATUS, unsigned long arg)
+
+If arg1 is :c:macro:`PR_INDIR_BR_LP_ENABLE` and if CPU supports ``zicfilp``
+then kernel will enable indirect branch tracking for the task. Dynamic loader
+can issue this :c:macro:`prctl` once it has determined that all the objects
+loaded in address space support indirect branch tracking. Additionally if there
+is a `dlopen` to an object which wasn't compiled with ``zicfilp``, dynamic
+loader can issue this prctl with arg1 set to 0 (i.e.
+:c:macro:`PR_INDIR_BR_LP_ENABLE` being clear)
+
+* prctl(PR_GET_INDIR_BR_LP_STATUS, unsigned long arg)
+
+Returns current status of indirect branch tracking. If enabled it'll return
+:c:macro:`PR_INDIR_BR_LP_ENABLE`
+
+* prctl(PR_LOCK_INDIR_BR_LP_STATUS, unsigned long arg)
+
+Locks current status of indirect branch tracking on the task. User space may
+want to run with strict security posture and wouldn't want loading of objects
+without ``zicfilp`` support in it and thus would want to disallow disabling of
+indirect branch tracking. In that case user space can use this prctl to lock
+current settings.
+
+5. violations related to indirect branch tracking
+--------------------------------------------------
+
+Pertaining to indirect branch tracking, CPU raises software check exception in
+following conditions:
+
+- missing ``lpad`` after indirect call / jmp
+- ``lpad`` not on 4 byte boundary
+- ``imm_20bit`` embedded in ``lpad`` instruction doesn't match with ``x7``
+
+In all 3 cases, ``*tval = 2`` is captured and software check exception is
+raised (``cause=18``)
+
+Linux kernel will treat this as :c:macro:`SIGSEV`` with code =
+:c:macro:`SEGV_CPERR` and follow normal course of signal delivery.

-- 
2.43.0


