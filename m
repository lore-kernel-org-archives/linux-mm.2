Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F115C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7036B0092; Tue,  8 Sep 2026 03:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BEE06B0093; Tue,  8 Sep 2026 03:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE646B0095; Tue,  8 Sep 2026 03:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDF06B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:35:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D71A2160421
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:35:52 +0000 (UTC)
X-FDA: 85189785744.28.229982C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf08.hostedemail.com (Postfix) with ESMTP id F373F160002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:35:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=sF40x1Tn;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=t4GN1Dhf;
	spf=pass (imf08.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788852951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ji2FYflr/CbjV3rk9832i6ivZtcJlLtueWgeq3em9Fs=;
	b=lJGhofUxmyvNK502mBsQMuSIajU9XSydIrA3EzrjcAUrH2jZusnCgUU+WcBW9q4JbZQCSW
	KcTQni3zk+JKqJX0hILiIYNQgxxAeVdd/kpQXrQBv0kVg8ktjbYPiVFFGzeLK9C4JMJXtn
	ouP2Mu+oe4vzY59zYSZeltDZJS06whM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788852951;
	b=LNwU+dETyJZER1a93QcES6JHRR5I++g3cmHOYfsOqQtCigQ7sSrcTFLD2bnvMLhlHOZIlr
	XVzgKJOXzUsDIog16igofmQVJrVIRtnNlr2F+UY3qXm0OKNOhWX7xKrYuKBqwnIDPJ1bKD
	3l8YA9rXgl2PAy9whMGLI7gCXz0R8OY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=sF40x1Tn;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=t4GN1Dhf;
	spf=pass (imf08.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Tue, 8 Sep 2026 09:35:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788852947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ji2FYflr/CbjV3rk9832i6ivZtcJlLtueWgeq3em9Fs=;
	b=sF40x1TnpsNhyt0sI38rIHaeAvtNg/EM8w3EtHzsFSvvVwHHMnTzo9ND4gwdFmZKWgwiQI
	zIUqZO38xf+hqbFqpxnJEf22XYPf5rduERB4k6rIc5UkCj8/unJYgFDyl/VlE7G+EFDI03
	CNmgd/Vj1Q3c/q3Ydr3Q/DKOj3v431wlaOso4rjeyTahr+hMGIpBnsAkCalXgeDSgVmwoT
	fSwtBw7bhzCeC4FkKyNmCXzfRLo7mT4mBMZCZPU/i5SaXQchJvrd+z5JqASF5WVbgiH5G4
	it4ju8Bz/fYLxG5O3MBiu0Nd1yKjfxaEDd33C3bFc0Qo3/mwB0s4uDaabhB7ew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788852947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ji2FYflr/CbjV3rk9832i6ivZtcJlLtueWgeq3em9Fs=;
	b=t4GN1DhfMH6AgNQoFSHKMaImcdOBofdEStAoUz2uy11ao2hSCXVnSiB6G9+q7fkA3MPgYT
	C9GJghb2CAl+FqDg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
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
Subject: Re: [PATCH v5 12/24] vdso: Add the vdsocheck tool
Message-ID: <20260908093302-1a1cf0c7-8103-48b1-9f6a-abd5c5c16523@linutronix.de>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-12-3a93791af1cf@linutronix.de>
 <20260908071911.GU4120091@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260908071911.GU4120091@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F373F160002
X-Stat-Signature: 6jnqx4r9ase5pujt7znooodxrhy3makm
X-HE-Tag: 1788852950-239136
X-HE-Meta: U2FsdGVkX19gxXV37hQBIg5qbY5bCajvLCRCd57tLynVwmyH4RLWOfCnMVewmOn2MDSeYX78TtcOkfpIIL6ZI3otix+30IM4tuzgvTDV6xuqGp3kFZob788zkAOqYZUse4HLvq136I+ToWN44yDUKXO+IW2y0Jp2x5qWK+79UoLVV26mqq9LDvDITZhZ44Yk5uO7ZLQMgNYbR1WWTKvSqd7muekyAwgbFydEemwF8R+FQmwqsPvpjMgSdf7OXZgDagcabBO9ioDxfhfD0lqwjX0kf01GPMa/D4Ti5EI/smh4A0POXVBxv64vFy6D1mtN7pN0AvCEecln6aFVCpaAkYLFMaSXOi3PM278WEAcMNJRbcJJgSe+YIZdBktyIAaLNT61/fFP1PPm1EFYB4pLYRMJWJrWcQRmXvZa7GofJj6uPmI2gONnBPCJouBzPIwKcv0GnZYu6DR7WcwII/DpBSxeGuLXPr1xFpu/aUsvxWDVTQySk0ITGVQgCEehVGcLs+pThl5/Qa3b9L3mDr6JoI1D1D39Ma6x79NgUxuWt2p1wAHJUK0zckl4SZXLgN1nfSuq84GkqWxjL5ce8oweLlzeKU+NS+8hJgU3IOzEjLZ14QTm8bGoJlKVHmZtURYVUYgA15TINx+Tym0iWiDd1mA3ZmIyAtCfDvK0sStNtbNI7HTR2M0bLXII+Er5oLhWaCn1JbhLR55aa97HJ9nEwG8VZYXNE18ehDXe3RDIACGCx5qUG60mSMGsY9lx76BlFBlfzlEG9V85gMZbWy1yogEXypKTchrG6j1UDqXbENcdvyIOvAQlmvJzcB+Acfop7krqZTcsv/eGLchdogJjSf0WrGaTuPg4B0LUYNhDJZ0NNXp/6sNcC+qJIYtv9aQx19ovtgi1aeIWXBzzOjw94DVGhzaFnfXdf8bDIF1fjKlp0DJDZqIwrntojd/D0cxXlzzQxqx1pa1vSKmOfGY
 +FxmIMif
 ikjkLOMVFW2ZZpeJsO2fNdDUO7Glywp5eYOQ9ZtQjmhRZsPet4cg0hbafOKC8dJ7KpWZnehQJS2yLFPoTiaqGr9p5jrZ735c4cNZIISca8tvyzOvYqT/HrZr1kA7yH5+RJsRKv2rkmqt4DQOlwsOXsYCFDGkRSo+pfIcet0D1aD7QJMvJLW3gMXCAY9ljJIvt+N451+k7+9mWR0vkcst0c5IZlfztYz0qDdVIyYQmMcluLf6FW5UCWewyS8/d+8heWMdg5/6oP8kzuQJb096RgFr9GWz8gR6g8TkyYvqWeVhG5g9D5HmONftqqSkROs/avU+iULxn7206Ci3znFdq+29oN4KK2XUS1p+NjrGmxAVgMJeg7QUAfEr1uyECrpAlDGQ/apjuJ88O0qRp5X7anX6yFLqBqOC+S895j11bf3O4nG4niDE3UnoN3w1zJWsOACAxm0DLH92UqbhqZda0ap4ICRm7Cu7shjM5QmSrqMws4sJStcij4DF89hBlqE5SKenK78CiTtrSZbMoh8dgWE/tQJC31mCq5y3iCZ7Wuq92MUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 09:19:11AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 08, 2026 at 08:33:46AM +0200, Thomas Weiﬂschuh wrote:
> > All vDSO code needs to be completely position independent. Symbol
> > references are marked as hidden so the compiler emits PC-relative
> > relocations. However there are cases where the compiler may still
> > emit absolute relocations, as they are valid in regular PIC DSO code.
> > These would be resolved by the linker and will break at runtime.
> > This has been observed on arm64, see commit 0c314cda9325 ("arm64: vdso:
> > Work around invalid absolute relocations from GCC")
> > 
> > Introduce a tool to check for absolute relocations during the build,
> > as the current inline-shell logic is not expressive enough.
> > The check is done on the object files as the relocations will not exist
> > anymore in the final DSO. As there is no extension point for the
> > compilation of each object file, perform the validation in vdso_check.
> > 
> > Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> > ---
> >  Makefile                    |  19 ++
> >  lib/vdso/Kconfig            |   5 +
> >  lib/vdso/Makefile           |   2 +
> >  lib/vdso/Makefile.include   |  14 ++
> >  lib/vdso/check/.gitignore   |   3 +
> >  lib/vdso/check/Makefile     |  34 +++
> >  lib/vdso/check/elf.rs       | 498 ++++++++++++++++++++++++++++++++++++++++++++
> >  lib/vdso/check/vdsocheck.rs | 154 ++++++++++++++
> >  8 files changed, 729 insertions(+)
> 
> Urgh, does this mean I have to have rust installed just to build a
> kernel now?

No.

If you don't have rust installed the build will instead use the existing shell
script for a less thorough check. We only need one build machine at some point
to have rust installed to report issues and this check to be useful.


Thomas

