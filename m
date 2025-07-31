Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A592EC87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9FC6B0096; Thu, 31 Jul 2025 19:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D37A6B0098; Thu, 31 Jul 2025 19:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8396B0099; Thu, 31 Jul 2025 19:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 475086B0096
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 145EA114CB6
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:33 +0000 (UTC)
X-FDA: 83726128626.08.7662FD2
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 499B418000D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=ndTbicKw;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003971; a=rsa-sha256;
	cv=none;
	b=lzvknFThYSrE4ICvMCfxJgOLs7V2rERhsHJpEWaIS2XqfeD0xi5/BHwTDlLltT34BqueVk
	ZR9n9s02vt83DOmnDT7YAqI2xchdIQgiMwdBdxay2uqAL0IfO40w/2Elv8E/08uWtENWsk
	+qW92vLI2446zQ7FSA7CgjWon2lIILw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=ndTbicKw;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ome3u7rmCNb01KyjL0hHySpySbFvJDab/QcqkVOgxo4=;
	b=W854dOp0qX2SqhFDYufof74VcdacuJxmb5z3FKhStBwjQ5psaKcwOuFj6G/GK2nthJgCSy
	pNGvNkcq8bghrwBEoUDNnsQO5fKQaX74oqDljvGG2++EkLIvysPcoq2m2x+EgvaOJWNQMG
	Ani9nmJ4VjQYzksSjHEipRIWE3h5MUI=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b3f7404710aso1332186a12.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003970; x=1754608770; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ome3u7rmCNb01KyjL0hHySpySbFvJDab/QcqkVOgxo4=;
        b=ndTbicKwAZa6UZxUh8E5opko7MJIb34V7xvUnDbYBnlfKNwHRGFpdN3cB1EdR/Nlfh
         eQ66KPSdToCl4XkiYi+sRxh7N8dAiuo6vITKh7/p7r7AYkSoxeTVM9aUxjbMwqcN/70L
         ienPQVZAU9Kv7INkl8M9WvjVgOR9JsMMp0QXV3UcE9EuKljRT99PooGpmcOG+5EmhzZ1
         8khWOvqoLf/MyNvccMsoAhVWxUx7HYs1NrX3/ZTFudtHKKfb5yG/wHYscJKnwutKG5Gc
         CljbSZqeJGe/v5GWpmOPtQ/PXaVRB7RrFOjznsVpCKtIh/b6U1wTXO4s5Ny1mxnJTfSz
         f3eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003970; x=1754608770;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ome3u7rmCNb01KyjL0hHySpySbFvJDab/QcqkVOgxo4=;
        b=b89a3quzE7roEkMI1uZPWXvV/MP69rOKFVJQIjMYndViOJX5X4fM3LV2pmBiUUoBAQ
         ifrfGrGA9wSaRCQBb5m2ujA6GSJCkUvaNF8pt9R73PWgTREL0cYzhcTn3zWjCq5dcDnu
         Ifjn3AdXjxszYojTtrrzXyRYQLuy5bb+4F/gn26c64sm4Czn29F3p4/Mha/PIuYEAmHu
         X3KvF+oCoOfXVqNqbhdroVacGpndT0ENnXQtQKGQA0FUDgUUfKDjFoIbKLWSzlnjwusD
         Wu5ACEtz8ZXFI1GsSa36ZHxWh7Ql+fXwy5yMQ3GPj688JpT93mnZykD3iRxWVi/GOPhl
         /LXA==
X-Forwarded-Encrypted: i=1; AJvYcCW9HmyF9UwJ51MBYPuCKOb7Pk+syd3wcW+Sxlld3kWAEGAR/ngb6qEIGNwsQxahU0AdrTrVERxFGQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6xWyMwYgEfuuepYwYyvmQmEHo/Rk7BNySlXxfFp6idjrKUpPJ
	yLy7/qhPIgHn4SkT7c3wcfQ3LeGp7gKH+x7f+cDtMGm1sZtSX132sQVQN3qnE50BGKY=
X-Gm-Gg: ASbGncuwBW5OE7nd+2ag0RNwsk82bLs3x3tolTeMGixVUVeC6GIebKXkeNNR1xFOzWC
	MtAfISgBuSMOogsrS9DuT3tzmeBAe8m6nesyfc2+b9n2Qf2XD3cQ9ocdORR6UXSQT/QPoRcAukC
	nfB4x4iTaq+Xhp8J20ot+NMKhwzv3nR5KIAX1//kX/gpem9qQ58AywZVf/6kwJ8Vg/lqWGeQTKl
	vzf1OhAgrvae4jY74fYezsakavB6Y3PIc5fetTMyMHjilnnQgu4kriE7vwzHkJSUUgePutoTBEt
	6Bcq09dh8BKDBhprBYddinEa7jSHighoRjEIAfYMTFmlb7OiwiLjth4AkcOygPULdKud9JGUzKT
	xr5uoHbtwSVNU+/nc1MAtq+FPW8NVTTWV
X-Google-Smtp-Source: AGHT+IEW/IYpi8/2d1JJvWg/cAIN1Y+XWLtRcPc5BAni0gcHSZT0OGnkDz3++3xD4dhcW2YSKWJWHA==
X-Received: by 2002:a17:90a:d607:b0:31c:c434:dec8 with SMTP id 98e67ed59e1d1-31f5de4b8eamr12568167a91.20.1754003970168;
        Thu, 31 Jul 2025 16:19:30 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:29 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:14 -0700
