Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE772C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542916B009F; Tue, 21 Jul 2026 13:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51ACF6B00A0; Tue, 21 Jul 2026 13:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430BC6B00A1; Tue, 21 Jul 2026 13:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 041146B009F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:06:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 785B4A088E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:06:10 +0000 (UTC)
X-FDA: 85013411700.27.0FDB67E
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id B13624000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:06:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Loz26ujj;
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784653568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaZs0dUksz9lWWombvtYA7KfGwaIYElA59FlH0y/uOc=;
	b=x0vsqocDp95xQXMRDT7NILDLIbvKAsOIyxxYOudFVf0Ho6IQlFdI+sF/goZohNwRURh5FQ
	9q8h7BlrR5KO3wfr2LeTJTviLMLmsMqG2itIIG3Zg15lOpn2wtTcgDdOkudhsmJx9n7fh3
	ss7qUe/dJV4NAWktroSXbMMU9UUavOo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784653568;
	b=1abLj43AQShsMw+jAAbgC3NOW7kRSywRj/LoZttDHpj8y6RQ3kppGPffwAlYslZcuzTjPd
	+n7Hw0hqtZAJnn+9f/ZHGYvA1fiTwko/QJLvle88dN8ocDiBwrvWrXv7YMKf02Erkxscjs
	i93iWRkuOc9+0nfT03a3V/FGCOGCE2Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Loz26ujj;
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-381216921aaso11020531a91.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784653567; x=1785258367; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UaZs0dUksz9lWWombvtYA7KfGwaIYElA59FlH0y/uOc=;
        b=Loz26ujjz5Qulea7U0nIjt7h4Cv4Mty1417dyoYqmQEsr5ppL9iqS55hwobcEvhmJB
         NerJ+KK2nZ5RYhOlk0GKsYX0hTEV7HGHqUSSASurJxguguxnXmAMdbyXZATub/61wn+X
         2UW141QceSWy207D0RM43q8QrigGOZWyNU9o6bfmmmoFvFQeoXA+KV+sHq0QM6pbxAdA
         kW//UD89OZ2kQ1/QtG01DrwAdWEk7p0LXUYR8u3mdlOBEdDe30CxVWXmYuMrPRQWZWbc
         lsprdPuKbSvLrmIv9+BIKUj8CZ7ZmqPNrJ5CEyC0SMxlNRgrMdxu45d0hyvOHg7p67uo
         gnPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784653567; x=1785258367;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UaZs0dUksz9lWWombvtYA7KfGwaIYElA59FlH0y/uOc=;
        b=iDBixklLZsqxDoM0gEHOrILS3+EwTYJrYXPzyJ5f387dK/cxX/Oh3AvcL/tOqihRG2
         rmWHeA0NFGeLeRjqMbbEwD5acYzDh3zENJ4BX7FTHUTEjlBzk0Jvt03xBABtl0G/ylAp
         fr2h/rT20bW6QS4z6mp/AUR9m3p+j4pLo+6ZXZgCKx7DAhgnzhjQp3Tzym4U+BK8mhfh
         UuL6UL1OC5rZYZ3llZ+KNfDD6ug6u1D1EE37T5tNJV2qATcsAbdXfsTnISUh4nvN3L9N
         Yy7R3AnYjgmgOs6d+K9PpydRNhpFb4HlaQ0iML9+IaWRk59iMrOehGQIJadgjsY3tFZ6
         Eypg==
X-Forwarded-Encrypted: i=1; AHgh+RoxvBQWa5QcTpBNnZyIepUsk9xJutUTm6ntuqXvxBnE1KSTdI8GSZ8qLL3N6oVjGgM0YyK5s9obdA==@kvack.org
X-Gm-Message-State: AOJu0YyVG1y4kZh6SloF/2E7bXKVWLi1PpNYfrqR5xQjJbFFQnviRUyl
	3GIaeq/+2rHAEpwKnsbdOJHAdQ40qEUR1Iu0314yFTigw2lp/Yr2tCWTAO4kEjjI
X-Gm-Gg: AR+sD12gPAPj2WGAPFu4nSQBCILdHb7XiRgIgJw8GggbLM6+Xso8DsRln/jybxhUe2q
	EWK3r5UZpi1ICIHwwMO+Eqxa7MgYO9qm1IXH1DJRUN1Eul79TtGt6QsBHEL1MJYa1Uv3wze9iGB
	3ZlOfl19otUfYkpk3wAd6EGttYlsF6UrnfwFODdvXanglu+kxZyExTkBTV9jt5MWlQ0krl/CRyL
	PrBlQiNnukkw/fOy6fKe1gGjuWSzVaLv4jqe7G4ImCRSbX3ERGlMDmZnPTvRwz7u+1fpwa3xkEj
	d5ncptQ7XGU4nBkkDK1OX54sq3uDKTh9Xej92xoSdqRkTzEB2pgQp8om/lb/2e6hgtmaThYQJiw
	biVm99vHfeTXwpWtl+/kLBDMwWFzOyADwT7frpLAvBhP+jwEvx7XjQCww42azU9dawnSijVU7Ga
	wyAlZVDR3LkgeYz/YdDahxx+0V5WMcu4lkYw==
