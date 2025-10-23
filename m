Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AEB5CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373438E0021; Thu, 23 Oct 2025 09:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324498E0002; Thu, 23 Oct 2025 09:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B268E0021; Thu, 23 Oct 2025 09:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02C728E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:25:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C12B055D51
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:48 +0000 (UTC)
X-FDA: 84029451576.11.E53A7CC
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id BDD622000E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=OMkxLkvr;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225946; a=rsa-sha256;
	cv=none;
	b=jR0SkFoIi0hXqKc4hbQGE8UYE33P/Lgvt7xZWdq3LVJQWQ6r6t0cGmNOC+qaXglM2T1J4X
	S+EjeaHT8/2jZYZx56xdGjSchlZXOMW3jIciL/98X48cyyhBwH+Ljd2Nbl/bknDgpDwMBs
	gp3IAl8owIbNTZq8cx0/nL+0N6Hi5LM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=OMkxLkvr;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
	b=rxF3D5KHGV9b9byEm+VrHii4SobLFAsd/BUNKiaZLwd34gCcsB/32Wzessoas/vfp0Togr
	K/FBzhJK661+L1gZCG/QRQ0voKZp3XwK1DOl69+9RR36LN3L1tPe+xmzvr0IoUcccTQ77O
	XFgXzF63P9XPb6KhXNeyWrQx6dKRXeg=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7a1603a098eso553666b3a.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225945; x=1761830745; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=OMkxLkvr+E1BiLmuAOipN+fj3wa5DAAoQ70gli0nTe3p8L6k7URqEHdpc3bpIElC7X
         LpLH36ZFADpK5dgmCV0FDi3fQsMrqbmTnlSJU16wybNe3hteW2bMVt/AZ2+7mYN12wJQ
         LvPfpqVWgUMi4omB26tCbEmTJVMiIqvwntRocAd7i/JIDRqzbXRQJHdZZRnMOqgBUMnB
         lbbIahq9+y5D56SUaoV+HYqyv0iqmbh63BveVmqLbQDBHMcYZpae9cg/z+Ag7ZA36qpf
         mYYbiEsg2IONcKzUSRL0Box04jXqK057OIr8mjyqDRg9xB0QStUdww+0NxOWdYI39S+F
         N3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225945; x=1761830745;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=m5owIIPBiuaFErtUcelUwiW+MDUzlD+YK4oo6NcGeOpeeDp9DoHVKzRE+n8o1t9k0N
         X8ERQ3lxIX+ZuK5EFVyKQlWwAnaAqNiUsTNSZ2HeIIT0H3X7S+LnCjoRzvRLx6m0sFqJ
         CAalfPh3tYuyncZxsjFM7kHeXfk6wKEy3JUloC53mP+M56Hu4932en+mj3cM4Er3uqPv
         uzwB2yodH+fPFHyGiRUdgtH3miFeCN71oIxS/Xwespg7WjAjcpTPcOH8XKvVBB4BGbTM
         emHkhfgYnhOxLoc10vHmdqTRcbZKpPtes45/rHTEhKMAzUst9rpgCxGp4129S0CcpXpn
         Fo7g==
X-Forwarded-Encrypted: i=1; AJvYcCXP/rEpfJhlqnfcjZ9jvV1z/54u4ISj8PahFezzkqHz1VCTFu9gOngU/JgBTmr2A34PEMp4hWKpdQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8af+ErA80NYGH+0jpUs2Gk5eRMnCXVErFPNUJOZFk8vA9EuhK
	s60wwxyjEMTOdWxL4TavGGx+WS9u/qVgJDFBy+sODr1VDE73gH6drZS8HNCs/HnBn30=
X-Gm-Gg: ASbGncs+jEz1iATMiW1feAC3eiYYm+jY2PjlOiBXjDsZ2xf43S3K506AGnGp1gNcXvd
	zHLdUuB+BhGjYhq4quAGEnD3VYI9zor4wfY91pzN6Yt/MK/l69qUVYoAXibCONP83ch4c8yxZ/q
	+Zo4d0/K2rO4/P8/ByAt5Paw2M1qzi/xZEfZ9QjXAPxUk23wSw9BIpCXYnI5h3Ub6NIRFrifNDs
	W9tdbxPSCC5dqU8r07kTRT+CY0tDUeYr2JOXkJiaYN6vDunqx+ljbwRgkXuxGsdbqLT+zM09GZ4
	ySWdlIdgalY7jCGjRABcc34cc6O0wCZeA4zEqKMIzSjDbdmkAM7q/lcyIYWlHBamPU4sH+XRAb9
	ZbknILxbz1dZ/fbqAtptExZh8NUbCvtwNHwEPMpg7peOM0ADCO/8e2lM88m1fbBmZrd7oDymW0o
	MRtThy+DQJ+SbTU0lHkXA/
