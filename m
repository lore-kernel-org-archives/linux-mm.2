Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA641CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAF26B00A5; Fri, 22 May 2026 13:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AF16B00AB; Fri, 22 May 2026 13:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A546B00AD; Fri, 22 May 2026 13:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03F9A6B00A5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:13:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C636C1C08FF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:13:02 +0000 (UTC)
X-FDA: 84795701004.26.1BE732E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 21933C0007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:13:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rwju4gJq;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779469981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiyUFzZqN9pslbNTfSLwhf195Bg0GoCgngfEHT8mMw0=;
	b=Sh5YperDvRcqRC5Tns7486lOe3XCwmxr+KrlvBVw4hA66gNURWYgtAbPkmRbQ5bAYqZgXM
	Qh+ND7uUsHQ0rH9NFRd767gJS3bKEWShxRTbnn+u68auzpYGeP3/jRV2RSYj0VhVyq1Yo+
	EG5wX/uyDifTurybPnY/Bowz3zxJXs8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rwju4gJq;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779469981; a=rsa-sha256;
	cv=none;
	b=UgwBFO8lG5FOcdvDnv8hwjKCdF+sLwvehmXucDcxcvxOchG/jcI4h+T+xs3zd40S3bqwGa
	iGe2IcFZ4t5TphlQixxasm3gAr9rjlbgBCRYv0w9AjRDYxbN5LChlJagqqcuNngaOhzacq
	cDdagASxT5o26E6mt4DCEzKZYxrT158=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41F22443CF;
	Fri, 22 May 2026 17:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0BE1F000E9;
	Fri, 22 May 2026 17:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779469980;
	bh=xiyUFzZqN9pslbNTfSLwhf195Bg0GoCgngfEHT8mMw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rwju4gJqo6X1kuG/alZGdb8qj4XKrN6BeadFhi6a0JPO+wNw1dtRc2RLZg5P6ha2d
	 XqclErO1kvpWmoLCalNTwEUA9/C0qUpSHHOQFnGNMmqfdsap2UB5iBMMOBZRIcTQbl
	 OqqpJ270JMx3f3360gBWgYv0gFL+Q2R506NoBgZWcUzoQwyXvOuwIXk53kY+DcK9mg
	 ZaleTCjdvABCBuqe6tAC5FtnGGM/7UQqzM5z3gha9yX4WQrWhvQ80Fnox7mFoqSI/o
	 FYJddHUP8I5dbmiFUqHx3lASyRJ/zyQ+AqcXMj0lhFtgUXOalRWryX6DuxwmlU1RBt
	 ZVtnlemjeZ6ww==
Date: Fri, 22 May 2026 18:12:45 +0100
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
Message-ID: <ahCFIDuyrvEfB9jv@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <ahByO_HWn6MB8z-u@lucifer>
 <CAA1CXcDoFdZZ4aBx0BPA7QXYKYBYDoqUiLTLYe3L5opJ0LsJGg@mail.gmail.com>
 <ahB_hae8coGvf12Z@lucifer>
 <CAA1CXcCoyGzEyeFPW+zKiA2AOj=0Lm7R=odLtVru+dQa0P_2cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcCoyGzEyeFPW+zKiA2AOj=0Lm7R=odLtVru+dQa0P_2cQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 21933C0007
