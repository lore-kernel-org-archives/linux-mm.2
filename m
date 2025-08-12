Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD09CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B928E00DE; Tue, 12 Aug 2025 01:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBA78E00BE; Tue, 12 Aug 2025 01:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB56A8E00DE; Tue, 12 Aug 2025 01:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B17068E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:45:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 879241A01B6
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:45:00 +0000 (UTC)
X-FDA: 83767016760.21.7539F33
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id A7D6B80008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=gVUd2BKN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=E3zfUlZM;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977499; a=rsa-sha256;
	cv=none;
	b=ACLFn0S10I+be+14erW1b6zn/zz5YLsjU77SDd5IZY4MFml97D9cxeIzWucSvq1EaxI7pM
	zNdMEDBCnngkfOz80wjYal2o7i3RLmUrYcPaVwXc6LBIAy0nOPf+OunBesNUPi5zSmM6G2
	2FXpJYIUa+eqGczPjvyu33QIu6wMY6s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=gVUd2BKN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=E3zfUlZM;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ohsn0uRwU+hqw8smnbWosllb5/RpGYnB9VEAvO1A/o=;
	b=c9Wn9I6sB4AFOEA8AcjcfM6G5zgqm9fNPfMp3pkNpRi8KfSbpRD7nPoNp+W4AWNeHuJJa4
	eZDIkvJX6iWtHbYVjvw8F66pAVPzAXriLumwfs0jwc8ModH9X36bTRahIGJuPRq9+7qTBi
	JjVQdVNy5h9EK6pmyN3XJ1xoMNG6+i4=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Ohsn0uRwU+hqw8smnbWosllb5/RpGYnB9VEAvO1A/o=;
	b=gVUd2BKNRu49lqg4NSeZ4pKy2oD1HLdzTFOjP5wa3OkUArCPejQi3q6nUUr2hwWVlPH2Kd
	CpxufrleSj5IZe8RVpKM1ltFMzRJO9obwhqsMGuapaXgAqGhXqHAW1SITBjzjuIFxYogme
	VHW9rhxA7fc8nsd57iZTz0NzWxS4qCvj0HR7XdalckB95CeAtDcPREEN4EOpD8wSUEK1Fj
	JpEDuofzGC0RATmSZcEZf8c/4R+6SxzYN4hGrvSuM267wDyFyN3n0HVqzoxPKY02BuyYgJ
	Z9VulQJw/Kd9S+FCzxMpZgWlnADluI2ZtXqh+SyfPfSKvhoitMn+YWd5L9OT6A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Ohsn0uRwU+hqw8smnbWosllb5/RpGYnB9VEAvO1A/o=;
	b=E3zfUlZMz5EWlnuWD04WRwJZzaIYqsb9Hq174OOh7rbwH0by1UeqdRfVLVDKyXeX8pZQ9r
	AHYbNMgU+lq97wCQ==
