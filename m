Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ACADCCD19A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294C08E007C; Wed, 15 Oct 2025 14:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243AB8E006F; Wed, 15 Oct 2025 14:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C498E007C; Wed, 15 Oct 2025 14:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF1FC8E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD6F013A259
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:43 +0000 (UTC)
X-FDA: 84001149246.24.86FA629
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7D6316000E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NXrxmoIR;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552081; a=rsa-sha256;
	cv=none;
	b=Uv6kGQxRuObirkfDxSxI2ubJ2OmuNigjpmzCg4OGR4Xtev4/G0dKuwGK5Uj2nmfif90TCV
	yQLpTIm+wMotyMkFz7QlPo9f2hldqTeWp/DTttFILuSQiK/mzfCPBRGZiGi1Ov0XXSdblH
	SfRof2iX46gHG4Wh1vl3KRykEpJEjUE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NXrxmoIR;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dbof0LYINd4D+dAMCbCh8LGflH6StFg2c2dYAuc2+YY=;
	b=Jxv9g3B6fp7Vthz0kgqxxcG5JaAl0vJN2zGSJ56Hc6lWDI6VQozFXyeeunCuKenUAb4eGO
	Hvv2bbcGpkh6AC+veDksNzExpTQHZfW5kBjhi20aW9nqwLwGO8Veu1ZaiWvBdBIdYH7yDy
	GPWbPJqNln8IfQ3KaSH3XdcOaE5F9bU=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b550a522a49so5719731a12.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552080; x=1761156880; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dbof0LYINd4D+dAMCbCh8LGflH6StFg2c2dYAuc2+YY=;
        b=NXrxmoIREaXsP08bBNNtB3jV3hlvlRArgABCYyzqqh8JL1vcVvXIfywIoFXBxmA4gj
         ztI08IZotvq1v/uwHuzTj7a4clsVqEyNQ5/EfQeKZiC1OO9ouDIqfVtLhLp9rFALyQOK
         xMXO6COqmILs1eHn/WGIM905nt9VZJXycycNH9AK6icD6/VpqFn+tFy76IwSN3ehl5QC
         FLX8bakaK1MLuz+G0DiA5BaGRknGij1+2hjBMCdZP8eqHJjB4Zz0eUOQevpma4+RtwX5
         MYHkhmBChljMmJpoWj903ZYowfj8/YDZCd9FrvRO9v1GuEgpebe8XCLnKu1c80vtuiqv
         GGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552080; x=1761156880;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dbof0LYINd4D+dAMCbCh8LGflH6StFg2c2dYAuc2+YY=;
        b=FT6kq6B9hg2pKjWjkLo8vEJkjSQVvxqYvSsnHmkh6n2WUA2ovyKog9TdKPYQ0iGhYQ
         2TUMRqdFY3TEYdFtl+ZP1LLRJ7lrBIBRvUFqcpY5qtixH7q8/aVEBCBpde3dcarIpzIj
         qXTx12m04yI1jZDymUDGP+9yVJnTSJdqTsY8Fjjv8372l3FTaBD+jxmilQ4MaJ1liV3H
         OZcPsyumkv6ZZNOKK3lwrgYK2ZD8PDvuUiQGoMH63KnRFvVkJZ1c/gmjiCqm2Y+MjVRg
         QdNxy5mv12P9lfAIOu3JgmL1Qupn8yc6KUXX4dcohJuhHElyFZxkXp56n8GRguLf13kY
         1+OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXg4iZrr4wF4NELkXB1QTvNwa720B8EJPN3dWe8sk2rOiqnaego0q5SajFINUMkDCcE7oH77sdrsA==@kvack.org
X-Gm-Message-State: AOJu0YwYi0vK1VpZTt8WVeefskMYcdAqh9lh8OaH0KsiSFSSPDhKXJEs
	tILmTTslsfR/zYHv8nIJcpxnMfvG0NT27hNsrQmjoG6x0WivTisb+mOD9OrvqL3vdEJ7MUXPGcb
	fnSwh
X-Gm-Gg: ASbGncsE6ElpecV+RVATjlB+KhMNeguKL4IcdM1PZmSuq2Sh9HCphohXodRPIGfPQYe
	+ESepaMYHHjv8jUyagQCJfQ0uUo2680z0dga4owOozXkhzOqkePYe0dnUjxcrwvTJHIkHo0+TNM
	isNuoYL4gOJ/Z3uF6KDR81Cu8BjzprVsFw7wAY/jfyJPyeveR6k7AKwTrI/0HtGFF5b99Nux70w
	JNhhHp1XDSyFhJIgtZNVlgMX/P2DhCAQTU8+Rp7rOtA5DEm/6stt9xF0q/E+v9519mcch2JHK3p
	pcfPL3jUi7uuh2e1FF3MKGac9p/yRBA6uo7A2d+lRTL3kZKwL7ek2/vpkHtq6eql/O3GCs6XjNe
	W8ixKXjyjmU2Oy2EMekYp3GK3vRdyD+6yg+wZK6J6mcHLFQPPZ0Le4njfEOXXx4WVoIjrOChT
