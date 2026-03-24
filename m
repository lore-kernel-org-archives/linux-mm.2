Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AE8FEC0EB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 18:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A295A6B0005; Tue, 24 Mar 2026 14:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FFCE6B008A; Tue, 24 Mar 2026 14:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D806B0092; Tue, 24 Mar 2026 14:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8513A6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:05:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53C90C19FA
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:05:21 +0000 (UTC)
X-FDA: 84581733642.07.07B55D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 71BF8140019
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:05:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HYng9OtB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774375519; a=rsa-sha256;
	cv=none;
	b=vBvBMPtZ1PObE7Y+xC3jElGZtx+krmO1Z5xGMOH0PNOkxhS6sJHX9OuRyRuau5zxBCUG53
	iKWDz6S8VvY5llHQK9Saf/miF0lZU2dalZ2KDOpGqTkg0wfDg732MiUwcNrgt9jRgMmnt/
	fKpEZX3UeGzZgZgsxYscinRFJGX+9GI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HYng9OtB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774375519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dlqLVj4YBSMV1ERLVNSMCZNx+SUiXN6lfv+s7nDtV8=;
	b=HHRzuyCyGSPCUvE+IVpJ0JJh3FQEq+WUlUQ6jV3eGu/U/EVXN01CdozXO0Zvdp3z2uft2+
	vcA2fMCqwFxZCPyqmRyPe66bXGP0MOHAzBWF4/flB/2ACwcPvd7ezR3eyoaz5nE9vSECCe
	GIN3E+YEUnpRItdP2ST5IifygJ4o9+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4300040329;
	Tue, 24 Mar 2026 18:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462B7C19424;
	Tue, 24 Mar 2026 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774375518;
	bh=dmkRpgdtLkIEFoeBi070LGyRImhGBs3fJfDu8AW5C6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HYng9OtBkL9m0IDKN7mnqzPLDKzDYnqlNh5YSBxeLqvdh7dqGMrPKPZ1N2U69+xqv
	 4IbjCvgG3LAu1TOUbejluvtcLSSuEiK0QTIHaRRu/ByyM3GfpJCNRf2FaECa053qCg
	 EZ69s5SHRAqqJ5Aajze3Zxuj4Su5evUZ6Ubyre8Nuj5nsuR2OwDE8Y2pz1br4NRB9m
	 7MwcbqlaHIwdEJxrkUXY6NJdiO8DcPoNMt2YNM+u6mI89NMN5lkOla1nracQqvZttg
	 atl/FFkRYb2ZBRrQ3UWRetow2vVClDWHngIVE17ar0n9siY/N/TYoNqaJXOBGsLH+Q
	 xx6WEkPoJq0VQ==
Date: Tue, 24 Mar 2026 18:05:12 +0000
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
Message-ID: <2662aff7-d437-47e8-8ccc-3233476dd813@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
 <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
 <87jyv2hw50.fsf@linux.dev>
 <bc42fdda-6be2-46ef-bec5-1ae82092f61b@lucifer.local>
 <87qzp9mern.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87qzp9mern.fsf@linux.dev>
