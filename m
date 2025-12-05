Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 266BBD339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312F46B024B; Fri,  5 Dec 2025 13:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C136B024D; Fri,  5 Dec 2025 13:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B686B024E; Fri,  5 Dec 2025 13:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06B376B024B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CE1E13A4D0
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:07 +0000 (UTC)
X-FDA: 84186274494.12.1971FEB
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF160140010
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AGiadpQL;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FldpuJVG3boWADnTyrci9WEZv61t3vqu/iLtDVGsedQ=;
	b=1Ed6vWLqlrgS83tTf5F6TEPrgsDgzmasdOPCxM7Oo65WdzkCHtr9GgBB8nVWWWj9ZAeaGH
	ktUv1/L/B0ZCIm492Y5bsLXfEdvwVm8BpTLuHNewXQ8TxBuEJAEreex4Rtf+obxHeGkTjA
	BjjcNdx7+uhSMEhe8AtX++viztgezDE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AGiadpQL;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959825; a=rsa-sha256;
	cv=none;
	b=dBbSqOORzG39fesSay5sOx3Wkj1Q9Eg1/qcI02XWovDa3gSbXVYeOJYtAuGpvywyGJbacj
	qGO90u0dWKCa7rf0Bg2ZOOs3cuGg4m3do/OIqXVWakB4CDdNEvfTctuFTeczGwI7FYdNcE
	NkB7PqOF1C1WHNEfbGBEPFQ7s1EPOEU=
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-bd1b0e2c1eeso1971985a12.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959825; x=1765564625; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FldpuJVG3boWADnTyrci9WEZv61t3vqu/iLtDVGsedQ=;
        b=AGiadpQLG/U/K+mGO84xke3rKWRhAHmWtpZslr1xEtPJyLMV5rsBH3U0jwWbRBRJ+X
         aiY+IQCVFOZ4OJ/q2AMxwHoGS+g+/anZm5+leMjIfPS52jgR5yyPKE0oPFb8jaB4s80s
         p3ADELmgEeRy3d7A1pd2iIvT7hcpXEVDh/UgD98T5dqbLD11CIogHILqvVDDwBcvdTrj
         2T9lvYIx3jxROUsE+5+dmqQ8mHXZjF2/ju4QYmtDYH8FQL8icToNJhQ9s/tMn3kgKITI
         FY32CW7+L5kUbl5aWvBtvO8fPdAmQkVEf+vM3mTa6C7GWDDDQBiAFJhCDVIw1XB7toZV
         oPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959825; x=1765564625;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FldpuJVG3boWADnTyrci9WEZv61t3vqu/iLtDVGsedQ=;
        b=W3BMPvuWYvHRk6xPNNe3cY1PCYO25kvSrPgPZqju44UMa8Nc1z14Gew7/liQZF4ecc
         pZTxsVTlWmE02XJpBCqFO1dRG/2kuoYrZXU3Sl76QkUW9KePBecvVlAIaASoijJh5MlZ
         k8RftkuodY4zGIpm98eti3ehOY1IrYYmr9RV8M3faTcsOwVOn3NXxax4EMeHoOlvhwVU
         W5AQ4aic2cSXcOGc7PlPuxNAkh86Nmqy4qspIKXd7enua9cUVS4i9CzPzu5czntnjKt/
         Gqm4sr8F3wLpJglizZNQfeHBQT16ahYIYNd0DPrpZpLxzBUnkmbTYpD1IviYrJI/QvzE
         4Gxw==
X-Forwarded-Encrypted: i=1; AJvYcCUqnSOmjLpgtIwEXy2m8N/bkbRy0/JKr+Jo6mXKLEMwnD02OI96gxZpmEfatlao/OGkluCDTE6YUA==@kvack.org
X-Gm-Message-State: AOJu0YyAjMBohCzEwW0JOcF3spNJveltAKvlS88zRe/eUXeTsGvufiPJ
	Q7jcOWuVEKSq9S0YcNn2omnXrFlVucrJiTXm3XfEeY71rNW48fEE40wazK/tHgHP3L8=
X-Gm-Gg: ASbGnctwyuiHeERXRI2yEWfQtpOc/wUkAzCabvjn5k8lWoZhwWZ6WSHsN7K+IcKxEBW
	Vygw2Yli30X/UMs1Xy8AufP9K51JS+FB/zhrhoulCADfqJN5E/caMfa3wVTscBgamQuxwsW4DXc
	4Zmmajr4M2bkH583+9Y/qwmA8EUpfaSPObtXCMByRltMikqepIkdFFK54aMOLYQEU6a0ABHFttR
	zpbBEtQkrpCGXUFusS9IMpCFE5/2rHaFV7RMy1G6I3HrEhpOxmYuvHgMETgTA4RGYSkDTwUsrbM
	I/lOJ87zbUK7bm08k19/ynGS4gaPUPpEiDeC1/VyqOAdxN0WsD8+jBpfO4jSiG32oh9OR/dvO3D
	f06yJRsV1swmN9Vwsg+nsADq4sGyx6iwMHZFonfKp5fslsuOSz6L5K6Ga5DJxUU/zTauUo+b3wL
	tT4Q7BU18kwYAkeiFmmg5h2YcvEaOAElo=
