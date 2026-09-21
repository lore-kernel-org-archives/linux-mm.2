Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB23C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC556B0092; Mon, 21 Sep 2026 05:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583DC6B00BD; Mon, 21 Sep 2026 05:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C08A6B00E4; Mon, 21 Sep 2026 05:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2763F6B0092
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:44:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B0641605FF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:44:14 +0000 (UTC)
X-FDA: 85237283628.07.4D9357A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6A333C0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:44:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0WzrlNe;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iT8if2mD/aPImn8Sm68Z/gW49Co1dlEv8RYUDg0WoK4=;
	b=PfZ00dCue0WSTW+vdzxQaX5pqOn8a4nMv8dOxrkn7Ut5ed56qta0x29ozAaRTENzk25X0U
	/O7SRKOKeEKRosM+glhmESfu0HoQq7JocGw30NRMwUSvXYiuf2Hv4oHkUmIHiPigDKHGWc
	X2W5c3P+swgjE9PMh9CmkCPgiFJXZE8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789983852;
	b=AySA2+n80zhmzBWSqeQD0K+bfaeu5TVjNk6RXRliTkcyikN1oAEMP0TeLeBL+q7SosZCOa
	TbDCMqrlJGO6bnVbWCLoCmCIoK0TVXhnvCLWi4qsq/v/WN8kQmXTgTxRztu0j1KYosL6pm
	zXN/PtSUQegGFBGV4EHht9NP+zdEXBE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0WzrlNe;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2DAA43EFE
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897B61F00893
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789983851;
	bh=iT8if2mD/aPImn8Sm68Z/gW49Co1dlEv8RYUDg0WoK4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l0WzrlNeFwS35n4gD5mWRMLGPAYWMSYHLNUgBqszppDslumljtwnzJCATFfAxhlTv
	 3vP8gEA4yIAFU4MKa9qwitfabtnstPyXxfTTCTZcxlqaXxwij/lrm+rq4W9nxqB7B1
	 5QOSXr7J6whdBgyS8PgRyKnVveY41m8wF4eO4f4D+sWe3UbmLEnlEORhFqt1TbAvMQ
	 b0vsWPUQbVdydRtevpYz45puCriu7BKH6N5iMC5nZt6iC26FE9VSmadsIl6kfTY1Pl
	 5KTu037fLirhUYa9/ZvahySuWL/y9Bv1j+UgbkQwJcSHS/0ASPeUDTzGeJZHzdYtgf
	 icnBxmjjxFXKQ==
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-6729c4030f0so1169433d50.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:44:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBylBCQygG6KBSBGLw9xogYL2o0mCgYBcHtShlegz8U09iuGglP0TUll64F1a6Xk7PcwmXY8d3x37Q==@kvack.org
X-Gm-Message-State: AFuF++kCl0fBF3c7nnTv1Z2v1yuCXR16li348AK3v8de/Wd2ORTI2m/W
	i5kVENUZgraa+Kchc1nBLA45cWFlN125ka3dbfmcmYlANfsj91RGmGeZSsDIpi5daF99r0r0LBa
	blaj76s6IfphavivlsdadbEA2K5tU7W7dOxvUq1yphg==
X-Received: by 2002:a05:690e:1206:b0:672:aad4:3ff5 with SMTP id
 956f58d0204a3-672aad4408amr1095386d50.62.1789983850636; Mon, 21 Sep 2026
 02:44:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
