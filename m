Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E545D339BB
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2CC66B027E; Fri,  5 Dec 2025 13:41:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB14B6B0281; Fri,  5 Dec 2025 13:41:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3E76B0282; Fri,  5 Dec 2025 13:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C71F76B027E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71713580DE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:55 +0000 (UTC)
X-FDA: 84186286590.16.CB1045C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 66C038001C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=amhMfDmS;
	spf=pass (imf02.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960113; a=rsa-sha256;
	cv=none;
	b=BLZFWRBU+wi6LFBk2PXXbkFZwUKJPkWSmKFCagw1ELIBCPEcmQkycvm9uWNuNgrSY5EsR9
	Mtd4BfNBpQIqfbKUvsYwhap4I4bC5r9NB2we0YJtYJEKTZHwLJCwBiQoqTu+N62BCNo708
	pi+TXMaZgYIBH7RqwJ6xhIBRD+TR2cc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=amhMfDmS;
	spf=pass (imf02.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ko4UZoali671x/Z3JPzfzRKjAHhqWt8s623S099BIJg=;
	b=wkFXwDGWBmh44lo0HcErigLK/osVPCCBp4PIOGXZvAtP7K/g9UkG7slOdUdKlNte9B6wjy
	SysQYA46XXXX8Rdxfj8SubraWXorFebhRJFxcFq+ZNS8sSZOGDfU8LjU5ObiU6mop0okqo
	rulMXzJtsQRQBFOWXkHyZsJcbVuaZ2o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93182444DF;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3745FC2BCB4;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960110;
	bh=RoLXunQkUD3GkpFVEtA9EVI1x173h9+oOTkpPb8AiyA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=amhMfDmSTHohN6Wc1pdd3rVWYIEX4UsU97c0TqHVZDgW6FiVYsVWarfrK4rcQx5gN
	 kk/L1K6wBfBUoG3TYMc9NJB0VjJeEFJwUX6rOYiFD7IiS45BGm5rFIuUmRbdjdrRAG
	 A3WDchBZv74gELIfiQPQJG0IUxaFFm+CRG3bK8xGmXQ8haNYTFAl/TlTCQX8p7w1v6
	 CekfN9xdHO3QEKWZIqohZ/JJrTt2C21xHf9xr8ZL5U7ll4CL4z5fWTyvFAEN8e2bj5
	 lye1igSXKU9X2TwITbMVsJBIDjCxflL1tKCvoiwPWUvh/pEzAwZGVwVWRfHTE5Gwmg
	 yidtNedjYYA2A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB08D339B7;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:42 -0800
Subject: [PATCH v25 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-4-1a07c0127361@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=2422;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=bX3DT0H8/Cf0WOd9ExAzvQuoOWT5xK5PI+asRJPlwXE=;
 b=SSOzOiFS7a+lafurhUTL8mzosiTdRa0uawAAcSMqnOR2x3j3ayafozy6KNU05qCXpP5YUCtAz
 ojOOUAHM6GXCQSIURYO27EP3bbrLw90JCc81wJ3KIuVfX1tt406wvjR
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 66C038001C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: x3zu97gfbop8eeqg55u9zsf5j1n9cxrc
X-HE-Tag: 1764960113-389265
X-HE-Meta: U2FsdGVkX1/FYWzsCJ5U6AQsoCy/JHBHpfzsrgGyCAzAy581VFFhY/HbSRol5U5uhUQsH6ymtOMJgP2hFyXssiS4MdTqxGbhsu5YJ2Bkg18e7fbq+yNxUr64DFPV35Cd6ypK/INH9qbmVZuESYZsFUjLTiwOA21lfYuYOLmUbX+d7M0/ZYBl2y//sqr5gviMsGAdgqblHB8DiSkj3zn34C+4bQGlxjKgL19WwKYWqAtFXCuyTY/okLiML7nsRqt452pptCiRRXJtMi8xX18ysZvx1ruaQzSpKiY2fMmoNuUvZUDt2wI6H6uGkmO+a601WI/p3IKwKAnMNhiwdjyNGt2kHa7uuETVLvJPsMc0URcPVmJdVYI+nxJEtL9X+0H+a4TB4jIoMGwcD/05i3H6gSyFC12RUfZvwmLDnTGgQOnSQqx8d9uNJmMUz7KoKCtQHNsOSRRda2346FO+Y1LB1RuxyVTgtzuZbs6+2Ncyz3uUP7ceMvgKMltGIR1TzYSmHopo25LMvJ9r1r9VXOglQ73KAGSAV7e52+mpMeGx7kfuePoUurz1U72ug6jHOC6mQzQSfBjGF9DxzzHHqFcFobrM4AsWYia2cDyFyhzdNQWSDRE2DmFLv+xcCIstd7AXWDkUAKG4D/JCAQ3cGL6VdU+LFOCcP7zjGvuAwXv3ziuNbQyJrxmHr9CjsaIh5mQ0d66HXHPSSrnIkQgrIG/kgKUCEVlb1zukWBItGV3VhV4KDQrB21Mr5DbraHRE4SWe0tNv4dF9NuisMTFpuKg4X4efECYQAz0kBnwyBudLJH68S2Mne5ipsRFYqoeZvm7dfhMpq18VfMq+9qMh/018uFKdnAdBX+H+9OhwqgQgC8ll3BrEEd9CxMzCIOytMzbIrwGOdgdBoc8npJ4iI23cc9yCyNNxruoe5Qos6b+PcYaZJ8p/YWglu2lnjc57ORQT5iwxTFihhbDbAsfjevt
 o2h1zd/t
 d23YZRteI6jiBEgAa36voStzU/+dt7f9Ix2PdDk/YlgEulwQAqNJG7ZExx2MdSozZt2UXqQJssfBK3fGeuev4fjYUgydGp3UwOs/WFU9qQJ+iBl4eBB04CTQIYd3AJUErmpK3J9tGwZQVIzHk4Op7t1qNS4t2iejwM3/u2JrfAtf5U22Syw7TGHyMTYtW25p8U/a7dnJLfsPJk0In2TQokx0qSx7N9uN/szU1HZd07KEEn/mrEguj9v0jbmqyAGjFyFMmNIGBwxY6qn4DX7AOrf7q9CdPXY0IWveb1lE9DF8/4Yyc1bLMVvdWH33Y4OJZbKz6Mqm01kN/r3ErqAgJAb2g3Kqm9iod5ewqj+dlwPpp7Fkwr5aHlvLuq6sNvclj6MIweZwiuVpc6z/WFo9e7ZLT1y0Us9Cac/iA3N5/N8IQ0sOlahq2BfhZso/RPN1dIvc370C4HSP7uMTtPnqNKCyBcPgk2rfLYMjLiq9BZwTpfsdJ+50pnuzHd6rbs0tJ9KCT3RsBli6gjzqPCCfNwxdJ+tgMzniK8SYr
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



