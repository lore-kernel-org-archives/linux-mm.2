Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1674AD41D74
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87526B0032; Thu, 11 Dec 2025 12:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A9C6B0062; Thu, 11 Dec 2025 12:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A007C6B007B; Thu, 11 Dec 2025 12:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88A006B0032
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A8A8B7BE6
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:22 +0000 (UTC)
X-FDA: 84207856404.21.5C753F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 488A9140008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M93GKUwm;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473680;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFTQkP5AB0Aiw6pz5RSTwQf0aEDDZt2zldnXwA59ekY=;
	b=gHS/bs0oJqGG2bBbVXaTYLilN+u+vwQFSE4w7qqc0lBu0Y+DhyMvLcoPx8TAsbJMnHqdMe
	IHuLawjzYVRAkgMe/N9tM7Gy3/+zpCqs9jZj7GAoWVNkmQpSVg/6wzTtnGMKOua4x7rIzg
	Wv1t3zC4ftz3gQb3rDPAZfu+/1dv+Ag=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M93GKUwm;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473680; a=rsa-sha256;
	cv=none;
	b=cREWQvRP/w0SU+wYYB7S+dQ5pXLqd5SU4oCd5cMH8m4QIl7oj+aknd5lMl/UF3e5aIshyG
	fXeVV7xiB2g5OfYVyIbtyWoOjHEkPbAbPB6GTRpGagCzJxMf3iMpNn9IXWMmHvn2zNxzej
	heJXiQXJtXDMhFBms2T4b/9Lhr8nFow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A08044578;
	Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42D49C19421;
	Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473669;
	bh=8y/E1znlbCd1q689Ofc4VYyPkZptg1swcCnlIJzmUAs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M93GKUwmFTHOsLCO5lG36Dd/p12pIKWTqNHW/n+E3qyDLN22+8TXTMoa3Kc6k8l2e
	 vZW257WO67bVboMVN5RwT4IMCXN3Zpkr7yxy3h0Y+rVLfiLCGatUp+yM1/jxDwu+J8
	 R42BYirRuPQHm381MbPl4yhEjEIUvylqbcLY4LfyUwscZLCCg7mFzduJLU0icnAYR7
	 avP5R7LzHpW0FBnrN6PsR0Kz4KlVgR9p8BM6P9XbBquLDk433zandvUPIAEEe/5DTm
	 HX/ujj8qHrRb7wQAnIqhvUktthBiT9Tian2utjH6IMb2xx/DdCsv0B2ukjGozebPFm
	 iS/pgN2nqnutg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDB8D41D6B;
	Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:58 -0800
