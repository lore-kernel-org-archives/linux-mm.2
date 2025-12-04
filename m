Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36FF8D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C55B6B00C5; Thu,  4 Dec 2025 15:04:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874FB6B00C6; Thu,  4 Dec 2025 15:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7160C6B00C7; Thu,  4 Dec 2025 15:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5190B6B00C5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BE28B8915
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:10 +0000 (UTC)
X-FDA: 84182865060.01.FDB8785
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id F249780004
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=WK5G1LLj;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cETj36wQ9Li8D++iY1PBxUMbJIR6wBVZ7mUW8zqZ2ak=;
	b=EhSZfiRjnU1mHBk2C2yZ3Ad9wTyCLH34sM+5AXaYeaFFFmPjavR+MLodM5i57jXvh6VM/L
	9NYbND9d2MMPGYvC2BI3T/T9nb1uhWonaPvlCSJEMXGDmg5HyfWhsKA3QnmpNsfnxaCFGx
	SUb/AiNUs9fbs+qZMeJW3KjMXoqIH/g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=WK5G1LLj;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878648; a=rsa-sha256;
	cv=none;
	b=mmZt5asodKOki3Q4rvwGliz2Yj2hWSOBP9KjUVdf2ERvN07vb/muFttjm0bEXjnaCnprkl
	CvBPWAlgWcW7Lu8UcEUx8irlpjvFTvOjEWstUJDmUvokIDxGNGrWCpyIeFieoP0IQuqMgA
	AprkzgIfqnCYeYWIHDlwMzXAHhOBPLE=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b9a5b5b47bfso1097342a12.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878647; x=1765483447; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cETj36wQ9Li8D++iY1PBxUMbJIR6wBVZ7mUW8zqZ2ak=;
        b=WK5G1LLjVrmfOidGE6YZfwUL893S3P0tnu/dVcLvrsxmhBXTjFNx3DAXp4saLvEsIN
         YFSQUhqlqTjwb5O5IhQoIK2X2ntuB8ykA5IyzlIuMxP2XPba71BN81Wdun+1Xv2cM1sr
         otI8onCPVDuDBrvximo9Anzxug4wqPCEJCWmlfdPtk2H/zHAPjD3G64iYdywqCcEJxdH
         HfdPi6Cgq4fDfkdKhSJ1MTCXUfGiS9EquI/baIDJmBI0nF/V18DwK2e2Jztg5HSRsCoW
         eGD4JT5mCERIGOwMG0HKM1niidRze5F4h33nY+JOl385pCt3UGDbO/TFwQ5uUhqveMi6
         6WOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878647; x=1765483447;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cETj36wQ9Li8D++iY1PBxUMbJIR6wBVZ7mUW8zqZ2ak=;
        b=D0xHCvBY0YxfJ9UjIjue75iWY670f5cWbPhY44UW6UXbahjG5gaayoy5HKd1jsmhgd
         P5wM3WFO92xVjsZmWYGZI8en8I84R4qLQxy1dUCDXuqUq0KC7CIBlZPZ1Ob1S7eFHG5T
         XX6PnjpMcgnB8KNixNjfIReEf1gTNLb2bQAJ+Zb4krurslH5GXN7vox/E6dnif3YsH/U
         3NgvFrjXetOlN+Qns/jb6VHdFoEkDV3cUgufMxfkaiHOkcJ9gAbl6dqFAxiuMBCjGXm6
         386HLVaDYzMMwc0MIcCbRFrBPqW4sdSjYAdTcURdCyb5HmIRyTFQNedmoPr2SpYE3osd
         MDfA==
X-Forwarded-Encrypted: i=1; AJvYcCWn9+9t7aFgkWvUHvEHT1hFdd7YL6sghXFb6zDzBSjCqKJos19NqXPorECyVZGe4XnyQUC8wNHKmA==@kvack.org
X-Gm-Message-State: AOJu0YyR1C+7WX6QdtQsvE5Sf3ToAReyANPTp2xrEju7WrUYjUYo0/h5
	9pEVxGswa5B/DHYIBrp9bw85EG3VSB8JcAGrQ8Ui4KZ/TyDZDaXCAUqUwft05toOvLQ=
X-Gm-Gg: ASbGncvX2ibEzrfXn0Qb1KiG1602vdkfsQxBoePVlC5AvtEcaDgM+eLEmQS7FRFLMGy
	/TDt5PL9AF0LnHlELO/L38fjUrMIrNxFV65cL3urTym6A3eaIwmvr5ywoQHINcJ0OasLkti71fD
	VvUzBRF7MnxWFSfjZ/ZT8DZIAE1fuKTX2T+TYTg1zD4V6bKERK6lWOF7lLcULhyg8KqNceiz0AX
	6Shm9h/spNrp3dxzdLF+qV5a2XvvAxwZN/1bLcOoWY4DdeZs1YVuhhr0tlq6hK0t8s1ATkujKAO
	jlV+eOyW3HfD8/akROlbVptKQ8VuEIpgtbt5fDi9pEwf7UhCQmN1zacSHhpcHrEHkFvcI6EytBQ
	Tdt78hDVVe9FrFF8NicIdgVL33aoR86kRoK7tThIeXMFZTqqaKcTxPOIOZf+swt7L2XYPs0fCLL
	7nBkuFAFSVp12mYGzFpldZ