In-Reply-To: <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 23:43:59 -1000
X-Gmail-Original-Message-ID: <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
X-Gm-Features: AcwNN1UvMXXPXLi0GhVBjP_wTYqT1-_o3r1PAGjjggfPSSuKF_y4-p-b05lQBwE
Message-ID: <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ftm9ynempwq817xpo41drq1o9bgqig3j
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A333C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789983852-522487
X-HE-Meta: U2FsdGVkX1/8Hpop0VHEQNq1SpR27SkxBoH1WYfFr785aBMxvCnWzqhwsu6AdiANfbp/DSesQr7Nj0CA9UBLVlKbESm3VOv0Pyg4DYuNA0RQing4zjuK90IB/gITa0hh84A8lunGjrNl8w1CaanO2M+Sur9kgXqykLrTLjJ+5+ETR4feCRffpSvgxYqn18B6H1ipbCbW5H4dgNcXHaHbSRKS3sTFDxElNUQUAbZVTND69blzA4RkZe2eR/8Zzi2ntkw4H1u7AVur+V0DDyfNEFJMbh0Iw4oBdjc8TXZq6OUpsL2VaIGdx2MK7tF4mibUyZ3dq+7W9TWHyb6t85omIOo8a6F69hHp2hSy6/7PT62Gfu8ynvIuF+McbaK8IE9OTemjAYq5VJBV7gqt5BMAzpmZEWaeLyciLYQirR6G65Ouvv3K2EFgoDBJEFz/ksIzIJQk1yY85uP4P0OHmEDAYeuWET2o3m3UC2Yil0rwcMBcEjfVa8mUetVCce+VKfwF2gVwcvJefMTHA8atqXv9lfhYExj/hjlLtTEwlIlhTJa7LQFpVHh9QnRmh7lOevF/3ZVImd4xFuBZoRA+CaUIi9HoL1FmlLm+H0BiK/HaiCJKAAfpiCQtrMqK6hObyuIjNVTQn/j9YKvEgR+iE7rtHunAq9SrxqfG7SPZ9XH55hWU0GxEgl5+sqe9gw0YpVmc/muZ13u581sEi6Qu87DY5YisZ26AMpsKIe976Ii1HXamGMF0l7kKu6p8k/+aZzk/M9OBI3j2wYkermIFhCiE3f5DrKMAFGXMTUmvsrrF+3ElP/jFk67w+Jmpd2x0qJJYxL0hdSsvbkkOb6ftBQkxkWN2hK99IXoOSibAb7F5s578MUc3QGuHsLcsggqlot8C9n1myL9bgiaKRoL2hsBkDU+R3LRIP5C9C6g+6K5GN68IBUXq2nWlyWDE08+IGNoR0TnFepq4BwwwGeXp2S9
 yR2gsq1d
 Dj/kj8MAAodkoOtcaGiMa/gEKMFZOeC+gJQ1Y/HZd+V7deteAmloPllOZ/XfFynnlYhgpjN/9PxIk1xM9x6chckehHotDVv1IiIlTLegXgTGPrgW6UqzJbS9cYVDwIZEEFqsnErxeYykNWmd1OO59kTNv71EOlIyNPDHkEEdgw5GpMc2XCUNapdSGEGd7GgKjc1/ODSu1nZS8BY/I5ZWFyh+/NozViC9HywpGum7HUtnMZewnoAYR/XokJCS2bVGifMirmayEx9DjEpQj7dMdAueWUHOHsdPyLwr21zncjHwWJc7xSOX+ecqQy4JEZuGPS5MI5gUkbGhvbsCacVOVxEmd2mgLGskifVsoIB7q6gW9RhZeL0dyl4eaeLIbSy0VXGur3T7L6pVQ0RMkHchjgJXkSpzSx/QQjOELVtSmdbLyYgbLymBf8v+sq8weEuAGcBLATUPYpAIWmc6thg2juNb2yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 3:53=E2=80=AFPM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Sat, Sep 19, 2026 at 09:02:28AM -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 6:08=E2=80=AFAM Gregory Price <gourry@gourry.ne=
t> wrote:
> > >
> > >                         Memory Post-Compression
> > >  |[CD][CD][CD][CD][CD][CD][CD][CD]-------- free space ------------|
> > >    ^----------------------------^
> > >          Compression Space
> >
> > Thanks for the explanation. So the compression space is just the
> > actual data store backing the zswap/xswap/zram.
>
> No.  That is not what I said.
>
> I said
>
>    It's the *amount* of memory consumed by compressed data,
>          including the metadata associated with it.
>
> I do not know how to be clearer than this. It is an amount of memory.

Sure the amount, that is what I have in mind as well. That is why I
said swap counter.
>
> It is not the memory itself or an abstraction to describe how much
> memory, it is literally the active amount of consumption - a number.

Yes, compress zswap counter.
>
> > Maybe we need a separate counter to track actual memory usage,
> > regardless of compression status.
>
> the separate counter is... the existing memory and zswap counters.

Exactly. So, did that solve your problem? If not, why not?

>
> > I want to add support for your usage case as well. Please clearly
> > specify what user usage you want, what the expected outcome
> > is, and why you want that.
> >
>
> I want:

I am sorry, that is not actual user usage. You need to start from an
actual usage case: I have a workload X, only want to give limit Y for
the cgroup jobs but with Z SLO requirement. That kind of actual usage
requirement.

You are basically saying you want a pony. I also want an antimatter
pony. Let's battle with our ponies.

>
>   1) zswap on machines with no swapfile
>
>   2) without being asked "how big?" - there is no number I can give
>      that stays correct, and

Because you can't answer a question, we have to bend over backwards
for you? That does not make sense. There are a lot of questions I
can't answer either; that does not make my pony request more legit.
Apparently, you can't even answer what max(%) of RAM you swap out to
zswap in your fleet. One way to get that answer is to find out what
that % number in the fleet across different years, then you can pick
up the trend and leave a safe margin. FYI, in our case, that number
has been stable for our deployment over many years.

>   3) the bound should be the memory limit that already exists,
>      not a number guessed at boot that hotplug invalidates or
>      guessed at swapon time that different workloads invalidate.

I am sorry, that feels like a rule you invented.

Let's start with the real question: on your fleet what is the max % of
zswap memory compared to total RAM?

I am not designing the swap system for hypothetical situations. I
design it for actual usage. Hypothetical solutions suffice for
hypothetical usage. No patches needed.

As you can tell, I am less interested in the hypothetical solutions
discussion. It is not the best use of my time.

>
> This requires decoupling swap *file* accounting from zswap accounting.

What are your thoughts on current deployment usage depending on the
zswap charge to the swap counters? Changing that will be a
user-visible behavior change and could break other existing
deployments.

Chris

