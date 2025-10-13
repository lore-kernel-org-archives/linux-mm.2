Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF63ACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447928E00AB; Mon, 13 Oct 2025 17:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8F08E00A2; Mon, 13 Oct 2025 17:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ABB98E00AB; Mon, 13 Oct 2025 17:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2ECB8E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABCC7B9265
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:59 +0000 (UTC)
X-FDA: 83994451758.01.9D20520
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id E8B0012000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fV2PpEl7;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EG1CujsNwBaYp55w8jydf3By/QJhyDp8hEQZ+a6RoEM=;
	b=JYhhPBCqWKr/KfWkhYpudJiVNMGETZpODHL58Ck/LelxvMM7jjUsfhiPfcfJNtyFkxqUmi
	qG+Rj+iSm9NeHwba8bFFwDPzbNI0xUflKg4MgbYOmTw5MnoxibpAYPexVH3IdERTKue9Nj
	aFuUVGUz6PHjGS6eAS5oiWF/921U31I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fV2PpEl7;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392618; a=rsa-sha256;
	cv=none;
	b=p9ZnI+HPvSmDMnc8M0MPCQZtoWundrhJcYnW+GtfQs93BTtsU8Gt9+JCxPJJwpqEapEIfZ
	2sIvGAvE6FT8lYj4e8SZPE58YUqDm0si7MVCJ2tm/VWdw6eJm6BjPj4O9HrnTXnPADUXyC
	mLP2baL777mFigX1Gnc7nGu8+mlAItM=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3307de086d8so3806060a91.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392617; x=1760997417; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EG1CujsNwBaYp55w8jydf3By/QJhyDp8hEQZ+a6RoEM=;
        b=fV2PpEl7uvlCgqhBSPcJ34sC/LqnzUmYiXYxPnH3f/MZkGCYcsNP33yZ/NHByh5x/c
         LPkdH8GjNDrILWrs4at0uTA660W7gibVWJzJmji8alIy+X1Fpojn+YbZkdl04M5FoPa1
         TZsqxbzGPY7ecUWRWlChwGFeNUVbYzqD2Y0WPt3zPxmfuk4Tpdg7rsVeUijy0GEPqkXX
         XpKZq5G7iogonKhdsXTwlW5Qu2wg6Qhcr+LeZCLUDOIYchIlrbbnaVKKVbPsitfnjb2d
         wYcX+0boqdh51uoJNex/Y9WO3+jwloy/KhBozywnWeSSzaPal993XIRyzyYxJu0W7Z6v
         PRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392617; x=1760997417;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EG1CujsNwBaYp55w8jydf3By/QJhyDp8hEQZ+a6RoEM=;
        b=jl4mIhq5nyNIqad6tM+YLVJ+277N2pdcgO51Eo5uJlK4PpNKA0d7FJIELWqDEEPZNB
         37TqjsyLFrtRb7QmlN4IoMbLoEllJR/boj056ABxcpNvQdigTH6l52Z+gwbWaNIQHdQh
         qcWHuJF9ub8F3TaV/NNwGY0brz1sj6DbLFcREXDK3Qq1oHXoDq0avEMaOeF44/u52m6e
         zB8pbeVrHAKxt2c/h5eMm2eeeLkC3iIqKYqwQgJx6O/UNAYKgscYse1MXapcYcLGrwLd
         MJPNE+s5P1QgOQ4KS5jmOUtYvDOC/7sbT4wZ6PkbHKcaODg3uN7uKjBYZEjuW1PGjVrL
         aFBg==
X-Forwarded-Encrypted: i=1; AJvYcCUsXs6nwlKFHhHZMbTJQF3wzJteHcsqD4fGAdsFzzj3EL9sFJXjsc3O1Y/H5GhyvGrtNFjljzBR/w==@kvack.org
X-Gm-Message-State: AOJu0YwZ77UvCweweqTjaUz4P9hw3O//wSXOG8TmLiNC15G3YoTLcxux
	ryjOFj4RIVDO3xbqamhl7WxoAYWZG1VA23+TbM+vjtcN44BWfmqoDk7YhCej0zlbitE=
