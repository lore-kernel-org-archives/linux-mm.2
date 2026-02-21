Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB31C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 06:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68456B0005; Sat, 21 Feb 2026 01:04:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC1C6B0089; Sat, 21 Feb 2026 01:04:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDF06B008A; Sat, 21 Feb 2026 01:04:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A630D6B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:04:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0862E1A041B
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 06:04:24 +0000 (UTC)
X-FDA: 84467424048.28.7801490
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B85040005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 06:04:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LMxxdDlj;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771653862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTauQkrmFvKkr/II8+81Sp8G1oZoJ9jGOwsLPvYTl+U=;
	b=ICNv2+33OM9yiXoXNGmtRZTlqksYLavwPFXSsTCte0i8JUAtFE+HTgoIH7ch4I/s8jgRbN
	5qIY1sc9cZH8RPL/6ZkSbxhQHepnBFYhOPETxn9rv4FOIdZAsZCPfKcXzNSpcg0FUgoAbu
	s4MuU0YvaZKJG63hbu/HiQb7bQbUqgs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LMxxdDlj;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771653862; a=rsa-sha256;
	cv=pass;
	b=yK2700IV6YijczgAI0TdAMnfKzrAsYY3mt9j/RMJprb5+Qg1Yv5Hn4wdiVwtcpzlFI9Vri
	YxY0kNPUFdpHJlaU9AnjAh/eMEyaTMa4lzA0igQHJsl4nCRQRRq882/mLRikb5uu5XMiGF
	EED9i9qRLhMB2TyWPzwsrvA9shYcHto=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65808d08423so4071646a12.1
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:04:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771653860; cv=none;
        d=google.com; s=arc-20240605;
        b=QXH6NUTKZpmEzsCi9ZMlhC4eJIM4ZlPaNw8J08k+GtsXPMAmPJFUufCqyd8bN7Dkl9
         fWiHmH4b03MWHRhFXjNhPSv2/0ehspAVX47IFgcCc7iMtfM+ajPEg0P9jlarDSM+EjlB
         MrxY+Jy8v2pv+ONFhdoh2NQW3KXAT+w6IW12BAmx9dNPhTeLCxsENlFs2QXPMldwsh80
         mCjlMBe6ZSNe50IJ/qa8O4hwwBdaJeTCVwgs9FTLsM5VDbVjLoO6q+Xf47ec7uVIO4i7
         knzzqUrIHSk+1CRD8rZA+Lh2PrRIV8vDy5xIxxWU6+1p4qe4mwZlN/grFw2gC4Az0zhS
         y2lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uTauQkrmFvKkr/II8+81Sp8G1oZoJ9jGOwsLPvYTl+U=;
        fh=Nllzl1aC1epaaaZSw1fRz1vcjxLYlJhGQe+wLm3SZcQ=;
        b=RHGeA/WRKUtuPVxLFe14rx2l5U/3nwONaqHm1F1kbyFVQgg2RhEB6ctnI9BuqZ0hjO
         bazD0/8cFCA1y6RkkQWUTeOYseD2zJyC8SF6Fa5jJAcpSSWtTZHPH6RW6PjCCpxUUbc+
         /h2en7HegSLkTQbmAoR8tlQ1ZW1hpnKi4Pb5+mwR5QcPAFP1kAS0H9VSQBKEqDylglXt
         X2Q71oxyrRpqsgqKM6zE0KKeXqx7d+B2Hdz0cAKekjKHHkqv4s9uAyl3bbOSGy78jPYf
         CRtQPh+rqtpDeN6ddd6AAp1y6Ss0EyvJJfmHzuAYyqBuyrc4FCO7InrJjWUQETRZtWwK
         LyhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771653860; x=1772258660; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTauQkrmFvKkr/II8+81Sp8G1oZoJ9jGOwsLPvYTl+U=;
        b=LMxxdDljl3HhcVe+Vftstbt70PlVCSifR2Q2BybiSgplO99KBiUmhV0z9T9r+1k8Fh
         886/emFJpfDIpE/aY8cCCsCpwdZissZG3ylCNNJm/OI9S8PkJ+ghBdXQDPaYuSclRNQ3
         YMKcldkdpnZEEN0K84/ie23CtXcnMpo1/lDrXCYLIiEKCg7E/gEdK99ZGGYximbZeXXB
         klO+MFTeb85xDEJfKEl15Oxp0AWf5Hod7H0Ci2T9ZLGv50T5ezcqiq2xOa3PHXLhmD7G
         h7qwxsg4dj3Xc7LxHNBCiSUB1MM974QTjGxM4vGPG9m4CYmDPvwy4xiL/r3hMrg3ZPjE
         QURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771653860; x=1772258660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uTauQkrmFvKkr/II8+81Sp8G1oZoJ9jGOwsLPvYTl+U=;
        b=v41p9Ft2MS3WA7uBrd2YmkMsOBJG9AWwH1PEB5cfnQSTsNWfbtW9II5EFFJCeIGu1o
         LGdaOOh/hLXp98+AGpHB2sizZvnOm6uGMYDAfIkn27a5XOvhTQKnif0SHnqXOx6GoTL2
         gtNbPflTvSVx/bfzmLH8N5Go+qwmgL4ujhRoVzZ8T+NKovKvxD8556tcFc4VZ5+YcUal
         2XDo1TNLdzk9pV5lYNJR6oYfo1eOjrj+HhBofF9gUcNr8Ds2ZycaluisbAjXGn8SOd7T
         UiZmWRO3lNCMRMMzIPPgt2wQ9MoX2RpMQdivSxQ0pjkJ44u90ALO3N8vXTjH2EqxVifz
         yplQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+6er/OJBug/4nWVdVMmRdQQP4uDYMsWy3pfFvDSHa+gePFxvEhZq+412CoQVoQMYdoEvtyiDnWg==@kvack.org