X-Stat-Signature: cddi86rxoteh4c5nrc9jz8ka74sghg8a
X-HE-Tag: 1779469980-219511
X-HE-Meta: U2FsdGVkX1+8+gFoWT90knEWVvwP2ocLZ63ZREK+2Bx57fKYLROKCoimb9QU44rPjNcV6saD1x55/QpHV4QAwOy4FDVy+E78oU69lpu0HIkz9Zi0Z2Y5Updra082U3g2ZrGr3RdWcMVCbL9+9bO8r/pn92oXqIYEcrS+0aNqirMG3HIX0rcgkt6Op4KaGwkKqLz+UDDO9GCFlHaSWXUDeceNAS3b2081DguWE/8/8MsusxhCIN+wBOgxLpvhh1IIczNbRi76/kYPOe1Fl92QG2aJWuoo5OSzX1Ef07yPyW7h66aPiiGzt3g5xySmrcQ8lFYwsRP0dW+b7+A7CGkdxeIGBKP836CJol0gz5TcECRAhzWbwk/YT4JJ7m+wBOIo8VyghH3MklWcm0P0qChJRnouskqsyxzhQxGsHxRBYmmuGy+jUKZABQ0sQxWKomaey80+MZVFSpAvpzQvWCVHEgLnqtt/BqF3fz+cyPmRzsaSRXgDMOIde9Xaxx+zosf9h+afMpJwreAtal6osCj5KQY2xlcdCkhQleBH5FZRGb01EA6H5wN70FDc1ZAwwm0peOQXZGGMzUAhnCtA9ibfInv500ttfRxl+JqtU7+HgjESKHxWDvGoefvTYMg7NEgM3M4nVig1fKmjnf1A04p8C24Tmi1mfzhkNKFbluiF3Td1gS0HW+Ax042zdKkot9EKdW0z/KF6uvRn63/Q0GYm9cTKIfG/oIT4hVso+jGvBLwCv+g+6M0Ryf6XnJPYs5hAwlt/E6owi5qRL5URxiLXoYzpZW918I9LZW/8lf4yR/jJ2N8NCDu5oN8J5M0AmkcT8/qhR8q+oZp6E3eBfK8gnFuBoQ48dpDgRuxjmXLVB82vJPOebKgcUs69OOieIOWHABZU190yXIrC6K6b0Cy9GHHZHzA+Pizq861n/EaTEpHaod61UpAW0JW0OaJfeYfCtBVpfZNXGqD+dWwVrwv
 kn6L1oQm
 1CO8gf/UVK5SmDewFjPQSQGO6PX/I3duQEOPloti68cdZcJPJWxA+5mQ2rZDbTs+zK9wlzeuHpV40YP8+dPSaTc7qFbpJ9KXMsKkjILmnvFJmYwc66XAGKap2X6fe9GFoi0fr8Xq+z2Ht5us7DaMvd+lyciJs0d0nD4lD1KUoU+M4VadrqtZyz34EgDdHyePUtdUPZ/+xI6iyiOS3RgbbCFNlpX7FSZF1hTuUfx4hPYUmPIT4/tVK0OfefMfP9F69N6ruLVbDnr3ZKb5fYZhpqhIjS6bEWRYCOOqESSeK18Uf/RQnyMfDqWeXX/TT9R0DNf297GMPPBGF91dWlx5Lp7vNvnZpz8J1OfuWXmZTPkODtJAgtaB28sTz8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 10:31:41AM -0600, Nico Pache wrote:
> On Fri, May 22, 2026 at 10:20 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > There's some kind of confusion here.
> >
> > This series isn't suited for 7.2.
> >
> > Sorry but Zi's series, unless it depends on functionality here, will have
> > to be rebased.
> >
> > People have been at conferences, people have been on leave, I've had to
> > pace myself for health reasons and it seems there's been more than simply
> > review comment-based changes happening here.
> >
> > (Again I strongly encourage, at this stage, to ONLY be making changes based
> > on review, not adding ANYTHING else or changing ANYTHING else to avoid
> > delays :)
>
> All the changes are based on review points. Very small changes in this
> version; the largest being the one that you specifically argeed too.

16->17

 Documentation/admin-guide/mm/transhuge.rst |  24 +++++-------------
 include/linux/khugepaged.h                 |   7 ++---
 include/trace/events/huge_memory.h         |   3 ++-
 mm/huge_memory.c                           |   2 +-
 mm/khugepaged.c                            | 168 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------
 mm/vma.c                                   |   6 ++---
 tools/testing/vma/include/stubs.h          |   3 ++-
 7 files changed, 103 insertions(+), 110 deletions(-)

