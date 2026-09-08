Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68533C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B1E6B009D; Tue,  8 Sep 2026 02:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833516B009F; Tue,  8 Sep 2026 02:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721E26B009E; Tue,  8 Sep 2026 02:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 441396B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D41EE1A03B2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:54 +0000 (UTC)
X-FDA: 85189629588.02.89C6627
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1F96640002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=BBfchTQ3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=epagOxWH;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849233;
	b=l0cT5lJWoFrubvnIVO6vPJAoXFr90Wn9BUVuHCovvvN07y95pI2h1lqtpW0yzgks2JMGhq
	1BL5mBsD5EPacBfyHPGzIrr87fqFG3UFak0L1o+CbNTe0Sffge4fme73Cp4Gxo3xIjGubK
	NEulZnlTjiuNaa6ZdyxXwQejb0qs+2k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=BBfchTQ3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=epagOxWH;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FawW0xiyyB3XDpeEil2328xu9JZeGaaUH29QSwtR0fg=;
	b=2T95Q+HLj9MpTHqkj4PdgWXrhqg80kBEYJKe3TBHRaRttiYShcUrHJEwWRZAXWVm9SARHQ
	ft19oZ8Y7iKEGPSp0Y18fQNOZZRu86zt/CFCiS4HQPo7cgk97CmpfO9vTsLs4t0IMU/ZVF
	f2j/MdIFzN6abcpalFCqJ9wVwImaU0M=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FawW0xiyyB3XDpeEil2328xu9JZeGaaUH29QSwtR0fg=;
	b=BBfchTQ31DifkjFqwb5y4n5BvOGW48DOyhiHYRpdPzrEQcn+IitYmXoSVnLWzvWa6lwHuy
	sZD+8Y+YV+U5Q+RLLiaQuk6+JRBJF9vi1Y1DGh92/GH1x2M0Sy+puIE8ZRZhqgBqF9ZxcX
	OVMEGjMH4cuC2Ih8qYPFGclgRGEjWPRnkw/+9BlYAZfTwu3dB+NLPwZ6JmOUFvLGShphqo
	lpE6byOStxgm5iAG6jOHo0tEAOdE8cTToyKI6d+gadpfoJgZfZRrWhapeXH8p8WEX3WKnq
	ZIRI/ePB8OFwnrq7FOJP8oo233EMrmmz/MJKwghMXEJPb8wamnhU9yuJgEsxpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FawW0xiyyB3XDpeEil2328xu9JZeGaaUH29QSwtR0fg=;
	b=epagOxWHbraL4pZF2ABSEKqkk81eezIl8Gi009ltXa6+5yB+cGQ8VNDm3CyFBBc9mW3J0y
	3loMMVZFFoRrE7AA==
