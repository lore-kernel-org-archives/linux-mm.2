Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E16DCD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF208E000F; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C038E0016; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59AB8E000F; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 81A558E0016
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BF0A160751
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:46 +0000 (UTC)
X-FDA: 84103736052.26.C5CB7C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 311BD140006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEqwruGe;
	spf=pass (imf09.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994624;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aH3TSp6tE9rHTee31FemkNesBahrozbNdg6Il2tnh24=;
	b=JEBk2q7L+3+H4cROHjPnpkiLtpaEjUI7PcAwCeE1MsqRsj21+gqQNKnF21AzMYEz/FdjTv
	CiQu5qPU732cKA60RHqCSbSqqfxBo4mY8Cz0a79zFDQ5ROjeo2WaP7le3B8d/8BhyS/9ba
	GmNLiDdpJ5If1aBYFqIulUMfEIHTzoM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEqwruGe;
	spf=pass (imf09.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994624; a=rsa-sha256;
	cv=none;
	b=lpSs1eHSm99+PPphKLZfl3/b2ajCzlsKfBUTAamiFIaZoXEwm1Mk5//5kOBL0CfAL96/GP
	f5XwltfzT8OxADOLnUwe9S22rw3tN9yQYwN/ycHwhFxOS2JK0afYf26KsGuiDETGVNdgmx
	XfEhxKbUr6jg1THukfYnvCm7LAClAsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63FE1446E7;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 024B9C2BCF5;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994622;
	bh=gh4nsTA1J+FtbBXbiS/i+dlW+2bjS5V1BMggpLU8Gvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lEqwruGeI1bBegZIfTYRUvLPrdzF24FozZJ3yCi3c0LV15MOwAMnLMa/ftTHudy2d
	 tvwecIIP3IxwJIh4V+TtGmmY5feIi27nuOCkvGvoHs1vh1O2JVgkw4kyr/Ni8cBXgA
	 VD3qfM8CHSH9cq1nNgjXSpdCb9q4r9aQ7VUUmitK2VgtnAImeSQqq27lNBisqz7w+j
	 8ETfESbnBQ/8uKNvswVJ1hWx3MUqbiv/6l046DQVHQlSOf5XFyHW1PzXen75as2iWl
	 pIHfYVDodbgDbCAB9GsIUlY3Bnworwiv2Qsf9C3F8ZNPCZhJKYZHzqhdwuQtdgDxyx
	 +f1iH5qUhR7Ow==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2BECD4F29;
	Thu, 13 Nov 2025 00:43:41 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:02 -0800
Subject: [PATCH v23 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-4-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=2296;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=kcKAh3qiYa6u+vavoC8VVP4XbgP0FdaLB3/LKiPnoo8=;
 b=IO3ZkwMEkhU9nwQna7hisw4yCYONtsFfyC+757gMDMv03Q9yxRHzmwGPV6/GwOXkPkBahd+fQ
 MedqRF7lCa/DbccTTnTqZB7XGnHdACjasm1zWJj+OhzF1TslAhshFVt
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 311BD140006
X-Stat-Signature: tutxb1nw68aztqbbsdq5owgehbhdax88
X-Rspam-User: 
X-HE-Tag: 1762994623-777602
X-HE-Meta: U2FsdGVkX18yTvO4ehqmswgQB+/sB1QfpJx1eYw1Gn8xMsiucP+oiQevTf4ieE5rjt5SIaTPzVYw9zUG47VLT1+H1RAglwvzvdsnO+IbDM0KIv1ZCzQ/gaxn2DJIDzwR3U3x08M/h8bEYZp268w7aMcc1TqKIocOMCNuma2kbmDDvDV8aROs4qyRdVwNH41r60eTxZJ0RcBjnVNmXPXRKr6PSDeR5aWbNtNX5L+bzT15qjVtAbhrShqkGvZbNtIilGgRquHL/2o/6ZiNPrztBH1x7M/jluNmSKMgMO0Q8gIMARzEpoqo9BPHifssz11k1IH9xFHZ36+2RQZsq588zheS577+aLlOuiZliwy4wz7v9K0gIogls/ghp77UBgNHjIlMw5Q7XTQ+NjidKOZ/K66wzYlgy7WnSWCPuhzmYUO3HyYG5xv/qlbjXvU4UjT5hs46yu6mA5p/p6edr0FIrm8PoNaqmCoU7MAr9Q60p9ghbpVFdKOcDxJ9lnvdVipe6wmE+h0c0dcnzOu8Jj1YHFt8KhHsQhmEyYonWURR/Q5N6OfRIF8xyisKoNvOeafdphBywL4+36607cd1jH7fOPuB9Z4fvyaxa1kVZfBhRiasDS2YY0m4BLUvnsRn+p4MKiTtlNFMmFQVAUFrzhYyKzeR5vss1NWmaGC2nNQkYkIPM5qjOMBXNUZ3vXqC46g6pfCPQbBdzBB43apBHfoGB+lLCa7NfxKiiry+kPO9YsjCrfVQZUbPuOPdQNJJxxGT/B4t8jyOwglNGcXHqVO+RtqXr3eaAcgZidIaLvA2v+yXBN7bqEw7oXue0Bl28inNZl2mea/t0B4BFghVPHhN/fOXl0QMpVy6f3PL+pFq3jLhGiMZ/tSgGDry1ufu5aoEZXa8CEge912HihBqmIJ9fbkh+SZJDLoJ2nmcmr2zP/o1Ci8gS7BVydAahnhVKecCTgmEdZdpYeHLsQxv//P
 uhi8tzbi
 9tnhSYlWpmwYcrUzm4NL4RvNBVT9qUQIc81x81AFzSeKxos6vJ+jQaC2ZApmrSifRHnOB77mCKlgfq062l02RKR0MIPj7xzYBadbTbUXQRxF+fHZy9e8B77a9rnJ003XuJMhQBbyO/DQk1Ldf2PIUyko1VGMSlUqRILgEJhzWgOaGdgVv1Fy1VFthMQDGWI4CooYd0CdG9Wym78+xpT4JJ7QOp8+laGwl1Jd1gqZzEkD5A3Fj39NMQO6r1eUOOGGhs3Ce78zo+D3X+2QekAqarxTnWgq1kYB+4gTBSdZnHnjeNSML8d4sNccatZZ0+YuSXHUlfNu3n5SAqKt+t0iZiAsFCZ2TbQGjT6s6iPAF4JPuXX6XLgo2SpP9zJcOQQ9sbriTZLp7FCXzwVZ7T37RGN+9S97lHpZsYPItfSyauxdoPIQDyuEpDs7cdOLm6VGqCyOwxMsdyGT2dFFnrfJo5mqjs960l2Sr/+pC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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



