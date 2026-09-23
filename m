Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC90C98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94AEE6B0088; Wed, 23 Sep 2026 07:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC0E6B008A; Wed, 23 Sep 2026 07:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAEB6B0098; Wed, 23 Sep 2026 07:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 558C56B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:37:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2909A6B92
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:37:04 +0000 (UTC)
X-FDA: 85244825568.08.EEDE17A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0A41040005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:37:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MUYdtQ/r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790163423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7sdWnYxMHXupf7TleaKj2/jZn70aUNOMLwBt1Gu25I=;
	b=EosMXVHHr24vdx1Vkc/AT698xv0yfQ3zx06UE3uXpRgj8KoEp60kWrS32+YR8AW4veXIDk
	sfxnzqj2rfxJCxfQpP0xKSDDuVwgVkRjH1XAOIPHXxd+eb266edWWUp61TLUuSXxxPgDoL
	H986HWh68mvhLIL1PR8Un6tp4lL2AZ8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MUYdtQ/r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790163423;
	b=4Lfyd+rIRxhjzBrLSojiE0Lw8h9/dmtB3rMYAkZ3jXPdPeEsxGkOWlL9c9ntsahCnggenb
	x6s96mO9G8G7FplptLtcnFR6hGVTpN1NNCmVi0uAZoKAfUY31v/11WVq11hQPYKaW4i5aM
	aLkjREbMea3Bj6OyobHFY3BSuQVYMXk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 814F3601F0;
	Wed, 23 Sep 2026 11:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD421F000FF;
	Wed, 23 Sep 2026 11:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790163421;
	bh=T7sdWnYxMHXupf7TleaKj2/jZn70aUNOMLwBt1Gu25I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MUYdtQ/rOOsFntGNDCU8gVljiX41ZOOjVjIa1/R6mHvqEVrHdCvUW00s158m6Rhfr
	 lrTfdsDZHHM+8coQufhdItKT2U0f3KpSO1bXFVK65E8hdX7jqTg0RCXs6dbA/rOsE3
	 hj+OXHPR25h/T+zpUP1sxEFBKfBfbEPENxxtH4NpPA1FC6zBNzSnYJzOsanm0vWeX8
	 zL3hunrW3+GWyBjkcp7ZV4TlKp8Hz5f+x0SToekr1cuh3sa+lEbvI9mBqvMu2yTtr5
	 AR51Ti0FikS+Z02shyQHn9y3MNOVB+cU717LR/sppvi3rpyZsF2wIvQXXwZp2C/8Bt
	 8Q399dOg4bqJA==
