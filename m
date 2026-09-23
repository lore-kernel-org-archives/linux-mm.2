Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F13FAC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1B06B0088; Wed, 23 Sep 2026 02:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0799B6B008A; Wed, 23 Sep 2026 02:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2706B008C; Wed, 23 Sep 2026 02:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9A8D6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:44:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CD871A06B8
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:44:58 +0000 (UTC)
X-FDA: 85244089476.16.305B6A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54CC4160006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:44:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KH+6SRSN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790145896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3Fe3GZkBaknJJQrEX2RpwW4P0WOBIbz21H+JhSeOuc=;
	b=3GJWLYujxKXdEuE+GUmKlMeVpwV08zX6Pce30I8w/W0JInbxC1uOqtRDh2H7gWqQDX0rGH
	lnbF5k8lGig0M0xrV8wk3IhzUG4k8Ulv6LUZe5h5pxzOD4ZcwnPUQEU1f2qjut+F1Dw5HF
	cuxl7E1vkcCkYfzAwp3iN81ZjHLsXD4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KH+6SRSN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790145896;
	b=BCLVCFOaQ7kYm9P9ia2Nzp10lN0A7UnLp2rB0tCjus3VUzz7Rwn2opAhhuxbuqxPzaWo3b
	dnKI18ACyRcJ2XCJzS8wYW4rPMAUmaHTyauMgE9BwzS9z8/e7pwuCOVXYYDzGthqDr7drR
	UxKYdju6QscYFv0L/wwQwhkpuSWFsZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90C1443F67
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F771F008A4
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790145895;
	bh=U3Fe3GZkBaknJJQrEX2RpwW4P0WOBIbz21H+JhSeOuc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KH+6SRSNEvqMduDQyrAk1/m5V6SS0ddO7ePNHzpfLJs8HzeRvVSi0MYcTbY4ASQYX
	 wpbI2WceWE2GFNraMR5MG8cOZPwg3dsaUpf2jzzvfRnW8RbzTJliBFcwM7aakKm/pa
	 rDVBbrblG0sQAVQ1/QB1x7vYTpcyBqdPmO2tkufLwdnZkekzWJLQArwe3c8Z+LIlaR
	 J3Au44TJJMbFiRsw9v00qM2/UtbkbXUriIjohRWxBxd24lKUprGOM5ozhLJh+z41WA
	 auoSIMkEGV/BhM69FLPP/47DiQMJi5PEEqK+oNovw6q/Scd9wIfxSEegEY2whp0+wM
	 8/5+3fw+fxJuw==
Received: by mail-yx2-f43.google.com with SMTP id 956f58d0204a3-66f943b286fso509397d50.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:44:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx0stA1byrvqeIz07ikCCcyN4O56+5fXNUZEYQAUEX7NbNqK2wp2sVqboQayiOeUQWHYNk0pBJoNw==@kvack.org
X-Gm-Message-State: AFuF++kQMTudI2HNto++Gs3ACWIre62v0XR7V72mdZMykcdoh+eWjYcD
	N65VW/d4ToqBIa3/qsxPQ8FKBuyNauc2SHPllXJ0I1v2dLyhr6tirW2H62s2Dw43rQ/1sqiJL99
	w0UoPJlsxhV+DjlwlmDghw6z1tAGhxE1VLt4JIh+5Yg==
X-Received: by 2002:a05:690e:1909:b0:672:c9eb:4755 with SMTP id
 956f58d0204a3-672d5765c2bmr1091423d50.23.1790145894673; Tue, 22 Sep 2026
 23:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev> <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
 <arKZpJDpsavixjPx@cmpxchg.org> <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>
 <arKgladcnmeTWUKb@linux.dev>
