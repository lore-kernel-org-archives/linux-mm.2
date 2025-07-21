Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99701C83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395686B009C; Mon, 21 Jul 2025 16:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C996B009D; Mon, 21 Jul 2025 16:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282316B009E; Mon, 21 Jul 2025 16:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1775B6B009C
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:49:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAC2412DFEE
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:49:57 +0000 (UTC)
X-FDA: 83689463634.18.581E0E8
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1CAD9C0003
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:49:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=USwBlGGy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130996; a=rsa-sha256;
	cv=none;
	b=v6sd3LEwTfAsotuNDsw3NQp3Bc1r2Q2thCWm2uDH4gi9c7jPYkNPQ95M1nn3LMg+tDLB2l
	UtrJoSJbJnmBCfXDBDFtrcVSCKDCtlm+fwRoaBX4GH1xmdVOY3HjA0ZBS26PLiM0/lZZ3+
	iNZCLOwyABM854/jeuybwK6gNF+zrzs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=USwBlGGy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgY4TtZ2A2t9T1odFgdUEhawq4pWen4ruPSFuhNnlGo=;
	b=mtz2aGsZufD0ESM5d3N0xnfc/aEIv4dZ/q0g+YkfOUZSvSnuEEPAVs5hBpUbehDXxn6Wa9
	gfH6l0DXItuYrruIt7Fdv4h9GOTBHqGjdmQFhqgY/hlySAhGXlCUNUQ5HHmRL+vg8KCUa9
	WDgdwtrQT4nncwEGRrvZhNbBNPcJHew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A6BBA5C4B8E;
	Mon, 21 Jul 2025 20:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464E6C4CEF4;
	Mon, 21 Jul 2025 20:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753130994;
	bh=RGpMFousrm9JXr2aga1XoiQZq81gXpkDZQCrU7p8kG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=USwBlGGycUbYKwRlz8H1PUciShFkTuZXfVpLM5MtEpyQ2A97ZmBOIYa0cGOwBplAM
	 P/UloDehuLPGSIqgqNRVeLye3ZQJwvjrIvND/8XbCEE/heb6TuWjlHXRTmnHic7i+/
	 ufyzJfA+Tj1dnxW4WNlS2ijwfnLETqFwratBaRXG4lRw2vboY071pv4Rgj4gG0uneL
	 vJADYIT6M2Sug0BnFp+wdbmKStgy/2g++iMRLOa45PAedgg8EJByYxkT5u6rz9xzId
	 7//OhF3fMircm2SYJfkHca/mWkXbMTQEr5KB9GUZB1xfjt2aV3YLzdWsmNabD0jVLY
	 gzg6qfQMQz07w==
Date: Mon, 21 Jul 2025 13:49:53 -0700
From: Kees Cook <kees@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Roger Pau Monne <roger.pau@citrix.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Usama Arif <usama.arif@bytedance.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Huth <thuth@redhat.com>, Brian Gerst <brgerst@gmail.com>,
	kvm@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, Ingo Molnar <mingo@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kbuild@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v3 04/13] x86: Handle KCOV __init vs inline mismatches
Message-ID: <202507211349.D93679FB25@keescook>
References: <20250717231756.make.423-kees@kernel.org>
 <20250717232519.2984886-4-kees@kernel.org>
 <aHoHkDvvp4AHIzU1@kernel.org>
 <202507181541.B8CFAC7E@keescook>
 <CAMj1kXGAwjChyFvjQcTbL8dFXkFWnn9n47bkN7FP=+EsLNsJdg@mail.gmail.com>
 <aH42--h-ARsvX5Wk@willie-the-truck>
 <202507211311.8DAC4C7@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202507211311.8DAC4C7@keescook>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1CAD9C0003
X-Stat-Signature: fac3xsbpse6tk4xydp3kiq7xqteqi661
X-HE-Tag: 1753130995-39167
X-HE-Meta: U2FsdGVkX1/YVQteK+ScKLFctrKoOLxFlB7Og0GhxgpQVSsWSSH4J8qrqvP9oIxxPTqSH518vUX3iA0beE5+1AT8RjT9CB9Dq3illt23TuB/gLMSp0+jjFkFKG+9VMfXPltIPpUpzbNUOFILhamaf9LIxxz7wv6ehIob5w/jTX8trn7OIJ/FXT4Np7cwsQcZ24YONVP49mhglFSJEYJ42UAC1VH3aU1FDR/M7lhsuwmnPQeJdnTsR3d/YillAMeBJgxc/UkUnmjivwJMgL+WHn3PITUHFUMU46IKYHbC5cEdUZZUzWk3Qzjr+1Ib8XWdLXmekNT7qJcZ4vjjs7LbZbhmlEtUQxcDEnddgKS1k7j0JBb1L70uc4MykkxfhPu80L3kzMPP+w68K+Xkwk6MLZPbhpVc74SRH/hbOEV+CmEQREtp/SMW6obVBRn0+9+R8mifUHmEEO4Gr2xTXH7xKw9cxvZlUeD5k3d6U9YF7NkZxZK3uF0e+BZaXhL5nUFoRxFD/vRfpFbgzEqWHr1Pg2OI1kOb/seMmLwnjAv3ALWbaJt458wN+obrWkidzTBU0+UfVtFod6RnL9lkxSN8ybRrOGgwI0BfZ/qOfb9UVdS15mCZow9zKxltX/08I7pj8WHc2+kGIMxt1FikUkC+yf+uA6yqr21Ph+lL++zV6ywgI8J+0jWoZzdyVjIg6cBct+tmryx+8HTaa11BZaRnbsfGX8WKJ6dLflPA7EyuANAHErLy4o3TDFBW/K1ImWxw3ab3W6PZ8YHQ6ruBx3+fzFaqbDJtcx2QiOj7OcczQHNuY+4W7Za3YSalRTUJ2R0FPCeX06YHJkgNNjBY+7QvPj6RCbK2PGUfayBRS4eV/xM4bSeKf8i1XjzNRzaTv6DgcbZNMCXEbPyMosBqPClKpa/2KTB97Xx+GskfxPYf8T7snFEYnWLgOReWkbspMCo0ifm7p9bcYIfxTJXE2lx
 JxvJjYrU
 O2W44cAXbeUew6ugqDt+GQjLppZw/rDnUwZTiKopCyi8PZwcL4cwRTCs5K1uT6ej41cJQTNeXU4gm7G3z/13Mw18uvWd3dmPyuJjxk7MCVvAHa2IyYHMTZT9CZh1WCVyVWwbNoXBVZToWmDUQks0fovQb27VXWIzg4Kz9wQqcz+5ReUlXOC1A8KwROqMpNyZ++uRHUb/PcB4UeeMuE3Aj3VGC9iyhaxuzC1JX0elo/A2oA/qfhHdltaSzcd0JOSIoB2+29BTvWoKmgBUJppnNU2O9ku3yMFvZlOTxfUikRX8KDUlm1J8Pbyr7u0zTuMJmqUr52Yo3HvwP45uEPIMZd/D9yTBZZ+WRHpN9x9YC8oskfMsTDRjg2qWENlHt+sxuRd2INgt3Xf3yiXg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 01:14:36PM -0700, Kees Cook wrote:
