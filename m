Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F66DC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91FC6B009E; Tue,  8 Sep 2026 02:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41366B00A0; Tue,  8 Sep 2026 02:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08E36B009F; Tue,  8 Sep 2026 02:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CED66B009B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3274160373
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:54 +0000 (UTC)
X-FDA: 85189629588.03.1AB184C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2BC9BC0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:33:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=RvteM5pX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=tPWSdfCK;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849233;
	b=wogzWXl/fMw4wDGeGsEDsd8nPxPqu14qyTxU87fvYfDL/yQtcN+IMFHIGY2GsVuJ/Pr6z5
	grWYJvMXSb44wmCH8aUhdprjVvIrigUe005zJX9A1LVkyNCAiGRs0cWsLYNzt48eQwo7D5
	ywuO3QTwL5mgu2tbd9qgmwGmiRRP30w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=RvteM5pX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=tPWSdfCK;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGf3TnE/lW/fYbZlFBrmGDjZjd6QYLG2uDJD7NOhZPg=;
	b=h46SYFDaZj1gdmB6+g/n6l4Eknm7PQ6dFklE1l2b5NbRshS+7JD3fAmJ/SqHzx7hHXlx3n
	pXiiq1s7PHmc7A3ug8c0la9uzI/4y0Fh4Euky4Gn38SkAlzyFAYTotBdOQj3KIdaEALvFL
	JCdczX4spgplOlW5qLDx4Oji1HN+TJw=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGf3TnE/lW/fYbZlFBrmGDjZjd6QYLG2uDJD7NOhZPg=;
	b=RvteM5pX/6scTvVHhc9nHPA51oZliMFKpw0j5QYKMFpse7+yPHSkVy9fM+rso/Wb2YFrm1
	H1wiqXKWH1Z2v3SGs3royO/jD58rDDfo11wybTYB9b0p52SEr1U93v/XqQsxU3Oz4QOvXM
	lB9yw3AsT0ySjk0xrTX7JA5uNIOUl9V0q9lwcoZAUyxlZjaonToBT7f4xPG3MCq6XztezM
	4IUl0hofZ21/AcEdhGZv5aCyyQyxkmx81s1BIOMmsqgAt4bfXss0uaKrGwDolo8Nz1mueb
	HIbO21hw0BEwZGhu5nDiFjPqpQUd/uWztc8r7Mp5JuDJYZbhdyZxqsyCd2nS6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGf3TnE/lW/fYbZlFBrmGDjZjd6QYLG2uDJD7NOhZPg=;
	b=tPWSdfCKOrl+sngE7bk54ExyIa5LzKKavkT70SIPlYNF5G1LVQzybS8BYFZ3IaW4EZdY9Z
	8ES7SXoSssj4LgDw==
