Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5340DF54ACE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA876B0095; Tue, 24 Mar 2026 11:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B646B0096; Tue, 24 Mar 2026 11:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98816B0098; Tue, 24 Mar 2026 11:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9777C6B0095
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:25:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6505D138C10
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:25:00 +0000 (UTC)
X-FDA: 84581329560.13.4AD353D
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 585CB40006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:24:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PnzdZ+TJ;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PnzdZ+TJ;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774365898; a=rsa-sha256;
	cv=none;
	b=URDEIYHHmx1DDbqRExUzJVRlqMum/rE+v+V5zCE+o29JBbOxmj7h+K/QbwnvBKsO207KBS
	BK+gs1hIKXQ2Y3DiLRMM3w4VQghUPuFwSbzK6DCxqam9vqmLzDZswC1r9+VtW/TwzOSLfW
	N7C5WoP/LLpUxI3vEOND5M5hJR9gi4M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774365898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HeiVvUHmOuUxiXDJ09SqoCM8eo8Ym5lTpx7hzcjszs=;
	b=C8sRDq4Srh9hZhf2CXpls62ubFaQubRgOHY62zL75/DkTy4z+8MC4Ud4u6gmOHpHCFi1Ku
	XS5Vhz1hTNAtd5oWKrnxsmLDMvZa5XYjaPXEyN1gcZMWt5BVb6gooyuIewg2otvzmhRCi3
	UvYVdbXFMDjYydHba7O0luM+P3ZhrmE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774365895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1HeiVvUHmOuUxiXDJ09SqoCM8eo8Ym5lTpx7hzcjszs=;
	b=PnzdZ+TJ3xnLKhHei33mdDQY8JB196kS9kEXgLCLUcaiPnd4LR9CR/CdH69RDRPIbNqCzl
	y245IoNZJMjbSD9ci6tGA4o7A2mXswEUbYAonsmtXLZb8ULmpL1YsVww+obLOrYOkI5dvT
	oE4/gW/duHtLaLzpMBh3OefBWcM+9EI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  "Liam R . Howlett"
 <Liam.Howlett@oracle.com>,  Nico Pache <npache@redhat.com>,  Ryan Roberts
 <ryan.roberts@arm.com>,  Dev Jain <dev.jain@arm.com>,  Barry Song
 <baohua@kernel.org>,  Lance Yang <lance.yang@linux.dev>,  Vlastimil Babka
 <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Suren Baghdasaryan
 <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
