Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58FEFCCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3FC08E0013; Mon, 20 Oct 2025 16:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0948E0002; Mon, 20 Oct 2025 16:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8308E0013; Mon, 20 Oct 2025 16:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA0978E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:22:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A629C02D0
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:49 +0000 (UTC)
X-FDA: 84019616058.14.3B452B8
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79EF6100006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dgcMskh8;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNLdHsHLApoBXgPow7nD4EiYKLadWrqIeWAFyfWBQTM=;
	b=goQ4pxjv9mhm0waankJvpxXHRqYWiTkGj5ZkF1r+QGOLTiaBtPN2aDIVOmNG8OxvZvbKbU
	92OF6CKKHEiTYtaqn2xO78PW+tn5stE1rPHgi+PAdwZ9zm31bkUCNA4b9+6tbh9H+P/uzM
	fvZhsojd9Ls0ZqfmvEciXVBOEz+HyJE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dgcMskh8;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991767; a=rsa-sha256;
	cv=none;
	b=uJe9xFLS+4DvGb5o8fI8+GVksXQ9jdhlwL83r3hUtcBqk6oCgpYpcxn8nPnqyKMiQtTEtE
	mG4ndnK0emjj7Id94y3Hn489VmPsOP4PYdnKPr7wZ2GrhZ82Q/KrAxe/I/4j5zM/M0uL3Z
	S8p404cpWDOURWL7VAox/DW23tT/ElQ=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33ba5fc3359so4831868a91.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991766; x=1761596566; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bNLdHsHLApoBXgPow7nD4EiYKLadWrqIeWAFyfWBQTM=;
        b=dgcMskh86OLABby9+rkabmkj9liX/aKNMpfHmy8cnhYkWe+k8d9u5i+q+HG1rGMU0u
         t090k54OkcjY2cdUpaT7/7waFAmE5WngutwdIi+Fd7ACVNfIRMHsdyb+hTaucSwAAsKt
         QXGCVBqI3n8SUB8MBdLLnFb58OcRgZwHQN8gyyi3LJxwue8NoE8tYyKsT20iYNg4Bqow
         1cCguDrsqv0Do8DmWi2PYPb4oo0tDVxZY50YeVl0XLBRMF+0lgz/6rqeYfxUuZJF7TDk
         Lvd/g2ZQVSoaT0P7Y9ppSPsl5Esw7sEy1MXgw0m5vGd0/TSEN958XIXz6EXs6iOvHzXU
         8lvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991766; x=1761596566;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bNLdHsHLApoBXgPow7nD4EiYKLadWrqIeWAFyfWBQTM=;
        b=vOkVliG2rBD9YXNZVokgn1AlDMjYIzIdhu8pc1+EB+S4x7dXefFu2+J03nD6oVihR8
         AjsJSCFRtEVg4oSbSQyQvz0j23kbu0oOGOocdQDB+IKfGRLNMG8uax+lYB7IxQeKRqgj
         Wm2R4wWWF764e9I4PYHVtEa7zfLxIvM/urqapsKOvziyxSZFm3qYGEZcLy/R0z6kZSiK
         1FQF9UoUc7jtelafaoWHIHTpGZqhJyJ57EH+JYJt5N8zZBHhmWIW92Mfsd9NdVyNSklS
         LSrYRhBYkqnx+RmPltHXyAbSPomzheb5AAhwIctHnkxjoFEcA1apUBRZHIpIKv+Ki8sm
         lZAg==
X-Forwarded-Encrypted: i=1; AJvYcCUCUhmUWXlVdf2tw1e3fGR60MjF1PVl20G6cFZt0/NRrBXpiAvTn51x6Z7/UxmI2tkoo0BoIb0Mog==@kvack.org
X-Gm-Message-State: AOJu0YxfUeh/30fVDfgjLGGlxzRukv2G4tdN1drlz51RLXNChB4YzdTb
	EPbBd9/p1OQh4YAc4gIX6oZ7/2z3JLV1aDFFoUvlgoeM0Sjr/DUDPyPLXsXRzq/ynVE=
X-Gm-Gg: ASbGnctYzkcDkezbXGU2brShjY3HNj3zP9aVdtshhlCXZkxvXUHFlk3uNGCptxa+7nu
	2NMiuTZBnbFReFT804jkXDR5PqE/fqWe+1lk1aowb6PVPhPQLS6y9R366ZvVDPX0Olzzj40Z+zJ
	b43F/xGNxp12vIEuq/C3C0v77yaTpgZNOHpMd4wDucv1r/NF9dYPw2dGXrVscRMuAybXAkfhlA+
	fl9HX3ZCDuNyV825e51UAOaxKNbC9oxpPd2irghuvsqqewZRQg30oH2UuWTL0ztBOUjYVanlP1+
	Bub7l8FMN0VSm5+2ajeBZzA2OgdylH9U+qb19wOKOWjuERAiWxh1rX6ESN1kHtN4tXOfPjbpPyQ
	03kOcjiXSiwtGWKslplcBAuZIKGt5fi3hpBgDfLvETU4XVqAlXmJYtbyhYV+AWc97dkxkwo957c
	ZjkGiV3G8ymL1dm4MlmwDz
