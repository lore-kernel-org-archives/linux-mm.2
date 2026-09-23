Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2C8C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557F66B008A; Wed, 23 Sep 2026 02:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E9A6B0096; Wed, 23 Sep 2026 02:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C3B6B0098; Wed, 23 Sep 2026 02:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17EB46B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:00:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8586F1206C2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:00:31 +0000 (UTC)
X-FDA: 85243977462.20.80EC8EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 96F7980009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:00:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAl6sxQx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790143229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkZS2huMpK9aj3JJu96Q0GZOFrTIfwhQ8vLWwetA9js=;
	b=e+EtReaDM5aGjFPRCf/LnXYq27FRH0fzDF8PMC+1SyimdmSQM/7U9wh0usFlhYZZUy48xt
	/DIAXRRIU73vn+ISkR9GN30pz/wboMCwFFgyIOF9m+qjgf+CN8tUBI/k09jr09xE7mkeSs
	XWFTUotzFWjgJBdcP9iwDV1HBsDd3yo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAl6sxQx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790143229;
	b=Jn4ffdPKVI8TaWUyTM6NiUQ3JeQyWxJ1l9vwjGadUvsTyA84+JxZV/+CrLV3xk1zgMCzx1
	xffisCbLgZHHaqKSDO5OeMeP8Dnv+t9V6TnMCEwqhsYeNJvSLeZQ2vua3egbww5Mgm+3hf
	AOZddVLSx0958XDFuV2wSnVHfC3dfe4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08B0260211
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FD71F00899
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143228;
	bh=dkZS2huMpK9aj3JJu96Q0GZOFrTIfwhQ8vLWwetA9js=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EAl6sxQxjjS4GK6iTM6EkJfU/8tbU7t7Df21vk+7jVJ55LC1r2rigDEqn4oTXNqAI
	 4SHzdTg+4tdbogPr5Fa3k1X4M0du/u4ZA/+6DCrf6rKAbWVTEovo9RVnuCTrNbxhQw
	 THK4KqFrrDkXQecuPtMxSKJRpVzthrM+8IQ6+C8iv62VTATRaRFzJw7FjiX7DmW4TG
	 sGymYUFI85nGxvE+SKaEkE/ELuXY6qODnXPMMSp9RsW6GKf+g/gH/5bh5XFwpGuzEY
	 WSYmzlGB7sklIDpLmlEj0Cwhn97QvNQRA8UC3iyUQBhenydkXPx4Mi74laeTi/kofM
	 tibGN5OCZ619Q==
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-914110894d3so1767036d6.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:00:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByoxgblRpTCGV/RBlKwXhRhwwzIf2mGSLWtnmdVRYiJixI2EastklUNYD8+C8p9cIFIm2+Gr7RcuQ==@kvack.org
X-Gm-Message-State: AFuF++kVnjXtXYiaE719TW0UyNIUL2mLUdqBhcLFETgvQUsOXYJ8soam
	7g6x6VXaKJgTWAJSvXu7294FO1gi9A+y3cTjmZRVnNfo0E+ZkoUrwKQLfIl75tYywMNbnpTbjWk
	7H4iDdqGS5hd689iQJY388QJXik6KyU8=
X-Received: by 2002:a05:620a:8904:b0:939:31b5:4e08 with SMTP id
 af79cd13be357-93c24f2151emr238190285a.0.1790143228001; Tue, 22 Sep 2026
 23:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev> <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
 <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com>
