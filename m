Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DB1C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365E48E00D5; Tue, 12 Aug 2025 01:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9068E00BE; Tue, 12 Aug 2025 01:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191148E00D5; Tue, 12 Aug 2025 01:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED5318E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD049B6B6D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:49 +0000 (UTC)
X-FDA: 83767016298.26.4D1C6A7
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1416D40008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=SPOdyyK6;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=G8Q+ixFA;
	spf=pass (imf07.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ni03bz74C9TDQf0xtR9HdEFVHcT90zf3s/r1yADBwxo=;
	b=M7na6yBXCQEp0YZcCtfxiktlGSEKdb0E09XC5rHkocbauGlYkduowidabOS7/+/h0eCHNI
	Foob+u2G6NmdDn5AFQIJvNNi7rV5x9pY7udsUHLEa/Vru4eh1t93AL/XezVXn8PA/xX+dS
	10Vzl7/U+xdm7/cg/zsr5xdebjOBoQg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=SPOdyyK6;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=G8Q+ixFA;
	spf=pass (imf07.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977488; a=rsa-sha256;
	cv=none;
	b=AkutowGNMzbrffLRKlWxtl7Fo82tl202I/jMk1VEybOET3r6X0Ng+U0dfXh+9vvovrspBE
	NlcAFwFDZWF8COJQYkDTaqpvRTWOvKkEz+LJozfo+hChcDjO5dU4FPvJML+pwOacQnZcj9
	1a/Q+vv4/Wc7RC9SIBHeav/LpSM3f20=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ni03bz74C9TDQf0xtR9HdEFVHcT90zf3s/r1yADBwxo=;
	b=SPOdyyK6sCUtkj6kxjiocTJJSEG7dMI/35DqLKjSrblI5G1I3CyLRTOU0LfTHDu2JQsxDj
	Dn/jh2j77Of16cGzaV4eefriQ+ADhNYDrnKqgGv5HP6LP8Jj0Yq6B+GTYhlGWdGV/jeCNn
	mChLIch4f7Gt0mUAyBg7i3cMLVb5B3npJ47FGQpkuXq4wraN8yU4e5d5OiTfiARGEt3ujO
	rpuqTNdsRVE9m+8DyoboNXYkzVlSxQ7GC9XLTUGVj7Vki1TG78RIYaiJMK8Y+oI+lds+EP
	JvwYSVkZ8fPvF1iauUDwZWuIMZtURfosroN8t78/t6nMmnrxJZEhAzgaCvJYpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ni03bz74C9TDQf0xtR9HdEFVHcT90zf3s/r1yADBwxo=;
	b=G8Q+ixFA4w8D6kq4xigxFt3Cczt1Y9MbywRc7XOy0tz4miHQTBoNTUawPiaFBeSqGu+zKC
	/2FQ+7R2EdhFKXBA==
Date: Tue, 12 Aug 2025 07:44:28 +0200
Subject: [PATCH v4 15/24] powerpc/elf: Add 32-bit REL16 relocation
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-15-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=1849;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=cTNg9TGsRxWfNuFVqiM2JjMT3BPMQJuifoiqKo4ezxg=;
 b=fTu+sca8EPLbAnEFtmDEkVGkzUGCf6ruToGNTg0scH5R7xB2jsm5rnvfxHsx+1Bkd74GG38mD
 NfkpwBlsVukCHjftZxM7DWULKfpV77bu2ffXVoITzAdYLtHpJEl0ViT
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: 1416D40008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: e98dqto3iuci9xr5ot7fce4pwsnnrzwn
X-HE-Tag: 1754977487-396451
X-HE-Meta: U2FsdGVkX19XTljhVYJDVfLnwd8jAjppjfHaghqdj/2/xx99BFbx8C1jrhqG99jXIq6DMkN9xTxGQTbiwrBNSlMZZpymyIN77FSSSJlLZqChMiW4XqGRffGWXeMyUM0cl1swm0PRZGG7zP8CpAP9i4DJV6UyyBiPuCWHt2Hd/BnAWFbl+YfSF/oE1zonSerJ2FYYKvz59YOaj0LdJO3YitDy2zDLQZunpNhNg+8+run6UFeJPo2iT7fn0Gw832Tmik+bjxwSLgTHUCNkIWqgwF0FzwCnRq9WeNU6udPKK57rmQvJAspmD9JaSsPeMHbRI1N6MqNL5YJqVmzvwYl4bURsC7jzi/e3XVRptvDlCFGS1BzYCeySQE4Oi5Q46XODFQ2cremjOpR1QBGuITUVgLaJ+ZS4fRSLvLgiQQm69OQ58FbpBiuyMlIAFYLD1puhYUrSHtecHGz6eoGY88HaNr4DvQSU2Xn1/Fg73N5GhCc9kYIMabiBhn3td6QYJxemNIcGrIZxIf2jS3kgdDh/WCCw7pc5l6tFP9SbQPQjoBah5lVhG72YrNa8xUfD0pPVO9L5HFXin9zrVmlpAkP/K4PysTu0dkDN+OpULkDFrhSSEfBHVT1MPspgRDaPUFBQCg2DXJTxFwqto3NlSE3rDk723FgtrDLr/zNfP89r/fLV5V94NyU0IXB+wGE8aWApkHuAJqbdBOq+GMvoTT8RhcD39ETNIC4DH42OKvcg61jpKI6bODv7gXSCOKCgCq6Nhq6R/bE3eaufT22p3gMrc5DYHLqlMBnEjbVWrnSKzzJQrRIbqoVM5urugn9ttZJaK+eyZ0nqjrtZ/Fau/lA1Pa7r8ILd1uTU4y4Cu2e+qSEBG21z30PXM7k74axZq+gkk7WfScL3dpLTeoz0j132yLv9AjkKAm5Ad5R2rPS5dpE4ScTeHZ/5qL2VyCPuL10M4WZZGIvARwPEV3JKpTz
 MsghRb6T
 uM5keDmQ+EymPLGMI7Je6TGENRZ2Zrr/DYnT51RoFJdvQWu18Xqu+9tbcCBQUWereoy28cCY6mk99CVvuDR2Z4G5wFAn6CKto+Or+fwScv/49Cm9AQfxqLWBDy6ezY8dwC3O0eg3dM+PUOXMNQHO2mo4ZddrXQZAF61kljf7ku3kxEOs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are used by userspace and are necessary for the vdsocheck tool.
They share the numbers with their 64-bit variants.

Also update the copy in tools/ so they can be used by vdsocheck.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/uapi/linux/elf-r.h       | 7 ++++++-
 tools/include/uapi/linux/elf-r.h | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/elf-r.h b/include/uapi/linux/elf-r.h
index 78085d26f4ab27a003fde65c8e981f575f411758..e750989e44e8f517d7dacf9d3a338af7a136e40f 100644
--- a/include/uapi/linux/elf-r.h
+++ b/include/uapi/linux/elf-r.h
@@ -182,8 +182,13 @@
 #define R_PPC_GOT_DTPREL16_HI	93 /* half16*	(sym+add)@got@dtprel@h */
 #define R_PPC_GOT_DTPREL16_HA	94 /* half16*	(sym+add)@got@dtprel@ha */
 
+#define R_PPC_REL16		249
+#define R_PPC_REL16_LO		250
+#define R_PPC_REL16_HI		251
+#define R_PPC_REL16_HA		252
+
 /* keep this the last entry. */
-#define R_PPC_NUM		95
+#define R_PPC_NUM		253
 
 /* PowerPC64 relocations defined by the ABIs */
 #define R_PPC64_NONE    R_PPC_NONE
diff --git a/tools/include/uapi/linux/elf-r.h b/tools/include/uapi/linux/elf-r.h
index 78085d26f4ab27a003fde65c8e981f575f411758..e750989e44e8f517d7dacf9d3a338af7a136e40f 100644
--- a/tools/include/uapi/linux/elf-r.h
+++ b/tools/include/uapi/linux/elf-r.h
@@ -182,8 +182,13 @@
 #define R_PPC_GOT_DTPREL16_HI	93 /* half16*	(sym+add)@got@dtprel@h */
 #define R_PPC_GOT_DTPREL16_HA	94 /* half16*	(sym+add)@got@dtprel@ha */
 
+#define R_PPC_REL16		249
+#define R_PPC_REL16_LO		250
+#define R_PPC_REL16_HI		251
+#define R_PPC_REL16_HA		252
+
 /* keep this the last entry. */
-#define R_PPC_NUM		95
+#define R_PPC_NUM		253
 
 /* PowerPC64 relocations defined by the ABIs */
 #define R_PPC64_NONE    R_PPC_NONE

-- 
2.50.1


