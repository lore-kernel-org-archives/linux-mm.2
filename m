Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 615E1CD3445
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EF88E0029; Wed, 12 Nov 2025 19:43:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8380A8E0020; Wed, 12 Nov 2025 19:43:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0E38E0029; Wed, 12 Nov 2025 19:43:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 577B48E0020
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B62E89940
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:55 +0000 (UTC)
X-FDA: 84103736430.24.3E41122
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 19992120005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JlVTn3n0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994633; a=rsa-sha256;
	cv=none;
	b=U5GjciPKNp6AJOGYNmyiqOLF5iDjtJeaSf8PmWivADo7jRQYlfneQ6rjO/MARRfdYm9kBt
	VvcRSR5S1HbMwX8hUQaxrPy9t5kREadl+TxHpOmLGN+s3RC18WSz8B1YRFBNxZkHP6auQV
	F+tiInrijan/xSEmY1+OrkgAz+DxK4I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JlVTn3n0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994633;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QO2wUj/sx2c82dUkDDOyKbgJ0cls8RAfjWRdglGaMz8=;
	b=buWqzHpuVYuUyi/f/mp3bV24hXQvETdxt3uX+oYmTNu2oKCRpYaQ8JoySmogF1DA+HanFF
	Mi7AU8apX7AxVV8tMaMlHDGeb+i9SfzSzUFNf+U10nrK8F480gbNBtMn40q6KoXNylnqje
	4HPDrPRisyNC8JvTXmeNiADWhyQDDao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 142B244792;
	Thu, 13 Nov 2025 00:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 107EAC2BCB9;
	Thu, 13 Nov 2025 00:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994624;
	bh=vMyk0DvBkufLwEJ3yIeuejYgqx65+1ZyPmH4BVNHQa4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JlVTn3n0T63UYSupSMoXqX5e2wH1sMYYlk+xpMFpTvZrlE6dSaRZ5Ewl0WR6jUF3b
	 BLkiwPIuNJ8XgIaveMXNCRAMaqHmt2MXVndODJygicB/fA2vstUQIvGWFuygEQOhfi
	 oI7jUDXBAFE9eCJlFs4YWFyADgs7G3bvyDMkBLS0KtT+1Mrc+IxPhSbmnyoceSoFZw
	 UBIswKNZ3jeCTUzy8LOww20BYiwG++TY+QFxpfReCO3Bm2zgrcYYDct1P5HLMo1Oep
	 jNEKXnOH2lDWx1FL1d4EnP4/ijWf/nlSxCP6sJkSw4DaNSXGhnWQPz0rf+ROPPMRix
	 VEuuFATR3OeLw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B6BCD342D;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:23 -0800
