Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFCB3C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82CC6B00E7; Tue,  4 Aug 2026 09:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59AC6B00EC; Tue,  4 Aug 2026 09:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C723D6B00ED; Tue,  4 Aug 2026 09:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A44EB6B00E7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:59:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DBE8160167
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:44:10 +0000 (UTC)
X-FDA: 85063554660.08.D7D43C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B90F14000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:44:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+v+kmdg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785847448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKB4l2IZdbP/Q0kXwbUuYXowkK37syxnhhgXnRPRqN4=;
	b=kURBhxeR0nvLwPi4bfMy9wBbFpJ6kKt+YPJh2jprTxnJhDqis5cZYRmO3fueSI8Vr2lFtB
	rpCMYq7W6sx8OiDr1NcwQVvuw2dQmZl242p2cXK1JVU5Jty2o+PYJiIgaTgBdMtssyfLMf
	9AtoyHN8pMjvmdKkXP2nwgYIbDq2ctA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+v+kmdg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785847448;
	b=Rro6VzTvQb4GqZIeT0OUtCNgSwSS0g5F0JBABMN18cWdsAXr+Tj9OQ2cusNqcOnbqkFMRf
	+JQ5fpT9/elmtwGJl2cFiZmslU2iVF02aZaN9XkOKJr+iuGB29UAZ7OgQcrXCuanuSSXAB
	1nzqulqTu4iLagbNR4v29W1bEwq29Ho=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3D9543A4A;
	Tue,  4 Aug 2026 12:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034D81F000E9;
	Tue,  4 Aug 2026 12:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785847447;
	bh=GKB4l2IZdbP/Q0kXwbUuYXowkK37syxnhhgXnRPRqN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T+v+kmdgCi3T4UxR1mhAPlH3L3GeQtz+35K3qNK/vTqxJ2yOhaKoAVspBfOMxLtsn
	 FIWPLNKujn5Olk6Z1+BnoEkDpCRSlRtCDxuydX1h9GeE6Eo2MOGwzDqGMneFaBwi/s
	 k1oHBA1ZQ6LyPgdPLKQitX4rEDVnEILfBvI9RX+oJ2Ihm42LEJmI4EzjPJ+9HlvHfA
	 kAMfGranFVW0VA+QEd5XUJV+yYuDvEayQq7xHv1OcCe6lMi7yMbcz8Nt00EWijb0Sc
	 z41BRatoKPG4RoVOTuLaS2r3qLW8wT6a0YEEg0Aik0zKahizkE1Pp51jHOmksup38v
	 HLAh1qHJ/KsIQ==
Date: Tue, 4 Aug 2026 13:43:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] mm/powerpc/8xx: constify ptep_get() argument
Message-ID: <anHeZx6Gg7waNWjL@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-4-pfalcato@suse.de>
 <anHI4B-lMu6AJJfA@lucifer>
 <anHc4aUbwxWx9YJF@pedro-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anHc4aUbwxWx9YJF@pedro-suse>
