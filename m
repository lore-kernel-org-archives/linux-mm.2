Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C8ACF532E9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 07:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A6A6B0005; Tue, 24 Mar 2026 03:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01E46B0088; Tue, 24 Mar 2026 03:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18116B0089; Tue, 24 Mar 2026 03:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC4176B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:56:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F894CE474
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:56:28 +0000 (UTC)
X-FDA: 84580199256.16.A5A5A4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BCE7D20005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:56:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TyDxYHZc;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774338986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gRsDUEq4arQyAXB3zsBNdgM1Lz5Y3q2vICkF4GCfOk=;
	b=Rg84HghDP1GOQFMKW/dpgPSaB2NfGhP8m92pNlRf6zjoaRglcr8AFOtIsVk6ribX/0hYyg
	uDN2zSDRmsYn7f66aUFUCZVlXXjkqY6JrF5cBRKS5lgqOXNLE4PG938//KxoCVMfxfs+ZO
	gpqKEMu5bHbvJsJQQu6JbNxPkbdy3Gk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774338986; a=rsa-sha256;
	cv=none;
	b=UiQy/8PVPFn1G7s3799qBc5bTF7LYjiTF0iT0YkHIJWUjUOC7Yoetf7B0wMIOYVfZQqS8S
	AV8T5B5FY9L1EbFaYMRVR3AoBRND825NhYf9a1DAxkuOfybYLKLUrHA3a6WjTQr7bh9VlA
	jtQQMh5vbKk+3JgDHEyss9x8SE1WX0s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TyDxYHZc;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE30344057;
	Tue, 24 Mar 2026 07:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3101C2BC9E;
	Tue, 24 Mar 2026 07:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774338985;
	bh=9wk/bFX4nd5dQmEjgYO5uHVfG2XbjHoZhownInZ0UCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TyDxYHZcWJy9JXm0+c5avwfcMa9JoWbC2/en9T14Y7tYB7qXgeDUuSKa00HanKDgc
	 dqwyeP50vhX97cVUoKu+FedXlVdRwD7mEJ/t8Mfi9071abZfQNpmwyoKnYyfSq5GSt
	 nEeRC9PPiNe92A88wJx0eF+feTjOMGewBsw6t4hV7/pAgnUnIQMrH3MeNpL7o4adCX
	 L5N6apKGHgMF4711qtqUqMQ0qSq3cAjyAddIyRWgn7NtfsSBVbSN8v+qpj/NfFi9vu
	 N2SmSV7cPZim76cnretAGL30gc9gPMzQS4PYkAAuZxLI1QwfaqLoQB4x/7rvKLEsQ6
	 /GaomKEFR4GvQ==
Date: Tue, 24 Mar 2026 07:56:19 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <bc42fdda-6be2-46ef-bec5-1ae82092f61b@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
 <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
 <87jyv2hw50.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jyv2hw50.fsf@linux.dev>