In-Reply-To: <bc42fdda-6be2-46ef-bec5-1ae82092f61b@lucifer.local> (Lorenzo
	Stoakes's message of "Tue, 24 Mar 2026 07:56:19 +0000")
References: <cover.1773924928.git.ljs@kernel.org>
	<20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
	<87tsu9kgv3.fsf@linux.dev>
	<20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
	<20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
	<5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
	<87jyv2hw50.fsf@linux.dev>
	<bc42fdda-6be2-46ef-bec5-1ae82092f61b@lucifer.local>
Date: Tue, 24 Mar 2026 08:24:44 -0700
Message-ID: <87qzp9mern.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 585CB40006
X-Stat-Signature: g87rygpr64kw81iba1ymhbgxs5agc3u5
X-Rspam-User: 
X-HE-Tag: 1774365898-552077
X-HE-Meta: U2FsdGVkX19G85bZEx42ZKhktBKlQCAd8vPBY79HCzuGbVCU7Nthsv78ImWmEuaXn3ixTNt2gh5RWh5l79rSLQZjsbyoKbV3PQ2NIt44to4kWTMi8rU24VsjDqjYyC375VTxQkxsTijoyPfScptZZ5G+5EGE5VrqF82dmf9Ov8/L+3dhJSz1tOQU9NsIpz8nDTI/YDuI3ZKXTbwmfMoiP3qrcyI74CWltlmg/J4wKzjW0fzzxezJC5MfxhXJ+Xf5G6lMMRT1LVKbwjjpseZVTA8/ekiTWT4YC78q3x0w4bN76Ewbs3W2w0nYoVoHXCHcZjGnfWKgBTykfFB5XxJRNwwhCbvdve57sG/PSX2Kh1whjADbp1LPFdhMbY9hfEZl/p8ywkq2rBlmw9ibJRTnwqFrfyEvqbM7TtorJ0TFAl9I7ti9VDTSrguFwwl/nhxwBvqOHTmb+UeGeNI5uaUw3n00CUiiy66aC86aZ3lrsdp4InFPsIwKGCnVRYgSneSiSxDerTrSdVp4X5gBLFrEWnmBJAklVEVnP8Lg/W373GxQtuatEpTnrhXgREH3+UTn6/Nnh0+gks2Pqhf9cbp+JSFuOLKqcI5PEmpPmsloQt+wvx8yTkSj4Ll1z6xAt2iIt7fsaEpCpmZwb2PU1+KiHYSfbyxsuUhYG659bhA4T8N/qPQ6d49h43LxC0ZxYXuQ26Kr7Z6tjvSngdzImkwQpZ8LHQO2MA2hI2mrH9N9No0WYYR8qqusWyGbNtRRBrmbQ/whdUBYEC2SAzPBeXGqA9dSddas+I7fKcOpw06RO811HSfFcZoUW8vPquAps28kjxi97GTXUSxOFKtRugphQlSlIBwmTm3JmjzC5BV/zFTM4xqOCSVYZkFaKzYSb757E0Uwxz2smpM020bN3qkclZ44T2v/MFMgZEqSbLXcnfBdzWIzf14pa8t6TijFHVZxkpzbgMlkyZAebZZ2qZ+
 uxmCeH4D
 wU22xFwdH5GzlAedcNMP4CulzD3emO4QA0G0QpQM/LuFXaXujoR4GotSOO+WNLGI5zUYRMI84hgMfVqyH8VEKaDfPRyjpBdRQR1YE8iD2ubsZ8qvoPS3IL4HpNTdEjqbVkEROCprLk0w+mpe5tzqWojDfLHdxJNkWQTxW1JcwGKRKGQOxokC94UoPXUbHEM3QGh5tSjMWLiJYq8NU7dkfX44rzNQckiMpcNPIdNSVxoWfczN/DCovu69AW8RnveHIRZtHtqnXzgWGx5WdbqPWPw/7lUkJb12BPzWhCSi1+Cd4A1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Lorenzo Stoakes (Oracle)" <ljs@kernel.org> writes:

> On Mon, Mar 23, 2026 at 06:08:27PM -0700, Roman Gushchin wrote:
>> "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> writes:
>>
>> > On Sat, Mar 21, 2026 at 05:15:30PM -0700, Andrew Morton wrote:
>> >> On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>> >>
>> >> > A lot of patchsets are "failed to apply".  What is Sashiko trying to
>> >> > apply MM patches to?  It would take some smarts to apply the v2
>> >> > patchset when v1 is presently in mm.git?
>> >>
>> >> ?
>> >>
>> >> The way things are going at present, I'm just not going to apply a
>> >
>> > 50% noise vs. signal?... maybe wait until we're in the 9x'%s?
>> >
>> >> series which Sashiko "failed to apply".  And that's cool, I'll just
>> >> wait for a version which Sashiko was able to apply.  And then not
>> >> apply unless all Sashiko questions are resolved or convincingly refuted.
>> >
>> > Andrew, for crying out loud. Please don't do this.
>> >
>> > 2 of the 3 series I respan on Friday, working a 13 hour day to do so, don't
>> > apply to Sashiko, but do apply to the mm tree.
>>
>> I'll look into that.
>
> Thanks.
>
>>
>> > I haven't the _faintest clue_ how we are supposed to factor a 3rd party
>> > experimental website applying or not applying series into our work??
>> >
>> > And 'not apply unless all Sashiko questions are resolved or convincingly
>> > refuted.' is seriously concerning.
>> >
>> > The workload is already insane, now you're expecting us to answer every bit
>> > of nonsense Sashiko hallucinates or misunderstands also?
>> >
>> > I say that with no disrespect to Roman or his efforts, but as discussed at
>> > length, it is not ready for prime time yet.
>> >
>> > It's clear that Sashiko is not correctly handling applies, and produces a
>> > lot of noise. Predicating taking series on this is absurd.
>>
>> Not trying to pretend that Sashiko is perfect in any way, I think a good
>> mental exercise is to put down our expectation how the "perfect" system
>> would work. The more I work on it, the more I realize it it's far from
>
> Throughout this discussion I have been making practical points. Nobody
> expects perfection.
>
> I am simpy saying unilaterally demanding that every single point sashiko
> raises is responded to out of the blue without any community input or input
> from those doing review AND requiring somehow series all apply is not
> good.

I never suggested this and explicitly wrote it below (but looks like I
wasn't clear enough and you argue with this statement).

>
> BTW, I don't want to make you the scapegoat for complaints about mm process
> here :) so I am being careful not to criticise, as I realise when people
> are frustrated with tooling even if _totally irrelevant_ to you as the
> maker of the tool, will instinctively want to blame you.
>
> I refuse to fall into this trap ;)

Agree. Let's separate the mm process from everything else here,
otherwise it quickly becomes too messy.