X-Received: by 2002:a17:90b:17cc:b0:381:a766:efcb with SMTP id 98e67ed59e1d1-38e4b3dc089mr20506488a91.4.1784653567393;
        Tue, 21 Jul 2026 10:06:07 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2cbb6e8sm39508170c88.9.2026.07.21.10.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:06:06 -0700 (PDT)
Date: Tue, 21 Jul 2026 10:06:03 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Kiryl Shutsemau <kas@kernel.org>,
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: allocate split page tables as kernel page
 tables
Message-ID: <al-m-6iCSScC7M9x@fedora>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
 <al5-fDRStgU6gjk6@fedora>
 <al5_Le9QlD4zlt25@fedora>
 <al8hE_ded6qyWiDv@lucifer>
 <al8_xx_99BjAUn5A@fedora>
 <al9BpTu2ma8GpiPW@lucifer>
 <al9KzIhKXa3PCMqa@kernel.org>
 <al9b5uE-ep9ADtLt@lucifer>
 <al9hMyqpjd4l0Fql@lucifer>
 <al95Y5aXof0ISEkI@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al95Y5aXof0ISEkI@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B13624000B
X-Stat-Signature: eweyqd755ch49prahjgp95k5d3u6kmb4
X-Rspam-User: 
X-HE-Tag: 1784653568-406248
X-HE-Meta: U2FsdGVkX19krapgs3Ldm6x+fkdxfTJe5dVQQWSBil3AmEX7LvLTiE8AHiRk2GxQF75zPJYoIkktlq++fmtRyCeUiLQF5smBggASMmrNB98T7fCwvwdEPfBYLeKil+C7cP86TlnM7H/JX6NwkYPcYaGkQEPLntf5rP2iGJwMF2dFFQ69gKsr2DXYTezzyGmJitFbVJmgBJNu4/xjHWodurNYJrxeiM7126IES3O4gkGd3QaBKRGMHKrX9pyjqDbFIXfhTA3nWK0Ys/jsmpmAvoJaNTCrpw/FW0e5P9tg3mhBxqRXuwnZNR56MHzLmtT3l+G6mprucaVzQudHA2ZUSM9wcOGV2RdM4Xl9yfjshiYhjUstNQiAxZZ4AcFfZi3ZsvLMdwMGHXWaO+4LoDBXnOvemw/NCkMjekXWg60MXZeDzohHjyR9xvIaXfWsIutFGTp/I5Noc/9H1yZK5sQ11SWg7H2+eAB1rSaxSkeEztpjV3+VK/qD1QeoVf9EqzRj4IzURtvwCqY3nDKh3oHwAOlu1heMy7GUtIEJaZ5ELJagxwOEl7o40J8V6Hvuo2snAoK1xJ2LVGi17TalIceQ4st7AJfUj/E9CWCb6J5lzoe0Hmzu9+mCohDUtp11+L5PzUMQTrLDd7yzjYb+AaAxicmWATFnkYXCwUX5yxBcoCkOHcyVzN7FNAWNEWgTa/vifYg/jyRsv+H2ZS3PASXg2l3BD2JSp59kHvCuJ18NDY+SPUGgQ10BrLGhZFwYgJuGFnpoYpwdACw/+X53q3OoLtDqf0S9I7m2g9OZyunoD4FpsdZ6WEMbC0x7C3s0Pr1dDXlgNWYOlkDPvPgsym4BCqyV2XCf2Y69DNZuYPsiqrlFHS3s/Zd09wfU4vUB2swpUrvz0J4gPOki45eQbie0OLKSdd43ZE6uqyAaqXQr8p5rRlpRSa4Chwl7wP6AsY4JWd+vLp40N1Qb/6KmwKU
 vq/6cbeA
 RNe8Rs3gzaqAHEvCrXxSlH78nr39gcbyP6GbGl3yJtjoJb9D8i+jbXMhKFH8Lw3RLsfJWjrQX/TnIG55E4EIv5aC0R5FDNGX5ow+gaBTxoKue1x1RGk28tEmXg7fFBT+4PFpMgilc+9Y13WGGGrn/3YU8SPWF1hdVqrJpNJWJlQeHNRZi4Itcukx0dy4aRQq6pKV1dDK3VB4X4xkMPTUWsGFLSZChbZZW1rGn2tC+oMh1S3a1Bl0Et/HwzSi/glYtXyOLycbGZvy2dvivPcuzm2L0yFjGHu7NlX8Oa5Bvdbg8J2JbhTVBGb5rRONstmzc6O+QsIA3oonPCJhN+ycGPz7dlE/qGCCz3LKKeOvH9AHrHOSWx+pZMRK4V/x29RyJP+p7S8Wiv/ipcieQbXglJWKpUNcceYvDmo2vZpH04w0sOyYuzVLZzcpTPGkc5WKLYwvlaqe4twrcDD7DN2W/TXI+H5i8JS52W8o+QvBayFYTNHoJ/yz2AzZNt5zAG6b6Yl7vQUaLaYpQnlrVwMhlbMO07zwLqHm6yLqIcB2LyPabAYtLVI/vAd4MBAM0h8NybZj5XTnOtKT1LET+2QHTyhbRRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 04:51:31PM +0300, Mike Rapoport wrote:
