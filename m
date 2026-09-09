Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70716C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 06:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1BD6B0092; Wed,  9 Sep 2026 02:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A7E6B0093; Wed,  9 Sep 2026 02:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290746B0095; Wed,  9 Sep 2026 02:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE51E6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:09:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC1791A0894
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:09:10 +0000 (UTC)
X-FDA: 85193196060.15.B6CD510
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id 193B6180002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:09:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Ba8CFyue;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=fAJ6G75L;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788934149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fsx+E+IxhTgqrNd5fDNEdWA4P4WjUu/zI9gxcY2gf1k=;
	b=Virb51orpgQC1jwm2mAmif6lPt/OWdyKisZylCePskzU8LCT07rMLJ/PUsOdXOkzjUEaAp
	pMEhLaGOEK8HkWzGF4Nx/C8bH9A8gDl8g+HXu8F2HfEVfpWlwce3jCeqIZUe6g0PUkxAeu
	SdRHVK+UVDDdqR4W3lxg5iuRqP3kr/g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Ba8CFyue;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=fAJ6G75L;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788934149;
	b=Laq8QzTTTU9G24wrI4aZRrLGI100s525jRpf0hUB4c2VLTvnxRZA+6Abe9FcVBvMyNGLmN
	4jx9uMDaFLYUP6Oo8ONjAgkue9s853hf+8gwu4C7JV2Kq1AeLbjyTLtEQbKr0phD5JY1Cw
	76lP5crWXFV1eXQd20kOvhl0isDJ2Oo=
Date: Wed, 9 Sep 2026 08:09:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788934147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fsx+E+IxhTgqrNd5fDNEdWA4P4WjUu/zI9gxcY2gf1k=;
	b=Ba8CFyueZIBv0OelbgTnQd8Liev5J1UqmQNZMlTvb9O8KcOJJTdoaB2ThyVqE1f8eVdkpB
	wTE4Lfz5SmplS9gum8fRJfjedlxYamdPBHVJ2zN0PmVQ/fAuza+eRyHTaqNl21luZW5FSV
	7mSECa3gWtr+fP2KkXm6iC1JdfB5MAxu3Qk/bZ7DsXkgsNE6bOUj/o8lxR1BIYweICcdVu
	Fm6yt/eraobBg9c2pGNyeS88edKZbZQw3VCce9fTmXPsolJkOwKGjp5YqUwJX6x49ccs+s
	3BERlZcIkDcJWAolf/r7TyPPNGX94YB/SldI2jSo7Dc4KeV5buIEb4c2Lh26vA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788934147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fsx+E+IxhTgqrNd5fDNEdWA4P4WjUu/zI9gxcY2gf1k=;
	b=fAJ6G75LaW8nnqqa43BRDYqlP7QW6Q+nfq2qssYjtogHzBntGBNA7rR18bMVBCUfwB7vq4
	TycChAiSqeQsMbBw==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
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
	Thomas Gleixner <tglx@kernel.org>, Boqun Feng <boqun@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-mm@kvack.org, linux-um@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	linux-s390@vger.kernel.org, linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>, Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v5 17/24] powerpc/vdso: Enable the vdsocheck tool
Message-ID: <20260909080124-ef171c1a-83ff-486b-b632-8613011a5a97@linutronix.de>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-17-3a93791af1cf@linutronix.de>
 <7c9f6ec3-5886-41ea-8803-d81019321d29@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c9f6ec3-5886-41ea-8803-d81019321d29@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 193B6180002