Date: Tue, 08 Sep 2026 08:33:41 +0200
Subject: [PATCH v5 07/24] LoongArch: Move relocation constants to UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-7-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=10431;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=TVNv1EnbeVl7eOp2X/cpMXp3v4L6yRWQXdRgwohhP1I=;
 b=H7Of+EsKkYRm00bvzre3reaxsgBnlaZY8AOjsL+5NYLinUvECXNhAROQlYKStcUa1mehUxMl/
 fwHuq7Wucb3BtsShMthHqQgQZN4C/z+vtTAIEgpoimFJKe1C60eIDd3
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: qc8d6f6zaernw7t6pdzoqjwqtgbb9sms
X-Rspamd-Queue-Id: 2BC9BC0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788849233-200345
X-HE-Meta: U2FsdGVkX1+/3ygxIMWQUF/eywuD29Sa7uaTa4TYjY4WHDlQ8/zb3VoAAmH9j69azrgglPYSAwUjPp4Q4RuVO/ZYVnwtkFF+/JJq3JnBNwBcuvlpLYn+YyXf4VUi60/8mOSbjYtuKON7KPryFydHquRErh3VFtmIEM7IA+UlZe6v354vesaVyAw7Kyx7GchNO2MSAcFedMDSi5FEPSgFnD6v7gyowhjRFTKRbso1SdV92w4Fi3BUIQjhZzvRuoNNbdak499KDVfb1mtUaOTHp52iCF5DZgq0QzRqJHiYuSMh4T1H9RtnyZWQJtu9qFBvwBqO84p41sbwPGpVNiyAtkrZvOLvobzar8L2e0Cbq+rQzr+wo2l+Wpe76V97FFGOJgW3BXgyjjajk4ff9jd7Tc/2OFWrVoUhn6M5uJUqg6dZTKOQ8U0hoq7EKqT2KNsX8KcEt4Sz1m4pZCuPOrNfqAso7F1z7V7Z631T4Xzqyti3oLl0/dPtZDspL6gNPjMVu746HizN1rkKaI+6atwA1CEjsmIux6Mday1QvFUk53SuSRRT0twhCt0a7ArUZLO/92FqxfYnlh9Yb1cXnHWZ1gGzYuX58Tycn5I8xlToI7dvrvsEGMurKyxQr5J85Q+bG51POZG7VbBSE6p3YL8s+voYZE+aO5REV8CK+FBCrkaMwVSLVbMLqRYCirT90jjcMJGoreICiVl2MCzXrJ4o+2X6XkqT23DqpaXRFQbvYNIeo32vTikWuWT0l28IGmODBAKLfXl3bsbg3gY+Amc3tDAmTrNh5eu3jXnlqv8xnSKnxI2VxftsOpvAuq6aJrjRH4aVt/fjgGs9Bobcp2pOfhE2gZLeKkDGUwzK5dAm5ZglNCLePJSQn7LbtqiNPDbqXA3RCqC4/wKWtPtYthw0kN8It6uX6rQslV7D0KdQ2BpSmFdwuEoewrvVaowW+Buu40Mlt3lBqaPkJ9PEwZI
 K3lozhYc
 mzJMsIyxmxwYb/0ZqT1AFUPvZG/kQQWyjX7PzTjQrWouixYYm0Vrwgf+ZJZ+55ID+ZeKPNUlIGiGFdo6oqfAIidRuVIloBPCKu2v3qi8t7ZrA+MvD3Fkld42yl5muPPRS2kmVkIbMbuQcmg624c6BpUZYkJQz8JPNiDC51snZVLVUX8GKUnvnr+nSXThzEcN60r7RgGRDw5rQs6cvjf+EdbWEhw8GFkMaBNHoZjWsjfMxerLccRLwZYQvgjXm8jyO+08Se6vyxcUjkkJ++/4w9AZ7nOhEa3VqIYXfeoR9pmlrD7pp0hROaGOGiaDDW0fw36idqCeRg2PU2gnFUgg//AJFT3wMHw0maEj5zPitTAQfN4YAxh0vkNENIL81u0kviU4xlRU87q8HHeNVpWYbd9M8qHth59H+BELBB63L9p6GsRDK8uYOj0MdGwlArOOskQotEYf340bg1EhG8KKkNQuK9GOT5ih61e5mVSYzhuo25Lt2FSQVhthIuyxTQcY4yeQc9VKlWsxKgJ4ODLq2Cxy5VewC8jJhphDXZgILU6zAse8=
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
 arch/loongarch/include/asm/elf.h | 130 ---------------------------------------
 include/uapi/linux/elf-r.h       | 130 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 130 insertions(+), 130 deletions(-)

diff --git a/arch/loongarch/include/asm/elf.h b/arch/loongarch/include/asm/elf.h
index 912c50cdd6b7..3cbce7e772fa 100644
--- a/arch/loongarch/include/asm/elf.h
+++ b/arch/loongarch/include/asm/elf.h
@@ -21,136 +21,6 @@
 #define EF_LOONGARCH_ABI_ILP32_SINGLE_FLOAT	0x6
 #define EF_LOONGARCH_ABI_ILP32_DOUBLE_FLOAT	0x7
 
