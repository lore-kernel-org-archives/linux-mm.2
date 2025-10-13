Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277C2CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815CE8E0094; Mon, 13 Oct 2025 17:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A03D8E0031; Mon, 13 Oct 2025 17:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA818E0094; Mon, 13 Oct 2025 17:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 466638E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F9A2B9265
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:10 +0000 (UTC)
X-FDA: 83994449700.18.93951C0
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 073F54000B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=QfceusTT;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392568; a=rsa-sha256;
	cv=none;
	b=X0WSJIJ7hW2uT+J1JZKaNLG3vKOq4HzEX6TKWT/gHChq7FjlTdcmCSj2OO2hVzUIkn3/dN
	uxg/ox4cWEqQkNH3HJCiI6esIshkQdQs8rYggExN1FAke7fA3BkXvhA+BrRPFNEqf0cTA+
	bYeqmk2dAczll6uD2BssM7e3EV/GgsU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=QfceusTT;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
	b=pWO3+ttwpWKnTpEn429VJPYvaH3b7sQiUHSnprdFz9Ja06u+nbGahn8OizngVO+zvmjge/
	tvIvTXLsFe4Kr/yGZcE8QCwn4azZZYaauRGZnUbTqLLQc1Sy+CSOd1mo8lOgh18BQGT4hY
	XAUj/PTt0oq9qwvNy5d6LOuX7LfNt+k=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-32eb76b9039so5992225a91.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392567; x=1760997367; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=QfceusTT5rGmExRcJRcn9FgiWO1HMu0/BU7/zgK85J7s6GlugYfxGaFGHIxoQuCoA1
         d0WqB/d9eqpYLhQnv+UifdbCBmurm3givnuBiObakeSzLsfLJQV1l186NdKax35CiKWI
         uQ3IEKyexLVGrQEBfvuqOKD/5nuwiry+s4SlKLMBpdJIsoDI0z7ptyu2rPH+CEb4NbRb
         QCcUL8mrZH6fKQhzi5adUQFCvoHPK/YmLwQUrL1SDUaaFPnOba4YGJp5L1xYdVTEME9D
         5eIdnRFgRCiikPD7mvYFwRym9JsNDSJeS8uzXm9rx2mHSmyAM+X0ox/LLQxVW9ChBpqn
         P/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392567; x=1760997367;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=TgB5Af6PGrbLNf/LwfspjP02ilQN98k7q/tN0kHBPGuKQEWju8blxsIh71KIlQEO+S
         efh1xbkF9TXvIapahiub2um0oVk7ZFr+jrgRnmbJ0ba22w7BM0D7GbAkHAb8QpBPl7n1
         ZjmA32ThDJtadhlvZEe3fLXJSEPu7L+YOAm/cxxt3Sa+PUGC5yPF7pV+PFOyBjgvdXm/
         BYfGh24McGyOqKAYpi5JIusaAuOEDRsek481lTm9YWxiFIMOXuBsXsnQyMDY89jqEwd4
         fIIUo5V9xpObBz1yK+1HSMJBVXRjNRo2/ezLjr9W0AGkR9gk+3sUSBlQ5eySdK2Rvv5X
         w1aQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+FDJkLtCmOcdauF0CDIG4abVNifddExE8zEy3bYf9b8CJ9u0p7yQwVXrBSPKerOHy0ic9Idz6Ow==@kvack.org
X-Gm-Message-State: AOJu0Yxrl5L0YkyTM1aXF7gIDnCKw54Qu1u9xZ4Z46lptns9S32wSyUH
	ADo9ktrhHEjoAvp47sAEx5dlIFB2KxltzpbV95axH6s2Dv5xkppvoOMF+u0Mb8BvpGs=
X-Gm-Gg: ASbGncsimIV+6OZB1NrOB8rVlbsGHgzVTHw323xK0bqGv+2V8TfVh00tZbh0i+ZvmG+
	AlZ1IbF6gsycuGA4ywX2kKDZDZZgUop7iAF4Uetz1hFeqY2eAUBlaFp4+nFU86RrLLUZibjFgFo
	CSF66nj1fAd5goVecRoD44m91pT6TXgljHW+mzUPZab8hB6MMrSftm7RsrQwqvhOJGLVU1o6/SO
	TCmAlPRXLnto/wciuxNKhWzLE7VHCDrCpK/yUHrjyrEeouYiP/X8yycTPC10cpqh6Khft2GacTM
	rgyE9B2dxw1iJ4Ws47w4m8DxqRECeAxR0fMXRTJGN7/fF7IK4efCjsOC29U4QLqNiCw24WbqoqV
	5K2hqPiVYA8+8utI1y1u5Dsbznliaki4/hdGjQk7aTPb5z4WlZq8=
