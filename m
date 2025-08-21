Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730D1CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 01:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06DBE6B00E8; Wed, 20 Aug 2025 21:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E736B00EA; Wed, 20 Aug 2025 21:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F876B00EB; Wed, 20 Aug 2025 21:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF2ED6B00E8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:08:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D5E61401FA
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:08:17 +0000 (UTC)
X-FDA: 83798978634.01.975AF4E
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E19E1C0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:08:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uo8nVExz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755738495; a=rsa-sha256;
	cv=none;
	b=jydLTePVpi5MyDdxQIXdBM/wf/blSgzYkjvQV1EqmpZLQxACcMnTH/mbrodK0cPH2h0DKp
	Zs0Jzmn7skzKFl8TRO5QJIofWGZfKU5Y3DDFSKKpsIho4UxmnKIWNmPoC6naNYm2zxATEG
	6LtrOxBTzDIbN6wDFf9X4PnZ0SLtr+c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uo8nVExz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755738495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GokggVHwsWgtzvgyN/qEZFMv+f52a+8zLwqs+NYYW14=;
	b=xpULIgM6X5dnOvPCi5INny6rYXnnBDSqdmddYcvuFyGtVZcvbrK0YjH6ipzx7PdZuGxl2z
	RWjSSDt+0+Yj/Sz+CeimzPtnZ9gDVfxEIoNw40+/IpLpET7rI0hW8FTq7o2QPZGfTi+ySw
	bre4DurVCLcodmvlV7P9is3EYDsKqcU=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-61c13125417so67889eaf.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755738494; x=1756343294; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GokggVHwsWgtzvgyN/qEZFMv+f52a+8zLwqs+NYYW14=;
        b=Uo8nVExzEIRXcUo1inmZ1/VPXhTMPhcGJHUBb3mOXKtFEFpq09IBE30I4iXGm6CBxE
         h+eJLUSVuSQpPSAPKbsmzn3o46ZWYCQ3nThwNYG0TPkbAuIrZWDwBqUxgB3X8PFk/HCp
         gAzc45HBopjtt4Dm4q2PMNA6R3f5aNZTifVlb4v7hL4snI9BVRLC86Zr5kE24AP16orJ
         sIY9lSMMavonkyXzJ3MoFvq/OHQULhH1+VM7hT8EQeiQ2oUrUJPGD4GMzUqMH1pbEj39
         RBTsEWXiA8hpXYijINrR+ZUlnE2yS/D07nAt8iwN8m3nByjYeFVRnkRA3uIqzWMMxWaz
         7uPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755738494; x=1756343294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GokggVHwsWgtzvgyN/qEZFMv+f52a+8zLwqs+NYYW14=;
        b=NKiOYm7m7ffmlSeQG9U1T42kDv/H5jpsL9D1gF8K4pCWc2lisX9zPKqZOY06TK2+I/
         F4ox8wwubUPn/XPGfjdipjdlRRS1N73PWQNIStrKn30ZjrtSY3IriGBSTFvGF5eRY2R5
         Rg4x01lE79/9BoMnJM9xRDX2xZZJxLAzGCcnknxbpOGPcH9Gv9JBx3lXyjK6W7Ndb724
         drZPa2qd5vXYwCChgfFoCpkSfwqarxC1IuG+1xKx5ynnBlycHPrKYpincPUbZ5/MGTZm
         hAyoisZuSYfBOGuulGp3evUGObdWocBgk2+rYD7M8SigNPum/wyp5OGlLnDBlpZz6MQw
         caZA==
X-Forwarded-Encrypted: i=1; AJvYcCXjY37FiB/gCjzOmLVScVN4rUxxjKilcAxcH99Sie+ICXMTlCHOjMoIe0yAYyU2VawP2zweL1x5hw==@kvack.org
X-Gm-Message-State: AOJu0YzXpiyETQ042xUKXohINkJIvyrEMrk4XL5O76x/BOgOAYG5hCk8
	HTcpYqmjJjEI4gOxyS8QI/rIOnT5bjk92U3kqIrs/gQu7E7nlVAkISEM/cSKDjosf3C0ujTbYWy
	Js2NBTBcyb4YOBN7Gab+w/8f+coZVjeM=
