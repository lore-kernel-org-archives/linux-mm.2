Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCADD2A524
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C096B00B6; Thu,  4 Dec 2025 15:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBBC26B00DD; Thu,  4 Dec 2025 15:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F276B00DE; Thu,  4 Dec 2025 15:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 989046B00B6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 599FC587E5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:52 +0000 (UTC)
X-FDA: 84182866824.12.910B80C
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F31780013
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=e+Nlia6h;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uR2ANK1p/GtJMLoYkqluiVL+IiMuKNKdjgHs5HSKwC4=;
	b=NkIKXLlZQF6hAEEJ/jYvxWBGZSrCibOJgOOo30xzOVE9VQGRyrkUUh1fhVwajrxiStwNQK
	o8qIPi4kRLJwY1Xqk4c6h8AxRfQM30224wu+pwSuq9bGqSCBazXokIGMlfCyLuOCt2lPKF
	9I/8qmZiqRyv0ZUcIH6IpbipBQbDYqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878690; a=rsa-sha256;
	cv=none;
	b=CYhKznEuBowkSZYHAleR450tEVMagPCzHsBFEQsg01m9/mQM3KQF2hNS/PuIafhFBQXVzW
	dXx0/85sveOCq0RS6ZD1ghjhqF68LksM3Jcjf15fg3fRmvnRQUFVz5MbuNSfR03/XH5L1b
	eA9M9AJWvEcwEbIDW6/1OAB2nGnyQZ0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=e+Nlia6h;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso1542827b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878689; x=1765483489; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uR2ANK1p/GtJMLoYkqluiVL+IiMuKNKdjgHs5HSKwC4=;
        b=e+Nlia6hNZNDea5D8ahhNQgt1xF3xIbA0kJfHyZsAy++5eCsNTl3Rn2xVAC6BC4NId
         fhh3UyqeFlA7eKn5MxEQdm7gCxBc3QSjWxHTzzLDZWp3OZ5kBJQ+IrTZvFzrPTNKCcWU
         8hpRQ1hQkhxKPZjad9nC37+9s24ReN1/6i3xod0WBPC8eBB7vEXG6qg5iTULtZHYovna
         EdYLkueoVK+JVOFbrPeV/ZmmTuzS6exMy7mQImnrruvjMaQqfmnfnwQP/Y47SWcW9KZU
         zsrNPNRPy4nwcLj+m74TzKExlaMZg2ZdTLVnUBgDShNnaKM2hyGGyo2ICXc8QlXORlsc
         Tyfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878689; x=1765483489;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uR2ANK1p/GtJMLoYkqluiVL+IiMuKNKdjgHs5HSKwC4=;
        b=cMw0Smsz18Wgv6z66Wk0/UNKmR1R23U+BgwkmRYsUT5a0m+qMdmeh9iTO43ah/HCLz
         7XUUIaLbafcvEPuW/bSBG8OWxakCfLafbuz547h3BM2P2k3a6v+NsK+SVo0hdSgtOv2d
         v8D7qziC0mBVgEofD4MJO4wimsoIQeOGxE1naoX2Y/OpCWhgBTvCnhGv2VajpRw9N/9i
         hj71ogOuuFUw6RQ9T+h1ovdSIf98Un6LWyjzHqSohjXK7D7/mvr6FXHyCvM38MBNWvrd
         4AQYGiGtLhXBdf7DO55VhDwag4b8/paVysQ9SGkiTABQXxPtznXQnBBrJwLTrf5dnim3
         yuWw==
X-Forwarded-Encrypted: i=1; AJvYcCVeugcdtXdOofg4O7z3oWnJV4KDXDeXa9zUPIl0whsSvMoTJh5J8xq/UZyvgYOZm3h8xCM971m7kQ==@kvack.org
X-Gm-Message-State: AOJu0Yxs7IaC9RZNrgJ/3Zig97D+/QMoGFtu2o7IHVhr/EC4IxDDfBdU
	AXD0Xh2S2pD4X+IazDYQ5VwJg55fSfaLrgnuLndNHD/OqsOUyHT8h1C7qQwJfwjhQjM=
X-Gm-Gg: ASbGncuWBqwNIPtR1pKp6MS57jKYwg5azONuJH8sSgvTlxg2IpIUjUMTcOfLO2ZMK53
	JhcgDJMsJcU35Xts5TX2BB+BfUxAYu6UhGkQDcQ08Y/D4yO0lfJNzSU4ooTYRrvsnopF9sO2iVu
	QfzVAQPXy3uF84JuIfVlLTHjpiMvf/CnCUQ3VlE1YNnFYzkvV9qvj51UVJAfp+6aH9iydZUCkpe
	YVtFsYu8dOjfk23Qpw5Q3RIWW3P4p1KSswHOb4W+efoY05Hp70ksiw9LLwD0cz7S858RFT0Gwkb
	jxl03MyslHq8UhuWAWd4TLCGtM+weJwnKTXLh7OcXR8YqlMMVq12YpIk3I335xPma3zodruCb6N
	xvvfhjd7EMqH8ZHS0yoswlHRkubsDjOnf17RpXNG6GBCxYzhcDZBnNRQTSyFfcB0VjkLwbPsO+9
	6RaWI7EkaMuBqp6Zo3eGge
