Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A80EC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723056B0096; Thu,  6 Aug 2026 13:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1236B0098; Thu,  6 Aug 2026 13:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6105F6B0099; Thu,  6 Aug 2026 13:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1326B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:41:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAB0E1A0189
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:41:26 +0000 (UTC)
X-FDA: 85071561372.16.EEEB505
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 130B31C0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:41:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALXUXSTq;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786038085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Df/ydgamO5+7P4cD1ZVVFnF9dgPe7CBl3Ddd0mKVtG4=;
	b=Lrpijv9CPHpC9X9R581uKr9LAy/zhnIID6kzndipxBFiZ46EfL/fiGlGzELuUhJo1dOIn3
	dekZO30q6SDUPbDKG0uMSSDfdiPuvAYdgCYxLNvX6gYUCy6du9wCcHnAu6pZhEfGTyFCGj
	OVupQ2bRrEawKVS09pD4YyiWANMsUFs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786038085;
	b=Y8ToHPEJAR09m5+9PdFSV8K06GHa7Atk3rojEW/uiLWKju4mCFgT+Dg6zfb19SWHD0DT1E
	eyNlufG3U4ps1F6eWFm/FqX0MJhaRbMxRIaIiHqTbpGYNJ5EjIlRy9hJ9JXMMccjyRNXnz
	maA/C2fHCQCad+WsdAXNcWSJrQ3D0x8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALXUXSTq;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 392FB40E26;
	Thu,  6 Aug 2026 17:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469AE1F00A3F;
	Thu,  6 Aug 2026 17:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786038084;
	bh=Df/ydgamO5+7P4cD1ZVVFnF9dgPe7CBl3Ddd0mKVtG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ALXUXSTq1G0i2RW06eSwepVItMA9+Lw1QZhi+qLKhuaoG6PtIXgx0Jbe1PmFh5E/L
	 1QdGKBZXN0Ju7Kwu5cJeipKb7JxMFyzjseFl9sSiVxgf0nqhflQ3VaIWeDST0jOL0Z
	 Q0l/kju8iFzKX/UlDJOKjXpWoOlJr/ow7CJO+CAjkm4kd+W3EAHhcgv8GmQhm07+Ew
	 2JcJto/7DhfIBqH3OipEgl0WXT+8yIb4RQkVehDtL5OMRy32PEJF3zz/4Mmsk5wAky
	 nswNJ5Ngg4kgvV+yrymjegjynoefETscVFKxkx5QTUqC9WyK7ielIkNdJdTmtkGast
	 BX0yOCKAawZMQ==
Date: Thu, 6 Aug 2026 18:41:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: AI slop (was Re: [PATCH] mm/huge_memory: let special huge VMAs
 bypass the THP) policy check
Message-ID: <anTFxPf5dP_jxVcD@lucifer>
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org>
 <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <20260806164517.GA140051@nvidia.com>
 <anS6hcgMkEJocbDJ@lucifer>
 <10b07d00-57e5-499b-a136-f2148e870d9b@nvidia.com>
 <A403B054-108E-49E8-BFF6-BE5EF8E61C02@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A403B054-108E-49E8-BFF6-BE5EF8E61C02@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 130B31C0003
