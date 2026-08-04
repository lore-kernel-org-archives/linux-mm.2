Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6366BC5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBE36B00E8; Tue,  4 Aug 2026 10:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3196B0105; Tue,  4 Aug 2026 10:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD96F6B0106; Tue,  4 Aug 2026 10:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9052E6B00E8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:40:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1863BA0AB7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:40:11 +0000 (UTC)
X-FDA: 85063847022.08.7BA252D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D22C40010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:40:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GGBdZNk/";
	spf=pass (imf11.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854409;
	b=zxlnjhDOGQ+SWUYzzV9DwplwTcUWOP1xJUqN06xScGWBe8PC67GaQNj26ot9iLIjrAFKcX
	zpLHeJwBr8vCwwEbtqI+yOcWM7ilVEswRSRgWHId5jo8i+FZMyRCMfU8ekhPjy6Wc1CXCS
	Mzt1pXN+7Q68P+xq2qCBp4vzY13WIYc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GGBdZNk/";
	spf=pass (imf11.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DMaTv2Q6Oy51TcvD7WIgdBHhGsFMUSAF28itA1CFi0=;
	b=BjvgFEomeLUUzNBB6fcI+3wZNv0PBT/vuwt+x0IJ8VZALzry8AiScx2DmP4bp5GHk9Fb6g
	hf1OZAsX3jUvEIoOutKydBBvSD1tiifbA1EQDaAAZk4+YXubciYAIIUDmp4Gst9e4EKNTG
	P8zPkHTIvGbGiMHfcHNqy9G/QhkZ3AE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D76AA60A8D;
	Tue,  4 Aug 2026 14:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6604E1F000E9;
	Tue,  4 Aug 2026 14:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785854408;
	bh=5DMaTv2Q6Oy51TcvD7WIgdBHhGsFMUSAF28itA1CFi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GGBdZNk/Xa9xVXhgFIZGWqkFOviRcHe9jUue2aUFXYg4P5oLfFH60mIGKg8BUFZQV
	 uUS69OJSjCuvI8HCZpSOG89Aeu/BwxtDm4yWlKnnmu0rPzTuKBPtmsaWp25cAlH700
	 6EAM0o+qjY51K4I6NDRhi5eqAqahIYxrrxO9ancACkWghQEc6cG6Ar6qPTITinnkwE
	 UTvYLh373bOEgA0OfRAup1bVsYDcJWi5PNH/XUbTaJkrm8wEGX/sEeiCkZK0F3Isce
	 LVCtluPifQSPI81NK7Wge1jz8fClMdxJVfCyBEd6tJOy2V7GNK1AJBNGH0W5XEVHV9
	 3LUcPmyfRC8HQ==
Date: Tue, 4 Aug 2026 15:40:02 +0100
From: Will Deacon <will@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
	catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
	anshuman.khandual@arm.com, david@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
	Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
Subject: Re: [PATCH v7 1/7] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
Message-ID: <anH5wnXvAhoLWmH1@willie-the-truck>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-2-jiangwen6@xiaomi.com>
 <amiabgyHSz3ZYY5k@willie-the-truck>
 <CAGsJ_4zgFk1iaQWisYMOR4iFxonwDskRt3Gte0cEts1q9hxibA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zgFk1iaQWisYMOR4iFxonwDskRt3Gte0cEts1q9hxibA@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D22C40010
X-Stat-Signature: csrgcnfc7o5qckxocm16o91nw9tk459c
X-Rspam-User: 
X-HE-Tag: 1785854409-510913
X-HE-Meta: U2FsdGVkX1/1cSI7fXIyZfIAn1IUeTFHNYhHFO1etFvPVM3x504Vj2doP5Uw4IIrYcIDLyg3NEJd+VlP4WlNIhob4MJCQXg7IO7StXH2JAmbFo0dPr+DUX8JunAl8VIO9/wfLUHYfUb+DDJfvg0Vx+DuezsUn4LPKyH8A+eXwVKiyW521tM+kk3KAJU8Ptdazgle2RQKoS18Rv1FwSbUrUITR4IdmYcVVcHUsdeykqzfg5X5U4FzEPweXpadqRzaSZPuRLHVsBZP6azx82N1F6F4adYTbAOgTCuoRNPwb+e8OStmscCNQmxCHk8AhqPbhsAz142iLPXSLVvz2z8uHFhBm/Qai9wVYkwSlT1TNs+VKq22CJqKRbkRTa7cpFULh0yI89uwOM/f85ur0zLP1C+47RX+PdnHCg/SKSPTuM2En87EGvBxtCvAbN9tPftuDRZueXu0KsXc/v3v7Zc2lL1pLsV4rlptZeNUUT/PU6gfvBm3tkShJNsic5RKYVi3LFI5Szhqhdo2l7O0xsJlK/UC8t6SZMlZ7ycq+gQqJeQYqcQ85FVC+PKs831Y4pY1nYBwAszWmJYbBTcY7c9fXQyshwMaj5ROuedOLrPB+daYeokjKhEnSG+8M19RIvc5gluvyWHo1C1ID2OYJEkjs63Xi/zaOJaBMV5lFC6fPJUsosYNTZTfSFl+1VoSM7al4c7cNBGdOfwcjj4tyVQy//3YPj2D7lL+0CTuGmLu7HFxlniX5hcmlROnA32knK2I9CCu84BHY2lUxhz3hKK6X0xqvBNLjFz2gHX9i9mUGl4ZUwiUi55aJkwRycPtzxT07Pc2tUV90NOr7eDmTuLGTt3RA5L02YWT5T4hh7UJiImQDmfUbytXFZjix0hGME8RgqmnpOKK++pO+J2A6Pk7AUS3CVguxkxBGYWEOJktpAdx/P/P7EaHvoe4daP8Cve+IYw2d5yFlNwjO9+fcTH
 pRUYa8l2
 NvnJihpgcPbd1slgtGfj1/gYNgfuChu+5kmrFjs50eH2LQzWJ8NsOX0qvvw0nfNl31EayKOaoAbFmo5JnE8X5ym0IkAA15gI6lHvJoWiv8ISfGRIciOfJsbZ288dwwrrIiaTXmgHfAplgge2R3nIeTFs2/AM0garLa0VpYnQsLjV2wyHdwWUit+o3Nj6pJNfMFTVntotHH4q6U33/oHdP4EQ1cyjc/KfwYbGERkw0J81eNvVD2AcHKG3wPQ/Gzo4qRN2eQig+0UnIHKadZOlfpUUW0l2IE1vZvkYgsqAVB6WVNxF2xH0FAK/ujqg2M5+hQaVxTBshj/fZ9lcMA0/GqoFo2xn/2l1FXAitpy2IaVEshulb+x9+qweB0W/1KhDnGnPtneesx9JNmgl8VtJY9A2TOvSnDaZ1WFDQYM7xGu6GyY0G+fG86/IhsXyxcTQawAK9ZZL51nSKVcA0rA7nUFDLqGeVJpgO9DBrwR727OadQFARAQhxjBim6UkL044vhfhrVvIpvcp5GVNAixQpvrnZi8+j2oJ4V+XDMzBmyMZzuGsqhI9IRu+1SvS4DSyu6zRjQ2yaoK5xqL9Q+ahaQ2PoBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 05:47:34AM +0800, Barry Song wrote:
> On Tue, Jul 28, 2026 at 8:03 PM Will Deacon <will@kernel.org> wrote:
> >
> > On Wed, Jul 15, 2026 at 08:08:07PM +0800, Wen Jiang wrote:
> > > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> > >
> > > For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> > > we can handle CONT_PTE_SIZE groups together.
> > >
> > > These additional sizes are mapping spans used by non-hugetlbfs(vmalloc)
> > > mm code, not new HugeTLB hstate sizes.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > Tested-by: Leo Yan <leo.yan@arm.com>
> > > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > > ---
> > >  arch/arm64/mm/hugetlbpage.c | 15 +++++++++++++++
> > >  1 file changed, 15 insertions(+)
> > >
> > > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > > index a42c05cf56408..7ce159483a354 100644
> > > --- a/arch/arm64/mm/hugetlbpage.c
> > > +++ b/arch/arm64/mm/hugetlbpage.c
> > > @@ -94,6 +94,11 @@ static int find_num_contig(struct mm_struct *mm, unsigned long addr,
> > >       return CONT_PTES;
> > >  }
> > >
> > > +/*
> > > + * num_contig_ptes(), set_huge_pte_at() and arch_make_huge_pte() can be
> > > + * used by non-hugetlbfs(vmalloc) mm code to set multiple huge mappings
> > > + * at the PTE level.
> > > + */
> > >  static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
> > >  {
> > >       int contig_ptes = 1;
> > > @@ -110,6 +115,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
> > >               contig_ptes = CONT_PTES;
> > >               break;
> > >       default:
> > > +             if (size > 0 && size < PMD_SIZE &&
> > > +                             IS_ALIGNED(size, CONT_PTE_SIZE)) {
> > > +                     *pgsize = PAGE_SIZE;
> > > +                     contig_ptes = size >> PAGE_SHIFT;
> > > +                     break;
> > > +             }
> >
> > Under which circumstances would you get a size of 0 here?
> >
> > Given that you're relying on arch_vmap_pte_range_map_size() to give you
> > a well-formed size, why isn't if sufficient to check only the alignment?
> 
> Thanks very much for your review.
> 
> Are you suggesting the change below? If so, I'm fine with it.
> I guess the current code is just being overly cautious for
> defensive programming.
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 8429d220660b..c1af52ba572d 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -115,8 +115,7 @@ static inline int num_contig_ptes(unsigned long
> size, size_t *pgsize)
>                 contig_ptes = CONT_PTES;
>                 break;
>         default:
> -               if (size > 0 && size < PMD_SIZE &&
> -                               IS_ALIGNED(size, CONT_PTE_SIZE)) {
> +               if (IS_ALIGNED(size, CONT_PTE_SIZE)) {
>                         *pgsize = PAGE_SIZE;
>                         contig_ptes = size >> PAGE_SHIFT;
>                         break;
> 

Yeah, that's what I had in mind.

> > >               WARN_ON(!__hugetlb_valid_size(size));
> >
> > I agree with David that it's messy having hugetlb tangled up in here.
> > It means this validity check is now going to miss some genuinely bogus
> > cases for the hugetlb path (as opposed to the vmalloc path).
> 
> I agree that coupling hugetlb with vmalloc is not ideal. As I
> explained to David, this has been an issue for a couple of
> years and affects multiple architectures since 2021:
> 
> https://lore.kernel.org/all/fb3ccc73377832ac6708181ec419128a2f98ce36.1620795204.git.christophe.leroy@csgroup.eu/
> 
> where `#ifdef CONFIG_HUGETLB_PAGE` is required by `vmalloc`.
> 
> So I'd prefer to address it in a separate follow-up patch
> series.
> 
> For the `WARN_ON(!__hugetlb_valid_size(size))` check, I don't
> see anything broken here. Hugetlb only uses sizes registered
> by `hugetlbpage_init()`, which are validated by
> `arch_hugetlb_valid_size()` implemented in
> `arch/arm64/mm/hugetlbpage.c`:
> 
> static int __init hugetlbpage_init(void)
> {
>         BUILD_BUG_ON(HUGE_MAX_HSTATE < 4);
>         if (pud_sect_supported())
>                 hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
> 
>         hugetlb_add_hstate(CONT_PMD_SHIFT - PAGE_SHIFT);
>         hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
>         hugetlb_add_hstate(CONT_PTE_SHIFT - PAGE_SHIFT);
> 
>         return 0;
> }
> arch_initcall(hugetlbpage_init);
> 
> bool __init arch_hugetlb_valid_size(unsigned long size)
> {
>         return __hugetlb_valid_size(size);
> }

I'm just pointing out that the defensive checking in __hugetlb_valid_size(),
which should really only warn if something has gone horribly wrong, will
now not detect bogus sizes if the address is aligned to CONT_PTE_SIZE.

Keeping hugetlb and vmalloc separate would avoid this problem.

Will

