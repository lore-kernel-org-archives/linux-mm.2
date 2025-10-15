Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E1ACCD19E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700BD8E007D; Wed, 15 Oct 2025 14:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8718E006F; Wed, 15 Oct 2025 14:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B0F8E007D; Wed, 15 Oct 2025 14:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F37B8E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D6EE13A3B6
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:46 +0000 (UTC)
X-FDA: 84001149372.19.D557F33
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2830440003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TpIp9upN;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EG1CujsNwBaYp55w8jydf3By/QJhyDp8hEQZ+a6RoEM=;
	b=nl994axzuK2fkskcx21UOOlwKC2WvLgaKWjeOK+GWe5LbHuU4ivEUF51A2WZL/Q8/czOVR
	gNoFyGRx2BIQqgY8fKDjxk6ayyFt3vARqXm/qqpfmXFpYqLXzoVpGrMQqaLgNSa+cBiwgz
	6OblMyPPRNOFHCZ/YQAhirmBGiga96c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552084; a=rsa-sha256;
	cv=none;
	b=qa4INcmQZLnWqkoI1d3w/mITCiVtbA6ArfA/bEvVpdFCkSh6GARArgKd5hti/svi2CLY0F
	Zvw2jTSV03gMapvANQlHKvBfCT5lWxiOCSiZdkQjq8bdSnD3lRUoD0EAdGT/iO5ZJfSjMg
	QVNkXtTG8ulStHh311MT/IBG6JlNfro=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TpIp9upN;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so6331896b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552083; x=1761156883; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EG1CujsNwBaYp55w8jydf3By/QJhyDp8hEQZ+a6RoEM=;
        b=TpIp9upNSr2Of2npCOPlpQGaQbroYUHgBOfHVyjsuop2yzyC0HxRDVCK0gqN/q0NZK
         VpJm2Mvq+f/8SRNA9uKqaBy/O6zhx+ztDnjjZKXuM9h4WVFU6bSLKv5h7NDwilzi3KRX
         T3ZGKp0dNLTBsw23FIgyYaPqSAA+upromddvJ/bj2Q1wgMoXtN7V2QcVmk2v4lS4rqZd
         NL6CbuF04MH20RtuXrDqPQSOMHhNvNmgyfa+jb0j/+9N5IFYp+KvicdJBrk1ttEpBR00
         3+Omey2pori5i5gIReLDlt5+ZIsrA48Au2SFjlSPXMiLQtO5zhFr9erU5vDWuJ9y1wZq
         7KTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552083; x=1761156883;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EG1CujsNwBaYp55w8jydf3By/QJhyDp8hEQZ+a6RoEM=;
        b=gJC92XixYGFeteRs5a5mcU9ADrHu2QqTfXiSpxogYWnYb3ndlH7e7Utv+FtQjW8/uF
         vEO8sTXRsM40HkzwqJ2kAe3qcfhweld2GdSjYBkWhCSAAK8+bkMLcgf/hPdJfO2zkxkj
         2VHCljWb8hU7TsI1OURWyv8ZSHC6vvZGoCpmi48qbecYlfClUFl6Ze1lPq7ALQILlWnp
         2u7yguefYeVYwbJMtY2Dm+UJkX2ntvL5Q5KouBATI1q+AwCLePLV+8FHUQnxqLTMQf2E
         /E2muhTXYrGik/Sc26LtJpUic3YaXUWe6S46edDs1OqOOH3gd1bIaZE+DItpyFllGKIY
         qhmw==
X-Forwarded-Encrypted: i=1; AJvYcCUt2dfjBpLlqYxngkrQo6CBY59IfHIKvptPgW36hlh5BmPsVt3kEqk6BakHmQ+kHir+wyh5yCxR4A==@kvack.org
X-Gm-Message-State: AOJu0YwVhMZDVjg+MExQHKOkP1fKPCxLlR++LeEv0cZUBxm8fyYO8WCr
	0zhvl0eehc8DU3e7ZXr8zGO+hZTquFf3WPKq/4G6TXswEDId8PebzawgOloL7we430NhZ/mfBUL
	DQfEs
X-Gm-Gg: ASbGnctw0PveqWJDxlmJKDNzVFeG38SQboY26DuHSml6Zcz1Ij5QoJsei+nF3o1sAmv
	1Rb3IlA0kk+5CXqawFYQoolGGQUX8Dfu8Faj4oPsv8ty19FpJSGkr3pN5sLulc6kFYgtkiC13B/
	n24A4wluDQuN3DlzMdd582bpmecwVDJtgdoZpbLiuqkd7+GoqoVGu16Ze9wL3d0BUmAmO/ohG2L
	tCuA4yU+Z9edo0g957a37PjG/NGn+mwN2zd1YYvPa4TsRTgK00Ty0x5GF73KJoZ3R018M88dc9d
	ptIlWEHpJcyCni8L3XF7KD8Z3Lp2dFScsiLJHogNSQrR9SkQGpm+BxdbiW/zFblIWMBR4znd/Nb
	2AkqSL74++dcstGFxXOrDWmcgJ+BRtaFcKeT+4tQEZR9WyfLKk5LmRssHkjcuixc5dUZRLXEn
