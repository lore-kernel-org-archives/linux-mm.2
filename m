Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9F1C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 21:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4338E6B007B; Mon,  3 Aug 2026 17:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4766B0088; Mon,  3 Aug 2026 17:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FAF16B008A; Mon,  3 Aug 2026 17:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1CB56B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:20:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83B3EA081C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:20:15 +0000 (UTC)
X-FDA: 85061226390.03.521F79C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 983B4C000D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:20:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsLtx+Hn;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785792013;
	b=GmBcAoLE+6CbfqBHusD4dPXiO6eFnrPFkZZjEJWxS393LcwDCow1EiSg4yKDM4moQijoKf
	/kUv1n+7zNNusVolH8/3w6nye09IzJ1TJDEWlCOXOOopOaETsFCeBz5z8QCfU/yNo3SqCb
	xanV6DmMKvh3+hI2mfRJPtUYhG53gWE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsLtx+Hn;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785792013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhajB4klxh4v80X3LNDpszm0tYAWjr6mI5IumldjZD4=;
	b=CwVkabH6vSEfammY9SxfFVd5pTlWfVq5pKMO9Kj/hJwAwSDLCfQ8H4+awnb8v/4cjDDOS1
	ExvCOMRWDBJiix8P2mNpwKXGWlHg25BSLbme46/UmjRZcatcll+SEyG+YWW1Fs4kTzRFW6
	Lz1jQP9nZElZmmUSGm9wrVceDDaVhfA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EBFB43AFE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7296A1F00A3A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785792012;
	bh=nhajB4klxh4v80X3LNDpszm0tYAWjr6mI5IumldjZD4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OsLtx+HnBNJCqyOHv/wAGUkRY5SUHYN54Z1hp94/yVRopqRIL5F6xFlJz5D1KLZ/p
	 KdXGzQCnJ4U5xYJCxGiucrFjKFtdJ76iFVuWVIanJO/HBzC7VBuB+AK3zoELc28yWi
	 3Fz44Fnb5+dcZUDlafncdcaHDGGrSQZjKOz9FpYMXr6hgub0Kg0m73D4Oo7UiyfTSN
	 bjZ+DPxNsLGf0w3ioBaLV11xgA+hYkERIQAKyTa0CAe4GPfaotHM8VbnTaP40HL5fc
	 8ty738ZD+mYeHIlnx8+7XgnvSFt13UDTHsnL8sE6YYaIk3QkPbeD2Jia2YQh2RecGW
	 h+LQzZlAdQnNA==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-930f618435cso213980585a.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 14:20:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqTuIePKg+1vxHA012ORI518/xANpHuepvufarQyktzbxiaIO/hR/p6PzwNFgQVkUB4TNBB5a689g==@kvack.org
X-Gm-Message-State: AOJu0YxhhQygNyGE/qTFAT1zWEvbdpY+2crJk9YOkaUP8x+htFGdMqQj
	cqtfFfx+DAoWuXJMqnEcSIm8HlHZmG3w7hhYder7/i/aP9hVJTURpEGwiu0FYu9R6031QmypeMa
	JjcPPClsiwQYVTS4XNyO161SFdNUPBAc=
X-Received: by 2002:a05:620a:230d:10b0:915:cb40:f76a with SMTP id
 af79cd13be357-934a0ac22abmr1687368385a.39.1785792011811; Mon, 03 Aug 2026
 14:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org> <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org> <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org> <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org> <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
 <anCpdjEoDNgVbfzP@cmpxchg.org>
