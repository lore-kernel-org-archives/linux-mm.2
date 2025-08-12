Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157A6CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41CC8E00C9; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC968E00BE; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2AD8E00CA; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B83718E00C9
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7836B81361
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:35 +0000 (UTC)
X-FDA: 83767015710.30.8AE95CB
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 949251C0008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=OzPn4l9b;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pafKDyE9;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf18.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977473; a=rsa-sha256;
	cv=none;
	b=uhCk4VxhmWij2zZYgV4UPKJtZJOIJWwIiyqsJkx35St4llpNZwGQVKbSrsicI3OK3djZhH
	ji5L8DwiLc8j06g7GGPnye558jWpaMhjRM0VBnubKZRflb2T1ngpbKauwZSil+svoMhVMg
	7M95snY/GoUcnL9/XlfucEvb7PjudzE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=OzPn4l9b;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pafKDyE9;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf18.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NxCSEvj2PqT9z+zh43cxWZPZy/pc7lSYDl/HSYdpX0=;
	b=xEQL+o5TmJ8z5obkUa8dRgT1UtW94FotiG+spIaOu9CeNgqRHuBo6DMjOSaLHDCAOfKlXm
	Dn0TqmDu+B5own5uqgm+Jq5LdEs3UY/WV5Zu83aN8QQMMIe6F6s1FEriQO1hzXLwqTUMjN
	wLb4N8io2Zt3ygdJKUGuR6HzwalRiZU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3NxCSEvj2PqT9z+zh43cxWZPZy/pc7lSYDl/HSYdpX0=;
	b=OzPn4l9bPnlKixJ4UTB4AhAiLkjej71xwPtqSacSd+DsXZttorULyXy0fBr+6XMEYsbpyX
	pktj9XCWQ8ee9sbQ7TYV8xKn9kXKt4m2MmDnVX9oK64iccISEQVpCVAjKsf5kfo2Y4wKUi
	D/gtoJVpdPcUWflVbX6Hs6iChwze2AWD5Nd6p9SmoIAq7Qmyf8+MGJgz+NTXtkznsfMX+o
	j3OCtHeIk3g8dw8i98Qx5qdXUibd3WkJPpTCzYYDMYJG02MGifnkCYLytDJNMiDCMFGFIu
	8/+eeYubofn5+rAsSCT5GEPgNyX67Wj5B38v0AvV+ZRmEt8rhZK2/TA3OnjrCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3NxCSEvj2PqT9z+zh43cxWZPZy/pc7lSYDl/HSYdpX0=;
	b=pafKDyE9bffqSWjpfAcol5Guig2fgcH1bW+oS2Qi1sEvJ6rykUviC/BNs2xCa8jswWQoAY
	SQ7jPA+bZKqPUaBg==
Date: Tue, 12 Aug 2025 07:44:16 +0200
Subject: [PATCH v4 03/24] ARM: elf: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-3-61a8b615e5ec@linutronix.de>
References: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
In-Reply-To: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@redhat.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=3153;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=jOcL1seJLYtGvYImS8V7KrNCGiyauUm9m0luaNV+25o=;
 b=2ZpJfDEg6FCwuTFwU3Nv++0bd6D+4hY16G/VIAHUE+ed4/E2i08I8MElZpFB/ZPj/iol+ibfT
 +7b+Uoz0sN9CIxjr9xcNzEwxHV7UcmSg7w4o2Gs4g4sQ4acRe/ztk9b
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: wkgpqnx3ms4t8wbnkgwfadys47ztsfeb
X-Rspam-User: 
X-Rspamd-Queue-Id: 949251C0008
X-Rspamd-Server: rspam02
X-HE-Tag: 1754977473-434695
X-HE-Meta: U2FsdGVkX19g+2oNBeCmkw61jR4uPxf1L5WPhk5u+NbL6TDLgSQQ9mC/JZeZGuJKTU8eaWgUA9UZm+OZzRJ4jMaFeG0ufyFfED8ZzeyuhZwXk+pMIHos3CSopOoKtIY1DG3g/LW3H4sBf3pksrT6my+CqZwTvwrmUPttNzF5STmR27nHQbIy3uEfK9VAIIdzcLSUBKvLylFAufd6GmcKzu8pFUVTqZMxTEGq9jfusd3aisD8cLJfFKd3JhvGlOUGjP8DZ4JmaHD7Zw6sUrzfM3MFv6F3uDpvhEmebaopWLMMc8Gyz7xOQ9drr0bxeo18cwBsmiq2Q3JBAKXaOL+/9AT4errsSqrOzXpwJ/pC4LSRsWUaWGfatLSbSep4gKyUyej7h4Y/DUAv2ZuP2n7XMLjiNNUjmkzQRxO1qJLmllkmt1zB70RLU60te1a0OBr0SSnYRbiaUjbl/jzyPS2Jdl5xo7aX8bluVNtLc2kLbhaFWEnnkm54sNo95HW5Hh3niQXyO/vDyMFvZelfbjol17gERug8j088BMLMosekQ5MotKA4BFm4oJ0CTelWxdZgoS0BMu1HfwM5ax1hxSFW8NalZH5XncAS5bLfIG+u7YihpqjG2aJqOxwV7gS2ZIPlRtP+m80n3gfgYxm/awCS/93iu4MaGgzcg1hOza2CjY+BJivWi6vq51JS8Q7dj6naRXJnPY/k9l44V91jVaeHcRiDDqrTsUp0M8BfRdpfre4fsqiJkKTggOlyBh7jGNaLcy1VS7PvDL6D4K0eaZbJQT6+kzO7QKBKFGZfRzHMhTtz/NeoR/RFXW5TsT49Fbksz+GDlshFCAEJLc1pbHa3hRBD8CH46zvZyKvE0aIlpyQ41SidShKJN//re29bJFVV/6aiOySVIXV1M0UE/vML3IZ+jA/BSiuqa7dnaXxBwKZYrHvCm/OaxsJG9nyJK07dGawCKdaZ+J+gvcQNOWG
 Hj78VrKd
 RWqTQeF4T5DZ5FAWNaSVqen72WcScsFhHxC7JvgQSHJ9pak9KA+aePbUoi1sJ9KsuJRMKHvlVzSTQidCMCAl5bhGLhEoW/yWlm9qbteBa+L6DFntH2ALYWrvxFWSbxlAXlyD439UCAVAw10LLfmb+gwLXQe3BjugMCqSeTYs7kJBPkGQb8MGbkWJrKt9vxPr+w4TwFp+47UigdLnhVbZF6afMUaVSwThRlGdMRcEkQ7ReRq9idlRBO5O974wX1krW542Atv644PaZr8paiC2yJXu6G6e4prechMNPQrFpCHBZychB9I31Qk7cjHn4unawsYM9AWYrjwL57/3AkJ7Amcp2wJLMmvZQNy/aR+lXJB11+ivsa8mnWOWTb7rv6skLJ69qgyW9jmz8QBpgORa8BH2Kfgh7ouhJizRKaI3u7Mrpo6GyE9Ahnb4cS/YHrSNxTBLUqmXYnk9KcOKOf/mQobfOTRZ+m0d045Qt5vG4KKEsrHgxljLA0fyRrAPyboGfKnpL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These constants are useful for cross-platform userspace, for example to