X-Gm-Gg: ASbGncsU6wDTbtrMHbYi72PRDzeYf4k4UO9L6wA2DyAv1V8gmgzVm8kM6aadMqDO943
	gLrwVmC8fRm3hwyK5SQoXSPI3ebinIOiPgtdIMs3i1t+6jPubxyQKJdNuzmJk39gml4e65/Dm1j
	i4xSjtiV5N1XTu0Gy/F6msMcUoXYUGcxwtqEcnxNSfbdX2uJg1u5uAom9uTLVcnvnABxXrYWvfy
	U6Wp+6ApdVqGSE=
X-Google-Smtp-Source: AGHT+IGMEq9pUyB7v0+w/oAnTu045iauyj+xCtdjs1ZA7QXJ8rtw+r/qDQiXoul2PqnBQyc4BEn2rmtyCs5i345g5Ao=
X-Received: by 2002:a05:6820:80a:b0:61d:a32d:610f with SMTP id
 006d021491bc7-61dab37e23dmr228323eaf.3.1755738494510; Wed, 20 Aug 2025
 18:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <CABFDxMHpodpNQM_a=T0vf48k486mYqukCVnQPbanLh+G_HH+9g@mail.gmail.com>
 <20250820182736.84941-1-sj@kernel.org>
In-Reply-To: <20250820182736.84941-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 21 Aug 2025 10:08:03 +0900
X-Gm-Features: Ac12FXwY0QvAKJXu1Lstb6SiLaFsDLAKOkZbXUCeMOgo9sq_Zc-hrouZIUfRh_0
Message-ID: <CABFDxMGmVgswVoZFgBz=7xqA59M7fMt0jw2QHqWjm-W9tZktWg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at
 first charge window
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E19E1C0003
X-Stat-Signature: sixnbru6g535xxy1bq99nbdcq17as78n
X-HE-Tag: 1755738495-4163
X-HE-Meta: U2FsdGVkX1/VRLuQdn92+WGRQG7Xk0kpEoRx/1+J+mmFWoRNrlNs86HK2t38WuuYlMx3ADbDvg5+AJDnqca/HBda1DVafGDO1/ErQzEVDsLYlCrRtPxhg2kavlc5KY9WMWJBVwLjcO1QbUGF7lkVu17KhZG9Ud3JL3RMs9CinBgEe9zU72VGV4l1VLfiTGu03hQMbLS2cAFlyXwrNDW3uPG4gb6s9Pk99W2nixLsP7rpT5yHXtEur2mSPhHv1RqDCsiNi5pmMEq+YcdAbBm/OfIielWcP0XTVtWiI4yzV2pZOro6lrbpTd7UjWBZKgyqYBj2TLijI8w2OmNi2A4FU3y/P7DJgOcSTEa8HnfcScZhoxDios1yDPyILS7Izd0aGGNWJ8neNqc703unZg/Drr2vUAk36jIuBQ/a9MCh91SD5twb9vw7653rU8lF0TKvME2f6tMUTFy/LeIn2nzMdKoAZgwaxVWSJ3ngZuMbqiJAWMOJ7cq3b6mclDG2awJPhCtWYmweMCWS7YUfu3k7JLwBIg/rj3DW84/LfAsTWO+rCCh5x/aHu3cF73Pg1YjvEyUVLnSNg1+oHazky8IUqwIugXayhbr9pFdvXg+0+DcxGvUM2qKeWyRiCcublG5OOpPr7H/Of4ZeefrJ3vdALwNIIjR7NhFdfQBika7T5yOx4rBNTOGh8wMOWUZwbMPwtqRDAPEJswiXOFMW41OlzmEOXfv2aBu5DzDRUvrT9nfN3MhLXTFHRNNCM+etywjlj/QM98WiclCwm+tVj+rqdwxy3QBuY1HWGvSg25gQCCB6rvF+lhi8pxn86gl+4R01sPaZ7Z5lw9K72q/6IB8pXvMmZ/vfAUBBLNc9fuODPgWOmIIgG2k/ulmvwkguRnsbg9+5tc8gI1pvr/ekEJUyfatoNPYLMX2moVySUUFh1lqhW2CuXb4A1vot0IZ6W6CUmBsv+zO/W/tx/QbQcb5
 vsdJfc5M
 y4iw306LH+/Ma28Z7cN1KXHWCDigCzfNNaT255Xjf3rf6rPXPTPsN3ZKQXIeKzgINzw5cow43D3fdcfG9jUIGyjJELeq13CmqakVF0PlbdEioVS3dcPrBc9h71HXnwSP8F8kW3jnPoaB1etednoQ/gQCni4IS6KUhk06kPKB83o8ItUf0ka3XyenQ9VZSLeUfCSghfCPd6d70fQpT2u4FH35gHlWoR23WJQu+ukTO2GpAD2kHyKkx1AUQ/ODr+Y54C81xwholkZNnFyehFN2Qod0YCpsPKANQTf+ed/Kbf4FdGg/ikK1szNHrjs71+rfVqg/pZSLEvjehQJsY8bgcv0TkWwTPWqv0iZGbMGYk+NJcEhlPa+Bgwt5ZzIus8YlODxFNAzlz+4zG4XzalojUvWsKD4K0tkGFuyAnEboRMAyPaYBq0lcf42qEolf/imCJNWj3cY8syn1tLQY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 3:27=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Wed, 20 Aug 2025 22:18:53 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Hello, SeongJae
