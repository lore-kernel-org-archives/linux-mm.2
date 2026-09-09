Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B38EEC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5766B009E; Wed,  9 Sep 2026 10:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9666D6B009F; Wed,  9 Sep 2026 10:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807796B00A0; Wed,  9 Sep 2026 10:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8416B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:50:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3A14C0237
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:50:50 +0000 (UTC)
X-FDA: 85194510660.02.4251CB5
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8C83E180002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:50:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b="bEJ/8Uz5";
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFpW3j2yfHvwL1AGJpeP1LDFFiQmnofCJ0pBK/QfQMA=;
	b=bh3KAkDMj2ocM8KcD9eh6E9zTwh7reHbhd+39Uf+FRzQsWgdNr8g8Lt2VAty8nZTduCX6r
	oR0+otdjicFp0udIRBfE4aKaB9ho3PMe95I3usb/8d/Z3JWiqMwFQsexUVtbwpB8QcdgTd
	kaG5EGS5LSnihJiINit7vlkpKvTLfTY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788965449;
	b=o/n6vpN1ljiAuvyI0Yh9bPIKybV0Bxv6Jnxlia6JJdWJ6/wSRbwBrNavVP0qR+hSiG0Ivr
	qJBcFF3/FcUM9AORcfwbWfR45tAuvL1VkGaJZXy8gyStDHtKRBE5IcVahNOsFOvJ1663TJ
	TTRIOdXbHQyhme3RvQDbhUOelWnvYiY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b="bEJ/8Uz5";
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A382C40E02C2;
	Wed,  9 Sep 2026 14:50:44 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 9Q1sj3DJqz9o; Wed,  9 Sep 2026 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788965436; bh=mhGQ4FEjJypHCScKuxG2hVB2Cr7EilB+iYsfNtWHQqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bEJ/8Uz5UTuL3M3aJaZ+2GA6fHLcktGtyqNCvODV6vja9c5ofeLAw9r5500Ldr25H
	 Qb1xaJZtybSTYQEAFER7kNXSbt0/1P3vev75HfTrRPKQqXMq8vzzF9d2raqW7yK4Jp
	 bgsBr5p7kVDTB9kpcsKXnfA2oZFXqMgcW2v064dS00SqLJQ4fh+FTTqMfbeE6ylt6W
	 xeBJaGn3HYw68e4HreCBSdk1xrJVqweEaR0hTlsp9ViWUcauqO5nf8umq0Nui9YTkV
	 GKJQEUzDD6o8zodTcnqrpM4CPq6NuYAB1O13ttqJjGS36Z2uCbR6KyqXxKlafFr7b1
	 7ctU5lA269NQ8wM09FSxrsRFiMlY4SvpNIR6FjrwsJi2GrkgzDphwoLgFgtc6VBlX6
	 sZEWd8ZjXFr7d4kNRkfTSiYGwhdgPhGoqgJg8tB+bIw14Mw3cuHC0Q9xIa6xFUY5jp
	 VWgJEsz5szwqtlotZDwBq7NU64xcPZ4oXFJ2qKu7h8QPHqSvB8mLBIMN7DQzBr9yKh
	 3B1hlQLHULtH82PyIzJVS+TDy4H+TQutkiZUSuErREjAkJcHO33xV54eAiErgaiPkg
	 dq6isTjw+AUWrupRkPovwFJvsVt6Naubw0PkaGCiRjPqR2r5eGwo9f4RLg22qsPqFP
	 0lcuEVktIzws0Z/idTv4tvxk=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D243A40E01E1;
	Wed,  9 Sep 2026 14:49:33 +0000 (UTC)
Date: Wed, 9 Sep 2026 07:49:30 -0700
From: Borislav Petkov <bp@alien8.de>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Nicolas Schier <nsc@kernel.org>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-mm@kvack.org,
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mips@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org,
	Jan Stancek <jstancek@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v5 02/24] x86/elf, um/x86/elf: Move relocation constants
 to UAPI
Message-ID: <20260909144930.GAaqFx-mjH3-u6jLjw@fat_crate.local>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
 <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
 <20260908161740-0d79e592-87a6-43c5-9174-84ce1904e639@linutronix.de>
 <20260908151238.GBaqAl5iKb64meuPJl@fat_crate.local>
 <20260909075156-06ff671c-ab7b-47d8-aaa3-588b570888bc@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260909075156-06ff671c-ab7b-47d8-aaa3-588b570888bc@linutronix.de>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: x79z88mia1woks7tnodnjzkdooanfr3o
