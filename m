Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273DBCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D1E6B0096; Thu, 18 Jun 2026 08:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155466B0098; Thu, 18 Jun 2026 08:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043F06B0099; Thu, 18 Jun 2026 08:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCEAC6B0096
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:37:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65ADC1C4BDD
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:37:07 +0000 (UTC)
X-FDA: 84892983294.12.01DB074
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4E9B920005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:37:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WWDTXm0p;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781786225;
	b=fVeUcjqJSW3vs68T8nwdNDXUZMhQfQBJGdyGPCYJtfcjM/MyT4bwflZnPC7ri9/cY0wBi8
	Zsq9328j/YLUEIp/6uVYX8qb/crUOkcTTKb7wJPrsNvSNDoOWiw6bhNi3J90WMmbzJ3+FS
	/l0r8WcI328FUr6Y0GGjtPGAYshJJhk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WWDTXm0p;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781786225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkSHVItH7tnbR0yMDRD7muLBdT/xCNKdF8GS+tUHV+Y=;
	b=1eQxj2oA4yDLzDFeSPJPJh8+z8qEwzGdPDiFTP9jxgshyQtPG+CUXVvQOKpPrgoDArVJ9C
	NPdCzVIJ5RuiUW3PHAcRYoz7vPidCzZ8erB+wK7uimQCsFET1tIo+mqRHp+F3Soe1ZHioc
	sXGm9TUZBChImj7R1gIMWs2dfJ5r2a0=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-464192ab2e1so409945f8f.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:37:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781786224; cv=none;
        d=google.com; s=arc-20240605;
        b=avnbPLNHCmJ+JhlW1Dkv/EzNRX3md90Z6FC80XeLqH6Yw3D0dNGkufX3mjAOfAaeUV
         ifzEEBwqbah8or+WXLD/F3Of8K/0sKvp6ETUCKL5uzCT1CxSQgVnNtAw5UqPOdEZafgb
         esXwVeLZzBTFq4nTS74BV4YEk1V/sncl4cIF2KCSqzPCxdNfixX13xk6j3RbHSV+1rR7
         QwXRGcZe7tICWbbghMm6o/JyWWsV8nrh/Ee7Rou/F+jIXhsSXqbOrN1ol88SwRzEQ7Ef
         h+W/h5e7vJrTQ6fof0oDx4guQ0ud6JMebTQ3nnFsoHv433sMBHG5IyCn0ZZlFA7HgNMi
         k+4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XkSHVItH7tnbR0yMDRD7muLBdT/xCNKdF8GS+tUHV+Y=;
        fh=axrcC36cDqF1q+apimRfAw5Y1+aBYgFeIxHf6JvYj+A=;
        b=BHTU7Jga2RKMZvOEYwrbbYDDi9c5WM7ZuRnXjLh7KjMGAK6OjHjI5ZoC9D/EIwQyxn
         f9clYoJPzeWc8jlYLt6/agQYX4Z/4qfQUXR1Xec8r4AS7Gh4veP7tS6eMHFVYTzv4XXi
         kO7N4ot469rfpicUsDK/Se58E1NDcWDoiviReOC8ghMkMy6UNP+tcrwJD5cUyVyLtQ3N
         1TR8S7hbIOdrLJeTd8lzZboVM/0tejfsRZrw8FILQbfQEAuxLD/HgWcHBihP00QNKvx9
         8S6X6dbu/eYB0vn68iyrGZ5KQ71iuLmzvTG+dTVeNs6Yty0HZUFPaMsrjIfzKnocegDc
         TLig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781786224; x=1782391024; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XkSHVItH7tnbR0yMDRD7muLBdT/xCNKdF8GS+tUHV+Y=;
        b=WWDTXm0p4e6W+7Z1cRvsjqDSLehZpTnphC/4RcigIFw697lbrtS1ov/0bA+4+gA8k3
         2qR4OS1J7mG31ankojK/IFp8qYE6P/nY7XrCreioI9QZU3swcRqbey23VNwMQqyLzsnL
         lqZde6WL//6yg4H6/LIK6GsrxkDHo6u5ENO9KGeE8K+1KjKKxdz8yL6/5JtSr9kSNw16
         hdD7UoAK2hjp3ibjFAMgftIaXN/WvKcSj48o0EtWMtSxE7HX3og+APO0xV6IXhn/V+3U
         BL6Ook5Xqomn2t37tdZycda4SjTIFmVrnGchDrEwXD7gVms0wIssmh0xEfV+hBRFotK0
         TsEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781786224; x=1782391024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XkSHVItH7tnbR0yMDRD7muLBdT/xCNKdF8GS+tUHV+Y=;
        b=k2RU1vyHhyZ+37o0ZPJXq8U40ayh3GZKycS3j2nvSFAd7wbsOlkfJKlNaLpPBVqSUO
         EN+4l4WCzAaVhRCz5TvQBAErEDEkwe+dYU5Eq3ZMt11xzeyr86l+a+19t1Fo2z2ZlQQg
         3ptJ4fHOJdNzkc3nzbSUhGhC+J4DWiDPirocxvSdjjarZT+/zwK1lVUoYvScV1yaOhCX
         s7HCfgN4iMNQ+XHOYlA65uj2TToRjtnDjLvOEYqHC06BgwS9dPLrPtYrF4NwZw4dTVRe
         F9meopcjT4GIVD44Wz+SXr8LlXDHujoRepbAfcJUR2oKdh+jrWcEv2+rqoOQvYUrun1+
         dUrg==
