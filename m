Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518CEC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461976B03D6; Tue, 18 Aug 2026 05:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439446B042C; Tue, 18 Aug 2026 05:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3768E6B042E; Tue, 18 Aug 2026 05:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF9546B03D6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:08:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A1D11A0B22
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:08:21 +0000 (UTC)
X-FDA: 85113814002.20.3EA6118
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7F2EA0008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:08:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IU8Okv7M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787044099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwW3cB/lnkwShvsFSs7vWWfzkEnX/dINOpOlgjM4dI4=;
	b=DCabgZlEaeRo4prTqhAbZ11BKzZqXPX4raU0P0kYs6PeGQIdhrQQS3/kmspULf88ihe3JT
	Cum7Xs1Jrb0FTJ0Anu3Rquk3z5F83RXLAUFAWZ9Uj4ZSjEVfwa8tgPKMTdoTP373rFfT4T
	P+/K7wTKkEXWQ9Aj3OpXiqGCpLntD/c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IU8Okv7M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787044099;
	b=dfppeiJc54/6tIF92GI6NM7LW/AMQRd6zXYHFF8WSqZunKbwO0V1P6q8TRuBAgzcPOVpcL
	dz6TUVEPBlosoh1XE2NjjsrrWyoFar68l8b4VeePZ8TnDetrqrd3A3fCsgdSFfKgKxm43+
	ViN4zzMeWwxbFpYMUT5Iu5ZYIliewtA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7647F43CEB;
	Tue, 18 Aug 2026 09:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECE21F000E9;
	Tue, 18 Aug 2026 09:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787044098;
	bh=cwW3cB/lnkwShvsFSs7vWWfzkEnX/dINOpOlgjM4dI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IU8Okv7MWS5hVJu4pfefBUmvVcKV9TPT1Z7oyACQUq6avnliTOwXLtNnqM0XvDv2z
	 wssPh2TfKGf6FOxppSe/koPP+fbAg6d8OhldTevGvOELxkNVTBKg0ddE+0rTZev78P
	 8rbks+dzxQ3x5CAwQHIr84+wF+fDOo11GwY4mDhvQunOwn+eyE9OzddBkziMIQNgZe
	 izkQfwFJ00CRWRyhjeWVXM6qvGX9QyNkJrsvJs4xaoDwAnc4lKlGKLUtXV8q01nh4S
	 qmipc73YKQKGOF5bEBssyam6UNnCpXRAg9WFW1gBIgfHigjFgPd4K4SE3uVecHrjsF
	 B/hoK2ftO4Aiw==
Date: Tue, 18 Aug 2026 10:07:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, 
	Thorsten Blum <thorsten.blum@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to
 vdso/page.h
Message-ID: <aoQgN0IJ9WuQWY7o@lucifer>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-5-thorsten.blum@linux.dev>
 <ag7pFxHpMGU0zLvq@lucifer>
 <ag8cvjwDGCt_14pY@lucifer>
 <CAHp75VcJJtfnSYFA8vhtsuZs1gLo+Jpne3TU2WgMZxLiB+95yQ@mail.gmail.com>
 <ahAzPTUMwMZfW2kx@lucifer>
 <aoNbHbfZyNfA8QKT@ashevche-desk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aoNbHbfZyNfA8QKT@ashevche-desk.local>
X-Rspam-User: 
X-Stat-Signature: ei8fpq3cyrc1fg745j49pz85xj3mkcoa
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7F2EA0008
X-HE-Tag: 1787044099-605216
X-HE-Meta: U2FsdGVkX1/aDoe9doWerV2MPTcJNrqSHAZeApdCz4J5xG5PwtDqLwMJO3KGQT5eFstBV1qZdL+lLz/FzOv5POgMptpdM3+uE3DJjngUAUE2GpqBz9FnYu5tthXI7DQN0Fqdf4V8zvmHfrPV+Gr+zt/9I1DIovkbwe2U5XRCf5uEQ5SzRQXJuM6ISUggFnwQoWd5RukuBiiluzZLMy8UhWu00oZyQB0J3PkQlM51/odOJXG7h33JR8FUOqoYckKZ8f2q2mn3K2yEOr5tnDSBbLsJkE+1JHvq6zzB0uDvoRIjx9t6VHQhqPGh3+bXT7YvyQJGD5ZfCYoum2HtBLw62YZD4Wvb0Osp4l9WKkDBQPvmTIOVqytQELevek1+xW6m9nRhtncx2qQx1nsJn2OVHFvOdcnzXtyeF7iVH0BZRwCaKLkKSYZcYOryOlfXjlVkM1d0C+rQss2xzgjDlJ4l6/dPe0fMna+GCl5tOquq82FOZ9arXusmQt/xJADMk8WZppHKbDFQWp6fMeheYMLJUu4XhDIZpIAOntvDEeO9PsVApKO+L/RZcDe9+bKmqfGvG/S6y/Kkd4yAc6NREmD8GmfHsyXreD0akgxKM1gn5Q2z1EsOt+AykHR+mNrxCKhmvc6mUOmrlH0ZO3OjgGTneSgdC6jd6Oen4osJpzOOo0zGQHqnlibSypCnosXRieWwda6dOJrpCtfMh8FFyPkphEi+RJY4vZRdR3HnqBuj4iLDr2pF5ctIJumwls3Pkvh6jC9GKtF7pKWJQ46uqq4sye+C9DG4sIoy5F58gbCxjwYQR2fdoomgJgeWRPjdBf81gPpDcQZwfU6KHJ/+YahPYa5scWQWj0M2d6dDBoCQxFYzQMpgH4XdZNgLGcYYBFxRZPAcl2FqEh9sNdqRk56f+woeCIQx7MXVLRHr9orkld0VoI/b9+YqH8wWHk7F8DBTYWMJUkG2dRaA69V7f7T
 aL8aZdiO
 gvKR2GDmMTnPJkQHJYf7FDYR+ZedVZzyKqgTAuLDpa6ar8WyGxS0tD259Va3FLcUssprwmFD794703R4BwoTxMcK55+guHEFIGaRUEPo+/9lFLhdexyXWissvt4zPLj+CJ2MANrweup53ppw7exwPqf/pYOl6FDkZpi60sN2Nrl+9xflACrScdy7j+RWGpD7Hu4vNZj6XfA6kjZpkH8dlzHQgQizbqDuMaKheKi43N0KmKp3r6hd7JJxhuY38HVHx+Rcau/9vrVH4TEjnB1QslGUhzN+E2ClVWffAmiMjpCVS0EXC+z9SccZT2H0vEaciH4x/4L4rr85rBo4/AAPnSfJ/Kx5clf1tv4e3uz4zRsWQyqSUJXaaRFC/ZdF14Hc7OkhxTh7/8uKZ+VbNKqV9aLEqdBWPWK/skReSt6pG6q4ndBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 10:03:57PM +0300, Andy Shevchenko wrote:
