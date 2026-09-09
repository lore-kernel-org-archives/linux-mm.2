Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1DAC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF8D6B008A; Wed,  9 Sep 2026 12:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F8B6B0092; Wed,  9 Sep 2026 12:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1756B009D; Wed,  9 Sep 2026 12:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C74CE6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:44:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 637EAA02D1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:44:44 +0000 (UTC)
X-FDA: 85194797688.28.9AC665F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D037240003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:44:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SvkfUBrj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SvkfUBrj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788972282;
	b=KoA/vf7fMau2pdhDbhZXVr3WUpvZw6LWZMYCND39o7I94emFEVPgt7+YlJ/WTUzUWV0GZx
	GpdKdokXR37vufP8Q/UDTlB9eXAyxEIXbBfShT0IfVVv+WDiTeukfXlrEZ0awCYXIwj0XI
	BEUA42JsyULZ1byeb5H7Rt73/UIh8tk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788972282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bapc0YSkMfnvYk3VlSbyVwcwaxlxEF/qdP5fqXt2FVU=;
	b=Q/o+fOYtrQpC/Nz2td0Qc/JeXQST2jmPPrhni+1tRUg0LRQYQOzsLfRB2RMobEj2ygVVJ1
	EpKNKiRqHoRV1bkl4I2lcrNJDQjLbpoOSPLomac9Tw09uGcnq1VHPqD09VXphqCYqaQdVT
	bmiB4ASTjH/K22k+QRfnEz4e6I6nhcU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A729F60202;
	Wed,  9 Sep 2026 16:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14881F000FF;
	Wed,  9 Sep 2026 16:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788972281;
	bh=Bapc0YSkMfnvYk3VlSbyVwcwaxlxEF/qdP5fqXt2FVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SvkfUBrj+qqUCItjJr4thxIOtrO+WmcNQus9iN7o7fjn21Kjri7ciOsZZbXojK8eq
	 ebmrsmEhjQ8lMe6NScH5NJJVO7FkHjSrPlMJAzs9SeDQJIL0euxfAANelWLDPoYw1X
	 CcSIvP/FGlOivDpnH/QksUP428gC7WgcKMjXSRAyqMHuiTJd6wYCdFyF9iWecTST2l
	 DPfn0SayJdOumRm8EjJ0YaCf7wOVn5AtF52jH/K7lyYBUkf1LvlE8O39pf5s+r01dw
	 hpz3MZmyVQYZqDR+4GQ6n1zp4Q8/XwEUokZ3xCVu0XLtYHfY7rf+QXRgnY7M4GG9HF
	 fN2FuuSzCKwhQ==
Date: Wed, 9 Sep 2026 17:44:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, 
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v2 11/12] mm: make userland page table freeing RCU-safe
Message-ID: <aqGMqVxJCWbZePmW@gremlin>
References: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
 <20260908-rcu-pagetable-freeing-v2-11-1f60b64e878e@kernel.org>
 <aqEivRP0LmJZcgEx@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqEivRP0LmJZcgEx@thinkstation>