X-Forwarded-Encrypted: i=1; AFNElJ9L6RpNvSHLI8PbcyvBD+uUPr9FM064h5N1kW0FcWDFqVXVOoZqoBL+zYytgqYraGmUvvbv2rdkIQ==@kvack.org
X-Gm-Message-State: AOJu0YyG9mA/mdzC70ojzXJ0TSSTIYhGT/Zfv7cZxy4o0ZMHrvCqgOUh
	hGseGUzMfR2QsU4vkz5dmVIm625LvIAVQyWDimkMMkBPtiw03DdXZjIesJc/klLZHcZWknRkFD7
	ZsnSq6QzmM/o57WE8gsDpO8l7B83UKY8=
X-Gm-Gg: AfdE7clGsE0GTBfEXuW7a78OsWFwyUvUeOAsllNaututb6HUyllPS1Hd5EwnqXI2GA0
	bYduNxPCuhdJDquR07hSQa/H7nxogus8viLacSH9m/pUBZc8q5TJj82OAH8A9SHeKD7Izu7Iibk
	WUzu1rbRrQYkNoa5rZNAyaU7+0l9UXJ0rW1y6VVspNX/G/iKvi5dpCfqXkYTVV/lamdHi23Jhqy
	A5YXpLHn6vPafOHSOKCzqynaVMG757M+1Qq5Eq7qJdeSfWlftjOtRhwz4ghNbtC/HoJdJhSS3LI
	KUFqU5gJIF+DCytn1WZax2LTHEk=
X-Received: by 2002:a05:600c:1550:b0:48f:e26a:1744 with SMTP id
 5b1f17b1804b1-492381eba37mr57093805e9.9.1781786223384; Thu, 18 Jun 2026
 05:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260617053447.2831896-1-youngjun.park@lge.com>
 <CAKEwX=NfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9vk_cbnnr6J6PQ@mail.gmail.com> <ajNOSesjwTyZc8EX@yjaykim-PowerEdge-T330>
