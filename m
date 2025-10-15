Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B6D0CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9B98E0066; Wed, 15 Oct 2025 14:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA7A8E0005; Wed, 15 Oct 2025 14:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725298E0066; Wed, 15 Oct 2025 14:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59AAF8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:13:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3B9F1DE5C7
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:54 +0000 (UTC)
X-FDA: 84001147188.26.36DD1E8
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13C8D80007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=aUQ0HDrK;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552033; a=rsa-sha256;
	cv=none;
	b=qEHmusVsLXIO4vsIvWWbCO5Jvoh+pudCs3IR+6HN5G6XDa3pwPh3AG5+TrK6rGOosqlLwb
	1JA8axp1gHQ8TWjkWmF/nYeAdbOczpsKlEMFC+kZCf2HdkYjLLgtxxygnmYz9wtQUDwdbW
	LSnIstViVS2DTbJo4zJ5Hw/FhiwN7ZA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=aUQ0HDrK;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
	b=QrIiLyCBElBQPmTlPCJgYVZiRQpprWW6+PoXfH990MNuRxwKaCeWVTn67Qu53YlvsAfPvC
	xYXqHScufvuTUnaMP0pAPVqnGuA6Ip16VpuAwEL4bTaec/8Ei3uTJHHP6krC/kmn4zUDBf
	YDnFso5+Mt0DARlqxR8wWIKHXrCo0QA=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-273a0aeed57so17338255ad.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552032; x=1761156832; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=aUQ0HDrKrY/xMowEJYhPfqDaEvMzQwnU91Pfd9H7GgtYHE+DUAbg1vpQbnL0kCo4tA
         Q/wEw8WWxu6t7vgIrzcyvi6MHoWdpjHQdmRdSVPCPOtxzfUNxzgaHZdKHWoJQcWHirXZ
         gRxfXF1eVLKBgs+WpWjUXJ0lN07Ha2XKFJBAXN6QlCP1Cea7XnmRz2Z8taKnANIbEv4f
         jaK4MBccF7NgPfb3x274l6dW6vqfIRW3qIhwl8MjxQKWqeUaJ7m1ddzgT4+jZLWeHDO8
         8BMCLQVZivy+fSbGxtBp3BQ0rXXYZr1YdaQReA+OBNY7IL67qGFyEx97Qrq8bFtsKNB3
         fOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552032; x=1761156832;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=HlOOe69uxxFXNTCQ0MZ0HZhS3dvsm1Vqp6JE+Wzg4PDPKUD6EosUX7Ti3c9GLWWfhm
         Dmnd9rIgEqznEC0mNETSlhzLesMiaP++foX9eJqmCIGlrcREcGcK9gcyd+fiZIsnqvc5
         8yb45OXG/oA96NYxRYLzh0rkQX0her/+cJLBzCctJqxS8azHHoJPz5O1P8VAfjvfWPU4
         OQVupy/uUItEUV5PoMlJA0MYlynkTr/VNx9Q6WYRFszomTNsbk4Zb1Wga5NxFT5GKHD/
         K1a2rVo5penmhOFtv7Z9MUW4d/gIFxaEAlvD3tarJq95KEimhFan72CPPHn8AKpzGdzZ
         lOlw==
X-Forwarded-Encrypted: i=1; AJvYcCW5e5H9ZmUMKFesS+58gf8ibweb6oxZjBQ7SXHafDsRUHcfhUWh4kpnLCPZIVEEUfaSrZ0i/vT3Tg==@kvack.org
X-Gm-Message-State: AOJu0YxenTbYUAT1DJIMp8ZJUM0uEdjeDNZ/1o86E4i86AhwHw9If9HD
	8QLHkH46ZqCJLaZThBkPJ3P9APFk6rHvypQG5G4YFJmRhp4+AiZod2PaQW7AERVrbD+r6AX9gj4
	J6SLO
X-Gm-Gg: ASbGnctxSkLwDtYZCU5D6/MuLv16HPlBbSKIe/Kn7EuMU76jeCso0FolYxfySmZvypV
	flf9MQjHgMsk/mWJh+3dPhoKUHKoyCmXVfBdcz8Mp735KgQZccFbJBnv777MdE+H/qWqxTgMjBR
	x5vUsVExM5u9vG4hAKfdoP4vBBfRrRnGtdMyh+r7FXiBF6k+YrqGQarCyrEaLRAvAuqE5/+aOF2
	92EIfWyc+Do/lcDC1EVcq8Tb4rSa6Hy5UsYCLdTy/5/WigzTai2MKyqF7cZLuQz5s6AwmezwxO/
	cHwj0UHEtt7rQvxAh8shPCLFHVBubC7n/cXJT0h4CrS43UPWqGcywqX6PikmA4UdT4nLO1dRd0p
	RuvaQJqi4reztGtGgEB77bJ9SLBYANo9O2RIVekhjeeGf+ryb1re5eyLvv0ZUcw==