X-Rspamd-Queue-Id: 8C83E180002
X-HE-Tag: 1788965448-890115
X-HE-Meta: U2FsdGVkX1+tDmqnRWtXY4gJyo5u5JSFIPwd7h8ymDgtxugyBIRgtzpieHc9MGD4FgyVyOukRDm0GYcOwPqixmp+nMtBa+hPAZWViWvnG/g8tumntTG0uJh+/HxMDFFHRu07MTaJad9oZ8HEf92mjDy/OD6w8Ly9+V+yH8eluWopGFeIvhU6YtrYOUwfHZgCzp6QWul8w5ifYw5nn6bMKSYtda3O6Ub3XgcwS9ib0TZEB0gev6sGp6i08/D09R3S3FU9SPlFYUu5/DCWVP3R23ovBEqwJo27G5MLwl4p+Jtyeur4mAQRdndBnOv2K/GWkWf4QxvzDqCqAwz/PIBBwr4XTa58ATMAuk/lSQwpaXAvzHjhAV9V4KqcHlmvaPPqhlwm9juu2GS00q6xOAyD7oNWRZRGNJZOPDf6+OQMxUV42Pddaj1mCgQUj9EKHb6AJnupfsmmYJ+NzQ/neQFlWLPE4/Sr1Aac418sRsEJ1sq0Rm00uj6f8Hyg5JzCaXrSJJJe48nZdPFCRkjnwOoEiERfmCTzmS4yc9j0nV7/5CCIOR8SU7+8WnnPnGUwoEWwwNJA10VjMruvPNFz85UHKWSkgg9dzdG3Zc/5j1yHl46r7Ua4aIaC19ysuR0T5Fn9RXL7ItPdWen4JK9L9Ig1ysVcbmX/I+ljG9AEhnYcSVyLL2gr7uIjYVRodQ76BAAJ5l+cdpXZl3EaZm4bsmgQBpyCN7ucnsk+JWbWLT5Cwf+uL/y2K378jRF89mnBVNJW2239JnnAtOXNVxVPU3ySY5Sbf5eHrBJnW078KGzaQhRNHf40b9NA4oGXDoUWcGGzk9VsKlhK3czHbxOG2/FbkM1v6pSJGR4JT4L9VqytJaa+hv6NU6WKxWoN9kQ87SGdtl86NQtg5wCjPOmkl4YR/QQUFCvcmxjqfbhBS51n4m2g8y2j/jPhSbxMtWIvaxU2KNvbIr4SHZpabozVmyO
 jegxg/6A
 XnwXLVBpYBcpf3i+WHdcgVweW/sselK5Wiz1HlGk7E2fxmw85XKoiA/bvqR0+/kbpXW/NkASaOyvKxCd9rEqVSw3rVzc577pbw0pKqCZ5ywEDQxP+F8gp4XQ4uALKY/DeXuCCv1gpTyij/4eEwfqNvJcEqXu0ZF9jeOcGI2KYh5u/QKIxvLoTPi2WgK7G3BChg3sIQZ5FMCcPkXrJlDBALj5G19CFuTh3mmxd1Bu/OPMAOe4OYOt7xlMvAt2gvnluaU5gLDokyJx9YRBaNHADq86Jg16vrximVPa625cMjObnRdtPq4btfNTv29S63Qh85MDKWjfYCVgQXOpVAbUraWkcPgrJ92uNOvFMnZ58EC+14J1YiyYxwg7x1Zg3x29UL1W95KC6/ncXwAYIesjTY5ZbOeOSx9uhI0H62fqCtoWuMxfAU7T2CIR2t7NY0d5jU/g9lzYGWsaW3hbtcviv95Dekg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 07:59:51AM +0200, Thomas Wei=C3=9Fschuh wrote:
> These names and numbers are defined by the architectures' ELF specifica=
tions.
> They are already cast in stone. For example see Table 4.9 of [0].
> Changing them would break compilers, linkers, loaders and more or less =
every
> existing ELF binary.

So?

Your goal is to provide them to tools/. You want to provide them to
*everything*. See the discrepance here?

> That is the documentation for the tools UAPI headers.

Did you even read that file?

"Why we want a copy of kernel headers in tools?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

There used to be no copies, with tools/ code using kernel headers
directly. From time to time tools/perf/ broke due to legitimate kernel
hacking. At some point Linus complained about such direct usage. Then we
adopted the current model.

The way these headers are used in perf are not restricted to just
including them to compile something.
..."

Just read the damn thing before you reply.

> Also we already have other, closely related, ELF constants in the UAPI,
> see {,tools/}include/uapi/linux/elf{,-em}.h.

Srsly?!?

You moved them there:

commit 626fd35278295fbb21f2da331cd8028e9738d965
Author: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
Date:   Wed Feb 26 12:44:46 2025 +0100

    tools/include: Add uapi/linux/elf.h
   =20
    It will be used by the vDSO selftests.


Looking at the rest, it looks like some elf bits got exported, you added =
some
more and that ship has sailed. I still think us providing headers is
completely unnecessary and it will come to cause conflicts eventually but=
 hey,
not my problem.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

