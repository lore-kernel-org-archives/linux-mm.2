Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF656C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761616B00AC; Tue, 21 Jul 2026 05:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711B96B00AE; Tue, 21 Jul 2026 05:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601016B00AF; Tue, 21 Jul 2026 05:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 332A16B00AC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:45:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABF9AA046C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:45:50 +0000 (UTC)
X-FDA: 85012302060.10.8D4395E
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id DEBDCA0009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:45:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PuVmZcn0;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784627148;
	b=fpfu7tmhYOgjzFEC/ehmOhF9xwqh35BdWYtLUelapsPwPbIiyfEKscZEd+s8MbYU5DKPVr
	GYut+mrSbnIKH4LFFrxiyC2mBMhRpcTGbzwEuRInCQ4e6id7Ws8rj3v85EFobtxXyNI/2C
	o6edw8E4dyhv9icMIuCsDQRkROMHn8s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PuVmZcn0;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784627148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlAqH8OpzhDNUGaMI/yhdZ5tSuc+jcqv1mstlCTQxyA=;
	b=sug12B7oxTDcVnROtFVsHmYhkSUV7RRZIsywN5acqT2n9Mr5iJyGYoLL/Kl/zNNEhoHJWX
	oLDRP8BRQQpBaeRGNiirsjWaMMGL3MzUSdSxcfuEqGC3yBTVGgksGhN7OW4qY4OTY4xFKY
	fOhnkWrSeNO0oU9Y4oNbsbVbJvQTGOc=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cace91f112so113888575ad.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784627148; x=1785231948; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BlAqH8OpzhDNUGaMI/yhdZ5tSuc+jcqv1mstlCTQxyA=;
        b=PuVmZcn0mB57QW+8QpJ3q7Rq6+pj6lW4ZPP2q+33ziQoyrjzd6ehr+vwn+WstGidWb
         3whwdetML6UmpaezJLbAXi3K6uagAJBN6Em/m8T/zMpviQ7CJsaIgaL962vUr0ukTksO
         iDc57jn+o8RspyHnFAlCUTSh/9Da4v6Ks3+4xAWkMRROXYovKnEsIAhf0Zrqlv1GXz5N
         ptzkmJr27+uAbCYGnB+EdXuIxHmQuKkQJ0PRdbXDMSrP8S3DrDOwNMY3as4cgKlkeXxi
         T6WAa5KmrCntWa/d0AfGcZM+qyhOa74Cpleivf6IirpO2ohu50G2vtTvh6DlgEnS0beR
         fvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784627148; x=1785231948;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BlAqH8OpzhDNUGaMI/yhdZ5tSuc+jcqv1mstlCTQxyA=;
        b=e3iLR6+oL9o1th+MfbRDhe4ejMUY9sgLhsDgLr/CnbkDY3zfYYcdv/0c1In9QrSEKp
         oA1PkHhVDdvSry+yO9aSYwQPGzTt8PqhS19MdizaKkrYVq+ds7bKgC/fyADd6iyFpHNq
         yNupylRN8Z86J03Za8/wocaGzBk5oNcW9DSz+z/2NH9SCWB1UiUSGcDmChcnvFCjfUIa
         n4LZnRRekTFHrHuJW1/1WMgEo0SR58/ysWgwcdYrALApuVEbkQqjc5rcJYHacZHhD8lA
         Mdh920ruKaP7BCY3xDa+icBrfMGTaZB/tLLBKrIgQQ6EL2JYlGsCp1gjleIRomm5Yw+Z
         uX1w==
X-Forwarded-Encrypted: i=1; AHgh+RpdSK53JXhX+/nIU9T17sPg5fFHVN/ynYljEiuPVFtCTvpuNIfZcJI7LFhCGrxMgT7L3Zo+yRG/nQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1jrXlXD+TAc1uR//tiT8CBO0Iy6CtflikDd8cbECdGocxrGgf
	Z0CDv4uZmt38wkD0QOZqNC+v3CdpQSa3Q3VLBbGK/nFpYArVX9AcQl1o
X-Gm-Gg: AfdE7ckpJeJWa5IN5JuVCmkwJ5EAaPKu2k46C0FVCZnYhc7TGOyWMzGjGzTMPrCozHN
	eDEXMo16/+yD8uoq6tEYT8EwL9njmPSPWwbA3bWUfZDM69lk/gucUFNxCexKs6Z98XUxjc19pNS
	/WuGMHAK8WTmtrrVYLElH3Qt4zq3HvfEAOAMU9c3Kabf+yOHk/a8z8ceZEnANC40swvv7fOZ56h
	DJ8MGZ3RGrhkwDOTWMB/CwQR0uyHS+y/Vrl8NkohFKtY7T+ZFP/bVjngQCmBiyiG4/E489k3kww
	bEg9m3nuhNrAgToigAiXltBdr2WsLvBSV539NRYbjuRLxVQXA76pxAwijasIt3znFbZ7OybuaNj
	NhvjItRC6LZXZG+FRDxY8Xak2YW5oTNu+DNmelZXJsl4083Zim3f9Bbb2jlOBr1sOyhlnGQdHWU
	p4ZG4uvJWX14Amj5adY+O+IUZvTSpgbUQ9Iw==
