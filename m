Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0A1CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 10:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA55F6B0093; Fri,  2 Oct 2026 06:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E026B0095; Fri,  2 Oct 2026 06:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992F06B0098; Fri,  2 Oct 2026 06:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 795476B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:07:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 024081C284E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:07:54 +0000 (UTC)
X-FDA: 85277260110.11.5468F95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 476871C000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:07:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3xND3jj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TKehAfJY7QFR23A7GBU33pCZhJic0kmyKqO1gT4cscY=;
	b=lZ+i7htze1QlS06fEYovC5bVhMjXWunY5LDXEddaVXMteDRhNKGwYF00a2LissBfZRXHzN
	vRKpuLsabJ7Gb6R2esbi/qM76oVegHdfs/7wxmyC3bB04ayZJ66DizbIRzUsqBf7ZWGKx9
	HDgX3I/yFSnMR27GyexjItlHX6xQgP0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3xND3jj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935673;
	b=jykpDPOVC0VLl3Id7lcXfX/zwzpN3Ye7BXvBs3XY8q5cyqB3a0aSW9hRZiBkjsovcKcAE7
	zR7DZRm01bU9f8Wxmp0KIXEUM6/sdWQbkT7RyD94oAE/viDpsTnSk57247C8Wu/vf555bq
	Q5WK2oBeCJVT3lbc8LA7LLplIpiaD5E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F11041161;
	Fri,  2 Oct 2026 10:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F521F000FF;
	Fri,  2 Oct 2026 10:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790935672;
	bh=TKehAfJY7QFR23A7GBU33pCZhJic0kmyKqO1gT4cscY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M3xND3jjGhCCzouEUAIW1Fd+p/k+1Y5VyzO7TBK5/AmP/Bcz/wCeF+2RVFQ+RH0+c
	 GbbBMHlQ1PPAObwulMxI241HlG/Q47n78GAM4JrJH5OREIos5QVwsSeoc7bE4O/TU+
	 yPaowDKkl1Zf/h9FUtXzKhawayFQF6JCVTjJxlOCTGbsOXOShwDuBL/mf/Ey4XWmwd
	 RtupXkxz1p0EY47kK2fpulAYCCHJzTumw6Ju9fR7FKzEpZFDEYNae9jddkQhRfsUL6
	 2+H0VWSTZ59iERwpOLgH5sph+7pwl1Zjo2jNx36Fn0KR8CSRC+4tAQFldcErBSHWyb
	 2XMcA5dahi2wA==
Date: Fri, 2 Oct 2026 11:07:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, peterx@redhat.com, dave.hansen@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
Message-ID: <ar-BkhuJINKdNpYC@gremlin>
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
 <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
 <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org>
 <ar9omYD3HcTDBpGA@gremlin>
 <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org>
