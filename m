Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 281D0D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 19:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8075A6B0093; Mon,  1 Dec 2025 14:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE956B0096; Mon,  1 Dec 2025 14:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4356B00A3; Mon,  1 Dec 2025 14:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB4F6B0093
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 14:50:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FCDA1A0397
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:50:03 +0000 (UTC)
X-FDA: 84171943086.22.D2FE344
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F90E120018
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:50:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ODgB1jI6;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764618601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMQ71FjTiv/M/XxD9qDr2Begby59Dyu9nimvb9z/0nU=;
	b=ootNTYxGDGyW14zkQoUH/YS9R6e/VTv9NDPS7IxwyI30ZmchIK9gO6R7Oy+h+Nfgb+6C3M
	3jXDIg5v6ZtWheTozh819KX2SlEgi5U1O+YVlgcK0nKrid+9f3qrWGZS/9WLYyES0xx8U4
	NpjnnB096oDTxmXxzjF3DXpfJYDzaGM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ODgB1jI6;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764618601; a=rsa-sha256;
	cv=none;
	b=jdkFBgX2y/n7OdDxvLYYpmtL2W/BgTLpt82SdO7i2TD5f3oK8Zzf8I9d65syNG+N+44laK
	wxIDQanzSfwDfareQPbngpl/la7RRSMIAKU7wGTHcQvuZ5MewJQVN7JaHXzPzvVaMgY+0O
	ieGM437oteLYr/MWzKxFBoGtiMJWuFg=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so8033716a12.2
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 11:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764618599; x=1765223399; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eMQ71FjTiv/M/XxD9qDr2Begby59Dyu9nimvb9z/0nU=;
        b=ODgB1jI665STcuDyKgWZaH4jMQsvAjclJ+kFxJTdSi6/RDKAD2g/tE7G5p+6K2S8GV
         4sLO9CkOEepWUwU9E1wzfGBlH0P6COlVZPEB5dLl6fslSbHe6Qhef+N+GkVVSqlKtOkP
         nMjI+SM4iqi9Sperc/9mkA0TZmZC7SPEu8nsv6yRvwV9DxXNU7dGMtgFKzh6pcnfFeow
         zvWhPdndz5LEfInv/T22tjDahkBSHmFG4nP05LuXvjiMWTxZzXCkwIsWte23gmOWT2kT
         0/zfWiAgcHK859RDwd4sSssxiP5VEq3CAakFpLRr+hY3IO/tcVuPajtMlYIxGdAjSL32
         abAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764618599; x=1765223399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eMQ71FjTiv/M/XxD9qDr2Begby59Dyu9nimvb9z/0nU=;
        b=UBlGYcMDGOZpFtCAB1twHBN/8cEYgFvOHWZVm9rPHKz4Kfx7Hu8K9k3ub/cLIrOnIz
         TYPcubYzzVeLvl7HBe97E+onD66P7vVKZghtBm1CD5LVb7Vxo57+YbmZ9UZ3wUJV5Mxy
         AROkPrwJdzuTmorpz/LrlCd1UxV8OUK7cYnET//CLkdE3wVXaOrmD8NBkAmqz6HQkHNS
         PMGN2AB0CtTSSu4riCS9TD2oBvMTu6waOCUjsk293KoN41ihJRHLWcgsnLNgA6DS8f59
         qQWNzu1YGRsdpfcZ5vcfJ4xcSkFv5vL0yehNB+b89xtOBZbkYo/W6WvQjjT0NbG62F+F
         aBTQ==
X-Gm-Message-State: AOJu0Yz5LAVq9zp3fjFMSWNTsi8bxtpjhQwEOM1KX9fcgMqtp4c8//5o
	Q2ahM3ejEsBjQgvW4Rx7k7aS2eL+YaM3/9liudpNU0PpimjkdUN7sFJy/frnK/zWMbAqIJfkvd4
	3EcJG0dDanUt4Wc/seGid70hlSI+pGnVxVTZ/gxU=
X-Gm-Gg: ASbGncs/lY/0CZ6M+6gTkJUYbgOTtI8RXafQGlvurh/Y35f2LK9sBYtPvYEb9vDY+i2
	GZaDTFYNzXzDTOlEWX+6QbtJR4IrIVGhy+KsI7f1mqMqmZkQWSlCpIkVte2OOaPBBLGHBpjke1J
	RgF570Ws8/yE9IkfHH6X2E0SHqPS7vpcc877tgKCSDhaS3/ne+8fqMIKtOwNXxeUPZM8sVeg5A5
	ECUojQAawmjjvWLwO6n2xcg+YG6IHVwGWtR5jyJq8yLknNDxg5KqZrCdX02a2p0lP3oihbAGCsP
	TSe2bA/4On9VEtPpsxAbod/aMYg=