X-Received: by 2002:a05:6a20:e292:b0:3bf:63af:859 with SMTP id adf61e73a8af0-3c3ad973443mr18673082637.45.1784627147515;
        Tue, 21 Jul 2026 02:45:47 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1bb8a4sm49625478eec.14.2026.07.21.02.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 02:45:46 -0700 (PDT)
Date: Tue, 21 Jul 2026 02:45:43 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Kiryl Shutsemau <kas@kernel.org>,
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: allocate split page tables as kernel page
 tables
Message-ID: <al8_xx_99BjAUn5A@fedora>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
 <al5-fDRStgU6gjk6@fedora>
 <al5_Le9QlD4zlt25@fedora>
 <al8hE_ded6qyWiDv@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al8hE_ded6qyWiDv@lucifer>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DEBDCA0009
X-Stat-Signature: 4z7e3kz6fgmayqrbrtdj4gb61kfrfbdf
X-Rspam-User: 
X-HE-Tag: 1784627148-648763
X-HE-Meta: U2FsdGVkX1/qwacHxf4tEn4g1lJUlNQOsYq4O3H1MJ4s/nfAThb5/jGKKLNKPNWYrqEyExzNHc+t5CNl8v9feVIZaKCByultF2O6t3UQvUVQpxV0rP36qFNZ0HwbNuaGO4GNYQ34fxYof7vzhOw6LhYnNcJsLe0hxhNPQLSJ+PkWBfyQV8egL/TLnH1PEv9Lxfxv3qwjLKpbBM7ozdeRrXbTyOR+FzUjKq5WNOPQFK9aDkad942KSA9QwsQHIBJdBQdpFr3D4fDPKqIF90Gm3IiWBf9UD9L+R5ZSrq9Gxne/bm7BRiRkLsqvWSdfJbtDn7R4eyCZhTVdkqm+JI74PoC21RFdkooWyJfRXYHPa/XukLrkWHm1LYxb8HIBOB04HQ2+6P6/CSaSLKasqe4DZ4yCwCxvwscJAS4sxgmkzwhuLQa0yGbopeRvlwoiHxa3tZt0Ga1PbyyQBd7cdZPOnWZIU/iLEudFfSbFOq7qxSe/3VM7NfZfW9ZaXA0LulMqMLJ4wc4DRaqcrdUVmesXwd7Ct6n9Y0vzsPkSTNgSEt0CC5CyQAr+8qWlOuTrRUS8Y0xsrGELvz3fw9V9bSe31evYPtceRaRl8rlwU+TA6WTRHN621NQrfIIqL6bTU87cCUJnvhKUaFvvh0uByKwVyR6pN4quwOhwfo+szgTq0kg1jgOSHhtiH4A+Qn7c3xn7jgVDObfrJiraTlWM3YQ73cS4hv299WTRjKtzBEHnNOjySiPCEtthLReewzjn+y6gDJLK0c5O96DseqAyWbBVJwLV8ty7mF9f7eZ1ibbNhrjh6uhQQjDAIlNZy8Tg9njgMhncgi15eilli2oZVMhSdkLAku1ECgXzDsFcIt2wUL9iYYwhKir1pTQNZchpcsycEIWH3Xq+7ehukrfZXCgL3OcYXijDkeH75X22pCtodM0VnghxbsffWZXFJWpxhO7ZsEvbxK+rljy/7tVQC28
 KHghkDDf
 zHkwdA3rNxU3LwRzm00ayAtqaiRX3vErfZkPsxUkuArTMF7BUfJm2GaspnZ4bALSU7Im2iLFGymB+7IdtLYQeFotF+IFTkaHqaOXPc2qMp3M+WyN7te1+Tu6wF1vqkyruo9mpjwPWio66i7wRFrWVa/W9pxfe60qo/VriihkMAsK/aZlx7CzGF3kJi1MUV9S3m1jZUIAN4vDosOLJqqQ2uXN2mfhqIvbU3Zy+Fm+QKcr+zvdIBjfTE7Teuf/LsGQcmNTY/NdZqKyqsBuUIji0+5y4xwOXMAKaQjgxwLz1N4qwCfGdTsFmyKzmI+8eyOdlRqmtsUvq89UZD3Ncq4MVfOxKtE2+c5+b1CPBeTMKV/XAWmEAo94fCjf0Oc2lnwbfGNR7t2cqmUsSvs6iiZrb2jyfjjI7AZ/iDmED9F18eh/c3chjudWyUUMlaTcwxgrfziDWVWeRPfWVaUfOweS/yLKnBBbVtDeT34he16ezd9EiAS2LCE7k8p9m3lQiXcXVFQM8iHW0+09sF2UXTT1WTZJAEE6SzIsSsaxG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 08:43:51AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Jul 20, 2026 at 01:03:57PM -0700, Vishal Moola wrote:
> > On Mon, Jul 20, 2026 at 01:01:00PM -0700, Vishal Moola wrote:
> > > On Mon, Jul 20, 2026 at 10:27:29AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > When splitting a large page in CPA in __split_large_page() we allocate a
> > > > PTE directly without going through the standard page table allocation
> > > > routines such as pte_alloc_one_kernel().
> > > >
> > > > This means the page table constructor is never called nor is the page table
> > > > marked as a kernel page table.
> > > >
> > > > The former results in the folio associated with the page table not being
> > > > marked as a page table (__pagetable_ctor() is never called thus neither is
> > > > __folio_set_pgtable()) nor are statistics updated to reflect
> > > > it (lruvec_stat_add_folio() is never called).
> > > >
> > > > The latter issue of failing to mark the page table as a kernel page
> > > > table (ptdesc_set_kernel() is never called) is far more problematic.
> > > >
> > > > Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
> > > > tables") kernel page table freeing has been batched and since the
> > > > subsequent commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries
> > > > for kernel address space") IOTLB cache entries for kernel page tables have
> > > > been invalidated upon being freed.
> > > >
> > > > Since split page tables are freed without this invalidation, the IOTLB can
> > > > contain stale entries for them.
> > > >
> > > > Resolve the issue by using the ordinary PTE allocation API at split time.
> > > >
> > > > This results in these kernel page tables invoking a page table constructor,
> > > > and thus requires a page table destructor.
> > > >
> > > > Since we cannot assume one is always present (early allocated direct map
> > > > page tables are not marked as such), we conditionally call
> > > > pagetable_dtor_free() if the PG_table folio flag for the ptdesc is set,
> > > > otherwise we free the page table via pagetable_free().
> > > >
> > > > Regardless of which path is taken page tables marked as kernel page tables,
> > > > which now includes split page tables, take the correct route through
> > > > pagetable_free_kernel().
> > > >
> > > > There is a user-visible side effect in that split page tables will appear
> > > > in nr_page_table_pages in /proc/vmstat (as do other kernel page tables
> > > > allocated after early boot), however this is a positive change.
> > > >
> > > > This issue started being markedly problematic after commit
> > > > 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables") so
> > > > choose this as the Fixes target.
> > > >
> > > > Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > > ---
> > > >  arch/x86/mm/pat/set_memory.c | 21 ++++++++++++---------
> > > >  1 file changed, 12 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > > > index 301fb9e77d91..a67ca33b9dd1 100644
> > > > --- a/arch/x86/mm/pat/set_memory.c
> > > > +++ b/arch/x86/mm/pat/set_memory.c
> > > > @@ -439,7 +439,11 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
> > > >
> > > >  	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> > > >  		list_del(&ptdesc->pt_list);
> > > > -		pagetable_free(ptdesc);
> > > > +
> > > > +		if (folio_test_pgtable(ptdesc_folio(ptdesc)))
> > > > +			pagetable_dtor_free(ptdesc);
> > > > +		else
> > > > +			pagetable_free(ptdesc);
> > >
> > > Lets not introduce more folio-ptdesc crossovers, we're trying to get
> > > rid of them :)
> > >
> > > I believe pagetable_dtor_free() should do what you're looking for on its
> > > own anyway.
> >
> > Actually, looking at it closer, maybe not because of the conditional
> > portion? But that makes me think it might be better to just replace the
> > ptdesc_clear_kernel() with pagetable_dtor() in the free function...
> 
> Well some kernel page tables are still allocated without ctor (early allocated
> direct map for isntance), and if you did pagetable_dtor_free() it
> unconditionally calls pagetable_dtor().
> 
> The ptlock_free() and __folio_clear_pgtable() there would be harmelss (no locks
> assigned for kernel page table, and if PG_table never set clearing it is a noop)
> but the lruvec_stat_sub_folio() would cause an unbalanced decrement of
> nr_page_table_pages.

Gotcha, thanks for the explanation :)

> It sucks, but until everything is updated to call the ctor we have to do it this
> way :>)

Yeah that makes sense. Although I'd rather see the condition as:
if(PageTable(ptdesc_page(...)))

We really shouldn't be calling ptdesc_folio() anywhere anymore.