-/* LoongArch relocation types used by the dynamic linker */
-#define R_LARCH_NONE				0
-#define R_LARCH_32				1
-#define R_LARCH_64				2
-#define R_LARCH_RELATIVE			3
-#define R_LARCH_COPY				4
-#define R_LARCH_JUMP_SLOT			5
-#define R_LARCH_TLS_DTPMOD32			6
-#define R_LARCH_TLS_DTPMOD64			7
-#define R_LARCH_TLS_DTPREL32			8
-#define R_LARCH_TLS_DTPREL64			9
-#define R_LARCH_TLS_TPREL32			10
-#define R_LARCH_TLS_TPREL64			11
-#define R_LARCH_IRELATIVE			12
-#define R_LARCH_MARK_LA				20
-#define R_LARCH_MARK_PCREL			21
-#define R_LARCH_SOP_PUSH_PCREL			22
-#define R_LARCH_SOP_PUSH_ABSOLUTE		23
-#define R_LARCH_SOP_PUSH_DUP			24
-#define R_LARCH_SOP_PUSH_GPREL			25
-#define R_LARCH_SOP_PUSH_TLS_TPREL		26
-#define R_LARCH_SOP_PUSH_TLS_GOT		27
-#define R_LARCH_SOP_PUSH_TLS_GD			28
-#define R_LARCH_SOP_PUSH_PLT_PCREL		29
-#define R_LARCH_SOP_ASSERT			30
-#define R_LARCH_SOP_NOT				31
-#define R_LARCH_SOP_SUB				32
-#define R_LARCH_SOP_SL				33
-#define R_LARCH_SOP_SR				34
-#define R_LARCH_SOP_ADD				35
-#define R_LARCH_SOP_AND				36
-#define R_LARCH_SOP_IF_ELSE			37
-#define R_LARCH_SOP_POP_32_S_10_5		38
-#define R_LARCH_SOP_POP_32_U_10_12		39
-#define R_LARCH_SOP_POP_32_S_10_12		40
-#define R_LARCH_SOP_POP_32_S_10_16		41
-#define R_LARCH_SOP_POP_32_S_10_16_S2		42
-#define R_LARCH_SOP_POP_32_S_5_20		43
-#define R_LARCH_SOP_POP_32_S_0_5_10_16_S2	44
-#define R_LARCH_SOP_POP_32_S_0_10_10_16_S2	45
-#define R_LARCH_SOP_POP_32_U			46
-#define R_LARCH_ADD8				47
-#define R_LARCH_ADD16				48
-#define R_LARCH_ADD24				49
-#define R_LARCH_ADD32				50
-#define R_LARCH_ADD64				51
-#define R_LARCH_SUB8				52
-#define R_LARCH_SUB16				53
-#define R_LARCH_SUB24				54
-#define R_LARCH_SUB32				55
-#define R_LARCH_SUB64				56
-#define R_LARCH_GNU_VTINHERIT			57
-#define R_LARCH_GNU_VTENTRY			58
-#define R_LARCH_B16				64
-#define R_LARCH_B21				65
-#define R_LARCH_B26				66
-#define R_LARCH_ABS_HI20			67
-#define R_LARCH_ABS_LO12			68
-#define R_LARCH_ABS64_LO20			69
-#define R_LARCH_ABS64_HI12			70
-#define R_LARCH_PCALA_HI20			71
-#define R_LARCH_PCALA_LO12			72
-#define R_LARCH_PCALA64_LO20			73
-#define R_LARCH_PCALA64_HI12			74
-#define R_LARCH_GOT_PC_HI20			75
-#define R_LARCH_GOT_PC_LO12			76
-#define R_LARCH_GOT64_PC_LO20			77
-#define R_LARCH_GOT64_PC_HI12			78
-#define R_LARCH_GOT_HI20			79
-#define R_LARCH_GOT_LO12			80
-#define R_LARCH_GOT64_LO20			81
-#define R_LARCH_GOT64_HI12			82
-#define R_LARCH_TLS_LE_HI20			83
-#define R_LARCH_TLS_LE_LO12			84
-#define R_LARCH_TLS_LE64_LO20			85
-#define R_LARCH_TLS_LE64_HI12			86
-#define R_LARCH_TLS_IE_PC_HI20			87
-#define R_LARCH_TLS_IE_PC_LO12			88
-#define R_LARCH_TLS_IE64_PC_LO20		89
-#define R_LARCH_TLS_IE64_PC_HI12		90
-#define R_LARCH_TLS_IE_HI20			91
-#define R_LARCH_TLS_IE_LO12			92
-#define R_LARCH_TLS_IE64_LO20			93
-#define R_LARCH_TLS_IE64_HI12			94
-#define R_LARCH_TLS_LD_PC_HI20			95
-#define R_LARCH_TLS_LD_HI20			96
-#define R_LARCH_TLS_GD_PC_HI20			97
-#define R_LARCH_TLS_GD_HI20			98
-#define R_LARCH_32_PCREL			99
-#define R_LARCH_RELAX				100
-#define R_LARCH_DELETE				101
-#define R_LARCH_ALIGN				102
-#define R_LARCH_PCREL20_S2			103
-#define R_LARCH_CFA				104
-#define R_LARCH_ADD6				105
-#define R_LARCH_SUB6				106
-#define R_LARCH_ADD_ULEB128			107
-#define R_LARCH_SUB_ULEB128			108
-#define R_LARCH_64_PCREL			109
-#define R_LARCH_CALL36				110
-#define R_LARCH_TLS_DESC_PC_HI20		111
-#define R_LARCH_TLS_DESC_PC_LO12		112
-#define R_LARCH_TLS_DESC64_PC_LO20		113
-#define R_LARCH_TLS_DESC64_PC_HI12		114
-#define R_LARCH_TLS_DESC_HI20			115
-#define R_LARCH_TLS_DESC_LO12			116
-#define R_LARCH_TLS_DESC64_LO20			117
-#define R_LARCH_TLS_DESC64_HI12			118
-#define R_LARCH_TLS_DESC_LD			119
-#define R_LARCH_TLS_DESC_CALL			120
-#define R_LARCH_TLS_LE_HI20_R			121
-#define R_LARCH_TLS_LE_ADD_R			122
-#define R_LARCH_TLS_LE_LO12_R			123
-#define R_LARCH_TLS_LD_PCREL20_S2		124
-#define R_LARCH_TLS_GD_PCREL20_S2		125
-#define R_LARCH_TLS_DESC_PCREL20_S2		126
-#define R_LARCH_CALL30				127
-#define R_LARCH_PCADD_HI20			128
-#define R_LARCH_PCADD_LO12			129
-#define R_LARCH_GOT_PCADD_HI20			130
-#define R_LARCH_GOT_PCADD_LO12			131
-#define R_LARCH_TLS_IE_PCADD_HI20		132
-#define R_LARCH_TLS_IE_PCADD_LO12		133
-#define R_LARCH_TLS_LD_PCADD_HI20		134
-#define R_LARCH_TLS_LD_PCADD_LO12		135
-#define R_LARCH_TLS_GD_PCADD_HI20		136
-#define R_LARCH_TLS_GD_PCADD_LO12		137
-#define R_LARCH_TLS_DESC_PCADD_HI20		138
-#define R_LARCH_TLS_DESC_PCADD_LO12		139
-
 #ifndef ELF_ARCH
 
 /* ELF register definitions */
diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 02e420c255df..4b6d3f111d7b 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -380,4 +380,134 @@
 #define R_RISCV_SET_ULEB128	60
 #define R_RISCV_SUB_ULEB128	61
 
+/* LoongArch relocation types used by the dynamic linker */
+#define R_LARCH_NONE				0
+#define R_LARCH_32				1
+#define R_LARCH_64				2
+#define R_LARCH_RELATIVE			3
+#define R_LARCH_COPY				4
+#define R_LARCH_JUMP_SLOT			5
+#define R_LARCH_TLS_DTPMOD32			6
+#define R_LARCH_TLS_DTPMOD64			7
+#define R_LARCH_TLS_DTPREL32			8
+#define R_LARCH_TLS_DTPREL64			9
+#define R_LARCH_TLS_TPREL32			10
+#define R_LARCH_TLS_TPREL64			11
+#define R_LARCH_IRELATIVE			12
+#define R_LARCH_MARK_LA				20
+#define R_LARCH_MARK_PCREL			21
+#define R_LARCH_SOP_PUSH_PCREL			22
+#define R_LARCH_SOP_PUSH_ABSOLUTE		23
+#define R_LARCH_SOP_PUSH_DUP			24
+#define R_LARCH_SOP_PUSH_GPREL			25
+#define R_LARCH_SOP_PUSH_TLS_TPREL		26
+#define R_LARCH_SOP_PUSH_TLS_GOT		27
+#define R_LARCH_SOP_PUSH_TLS_GD			28
+#define R_LARCH_SOP_PUSH_PLT_PCREL		29
+#define R_LARCH_SOP_ASSERT			30
+#define R_LARCH_SOP_NOT				31
+#define R_LARCH_SOP_SUB				32
+#define R_LARCH_SOP_SL				33
+#define R_LARCH_SOP_SR				34
+#define R_LARCH_SOP_ADD				35
+#define R_LARCH_SOP_AND				36
+#define R_LARCH_SOP_IF_ELSE			37
+#define R_LARCH_SOP_POP_32_S_10_5		38
+#define R_LARCH_SOP_POP_32_U_10_12		39
+#define R_LARCH_SOP_POP_32_S_10_12		40
+#define R_LARCH_SOP_POP_32_S_10_16		41
+#define R_LARCH_SOP_POP_32_S_10_16_S2		42
+#define R_LARCH_SOP_POP_32_S_5_20		43
+#define R_LARCH_SOP_POP_32_S_0_5_10_16_S2	44
+#define R_LARCH_SOP_POP_32_S_0_10_10_16_S2	45
+#define R_LARCH_SOP_POP_32_U			46
+#define R_LARCH_ADD8				47
+#define R_LARCH_ADD16				48
+#define R_LARCH_ADD24				49
+#define R_LARCH_ADD32				50
+#define R_LARCH_ADD64				51
+#define R_LARCH_SUB8				52
+#define R_LARCH_SUB16				53
+#define R_LARCH_SUB24				54
+#define R_LARCH_SUB32				55
+#define R_LARCH_SUB64				56
+#define R_LARCH_GNU_VTINHERIT			57
+#define R_LARCH_GNU_VTENTRY			58
+#define R_LARCH_B16				64
+#define R_LARCH_B21				65
+#define R_LARCH_B26				66
+#define R_LARCH_ABS_HI20			67
+#define R_LARCH_ABS_LO12			68
+#define R_LARCH_ABS64_LO20			69
+#define R_LARCH_ABS64_HI12			70
+#define R_LARCH_PCALA_HI20			71
+#define R_LARCH_PCALA_LO12			72
+#define R_LARCH_PCALA64_LO20			73
+#define R_LARCH_PCALA64_HI12			74
+#define R_LARCH_GOT_PC_HI20			75
+#define R_LARCH_GOT_PC_LO12			76
+#define R_LARCH_GOT64_PC_LO20			77
+#define R_LARCH_GOT64_PC_HI12			78
+#define R_LARCH_GOT_HI20			79
+#define R_LARCH_GOT_LO12			80
+#define R_LARCH_GOT64_LO20			81
+#define R_LARCH_GOT64_HI12			82
+#define R_LARCH_TLS_LE_HI20			83
+#define R_LARCH_TLS_LE_LO12			84
+#define R_LARCH_TLS_LE64_LO20			85
+#define R_LARCH_TLS_LE64_HI12			86
+#define R_LARCH_TLS_IE_PC_HI20			87
+#define R_LARCH_TLS_IE_PC_LO12			88
+#define R_LARCH_TLS_IE64_PC_LO20		89
+#define R_LARCH_TLS_IE64_PC_HI12		90
+#define R_LARCH_TLS_IE_HI20			91
+#define R_LARCH_TLS_IE_LO12			92
+#define R_LARCH_TLS_IE64_LO20			93
+#define R_LARCH_TLS_IE64_HI12			94
+#define R_LARCH_TLS_LD_PC_HI20			95
+#define R_LARCH_TLS_LD_HI20			96
+#define R_LARCH_TLS_GD_PC_HI20			97
+#define R_LARCH_TLS_GD_HI20			98
+#define R_LARCH_32_PCREL			99
+#define R_LARCH_RELAX				100
+#define R_LARCH_DELETE				101
+#define R_LARCH_ALIGN				102
+#define R_LARCH_PCREL20_S2			103
+#define R_LARCH_CFA				104
+#define R_LARCH_ADD6				105
+#define R_LARCH_SUB6				106
+#define R_LARCH_ADD_ULEB128			107
+#define R_LARCH_SUB_ULEB128			108
+#define R_LARCH_64_PCREL			109
+#define R_LARCH_CALL36				110
+#define R_LARCH_TLS_DESC_PC_HI20		111
+#define R_LARCH_TLS_DESC_PC_LO12		112
+#define R_LARCH_TLS_DESC64_PC_LO20		113
+#define R_LARCH_TLS_DESC64_PC_HI12		114
+#define R_LARCH_TLS_DESC_HI20			115
+#define R_LARCH_TLS_DESC_LO12			116
+#define R_LARCH_TLS_DESC64_LO20			117
+#define R_LARCH_TLS_DESC64_HI12			118
+#define R_LARCH_TLS_DESC_LD			119
+#define R_LARCH_TLS_DESC_CALL			120
+#define R_LARCH_TLS_LE_HI20_R			121
+#define R_LARCH_TLS_LE_ADD_R			122
+#define R_LARCH_TLS_LE_LO12_R			123
+#define R_LARCH_TLS_LD_PCREL20_S2		124
+#define R_LARCH_TLS_GD_PCREL20_S2		125
+#define R_LARCH_TLS_DESC_PCREL20_S2		126
+#define R_LARCH_CALL30				127
+#define R_LARCH_PCADD_HI20			128
+#define R_LARCH_PCADD_LO12			129
+#define R_LARCH_GOT_PCADD_HI20			130
+#define R_LARCH_GOT_PCADD_LO12			131
+#define R_LARCH_TLS_IE_PCADD_HI20		132
+#define R_LARCH_TLS_IE_PCADD_LO12		133
+#define R_LARCH_TLS_LD_PCADD_HI20		134
+#define R_LARCH_TLS_LD_PCADD_LO12		135
+#define R_LARCH_TLS_GD_PCADD_HI20		136
+#define R_LARCH_TLS_GD_PCADD_LO12		137
+#define R_LARCH_TLS_DESC_PCADD_HI20		138
+#define R_LARCH_TLS_DESC_PCADD_LO12		139
+
 #endif /* _UAPI_LINUX_ELF_R_H */

-- 
2.55.0


