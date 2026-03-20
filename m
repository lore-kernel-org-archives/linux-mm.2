Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 577BC108B8F7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE546B0005; Fri, 20 Mar 2026 07:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5586B0088; Fri, 20 Mar 2026 07:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02876B0089; Fri, 20 Mar 2026 07:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E39E6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:27:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FBA6C07D4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:27:41 +0000 (UTC)
X-FDA: 84566216322.11.7B99940
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3ADF11C0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:27:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DANRyTA1;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774006059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kT5yFeL+gDvTON2O10niF1oYxXjGyj6Ksro/yEkhc08=;
	b=eUJl2ScvNVT2+Tz2QKS9ByUN268pnuRPyv4MVLttqEr2HPaZlO1GXrpeqSEUE/lLeyBsNU
	eoRuXB9uoqRt3ue+6CNmq0dbTS/w/3sAnv38gC44s/kPA+I1ZSG6WGH7Ao8X5CBpqFFqbr
	W5AJceIeJ377wB/o9R0qqyycbhS/MtM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774006059; a=rsa-sha256;
	cv=none;
	b=CDKc/NHKcRq1Ide0rZuNrAMpiGIOZfFVa4ZvGx3SxMt9WniGNtf4MLNCyy3waEdlCg4E2e
	sigBlwKXCCYOvqEIhNRJAa5RD9KI5rEJVf5MaEx7nKuNIDgEo+2imfw3hCh4imgJHEvqBD
	VOrSy5uV49qD+lElnZbMbhx/Ic5Mg7U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DANRyTA1;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 214CD4033A;
	Fri, 20 Mar 2026 11:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A90DC2BC9E;
	Fri, 20 Mar 2026 11:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774006058;
	bh=IJKvox6QaTG0mgCKG6pc9awot4JDTa3WVfzN1VU/eFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DANRyTA1Ro5gqbIJBoXEAOXZTSFb5/RS0WG7t0ZdvMl5bj3yYFNa7PwgFCUoUskwX
	 WrNvAoAlYJKasFXxqXncsiWF9rsMRHxFafsMuuKnQFOEVBle4PHVOYO+awxkVONDbB
	 eoCotQIopA90QAdiW2lbghfU/fFNZGfZDHmCeSOA3Pe1DN3RKQNrzU7hOAQVnL9zyC
	 jBohVlLrmpUz5OfVA38cH+2hcPKFjtbqnCDhwjaXQkKn6ItdwkONOZ+X9nGqVFwxsU
	 EmNnGay2JI/KbSqM21v2bIMYiwifQlP17wg/fiSVixLYfY8QXNJpyB/P8shtB2Xl10
	 MjTScUpBb4Rmw==
Date: Fri, 20 Mar 2026 11:27:32 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, 
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
Message-ID: <a9d6947e-f1f1-4053-adde-189b5546dbb1@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
 <69382383-5f08-408f-8c13-d674e82c4dfd@kernel.org>
 <fcc2665f-014b-490f-8451-ca907730e60c@lucifer.local>
 <tv6pcikk456ynfx7lz3lrql3yafg4njuy3bzi4v6yi5hpe27gi@hakvdy2jmewu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tv6pcikk456ynfx7lz3lrql3yafg4njuy3bzi4v6yi5hpe27gi@hakvdy2jmewu>
X-Rspam-User: 
X-Stat-Signature: qtzouh4egnjrd7fuynx74nzbm6ip1ccg
X-Rspamd-Queue-Id: 3ADF11C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1774006058-102514
X-HE-Meta: U2FsdGVkX1/wown9g9Fs0kErn4HHpptUbZ5GU5gYu2CfF0rBrgYCGj92QLzi8935RwZAS5BnqYitcHMuGNFO15nFS+kIHQB94I+6lhVr6bfZ88N8Tvyjj2he0rq+n1XRupzbN0OmEy/Mt3wqkpDal+N8chq245EXZ/JEsfsAQMGVEpmzOH7Uu86EOLS32F87Ukq/JyeoLOg3Q0e1Cbk+d5dqh1Qs1CgQHttyaAB5jZKahwjggpznyRy0fxYReYqRW6RwZDWhZeBuMAcnrjcnn06Khhb/rwbc47wKxhZsIvewElxuksMYpLZEIVBiOsQpWswX2rbcITsYtLVM3arRrVm8B8hfI9Ro4C1eRm0aM20JINKzGAbnawTR2pglm4LfLilUc6Y/cXNwMG4wtnq6CSy73M6kr6pYGjnqigC868xJjtn9xb8JVxImF9CIBr2FSuJyu6Cj9j28aDsy+kuNEMA+RoKrl0+HqkFrpoF2IGEe3+zDC/SZV3wA+LN5Y81lXhch9vygr7E/z49OuQrgBEIodU0zItjL4G/JpedS60Q++5KtkM1fYeaK98nfXw+o/TeYvddvG8sr/OawAhOWBB481b04m2FnPKSfNboTxizd6Tkn5JLtaCjoXb2jDwb/Wd8Y3rZoGy8x9IAx+0ukPcNZMAjc3od4BZ7TNuo+3U2sKBn+IGqGMfq5EWcCy/XlZ/6s6o4DqzrbwQM738p7RLQgLZeCg3YDcpn6rtlU25NNRPnpwXbuTXLGyuyN7UWOJlvrOiwdSbSHoXz1kRoH29jy2gmWKqGlDD/1hdCMtFOVgnc90d6HXf8LyoJ66BVUfC11f+rV60IlktFPdni7qE/AWnO7gBYM7XKxHe05OvwJHJgCy7hF4dTFK6JcjPawoZdW6bTP+epTMFgOv7jfJ6m1colIVnsh0ZDLLK+djfFDzeJuviV149BPVWOnrbya/ML647WRyO9nuTkJ0CK
 MfCsU14E
 h+FJLdg1OyO9R4DYWEf8LQSf7qeO0WCCxY1qthsp0Lr1XznpTlSxtnXw/cGh8DG1gRFPcs4gztoQN5vpZD3MsNjWZQY+hLRqWlo4/N1HSLHbtlPlPcXH9Q4rmTeROi6OTBMvv5hLi17GeRnwTZ1eJzkk59nwlQZwQPw4c7FKgJy9wvdNS+zhnlakgYef8L/DloBc0sS+zCZflNcSoGsjOVsveN2FiPx8awH0SQQ7oPY1G1DDBnuDTDDeZacA+UQmWZMZc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 10:59:55AM +0000, Pedro Falcato wrote:
> On Fri, Mar 20, 2026 at 10:36:59AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Thu, Mar 19, 2026 at 10:41:54PM +0100, David Hildenbrand (Arm) wrote:
> > >
> > > >
> > > > This is all seems VERY delicate, and subject to somebody else coming along and
> > > > breaking it/causing some of these noinline/__always_inline invocations to make
> > > > things far worse.
> > > >
> > > > I also reserve the right to seriously rework this pile of crap software.
> > > >
> > > > I'd rather we try to find less fragile ways to optimise!
> > > >
> > > > Maybe there's some steps that are bigger wins than others?
> > >
> > > What we can do is, collect similar folio_pte_batch_*() variants and
> > > centralize them in mm/utils.c.
> >
> > I'm not sure that addresses any of the comments above?
> >
> > Putting logic specific to components of mm away from where those components
> > are and into mm/util.c seems like a complete regression in terms of
> > fragility and code separation.
> >
> > And for what reason would you want to do that? To force a noinline of an
> > inline and people 'just have to know' that's why you randomly separated the
> > two?
> >
> > Doesn't sound appealing overall.
> >
> > I'd rather we find a way to implement the batching such that it doesn't
> > exhibit bad inlining decisions in the first place.
>
> Yes, you make a good point. At the end of the day (taking change_protection()
> as the example at hand here), after these changes:
> change_protection()
>  loop over p4ds
>    loop over puds
>      loop over pmds
>        loop over ptes
>          nr_ptes = loop over ptes and find out how many we have
>          if (making write) {
>            loop over nr_ptes
>               loop over ptes and find out how many are anonexclusive or not, in a row
>               loop over ptes and set them
>          } else {
> 	      loop over ptes and set them
>          }
>
> which the compiler FWIW tries to inline it all into one function, but then
> does a poor job at figuring things out. And the CPU gets confused too. It
> was frankly shocking how much performance I could squeeze out of a
>
> if (nr_ptes == 1) {
> 	/* don't bother with the loops and the funny logic */
> }

Let's maybe focus on generalising this then to start?

I think David + I are in agreement that these are obvious (TM) improvements. But
let's see if we can generalise them?

>
> I would not be surprised if the other syscalls have similar problems.
>
> >
> > I mean mprotect_folio_batch() having !folio, !folio_test_large() checks
> > only there is already silly, we should have a _general_ function that does
> > optimisations like that.
> >
> > Isn't the issue rather than folio_pte_batch_flags() shouldn't be an inline
> > function in internal.h but rather a function in mm/util.c?
> >
> > >
> > > For
> > >
> > > 	nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
> > > 					   max_nr_ptes, /* flags = */ 0)
> > >
> > > We might just be able to use folio_pte_batch()?
> >
> > Yup.
> >
> > >
> > > For the other variant (soft-dirt+write) we'd have to create a helper like
> > >
> > > 	folio_pte_batch_sd_w() [better name suggestion welcome]
> > >
> > > That will reduce the code footprint overall I guess.
> >
> > I mean yeah that's a terrible name so obviously it'd have to be something
> > better.
> >
> > But again, this seems pretty stupid, now we're writing a bunch of duplicate
> > per-case code to force noinline because we made the central function inline
> > no?
>
> Yeah.

I guess we can discuss on other part of thread :)

>
> >
> > That's also super fragile, because an engineer might later decide that
> > pattern is horrible and fix it, and we regress this.
> >
> > But I mean overall, is the perf here really all that important? Are people
> > really that dependent on mprotect() et al. performing brilliantly fast?
>
> Obviously no one truly depends on mprotect, but I believe in fast primitives :)
>
> > Couldn't we do this with any mm interface and end up making efforts that
> > degrade code quality, increase fragility for dubious benefit?
>
> Yes, which is why I don't want to degrade code quality :) It would be ideal to
> find something that works both ways. Per my description of the existing code
> above, you can tell that it's neither fast, nor beautiful :p

I mean the code is terrible in most of these places (mremap() is much better
because I put a lot of time into de-insane-it-ising it), but it's less degrading
quality but rather:

static noinline void blahdy_blah(a trillion parameters)
{
	... lots of code ...
}

Developer comes along, modifies code/params/etc. or uses function in another
place and degrades perf somehow and suddenly what made sense at X point of time
no longer makes sense at Y point of time, but develoeprs don't understand it so
are scared to remove it and etc.

Which is why it's better to try to abstract as much as possible and have some
way of then putting the sensitive stuff in a specific place like:

/*
 * Lorenzo-style overly long comment with lots of exposition, a beginning,
 * middle and end, ASCII diagrams and all sorts...
 *
 * ...
 */
static noinline void __super_special_perf_bit_of_whatever_dont_touch_please(...)
{
}

That's wrapped up in some saner interface that people can use at will with the
perf-y component safely locked away in an insane asylum^W^W another compilation
unit or header.

>
> --
> Pedro

Cheers, Lorenzo