In-Reply-To: <anCpdjEoDNgVbfzP@cmpxchg.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 4 Aug 2026 05:20:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
X-Gm-Features: AUfX_my5DInNlM16VQ1g82eeKFlXBW6QPdPYwLpd2qfDvR7yb3QsjsoFnN7FLA8
Message-ID: <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8xx77cnax3uqayhmp8b6yppgezdutyjh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 983B4C000D
X-HE-Tag: 1785792013-127131
X-HE-Meta: U2FsdGVkX1/1E43PbMOrAW9fyMeYfMc67z5R66uZITr49yXPZ2yISRN34KdVgXKj6Ia2CjNwjNt5+8ZVE3cNFzgqtblBnXt/X9SNG9t5MEeJS2abpNzEM8GIYWC4UzZqYFFG3qv24XVtmVtwPMIxQ3IWdZFOKK/r++tfccarDogz+yjdwmB3l34fvFejUAMbrgEg6pBa6CfPinXA6O1Oecj+Co9eJsFVDGJxkl99iiPdLO0XATjuykL/MWtd0YCuo/BjXNiHxPQ99ORXgU88uUUbOw1RXQJ3dueSjnbdn0MnB7HjWz4nPYHiuLFkoJlszx3MZZ/FIddhWthcxKeTAEXRKd5q7OuwZdCsh7fNh6XXDeht4oSL3Vwdpf3gmf+hUV2fKsw/xNMl0RP2VoBEkHBg5SicMrTCqLYMcmKUpl9OTOgcyoE4ikmDfiRP1ywmra7NDLhW7Ss8YmwopHFIZLzWgdpsw+sTumf4etRo5uvKT0lIabrKzoSJbLZqsc5sFBib8VxzLYDQSJ7f/6dbTfkglvJkRNjtyUw/1/rbsk2RHoPVkD2rY/y70pA/Lo2HlIB0oo9D2vZ8F8dsLA0vrfJVa8J9RhlZlrExG9mYwxxRRuzIqNKVYKRJf1pHP4Fc7+p/EaK8AwyjpgydSHyt05K5DWAomEmWGhFGVDqbw/38T61VV5BOIfwUKhelZtcAOOPlpQaC2G0ow7Zo13FI2p6jiu9HattSCBBkW1X/FvQxD8QQp7wKEfPdes89fGFud/WHxkzqrEHc2Ex/BTS8jAaHMrETNgFqwGD7Rb6feKTm/OC73zhPbQ6yv5MWTJs50VXk7E2patMQyRIOVu9zGYDG4QfJ6oazJKLZLa8fO8K7l/yXrqH0V7eJzMXWesosNeKS1WOUPqICPuW6Rn3VkuGLsATcQ9WvsAiE7aAg/ksFkaiGn8sMBSEw0ZY+8zTB4lr06uhh9O8T/sgUPQX
 0WDTG369
 8V3ZnRalcADJO7G3VoAlOWzFOjjw4JDj4t15JCQPFeYUvZxuto00vkhNI6pOOmneOrxiJUBAODhSYdMGZOml7MuS4wORv+yNAEL8yLnw6kK26Kv5uCzymCxvmVBPwfVrxmvA6FmWWaJ9HpbAg7HI3tEJfxYw+6LQfINjCpvPGDy+IQZAnIx8vRQxTxWRjnOBPndQ7q3xnRWr3OA74POW/xYPJ/Le5ycTrM9h3BImZqB/BlAPS0HpuJ3kV2jIoRwCRCH62YSQQtFvmBASZyuOLECGRIJ9U/AYtnAgLAHk2tle9kY4tNgxmjYFxteFPl8OtYGuEDmwM/S/Ea6yVIiwqjx7DvBL1UCcFnLMzQHna6FV8oTbAzo+DCyQGWwRevsGFeVn+AcIzXALp4no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 10:45=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Sat, Aug 01, 2026 at 03:33:42PM +0800, Barry Song wrote:
> > On Fri, Jul 31, 2026 at 11:04=E2=80=AFPM Johannes Weiner <hannes@cmpxch=
g.org> wrote:
> > > This is kind of tangential, but I'm curious if you would have
> > > experimented with larger folios AND the THP shrinker?
> > >
> >
> > Haven't tried it yet.
> >
> > A key difference between Android and server workloads is that Android
> > typically has many applications running with frequent
> > foreground/background transitions. When an app moves to the
> > background, much of its memory may be compressed. When it returns to
> > the foreground, it often allocates a large amount of new memory,
> > creating significant memory pressure.
> >
> > If we need around 200 ms to cold/warm start an app, allocating 2 MB
> > folios and later splitting them into smaller ones via the THP shrinker
> > could cause us to hit this shrinker path directly during the app launch
> > process. For example, we may spend the first 100 ms allocating 2 MB
> > folios and then the next 100 ms shrinking them back under memory
> > pressure. This would be quite ironic for Android :-)
> >
> > Since Android app launches can demand a large amount of memory on
> > devices with limited RAM, keeping burst allocations small is also
> > important.
>
> Makes sense, thanks for the insight.
>
> It works for many DC services because it's just a bit of extra startup
> cost, while then getting predictable THP coverage for exactly those
> areas where it makes sense, and the TLB benefits pay off over long
> service runtimes.
>
> > > In Meta, 2M thp=3Dalways without the shrinker would also not have bee=
n
> > > tolerable. It OOMed immediately on a large number of services. The
> > > shrinker *is* what allowed us to use such large folios to begin with,
> > > without the internal memory waste problem.
> >
> > My understanding is that Meta's use case is a service that is already
> > running with 2 MB pages, and later additional services start and
> > require more memory. In that case, shrinking THPs from the existing
> > service to free memory for the new services makes sense to me.
>
> It's simpler than that. We had existing services, scaled to machine
> capacity, running with basepages. When we enabled 2M pages, they
> started thrashing and OOMing from areas with poor virtual packing.
>
> The shrinker makes it possible to run with THPs enabled, period. This
> is why I'm concerned about making the search for waste less
> efficient. It would likely regress things in production immediately.
>
> > > Here is an idea: the THP shrinker will not consider anything unused
> > > that has <=3D max_ptes_none zero pages. See thp_underused(). Joanne w=
as
> > > proposing to scale this knob down relative to the folio size for mTHP
> > > shrinking. What if instead we kept the meaning absolute?
> > >
> > > The knob is an expression of how much waste the user is willing to
> > > tolerate per folio. If the folio order in question couldn't possibly
> > > have that much waste in the first place, we don't have to queue it?
> > >
> > > Something like this:
> > >
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 2bccb0a53a0a..1670e9869bd3 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -4364,6 +4364,9 @@ void deferred_split_folio(struct folio *folio, =
bool partially_mapped)
> > >         if (!partially_mapped && !split_underused_thp)
> > >                 return;
> > >
> > > +       if (!partially_mapped && folio_nr_pages(folio) <=3D khugepage=
d_max_ptes_none)
> > > +               return;
> > > +
> > >         /*
> > >          * Exclude swapcache: originally to avoid a corrupt deferred =
split
> > >          * queue. Nowadays that is fully prevented by __memcg1_swapou=
t();
> > >
> > > The setting defaults to the PMD-1, so out of the box we wouldn't queu=
e
> > > any new orders. It would allow that 2MB on 64k ARM usecase, without
> > > jeopardizing smaller mTHP usecases like Barry's.
> > >
> > > Thoughts?
> >
> > My understanding is that adding smaller folios to the deferred split
> > list is not the right approach. We could end up with a very large list
> > where we cannot distinguish partially unmapped folios from fully mapped
> > ones. For example, the deferred split list could contain 100 fully mapp=
ed
> > folios but only a single partially mapped folio.
> > Moreover, for smaller large folios, the number of zero subpages
> > is likely to be small and short-lived.
> >
> > However, this is probably fine for larger large folios, since it is
> > unlikely to significantly increase the size of the deferred split
> > list. In other words, the deferred split list should remain manageable.
> > For the same reason, larger large folios may not benefit much from the
> > LRU cache either.
> >
> > So if we have some mechanism to prevent users from doing things that
> > are not beneficial, such as adding smaller large folios to the list, it
> > seems reasonable to me.
>
> Just to clarify, we're on the same page, right? I was proposing a
> mechanism to do just that.

For example, with smaller folios, the distribution might look
something like this:

Smaller large folios

+------------------------------------------------------------+
| F | F | F | F | F | F | F | F | F | F | F | F | F | P | Z |
+------------------------------------------------------------+

F: Fully mapped      (dominant)
P: Partially mapped  (rare)
Z: Zero subpages mapped (rare)

So it doesn't make much sense to add them to the list, because we
would rarely find P, and even the few Z entries we do find would
soon be filled with non-zero data anyway.

For larger folios, the list becomes much shorter. As folio size
increases, they are more likely to contain zero-filled subpages:

Larger large folios:

+------------------------------------------------------------+
| F | P | Z | F | P | Z | P | F | Z | F | P | Z | F | P | Z |
+------------------------------------------------------------+

F, P and Z become much more evenly distributed.

So if the folio is large enough, this seems acceptable. I know a
sysctl knob may not be well received, as it adds to the user's
configuration burden. Perhaps we could just hard-code a
sufficiently large value instead? for example,

#define LARGE_FOLIO_ZERO_SCAN_MIN_SIZE SZ_2M

if (folio_size(folio) >=3D LARGE_FOLIO_ZERO_SCAN_MIN_SIZE)
     deferred_split_folio(folio, false);

If, someday, people find that 1 MiB also helps, they can provide
data to support it.

>
> > As a side note (I'm not quite sure whether this is relevant to this
> > discussion), one thing we tried previously as an out-of-tree proof of
> > concept was:
> >
> > for (pfn =3D start_phys_pfn; pfn < end_phys_pfn;) {
> >      folio =3D get_folio_from_pfn();
> >      if (folio_is_zero_fill(folio))
> >             swap_out(folio);
> >      pfn +=3D folio_nr_pages();
> > }
> >
> > Then I was using my previous patch to remap it to zero-pfn if someone
> > reads it:
> > https://lore.kernel.org/linux-mm/20241212073711.82300-1-21cnbao@gmail.c=
om/
> >
> > This does not depend on any list-related logic. We can scan all PFNs
> > within a short time.
>
> Hm there are 268 million PFNs on a 1TB host. I don't think that can
> scale?
>

Yes, this is a problem. We tried this on a GB-scale system, and
the scanning itself was very fast. However, it provided little
benefit, as the zero-filled subpages were quickly overwritten
with non-zero data.

> Compaction used to be linear scans, but needed to grow the freelist
> search and a whole bunch of position hinting to stay ahead of scaling
> bottlenecks.

Right. If we want a physical-address-based scan, we'll need some
lightweight mechanism to hint where scanning should start.

Thanks
Barry

