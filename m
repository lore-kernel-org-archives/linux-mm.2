Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477FFCCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6928E0010; Thu, 23 Oct 2025 12:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6C88E0005; Thu, 23 Oct 2025 12:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95C28E0010; Thu, 23 Oct 2025 12:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B344C8E0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78A60140BBC
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:14 +0000 (UTC)
X-FDA: 84029969268.04.E5E1EA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 685E4A0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g0n/0MOy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238272; a=rsa-sha256;
	cv=none;
	b=0grtZDbB/pZwDEOmKZew6QGhYPXJvOWDkKTtL5t5iT1Ug+DRI1u7vbw35GPgo2cJFAdvIh
	If4fR2vtE99SlV6lXSGOaFU0FQECR7ql8s2E1hihsB/IiiPqQDm7CpRyWrhXXUIEmc+1/i
	FD7gARo9wDUNGsIHoebJsDdzOHzRjyA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g0n/0MOy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238272;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aH3TSp6tE9rHTee31FemkNesBahrozbNdg6Il2tnh24=;
	b=erqbwWXNqUoaKt85Tq23bb12aaxw8uz2kcQGGi7H+Sv4klu/gqVyezVh3hZcvT4EmvsjiT
	mAUG+/XFVrOAPbrCkihqyrbHhDw+3Uf7l2mZmjkfVJBCe9bWBk5/EPvoUtBNX4uhLJoAKM
	1m5pIH0kC+yH4w3/SjmT+yxWdwt1SFw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 254004AFFA;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE804C19422;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238270;
	bh=gh4nsTA1J+FtbBXbiS/i+dlW+2bjS5V1BMggpLU8Gvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=g0n/0MOyIzXjTusHNj/asBvMbRm2x4ldzrdWe1ph/Bf1UvQclTLRrx2ffC6vSoyzU
	 NL7ljZYSwpI9GXp0WBFN8gJoSgxhW+EKTdRUXbkbAz1ivpco9zMpn15xvT2lfcqKdQ
	 qJMihoujOlzHWkMrHw7dRDnuvSyqNmdQjob/WIrEHh6gizDSpUMwl6maCRKE58oV2h
	 wmZJfoLb1DkMFGazuatkJiNaXX/H7jCKYeYw2Glsh+Jbmb7UW/uXKMaSP6XIJf/Nrs
	 RA00R9AZXs+XSy06K0vihYfLay5MNnpF3QRaFoh7UkR9dgKDwG6Sr71GRPh/oo2N9X
	 7j1GFrLx6QGfw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA876CCF9E4;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:09 -0700
Subject: [PATCH v22 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-4-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=2296;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=kcKAh3qiYa6u+vavoC8VVP4XbgP0FdaLB3/LKiPnoo8=;
 b=5abQ/8Fyb67brrslHsppHvVHhbfMSh362P9OdeCdOVQdtEtbY5fxaIbvhvl5q8aWJDf/FV0Fq
 fHseZWEX8HbDzUjvYtlSnv7SPpsB46CG4aJqGJvIu5MxcK1mzpPlmzq
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: 39hs9dswr5a1jwpyjx3gcijcyygq7jje
X-Rspamd-Queue-Id: 685E4A0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761238272-156993
X-HE-Meta: U2FsdGVkX19oAODTxyEBAhCKy36ZQG2j4PmbRf0ssncknJcgeXVLXmxpex8nbQMfVHCa53FPHsy3x2r0Ers2NfwSyF4Sd+l33q9Gw38/MMyuSDucEmm6JlSNrLrfHbJJIYIqhEmCpc9XyusYk7mmUaWTu9pc9i2+CClYiwJU41TtpwPclQFHeQ1fc0wA4zBBC2qjcRFrpy3nb3bp7zHFqkFyhuHzk8xvjlPj4VyhA+xWaIjVunAQpZVulwXFZzwYcar2pzHmf6pC/cNciUkaxpt+rDRkH0SRoAO6mCmxB78iEqzAFn6JY+ofqWil059P5L5Z5jJvU8zDG/sgU2bjjzQt+vVlPvVBtTStUON9KIiwKqtL6xm+TfPaWnv/TZmFOAlkRiuWzQme7+Uu77NLgoMvgPWyiR/JtG+3OdVKIeF4CcQK+1E62sBUPtCIfMt7lVPXgCMHBamU3m9rip6yEh7KBEnfyrnJ3h1rekZ6WCVRdXBJxSp82K/QGt3iVlT9A1yCLZdt6IPkT83oN2pC6NT5bQ47gDb5cIxcwU5zZeLQ2wvDkOvVFitw/g9hKXQFvyMIBGplaTUjVyKpQHIMT9Rg542lEGVpad91JkJFVudlOokoi3Hu3x5g+3wtxw/UiQE2i6oCuFOBdNVN9YF+g99LVHfZXU1HmVLvXBvr0VnkAHmsREKELQ97Lkg0W1auDFz73uZl0oSJeNzI5IXVftHyw0gaZz9eq7voVEgKClfM78OYITpYS35tAHG4DTMC/gxnbuzeqjxxStThnZuKqD1V33xWASSCdb3tMuvDROj7xINDmrxgXF3u1q7/mbPTvfHRNWyxfIojbIGa7K/i2OJRxGB2tMCaGGj2eqUqvz0+Zuwk8JgscKJDBci9NAcDd12JhSEYIeBlAqkhEH5cP7NhQtWD27FtSFve9JMfyhBYgPKygBVmY1p1J2gcgTpcoPBqJi5N/7PB9p05rk5
 vxFYiuLJ
 J0Clp8WWKZ0KL5QbPTKm7n4/EY8c1LysjLbUFjRYyRCA7WkVb5QBodbhxn0BlJz0gI5XXAIERutN3ZLp3H/n6+MVxWiq0N0efNh9xkkFQUMKDOUAnvwwwr/yR+xDs24XZKKe7Sg+Tov9XsB6j4G8yIuTsqdnLhIFNldq+rYdhj6Ke+vPmIABF7fAwZ5SHS5y3aXXy8P0nhGHvKtcfsyRB1ctLiFyqDOqN4cWs0ePfaxHIOgKI/fVD4b8mhKpiCOxUdfc3NRyWYdZ7aS87fw0F8RbcSX46jXHJqm4ivAJlF6j+f201biRHXmhbM+pdOsNXIr7YzJJrPsxO7XwuXI3CsNHP5ypNrijGySQvpBpC0jKkUHRS9jb8EtQauYbBSieRIEcNSspO+z8CN2rakwG4M2lTMroAazf+MFQLxgJ09M0UA4qaEaRR2WgPQKz54tqkkkRv3UsUf9/wPk4f+4FxunVqfNXI41LKCdx2
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