> On Fri, May 22, 2026 at 11:52:58AM +0100, Lorenzo Stoakes wrote:
> > On Thu, May 21, 2026 at 09:34:57PM +0300, Andy Shevchenko wrote:
> > > On Thu, May 21, 2026 at 4:56 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > > > On Thu, May 21, 2026 at 12:16:00PM +0100, Lorenzo Stoakes wrote:
> > > > > On Thu, May 21, 2026 at 11:06:57AM +0200, Thorsten Blum wrote:
>
> ...
>
> > > > Unless a series can be put forwards that sensibly justifies this, not some
> > > > random change somewhere, I'd rather we not take it.
> > >
> > > The problem is not only a compile time but more generic - the mess in
> > > the Linux headers. People who want to use this match need to include
> > > mm.h which is a bloated header with *tons* of unneeded dependencies
> > > (for those pure users) and increases chaos in how the headers are
> > > split.
> >
> > No question the headers are a bit of a mess, and I've had absolute headaches
> > with dependency chain stuff there.
> >
> > > If we don't care about it, then provide an "INCLUDE EVERYTHING" header
> >
> > That's a false dichotomy - the series isn't upstreamable as-is. I've provided
> > feedback that's not been addressed so we won't take it.
> >
> > > and let the driver just include that. But of course, we don't do that,
> > > we do modular headers for a reason. Currently I see no reason to have
> > > that simple helper to be mm.h as its use is much wider in the cases
> > > where the whole hell of mm.h is not needed.
> >
> > We also don't want to have wildly divergent overly-specific individual headers,
> > and series have to be upstreamable.
>
> No objections on this.

Yeah I think in this case this was the main issue.

>
> > > So, the best course of actions I see now is leave mm people alone and
> > > simply duplicate what we need in the headers we want to see
> > > (util_macros.h as a rough approximation, but maybe something better).
> >
> > I mean I feel engaging civilly and constructively with people who have taken
> > their time out to provide feedback is a better approach, but obviously what you
> > do elsewhere in the kernel is up to you.
>
> Yes, but it's may be due to my blindness to see how the whole mm.h machinery
> is useful for just simple macros that use PAGE_* ones beneath. I'm for whatever
> (much) smaller and that has much lesser dependencies, so people can use it.

Yup agreed, but it's all very catch-22

>
> > > > Also vdso/page.h is a VDSO-specific header by MAINTAINERS, offset_in_page() is
> > > > really an mm thing so that's another reason not to move it.
> > > >
> > > > (A justifying change would show actually build time/binary bloat/etc. numbers +
> > > > involve actual substantive changes).
> >
> > Overall this all feels like a storm in a teapot, this is a very trivial macro
> > and the use case seems nebulous at best.
>
> It might be more users found, if we start looking into that with tools like
> coccinelle. But I don't know.
>
> > A series actually addressing header issues with _a justifying reason provided_
> > (I am astonished that it still hasn't!), would be more useful, as long as it was
> > upstreamable and didn't cause other issues.
>
> Sure, justifying reason (one of?) is a very baby step to clean up the header
> dependency hell we have. I know that some people want the problem to be solved
> once for all, but it's impossible to achieve (remember Ingo's 2000+ patch series).

I know Matthew is looking at doing some work in this area actually!

But yeah it's horrendous and I'm not sure we're going to make all that much
headway, esp. as it's all very bikesheddable (perhaps I was demonstrating that
here ;)

I hate headers in general as a concept they invite the kind of horrific insanity
we have in the kernel.

Have made some small contribution myself too:
https://lore.kernel.org/all/20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org/

But that's just symptomatic of the mess we have in general :)

>
> > We in mm are friendly and accepting of good series, engaging positively will get
> > a positive reception :)
>
> I believe this is a standard for maintainers in the kernel independently on the
> subsystem. But thanks for confirming!

:>)

>
> --
> With Best Regards,
> Andy Shevchenko
>
>

--
Cheers, Lorenzo

