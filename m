Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD783D339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4241C6B020F; Fri,  5 Dec 2025 13:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6306B0246; Fri,  5 Dec 2025 13:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EAC36B0248; Fri,  5 Dec 2025 13:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F04D6B020F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C84F31602D1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:01 +0000 (UTC)
X-FDA: 84186274242.28.0A8F695
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id A9F9414001E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:36:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TUYenhHT;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959819; a=rsa-sha256;
	cv=none;
	b=njSFm2fau5/NT+UvIIwy565v0P13SPJ2hgjI9mZW5dFoEOOMtYmXeThewBNeawoOpwlxzg
	LQ2EsiBJSb53ci51JT6c0GpfiDjKPqy78fQbVSiGCb5laOFrmJG6tuvGBM9sa8X7niB4Wl
	R2OHHQQmHIi+e382vGzRd90mWZKGMSs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TUYenhHT;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cETj36wQ9Li8D++iY1PBxUMbJIR6wBVZ7mUW8zqZ2ak=;
	b=JVCYDKgvgtpfRihkW0BvNR5KVbcITBNAdMOcmjhQiu9mVPIIiNilI/MUi8AEHJ2QXpkX+s
	BChwqAyHFKrLNZ/NGQdijQgDjYNNHk7h+1hlsKq+82GTczNmX7WNr+5tyA3uiNE3iCLnst
	Oeuumhp6IpvrHa92702gCs877ZsQmx8=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bc8ceb76c04so1631143a12.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959819; x=1765564619; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cETj36wQ9Li8D++iY1PBxUMbJIR6wBVZ7mUW8zqZ2ak=;
        b=TUYenhHTn3tWWqyANJsmRPeIHPYqY9ycSyqSyAQQg3HtYSaRdL3m4rveoT3jtltcTA
         p95tGElA1QqqaVEY6Q/lsgZRf8sIZJtdz3G354dePIC9FCDNOyiJW52raM2YGG144E0i
         4YwP6JsyRV9BEMBdepkm9qUUvpaCsOtky24EbNGmaDGRW+C7bIVPw2xRbf6tHxoF4Bkv
         fJJ3OCjULaI8GDmdwScO8BNwZlNviMdL8XcJ7KpRcQ6WX9eA1cWC8ku25aEuTjsyAAWU
         M6zb1PcuWRTnswyFOZ10pOImzXhGn+ocEErNm/tnXJVWv5wJL2D9cL3cHAjnqRkY2xVP
         XSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959819; x=1765564619;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cETj36wQ9Li8D++iY1PBxUMbJIR6wBVZ7mUW8zqZ2ak=;
        b=vs79bRFlal7XG4Ng/7D4RmcXoEPfm+7Iz5oPoue9VnM9y6taSrIvIr1Mfo3kZDSc0w
         CcuFooEO2cOzzV7NbXY8g9Smjy/nyAPJN9ZNSVxhnU6jbM2Ak38WL3Q+O648ZvV0/c+W
         gYkRTyovk9QarbdRTr9GlDdKEAHq52PZBvhiUtTarWHqdp05Y96VIg6XMhObma8I5c8a
         zwMUIwfaItJo3USZwoRL1Xqvldz0wy79X9vh/Xrkv1SaH47quAV0pqCp6ciYlvAm70cG
         m7RrLBjf69G+sxyCg4HWp/i4zgASzd9XlaHRnQ/IvwGNIMsX2cPl9QELFmpNhrCiZTbe
         cSmg==
X-Forwarded-Encrypted: i=1; AJvYcCVmI/I0+/cU6/dMqWbbGWRffvOgh9zdrila0paAkUyA5EPUCgQSqHYVPovtwXiZziPk8DNKRJ7JTA==@kvack.org
X-Gm-Message-State: AOJu0YyrGA1ZMhVxGaq/f1c3CGvl2LQ+1m+YmFiebanuk6vhVsp1UjjP
	ofq9E5slGKAghIFfyWpCVUZKtRfVfREFLDkH8WCjFRxOXopKUnxxpPqgXlBG+sv5334=
X-Gm-Gg: ASbGncu2dKmczNJuVQH4YnSbZvqfF3Bziowi7Q+zDu4c+T9WLrdMIBUDc7hxEDPGFOU
	GusNOCIVjL3Cp57kOXojKMTHdXki2UCZyoPrH3ZX+1Wk17bUja/yd917jRd3rwyHHHqHf45DofA
	Ea6aXGYP0Xj4mcOG//8qgOV0A2nsIpqyihOOqb/HWs00W41XSt/RxYMhU5jRI8K/zD1rW45+H2n
	YdgIoHBaEILjV8+muyLAg25apGMMoZz7yKAoAVcsl8rFLY5XyG/BRSyOtD9gc0jC1YwwnkDrqzf
	BdYAGLUiIVtnCsCs+pqm865zhEQUhUhIzc5Dm+oyECGRhcpc80LXd6nvppGl8N2yaRGVw03B1AZ
	RxI9e0HuLLwZEHuAjwHepYj5ESGiJZEzHOl7nRmWlugQRu8n6XnNuRfF2QdO5UB2Kmt3g6cQXOo
	ULdbUKO07/7J/oiKLttz4A
