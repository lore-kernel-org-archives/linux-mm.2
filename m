Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09473CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E436B042B; Mon,  1 Jun 2026 11:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F61C6B042D; Mon,  1 Jun 2026 11:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633626B042E; Mon,  1 Jun 2026 11:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 532496B042B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:41:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 043801A01BA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:41:18 +0000 (UTC)
X-FDA: 84831757878.23.B9E4C9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4406A20008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:41:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TIHofZok;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXGE/ImL3LG9ug1N+zBj+qfgDjTtJ0SFhuDhOcVyA3g=;
	b=1IsQcC4F+SI/84u22A0p/MJ83WUO+RyaUDJLiQXncaEivYqJa593nGg+rY7fpFHyvfYKjy
	RMrOI3y4y7w8YKglpTPz1gscSGWBYgkauqq2VZSIHpNZBBQlbUDag/NaDbwybBJe5kV1Tt
	BSQoKDhbGl+M1hD2DOaQK9u1bWkR4jg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TIHofZok;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328477;
	b=aCRo7itrEQDJYHFcPyg9GK84zrzIvOGt6MsmiiGOXUNq2iQkrer94xnyjU6EdsnYY/HdHN
	HUbx3UeNd4j7Y7iCupRlCtDDDDrc4EFw0+YtBbBf34Dd6vLH5ktaCMMBGl9gjLikvCUXIZ
	2+veUVRdn3HgWEjNxN0fmlWIGua6Lqg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34CAF40635;
	Mon,  1 Jun 2026 15:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE711F00899;
	Mon,  1 Jun 2026 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780328476;
	bh=CXGE/ImL3LG9ug1N+zBj+qfgDjTtJ0SFhuDhOcVyA3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TIHofZokpd2Slil/bA0ZEHOxLelS6irz+s7ICShUyFLNrc678BtfBukvOF2CdXkpi
	 +fg8LqZO3Il9ZcVizYaC8fTHj7MtmUGkYBv1MEQBkqQfoxReiRfZd9yl1PLJl1Z0Yn
	 ySf/IO+xYYd0dv5WyuUll8uodZgb6NQAodyH7k0N1H62KQRKBwgyqk70J1ipj3IMqi
	 gejDaaCW5w3w3f8xhjISs7rGliGApuZtCe7u7Xq4QH2tqx6e5CgFKHFCpRktAdJeqi
	 CK/ES3fOC14daidB/O6GQoJibMBtEL6YICr/1Lr+fKoOLrvSjIRUS174/i0LZRUCbt
	 Xq9ClzbOm3Y1w==
Date: Mon, 1 Jun 2026 16:41:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	vbabka@suse.cz, willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ah2ndruO3RQGtePP@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
 <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4406A20008
