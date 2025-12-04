Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0050D2A523
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE2F6B00DD; Thu,  4 Dec 2025 15:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9BC6B00DE; Thu,  4 Dec 2025 15:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B136B00DF; Thu,  4 Dec 2025 15:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 914E16B00DD
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5BC6212C96
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:54 +0000 (UTC)
X-FDA: 84182866908.10.88180B9
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6B86740019
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=MuAqUrGu;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878692; a=rsa-sha256;
	cv=none;
	b=RMOCu/9yGv0chtprMfk5rKRfleY0JA2nbdCVkXnoeDz73RSmzy6tG7dkc5GZ6eOHgrjWY1
	TCFS980yftg39RJAztSvQlQ2z296pozcNJfaZuDq9FmV5LR1zN0aSt6DncMpXkEmLZCf7H
	MkuX9Ys8shOtkrGTdPv2Xh4kr6TE/T8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=MuAqUrGu;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf04.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUqoxQ5CjiuDs0GKdFRZ0jt11JFnCh2SjtTuYqVD0Ko=;
	b=5J8cOwwJkbzx+To+hgyu8+qNqmpmbKV2kg+++rS6astwYVuwkMO2QaTEOA8TPfWnzDZH5D
	biqMBfBE+A04cnjJj0mAWrxXJAYRpvYNT9VfI204b7zAJSqv9BIxa8UElZbfWHkxR2loVV
	04idP5p2gjWs1twgMI4GqquaKK88eTw=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-11beb0a7bd6so2959651c88.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878691; x=1765483491; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RUqoxQ5CjiuDs0GKdFRZ0jt11JFnCh2SjtTuYqVD0Ko=;
        b=MuAqUrGuAvN3jGgcub2JnwBYD5kyrde8Z4Tlyy7kDyQ8XFVVGmvLJYqMikAc+8rbW4
         6KTrn8gnDffxY3IOvDsBraTZN7iFaqYRjNAMsu9fgJgaoXAcT50ddAFUHvO1Qg3PTson
         FBGrEAGDg5ek0DRNJAmk34h614tGUKvxZ45M5lbR9Tg2rpuYv+BONAukSRz7YphqZZf6
         6ENaD4E0//wCI0qW/BFrqY9Y4SBvwYeh74ivBK6hqKzrZTS0dD2HifTQvwCz331cwF3f
         dEboM4ho0GMEl9PlAAOaX8ieUvRrVAhHThpFG1/GTU06Voe/OOV56xSp1/Ab2lwyX0Tr
         hMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878691; x=1765483491;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RUqoxQ5CjiuDs0GKdFRZ0jt11JFnCh2SjtTuYqVD0Ko=;
        b=NcgkpaqXIuAhFuOcpxjtWKYL89m1ycFFt4mR84Cp2qUSI99xllJ46nSycfegvP4Vn3
         pFgt/cNBCJBD2oXb4vITaOKdN+mUDVDzrHSBH/KqgI5kx8yp+rVP/li6lWbRiqXr/hEl
         GKk3uaNjo4/z2H5tqAa6PQH3gDzwRnDVQVmGPk0rAPfdd1gIz+7jg62+ZBBrqWv4jYVK
         BVGSWOCxyEAXOdLneXtyBBIOks5r2cQUuA6zHIc9ZWLqsxGIdoHS3n3IcZoSoGQUT/OO
         uqn7rGsXhcg+L0ERufGvGvhs2rcXoPceRPqsR/p6pinHPriSbQCgXihhQmE4lXJZ299r
         NUBg==
X-Forwarded-Encrypted: i=1; AJvYcCUR+c2okFXXLx8mcmXcnZGM0Abnk88Dql/lQWHbDEyhq6gFbf3NnEcr2tKpBp/hEJLnBwm+x7bt9g==@kvack.org
X-Gm-Message-State: AOJu0YytD4vwPZtJbrbYLLedip75rf5nB6dMCo+C0/u89iJOBRkSlV3o
	7wF90WXWczyebSOAxyUn3xPFCGiMHsCq78HgWAkXtm+NNGQnVCoeJ0NyKVf3XaNz2jU=