X-Google-Smtp-Source: AGHT+IEkzbnT/WgOlempvP3hpilfiz+Q71aHJSWUM26fnmV95b/U/OPvqEShn/bm1V+eS1bH7ZJBNQ==
X-Received: by 2002:a05:7301:7389:b0:2a4:6488:7a91 with SMTP id 5a478bee46e88-2abc721e3aemr63588eec.37.1764959818484;
        Fri, 05 Dec 2025 10:36:58 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:36:57 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:50 -0800
Subject: [PATCH v25 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-4-8a3570c3e145@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=2422;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=n7bR1NnVFI/AqRJ5DRrpGqIuuKL5t/EAGbECncFah4k=;
 b=31A6j7PC6Y5du6FtyG1Tip5TQTReoqkkZmO7mrZz/KN+VapztQ/ClG5jXhF8oJEHAJfpgvSh7
 Wdgdq2HWZ/wBlxT7xVvM72WWT8CT9lmclkSWtwU4fMwFZ3NA1iNoLlQ
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: A9F9414001E
X-Stat-Signature: k13wc5icnkuubtwgoc5u79jxgpsg6whe
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764959819-881997
X-HE-Meta: U2FsdGVkX1+LPsB1vRtDqfigiKUmh46JUXL0+SRVY84BLjZNZ3M7b3txpO2qr2/nr4rj89PqpZyJmttZKoCCSMvgXsFKdvz5W2pfdKDQgOQ+9zkSrw/WKnV7t+AYB2gsXA76YxmUQQgCOJMsuOpBjBpr4qvFd10Oup6PdoJnfilhuuS8iH+PYaJ0WVB0A+hx6SDIsHuY17DbdyIs7nnkWWNGbACeLFTJFdRG9hzsnz4HNE9a7OAWiZBTn1Xh7JxmXhpIJjxqeljsSEHVDblqgYLEO9aSZVNwrWinzxY3ZI40sh1R1FyuRxBeaTZE4T1ESIxN1KXTsI7694ZQc8Z4j4B8E6xFCXq0LVXfAx8Uvo02cEyGvsBeq/5207T3+TJ8DWv9eKK2sh3rqBnJFWzL+d8zirk1EYZEVAYm+E3EffBlSXCPVbqSzrGaAutb7K3GKjuzwEpX6Bo/e+SLSaRv60mMRC5XjusD0bYDTMJh9g1MPYLp/8ijbQhxb6K1iARRz3MFTADDoQqs0pmgwyHLggt6k6VOAwFsoxS+w4pteIVCtjtMXIR5pleyg2J9/sqaBsdl7Z5DKAgUwr/K1yKejokZP9A39HqJGt5Ur/pwxDPuyW+x4uBycTqNfvLvOjR8vPQr+qLCJxnjdkfBfNfEl0p6z4Yz9+wHNPXlAV1r1kwzIwpZwj6RlcFVsQdLPQHyS74H+mHI4xWceGERrrtVp/kr7Ao6pZvj/hfDBSNeBCNxuNm6nzqFK3iG2CXIqjErPHTjSvhSRz7AeYvXtDjK20n5QQiqdkStI9ctS+8+Jw0/GNEf3QFIQx1qbxPvdJ1n/qhZXQsEEjVOJoHjTjVHvXst7+tdjIRYByY7JAEjKBlcr2jNPPs8q8Lv0DFcSVU7c42k4K5YDDcnsEW53fOdHXhD2YTfu0EAuuGRSyHG92eA9S6Hl7M01pz4vVDtuZa90AENeN12wOgeDmTg0t0
 qTDS6bBd
 frHymM/u1zPclIhgSoEDh+hltu+OTMXXgAWC/zumGR7WcKKHCnpcPY2YfTToUno2Znfajh595GXU6HFOFRhUkny7UIZgwIP6Zhsv5nkq4be3byjTatNAEOBK2hXLLbw9v5dgp6Zyjqyxs0iu/VCpz15WK53EDN5XFpngLzc4K+YSTpUn639WzfbQC6wU6u2/m40ebvKCmjzxgAPWtB55+6IQKXTzt59nR6miNY8iVz/AKnzI6pxj5Ryxv8rfl6PmZtOPIHWowyO4wIKyiocQGPqVq7KHZzfCniadrKffK/wWeCw8JCEns+b/8kVam6fvCrDYoQZvUfInyEGB7US7z0m/1fKBhHZus8GfxT2FkiBVDUzEFk+4eiT7utghdqDUq++/m57C0Rrs0o3Y6itWy/y1i4kL55+EBXBql2TaLwDi7q9DRei9IRhtvLjWXntPQOe+zlmezCPzxJtItdWfVT5n+re5Mm3AFS/1X
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


