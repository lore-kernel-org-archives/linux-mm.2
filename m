Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3561EE9A756
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4196D6B00A5; Tue, 24 Mar 2026 05:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CACF6B00A7; Tue, 24 Mar 2026 05:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0536B00A8; Tue, 24 Mar 2026 05:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0AE6B00A5
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:55:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5EE6E0677
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:55:14 +0000 (UTC)
X-FDA: 84580498548.11.521491B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 150FD100007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:55:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n95pV2Ix;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774346113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEZniZZvUyMZZUyue9O5b8cHxmnacA4Ab0/qLTx11AI=;
	b=aSS6nI+zAGySr13V30/n6vzO2Q1xCexr2zKDbiSlVLhvECLepo4pMC/phOdXbwHEQg+BS0
	luZDE05TUHR9Ek1OlPDDyoO657Jv6RB5bggXk0pzN0vdLezrHWW8q1bUfFioPMHhSLDa8Z
	RpIKsWzh9SpBtriLiNY2ouFLQ+ZXOQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774346113; a=rsa-sha256;
	cv=none;
	b=1EZ5ZRpamwRaZQKfCqtBYc+bT2LPYwEygFWHJQzTcNx9lZ3gEgPGKcmSu9gEses8BQbllw
	s5nLlPXSjiULFqmt49LjP4hJBZsO8s71WQKDkjh5ZUlRZreW+nEjU1ubZzoAsuW5Dar1ur
	UsoEFfuTvYzR5Z5HshcJrQO4sA2R6zI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n95pV2Ix;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58FEF60103;
	Tue, 24 Mar 2026 09:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0815FC19424;
	Tue, 24 Mar 2026 09:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774346112;
	bh=TOtQAdoYsufowVRlX8FzsolD+TBEzVDXgik+c8zNqeU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n95pV2Ix/tofmHPJdaa2/LhqGS61Bmo4BeFu9DXHtzuXZVYYZImI3p9VmuYee4M4d
	 INJ5LOSf8ID65YQn6BFxNFBPlpqCyf8KMHkGRpFFqUpLZ/UMMOoH8HCULP4f5ySNyr
	 OMKqoeed/r3LgMOP9PCr8MwvkbdptQQLVF3FOF1SELN6NgrftK70Q6YYPT5Taxr62n
	 SFz8B3yjyI8DVNQ0ZsbfCVpSTmVuX9Dsn+epPDZz/16InFyrz4v/RidA9gPnnF8ehY
	 e5DKuGWSe93CKpE/bn8VEef9w76dkBYVbwlprUxoXDJ1Bpi8B7bup+y9daUZicrPTU
	 ZiRWwngdm8H6g==
Date: Tue, 24 Mar 2026 09:55:05 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Pedro Falcato <pfalcato@suse.de>, Roman Gushchin <roman.gushchin@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <bd2ef627-16d7-436e-8fb2-6cac32e2632c@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
 <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
 <j6hsn4mxnzoukebcdggu6ojkyaj54joohocbbkrzksm47km7ni@zzp7aurwmto7>
 <20260323143604.603b20aec4e3ab77cabec107@linux-foundation.org>
 <acJEFArj6uw2Z_2e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acJEFArj6uw2Z_2e@kernel.org>