X-Google-Smtp-Source: AGHT+IGAsBeXLYnUBeSk4VeBAeMiRCSfs4dgrhVgQ7j/hrfP/0NXVnhFuxrL4cfJn2DM39e7oP4gDw==
X-Received: by 2002:a17:903:1aef:b0:250:1c22:e7b with SMTP id d9443c01a7336-290272e3a78mr384355745ad.43.1760552080319;
        Wed, 15 Oct 2025 11:14:40 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:39 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:57 -0700
Subject: [PATCH v21 25/28] riscv: create a config for shadow stack and
 landing pad instr support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-25-6a07856e90e7@rivosinc.com>
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
X-Stat-Signature: fz7qoi49ebq36xk3uzcsqd9jc4q9ogyx
X-Rspamd-Queue-Id: B7D6316000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1760552081-714614
X-HE-Meta: U2FsdGVkX19cdKgp3Z3eBu4YHRTFSz/PiYPSyQDipeZJkJUHEIX6XjR4YU5BZJzMHrnp/Yf3gllHjDxnr6yZopUpVUwSWAY45dcmjfY3AYT7xBDDx1+nyNo9ErMjuRJen0KMOLzs2pOrUziRaXWyawMqlT/rJWFhACrJkoVieXk+pIiRI2pNmfrRN6ETGKhYPD1rn+NSxK2V0fUNq8cfEQfzFhvGgy1VXPgmLoRbQ9YI7jzWExvwydxrzc8IiSPrkzw9VDesDnRcgd1ZggvSo/xWd5Fux+RJVBhR2eP/vW11GDV/U1Ah7bXSDCiCA0gp7lIgZ0oo/CefnUEPaVMRtakX/j6K4acJwEs7GJBF+h88NKCl8Gbqv/rA/s9jHK6Pza3d8W26oSkirRlrFQxmfrJiIHDxBwuNoSNRbJMqhtRLqH2qt0stJPLEBmCtHxH/AzYccEciCJNLrVgBch1VAjraLCPwkrxQgVTh7GpUSZ4qMmKId9nBnvGfMGbBxTC+F9RwIrbyH+vhjHjfLg7k654QFhckrH5MWEeIA+vD/EbPKx/Z7nJa2+YPxa0PZPSYfIwGR9NkfgDoNm7DDDq2XX13m9Pl6tdMrGOMrUb/H2JzJ/Er6kJU6kXJtPivMIMqPOWUzJUa+7JSCBqGJAt+QM60VcXfthifyLUoUamlEBMVUgGEQiUEN1Ux2hraqjO6zP2EXC/QUtXsLfjHEiMnstSoc0+7VMhlhqTHeyS7sBo0fFt1d3cmJV1hmM+IYV/KbRXTMw3gTCeZgbmqf/xdKoRazxEDTuW5fmxcXI+VVgYbkRRv5AnczHU3KVHOpCmn5G5Wgy0owWcIZouWcqfl1HHlavuGAVkSSlBfFSsKhTAkvR+xm9vBqRAtrijll+9sic6BJOwLRhf+dolx7qMaXBUGI8aep4DMbfyHKWJz7NGcgCkLxmN4wBpd8dEintWPQrc3cO1AullVt5QJm4+
 VGFIfH0T
 TF1bRLRV7eiNiSXwoFFrvlc12Az8Phlez7XAlDbTsI6IsC8BMHH3Y63FyyO8qUOmtxKRToVJcvYg9/povo7zIKDXVd/wm7YQLpk4cgrBvi5japyq24pfegoX96k3YZ2ZxaijT/MuEcKx93Jx0CTVLhnc6E1NQbYX1/J+s+rvdJrRXYN4c+rOMZbguAQoXCJ78rJHae3BwqAmmshhYmoZaqDtkVoy9UWpfl8+PvK/2N4GFy17NeT/0ZsK8HgxKWiE0gsnIRv7rNcS2LCO+WZ+Y/RNCKakTWzW7Yky2kHn5ROKGjePWwoO2omIDk5VEPgxXLODvE3rdCRV6NmO2KSBUiLnJqzUnEzFeioDYMT/wP6LYEfbKx6B5KWpefhkKg5Oi0PRRP5LuMEhXNsnkqYIcPHm8f0jzxgVhW+M8r/Fsbzk0YmESjIhs4Gf1D1Pg81gkQBYCjV/UwDngQ16fTqIdjBWPo9DTuDEXaylf
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
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Kconfig                  | 21 +++++++++++++++++++++
 arch/riscv/configs/hardening.config |  4 ++++
 2 files changed, 25 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 0c6038dc5dfd..aed033e2b526 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1146,6 +1146,27 @@ config RANDOMIZE_BASE
 
           If unsure, say N.
 
+config RISCV_USER_CFI
+	def_bool y
+	bool "riscv userspace control flow integrity"
+	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfiss)
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
+	  default n.
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