X-Stat-Signature: y5aocynsmua9z3b5pnz9rr4ysp4hx9ut
X-Rspam-User: 
X-HE-Tag: 1788934148-607294
X-HE-Meta: U2FsdGVkX18vtZOlJKIkMNmnZwBa7PUA2utXl0b8AYsDrTnngfEbs/MF/jyyf4EeU7XrW46TUM4HWzwIzfAyowAzuk5a/7FUkKi3/uY4is6wJV4jy/pb56VJQtxhS7AeFtHFO/d5iD1l4tQ6YCg/BoVB+PZcZ+KKjhPg529lf6SdDHDXzj4J1TVi36SeyqfP3LS17aqWth/ghH6MA9VpUbQudipBSm9dPivnW5fkCzgf+3y13CPHFHOgbdPDw2bzsQbIgzrYP6Q+vqqbOkEkMtRl7aPhxZ7v1YQPJiGGCQf6JWoRpA/RO8cKy9oz1jLQCo6mJvFC8aKGjEikN9zxJ3Yd8PY1Rr6MPi1e44ppts9qaGy39ENJ/XB2FztdxpjrT23b463FEngmPvKXGYiffOlxktGnJrBR206YYKyxrPQVCZLQR4pECFfv7nwDIbmFRmkBPRG0d5kbKBti9dtg7R5Dv5D0KtBPxcLbdAXKJALxnnLrqAkYy/CkdL0Qz03Hps6RELWlsrwEkWkYNPQEMxFSM2HK/Bq+KWAzSiJsdRDRaKpxoQ4OO3lEB1d5tzjJnalOHjK6fcm/W7wXC7NYHx7Q51ffMk8OaQDTKszbDwZGEVO+CLrnWRU6a7CaGuZH7h1MbD+6qZHhFEmXT6WmEmY7FPYYT5GDsym/wSn0BMcKu02SE66dgkmKZjE811JywiYn2gnUZBcg06Hq7Mi1d+nTCGKQ1tFZNM0SYDg31Dw4Mf8pC4Lkj2MAqfy94O9jb3P1QCSx7AdYvt2GpzhB8qnXN9l0ZA8PiVb5EmShU+j+9jiN+YvU2TQwRJtHXb6GUSl3oMrhJumxinym+pOQjeuE5RHJGbCbqnpKH7LnrPXXuc7cDwN1jV/WUfQ8dZGme+4rokrLUexncCQNqGQxHA5UscmMNDPeJBJAhe5FAQMR3F7aQV5RBpD6I1ghUYj14U3BthJd3dZjm0zqQ3b
 xWfBWJAq
 W4ryDlhbzVkS2p9irY8L5uJfnLbF1vVlQTy0MpLdG7f1Nruu9lbxSo1Euhz/WQQAs6lKGSJmAZx/d7Trxvmd3jyMdPHrxkrQmhwSgJwm3BHD8gX/bSfdavu39eCtaP6ClWVqrCH8ePAyPmHtDHWfRrjzg/n/rR5ZFiJPArq41VqhAK0H9skOCUJen8CeTccpeo3quyH7g2ygljHzJU6FfBOK+mzFuenRH4eLBdZWJWZaiRfBbcvvJAMzQYk2hGBBnh69C/kaQxVqxHuitc1ciF1NERReNVSEScFGb1yr+9XSa2i6AcEijPRQLAGfyz25odIuvROwVoHQoxGvYojRCpP0ssnAgi7eWUicafRjTjLweVBGlgI6RXYWUaw7nURghd1XJs/8X2UHZ9YxmmLvYNWoD3jZ0KJbZrukPlsbVATWH1L0IqyoYHM/hK9tUWX8wVUC149g3OpbBITI8dkfVLEYmvameiYZ1y6senkdU97ZDADQnYRUBaxQl7p7pTGlbJ7O7NFeQdkN/XNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 04:41:09PM +0200, Christophe Leroy (CS GROUP) wrote:
(...)

> > diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
> > index 368759f81708..ca20b91b4373 100644
> > --- a/arch/powerpc/kernel/vdso/Makefile
> > +++ b/arch/powerpc/kernel/vdso/Makefile
> > @@ -81,9 +81,9 @@ targets += vdso64.lds
> >   CPPFLAGS_vdso64.lds += -P -C
> >   # link rule for the .so file, .lds has to be first
> > -$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o FORCE
> > +$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o $(vdsocheck) FORCE
> >   	$(call if_changed,vdso32ld_and_check)
> > -$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o FORCE
> > +$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o $(vdsocheck) FORCE
> >   	$(call if_changed,vdso64ld_and_check)
> >   # assembly rules for the .S files
> > diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
> > index e45a1fbc6829..429bdcd65818 100644
> > --- a/lib/vdso/check/vdsocheck.rs
> > +++ b/lib/vdso/check/vdsocheck.rs
> > @@ -69,6 +69,33 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
> >               ..Default::default()
> >           }
> >           .into(),
> > +        bindings::EM_PPC => AllowedRelocations {
> > +            in_object_file: &[
> > +                bindings::R_PPC_REL24,
> 
> Not sure this is correct, see commit 42ed6d56ade2 ("powerpc/vdso: Block
> R_PPC_REL24 relocations")

(...)

The mentioned commit prevents the relocation in the final vDSO,
while my patch allows it in the intermediate object files.
In the final vDSO no relocations are accepted whatsovever.