X-Google-Smtp-Source: AGHT+IHIuPapqKaEgJQDooYNegliwk6TBhWvUDTrNLkBFXNxNP1x5VscPPMJdzsUIVRc6YQ1lTVYMQ==
X-Received: by 2002:a17:902:f64d:b0:26c:e270:6dad with SMTP id d9443c01a7336-2902741e4a0mr313345865ad.60.1760552082633;
        Wed, 15 Oct 2025 11:14:42 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:42 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:58 -0700
Subject: [PATCH v21 26/28] riscv: Documentation for landing pad / indirect
 branch tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-26-6a07856e90e7@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 2830440003
X-Rspamd-Server: rspam02
X-Stat-Signature: 1t8fnmhrigftymcrjqyxbuaz7xmbm8au
X-HE-Tag: 1760552083-287668
X-HE-Meta: U2FsdGVkX1/mGn+QaPm0j4mtDeh/5L6N+t87OhP2rExgiY2B1dUcVYw5TBZx7tvDVhftxu9l0sO/EDnz1QgsCzfiI2DVoLqphPNrdrzSmG+SJurG7luqrT7ixRfzofQ+932bF0wyorTu+HrIR1hf8me84U2YJ/opXsnEYehiudpGNrqCBYxRksXZq+LixzvgdVs68MmqRkFB1dlW3aUN7EA3dxe4nTYYpnzooavyuv0g8LxE0BDanj3ypINcPeHqOp/N35+qbCO+ucsyY07IEXrYFjS+q3Z/94DjR2b+AwPxgAWlIsSrOKbarhapv+WO2oArnuMePzu7ZIX/mfmVU4DbcJbnLwyoDaRiY1+WPrC2iqyXbGATQlWRwKM+a/+P+MKG0i7DRGMuj9ywoNZnkTFPNo9xmV1T9qzomeDJA05EZ7ECZa3zKABfc4nmtsSGvgMrbJGzk1EXV8GBq4EGr2JczoXvAaGDi7shYEzeRUaBXZiWYoIpgAbaKEzS7JjcVosxpC7ea3sxahIxFQvMnTxWRl9HRV4mpXqQQuBPXUcQvmMQrQs2aAJi7hdClVgyVYJQ8onCCRgYjgSV6qKKlp0cdz945E2jdD8j5eJmHx7ZMDYXu2Y4UPIrSJlSdSyFcfbb0IEfWGcS9Q070hFBA29TQhkwflXHjZgUeUegMkGs2chwxpULfI3/fEPTGE4+KCurJirc+CkrZBIowdWGH2hKx9PGUtQSnAYy4cTXcMMxA4QYuP/GHrrJ9BOlvmZ8B7V/xwOmtjugiMXLGZACLfgupa3RfHFI16eFo4iADQrKtkZqWcgCmRTZE5Nabz52FbmRz37fyhp0lHyC1gNfQz6fqT5qpM1CG2VpHIFGmsipMwMpfe/1RdMZyJKmWtAvoQQV6LI6U33eDWDtVtV01YwF3a5tv7BX9IZBSl+v7bMqtDdTX2gcmI7K1I85CuWRAbElndXhcmzts+WV+rF
 JVIzY4zB
 hYbIS12lNBFrWqoQ0/QWgNVAcdOz2+ouWdcKNB3354YZlTCqSiQwjLkNhoWnLPBtqFSnsmEL2qOo4q7x8V6QqFTusDNXNCyEziEfFS5GHikkQY68WZLIR27+cckLrMghAE3Kx6HHpJOQx4zpTJU7WHUJupfrzhqQztQcGdSikm9gXfQiRMNtPGG85JnYrF033YkCWSpI2my4dZEKbAjpWWPdhfreall7006AqnDMkqhXDBNPqVvSK2L7A1yyN5DYoAWnRzD2QFS9ajETXVsQ2gEUfw62ccn68/1CbX+d6PIULR7HTn1Mhj14GOw/dOjInc0iNqQME9HDUkvbwwH0mJZsdBxbM9tOuWq300YGkUYbZh2bsGB2EEr3RzCGymCEb1LfEQYOtQ2/yKL+RlbLz6gIvt6pNZ/AVQMDdNOS6xrySE9CW1M5npcnVVC6sJvL9oSDk+bKgdVEec/NIkRoIttLhjBAOk8a32/KV
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
index 000000000000..3575c7db2cef
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
+    Such form of indirect control transfer are still immutable and don't rely
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
+* prctl(PR_GET_INDIR_BR_LP_STATUS, unsigned long * arg)
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
+Linux kernel will treat this as :c:macro:`SIGSEGV` with code =
+:c:macro:`SEGV_CPERR` and follow normal course of signal delivery.

-- 
2.43.0