Date: Tue, 08 Sep 2026 08:33:40 +0200
Subject: [PATCH v5 06/24] riscv: elf: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-6-3a93791af1cf@linutronix.de>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
In-Reply-To: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Andy Lutomirski <luto@kernel.org>, 
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
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Christophe Leroy <chleroy@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Nicolas Schier <nsc@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@redhat.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=4962;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=A2KwwyE44rpRvMfg8HmJMKqJMXpNGArDCbHCP2lPOtc=;
 b=BIFQBlA6uOHvotUFp7WcFcjkRWr4zWTBvAzopoDSHqbuVQn/0iY7yQ9cklHXDfQCbhw1lLP4v
 +pw2vSBQ8BmAxY2zgjj9x+KL+h6I3EZtcmF2oBqsXSxkzdljxYY/Ns5
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F96640002
X-Stat-Signature: bko3bimadhz76psct7ihrnsdmw8m7id9
X-Rspam-User: 
X-HE-Tag: 1788849232-94215
X-HE-Meta: U2FsdGVkX1/9xJfn+8nQrmmgWrj6rEG+s0jCzKOiXjBZqg0PXvlSlvivyC6EwBQIu6Eb01n8IYIP65b/MasvvGZYoB/pFpT8ixt5Ww8WkMe50xc1luuG+NkDNYgXFHsuMO/GUeoCPpux8e1GR8ArU0896wAXJOLwfdbaBpU0rKx7s7vBKuAxZsjGZyh1k9cTYp0SB2TRUG8jLlT3/1IK9uPXgzuiv2xDAYzRQU2Tj82n49ws9L+BdhOlhh/4W5e5YzztGR1AscWq7y5ANUMMTJGJU91ygiUZkRhnSx1VAGQxUhtBQucXTUJRdlf7XRX8SeWN23xrD745BLeCPBbaZRVGQOcnqV/inQzTUZacjPYGwDY8yel4jGzmThUCPeb+EgfiKV23VElHGmUwzW6rpTaYdUXGFLQ74sywpTeQxjJjNcrSFD07Qamm13+VkvtSFXLgp1C0kJf2dsb96O/ov5Y1TbQqTKno4UCvtCY/Tw/dc3jC7Micwz3zaXD/Z2GWHjqIRSe6vtsNHbezPhS/Q21zxnXSWn8NUdMaL4SEe8FSWIMuQFgbXKTvt246Jd95/XbgxfhpTo+vrdQacvEz+NhxL+9sriNRPrH525o1bbC7K1WZAm+940XIvjow6eWSQBTpBClO61tL6wNUwGNvd0chiiDcTklAAS7PeMjikXQjvG9pyWIeBaI2m15wQf4qzico38Y6l97HmV5beby8ke8EEmL0Tx9RJw0YJz78Yt/id4IeZj0V0HfXgAQIeNK6znMLtgfj8p766AEcy3BiiInsrJo6axfTvUTbcNPod/XVyUfqIjsSev9hj8Oem+Ap5hY7Tullq8kC3iOnJbsuUYXU6bBC1lfk98N1MWZA8Rxvw2V/BodzqLEMC8e5OQcvNnVCFKDQpW1YCxS7Ex1JqUl8ylaHXGf5elNzslGoMYkaO06VnTe0/s7Cr/a2zaGBeaKwTpMTwPpBUvVkc+e
 O1tTabaE
 PxpECbYBki/bebixK7p25WN8r0hFMQLgBmO1y4HWpMXdLGN8dIraV1x/PTkJx/RpMp6xgXZJEpLLuw/NTm2cGGr3XYCe+ytyUcr0daQNVHV8xZ9PmPGIONREyWOIG1uYxcI83V+KuUK71RBaLslL64B8smUr5PxRPc5siy5ekrM9INzUqmYEJfS79f68el1eSQbRNbw7AciehmxF2LKpDz/Mq+BBU86ghMGF8JZZiy5X2We9zXrBGeYHJpz3OSIlSdkzhkZYqEhFUdLPlFW2cuXxq5zc0qtFuK0xtwAK7tu3L1LOYVjrS8qrYLdPYlCH603Ph7qgLKY4vDeMMi1x64FHKiAjYeunPbObrgynQ04iYug9yOL2aBDCxsdPJQr44acDPeFG1ojhCFq33xxUkrLToLnOB6dzZJYd+lqsXSkSnwmVUfj4Pw+17erijeStiAMFKqknjKzTP7uNKmHFuPUEgAB6irtYpXw6o9CI2TBLLtBCqZicSHCIwb2yAmSR8NgtToxReerbBlSGiaafcEJX9P7d7sYxabFMiiYDrj/s9MHOnunVK4WDNTbxR9Aub+qG6LYxsVKvYFUraxWT0gL13lN+/Jd69Dpb/
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
Acked-by: Palmer Dabbelt <palmer@dabbelt.com>
---
 arch/riscv/include/uapi/asm/elf.h | 66 ---------------------------------------
 include/uapi/linux/elf-r.h        | 66 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/elf.h b/arch/riscv/include/uapi/asm/elf.h
index 11a71b8533d5..05cf74a4a535 100644
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
index 0d0dfaa7c724..02e420c255df 100644
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
2.55.0


