Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B32DCCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967A28E000A; Wed, 22 Oct 2025 19:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9407E8E0002; Wed, 22 Oct 2025 19:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFEC8E000A; Wed, 22 Oct 2025 19:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD2D8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:29:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17111C0961
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:49 +0000 (UTC)
X-FDA: 84027344898.22.E681157
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1AE1EA000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Af/NbIuV";
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175787; a=rsa-sha256;
	cv=none;
	b=TMo5LgOO6FPfXy3R0CHBUrU3CG1NZ8No4gaLfmLyRe+JsquCmi71l+TctDlXYLwEvRWMDB
	htx36WEDPQQv4gjbcWGa7dmOwtdMTCAzKeApsGYC/F33OScosi8F+TYxlLU5FVNcqkWnCz
	isePcARpFozLlK4gm7OpP65L/CP2ZzQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Af/NbIuV";
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
	b=SKlnT6YTIv3amQuGomaX2h/ORfeuSNVE96U68FrSfuoIvj1m88jEXtx1j2qBMrlE7mhaYx
	pabwswajI67/xgl/ioEhwr09qRRLweMTHRHdWpLe4TPjaeTab5gdODvbXAtz8l1DXYnk+2
	oEwCzQZTzUbci617HaG6yOa+kwzXfnQ=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7a226a0798cso150531b3a.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175786; x=1761780586; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=Af/NbIuVA3vvqArBxRm/4KwwOvAI04wP5+XYgHnqw3/0+nf1c/j3BukM/MU2cVdkjb
         w0H3sgobnf3tw1JFgbAomR7re8zCdz4iENx9pW+TIUFgOqoT2PAH+7nJmVZDe2wLF7wJ
         c2bYVGEE1ylGfsTfp7nOlT3LEbIhTNns7iXR8CLat6tIl2ixR7qRWPS1l+Sh3Rrhqsq0
         EkrHkDi+ZdaupnZnV30Q7UBXCIBi9ZsojtEqzf8B14NH6KK5RPTh0wh3jL57LyinpkuB
         DgctcgwQrZMNV7/P6XF+x0/x0TEyA4EfTWwBZ3JND2f11u/ZNnsDBhD4id5+43bZU90b
         qv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175786; x=1761780586;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=N1lfV9OoOHlxK8w0GQnM3Z2c9AN8gup8qvpOoQSQDrlGVo03Nk9OEjLLz1U/U18vVj
         hkeuYWa+xtqlArLROnuOpa00OquVZSP1SRILOJGqD8lQXKf06YVVnAYj9/+KlU0iGOBZ
         jpja4P9rxEROTiUoZfn0gPIlgnGe8ObdQbdf1YS+P0MWGLzR1Zt7HjQ1lloqUhOuc7Xq
         zhHvuOaAy00i89yFXhLneOHYJViidPRJAWKdwFj/naYi4XLyed9Rcowb4F+ksXsCMH8J
         jOh2MBAUodSeBrTFpJgAfzmr5I24Zud3w+97VxwWRltTKVM8wThznYvqnS408ves3gN0
         7PZA==
X-Forwarded-Encrypted: i=1; AJvYcCUHhDAPhLoNJc1HTZ2G30p3zvofB/+qiDMDoGGlBUCFIz1ATxYdd8Ktt/wiIEP8je4OzuMq8eWn7w==@kvack.org
X-Gm-Message-State: AOJu0Yy5rqfnCYfAWutF8p/h+CXSkwBqstmp+/DeHosKrYZe/nJ5oszs
	2/GL9URncudIxuufITUnz9lvuUKzDyPGKOd8iDm0Zyauj0mqSB/zk5NaFYTi52mdcp4=
X-Gm-Gg: ASbGncsEWIAKBDwoGsmhQ2TkrKNkzVu4abDG5D70zLzHBJ+ezxQu5vOuGneB4jVNOZ0
	P1YxrBJYAShXt0hKVgWxgq9f8LBIO7sexmwtV2WTag8T6QGDHIcHDEsikmG4zWkI1C8j5SsJBgp
	HLdEYHNScuW/AnIroIPh65hYks5TsBMqI1sktbQ89LjW9ZAVCAlPHbZJSnaQEtYfdxOvhsXY1Fw
	8WsxjxjwR6rvlFhMUelh54rM2LLSfTT5tleEC+PY0Ss9iuRWr37qbt8unn8O06IEQtpV8Xu2ei8
	hhVYMLEU5/FOcRZLWii4hR+qQwAp5lLiVxXE2cOsIfTodurS5lKvb2vtAOf2GQtnujvRtDCwNCL
	nAopJ5Hbabb2DBkhQCF0YWskdbCAZnz7HPFNd6IGFXln4ACz8hLoI2QibzCgVSnFH9nflw+wJe6
	eF3wJeEiUmFQ==