> On Tue, Jul 21, 2026 at 01:09:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Jul 21, 2026 at 01:00:53PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Jul 21, 2026 at 01:32:44PM +0300, Mike Rapoport wrote:
> > > > On Tue, Jul 21, 2026 at 10:58:50AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > > On Tue, Jul 21, 2026 at 02:45:43AM -0700, Vishal Moola wrote:
> > > > > > >
> > > > > > > Well some kernel page tables are still allocated without ctor (early allocated
> > > > > > > direct map for isntance), and if you did pagetable_dtor_free() it
> > > > > > > unconditionally calls pagetable_dtor().
> > > >
> > > > TBH, I cannot think of a scenario when page tables allocated at boot would
> > > > be collapsed. But surely, checking the page type is safer just in case.
> > >
> > > Yeah nor can to be honest, anything that could be made large in the direct map
> > > would already be large right?
> > >
> > > But it's 'just in case' somebody did something dumb :) Later can maybe make it a
> > > WARN_ON(). But just to fix the proximate issue for now.
> > >
> > > >
> > > > > > > The ptlock_free() and __folio_clear_pgtable() there would be harmelss (no locks
> > > > > > > assigned for kernel page table, and if PG_table never set clearing it is a noop)
> > > > > > > but the lruvec_stat_sub_folio() would cause an unbalanced decrement of
> > > > > > > nr_page_table_pages.
> > > > > >
> > > > > > Gotcha, thanks for the explanation :)
> > > > >
> > > > > No worries, this is subtle stuff with lots of weird gotchas and stuff we need to
> > > > > improve... I seem to have fallen down an unexpected rabbit hole with these fixes
> > > > > :)
> > > > >
> > > > > >
> > > > > > > It sucks, but until everything is updated to call the ctor we have to do it this
> > > > > > > way :>)
> > > > > >
> > > > > > Yeah that makes sense. Although I'd rather see the condition as:
> > > > > > if(PageTable(ptdesc_page(...)))
> > > > > >
> > > > > > We really shouldn't be calling ptdesc_folio() anywhere anymore.
> > > > >
> > > > > I think better for a follow up since the code already uses ptdesc all over the
> > > > > place (fundamental to the approach really, keeping a list of page tables etc.)
> > > > > and this is a fix that needs backporting.
> > > >
> > > > I agree with Vishal that it's better to use page type rather than folio
> > > > type. And it's the same for backporting ;-)
> > >
> > > Ah sorry misunderstood, you mean straight up PageTable(ptdesc_page()), I thought
> > > Vishal was saying we shouldn't be directly referencing ptdesc's at all (which
> > > would be the rework).
> > >
> > > I guess definitionally page tables are never folios. I lazily went with what I
> > > saw elsewhere, my bad :)
> > 
> > Ah yeah I remember now, i saw __pagetable_ctor() dealt with folios:
> > 
> > static inline void __pagetable_ctor(struct ptdesc *ptdesc)
> > {
> > 	struct folio *folio = ptdesc_folio(ptdesc);
> > 
> > 	__folio_set_pgtable(folio);
> > 	lruvec_stat_add_folio(folio, NR_PAGETABLE);
> > }
> > 
> > 
> > And was like 'huh?' (surely definitionally they're _not_ folios) but went with
> > that on that basis.
> 
> I wonder why setting the type is even in ctor rather than in allocation.

Yeah, you're not the only one wondering that ;)

Kevin is actively looking at moving those to the allocation/free site instead[1]!

> > Another place to clean up I guess? (that one _definitely_ is a follow up though
> > ;)
> 
> Yep :)

Yup. It makes most sense to clean those up when we add a per-memdesc
api (i.e. for memcg in this case). I haven't really had the time to work
on those though :/

> > Cheers, Lorenzo
> 
> -- 
> Sincerely yours,
> Mike.

[1] https://lore.kernel.org/linux-mm/20260714-remove_pgtable_cdtor-v1-14-44be8a7685d7@arm.com/

