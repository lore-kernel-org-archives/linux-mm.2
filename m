Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2D1CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB2B6B0005; Tue, 26 May 2026 04:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392936B0088; Tue, 26 May 2026 04:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8716B008A; Tue, 26 May 2026 04:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 186666B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:15:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCD48120217
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:15:06 +0000 (UTC)
X-FDA: 84808860612.12.6B26A34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 23FEE40010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:15:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGSVDjJf;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779783305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaExe0o8sgOuAffurTxA31aVwWKAGfat/zImo5zQ05k=;
	b=zGtjyGGRJx7A5L8iFPQnFAnQoofbKTXy4ZczEUnXkDTwxDFwdZUECVE54qm3zLvx3mU76Y
	jXpF/Hz+gnXOvheWQc/qPP50iy6q+WadcOX8Uvqea1Fo/YBUIE+ZUh4vMdL+lvc3NLCM5a
	g5CmdwBf1/EAo5enUxlSY1OyxuQxiSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779783305; a=rsa-sha256;
	cv=none;
	b=ADYmh0nVp6EIGI+XHmrXmaF/tTiZpan9kUjzzlglTBKE9/6hS/MPQnHVSOtjvuE46DAB7i
	nufazft0kqZQE1bFhfx2gYPp2jfhtwY6VOFmH6Q3ZT3l5qqS2Sq7XKg+5wGBfInzIfmezf
	zZL1HAsnQYmjDNJ9fhflB7WRcSpV9/k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGSVDjJf;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 705676008A;
	Tue, 26 May 2026 08:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332811F000E9;
	Tue, 26 May 2026 08:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779783304;
	bh=LaExe0o8sgOuAffurTxA31aVwWKAGfat/zImo5zQ05k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mGSVDjJfaqHxThhrHHY8/jlIJxBTbDBY8eXvuoId/eqeQNh1XyQbgLFJzrNsjYz0k
	 fMkM89kirTVpe1jYVZ1OeFUjsPs+e6TSiyLDr0y5fqzTtQ8PANppUQgUNnSiB6CXI9
	 dntgodUx4ZbIKxUpC90dMc4ku+2d20O+t1F5zxkWsuon9xc1v639tAX9saPLJT8zUb
	 2NKb0NiFp6cGqBilQtwPtN4I/oZFLOhz5LErZEpuubsDR4mm2W8/j8eL63Y+0f3YGu
	 wE1u+Hdd3KNki6jyL7IyhfJ6D1CBdkURnwcFwI89nmVzwNPJLI0M3HYySI6VcBF7xx
	 8QZ3CQGl+qbgw==
Date: Tue, 26 May 2026 09:14:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
Message-ID: <ahVVP_lDpTlRCPXD@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <ahByO_HWn6MB8z-u@lucifer>
 <CAA1CXcDoFdZZ4aBx0BPA7QXYKYBYDoqUiLTLYe3L5opJ0LsJGg@mail.gmail.com>
 <ahB_hae8coGvf12Z@lucifer>
 <CAA1CXcCoyGzEyeFPW+zKiA2AOj=0Lm7R=odLtVru+dQa0P_2cQ@mail.gmail.com>
 <ahCFIDuyrvEfB9jv@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahCFIDuyrvEfB9jv@lucifer>
