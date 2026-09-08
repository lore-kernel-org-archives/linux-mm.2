Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2856BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A73C6B008C; Tue,  8 Sep 2026 10:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27ED26B0099; Tue,  8 Sep 2026 10:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16D3E6B009B; Tue,  8 Sep 2026 10:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1E736B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:26:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8429EA071F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:26:10 +0000 (UTC)
X-FDA: 85190819700.24.5CCF046
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id BAED510000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:26:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ibCJ1vTa;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=dujpHxA7;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788877568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bG7xzyOLgkq/hT1vQoL2+37rRIngeN99Zi6O3p/t1Q=;
	b=U6+nf0lr3R8vwwW2L/CkJeUOxgr02qIu+uSMbW/R95i0krpxTCsXMt4/IY6gkBYmRxouzJ
	JtqhyTq1v+7vjxDh74xiyfgp8unPWVkK8K5oFBu22/3Q2WiSElFmJXt8JjyPCAz9RxokQJ
	fTr1GXCeQ4JJba66TnyGNqPVmjiqxuM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ibCJ1vTa;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=dujpHxA7;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788877568;
	b=YiRw8dql6Pl+c8JGBn5DPOn6bbifdGVh1hGnbXgOV5LvzQ+0cO4Z0WFBIybXISA/zSYAB/
	rFvAzSHt3zP05s2zk2OjksGK2bkTfLhn6cvtNY7J6FixyIpUv/rCawFVDcTkIJa1JHmLCo
	GEnWNp5z1ILFloq+McA35i1rca8qdkI=
Date: Tue, 8 Sep 2026 16:26:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788877566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3bG7xzyOLgkq/hT1vQoL2+37rRIngeN99Zi6O3p/t1Q=;
	b=ibCJ1vTaf2PfeTeGGS4CPdeCQlmt6p7aLY7mIyests6CYT2a6E4Mjbx9HP5VcqSFIGIDN5
	lQzNq4LeidtkfT+EysNyxDj3JNRd+SkiSObbBLZntgveQTRfZuO3v/L3jsJBVUb2BH8YCM
	7vKdLixe7hXeDeAfmTR73MLoheT6qddEqn0zSpdo08XfzCFSXasPoLv5PXY5oZ4uUtuuhQ
	ue9dInv7mMssJZ5SEhI8zG40m/o1XMobx0JA0bqLkrd6i/I6QO8W9g5ozGh5HmdlKJSK+H
	nBg3aR8ypjomfwqNmYevI/XWRU18YkOzSNQOVFvzM7BNe1wvopfv0uHl4KPu0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788877566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3bG7xzyOLgkq/hT1vQoL2+37rRIngeN99Zi6O3p/t1Q=;
	b=dujpHxA7PKpeJCyeZiOagFVHrYS6MiqrupOYGFJ0EP4mlmR+jdnMRKg1XsL53yLYA37pen
	ASTs5tXfWZYBIDDw==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christophe Leroy <chleroy@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Nicolas Schier <nsc@kernel.org>, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
	linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Jan Stancek <jstancek@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v5 02/24] x86/elf, um/x86/elf: Move relocation constants
 to UAPI
Message-ID: <20260908161740-0d79e592-87a6-43c5-9174-84ce1904e639@linutronix.de>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
 <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BAED510000D