> On Mon, Jul 21, 2025 at 01:47:55PM +0100, Will Deacon wrote:
> > On Sun, Jul 20, 2025 at 04:10:01PM +1000, Ard Biesheuvel wrote:
> > > On Sat, 19 Jul 2025 at 08:51, Kees Cook <kees@kernel.org> wrote:
> > > > On Fri, Jul 18, 2025 at 11:36:32AM +0300, Mike Rapoport wrote:
> > > > > On Thu, Jul 17, 2025 at 04:25:09PM -0700, Kees Cook wrote:
> > > > > > When KCOV is enabled all functions get instrumented, unless the
> > > > > > __no_sanitize_coverage attribute is used. To prepare for
> > > > > > __no_sanitize_coverage being applied to __init functions, we have to
> > > > > > handle differences in how GCC's inline optimizations get resolved. For
> > > > > > x86 this means forcing several functions to be inline with
> > > > > > __always_inline.
> > > > > >
> > > > > > Signed-off-by: Kees Cook <kees@kernel.org>
> > > > >
> > > > > ...
> > > > >
> > > > > > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > > > > > index bb19a2534224..b96746376e17 100644
> > > > > > --- a/include/linux/memblock.h
> > > > > > +++ b/include/linux/memblock.h
> > > > > > @@ -463,7 +463,7 @@ static inline void *memblock_alloc_raw(phys_addr_t size,
> > > > > >                                       NUMA_NO_NODE);
> > > > > >  }
> > > > > >
> > > > > > -static inline void *memblock_alloc_from(phys_addr_t size,
> > > > > > +static __always_inline void *memblock_alloc_from(phys_addr_t size,
> > > > > >                                             phys_addr_t align,
> > > > > >                                             phys_addr_t min_addr)
> > > > >
> > > > > I'm curious why from all memblock_alloc* wrappers this is the only one that
> > > > > needs to be __always_inline?
> > > >
> > > > Thread-merge[1], adding Will Deacon, who was kind of asking the same
> > > > question.
> > > >
> > > > Based on what I can tell, GCC has kind of fragile inlining logic, in the
> > > > sense that it can change whether or not it inlines something based on
> > > > optimizations. It looks like the kcov instrumentation being added (or in
> > > > this case, removed) from a function changes the optimization results,
> > > > and some functions marked "inline" are _not_ inlined. In that case, we end up
> > > > with __init code calling a function not marked __init, and we get the
> > > > build warnings I'm trying to eliminate.
> > 
> > Got it, thanks for the explanation!
> > 
> > > > So, to Will's comment, yes, the problem is somewhat fragile (though
> > > > using either __always_inline or __init will deterministically solve it).
> > > > We've tripped over this before with GCC and the solution has usually
> > > > been to just use __always_inline and move on.
> > > >
> > > 
> > > Given that 'inline' is already a macro in the kernel, could we just
> > > add __attribute__((__always_inline__)) to it when KCOV is enabled?
> > 
> > That sounds like a more robust approach and, by the sounds of it, we
> > could predicate it on GCC too. That would also provide a neat place for
> > a comment describing the problem.
> > 
> > Kees, would that work for you?
> 
> That seems like an extremely large hammer for this problem, IMO. It
> feels like it could cause new strange corner cases. I'd much prefer the
> small fixes I've currently got since it keeps it focused. KCOV is
> already enabled for "allmodconfig", so any new instances would be found
> very quickly, etc. (And GCC's fragility in this regard has already been
> exposed to these cases -- it's just that I changed one of the
> combinations of __init vs inline vs instrumentation.
> 
> I could give it a try, if you really prefer the big hammer approach...

I gave it a try -- it fails spectacularly. ;) Let's stick to my small
fixes instead?

-- 
Kees Cook