X-Stat-Signature: egud617956s33kbz76w1zu6sgk5uordp
X-Rspam-User: 
X-HE-Tag: 1786038084-3781
X-HE-Meta: U2FsdGVkX18OhAdAeKg+2dYSRD73DLFUFgqIbtE82mF9JJMLqt4qedlfbA9y1CFyAqiap9w2s5yPQ2+jzNLe3S/4LD3dO+cARfGFnanp0EiBdx+UfojOj1nD0p3OW0lwr/tOtkX0AmWY+rRRcKvOxuJRZEcUV6wh10HXDXDUbVy9FVFCosg139htIYPd2CVZUTxwOpdkBKtgqR0sGSaFtcGy820xW+TveRctA4cSvLh+2g1ZxJfJLF+lGvHGo3X+Exc7UB+iTqmhvGv09L26zUCCl3x2MQhUyhBXMe3iiKakppGWSgfXvWAMS2BihIRbJOUfp5ggvQqxze18Szm9B4hzc+4hFkDnC5xgGChdpU7301FkKSurgqKZ9w+lqJ8wCD4A4nBZD0OmxWXwgbbUoCnO2GykrC0B1j8JZleZQND8trn5Dhm1nFz7Fwq1B9TZJcSC/7T2mgh6FoFGJgcDrBL17xuAs76awqmJXN0uTfXJLVv8X1kroVRs28J3UDZOBJDmGDcHfhlazscwdkXyS1U9N4NIpr60E56p26vxEZKriC5Z73NkD0G15pDdzuUg7qYe5+KsQKvBAdCEtxfNeDNWnndxvsr3H7IPg6o+424fYmH4V5QpkazPB+U+EhZlj77DCr9v/b38f/9fDVUbdB633UjUYMbD2VOmDuapC0d3B6IzNjgMo4mzWGgjU2m9YOOCIR5LYQvUtG05roSKjbw9coleh92h/wh7WGm3Jy8+HKcsc9IMOXmR0UNY3gwc+hBS9vqUSQ4J4mgNWf8imL5DN4yPUHG2bxanlo1XJ0Onx5VVRN3PkgxZbCGLR/2Hky54tJv9EwIJ0jFk0O+4t88GagJolMcrNtvZlD+yZRVr1IOvvSHEgzYgqz3wnlPDzZx+iUNAogE26B5aA7oAnDsq90jlv9D4bQiQH3JJ9CoK1msQUJlsR/XL2MEhxnncQXSVlsj4HeDYaEdFnp7
 oWq3rZBj
 h0EQJKlUAlEbMfB9PqqxuqBUpxDAO6dJHf1cZC6Tb1kKSyDcb8mYqOu2AMJFHwbwOQKWDXNayWuBx5YEliScnJEezflb/i8BZAb/k0LBx6/3K64o5fwsgDeX9YLo+DpoQG40K5ulLVd40HZvhqA1yu/7ZS1RoUPlpRvQk9856U+EkGNxu9AYiLU5pSpr3xNyOvGUQh0tT5yxeZie6+Y4COnlGK8TNB5gAPTs0UNIi8PCDAU1zgoJmniCPDzhjxFs/14FPhdKqnOj7iRJM12QRHy8kOZs4SWo8QFKVnlEyvUYWmfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:08:15PM -0400, Zi Yan wrote:
> On 6 Aug 2026, at 13:05, John Hubbard wrote:
>
> > On 8/6/26 9:50 AM, Lorenzo Stoakes (ARM) wrote:
> >> On Thu, Aug 06, 2026 at 01:45:17PM -0300, Jason Gunthorpe wrote:
> >>> On Thu, Aug 06, 2026 at 04:47:07PM +0200, David Hildenbrand (Arm) wrote:
> >>>> Just to be clear: Unchecked AI slop in any form is making my life
> >>>> worse every day.
> >>>
> >>> I think eveyone's life who contributes reguarly to the kernel.. The
> >>> only ones who seem to benifit are people doing drive by patches!
> >>
> >> And they shouldn't - we should make sure that nobody doing this can
> >> benefit.
> > ...
> >>> Yet responsible use of AI seems genuinely helpful and quality improving :\
> >>
> >> Yes and I use it daily. It's really helpful when kept on a short leash...
> >
> > haha so true. A *very* short leash! :)

Very very :)

> >
> >>
> >> We're going to have to move to a trust model eventually IMO where random
> >> new people just don't get to apply anything until they build trust with
> >> smaller changes (and with measures for established people who start
> >> sloppping).
> >
> > That sounds like a good move! It really is all about who sends these patches,
> > and what their stance is toward creating patches.
> >
> > And furthermore, that's not even a change in policy! Because traditionally,
> > that's how people started anyway: with small patches and patience. It's

I should know, I did the Eudyptula challenge then stuff in the staging drivers
then I wrote a book etc. you know the usual stuff :P

It took years because it's you know a lot. And I still don't really understand
anything (therein lies the zen state of knowing enough to know ones own
incredible ignorance... :)

>
> Patience is the key. Seeing patches refreshed within a day is killing me.

Tell me about it :) the workslopload since the slopularity (circa
late 2025) is slopcrazy.

We so need some kind of a support group... maybe at LPC? :) I nominate the
pub as the venue for this...

>
> > only with AI that they've been able to skip that step, to everyone's
> > detriment.

Yeah. And also there are a number of people who, bless them, simply could
never get to the point of being able to contribute.

I really do think talent is a factor (I know for some this is a
controversial position) as well as bloody-mindedness, a certain way of
thinking about perhaps some masochism thrown in there somewhere ;)

I think only a small % of a small % have what it takes.

In the past those who could not, would not, even if they tried a little
first.

Now those who can not, do, but do so with absolutely no understanding or
sane guardrails (Dunning Kruger comes into play here also).

> >
> > There are some patchsets in my inbox that I instinctively just skipped,
> > because they were huge new patchsets from new AIs (not people, really),
> > only to watch in dismay as they burned up other people's time in
> > review attempts.

I fear doing so in case things end up getting merged mistakenly.

But I am certainly a lot more quickly dismissive of this crap than I used
to be, simply because I only have finite time and an infinite amount of
work to do :)

> >
> > thanks,
> > --
> > John Hubbard
>
>
> Best Regards,
> Yan, Zi

--
Cheers, Lorenzo

