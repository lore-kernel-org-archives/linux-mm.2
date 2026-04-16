Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20270F8D760
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 16:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A026B0005; Thu, 16 Apr 2026 12:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02AD56B0089; Thu, 16 Apr 2026 12:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82D56B008A; Thu, 16 Apr 2026 12:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9BAC6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:13:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 773F88C70E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:13:17 +0000 (UTC)
X-FDA: 84664913634.18.229D534
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9A6008000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:13:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RFMlIkBM;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776355995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/bqmT/sHPhtEYlBdl+Pe9z2g5g8mvJyEt3k/kSDG8s=;
	b=k6SKqQvtF3FCHU3m21SIBaS0T4E+nEj33yCPppT6+zfYNUM7DhzKsxBQJuWjGSlap0Znb7
	iufyKPFoJhp5mRnEQpZF5d5aH1fYQKXSnCuJSl+1sipDFX8PA1S+EDhWBFBBmn/pSs3vMc
	KhOUDSF2ScEzwa8Ct1uX/DrfWDksYfk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RFMlIkBM;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776355995; a=rsa-sha256;
	cv=none;
	b=UVZ93Nci9ir+gbC0X5sYCrj50Ucp6baiyow3jMGYvfmcq9DA0zGa0aR82yuLUUt+8ZDsEi
	yTWJd85SDoupuDUjwIoRPK8whHeMNB89l3ezqRLIiw360Z7G/CFsgwQTGs1sZtbU2sURar
	JLiQ9hHLvCl6CCLu6OHmd+a2SygNk2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 392FC4045A;
	Thu, 16 Apr 2026 16:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC17C2BCAF;
	Thu, 16 Apr 2026 16:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776355994;
	bh=qIXWb9zk7cCWCWuHZHzx5UEDyqwqm3ROl3GtCRHkRO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RFMlIkBMMOgwrHCtflz3RSb2FmJbQI3+0F0SMsRAc0uohnsekVsLJz5Z9EXVf4Xb0
	 CtGuojup3h+lZc0vq+tLGlF7XtmI2de9YP7mqpprDY74xiQG/jxLLMYMwLo7k3q/82
	 aUbDdG6fQnVsbHAwkZs8wYWu7BH+Er8zqlf1x2vL6/jy1xTnaNgbPiyQMW0pDl8Arh
	 AIGMIJenzzQrP6mpskMgHgfAzxrYBi1dTrPg+DlXpi46lkwFLxCm675Rg8N7G4gKe/
	 jbdlQfMq5MkkffV4oTRE4OJwJ27mpwluJ1cW944HIiiJsDAnOQ8/IlVOBESGAkdf2Y
	 /KE0/l9U0ErFQ==
Date: Thu, 16 Apr 2026 19:13:06 +0300
From: Mike Rapoport <rppt@kernel.org>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v8 1/2] kho: fix deferred initialization of scratch areas
Message-ID: <aeEKksfLxQ0A7Jun@kernel.org>
References: <20260416110654.247398-1-mclapinski@google.com>
 <20260416110654.247398-2-mclapinski@google.com>
 <aeD2Fzr6yr4pu9-X@kernel.org>
 <CAAi7L5d-ujEa7R21Lmd37X9451KBmK8ZhagSKbJde15aQLi2MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5d-ujEa7R21Lmd37X9451KBmK8ZhagSKbJde15aQLi2MQ@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A6008000C