X-Rspamd-Server: rspam11
X-Stat-Signature: wrrg9b8fzqnq3cfhcsgsjznpbteqcj1b
X-Rspamd-Queue-Id: 23FEE40010
X-Rspam-User: 
X-HE-Tag: 1779783304-954812
X-HE-Meta: U2FsdGVkX1+5u4roCG8MfF3AxYHYTvHyit9FUXlC2BbjKwQHD4Mg93Kt8vyRC1k4DiqBZgLcCURzGZKnzSAfDpFEQ8DbzTcZb6PpJcaP1nsCZF/lGfik+UMozMTY6sFRLxKBOwRMdA6Z529po9/92lDaUTE0vCPfRwQ3i9F73s1T3J81eSloEci745v5iZ9vtUTLyybxlOVML64K//Zarpn3OIo+sVpDm7JQ0Qi9UCzHgymq8xRBYheLFCy5TtgziSap3q3y263/ddDwU5bgY/LZs9/WZBhWevpIWl3cM/4KVu2K9eTDzb3XZknWZirwjSOSP6uKB0poMaOpMRzFRIL7jDiXuynAkD5PyKVBFZ6McavU76Pdz9PjWepnHsi7Uy9dIdTNYb2BFqNYzb69ulAa9RXOmQE3NPZ26YyrMI+vf+uj68/xM61tvYnKf7lbdwllQ1z5a4I+ijkv1v0iZUJgLnTu2QONEWFkN7beff+q94huOcLpGLsaVg17iivw+948jaAC6jUXVHc+qSgnKLzoTsqmRqzmAGxkRUlGzCPYIi5UdSDYsX78n0uAZt987oY7Pqz5zE/cVgOurTrK5c/OXV0ucp1n6U/hNssuYoYs3vUv+iJudeq0EIhUNAQFF2IdPlbPLi6m+VDMCjR9WDH+gGSpSoJFZ8eIa+TOYJ3yYRsYU1oR2JMnfCbJwiK/ACQVYnp+R5aPP94Os4lr7WHHKujBj+pYVOhXT/OxCKIX0u86UtZxQgFqNQuG/T/sjw9uKPFlFCNWdHMD3L2QUj+UJI+1KXxoCZ9LQ281/OIKu80stybDoVd+AxIVdnrf6nWn2CaXTZFRQz5hWZz6GKNiGZa2vY4YcSckTtKrl7udya/AIcObLYVmhNHRxnIuz8yBSp1VENWrdXcbB6d5Tdjkeg1e7Yn29f32ZlXTnDCbf/83q16M8s19COq9gsebQGSa/lJuA9ddajbGAPP
 KodhCWub
 0/CHa9ZxsfNmpdhFTZSlhhjb1xq6JI0jzTtElxYcI+eg/jhwD6nvSfUs01UJIArbpR6NI8bPm84uu0vV8AhjW/khGKQp/qrd7uVn/JYRXV4505AjIoEPLiHSljXrgZX1j1gqSuo0n/gV0aQWY55PUjCzdgidY4pOQsnikUj1dE072Ppdi3E+MrJdbR4MHCDHmKsuHx/9087LO6N0nVamxqf0LfMcG73p0h77JK4nEdUOGwYIZSYqbdjsU8ejN9XuZJHievf33Q8iWGvG+fgTFUYm6HtfQU9nYXo4JG/5fdUX+7CTG8c39cWVzoWgUS3Xd0htz9onx4onx+bZLS2EbfVgCS6mW28j0qAmiSN4h8Y144zIxoXJi2D39ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nico,

While I stand by the below, and we very well might wish to delay this until
the next cycle, I will try to take some time to go through this myself as
soon as I am able.

If David's happy with it for this cycle, and I don't find anything too
crazy, then it's not impossible we could still move forward with it now.

My only aim here is to avoid rushing something in that might have
unexpected changes or issues in it, given how late in the cycle we are :)

Cheers, Lorenzo

