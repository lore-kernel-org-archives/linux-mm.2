Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FD4D41D6B
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1AE6B0010; Thu, 11 Dec 2025 12:21:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F0B6B0022; Thu, 11 Dec 2025 12:21:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB676B0023; Thu, 11 Dec 2025 12:21:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 459DE6B0012
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 082F212E57
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:12 +0000 (UTC)
X-FDA: 84207855984.28.BAFC444
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E07D640005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h/PSkJyW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473670; a=rsa-sha256;
	cv=none;
	b=ZBYP/Uh3iYKrPAjdSuXQiTBQ3ww1w8sQpdpLFx8yHhgf0X2b/XBe2yrmH3z4ZhlbmmwT6h
	3qrT00Zej7pyPgIqjt0isYQC8PLhQDRVoHclZ7TFl2hSEEDfFS8Z6BiUi+5No6d66CRtct
	zXpcnZCkXiFnhh69K3UOTuO0OMQ+YIU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h/PSkJyW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473670;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ko4UZoali671x/Z3JPzfzRKjAHhqWt8s623S099BIJg=;
	b=To25F6Q8WgxgaoeyKxN9YHp0aycded3BJmqpd69jVu1kxjuLCgJ1a3k/1cS/RdOZ+VjR/B
	m6IfSjFHIxiWXiLCXxOrFGr+nXhUVUrDfwC7rnemJdtzc9EGyqVzO96sEKeScVGmn0ZkaH
	Ji3Z5FgCtZ7eULdI+bUYPofoo6drjLk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 42B1F4446E;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C537EC2BCF4;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473666;
	bh=RoLXunQkUD3GkpFVEtA9EVI1x173h9+oOTkpPb8AiyA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=h/PSkJyWA3Fc5T+o9VAyTxeov6ptW4d0rF4/cNN5idX53lMFF2ZqexxxPNmAOix1N
	 G4sEiNusXReeF/aLbW8Nky+YAfTwl3uJ0NQ+tnHYz4ph735Pb+8m9PX+yyxcR+cILA
	 +WxLQXPdlcM2g5bPpqtjoqqIAVzk1XpPhhZ4JFEKrB1SWd00f1lAMuhxw3IQNLw5QM
	 q1QoVCOKr7E/318Y9Ceiao+3KExRqzU4ec+/yzxn9TMjMATHQ3eav9QWcCLiMZ9kHn
	 L/eTCQerBKGpi4MEsXNkYHtZfe9LXi8dhK6l78tc94VsCMbv/CXy3Own2W2DamilxO
	 OSLkk8WVUyTUw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E0FD41D6D;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:37 -0800
Subject: [PATCH v26 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-4-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=2422;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=bX3DT0H8/Cf0WOd9ExAzvQuoOWT5xK5PI+asRJPlwXE=;
 b=7vL5S6tr9ip8gbe0kr+CUiPbFC+rIyqsA3QNT3c8IH+v5A1V5OXBdbcBAHN9xjU0+XAV4S+wQ
 OFK/5L7qhmwCPBuowQpOrg8wMNlhsz/vj8qWnzuCNuTqg6SVyi107C/
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: E07D640005
X-Stat-Signature: nx6ckx145ynjii1rjtq5ku99cgp3rm35
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1765473669-733682
X-HE-Meta: U2FsdGVkX1+pJNToY/j4Sc9hQYKBLcFxMdvMhmbdHEDty5KVnxSLlarf1UzLPrAg+7tGwMiIBnQgacvMpuEzam8Pi0vvN1wvw44XC9bXxrEql+T8PUIxSslFxx0f/i3NyZt3RNZVN+9KlW2N4QBMiGueksoJ4W6pmLvSRDZIYR2pZF7d+HMqZEItHOHmcWkB6GgvIOFX2h5LDxCTSfwlYkQp8jGuidrfb3e1JGhf2WWsIzDxIAsdLEl/4KB7pZ6kZTs3BPyYei91UeVfs9o/JPlhODcZXCSPygqqXD+OkbyJO+PIMYl5gt4PNsyJAmzlD7dDVgnwNICBu1NT4tv7e7Wt0w/UwxrarC3+YENBQDUdcxp8ABhy8Y12bWyAKc6JpnJajDrhfXScTYTuhnUU7h1Iu3epEGaitckyp2h6iWSloiolpgosijIqiueBJalPIgG9EH+8tN/QDU2X5k316auKh3KMiicaSdDCzy0xumhJUnCoIv/d34B+VkS0NQPv0PO5xm0Jh+a/NqDXWgjA+SPTVR8zOkkUojGAXN2GxTJEldVccEpcj3m/aojFQmk4cQkT8rHYtl3aB8fRxS4eySlXn69mL7quwtvNsJWRDaHBVTX0Jfbuwhnfa7hpV+50GX74YvlmTJ7iTcSg4X+ttD++SJ8gE1ozWhdbT2T2YUItN54nIxa38utQ26eQzkNuymKv0eOakPpx6G5AU2FSGjDVj9HsPJFQAE2uqR5rRd0U9RyqzYtHC1H1vfjfBEnp9VD9MLICftZUPV4jayYVBO7g4g977LF0OOs74U5f4iWHcw1Afzf0rOZBjYwjfZ4xVE4/0xP1qmwq0fjnTIbu1zT/cuPf3Yfgj9c7dqlGpffAOr40BVqE4YoxjrV6eYor6c5HIMPf4Qmariyp7j7i93+VU+OcIfRb4J/DyzSeC1E2sQpum+BSq4+HLINDcTivZ7QFAuZobgQ/wgoWdV0
 8BmiaRLu
 wc1OrXoRc9CT9oJLn/AlLOU0K2qtKsM0++xBgSjvKd4nf0VRgZPyXhuxQgR3GS0cyzfA6fgAEqksOZEsRVDacJ5zNFXRUoSiv+wJInjv3SIEfv9AqqUHoV50UotU/CSWbEMCQKGS0rMYtY+1xhCunO3VtMIcLiDZKEXJGymWTMuNMLKCH5Kxs9tht03qXU6Du1HpdHdLYdy1itMqv0KIbPh7vLC5Ef+9OusJnT/TccYs76+jLWprFkB+WXOaBbhO3+ASIQIsI7lW/MO6r8dn34Z5+3TD0y8hNkPGWtMdoUBJ468BIEC3wlVKxIRbd57vUaes2Nyg2MaPEJkGv3BN/6pSYNwfMM1paetwT80u1voD48/gIRvvOUHG1xx229F+bQedno/J8dBAhFcsJOlgrlX1reIGMPQveIOT9QxEsB4Fmz1g5BLi+uXCCtTPWX9oBju8MJp9n70u4dI1XsDEggImEsQAfnfK2XRbArWsbmBuzuivdM1JkiBXn3ILoevK5ew4kXEeU5juHMxMetlIZPMOjpFPT7zgGFSe8
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
2.43.0