X-Gm-Message-State: AOJu0YzmSjPtWtGPl83mdMWI4JFO22BroGncAhGcUOCu+I+lSRcm0LGA
	qErQI8yHaiGZRl061PBCtFvIQ8kI5P7Q6tRuGs3UzmjWMCL1iMA1thAWgSTyYRCdf7ayYlM2lL0
	TT7PEou57Lnupskave6zEaP7oDMbkuRw=
X-Gm-Gg: AZuq6aJc+Z85fnyMIL6BBa/2CCCM2SsI/I4DYAZX6AwAH3DlzB73pwS5h1NdO7UgMof
	m9IPAa/dmKD9nFh+vQnpmv3C4n7YHZyEYUA6pk9XDj060GzuCgp1fJ6VvycEW1eLqZmtaQlDz1e
	PUw5FBOBQq++8lu2Il+zFb6OLyCettafjhAbRKi6NKL/8m7SM1VkoUixTauoDnDfZUFXOADLpPH
	C0MAkIvM0I6aIuldP7wCyaYe9XkkTn7YUWqW/zBNwbQhJwlrcDUNNkCvZP6/N6FJhUh/XFkDNqj
	R2yoDnCvvTJs/+yz5J/eeAj6lx0m79fnQU8rouTo
X-Received: by 2002:a17:906:fd89:b0:b8f:8660:3cb4 with SMTP id
 a640c23a62f3a-b90819546a3mr103681266b.8.1771653860014; Fri, 20 Feb 2026
 22:04:20 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <aZim2hT0nNjcRYVG@cmpxchg.org>
In-Reply-To: <aZim2hT0nNjcRYVG@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 21 Feb 2026 14:03:43 +0800
X-Gm-Features: AaiRm53_Z_Uanuz2pbqKEn_PEYzIznLIBK-pucpY6EGel6jJHnN1IU9znKEInpM
Message-ID: <CAMgjq7D8uPq3CpCksdqZYh0kybOiWojsZnfLPTYfP-UCuw=zwA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: lsf-pc@lists.linux-foundation.org, 
	Chen Ridong <chenridong@huaweicloud.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B85040005
