Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1D4C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8356E6B007B; Mon, 21 Jul 2025 16:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D2D6B0089; Mon, 21 Jul 2025 16:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722716B008A; Mon, 21 Jul 2025 16:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 634DC6B007B
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:14:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD9BE10EC3D
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:14:41 +0000 (UTC)
X-FDA: 83689374762.09.52A1803
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf29.hostedemail.com (Postfix) with ESMTP id CDA6112000C
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:14:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753128879; a=rsa-sha256;
	cv=pass;
	b=yKPNX/FFmKihiBe8EsgGk7KQVsnV9DOLvaaGZyDHYq9YUpWK+XY7QcPTVH3Zasz70DI7Yh
	vTOY142Emi2JJ7gO1FsmjGrqmYPMz7J8n+3/KmUSOvRruKRaaApo5CaWqaOhHgB4B7sxzY
	wbEWZOwvBYsnisitGnxyeNiCUP7w69o=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753128879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/NyKUxBiS0QG5jJhquPTyFd9NQpPurrr/JYyOYtD/w=;
	b=m2SOtVQiwwz4D9iWKHyYOz/uC2K9UIWejcaPECOM4T2mZDTrRDAxh2A4PuVB1eGzN3czr8
	ZT8vjFUYzUUT8nBgIZYVSF1DgDGAwKE3FxwEQK7PjjxeKIdmnGSgjuGZsRABLAAUXcPw/q
	fVytW0szr6recwMrXU9Mrmsu0xdAIQY=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61C731D864E
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:14:39 +0000 (UTC)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33B63C01A7
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:14:39 +0000 (UTC)
X-FDA: 83689374678.17.1A402DA
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9EC6D40003
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:14:37 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753128877; a=rsa-sha256;
	cv=none;
	b=Na8Szs2Y581vroWU4Q63W57hE9cUqMm/1OR2Tml4mailaBvq6dnWYXPL+8nggIGsg9abmy
	HcEZAh43gyTCYoWEUFIHWBTsP9vGXWWzZB1SO+6waapg5UgR9cbtENHKvlZOg8iHLDgBwI
	eDVYIXx3i+uGi1AkW++bm5CK9Ul9ml4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lFAdcpLW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kees@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753128877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/NyKUxBiS0QG5jJhquPTyFd9NQpPurrr/JYyOYtD/w=;
	b=wVmTQKyjTRwxxGK0fkcjruTyNtvdfgOkfvJIpNRogDwmjZIf6nRz7ydKsi75R0N6OYAB0r
	oyhv8GX/Mg6QCnxxGNHtvTuGfor4Ovro8eUdUucybDIYKWb63U0k/3ZX2hM8GOIV2ha1bk
	pyE3JkOdjpUuWTubNtGQxeuyPyggipM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id D3432A55D87;
	Mon, 21 Jul 2025 20:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75591C4CEED;
	Mon, 21 Jul 2025 20:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753128876;
	bh=4r/4nG1qgmsh/c5VG19N2iiUSmLvYYkyHl3DeygcpXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lFAdcpLWaHxUml6OxVBwU6HF1hrXLHYFkb/H/aJEA6dwrS3fNYgpHHD9vBXhtoV4B
	 DnlKcNVrSuy3OpcCNz5sLZixJ87BNNsHf8Wz/iXbKKuKn/4kGIyWtHqBOtZbDd1IXJ
	 HugdwrRmbPiDKguHMjzYQAyiU+QjuAhDHP4sI+9soOwfvMemYiSYDeWbZvGVJV9Fex
	 I+fr6vfi5W5pHpIw/Uwwc0t82cvI6vzhJdTGqyaczDCk68iZYr7Dm3hhNM2Cwu5lkJ
	 0NpKGkTxKOKNy3D+Lz3rZTszczYJyLaRnmSD0gVfod3q27zUYqquJUIShZDNnZldk2
	 WRNb0JXBCq60A==
Date: Mon, 21 Jul 2025 13:14:36 -0700
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
Message-ID: <202507211311.8DAC4C7@keescook>
References: <20250717231756.make.423-kees@kernel.org>
 <20250717232519.2984886-4-kees@kernel.org>
 <aHoHkDvvp4AHIzU1@kernel.org>
 <202507181541.B8CFAC7E@keescook>
 <CAMj1kXGAwjChyFvjQcTbL8dFXkFWnn9n47bkN7FP=+EsLNsJdg@mail.gmail.com>
 <aH42--h-ARsvX5Wk@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH42--h-ARsvX5Wk@willie-the-truck>
