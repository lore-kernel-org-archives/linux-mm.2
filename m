Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807ECCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F990900047; Wed, 13 Aug 2025 04:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9F0900044; Wed, 13 Aug 2025 04:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0992A900047; Wed, 13 Aug 2025 04:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4332900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:16:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 944D01402B2
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:16:09 +0000 (UTC)
X-FDA: 83771026458.26.66BFCEF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id AFFF4C0011
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:16:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=t3ZaanvF;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=E1zvWv48;
	spf=pass (imf10.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755072968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgBW8b/WLrVQq0BHMU+zEk/Lyyfrm6a/mGbcYhX7PWw=;
	b=khnht9EmVeD5Ig5ZmEABd33Zi13tnhfwWwkNtBWKrx/g/gzQyCcuUxaru7i5c4NftairWn
	Tx1guYyoCQJp8yaNK0XbAff5obXmb12NIg8sZ2MZj9+4/D3KuMajHYumGVmSTgcJW/rExg
	jEHkVBfdg7gdeIO65ezTWgIxDnosG78=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=t3ZaanvF;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=E1zvWv48;
	spf=pass (imf10.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755072968; a=rsa-sha256;
	cv=none;
	b=FeSfu6cnzTeKLsPJkbrb+8BDYCVPmXAQUAJ8Aday/2KhlyBfhVO/EJuzfz3J6nKlU3Usjo
	2gRCT0FIDus5BRaV8jzzpWh1OcMJOacSMBusQtY5QhbNyu8ly+6l7Q0CjhCSfwrKAHB0fZ
	9kLVnV7R5MpoOZQuMnnTihZmXW0+FaQ=
Date: Wed, 13 Aug 2025 10:16:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755072965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgBW8b/WLrVQq0BHMU+zEk/Lyyfrm6a/mGbcYhX7PWw=;
	b=t3ZaanvFJHTW1l1H2nSwoa1VFh8EVFo/BJn0UMRG7bq78PXYOpzqMO9UGefI5UiLZP7nNe
	J1FX1/E5cqcFOVpKvUjolk1j8zY71ykS0B7X6UJ1jM73mZGhOMT+2RFDhdp4Y1WmHG3lB8
	fhvgGlk/PFabS5Cn+w3uMjkgmqVzkQuRRvX4xJrjg/8hJ+0j7jOT/qLXJIWkp6a9jfxObj
	LUOs4JziO5PF87uDbwzJHBzRMHIM1CkGRGPGIwWfVdP7ckTLMMlHtUDzc+O5vxoBEjlmG7
	1skI/bKKNj/R2CTmQujVy01wAp2WhS97QfxNvozWzsRXygdxqvZz7+ZCEZyixQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755072965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgBW8b/WLrVQq0BHMU+zEk/Lyyfrm6a/mGbcYhX7PWw=;
	b=E1zvWv48KJJ+SOu4RstGU/Hts0jpCLaRVEpYFntAu8DSCAbOKCuCF3vYrHswu5Uo/Nk8OK
	GMt5eI9bpKssCIDA==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Nicolas Schier <nicolas.schier@linux.dev>, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	linux-s390@vger.kernel.org, linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>, Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v4 00/24] vdso: Reject absolute relocations during build
Message-ID: <20250813101305-04911850-2375-4be5-9a06-ced21de3ca22@linutronix.de>
References: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
 <CANiq72nV62c8cVBzke73OH-sfLdgerDBGrLKTmT83+OQtK6PjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nV62c8cVBzke73OH-sfLdgerDBGrLKTmT83+OQtK6PjA@mail.gmail.com>
X-Stat-Signature: efx8quktb76ujjprid3ipnbgan9zu881
X-Rspam-User: 
X-Rspamd-Queue-Id: AFFF4C0011
X-Rspamd-Server: rspam05
X-HE-Tag: 1755072967-722110
X-HE-Meta: U2FsdGVkX1/JDyv9AK/2VOSZ91JjSs1SP4buO+8HKjvTvVomq7u25sTqwui+b+Mu6L3mjicZ5KtHuID0jtDvMXi0S/EDIU+yXPu/SyzdF4x73L9I+p6hOmHvP7zWcvz8+r+/ndB0g8SsZT9Qq2piaVk+FfwNLxaFOE2Deehudy9lUOkOS516chCC8MH4sKWsNR8UYBlH8ohjv5VdfZVxOWS7clamVeKvivA5R362axXZWupO5okQSsqi8hvAg1Yi7c3XFSDBaFychvKhtQoFb6V4i+IjAQDxrIJV78878UGGCbVwVqQi9lx02rZsIiSDlTKp6ZGDcbKClPmp7tEzkSGWg26sPbYiFgy7KBPA20KM8f3APaB+tMhiw/6U1gsBSdnWgAjy1XJFo5QUv2RuxKCLrq9fbsXdOtKJZdDKrzrvHctYGBvvF+S6NyLRxXeovpDfb8rZChkXy8tnwYnSY/SJVfIxh44QWTrPu+kAA3HabAi8KDEUd9UK00nqmJucvGEYo4bKZIfr8NhcUpDm//T1QV2m3NvZMZB/kUAXGOReTXHVockMxesAhiS6nNet2n2gvrvVgW1aTpEU1fKxUEy8imVVNoF1A8rWONf7aT4Yie/n7mfDv3nXKu0mb/yvWvkpU5RZIqvoCxTHe1Rlgs/o1g4KBwTP0vMJ9FyZU05Tw50hQ/hxkkX9QPPafzRFqnr+hfaXsF9y87dPRf7dneri53dhuXEiS5H/u+CE4qbd5HJecviBWOEoHqTze98BnGYYDg+XqwbJu1jWfzDBRS0I+3pFXrSEYsi24uxAfDtfb50GGONGJyAaAjHskdKV8lHk/wnKf1/dR9Dj9+wF0BFGuiT8sXzK+Xapu7Gf9Lx22SAqUNw0mRV4husNmMsSEqHOWGY6iwJeFfRHORlb2Y6do/tUkG5jyOWpBRsrAEzukR8mlcJez/VG75nTQSn9b+T8f3kqjlpRGDroBv0
 s3oKQhYY
 czvvDoo22h7nn+jA1gTN47psQ1t08qYElWtI4QQmQbAQ0DsqNur2utXO6B/itHzsKfPMtLdchHv9K/gs9+sUiNkOQ7joB2VDX5oontW1Q3hUE0jGLnw9HdGKhb9ge0zDDcFLdT65rx/sxkmoNAiGHtOc2//9FN/aDqe/Gu0imyx9OsRJmVl+xK6CAGCIfaZGaC9ewmcXkJYmJW4iGsto1CytXs5bp9AS4fMyyV5yZ0ejZXomWAWgJanwzYM742XwbVPjzeb3Pya+dPvt58LF/HD+WWo89xo9VLuzfTfMCi/UlseUiSv7pY5LauFk+uA2uzCW9dFg0YyvQVgsUHvl7Nudpi3bbc2E2qnyzRErHrGDsfrXoLIiBbxIWVcinjfbOoWIpJ1RP2T0q0cC7uc70CRE6yIOAsVszofLV7HIEQbsnRnVA+6k9ncpPVbVzJ2/oY99QlBcDHKxV4CcqHVlxSMGDKFaGAZpB1TDcRDkyJH4SpJE/lvEF9I3pjQcDlZjO3aQ7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 01:07:34PM +0200, Miguel Ojeda wrote:
> On Tue, Aug 12, 2025 at 7:44 AM Thomas Weißschuh
> <thomas.weissschuh@linutronix.de> wrote:
> >
> > Kbuild and Rust folks: This contains custom definitions of hostprog
> > bindgen and rust library commands.
> > These are currently only defined inside the subsystem directory.
> > Let me know if they should go into scripts/Makefile.host.
> 
> Glad to see more Rust host progs :)
> 
> Keeping them local may be a bit easier initially to land, I guess
> (e.g. no docs), and then we can generalize when needed later.

I'm happy to do the docs etc. I only wanted to avoid doing all that work,
only for it to stay a subsystem-local solution.

Also it would be nice to have a Kconfig symbol, RUSTC_CAN_LINK or similar,
which indicates that the rust compiler can build host programs.

> By the way, for consistency with elsewhere, probably we want
> `HOSTRUSTLIB` -> `HOSTRUSTC L`. Though I am thinking to remove the `L`
> anyway since eventually a lot of code will be "lib".

Ack.

