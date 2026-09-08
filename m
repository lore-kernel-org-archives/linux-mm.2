Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C57F9C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53616B0093; Tue,  8 Sep 2026 05:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03A46B0095; Tue,  8 Sep 2026 05:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF20E6B0096; Tue,  8 Sep 2026 05:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78B466B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:37:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FA4F160470
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:37:39 +0000 (UTC)
X-FDA: 85190092638.11.B4D33CE
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id 60CD2C0005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:37:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=F99r3XWu;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Eal5NKMa;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788860257;
	b=gH6W8PGHVyU7Z1iGw4VxN32O35XvfiaIqa9sgySHNL0ZLeX4edBfgmOLCM/AJL4iI39fg9
	0o38Fw5lzIaerBaofJYjfIUeXEA1+KPj6XOt2rTPrpsKfkDgHFzZokbsUe1YQxctTszMsp
	eV2mkhmEMxiI1LsJnWDlEjBSpcmWAvI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=F99r3XWu;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Eal5NKMa;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788860257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4bnahwswymvE5nOIFxOjV/veHxRfM8mUS2vFlMphLI=;
	b=Pq0xbCWrSaPXVZBKQxIfKemWdTI/qVtI3VOYWWI3F/1AoFmj5NvGnvXDYyG9fViuxomrib
	y2jR/TGdzfRA0TJs1yadm6z6kUTeSrMPxc1ixaak/XKGfw/33VV6Nnx6RfZoIFIimHVe7c
	DD32rQmQPebVpI9YLz0wkXP+afqzC3w=
Date: Tue, 8 Sep 2026 11:37:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788860254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4bnahwswymvE5nOIFxOjV/veHxRfM8mUS2vFlMphLI=;
	b=F99r3XWuTQu1aQaZj3Rg35vrK+Vh4xoW6esYP08KsnkTB5yxRHFlAX+DCSQ9MmE/ytdjCY
	bT6ZSwlbgz0Tp/9QlaRm9xj6k6x+gQowVBcql48kgWTi7EY8hoPzlCmCwOwmHC8SxOCa3J
	0icgZeoQJU6KNJO4gOL3qhihZkDuWn/jnlOBCrvGJD7o4Fnl7C36ruhip68Y+2nMvnOAVX
	9XoGZlIvgcOwA32mE4o6lEcMBu1d9f3urtNxvC6vBsxPGt/e/3MpqOApvFdmwEjj/Zakfp
	dC6HHcg6MFdoR4Ez1Du4OVqzN/fIOPQmWkTrSXFlU1lEDS+2M+h55TuuwKLKTg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788860254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4bnahwswymvE5nOIFxOjV/veHxRfM8mUS2vFlMphLI=;
	b=Eal5NKMa9KoeM279byQBbEfyeEmUQxO7LFbQVe68UMo95PO7FvduzWF1IqJWwbafV544s9
	HhGMsegsgfpaGqBA==
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
Subject: Re: [PATCH v5 11/24] tools headers UAPI: Sync ELF headers with the
 kernel sources
Message-ID: <20260908113701-7b7e8e99-81cd-40b3-8a33-f316defe6f45@linutronix.de>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-11-3a93791af1cf@linutronix.de>
 <06996199-5255-41d0-ba6a-ebeca57f61da@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06996199-5255-41d0-ba6a-ebeca57f61da@kernel.org>