X-Rspam-User: 
X-Rspamd-Queue-Id: D037240003
X-Stat-Signature: osxbe41brcaf5hxqq9eub8fgo36xu14z
X-Rspamd-Server: rspam01
X-HE-Tag: 1788972282-708623
X-HE-Meta: U2FsdGVkX19ZXqj3rXr+QT0E7f82BKXOqI+/FM87iZRnamM55GitXEzxN4+jAra4QYc+tCIABJQG5MjUMVuxq3sRtXN87fZYM61OxaPPCJPiCpzG2oVxjZqv/NR2TAQjyoBwn6BLKWeLzsCE22LZzOenyp6W9YaPVaY3qR/93gN2sW1Tqpfbs8Mqzl8n72w/fL53MeVizsdbH44qZqUn3p3ZIvKCy1nk6olIS7wDJ7/CWnzQT8yM6Vrz99rNqW9q3EUaAhVivaafcwfetNGsl1wsx309J6S3c0tEKSyVLI5brogxiEjzOeRjs8CBfzy3kBFKHjxoFmiGOEWLas37Cra9Y3RRXZfJS8e0TPHMYumjtvLs6Qpwupq8bh1knh/hF+pcnPfRCEuw+vrz1J0WLPnojafaR8JX/joXXJLDnHb0ptmrTN0gQ+4vsTlo05yFmRP2+KV1XCDP4DMXoEzb/i61zo4IMrpXP5vaL/8lPrrbV6+EjLks6PUzw6MR9AEPbOARPwbXrT/FdpKlRdMGDnepyUTpmRjv7f5c3ZQOI8myj2FwVGfFpdYMl/l0Tt423OkVgS2ORYsDm2NuYq4Y0Mijzba9bpIqm5PsGKQi1RvNEmsqbd7NSGdlVGQsn4ir32sankOgGa8AYzJWZleSvH0V7Ki0uAO5g9/zudXV1Nuh55XbN5cKcZ3CLr/ozKrr9XL3fgoQzpHJE/PwFv83hPACj7+e8Ic9+CKhXYWThmyCP89UyGpWGQzzY4GyjAiiayzl4tO+x3dB3b9DdrXfwCHCDHhcMpHv4zvVsRulEApdzXTVIgSNkmRqEbEyPwjUvRd+aY1RufLIG4mwln9Sm/aCSbRFJoRdZvxRl8hdUeDvT6NuQ1f37f/M75LG2BpciLL19/gnkiqM5m33qSXHnIrhY8iWjf4dsXUb1LSEmDGQlfmXlmalTfhoSbRVOjfzJq0shfDD7HxwGDVNcfA
 udpzUz1v
 EeVZwgw+OdcMT+Rg6RGrkWkCUcqsN0nDwaWm/6BD8VqX9moYZhXq7mEQn2hUFBMr8dJ9HSuStuxOlSzRedt0o/zfsG23Hov2IARQLSUwnkAKSmYwTiAiOnfaz4chZ7V4Osk9NfnZfEvCqIIBkyKid1xJpatuyJBc80WJqUthuY6+qxAZw3B9P84sX5iWy2KQOV6GvvrIxewlKiBcL5Pcxn0XTUWKJRpM4zr1EgMZgL7GxwDabqUAB3kRPXJCDoPilrdzGX0bfhgDYECsuwI9EpGczNSH2d0RxutvkeZQlgxnyRhS7Vd98HH+YGiecN9DFV9LT58hHjK5EeSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 10:15:13AM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 08, 2026 at 01:32:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Now every architecture has been converted to support
> > CONFIG_MMU_GATHER_RCU_TABLE_FREE, this configuration option no longer makes
> > any sense to keep around.
> >
> > Therefore remove it, and remove all the dead code that existed for
> > !CONFIG_MMU_GATHER_RCU_TABLE_FREE architectures previously.
> >
> > Additionally, CONFIG_MMU_GATHER_TABLE_FREE is no longer necessary, as all
> > architectures instead use CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE when a custom
> > __tlb_remove_table() is required, so remove this too.
> >
> > A number of architectures only enabled CONFIG_MMU_GATHER_RCU_TABLE_FREE if
> > CONFIG_MMU was set, however the mmu_gather logic only actually does
> > something meaningful if CONFIG_MMU is set (mmu_gather.c is only compiled in
> > this case, for instance).
> >
> > As a result, there's no need to gate any of this logic on CONFIG_MMU
> > explicitly.
> >
> > CONFIG_PT_RECLAIM however does have a strict dependency on CONFIG_MMU, so
> > make this dependency explicit.
> >
> > Additionally, correct comments to remove references to non-RCU page table
> > gathering and make it clear that this is not 'semi-RCU', nor has it been
> > since commit 1fb3d8c20bfa ("mm/mmu_gather: replace IPI with
> > synchronize_rcu() when batch allocation fails").
> >
> > With this change in place the kernel policy is now that all page tables are
>
> You missed s/all/userspace/ from v1.

Hmm I thought I got this... will fix on respin!

>
> > freed after an RCU grace period, and thus it is now safe to unconditionally
> > perform page table walks under RCU, safe in the knowledge that page tables
> > will not be freed underneath the walker.
>
>
> > @@ -151,24 +148,15 @@
> >   *  This might be useful if your architecture has size specific TLB
> >   *  invalidation instructions.
> >   *
> > - *  MMU_GATHER_TABLE_FREE
> > - *
> > - *  This provides tlb_remove_table(), to be used instead of tlb_remove_page()
> > - *  for page directores (__p*_free_tlb()).
> > - *
> > - *  Useful if your architecture has non-page page directories.
> > + *  Page directories (__p*_free_tlb()) are always freed via tlb_remove_table(),
> > + *  after an RCU grace period (see mm/mmu_gather.c).
> >   *
> > - *  When used, an architecture is expected to provide __tlb_remove_table() or
> > - *  use the generic __tlb_remove_table(), which does the actual freeing of these
> > - *  pages.
> > + * This serialises against software page-table walkers, including architectures
> > + * which do not use IPIs for remote TLB invalidates.
>
> Indentation is broken.

Ugh I thought I fixed this before I respun too, doh!

Will fix.

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