process ELF files during kernel cross-compilation.

Move them from the kernel-private architecture-specific header to the UAPI.

One arm64 header is also changed as it duplicates an arm definition.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm/include/asm/elf.h   | 24 ------------------------
 arch/arm64/include/asm/elf.h |  1 -
 include/uapi/linux/elf-r.h   | 25 +++++++++++++++++++++++++
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index 9f21e170320fc57f1dc21a33d637bcfd3d1d3917..ec2d416baa9f7ef4b860c4a18b2e2bf2f05e4a9d 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -47,30 +47,6 @@ typedef struct user_fp elf_fpregset_t;
 #define EF_ARM_HASENTRY		0x00000002	/* All */
 #define EF_ARM_RELEXEC		0x00000001	/* All */
 
-#define R_ARM_NONE		0
-#define R_ARM_PC24		1
-#define R_ARM_ABS32		2
-#define R_ARM_REL32		3
-#define R_ARM_CALL		28
-#define R_ARM_JUMP24		29
-#define R_ARM_TARGET1		38
-#define R_ARM_V4BX		40
-#define R_ARM_PREL31		42
-#define R_ARM_MOVW_ABS_NC	43
-#define R_ARM_MOVT_ABS		44
-#define R_ARM_MOVW_PREL_NC	45
-#define R_ARM_MOVT_PREL		46
-#define R_ARM_ALU_PC_G0_NC	57
-#define R_ARM_ALU_PC_G1_NC	59
-#define R_ARM_LDR_PC_G2		63
-
-#define R_ARM_THM_CALL		10
-#define R_ARM_THM_JUMP24	30
-#define R_ARM_THM_MOVW_ABS_NC	47
-#define R_ARM_THM_MOVT_ABS	48
-#define R_ARM_THM_MOVW_PREL_NC	49
-#define R_ARM_THM_MOVT_PREL	50
-
 /*
  * These are used to set parameters in the core dumps.
  */
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 3f93f4eef9530a7b5bc966bf4a16d83093a016ee..8efcfe7efe0c70c59b9b81f93ac9c1442bc7656a 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -18,7 +18,6 @@
  */
 
 /* Miscellaneous. */
-#define R_ARM_NONE			0
 #define R_AARCH64_NONE			256
 
 /* Data. */
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 45a160ecf40570f3ac916344be363d7e74908ea6..001884641e7703146f91e2dd96fb5a2bbfc7a324 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -36,4 +36,29 @@
 #define R_X86_64_PC8		15	/* 8 bit sign extended pc relative */
 #define R_X86_64_PC64		24	/* Place relative 64-bit signed */
 
+/* arm relocation types */
+#define R_ARM_NONE		0
+#define R_ARM_PC24		1
+#define R_ARM_ABS32		2
+#define R_ARM_REL32		3
+#define R_ARM_CALL		28
+#define R_ARM_JUMP24		29
+#define R_ARM_TARGET1		38
+#define R_ARM_V4BX		40
+#define R_ARM_PREL31		42
+#define R_ARM_MOVW_ABS_NC	43
+#define R_ARM_MOVT_ABS		44
+#define R_ARM_MOVW_PREL_NC	45
+#define R_ARM_MOVT_PREL		46
+#define R_ARM_ALU_PC_G0_NC	57
+#define R_ARM_ALU_PC_G1_NC	59
+#define R_ARM_LDR_PC_G2		63
+
+#define R_ARM_THM_CALL		10
+#define R_ARM_THM_JUMP24	30
+#define R_ARM_THM_MOVW_ABS_NC	47
+#define R_ARM_THM_MOVT_ABS	48
+#define R_ARM_THM_MOVW_PREL_NC	49
+#define R_ARM_THM_MOVT_PREL	50
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.50.1


