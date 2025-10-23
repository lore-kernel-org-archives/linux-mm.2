Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D826CCF9E6
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB818E002A; Thu, 23 Oct 2025 12:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D2F8E0029; Thu, 23 Oct 2025 12:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9162C8E002A; Thu, 23 Oct 2025 12:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 764348E0029
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4686513C1A0
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:29 +0000 (UTC)
X-FDA: 84029969898.16.F4362D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 312A640009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iajzcLjG;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238287;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgDBHmdHX+ii+XTCRi3AGqTGnWbo6040xDC6AfwliEU=;
	b=bM5XrFZZked5r19k0X/pXqLcKFg2pWTUSyhjM6sOg5otiX0w49htEcEIMurocYWEyEMCUT
	nDKV0drhkZqhFRfj2waM64phyHWEWcjVPe+C1y1gGEB6eQHNsux85ga+GIzgGC4I9vdKCF
	E4E5GOgxoHVC+nFMJCq41OQLxVbOCTo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iajzcLjG;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238287; a=rsa-sha256;
	cv=none;
	b=IaoWqoxMLpQ74d2b+ZhoRM1d1ZD4qOEdpnSTe+YQc8/aPGnh8vmnhXnKF/1hiklZxfi5QS
	WFGQfSJFthGVb58LpdoI9GxjLhSfL98Ksj4AM+bFvTkoMplIGKcdicKxTe7+bZmsSE2jC6
	GNsLn31dyn6FSlIOMeHjK3mIvljaVtE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 22F364B199;
	Thu, 23 Oct 2025 16:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D75CCC2BCAF;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238273;
	bh=bPL6vxe17/1hYXtbU8DLV1GggN8NhUYMmyQybHsKecI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iajzcLjGiireSHFzrG4+ypgg+gL6GnR980qG1Y47jE4BnmadKOn7AuYXmL3+bwOd1
	 4H5qD72dF/xO5jUJ6FKrOfJhPHkyZX4boTWLJDiZ+ZhGzSdC8zCLkLdzk6Lq4NhOWx
	 LxVrxMEvYqVdnbWs0pKI7qyUMVQ7h+fyyDOPBvCeHscptyjojsYwnC4a1MHZmtY4Sa
	 tajegTakRAFWUKrI8sY55Ln59joPj+o5pdlOqOCTC2jYK3TDk4/XAl2KGXXXuRqBtb
	 MURFFTvh1zfZmKYttk8PAstHm/wVVMxgsrV7EoyIhOvtWC3VxsQXykWALOJIgpnYwJ
	 if4bYjD2J9RPQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B88CCD193;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:31 -0700
Subject: [PATCH v22 26/28] riscv: Documentation for landing pad / indirect
 branch tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-26-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=6062;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=7LCUsE6kNUEwcM1QtIZIjQu/BHRL3vY+rwSlBm5MqpY=;
 b=ipuDwWSI/04qT6RIaANW4ewszxyYVUEQ6id0gaZsYEVtbEubqhL3Dv1wawJYb81cPaJpot0SV
 hFGpShFiXftCOrVGzjTrCfnmQHZetdqv6OfQwJ+1lnIk2jAJfCD9noE
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: trr4jm9khipthacc6ttugujg8xhxhi7r
X-Rspamd-Queue-Id: 312A640009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238287-272546
X-HE-Meta: U2FsdGVkX19Es8RTSLETehJbFq9gy56mUw2VSKJIgVYIWjRfv4Ox9DV04qApNDlgq0lmZ4AjvlS11Xhk9qVaWEnZTTcOGbLh9e1xCMnuR16D/Kh/W1JYmmFXBtQVqrUGGZAuWR0ig089J85B6nLYPnTmSpe65qDVF9v6S8FYLrsjupJkTnsfPgeEEWWQsc8TFvOBqZj0xW/P8LOh5TMLKt78oBjitjg2YgVWOwfAWl4bdsTPZx83Vir7KV9/LDZZ4pVtLCnM66A4gucnsYE+8O6vdC4W8XCsIN3TA4e/RqarsepBDSj6VMX4YYYN87GJrPV6ppxfygzZz9FNg4taeusVoUMDfSEriHAPMu7BUmaAsFErgfeif5jOzNr3W7LEX8GH/BoCCujPaLlyt0ezTtZfKRgOZp0iv4TsIQUq7jcZJTC5cEsLQY3OTaedgpdCgN+tXzq1LkYScXwg8iNNJP1DsbfwfN5seb8AFiC7TjntxG+zFClczFVUIeREhtoLjY3FB/drHqnIdZGhkSZdACWCL2DYIBVIog71RMEipZoz42ug15ZhSbM0lkXdx6U3i4R1EN/2Bwb9EzY+L3OF7ShI8hehNesFIKIhOFckG8h3AwAa1NgD+HHRtqY2D2rshSujVct0n62DvLiPtooK4j83VfUpDcSL4LEBRTS4buTfYfflzBUHbPwB0W50R0wBNt5zA4nhu0jsIs8UVp4/clE2Jd15O5gML4XQ9/uRKFkKne2606nwqF//0UfGzxO59SEEGmX05D3cZkFgHdPOSuxAkS1ua3J+ulKp8wKa5C8LZfOddyQ5NB+occbI0rYHnlngMgavFvq4+qBL3eXvP6eBhPhacJvk21GQRjQD/Y70wSV9eaF7wnOxILgnrbvHTFs3y27eBgdqjP0gyoAO79v5MztawhB5ZEoF/YyBMYbLK2E9WkcWl080yahZqOWDJS5uDJ3NBG1GgCDZVeH
 BYx+wQ3l
 +c9sJdtxWd2XcYMYeuTFC/ZJD/39vZrRMBL4bq26KE+cyYwXO4gA3lJhNMewL1PffAriCMIzheXOB8HSIzAQSAnH9/bEZx7qVMVZ4WG223PRfD9mf2uTZIthKqe6BPZZyL95mYeaIy1S9zgFKxyOmxDAZManOvI9ivnGqAGesGgKDTS4ms4N13eLJGmDn0J68qkhk3iV1xBFMysX32ll0TyVimQlhh74PHBhnXkcMC87pzRndIlJpPgo06GFCfmaPVYvdAQtIU4FQZ57XssZm07VhoHQQMGIyNIcBu41immzG6s/ZXyWf0VLYBM7nV4JPEbC23lRPSBBkCBNbfsj3A1+4/psD3g2CUEYch19o9FmP+wogQJPUJ6rFEyXdcGA0HmJxRpr/YdZAwf7l9zf5Jpr5wMDOynLMZrI4SmkrFMoMS2BpGe6sC6XC2eyPwW7+UOUPcSNWNxYdgwF0qjiZ5aRPGbw1HNlSpf/2XjwQ1+NINo1sG4NSihCgy4/8HhSX4lGTgGCQqW1uO7Y/Vb7SDh4OCphC1yANYfDu
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



