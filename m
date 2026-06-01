Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6D1CCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284D16B0425; Mon,  1 Jun 2026 11:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CFA6B0427; Mon,  1 Jun 2026 11:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199A76B0428; Mon,  1 Jun 2026 11:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0932B6B0425
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:38:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6DF01406B7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:38:02 +0000 (UTC)
X-FDA: 84831749604.12.1D46772
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id EDF9D1C0009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:38:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEl4kY3z;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRsJ96HteFVHVry45xwwgZ/lAOnTgbYBsNn63u9HIEw=;
	b=j6a7Q7N1DDllFKXjLUmQD6kQAI0SjP7wAhGNdKzWVWvIUQc6LsjPv1XkPJuR20p7Yvni6G
	w4UIKsmyOdsWHjk3QiX2lZBRh4su1abJF1739PJ/DBK2MSmDBnjfHHSWrt84zxXJOyIagT
	ivdl01wN+WlmhSY0FUZvJpLlE8VQrVs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328281;
	b=gFAjOpjDhtAlfuyv/Gkh7ZGcJUs5MfudBGHyPW2kg+7pl/AKEs6s3XeZSqXZ98wbEjdbmL
	0xjI49ZD0vdUyOGYZfUaZMJ6dIH8DYXUaQGI964lzmQkp5K8vnaAr1q9bMYdqtvdsMXtj7
	zBAc1n2hfRZwZdDWqqwR/3K14O58II4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEl4kY3z;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68A4F601E2;
	Mon,  1 Jun 2026 15:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697161F0089A;
	Mon,  1 Jun 2026 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780328280;
	bh=WRsJ96HteFVHVry45xwwgZ/lAOnTgbYBsNn63u9HIEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LEl4kY3zYbJFSv7Qgi/YIRKtgs1BCTTZ986d1mK9N/YRzKMNjZJeO1u0oM8JaWlWd
	 2QCMcLEUQH0K8nEaoJmpF7VrOrQKZtAsnMkGpz+VEk2eMjfJj3LDV2vL4NQBst3aWu
	 MTcEtZroOVGgXBaDr38ZPbPg/0iqotbCYlZfD6w+KrVPacRb3o0NvD1SOsVHkdVRda
	 F5EgyzOEyLc6KxTHXn/U44tcP5bgAh0MVfo83Fomt30CZeolUU0x25z0Z0o0AnFWfy
	 GvClDQMfk4FJoxkxhESkkirswFzGhsR/z3eHhZf3TbMRcF+b3PeUnv/ao4A0aecMrV
	 4iEdU+R1PGwpQ==
Date: Mon, 1 Jun 2026 16:37:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	vbabka@suse.cz, willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ah2fG9fSqbocqUlE@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
 <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EDF9D1C0009
X-Stat-Signature: 7peqd6cef5yxwudayut54u7jyg3dubb6
X-HE-Tag: 1780328280-70319
X-HE-Meta: U2FsdGVkX1/sRurEAm9iTi6OJGF8DYHCb1mX6gm4iqrEjutm3Giv8FQEEge+ZS9y6FJ+7162Jh3X2VxE+reuugNx9j2jMyGJve1hm2xBm8vQC2lzktZRh3BPzcPyCeWMLx6M5zHRUSGykatOHF1X2+YmAepMkMpnWWY7E19SmLzpuef4aimqbRLjUbXlAFV0tIWsrzN5rtVJO+b/D+dZcQPph95PuvINONCZofWoFHVFyx4un3Sf9Ed3TBepqHD4naGIAzSNIjC2ZE6afNMSjMfpb/PXVQDYuxzJn6FtTmBoyO6ZHsONC4DZ+iCaiGd4jg14dxCztPZDdzlpWklh+KTjPTA3O59Y+IzfC6HYlVCBYfidDqXUj8KGNxavsZnUGGU4ARdQkbrUL05s3H7qoyJwawWRJfodp4qKSmdb+fsWGOHBJEJ290bdPofFqArzvjsSWTOQeUhRcgKG8TmnZ5MH40FbHPOer4xwp0U9pJeXZYmbu2lZ3z/Dw8wpiTFMhYAN3ixZKK1sC0OVA5sePRt4CcqF2CfB0YIPRiVN+fxj8ivgBA9bL8xinxfuY5sqsNtuArrZznSCU+cLmzxPvVidxLQUKdYuwWYt6LGshcbtEup+YhikUdH0rkqeQbdNVZmUYrsM29HJRsTxg05f7TptE3/O/xGtYNZYc7UfvpxOe0UX9S2pWQ5bHZWq6Y/hDeej3W9o81zlmIadVLO/7OzvPn1Odw013Sa/PzSveW6goc+ADZW/nJecBO99cblGdXgfYsAU/L315HhHe9X2itaxG5heePD17m4NSw6yR7d1ZgMSL1x9AnSO+9jZOMceXcFYNwlgdPzIaF6Axb9bU/vWDopdoUsqX+ML9YSdPOFN2ah7jFWN5sBxPi+/GNaVd0I/gkTgAXIibcReMXkY1X9vj7/CgXWRZstLi+/1GfS+V+qXQy6BTRMZcX+etD0o7Sf5MLZiHlDqD/IhQNE
 44J2bNa6
 VLLwNe5DVc0tZ9uUu4O+8/m4HxkFzCSDwAU8w0J59Uj0IJrDm+3sZK+K40J1nFD52egHJDbXh0WKhLl+4lXmmqCaQV+Ag2op1zP8OJq6/fX/Hu2q+ElFKLlYdRpQM5iHr8uxlVSuK7QbprA5PiC1o+8+qaEMmcrMSLnjOwcKbiBGFXcKWA3xFnzfDr5Wz7z2AQIZhaGkV6+UQtWO6C/lEelz++zzG1pAaQO0xMNljyKn7vtxq350e3xB4DGfFAa5ok3mc565u46tav8mv+TFLWemg7XIOelfs3JLoldrv5K4wodQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[sorry busy with many things so took a while to get back to this]