In-Reply-To: <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 23 Sep 2026 14:00:16 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x_Q1Ku9r6zfC-K-o87juQ9JNQ8=OSNp+UZzW3MPtZXbQ@mail.gmail.com>
X-Gm-Features: AcwNN1V-Cozelpt2XHBHYL-ucn6sa6OiDIMLWfyJ_uDbOL_YzbUy9AEWvOryN5k
Message-ID: <CAGsJ_4x_Q1Ku9r6zfC-K-o87juQ9JNQ8=OSNp+UZzW3MPtZXbQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	ljs@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nqyxjken518f1kzmjzcjd5jmngm4zbs1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 96F7980009
X-HE-Tag: 1790143229-832077
X-HE-Meta: U2FsdGVkX1+WwE4m0vnD5JyJB1miyXXcbMw+D9HOhROP6Ji5TqHl0TRkRQc0Z54V9RSu4xpWRog0dC6GSXrbFRIsLkK2tmzkUaJemYTpxfpnfkLbB/DLlOkjCG9/d+nnotZp4Zs7atQKgY80YLL+zxBWalxESu5gABTOoSdWLXdi+UmtKrOUzRDEZwYdG3UTQs0YJ09LWiNx9b2B0h04uuyWWPy8xgNvp5XrQd//C1p3cBzvhhePM5aRjG1NMbQnGRQhEEWvsjx+DCnqN99GD7Yv1h64IefStKfogv1xETA8LJHMI5nMPQZxAFcOHiGweYw7dhGKWqSBKDJH7oWselDCa8gMsH84sFN/nMSk/QR22o5QOdfO/ySLuBSEmbV6EO8cpnVdZSFim4jM3wtcrygqpqx8YPHXR27CznKTFBXShIWrmLvLSKIruEMrvhs7PX11tPXuQaAOL0UdF14+Svh9wdrhz4Vvr+BSqOOE+CUhg57eUUn++WVD2t6T4YDo4nX19UQCHxZ1xMx8HKddcbfDI1HWxhpYVahxeGB5e5Fa0B/cOdN6kEg4yNjnZqQTDmAdWPlB24ErhtQPQXq9KHfUaVmtAk2uw5NWAJtWT4PxfSZdcRNmhkmsbSIbZf3CamypLBhiX12+84ZqTSve9IslJ2Em1PGanhJioMM561XWqTFJllfDxQMgV8e7N4+B6zlf3hOFaky2VtzPlmdK0IMpVLCEGklI/esY/62FcskqBrgNz0GeXuT3qVSZ+6m5wyoEjRS3xP/viOM5JWpB8pg6SraHVlxzv8WAQixhQ5XBCUrSeDN+neNoKlY+EqO4c0goPpIEpYfpifn/kAsEf2V6td/h5UphbryKRgZdzwBgK1N3J2Ekb5F7RqarDg2sd5jGv8rXMNk8aMMscSQio1T4g2iNodFT6NK6OmFVwQmI1jJcVk6az+JEB6dMn3fW/V3wf5dra1S0NixivAy
 pQnBe6bv
 NSkAQhLorrUJDUeK5Zi6X0J5WF7wNW0Yh3HqdJibtXiLUUU2l+55a8gUYlLDNL3SFNQMfFAOrnmbytCkIGOMYLXtn9P6waJcE/1mNQDbsCMTXPuHO4PzbSERdTkj6nJa84EkK/fDMOyZ36fN3md69jtUlYZKnfUQQq5Q7nmauK4KY3oOtrnrnrjlglCOE1gB8ZeE8GMAp9M7RSUuYsfQHo1Bp+XZ0PcgWfoIclZrpsMOW5u6HiyuwD0zS/6IJQNKW+ErZGIjaIiPqSTgeRdb6zkAY6bt8WJG39qDPyu+NxiZTyowphSqO+rJBCYLkVjLcRsZ7hr2wAIXVmQhlxe8/StxoSSUlq19iAYxMPL9PsEZ7d8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 8:44=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Mon, Sep 21, 2026 at 3:12=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 9/20/26 18:20, Lance Yang wrote:
> > >
> > > On Wed, Sep 16, 2026 at 03:44:34PM -0700, Joanne Koong wrote:
> > >> PMD-sized THPs that are mostly zero-filled are reclaimed under memor=
y
> > >> pressure by the deferred split shrinker, but this is not done for mT=
HP
> > >> folios. At Meta we would like to deploy 2M THP=3Dalways on arm64 wit=
h 64k
> > >> base pages, as 2M provides the contpte benefits while the PMD size t=
here
> > >> (512M) is too big to use. However, 2M THP=3Dalways causes memory reg=
ressions
> > >> unless the unused portions of those folios can be broken down and
> > >> reclaimed.
> > >>
> > >> v1 did two things. It scaled khugepaged_max_ptes_none down per folio=
 order and
> > >> it queued every anonymous mTHP folio. David objected to the scaling =
since
> >
> > "David objected to the scaling", not quite. The tricky bit is the scali=
ng when
> > collapsing (creep).
> >
> > When freeing, I'd assume scaling should be alright.
>
> Ah, apologies for misinterpreting your comment.
>
> >
> > >> collapse had already rejected proportional scaling as either letting=
 the memory