X-Google-Smtp-Source: AGHT+IEy3qLITcuChtDM79cXlP4i162rfKSR20rjSZYhE6w88AMJ5HcNN3dCkLwwo8KQPtiBjUNHgw==
X-Received: by 2002:a17:902:e88e:b0:27e:f018:d312 with SMTP id d9443c01a7336-290c9cf350amr320485415ad.1.1761225945527;
        Thu, 23 Oct 2025 06:25:45 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:25:45 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:33 -0700
Subject: [PATCH v22 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-4-1d53ce35d8fd@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
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
X-Stat-Signature: 885wktuszauz4q3xyyjppwzc75djc37s
X-Rspamd-Queue-Id: BDD622000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1761225946-428140
X-HE-Meta: U2FsdGVkX18LOzXGW3pe+neriyVC1u5nnZGiSIyitBWyniaKI3bhb927y1eSkexBvjDid6BKmEiR9mlmtfEr/X/S72hqUbGZoCbxUNMj8LmkLAEyQAvepROqxuF7cUeMHrazU/Uc4DI/LPV5WBiTR8AimeApbvBrGS+dilRJf+bP++VOOI+ur1YpzGj6oIIE4HBhQANfhVM3KWwnC99H9UT4bC3nNLUYc3WZjVsps52Hz7jW2jFQnOMjhhRcjbpJeX4MJb/9bD2CUfSlLRPnbJoeYZ9MyAdYkXIyEv2Y9l4jLtwqrD+AQFJK3VbGRXArNP+aZx7Tyn7A+2y6tHQJ0T2x2RhQGhoNooTCEK6PVO8IYvg9oILxFlBq7TgrAfh0yEOps3eWAQi/L/qzzPF2gfLXD+U41kNR5Pb1bcXy7tH7eBn42sovt7brbNzn6zok0HW4LfOSk/IXcnQtD7gRvpl8PlbuE1PX0H0S9q7dag7w1GFPrLSYRvuxlblJfcMKQTxJMI7NeRIVreBPmzgqMoPH8Cme6gUITujEdNjZP8UhiVr2tbxRQpvLTbaxH37uPitLVTs7o+SFy3fWgV/gO+9vbjck+C51AUgr981M0ywAb48oZIAN2XcJHz5YZWC5z28VACbZeffv4K1ghJuuDZ+kZzmDiv5caQJhI6zgf+l+xsXNnoczLRPXUf8ZLqRMNO6YFnqhqMoZwLz+VsSQI4BFGfIsOnlxA5FUV+/4OX4F8qx1p39AiTAri332vrAK4Rh/6BSryvKfh4P2kRvwvvSDmSsjeguu8mo+o11xuToCxV2NR9M/xgtx7EebJ//JL+vgrKnhXw4BvmDLWVEqyDq3pz4ddEyiDKRrDzdl879FLh1prSHF8ixBSxcTkxr9QiOnxrA0M1MugChxpt5v1OHtWuEG9G/h3Z1LUGjvQX6Li+ok1t/5wnUeRolOTeNKq875T8UL8V5hk3eKd98
 DjnoMeUe
 9/jXakgAeMnSHvG2e+isI6UgR/ojJSZp5g9BS4kuxr+9TbI6OqusFOHw6Lw3wdDONH2LK6efGTRamhULd8ykr2TrNpqv5Q5bod1wKxQkp7r+xQS34Q1QSuZ/en0+AuwIg1pN4mdOrf8pdXzLFTwUo8Jn0nGYRkN/xifSIpA/zB13PAfYrpw1fm5R2xiY6Dlx6D8Hx8Q0JwwIAB1CQQjyOtg0u5sWyzggEW1GD2pTu60nF6QxhIQPfC1lvcYYrt+/ANrvlPGTIr0OxhWQuIxivXjTmQ42GrUDWm9NdVounioRcs2pCm3HQPdW7emlMDyrfPuNzksAt1SKSo+E1COLDXuy4I2JOmra39nfkTHsgGXJALS3kIkt9qPBC14yVD5wIxigI31Nb/4CNHddMgc+F3LDB+3m43eHMAK7c
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


