Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83E7C88CB9
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E88C6B00BF; Thu, 31 Jul 2025 19:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991B06B00C0; Thu, 31 Jul 2025 19:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859E56B00C1; Thu, 31 Jul 2025 19:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC666B00BF
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1EFDF8104A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:35 +0000 (UTC)
X-FDA: 83726131230.26.36F2C95
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 237FD40007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=K0p1DYjB;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004033; a=rsa-sha256;
	cv=none;
	b=GHy52+wLtl3/4jU2rp+3bGF6YVEh6pzT7uA3PcrDg7FQ9ecsP5QbsWM9ckz77yg4/P88nH
	10RjSLACWzqieyw3grGGy5uvuFyFVwrI/K+84/458VAiYF5PfhWUXpCcJUefutmyHqYsje
	bUEDx7tN1sE5H3aWy/nOj/xQgjNF5mQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=K0p1DYjB;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGYKU8oEStLMY+WKb4utGxIDZo++9HKS8iEvkqWqbZk=;
	b=Z5EHfWzZ2gwpFHg/Ps3RhsEsqdmtXjYwYXtt/7aEkCBZ+gNWiG2cUFYfRuQ7a06oDpwpUe
	xzfVXB64Jb7yP8Z0L2nU6UUd7h9Egx00JW+t8VVoTDYA7Z9a4BPA+4IlgDATYwzwqoE624
	NTGwp5G9IIVPhT/9dPZwyn4w8Rsdi8k=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b3be5c0eb99so896562a12.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004032; x=1754608832; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGYKU8oEStLMY+WKb4utGxIDZo++9HKS8iEvkqWqbZk=;
        b=K0p1DYjBFxksz4uxDCJ16rL4TeQUqM+b2AgjgpjyCkjhgSuQptf5o3CpZlV0CkoRZ/
         BiScUGsAXBPiR7cNnvXdDkBnw0T9kUbSCP3BY22O1ojc3PHFyqXYdsVi8kiQDOAybdWg
         rgZgVaiI12sBYXZxCWyLvXVKfJRN4+0kLe7QS7YmYePgwLqjKKoMtoIe/tAf83/PmBx2
         Hq6ggsl80LCs2Udq2KfZeCm+tuoVwuLz7fFmT5JcECLaOQu08pdIDCMWmJ7XCH4RemMW
         QvHZq0tqX07WksRsxzwlfQll0sU+7wi7KWtzhU/gO9iKua+JHy5aQQLkWv19a4uUGLFc
         HrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004032; x=1754608832;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zGYKU8oEStLMY+WKb4utGxIDZo++9HKS8iEvkqWqbZk=;
        b=rcR1V0wgG+3NgPzWZojGJJnmMQHPVFF8WMoqYfHRTXWELmjqPWOLXLG+o5coCduwCh
         sK/z3WJnt/qmmey6fxmuNy7aw+AU4cKSgSoLKM7lSascgL4XJM+oyYH4+/J/5mN9rmA8
         v0cd4ML1+Xkl+x+c1uMCEOxeLJaQilHTHECDkdNtmYg1mKRt785oBDOeMTFj2x8lAGZP
         tO/QN8YvZi2wumBX4VuUoyTHiXHmyeK2nPVE/Cs8ymPouDKwoBQXF1/oSzeu+X+sITKI
         UJXsNXk6zKdI7AFKpKJyYRYwzS39XtCobiWma/a4lklPhUX6c3QS8RlFsa5uirRFqn68
         w/5w==
X-Forwarded-Encrypted: i=1; AJvYcCWeBubalELW2aApbLDrYG+xQDBLTQrd73672U219g4sWzOqLSaGwzzDdUW4ZWOhHOljsRlPj3FxSA==@kvack.org
X-Gm-Message-State: AOJu0Ywx44qCCkhyUQh0rl7ocJqc73rrSQrd5TebN2TlhvOHI7YvApRH
	4fjjef7GTGn/yl4cfDP9zXCG1QZcdOgZ/eVvMRQ1AkmMEq4QOPFLv+tNhrb0pRtkb3U=
X-Gm-Gg: ASbGnctMq/XvmTxUQRu3DYt6SrnmEc+tb8OJbUrIUTiqzdP5Q9uB0wpzEHECrKA8EKu
	7878Dz+xdkOh4QInMWZFVYw2jR0dGpO6jVEhUJAVrm5OHpc5yZTBP7cTA5vUKNUQw4kBalL4a6s
	/IPplsdR/cM2PWuXwKNa3kciyQK0zlxXo7FsVhbaUCCAE4zMCw0K6mgbzlUE5+2a4P2nYsfk6St
	U7yvUfBfIoMZxYLjKJ0Ka4dbQdElJGN+cecQToEVSCjFUF7v9765gYEY8yNOJycOQNtVxOKZ8o0
	sZjde52M5p7FoC7jHBEx2gd9xZKxvGxCNtURvnYOXXgugAkm/SQTKJrAJ30xfLNVzLHe6M5TLHC
	oBLarKB2qwV3DkT/lBflwRhVbOquBxKKu
