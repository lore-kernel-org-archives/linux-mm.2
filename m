Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3860EB7ED5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 11:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2326B0088; Wed,  4 Mar 2026 06:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96756B0089; Wed,  4 Mar 2026 06:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC32E6B008A; Wed,  4 Mar 2026 06:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99CEE6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:41:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44CA61B82AF
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:41:22 +0000 (UTC)
X-FDA: 84508190004.07.7A63C99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AF38A14000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:41:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nY53Ijkq;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772624480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OskFuaIg9ilN1+N7MqlVVxabPEYLkhAzzhtxcyo+h4Y=;
	b=SjkmprwE1y5slYgxGt4MvIMJAQIXs1vivWp7wlpwntOk5VpnVPJwSUNg+SmI6yoOvFvxQj
	Hy1LYuhKmlMex0JoJOTqCMtZdn3PBE0Vbe3NA0dsDXbi6K+03yreV8pOcdW0+XjGwrpVo2
	jrOvhbqdImnC2OoRJ2YR/TkCq6y7P0E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nY53Ijkq;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772624480; a=rsa-sha256;
	cv=none;
	b=riTQVjHyT9lX58AXvM39weH0wrWDtQh3z+2okTxQIGPjsJDnDGR9fP66u675OY0cA/cDGk
	2EArP4uahE73a7TADHfCsJE1A59XjbMN3UkC7PfCHFHAsQh7r+K6dbOEmrp0W1XAen2Abo
	x9LXeW3wK41Ftwx0efxpsEA+SVpplpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0894860097;
	Wed,  4 Mar 2026 11:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FCDC19423;
	Wed,  4 Mar 2026 11:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772624479;
	bh=QYQDMf0KXMinGrKjxi56od532q7tVilaaPt4udBEewc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nY53Ijkqn98hiUXWMhjkfApfuiQPEMs4ojrXNL1SUSD/OvZ+Jod53WH+eyuECGltL
	 AwxFkpx1EVJrEbqrF4zx5cvEh51CSmLLt7qOPHaqE+7lmiEQCivSDaev0MleVJoG5f
	 gsFhLwrLkDrdiXN4aQB9ayMi4hMYGDJrk3i1+eDKlEFC/5GIOLD87gu7nqHoVB9ugb
	 WlKATikK3PBqmbwyIOXjLEb087zrEyjWmFRPmGHP1rItydqueDcLNqHuNV+D8TBTwo
	 4niEVc9fIFdxjeGwoqEYL7tN+DFQjkUwWVFmA+mN/9qgExJHL1lhMV3HvTX/xipvzb
	 ad6L9DGiotY1A==
Date: Wed, 4 Mar 2026 11:41:16 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Chris Down <chris@chrisdown.name>, 
	Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: fix memory corruption on
 huge zero page move
Message-ID: <c4d29d08-50c3-46f8-a9ad-95f3ce552734@lucifer.local>
References: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
 <901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
 <f11357fa-29ac-436c-a9a9-8406f516ea30@lucifer.local>
 <20260302125032.313797b0ec908cd133f3ed82@linux-foundation.org>
 <a1e787dd-b911-474d-8570-f37685357d86@lucifer.local>
 <20260303174226.1b9079ccd60164fe0b28a3e1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303174226.1b9079ccd60164fe0b28a3e1@linux-foundation.org>
X-Rspamd-Queue-Id: AF38A14000C
X-Stat-Signature: jqeuhh45oya66yi6su6xb8rfawiweocq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772624480-594436
X-HE-Meta: U2FsdGVkX19rJrrxy2fWsaBLizECTBD1GxHY4LItxMKpnmpYmialXgEP1u7lwEjerA7lB+w0MaGjPpLaWgUSR81srsyJwd1SoqjjYeaPYE9992LDXmzUSNterBXsBShTt4m3TCbLyltBqQmWKAT4OB737tEMvxz+PSKO2/ttITKw4AJ/SOlCdQFMLxCmDBsa207c7J/ziXOPvzpbrMua7QR7c66Gf/yYY2KgUzHzQiiicAPNcMvAwUsDoItoOBX8SMWPLYPEtzROdC+2EMIvZ87QHoruywaZgbM2IqZ2YAxQ1/7Iw4TZKdh/dqN0N1UhyauowtolB+A5vzTKO2k1Vm4MPKsXz4bYVfXAG+KZr2OhcmUvZWe08XqcxgKPJKSQuVYnikLMJ5psfYpGvkO1/CP1e/us/p6jwJzPdXvF/lw/Hwr0Jh2Dry0s2nsoV7P0JhdiIc8uznAghIfAKp9J/b/4z7JQOQ3hEWCUw5XaU1E/9FYi0Qy+hK5+sBVKeb2TtLz91dpMF2x5l4Pw++NqRM/SBiUaKW3sZjwujmkFguiMD3ShEi3ysk3E3XfEM01la5E+aweOig6FFSB/idPittn119oYtbg10GPPX1/qf2G7eBVzrolsZcjXyAqjK7+fuHLFpHuc5TkP2n55nUXVSHhd6H0ZULtAaDA8IMVptziQSAWn/FsTpaA6fFo3zBToy/zRGT7jJpLn77hkiXbr+6f8EeE/JnZIm4fOsd59NFbuUIuE6YjKZzoICs+cerZuLsWcnU0phv5Nt3EAYCKybpZYqaS6oPQesFp/U5YSQkpkrDUQ5KbYdgG4trXvWJ8WvYPVOStx8XAp7DqZN1+10ViNiHB9/CSxYe4caOCGQ5xMUhwR5BGputm1HwQefspKNG/2hyHwPUMOq8GHVjGqEAQsSeu9WDiJFvj+EhsLEmLHMZ2CMCUIcMGQpy+NRyo8N4E8a1dLYrJuxCjSfHa
 TETjqcvG
 b9tK4KfeX5yTr76jYXXCr+soIFDTQHWDj8OQk45q7Wfz19r98Ee/mb7N7L5IUnYHsMwLuq+viJ7qEgUJuPHmtehZZST5lcU9+1VJLMFdACJAyHdFeBQZvVOii5Hu8EXkoiVqUhjzS2n5fJzP1Ko8XVWlKSiLITonn/tFcEJo0U2MsFQNw6t2s/hBHFmq7MT1Hd0MqhO/wUf8LKIRCS/RrKC9bLFM5gtBAjJGs5NwNaZSoHTzJgkwRj/7NZJnW9TpNv1frqx8ZQJq8O8VxFmYnCUsMy1XLZISBbtwBFBjV4LX1bptKAooWnNdcEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 05:42:26PM -0800, Andrew Morton wrote:
