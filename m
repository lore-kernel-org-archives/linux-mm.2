Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F68BC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD446B008A; Thu, 10 Sep 2026 04:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF296B0092; Thu, 10 Sep 2026 04:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3676B0095; Thu, 10 Sep 2026 04:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0B06B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:33:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C28314021E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:33:12 +0000 (UTC)
X-FDA: 85197187824.22.750DA11
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf19.hostedemail.com (Postfix) with ESMTP id 600F81A0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:33:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=nq0t+a13;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=5bolpWR6;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf19.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=nq0t+a13;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=5bolpWR6;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf19.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789029190;
	b=SCQgAzyVlPfGZHSHOPmXyDv2zSGTZkJ83lidx0XInAAQw+Ap5Usb7yYMW7h8Se+exLRGLL
	kShVUjWH1rPPtbQ/BPnKW8R4BDpkUK+7Oxpb6KzIJv1AeZ895H/Rvfi0v3q7Aqf/BKZBQH
	yGyvbGbJJJzPndCXSzpbUXo9xB66c/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789029190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgYnxH7H+tx7By2AM1sGAFXZm+b1KJf3JRXo/DozlYY=;
	b=BSWCGc6+6qWM8PuRlWhCvAFiQKNkIcAjftdjGLCPbzp6RPmA1YwnKput0vszdgnoCmBjdB
	RMmm1j2KSE+wEm8iYVSOX/Oj4mZ/9BlSa/tUhGfZUSxLX0DgYXS+ddcgwO1AX7Mb25GGEp
	n+K/F5tl6twZVu8Vx/X2N2jcwOD0AVA=
Date: Thu, 10 Sep 2026 10:33:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789029186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PgYnxH7H+tx7By2AM1sGAFXZm+b1KJf3JRXo/DozlYY=;
	b=nq0t+a13NaTSuYF4CeenzbMGkxy4JvQOZ0gqaRRD4cV9bqclklB2nkc3jSKVIovWerzMBz
	LqWRF9Z/Wq6H9Z9U5z8AE+VQpRnpoU7JLulnrl5INZdb1CMxTMPnV05lqmLTS9b7bcJFm5
	+Jtv/C4gZ+T4oI66pMCTl5u5+NHtvOkMZSIlvstSVWgfAMfF9Uop+cNAY9pJ1wnhDHX3xt
	0EaSx9l4i8NZrU/FDddnLlVafk+g+pAz5r8kkTP/k3bKjkb7OYFvZ0hMvCNLC7AHSIlTma
	Sl6zOqwKm4Xb6YskdZMSeNDBr8w0HvolM2Ie/L+Q4FlwBs5LfCMZSPSM6ejB+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789029186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PgYnxH7H+tx7By2AM1sGAFXZm+b1KJf3JRXo/DozlYY=;
	b=5bolpWR6VEOPOQDk4aOdzzFsCMnIuSs3+o1Bx7da9a/VgRkSmhJ5Iff3Ie4w9HH2UtpfSb
	Me4QoEKEhv6cUqDA==
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
Message-ID: <20260910095003-d751da0d-37d1-4b14-9941-e3c388c94733@linutronix.de>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
 <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
 <20260908161740-0d79e592-87a6-43c5-9174-84ce1904e639@linutronix.de>
 <20260908151238.GBaqAl5iKb64meuPJl@fat_crate.local>
 <20260909075156-06ff671c-ab7b-47d8-aaa3-588b570888bc@linutronix.de>
 <20260909144930.GAaqFx-mjH3-u6jLjw@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260909144930.GAaqFx-mjH3-u6jLjw@fat_crate.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: 600F81A0002
