Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51093C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 05:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57786B019A; Thu, 13 Aug 2026 01:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07C76B019B; Thu, 13 Aug 2026 01:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E636B01A2; Thu, 13 Aug 2026 01:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67E2E6B019A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:31:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA05E120517
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:30:59 +0000 (UTC)
X-FDA: 85095122238.02.BE86265
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A9B340004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:30:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SrKE60uI;
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786599058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRXTmCRot5QcI6faSmaQsj0x028gIwbwjB/VBK+GoXU=;
	b=0VuVQF5QACXRu3CePX7MderNqLK6sVdJ0HvdEXWvKVKXyDhUuiCAVQIiV3edT/+kNG1kOA
	+U8xX3O7ryC7eesKJEcXHe+RHE0ZkgAuFeIamnNo866mTPyY4KQ1kQwtB1T321nPX+V1l7
	BaYcA9IYCJIy4+1B1eSHN6J6V3qH/sM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SrKE60uI;
	spf=pass (imf04.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786599058;
	b=IGM0iRIQh34frseE+h0hmUjWlSE6Ttz3S5HY8Lcgv1k5guHPQqjIHkxft5fs9p1WjLvn4w
	tUaWCuQgCTnKD3MbxOafWK1CcTeB4Sz5y+8yzZHxkDfYt5cjMBgi9q7jrDSBiVKolNqQ6O
	pV5jq1J5EXtVigfMw5hPUTt6dsEGsno=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A97B14BF;
	Wed, 12 Aug 2026 22:30:53 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B16D3F673;
	Wed, 12 Aug 2026 22:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786599057; bh=X+NKUVlHUgJ3ufurYsAc3c38TCMI9lTEYh/79PTkQxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SrKE60uIrBnbijwn35bVkTCswfmosJsNxYIwRXmIDvDEYsUPL/XRaOQw4NTWq9+R8
	 HTXCeA7afpFyAnPj1s0kOuibIeMGDLyy/hm/UQgt+OEqxfzPqBuw/BgmcxyZJ97m4P
	 B3v5HjN56UBmNRhdGR3eqCOkRfuHaef7VMgKMqK0=
Date: Thu, 13 Aug 2026 11:00:53 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC V2 3/6] sh/mm: Stop using pte_ERROR()
Message-ID: <azo46amarknescr2uotz77khpt6zakwex7sb52krsvakrzfdlq@qu2t3ahd4m5t>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-4-anshuman.khandual@arm.com>
 <28c24991-590f-4980-a92e-26c89288cae7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28c24991-590f-4980-a92e-26c89288cae7@kernel.org>
X-Stat-Signature: uwz8fz3bcutm3f4uwfja96s5nitpmnkc
X-Rspamd-Queue-Id: 1A9B340004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786599057-627718
X-HE-Meta: U2FsdGVkX1+++N1+I68jx7UXznyBZlVE2pnrVfdmtIvk1x4lqqPLo0njQovmJuWF4G06OLRlC1o5TMtbCxIHxNn7gZQg/aE5XxKRee7ThDJwg77KgL48jPW148hVHqIZLsiKgXpLZgRuWm0568wy+tEqi6OcpvDBsFCpqTQnXOIPXsDNTYvry2IBB8Vu24QV5HtI56INB6ckR1pSH8brGfdx3G5i0ROMYThkq4oS3KiFPdjh0mMZo+bJDYnzBcpAalG4zs4IgQ/gYKyEkX+myNU1ZmHKFWuM1zl/2CRwyEfHYt2frn3dhzUW1t0T6Ccfdwd5rDi5+S90KX5yG/hDcOGV0xPQxwNBjIFGJOrRlWGGfIB80qcu6xAfWc1//iix0HUcOeIkm4RqROdZNdNeo0WDdndhz/4V7VyVzAGnqm6phmpO+ZRTHi0Gl23Aq+DSMUVlkHjXzparCuh90N/FuTWnt0WQS+aisLuAIbEtbe0LxCZJxPmjseAXzXJxlsFDT1ytPotTQ0cwQRpvg1YI3GuWteCxd4ATT/7dSkf91x2kxtWa7BRgHBAbrX+jej0F8N8Es9yuNFV5bx8xa8ItGlpWZH1IOo307UXeuwjGUsqfueYP/M5gGS282vJ05p8fmyff8wMn1Nfa+GKxrxdj97S5mxsjPXw+YbDE0YXucfnQep0E/0GAba8pCrDjwSSOf9uksR6bsO3DxjM7x6yVbLcXOzP49oosr6T5cWy33t5keCXvPOJRX2GY/FqULvZgjdw0QDlHbux7EZmHzRGkejpGT/ouWK3/z/4E9i78DhVovxmesyfvnRdI4N26m7dqQlQUeCGuKt1/oWDZh6PecSMZIMW6O3aravObiltVd+bPspvRJEUBWYvlCFvfszgJVylxBJfQ8iJLqwaLO6pW6Kw1afrL/ktRfQ21X+uGvxqw6TJ4JjFOY9AOhh975MvXxb+dMXDp/03gE4mjlf+
 HyFC4K+q
 67XU6t5fC+vrfWFPlnsr0yRhou6j7ZRGIVKMPebfUpoiEVklE9iQj2Z73C2aUqBT+r0IShAGYlWkxfL0DOcxVFZjjpbj3zXI9P85PH7Vj7gq0uxw1Q7PYqbSwjufcteBuXK7vGAqgno22TDyoyKR7WxAPHCMyvVRC0aWSNhcTC9qkvjcag9qAmY4NVc6FVjlD/ZWCNdAreQoR8KOfiIF94hjx7WcZhg7bR172mUcpny3hJwk4ukXSoJzdp9YRog/EexcicHkXl5gTmy/EdpCyC/+mCml7ygXPrXILsObQGk8oQuKlZBDSE0DJhsrj/p+HOgr7LeML3TOf60maNLk/YXAzgo74mMFb/ELHzYDFMZPkhwGQZ92OgDjkZxfldqqRQ12xJIiKS3qnZy+jkrvcjljTx1bHlxYganc68cPrELTBWNkyT0qd8XeB5PhWWJOv6Yl1gT6k8Ycn3GqhrOtCIahnVK8CGz5zlA67xo0niZxNBW12tAADcRGulcngjiudhSaAY5NUfD0Se9aCRT13m+CXVvobv/8rgNc8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 01:28:23PM +0200, David Hildenbrand (Arm) wrote:
> On 8/11/26 06:21, Anshuman Khandual wrote:
> > Directly use pr_err() in set_pte_phys() and drop pte_ERROR() which helps in
> > eventually dropping pte_ERROR() macro across the tree. In this new printing
> > __FILE__ and __LINE__ has been dropped because they are always the same and
> > don't really add any value.
> > 
> > Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> > Cc: Rich Felker <dalias@libc.org>
> > Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> > Cc: linux-sh@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  arch/sh/include/asm/pgtable_32.h |  5 -----
> >  arch/sh/mm/init.c                | 11 ++++++++++-
> >  2 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/sh/include/asm/pgtable_32.h b/arch/sh/include/asm/pgtable_32.h
> > index 5f51af18997b..c8eb9a7a4c4c 100644
> > --- a/arch/sh/include/asm/pgtable_32.h
> > +++ b/arch/sh/include/asm/pgtable_32.h
> > @@ -401,14 +401,9 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
> >  #define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
> >  
> >  #ifdef CONFIG_X2TLB
> > -#define pte_ERROR(e) \
> > -	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
> > -	       &(e), (e).pte_high, (e).pte_low)
> >  #define pgd_ERROR(e) \
> >  	printk("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
> >  #else
> > -#define pte_ERROR(e) \
> > -	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
> >  #define pgd_ERROR(e) \
> >  	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
> >  #endif
> > diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
> > index 110308bdef01..b3c7fd84ceb4 100644
> > --- a/arch/sh/mm/init.c
> > +++ b/arch/sh/mm/init.c
> > @@ -78,13 +78,22 @@ static pte_t *__get_pte_phys(unsigned long addr)
> >  	return pte_offset_kernel(pmd, addr);
> >  }
> >  
> > +static void print_bad_pte(pte_t pte)
> > +{
> > +#ifdef CONFIG_X2TLB
> > +	printk("bad pte %p(%08lx%08lx).\n", &pte, pte.pte_high, pte.pte_low);
> > +#else
> > +	printk("bad pte %08lx.\n", pte_val(pte));
> > +#endif
> 
> I'd avoid that helper if possible, so we don't encourage new users.
> 
> Shouldn't we just switch to pr_err() right away?

Yes we could move from printk() to pr_err(). The above helper
just prevented an ugly #ifdef block inside if(!pte_none(*pte))
conditional block, nothing more. Will just drop it then.

> 
> > +}
> > +
> >  static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
> >  {
> >  	pte_t *pte;
> >  
> >  	pte = __get_pte_phys(addr);
> >  	if (!pte_none(*pte)) {
> > -		pte_ERROR(*pte);
> > +		print_bad_pte(*pte);
> 
> Maybe similar to my reply to patch #1, actually print something more useful than
> just "bad pte" ? And possibly also just use ptval_to_str().

Probably #ifdef could be dropped here as ptval_to_str() should be able to
handle pte with two unsiged long elements in there i.e pte_high, pte_low
along with standard single unsiged long pte_low format.

#ifdef CONFIG_X2TLB
typedef struct { unsigned long pte_low, pte_high; } pte_t;
#define pte_val(x) \
        ((x).pte_low | ((unsigned long long)(x).pte_high << 32))
#define __pte(x) \
        ({ pte_t __pte = {(x), ((unsigned long long)(x)) >> 32}; __pte; })
#else
typedef struct { unsigned long pte_low; } pte_t;
#define pte_val(x)      ((x).pte_low)
#define __pte(x)        ((pte_t) { (x) } )
#endif

static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
{
        pte_t *pte;

        pte = __get_pte_phys(addr);
        if (!pte_none(*pte)) {
                char str[PTVAL_STR_MAX];

                ptval_to_str(str, pte_val(*pte));
                pr_err("unexpected set PTE at %lx in set_pte_phys: bad pte %p(%s).\n",
                        addr, pte, str);
                return;
        }

        set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, prot));
        local_flush_tlb_one(get_asid(), addr);

        if (pgprot_val(prot) & _PAGE_WIRED)
                tlb_wire_entry(NULL, addr, *pte);
}

But if this does not work revert back printing both pte formats separately
like before.

#ifdef CONFIG_X2TLB
               pr_err("unexpected set PTE at %lx in set_pte_phys: bad pte %p(%08lx%08lx).\n",
                       addr, pte, pte->pte_high, pte->pte_low);
#else
               char str[PTVAL_STR_MAX];

               ptval_to_str(str, pte_val(*pte));
               pr_err("unexpected set PTE at %lx in set_pte_phys: bad pte %s.\n", addr, str);
#endif

> 
> -- 
> Cheers,
> 
> David