X-Rspamd-Queue-Id: 150FD100007
X-Stat-Signature: w6eqeyisc8uz6zpmoiu9614xwcwhekpd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774346112-21696
X-HE-Meta: U2FsdGVkX18yQMLs92mYvTQD9vKYLlAHg5u1hU7NeIi08e36hLUXO+ASwNhW7D9KXSUWNVcGXyw7xT33yv90BE28iPdXJAJ6y9ikCcXUwe06mTL9nfCCmw+YgHbaB59RxMQSR+arOknNrSYa3gKB8HqRRDuGqR+32Jgpp1XhZchnWWzg1A78B5iZivNUCtj0IUJMQhLBMgpJASKjWcdNaaOdS/u66pyEawAi+SK1CkRMPyM5yrX0IITUsGgsYuTfhGgeBhOUzaegq0pzU5UdiPkfAsO6lXdJzcYQQgr6YmnIPv4GwOCnidViWbCGFnyh0jUEdeUmYqdlKx8SWUcB0V1wMkyhXjW8zkPzLhv3opJYj9zbm0Sk2/xpWl+KXpv7k0g9sbQLyjqy0ftz8j8g0SYyYegRhMjlhJSNUUWCKDyVHoVbKGDAWmH43eTdkCMnDd2xUqTi+2l8s9NzNnLtVH8ON2gqL0NuiTf+uVQRfxVW4Afg//zA8Gn5W/4dcjgOaGryC8wFegLwHXgu18h7o4YKe754mYpLeJ5GQmP6/KPNkNybka5H3DjAxlhbfiWnkSl6NKsrAPD3BFFJCRSZYrBcjTEAjCYQO0J4AGThkcJouJGvgzdlD0llXDlrDnVH38W16kSfbPX5iNpLpfiZa94DP33OuSQYVFOWJsvLEGKaCe1wcx1l72ISJwKhHqvCpA/CGq4mWum9Ep1r/TO/P1j+HAKLkS+yw9vRLrs8HaG78f1UUOPYBfMZoRRmU6tEpis24eZfaGwZo8bxXbDzuTuTUH40dD5U2RTWfZYcL2XaQSYp/ke3x78MXb907gu6q4eqhVFdxStCkxV5+pB1bjPEHcEqa85Dp3SnYy3PY1+xC6h093g6tqDE/W7c3lQNuB83KOXGXKc5Rhrd/m4RfyNkFVOP3RbO6786t/efik7CPDuMZsNMoOaGkyIBMh+cGZrK3tlPkJdLdDse50M
 slxrOCMD
 yKrCQbpS0YCOvoPg7hwdskmNA11Nz+j+g1RMmyAFzmyjhLtAhfSmMUPGwpRLpitXxT6jR8OslT64UYwK53kKYicPtA0yxGGYxj7sbi3o8x5vNZ0JMEq62LO0x9dwyZNCU4OnueWv2gjHwAlwhayaU5oZ4b/ViQKN19fcd7XYLyIpYnyZc9R+dt906lT/9ov8nOmJcVTc4b/U3daUcgEffLT9HvcmhnsU5vVJ4roZiU8o7lOdg0nB9Sva09VgfypQ0jYNrFF3+UUNDwU1hTThzhmV6eROx5wP5NDYJQl7vJ21ktSw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 09:58:12AM +0200, Mike Rapoport wrote:
> On Mon, Mar 23, 2026 at 02:36:04PM -0700, Andrew Morton wrote:
> > On Mon, 23 Mar 2026 12:34:31 +0000 Pedro Falcato <pfalcato@suse.de> wrote:
> > >
> > > FWIW I wholeheartedly agree. I don't understand how we don't require proper
> > > M: or R: reviews on patches before merging
> >
> > I wish people would stop making this claim, without substantiation.
> > I've looked (deeply) at the data, which is equally available to us all.
> > Has anyone else?
> >
> > After weeding out a few special cases (especially DAMON) (this time
> > also maple_tree), the amount of such unreviewed material which enters
> > mm-stable and mainline is very very low.
>
> Here's a breakout of MM commit tags (with DAMON excluded) since 6.10:
>
> ------------------------------------------------------------------------------
> Release        Total   Reviewed-by   Acked-by only   No review   DAMON excl
> ------------------------------------------------------------------------------
> v6.10            318     206 (65%)        36 (11%)    76 (24%)           10
> v6.11            270     131 (49%)        72 (27%)    67 (25%)           17
> v6.12            333     161 (48%)        65 (20%)   107 (32%)           18
> v6.13            180      94 (52%)        29 (16%)    57 (32%)            8
> v6.14            217     103 (47%)        40 (18%)    74 (34%)           30
> v6.15            289     129 (45%)        45 (16%)   115 (40%)           43
> v6.16            198     126 (64%)        44 (22%)    28 (14%)           16
> v6.17            245     181 (74%)        41 (17%)     23 (9%)           53
> v6.18            205     150 (73%)        28 (14%)    27 (13%)           34
> v6.19            228     165 (72%)        33 (14%)    30 (13%)           64
> ------------------------------------------------------------------------------

Thanks Mike, I've gone a bit deeper, classifying based on the _actually_
requested requirement of sub-maintainer R-b or A-b (not all reviews are equal),
and since sub-M's were in place ~6.15.

