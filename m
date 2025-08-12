Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E753C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4FF8E00CC; Tue, 12 Aug 2025 01:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66658E00BE; Tue, 12 Aug 2025 01:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6FE8E00CC; Tue, 12 Aug 2025 01:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1288E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CC1F1401AE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:38 +0000 (UTC)
X-FDA: 83767015836.02.CE882E8
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D0A240006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=xmdZdIHs;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=p9LomzCh;
	spf=pass (imf17.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLFF7RcTXEh7J++8oRFtDMgib541QPR3j3iTPRakVR4=;
	b=NMY2CZWLr88r3qi58FDIGmIz6iMp+so/LwM77UomNI6N5OScmZRXpRE2EkJZs7ov4v2nYS
	BihqG50Fxo/fQT2V1k2RXacjQdOyKVEaDcpPd+eij4S8pQ2DYH1Y0h4Q9JLGFBs7CT9AEx
	xD4PeCzrygzrpDkeVu2Z09ba0BHagP4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=xmdZdIHs;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=p9LomzCh;
	spf=pass (imf17.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977476; a=rsa-sha256;
	cv=none;
	b=GbLFgKgBFTlIayFFAhBW8Om0kzIA59OetRn86EoQyRsfq/1Ibk2/R0vSwj91o/fFKICDo0
	55i3Iz/doArkOzy6/9KFbz6O35Il/OroV3g40UqCjbOcKqSbhKfdHyORwkfv2mumvF7//k
	EC+yLteRotp9RrjTjFj/BaXHutZbC+Y=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xLFF7RcTXEh7J++8oRFtDMgib541QPR3j3iTPRakVR4=;
	b=xmdZdIHsWwP/TxhfVFisseNTc/0hbdZicN0qfGKNGeNlzKewzVkXv5sdA4lM27FEH7QMYE
	4QKhLUaNxvKkExW0VFtSrE4t0q9FrVpd4/cBeivIZBP5fi3pj0Q2Y7QMvLbWQkr6+n1wo9
	jFox27nxR//Pwo5WgItwK6Jj3DT4yo/xZpgFYRbQd4kP0McfvtHYIMbAHq/4T8kPOxsiTN
	MYSLVKmQvoc0cVXaSB+H07FPBTnFfNQJ4YoXXoiC+NBV0aOeKZ5CttUwtasDbWQyh/Mby2
	CBKsQ8v4MYuZI2Y6GLTDGq3dYFUTYHoJSpVxJD8nQwTQhoAHmOkryjb4sNqxLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xLFF7RcTXEh7J++8oRFtDMgib541QPR3j3iTPRakVR4=;
	b=p9LomzChEORTxM1tlQ8Uf6LNOyTc69rJSBAcj7cgFyKnXKqJPsVlZUyH8jeP2NLLcC3ZbB
	bztzjjgIw+CLksCA==
Date: Tue, 12 Aug 2025 07:44:19 +0200
Subject: [PATCH v4 06/24] riscv: elf: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-6-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=5027;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=JvVhNnXqLZi9Urcv3cUqECDYuPaTssZzAN5WZwS9T8c=;
 b=cptfkIfZYzK20UK+A4ARj+d2phq5mEEoCRFgWfpV+I4Wc+7KlP2R8hpKDZkDsX1BB87WWP8wh
 BGrov+RrHd1CwtMXd0tfU3+rXk87A3z6hSUldor6cipygzbxcVGxdE+
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: 5D0A240006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ehw49kxsub4xna8kterh5og8c7di6n5z
X-HE-Tag: 1754977476-522376
X-HE-Meta: U2FsdGVkX1/mO+HMji2htLc0BlNrRzh1/RJkTEf4Od0yonn6XPecD1TZr+dgfBcuubsgTZ3xjdYoPUP9S/Ac0GxtZPwqggLahX0SzNJSxl/gVQc8lkNCJ3VilA/C/zDICoe/hOrLkVvTIeQBW7aDs46dkvpn9bS/AeFClni4fvjgFHu2Hms6JFOaMo9Ra3EhZsZ3WQDu92YQt63sYojO3xKJn06nArXWqKeBw2o5XgvWmOcuvGpjgNS9ob+3Z2eEJrLsjqiwzhXDLKys8SZdlFZBpXnYWfiIcur3uYJ2E28knWxICA5FHSUK0bYyyyNHeukV8+lQzigauSYGsVb970QnH07l3Zq+lTiCNT8iyH12drnP9lXHE3XLnKl464zAo4HAYuuZ+qSndjDtKqraKh1T1o2aDXnumNmZ4XEc40AHhCahjuiF/gMjT6yCYTDknrBZ2C4OLxqLaHVEv9M+DMxuITiJrxTJF8mxpGddOfKBdMc+SlY0E2/qPOmrn+eDdcpwFCUN8CyBmJXR6GGseobvGDjPHwX1JfVe9Q+YEJmpyks4sWpCmJhkCzZ1ixhiPLJALlaCSh9ORGAL4nLNREZsym0R1Ru7lSDu5RnV6YOWa7jsQBm5Qp8Rvfv6MAYCQ1fSbAoo7EKkL3RYOVwYf16yE0rmKqikxWD4uWvv24Ksg/iScWJVs/9BW54sw7RoE6uvyoGhkdIOTBp9buNiNL/2yRgDi+rYv0uWdB8aIS+HYuEKpNpdguQMbYVfUbBs27wiQ9Q/mPAvxw9+dW8luCweGW9Z0IiG/06zaaBAhStjbmzGFADXwcshl+BHlj36LRs/xp/BnXROzNgOeBtAQir6UdAgY+TqG0EMUF7skumjBK5/NyvjxTi0PWOn5E2mphsA9xUpZl1TjuKIIVYnGcMFlx2zgjD5GN2UVeJtmSwI//nKdYPkfp5aJDLP/quPllHwR0mJC4vmc3+Fnl8
 LHHcjFfR
 WALIPEcRBMaD2vRNBqRoj+UYqOS8DTEYUUHI0jUDqpGUMnz4xWK/GZuJCevJhTR6eHX6ju7KNQG9c+24bPXVBviFLzJ3LG8l4CbfTp3BDR6dRgdhmqVvCXdHnDhvOL6JcXAVGWdtmhCg1xxWVYjpU+PpLoZFABl/4OZGP22xJ+OfJ8cv7G7erXJpfXAbX3sTMpTJui+txpemjRDS+TtJpeU1rvgT23N8VHqnIRR9TT7eqNS7rq8aA1FSRxIQ73oN0VLJqna8R/jhQfiWKXL/QvFE2ujLB1lDimaICN1i8Mvz3rZMOwIe4boLMb27HWcedxKG16sE4QilnatEjly3s5EpYICih7qOuXunBPj8AW3d0kyCHIMjrKe134Kgy2IHvj+Z/6LAF5rPK1v2hByY+ncWDEvv0HmCDN3jOtKxrULrd8cEBBVlCkdNeAEwc9gnoxv1hfvMB2syqa8GWGETVudvCzjE4Ert5t+yUOjXWZfZzX5lG6620feConzK6edm5QoTI
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

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/riscv/include/uapi/asm/elf.h | 66 ---------------------------------------
 include/uapi/linux/elf-r.h        | 66 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/elf.h b/arch/riscv/include/uapi/asm/elf.h
index 11a71b8533d5759ec724a8359d0ffa2a4f2e976d..05cf74a4a53579006a9cef1ed1dbff81d0e50c87 100644
--- a/arch/riscv/include/uapi/asm/elf.h
+++ b/arch/riscv/include/uapi/asm/elf.h
@@ -32,70 +32,4 @@ typedef union __riscv_fp_state elf_fpregset_t;
 #define ELF_RISCV_R_TYPE(r_info)	ELF32_R_TYPE(r_info)
 #endif
 
-/*
- * RISC-V relocation types
- */
-
-/* Relocation types used by the dynamic linker */
-#define R_RISCV_NONE		0
-#define R_RISCV_32		1
-#define R_RISCV_64		2
-#define R_RISCV_RELATIVE	3
-#define R_RISCV_COPY		4
-#define R_RISCV_JUMP_SLOT	5
-#define R_RISCV_TLS_DTPMOD32	6
-#define R_RISCV_TLS_DTPMOD64	7
-#define R_RISCV_TLS_DTPREL32	8
-#define R_RISCV_TLS_DTPREL64	9
-#define R_RISCV_TLS_TPREL32	10
-#define R_RISCV_TLS_TPREL64	11
-#define R_RISCV_IRELATIVE	58
-
-/* Relocation types not used by the dynamic linker */
-#define R_RISCV_BRANCH		16
-#define R_RISCV_JAL		17
-#define R_RISCV_CALL		18
-#define R_RISCV_CALL_PLT	19
-#define R_RISCV_GOT_HI20	20
-#define R_RISCV_TLS_GOT_HI20	21
-#define R_RISCV_TLS_GD_HI20	22
-#define R_RISCV_PCREL_HI20	23
-#define R_RISCV_PCREL_LO12_I	24
-#define R_RISCV_PCREL_LO12_S	25
-#define R_RISCV_HI20		26
-#define R_RISCV_LO12_I		27
-#define R_RISCV_LO12_S		28
-#define R_RISCV_TPREL_HI20	29
-#define R_RISCV_TPREL_LO12_I	30
-#define R_RISCV_TPREL_LO12_S	31
-#define R_RISCV_TPREL_ADD	32
-#define R_RISCV_ADD8		33
-#define R_RISCV_ADD16		34
-#define R_RISCV_ADD32		35
-#define R_RISCV_ADD64		36
-#define R_RISCV_SUB8		37
-#define R_RISCV_SUB16		38
-#define R_RISCV_SUB32		39
-#define R_RISCV_SUB64		40
-#define R_RISCV_GNU_VTINHERIT	41
-#define R_RISCV_GNU_VTENTRY	42
-#define R_RISCV_ALIGN		43
-#define R_RISCV_RVC_BRANCH	44
-#define R_RISCV_RVC_JUMP	45
-#define R_RISCV_GPREL_I		47
-#define R_RISCV_GPREL_S		48
-#define R_RISCV_TPREL_I		49
-#define R_RISCV_TPREL_S		50
-#define R_RISCV_RELAX		51
-#define R_RISCV_SUB6		52
-#define R_RISCV_SET6		53
-#define R_RISCV_SET8		54
-#define R_RISCV_SET16		55
-#define R_RISCV_SET32		56
-#define R_RISCV_32_PCREL	57
-#define R_RISCV_PLT32		59
-#define R_RISCV_SET_ULEB128	60
-#define R_RISCV_SUB_ULEB128	61
-
-
 #endif /* _UAPI_ASM_RISCV_ELF_H */
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 0d0dfaa7c724d5f0230e5b7b9b713d8587030637..02e420c255df67f8f7e4bc3165f808b9935f5b1c 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -314,4 +314,70 @@
 /* Keep this the last entry.  */
 #define R_PPC64_NUM		253
 
+
+/*
+ * RISC-V relocation types
+ */
+
+/* Relocation types used by the dynamic linker */
+#define R_RISCV_NONE		0
+#define R_RISCV_32		1
+#define R_RISCV_64		2
+#define R_RISCV_RELATIVE	3
+#define R_RISCV_COPY		4
+#define R_RISCV_JUMP_SLOT	5
+#define R_RISCV_TLS_DTPMOD32	6
+#define R_RISCV_TLS_DTPMOD64	7
+#define R_RISCV_TLS_DTPREL32	8
+#define R_RISCV_TLS_DTPREL64	9
+#define R_RISCV_TLS_TPREL32	10
+#define R_RISCV_TLS_TPREL64	11
+#define R_RISCV_IRELATIVE	58
+
+/* Relocation types not used by the dynamic linker */
+#define R_RISCV_BRANCH		16
+#define R_RISCV_JAL		17
+#define R_RISCV_CALL		18
+#define R_RISCV_CALL_PLT	19
+#define R_RISCV_GOT_HI20	20
+#define R_RISCV_TLS_GOT_HI20	21
+#define R_RISCV_TLS_GD_HI20	22
+#define R_RISCV_PCREL_HI20	23
+#define R_RISCV_PCREL_LO12_I	24
+#define R_RISCV_PCREL_LO12_S	25
+#define R_RISCV_HI20		26
+#define R_RISCV_LO12_I		27
+#define R_RISCV_LO12_S		28
+#define R_RISCV_TPREL_HI20	29
+#define R_RISCV_TPREL_LO12_I	30
+#define R_RISCV_TPREL_LO12_S	31
+#define R_RISCV_TPREL_ADD	32
+#define R_RISCV_ADD8		33
+#define R_RISCV_ADD16		34
+#define R_RISCV_ADD32		35
+#define R_RISCV_ADD64		36
+#define R_RISCV_SUB8		37
+#define R_RISCV_SUB16		38
+#define R_RISCV_SUB32		39
+#define R_RISCV_SUB64		40
+#define R_RISCV_GNU_VTINHERIT	41
+#define R_RISCV_GNU_VTENTRY	42
+#define R_RISCV_ALIGN		43
+#define R_RISCV_RVC_BRANCH	44
+#define R_RISCV_RVC_JUMP	45
+#define R_RISCV_GPREL_I		47
+#define R_RISCV_GPREL_S		48
+#define R_RISCV_TPREL_I		49
+#define R_RISCV_TPREL_S		50
+#define R_RISCV_RELAX		51
+#define R_RISCV_SUB6		52
+#define R_RISCV_SET6		53
+#define R_RISCV_SET8		54
+#define R_RISCV_SET16		55
+#define R_RISCV_SET32		56
+#define R_RISCV_32_PCREL	57
+#define R_RISCV_PLT32		59
+#define R_RISCV_SET_ULEB128	60
+#define R_RISCV_SUB_ULEB128	61
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.50.1