X-Stat-Signature: 7bqnp59czkq48dsynfje6k16yeh9onjx
X-Rspam-User: 
X-HE-Tag: 1788877568-764564
X-HE-Meta: U2FsdGVkX18iI3e16wnP75TMLsy8aphFxAyXhB9xH3Kpl4nLoDdE8Eu87rmGYYXwMIDjP9k7YWlDm0tUYuaGvx9l1aH/f/XQaZxYvaJ8/LlUs1qEVDSl1WAyjS2tTiQIV9L+2yaghy+aoFwb3ZWPaKqvyahNCi0a/pQdd0PsVlC5wtO+ec3X4YpzDOU2Zg2pOMGiuKAdDYpOq6j3bN8CPSFJWTDylVcrTgb3GUakAaA7WRfl3AwHchbLrw1Q0CLrizKXNCWgRXGgQYwGdbaZkF+HvzPI8z/tQ/KH3yzt+JH6N73YluaFSrHqY4j5wO2+pf1M1rTtjrRENLPSAfEl20BMj+AVB6OvWCCMRA+yxpA9NzhnRB3Fuo56CdcH7QXNc6NpwfvZUjSUdl5pvEC+b6cJK1+DacWAcGj21Nkb7fk+tz5f1KE7OVYoxwYqsRpAqbsyxK8DFQ61hHPuLuLogUC+GrStPeB4SXoqwC6drDSwf3eLOqhiITov7MU2jsDJwPlsH8spGNax1N/pXhkdhYA4XKjQYdV0oEoku0sgFc1Ebd0l0sJSNkTGwgK0Gp3oKr6cU/GpPcIAGmSs6+3TPJAsoo+IYx9vEQXeOBx2CNC5Ew4l+cHAaW65C0LPsZ4VKH6wkD8lMAb9CsHezYVRsSBUD4uvlpch5HJn1JstUtuO4ms3AYXdh1WzWeg57UT5bAUvpkapcFw4pBOld5YCM2A3Pm2k19r2mb2qFmJg+AdsZjL9mRXAombfabi1aYPHBgPWI2qYgqG7IVKNyLJBFfwIj/bk0edq15P/B5381wOtbPG+byGj64sJuxlJOJWb+7D5ZY/PfCiIlFfYwsUz3ZPEZTGTbByf4r/tk09/BUbgIhr1frhAyq7cQi/B4E5oT7xOVRGX/BILyyX0oDBuSOwAQtp7gFYyBXDcI+KbPAfQLl3xVO3qxUIedf6bTPbARJkYsgvFNI5f6eQw42J
 e0P7erCU
 xf/4d1uckBYRDMQ0Wc7sLYy+/eojzjmrXNuozdKpdi9/2oEHaVkb1fXD0DxEJ4DzmNxfPFrtb3LEm9ed1bNvBdjweDwj8u6dFudT2roL8cyvAYJ9ExR7Dza8MHj6Yr96OWSEOx+D3KsVtqPclEAp9mDt3CLLwXnnjyrhQ/1QWkGPIwdfm4qzlmwLIq1hFG2cWLEEVRTnJ/5HsjoVaEsPrPQQ6I90Ipy+DndYIf9dAxILyTBhZ3AMV3NGlxfGRKf/pfXDoBsCoEVoQ5CaMweOHd+IxxSPdeNcMpK0uTDhI5Qi6o+8B79IMYIM8SjRcLq0JvkDNClP/tYKEihjHB5zGfS7V8rDXByjNG7tcWalIp2H6zNyf2CN8HsTwvqSGygVF35XzlGvFNWeen0TcVOPtiF4D7x7AAD4ytU/Qod6E0ia6jOgS7GOEiRxLkyguz/rM0DqYnTmtVaes8Hgcshd0Or1X0EL1NYS3t6v5rRXXz1jeAcMjkIhdnJl3vPixM+4SkysF0OCG6wwRzLwO7HlNq02ceQK1WNgsYDiMhsLXFIn9JtE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 06:55:13AM -0700, Borislav Petkov wrote:
> On Tue, Sep 08, 2026 at 08:33:36AM +0200, Thomas Weißschuh wrote:
> > These constants are useful for cross-platform userspace, for example to
> > process ELF files during kernel cross-compilation.
> > 
> > Move them from the kernel-private architecture-specific header to the UAPI.
> 
> Why UAPI?
> 
> Why not include/linux/ ?

The existing, generic ELF definitions are there.
The ELF stuff in include/linux/ is highly specific to Linux.

Also later in the patchset I want to expose the definitions to the
tools/ build. Exposing generic UAPI definitions to tools/ is a much
easier sell than include/linux/.


Thomas

