Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64076C79FAF
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09D76B00A9; Tue,  8 Sep 2026 02:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B9896B00AA; Tue,  8 Sep 2026 02:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881B86B00AB; Tue,  8 Sep 2026 02:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE9F6B00A9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:34:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAE81140383
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:02 +0000 (UTC)
X-FDA: 85189629924.01.39729FF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0191520003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:34:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=srXUKKBv;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="rW7/VoVl";
	spf=pass (imf31.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849241;
	b=WRti6iFTfT8i6rdlWAGDDfLhOmcxtrSfsqS23ej9BphPOvFbWAAEsIQX8tfLFQHNbf4PSe
	5BY4x/RTZrrk9ENPcTOdx7RziurUW9sAN7nmN3LsFV8kSqH8WMHOJ5UZn2vRknr4Azc2Hf
	Ed0VeQZC951u+gDV9Rngb4np64YTxK8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=srXUKKBv;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="rW7/VoVl";
	spf=pass (imf31.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pdi6tJcXia5GQvjWLdDYxiQ6I89enT2mzL46ZqnmdMg=;
	b=z9tLM6rkYy/Z4EszUoOmbaMaEGBzIrbANvx5+C2eGfKqbaec8zz5p2vj0Mhc2OkFGfMP9f
	Rc92JtLkrj1RG72YIzhlqwAXw6/5wR8Y2TlAy4X1Lkbq7dD79KA2W44pT9JP/PBrou3Mnv
	IFaeBkF2lLu8dAjW3BNMRNtPwULHOFI=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788849236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pdi6tJcXia5GQvjWLdDYxiQ6I89enT2mzL46ZqnmdMg=;
	b=srXUKKBvBnZWl7h+1tvBv5e+AlKq5znw4KLWobhNXWNfQAuYkrwrf6qLr9sX3I376tXpaL
	0gCLK9hvRcYej1aY+vuLNUXX8k0WaaNjh/gf2Si2JH/haTjazZxULX0a5f7Yw140D5KgYT
	mY6i1JDe2y9ffdmhX61Pp10Gxy+SfEXQxM2EnqvziywLYsrgXQI8aTTmQXJNqF3Wlg/vEp
	0gaYbr4thtj8q00nsmFu9BsDc1syHcFh5c6rh+d3Wwq5S09FzqW3vh3uH+fdVp1FSM314K
	eg0gs4ury6AuRJrLxdmHGTOamuoIr50Pr/4C3keU04Rznfn+4zwCC+V/Fh4gkA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788849236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pdi6tJcXia5GQvjWLdDYxiQ6I89enT2mzL46ZqnmdMg=;
	b=rW7/VoVlTLF38Sp6NbEw24XpKKO0l53Bu8vFJSSAarrgsh5+3oOcPR3GCmN8eCmuxD/xDP
	pyuyJDO6nu5wCADA==
Date: Tue, 08 Sep 2026 08:33:50 +0200
Subject: [PATCH v5 16/24] powerpc/elf: Add 32-bit REL16 relocation
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-vdso-absolute-reloc-v5-16-3a93791af1cf@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788849226; l=1737;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=gDavw4WAqw6o13GhA3u/II77o40pPBvpHsDECXNhldY=;
 b=at10aJs/4BEOnHQNfCkeHcofnKffueuw1V5jX3gearAcRNXGLUowN4VA80tWswO8yBV0CJAoU
 1lBC/PMHi3vDICsSQ0DEs5CGMsAX8t5/pR4/5NVDW4dQxNWMl/dsaZv
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0191520003
X-Stat-Signature: e3ab1f8y9mgnq7mfjn5r7zth85gbob1c
X-Rspam-User: 
X-HE-Tag: 1788849240-832340
X-HE-Meta: U2FsdGVkX1+Tx+w65Cc1ZrM/q0In3aygeW7wDEN49/pkQ5+g5NMxZ68QnWBDRoMjlgiGan/RoStvPZRfEKhN3V49VoPrikk4Cj2c3sP96GdUhI3u001o63edmpqdpVbcQ40IMxIDuljVpRJ+QATz13eECLeOVqILViqYzOr7hBVFBF2F0FocbseeV2NNPvk3sZJlW3CFjO2FmFGc+3BDhp8Gk2hIUSenhG7ciOJfIrGAJ/ZjrV1StG4SbColB/tK/B780CPJM4tPWJOTS6DxX0nHO1IoqRyinwobmGZQUPyo+/Qy4E4oNN3MunaJU/MpYGqOovAiWXiQsyk5uLbFk6VNZ3SGpb4o5gks+jKZp0lgcFJK4c0CxG5G6yBdcn1z8EZxD3We/Zb3gzHaSWA21PvgC0z+frk9BwhL2AiOo0UM4h6U2ElU3ejSw5WAoBdJ8je8oHLyx+ZB/nMGJzfhLp+ICM+SKgGdBCJ7LKZ7gUK69nFR/MJK59P+YXDtX+yv6ldvcBTRHNzCChfFG6c9qvHbEqsfwnwHR7IUjv5ETnc3QpfAJdgvZG6mLWZaYaQZF9zmmZtjiCVOwAnWtgWxcN3wqmZwO6F9WPaJlJy6suJfFCJCRg2FHo5as7dwS43VNlzm/bVg8RxvXxviRfJO669IUtHStoxAvUnXO8t5UwU8dm4xvuBlGNyvvJq6Di56eQQmK9UBPRF6rzP6cl3dnNWg2aPu6LwJWJUI5IBZ2oD/XowfazqA+df3mtjecr4e0lRF+EysosfIr5IGm09KXd8eVto7pY+zhk5TUqeQbib175iTqelxJmZFppGBRot5jawnBjna8gzYJFzyrkareleH0hMeSPJpwC7i0rm0aYnq2pOcDVNx2mLZwY62AWqqKeEccQhhT/rjyG5qaNRvb1W1JokKhqmpOUOkQgGXEujnIlIh3c7N9oeNwFJxY/FfVjSX7jfqXZf1XXuohUi
 HlQIa3Ko
 is5RgKpWgmUZHO/Rmln+O20Su+o9ltAYWMqSMDI1dT5WALKlPeWJK+QxGcGcHjGnf7d8GOKeZ1FEE5kJ339UDK/c+9BTdFzS1ZptvyjpwuHWj1Ig0gdhQTWx9UqBQN6GYPPq9IZ0DjS++DTd3hC+h3QvgN/kYTObt1yVATcb7HEOsY5zSIxuzo45mpXd0CLSK4oORjsXhcpvww61Cs7Ly+12qE7EFZ6ltTC0PgbI2nshdHR61GRTex6/uh8FjyMnsmHH7lUo11Vp27jGT34Bur1oIWWuciVToOwsWq96AKpnUPOHD3WEM0g8Jo/Rbkm4hJ1xZBkl+DGMYhLqsDNu6UjtMTmlv4KNGKBXqu9hntOIsV8ts6+Zlcarpf/+2e8ahkMUiP/9rjJ4G+GX6en9uUi8q6duYVRhEGAHsVtEznwQWdx169AP9NBoMLe7iVfFgXlxQK+PHbiymGsU/gPeEAou5x9wyKoQDfiZWlmjOJNp7QFwkkU8kRVQS0l/Rs6vrvzvD23Y8/uBNTm57zOdBymCLai7SOKSGoRglxZbOpBdQAEo=
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
index 72fc9045a5d4..170888422400 100644
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
index 72fc9045a5d4..170888422400 100644
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
2.55.0