Subject: [PATCH v19 04/27] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-4-09b468d7beab@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: pyayus7yhpd5moturs3t3pq3hdyzrozt
X-Rspam-User: 
X-Rspamd-Queue-Id: 499B418000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1754003971-528170
X-HE-Meta: U2FsdGVkX18PObEktomeXFBdmz+H1sAf7LM+7oFM9/Mxvgy+rMExDiKty08FIEH6UGMwocgDrEc+hmDVNhZYhFcYPDEK3Gc74YFAuIlUXIhKrrAQLVCVQ3mDS4ZjLFZRU51+9Z3lToLJlmZJh5HrdZ9SnzUYQWcaoDKY9FEIo01F9AnJlJu/e1efq0A46Bs7dR+V3qJccJvfrE70TQF4wlrn+AqzKWy3+RS1aQa0id98s2yLXvkrRulYlFH0XXvMeHgvduhKsrGAaRcoyKoLGtcBTyGc/hNwgg4eI4aGK3+cgKOFlurTlT0cR2coO0y//Wau1EUGjfaR/ArSesxDtdRqqnP5JLSb6LpZCw4sK8bLk3Vwm828EQ5mCAb6XOy9+ObwRghOsMY3AkQ9897Z7wnIlRAFSqnkizb62rAbfxRltbpmhtAyFa6tHA9fZ/L1Ywy6bBN9Sha1KX6uGIz+0hP17lWZ6ABGnHxQ7DIZPzeh3knUMkUJJErCfHxsqRtETAAeei1sVQc5Lpbjjh9kzDYQg6E2t86qFzcdIA4U+NO57dpdqVQst/alIMEPwghP9tTDEXax+aANUUOKnSFi0d4hp4Tuqf7KLdsiuKIoBegJpkOcSfsxtdEi2AXJr0XfoQrUmUs5+v3FrcxmGLwmeN36Y1jjeOU4zpV7QcPp0fD9a4gvyKntwE4pfczLUqZ7tUOZZUv85jGstwfMDrJqFxlSW1oWhvoeyM8TjcuNdsrT9aTVj2SIHU06vY464Us+96avFpKkk3qv1pWEDVXE04mN3L+gPDoI3p2TYLwmKk1hx4Gfvayx5FqvadtBkU9+gpDVARw7xVqtlveYpSK4PYfvDIJfXP838nJd7+hwGlMUyfV0mdmKWUs5YT9rZcaqqQkY3D6B1M3ZmMxVY4IFQYtJ8cd/ARKVmbaMwcX4oPj4S85ifs1haYDYUcx/ePuZAzqF1rqWssA92jzocd7
 1PlJaRnD
 hgFFTJUrfhf9SGjuhQz4JKhZl6Vcuw+8Sr08QdHAIq/3t5LnNklyv06LBsmIovEBcP0eye7NSye2ElzrmrKSEHYGRjbtNQOSGm+le73rPHiYGd+A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zicfiss and zicfilp extension gets enabled via b3 and b2 in *envcfg CSR.
menvcfg controls enabling for S/HS mode. henvcfg control enabling for VS
while senvcfg controls enabling for U/VU mode.

zicfilp extension extends *status CSR to hold `expected landing pad` bit.
A trap or interrupt can occur between an indirect jmp/call and target
instr. `expected landing pad` bit from CPU is recorded into xstatus CSR so
that when supervisor performs xret, `expected landing pad` state of CPU can
be restored.

zicfiss adds one new CSR
- CSR_SSP: CSR_SSP contains current shadow stack pointer.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
---
 arch/riscv/include/asm/csr.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 6fed42e37705..2f49b9663640 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -18,6 +18,15 @@
 #define SR_MPP		_AC(0x00001800, UL) /* Previously Machine */
 #define SR_SUM		_AC(0x00040000, UL) /* Supervisor User Memory Access */
 
+/* zicfilp landing pad status bit */
+#define SR_SPELP	_AC(0x00800000, UL)
+#define SR_MPELP	_AC(0x020000000000, UL)
+#ifdef CONFIG_RISCV_M_MODE
+#define SR_ELP		SR_MPELP
+#else
+#define SR_ELP		SR_SPELP
+#endif
+
 #define SR_FS		_AC(0x00006000, UL) /* Floating-point Status */
 #define SR_FS_OFF	_AC(0x00000000, UL)
 #define SR_FS_INITIAL	_AC(0x00002000, UL)
@@ -212,6 +221,8 @@
 #define ENVCFG_PMM_PMLEN_16		(_AC(0x3, ULL) << 32)
 #define ENVCFG_CBZE			(_AC(1, UL) << 7)
 #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
+#define ENVCFG_LPE			(_AC(1, UL) << 2)
+#define ENVCFG_SSE			(_AC(1, UL) << 3)
 #define ENVCFG_CBIE_SHIFT		4
 #define ENVCFG_CBIE			(_AC(0x3, UL) << ENVCFG_CBIE_SHIFT)
 #define ENVCFG_CBIE_ILL			_AC(0x0, UL)
@@ -230,6 +241,11 @@
 #define SMSTATEEN0_HSENVCFG		(_ULL(1) << SMSTATEEN0_HSENVCFG_SHIFT)
 #define SMSTATEEN0_SSTATEEN0_SHIFT	63
 #define SMSTATEEN0_SSTATEEN0		(_ULL(1) << SMSTATEEN0_SSTATEEN0_SHIFT)
+/*
+ * zicfiss user mode csr
+ * CSR_SSP holds current shadow stack pointer.
+ */
+#define CSR_SSP                 0x011
 
 /* mseccfg bits */
 #define MSECCFG_PMM			ENVCFG_PMM

-- 
2.43.0