X-HE-Meta: U2FsdGVkX19mL5qgLp6CSY3M+Yh+geCbgQd6nKAaDtfds5wXxfTXdOKE7tIkNWK2q3/31tF7VJ0P2UslKPjeFbswqoHyEDUI7h8i8e/5yYT+V/3+VR46fZVd6kPFQkloAFThoGhuvkzBkN7uu2hLh3WB4gccNMqCOgldBBNdNusm74DWDft+Spgnp1BtxwuYAqgaQ7SkmBGt+/R4TLnIgQPNgba1aVDpLRJzq7cR3Tl2bz7esHKD+73h2FWpaaeBBlqlGMaag5mW5jODKNTCs1BJLfMTqqZH++PIFLDxS3rDBIc+2ePeW57NkQsxt8hbfpk6u9f9raTLhHeCnu/yfd8UVyodDAVvAAnVtLvuU0A2TjBM3j6FM/KiMEvTu3R+bzLpNA9TJipFkOx3CO6wpiUHwIgYOWJrYgeZGb9P4oHyqusdlFI++9W4rvOFcycOdA9Zk+8p/wlXJL19HvjDTJBNzAg4oD+PCnI+NijFBbsqU7DImzQaO73DUMi9uODn5ReceYw7QCHyjuPHWDRL8scHq9AtfCWpZLhTE2j9PfEZBuEcGYlfc0Db89lOrh3U10nXBr0XHgLNMfPyKdAh0vxwu06QJ6MVOoCmIQ35lUwDbYknQW75x5Bm4ZVCcVyrAqjwMalrPFj5R/krc+GBpBlWzxNRX63NBh2+8lVHI2wmqvAAQiHOmX7s9ZhxswEr2ngaY7y9IXK45DQOWsLeIVor4pneuGC/UhufGiyNOc8pxW9ms5EypN7VLa8bnkOOEqiwaMEs885qCSCY1/UMmNKobwrwzF0DMtSLEHzqfOAGN45azY8RRDSFlh7IePgaIku+hl/LmvvFFAy6/YFBtI4g44PjHp31WiTLguwrOOXdE53SDevQbjjemWUbBmZBaywUw8gqDaLf1mNSU9yOeQyf1d+eYX/hm7pyO4mkKyEj/ncNQwPXMa8cZ9feQBIkSnGN6uYezKYzU2vPyJp
 7rS0DHuJ
 7I3hgMesl9gHVQt33D3usX7kecYeSE5ealJT3y6nAyARuB+C+7EnVwr35BvHjlVPLG3yc12NVWIMsbVX6P24PJnOsBPur6wtwcFTAUFzJQNFqZ1XhhZUa+/kxH5AYuem1dSwY91JU8vYjoYS6Q/IxjHa6O7wqjNhA5esZF35j5rz4We45nMP9S4brpgf/N0rf/QS4pLQTMGqaIoUSHM0MC6QoodCi8lWRtRv6tyTDMjBgFhzYBxnjcMxGB8vVP36Hmtfh8MSKMEUNhWNFF44CHDB9J+lrRWmy2lG+hIz6CABlLtVp2E10XJND2AjGGDE+QDPwMRH57e3Zp+8eFYH71HJNveNeOME1M2x9HI6Zaa+wEKa+b754yNHUmQo24d2zSaPWOCU6cSC1o/c=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CDA6112000C
X-Stat-Signature: kg4qxecw6srtyx6ma97bio6ax8m6tjhp
X-HE-Tag-Orig: 1753128877-292075
X-Rspam-User: 
X-HE-Tag: 1753128879-340526
X-HE-Meta: U2FsdGVkX18/HEgCcQ4ga60oATZtuQm8uvwA25qDINe/7cYWNx4hmuvSnZvsU01sONjmGYceY/XHF2/SY20p4Tw7lqAar4ltTKlKYwYp3/BueC4Z8zl9f06MMlHEUxIJoQ/vs2hpq1t257r22e0FNl67qBUy6FjkeMR204XkgLN4eR21FEdpoxNOTAsnwpdV0L9xZf/uwRUR3+Tl9xH5v9hYMEPRfwYIOqE8fSiTUFYMyFeQxD4W1sCWnGO9N0T3In+nb3gJTC+2dC9tD4WyeTQEALgiEmP6c8delYOGQn2xqv0fr1JgtCjRaRZ9DsWMBF43BFQVed3zdl76bB28cNgIkQPUu9IQwHxHdK1Qqtb/HN2TKBAVFw0sXBIUzFYynxAR5Mv779yuz3+LoV0h/gyg98s2012rWqaAT+EpnRTHW2Eg5H4Uoz2gzKJi7aXv/QJvOH6LUG3RncSGK2C1E+GSlbP482QKBTPJrZux4/XznPVf127vaH82Dm/jdyntHjJ1JFRwHEQUR5bT0OrTMVkRzAFdYCAGhF0qJsqUph9UNNnSJkwv0uFD7QCzcYet0O6naFya5K6y7/KwvKAgl5XyvjP/uuApP3YmtlQtpZqUvUXho1MCCWtzpgHQbkZFe7DmOGdAhymiWz7J5ZnPnNh0EE+/IIgvvp2hkhkV6u96EHgLU8+vwoW3xzpykWdnim6ryKFRdX37QrC7JPPqHU4v2InRYXPpMUE2w7/2D3Nd6oXcv29PMBfRhlab4OYIiH/VzGSAnag/yZYa1g6S/a5X2DA+UB+6Isj39fpNyEJ+BkJz8j3ZBpl3EZmiDTGWyatwtO3876eDgaGkrbumouu1O7yM6wepv6gPeq/YMgBdgiUeXfy9XVtfqXQv6NYppfspIPYrtoQVV1rMZkXlkuj9u27Qe38RLz/k1Rq9Y0qK6V29a1UKxFCn4L6pvf4UgeVhHzJlGPG2Wi3w00v
 obbSBxTG
 rWtC/A9zrk0c4l4nK2+W0pkb8Gnh2q3Q6gD4tvRNUUKz7Hv3nv+Ci6X/nws315133yuhxgmPpybk8pPxV9FowYn1P655Y6pAfg9WMGI5KwVHEa3No3uSO0pRUa9/vj811UOzOf1/PZXtdIdbbj034826ohylnfbNK6m7zJ5ZKnw9Cgm8M8mmHzUIt/PZsOcc9jXPK/1C1M/2ng0eHZeneTHui33xx+yAPFfVW073oEzMn+JoaAR5wXsjbJq35F0VM6cAEyRp3o4jM104hcWCh23bcuVEuHX9ceygx9Dmi4LPhcwMw2VSqPfPAGMujmRgzvStY9dtRi2EL9lFPdW/FK+dMpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 01:47:55PM +0100, Will Deacon wrote:
> On Sun, Jul 20, 2025 at 04:10:01PM +1000, Ard Biesheuvel wrote:
> > On Sat, 19 Jul 2025 at 08:51, Kees Cook <kees@kernel.org> wrote:
> > > On Fri, Jul 18, 2025 at 11:36:32AM +0300, Mike Rapoport wrote:
> > > > On Thu, Jul 17, 2025 at 04:25:09PM -0700, Kees Cook wrote:
> > > > > When KCOV is enabled all functions get instrumented, unless the
> > > > > __no_sanitize_coverage attribute is used. To prepare for
> > > > > __no_sanitize_coverage being applied to __init functions, we have to
> > > > > handle differences in how GCC's inline optimizations get resolved. For
> > > > > x86 this means forcing several functions to be inline with
> > > > > __always_inline.
> > > > >
> > > > > Signed-off-by: Kees Cook <kees@kernel.org>
> > > >
> > > > ...
> > > >
> > > > > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > > > > index bb19a2534224..b96746376e17 100644
> > > > > --- a/include/linux/memblock.h
> > > > > +++ b/include/linux/memblock.h
> > > > > @@ -463,7 +463,7 @@ static inline void *memblock_alloc_raw(phys_addr_t size,
> > > > >                                       NUMA_NO_NODE);
> > > > >  }
> > > > >
> > > > > -static inline void *memblock_alloc_from(phys_addr_t size,
> > > > > +static __always_inline void *memblock_alloc_from(phys_addr_t size,
> > > > >                                             phys_addr_t align,
> > > > >                                             phys_addr_t min_addr)
> > > >
> > > > I'm curious why from all memblock_alloc* wrappers this is the only one that
> > > > needs to be __always_inline?
> > >
> > > Thread-merge[1], adding Will Deacon, who was kind of asking the same
> > > question.
> > >
> > > Based on what I can tell, GCC has kind of fragile inlining logic, in the
> > > sense that it can change whether or not it inlines something based on
> > > optimizations. It looks like the kcov instrumentation being added (or in
> > > this case, removed) from a function changes the optimization results,
> > > and some functions marked "inline" are _not_ inlined. In that case, we end up
> > > with __init code calling a function not marked __init, and we get the
> > > build warnings I'm trying to eliminate.
> 
> Got it, thanks for the explanation!
> 
> > > So, to Will's comment, yes, the problem is somewhat fragile (though
> > > using either __always_inline or __init will deterministically solve it).
> > > We've tripped over this before with GCC and the solution has usually
> > > been to just use __always_inline and move on.
> > >
> > 
> > Given that 'inline' is already a macro in the kernel, could we just
> > add __attribute__((__always_inline__)) to it when KCOV is enabled?
> 
> That sounds like a more robust approach and, by the sounds of it, we
> could predicate it on GCC too. That would also provide a neat place for
> a comment describing the problem.
> 
> Kees, would that work for you?

That seems like an extremely large hammer for this problem, IMO. It
feels like it could cause new strange corner cases. I'd much prefer the
small fixes I've currently got since it keeps it focused. KCOV is
already enabled for "allmodconfig", so any new instances would be found
very quickly, etc. (And GCC's fragility in this regard has already been
exposed to these cases -- it's just that I changed one of the
combinations of __init vs inline vs instrumentation.

I could give it a try, if you really prefer the big hammer approach...

-- 
Kees Cook