X-Rspam-User: 
X-Stat-Signature: gtznim1uews7txoebeewc5n5i4jkcdke
X-Rspamd-Queue-Id: 60CD2C0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788860257-611774
X-HE-Meta: U2FsdGVkX19CTul3IHHf4manjXwqFlH3U8A704dH9qkrcFBXfPW+Ar1LIg8YR9r69UbIlPcT+E91Iv0hWBczYOltFDKjnwWd0e6BxOias1HlOP1/uFBQxBVDDhScQCDjy+l1sFhyqbsqd7BIbXWf+yIItTdJ920mwWbmvrbwxlRIlL4rxDnLFAJbMUw65wB0XQuvAz2rT+NJ04QN3WSwYD2BsTQj3+TzLfhb2ndmi3LwTCf1/3BzmDXpXI6bXZ+bbjswXCx8dKovHubxbx0c27BbUHL7mOOnM2j3cx/gvnMlIOjHLxHSMCscJGi8sj6WubnzBw+yXOeAU7Fpi0qtaxo9NNUnehtAl7AQUOA1ctMBA/fFCwW+GV2A5yblUUTDqJdoAdtaEvDvkTbrHoDe+2nO+gphOk3xugx8YWRn5LBHsa7R3hZdjXyQbJ42mRnE2dHHV507BV5Kgt9e+C8XzFudxeO9E266BjAYPoNE/+jljkP8/L6qrei9HQdUbQNKEj+Lj5en07dJfPdYGV+i27NbK8pDAI2uPYACxjzKkVoRsN9f+PANMr5YjjejgSGVvIVQf454229pA8lrnfC6d89MCAD/Pe7Rm4beurdZj8CSbI3pnLfEdIcw6hogvaC+HY0qIWEqsmqF6TU7yI9EJfNv4/2hlmU9r2i+rjTuBgbpT7g1xkIFsvzuwcW+k4kqgXqboFAe62pHVH/+x4hXeWEaXbfkwumY3Bm7youmQAHlZ4AEMjIMLy5fE9gVlv0YF4hNvexuDnf6M2UkJqikCOvBktybeOxWEPD7/Jq2NBksKJ/P6xYvAD7VFUz4CFvAFODqyDHnqz5SVDx0VV3MiUyv7cuW9mw2tNH4Z/6m8Ij3dPdzdNMHsI2D6W5G2RzmWv3sSw1xHVgDlP1ESpcmQZ1HjRF1mfWnJ0jOB1FqqhdioTmDQLAqXO1jUFj8nzQfPPTlj6ecp02IPPiFs3X
 y57vCeN6
 XatHVRbO9wZa7HFmKhgPIzRGE/VVTXRaAz9T0ByLYVHs/a/OGk/WeG7zmbdmRP/hGqZmQK+UnDA7EGh/yJbI+abGqN4MaVygTCNTo0pw0sBEvUy6OHLOqHczyFP028w/2hQD6ZlDhtPscX3IOjD0CoJKliLnxNhzoUI8dity+fHK1mv20vKPesm2CQseMpTKSTxS1kST/7KYxISmMf5LVdwsxEMF4n2H6IpmIsoK5bFKr5JdnMNhTy/VF5ppgAncXxnU8Y9V5HodytleShbKCUDJveWE+W9+iEwrhzCz4usjp7O6vPaqtEJlZR4tfEbfgzt+ICrpxnswTKvfOpQqSIes8gZSuKW+cblxrYJV9+Utc+EBclIJmixm66w0PHC0mQlRhCqgEqdUoQEzdRM9K2cOyEuaHttZ0JyTmVfTI5TyOJqBVkPpi7Kl51KOtsk2iHzxOId6KDyBeiBWh6n0zYFTrFZ4nZ0TSgl+8mAhM0zv1YMYfjb7BGswjgaNFWyxbvpKv95tF/Rwxh9EAVXm+1N7/vtZog6GAP3jETibctq0VJPVhbtoOMBxJqNiXa+hVTJxn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 10:56:58AM +0200, Christophe Leroy (CS GROUP) wrote:
> Le 08/09/2026 ‡ 08:33, Thomas Weiﬂschuh a Ècrit†:
> > Pick up changes from the UAPI ELF header files.
> > This picks up general changes to elf.h, elf-em.h which was forgotten
> > previously and the new elf-r.h.
> > 
> > Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> > 
> > ---
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >   tools/include/uapi/linux/elf-em.h |  71 ++++
> >   tools/include/uapi/linux/elf-r.h  | 696 ++++++++++++++++++++++++++++++++++++++
> >   tools/include/uapi/linux/elf.h    | 112 +++++-
> >   3 files changed, 868 insertions(+), 11 deletions(-)
> > 
> 
> > diff --git a/tools/include/uapi/linux/elf.h b/tools/include/uapi/linux/elf.h
> > index 5834b83d7f9a..88bdcbb526c1 100644
> > --- a/tools/include/uapi/linux/elf.h
> > +++ b/tools/include/uapi/linux/elf.h
> 
> > @@ -312,7 +323,7 @@ typedef struct elf64_phdr {
> >   #define SHN_ABS		0xfff1
> >   #define SHN_COMMON	0xfff2
> >   #define SHN_HIRESERVE	0xffff
> > -
> > +
> 
> Getting the following warning when applying this series with 'b4 shazam'.
> 
> /home/chleroy/linux-powerpc/.git/rebase-apply/patch:846: trailing
> whitespace.
> 
> Seems to come from here.

That's also present in include/uapi/linux/elf.h.
I'll add a fix for that, too.

> 
> >   typedef struct elf32_shdr {
> >     Elf32_Word	sh_name;
> >     Elf32_Word	sh_type;