X-Google-Smtp-Source: AGHT+IHr9eCZ7OoyJRMHMKZM3eAa0ZLkjuqDEJhukBTDFAFWWCXqX+gcmL/RFs0P9XhWOx4pRyl01w==
X-Received: by 2002:a05:7022:fe09:b0:119:e569:fb9b with SMTP id a92af1059eb24-11df0bd1799mr5495837c88.10.1764878689024;
        Thu, 04 Dec 2025 12:04:49 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:48 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:14 -0800
Subject: [PATCH v24 25/28] riscv: create a config for shadow stack and
 landing pad instr support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-25-ada7a3ba14dc@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=2507;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=+ngELFAfNSDVPG1dfl4U/GNwgJgSLmHNPMTUuZ2hwrY=;
 b=iBrp1RtTRh5oJZVzaOaeFhva2V5Z1q1JFj7rzOxyzprKnymzoWjN45RvOVAV8T5/wMd+G1JGu
 G1MvETpgLboC+3bOxlsHE8Ns8RB1GZmzEixY2AHWIc1eUxbU9mIcSne
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: 4F31780013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: megueus9g9zhgj8p5ebxuhe4eek4r4do
X-HE-Tag: 1764878690-335160
X-HE-Meta: U2FsdGVkX19lXXcL1iZQQgG3wvMgN3mFyemck014N9K83ht5qLN055hjepCEFKOjm/2pQ04C4YuDRF2emCMwceUaT9gLCsKjMBrDO4BbOmIeK31oRoPJ/WlIh1DX1zcO188MUJKRcP5SNLKQN9P0ruo5gH+84gFLwvyPbw1Incq26tEmhhuJPXdycriUGfiHRK/B/qV+uJn/NglKbv3VUuy+tVVjpUHH9DLd0xGbzhTMqFidaGR6kS0mCuB2hyiGm10ZP6Dl3eMD86EbvVlZ+h5sGu0EQIhYkYv0uYhlB+6r3fhDRC7jDaaNsOdvsC9h3yEDyu4sWDujvndsSkveAatXH1JEJJtZin55WU5PhGPSdphkvRWIqIc3NPAl/epu/5xNI9CBKzKKuqaltInXiH1VyBEgOWDfrKZGQkKpfAzwgh5IlJiDSEB0G+BdoPowxh1vq9e065kMb/3BC136s3KqUW91lFGffUe3jNudVlo5s10P7SoEdAljjncmoCPHaCSVfDrtN/kUiK6sIsFuPd6q8FZ0nJjMIXEIVFNjl2bsdPSjlN5HeR36q+FrL8HBex1LlxOk5CUPS/TSRiH2wER05/LBOYcBf5xBI+/MfE3mwqr/M0JoaK1p18w2o1H1SdpY3tSBUqg3eUzBD2815dKIShjIfwq9LSUvugV2onkt1o//HDwd2GOGoqSr2osc9bsIZoEU4VmoT0oZdxskB+PeL14fY4LvVB7F6jFSFkC0hKm+vnePL0j6hMxhi6vNSkEQgumlyoaiE1Q6wCVNidS52gtHc9gFEqYQtoV5uMbzPYTXlkhyVOdSq1gUhc05Vxk6m+RFOMpl+e61AjbOr4KH7Pp3ykQUyN2jF0eaFvwUT8EggtQsgPcaHL8VRAvAiI7Qscbr1h7zT0K/3jAqAGYa5FKExnq4l/x3zJnbpzOE7dfL1IEcpjlvXxbFgYoT7QadHjVGzuGIErYTLkB
 NrHVxiWf
 l6V11mD9vpX7fXAW92WvOtKjXeR77ykIlD/3dUxZYon86xE33+piwANZg6X3vPBI28nvt62JO9LuVmRZdoNXZJPHuLDdilbvskDQD5oFFApqSUFp6Ui7SFKZrdslSTfxuvDDwSiUzDr6kVNINCmK02k1askwtR5wpYhtNVmyQAFhHHtbaV/U1vKKXerpv6cI9vkgQfJ7OgES4ZGRUdnxqLtPurS5CKuNcxAgvvKPsFSZGQMCeU6hhMzA0VU5bG8qZMRKrhBSkkldhjT2laMnsrXpQbuArJmbv0hh75/i5O4Mqt366A6cq7LyJZYsFiGKI06zGSNDtPOrRhkOGOobylckHTxgWiLOBTZfzZcxgeP3ybeGCtwXsVZHDzhSlOoIJaucnWsrRz5IBQNuh5aUYaHuBOrOW59TlwyXSGJSHFqLChIqfSLbeX9ifbIIDbfNEjUOy7BMq8bTBuBM7d/+OQC4CYVbYBR9YPGtE2m4qppSgNHmqz1ltuNDAd428szFAWRZ4oCcw1IoJz3tJA6+uL39wVd/EA6NIKY/c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.45.0


