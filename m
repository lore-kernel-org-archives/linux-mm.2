Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98075C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 13:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790A06B00AA; Tue, 22 Jul 2025 09:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767F16B00AB; Tue, 22 Jul 2025 09:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D9D6B00AC; Tue, 22 Jul 2025 09:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5946A6B00AA
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:29:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0FE51DA62E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:29:35 +0000 (UTC)
X-FDA: 83691982710.08.957848A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 303FE40004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:29:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=icCzbYE3;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753190974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rBiQqj/Tcg+yYn70Z3uULhGEZLBEASKzOk/gNIAvos=;
	b=cuSO0S0xA+QiJ6BQMAg6WgyA18vbuzTG/AkBN2flPOO4UD/GUinkmtQ5e3+Uza6y13xDOi
	FE/Runh8dU9qDSAgfhtfv5VdlHttcodKrQv6v2AAVECThQLGGrFfEQrEElmjNST4/5ZXqU
	O3MXuDmF1wpXSvf4T4n5BmzwVzqVD8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753190974; a=rsa-sha256;
	cv=none;
	b=jj18KXEt8AudWSy9ZiBePsoXcYAqA8z0IAVyM920+Cu2/U9tYFQtL6GXTM/E5jFBtOM2eW
	kefDgoey3pHgK1n2L9DHvSC2fQdw3+JVR0nJE8FgE2Emzbo5FFpHkRFYbk/RDLvpWMKy+g
	evCUyUNN/HLXrOVNxoU/uVKC6bMF24Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=icCzbYE3;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB0C9439BA;
	Tue, 22 Jul 2025 13:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B00BC4CEEB;
	Tue, 22 Jul 2025 13:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753190972;
	bh=v5BLSIwd7srHi/OWA5ndIBkdalmEzmLEQmrp+RewTTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=icCzbYE3Gw4FMkjzZQGdd5PRl3DLgwJi4XEJMOcR2bhXW2g1yFhd+T0X/aqMi3/BP
	 CibFuID4nbj6OAYkc1NMOYpqf8N3QkVei13FupO8PIGWwd7LMLFew2Gjxu4KdVUg1O
	 DkTKaYgXxxbbsiX0+w7BLz0w/qJZtmL94y+JVE7CzC9ZZx6kQNyfp3ET4nPZ9scvga
	 Dn2CpPG5UqY1IGli6LRySAYz4YmMRdxPp1TJllyeOcCWdL2WRYt94l/h9D04DE4+Uc
	 MGgZG1jWvtMVVXZVVriPuhmhhcn2IesGNkPl/Ho6XBcy/wvha6uvWcQ0AKEDdQ4Ukm
	 HjjZtlQLlu8FQ==
Date: Tue, 22 Jul 2025 14:29:19 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
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
Message-ID: <aH-SL2V2bSPkJ18o@willie-the-truck>
References: <20250717231756.make.423-kees@kernel.org>
 <20250717232519.2984886-4-kees@kernel.org>
 <aHoHkDvvp4AHIzU1@kernel.org>
 <202507181541.B8CFAC7E@keescook>
 <CAMj1kXGAwjChyFvjQcTbL8dFXkFWnn9n47bkN7FP=+EsLNsJdg@mail.gmail.com>
 <aH42--h-ARsvX5Wk@willie-the-truck>
 <202507211311.8DAC4C7@keescook>
 <202507211349.D93679FB25@keescook>
 <CAMj1kXGoy7D+_hKyQrT_uXdjuFMYGUEMDYdRf6mx69PLeuBQQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGoy7D+_hKyQrT_uXdjuFMYGUEMDYdRf6mx69PLeuBQQg@mail.gmail.com>
