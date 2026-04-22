Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5488F9B609
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 10:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4E66B00A1; Wed, 22 Apr 2026 06:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E658F6B00A2; Wed, 22 Apr 2026 06:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C9D6B00A3; Wed, 22 Apr 2026 06:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C50016B00A1
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:20:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6154B5D659
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:20:26 +0000 (UTC)
X-FDA: 84685797252.27.B9B05A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E61F100015
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:20:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NIu6y7lu;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776853224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIbLemg8PaVXa6jTmMATQEGpJJE36UXeV4ORx+WW5hg=;
	b=deZRO9AJ2P7RSxSaFTHwwBpEvm5ja6mGmJVNlxtbssnWdWU81b+AbRLoms7GOzKuaySKG6
	oOtg583pu4519IvEeQjeAl2uSX9+50sf61TkcGXW7qN5Gl10QAwWxysnydO3jodmrU3Onl
	FVjDLehlVTDsbJRfTq/hej6GHGPTgD0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NIu6y7lu;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776853224; a=rsa-sha256;
	cv=none;
	b=M1McBP00wpSac94yiOgmpXbB7RqQ02F9sve9jZdTa+Fau2b8/HAZyDcBHdkuuUeJNCvRl/
	fNmpUyIcFr+6JCrTmOIRAM+UtepZ10+/ki//VXgVQJsSn4c4bM+cwRkWuoOb1B+mZkCEwL
	HGqCzPCunpyfW6O5lX9+r79n7DENfT8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 473C840530;
	Wed, 22 Apr 2026 10:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3004C19425;
	Wed, 22 Apr 2026 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776853223;
	bh=2rO0A9K+uKblWGZ7ie12xOMAcsB0BFhdWOdf48JACFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NIu6y7luJXUKZKKm2bVTfB9tV3JIB5a39xhEkpJV/g2d5QZk2E/XzoM/TLCZjLnWa
	 geqWNNsHdag3CipAyqxsRuFa4FnbUBqBd4YKmkVm0NHf87M3CiR1asYkC+YVNnxown
	 cSKK0g+3EGA+dQd2uQ9AL7QbV1AVbzUTjm7gUhfIaRYkGgDXypzeaa81oYr38eKS+7
	 p9LMm/YMO8NSmCILvhAcJSeICIY1eJ+X07tdmr9+0K2JmbvmAtJr1xdQJ6aE1pjIo8
	 l5txp9FWdV7CfAVfnCrmQJEDk5RahtAo8v+z8+HhxD7wJMwMHR8scFOdZITin0LWaB
	 SLlMJ2xF8n20w==
Date: Wed, 22 Apr 2026 11:20:16 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
Message-ID: <aeigig1ebWkMYgLX@lucifer>
References: <20260417011606.1089985-1-gality369@gmail.com>
 <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
 <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org>
 <aeNP7mtx878gynXS@lucifer>
 <7b983108-4846-46ce-b9f5-2aef319c00dd@kernel.org>
 <aeTcdRL0PEg0y78s@lucifer>
 <CAOmEq9XF0P-=QyStrCr0khCsGvPO5SCHdXShKNa3PeST3abw9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOmEq9XF0P-=QyStrCr0khCsGvPO5SCHdXShKNa3PeST3abw9g@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E61F100015