Date: Tue, 12 Aug 2025 07:44:37 +0200
Subject: [PATCH v4 24/24] vdso/vdsocheck: Drop the transitional kconfig
 option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-24-61a8b615e5ec@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=1638;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=XgLT+HRfIExEaxGQakA0kG9YYMgwqfszT+N1NJLYmAY=;
 b=1I1jQfDAIUdxhhr5poZTNsBtXG7kI9OeSFZyV1uG5GiskTP3f4x0XtJf5y22KDovg2SDqYoC/
 1/LS9SuRW0lC44pibDwoRDG1rIxAT00dk7cwwtQfK+pJ8Esyu7dhqf4
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: hozfixqq1zs1cw1dcuduxy953nyrbc8c
X-Rspam-User: 
X-Rspamd-Queue-Id: A7D6B80008
X-Rspamd-Server: rspam02
X-HE-Tag: 1754977498-787807
X-HE-Meta: U2FsdGVkX1/hQ2CwRodDyGhtxHiInHRCLoLQVQnsWMllY2Gzht1r+Z7Xwp1G8ibbexbiBsZj0Vu4Zpbp1Cy5mYfq1K6o2yjfPH5/IovkSYTxnxEE9McU1LmDtal/9b3v9xxp59z98ewKbfFGnl+YaC02lzMQPa/05oiojoU2iNscSMQ6WL0zNFNFeoeUtgHifZ4NxwTY59aKJCxdmcxdk+e+ISFbzklWN4P8Liv+TWypwZsz5mi4U97KYDHqiXAaR3TRPezH81Ma4gNqLcL1EiudqkMfbb+h4U5Gv9sSyp7smTRiSLcXM4T2ei9NlKNmyQmZoHhFyYExbV839RuGjVpK/JXeRU1k6wnmlCTuNYRLDh6WkBRvebL0+Zb3l2p1x9r07/eOiUJpJIQu4BdGXYDcJiVJBQQDX6wZZZLGOBuD6VEU+4cY3S408fDsx6hOwGcza4SsqVjBOxFFIX+juL2SYPX0X6hvs94xgA8b5+/hnNPFSjcydgWwvE9i5+fcHprb8Hl17lMNB/9rG22hxsDZV+2yvRDBhXFlA1I7etmplZ//SvvZ3eOR7RG3v4diO8oEah1pZ34yPW5HYwIqkw06274J7XdGvj7fK7sYRvTRjZgUmLKnJyMXufFK3nDynjbfJ466hBr8Ge6L5YBRGrnM4pP2brVYaGE3XKSs/N/HSJxY1hFS7Gj9fQYyGw8EMAvNh5R3hiQPVwP0qTkJ6yBw1FRwjf3vbM2B/fI7VB4dwkomHBdNJTTL2vsHcVVi8hGNMc8cwkYAskybN8gOVgdOFMz4/i2PN+ypcby2f1uec2UKudQEoILzDYIPgAqrBoQm2UwMaEklT/cpcPXoYr8X0y7z/q3YAKcEQcpphQrhLXr2DLZMYrxr9oWeYJuPLSdRsU6OdUKy+x9HsUOff9i/NwbNSXiFVwD4b/zSZSOZN3qnmuhi4+FG8Z8s2lOk+LbDsikxi/91QuhzeAS
 8g5wGeOB
 lok3+Bp/KDPdDStx/lsjbhAX5VCe8lTLLLTrCkiJXVvzREsUjsjHFjwr+RnWyap+um/V1Ao6MwVT9NHftI/Aulb5j2CTdUZ295Zkw/azH4iC40Z6yp8sc2ji7CB02+1El+duS0FNO4R6iM7G+Q69BjF+LXimrU12eAVfxtmNK7a8PuPwxKppiViZzsRS37vgusiudXOGt/3kITFcqKjeEPhAvsxUxzDctyXERCai1qUMZiEBiqAfBIzIp2hmT8CiN31+v4gNen2+emcnv1R7Lhxji8aa/MOdqZw1xIVb9pdjbGFQYarvJTbPCKXxRqzQvQ2sG/I2mJaJfqCAbesJ82hFHJ/6ziYmFth3pEpfZ2PG8emNGifPLpaWYkRVebvrd1/1ikz8lXJQDwm2GNCT1PcnRWDYYL4u/MzYOetDUXTkncf2RxtEpahBWc5x2iZmleWm7w+gTXz3NjSkMCmdD37IdDf6rpXnW0ZfStQ2+vlvbD4jcXvMNlgRnGBlPTmX/YWtrSKWlSbhaBpL0VrmnVDptoSNMggULgw0jAiU2d6mC/ZL07Pj/S8og1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All users of the generic vDSO are now using the vdsocheck tool.

Remove the now unnecessary kconfig option.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 lib/vdso/Kconfig          | 14 --------------
 lib/vdso/Makefile.include |  2 +-
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index 567ac937a9c3084fd5669e1b890b667af8a2f12d..45df764b49ad62479e6456e00c053e46131936a3 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -48,17 +48,3 @@ config GENERIC_VDSO_DATA_STORE
 	bool
 	help
 	  Selected by architectures that use the generic vDSO data store.
-
-config HAVE_VDSOCHECK
-	bool
-	default y if X86
-	default y if ARM
-	default y if ARM64
-	default y if PPC
-	default y if RISCV
-	default y if LOONGARCH
-	default y if S390
-	default y if MIPS
-	help
-	  Selected for architectures that are supported by the 'vdsocheck' progam.
-	  Only transitional.
diff --git a/lib/vdso/Makefile.include b/lib/vdso/Makefile.include
index 759fe41b48f658c399f54aa7d54a3dfeb07e5c9c..a5621b1d6ab51fde3fdab6e72309d51943939860 100644
--- a/lib/vdso/Makefile.include
+++ b/lib/vdso/Makefile.include
@@ -6,7 +6,7 @@ GENERIC_VDSO_DIR := $(dir $(GENERIC_VDSO_MK_PATH))
 c-gettimeofday-$(CONFIG_GENERIC_GETTIMEOFDAY) := $(addprefix $(GENERIC_VDSO_DIR), gettimeofday.c)
 c-getrandom-$(CONFIG_VDSO_GETRANDOM) := $(addprefix $(GENERIC_VDSO_DIR), getrandom.c)
 
-ifeq ($(CONFIG_RUST_IS_AVAILABLE)$(CONFIG_HAVE_VDSOCHECK),yy)
+ifdef CONFIG_RUST_IS_AVAILABLE
 vdsocheck := lib/vdso/check/vdsocheck
 
 $(vdsocheck): FORCE

-- 
2.50.1