17->18

 Documentation/admin-guide/mm/transhuge.rst |   5 +++--
 include/trace/events/huge_memory.h         |   3 +--
 mm/khugepaged.c                            | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------
 3 files changed, 66 insertions(+), 63 deletions(-)

These are not small 'very small changes'.

We're nearly at rc-5, and this is a major, invasive, dangerous change that
we have to get right.

You've also made changes unrelated to review, repeatedly, throughout this
process, which as I've told you, is causing delays.

You've also throughout the review of this series done stuff like make MAJOR
changes to things and _kept review tags_.

You're forcing us to use git range-diff etc. to forensically check that the
series is what is claimed.

Dude I mean you switched to using // comment style which is not used in mm
anywhere for instance? Don't do things like that and complain about
delays. Honestly.

Also, again, LSF happened. Other confeerences happened. Bandwidth is
reduced.

So again, I'm sorry, but you've been hit with some bad luck here.

I really wanted this in for 7.2, and I feel bad that we couldn't make it,
but you're also doing thing that's making it difficult for us.

I've spent double-digits hours on your series, and I've also had work
pushed out becasue of that leading me to work evenings and weekends as a
result.

And I'm not even going to get any credit for it :))

So while I sypmathise, really, please have empathy and realise it goes both
ways, please.

I'm not being mean for the sake of it, I'm pushing back because I feel this
is not at a stage where I'd feel confident in this being merged at this
time.

And it's very much a regret, as I _really_ wanted us to have it in this
time. But life and circumstances and the issues mentioned above have
intervened, sadly.

>
> >
> > Also - shouldn't mm-unstable already have mm-hotfixes-unstable in it?
> >
> > I think in mm-next we will have an stable branch, that everything is
> > based on, where things go once review is complete and things are mergeable.
> >
> > And a separate hotfixes branch based on Linus's tree.
> >
> > That would avoid issues like this :)
>
> Im sorry im new to this, but I really dont think this tiny error, and
> something that I'd confirmed with Andrew beforehand deserves NAKing
> and defering it. Ive worked through my PTO to clean up some of these
> review nits just to get it in 7.2. I even through this through my
> rounds of testing today before resending.

The issue wasn't the error (though it wasn't tiny...!), it's the state of
review. There was fresh review comments from a few days ago, and there's
big diffs between revisions.

You've also made unrelated changes as you have done throughout the series.

As I said above, I'm sorry that you spent time in your PTO on this, but we
cannot rush this in when things are not clearly ready yet, and I am not
confident in this being ready at this stage.

>
> >
> > >
> > > The intent wasn't that this is a hotfix, just that this was the
> > > closest base before the v17 that is already in the tree.
> >
> > The convention is that [PATCH ... <branch>] indicates the target of the
> > changes. Putting the hotfixes branch there implies it's a hotfix.
>
> Sorry I thought the <branch> was what base you used.

I mean, sure there's clearly confusion here as you sent [PATCH 7.2 v16 ...]
(against an unreleased kernel version) then a branch specifier then the
hotfixes one...

Anyway sure, it's fine, I've made vastly more dumb mistakes than that
myself, nobody minds, but it's concerning as by convention [PATCH
... <mm->hotfixes<whatever>] generally is taken to mean 'please rush this
to hotfixes!' :)

So be careful with that please!

>
> >
> > So please be careful with that in future :)
>
> Yes will do for sure.

Thanks!

>
> >
> > >
> > > Sorry for the confusion, hopefully Andrew can still apply it to the
> > > correct tree.
> >
> > I'm not even sure what's best for that at this stage given we have
> > conflicts and this has to be delayed until 7.3.
> >
> > I wonder if given that we should not have this in mm-unstable at all and
> > just wait it out until the next cycle begins? Review can happen
> > concurrently.
>
> I still dont see why this has to be deferred, I was working with
> Andrew to prevent merge headaches.

I've explained the why above, and David and I co-maintain THP so I feel
that ultimately given the blood, sweat and tears we've put into THP review
we ought to have some input on this :)

Thanks, Lorenzo