X-Stat-Signature: gaacrhiqnuk8o1khruwcobkgz1cqf96t
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B90F14000B
X-Rspam-User: 
X-HE-Tag: 1785847448-279298
X-HE-Meta: U2FsdGVkX19yzMO4KeyKvYwtn9k68vMG5VP7yIi+RIhWX9/PC5eFHmOeVBQ+8UlfPMtAIqJXZEZqbHo4QZnCCUDLH1rb23u1TsTjlBBklMWnS8GvFfNg35p+PffUXyRyB5QlK2VBX7b89n9ITlI9x5fkD+jkh6TpT6ci3m7P3d6FwS2lE3LYKLc3zg4zgReT5YVw4fiD6+GQRDTsyw8fQ/vARMp2ZB0+tOypbGgCj83oJiYiNtLqWYbf1AjL+s6G6Ej5GHFryJTS8wVKugG/8l+x1vxp6zbp6ZUVixqjDdT/+Wz9QUAdlz3MPaZritsYWUNNeOtl9Gb449WO5bBrVLaKi8pxlaxQM9G9sfeWHml/Yh0SZkcZjAaljZ4PbLlxBuoCHSTKjMEetjS702CgQ1oVg2sW/ZmrUiFo7r3bEuUaPcBV+XAVp3VCeV/jYdE6fiaOAiw4v6yJVURy0xwdj9NynCJLxeGu3ZkjUYrGzhRog/ckGvsv/b2rcMeUaNRO+A2QfZajNwTkz8fLuO/GGl5dfIW+84cO9dP5K1t+EU1uVMAaIvnOoZuG186mWHAqdxG1JHUQ7PKgTsGLPonzORC7/YZ+7Yn2EgXTN3SzVq6UOXj52jojwpBWO1y4w1epLrA7eGmr7a62MhsBaPItceOZbox131dk5lx7VzM1V5aJyHGH926+ij7sc4uz1DVYeUUT3K9Ou6J9vvFp6ozbxl/EEt1wonAEy98afC4yqbr2eKW7NmTjULrfF7377VhsyiBgas9s1eJPhkRutE6iToT4yFbfyXaUewh4vARjk+t7be3UjIeM2xfPzt8IVhS2HmP3QRN+GbuSqxoOW3BSbZBJR/tH9/OJopN+nuHbzXNU8XavOgKsMeDNZg3lhA3ppB79R1piH8QiQYDeTC2iAsX7B/+MrAfJEImn+RdHDD8cu1EOaAny+K9GRdW80FDOHc7QxhARPH2EEctltkx
 OdEhYnaG
 tt/9+PvgHRPjQM1dgIUg7e49V0VSqbZKdakbbjcKvpfdruOVT/LAAE3mImmaYoyoqQ7vf5T7WYif5A/69P5B9cCEa8dHeOEhPy/VehYebayOei52Oa9Wb2rNtMg88pL3CP9pX3EHtMpwfum+wJV/XDD6rKHUg6ozV0GzWgsABsR92uN8tvVEDWtzv55nOgJUxi4pvM209u5el6lH0RzkK9YeQs/nSevIjN95EhpZjlmuGK6eHh5PcCKq2/ZPT8wDI8yhP+pUvkSMtYB43zzP3xL1vXsB8RAKPUgR6ZRLAnqiBxSARro1yJt2TjgRcXLM4i7qKjCszAGmsckLBrN/v/quhhy1+igYOu3bg69Go3FOUPXjm6v1ZDLlsMUkO2Gub35/+nTKbzGXiAhVFcYkm14YU9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 01:38:52PM +0100, Pedro Falcato wrote:
> On Tue, Aug 04, 2026 at 12:13:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 05:43:57PM +0100, Pedro Falcato wrote:
> > > There is no need for write access to the PTE.
> > >
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >
> > With below addressed LGTM so:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > > ---
> > >  arch/powerpc/include/asm/nohash/32/pte-8xx.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> > > index e2ea8ba9f8ca..f2bab31040c7 100644
> > > --- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> > > +++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> > > @@ -226,7 +226,7 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
> > >
> > >  #ifdef CONFIG_PPC_16K_PAGES
> > >  #define ptep_get ptep_get
> > > -static inline pte_t ptep_get(pte_t *ptep)
> > > +static inline pte_t ptep_get(const pte_t *ptep)
> > >  {
> > >  	pte_basic_t val = READ_ONCE(ptep->pte);
> > >  	pte_t pte = {val, val, val, val};
> >
> > Worth making these const too (that {val, val, val, val} horrifies me btw :)?
>
> This is PPC code, so I don't know if they have any particular opinion here,
> but I could definitely do this.
>
> (FWIW, it seems we're more aggressive in MM in doing this than other places
> in the kernel?)

I mean I can't see why there'd be any objection given you're already const-ing
here :)

>
> --
> Pedro

--
Cheers, Lorenzo