I exclude DAMON from everything, which seems pretty arbitrary, but for the sake
of being generous:

(getting some slightly different total numbers maybe mildly varying filters)

------------------------------------------------------------------------------
Release        Total     Sub-M signoff		No sub-M signoff
------------------------------------------------------------------------------
v6.15		289	136/289 (47.1%)		153/289 (52.9%)
v6.16		198	147/198 (74.2%)		 51/198 (25.8%)
v6.17		245	201/245 (82.0%)		 44/245 (18.0%)
v6.18		206	155/206 (75.2%)		 51/206 (24.8%)
v6.19		232	181/232 (78.0%)		 51/232 (22.0%)
v7.0 (so far)	188	135/188 (71.8%)		 53/188 (28.2%)
V6.15..v.7	1358	955/1358 (70.3%)	403/1358 (29.7%)
------------------------------------------------------------------------------

Now if we consider series _sent_ by sub-M's as being reviewed by default:

------------------------------------------------------------------------------
Release        Total     Sub-M signoff		No sub-M signoff
------------------------------------------------------------------------------
v6.15		289	204/289 (70.6%)		85/289 (29.4%)
v6.16		198	163/198 (82.3%)		35/198 (17.7%)
v6.17		245	212/245 (86.5%)		33/245 (13.5%)
v6.18		206	176/206 (85.4%)		30/206 (14.6%)
v6.19		232	200/232 (86.2%)		32/232 (13.8%)
v7.0 (so far)	188	174/188 (92.6%)		14/188 ( 7.4%)
V6.15..v.7	1358	1129/1358 (83.1%)	229/1358 (16.9%)
------------------------------------------------------------------------------

So 'the amount of such unreviewed material which enters mm-stable and mainline
is very very low' is clearly untrue.

In aggregate there were 229 patches merged (and by that I mean to Linus's
tree), or 16.9% without sub-M review or sub-M S-o-b.

I seem to recall you claiming there were only one or two series/patches
that landed like this for the past year or 2 or something like this? None
of the data reflects that.

Clearly there is still work to be done and clearly there are still patches
being sent that are not getting sub-M signoff.

It _is_ improving, but I fear that a lot of that is because of us sub-M's
burning ourselves out.

Let's look at that.

Rather than limiting to mm commits, let's expand and just go with commits
which you were the comitter for from 6.15 onward to make life easier:

Of those, there were 3,339 commits, and 2,284 had at least one A-b or R-b
(68.4% review rate).

Looking at commits actually A-b/R-b from 6.15 on and taking those in 3
digits or more:

-----------------------------------------
Author			R-b/A-b
-----------------------------------------
David Hildenbrand	484/2284 (21.2%)
Lorenzo Stoakes		356/2284 (15.6%)
Vlastimil Babka		276/2284 (12.1%)
Zi Yan			213/2284 ( 9.3%)
Mike Rapoport		193/2284 ( 8.5%)
SJ Park			174/2284 ( 7.6%)
Liam Howlett		128/2284 ( 5.6%)
Shakeel Butt		115/2284 ( 5.0%)
Oscar Salvador		111/2284 ( 4.9%)
-----------------------------------------

(Keep in mind I reduced my review sharply for a couple months during this
period due to burnout/objecting to mm review policy.)

Do you think that maybe some of the people listed here should be consulted
about these kinds of decisions at all?

Do you notice here that the people listed above (apart from Zi, who is
exceptional overall anyway :) are sub-M's?

The data overwhelmingly backs the fact that the sub-M/R changes have
radically improved review in mm.

This is something you have pushed back on, so I gently suggest that you
should be a little more accepting of the fact the data lays bare here
please.

>
> There's indeed sharp reduction in amount of unreviewed material that gets
> merged since v6.15, i.e. after the last LSF/MM when we updated the process
> and nominated people as sub-maintainers and reviewers for different parts
> of MM. This very much confirms that splitting up the MM entry and letting
> people to step up as sub-maintaners pays off.

Yes that's evident obviously in all the data, I felt it had a huge impact and
it's great to see the data dmeontrate that!

Andrew - hopefully that helps give some basis for the role of
sub-maintainers and reviewers in mm, I know you have expressed in the past
(on more than one occasion) that you feel these roles are meaningless as
you are able to subjectively interpret reviews - the data clearly shows
otherwise.