Subject: [PATCH v23 25/28] riscv: create a config for shadow stack and
 landing pad instr support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-25-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=2381;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=8xXhGOHwnAnDsfTny7atQO4X4Ig8h+BkYqQGslWOtL0=;
 b=oVLei2Wb2IxpVhKAOsRM4E9JUd7n7tPRxHysa4C+j49eH1Nn69+BaLEL7Lr+py9efK3eWyj+U
 vPx2nJT9OmTBExUMIChjBE5eZB7shcypJVuT2lRx3BdyOWa4maKRdHl
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19992120005
X-Stat-Signature: 7op89sosgms9r6cyffmgmdsson6ee3um
X-HE-Tag: 1762994632-54170
X-HE-Meta: U2FsdGVkX18IO1RzuYfS2SUE2gPU/iajDHKNA/2yE8MkdGlKZbBr9TgWVzyMiRemEKMKKMZsmD1h6HWIgU8UQxt4peoM7nH9rzM2kIRRYS+E1cBazQ8SgqyI4sCoQ6OYp3pcQkPjdRZfSBscQ41Wg1qVsJUZ+zeTiYqSJkLrFx5KcdFadfqpjHZKR8wO1PyK+EBRNF5tUdgU4+dMOhQFtaOovQRgiWdJOQF/z2KylhSYzoOcAp2fJb7X37sTONiw7G31Ru66TRb+HC/OsWMr1OO5zZ1ITu2jQU3a3l9942hyLYUK4ySf+023tutWjiVeQ5ytxwNxZGCdYFvAwiEGrKZdmwcBhyMXU+TANQurByeeDyuute8HEntFO+8fCFh+CpPG81OnXD049lhsgi/omPbi2uTIrdbyGJyR4GNlXPr0or1xb+C/r2EzPDH2SKTAS/P9dB0f8G7KWVj6A4EvQzA8pkBi8E6V9dC9Lax8lxhQGRXI5c6sV9iInSZ/XKZhGhpSXmmCY3BUK+Q/0gXmxW0fs2SAXUN5Ur32DjpBpOz579c/AcgT0wdschq5ApBliLn/19nBFt/4/MIACttCR4574EnkK6nzMoLtZMlNKzm6vYgaiizSesZcsS9zjQkoWAGAfpeouD9KklcbgI/ZznPHb82hpYgRUifiSN51IQSo8X5Du3YBsto+ML2RuYNNILxTwSIctt1A5err8kpFecp7z8JwaC7UMViQgFYj1IfN0bF88RDUtbcB2McHGHNF0fmLTCpBdBGGxc3KH2R9mT3fD9f8BvSBTeKqB0ADliJC1LkLtMKsTUwnBdR6/ZQESGEKy8RTjEMLso2r5Kps0Ttb+4iswRxtR/HV9NIZAMDTmvg1lLoR7IueniJ5N3euLVNlotJrlkXSPmumXw8JbrVq7VH3BD5p2NJ9fhXfe2entDUfoc0jaDwNX7paaKIpCuCa+GFm1kr8fHCpVsA
 WlGEzQoD
 tbQ2+JrUkEuHG73nc9U0L7LgILOlTPJhYFJGqFGqRBJ2GwZeYT8enkv5MvyaNLy2YJW1zQdXMERM3LszYlWMylJ8Eu9+pNwgYrovwY1ME5sjs697pYuXMC5nsodo4DRLswE1LeAgUa6Rkm9Qzya7zsBl2u007lknOipOYwx0E0tax/B/3NIlntskkLAGG3iRwyI0kFYl0rcL2vQrGhjNMgAs3+wLR00Yo4DOh6gRFPHVeqq9wGjpnSsvIoMZYACkVH2CcfVMn4nyUS+XaE3pxs41vUNoF4vMwKAhqJ/1w0L7JwmUl7DIVpXSFF+XD5bM8W/UruW77aXyQvJ6PSYxcoccditqP6UN45qNw3bmuqc3m1ynFXQLYnEy2W+OrvLzESmhTs2f7KnbPq5uN+8sCDwPcBFSFhEhnWAi2OGG54+RbaYyKZM8Q4VpTMtOP/Mf9e3JgpAtxIyitkM+ThHRaxhhMrl1MTbSZ0vd6/9Eay5+UcWut0uELl4KUVPlP0MZZIpMBuZxqapeT0hX+7Hp+IfdlvBnuqNbqVB74
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

This patch creates a config for shadow stack support and landing pad instr
support. Shadow stack support and landing instr support can be enabled by
selecting `CONFIG_RISCV_USER_CFI`. Selecting `CONFIG_RISCV_USER_CFI` wires
up path to enumerate CPU support and if cpu support exists, kernel will
support cpu assisted user mode cfi.

If CONFIG_RISCV_USER_CFI is selected, select `ARCH_USES_HIGH_VMA_FLAGS`,
`ARCH_HAS_USER_SHADOW_STACK` and DYNAMIC_SIGFRAME for riscv.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Kconfig                  | 22 ++++++++++++++++++++++
 arch/riscv/configs/hardening.config |  4 ++++
 2 files changed, 26 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 0c6038dc5dfd..f5574c6f66d8 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1146,6 +1146,28 @@ config RANDOMIZE_BASE
 
           If unsure, say N.
 
+config RISCV_USER_CFI
+	def_bool y
+	bool "riscv userspace control flow integrity"
+	depends on 64BIT && \
+		$(cc-option,-mabi=lp64 -march=rv64ima_zicfiss_zicfilp -fcf-protection=full)
+	depends on RISCV_ALTERNATIVE
+	select RISCV_SBI
+	select ARCH_HAS_USER_SHADOW_STACK
+	select ARCH_USES_HIGH_VMA_FLAGS
+	select DYNAMIC_SIGFRAME
+	help
+	  Provides CPU assisted control flow integrity to userspace tasks.
+	  Control flow integrity is provided by implementing shadow stack for
+	  backward edge and indirect branch tracking for forward edge in program.
+	  Shadow stack protection is a hardware feature that detects function
+	  return address corruption. This helps mitigate ROP attacks.
+	  Indirect branch tracking enforces that all indirect branches must land
+	  on a landing pad instruction else CPU will fault. This mitigates against
+	  JOP / COP attacks. Applications must be enabled to use it, and old user-
+	  space does not get protection "for free".
+	  default y.
+
 endmenu # "Kernel features"
 
 menu "Boot options"
diff --git a/arch/riscv/configs/hardening.config b/arch/riscv/configs/hardening.config
new file mode 100644
index 000000000000..089f4cee82f4
--- /dev/null
+++ b/arch/riscv/configs/hardening.config
@@ -0,0 +1,4 @@
+# RISCV specific kernel hardening options
+
+# Enable control flow integrity support for usermode.
+CONFIG_RISCV_USER_CFI=y

-- 
2.43.0