X-Google-Smtp-Source: AGHT+IGpg9In2jt8/9pAPq15ryiECZkAZCWmg0292eiGIgEJkxmDrXUmRgAvAg3+aUxc5xibypmpsQ==
X-Received: by 2002:a05:6a00:3e24:b0:7a2:6e61:c2ad with SMTP id d2e1a72fcca58-7a26e61c595mr2577650b3a.19.1761175785988;
        Wed, 22 Oct 2025 16:29:45 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:45 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:30 -0700
Subject: [PATCH v22 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-4-fdaa7e4022aa@rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
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
X-Rspam-User: 
X-Stat-Signature: h8t314coa9te65p4az6rimtac83471kz
X-Rspamd-Queue-Id: 1AE1EA000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1761175786-581172
X-HE-Meta: U2FsdGVkX1/KMAQ3OuD/TI93jckRx1eC62NlJI91eu2gUgDM4t8gT10NOog5NsSP+5zp7BS3XFtl35cyK/osMVAZKpJX1ZK8/Tyydh9vUNK/HWO0lE4AfoOY+/Hl2BzcRX2l3Ddv9n5rKqlJ4Cvgt1Gwq4KUzFvWy7tYVa8LvNh9xTzRNz2MAPNOpHLtuOqJt0kLwnLDF2+NACmOu5NUReJWqLcdwHdX+iFJ8qg9i3iwEwwGvvh7tbDTUuAITjlwgEb/QFewMNm/f1pGxWkX0uT5ciITgAC5Tfx7qMaV2DokO2sHS2efm7ywa/csed/6nH0S5az/3Lm+0WxV7zETuYI+9yXCcGjku43kHQ/J0YeHaP1Jcjh3nnHn52KV7KEX59d9iFXc8KcxlURyqMFBRPWx35ocQ938EImPe36vZ8gAyWsk0g6oGWt6EZlAJMDc8kjn/gm8uL9kToJMfVVDtKjwAMgB9JxeS7y2bq5Lkv0cgXChpdHAlKOC1H/7N40SYCJrf339rYi0RAdyzNobHzW9wwB8ThUXqOUQ401QZ5gXKQatlJ2ll6U5TVStffd8St8kUFg6epmXA9E1fbSPfzAV8i2/6AQEtMBqkNymt4C5ZhPyXXIo4MVs4xsmbD6bm42rb9g5QekdlB1iw1KiO3L7MLMZethvf2+P6gDxzV64MwLytfd6Hf1+dI27E5jEujPwm7H2p2qM6PEAx9Qtlm0ZdkzoJCPCN67IWY2T/HI59ckKjw36m+8KRvOtQLrc8MJG/EJ94cvPvfF+7X5UHCI4nK5Z2oLxv/Gm5F13jXqbi2Gwz6XdKdAQWZZ/Qxd6ctfI2hoMBBHK0Ia7hl/7jmw7NT+y2YvJ+d1V7TJmdsYXFGTiIVXbBx+Wbyf0708kYyqJXM5FW6a9whfd391d93+QeOQJV2AG0BZU7RnCmEHw6i62cdR+rO/hjxfZQzJ1K6Xj0mxaO5ZsBiQltDg
 Ga1KA9f9
 sClIL5Fx2dPyrtUdUAgdwGFyI9qvAWksxkL7exeFABnONLoWzxZ7HvGdtsx9987s44cP00ZO5tbD1tQ0/uZAvEcocJ/Qj/8Mi9Zm3ej93X6W+VsuGTbAItNXpaH6jp9NKGYSEZZA8PdrMK3N0vcgemxAY7CVVgt8qDTcqtJOfXXafCWg+sW6vPu+R4JKs6BQWQx+axa+Zeir2xe/7K9fVt2F6jJJRi1usL9us0O5AZFC3ORUUqmTTSgDMbLf5gdYH2vGO4E/SsOgacZmCFG68R76kTkNouY7gpRr3rBRaa3a255XFCsyjdZkcWZSd9fJApsmzIHXLH3yEpSzpXOhT4lfV+SDAyJtL/nZlCGYdxB+21JVbWe0ko90jhBxAHcqG0Vs7S2AgRme8Lk8ZPYdyKDfMcIIOziqv1mpN
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
index 4a37a98398ad..78f573ab4c53 100644
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