X-Google-Smtp-Source: AGHT+IEBs7LutVwN0PKX0aA2mBtgJYhvV4n145Nel5M/EJeFypNMhPK9pJ6ovYsY7ICv3krp+mHrVw==
X-Received: by 2002:a17:90b:5826:b0:313:2206:adf1 with SMTP id 98e67ed59e1d1-31f5dd6c4bdmr13449189a91.4.1754004032001;
        Thu, 31 Jul 2025 16:20:32 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:31 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:34 -0700
Subject: [PATCH v19 24/27] riscv: create a config for shadow stack and
 landing pad instr support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-24-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 237FD40007
X-Stat-Signature: j5b7kieyt38dyy9duhhx9cmg78enrtz1
X-HE-Tag: 1754004032-549686
X-HE-Meta: U2FsdGVkX18Y5biyAVF2wsU1New3nChXEfvXMXI5sFzdDZ/+YI7diWmvpPMvl7oz7xzUoKau6ps718Qjugi5nCWAivpjjv5A3J9VRF1OXw4X6uqFEiNavxVvjtXeBMiBLHPh4pNjQ/GfupryD5uvzFn0I+iDG1NGzkKFtqYXKhZwJltvsDjwxCLYsxLrBJaD1gLPMD+O1OkNJVWpZlEFaZl7SPGVGeXcCdLIpWKVrTI6A8KSb3H+yMI2D8nK8EjyI4PGyWwAvEDYy7KlP3tVaoEVNBW+1Zu/+weRBQIhB7SRIYAMoG9uJ19ae6Rm+fizgXdvVSeTA2xKwtFb7yn7RjcyFZjdajKjxppOcAANJQkEDG3YfN7NUC1jceuiQ1Iv0H6F6YeIKr6iBKvMY3D50mXMRhYJeGsOnlxhW8Jx5qITCrkP5qq8gI5YPR2eKjrqI96E1gy0F5DI5yutgKWqxTHqjjFUCNxgLeiYPamucIHOb2Pev1zyAwVQwIpKn09WfWJiGtHuOgsqAMuhSIbW8cQwPWXPsdTcXQoSCzjj1O6WJvYkz/m9XZok2TVlLKRkM+iCYia/SqLbXa87rv+XRkGnQUUHmrQ8kKbsGSqYs2EgU52Q8qzZen1DLbPIBWGuN+mrbaex/vH5UhGYkd0WcKdBHBfYW7E9vFWbVpyLUrnrWrkbOHQLOXZflkmbfgsHa7OyjtIF1q9rYP/nL7lkrlmq+8hv/zrJ3tubHU1qrk8AnJ/+7Z6uxljHWKXZYdzsh6mrnZiRT8dbGB8Y9N8OBH23Tw3MZ9FanEy6t/X/6ZuvegmJMg7Yssmb13pzDPm8EiZWYSPi1BLgjtWdcqQduYWUcUSudnwBN86mi9T2zC1gVfuKigUULoGDjH4f0fk+LzEy2mGz73FatE/jg1Ai/tHDXyM7jYBa5pkncFIWAiFGRqPVPUWd/lcxCGMFeSMxXe0WT+9NwAs/rP4XyKR
 Z7cgdPMn
 F63X5NRotf+5ittq/Z0Bf9EXciZM42FFNE89x3HRFIpPM6y96UWM+ytiV4w1ZXHXLKzp+lbgc9/pBXZjFFb744Gj9SHryeouSZMzgd3SxnMeonFyQwvvJRMKoaKQ9svssFhf8QDLFJQbEwlHkh4KseEtpxI33tKVwtPnSBc+pRK292ucWNf2Uwgr82DoiXgksDDcpp8v9X9uKcJO9WBKLxYP9ohUtO5HPHoxXs5vS7XoqdJ/zVTKXK7eHw0L9MJ/00rCK9PDMcHvS3ygeHfIR/CHx/VLxTuJ8OMsRDG4wY2tpEciOJFN3emqGkJ8Ddh8IJKtUcAD6Nh0WkfJrwElgz17nCuEsygrxX2aDMRkFptswDDsqXFvohYYcCyhc13EsQBH30lVmLulAJ+JjWdOgH0ivfWiGc9yWjANuTQTplg7j9EMg0x6w/JFdplBI6jWKzrgpCVS2PQ4I8BeZFO2Jy/tyIS6yK8lyPXtIscQFlnxXEslFVtTh1RB1JiNt6TjC0NXBe9AK4HVicXQcmn6cLkJ+ZwHUz48bjpDqNn8crht5hWVAQTDqkgXL7g==
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
index 36061f4732b7..385c3d93e378 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1161,6 +1161,27 @@ config RANDOMIZE_BASE
 
           If unsure, say N.
 
+config RISCV_USER_CFI
+	def_bool n
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