On Fri, May 22, 2026 at 06:12:59PM +0100, Lorenzo Stoakes wrote:
> On Fri, May 22, 2026 at 10:31:41AM -0600, Nico Pache wrote:
> > On Fri, May 22, 2026 at 10:20 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > > There's some kind of confusion here.
> > >
> > > This series isn't suited for 7.2.
> > >
> > > Sorry but Zi's series, unless it depends on functionality here, will have
> > > to be rebased.
> > >
> > > People have been at conferences, people have been on leave, I've had to
> > > pace myself for health reasons and it seems there's been more than simply
> > > review comment-based changes happening here.
> > >
> > > (Again I strongly encourage, at this stage, to ONLY be making changes based
> > > on review, not adding ANYTHING else or changing ANYTHING else to avoid
> > > delays :)
> >
> > All the changes are based on review points. Very small changes in this
> > version; the largest being the one that you specifically argeed too.
>
> 16->17
>
>  Documentation/admin-guide/mm/transhuge.rst |  24 +++++-------------
>  include/linux/khugepaged.h                 |   7 ++---
>  include/trace/events/huge_memory.h         |   3 ++-
>  mm/huge_memory.c                           |   2 +-
>  mm/khugepaged.c                            | 168 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------
>  mm/vma.c                                   |   6 ++---
>  tools/testing/vma/include/stubs.h          |   3 ++-
>  7 files changed, 103 insertions(+), 110 deletions(-)
>
> 17->18
>
>  Documentation/admin-guide/mm/transhuge.rst |   5 +++--
>  include/trace/events/huge_memory.h         |   3 +--
>  mm/khugepaged.c                            | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------
>  3 files changed, 66 insertions(+), 63 deletions(-)
>
> These are not small 'very small changes'.
>
> We're nearly at rc-5, and this is a major, invasive, dangerous change that
> we have to get right.
>
> You've also made changes unrelated to review, repeatedly, throughout this
> process, which as I've told you, is causing delays.
>
> You've also throughout the review of this series done stuff like make MAJOR
> changes to things and _kept review tags_.
>
> You're forcing us to use git range-diff etc. to forensically check that the
> series is what is claimed.
>
> Dude I mean you switched to using // comment style which is not used in mm
> anywhere for instance? Don't do things like that and complain about
> delays. Honestly.
>
> Also, again, LSF happened. Other confeerences happened. Bandwidth is
> reduced.
>
> So again, I'm sorry, but you've been hit with some bad luck here.
>
> I really wanted this in for 7.2, and I feel bad that we couldn't make it,
> but you're also doing thing that's making it difficult for us.
>
> I've spent double-digits hours on your series, and I've also had work
> pushed out becasue of that leading me to work evenings and weekends as a
> result.
>
> And I'm not even going to get any credit for it :))
>
> So while I sypmathise, really, please have empathy and realise it goes both
> ways, please.
>
> I'm not being mean for the sake of it, I'm pushing back because I feel this
> is not at a stage where I'd feel confident in this being merged at this
> time.
>
> And it's very much a regret, as I _really_ wanted us to have it in this
> time. But life and circumstances and the issues mentioned above have
> intervened, sadly.
>
> >
> > >
> > > Also - shouldn't mm-unstable already have mm-hotfixes-unstable in it?
> > >
> > > I think in mm-next we will have an stable branch, that everything is
> > > based on, where things go once review is complete and things are mergeable.
> > >
> > > And a separate hotfixes branch based on Linus's tree.
> > >
> > > That would avoid issues like this :)
> >
> > Im sorry im new to this, but I really dont think this tiny error, and
> > something that I'd confirmed with Andrew beforehand deserves NAKing
> > and defering it. Ive worked through my PTO to clean up some of these
> > review nits just to get it in 7.2. I even through this through my
> > rounds of testing today before resending.
>
> The issue wasn't the error (though it wasn't tiny...!), it's the state of
> review. There was fresh review comments from a few days ago, and there's
> big diffs between revisions.
>
> You've also made unrelated changes as you have done throughout the series.
>
> As I said above, I'm sorry that you spent time in your PTO on this, but we
> cannot rush this in when things are not clearly ready yet, and I am not
> confident in this being ready at this stage.
>
> >
> > >
> > > >
> > > > The intent wasn't that this is a hotfix, just that this was the
> > > > closest base before the v17 that is already in the tree.
> > >
> > > The convention is that [PATCH ... <branch>] indicates the target of the
> > > changes. Putting the hotfixes branch there implies it's a hotfix.
> >
> > Sorry I thought the <branch> was what base you used.
>
> I mean, sure there's clearly confusion here as you sent [PATCH 7.2 v16 ...]
> (against an unreleased kernel version) then a branch specifier then the
> hotfixes one...
>
> Anyway sure, it's fine, I've made vastly more dumb mistakes than that
> myself, nobody minds, but it's concerning as by convention [PATCH
> ... <mm->hotfixes<whatever>] generally is taken to mean 'please rush this
> to hotfixes!' :)
>
> So be careful with that please!
>
> >
> > >
> > > So please be careful with that in future :)
> >
> > Yes will do for sure.
>
> Thanks!
>
> >
> > >
> > > >
> > > > Sorry for the confusion, hopefully Andrew can still apply it to the
> > > > correct tree.
> > >
> > > I'm not even sure what's best for that at this stage given we have
> > > conflicts and this has to be delayed until 7.3.
> > >
> > > I wonder if given that we should not have this in mm-unstable at all and
> > > just wait it out until the next cycle begins? Review can happen
> > > concurrently.
> >
> > I still dont see why this has to be deferred, I was working with
> > Andrew to prevent merge headaches.
>
> I've explained the why above, and David and I co-maintain THP so I feel
> that ultimately given the blood, sweat and tears we've put into THP review
> we ought to have some input on this :)
>
> Thanks, Lorenzo