X-Stat-Signature: 9tgwpps71zf7shrpf5jkhwimzehmycnu
X-Rspamd-Queue-Id: 71BF8140019
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774375519-221411
X-HE-Meta: U2FsdGVkX1+7MRtzvAwz98AGjs6stT5UrDgVq8BoE/IDPvqOGPy10IFmXq9kTFOlzA8ugJ3kaEvLqo8Wz7lqR4qavUTHGqNtOlthU9cBmRZ2kiHXiuEaKsrmhK+ZhVt+V1/BV31H4JnoZ/m9mhSR6V+U+0rtIGIBYOX4DyqOzPIah7+Z46CnyyzvXNBGlUyOEFf0N1OsPPDUq8oLAnMztWCWL64+2k8RFRuKuW+fbE7sEccj+jDCeBX8+lf0QllLIiE9ISy2VIf0qW5XW6lfLb3xGDymafB3dG9dVZ2CCec5dwaUvgrtmUi6WiTCFZ54QyuaG0Q/i8EyxQwp1Pqb3Ge9eZXRLefsFO2QB4rWbPO6Sx7dW5oGg4+vZTPy6i0FII+1W8k6P/91YxJpN7qrASxOwnTK6lLBDgyTbB58caS4/13Mr6QogHY66cZ4ltSGUua+oZJdZ73PUGyh99Kasx/EYsL0giHjFO+pxFPHt9uDS6QFTOW2eIiYS0X9hpRUUysVwVRU7ApOf05303suM9Hq72fgVUQUnyJx/esYIKCOK8TMlvwvNfQMs5MmlvxxJ1a/E7Vtjqk7RhpGhpTU5cW4VphCfxW3enOqYl7EtyQ8hQwjaRCKqd/cBZfgTyNyyzFAMZlgYRwNcl3/z22e5l1NGmCrxA24cctAYH5qPG6i77crGOdXW/oZV1K+UNZ5SyL4YixXDyNzT2CoqZnD5A0UWE9elylENJ6MvyNldRvy0UT0CQ6irTm51AyxckqyuSvY/Hp8SAAG86cN4+6Rqq1K03qwLuEB5/WGKn2YhMzBXkCslmWiULFfLqffyeENUg/Ne4FGNkyHIN8HoDcebdCGqtkVTCMPsbIyJ0SkABX6OdYqZCR+sKiCVLrukCu1S03qgomKJPiAkj5d7gVMPEleiwzqYx8qNUC05X17HwR9+gPAw04CJVYZV3RbMot6jpa9cznGzqcIa58hVOH
 y9cS1v9e
 4HD4h93UzO0u4rJ9VBHEgcpz5/fMBVHnA7e5sE+fWnJbSEkWfK4y3wi77Is5sGrartYpg2Z9r+6h9ijTlvxPRhoVfBzyIlOTgO7RO5n1EGLwxt7k5M6VJ0lMH8MZszTdwn7ZTqZb6HOatuCMQ4TTrzevkSNjF6fgZ9uRvtRvEgSp6JVGppgD2menm/6aJQTIqAZ5KqkMDmZt51OxWRAfSBi6O0hn6yyRFsNE5tuKs360PEO6PbX3tzlZ7Ydc8V+d5se0vPED0uKm2mVnUNghYxHMb+fUL3uixtKysB1wr4FgqB9lehA+JI8FLvC31Ph/5LUWIqNXGbtWuDE30Zs0LFXsdwMlEeqVwoZ/d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 08:24:44AM -0700, Roman Gushchin wrote:
> "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> writes:
>
> > On Mon, Mar 23, 2026 at 06:08:27PM -0700, Roman Gushchin wrote:
> >> "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> writes:
> >>
> >> > On Sat, Mar 21, 2026 at 05:15:30PM -0700, Andrew Morton wrote:
> >> >> On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >> >>
> >> >> > A lot of patchsets are "failed to apply".  What is Sashiko trying to
> >> >> > apply MM patches to?  It would take some smarts to apply the v2
> >> >> > patchset when v1 is presently in mm.git?
> >> >>
> >> >> ?
> >> >>
> >> >> The way things are going at present, I'm just not going to apply a
> >> >
> >> > 50% noise vs. signal?... maybe wait until we're in the 9x'%s?
> >> >
> >> >> series which Sashiko "failed to apply".  And that's cool, I'll just
> >> >> wait for a version which Sashiko was able to apply.  And then not
> >> >> apply unless all Sashiko questions are resolved or convincingly refuted.
> >> >
> >> > Andrew, for crying out loud. Please don't do this.
> >> >
> >> > 2 of the 3 series I respan on Friday, working a 13 hour day to do so, don't
> >> > apply to Sashiko, but do apply to the mm tree.
> >>
> >> I'll look into that.
> >
> > Thanks.
> >
> >>
> >> > I haven't the _faintest clue_ how we are supposed to factor a 3rd party
> >> > experimental website applying or not applying series into our work??
> >> >
> >> > And 'not apply unless all Sashiko questions are resolved or convincingly
> >> > refuted.' is seriously concerning.
> >> >
> >> > The workload is already insane, now you're expecting us to answer every bit
> >> > of nonsense Sashiko hallucinates or misunderstands also?
> >> >
> >> > I say that with no disrespect to Roman or his efforts, but as discussed at
> >> > length, it is not ready for prime time yet.
> >> >
> >> > It's clear that Sashiko is not correctly handling applies, and produces a
> >> > lot of noise. Predicating taking series on this is absurd.
> >>
> >> Not trying to pretend that Sashiko is perfect in any way, I think a good
> >> mental exercise is to put down our expectation how the "perfect" system
> >> would work. The more I work on it, the more I realize it it's far from
> >
> > Throughout this discussion I have been making practical points. Nobody
> > expects perfection.
> >
> > I am simpy saying unilaterally demanding that every single point sashiko
> > raises is responded to out of the blue without any community input or input
> > from those doing review AND requiring somehow series all apply is not
> > good.
>
> I never suggested this and explicitly wrote it below (but looks like I
> wasn't clear enough and you argue with this statement).

Yeah, Andrew has proposed this, nothing to do with you!

>
> >
> > BTW, I don't want to make you the scapegoat for complaints about mm process
> > here :) so I am being careful not to criticise, as I realise when people
> > are frustrated with tooling even if _totally irrelevant_ to you as the
> > maker of the tool, will instinctively want to blame you.
> >
> > I refuse to fall into this trap ;)
>
> Agree. Let's separate the mm process from everything else here,
> otherwise it quickly becomes too messy.

Yup :)

