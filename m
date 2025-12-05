Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00178D339B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA886B009D; Fri,  5 Dec 2025 13:42:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519BF6B009E; Fri,  5 Dec 2025 13:42:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392AD6B00A0; Fri,  5 Dec 2025 13:42:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 259076B009D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEF641402E4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:07 +0000 (UTC)
X-FDA: 84186287094.06.B27B182
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D14D4140019
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MM5OQXzO;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960126;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IE+15EAqBseA467abRspl+Ys+87eBXG11IwQGPs6jFE=;
	b=EdDFBg1mFhxWRmyIy+R3sCJqRTTlzxyuPkwDVycGeNzH1WcKwWXZZ+zIWasWw0wXU4zvb0
	oxrdg0QtTutOHmU5lsmES9AcPZhuLn8vZ31YILc+eqH8MgzjWEVRiNKdRuTRvgvKtp7K96
	X6ZvCd5Au2j6W/njRsCWLVV/2tnoJmc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MM5OQXzO;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960126; a=rsa-sha256;
	cv=none;
	b=0hujScuRtpazJFpO2HG0PMdZGynZaTn4Ktzh54HmNyjM07zwsLXyro9MIJdzNG/G5cYBeU
	pAzCmzPbkchIOyY4yXv25p1b7e1d+7FXt9kjWGxClyLUQB1EzDo4o1paIJiNiPQvW9YoVL
	fdfWOAi2AUYyZCawolYRTVY/N0NSJ+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4F10444E0;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A65BC4AF0F;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960112;
	bh=kGfEQABBCLCWGrC1+6CGHxQ0qt9V1jRea574vGTdULs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MM5OQXzOtxKM/YRCMCPqrzoEVVnMnnM/UuVg3DyJreNKtnfqAN8rLL8TpNqUVJ5AJ
	 csTMlCSGYZKnIYaFW+1gMCa2YnxcIbBmfyQYJ38l9n0XMxoSGY6b9BXh5VjdCpKLJA
	 +FgKPQLOGOxu3FbvgSirgzJVBtdREIy6ijLhXe6wgsPrRGAYjEalJ6GzTkYwEbum3b
	 HpmHe0eV9WS2KKEtblq5jJoeETXEI8WH3vK23n8ysKYqxEEN9CZH7UWc4J58U/tpkI
	 E2qeyZN+6kZ047fFdz82Ob7NM7yPp+IJP3+j9+5swY8KanOqMa1xqQCDXkafXU5WhX
	 vz2sdAAUTpqmg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDFCD339B9;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:42:04 -0800
Subject: [PATCH v25 26/28] riscv: Documentation for landing pad / indirect
 branch tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-26-1a07c0127361@rivosinc.com>
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
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=6128;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=y+R2YD0IqHtmoCU6xGbpFDzJNxIGE80ncdjG1f/L4RM=;
 b=DvXuExdEjliS6tF3eN9P64am2XiIHIwrvoPnhR7aNngQiCkXybReomNOQJC3nTDTSHywEV+4M
 9rWj9EMREJuAhtdfi5YakBmwsGvAGzRR8FOh3olJa0FM/yYAXyjRK0o
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: zaxte1xweu7cffhi3frjw3u7fuh5cwos
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D14D4140019
X-HE-Tag: 1764960125-511488
X-HE-Meta: U2FsdGVkX1+ri8iuuty3RcX0zI/09yD2E0WgT2MBcIVSbF6YVuTt2GTRbLppo+5L8wMExCsSq0RiBxEJAiiXKMFrMqyEHRozhwaVFM5pXCTsXflz/BNmaiKCyJrVZBgYTxrMJQ0Os24rul0PQf4vlu9MzQWLCL9ot7A3pTyt8MDwVJWOiHsnXJZxA6hQi53YCP3KSP4cf4QoQumAaEBgGrSGjdOSIg8Tigw3Xojfo31njujs9otWUJrA4PRa1zjxxHCNNL2Vjo9ySqM0ykG8x/rIIfdrHdkDbp/ENDvoU6PQvulpp+deYLFk/eGJ2mQdEP45utD7TNF4Q6l5S0e42itR5zpLgys3Fs6SGkIXCCyCtErnf7FlVDssowbyVwiRNdoLgRGMEvz0lS2pME1OEbFEj77jLXs0W5xqesmwzdmw5robsjVvU4HiS1jmI780DchiPx2rzHd5jPOVIIaLQf8JK/9ezt+cciHA0hvid5MSl7qQeI20OLZvSraqECyn/OoXrs0IYvpjYHx5ADPzQ96b2xk3Ru5SZEaMcAVxFf3AW7vUrgUiGBp6kH3SiTBfNrnk296B3/WlLG3lqaDL/Wp0OrP2r0X2mORtOArbdBSevTPSqnPXgpYc6y0vgnumb0aoMryMam4RaysaRScbVDTvREYU6euhQ5jvD48YWG6Sv6d5R8iTXyPdjZLKgAHJyeqbEuLR+oOlHvVencHQX3/IvSQ2G7U5nI9yYUT7AwE/H0/zyWdLTRpKBPW+2c92Sdznud5USXAH3cQwnozfYrmTWFvBNyrWIt//29+MBk0td2qOqbDSv+t1N8VFO2k8mvdUQbVcH4yUVmu57YASkqYD6aP2RIR3Fj77IvW3BOW3Xlbj0y7vNAs4alFPtoqXAiWS5JdHvKeIMmf6l6XKmWeMyKGxenLo2lmwcQOiZuBAylkYozqbaBU4LBZmE1/CxYB3mRRE/d2OyfHpPh9
 bA3vrh4a
 Kjpa/V9hCzBppbLizu1iNtCt4P/EmWABsa8yIDdyb1teZwQJCZ/qbJ0pXJtIg7vI45A2NY5DhRltOjNT7L1ZafRTNsYYfsskPtdf+z1uQ3QtAWoe8Mv4jr2En948XKCta06VjWU/Bm7AMT8oB3H+GcnRcPtLfmHDxCb6+03ot9uJazfzqmpltN2MeCbyi+qERvzVe6oHjH54Sdy+W1bhhqXxUbKqSj/3w3QHkz8PlInqA+E0XlypgPF+MKPKy/v0ToJOgO9zR21lpTTJj3vPRBsq3FsJq/dW7h+bc8RUb9bmoNPOlk42+Ta3Zld6yYWqbxUpGYQGx6q29YJgk+5v835bTCIVWTLWsQg2bTD/OG92ZDA+qtYB16NKjO7IO7Pakn13CZol7ntzWdZWFULuXyugWS4FLfkesoq8XpwPEA/wfZA97nbylrlzKWeLTBxk8K+B9n7u88KHCLrfZ6OJ70ddmPlnhkOJGQakEtnRHq1lcp+nkYcim5OlCVXkXXU6L5UUX0JbbCMsGsI8IrihrVo6D75Hpi2Yzq2yUD0a721qeB/A8iU1LOvLsmjYPAI7yBLsidwouCAFkICI9WcCTV/1BrdKktOrPgoyz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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
2.43.0