In-Reply-To: <arKgladcnmeTWUKb@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 20:44:40 -1000
X-Gmail-Original-Message-ID: <CACePvbUYhwSjOEXCM08Na_5bccOo6Oz-9BatRSPDO7R310YjaA@mail.gmail.com>
X-Gm-Features: AcwNN1U76kw9ArcfhXgJlon_Ze0jFZEqulu20gcTSrQsz-WCh9osS09uot1Y_ic
Message-ID: <CACePvbUYhwSjOEXCM08Na_5bccOo6Oz-9BatRSPDO7R310YjaA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 54CC4160006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: msnfifj4njuj3kbmgya5fq3xpwdz1yqf
X-HE-Tag: 1790145896-783289
X-HE-Meta: U2FsdGVkX1/dzWATPysQgqE6V31zHchHNcZf6QCf4ktNn20AJ8GqvYYTLpzA+lDKGgqxKRHNW39Lsh9VF5SP2oWhdi6nVJUQ5vTrUhVLiOLGaSStIU2Co7KZJEhXeLGjgnrymwz2lJ6HbkO5h21OMxvK9Z+lVfChXlhQyD51v6EL2mZNtgmw5iT0ZktNylciqnNujGysbS/0L+wlrD8xJuvmNGF4RkJD9ILsRCLyJ2s1FsLcoye7WsxTxjes8CacBEubo7cml4LxreyWx2oDMVdM2N4uRpNzUd+Fpzb9Bw5T8TQ9H58dYxK4WAdd6/vEIxiUUTAoMt+bc6qDHL5v3O2CZiqebX6fZjGlL/XvTjdKzAZDWcx8+szcQZh7YCFW2gKZYFi6hkcBZSIAIWsw8GorkquOqb3TdYr++/8UA5J52UzEx/6+WL+Xvx4i7gckX+m5x3UrM3sdYlWIWUVIn4kBZQmYsRHsZSHQvzaBEjlZsaYdxv1QXFusfgYTP7kRwlOYXH0cWN9XkRXsVYYqUjDFkIFoYZjCBw64JmidelCdfu8RFkqX7E4nuL6XIQNYtiNaTT6qNBqVB31jb+d348VYHPXSKSqNXABknC/S1duijcJvCG5wKX7nmmNUJdHNr690dZVIvv6qi8SB4g852hd8hbNxVlO9vjNbctwQrIep9Mvv7/7gY4xebzncGdNyBSVxQU5KH3Pd3WQD0n6sdMNHmxaEgom0pXzgHUvegBku24Z9as0P4YIcbj/mRwGizBa4xt64yb+XvoOw1CEpgu8+wdFYPYDdshdWXgDRQ/HiXgU+9riLpaQvDntfUvxuN8DBuH7Zr2LYBozF7ApKZ6CuD6dBA9C6JKecS0nRLWIAAaJZaTMHyA2ZGXKgabevP/71Om8U6q/sh0e9xh4H2c1WKTuPxQ9zuNMT2OkN4u/HQlTeVnB71L/PNhO+30/tuhhOxwedfS0b7o+g9xA
 dPHJqn2a
 bYzcBEpzYcFxXZHDkaESU0XaLAhWURzl5sZqTP0gNXqYmjf+EzYcGPLlbZFaHmM4OLEVcgRstjZjkqg/zOnRRL4aQ6EuUEzHRXrQZJB4GOZd6nmItbz3pQRywQ8s7Tgg29zHumNMnhJlEDLcMXOznF1nOCYOVXpzAuQFLLRB0JZenrEDTBsW5VDVfelTapQEKDFyx3QqOT/9dVtyPpxNfYN1etbro9e3xirOM+AM6K+tMthbqY63wEX2DFDEYi2HcTV0KPaED9pDjGsfYT5eYRRg+W5lnbipRGSeMu5gNZYA+FKIsrH1EN5MG7tuYLE+yJ9Nxoa1nA/vXmMzQyOn3ZpuVNOuhHyIE+7hZJ+ohqLtZlZoTIhzveRnX7kGIxTsF9ysODQBlj91xOhu/s3i0sjJHIsl8SskQZfu0K212AEVzg+/ziuCcmX+oQyBDunoOehCPLgrfNgDgdvZeOlr565rH+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 5:46=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Sep 22, 2026 at 05:30:44AM -1000, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 5:07=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > On Tue, Sep 22, 2026 at 04:56:48AM -1000, Chris Li wrote:
> > > > On Tue, Sep 22, 2026 at 4:43=E2=80=AFAM Shakeel Butt <shakeel.butt@=
linux.dev> wrote:
> > > > >
> > > > > People can speak for themselves and suggest other time slots. You=
 do not speak
> > > > > for anyone but yourself here. At this point this is derailing the=
 conversation.
> > > > >
> > > >
> > > > I am expressing my opinion, freedom of speech. As you can see in th=
e
> > > > previous discussion, Baoquan wasn't able to join that time slot. He=
 is
> > > > a major shareholder in XSwap. I worry that alignment vswap vs xswap
> > > > without Baoquan is ineffective. That is my opinion.
> > >
> > > Actually, he said he is not sure if he can make it, and before Nhat
> > > could respond to that soft push you drew a hard line without actually
> > > proposing a workable alternative that made Nhat give up instead.
> >
> > Please consider that it is 1AM in Beijing if I remember correctly. I
> > don't consider that is a workable and reasonable ask.
> >
> > > So my free speech opinion is the same as Shakeel's: you're speaking
> > > for others and thereby derailing efforts to align on something.
> >
> > I sympathize with asking Baoquan to join a meeting at midnight.
> >
> > >
> > > We all want Baoquan in the room.
> >
> > In Chinese we have this saying: don't apply things to others that you
> > wouldn't want applied to yourself. Do you want to participate in a
> > technical meeting at 1 AM?
>
> Three emails in, you have rejected the proposed slot and proposed
> none, and your own conclusion was to drop the meeting and keep this on
> the list. That is not inclusiveness, it is a veto, and the outcome

You skip an important step. I raised the concern that the time zone
does not work for Asian developers; we should find a time zone
friendly to Asia.

Nhat still suggested the original time slot, disregarding my concern.
Which implicitly exclude Baoquan from the discussion. That is the fact
that you missed.

Then I suggested using email discussion instead, because the key
shareholder couldn't attend. There is no veto. I suggested the same
approach Nhat suggested. If you call my suggestion a veto, Nhat veto
first. Nhat issued the first veto. Mine was only a response to Nhat's
insistence.

> serves Baoquan and xswap worse than any hour of the day would have.

Baoquan can't make it at 1AM. It is not a reasonable ask.

> Baoquan said he was not sure he could make it. He is perfectly capable
> of declining himself, or of sending alternative timeslots to the list.

In Baoquan's own words:
"About the meeting time. I am in UTC+8. If the meeting is before 23:00
my time, I can join. If it is later than that, it is too late for me,
and I can only discuss in the mailing list."

He already made it very clear he will not be able to join that time
slot. It is not a maybe. It is a 'can't'. His reply was very clear
before you sent yours. I don't know what part of "not sure" you read
from his email. What is your motivation for twisting this?

Suggesting a 1 AM meeting without considering the time zone difference
is an understandable mistake. Insisting on that time, as Nhat and you
do, reveals more about you. Attacking me for point it out?

> You turned his "not sure" into a hard no on his behalf, then argued
> with everyone who pointed that out.

It is a hard no. 1AM is not a reasonable ask in the first place. Even
after I pointed out it is not Asia friendly, Nhat is still insisting
on it. That was before I suggested we discuss it via email instead.
Get your facts straight.

Chris

> Please reply with two or three specific windows in UTC that work for
> people not in US timezone. If they overlap with the other participants,
> we use one of them.