X-Gm-Gg: ASbGncuTi9/xwcd/mQF7wvHcuM5jycaQrfzNZFYq6P6cam1uLD4DOe1boXk/PCZFagY
	aHNrgISU7fVCGgCnEKsR1ZwixWMG4IXqm4fkT5Do+0SBGkBvbInjf66Ql2S4c+/itXbkz+G7EKx
	8T2RjooxQB367N62OiT5gAyB9q4YIy13oINkRcBHDzMYoJ0WNv2sfzs96c92UG/kYRxAkFeEDvV
	iTNfYXHzmoWRC46Gs25M7rWFvVpYBR3tIEDv+GSn1aGETcZC8Rgm7plmj1fxNaalQUUVj1ltDuW
	f+Rpa1PR55ccOWukAjf2qrC2FF+OMAi34FaQ3++xNMjLIZEq5c++9fP8DiG/NQVpUgeTJ1MiomK
	tJ5iJjb1YdBlp8GDDBcOP/iOfIZlcd4/AHvVCmovP5azXvY3GHD0=
X-Google-Smtp-Source: AGHT+IGfid4ZsMR3CoaIlWB5+Gunj6s0lNmjIuB2fbZTvaSGFUFt+EbWkoJNHt/MTShbkGbwbhds1g==
X-Received: by 2002:a17:90b:38c3:b0:336:b60f:3935 with SMTP id 98e67ed59e1d1-33b51386232mr32947105a91.23.1760392616746;
        Mon, 13 Oct 2025 14:56:56 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:56 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:18 -0700
Subject: [PATCH v20 26/28] riscv: Documentation for landing pad / indirect
 branch tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-26-b9de4be9912e@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: puic8ro184fkpopthgfx8rfob5b3fty3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E8B0012000C
X-HE-Tag: 1760392617-483444
X-HE-Meta: U2FsdGVkX1+41bw0b37CDAlIUVuTSs4LgLX79T/PUGlO7jKIyLO7HluWTjSdtFsDrHr8vNMHwNuXJE0/GwHaHFpy8cADyfHZwoePomIkuJVDgBXJEViOfzV9lcXSGmfKW83KILzwd3XbFX/3MMeh7sj7KvyeufXEliFIZL5JaGsejJt3H6kvVtZUIZXL+Y/iCUm6WYAMtZPA2aZjlHF5DeRBSCWweRbO8DH90HADwxX+EaD4a3DlAcM06Hsd43EH3TB3w5+WkkqmYfzPVhhXXCgw1FKSDrxKaFl7R8va+bCArqdRBfP3jnWzqROWIb4elrDoOHyS6NEYWxETMxlGj7A9tVNHRAdG3j/rSBJ3waU+kcrz2xlafV+x3XLJSQW54aJYXOtKLHTw5TBDcH3SdGF9eKnD9xW+KLta6tl6kQIyfqfql0xcgGM2mvYDqva8K+PhmP5k/qKFAMaMknl9z4k8cPAhRNsSclOkhz/Rqwpq17bOMelX3Dn8YRFv+Nte4zBlO5KaB66LKBppXwmheh7uBI97IE+/+kJQ5At35rmt59tu50A1r7U18XefFNnk9VD3YdufKBDuPJ2FROuQ2uElPKgkhAU/v4pt4+dTevE74FHZu+YYP0a7v1kSTUF/JdCaNtuX6a5JN25/DBE3MJZtiQ2muHl+VwINdEK7YlG8WxQkoLn42gmb/R2tJY7TNo86hhboxlzddhYvAVGd5lrgn6sLpZNokwa5jIKtznY1xpgRHLEI1COdOjVbmjP2EYx34Z7Prbx6QRuXb1nrneeoWDVkm17la6MDCwJl0WgyoeqXQd049tQn7I2rH6tfH7UFbGCxIuMbnSanPDt5o6BMOo7E5PEjM7qjTPgI14SUw/DiEjhIxR1iPMHiU/VrDOBolJnhVrJr1KsGxgNYkottaO7lmq7G9bCmJC7Wuyjpk9S704ni6BUZcHRvFOmraowXW4Wt3pRnVXzbvJQ
 l7ZjYK44
 BeRtVPe5n3N3HHJ9psTI/Rh8py2VfKiap3R8E3Kf5dAdpAQUpIX4+sihSlA==
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