X-Google-Smtp-Source: AGHT+IGEGkQ/GC8t0NOwkUogPjF7cO1kT60SXt/VRwKMgl2Ot2MJzGp+Dj2kvvgz4fiB3gPv8XWB0A==
X-Received: by 2002:a17:90b:2781:b0:32b:9750:10e4 with SMTP id 98e67ed59e1d1-33bcf8f9844mr16500269a91.27.1760991766307;
        Mon, 20 Oct 2025 13:22:46 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:22:45 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:33 -0700
Subject: [PATCH v22 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-4-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
X-Rspamd-Queue-Id: 79EF6100006
X-Rspamd-Server: rspam03
X-Stat-Signature: cqyn4awxmry8sgo6fokx6qpj3cupmhdi
X-HE-Tag: 1760991767-983529
X-HE-Meta: U2FsdGVkX195k3NRGyyVChfpCQejThl562a/1r63Boyq3IkEo226Dfkau1kkSxqrIXXpQ455T34sdxvw2bxvU9iXM/AAn8JzqQgRGMhpbozluWgStflXdKjsxq9EcB3a6l9ocDvhQMBw7o2gMCiMAfNfCBipJEReu5wNsYOIn9ruApN6WmkCH7yy5eElrCFDy0qZ4SaIeY8/lQJOumwSCPALLUKCJz5bGEXDaIYevqv4olnEZSKGC2eiY98mbGetj8WaYALDZHV56MatoxFAksRhvgWJ9C1I0kqdoFfsd3fXA+qFQxjl/38WRYzE5ChdxyD1h6+Sky5N11vhLWvxfkvOFCMO9/jrSXlkM3FN/V7sgx+xSStPevemaBxUUmUs3HsZdKKeIMGmSCjvPzaEmoiRVU4A/mbdpMWuhUKTxoAhaslBgCP53WcqMjgCsjyclHoM4WBDIJ2F1f259EOrs0pyrJzbuamyIlEeCbRDkl1T6DUXySe1vUgE/2QmMT+vHqz745+e9SwCiUNoNstZ0qHPi+hw10U9fgz1VlY36yTHxlHjYo1hfCXIBZjC/lDP6POSuHhSWVRguA+I5jMMvFhxtk8tYknFGthoYwLLgyElXKwVymWPAKRmefC5iHBLDfkAm6nsLmhTkY3THBsKzWQCNtNQGk8YlaCH+NbgC0JjUs3R8r1wzKLAGEyNAKNYqyMP+g2FaO4hKXl4e52Lu85ZbufHT9ViJgzoTXJfLXpFJSk43q/O6vKY02kUTd01iBk7+P7HGhOfI9zev+EU7jHAUtzU8fypPBYJkCqnNUp53XDeWgstzKhgtTafIzb2HGL7vX9mqnMxW5hzLCZmHwmXe0lnvMrGAAfxMD1NlnclSLV8gXz080fcRC0w9sGheebD4GvteHzUkkgrm+zRrPjMtRtC2qRs6tUvuh5F2kPYDU6aHZ9o47HOwJ6Iuj19WgokApdYjPtAyObBFJo
 +EnyGq/y
 1myNv7fX1nBLFrIJx0QAHDbz7tNCOyLnmtb6JoJWxvumOYsMOeTVWPCA55E+8up43DHXaKS8WQlrnf+LbNolhms7rS4DvB3KTWKUeJuGKQPq3YheONX/GrMVUOZAi2/Mr1KFy2WXYy7+oMdBl/QfBuEYdmuTMyc12mUi7CEyFw6mUmRfUegmKPIn4AJJCLVM1xY7lSwpQ1UDLkHEYup/lIZY2NtdQCaa4y9Ou+GQ9XOrnOY7WjcDJyH7h7nRIKuTrTHycKFis/5685jukVBQUXJ9pJuAi6IYbBakaMkiBdY9aPrBvPc0F4AQnevc7sdYqP47MUVmq7sBHJBkMhKr+liGC7isW4TeQ0ZRAKyZ64x8TciRJyS0OZyFcebUpdTrPn93KxYGZH+aiWqQeI524SH1ZJQmb9vyzNOUN
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
2.45.0