X-Stat-Signature: ybjouyefqtr6ij1dqhrhbceaun5gfx8u
X-Rspam-User: 
X-HE-Tag: 1776355995-868045
X-HE-Meta: U2FsdGVkX18qB3C4qObMczd2oauYKhA7LJHtohUQtisNBaXK+WRh5jcynQMaL1HbrivBFsIvG0NcfSiPvhTmW6vtgkaZ/S/QOeBNxfTyMOXu3v0syZDGUwkZGA0yNlt0HLXPZO2xelM9kZ/XXPcs54gl5S9VBTDQfCPv/6+iFbSj1v3ehGfDxRCybFkygvqvC/AMzSbBWzUNkAq7uNxxQCCjob1Ouhr8rXTFqMlpiODLneZK8FfPvhz0gAoBemzoNZFi8XA82/aio0YIiS10h5LgIfoXryhpotpGEm5lUwvpcQyhDSguFJi2ACm6RXqc7VPWSG/GhbHGnLlBer+XeLNg2BLUY5MHcr2JroAsBe5DZs1WNpOk3TlqG9qVbqEQRP0H/S9FbVmp8frQuu7KQZa1UA+TPm7R+3oZsIiVa5rhno9WBYIc+GkhS9qyFS12R9pYwsXoOqnQPmwdV0HmLuQHU9yAQgCNTQYPyPmIOZ/jG+8n4ImqNRpzi6pr5Ozi7dYbKIcybJewbDUrUIrG3+xVZoCbMxNfhhri/sV+mHItBqxLzzFJujKnkRtCaxa3ApDB4AgWHsYXJMuOAHeAZ3vCEYL3aQRhn6XCzS3HQkACX1uS+Mm/lhF4eIVvGYO4aMd6ut8POgVz711StMMJ7amjCNPDWsLihjiDNLmRNr8VYIfniHJmIHfDDC8R9ptt+n1QpMwzcpkPnAJ21esUZnR/TluWZXKe49+Ku72ZiJ2LHZhSJ4xcXNIfxEJ6Vw32+GuY/0wjNXJsUAEYuUu1SeVUYiVM07mG+6VdewccBvsGplbgElNGoy8HZ2OlOoBG5fIaZsjkWQn8J0D2KQWeY8s/W7Y6B/MCgnnM9di6cA4ycxfoPEFhZkpAOaDCyq/0SUpIUmfAZf7Wiz0U7UW/HzdPV6xjnpItut+W0QPuVgMfRkh3x0XGgJSVLLRXSpWaycnbx/OJpF4QcWFyt0A
 OXsCE+ca
 bCQDw8NzIBp/kREW2sj/8W5b+EKnb75huVdLZjNXWmFvMbFIv0Wo7P7Q+Ycv++45AzDzlj3n5btsEvNfiTXJl7awpnx8iNPXUGmN1C1zMenTLVCaBbNmF8l6h0UHCRo1yaBfZx6lel1bVZeVSpyy7JzaDDjI0DLaLIbgvN46Q4u9tepbjOrgmX9T3vkeDLyFxE6gqkTkMM8Y/gXrg7MWhfMM7YKzfSigASlWX/vymmli2KmAI0/DsZBs2naV6UaKCG6sdfhLHc1C1pMWZqPZbzoikeOuyHDcKqgb2NaYeRBX07E4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 05:06:10PM +0200, Michał Cłapiński wrote:
> On Thu, Apr 16, 2026 at 4:45 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > Hi Michal,
> >
> > On Thu, Apr 16, 2026 at 01:06:53PM +0200, Michal Clapinski wrote:
> > > @@ -2262,6 +2253,12 @@ static void __init memmap_init_reserved_range(phys_addr_t start,
> > >                * access it yet.
> > >                */
> > >               __SetPageReserved(page);
> > > +
> > > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> >
> > No need for #ifdef here, there's a stub returning false for
> > CONFIG_MEMBLOCK_KHO_SCRATCH=n case.
> 
> In all 3 places the #ifdef is there because MIGRATE_CMA might be
> undefined. I already broke mm-new branch in the past because of that.

Hmm, that hurts :/

The best I can think of is to add a static inline in memblock.h and ifdefs
around it.

> > > +             if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
> > > +                 pageblock_aligned(pfn))
> > > +                     init_pageblock_migratetype(page, MIGRATE_CMA, false);
> > > +#endif
> > >       }
> > >  }

-- 
Sincerely yours,
Mike.