X-Google-Smtp-Source: AGHT+IEk8C0wXtpiaSerIOmMVJ34V19j3qCgt/dP0k/QOvSZF8SGdHByWOIwcunMLrrPAiMMdWB6bA==
X-Received: by 2002:a17:90b:1d85:b0:32b:623d:ee91 with SMTP id 98e67ed59e1d1-33b5138623dmr30507133a91.27.1760392566692;
        Mon, 13 Oct 2025 14:56:06 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:06 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:55:56 -0700
Subject: [PATCH v20 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-4-b9de4be9912e@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: 6ddwkw7cerdxfmpd9od9167pdprokepc
X-Rspamd-Queue-Id: 073F54000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1760392567-986010
X-HE-Meta: U2FsdGVkX1+IWAgKm2+1TIVLIRXoUbJQW8Yy+zyVRmmdfXRJT683bFIcLwXcWcnUOdnqE3eyciAft0oO7+V7hMZvZwDF0vylhvKxg2cYOHB16CRsx0jQNdPMuVGuhls/R1GLs4d13TldR7Mv9jQFlFAYU/ou1djvTqL1+Il+cJGgU2hpFiTMOnmdgZL4VsmO2BS458/DM30FS+n0n5bTTrF97B3GP1AdXsgKMbHVya7vPv2HMmNKghvLwQYIVL3qGDgiq9xfxUCVAvzjuN0NWEU4YeyWeQvQZ2booJXK+8ueh3qQHqnGF3I38I9/qCbvR30UTvHEagqFCe1J6VSMl9zI0gVvErQEqfmMf6PkE1/s85+R434+/ZxAOQCVOa0QdysH3ZkOeHSQYhstym60tDVOlgEbnsSU3KubX/k20C0+kbvSI4oxVkxFmN4eWFAC69k24IT6xsRfsI1bn3kwQnMeIqE7uFhhhiJ8A64QFxWZ7SbiULrFKnWxFZXrw4iEtd59cMHOg3SEIuDEjF+ryK5pd2kssm8qyviuBwA5dHavx+hAGNgrIMGlNsSFy/eNJr6FYSkMvttPP8BYpAvAINwuo7f4Ez2+8R+n7gerd9CV01Rkr0Mg+lMj1T22awGpAPVbqtkYIAVs/9Z+7H+H6qtWSRjG2l+NFy71eeqlDywUmbwBeRq+QaHMrDPGMqUNnqxvKvOsdIFYMDdC+2EeHVRX/t76+kSLoYVemA75CyWhjaYQYLDgvGFAwzkUYBua1D6Th+PexKA2pt5GxsLeq+WAnSnhPGlB83sDgryKNCnJb1X2RAp0ZDTOijkuinYnZvxUSMoprNFOfGYtQ16nD5ThT9Dti71Rs53nnu8aaH6guHT4OcQFUu7BmkqYGrQqY1hmcC106uMdj3V/rhThcOZ6fVIrqyM2u9CO6gSIR/y/BDCIFAI/iWnSDBpTHfJcolGVA1wu83YZcMnS7Ze
 jb453S5D
 lboS+WsYtdVEoaut/yEyqMjOE/asbRiEjmqI03NgfMvp0hmMmjtV5Q32nfw9x+d6MXAM/+y4tT1jKj0KshoKH2aqYvqp8x9bmiwhf7mFAVM3WCFOfLsmeuT5QT0if7SAsemk3sbEdV7J6u/7MrxKmY688MiIQfIEmwqMCnrXe5DcY0xG0WPXUiPGQbKODzrPi/CqzE+snQaoOH2uC4nVAJZz6GTJRMew3aAdsGHkrefx7gYJXkHE7LAqtSHMK4CuXsr41Ffg0kEcp2c3ilOHiEqst4rLEm+Frkfu5shJYRa55CmJt3KTblwScW7id6fZvdc17kGyDbFqE0M3XHtvEeZcnuRAOE6I+W5R2LxoFTP+Uc5StH/FTQHmKjFR0ipXUYjDL7PK9ag9YjYnadTPrtXIY3EF/LcxOR2gz
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