X-Gm-Gg: ASbGnctvsKJc5ET7P0tXeBU/xXDy7zwrnWD/NHHRekQFLG3+ZkJjZIMivK82OPOrw4H
	r94NE7pEhBEdSoGjZGoNMg+pgrei95vJe17lULLL4u6wJX6tJcEZHTE8G0jc/eGk51+Ixdlih8k
	M5FrrA1u5EjTO0d9arFKEOCBh5cpWgoxsRE6qHhGPx6bkjr5jd4pmbUcb/BazqoQs7Sg/cKYssu
	+MP0PzOAYyHBdvo1sMzRa7Fr578jaqL5hF72yL0rUiEUqFE14VJmjBMJftx7KRX4JPEG7iB+Cha
	y+d7ocmyVdBvwndHIFq/q5LwksLP6ZQjecOQr6DdKOPwssrg0l7iZb1CzP64oCVtjv3FQ8qvDGp
	C0fy27LFwWR35wfAgBhq1QOdKWvng42YJ6qTBbBq+qKT280yEgfH4ZnVKsfSmik8/MTypiMwgOi
	Kf1mqeoYo/FgipmxAOWJba
X-Google-Smtp-Source: AGHT+IGiwuOlh2qwyHr6IpDY10nGTQeyW0GZJ4L79tinCNU61MCohBC19s0o+eYrmeMWD1XB+prpdA==
X-Received: by 2002:a05:7022:6999:b0:11b:9386:a382 with SMTP id a92af1059eb24-11df6016757mr3427632c88.21.1764878690899;
        Thu, 04 Dec 2025 12:04:50 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:50 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:15 -0800
Subject: [PATCH v24 26/28] riscv: Documentation for landing pad / indirect
 branch tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-26-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=6128;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=qc5jb0VBTvMD5i/U1+IxkjxGEykvbO4mg8nEvnUxuns=;
 b=i+38omcnFs7+RGFeIcjnYoj3H2uZTRCXIbBxmni/2r4/2TvXGZrsP+gBajN7oQMWiqR9kQqBN
 Desh7xgprmeB1xUQ23jD6r0KLCh6C8YEl6ZRcl42648SR3NgskXRQzH
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B86740019
X-Stat-Signature: phghr9nsq8xkodobwkduipojknjt9dp6
X-Rspam-User: 
X-HE-Tag: 1764878692-629903
X-HE-Meta: U2FsdGVkX19t4bIkFar9YC7kYqH+szvnukZYrzpwx87GEKemphkq1/js7gujbdPQNQqtYC6gL6M0c/rPYyGDQmDgBOUeGtwhbsG3hq1sPdL+cfu7ZLLTVRR9M2vvQs+sRY45uJeCXsSqZj3wpLyV7dqvgbla/U5YfoX+7/rjJR5fdalJgzvskA5wi6NK5ILLC4BMyKuw7hAoS8mTUyozc7HTg/OT+991Xnvh9i6SsBxsdQS/ccSDS9g2M4tu6aRwYNXN04THRqX0WPaDOW71PzYMDDUC7ycxZqZ01By9RzJp0YyZ1QrjdYqOndOu/2fOPzj54cw7kh4ylloXOvc+gOUdr4v+/0iWQf9AF+yiwXYrohFx4RFolnNFjB0Kq/B6djZI5VQEXMrWXJ5Us47BmhiFJbRjBhXTaQ9HCii/LjhqmDHUo4mpnIfQK6elWNA8M3tvfqq6Lk+inCGTd+GpPlXTQrq8X7oDp0lSb9QHkVRm9xarC/RSFZMDLczdXvLNVx52FWBE70J15+Q90qaTPqEsSDIVS5UH5HPUxrn42umlVVLxbItg3+avXXLt/wL5V4+Q0xHso6KD8i5VHlE41RVIail5XGW35Vi14s9l1eswU4TzbT8EliNLKoeU+7if+14c4aiDMDNjHz6E1jTw55Y0+U6AJy1LS2q2Lu0c0thoXU1eYoWzrpxzV/X6V+1bemDbt/MRLqQa8o2pQxo1wbcQ0C0/UMuZoIhObQnLUmSGkqupSVsmPPMHNpjnhNGkotiipodi4PWV3xqFecmmaA3PBDFKHLfvJi5uACLWTos6sAjMc+bTuDIPIld9AIUV714u3tQ2uHZZJ4hggZjPjqENNKRh0DP8eAwX2NnQnhI0uWNdjkpdSljdvQ/gN+vh8iD8Gt5dPnPaMBa1eZdK+TJQSVOFS7qspxPo8G7UG8y4jIT9+TWlmzsLIvbvmkuUffnas4biCcFEbT284BN
 cT7wQk9w
 w358kNmDS2ICxLe16In2TNpMxfxacdm47mR1cW3ZRqCwXxmxqVMbOCIILXg==
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
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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
2.45.0


