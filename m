Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15215C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 08:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C22D8E0002; Tue, 22 Jul 2025 04:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972B18E0001; Tue, 22 Jul 2025 04:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888F78E0002; Tue, 22 Jul 2025 04:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72A758E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:27:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22F8AC02C4
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:27:08 +0000 (UTC)
X-FDA: 83691220536.27.4A9F90B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 901A74000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:27:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ftIKtFsS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753172826; a=rsa-sha256;
	cv=none;
	b=5tyUDf7x8K92VTMNwb302UhcursntjUOmWCBfg4/LbjGeMp3Cz7r5l+ihDTeGV9+evRPaZ
	+yHDaQiNE8Qbp6Zq+W5KRfCVn1ONXT4/UdM+QXBQNuSVbVHVWUdDIsdASrcc8OHlEOab1J
	c03A7nwJ8VRnOiho4qB2+/dpwy9Trv0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ftIKtFsS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753172826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbOnJHGDVjc2/tyeEkcbXWv/oF5daTXS/lsYhGkGX7g=;
	b=u3sdrx4JHIh+rrUGyEI3co7qd5/Qda2Om5q2ePwgztPj8aWUIbhphEFRfSzp683Y8486We
	00svfZH1QsZoRNDePQ3Buv9RGareR+lH4pIOBOU0tTzpxEztNq1177OeNxPIM7NBL+kY6s
	/pReHiY8vvpoOnEN+DiGjsEw2kyEt/A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 017F7600AC;
	Tue, 22 Jul 2025 08:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A537C4CEF5;
	Tue, 22 Jul 2025 08:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753172825;
	bh=yGkRA/6qnjLPhMkWmaVYag52FJSXvc8HTUW6Y3Xuzs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ftIKtFsS+75DjkESBKR4C/0fTfhjTO5EAQaosz6bDp0SBtC0xu6jrbFmvS+RKsdrx
	 f4dMY3bCIrRdjzyHRTqQ2IS3DbC0aaJA20FDQXMOHNRYWFh4FtQSBKE6qcpYZfqwwn
	 EBlY5p7lMzTdcc4tj5YJJGVzamw8NuZS2DY35/I8OtpLoIXd1OL5/ZeHJymCJvh1YO
	 fQNqEpJ2tIsXeilrIIv/4unMX0gRI4A5tYLUiPoiE/g7dGzpTCnD1Qfrv0OCm/INtf
	 +6BTjWwe4qdBcxVcEwQyD1qD72/jVzjC0CRHbF2sbB7CBVIvfoxl37x9XjTdsKkyQI
	 517UWQRiFJG/g==
Date: Tue, 22 Jul 2025 11:26:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
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
	Ard Biesheuvel <ardb@kernel.org>,
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
Message-ID: <aH9LRgiiXQdABrd6@kernel.org>
References: <20250717231756.make.423-kees@kernel.org>
 <20250717232519.2984886-4-kees@kernel.org>
 <aHoHkDvvp4AHIzU1@kernel.org>
 <202507181541.B8CFAC7E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202507181541.B8CFAC7E@keescook>