X-Google-Smtp-Source: AGHT+IHf9VCcJrzomY2w47NOGMiIFXsiRbHA2ENGQOPxL+quuCn9bNzo4PbiKvmN4fVVPNoVKadYVQ==
X-Received: by 2002:a17:902:ecc2:b0:281:fd60:807d with SMTP id d9443c01a7336-290919d5389mr11770165ad.2.1760552031474;
        Wed, 15 Oct 2025 11:13:51 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:13:51 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:36 -0700
Subject: [PATCH v21 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-4-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13C8D80007
X-Stat-Signature: fpxdt9w1tjnckwx5z8f8goz4xnwhh8dw
X-HE-Tag: 1760552032-200258
X-HE-Meta: U2FsdGVkX18pG+I2Hpjtt2CjQvobzHhGnqxcC6NxMF9+5cWccBEiEAz1IBTsBJ7aRfPe+4e0c83fD6CmybQTayxXkxoNXCa+uN4VzdbdgW7Ozi0pESoWo2nXCgpPHXtSWusOBHVK4FvSAV1+YW0KfpdFo7CcIcCZrRUwoHkfbF004LmySvg/c1vulc7ZkWcempBbIbVn1+c/v0DxJLtYPF+gHdCEt4Mxt9ikVoLMaGwVXuaTANIGhdjyKLlQsms1Lejc7MliKOyMyR/5rkiRFDCtRNCcU5dhC8qNMsBcuTlylSctI7yngGFlGfhMbxKpkRDlbZ08Cb+ilmMBPDeVNmN5nu1cvy+WBRh8Kv/8utkuw2yxYu94SIy2Z+XfHIUFIaFBQ+pnS1jl6g45yigFHgdYzgZ+HEtK1W1N5HGYcsAq7azwJoUTOi0oxPr6xVhVeWEQRZ0n7L1VgkUbDZ4EIPNHDTlYFhDmqhcfIkRHJFYlxpheg4PJFEtwhq+ufXQiDxBr0DRpRA7wZ8yPl7xfUBD5eb1DXuSmSJSRNyC+qtwNvvqJd39Xz2Db7TWKB7p8N5GUWDmPGgF1DMNYCAOEvXrsoGsbNiPX1cRtB4e127Shm8CDDbua5zK5fi7QjyQfEsskmGZ+hLwc5KiYXRUaagUdKlKP+cDXEjML3CzFqWSOrVzIXDC80pAjyF3QfJw6qQt3oxXlkB+Qm9IEUR17FW54Pd3hoxZ2JZB5aR25c+JpeNG/ug55e6CCP/I4jD6iCe60HVUUx8tJ2SGcFRo4wFEsj0GVZ8oeD1Pj4iOAdLjgKHlWfxQjoIVPwhC6hi1y/4s2p6JPWECdBzzOJqdrq1YqNlRtTCrLCGHil6pA9lE2O9zyHfx0uSXwbeC2KQgoeQHq4QiUcbbKGj4+KOh8MXcd0HuQntLfdENDS5P8fbbVwxYbxat6N5ItQrt4hSTqAzdsTHi1I4esjY3tvKN
 Vk0H7vr/
 t9IbsyYbfPFdGeJ2Z1icbRhHxvW5E+DUClpK3+eCeE7kaBo6Dc31+a8CZIB+Cx90s/OEQquBm4X9IqYDfUaW30rbijkhLFmZp2wItW7o4BTzFtXobABV7P3XrUe3FgPAbDzHihePeYHyHWygCFq6lrW51Ts39w5t+XxTU7vk+1yZUfJV9jMLjU5FueMkVokurd7U7+T5n/s43UfWmLtb/NyB6YJPCODabjLY/Rl3BNASh6iTAem1QGmTYaUPLlkqKuR9saFcwRUqc2l/lZlqGBwviZzdrwxCz4QA4UL+51YaGjNJHFHGf1T1bHKpmyzytZUxRz58t272DLu7amYTolr+oGSxYWU09MrBNbOOT3Flvkb+y1RLYO/4fvF4zdbk/h2Bfs0AhqYXEzFyGruWcvfSNq1H9S5lxsxJ8
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