>
> >
> >> binary correct/incorrect. In fact, the same applies to humans: I'm sure
> >> everyone of us had once this feeling that someone is to picky and just
> >> annoying us with finding small nits. At the same time some of these
> >> people are extremely useful for the community to find and fix a lot of
> >> issues. In the end, we do argue all the time about questions/issues
> >> raised by human reviewers.
> >
> > Yes except human reviewers generally evolve over time to be pretty high
> > signal if they remain consistent, that is at least how it is in mm. Even if
> > you think points are trivial.
> >
> > Sashiko is hallucinating, it is raising irrelevant points that have nothing
> > to do with the series, it's creating responses that require serious time to
> > decode.
> >
> > I have not encountered review in mm that is even anwyhere near the ~50% hit
> > rate, rest potentialy violently wrong/wildly irrelevant that sashiko
> > generates.
> >
> > There's an asymmetry too - sashiko can just keep on generating this stuff
> > indefinitely (well, limited by tokens of course :), and potentially
> > generate serious useless work for submitters and reviewers.
> >
> > We _have_ to take that into account when it comes to review process.
> >
> > Again, this is nothing to do with the tooling which I'm grateful, again
> > it's to do with mm process. And sadly you've been dragged into a debate on
> > this which you are ultimately more or less orthogonal to :)
> >
> >>
> >> Like do we prefer a system, which finds more real bugs at the cost of being
> >> more noisy or we prefer a system which misses more but if it points at
> >> the bug, it's certainly real? I'm sure you tempted to prefer the latter,
> >> but image a hypothetical system which finds _all_ bugs, but has some false
> >> positive rate, e.g. 20%. I think it's pretty attractive.
> >
> > I think we are very far from that right now. The issue is how it is _now_
> > not in some imagined future.
> >
> > And it's easy to pontificate about all this, but in the end it's the
> > sub-maintainers in mm who will have to eventually figure out whether a
> > series is ok or not, and have to decide stuff people might do based on
> > hallucinations/irrelevant points etc.
> >
> > Right now this is going to result in _more work_ for us, and already it
> > feels like in mm the sub-maintainers are the reason things function
> > reasonably, but we don't seem to be having our voices heard here.
> >
> >>
> >> Also lot of raised issues are real, but subjectively are not worth our
> >> time. But this is extremely subjective! Depends on the personal level
> >> of perfectionism, amount of time available, the state of code before,
> >> further plans, etc etc. For example, syzkaller has usually o(100's) open
> >> bugs, which are 100% real, but not always are high priority work.
> >
> > I don't think it's anywhere near as subjective as you say, and I think
> > that's easy to hand wave.
> >
> > One issue here is - trust. There are people in the community we trust to
> > whom we asssign M: and R: entries in MAINTAINERS.
> >
> > Trust on taste, judgement etc.
> >
> > Now sashiko is essentially proposed to be given the same trust despite
> > absolutely not deserving it.
>
> I don't remember anyone ever said this, at least I definitely did not.

Andrew has said that every single point sashiko raises needs to be
addressed or patches will not be taken, that's again a separate process
issue.

>
> I think Sashiko can be really useful in finding mechanical bugs, so that
> _eventually_ maintainers can spend most of their cycles thinking about
> the direction and high-level ideas rather than checking if all gotos in
> error handling paths are correct.
>
> >
> > What I propose, as I did in the other sub-thread here, is to use it as a
> > _tool_ to _help_ sub-maintainers do their job.
> >
> > Not for it to become a new trusted gatekeeper out of the blue and
> > unilaterally while adding to our workload.
> >
> >>
> >> I think that asking to address 100% issues raised by any LLM is not
> >> reasonable (especially because it's output might be different each time
> >
> > Really, again with respect and trying to dodge the 'blame the tool maker'
> > thing :) that's something of a strawman, nobody is saying they require
> > that.
> >
> > I think >~50% signal is a reasonable ask though.
>
> I think you misinterpreted me.

Right, but this is broadly the hit rate I've experienced. It's not a
criticism, just saying that from an RoI point of view, I'd want to see that
be higher before putting in _stringent_ requirements as to having to
address points.

>
> >
> >> you runt it with the same input), but I also think it's reasonable to
> >> address critical & high severity concerns. And I'm happy to tweak
> >
> > Right, but with respect you're not an mm maintainer who has to deal with
> > the resultant fallout :)
>
> I am btw :)

Oh damn I am so sorry! That is me being a scatterbrain and not some strange
kind of insult or something :P I promise!

I was thinking of you with your sashiko hat on :)

The point of saying that was to emphasise the process side of things, and
it being separate of course.

>
> >
> >> Sashiko to be more conservative here, but I think it should be based on
> >> some specific examples or data, not purely subjective.
> >
> > Well you can't both say all review is highly subjective and simultaneously
> > ask for objective feedback :)
> >
> > I have provided detailed feedback on a specific example elsewhere, and I'm
> > telling you as an experienced mm maintainer that the hit rate is ~50% in my
> > experience so far.
> >
> > I'm happy to feedback more, but it's again a time and workload thing - the
> > default here shouldn't be that mm is just taking sashiko input as read and
> > we have to jump on everything to explicitly say it's right/wrong.
> >
> > Ideally we'd have some way of feeding back on the website, even if it's as
> > simple as a tick/cross as to what points you are actually accepting or
> > not. That'd be great I think!
> >
> > That could be useful as well to Andrew who could see that in action.
> >
> > User login wise you could have some system where somebody could send a mail
> > from the account that is being reviewed to get a login or something?
>
> This is an option. We have to agree (at least on per-subsystem basis)
> what's the best option here. For me as Sashiko developer it doesn't
> really matter which way I get the signal - I need the signal.

Right, but from a workflow point of view, it's not really workable to have
to respond to every input in any kind of detail.

So to me something super simple like tick/cross on responses would be
great.

>
> Thanks

Cheers, Lorenzo