X-Rspamd-Queue-Id: 901A74000C
X-Stat-Signature: rx6gjebie49aae79htrpoxi4rr81za6f
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753172826-743942
X-HE-Meta: U2FsdGVkX1+Fir6mPtM/aju/+UZ/f8GQYUWGP6D7sFQ4dbqaR/QMSqVsjj9S5GNaQmcbAlfswq7xebSpZbq+/TstdoUCe8VhXw3wqGR8BdkUv7xM9IqBpFot95FSOEZp5rgHoRMYHErcINPDs9B/D4UyotovdY0KweOtIVRV1LSSxZJFz86IA0PULThfNLNYNDZNQV9CBuXar5vCXX0xGxEWeBRsko4c4Lj8yQ43ynXOUk8OuyaszWnff0VJggDvE3jfSxRXIZBtO7xZo1VEZ56qn4eLhQrEoIg6CN6EHqPYIn0889xua7oS7k5OdFlM9fY31mv878nnI76I+f//EcA37vPm+wr17b0god4T2nWwDFQRnX7bGEtljdWbb5HCLxxYY6FEXoVjixRzSGPen0KY83ObMQ0d3lD5OKe4o68wqPCgdl7kyF+I6BETTOyHK4VQgpRFYN7v3s9ueOG0uzmBmra1htEdHwz97E+sOO+2NLrUiNOs23Q63yppUVnoaaHprh1SNcCzzhUPTGgpWBVN52itFGPVJ+Nid/DrO4zu8gZha797gKyZtN6wLWyARTP8ua0XaeMULLRppjeEtj4KoAXs2wnZLgbxg7i9VycgUet/FAlT5LjetmK1b13D3bm6UNw4rESqVV/Qot+6kXdwG86Gjpm+u1SlTT+t4E1gtFKlSyZrY6OQDjt0HtXHrKOPUr35su6atLd+ah9+I1mJYnsdZ4nbQticjhdqr52PityIGZ7qTFbZ3JsdpIQPm7MFjkwti1DPDtce0Nh6I2C7kBjUYhqa3D28d3pKYxCkOhwaXpTojaeGdrLRay909DSc5sqgyi4c6rBJh8f7TRTuQDQVFEIo7kW+a+E5PxvAmeeh6iXl/tSrKB+YuiknTaM9Ht8npUJycJugO1vb71J4GgbvB9MiNNjIqOkOvEe+2fTLn2aTmlvbbxZXrqvHAsftcRSnEXvgdW8nxPl
 ilX08GZJ
 yosuSU+E4P5Fe0klBelTigkZVT9kqBMBG9Cfaa+SuqmMwAwL5YmkamndMxEVDGOBHzTftS1r2JsuDsB543OtnV10eHsvKhe1mbWHLuMQOIWL0M7XN6nOFtcQ7M1pWCRddVr2jeOv67WAOIRe/PMTBurTFaE1QoCLD/J5+moUguWLAlpfe5factPrLouh6A2KMMwcTiFoeg2xbmVMCd+VYBPQoE73kiWcm8R3r+5fF3ds7Yh92R+9K3Kl1/CJVNdMCSEVPbRvmjs0H2uUIvqmgpb7kNwkcAXHNM3eIF9n/qD7KRD2A7BwSVsMdeV2SJfkXKK7o9p1BcZ85FucpuUlvW1wEW9A0X1ycw/xa38xuNEwgGwzB9nTSSeWfsWv1RmznLCOb/scqKpmkpfA+/No2YmAVVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 18, 2025 at 03:51:28PM -0700, Kees Cook wrote:
> On Fri, Jul 18, 2025 at 11:36:32AM +0300, Mike Rapoport wrote:
> > Hi Kees,
> > 
> > On Thu, Jul 17, 2025 at 04:25:09PM -0700, Kees Cook wrote:
> > > When KCOV is enabled all functions get instrumented, unless the
> > > __no_sanitize_coverage attribute is used. To prepare for
> > > __no_sanitize_coverage being applied to __init functions, we have to
> > > handle differences in how GCC's inline optimizations get resolved. For
> > > x86 this means forcing several functions to be inline with
> > > __always_inline.
> > > 
> > > Signed-off-by: Kees Cook <kees@kernel.org>
> > 
> > ...
> > 
> > > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > > index bb19a2534224..b96746376e17 100644
> > > --- a/include/linux/memblock.h
> > > +++ b/include/linux/memblock.h
> > > @@ -463,7 +463,7 @@ static inline void *memblock_alloc_raw(phys_addr_t size,
> > >  					  NUMA_NO_NODE);
> > >  }
> > >  
> > > -static inline void *memblock_alloc_from(phys_addr_t size,
> > > +static __always_inline void *memblock_alloc_from(phys_addr_t size,
> > >  						phys_addr_t align,
> > >  						phys_addr_t min_addr)
> > 
> > I'm curious why from all memblock_alloc* wrappers this is the only one that
> > needs to be __always_inline?
> 
> Thread-merge[1], adding Will Deacon, who was kind of asking the same
> question.
> 
> Based on what I can tell, GCC has kind of fragile inlining logic, in the
> sense that it can change whether or not it inlines something based on
> optimizations. It looks like the kcov instrumentation being added (or in
> this case, removed) from a function changes the optimization results,
> and some functions marked "inline" are _not_ inlined. In that case, we end up
> with __init code calling a function not marked __init, and we get the
> build warnings I'm trying to eliminate.
> 
> So, to Will's comment, yes, the problem is somewhat fragile (though
> using either __always_inline or __init will deterministically solve it).
> We've tripped over this before with GCC and the solution has usually
> been to just use __always_inline and move on.
> 
> For memblock_alloc*, it appears to be that the heuristic GCC uses
> resulted in only memblock_alloc_from() being a problem in this case. I
> can certainly mark them all as __always_inline if that is preferred.

We had a few of those already converted to __always_inline, so I'm ok with
continuing to fix them one at at time. Gives a feeling of job security ;-)

> -- 
> Kees Cook

-- 
Sincerely yours,
Mike.