X-Rspamd-Queue-Id: BCE7D20005
X-Stat-Signature: w6h493qkixq586qzfj31xqdguy1kgwtn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774338986-864024
X-HE-Meta: U2FsdGVkX1+boVb+QiMeqkBfJS2SmvJLmb4zrpQL0vIWGVOakb3XJUAiRnkdJnA7mNyOKmLYoWNXxccwPBdx6sPztcx79eKDMq7nnus4CJ8Xv7SUSQwdwFn7t+1IMPLV3aKV9NOEHi9R7DD98GuHeDyuZqBl3MvmOcJ/wl8ZbaHl/d1UgvLI45ctoSbt30vv0W86hbASOWMriok7PccG6TVIxhbX8YLKOdebvLDxhA4BRgHAV9tEJheD+GVA5ESIdfFkzNnGy/CESzwWgnGqn+pYw1DkDZDiUmNrAndUsNtKngpbNe1kKgpxpQkmExQYMILwJrqB/UKFUT3w83ObdZfmaU3Ix70ng/0FjUzLHHe8yXr9oFFMUBQOZJCsPjz7B1+iMsGNIdCJUtSrQI36psSaFhM9jBA8d/G++vjRMJGiKIA99RwO8t4wjOl/sD7H0ohdwn34WB/1gnQUAQtqQnSidUuY/Wu8gXRr0orVnaStWhN+DCPeHYu1lEu2tdyFAHGk0+SS2V1HgY/4pTWtdI2CeEKj3vF6t04R4gGVupD98O6JH36iXHmV3KBI7mz1/JWvjgxBfFFWSgi6tgG9d1Ne0+Uv/J3iaT1AJ/JesLXbAlBWbO53V0fEStH/awFjDpRCFCuI6/xePwxP1+UqElHDO8EhXpF9Z9byToMD51x/sDNJNYpAjQGUM/sV22tQng/X8jP/jJWMGEdV8CK2zb9TMK4kS+R1EU0gAgJjjfqHK1zm0xP6Xt8EvxIUg3UnGjfxghfxpadwSC0mhbp7r0onkTM5NPs4ptSHLFxWQ9yKVl/rKxtedQV02/Co1c9O26IYNPjx4uHTYY+XyAIQqlR0QJDW2GSBR6uwMFCiF4Dt1uy8EKvJoWJ87SRbta3fj1AmBYFqCMlYOwcAf6rGbg98LQZr0C0ndtcSytiYkC9kFqtPWiOG6khp9lHjyoGFg4kVhEt/3hyLnMUsKZ1
 krHDwOaO
 89+sJrx+a1FXJ8n/k2i/S4jIR51Yc0yjuODDsy+RK2XwHpEi7M26PkP5TrzCZJ+SommC94g+/9C9qa/wQlJ28bk5dXopZcImLBVO4+LW2UMbWD8ZelMocTQCjwGagegNVfas4v2BBxAE2CH/5dYBTwvKTbwPJtdKg0846oIVaUrV87FmNH/dXtpfRAI0KI951nAjL62CEY4f3508GapbO3sIy21JTQkFhitXw2Q+JUyEDOq60KcOQZllhfL9Ij2FZujpVqp96cdQkSNAxRmfa8LUaD9M31XKLfxPXTCfXpYGlp47HBX4ZD1XPirMHkzP7IK4aIY1V3Kf4nbHjFY7pnxkqQUDqjxTZfPz9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 06:08:27PM -0700, Roman Gushchin wrote:
> "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> writes:
>
> > On Sat, Mar 21, 2026 at 05:15:30PM -0700, Andrew Morton wrote:
> >> On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >>
> >> > A lot of patchsets are "failed to apply".  What is Sashiko trying to
> >> > apply MM patches to?  It would take some smarts to apply the v2
> >> > patchset when v1 is presently in mm.git?
> >>
> >> ?
> >>
> >> The way things are going at present, I'm just not going to apply a
> >
> > 50% noise vs. signal?... maybe wait until we're in the 9x'%s?
> >
> >> series which Sashiko "failed to apply".  And that's cool, I'll just
> >> wait for a version which Sashiko was able to apply.  And then not
> >> apply unless all Sashiko questions are resolved or convincingly refuted.
> >
> > Andrew, for crying out loud. Please don't do this.
> >
> > 2 of the 3 series I respan on Friday, working a 13 hour day to do so, don't
> > apply to Sashiko, but do apply to the mm tree.
>
> I'll look into that.

Thanks.

>
> > I haven't the _faintest clue_ how we are supposed to factor a 3rd party
> > experimental website applying or not applying series into our work??
> >
> > And 'not apply unless all Sashiko questions are resolved or convincingly
> > refuted.' is seriously concerning.
> >
> > The workload is already insane, now you're expecting us to answer every bit
> > of nonsense Sashiko hallucinates or misunderstands also?
> >
> > I say that with no disrespect to Roman or his efforts, but as discussed at
> > length, it is not ready for prime time yet.
> >
> > It's clear that Sashiko is not correctly handling applies, and produces a
> > lot of noise. Predicating taking series on this is absurd.
>
> Not trying to pretend that Sashiko is perfect in any way, I think a good
> mental exercise is to put down our expectation how the "perfect" system
> would work. The more I work on it, the more I realize it it's far from

Throughout this discussion I have been making practical points. Nobody
expects perfection.

I am simpy saying unilaterally demanding that every single point sashiko
raises is responded to out of the blue without any community input or input
from those doing review AND requiring somehow series all apply is not good.

BTW, I don't want to make you the scapegoat for complaints about mm process
here :) so I am being careful not to criticise, as I realise when people
are frustrated with tooling even if _totally irrelevant_ to you as the
maker of the tool, will instinctively want to blame you.

I refuse to fall into this trap ;)

> binary correct/incorrect. In fact, the same applies to humans: I'm sure
> everyone of us had once this feeling that someone is to picky and just
> annoying us with finding small nits. At the same time some of these
> people are extremely useful for the community to find and fix a lot of
> issues. In the end, we do argue all the time about questions/issues
> raised by human reviewers.