X-Stat-Signature: 4c8n4kcko55di6uqju8faot6q36jft4k
X-Rspam-User: 
X-HE-Tag: 1776853224-852629
X-HE-Meta: U2FsdGVkX19FC0qd2X7eqPCkSbK4H6lwcGSuW+0bCzNSLq401D0T94z+ozlJ4Bzao0lyY2PullPAKRK/AQJ/r2ofuSvDKEueunaqwGtK9PpjP+Qz0PmCbxbtZojoE6Y7q0XCCDdBj0b9PgoOG0JAgD6INmjLCl8eAiakP2jAU43s18zdydVC/at3FJHpiFMENeyCvHI20b6AmYPsr2IzgkA4pzY5UxyW2nLwGNl4ZdCr1o3svLUBmWiJwCVIJ+Au3+wt40oHh1n92i6cn0jTMOTp9iWonox59GkWCT/5UuNuc2+IFbcnyBxa3XdKHDxaF7rbQsmWz7iUxbYd4sLFgleGi2NsbEmyiYI1n2bK4/vhp7KHGJmnEq2+E/i6tmA+Cii/NGgMn3EneAPQi7gQBQJLJ+fE+TBIOhTSqxsp4/RwbYgqdPDc0VbdszebtrjiBza3qZ4C1tQs3N8GGMY6d3XN8c0QyoWWoQCYT8aaOQGR9oF23LE06hLdBcTkmYFZlc/ITJi1+PkKEZV+CiqkvmVwCm6WRpEWUTDwvPR07GLxW5ziw4hopzMmZ94GMt/Rt0cZFRJTXBe2o7CTq5R1J1+bvfXLPjS0rUzT+ugrWiiZKIC2xF4onaXmrgoaYl73PrTRs9C9+62snSxaj/Qm6t6yMF2VkvThggQMhC8mqkpfnRdRAToHtP8omUZ4KqM5f9VEO0mkpfJNtbDqu68d/gVVAGAbn4hLobDDh+wTT+ZiJPbUh30/FnGYGhwv+M5vzwg+qeAuX9tcXSf3YmxXTSdbZPUD2Iy/eyqsgCnlB/IhqLAjOBmQfKGupjMyt2nZ3ofJ70dZVq34C99H5XKhK7rHu59lDMUxahVBjav2bVikfKEVdx2Kxv/jJ+N1ptJpnEKheOsbV22nfjgun9TQRP5D4P5RTglZCVjTtupZ/i4DLyyM9UiL9kBtbFiJTTK7MVTlBMfzSRWoASeTiKW
 DsYRjTgr
 ezukFudwPale6RN+2YIdzsNVyw4BvKh1ubDGoVyfPpwGy16UUT8Kp5yREjHSneitqkUm6VvZM3P1o3U1cI+DQpoCoDz31XS9CQy8+FMRBIaRy48daCgHBa+pHF53If/cbzPdmGz4CmuKIeSxqC/yi9EVrWO+FBr7eAdjQvZcTwBeF+itt8dsTmqpDWhSlCT6mAXrOnAtXo0IFH+0O8WFFEpUwBAQsZScGXQ5CmFLjClIu+gZ/ZwSioyCelfwC5o8K4UsqNylORPxpVMsVySAKsF37XLqfO1jo3dr990kOrN3xd1GTqE2jdTprpKJPI6R6CyhgURX54bz2NBoDlLzG0W+K/p0I94VxV9WlXhIrW6SGMddbJFJuhr3sHjOV3pTlwmgLFDVBGedqq5OC2umzIjcya4Vb35SJ4MeIfHh4TcKov2gbOrdu8Dpo7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 03:59:57PM +0800, ZhengYuan Huang wrote:
> On Sun, Apr 19, 2026 at 10:21 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Sun, Apr 19, 2026 at 10:19:59AM +0200, David Hildenbrand (Arm) wrote:
> > > On 4/18/26 11:35, Lorenzo Stoakes wrote:
> > > > On Fri, Apr 17, 2026 at 01:57:59PM +0200, David Hildenbrand (Arm) wrote:
> > > > > Maybe there was a scenario where we could have lost vma->anon_vma during
> > > > > a merge, resulting in a swapped page in an anon_vma.
> > > >
> > > > Unless there's a bug (and correct me if I'm misinterpreting), VMA merge requires
> > > > vma->anon_vma to either be equal for merged adjacent VMAs, or one or the other
> > > > VMA to have NULL vma->anon_vma, in which case we set vma->anon_vma in the merged
> > > > VMA.
> > >
> > > I think you didn't understand what I was trying to say.
> >
> > Let me take more of a look then!
> >
> > >
> > > The reporter claimed that it happened on 6.18. Nobody knows on which patch
> > > version (stable tree?).
> > >
> > > I was wondering whether your fix
> > >
> > > commit 3b617fd3d317bf9dd7e2c233e56eafef05734c9d
> > > Author: Lorenzo Stoakes <ljs@kernel.org>
> > > Date:   Mon Jan 5 20:11:49 2026 +0000
> > >
> > >     mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
> > >
> > > that went into 6.19 might have resolved this problem.
> >
> > Ahhh, no not that one (it affects merge of VMAs that have a CoW hierarchy which
> > we shouldn't allow) but 61f67c230a5e actually could cause this.
> >
> > Can see from https://kernel.dance/#61f67c230a5e it was backported to 6.18.7 I
> > think.
> >
> > ZhengYuan - can you try seeing if it repro's with/without that?
> >
> > If you're testing literally at v6.18 in Linus's tree say and NOT on a stable
> > tree, then that's your problem - you're essentially testing a known-buggy kernel
> > (we always find stuff later and send to stable, just how it is).
>
> I can reproduce the issue on 6.18.7, but I can no longer reproduce it on 6.18.8.
> So it does look like the problem has already been fixed by commit 61f67c230a5e.
>
> Thanks everyone for the insights and pointers.

Pointers always makes me think of https://xkcd.com/138/ ;)

Thanks for reporting the issue, I'm glad that the fix has that handled (mea
culpa for introducing the bug! :)

>
> This issue was originally found by our fuzzing tool. Unfortunately,
> our reproducer generation is still a bit unreliable, so I cannot
> provide a standalone reproducer at the moment. However, given that the
> issue appears to be fixed, I suppose that is no longer strictly
> necessary.
>
> Let me know if further testing is needed.

No that's fine, you've confirmed the expected revisions and really I think it
has to be that fix that got it.

>
> Thanks,
> ZhengYuan Huang

Cheers, Lorenzo