On Tue, May 26, 2026 at 10:42:51PM +0200, Vlastimil Babka (SUSE) wrote:
> On 5/26/26 10:33, Lorenzo Stoakes wrote:
> > [trimmed cc list to avoid noise, apologies if I excluded anybody who is
> > interested in this!]
> >
> > On Fri, May 22, 2026 at 11:13:42PM +0200, David Hildenbrand (Arm) wrote:
> >> On 5/22/26 18:11, Nico Pache wrote:
> >> > On Fri, May 22, 2026 at 9:13 AM Vlastimil Babka (SUSE)
> >> > <vbabka@kernel.org> wrote:
> >> >>
> >> >> On 5/22/26 17:07, Nico Pache wrote:
> >> >>>
> >> >>> Whoops I manually changed the coverletter subject to reflect that this
> >> >>> in on mm-hotfixes-unstable but never updated the others...
> >> >>
> >> >> But why? That branch is for hotfixes that would go to the current 7.1-rcX
> >> >> series. mm-unstable would be the correct one for this, AFAICT.
> >> >
> >> > Sorry this was a misunderstanding. The goal here was to base this off
> >> > the closest base commit behind where my v17 already lies in the tree.
> >>
> >> Ah, I guess this is a problem of "v17 is already in mm-unstable, so against what
> >> to base v18".
> >>
> >> Yeah, we touched on that problem in the LSF/MM process discussion ...
> >
> > I may be misremembering but... :) [correct me if wrong]:
> >
> > Wasn't the general conclusion that we maintain a stable branch (Linus's tree +
> > stuff that's been reviewed and is locked in for next release),
>
> This I think basically yes.

I think it's _vital_ to have this one source of truth, and for that to be what
goes to linux-next, then eventually Linus.

I think sending stuff that's still unstable to linux-next, while it gets early
testing, is more problematic than helpful overall.

And us improving testing in mm-new can mean we get some meaningful testing
involved (AI review bots helping also).

(Also Linus said linux-next doesn't get tested all that much anyway :P)

>
> > and have people
> > base work against that?
>
> This I'm not so sure how it would work. Assuming we have submaintainers with
> their trees and branches, the final "stable branch" is merged from those.

I feel like it could get hairy pretty quick, but I guess the key thing here is -
maintainers resolve merge conflicts.

As long as we have a specific _solid_ basis for work.

I think actually this speaks to it being sensible for each submaintainer with a
separate tree to maintain their own repos rather than branches.

We need to determine what this baseline would be for each tree though.

So perhaps each submaintainer tree has for-mm-next that's the stable branch from
mm-next + any stabliised local changes.

And each week this gets merged to mm-next, and everybody resets to mm-next
stable branch?

> But it's not a good base for work targeting the same merge window, as that
> work would likely go to one of those submaintainer trees. But then it can't
> be based on the result of merge of all submaintainer trees. That could only
> work for patches targetting the next cycle (after the stable branch becomes
> part of rc1).
>
> So either patches can be based on rc1 and applied as topic branches in a
> submaintainer tree and then merged, or if they really depend on something
> already in a submaintainer tree, then based on the respective topic branch
> that's part of it.

OK so topic branches = series people have submitted?

I did wonder if we could somehow maintain the separate versions too so we could
diff between them easily also...

And yeah it makes sense, if your series TRULY has a dependency on another, to
base that on the topic branch.

>
> > This would be 'source of truth' and what we eventually send to Linus.
>
> Yes.
>
> > In that world, the maintainers perform conflict resolution, but with git rerere
> > we need only do this once.
>
> I think the conflicts would arise from merging the submaintainers' branches
> to the mm-next tree, and if they get updated and the merges are recreated
> (like linux-next works) git rerere avoids resolving the same conflicts again.

Yes they could arise there, and if we use the model mentioned above with each
submaintainer tree having its own for-mm-next branch, then when that gets reset
to mm-next it could cause conflicts for topic branches etc.

But then that would not be a repeatable resolution I suppose.

But would updates really be a thing though in general? If it's for-mm-next
[submaintainer tree] -> mm-stable [mm-next] each time, then there cannot be
further updates as those are the finalised commits right?

>
> Hm like Andrew said, this needs a diagram indeed :)

Yes, am happy to draw/document something when we finalise things.

Cheers, Lorenzo