X-Google-Smtp-Source: AGHT+IHWIa+CUlLJ0qe8tt+iE2caT6nKD2wfDSY1g0hDmU5iV9uKmwprZ5K8BpaoIbktQvNqImb1UA==
X-Received: by 2002:a05:7301:60c:b0:2a4:87e2:bcca with SMTP id 5a478bee46e88-2abc712e3acmr123339eec.13.1764959824396;
        Fri, 05 Dec 2025 10:37:04 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:03 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:53 -0800
Subject: [PATCH v25 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-7-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=1430;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=nBM+gKOHTmPMkti0DTh5flAX5grcW8t0U+G6mikLn4g=;
 b=oyiVB2mV2Xr0Lyb4BupLSuiXGMjHkUrkc1x6guHAqwdwHbYglV/kn8YYY3hQ4vZqsYqYf0IH/
 luTeFhKyqPYALE6hb1xL5HYvgU1E78HSbMsFrb/HbDOtyeGcM4VZWOy
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: c7w98xsn6c6hc43es1sf45h66nx7gf93
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF160140010
X-HE-Tag: 1764959825-227399
X-HE-Meta: U2FsdGVkX199792wg2+jyiruMJmwnPgNEkqwpofe1edE897X0rjCgVdf977JtkbrfnMtFDb1ynYaZ9dmbSNdvDWL2La7SORU5oDEHk0WDLgO8N+qoy6WWnKbm8MEKfkCo9SEkusr2+FR7/1E2Ki7FymYshKW1fveO3ntT/8XOZOd3l3RkV4y3ujwe5aam0+t6ZyCj4vQ3mN8tCRD0kucQSWGBxtOBa4OIBM+LyByZZyFJhM+EeqG7UsafWziV0NQ12DxJiYfn4DWrF708wDA7GXlgDaEViH8J8Fy7w5C6OUXKf3JXLcRBG35h82MytcSUc0te/966q+xNPjuz9/RWpw6vMKRPVvq+vdgCgf9uA8rjVGboxA1Cgq7dGQD3gnXnf6qe4ijFf9BSG41kUBCraDw/K1dWgDuHQ6bkC48TtDbwI+nlP9lrLafGzDQkAYLVz/+Kifh7EfGk6fzrUdCIQBrjoBAynwY0w6BVtOsdN56250bFWZL0R79QVt4GPRnPrTmr2l0OrI/ZadAGgTjfGWAWdPeXuLmxXl1qDkQvc5QGxnghQLwO9cSj7yyXa8l4dYIQ87+MdUyfNyVaqQvIjOcAK6/dj0dK/HDwVbi5YZbMW09NoDblejsdRU5H9+7VOycYHkcX7aQdOGmnC4u/v4Fh33p3SKXlEzLnqWPUhh2aOsG7ZT7CDzKIs9Etlsh/715jFy9Mvk/9j9PDoCxNLz2TPDLmTEW1KUIqCEJsTcPsmX41/jMvvtNhMbGwdGrWWmevHVwHrgkFSa9E6GLLvvjTSTz4Q/vvrNNVu4WE64t4vvIQtyAR3ud49lqA9rnreYanGpaN+PEXTyyeXr1Xw8SxU6uRrlrxbebUbsLYobjlWCgN6lyoPROwG4PXm62D3d2taFvhbQCCCqCqXJ5yAgRECee31HU51Vt2XL+lt6Ew+//45bIu5MfDw4NyO798pD8TgqiP72Zi032kKh
 tDF0fIk7
 v4g1N8+w28ksHjnaQPtoJasQOywj9Xk1uKQgsWYMY0OWTEcHGIeauUJDicu25PEPgEjDNSX9ggc5rn1Ha4a1xLCYEbjPaiIgiynHDskj3dTf4xwREp6YT1qZUNDHFWGjpDTB1FxPYKPckNMyLSmvXyWj4Kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch implements creating shadow stack pte (on riscv). Creating
shadow stack PTE on riscv means that clearing RWX and then setting W=1.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 4c4057a2550e..e4eb4657e1b6 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -425,6 +425,11 @@ static inline pte_t pte_mkwrite_novma(pte_t pte)
 	return __pte(pte_val(pte) | _PAGE_WRITE);
 }
 
+static inline pte_t pte_mkwrite_shstk(pte_t pte)
+{
+	return __pte((pte_val(pte) & ~(_PAGE_LEAF)) | _PAGE_WRITE);
+}
+
 /* static inline pte_t pte_mkexec(pte_t pte) */
 
 static inline pte_t pte_mkdirty(pte_t pte)
@@ -765,6 +770,11 @@ static inline pmd_t pmd_mkwrite_novma(pmd_t pmd)
 	return pte_pmd(pte_mkwrite_novma(pmd_pte(pmd)));
 }
 
+static inline pmd_t pmd_mkwrite_shstk(pmd_t pte)
+{
+	return __pmd((pmd_val(pte) & ~(_PAGE_LEAF)) | _PAGE_WRITE);
+}
+
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
 	return pte_pmd(pte_wrprotect(pmd_pte(pmd)));

-- 
2.45.0