In-Reply-To: <ajNOSesjwTyZc8EX@yjaykim-PowerEdge-T330>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 18 Jun 2026 08:36:52 -0400
X-Gm-Features: AVVi8CfzuQSfKHh9oPwDJSuQShydMBfDCnnVhDZx9e0tsjDeRE3g_0kv6j5DVww
Message-ID: <CAKEwX=NDM9ohO36wSE-vVpVkpM=UBhhgBqDzSZdo6gW2BgWDVA@mail.gmail.com>
Subject: Re: [PATCH v8 0/4] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E9B920005
X-Rspam-User: 
X-Stat-Signature: raaewp3stm65gbcf86e6w5iq68d9twry
X-HE-Tag: 1781786225-871682
X-HE-Meta: U2FsdGVkX1/3DsfrSBS4EUlsKWtnkwgjCbi4WPQNkBbWapAKx5udMs3Zlr+4yaQJLQk2gTqK38gkfF7maeeBYPkH8Dy8bBG89IuMJUZLBPZ138kE5CmDDsgEWyvrOApexiVcuYkMqYT0qn0eVzT33RHRqCzgS61wih11KlUlm2VzNur7ZV3870c/f/2WFBiC/dPJRzck7uRgjMG7jFv9hKTnywf3pdxHZPc68ntbehJEDxgprMDWYqt6KwA0v+BUyQIadEg/8SXwRgI4rF8x0yM3bZULid4Sl/akCLj6hOtS/7be/Rmw8derjzrTxROnOsQsXlD1jtdKplqubzfkuddlBjIJc26J+E482Xf1v56MCBDulq6K5aSX+8mwFtxKB5x2SP0sLvyoArAL9FaS0mETcNxO1+MVE59ikua7jwI8vaaciwFQ8OwSUTkGH6m1vh95lD8SFaS3fprVAnVdJ3wb+LSPSv51wrFDESu04C2Dse6WbJVOOpkXpOuDGuywpHOsmQzxAfjyJTiQi3vMZjs6N3gB1KqCqOv8m6HXIxQqNIRUbnRO96RCffaF1rA0PGRBm2AF0koFC51ylEuGDMXv10iEWzA3Ox3K9NpTNnGLjTl1736p9gGUHucmaWMeH8pTyv7hlAmDnRtU5nGYb9MPbtLyJ1HhO9ZU/WvbUfJUvpnAJpMlZzMNw3SHLLdvkYsEkireqQriSelkfgDD++4B06eG+RGUrtZYhD9VjSh4Kavb+zYHqMXzrfDNyHjtvge/4DrEPS7RuFZFEaVcK5zoV0Z4mcnbd0lOyl2MsVB8t1SQGthdhpRMaXR7XCxJ6LGefhthUqfItfP0mJSW/qlZ7bNGoa0Tk1/N7LLul6WTM1Jb+1LehxkcKBlpadQ4VNJEgnW6O11InWPECHbUi1Vhu7TU/kaax7djzlr7KdzLB9SmQtz3yjb5Gc8vlUiF1VPGFjhrs2gdg4cARnJ
 hGYwuY8c
 ipRtXHXXfR5uryYYc6n9A7FwEN8Sozfb6+iwtPkT783mXv2TPMAsUsp6qUTrMlHUyiF/W6rVLmTYpP7kKtmiS4t8HnGH6z7wexzRp6IohjlRhJlr46Gp9WtLcgwBG5hiIOwMFON2uI2hJ84pLB9j7ls0Fb7agc2r1k6dn+7jmkv7Wiiu+OEB9IXeO+NyuTPFE3hM2rI78fUY+vXYVs583Vk6plSYt3v27fR2v6N/cQowfkhzPi61lceeyn20czkttArEz5nGYE9DnChIgBimDUOS+pJQU8LyL4rU8s66c+gF8ERmhVPr2lFN5bWGXp9hn8iYBmGGr/taCikC3fzUYuuOFaDxVWM+H9+aamt4PEDqdEPfZ6+/fHioAMjVVG/l3hP+eSHcqcr4e0/b5lzpzlgVwMkYzlObtmtngFStO63UwIyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 9:47=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Wed, Jun 17, 2026 at 01:50:49PM -0400, Nhat Pham wrote:
>
> > On Wed, Jun 17, 2026 at 1:34=E2=80=AFAM Youngjun Park <youngjun.park@lg=
e.com> wrote:
> > >
> > > This is the v8 series of the swap tier patchset.
> > >
> > > Great thanks to Shakeel Butt and Yosry for the reviews and discussion=
s [1].
> > > The main change in this version is the interface change to use
> > > memory.swap.tiers.max with '0' (disable) and 'max' (enable) values.
> > > This mechanism was suggested by Shakeel and Yosry
> >
> > I like this interface too :)
>
> > I think Yosry wants zswap as a tier, right?
> >
> > Just that without vswap, maybe don't allow it to be an tier of itself?
>
> With the current architecture, users cannot dynamically specify zswap as
> a tier, and zswap is a separate layer, so it is not tiered by itself.
>
> Once your vswap work lands, I think we can make the zswap
> become the default, top-level tier.
>
> After that, we can also look into cleaning up the zswap.writeback
> interface together.