> > >> footprint creep or being confusing to reason about. David and Barry =
separately
> > >> objected to the queuing, which adds list_lru lock contention on ever=
y anonymous
> > >> fault, and hurts lower-order use cases such as Android's order-2-onl=
y
> > >> configuration. Johannes suggested keeping khugepaged_max_ptes_none a=
bsolute and
> > >> simply not queuing folios that could never exceed it, which addresse=
s both.
> > >>
> > >> Read as an absolute count, khugepaged_max_ptes_none also implies the
> > >> smallest folio that takes part in underused splitting. A 2M folio on=
 64k
> > >> base pages is 32 pages, so the knob has to be set below 32 for those=
 to
> > >> be queued at all, and any folio with no more pages than the value st=
ays off
> > >> the queue entirely.
> > >
> > > Em ... I'm not sure max_ptes_none should also become the mTHP underus=
ed
> > > threshold ...
> > >
> > > Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
> > > collapse uses 16, while mTHP collapse turns the same value into 0. Wi=
th
> > > this series, an order-5 (2 MiB) mTHP enters the deferred split queue
> > > because it has 32 pages, and is considered underused once more than 1=
6
> > > pages are zero-filled. So the same knob means 16, 0, and 16 depending=
 on
> > > where it is used ... That's a bit odd ... no?
> >
> > I very much prefer scaling over using absolute numbers as proposed here=
.
> >
>
> With scaling, I don't see a way of avoiding having to queue every
> anonymous folio of order >=3D2 to the deferred split list at fault time
> in the non-default max_ptes_none case, since any folio can now
> potentially qualify as underused. This drew some objections in v1,
> particularly for the Android small folios case. I read that as ruling
> out scaling. The objections were a) the list_lru lock contention and
> b) the limited upside vs cost of splitting small folios.
>
> For a), I don't think there were any hard numbers showing this is a
> problem. If it would be helpful to have some benchmark numbers, I'm
> happy to run a synthetic one (patch 3 applied (which adds anon mTHP
> folios to the deferred split list), only order-2 enabled,
> max_ptes_none set low enough, all threads in one cgroup on one node so
> they contend on the same lock, each thread faulting in a large private
> anonymous mapping). I'm happy to run something else if anyone has a
> workload they would trust more. Johannes also mentioned batching as a
> mitigation. If the contention does turn out to be an issue, I'm happy
> to prototype that and measure it too.

Hi Joanne,

you may take a look at Shivank's report:
https://lore.kernel.org/linux-mm/08f63301a58f0e0c38480553295ad9af95928da6.c=
amel@amd.com/

It's not the same lock, but the problem could be quite similar to the
`lru_cache` case.

The `lru_cache` work for mTHP order-2 not only resolves AMD's
regression after enabling order-2 mTHP, but also improves overall
performance. before that, there was a regression after enabling mTHP
due to lru lock contention:

"
Performance
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

                  Base       Patched    delta
4K                109.60     109.11     -0.4%
mTHP-16K          144.10      99.00    -31.3%
mTHP-64K          104.75     104.25     -0.5%

mTHP-16K was ~31% slower than THP-never, due to lock contentions.
With your series, mTHP-16 performs ~9% faster than THP-never.
"

>
> For b), v1 unconditionally queued every folio of order >=3D 2. v2 added
> an optimization patch for skipping queueing entirely if max_ptes_none
> is at its default value, which would also carry over if we went with
> scaling. So I think with that patch added, for the objection to b), it
> depends on what max_ptes_none Android actually runs. At the default
> max_ptes_none, nothing would be queued at all, so a config that sees
> no benefit from splitting small folios would pay nothing for it.

I assume your case is that you always use 2MB mTHP and don't use
512MB PMD-sized THP at all, so you don't have the conflict Lance
mentioned? For Android, I don't think we would enable both 16KB mTHP
and THP either.

But thinking about it again, for a general-purpose system, I also find
it a bit strange if we have both mTHP and THP enabled.

>
> Does that make scaling acceptable to you and Barry? If so, I'd prefer
> that as well because if/when intermediary values are supported for
> mTHP collapse, that support would have to be proportional, and it'd be
> easier to reconcile the two with split also scaled. If not, then what
> would be the suggestion for where to take v3?
>
> Happy to also discuss some of this at LPC in person, if that would be
> more helpful.

Thanks
Barry

