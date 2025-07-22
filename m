Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C413C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 06:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E716B0093; Tue, 22 Jul 2025 02:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EB76B0095; Tue, 22 Jul 2025 02:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDD76B0098; Tue, 22 Jul 2025 02:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD71F6B0093
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:56:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59F331A02D0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:56:04 +0000 (UTC)
X-FDA: 83690991048.21.5377DA7
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5AACD40006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:56:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CpfcgUnu;
	spf=pass (imf11.hostedemail.com: domain of ardb@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753167362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBGgbxt8MKz5LketeO1zUYFxZOLJFPQlwgRW6vu/bXs=;
	b=KqMzLQjhy6NSoHEC8IIys7Lcr34dtREZsOkIwvwGx/f1lC3OtjLlUdvzSITFC0iNL/Xook
	vagJecDc2C/G1vXNUkHwMP5CEGUUEslsUpp/HfFx2EYy9A6bREZ9jalG0BzTxtKkQJ4LFt
	bo9pMmlD8dFsqN3TPALFR+ygq0KgSQs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753167362; a=rsa-sha256;
	cv=none;
	b=M57UBoa8HHN50zVc8O6QaTErxIjwVHPACYzodFIs5W/5E0VnqaJFva77xJ/OJhwpt9Nf1j
	ntvA2Q1NgZBrXxIuDVVfnNuSL8g49wf4GoYsyYv1U8E7gPjzNWwiq/IAY2pjHenYeybr+r
	Z5wGs7tut9DGGVDsZFTrJdKiLsrQRR8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CpfcgUnu;
	spf=pass (imf11.hostedemail.com: domain of ardb@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 4DB535C5F3A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC33C19425
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753167360;
	bh=DqE2r+jnLUTL7QjlcN7tboq45VqA22jH4eIVD8o4Gmo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CpfcgUnuDL0Vl921O+6i/yShR++00pNLOKABN64TGoQv08s4JWDaq5R787TzRwPYd
	 SOxP3mvcTg3o5UodLqlybzcfO2KW0UIPKod6tyjXn4Q6f0Jg20Bo4EcbVyst6PFIeD
	 9wwLag5HZhkuEkGdG4rGL0/xDa1dd1XF4wE0tl/b+CrzT64kGYr4RZg1sRlNLV6OW9
	 D1EcUuEM2t8ys5AutC5biwDJeSbkbVn8adA+/943wMPAxGJivryo7aGbp+SI8Q2V02
	 kg6rNPNzOZNNl41J5VZzJI8EAO2Ut8rnz8gAHCFuXdd0jodm+XgB+V+DD74LOgNTj5
	 FmJF7Vu5xhdxg==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-32f144d0db8so26720351fa.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:56:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUBXA3JGFWL33I+nhgKfNMuSMt3XYbYZXMtu0q+tfJBmAOR/6vc6sMfq8xmBJouApLl16QTVl9Uhw==@kvack.org
X-Gm-Message-State: AOJu0YyDWdjIVXGTZefMWidZfkqFc1MoznN0QJi7oHK2RpUjFH4tSfyx
	vDEX4u62ku65c0reexErrzfwDpw6dOsuKdrS0v+mgH0pY0OIOy7SZ7VGelGtZJ54EnXUgtg1jDo
	sSU5/ziErbahVqtUQvcOe57MGmXy1TrM=
X-Google-Smtp-Source: AGHT+IHafl72rt/goLHslFsPSeMLrUwjaR0SoHeFAxURGVfbf4gcV3AlCo9M3FCJzrvPSuMBFqrA7K/+xkn2H/6KxwI=
X-Received: by 2002:a05:651c:b11:b0:32b:952f:3e0 with SMTP id
 38308e7fff4ca-330d25506d3mr8241951fa.7.1753167358762; Mon, 21 Jul 2025
 23:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250717231756.make.423-kees@kernel.org> <20250717232519.2984886-4-kees@kernel.org>
 <aHoHkDvvp4AHIzU1@kernel.org> <202507181541.B8CFAC7E@keescook>
 <CAMj1kXGAwjChyFvjQcTbL8dFXkFWnn9n47bkN7FP=+EsLNsJdg@mail.gmail.com>
 <aH42--h-ARsvX5Wk@willie-the-truck> <202507211311.8DAC4C7@keescook> <202507211349.D93679FB25@keescook>
In-Reply-To: <202507211349.D93679FB25@keescook>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 22 Jul 2025 16:55:47 +1000
X-Gmail-Original-Message-ID: <CAMj1kXGoy7D+_hKyQrT_uXdjuFMYGUEMDYdRf6mx69PLeuBQQg@mail.gmail.com>
X-Gm-Features: Ac12FXxN7NYW1J5gsbL-uJ8eWKShqoH6QBvGfux9lCX9EcW_ZhNmDxq92IzpXG0
Message-ID: <CAMj1kXGoy7D+_hKyQrT_uXdjuFMYGUEMDYdRf6mx69PLeuBQQg@mail.gmail.com>
Subject: Re: [PATCH v3 04/13] x86: Handle KCOV __init vs inline mismatches
To: Kees Cook <kees@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mike Rapoport <rppt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Michal Wilczynski <michal.wilczynski@intel.com>, 
	Juergen Gross <jgross@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Roger Pau Monne <roger.pau@citrix.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Usama Arif <usama.arif@bytedance.com>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, Thomas Huth <thuth@redhat.com>, Brian Gerst <brgerst@gmail.com>, 
	kvm@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net, 
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-efi@vger.kernel.org, 
	linux-mm@kvack.org, Ingo Molnar <mingo@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas.schier@linux.dev>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	sparclinux@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5AACD40006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 5gx4pc4gzs5rjxwf7afugmr8bcubntqg
X-HE-Tag: 1753167362-168923
X-HE-Meta: U2FsdGVkX19yZa+VqqiPsFdsi2fBflNdpb6364Mk9few6AqlDCUHKBg/HQZWcBPF9sF8aDYphqOje8KS1dpMITAVJxXu4AcU/j5yA1P0Q/Ckctw/OLKUdJxdVwj4RKmh8mxvRbEJfYuXLXumw9OsD5yBi1jDNHUxfAGyzJnTTDZ5pTnsRd5UpySu6s3pS1FreRLTrQVvqJJTiPgc8WJcrhZflXxod7+hgRshskn0btTkZIkjlWZkjhs2ec6OiWPpQd7z60BxGYXwUk07m/HPtNNRuSZ49fjePp3NmrRmtwhCAxUbOpuO3So3jOeEih/d3WJl8/NctzYgWH/XvJtAoO9Vvpqj8VzaD+9SNafcLEuiOGlZ/lZnaRRWdrWu6S+LWpWsVGr2R2tJl/11C53LQAwFknR07G4nPrnmynf+QDDKRSsXdoDe1DV7KkPJuIBQEvHYhdCb568wHEQ+zxRU3IsLsQPiruVOkh5M4fZ5PIkum1uzg4Hs1uNSdRBl+4YDrmadeMBqHV9drGs55couABjFR9bPRHHpuVUjKDr/V4c8pNIenrkS8viYuFIJwcQrfQ7Lyi0L8Y0LMzFsbAcXLzU9Lhyut3/R9t2CCnrrHM1I3QvwdT6/fq2MTJhtIG1IjNPiOjTkMhxdUbX+hs+UFUni0zVfNHtwmhPjSjZwa357fo5PMzvEc6o1Xx4ZLllB3UcVzLtTI/xWrfM1lUEyNRJo9K4qV3bM9TRc4tl0ewgcJ3TT8hLIVzM0CCYUowdQrkehwIgRxfCD0Z3KewZqq/u90EtUhejSYoWvAnt3xh1iK98E+t+y9tk4Jvf8RlUBm7z71tz6P0j+MnUac6EGr5IA5rHkpf4JkjulEeFN4LqcQMyOlr8SNoopR9ND/CphgLV2O4OZ7GHos4EKSqfArs0gHzl6/QF95KjkTovzIHUMl9O54F8HeW31Q1UZHW4auszr982MIrlQC62gpRV
 hWan+nsl
 ALTeB7utdCZFeVt0BuOv5vqbisf1EagkU0pSKaZw2Ctso4YuCYR9TGqMEjRmjJQN5iNIHFnj/PQQNhuWm+NTcmx+8D92Lpc7DEg0OfOXuV9ecmMuVYku9aM80q9mb1vo9JTyqGwebCTzwCMVRyeP7bX8PJWKKZruHUPe7vDVnxL1cSo1mO10d2XH0OqWHHUVok9ClnNLGfPWkkjygqjen+2nsEd69ymljqTO0xFD6ynpqRoutup3/tUQ8tLiXvPzsQeXQ+lQBGQ5Ld4RnqXCHmJ3lLgvNc7+btbDg1W8YfVQBqCETxccHN7d/wYOM9fqzZ62MnsJJbVj4ScezAdZ5wHHyj+6sGAdwkargrpvcyeam+oTTE0r1C/41ICFlWmbKzbhJj8CXsHi3BK7FCc34zwB68WM8Rp1nmLlZgu0S9m/VXz4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 at 06:49, Kees Cook <kees@kernel.org> wrote:
>
> On Mon, Jul 21, 2025 at 01:14:36PM -0700, Kees Cook wrote:
> > On Mon, Jul 21, 2025 at 01:47:55PM +0100, Will Deacon wrote:
> > > On Sun, Jul 20, 2025 at 04:10:01PM +1000, Ard Biesheuvel wrote:
> > > > On Sat, 19 Jul 2025 at 08:51, Kees Cook <kees@kernel.org> wrote:
> > > > > On Fri, Jul 18, 2025 at 11:36:32AM +0300, Mike Rapoport wrote:
> > > > > > On Thu, Jul 17, 2025 at 04:25:09PM -0700, Kees Cook wrote:
> > > > > > > When KCOV is enabled all functions get instrumented, unless the
> > > > > > > __no_sanitize_coverage attribute is used. To prepare for
> > > > > > > __no_sanitize_coverage being applied to __init functions, we have to
> > > > > > > handle differences in how GCC's inline optimizations get resolved. For
> > > > > > > x86 this means forcing several functions to be inline with
> > > > > > > __always_inline.
> > > > > > >
> > > > > > > Signed-off-by: Kees Cook <kees@kernel.org>
> > > > > >
> > > > > > ...
> > > > > >
> > > > > > > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > > > > > > index bb19a2534224..b96746376e17 100644
> > > > > > > --- a/include/linux/memblock.h
> > > > > > > +++ b/include/linux/memblock.h
> > > > > > > @@ -463,7 +463,7 @@ static inline void *memblock_alloc_raw(phys_addr_t size,
> > > > > > >                                       NUMA_NO_NODE);
> > > > > > >  }
> > > > > > >
> > > > > > > -static inline void *memblock_alloc_from(phys_addr_t size,
> > > > > > > +static __always_inline void *memblock_alloc_from(phys_addr_t size,
> > > > > > >                                             phys_addr_t align,
> > > > > > >                                             phys_addr_t min_addr)
> > > > > >
> > > > > > I'm curious why from all memblock_alloc* wrappers this is the only one that
> > > > > > needs to be __always_inline?
> > > > >
> > > > > Thread-merge[1], adding Will Deacon, who was kind of asking the same
> > > > > question.
> > > > >
> > > > > Based on what I can tell, GCC has kind of fragile inlining logic, in the
> > > > > sense that it can change whether or not it inlines something based on
> > > > > optimizations. It looks like the kcov instrumentation being added (or in
> > > > > this case, removed) from a function changes the optimization results,
> > > > > and some functions marked "inline" are _not_ inlined. In that case, we end up
> > > > > with __init code calling a function not marked __init, and we get the
> > > > > build warnings I'm trying to eliminate.
> > >
> > > Got it, thanks for the explanation!
> > >
> > > > > So, to Will's comment, yes, the problem is somewhat fragile (though
> > > > > using either __always_inline or __init will deterministically solve it).
> > > > > We've tripped over this before with GCC and the solution has usually
> > > > > been to just use __always_inline and move on.
> > > > >
> > > >
> > > > Given that 'inline' is already a macro in the kernel, could we just
> > > > add __attribute__((__always_inline__)) to it when KCOV is enabled?
> > >
> > > That sounds like a more robust approach and, by the sounds of it, we
> > > could predicate it on GCC too. That would also provide a neat place for
> > > a comment describing the problem.
> > >
> > > Kees, would that work for you?
> >
> > That seems like an extremely large hammer for this problem, IMO. It
> > feels like it could cause new strange corner cases. I'd much prefer the
> > small fixes I've currently got since it keeps it focused. KCOV is
> > already enabled for "allmodconfig", so any new instances would be found
> > very quickly, etc. (And GCC's fragility in this regard has already been
> > exposed to these cases -- it's just that I changed one of the
> > combinations of __init vs inline vs instrumentation.
> >
> > I could give it a try, if you really prefer the big hammer approach...
>
> I gave it a try -- it fails spectacularly. ;) Let's stick to my small
> fixes instead?
>

Fair enough :-)