X-Stat-Signature: 4ej5e34sfuwkma88tfos8rhiicsrs6ix
X-HE-Tag: 1780328477-267040
X-HE-Meta: U2FsdGVkX18kTsKXGeaPNL0Qrx/Di6ufMGSa0DbrMhQEFEMH435Q/UcdBSdN4roseWYKNS6pVAiZdrYGxrk88wPqMCxmPTtJdBB16Yy99uvjAt1NvJovN64h2RHGTRe6aa5Yks/ijVMz2jf2sR0QIOVubV9no+wdbudJ9AMDa2MtoYgDuYvpUosZ8XapKNuANEiANGPCsu030M+zxurVuakRyobp8AvNGrjH1AeDSq1GXBXi5JDwzNqs44aEaTAtIQZzZh5xg7CHRaTLCQJHRTS8ivrkNK9RcWWpqGZXKfBkUnzXqKZRZLccOLJxAcCHEytCPBdVGBBdrpWafhN8i+eNHvL0/1Gzy7bA6g+v0hAXp+9fRI4l6tBmeq1Bkt6uu6pciFxIJruFrUNdV/4VD9Rc09TBe44pO7Fp35P+cY6LwpbiFpG3gW5Dpw5Cn7uSNn6qmQlmPPnW87Yrqabn5AJkcd4RlhKtbo8Y8QoGS6A9e7SWGJk8KPhh/MaaeCbmiGDfMWkTQrR2iUre4yaXkW1aS/RYJs8+pjLqXUjhYJ+6WVs7YaFwkqdmrxDzdd6MH5+AZHwzAb5lM3at60iWJlkrmsue5315w1kQ6j15p8nTsFN6+jKKFPBpZ9+4L6vytHacIRNfU4mjpOGXraUr9qmRQP1VfJ2OBSqXy6P4k31alPKTPFFQZf+sAOe83Jpr9ocA9tBSCKcYVEc5L+ZtxJqFsENxNJpKTpYxPj8Zcow9YsG84rxiBU2/T1Xqgp5dQED0s3CzAroU6+H73e398TU8gOOGrIZ/ApVyUvOikVWaEd+1C65O3t85GV4EiBijCTZFdnS8EQMXXz3u74g+W8e1mu+4WMnquI5kXrIqka9K9JDnsKX2xxR/6a9T+2o18PgnLYkexiXmMgzvS7BgBevClCWHHrOlhHeQtCtIu4fn320GuS5coyY+8/Jb/E+fa7D9H6j9TRjJ6+NE7S6
 p8PrOtgD
 3j2R4G9IHKpaokUDV15sreDaiUwNWrce7XX3lqFLz06Ez5ybJlD9Sb+inaWLDCdQ7aT0lPaH/mbzetvA7Z/4Jzz2Ho3ZvIxUGf+psIIaLzECLa//etFSJdQ/GqFEIevVx+Cb1H8ot28zlh0Dk1SjViqs+3lksuKtbUsxqS1fdnBCBWKfy+i6+C7gjeMwQHlVOj/jTN01MjyiO1RCdwJ3BUhVz9TC+225/O1I01QPRyjwuigfyMnC3hP6dq445vxF6ZY+5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 09:49:02PM +0200, David Hildenbrand (Arm) wrote:
> >
> >> and have people
> >> base work against that?
> >
> > This I'm not so sure how it would work. Assuming we have submaintainers with
> > their trees and branches, the final "stable branch" is merged from those.
> > But it's not a good base for work targeting the same merge window, as that
> > work would likely go to one of those submaintainer trees. But then it can't
> > be based on the result of merge of all submaintainer trees. That could only
> > work for patches targetting the next cycle (after the stable branch becomes
> > part of rc1).
> >
> > So either patches can be based on rc1 and applied as topic branches in a
> > submaintainer tree and then merged, or if they really depend on something
> > already in a submaintainer tree, then based on the respective topic branch
> > that's part of it.
>
> Right, most patches can be sent against the "stable branch", but cherry-picked
> on a submaintainers branch / topic tree.

I think life will be easier with submaintainer separate trees for this honestly
:) or it could become a horrible mess in one tree I think.

I think the simplest is what I suggested in reply to Vlasta, where each
submaintainer tree has their own set of changes against mm-next/mm-stable and
then we merge each week.

But am open to learning about what other subsystems in the kernel do...

>
>
> >
> >> This would be 'source of truth' and what we eventually send to Linus.
> >
> > Yes.
> >
> >> In that world, the maintainers perform conflict resolution, but with git rerere
> >> we need only do this once.
> >
> > I think the conflicts would arise from merging the submaintainers' branches
> > to the mm-next tree, and if they get updated and the merges are recreated
> > (like linux-next works) git rerere avoids resolving the same conflicts again.
> >
> > Hm like Andrew said, this needs a diagram indeed :)
>
> It's one of the first things we'll discuss in the upcoming meetings ... I want
> to talk to some other folks (in particular, TIP and KVM) to understand how they
> are handling that.

Yes let's definitely see what works for others and use that to figure things
out.

>
> Hopefully I'll find some time after my inbox calmed down a bit ... jeez, 1500
> mails in one week if my eyes didn't betray me.

Yeah, it's crazy again lately...

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