X-Stat-Signature: xpofr9yqc93mzua56ouub5mahftijejc
X-HE-Tag: 1771653861-535698
X-HE-Meta: U2FsdGVkX1/abpyjaovUa8aGAXfop+tXS+unEUrcvw7CYJPM/QiRw7JxQOzKEEkf5KIuqouOZveg1YUiUDnFx5kwejd3msE1nVe11yOVe09yqM5I/VyE5l0RjwjtdTvFtc0LJ9JrgHc5c4olL5pm9z/2XKZVVFei5BRSH+OslfHqljiywwlyscswNoeMKCDsPmOQ2DnyG2YOT32p8R8oSNPEWr9qzQ/cKi+ueXKAIDmGAIl43bSFSCQO15pKSMNm8d45T2o0gY2/o0QwnIVvUa0gDMeBBk246V+ZzRjjUx/HXYUWuWtlvwbXxJcgAjLUYnle/yngiLuzMq1KHOK0XmoNVbBKz4Ilp0rC9eDWOCb+QQaTF+dFeM/XJUsiZXoMHZUeV4Phm7Yrfqzrp9xTCHJZ6T9s0I4Yf2gJuOnIVBPuszPOfXmp2GX6wb7Lz2r0zNr6CXbHk0+QiVuqHiej8JkHxcSvgSVXG3zQDWF7/XdLrPFItW1EAfDty5Rr2EkGVL23gGEgO6jEVuOdKScGdUpQsEwdboP1HT4dfPDSlhg8WhDVMUoUmS1vGkpxpC/PqJoJwVcotEAcS8Kh3Xz4uRuObl4rRBXdKwChP801DCEMrOXEFHj/MS3jHA3ogd3sf+tB/2otHXhH4peePJ2brKcU+SOV6EtLnIl6OO02mxX/WgisuUd4++iIxIjYOCeCb8RM932+1F1LMM86sEHGqnSVxZc+/CxQW42Z9C2grdzZd4+oAshbGuOKHLjlEQoO3YS8ZvvwFnhvumPWWGkJnDlHJF7wYOZOzS1ODB4cgz9iqoxXFwUN5u40dIeXUXAaY5yZyqL47hSdKTEXQC3e+ziSUnNuYNKf8kcBKr18iukxlUsqj5NsjMEcMb1rnoziVJD0iNQ3s3c53mkG3w0+yl4KPwc0HW+VaQjEnmZutvX1yoFl2wN1blRv1/WgZUjs2lK+koucidiNjqWRDWL
 AHrsauyU
 dcHDk0JLQlL4pQgJcpE4Iyl+1sqxggghxGmf+EnjE25Ojd8CX23QqGboJV9g0ajKcp1O4l15iJ3HTTcBL0jGazHFT4n2NAxY2YZF9DlX2KE3wVjwqWQA3inN4IeMjoIYY0X7oUWK/yiMLE018XFSDUNLGs5+19pZ6mN0rcvapI9jqVziQp3N9HnBN8tmlodtrxuHS8QFlkkQQEO858QR0/ovNUIY97J8YhrY29DBQ6sMNfS8zVJ8HlbCzrePnEsl8iCxm3ZMqmbXjNRXqSSiOQZoQGBFj/JGs/NFlwfm0AREpwLvx21XkxOgY8OJgmifD/yIUva1bVq+0HG0bFA5lpMx7Vncfc4RWTUgbq5MYy97MvdKWUiLiEXezzNRbCnJn5gRVORfGZkA36oWZEilKhFsZAHp4iUHQZmbSS5wCHCIHrclLg+7qepifCScHeNvy+bQAoszUrLFOQ2CT25B7F/v2kM6HOCgg9xg96TsQlPeMH0Z1Shu199PF5+WiOUvIUKRLXf+y+w/5H4SsOD7x0k9mHZ6ZTdL+YQpOD1VbipJFwed9HL2mg7Ewab/kfmVaP4nrVzQ+pXaSWkTi56LeG0AvV3g6/nyVMGNq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 2:24=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> > Hi All,