SGTM if Yosry is happy with it :) FWIW, zswap is a conceptual tier,
whether we want it to express with your interface or not. This is just
interface clean-up work.

>
> > #2: Inter-tier promotion and demotion:
> >   Promotion and demotion apply between tiers, not within a single
> >   tier. The current interface defines only tier assignment; it does
> >   not yet define when or how pages move between tiers. Two triggering
> >   models are possible:
> >
> > >   (a) User-triggered: userspace explicitly initiates migration betwee=
n
> > >       tiers (e.g. via a new interface or existing move_pages semantic=
s).
> > >   (b) Kernel-triggered: the kernel moves pages between tiers at
> > >       appropriate points such as reclaim or refault.
> >
> > We'll likely need some kernel-triggered mechanism, or we'd have LRU inv=
ersion :)
> >
> > Cold pages will fill up fast tiers first, and more recent/warm pages
> > will land on slow tiers...
>
> Yeah, good point!
>
> > We'll also need to enforce isolation/fairness to make sure no wordload
> > hoard the fast tiers too (but that probably requires demotion
> > support).
>
> Right, that makes sense.
>
> BTW, One thing I am curious about, though, is whether there are strong
> real-world use cases that require demotion/promotion.
> Theoretically, this looks useful but it would be helpful to better unders=
tand
> the requirements from such deployments.

I think so, yeah. The LRU inversion problem above is one :) Hard to
make proper tiering without demotion.

Say I have a workload that have a SLO - for example a PSI target - but
don't particularly care about exact memory placement. To optimize
resource, we want to place the warmer stuff in fast tier, and the
coldest stuff in slow tier, etc. Having the ability to do demotion
derisk the initial placement - we can place things in the fast tier
initially (and rather aggressively), then as pages age and prove their
coldness, we can move them to slower and slower tier, etc.

Otherwise, what we end up with is really a placement preference
interface more than true tiering. Which is still useful especially
when co-tenant workloads have strict latency requirements, but perhaps
we don't need a full hierarchy-style interface for it? :)

The other use case is for fairness enforcement. We can (and probably
should) start with strict limits, but setting memory.swap.tier.max for
each cgroup is a bit of a drag, and it might leave stranded capacity
in cgroups that are allocated but not utilized their fast swap tier
capacity. If demotion is possible, we can let workloads use more than
what is fair, but then demote swap pages from swap tier to enforce
fairness when necessary...

Obviously, it's a moot point if there is no good mechanism to transfer
data one tier to another. The data might also be so cold that all of
this has diminishing returns, and moving things around cost more than
it's worth :) So I'm happy to start with something simple, then we can
figure out the next steps.


>
> > >
> > > #3: Per-VMA, per-process swap and BPF:
> > >   Not just for memcg based swap, possible to extend Per-VMA or per-pr=
ocess
> > >   swap. Or we can use it as BPF program.
> > >
> > > #4: Zswap and vswap tiering:
> > >   Tiering applies to the vswap + zswap combination.
> > >
> > > #5: Vswap on/off control:
> > >   Currently not supported. If a strong use case arises where vswap ne=
eds
> > >   to be controlled by memcg, the tier interface could be used for it.
> >
> > +1.
> >
> > Also, per-si/per-tier per-CPU allocation caching? :) Kairui already
> > has a patch for it, IIUC, but if not it's pretty critical I'd say.
>
> Yes, I missed it. Thank you for addressing it.
> we need an implementation that integrates this with the per-CPU
> allocation currently implemented on the vswap side.
>
> If Kairui's patch lands, my patch #4 also can be optimized based on that.

Yup!!

>
> > BTW, can we add some selftests, to make sure the new interface works
> > as expected, and to have example programs for new users to model their
> > scripts after? :)
>
> Yes, I agree. I think selftests are necessary.
>
> Do you want them to be introduced in this patchset, or would it be okay
> to add them separately as follow-up work?

If you have to send another version, might as well include them :)

Otherwise a follow-up is good. Thanks in advance for keeping our
codebase tested!

I'll take a look at the exact implementation on the swap side later,
but I suspect nothing much will have changed :)