X-Google-Smtp-Source: AGHT+IFWuqKYnQSvLkeJOo70BOomylUNzBut9o8ts33EDbsDYkfEsTuZ3Pa7zWK5UOQJ525hf7WoDw==
X-Received: by 2002:a05:7301:4283:b0:2a4:3594:d54a with SMTP id 5a478bee46e88-2ab92e3a972mr4143173eec.23.1764878646675;
        Thu, 04 Dec 2025 12:04:06 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:06 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:53 -0800
Subject: [PATCH v24 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-4-ada7a3ba14dc@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=2422;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=n7bR1NnVFI/AqRJ5DRrpGqIuuKL5t/EAGbECncFah4k=;
 b=4TAIrpmfuAfPnl8tn/VIyCTK2V1JPV1OlmYCd1ZA/LG2RWhQpYMma8sPJT70bjwwoSMUdt5tn
 ECJHYi4ghjZBSfdrpryBl6eil4hs/VFJwegf9Jsy36h+Tc2IQMN9sui
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: e4b95ikdo4i3re3ar5ne13brod5crm73
X-Rspam-User: 
X-Rspamd-Queue-Id: F249780004
X-Rspamd-Server: rspam09
X-HE-Tag: 1764878647-474021
X-HE-Meta: U2FsdGVkX18GYPPVXepWFqnOWdA1P7i+meIA5SPJa/afh+Kumxr9F9TInt2orvGrK9TWMFU0KytUAyVRXNsY+vt0W8Q7fWlYTCU++dtpl4tWx0fqk2V7M4Pwwszo/XMA3OfVlWfK5mQRvSCinAlxAPckYl3bIG1BQuQXz5YeZQHUutn56B0FFa4x53aOc3yxax36jHKSaDVZRYU7OO5VgRVg8vhLtAdIJhbrl54ci+ZSGtnQIw1aZbub5cy7p1RfT2lkgFKxChtOG1LkHmfCiisCftUnovCO0ClxpKgJixAav6WWz2TFnZZoqHccsLMrbb+reTGTcwqZ8PQ6CFmd38SCwC03D2/iwXtAqHtQyqUuv2hj7qIMNQHdUKoj9sOxTcBafxBKMW5VFJorko0dWLPAfyeyEu53iud6koVaADm6LYtIAzx3ZnkWMO68I4Qu0pEDD5H1nypLqZRMZs1NBhlH6gbE0Nsxxm9eOo7ltd+Ps4JoOPqpOaIaEEB8DUchHFVW+96/EqoWacnR4jqHiK22b/Hx+315LzYkBI8gKB9XbqX3PmVoPsHZAg52nxnf3z6T29wGyEa/aCZUBltD2xOVyV5eeWj0Ral1CktmMiEY044582BNzEn9BDpDN118qZJ5BoONeDFTzG9NF7QbojJtBhyCLkY3irqZzZ7GH3MvdJR07o0h7tMXzs+foKSFPumYxEzKP0f7pPE11pMMTolmG+484ruX6T0zE7Q2CpOGswUOeiCB/Nip0Y+5mVoOijQHHBzItT+ffym3jnHwu/fO7004ZWpe1/CpLL9okxw5M7TFKYoyL8jhiclQoUFaycZaEOsfU7YL6szTo6Nv1i3oSwvM+kWI3KjlTe1rA4NuYT8h3c3ejAQ3MEoyFBkBR2ZsybyjJwziM1kdUzv4ZlugHMDmykvepj2SK+15BFckJM9BUXsNHAb08zlJCb1Pqqs7G2I5Ye+3P0F8/pN
 1b6SCTp8
 TRj6vd23zMJFAXaL3+2PuKRD0S3P7lMXJUQq112P8qQ3Hw4CjtnNcm3sExEtPxf+7mOAqA2tA/JcdHMo4i4ItAuf5Bu5awWoKmFdYytissgpupJRjHpuEbn1Weeql+EAy6RIbSCCXV5cNSuOmJ20H/FZc5xk2nt1R7nxSe9Mi/FWgmstcLG6j881BP8ZoYJOe9t2544wx0iavngl0qdu5rGzLPK3sbQ5+O9nPPBkcrpIGU5zy+Jy3aWXqq+N04qA//biWj2QYISJVmKTbZNCuI+lj4cNKG0+girO6sPNjvt5o3+4slzfL0Kj93NbD6a34lzlGXSpyBV5b3RQIHvEsaEAJ7Ey88VRpyJ8EAG8UcSPkyAT+SCX/NuhMYdG8dEJwGfVIkrZVvZXPCdtA05cVw4VSmVnZo4ea6TEVu9YU7N3nL6q+1ZbHCJwFIXXWYMaE4N8zTUzO0t7TOt8DTd6Ni7MEWBRE3v5pwiq9
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

Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
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
2.45.0