> >
> > On Wed, Aug 20, 2025 at 2:27=E2=80=AFAM SeongJae Park <sj@kernel.org> w=
rote:
> > >
> > > On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@gmail.=
com> wrote:
> > >
> > > > Kernel initialize "jiffies" timer as 5 minutes below zero, as shown=
 in
> > > > include/linux/jiffies.h
> > > >
> > > > /*
> > > >  * Have the 32 bit jiffies value wrap 5 minutes after boot
> > > >  * so jiffies wrap bugs show up earlier.
> > > >  */
> > > >  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> > > >
> > > > And they cast unsigned value to signed to cover wraparound
> > >
> > > "they" sounds bit vague.  I think "jiffies comparison helper function=
s" would
> > > be better.
> >
> > I agree, I will change it.
> >
> > > >
> > > >  #define time_after_eq(a,b) \
> > > >   (typecheck(unsigned long, a) && \
> > > >   typecheck(unsigned long, b) && \
> > > >   ((long)((a) - (b)) >=3D 0))
> > > >
> > > > In 64bit system, these might not be a problem because wrapround occ=
urs
> > > > 300 million years after the boot, assuming HZ value is 1000.
> > > >
> > > > With same assuming, In 32bit system, wraparound occurs 5 minutues a=
fter
> > > > the initial boot and every 49 days after the first wraparound. And =
about
> > > > 25 days after first wraparound, it continues quota charging window =
up to
> > > > next 25 days.
> > >
> > > It would be nice if you can further explain what real user impacts th=
at could
> > > make.  To my understanding the impact is that, when the unexpected ex=
tension of
> > > the charging window is happened, the scheme will work until the quota=
 is full,
> > > but then stops working until the unexpectedly extended window is over=
.
> > >
> > > The after-boot issue is really bad since there is no way to work arou=
nd other
> > > than reboot the machine.
> >
> > I agree with your point that user impact should be added to commit
> > messages. Before modifying the commit message, I want to check that my
> > understanding of "user impact" is correct.
>
> I think you should make clear at least you believe you understand the
> consequences of your patches including user impacts before sending your p=
atches
> without RFC tag.  I'd suggest you to take more time on making such
> preparational confidences and/or discussions _before_ sending non-RFC pat=
ches.
> You're nver lagging.  Take your time.

I think that I checked about user impact already but it should be
insufficient. As you said, I should discuss it first. Anyway, the
whole thing is my mistake. I'm really so sorry.

So, Would it be better to send an RFC patch even now, instead of
asking on this email thread? (I'll make next v3 patch with RFC tag,
it's not question of v3 direction and just about remained question on
this email thread)

> >
> > In the logic before this patch is applied, I think
> > time_after_eq(jiffies, ...) should only evaluate to false when the MSB
> > of jiffies is 1 and charged_from is 0. because if charging has
> > occurred, it changes charge_from to jiffies at that time.
>
> It is not the only case that time_after_eq() can be evaluated to false.  =
Maybe
> you're saying only about the just-after-boot running case?  If so, please
> clarify.  You and I know the context, but others may not.  I hope the com=
mit
> message be nicer for them.

