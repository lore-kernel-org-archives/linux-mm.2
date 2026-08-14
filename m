Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E47B6C5CFDB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 13:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22D46B06AC; Fri, 14 Aug 2026 09:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2666B06AE; Fri, 14 Aug 2026 09:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F326B06B0; Fri, 14 Aug 2026 09:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 955786B06AC
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:02:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25F7480417
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:02:43 +0000 (UTC)
X-FDA: 85099889406.08.45630C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 56E9214000E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:02:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WRwhsrIp;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786712561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9u1rGVG6agDFZWdG40l3zEmJc1IeDbuPGBZf6iWuaOo=;
	b=3MVZMeMrG/dQFT/H/NMAV5CNTvgvuStRWQIDl2H7K85T1xmWV/N6FvNrYhA8YOiOWlpSzD
	mUuUHfsqXdlX0szsxdRhZYkr+I7nbfLPC4WMtpCWClWpeSxFI+pZ3nkKNHNPMARzk7N4BQ
	mAmr9z/tGX+zyEIKKIB1RlIcx3a6ix4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WRwhsrIp;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786712561;
	b=CS0aOUaUCJj4QAGwV9eoHUZXmc+xH1GOO6PThKoi39wXM+m+Wp5GN4metEsuoGcTQeTVUo
	ek4u2PjljaaZ9xeo2i5yL/qV1kAFgMDKIgPUsRCdETIqP+ubGb5Q34UU5bH+Lg+ABUMI8b
	Gb/z6XyybTuwBdhFB1/IeaJk09xheCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AE7E43441;
	Fri, 14 Aug 2026 13:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC841F000E9;
	Fri, 14 Aug 2026 13:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786712560;
	bh=9u1rGVG6agDFZWdG40l3zEmJc1IeDbuPGBZf6iWuaOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WRwhsrIpWrAeXQ6+P5BbK653mIKbVuP3KoJuEhKi7AYB2Cy4IwT2135T3HzhsQn3z
	 pAz+xiSbm2blljK4UjJ1Uyl/H2qnJ8/qxqgINpoU4b3IhCVSVEOYQ81GjtNIsE3VXh
	 NO+eBPFpJYwfl57ePvXhg5q04txgqXy5lW6XmgTnUQ8RPzyg1UXbKcuZdfWM8NlC8P
	 bGEnViqmf1FTXg4JskvS8iA+UMoX0mcTHM5VyDDP7pdUJVqRqRxcjKOFfXSYIbaI+d
	 t+JJrebOkmosntcpdRtPblcAI3spk1A78mewlJ7fp5lRojtQB0uHk1BLwNQTkXV5kP
	 ymsFTF5pCkAgA==
Date: Fri, 14 Aug 2026 14:02:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: daniel@thingy.jp, gregkh@linuxfoundation.org, linux-mm@kvack.org, 
	geert@linux-m68k.org, arnd@arndb.de, willy@infradead.org, jack@suse.cz, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	pfalcato@suse.de, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <an8PTKUAuZh3BtJm@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
 <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
 <an3COKVbgQKdY52d@lucifer>
 <m25x1crhym.wl-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m25x1crhym.wl-thehajime@gmail.com>
X-Stat-Signature: rqmf866a1stfzpxq41h5tctf4og56wzh
X-Rspamd-Queue-Id: 56E9214000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786712561-724273
X-HE-Meta: U2FsdGVkX1+AcWV7xWzUcIDsbgwi4rEt5dlBcYMk5qQ0O58K0hOAIzpG9HLvo8jwQ5NpkNJhKkuf2SmnVNwJx7YSucZtWkX/inciuBy4ylmF9HXQHWSP5M6RhC1/rK2yXlhi0EWj4/Y7MdcWIrDPxI55rLfJMdh7QR2AVg0aGEDyPJm9CuhNwKA5ONSjKW920cmQfbvsb+VN6xUVPpcbCL6zSgu5aWox1oWhd7LDrDZb9YlWeS7abgFaXuS+Fh0qRQvb/BIfMSlqeX7LNbPcKbwkJKPVK1aSrUwcB34WDZ/UVFh+mW8HN0T7q8WP0IkYh5xv+R3B/BYSopJ2XHSG3WO8QE6Y/2vSXi26jxkR4rDkX4fXE/AGrK6yswvKrd7kRa8mdpbUze/FSEv17MWC4PPPBHS/TsTj9aKZhBgTaoXj3pllr4cM5IPvIxD5dz30IscaIx1WtM+rxehfvYmHQxlqd+IRgxmr+DthOjWGS75/f5Tm9dsjuf/2N5NVIwWCb2Oyr4QbFci5IMwmECkN0MLDJ/B6cxG96G3XafWomMjzdBXpaG6zJQ1oqhICp4ZrUcl0XFPN/KaBcEmlJ9kfAvnazFk366u7haPDzBC84vu+1JejQMA0YcrhcTUXFLA9oSoAe8lnmcf99oRkysYRf3bXi8JOFXGIA5RtIIB3y1U5S8oCiuhoDWboaL4W98Ic/JTVcaOjrLLmC/M08APdOLHXX8hYFZmxF9PyW7/8/kciuyVtAiKhqYSCX2curogjCgWDJgtStXyqiQysyo8F55T8Frw2M+9fOk1DM6NsPD/9y3qa6xtWofVsV+rQHS+wfsYcaYaQrojxux2ZC5xH6bkHkTjbhhhaeHT2lwO25KutmfqJ9Aeb1dcR+8dITY+8k2ORHE9CA0nrMFPw70wg3StsE+9SE/ptzGqtJfZzmW0Xu+AOqhlyGCn0Vvg5A8OOuksResy4AWdGcRsrnc3
 yudpwd+N
 Vj5kRduFG6Ebl2lWT5VHMTDSzmiVlZNKzvekiIUItLcgojIVx9pm3YRPj6kbv2uGkOdi3mXUkh1spUMjPGWKLq9vBOv4YtxmYqzvtPUIoPAsEgVudb1udd4I4ks/6vPvF+fxpvXjN+icl/wITswt+8NqV040keP9atdT3nY+4oXPNHMbhCVcFJphigWhQRzm1cKiY42cSJar8F2FMn/URQumrn7dr6Uraw48GOk/8wr/z8+tAbGUAWkHfIqn3cm10cyezNn9pcvoOQVwl6mDXY0w/KLesbAn0hoq8YA7pJakkmWu0LLHYUSmm9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 09:42:57PM +0900, Hajime Tazaki wrote:
>
> Hello Lorenzo,
>
> On Thu, 13 Aug 2026 22:29:38 +0900,
> Lorenzo Stoakes (ARM) wrote:
> >
> > On Thu, Aug 13, 2026 at 09:43:37PM +0900, Daniel Palmer wrote:
> > > Hi Greg,
> > >
> > > On Thu, 13 Aug 2026 at 21:26, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > >
> > > > Given the age of this issue, I don't think anyone uses no-mmu systems
> > > > anymore :(
> > >
> > > There are a few of us using it for hobby stuff[0][1] and there are
> > > apparently people using it for actual commercial stuff.
> > > There was a session about this at LPC 2025...
> > >
> > > One of the big problems for nommu seems to be that everyone is
> > > convinced it is completely unused and totally broken. :)
> >
> > No, the issue is that nobody seems to do any testing or contribute any code
> > aside from at least Hajime (thanks Haijme :), and possibly others (forgive me if
> > I am missing people's names here!)
> >
> > There's been situtions where nommu has been broken for a year and _nobody
> > noticed_.
> >
> > And yet whenever nommu comes up people always seem to pop up and say how
> > important it is, then mention a talk etc.
> >
> > Well if it's important, test it. Test the tip kernel. Report bugs. Contribute
> > code. Any or all of it :)
> >
> > Meanwhile we in mm have to _constantly_ fix stuff up in nommu because it's a
> > total mess and has real maintenance overhead.
> >
> > Having to account for legacy systems that make no sense in 2026 when you're
> > trying to make improvements to systems people use, or not being able to do
> > certain things, really grates after a while.
> >
> > I mean if you don't believe me git log mm/nommu.c. This overhead reason is why I
> > now co-maintain it.
>
> after spending more times to look at code, fixing issues, finding
> other flaws, etc, now I become to understand what you meant in past
> emails, when you're saying a more maintainable way of implementation
> of nommu.c.

Yes :)

Thanks for having some empathy about this :) It seems a lot of the nommu
advocates simply assume it's little or no overhead and is 'working
code'. No and no.

I know Liam had to do a _lot_ of work on maple tree to make things work
there, for instance.

And the recent VMA flags changes have had to be heavily updated to account
for nommu.

And the list goes on. New features have to touch it all the time to avoid
build failures even, and etc. etc.

It's a really absurd situation to be honest and the RoI isn't there at all.

There's a reason I keep going on about this :)

>
> Since I wish to use nommu.c in future with the latest kernel, I'd like
> to contribute it for, let's say, refactoring the nommu component which
> mm subsystem currently has.
>
> but for the moment, I wish to start with introducing test cases from
> very basic checks (which is in the [6/6] patch of this series).
> Without such a base, we may not have any chances to improve this nasty
> situation of nommu component in mm subsystem.
>
> # this motivation also applies to LTP (linux test project) which
>   currently doesn't support running tests on nommu platforms (I've
>   already started).
>
> And also as I mentioned before, ideally the code should be maintained
> by people who use it.  And if I claimed that I used/use/will use
> nommu.c, I wish to maintain this, or at least wish to help to decrease
> the overhead of maintainers.  This series is a very fist step toward
> this.
>
> I hope it clarifies a bit for your concerns,

Thanks, and I appreciate that you're actually doing work here, but I'm not
sure a single person suffices for this, as well intentioned as you are.

And as reviewed, these changes seem to be adding _more_ maintainership
overhead rather than less, I fear.

I believe nommu is pretty broken across many domains (it's fun to set
claude on it for instance).

And we've already spoken about broken things that have sat around for
a long time.

The way it's implemented now is just horrendous in any case, if we were
forced to keep it in the upstream kernel then the correct solution would be
something that somehow 'emulates' an mmu system.

But I'm not sure that's even workable, and likely implies heavy
maintainership headaches.

> -- Hajime
>

--
Cheers, Lorenzo

