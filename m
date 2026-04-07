Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED484EDB7EE
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558FD6B0088; Tue,  7 Apr 2026 06:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509B46B0089; Tue,  7 Apr 2026 06:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8AD6B008A; Tue,  7 Apr 2026 06:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC966B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:22:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D18FA87544
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:22:44 +0000 (UTC)
X-FDA: 84631371048.11.B44FC13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0437380004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:22:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHXzlVJd;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775557363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cd0hB3JVy273e/0T2id316HV1m4HpB5IJATgnURbc6I=;
	b=Hx6zf/usd0VGlLNhSQFR5ecZVf6Tg19oWGIxpAbIDPbpslj/NhJrhLt3f3MCD6g+8Hs8G6
	1FWuMN0Jb8kgPNmFe+E3pLuLwuPqSnU1Wg2T4z/Ko/Fx6aDdKbnwFDgRBu0UHPe5Bt9GpH
	npc81fmFIh1k/eMLB1Og0qlgM+Tk2QY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775557363; a=rsa-sha256;
	cv=none;
	b=TRy96ngTMut/mCxDBRAexvjSBiIR9khQgqYruSadqQnJZNc0MRkgsS5x4tx2+hwxaAH2Af
	rDnoYI2r6R6J4QYEqGfI7hSArLUfLlG6IFbA4/4xk9D3bLZVl3l8To3NrPqubtXuUveZcK
	c1KAu31YMwvQ3w18D5IhYGXSTNUFSMA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHXzlVJd;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E316243A6D;
	Tue,  7 Apr 2026 10:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A19C116C6;
	Tue,  7 Apr 2026 10:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775557361;
	bh=FZkXrU5Sd83jhvoTVMaDHnOI/PwYuAOxdZZgsx2RnDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZHXzlVJdcn23biVy0NIGUnEkgIbhCKM79YUU7qVLdsa27iyW2F4YS/cqLPvQZMwnx
	 wBUa9244UMoGK9QDESuLHCHGfivKDN5nFW8aZEzs5aKMjYodHJFTSaD4vIkJNVNFvx
	 pLlTln2YYRfSIluTOI9UpSdIqFr72/k4dLuXK1bhEcEvteMzcd5bOlFDY2JBmUmiF4
	 QH46TOAbDtuDwMDKhCHjkwLY7Wtz5p5st0Yx1jggpBGBSUs5DczSD/qjS+dNcVTlfJ
	 1jDiTdUlSamOHQ6s6UXivis4w6CZYdzw7FvFtKFmf3Bq5uUd8IAu0gPwFcqiDXJk8q
	 xgQwywDrKn3Rw==
Date: Tue, 7 Apr 2026 11:22:35 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH v3 08/13] selftests/mm: ensure destination is
 hugetlb-backed in hugepage-mremap
Message-ID: <adTa3YItApOvQAlN@lucifer>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <3b6ffba238a4b59de891acf896fa25d7d3193228.1774591179.git.sayalip@linux.ibm.com>
 <ee15d52f-45df-415b-b0d9-3d267d147e5c@kernel.org>
 <b590a17c-13ed-45f4-9f51-ac662d00e7bf@lucifer.local>
 <066a146b-7dbb-408e-bbc0-542bdcdd6681@linux.ibm.com>
 <86889304-c450-491c-8c06-48ca9c973531@kernel.org>
 <0a1befae-1037-4bbe-b976-352ef4607d2a@lucifer.local>
 <f0905481-3ed3-49e6-a25d-4b58dca7493c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0905481-3ed3-49e6-a25d-4b58dca7493c@linux.ibm.com>
X-Rspamd-Queue-Id: 0437380004
X-Stat-Signature: az6ceemirjwoau3qec7u5jgxebdxqyy1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775557362-931580
X-HE-Meta: U2FsdGVkX18/z7k10/n+jK+qBLWw2yr55UodHerhTdRLuW88UAWANAUWJQkB35ONUJarkXV/cfkbL42me4MRJcst14IZAf4MMo6HJBPrrqqckowoHkj21p8J/ciMaRk2GJo80G54eb65NJGao98tcLgxf0MynBxsAzNqyVm7ij73FAgxVh7mcGy0hYoiPCc4JZgt+inwEqbbWF1/6KXWk+4YWzJ5H7C13lX9awzmZO4arTUu0M3+8OHk2pDhaW1JbB33gbcov0XWNFeFVA6SF/zm+2B5LzcG7lT5j+QggHVxfs2BtPeTYkB46UljNVJleqwp2YLwy30DvKM9juVseNTwCi8NOkqtUKdBl/pGD3MfF2AltDwa8RNyfFD3NLvXKFpY0fy9rZQWjupIRoNlj6sQY7hqh4/dPS5UKBLs7ONm60lIHt4hozLkNjuFGLAHtOX7Yv0kWUhQ3/n/SEvLsXwIEqylhDYYbC8eA1us3K6kklhkZHmH5xBxFm5bCBbdGJkGJFrpoIu3ObPDep+o0v9VEeHyt/hCkivL5apcHSUCHJplUOiKjtZMCVyQHCAq307fl5Se+Ddt77k7XaStcbjiRdFGetm48OdRcuc2QWCAYPnGGwntIml7caoPEl+SSpc3Gjh+OntufjDv8uKtkIdzhaF8e7nll7vCDhWbHPWnQ3sSMivZ4JuD6cWQPpco6Y5GQ8rgHjbNJ3DZnqrqLPTAuU21btBltsk49aWCZtvCR/Y/n5HgVGRP5O4L7uhXV5B/EzrWAhgK8xxqiXZcVjejRdCo8dhGnP3vQ5pxXSuvDflgmSR4kWMANXkX5XwztFwU9zp8WZpZ0FqGyfjYIIBHlJz4uPwqTP26IEi9Kmo9G7wnwspkIUsytCS5klD1WVO7FSZgdHrT3oNrr1vqz7Uhjv+6vGvgw6wH2VlgrZ02/JeTMY5gKOzJyXywtv/mc/YXEfB6TqKAOhIQowP
 rK2GRx1J
 wAj7tsCRdOmIVX0ymcMQj1u0yS3ALjgbunKIfJoB53lilvoH22c2VZsKZqY3XO8pn0ONHZ056iQE9ebMYK15hK6ov0VZWjhIzk4sRXfDiR4KKvJYZkzyXUYhSx/P0TqP02NY2WTPSKoXOxybJqqv36T/9Ox4EjVt/0Z2pkWLDyMtggLbMn7wSbL8t1qXh1f505XOKHOC8Z58oxvCBdXkitjgBDMxkgOff44YI9FKjHzHHmR8p4crOtgTRj1bSaWwQiBMf9zM9b/GiIIfi2lDPSoVrqjOMA3xu/ReCK9LbljiTFC87O/hc/BpN6oDxWSE1xp5QJyLCZOqslSz7Mgk3z+CfNLJrheNHOza/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 11:11:25PM +0530, Sayali Patil wrote:
>
>
> On 02/04/26 14:35, Lorenzo Stoakes (Oracle) wrote:
> > On Thu, Apr 02, 2026 at 09:33:29AM +0200, David Hildenbrand (Arm) wrote:
> > > On 4/1/26 22:39, Sayali Patil wrote:
> > > >
> > > >
> > > > On 01/04/26 20:10, Lorenzo Stoakes (Oracle) wrote:
> > > > > On Wed, Apr 01, 2026 at 04:21:55PM +0200, David Hildenbrand (Arm) wrote:
> > > > >
> > > > > OK so digging in:
> > > > >
> > > > > mremap -> ... -> vrm_set_new_addr() -> get_unmapped_area() -> ... (in
> > > > > ppc arch
> > > > > code) -> slice_get_unmapped_area():
> > > > >
> > > > > unsigned long slice_get_unmapped_area(unsigned long addr, unsigned
> > > > > long len,
> > > > >                        unsigned long flags, unsigned int psize,
> > > > >                        int topdown)
> > > > > {
> > > > >      ...
> > > > >      /* bunch of checks */
> > > > >
> > > > >      /* If we have MAP_FIXED and failed the above steps, then error out */
> > > > >      if (fixed)
> > > > >          return -EBUSY;
> > > > >
> > > > >      ...
> > > > > }
> > > > >
> > > > > Is presumably where we hit the issue.
> > > > >
> > > > > >
> > > > > > That is weird. An mremap(MREMAP_FIXED) is really just an munmap() +
> > > > > > move.
> > > > >
> > > > > Yeah the weird bit I guess is that we _still_ invoke
> > > > > get_unmapped_area() but
> > > > > with MAP_FIXED set to indicate that we want the specific address, so it's
> > > > > subject to the above checks.
> > > > >
> > > > > >
> > > > > > Are we sure this is not some actual problem in the hugetlb
> > > > > > implementation?
> > > > >
> > > > > It seems the 'slices' check sees if the _target address_ has an
> > > > > equivalent page
> > > > > size, presumably hugetlb-mandated, and fails if they're not
> > > > > equivalent, so this
> > > > > change is just accounting for that.
> > > > >
> > > > Yes, this change accounts for that by ensuring the destination is
> > > > created with MAP_HUGETLB so it has the same page size as the source.
> > >
> > > Okay, weird, so it's the right thing to do to cover all odd arch behavior.
> > >
> > > > >
> > > > > >
> > > > > >
> > > > > > But then the test suddenly requires more hugetlb pages, no? I don't see
> > > > > > a good reason for the MAP_POPULATE, really. It will be discarded
> > > > > > either way.
> > > > >
> > > > > Yeah I'm not sure about the MAP_POPULATE being all that important here.
> > > > >
> > > > As far as I understand, without MAP_POPULATE, memory accesses would
> > > > trigger userfaults, and since the test is single-threaded and has no
> > > > background handler for the uffd, it would deadlock. MAP_POPULATE ensures
> > > > the test runs correctly by prefaulting all pages, but please let me know
> > > > if I’m mistaken.
> > >
> > > So you are saying the test would deadlock if you are not adding
> > > MAP_POPULATE? If so, please double check if that is actually the case.
> > >
> > > And if it's actually the case, please carefully document that in the
> > > patch description, and probably as a comment above the MAP_POPULATE usage.
> >
> > Do keep in mind MAP_POPULATE is not _guaranteed_ to work :)
> >
> > For guaranteed populate you need madvise(..., MADV_POPULATE_[READ/WRITE]) or to
> > directly fault in.
> >
> > >
> > > --
> > > Cheers,
> > >
> > > David
> >
> > Cheers, Lorenzo
> >
> Thanks David and Lorenzo for the input.
> I tested without MAP_POPULATE and the test works fine without it.
> I will remove it in the next version.

Thanks!

Cheers, Lorenzo