Yes except human reviewers generally evolve over time to be pretty high
signal if they remain consistent, that is at least how it is in mm. Even if
you think points are trivial.

Sashiko is hallucinating, it is raising irrelevant points that have nothing
to do with the series, it's creating responses that require serious time to
decode.

I have not encountered review in mm that is even anwyhere near the ~50% hit
rate, rest potentialy violently wrong/wildly irrelevant that sashiko
generates.

There's an asymmetry too - sashiko can just keep on generating this stuff
indefinitely (well, limited by tokens of course :), and potentially
generate serious useless work for submitters and reviewers.

We _have_ to take that into account when it comes to review process.

Again, this is nothing to do with the tooling which I'm grateful, again
it's to do with mm process. And sadly you've been dragged into a debate on
this which you are ultimately more or less orthogonal to :)

>
> Like do we prefer a system, which finds more real bugs at the cost of being
> more noisy or we prefer a system which misses more but if it points at
> the bug, it's certainly real? I'm sure you tempted to prefer the latter,
> but image a hypothetical system which finds _all_ bugs, but has some false
> positive rate, e.g. 20%. I think it's pretty attractive.

I think we are very far from that right now. The issue is how it is _now_
not in some imagined future.

And it's easy to pontificate about all this, but in the end it's the
sub-maintainers in mm who will have to eventually figure out whether a
series is ok or not, and have to decide stuff people might do based on
hallucinations/irrelevant points etc.

Right now this is going to result in _more work_ for us, and already it
feels like in mm the sub-maintainers are the reason things function
reasonably, but we don't seem to be having our voices heard here.

>
> Also lot of raised issues are real, but subjectively are not worth our
> time. But this is extremely subjective! Depends on the personal level
> of perfectionism, amount of time available, the state of code before,
> further plans, etc etc. For example, syzkaller has usually o(100's) open
> bugs, which are 100% real, but not always are high priority work.

I don't think it's anywhere near as subjective as you say, and I think
that's easy to hand wave.

One issue here is - trust. There are people in the community we trust to
whom we asssign M: and R: entries in MAINTAINERS.

Trust on taste, judgement etc.

Now sashiko is essentially proposed to be given the same trust despite
absolutely not deserving it.

What I propose, as I did in the other sub-thread here, is to use it as a
_tool_ to _help_ sub-maintainers do their job.

Not for it to become a new trusted gatekeeper out of the blue and
unilaterally while adding to our workload.

>
> I think that asking to address 100% issues raised by any LLM is not
> reasonable (especially because it's output might be different each time

Really, again with respect and trying to dodge the 'blame the tool maker'
thing :) that's something of a strawman, nobody is saying they require
that.

I think >~50% signal is a reasonable ask though.

> you runt it with the same input), but I also think it's reasonable to
> address critical & high severity concerns. And I'm happy to tweak

Right, but with respect you're not an mm maintainer who has to deal with
the resultant fallout :)

> Sashiko to be more conservative here, but I think it should be based on
> some specific examples or data, not purely subjective.

Well you can't both say all review is highly subjective and simultaneously
ask for objective feedback :)

I have provided detailed feedback on a specific example elsewhere, and I'm
telling you as an experienced mm maintainer that the hit rate is ~50% in my
experience so far.

I'm happy to feedback more, but it's again a time and workload thing - the
default here shouldn't be that mm is just taking sashiko input as read and
we have to jump on everything to explicitly say it's right/wrong.

Ideally we'd have some way of feeding back on the website, even if it's as
simple as a tick/cross as to what points you are actually accepting or
not. That'd be great I think!

That could be useful as well to Andrew who could see that in action.

User login wise you could have some system where somebody could send a mail
from the account that is being reviewed to get a login or something?

>
> tl;dr I increasingly realize the importance of the social context for
> providing good reviews, and it can't be easily derived from the code.

Yes for sure.

> What is acceptable in one subsystem is considered a bad practice in the
> other. I guess the only way to get the system we all find acceptable
> (and we still might not like it, who likes being pointed at their bugs?)
> is collectively codify our expectations in prompts on per-subsystem basis.

Well not only that, we need to figure out, per-subsystem, what our process
will be.

Again the contentiousness here is not around your tooling but really around
the unilateral announcement that we're just going to block on sashiko now.

And on that I am pushing back with detailed points as per the rest of the
thread.

>
> Thanks!

Cheers, Lorenzo

