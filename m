Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C7DCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 10:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534058E01E7; Fri, 15 Aug 2025 06:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BDF08E0002; Fri, 15 Aug 2025 06:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1FD8E01E7; Fri, 15 Aug 2025 06:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1448A8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:06:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C72B41181FD
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:06:07 +0000 (UTC)
X-FDA: 83778561174.05.57713E1
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf04.hostedemail.com (Postfix) with ESMTP id ABD3040008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:06:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=aO2iazZB;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=S6z9FpXD;
	spf=pass (imf04.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755252366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKM6vYBTvYJgJZpC+3klg9OwyY5OfNg57KkNb0OocWg=;
	b=QLpeUjiDFbBctjFKPYz9GV0gBnL8R4hZfFWUeC4rku1rdKRyo/dWRbhde1EdtnXr4xr1af
	gOA+DQWJH/sCfuoOMoxpMALR+JYqGp/soQCOdd+7KGNbCtkPmuzn8vcoAz84V3rcmnGHhW
	zjMNFdDREqBtAnoneBVWquGgB7K4GCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755252366; a=rsa-sha256;
	cv=none;
	b=wz0pWt6uw72+wQGyoo2JqRrhm/QuaD3qRFoGXlG8/sgyGH3uhTF1rBbbjWYONuDGZF0R6y
	BqrAs0k1Y35FH5icTuQ5Zt4kB0nH9xF+bTanUHSCEJ8WztWYwHgS0OPIizOBezyG5B60Gu
	46MP8DDsURd8XFOMFII0zE+Gks+0ZRI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=aO2iazZB;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=S6z9FpXD;
	spf=pass (imf04.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Fri, 15 Aug 2025 12:06:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755252363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NKM6vYBTvYJgJZpC+3klg9OwyY5OfNg57KkNb0OocWg=;
	b=aO2iazZBVl4jvGHcxioVfsh65iLR3Izq+qWPXADbutMqMavKgUaUthaDr+R6w1r6xC69M7
	pL5h2TEWtWYewAnpScYhJCkIaFAKgULbi15SjfGtKC8LJ/mZc1hQQzLg71FWu25eDTH0y1
	MdUY3+nnowrj0PdDzw1hyrQ8ozJ0BdBe+J6xfrhxUNOLMiWm7280NRlOtJuKnvCK2Hl4+R
	JjnaSPjNDatrg+pgW4dq3uCQftbz45AWPj/EWmXs4IklOD4k8lw//0rXGaZQYflfEXqJDN
	ZoNnis/wD+gc1ASC2wdlydN0BBi8bv7A4d+0Pi34HL6a8GZJXUQvVqO1fxQIkg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755252363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NKM6vYBTvYJgJZpC+3klg9OwyY5OfNg57KkNb0OocWg=;
	b=S6z9FpXDI0m5KmQAvWcT/IWg9tN8RVfisToJ75YI5pbqWTKx4VxzrYh7GLy6FZouW5QiYj
	9qWhB6v7+0ZZRyBg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
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
	Nicholas Piggin <npiggin@gmail.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
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
Message-ID: <20250815112851-e613308f-d49e-44ae-b2dd-ca7946fa1fd9@linutronix.de>
References: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
 <86186254-b2c6-4818-af0a-4eb67d90e501@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86186254-b2c6-4818-af0a-4eb67d90e501@csgroup.eu>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ABD3040008
X-Stat-Signature: mcbchzjcau91h5utmbfp1o5ug3ex7jym
X-Rspam-User: 
X-HE-Tag: 1755252365-854450
X-HE-Meta: U2FsdGVkX1+5SSbL/s4GfFutdLJsnmq4T1lb27Q+F73fVbhWfzJMfX7OTU29gCVfve0vnOfIWW299Ywe6ppvzx3iGiDcrGJP7IdMxzmYcqlDUOiZC+xKl/NWHee9jEucb0gjTytUC2Hp5XTyBSPFpS+1rJ/lsYnJg76HM9uqC5odJXrqctyz9jpe3Dq6maWRCAY59QFADlTxoa9G/naA78yTO4KZgvDx1buKLWFYcgwkwqNxJtmi721U8ov3+G0VX75Vqs0nftszfyXRnrHBiqVQ8i+FZXBCQhuX+ansLj2LfEQdDiRysGlIO/+yOhO0JagEN+5EbgLg2WNV/YXLRv0akJGxZrDwOYMWLRqx+Y9fAZUFTmCatw7lx3uzOG21RyyFHXz/Rbl1g5M3SRyKAtMFrM97kJGe5EskX/hvcaKvK+V1jm3vtzV0X+zpYVATqwRe83pd+nfOwDGVJFd14lUUmtPquJNlVpw40xsQadXiNnFYhX4km0aolazHr1nRyCCQhQrLSo3e+cotY5RAnAupxYImWDdIQo6GTu2XCVmO74cIAk0bg2MSI8lsZIJWKY/NUMgzvlnSEWNtEAEsS+070e4fdgcnagwje8ooa4BUJYQoSdYgBNFsaUJvStgd/Evvv1O1Eh6ya3weu67bFn1DAT2RDGdOvmc52KYRW6n7RQu/I+QHS0QuStH+oAIeN29YWCDlSnSofz7Hk3m8EcP11DhoGEYkgcyVyQO4MYUEg4hr3Nrgq9/7TclXBM5+fQtKFn9bC+GbknKhXk1Dji5TbBDceEGKe0ju8mkTD8lz/Ubn9/+7RaV0xGgG1ohyqqq96+Gl/UzA+ZY85TghX7Vh0fFREYaULG5I+jKKnfUeMmaQ91TJEd9QdVMZwXpVF7n/BTiSjTTys3xE2BveFkYmLZvHvSGUryZPhthpITvkADWdaT6/KqAMqlMhzi6zxPyP71nvBkPsO0AsLfo
 O5yAmoUJ
 H3KZmExeghMAN+Iv3QWQ1vb6qhlgUZprSBMqZ2ezZQPcHmLnbPVkBFpahau0641j+w+cLfa88hhniKDIPbDtdaolJzDTKzKtpmaHBYcmzPt88bAkC2VoZrhIWmtXPshW2fIXNW2Aw+fKyXvU+6WZXBp/TTehPg7UYY/PvGsiKjJfwGwrtntGOj5gFMtU4avJgna6fQncTzhfc7dpxs1PHk0xYhl7H21PtMr1gqYiszj06uovKuk1QhOBMm+tYiSpIxoFyROlAAByLFRk651mvBq4xBio9BCcNCS8I630yPCDp7MhvsX3LGZNodn8wHFntNKeQobXdQJGg2tPSVa5SS2FMsNzG7WiiTZeiwnD/tHudLPcMVmIvzt3H1k4rX8TSegEPGfNHClKniM056eOlPuQ+tKQtpU0pD/6uVM0a+IOmI9baCdtiqlmqqyCh50A4ZyEiolaHwaMQiWXSV6CrXL66DAoEvcstu9zNaMApplFAwd7Txdf44pCgXxpqH5CULuYK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christophe,

On Thu, Aug 14, 2025 at 03:43:09PM +0200, Christophe Leroy wrote:
> Le 12/08/2025 à 07:44, Thomas Weißschuh a écrit :
> > The compiler can emit absolute relocations in vDSO code,
> > which are invalid in vDSO code.
> > Detect them at compile-time.
> 
> I'm a bit puzzled with this series.
> 
> If I understand correctly, the check will be done only when you have RUST
> available ?

Yes, this new check will only be performed if a rust toolchain is available.
CONFIG_RUST however is *not* required.

> I wouldn't expect having RUST to build a C kernel.

The build will work fine without Rust present and will fall back to the
simplistic readelf test. A single report of breakage will allow us to fix the code,
not everybody needs to run the full thing.

> By the way, aren't relocations already detected by command cmd_vdso_check in
> lib/vdso/Makefile.include , using readelf ? Why is a new tool needed

The current cmd_vdso_check only validates the final vDSO image.
However that is not sufficient, as some problematic relocations will not show
up in the final image anymore but only the intermediary object files.
And there the logic is more complex than can be reasonably expressed in inline
shell scripts, see the previous revisions of this series for the attempts.
The valid relocations depend on each architecture and the specific ELF section
they appear in.
For the real example that triggered all of this, see commit
0c314cda9325 ("arm64: vdso: Work around invalid absolute relocations from GCC")

> and why does it have to be written in RUST langage ?

There is no hard requirement for Rust. I chose it for convenience of
implementation, especially around descriptive error handling and generic
functions. tglx was fine with it.


Thomas