X-Stat-Signature: tfnjoy9knqym9jfqn1gjhed76aib7kco
X-Rspamd-Server: rspam01
X-HE-Tag: 1789029190-647704
X-HE-Meta: U2FsdGVkX1/WHibcEF5SWQSf65nkH9JaMfJqDGpn5k6H3CeBbAREafs52Ba8/DLEAAuN4bIwyKQDjUPUeuO2FxxTClhDBtvSXAl/Na4oUpPhUsDy7Mo8VWWZ82dyzs7gS9x0yrpkVCE8BSuhIyPbkepx07+OR5hkapk/53uITayAKP70zNqu1ILIeIHgZRzE/SWog/DsyAFp630cvAocjWf9MOv4SHh41qhH5QsdqgFu2Gs/YON0mQDU5frnxhUDgMo2zHIY4OA4v0daLwI8npYERg45vChKoD4SMfsypSwjhKujXDg749VdA4QzSkioMquiIff/ZeT7O49AvSBdGGV4bYm5LnFYy8E7cNnu7p9ggqksG0KT3E4FAU3ykS3T79MCYVEDvg5ti6pwJ/E/sn+ZggDj+dizczE4eTyDReI33QBOJojQUYNPyQeoVxoUgdfnK7Y3n/Wa+z/hheLTomGnT+6a8nuND82McrE73GZNy6LuOiGbHh3MvMgDsEZqtcrjPcdoXMapXhblkS83lcjVnEehwcFkSzGzRYWaC0e9x1ET4E73WbUdxRaqr3QwNuBcvDLGxRr2NhQVEPSi6nzWMyIu/40t0hfacWJ8oKsqO+6suz+A+OleivOSKkZYuTDuWBfjrIUBdTrMhMKz6oeeVKSuQjCHV/LiG85o/SXbh3D5YIsopUlmgT7LlQDYxSlpji46kN21G9ReeHMiRz7wt7KT+/2KEKo1JdjL/8dy0Wxl5QbYR6/+iJV12Evqx6s3bckgg2hQvk8DJy8KTapd0mYZaMOf0ZYOjUucg44AZ/nvaaYG+xzx/V4CHBgfdRI82IoPF27bI13qnVsen6ZLM1VJdjfXBaYIGSLIFEsnWHyNrC9RE2gcg2a1rUIkpD49IjB8Qce8Vrjjp/sDs15FXm3lileCUs73VdBdKOat3/ZHx4LYun7YJGk7mp9GPAHuZd07ujo4BE82h7a
 JEmFKM/U
 gpyrGNMjLBGDi4YlGFVEVQ+k/yznT4yYZIC7L4qiAX/N4j/8cnRxUUYkijh6Unuoa12q1jKSfjLE01EaC955rJ1paYJaXz5mwg8aQJhREMBqH+7WhVdgk+PkP+IIyCVkd4HHyDJTZ3/H1l2PdKPdAaiGdwtlHk7MBYj8yn2SiZ5MhhzPCqem2NULk3jiUvCH9WvoSAcnTLmNSb7EqKG3DmJk7GgRa0Bi7AXZoAz0pEiLuPuFl8DhRaUV3eOG2d6tjUawi+3FxjwyQfrS7lLgWc1PAftBVLY1LHjdf72ECkBWV1tyUmoN/8EhGV5OOaT79E4+IzbpTZk1evZvilc81w9jlEHBkA11KCnHGyB28DnfRpP5CUr7H6cshxg3VTqEkmJZbVOqsgAQIm9extL5g0JbgjUrZ+Zgq6mL/fZbgEljN2ShXwzVewlQZvZaEvGvUbewQSQv9w3PpT73lUqN4HazPL7voPBU2gcodfIkGz3owBqRFwC0ai7ya4Rw526EV9qaOLtj1Bm2YSWc4cd0J0asAs7ozqck/axhPUDigbsROdSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 07:49:30AM -0700, Borislav Petkov wrote:
> On Wed, Sep 09, 2026 at 07:59:51AM +0200, Thomas Weiﬂschuh wrote:
> > These names and numbers are defined by the architectures' ELF specifications.
> > They are already cast in stone. For example see Table 4.9 of [0].
> > Changing them would break compilers, linkers, loaders and more or less every
> > existing ELF binary.
> 
> So?

This was a direct response to your "And putting them in UAPI casts them in
stone". With the idea that we can't possibly cast them more into stone
than they already are.

> Your goal is to provide them to tools/. You want to provide them to
> *everything*. See the discrepance here?

My goal is to make my tool work. For that I can just as well add ad-hoc
relocation constants definitions in my own code. Just as everybody else
has done, in what seems like a well-honed tradition.
Unifying the constant definitions was a preparatory cleanup step I put
in my series.

Some architectures (like x86) define the relocation constants in internal
kernel headers, but others do so in their UAPI headers, so we can't have it
in include/linux/.
As the UAPI is the common superset, and given that we already have quite some
ELF definitions in the UAPI I this is where I put the relocation constants.
We can add a tools/-specific header which is not shared with include/linux/
but then we still have duplication with the regular kernel code.

As a coincidence, these definitions in the UAPI would also be useful
for nolibc static PIE support, but that is more of a weird curiousity
and not something I want to bring up as reason here.

(...)

> > Also we already have other, closely related, ELF constants in the UAPI,
> > see {,tools/}include/uapi/linux/elf{,-em}.h.
>
> Srsly?!?
> 
> You moved them there:
> 
> commit 626fd35278295fbb21f2da331cd8028e9738d965
> Author: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> Date:   Wed Feb 26 12:44:46 2025 +0100
> 
>     tools/include: Add uapi/linux/elf.h
>     
>     It will be used by the vDSO selftests.

I think we are talking past each other. To me the act of "exposing
something to UAPI" is adding it to include/uapi/ (or the arch/ variants).
That is an actual change worthy of discussion, which I am happy to have.
Copying headers (UAPI or not) to tools/include/ is a rote administrative task.

The commit above is the latter.
elf.h has been part of the UAPI for as long as the UAPI exists.

> Looking at the rest, it looks like some elf bits got exported, you added some
> more and that ship has sailed.

"some elf bits got exported" undersells it a bit. There are 14 years of dozens
of people adding constants to include/uapi/linux/elf.h. So far it doesn't seem
to have been a problem.

> I still think us providing headers is completely unnecessary and it will come
> to cause conflicts eventually but hey, not my problem.

As there is pushback, I'll just drop all of the header changes.
Maybe somebody else wants to deal with it at some point. Not my problem either.


Thomas

