Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C0EC98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58316B0088; Wed, 23 Sep 2026 05:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A4F6B0092; Wed, 23 Sep 2026 05:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7826B0093; Wed, 23 Sep 2026 05:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3B86B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:07:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 046E4160755
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:07:08 +0000 (UTC)
X-FDA: 85244447778.26.5889256
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6606D20005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:07:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAwdkSD5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790154427;
	b=8q+MQeVJbmN+uxOieThD+ONpXYqi0SC2g0+jLksNFgLtUEMlLuUowmrCojsT9Lyc/yW93O
	HArpkPx7mufuMk1GEp1ypTiZZ+YTbUYYAxge7BrFuki9KTW/FgtU/b+WOSiEwXVKCUAeBA
	ObDBw7oxuVVof3qgVgZwPUcxTJBd+RA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAwdkSD5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790154427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijxX8jmbmIhLUVAlgpu4wGN9OCs93woylxUncz1YJO8=;
	b=b8FlzaPxEAqp/AYhkKQkKB8wnmODFNfGRNgv2e7o1yc5yMxu4AEwxngqT37B0J5GvPWzYt
	fx8iXgtaR20vyuUeQm3KkU6hbLAdWD/rXh7LchiFFR9m3prmrI6PBo7m/ZtEPpfkjK5BXL
	yt1n+qaNWRYoXGv/7MM+qwisT8hoEIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9813F405A6;
	Wed, 23 Sep 2026 09:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF911F000FF;
	Wed, 23 Sep 2026 09:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790154426;
	bh=ijxX8jmbmIhLUVAlgpu4wGN9OCs93woylxUncz1YJO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bAwdkSD5tOW3uSVWxMzm2cuxEOctSvm7upiBz52QQgLh1Fp9Rd2BrR27jhHQIGX1D
	 03FLfGYqnqMpsgrwWg6NuY3wCZsFPfpnaSn7FT0wD73NSlHIvsYvEi/JGXmdHhyYBh
	 Efd2lHjnpvzCYvE6IamlA1AxLWKWSLywhDW2Z+KgjD3ZcL9lyDJcNXeZYMDQpwFfPx
	 WXdI3juP8lJmxxiGyfzOaeA5OwQifsTbNhZfOL7TC941WNds3R6K7uUmYZvvKOCLY9
	 sirrE3GI0tMMCEVeeeA/BxuD/c1QG59rgcina6NubfQn1BvO6FmOYDPEJFO456rfNZ
	 PVwkGIBGoLtpA==
Date: Wed, 23 Sep 2026 10:06:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Jonas Bonn <jonas@southpole.se>, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
	Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 11/12] mm: make userland page table freeing RCU-safe
Message-ID: <arOWZCeV8FrkAvhK@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-11-fe1ad1f1e303@kernel.org>
 <72d1548a-a4ee-4832-b2ab-4bc82f1933f8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72d1548a-a4ee-4832-b2ab-4bc82f1933f8@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 7cp5o198kz45rm8ey4ij95eneazszrpw
