Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E5F3CD6E64
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971E66B03AC; Tue,  2 Jun 2026 08:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948BA6B03B0; Tue,  2 Jun 2026 08:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EAD6B03B1; Tue,  2 Jun 2026 08:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75E1D6B03AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:40:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 220DC162DE0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:40:16 +0000 (UTC)
X-FDA: 84834930432.10.CB771F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 49230A001B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:40:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMrohNNf;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780404014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rw5GGfqEX7JYH8yleWjvLQ7agemetRZbHn8SYrCvt2w=;
	b=iv/pwqhvU0Ke5wDgtM+J/DK9tv+JkyaK9MxUGD6r0B4au8cS6ph9W0owVE4HqKYJOw4ooT
	TQRO6mijRO9h215rZrT1JqtvN7hjut3TU4o8yZzLi/H/oTimwvReUqaNf95USrmlQXcwnv
	E/Cuc5OGxpzoifQvCbo9/WTx3iUXCeo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMrohNNf;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780404014;
	b=uRDbXGi9hZI8TTdBe2u3JI5cg7Uue1AmIabHtbr8CbYxdAWMUo8ZToSApAFyrnahiUN/bh
	le/5QFiakcX81+hddO1VBJsP6164FP3Ym+slxUlCPjxCmQFGaGmVzFOqeNsa7VOhlWBMqd
	LE/ILWOCPmu50rapw3b02bjVXtqz+Ww=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E49D40179;
	Tue,  2 Jun 2026 12:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA011F00893;
	Tue,  2 Jun 2026 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780404013;
	bh=rw5GGfqEX7JYH8yleWjvLQ7agemetRZbHn8SYrCvt2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DMrohNNfydVMhHardbyD8D5wPkMGFPrb4XsBqkoCXprVmKtN2f+xBYh2oWOjXvc1R
	 QXg6ob5Wj2ZsD1fcVp2RbMq49B8kf3cZGbzHDAOHsVW6//8vKL0JGAnMj8JpFgl8un
	 aIqCQCyBd9k70SSf2O7x5H7iP9e3IUGaLQkhL4dT+D5EjZoqZUWlOv4K8aR42odhu1
	 WIs2d7/+fGCZ4HColqoYRR2nEw+gORmHuA5PXMQiKRbOqYv8k9N4fjHGdy09rUb9Wl
	 NVNn2kSnzzzxiLHuV7nOimT8Aox3+tu7wTBYKkctyNEkRYYOTjgPsrr2LzDg3ikzrK
	 Jk7XjrkjeSCGg==
Date: Tue, 2 Jun 2026 13:40:07 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	vbabka@suse.cz, willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ah7GctQYf8EqZjIa@lucifer>
References: <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
 <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
 <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
 <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
X-Rspamd-Queue-Id: 49230A001B
X-Stat-Signature: uystkoeu6wafmzoqowozbsfcxab3r38a
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780404014-474768
X-HE-Meta: U2FsdGVkX1/vkuq0wuuVQwPvRRTl6KMkhe5CCQoDAdIDSyKkwaiP3LCsGwGXU4CnJJ7ucP0yQYHCmpoy4PAZvYFiK8F0PAG2lym5Lx44az9fZ7M75tyzB6uHIRmmvYuvVjFu3C7EBhz7YP4iwXdY00Zecvioj5JU+456VP3oN4e5b11TPV9lyDHDbbWvh/8mMW7HcxrQEBilXL6N/ixNd6f4SGSornMKoEewaNpA6qWp9C1RqNE3xBjts3rOsVZh9/aWg835wAEH6qfmSf6byAqBw4y0cLonvLO5ZfbIUs2fctgfkFVQuIit6zBtRhbktfr0V6yOeWjg/Od60xp0o2MinxOtdWglapWZMmnDB4y4vc5rTv6qa4+mx7HY2bCyWsaIvb+pxDf1BCcNFOQeUzeIoPQZads1QRA8kQUFu2OSsMz4smNlcTGoCUU8dRDUQRFi100tDqnLBq9XSCuTeJWOmGNmPI9IpljIHAbtp8AnhMHLove2V9bOcdRPzdhCUdKs1YlXJOafWJi3IS85+VtUkY4M08WXqqD8tZo7ngWk43Oiw5jkdVGRbfKjpSp4o8yxZoWAWugWSombxdqwJfgLJHuL8friK+CNxqb9DyrcFw6jqDu8IQghU5sJACCZTWylhtmDwMY0Uf1lYYtFUQFKTHJlZoxm+yFtg7W+SpFE461LJ8jguRHpU91ofRXNx7JcBWJCZ9SymnBeVlsf1I6Vt3StzLHLh9aXVnT0oMphiddQiYGfaLTmZa+8HXBepMY7QX1ZXK8nTgTbIY33jrgPjSFyT5SpTl38qwImbnxqWSgm3oZWFxUrzIMTDuiibqsiADi473BUCwqjqvp9SUtGGGyuGdvWKin7LFM9B1YjWlk0Sex3feIUN2ftlMLgHYaSJ6nBj3VPlj7xlIKym8hfKsctKJ6B5YEo6w1FfnoL9UBPD/6KfOmTe1FHUhLtGBrIhJY5/ZIGX9o7DEZ
 Qru7+fGv
 PKT6n6rihIczAf21IC56fmFDsLTXoctYdKj4JEdYIumWIaux/bQQwfBujuHeenL/EmqiyDMHQERZ70XREyWoi327KjLzA3ok3DLs+ZvoafyzuEvlFb3KAZIMFCH6yicXF2Cx7kgEjeMN2KFNZIljxpWIPTKhY/FUzsTNbAdisD9JFM5cGauvFD7OUuecC0Dn3fIACJW65O1yZ/bu4eNgDZjbp+Cbik27C49mrpPNHO5MLpXEUQj3JwFgwMXJ9IDs4tmIv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 01:20:07PM +0200, David Hildenbrand (Arm) wrote:
> On 6/1/26 18:16, Lorenzo Stoakes wrote:
> > On Mon, Jun 01, 2026 at 05:45:30PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/1/26 17:41, Lorenzo Stoakes wrote:
> >>>
> >>> I think life will be easier with submaintainer separate trees for this honestly
> >>> :) or it could become a horrible mess in one tree I think.
> >>
> >> Requiring contributors to submit stuff targeted at some random trees is madness :)
> >
> > Err what? The 'random' tree is the MAINTAINERS entry you are targeting, it's
> > based on the mm-next stable branch and only diverges in the work that's been
> > done specific to the subtree, what's crazy exactly?
>
> We'll still have plenty of patch sets that touch files cross trees.

I'm not sure how keeping things in the same tree fixes anything though?

You are just changing the _timing_ of when the conflicts happen at the cost
of making things way more difficult to manage IMO.

I mean the reductio ad absurdum argument is why isn't all of linux in a
single git tree? :)

If what you're saying is true it should be without issue? But I think there
would be pretty huge issues...

And the disadvantage is now we have a bunch of sub-maintainers with write
access to the key mm tree who could make mistakes and break things,
hundreds of topic branches all bundled together, no separation between
anything, and no sense of where anything's at.

If you're saying submaintainers manage topic branches (this cycle the ONE
tree would have ~400 topic branches right? More if we included versions?)
and then independently merge those into the mm-stable tree I think that's
going to be a disaster in terms of timing/conflicts/etc.

And you're asking for conflict between submaintainers I think - what if one
person merges his thing that then causes conflict for another etc. etc.

With separate trees then decisions can be made by the mm core people as to
how to integrate, rather than people unilaterally doing whatever.

And if you're saying submaintainers won't do that, then essentially you're
saying no submaintainer tree management at all :) which I think is a a bad
idea for a subsystem as busy as mm.

I think mm is too large now to have everything under one person or a few
people.

Separate trees implies division of labour, and then the integration tree
can be more of a pure integration tree.

>
> I don't see the problem of sending stuff against the integration tree from where
> it can just be cleanly picked up by sub-maintainers (after all, that's where all
> the subtrees were integrated against)? Or what exactly is the problem with that?

But what does 'picked up' mean? See above re: concerns.

>
> This is likely something we'll have to play with to understand what is workable
> and what not.

Actually, I think we have to decide early - because if you want
submaintainers to test out this sub-tree or sub-branch? Or whatever thing
it's very different asking them to:

- Create a new tree and do X, Y and Z to sync up with mm-next

Vs.:

- Have full write access to mm-next and create branches X, Y and Z and
  merge things

>
> >
> > I mean, is there any meaning to separate 'trees' at all if we just have one tree
> > with topic branches in?
> >
> > Or are we going to have several parallel stable branches in one tree, and a
> > bunch of maintainers with write access stepping on each other's toes?
>
> All valid question to which we don't have an answer yet. :)

:) I mean learning from how others do it is definitely key here.

Maybe we need to grill Brauner?

>
> >
> > That sounds a lot more crazy to me, and I just don't think it's workable.
> >>
> >>>
> >>> I think the simplest is what I suggested in reply to Vlasta, where each
> >>> submaintainer tree has their own set of changes against mm-next/mm-stable and
> >>> then we merge each week.
> >>
> >> Throw in hotfixes and it already starts being crazy.
> >
> > Again I really don't understand this?
> >
> > Hotfixes are a completely separate topic for one, I'm talking about ordinary
> > development, but surely they're simpler aren't they?
>
> I mean the interaction: new material that depend on hotfixes. Talking to Michal
> and Vlastimil last week, there are some ways to make this work based on topic
> branches (hotfixes being a topic branch IIUC), but I don't understand yet how
> that works in detail, or how that would scale to subtrees.

OK, yes we would definitely need to have the hotfixes applied effectively
as if they were merged in Linus's tree I think underneath other things.

>
> >
> > Everything's based on Linus's tree (so no confusion as to which tree), there
> > shouldn't (hopefully) be a huge amount of them, and submaintainers can just
> > potentially find a way to send them direct to mm-next anyway?
> >
> >>
> >>>
> >>> But am open to learning about what other subsystems in the kernel do...
> >>
> >> The TIP tree has a pretty elaborate model of dealing with topic branches, and
> >> don't require things to be sent against specific topic branches.
> >>
> >> I'll try to understand that model.
> >
> > OK well, interested to hear about that.
> >
> > But also we should adapt what others do (which I think is very important to
> > learn from obviously) against how mm works in practice.
> >
> > High review load with many overlapping changes might favour a different approach
> > to a subsystem that looks different from that.
> Yeah, but as we said, we discussed, it's all rather complicated and we should
> move incrementally.

Yup, but some things have to be decided early I think. We can roll back
decisions, but some are more costly to roll back than others.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