I think it is not just-after-boot running case also whole and only
case, because charging changes charged_from to jiffies. if it is not
the only case, could you please describe the specific case?

> > Therefore,
> > esz should also be zero because it is initialized with charged_from.
> > So I think the real user impact is that "quota is not applied", rather
> > than "stops working". If my understanding is wrong, please let me know
> > what point is wrong.
>
> Thank you for clarifying your view.  The code is behaving in the way you
> described above.  It is because damon_set_effective_quota(), which sets t=
he
> esz, is called only when the time_after_eq() call returns true.
>
> However, this is a bug rather than an intended behavior.  The current beh=
avior
> is making the first charging window just be wasted without doing nothing.
>
> Probably the bug was introduced by the commit that introduced esz.

Thanks for your explanation. I'll try to cover this point in the next
patch as well.

> >
> > > >
> > > > Example 1: initial boot
> > > > jiffies=3D0xFFFB6C20, charged_from+interval=3D0x000003E8
> > > > time_after_eq(jiffies, charged_from+interval)=3D(long)0xFFFB6838; I=
n
> > > > signed values, it is considered negative so it is false.
> > >
> > > The above part is using hex numbers and look like psuedo-code.  This =
is
> > > unnecessarily difficult to read.  To me, this feels like your persona=
l note
> > > rather than a nice commit message that written for others.  I think y=
ou could
> > > write this in a much better way.
> > >
> > > >
> > > > Example 2: after about 25 days first wraparound
> > > > jiffies=3D0x800004E8, charged_from+interval=3D0x000003E8
> > > > time_after_eq(jiffies, charged_from+interval)=3D(long)0x80000100; I=
n
> > > > signed values, it is considered negative so it is false
> > >
> > > Ditto.
> >
> > Okay, I think I can fix these sections with explanation using MSB.
>
> Also please make it easier to read for more human people.

I see.

> >
> > > >
> > > > So, change quota->charged_from to jiffies at damos_adjust_quota() w=
hen
> > > > it is consider first charge window.
> > > >
> > > > In theory; but almost impossible; quota->total_charged_sz and
> > > > qutoa->charged_from should be both zero even if it is not in first
> > >
> > > s/should/could/ ?
> >
> > Sorry for my poor english.
> >
> > > Also, explaining when that "could" happen will be nice.
> >
> > I want to confirm this situation as well. I think the situation below
> > is the only case.
>
> Again, if there is anything unclear, let's do discussions before sending
> non-RFC patches.
>
> >
> > 1. jiffies overflows to exactly 0
> > 2. And quota is configured but never actually applied, so total_charged=
_sz is 0
>
> Or, total_charged_sz is also overflows and bcome 0.

Thanks for clarifying me.

> > 3. And charging occurs at that exact moment.
>
> It's not necessarily when charging occurs but when damon_adjust_quota() i=
s
> called.  More technically speaking once per the scheme's apply interval.

Ditto.

> >
> > Is that right? If right, I think this situation is almost impossible
> > and uncommon. I feel like It's unnecessary to describe it. I'm not
> > trying to ignore your valuable opinion, but do you still think it's
> > better to add a description?
>
> I'm ok to completely drop the explanation.  But if you are gonna mention =
it
> partially, please clarify.

I see, your opinion is reasonable. I'll keep that in my mind.

> >
> > > > charge window. But It will only delay one reset_interval, So it is =
not
> > > > big problem.
> > > >
> > > > Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for sc=
hemes application speed control") # 5.16
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > >
> > > I think the commit message could be much be improved, but the code ch=
ange seems
> > > right.
> >
> > Once again, Sorry for my poor english. I'm doing my best on my own.
>
> This is not about English skill but the commit "message".  Your English s=
kill
> is good and probably betetr than mine.  But I ad a difficult time at revi=
ewing
> your patch, and feeling it could been easier if the message was nicer.
>
> So what I'm saying is that I tink this patch's commit message can be more=
 nice
> to readers.

You're right. I'll try to make the commit message more clear. I'm
really sorry for bothering you.

>
> Thanks,
> SJ
>
> [...]

Best Regards
Sang-Heon Jeon