X-Rspam-User: 
X-Rspamd-Queue-Id: 6606D20005
X-HE-Tag: 1790154427-31379
X-HE-Meta: U2FsdGVkX1+8KkYSZlzSC/RThmq2EF67Q8urXvYdqaZxOv1KeqN7Y+TUwQkkYwToWTkkfi4YvxtleWyDchkYB5jOFJbR6JKBVHrgb+j7U+Ch0sUBVKLdPOFPnmNyInssPkaW/rDidRld2JofWLh/Hf15dWWxB3wKbPQHDBsXNTpUhoTd3pSZX3s7Rr7mQRny53UM+CAflO/r9/GC89eyO+sPkRS4+fdFfxmzBVqjCVlGDwDELg2cSYHaJAa/wrp3lI/uyaPrsr6YGkLe8dO9uPSnBBP35GL43y6St5Y/V3hW0Mu78xWY1SVAmRk8LmyDrxY979gpfqWBXM9vW0d0Yn7/mEtF0aCKP9vPWbdjsTzA6etOERvYa8BmCBOWLF/UgZkiPfacWRDkHSsTAZnpBEoY8VImvU4YtR7acwiH5N6yse2Qessl8Rrv/h+OMOWLvYq/gpr9TWeS/O4WQ88chYZhQc67YQDrNTvUEngiQwIXFJumJ++uBisFnR4V7F/8kveOZIPU1U4eY493e5xebZVHIv8WiNMfeR4CWrqPgXcN4QNdcwlrBz4AH4hijZ3zlCj8dqlxJ8MWOnuuM6NWc8dmK4cLsJA80S+HUDyxxtt2QPRTFaXPzV9OVIiD5zBmtjvuA6tc1NAKR57VKm8KpLqEMFC5Gp2r4PVh7anORmTFd1DPjWTu2Om4NlH/MTNItuMbjJf+iWGZXyKDOvwb5RD2Bu1cK2Rfk/q/hzNcSXEpsFcW8ptCIhbK+IXLsMnhGMgTChnlbIRpwJGoVkd+VCja/EjYS7IikwbHbZpTYyXH5OkhloJoPNVe/k2s5DGC+UfvvdVWz6ervRakG+bdXZU2YV52tOh8tJCb8MIUZFO0+9XriGvKdlGyJwxRovbPgk2gLOjBgjbYzCbajhX5WYWIgtHZvIwSwc0tXIwUU+h9ItdTFRtq211p2qzhvN2HlSLMlWKfx6kLrt02Utg
 hmv8xyj4
 td56MuJWtWRxDmzbtbWQlhUN9xE47qaO3rXupq9cQZ8VoSDZXi9pNGFjn2RSefIp5PE5/5i6ddsk0l7NUwt+XolpSYmUov/aSo/u8Eyf8CbadE6fs+V/Eo/JXCct9uBJYxUTh0S8HP5Sv2+urTaZdr8o+7sKYsfcpsELnMz+BpB69SSM6m4io0tRc12Vfz5e79CO0kY1+tvKG1rdr0Yfp/AEM08iFp+O/Ltn8fqjSPsbJFT30Y1P+lpcWBC+RKCQX9X7hcQdMVtZcGDeYsBmRv4xkUpq25U11Yed+XZ8hqInlUgUQohtMrCrsUwdQNxg6k+8SSomRJVx65ouJN5UmTLgMm9BlhsJAZpgJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:04:17AM +0200, David Hildenbrand (Arm) wrote:
> On 9/22/26 17:35, Lorenzo Stoakes (ARM) wrote:
>
> The patch subject confused me at first: that's not what the patch is doing, no?
> Previous patches did that, and now you're just removing the leftovers?
>
> Maybe I'm missing something that this patch does along the lines of teaching the
> code to be RCU-safe.

It is the final piece that makes that the case, so I think it's OK to allow
oneself a nice subject line? No? :)

If people are confused they can read the commit message which goes into some
detail.

>
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
> > With this change in place the kernel policy is now that userspace page
> > tables are freed after an RCU grace period, and thus it is now safe to
> > unconditionally perform page table walks under RCU, safe in the knowledge
> > that page tables will not be freed underneath the walker.
> >
> > This is all that is guaranteed, however, so naturally it is still incumbent
> > upon page table walkers to ensure that the page table entries are as
> > expected.
> >
> > Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
>
> [...]
>
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1465,7 +1465,7 @@ config HAVE_ARCH_TLB_REMOVE_TABLE
> >
> >  config PT_RECLAIM
> >  	def_bool y
> > -	depends on MMU_GATHER_RCU_TABLE_FREE && !HAVE_ARCH_TLB_REMOVE_TABLE
> > +	depends on MMU && !HAVE_ARCH_TLB_REMOVE_TABLE
> >  	help
> >  	  Try to reclaim empty user page table pages in paths other than munmap
> >  	  and exit_mmap path.
>
> $ git grep PT_RECLAIM
> mm/Kconfig:config PT_RECLAIM
> mm/memory.c:    if (!IS_ENABLED(CONFIG_PT_RECLAIM))
> mm/mmu_gather.c:#ifdef CONFIG_PT_RECLAIM
> mm/mmu_gather.c:#endif /* CONFIG_PT_RECLAIM */
>
> whereby all files are MMU-only.
>
> Makes sense.
>
>
> Very nice
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