X-Stat-Signature: m8otji57p3bt4zeqg5kfekjjse4ydnaw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 476871C000B
X-HE-Tag: 1790935673-280360
X-HE-Meta: U2FsdGVkX1/g+frODuiWGodz7c6jXIiQl50P+BVyWIYryvVwzIuZZSXTcaLoB6mG9Ey+8realIXzYf3dDKsbQYn4KFkNW79+vL2Zs1rBAr6/73pVaqd1llXsYl/6Q8D/A63Hes5UTIxXAZPIzBinAJ6+7RxiSIDydsHDE3sA5VXF73DlkU5DYimNRirSDGT9wU3mJv6C4o9sx6XiEy+ULBv6gEgMci5QbOOHtdraaoHd6mS1cpCrGwHWAv/yCqj+G5VtC7gxNg0NWWYGZEhe6np9f/0XU9lhg5auuyaFrPQBxFlWPZF4q7xQUTas2ZVU0QhqZ4oSDllw9MJm3tq0XyyRmX46BIlsPGaX5vDH/XbTTc6zfM9CdSRxpQIvH3VwWz1JDMhO0h662xLHsbLfMStZLH2GuMscrCkD7J6uazfXqoP2qMBjRD66Yvkv0oVRmC6nvEDHsX6u1GWUct2wjBMfcIIWbOjbooUE8F3Oar7y0tVTXTXKXmo4sLea1HU5WYSJxeQ57nZUjT61p44UFlsgaXG7P6u5cDnT63uW4uh99xF0M3Tl0ixZDWODjO2As7fL3poZ0mglAQ36nEZlgwBy1n4m3/xSxIojscK9kFBwZQaH/RBPtDcNUO8tDzT/2maSUpVZmFTXWO+QRANhBBsm/ecTI6UKapSCXoCeh2lUIrK5HfUi4+Bn6rh6NDJw4AUVGpSyilQN3kNl7ED7DKjD80Rv2DBN+fZOQL/d2eCMck6DRJydRH7H7WZC5KkqjgGf9SOl+2iavNpQbppKu3ATeKz6FHlJ35RAPwnQSE0MKrt8GHYuFakHIkEcK0UcndP52xA6fJ5Qo0bRAvhe2f5zldlLT4a9TmQa/uDuqO86db0FKWGzY2g7bczhH/SqOfrPjnUpbR2E/K0EsiODm7MBkZxiFUqRxX0QUSJaM+rnz3K6dKq37cs2b874rrSrSiDzz/b8U3vKecdjSLl
 NXlyz/FH
 kygFyeHlNkLdvIMFU2L/zUy89Fis1gk/OQNwc47ta5byW57+iBd4mifhXp+WBQUvFtqUjb2sztV8MEqKrP97REM7XfQSgzj+6iYEwf+7UtyGdl0ZuUPkoukC2BEwOHuuetSjInKUkPdVx5GLTxeyK2XPa2LqSBdAWErx8LpaZP9FZaug/R4tqcxbwk32QQckXE+yz48yfMai+FT8w30Q2HR9If0eHQqJQJffydGs+5O1O/+wn4wfidQeg0eBBT2QYX9jSGUTY/ZE0nXRxgAFMsx5fKSn+PEH/2T7/kljEhojbjYQPiugB96kMDZepwtHnABpWjoq9DhJ98Y3vCOPodIq6uXBwLPje2bhYBUqoNnJbVcUndZFpFl5oVmNLWR2veXov9J0OFkNGD2OOSGDVXP5Jl46GNRZXnt31huZa8vld9Fe/BU6lyIwZ+XdUgbNrPofPJzm26TaJhZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 12:02:15PM +0200, David Hildenbrand (Arm) wrote:
> On 10/2/26 10:38, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Oct 01, 2026 at 10:22:29PM +0200, David Hildenbrand (Arm) wrote:

> > So I'd say somebody from the core team should take over this if we want to
> > come up with a patch.
>
> Yes, I'll take care of it.

Thanks!

> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > This looks reasonable but I hate that we have 'special' CoW overrides like
> > this :)
>
> After sending this yesterday, I concluded that we can do this cleaner: just have
>
> bool normal_page;
>
> (naming suggestions?)
>
> that express that this is something refcounted with a struct page, like
> documented for vm_normal_page().
>
> Then we can just refuse all of these.

Yeah it's all a bit tricky.

Maybe is_vm_normal_page ?

Or do we want to default to referring to a folio... but then pfnmap not a
folio... ugh.

is_normal?

With a comment explaining in sense of vm_normal_page/folio()?

> >> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >> index c49ef99b4413..b90e547797a9 100644
> >> --- a/include/linux/mm.h
> >> +++ b/include/linux/mm.h

> >>  				  unsigned long addr, pmd_t pmd);
> >>  struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
> >>  				pmd_t pmd);
> >> +struct folio *vm_normal_folio_pud(struct vm_area_struct *vma,
> >> +		unsigned long addr, pud_t pud);
> >
> > Hmm, if not defined before why would this need a new PUD handler? Do we
> > even have PUD-leaf PFN mappings?
>
> Yes we do. In any case, good for consistency.

In that case then we should definitely have it!

> > Since a folio being 'anon' is vague, because we stupidly made 'anon' vague
> > in general.
>
> For folios it's an established term :)

Yeah, fair enough, that is true.

And makes the anon folio -> tracked as such in my change consistent end-to-end.

I guess we have swapbacked for the shmem stuff as a clear delineation too.

>
> >
> > Anyway I was going to ask does this suffice for CoW but having an anon rmap
> > implies CoW so it does.
>
>
> The downside of using "bool normal_page;" is that we should check
> vm_normal_page() for any mapping, not just cow mappings. I suspect
> performance-wise we don't really care.

Yep, I'm sure it's fine!

--
Cheers, Lorenzo