As a man of data, I ask you to take this into account please.

And as you are showing you are more than happy to wait for review when AI
does it, I genuinely do not understand why you would not accept this sub-M
signoff rule at this stage.

>
> But we are still at double digits for percentage of commits without
> Reviewed-by tags despite the effort people (especially David and Lorenzo)
> are putting into review. I wouldn't say that even 9% is "very very low".

Yes, far from it.

>
> > > Like, sure, sashiko can be useful, and is better than nothing. But unless
> > > sashiko is better than the maintainers, it should be kept as optional.
> >
> > Rule #1 is, surely, "don't add bugs".  This thing finds bugs.  If its
> > hit rate is 50% then that's plenty high enough to justify people
> > spending time to go through and check its output.
> >
> > > Seriously, I can't wrap my head around the difference in treatment in
> > > "human maintainers, experts in the code, aren't required to review a patch"
> >
> > Speaking of insulting.

Honestly I think unilaterally instituting radical changes to review in MM
without even bothering to consult those who do the actual review-work, and
responding to push back either by ignoring or dismissal isn't hugely
respectful.

I also feel you are not being quite fair to Pedro here, especially when the
data bears out his claims.

(I refer you back to the above data.)

> >
> > > vs "make the fscking AI happy or it's not going anywhere". It's almost
> > > insulting.
> >
> > Look, I know people are busy.  If checking these reports slows us down
> > and we end up merging less code and less buggy code then that's a good
> > tradeoff.

I mean you're literally ignoring the people who are doing all the review
work here and then saying you're fine with adding more work for them (it's
clear reviewers will have to account for Sashiko feedback in a regime where
that's a hard requirement for merge), as well as to submitters too
obviously.

So I honestly don't think you do know that, since you are ignoring
push-back from the people who are doing the work who are demonstrably VERY
busy.

>
> If you think this is a good trade-off, then slowing down to wait for human
> review so we merge up less buggy or less maintainable code is a good
> trade-off too.
>
> While LLMs can detect potential bugs, they are not capable to identify
> potential maintainability issues.

Yes precisely.

>
> > Also, gimme a break.  Like everyone else I'm still trying to wrap my
> > head how best to incorporate this new tool into our development
> > processes.
>
> It would be nice if we had a more formal description of our development
> process in Documentation/process/maintainer-mm.rst and then we can add a
> few sentences about how to incorporate this tool into the process when we
> figure this out.

I mean we've been waiting for this for a while :)

I actually think at this stage it'd be better for those
actually-doing-the-work of review to be writing these documents.

But then they won't match what's actually happening, of course.

>
> Right now our process is a tribal knowledge, having "Rule #1" and a few
> others written down would help everyone who participates in MM development.

Rule #1 presumably 'don't introduce bugs' has so many caveats in it it's
almost meaningless.

For instance, as a silly example but one that makes the point - if
reviewers were required to do two rounds of review, the second with much
more scrutiny after having tagged the first - this would ABSOLUTELY find
more bugs.

But it'd double the time or more taken to do review.

It's like saying 'reduce speed limits to save lives' - invariably you will
if you do, but there are other considerations. A 5mph limit nationally
might have other knock on effects :)

I'd say this requires _discussion_ with those _actually doing the work_
that keeps mm moving and stable, i.e. review.

Plus review comprises of more than finding bugs - in fact that's almost
secondary to ensuring _architecturally_ changes are valid and we're not
causing user interface issues and style and code quality and etc.

All things that AI frankly sucks at (at least for now).

This new approach, taken out of the blue and without community discussion
also FLATLY contradicts mm process thus far - Andrew has repeatedly argued
that 'perfectly good series' get 'held up' by review, and he really wants
to avoid that.

And thus has rejected the reasonable requests, whose requirement is now
borne out by statistical evidence, for sub-M signoff.

He's even intimated that stable patches don't require proper review in the
past.

Now AI is being instituted as a trusted gatekeeper and is immediately given
full veto power.

I don't think documenting this kind of decision making is helpful, but
absolutely process docs are needed, were promised, and have not emerged.

>
> --
> Sincerely yours,
> Mike.

Hopefully the data helps paint the picture here.

Thanks, Lorenzo

