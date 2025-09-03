Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D88CA1011
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9EE8E0001; Wed,  3 Sep 2025 12:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091CE8E0006; Wed,  3 Sep 2025 12:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF00F8E0001; Wed,  3 Sep 2025 12:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE5608E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:41:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 984C5BA64F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:41:33 +0000 (UTC)
X-FDA: 83848504866.07.8D7DBF4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id BE53680008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:41:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wze+4d1E;
	spf=pass (imf30.hostedemail.com: domain of fvdl@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756917691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/vJxcPRpGvESlgzYXyBU2wvc3GwYzu+Leq41l/JUsw=;
	b=6FiwDz6KVfEq3G1WTiOSas7CWHicIK7ZrMFZE1BbScuvXrP1E/BjmdPPTTw/Xa3vUFe5qQ
	Jd9EmCTuInMwdC4yYIXgTC13IOrWWmQ2p9YsVsYZZUf90jVrE7ZfXDfY/FKFnYxbAOzTT7
	m5axQMrQhN9XsSpED/4T1kolxPyGiJg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wze+4d1E;
	spf=pass (imf30.hostedemail.com: domain of fvdl@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756917691; a=rsa-sha256;
	cv=none;
	b=LACv01a80dBYBoarmfG1UArlI8rqyxqwssk1CkksKAyIUeYsfNxxDCoIH6ZsVfwk7zWBxm
	R9bat8pqR+BgKV2uG9qHkZjstDEy17fzqyQsu30xmzu3nzeNMG9hcJRcBGw2ZBn46CAwTz
	RjfC4byl/mdGUSpLUITaieuTs7JfHtc=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b327480fd0so2151cf.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 09:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756917691; x=1757522491; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/vJxcPRpGvESlgzYXyBU2wvc3GwYzu+Leq41l/JUsw=;
        b=Wze+4d1E0XcQoi1T9TNW5vxdMyR5USAN8oB7w07zqQFxd7syI6Byseo/wXi8HC2JlC
         j+gakHVNfhsmoIh0fmn6ltKFS8k/b0b72lmhvGDzRIONeY/r+Lv+u+bqkcCeucuhMOkM
         3GQvN1s8cp6jEXvfdYIG1fpYsPaCtiqojo60Kynytn2Sn0ui7CicAZ3SrQ/VbEQRlkMS
         u0O2526U9zuU/0xm63FPyToYY3Z3PU8s7dTtcQ069kBh2x0vtqsTpluFdGuyb+9Hhhgi
         l4GqaXEn7eHlvBahrK1BdfCOJefZqJLhzImvUd2WvI8OzHlTo0YtKSz4rVTwCm0l+a7m
         Sqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756917691; x=1757522491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b/vJxcPRpGvESlgzYXyBU2wvc3GwYzu+Leq41l/JUsw=;
        b=DIMylBhN9fCcDTBccdAtKYbM2UNKYiLXeeSbeLWDwdUaKfqKjKGN4PW28/upciZKw+
         ebN3yESBP8+yCg9XnTEni3JtPXBwKAp+bvC/F4z9dUAIAE7ZXQTB0HilfJ3XvJI3Z49p
         jTXm4r7EHjT3aP/pf4oabPUnsNTJeEuJUT28vYDdjqtk1DjlUZ5tFe+7mUEImK7mfxBc
         13WOEhTtjiLLJtCN4U61YHNL5ERlcMbenGAg/Yu/L5yoY5CnQ7UvN+ONNLvnYab7Kp5a
         hNh3v+SnShZapKOiT0Zs530moqQGhiVvvtIKOgqvLHVKUZvmYcAr2LFK8kLnAeNlKDJV
         0KYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVf1WvK6MaEH6mIbzi9p59XG9yCnRFJqOYpJchmLwyRM2eE90T9PzRZRoHaDNEnyA2MWYj43CM8tw==@kvack.org
X-Gm-Message-State: AOJu0Yw1V0Hn9kt7zgDnFwAzkm0HHfJtV6PMbzZEwhuyVEBataQTHEcI
	puyiskPZW5190ksI9xblCKt3N5MmCNLzKgmTqpVJKjegAq5S8me3EflKu/mrg1k2pDQhZY5Sv8p
	yLMJbznHZZxRbW9QgntfQiAAqANQfxQup/q1a6tvh
X-Gm-Gg: ASbGncsk6BYkQgWxpXLhIQ2jJRH99sp/FmgSxmENmHpG85ZZIH3zmf4YX6iigHJT2tQ
	hXz5fKEaQJ8wa2na0Jq98jJQKhBYXlcroLsf9uqvrrDrokDWr1V5kpLJrYRmzkA+MJz7LF2xuJe
	ny6FOhBEKQZWtnaVQIaR7D6vvMMt1KpPJodOtrNljYD9HV74VzagLvZwbr4uOkCD+pKk/gvnw+z
	ZR8yVrOptMQC7n053xP+A==
X-Google-Smtp-Source: AGHT+IFoHehzzAC3at7wJqvFXiruuFBM2qqp0XopgJmPwvY+aBFXS+0msH1KaCucKaOoLggA7VwXzewO9Mt5vZOrJ2o=
X-Received: by 2002:a05:622a:1a94:b0:4b3:7533:c1dd with SMTP id
 d75a77b69052e-4b37777a325mr9305051cf.1.1756917690086; Wed, 03 Sep 2025
 09:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-4-thierry.reding@gmail.com> <CAPTztWa7kcx8bBEJEKvnjcD4v1-eDLVxMd9C10XiBQi4CDLfHg@mail.gmail.com>
 <v7zrmrhvemyymq6qamz6wbgzr4cijfe4n76ivwyadmltadlot7@3csy442wfasf>
In-Reply-To: <v7zrmrhvemyymq6qamz6wbgzr4cijfe4n76ivwyadmltadlot7@3csy442wfasf>
From: Frank van der Linden <fvdl@google.com>
Date: Wed, 3 Sep 2025 09:41:18 -0700
X-Gm-Features: Ac12FXwYZoUQJMYKoMG2IfRlVgeA9SBEMubP3Ywv8OOtSs4p9NBUTv7ipqCvUr4
Message-ID: <CAPTztWZJqzbR7Y6jE6NM1qQOumYz-ckzSfGDfUcsgMVU7SBb0Q@mail.gmail.com>
Subject: Re: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BE53680008
X-Rspam-User: 
X-Stat-Signature: 6gs11mpan5hh9919j9597eem3w6wi3kz
X-Rspamd-Server: rspam09
X-HE-Tag: 1756917691-799425
X-HE-Meta: U2FsdGVkX1+7oSzC/myGbpuxuRwdNVbbujIR7mujXHwyVYuGXNcw9xtpo2baHJGE3DN5j+MIqJv/6t/9mFiLCJkZCpPmCmNYzWxkJZIw6FAqoANlcf9Nc2vzXqWCA1XNXfKpM55/U7IUeZZ5KbYnBRnZVWL26SruYnwFeeKHdczH7YAy5vqct6tO3x5j7IdmOx96Hj1HtxTPQFCJIB5auAc94hEC+MCoVg9YyF86dkUQdjUqGnQ1rrAO0OLTIxE0aaz7dvF3XF9+PJDjMH11ZOpiUEOlPWQ/78f2FqsXw2VsugGNKrvtkO78hrqWlOoKompKsL1I/cseyZrZWpDxU2FuCwQ654wJfj5AeNCwsr11QErUCkymKSsBuo23h/qE2Sr9Ouo7Wd/N7SbeIF0PJMZzAx4RvKoga4/Hu5rB1TRc/95lfFcZ75aZyVDif5Pv00Au+dkcyzmZV2rNmq2g3nlfXOwNaepORGGdvQ1lghDXJVbl5MgK3lmjwxtqdymkGBi4xZd8zzmwPn1CshDYxoUzY1l9rrwSvmGezbnE/QYBD7hnnDdgoJepCURR6uURSEbPbxHWyIKhN9zgu8bbYKB/hyLgrxdD9btLuc2H0tL3S+qYDIM5l9AjjJ4pSorUXmB92XW6XIlNB+K8Kz3sRtFuY2m7l50SIt6UFLUx/UDmBAufpCRv/AMU0trAvUHJ/0BvigywVohShkjf5Aue/s2rW3yXwb9B7NSp2lIARV+3m1dpcv0lYmgHx3My8QTsaUlytngBenb0wlFXzuO1Jtj18kVBxSK+nr1reXxLJh77HyQrbZtK9mCJQW73zY/9SkAJQsgYQFlqotxqEeoD7vZZFUOTGwto6mOHUI0autYGKMNPfB6ftUSYVDAudEq2Hcvw1rKf5y1Kj6Ey1lGga8ranaVr+44oeMCvmmopDseNpft8OqALpamP6Ebdww0XhWMl0Qb1rPIMgCC1Y+B
 lFUjJfo3
 ZJXTtREmte8eZskghtz86g6+drXTwdV99mZfl1Ki0k2SynE4Vji7XLVrc+xIU4Yx26TLsqvbQiPx4O6RgJru7W+uUyfISrUlTSXFortxa584+iyyRs25mxOEgLF6jVYvFAXCGycNJ2zJy8hStN4WIbxB2SLLB8WCtGGWZhenaQrBbOSlnH6x7gaKJCb5KDhe8MxjGIqjD+2MhE7eVeWe1JgdW4dbxKO/tx1gLu46z+oxGoC7MI7MLznqH0ExQx+inKAUZLx/Uj12PNJbbk+pixS6zI0Z33ucl6gBEJTk5WIiB9Yhr2eaV7CW4UVYeTmqWBkrx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 9:05=E2=80=AFAM Thierry Reding <thierry.reding@gmail=
.com> wrote:
>
> On Tue, Sep 02, 2025 at 10:27:01AM -0700, Frank van der Linden wrote:
> > On Tue, Sep 2, 2025 at 8:46=E2=80=AFAM Thierry Reding <thierry.reding@g=
mail.com> wrote:
> > >
> > > From: Thierry Reding <treding@nvidia.com>
> > >
> > > There is no technical reason why there should be a limited number of =
CMA
> > > regions, so extract some code into helpers and use them to create ext=
ra
> > > functions (cma_create() and cma_free()) that allow creating and freei=
ng,
> > > respectively, CMA regions dynamically at runtime.
> > >
> > > Note that these dynamically created CMA areas are treated specially a=
nd
> > > do not contribute to the number of total CMA pages so that this count
> > > still only applies to the fixed number of CMA areas.
> > >
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > >  include/linux/cma.h | 16 ++++++++
> > >  mm/cma.c            | 89 ++++++++++++++++++++++++++++++++++---------=
--
> > >  2 files changed, 83 insertions(+), 22 deletions(-)
> [...]
> > I agree that supporting dynamic CMA areas would be good. However, by
> > doing it like this, these CMA areas are invisible to the rest of the
> > system. E.g. cma_for_each_area() does not know about them. It seems a
> > bit inconsistent that there will now be some areas that are globally
> > known, and some that are not.
>
> That was kind of the point of this experiment. When I started on this I
> ran into the case where I was running out of predefined CMA areas and as
> I went looking for ways on how to fix this, I realized that there's not
> much reason to keep a global list of these areas. And even less reason
> to limit the number of CMA areas to this predefined list. Very little
> code outside of the core CMA code even uses this.
>
> There's one instance of cma_for_each_area() that I don't grok. There's
> another early MMU fixup for CMA areas in 32-bit ARM that. Other than
> that there's a few places where the total CMA page count is shown for
> informational purposes and I don't know how useful that really is
> because totalcma_pages doesn't really track how many pages are used for
> CMA, but pages that could potentially be used for CMA.
>
> And that's about it.
>
> It seems like there are cases where we might really need to globally
> know about some of these areas, specifically ones that are allocated
> very early during boot and then used for very specific purposes.
>
> However, it seems to me like CMA is more universally useful than just
> for these cases and I don't see the usefulness of tracking these more
> generic uses.
>
> > I am being somewhat selfish here, as I have some WIP code that needs
> > the global list :-) But I think the inconsistency is a more general
> > point than just what I want (and the s390 code does use
> > cma_for_each_area()). Maybe you could keep maintaining a global
> > structure containing all areas?
>
> If it's really useful to be able to access all CMA areas, then we could
> easily just add them all to a global linked list upon activation (we may
> still want/need to keep the predefined list around for all those early
> allocation cases). That way we'd get the best of both worlds.
>
> > What do you think are the chances of running out of the global count
> > of areas?
>
> Well, I did run out of CMA areas during the early VPR testing because I
> was initially testing with 16 areas and a different allocation scheme
> that turned out to cause too many resizes in common cases.
>
> However, given that the default is 8 on normal systems (20 on NUMA) and
> is configurable, it means that even with restricting this to 4 for VPR
> doesn't always guarantee that all 4 are available. Again, yes, we could
> keep bumping that number, but why not turn this into something a bit
> more robust where nobody has to know or care about how many there are?
>
> > Also, you say that "these are treated specially and do not contribute
> > to the number of total CMA pages". But, if I'm reading this right, you
> > do call cma_activate_area(), which will do
> > init_cma_reserved_pageblock() for each pageblock in it. Which adjusts
> > the CMA counters for the zone they are in. But your change does not
> > adjust totalcma_pages for dynamically created areas. That seems
> > inconsistent, too.
>
> I was referring to just totalcma_pages that isn't impacted by these
> dynamically allocated regions. This is, again, because I don't see why
> that information would be useful. It's a fairly easy change to update
> that value, so if people prefer that, I can add that.
>
> I don't see an immediate connection between totalcma_pages and
> init_cma_reserved_pageblock(). I thought the latter was primarily useful
> for making sure that the CMA pages can be migrated, which is still
> critical for this use-case.

My comment was about statistics, they would be inconsistent after your
change. E.g. currently, totalcma_pages is equal to the sum of CMA
pages in each zone. But that would no longer be true, and applications
/ administrators looking at those statistics might see the
inconsistency (between meminfo and vmstat) and wonder what's going on.
It seems best to keep those numbers in sync.

In general, I think it's fine to support dynamic allocation, and I
agree with your arguments that it doesn't seem right to set the number
of CMA areas via a config option. I would just like there to be a
canonical way to find all CMA areas.

- Frank