X-Google-Smtp-Source: AGHT+IF3MEtl3a3/0fdOKj7mXHj1RC4VZIGNKj2SZzS0A34OugEw54a5C6WSE0/brdQYFAL5c8aTnL62QvyOeulDJCI=
X-Received: by 2002:a05:6402:3547:b0:646:683:6075 with SMTP id
 4fb4d7f45d1cf-646068360e4mr20104683a12.32.1764618599075; Mon, 01 Dec 2025
 11:49:59 -0800 (PST)
MIME-Version: 1.0
References: <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org> <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
 <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
 <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
 <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
 <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com> <20251201164338.GA430226@cmpxchg.org>
In-Reply-To: <20251201164338.GA430226@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Dec 2025 03:49:22 +0800
X-Gm-Features: AWmQ_bnbDjp79PAvMWoE2dWqg0hfjicNaCX5W2oiFMtvtSlmSjqorQJavH8dsgw
Message-ID: <CAMgjq7Ch+M21W0YH-edngSYVfb07-m-bVq=zTenF2PLcAPt4EA@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, YoungJun Park <youngjun.park@lge.com>, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5F90E120018
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ywnuuhr7ihpacg7if43n4dadd197kcyj
X-HE-Tag: 1764618601-754625
X-HE-Meta: U2FsdGVkX1+xQTpi1uVbbb/XtOT/rFqRTABDV+J8IvUOYZOU53aK2rZ58bx72Bqj+z42JS3hwi+Lyk6xQIqH+1ZZFxT5HqegSNEESSHl86ilSPKWO32dOvV2l0UUW5YNpUn/PzqXxxEAG2noA6+Hsc58Y/FMeb5UJGz2/pJE4Jrv66jnbzAGF5kAGYR3yVHX0/p+Le2Z7zwYyvJTNZn3oqNY4Id4iWFtqcnHULZh/KnU8i3WdqoWtcOSwG9nCyvArOnREZN71jjTHf3q8XhODkpq+KGu6aHkB0KUxOQuJ+AaMIb7H/oT1BYWGKDrVQ62IiFh1aJTBgc1dOL3qPer70x02BGYQjVJAEYz6CnrsAUO9S/zh5sJvtY6hd3srsePLqWcC9C7YoJ36oBV1KXKDqqq99aJ48Sz1wCXXQqmANjyAAE3ifoHAiJG0rU2hbTpBwL9MpZpHp2kmMkPf7wEe17zI5Hg0B92U3Rq7dNpw9xhlxyCIIvqtXCOl0ppDWcr2DknSb0Iv9xOR3SsZ0JUz6fUYnhkq5UHX5wcZMrUGRWubroVrTcHcLMrd8CB6nTvXcjUA4FdRN/DM+o0DeqjsS2HbLRfs9bG4PXmyzNYGPTBmuJHb+cXvOncx71pCuNwiaj3Z6V9vbrFDz3hkh6iE3NU/So10CdIzkDXw/uBdpTCcIldoPsMvgUHwRw4xe6MzIfDTTTFcZwcg9cIeZzD9IsY2sHGKbcMcoBcxeDkEml/7+RdG+yxiLgLAso1SV9pE6ebLrYK6+esvt/nTIzCjIzNM30zmkwQ+ElvE0pa6fr5rL4D37N86EpQFx9kvGlk57zluk0f2mC/hjxNjkFaVp3SXODlQx3raAlLbDkwjV/5ttVlvDqlq6VFd+NAPEOFt9dzfEYLLx2g7x8AD92F5Gy/A6t5DqNkzvG3kDX7ZXYY8iECyxyMID6tEqe/uERhGQdCDIM10TLp4TqHBMq
 3oHdSTNO
 aTUVQgxPoOmQiP7SxF7PFzDGK3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 12:47=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Sun, Nov 30, 2025 at 12:38:38AM +0400, Chris Li wrote:
> > On Sat, Nov 29, 2025 at 12:46=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> =
wrote:
> > >
> > > On Thu, Nov 27, 2025 at 11:10=E2=80=AFAM Chris Li <chrisl@kernel.org>=
 wrote:
> > > >
> > > > On Thu, Nov 27, 2025 at 6:28=E2=80=AFAM Rik van Riel <riel@surriel.=
com> wrote:
> > > > >
> > > > > Sorry, I am talking about upstream.
> > > >
> > > > So far I have not had a pleasant upstream experience when submittin=
g
> > > > this particular patch to upstream.
> > > >
> > > > > I really appreciate anybody participating in Linux
> > > > > kernel development. Linux is good because different
> > > > > people bring different perspectives to the table.
> > > >
> > > > Of course everybody is welcome. However, NACK without technical
> > > > justification is very bad for upstream development. I can't imagine
> > > > what a new hacker would think after going through what I have gone
> > > > through for this patch. He/she will likely quit contributing upstre=
am.
> > > > This is not the kind of welcome we want.
> > > >
> > > > Nhat needs to be able to technically justify his NACK as a maintain=
er.
> > > > Sorry there is no other way to sugar coat it.
> > >
> > > I am NOT the only zswap maintainer who expresses concerns. Other
> > > people also have their misgivings, so I have let them speak and not
> > > put words in their mouths.
> >
> > You did not mention the fact that both two NACK from zswap maintainers
> > are from the same company. I assume you have some kind of team sync.
> > There is a term for that, called "person acting in concert".
>
> For the benefit of anybody following this from the sidelines, the
> third zswap maintainer also expressed concerns about Chris's proposal
> upthread. He works for the same company as Chris.
>
> The reality is that Chris is failing to convince others of his design
> direction, and is now obviously resorting to manipulation and hominem
> attacks.
>
> During the course of this thread, Chris has asked for "a little faith"
> that his idea will work for all stated requirements, without deeming
> it necessary to explain how.
>
> When probed on technical details, he stated that he doesn't like to
> plan that far ahead, and prefers having somebody else iron out the
> implementation details. He also referred to high-level slides from his
> LSFMM '24 session - which was received thusly[1]:
>
>   Matthew Wilcox agreed, warning Li that he was setting himself up for "a=
 world of pain".
>
>   Jan Kara said that existing filesystem designs are not suited to this t=
ask
>
>   Hildenbrand said that this plan was introducing too much complexity
>
> His first response to criticism was to invoke his <4 week status of
> swap maintainer.
>
> Meanwhile, the design direction that Chris is construing as a single
> company conspiracy is anything but. The collaborative origins of these
> patches are well documented. Chris was CC'd on those RFCs. He notably
> did not engage in them. He is now lying about the narrative and
> choosing to attack these patches in bad faith and out of context.
>
> This pattern of behavior gives me low confidence that Chris is able to
> collaborate and compromise on a design that works for all users.
>
> And while Chris has been quite vocal and opinionated in mailing list
> discussions, his actual code contributions to the kernel do not
> instill confidence that he can solve this problem by himself, either.

Hi all,

I=E2=80=99d really prefer we all let things cool off a bit before the threa=
d
gets too dramatic. :)

Sorry to see that the discussion went quite off topic, still I believe
this is some kind of misunderstanding on Chris' intention to improve
the kernel in a more generic way.

From my perspective, Chris did co-developed, suggested, reviewed or
authored many of the implementation details around the swap-table
idea, and he implemented the swap cluster allocator in 6.11, which
unlocked a bunch of follow-on optimizations.

I=E2=80=99ve been working on swap for a while as well and have rewritten an=
d
refactored large parts of the swap, swap allocator and swap cache
(mm/swapfile.c, mm/swap_state.c, swap.h, swap_table.h). Maybe, yeah,
I=E2=80=99m not a kernel vet with decades of patches yet, but I do think I'=
m
familiar enough with swap. I think Chris' work, words or code, has
been looking good in the end results.

It's hard to put a penthouse on a sandcastle, and maybe that's the
reason makes it hard to describe or layout the further implementations
of swap.

We all struggled with swap subsystem a lot, the code base served us
well, but it had accumulated a lot of historical complexity and
awkward workarounds overtime (we had so many people in the community
complaining about it for so many years). I think we all agree that
pursuing incremental cleanups and improvement (eg. swap slot cache
cleanup, swap lock cleanup, swap_has_cache cleanup,
direct-swap workarounds removal, etc.) is more suitable upstream.
Chris also help a lot on this (eg. the LPC talk last year) and we
finally got rid of many long time burdens, quite some of these
works are directly enabled by his swap allocator rework first.

And I do have a more completed branch that I posted several times
showing the end results of swap tables have better memory consumption
& performance, and the code is much simpler than what we had in
upstream. It's getting merged step by step, and each step is a gain. I
believe that is the right way to improve things upstream, everyone and
every workload benefits, and progressively. And based on that, we will
be able to implement things much easier.

I believe things will look much better and cleaner as we process (eg.
resizing might be doable for generic swap too), and make it easier for
all of us, and make the swap subsystem better in a collaborative way.

Cheers.