X-Rspamd-Queue-Id: 303FE40004
X-Stat-Signature: sh5btj19tmknj4qayqpima1pgfse4383
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753190973-188640
X-HE-Meta: U2FsdGVkX18EnGLaFO5Xwom5q7Lg4lwt8t3/jSHKTaG+AqoPU6Iu9aQaE67tNYyGZC+NV/AsWg5u/EQytv+fRy5cSKa16f/U0AdtVtCPKqjJjY8I1X1OFw9Mn/E6mdxBmCpq9Dtox8+5mVS/LNnb2GGqEcCMRH+3WoLj49UZKhhUJ6XQ6F/9Zw8ZDtD9h64Q4JIMczXbaF8ewpK6jYP8pQIYj1DCLlJUT51mui4ApxhSkC4JPP6QyqEzSE+HBv0pRrxrA3IPqgbCF21Tmku5n5DtI1e3Thtcpjom1fha+Ym5APlRy7z+oEh/b5m0xnQzyiQPQ1xBzmi16/OTAaZgQSRU6mldjKJfXEHBqz7swajgCD0wpR1v37gyL4dJHBUiqc2PQ19FQRV/F7KJBDF/eOxl4saFyq6zzmft7cN+H9dPuFJ6xgNgD6vDH6l665FLGamfMQemAWF74Fx2dWlk+l1sSw/2DJc/pLAeGqOUFw5xRk3h7wsKq1S4dm1UTHzcDTRRGiPv7WQP/Nzk796aj9BNB1LqW2IM71CpghZqjqEZgAadq1qiPSx0ZIavk6NnjF22Vg1jwYRToZVa03VpaOTRaSrNCcRyXZ0gDfxs5ZYrwM6pridzqAYcpcGvpWWh1FPGycV6pK/iQJVl80tIhTPVWFwiCZlZJnXkkXl8YeSzzQUNglJFtN+pl/lLLPdoa99MtGBt9BKeoz5HijY2xMqAPR/uycFqiaNf3NqMUtsIP89OblBWH4+cJWNzusY7Oi6B/1XKLWxxdab93vfVcqyUIU+/i8q7AaydaMtJIffS69IWSYOtuccicHBQ2/wtnZr2CXCJEFG5fEWm+JykQAzwkEHS9DLAV8LawsnWvGSh0JJwFO5fpd4ps1vCp4AQdSOneZL3Fz3r/+46I0Lv4HGhHOeZFQgcGhShKC5CX82ETgSpVKchhyoCych20/JSKO1OnD7CKrP49Fxkygo
 jHKyleAv
 0g4kwRUKeFB2ORsbBEF8HjLKcIiyFTp+pbVkU7T6mjNBR1nhBJdBUpdBd8Bp6CLz8ItNShOBQgL2I0P2MSv6a9XIklVm4p2FoTvWKuauEsSBkoGFs4Zo7bSOLTZnpArZ+RdQ9PLtNLaVAMze9VFY3a+qjvk5aWNE/cGu4UWgo24Xw7/S9szVifwlG/u5NlhzfkuZd1IKHXkQhwvfCzfyz1kVtO42S/uaWgOFBNG6Q+3aYETfmQ88j2vI8smAj/bbKmOJH2Hq1DLPdrc4XPOeWJs5mDiK/6zCOUGKb4Ry8vTgBcVVjuhv7asEyG3RldAUMAnCLllTIFGfCHzhgsXnbvZ1WLSHfL8aIvhXMDnjrv2S5JXguiU2G78HYxg+k6oBm3gDsUQ8DRjA8V+1jhBquiWDHz63Z6tG5ovnuUw9Y92pyFbMvJH4sjGcqOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 04:55:47PM +1000, Ard Biesheuvel wrote:
> On Tue, 22 Jul 2025 at 06:49, Kees Cook <kees@kernel.org> wrote:
> >
> > On Mon, Jul 21, 2025 at 01:14:36PM -0700, Kees Cook wrote:
> > > On Mon, Jul 21, 2025 at 01:47:55PM +0100, Will Deacon wrote:
> > > > On Sun, Jul 20, 2025 at 04:10:01PM +1000, Ard Biesheuvel wrote:
> > > > > On Sat, 19 Jul 2025 at 08:51, Kees Cook <kees@kernel.org> wrote:
> > > > > > On Fri, Jul 18, 2025 at 11:36:32AM +0300, Mike Rapoport wrote:
> > > > > > > On Thu, Jul 17, 2025 at 04:25:09PM -0700, Kees Cook wrote:
> > > > > > > > When KCOV is enabled all functions get instrumented, unless the
> > > > > > > > __no_sanitize_coverage attribute is used. To prepare for
> > > > > > > > __no_sanitize_coverage being applied to __init functions, we have to
> > > > > > > > handle differences in how GCC's inline optimizations get resolved. For
> > > > > > > > x86 this means forcing several functions to be inline with
> > > > > > > > __always_inline.
> > > > > > > >
> > > > > > > > Signed-off-by: Kees Cook <kees@kernel.org>
> > > > > > >
> > > > > > > ...
> > > > > > >
> > > > > > > > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > > > > > > > index bb19a2534224..b96746376e17 100644
> > > > > > > > --- a/include/linux/memblock.h
> > > > > > > > +++ b/include/linux/memblock.h
> > > > > > > > @@ -463,7 +463,7 @@ static inline void *memblock_alloc_raw(phys_addr_t size,
> > > > > > > >                                       NUMA_NO_NODE);
> > > > > > > >  }
> > > > > > > >
> > > > > > > > -static inline void *memblock_alloc_from(phys_addr_t size,
> > > > > > > > +static __always_inline void *memblock_alloc_from(phys_addr_t size,
> > > > > > > >                                             phys_addr_t align,
> > > > > > > >                                             phys_addr_t min_addr)
> > > > > > >
> > > > > > > I'm curious why from all memblock_alloc* wrappers this is the only one that
> > > > > > > needs to be __always_inline?
> > > > > >
> > > > > > Thread-merge[1], adding Will Deacon, who was kind of asking the same
> > > > > > question.
> > > > > >
> > > > > > Based on what I can tell, GCC has kind of fragile inlining logic, in the
> > > > > > sense that it can change whether or not it inlines something based on
> > > > > > optimizations. It looks like the kcov instrumentation being added (or in
> > > > > > this case, removed) from a function changes the optimization results,
> > > > > > and some functions marked "inline" are _not_ inlined. In that case, we end up
> > > > > > with __init code calling a function not marked __init, and we get the
> > > > > > build warnings I'm trying to eliminate.
> > > >
> > > > Got it, thanks for the explanation!
> > > >
> > > > > > So, to Will's comment, yes, the problem is somewhat fragile (though
> > > > > > using either __always_inline or __init will deterministically solve it).
> > > > > > We've tripped over this before with GCC and the solution has usually
> > > > > > been to just use __always_inline and move on.
> > > > > >
> > > > >
> > > > > Given that 'inline' is already a macro in the kernel, could we just
> > > > > add __attribute__((__always_inline__)) to it when KCOV is enabled?
> > > >
> > > > That sounds like a more robust approach and, by the sounds of it, we
> > > > could predicate it on GCC too. That would also provide a neat place for
> > > > a comment describing the problem.
> > > >
> > > > Kees, would that work for you?
> > >
> > > That seems like an extremely large hammer for this problem, IMO. It
> > > feels like it could cause new strange corner cases. I'd much prefer the
> > > small fixes I've currently got since it keeps it focused. KCOV is
> > > already enabled for "allmodconfig", so any new instances would be found
> > > very quickly, etc. (And GCC's fragility in this regard has already been
> > > exposed to these cases -- it's just that I changed one of the
> > > combinations of __init vs inline vs instrumentation.
> > >
> > > I could give it a try, if you really prefer the big hammer approach...
> >
> > I gave it a try -- it fails spectacularly. ;) Let's stick to my small
> > fixes instead?
> >
> 
> Fair enough :-)

(but please add the helpful explanation you provided to the commit message!)

Will