Date: Wed, 23 Sep 2026 12:36:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Greg Ungerer <gerg@polyxeno.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
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
Subject: Re: [PATCH v4 07/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for
 m68k-coldfire
Message-ID: <arO5wY1tLAPhJ721@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-7-fe1ad1f1e303@kernel.org>
 <3e6740e3-0515-4e29-9627-f554261daddb@polyxeno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e6740e3-0515-4e29-9627-f554261daddb@polyxeno.com>
X-Stat-Signature: jnk5gb6zzzsmqz68jieyn3szp46kaquj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A41040005
X-HE-Tag: 1790163422-282516
X-HE-Meta: U2FsdGVkX1//Zq7PEBGcUSAVAz4D4X5Nfvf7cmdg/ov96oTT1jxk7kKGORYb8nh79ng2gBvbgkw7FXtLlu2hmuYogEEjMKgrRsBLRgzgQ09iZeQWYPPTQMcAZ0KM2exJ+G5CZnCOMg5Ct75UvwnHGP6n3uOKrjRhHpg+bnCpjpRHhPh25HKkYE3eqld/qTmSJDs/QTb1yYXEkzplU1db3eyQF6cLN6l3vxhjwHSazNvHCd7OIqsz9kBvCPoFkgkG6QIB/A/KPw13vAEtLBL/+eTJ/uZo6HkH0V2H1oOhzDG+iO6zHtI8EKdUusEMf3wzZ8hFIglER9nw6slMt9kXAgxRdjWurY2oUBDqqWOo28vmW0Wt+1BsnFI5L7RE5C/i5t9xXsoiGrSJKwhpv4iQc7pfRdbVaXv0YUATqPF8wjwvvwNXzYFqrXAVSpdxhA3l+ozXdUsZ9SGdpwo9d0PbcPRRBK+RG97/HYFOQb55qCqO6XouyiV1fGPC2J7caLpHWCygr0I/uyaRIzAQzCqgWDDksuqE93HUjQeZDI5NCrr4Qer3lltd0IXwiMevoqr9jmMMDRGKNiq3DA2u1zwSTwY6/pUyBMCQlwZW0mCZw0nOI2MGhD0CDnZcboml0QC8M94yomFvXd5wDmXA8AzZOIJXCoQesGzfooRV68osxDgMFEP7BI3tjzkpRJulGKUBus3ei1XsjrWqfKmVUFgdkQxUJv3s8k2H4sOZ7ErUeYVc2FqYHe6xx7ml1uG49jaH2Xr84vqhG0togLX07Hlfbt1fo5bwyRRVtkxZoEMI8n2jM8kHPpbg7nlPGrD6cksfEruuqg+nhrryjZqZ2SnhBC6ywqTZA0AUbd8gZ3ypG5uBXkkH60X3qdm43jnXwWWFLH092xivsGEL45V4Jh+lABUOCo46UYD9ZjOz8c3F1GAsTlN/ztHr1KWufFQclmRros63cH9KNRMMaLJdsqf
 kDpnJV5p
 fHxf7msXXoaKyFkcyu4ERr8e+MN3x0Io56a1DDkW0as3Q906szs8xaX2xdChFknSPcGEjwDbC31Hgt82KySgoBwAfawfeS6jQSq7s1AnU9uuQCXTTvWiWpMUK9KDfaNKrRDyXANJddUlit7HYrQ9jZe91O0ywqWcNyRd1UsT/KrFyulAo+qWGFh7EAZgEEaI24k/9vLyj/BWLICbmT2/hLFr4bYrtMJUli/VcJQwum89tvrBQxc0amvbXLfUhd7TT2rQf6IWqF2dyqaGqTQbvoqF7eH0Bq352q05g4LoYqdTezch3XPjAVMxo05c40fw6hRtnISFR6qWwJVQNV9Um8zJyJeHRpJD7asmFxjblm6q6rNlaKePnozlFW6GKLsBcGmRghB/jZdItXRAkNTT7+Q1v9DEHy0b8Ze/JBLVQX1mVFqT5Rk8BR7PefYDXMnft30I40ni8bEB5/kY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 09:31:47PM +1000, Greg Ungerer wrote:
> Hi Lorenzo,
>
> On 23/9/26 01:35, Lorenzo Stoakes (ARM) wrote:
> > Similar to sun3, the coldfire variant of m68k uses 2-level page tables.
> >
> > Update its __pte_free_tlb() function to use tlb_remove_ptdesc() in order
> > that, with CONFIG_MMU_GATHER_RCU_TABLE_FREE, page tables are freed under
> > RCU.
> >
> > The page tables occupy a page each and have no odd semantics, so this
> > change suffices to allow enabling of CONFIG_MMU_GATHER_RCU_TABLE_FREE for
> > m68k-coldfire, so do so.
> >
> > This forms part of an overall effort to switch every architecture to this
> > mode.
> >
> > Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Looks good to me for ColdFire, so:
>
> Acked-by: Greg Ungerer <gerg@linux-m68k.org>
>
> Tested and run with no issues I could see on a M5475 ColdFire system, so:
>
> Tested-by: Greg Ungerer <gerg@linux-m68k.org>

Thanks, much appreciated! :)

>
> Regards
> Greg
>
>
>
> > ---
> >  arch/m68k/Kconfig                   | 2 +-
> >  arch/m68k/include/asm/mcf_pgalloc.h | 5 +----
> >  2 files changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> > index e29610fd1240..6b8ec67c86fd 100644
> > --- a/arch/m68k/Kconfig
> > +++ b/arch/m68k/Kconfig
> > @@ -36,7 +36,7 @@ config M68K
> >  	select HAVE_MOD_ARCH_SPECIFIC
> >  	select HAVE_UID16
> >  	select MMU_GATHER_NO_RANGE if MMU
> > -	select MMU_GATHER_RCU_TABLE_FREE if MMU && SUN3
> > +	select MMU_GATHER_RCU_TABLE_FREE if MMU && (SUN3 || COLDFIRE)
> >  	select MODULES_USE_ELF_REL
> >  	select MODULES_USE_ELF_RELA
> >  	select NO_DMA if !MMU && !COLDFIRE
> > diff --git a/arch/m68k/include/asm/mcf_pgalloc.h b/arch/m68k/include/asm/mcf_pgalloc.h
> > index fc5454d37da3..b53ff0950db2 100644
> > --- a/arch/m68k/include/asm/mcf_pgalloc.h
> > +++ b/arch/m68k/include/asm/mcf_pgalloc.h
> > @@ -39,10 +39,7 @@ extern inline pmd_t *pmd_alloc_kernel(pgd_t *pgd, unsigned long address)
> >  static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pgtable,
> >  				  unsigned long address)
> >  {
> > -	struct ptdesc *ptdesc = virt_to_ptdesc(pgtable);
> > -
> > -	pagetable_dtor(ptdesc);
> > -	pagetable_free(ptdesc);
> > +	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pgtable));
> >  }
> >
> >  static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
> >
>

--
Cheers, Lorenzo