Subject: [PATCH v26 25/28] riscv: create a config for shadow stack and
 landing pad instr support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-25-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=2526;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=SpjXI/Sv2cms4/hPyvTpnR3A92e6omNkXvivaJVRwUg=;
 b=7/1Vo594BlTsNwHQrxEPTE7D01oSiid2N0KsylGoMm2neqMQJHVHRKOKvAPiaTMwtZpW320hO
 BXvd/dzz6YeDNqhItgEUfqFoN1nMiV1fWpYfT+iHK5l3z3s1Hs+UDTa
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 488A9140008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Stat-Signature: s8474398ndseq1y7rjcbmao865hiaxj5
X-HE-Tag: 1765473680-705730
X-HE-Meta: U2FsdGVkX1/PW1KcgMS0M/TaqbqqHP8BUSFm/Lvc9T2e+nVPoD5qisu+LeiVaRfocLEnhFSdJVyi6f2pelv5EkAaZSPYbKkLsWW0ywEUhnpa7dxCb8kCM3CcPmigEWOxL4ruqVFHaQuEdImK3eyeiA/S99BcU3cTOQuYv73J6A1yfMS3xQFaEPAx09BhDe0JJRnJ4f2cHqUoW6XHLGbginP1Q7+JLupXwTnuyJK8f9kiCTgTj0HmDqyBAD4GI4Uv6YQPHb5+tjcveM8tvuz2cHwNnBpf25vq747FOn+h3Lo2UcdqgRWU8w++Otv0E9Vi1gw/XLWf9AE97B88q1w4a6Dgz+yrHv0navfs0ZWYniqx2pmM91QeIdcS2HCMQ2toS7eyUlJ2EMyRgvJngFgkxVxkYfGBAH2hBv5zV9uSKbu+PLvSu85olSnFDYAXYeRRmHCJwqEv8jfrecrNtWijrOnRfEVFvW1SvUtklEwFxoNVAIMX9uc7/dqnbYoiy+tfDbQkmn9zvCixKW1YLAwszc9wHbayfBGv64VDv0IMB9hzgIAAACN6J3X+LqUJBM2QmutS4fdzlyEtkw16b37mfbOuNHj7xzH/Fhy1t0b9RVycddjXcHcCE6qM4c6wyGiekg46kagaQRAG25yRqoLqQ8T7dAsDaPz5FW5m5F29omGTSHKmyX67rD25oM+r8UL0A6xnoUwK4rQ0+dJ7ncepN92vgUvJbDpeijXmaskJl05rnBsyMVN+RLAmGSqibG3uHyL4cT3jIPtY6c+2FguGaHUCtK6ZP+LLKKlYWRivauHVD+V37jGt2AIbfI3gc9e3ycdHR7/vyxStW+DfMLSiYdXHroceoiMuz+f9CH0xfOmyKz4XahX6/CglQo2koudIkzFSkLXnEOE60qCT0JG96QTQm7OzEpnfKKrx6X8QHO0fOZ5P+YwiQr/cTl+oAbGSEprhji1fIr5VxkWMYMW
 hjb1Sny5
 3oUuPow/g41aUocZ0UNBpsPhCo5n4hSSS88aBwNIG1hGWjBDTi/82wzHuBxbnuLvSbBlmBKlzNBNipdqbMvRtLNhNO1PQoKXx4BcakZbAUExa3jdE2uAsn2EUFJbb32ZFtb9t2C7OB+4xI9MqWBKMj2tfvFQmsWy9ka6K8Ivj1bQtTCRCHAlwFE+siH1aY+rcpqfXJdl7kpy8j3Bsq+P9sndyw1vZexrgISQf306SPwhQvhaWCkAKkP6F0YUkNZ0Ug5DMlsBqWb6BhDu77Bd5LAAk2okfJo6k90MbnNtPHQXSjwmEZIHLnkAMuEi2li98gh8V6H9f9ibAdIbjkR8EvD+CoFbvko4OecJTcHUjKP4ZHbNwm3YLjxrO9z5Jyecg1Op3IdfcHzjlog1KqfH5dX/g3DYHwVM1thP5rwJ77I0r0Xz1ZRqjvc3gfMqaRvcQmIwEOs6//wR17rQpqpwnD9o86btBYE4XFY1zDzznA8DL8E2PwfjaOdl1UC25dh1jieqUkCh7bJ7ItRrwSOKrlN+zPgjTrfXr/VmcPTvEaCHCNpNrgG2KV+9lHCgWpByR+N2aGkBCBjVyfGOuuA9IeAp22NA8JE8+MiDg
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Kconfig                  | 23 +++++++++++++++++++++++
 arch/riscv/configs/hardening.config |  4 ++++
 2 files changed, 27 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 0c6038dc5dfd..4612a99cb387 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1146,6 +1146,29 @@ config RANDOMIZE_BASE
 
           If unsure, say N.
 
+config RISCV_USER_CFI
+	def_bool y
+	bool "riscv userspace control flow integrity"
+	depends on 64BIT && \
+		$(cc-option,-mabi=lp64 -march=rv64ima_zicfiss_zicfilp -fcf-protection=full)
+	depends on RISCV_ALTERNATIVE
+	depends on MMU
+	select RISCV_SBI
+	select ARCH_HAS_USER_SHADOW_STACK
+	select ARCH_USES_HIGH_VMA_FLAGS
+	select DYNAMIC_SIGFRAME
+	help
+	  Provides CPU-assisted control flow integrity to userspace tasks.
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



