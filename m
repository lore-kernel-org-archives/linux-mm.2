Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FB3CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B867E8E001F; Thu, 23 Oct 2025 12:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37CC8E0029; Thu, 23 Oct 2025 12:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98ADA8E001F; Thu, 23 Oct 2025 12:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76C4D8E0029
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D2191A0BF8
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:28 +0000 (UTC)
X-FDA: 84029969856.29.881104E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2CD1D18000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egzYIV+F;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238286;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzYLx/39jtLTBja9r9HjApFxXOQbSwbf+0XXhyGnRsk=;
	b=t0r0Lz82JfJ16FPHapS1Ff9lOH3+kZmiQF+VZl8qUSwBym/Wd6Ociy7IjYkaRYJzvOQgQK
	tmNaU4QLsYwu8dEL00648Ca2FFen8kAOU90QAaCqFmpjfSpyP0rtgcpzWh4THN1RvgmxLQ
	SPtdM+nKlRmIZN0ruw8+he6G8G0DqvI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egzYIV+F;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238286; a=rsa-sha256;
	cv=none;
	b=FszQLt/Sj5naOY/i46rBE04ZyV7lhuXDSaywiX2N9WUOuutjWxq/NPR2yMRFOEu24e2UqA
	NtYcHhqAP0gWmls7uLW2tJeMHwfJRx5RfRumK8eVZNVueq0LLu3ieaO0DapCbJDGkzn0LN
	SN8G17AITnyjWBdNA1F8W4oHfN1jKJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3A2A4B181;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C49AEC4CEE7;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238272;
	bh=Ei3i6pCUom8eAx3LyrcIPVLrF6EpFXz5PrC+5I2lBc0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=egzYIV+F6sc5eOeiyUAa0/POROUfnPTHQes13oB7rCy4DY/z4vOkMeC5OgWekGpLL
	 co9/qiolnKhsllt1Y6QPRYc4+7g1D/8ZCDq7HDJXtaWK7MQrQJwrKQQgmlvWrNUuoM
	 dkxlSKf73cX5C792YDBzYqOhvGdcxo87R0XFmUWCNIPEiTbx2tCq+CxODhRNMxHF1f
	 Mluh4XWlKOd2Nye40u7OcoH6Thfoj4jYUtd1AcOIAj9ru0JwXKHI3O/kTZlTqByNlX
	 9cO3LtBgOwsbU5ULZEfkrcPHhcGSR5TCneNrvM8qxFRPhatpxNH6BB9/iQsQE8zBt4
	 3TnkotYHABqaA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F78CCF9E5;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:30 -0700
Subject: [PATCH v22 25/28] riscv: create a config for shadow stack and
 landing pad instr support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-25-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=2394;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=zi+etEd135eK9OaxRpxj8DKs2cttYpN7VPg6r2ftWq4=;
 b=NULkWKLZARWqV0WWPqBWvPEE2Syjy487jSqwmiZtwhrkXnaV01qRffUz5piYl0VjGsejoPMFd
 QISC42GXiurDCrbUzGEn7It4bc9jwpkX8hNfuiiiv/0wop9XUQPCgl3
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2CD1D18000A
X-Stat-Signature: qzug4izj43yz71sfemu6r87hwksjccmx
X-Rspam-User: 
X-HE-Tag: 1761238286-88649
X-HE-Meta: U2FsdGVkX1+pdCBvWOLKTUFpwjrw5TB6H2xCxlzI2JfWdu0wY9xwsIE4zaq/tmlozVxzHPh+CSkwZdjghMmpfPpjhdJwT92Gm7XHTZ4IPxnLJA+sPpkg5k3qp93pEvXpGUkqLW45eSHlcOJxBrMJV+Lsb6DqWSwyi1Fdw3ZhiC51Dr6dnQpJFogUnaIDlDbePEI/lflEkmIbO4j9MNm4mplEYd6gk+nRuQYv2c7Nhhnex+sHxWhKDRTUbWkIBnjwFoUAYcvYQs39hr+SLZMMD44NFtsqnGl8SlSeZZYAEHLmjM8dfY5O3/t7wtlZstnBx/TT2lDGyEjX+QvoNYuySyOXT3YcUdpPYEjsMeRp4a8LYrYia2gdEmQQ316ThkQCyW0v1WWKtmx4EmIqJvNm9EaGTXMRFzu2IH2jHlpqh7FG4ZVlPv0yeB0usqcTCFs4zvBopIDz3agOVb1NvAFPi+kEIX3yHiWM6iBo4Jo6qFKdfjuwn3dzFaVeJtAILoYZrd9T4FSKPWuhoNRg9kV6mHVRb3XNGiD0g+dYVlX+YECAfMHdPRlEvs1exX8txZG/Y5FOQPW70HasWdXZ/JHGB5flJEpi+3/r1btMr+PD8tYh/PWidBh2F4k4s/FuqNWID/cgAL/CUFm+XfQV3GqRrTiJKf8cPTIQPVGR5V72FuBIPL+A3VhBAX6MOpsyHVP8sWXeUmQfW5GQlKL/8WSHZNCYZuUgMEoYyV1MvQjKbMNqaDKH+k08+MYIzDejuVstD9GY0Xw9EizUnv9M/f23KL6ZBd4++c5cE1op76dmNy8cmuoHZiaUcFazkQR9CA4qKgyFq3YLo4VPwgbBcrsBO9Zxyg8mKXM50R6gL1vL9sEbSxdEIXhFonxMKOHlddNrnriZztK16NWAzrauzDqVuShfJ0vG72hqSdh3C9jaA64tRvTA/zv+NXRvrhX0EeQRq2x8w7w4SCz6o1HR0Ys
 zu5JTM1v
 bW5IEF3xw4601izr053K/YPGkaPWJXQ6fNoOzMJE47iM/fkXwYLwIHtL5E6Ddz9cjg3l/9al5edaMcz1pgCYosMe1MHQK5gELROgHDbohvTIdmGPDfPXEADT5RGlk/CIZVbI9Sr70Duzcu691KjYEBkcRcL0WjoACVZU1on2r+yxSb1OhkF7ri2dZsDsJFA/W/WCoFum4QrMCEgzASqiMPu5WeLHMjdL5N1dTtKVKqs3jL5BGwt+iIll5e6WtdP70pgnCygIXsMwKK+XaoiDXwB7eaffEaS0UJUAk82Ma1ELsg9zPPCwIJOZGlbNvl0wqY75yU4EnDzSaDQptKabKXOKCshP7aSBBeuL90R1WxiIheqlexpNSwB2BUdUwG/JNtJgjEiusAhgoF20bfTfTLqek13X5woe4IE7l2B+djoeEhwYjHtnvNcevDK9euiWw7VTko+vU0AsU6cYbaWUMGcctQAUOaOwr9f/sOZaIM7jAkK+uDRcEJ5+q9wFnivsJG5j9u2G+53Yc65ZC1uSJYdqe5YxYkDQFrVPG
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
index 0c6038dc5dfd..4f9f9358e6e3 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1146,6 +1146,28 @@ config RANDOMIZE_BASE
 
           If unsure, say N.
 
+config RISCV_USER_CFI
+	def_bool y
+	bool "riscv userspace control flow integrity"
+	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfiss) && \
+			    $(cc-option,-fcf-protection=full)
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