>
>> binary correct/incorrect. In fact, the same applies to humans: I'm sure
>> everyone of us had once this feeling that someone is to picky and just
>> annoying us with finding small nits. At the same time some of these
>> people are extremely useful for the community to find and fix a lot of
>> issues. In the end, we do argue all the time about questions/issues
>> raised by human reviewers.
>
> Yes except human reviewers generally evolve over time to be pretty high
> signal if they remain consistent, that is at least how it is in mm. Even if
> you think points are trivial.
>
> Sashiko is hallucinating, it is raising irrelevant points that have nothing
> to do with the series, it's creating responses that require serious time to
> decode.
>
> I have not encountered review in mm that is even anwyhere near the ~50% hit
> rate, rest potentialy violently wrong/wildly irrelevant that sashiko
> generates.
>
> There's an asymmetry too - sashiko can just keep on generating this stuff
> indefinitely (well, limited by tokens of course :), and potentially
> generate serious useless work for submitters and reviewers.
>
> We _have_ to take that into account when it comes to review process.
>
> Again, this is nothing to do with the tooling which I'm grateful, again
> it's to do with mm process. And sadly you've been dragged into a debate on
> this which you are ultimately more or less orthogonal to :)
>
>>
>> Like do we prefer a system, which finds more real bugs at the cost of being
>> more noisy or we prefer a system which misses more but if it points at
>> the bug, it's certainly real? I'm sure you tempted to prefer the latter,
>> but image a hypothetical system which finds _all_ bugs, but has some false
>> positive rate, e.g. 20%. I think it's pretty attractive.
>
> I think we are very far from that right now. The issue is how it is _now_
> not in some imagined future.
>
> And it's easy to pontificate about all this, but in the end it's the
> sub-maintainers in mm who will have to eventually figure out whether a
> series is ok or not, and have to decide stuff people might do based on
> hallucinations/irrelevant points etc.
>
> Right now this is going to result in _more work_ for us, and already it
> feels like in mm the sub-maintainers are the reason things function
> reasonably, but we don't seem to be having our voices heard here.
>
>>
>> Also lot of raised issues are real, but subjectively are not worth our
>> time. But this is extremely subjective! Depends on the personal level
>> of perfectionism, amount of time available, the state of code before,
>> further plans, etc etc. For example, syzkaller has usually o(100's) open
>> bugs, which are 100% real, but not always are high priority work.
>
> I don't think it's anywhere near as subjective as you say, and I think
> that's easy to hand wave.
>
> One issue here is - trust. There are people in the community we trust to
> whom we asssign M: and R: entries in MAINTAINERS.
>
> Trust on taste, judgement etc.
>
> Now sashiko is essentially proposed to be given the same trust despite
> absolutely not deserving it.

I don't remember anyone ever said this, at least I definitely did not.

I think Sashiko can be really useful in finding mechanical bugs, so that
_eventually_ maintainers can spend most of their cycles thinking about
the direction and high-level ideas rather than checking if all gotos in
error handling paths are correct.

>
> What I propose, as I did in the other sub-thread here, is to use it as a
> _tool_ to _help_ sub-maintainers do their job.
>
> Not for it to become a new trusted gatekeeper out of the blue and
> unilaterally while adding to our workload.
>
>>
>> I think that asking to address 100% issues raised by any LLM is not
>> reasonable (especially because it's output might be different each time
>
> Really, again with respect and trying to dodge the 'blame the tool maker'
> thing :) that's something of a strawman, nobody is saying they require
> that.
>
> I think >~50% signal is a reasonable ask though.

I think you misinterpreted me.

>
>> you runt it with the same input), but I also think it's reasonable to
>> address critical & high severity concerns. And I'm happy to tweak
>
> Right, but with respect you're not an mm maintainer who has to deal with
> the resultant fallout :)

I am btw :)

>
>> Sashiko to be more conservative here, but I think it should be based on
>> some specific examples or data, not purely subjective.
>
> Well you can't both say all review is highly subjective and simultaneously
> ask for objective feedback :)
>
> I have provided detailed feedback on a specific example elsewhere, and I'm
> telling you as an experienced mm maintainer that the hit rate is ~50% in my
> experience so far.
>
> I'm happy to feedback more, but it's again a time and workload thing - the
> default here shouldn't be that mm is just taking sashiko input as read and
> we have to jump on everything to explicitly say it's right/wrong.
>
> Ideally we'd have some way of feeding back on the website, even if it's as
> simple as a tick/cross as to what points you are actually accepting or
> not. That'd be great I think!
>
> That could be useful as well to Andrew who could see that in action.
>
> User login wise you could have some system where somebody could send a mail
> from the account that is being reviewed to get a login or something?

This is an option. We have to agree (at least on per-subsystem basis)
what's the best option here. For me as Sashiko developer it doesn't
really matter which way I get the signal - I need the signal.

Thanks

