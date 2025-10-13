Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1842CCD192
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0296D8E00AA; Mon, 13 Oct 2025 17:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2AC8E00A2; Mon, 13 Oct 2025 17:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E578E00AA; Mon, 13 Oct 2025 17:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE9358E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AAA8160652
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:57 +0000 (UTC)
X-FDA: 83994451674.22.4603C21
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id A456C80015
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=UizS6CVe;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392615; a=rsa-sha256;
	cv=none;
	b=XnqKQSrzoKbNID3+rWDysx6uRsCp8WQZVSYCXTsB724wtd+3FppqAPMo4WV3aWjoTt1Jln
	NMGlWSNRIyX8SeU4XmLcuCvQjsCJOy36XNNmMDda8RpeyiGqm2i2Gvg3PcVeDFCrsKUWcg
	/OlcI2OMiTAY+3nrnc0Q9g53khWb9bo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=UizS6CVe;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dbof0LYINd4D+dAMCbCh8LGflH6StFg2c2dYAuc2+YY=;
	b=NqeNcBvW9BNektc1YwrtDEKclSQdtvdBC9nsVYyyPyw08NKoLfyRN5jcXwIswwhmLYbi/t
	n+SN2fC4M6n+oR9Vzd1zLWXJCMEpzDEbUOPT39RCenUKrdNaqJDBZcxUP78yGMxQebItH+
	hTcfGmGX9NAgPARsXRzNdldimRCF27g=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3304a57d842so3771526a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392614; x=1760997414; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dbof0LYINd4D+dAMCbCh8LGflH6StFg2c2dYAuc2+YY=;
        b=UizS6CVekP3KAm5kGzM0/kBe4VB4ttCjE/TzaO2ZwI/AtzBJvVMWUacUf1ZhN01KKt
         YFFJRleeMRUBnKJxv2vetWa0Nt5RHnoVNtmeeQtjhynWhMvle1AA3DyPOqj902FGs2lj
         cdkNSyuf/NUVqe3ZmU9lncTz15ZYCgRHfENGHFZF1MhZDaOFPgYGNaa7gj6pW5F+1MKZ
         gpv6KmR0DlTDZOltHm31mKd3crjhHSPPyGHKapEyS+VeQpdkulSwcIiBMe2WMzWSzxmE
         pITfJAFoI34JyPG5qAmVqOlAEzwlXlCmhTZmLdsd4moMgjYCmw6vAvq+2k0rT08MZSRK
         mbMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392614; x=1760997414;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dbof0LYINd4D+dAMCbCh8LGflH6StFg2c2dYAuc2+YY=;
        b=HXmo2y6zbTA55TMWAev4B/ff8x0EtPwSpbTYdmF9C0kN5ugem+Bwc1F/WTwwExGUCX
         eudNdjZtuPd6bHOb9TBwAknpCOOdzc937PGIVv4FgSgYJB/Es+ntfsqTN2SvRuuoJ1lt
         QfBVTMVvnAuTUz+cJSwQGeYUoxuhk0DO8GiyWPr5K/NsLLeN6UXCDz4XGDjwiEV5nbG+
         Y3GzdWHjw6WftvJlhJpofhi8qnH5CU0/Vmzi2yDueOchn7g8n6o9hUyLYPYzOC9mN2lU
         f1QMsGNp4B2drECBtfpESqskVlryo/dL9y+uHjLQ1sFVIygII1fSU/1btYdnqRxpjKSD
         02KA==
X-Forwarded-Encrypted: i=1; AJvYcCWzIxTi2Kt8Nizb+RU67uoFLRC1bldILq7MpRab2cyE8Q2k7lupbYVyk4MWEo+VYFb9coGS1+Gysg==@kvack.org
X-Gm-Message-State: AOJu0YyeHcQVlDWfw8qeKq/WjvVySVWYh7mA3+69sy7L89nSrRZetVGv
	9cFm1Ucr8gIKRvdGeiwLEs++aTLxR+YKqfiovHqDkJ1h1BcydbG8EOqEjJgzFPxaT3o=
X-Gm-Gg: ASbGncv92xbJlsaCiH8GHHMyjE9+gDn9CUfEH6f5zS6POxwlcop2s+OskOKeF1wIZbd
	xU5t13uK1IH/Np5nSBe6YoM83BQPmRddHmsAgetosYVeuxoLRXHf0Lng0hKipyLIR+oii9oDCzp
	Xn0bMxwiaKJ/ba1X3+kS7tlR3khWd8dFjPXLP3nEoewaJinkBLfxPSIifxZV9gBhn0n2RwSs4Wo
	+b0dg1SojUZm4rHijqUnycENzd5jFL3YXpz4IGpMjTasOTCRppdEwROVujrK5AXacdmWT0LoKz7
	I/pprRgQxkWujFdBdNA85jc0dKcT7CibdivkoIHUykwJXsipfx1SREz+UWkysjhhmUEYEacp/6e
	Rzi95wPwQ9IpKQ+L9t9Urb8XQt4Fe1skqezARpv24HFosmZIEV2lck1KFMnmyIg==