> On Tue, 3 Mar 2026 07:25:32 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Mon, Mar 02, 2026 at 12:50:32PM -0800, Andrew Morton wrote:
> > > On Mon, 2 Mar 2026 17:19:15 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > > On Mon, Mar 02, 2026 at 06:10:06PM +0100, David Hildenbrand (Arm) wrote:
> > > > > There are already patches in flight:
> > > > >
> > > > > https://lore.kernel.org/r/aaBVaHs8rIkNcwM0@chrisdown.name
> > > >
> > > > Yup, if people would actually cc the right people I'd not have wasted my
> > > > afternoon.
> > > >
> > > > Replying there.
> > > >
> > >
> > > I'm not sure where this is headed but I'll queue this patch for now, to
> > > get it some testing, to lessen duplicated bug reports and to generally track things.
> >
> > Hi Andrew -
>
> Who is a confused person!
>
> > We should drop my patch and take Chris's.
>
> "my patch" being "mm/huge_memory: fix memory corruption on huge zero
> page move", I assume.

Yes :)

>
> > However, life isn't so simple :) as there's been some confusion with his series
> > since his email client seemed to mess up somehow and a couple patches need to be
> > squashed on one another.
> >
> > So to make life easier, I enclose a squashed patch (combining the commit
> > message from both), with my R-b, T-b tags attached, please replace my patch
> > with this one.
>
> OK.  I added your signed-off-by also.

Thanks, probaby appropriate.

>
> > Also, could you make this into a 2 patch series with
> > https://lore.kernel.org/linux-mm/aaBWG4fajXXbjpVN@chrisdown.name/ _after_ this
> > one?
>
> Well, "mm/huge_memory: Fix use of NULL folio in move_pages_huge_pmd()"
> is a cc:stable mm-hotfix and I don't think "selftests/mm: Add UFFDIO_MOVE
> huge zeropage PMD regression test" is to be treated that way?
>
> If correct, I'd keep "selftests/mm: Add UFFDIO_MOVE huge zeropage PMD
> regression test" as a standalone singleton in mmm-unstable.

If you can _ensure_ the fix appears in the commit list and in -next _before_ the
test then yes.

>
> > mm-unstable (I'm not sure why we're rushing changes there so quick...) had
> > _only_ this regression test patch in it, so we were left with a kernel that
> > splatted on running mm selftests, which is not what we want.
>
> But the regression fix "mm/huge_memory: fix memory corruption on huge
> zero page move" was in mm-hotfixes, cc:stable?

Chris sent 3 patches, the first two addressed the bug, the 3rd was the test. The
first 2 had review feedback, but for some reason the test was taken, and then
taken to mm-unstable almost immediately.

(This is partly why I wasted my time tracking down the bug in mm-unstable and
ended up independently fixing it...)

I think things were confused by Chris's email client somehow messing up sending
the series which we not threaded etc.

>
> > (It seems to me this is what mm-new is for, and it seems we have some holes in
> > our testing still since this got thorugh).
> >
> > Please drop the patch you have for this already in mm-unstable and make sure we
> > only have it _after_ the fix is applied :)
>
> I think you mean to drop "mm/huge_memory: fix memory corruption on huge
> zero page move" from mm-hotfixes.

Yes drop mine.

>
>
> So we now have
>
> "mm/huge_memory: fix use of NULL folio in move_pages_huge_pmd()" in
> mm-hotfixes, cc:stable
>
> "selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test" in
> mm-unstable, not cc:stable.
>
> btw, "selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test"
> still has a bunch of unaddressed review comments from David.

I mean let's not have it in mm-unstable then? Things should only transition from
mm-new to mm-unstable/-next if the review is in a good state.

Generally we go easier on tests sure, but if there's any hint of it being a
regression test we have to tread carefully, or we end up splatting people's
kernels and cause unnecessary issues.

>
>

Thanks, Lorenzo