> >
> > Apologies I forgot to add the proper tag in the previous email so
> > resending this.
> >
> > MGLRU has been introduced in the mainline for years, but we still have =
two LRUs
> > today. There are many reasons MGLRU is still not the only LRU implement=
ation in
> > the kernel.
> >
> > And I've been looking at a few major issues here:
> >
> > 1. Page flag usage: MGLRU uses many more flags (3+ more) than Active/In=
active
> > LRU.
> > 2. Regressions: MGLRU might cause regression, even though in many workl=
oads it
> > outperforms Active/Inactive by a lot.
> > 3. Metrics: MGLRU makes some metrics work differently, for example: PSI=
,
> > /proc/meminfo.
> > 4. Some reclaim behavior is less controllable.
>
> I would be very interested in discussing this topic as well.

Thanks, glad to hear that!

>
> > 2. Regressions: Currently regression is a more major problem for us.
> >    From our perspective, almost all regressions are caused by an under-=
 or
> >    overprotected file cache. MGLRU's PID protection either gets too agg=
ressive
> >    or too passive or just have a too long latency. To fix that, I'd pro=
pose a
> >    LFU-like design and relax the PID's aggressiveness to make it much m=
ore
> >    proactive and effective for file folios. The idea is always use 3 bi=
ts in
> >    the page flags to count the referenced time (which would also replac=
e
> >    PG_workingset and PG_referenced). Initial tests showed a 30% reducti=
on of
> >    refaults, and many regressions are gone. A flow chart of how the MGL=
RU idea
> >    might work:
>
> Are you referring to refaults on the page cache side, or swapins?
>
> Last time we evaluated MGLRU on Meta workloads, we noticed that it
> tends to do better with zswap, but worse with disk swap. It seemed to
> just prefer reclaiming anon, period.
>
> For the balancing between anon and file to work well in all
> situations, it needs to have a notion of backend speed and factor in
> the respective cost of misses on each side.

A bit more than that. When there is no swap, MGLRU still performs
worse in some workloads like MongoDB. From what I've noticed that's
because the PID protection is a bit too passive, and there is a force
protection in sort_folio which sometimes seems too aggressive.
Active/Inactive LRU will just move a folio to head if it's accessed
twice while in RAM, but MGLRU won't do so, as result hotter file
folios are evicted equally as the colder one until the PID gets
triggered, or still gets protected even if it hasn't been used for a
while. And by the time PID finally gets triggered, the workload might
has changed. This is fixable using the approach I mentioned though,
and it seems to be better than the Active/Inactive in all our known
cases after that, whether that is a good fix worth discussion.

I also notice Ridong has a series to apply a "heat" based reclaim,
which also looks interesting.

> >    Can we just ignore the shadow for anon folios? MGLRU basically activ=
ates
> >    anon folios unconditionally, especially if we combined with the LFU =
like
> >    idea above we might only want to track the 3 bit count, and get rid =
of
> >    the extra bit usage in the shadow. The eviction performance might be=
 even
> >    better, and other components like swap table [3] will have more bits=
 to use
> >    for better performance and more features.
>
> On the face of it, both of these sounds problematic to me. Why are
> anon pages special cased?
>
> The cost of reclaiming a page is:
>
>     reuse frequency * cost of a miss
>
> The *type* of the page is not all that meaningful for workload
> performance. The wait time is qualitatively the same.
>
> If you assume every refaulting anon is hot, it'll fall apart when the
> anon set is huge and has little locality.

Sorry I didn't make it clear. For MGLRU currently it already ignored
the shadow distance for re-activation. And yeah, basically all anons
are activated on fault, which turns out to be quite nice? None MGLRU
users considered that as a problem and in fact the performance looks
good.

Of course we can restore the old behavior to test the folio
against some distance (gen distance or eviction distance), or push it
further to only keep the reference bit (not completely ignore the
shadow, just only keep the reference bits, if the LFU + PID still
works well without the distance), and gain more performance and bits
to use.

BTW I tried to restore the refault distance behavior for both anon and
file folios sometime ago:
https://lwn.net/Articles/945266/

For file folios it indeed looked better, anon folios seems unchanged.
But later tests showed that it doesn't apply to all cases, and I think
something better can be used as suggested in this topic.