X-Google-Smtp-Source: AGHT+IFIgzSXP/F7dXAlqZ2LJnQcYWDmxG36zDHOJJWTPgNoALO0OawBjU2puecWF73352ydInfFiA==
X-Received: by 2002:a17:90b:1d8b:b0:32b:355a:9de with SMTP id 98e67ed59e1d1-33b513d005amr30620659a91.32.1760392614454;
        Mon, 13 Oct 2025 14:56:54 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:54 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:17 -0700
Subject: [PATCH v20 25/28] riscv: create a config for shadow stack and
 landing pad instr support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-25-b9de4be9912e@rivosinc.com>
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
X-Rspam-User: 
X-Stat-Signature: gzr1s73mb374af665dyeix4s6ds7ga6d
X-Rspamd-Queue-Id: A456C80015
X-Rspamd-Server: rspam09
X-HE-Tag: 1760392615-529515
X-HE-Meta: U2FsdGVkX19Fj0p0epMDIEhF2rpvon5uhVZ5Y46ym1p6E41uxch4pS3mf5PN6Yiko94RtMff9Akpndw5kWLs2AnutvRdWtZQn9J4Zel0YONvMWctNVAeuAwwCxrHqbIIGD90U0Yg4yQFDj9DBj5VUTj3ni3gL+B1vXZ9eLi9KzS8lEeCJ9yJZmFHBo/ICTsr8vfGTSQ1vw4un5OnWVa2rSbTa1iiDIbDnvCmP2vzLjD5NP40KY8+/Oysamx30sZAd2SK0dF/m0sjCX0jXvB1z0O6pxUoE7hWRX8UXR9cnuY6dRFx+31WHEaqamzBgPNxd3jqumMIByUT4y7WCKOQytcabXs97SXZ2SrKcaQgEgyBDNIrOuANFqQ5GBVIOMdpAgn4CQmDT7iRnYOXrOPikr0sHUsHqJs2jmyiTPQ6BZfMeVD8IW5h1AF/K3TNZkUS7+otPprt7GJ0NCmU8JhuHC5oVHCXOegxFQc+oLD4A5IaNQ0GIrJJ+4CexrjPIxXi19ZNTjijKt4SFYjgLWN8vWOB9/4BkqWQhJdUuX4UgkNF38gvw3DIcMxlCtRHzlRgrf7DGrnSAAIkXVHCPML7d2JekPQmSBjeFHJJui/HsfBtZnCFQoJtv6wZxORg8Oc1KZbPrzCGcZODRH/6SqFU4PuRI0EzygmcC5zCZ29jcYujNskmbpxgaR6ft4+X+h9Wgv5FBBuhCJMD3sXvDgqvrUTe4GiqqjyNMcO10ZosUOdyvS1kC8AC+nZkUbWym94EGljX0q5v8/EJCEWsXjzWJ6gEQK+Vkly2gwnp0Z++PXt+Cmbf2op+PaB7EqXj15v2Pr0mSKJAXm2lfToKuEMjB9mYIzQFIwLjtsI6bAsscGkj7I+W1M6LqadunQWN7G/KxR2qMr34a6bkHtOv4rwaWZidlyn6b+GH5eZIfpLHNv6DwKk2JsA4TSw9LoxnQK52m2B7CRvQU8OhWcEpCDA
 jK3xZS0T
 GT0Wl3gN/HMnH+nifZa1JhlgwHQ1CjJrQ/v3T2b9Q+M41vEtJJ0xQpL+4pMXQA1UvnQHj9y+Y9zSLNhm6czb+USXc7mzwskFDNP69aJkEC9FyOlxNpNsmkrxO/xK33rFLBQwolzmtIobe8ArJx+66n0MrPRQrybX7K+ueBPfYmxRXPP+NOPYKbie4LalPlaWP/FiL0rlaOuND5Ye3DJUoGu9oO8YrLqKJIb5EhXGM1COxtP/u13Gd1nk6iblybiNfD5i/l7i+plYPIeufVB4czNSEpajrBoMpDffL3jxBW+33ZTWP0WS0a9jQK0yjKTxbkXgxsYQKkohremVTLqLrWY00+v6vLCQMtFCpu0ksQEcc0FBl047ZZxea51jOmge6KVuBMyzhTtow7/X+W/+/DlBICazcDzZKgn8ZEXuqJ21bbktBrLU94gNvjOFyeAPEO3lxGVzhrW5RiBBnwvBtwEh+j6SDm5ClrBfn
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


