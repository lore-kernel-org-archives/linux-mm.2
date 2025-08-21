Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBBCCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79368E003B; Thu, 21 Aug 2025 07:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02298E002A; Thu, 21 Aug 2025 07:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA1F8E003B; Thu, 21 Aug 2025 07:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A47B38E002A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:07:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60E5B13843F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:07:12 +0000 (UTC)
X-FDA: 83800487904.24.6506AE9
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 81C4818000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:07:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YaAs2I7c;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hiIZ6lQmGLvY+69EJfMpz5tBA2tanpZN8rHbO7rGKac=;
	b=E28punajbKM5Hjs/6t1X6ZHW8brfB4OBNKFivwW/6jZpDhx/d03wl/O+r3kuzJtpG9oiTK
	DJA+14Qq+wrSZfhoV3IsPwtQc2Lx9AIyvEs3XAEODL9p6dnZQ5XvSnQscaH6FbnBZVqF1X
	sChp3X5KwvWtQnZHUgPmqOBy/ZcvJdQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YaAs2I7c;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774430; a=rsa-sha256;
	cv=none;
	b=FWQm47bcdnjM/9UWAixY1n7bGN4FJnwtHOVtYc9jhRzePbU/FkXVdfNxACsENbIwopM2+j
	N5FJyRyF6Dp3oZnP3OaC21WAbiyNb6FkENnSTrvo39YJsFBZNZQGJrFqVLJAqkqP7f+WhH
	134lr2IlK6BjLa8U/N34YnJxNa96ftY=
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-61da3cf98efso186871eaf.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755774429; x=1756379229; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hiIZ6lQmGLvY+69EJfMpz5tBA2tanpZN8rHbO7rGKac=;
        b=YaAs2I7ccXoIV3YWTULRkldpKzyVbUKOZyiBWMkf2SSpIodO8Sl5TfqL6QTj4UYeuW
         TuO7SZf64XDdtV5GHepMa5peoIhMVl6oG1p9zQX0SGZV9IL8Wl5pmKYZMmLTpdC6FlKC
         qGbuHc8VBkNl+qGKBIrZjqnMsr6hFnO1VzOgOYRQR0Jp7r7UEn+xNoKsmbYmT/G95/6R
         XMGFSGWXgcNApOFFnG3jbbwRGPr5XYh2GRNc4qSJ+z6YrZqcl8wlEeobC6lIEOel4wd9
         skaaFgysAcJotUr9dhfhaap1s4SEFyu43YVjVhk5NZUvPeOzID1wOel26RIKdEKpkITv
         ZvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755774429; x=1756379229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hiIZ6lQmGLvY+69EJfMpz5tBA2tanpZN8rHbO7rGKac=;
        b=le+cYsd7rjTrQbxsTpJQu51pXLg4f3e3mTUI/hpMOg4e/tmLjsen8Upoo3PS/G3+OE
         DNNcFex347EVWCjbxuzQhBxNFlEVP+Wwp22wxFe9jKu589bXpfGsCz3nWmso/N+3OcBD
         jFbQQE8Boo4ERXAkClnhbx51PZ0M3sL/RczF5K0Fc5kTkq0FFDJXYvLC3Tp9w8Qla4E3
         cOTTXKlYV4N9M6qyJss9j1y5lNCCP/wW0p1OBoMdKe+Y2PrH5BfPh8ldjmMtn3Cwbb9U
         XWioutklo4jBzSnStS98T+0hIJGTUX9wGBeAbRydB4nIO36JLQ9CG7947m34zso5N6gh
         cFCg==
X-Forwarded-Encrypted: i=1; AJvYcCX7HH/9cXGc9flIdBFuWZfdfDufSs0C+yS2mY+f3/N8a4Eu0mfLyrQzB12ADRvLIJzLG9EDCbN/Cw==@kvack.org
X-Gm-Message-State: AOJu0YxXFuzYe19BdGDcklZoKJS7K8aaUDIuPSCHp3W5NulHZnQCw2F6
	cDfkbGWVqMHuDsjZV/1smA8zva3zJwSOpfziXooUTa2jmSvn+2Op2LLALFeV37LgciTVZ0PrsFQ
	2lpzGI5uiA83EsiwMB4X1JnYgCfA2e/Q=
X-Gm-Gg: ASbGnctREVjO5+efeU6F+Q3P0Rpo4BPo47lutt0E0k94ncL9BPJcRMyRSEVly0yJN6j
	me1rVEiwMeplb7HmTVuFuSZG//zkUZoYWs/LhFbf0Q8nXhnjofi3GeHACcmp9MojDIKYXnFPVWH
	9rWhWe4GwG7xqfAWR0LIt8hxehkfQGtm6mKo1585tX+gedBvrL5BnB+2LrCTQMWfjrXXxpkS0B1
	3eQOr+LdMOprSs=
X-Google-Smtp-Source: AGHT+IHDLck68A4uwh4SnafV/XdhO0tvddlIcwAPIaIuldKdKV8FYfx8DQctiAAl9nm4vwx0UEGSyaMl0wGd0sRiAZE=
X-Received: by 2002:a05:6820:60f:b0:61d:95ee:b387 with SMTP id
 006d021491bc7-61dab39122amr828362eaf.8.1755774429258; Thu, 21 Aug 2025
 04:07:09 -0700 (PDT)
MIME-Version: 1.0
References: <CABFDxME5ZEAn+6=0GRWybTi-xBzbhhz7U38pMni3SdKjA+Aj-A@mail.gmail.com>
 <20250821054148.53746-1-sj@kernel.org>
In-Reply-To: <20250821054148.53746-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 21 Aug 2025 20:06:58 +0900
X-Gm-Features: Ac12FXwihon6gThYHt62W99b3GivzmKJ4uU22wv-CFXcXYs_nLemAr_4GPQ0U3U
Message-ID: <CABFDxMHgOPt5zx3q=KRxGGfp86R4V0AgO+FrHDftqLYoG20BWw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at
 first charge window
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wukaytkwu5du4ist4atry3hzh1sj9dzc
X-Rspam-User: 
X-Rspamd-Queue-Id: 81C4818000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1755774430-334462
X-HE-Meta: U2FsdGVkX18RYa8LcTzS0g8DwsCL2Z0e1jVi1H/u5MUYrwaYOmYu0gtWJdNGiKA0/z5S9kA8A41R9lM9T55VC7zKyd/4UsvZ8mdjDnE71GZtTW8vEsplfMFyl/vvPn97IPITQli7K0gadL3fCInKjKHA1g6AJ+gqEpuERTkRrlYWIovQHEE9cpwKfuWyOmXbRF6SwTJihdJk2226LzOdKl0zmsQfyThS7azhJeY9Ivto3nX1lE43o8jgt1VPGwZDLRvFzT9dW8X0z3CwTegc62foMkfMXjpksdDndyB22Dqfo0CufpPBhX2HXr4nKr1wDSayUjKC+VF7EWb4Zctq04Gx7k8moWcb8RRmRWgUNBQv7MRhH4Cn4kTQpw2qLJ8AxhktkEmAC3GR9o5hkLyVOb6u+Ir0N27Oktyoxf+eWG4KaFk0xInrN/EN9tJxwgYVfe3tSin6dliSQ6LagMfgn8U+U+jUBsLwp4MB39Ds/j7NdZsUKdrCrDn7+8AV1MpmdhmtkShj5BcX2z9830HoZ0BV4TVAQiukRjYMi5i4nqUBR/d35E2fJhK5GRJsm1Zi44b12xalv+nvF4CQ5ee+Z1YCUlhRvtBmW12lAdVf9vFnp2g4ULcEuKUjL6VBRBm2CfmwZNQnbxxB97EkAsVxAejcvNBOZmPjY6Ent2F4gJns3tzv0mXt0N7ZElCAWYwTIIHaJVKYZ41y+jn6bCV0xIYdl/sqV+tlbruV6sRb8HVeWxNsSCTTWgA1UgbDC26OAJO0QgF4ZXD9hJxUpTh2/wq5qkbXw6mbEnziI6s6D/gkR1FxW6dcwifSTcXjYSJzrpqbtnmmRsir+AZDvPMcFTTpTsVFZ4PNM0nmrzMYNxu/Q90d2oMq8XqvNinZE8DneYdfo+xXdGnzq3EPzAfUmdAQe6qcRZNhChn1bpGAWqfDAR3QBAO5d8XXv6OLocpeP11MYyvFroIaorzQP5m
 FlT4OPuP
 /On6QjVoCN8ZviLwFXxOzBxnph6NVYPP3Y18895h7o0YrAMkUuTK0NQ0d2fR3oVGLGArCftAWW2xFmW/WUn1aU8sTJ4ladkXL4gMn8JBDWuFWlk8itU4/jB+pXG1h1NuKs9YMpf/CiyGU4b+xBsa0jp8jpHCjR3RwuaOrFpHht6NeADp9Mb9OFV3KbsDoSt4D0OBL8Nd90L9WoH1I/A+MxACsnAhc7paYhE3eDEJYFocnJy1soBviZRNBg7ka7YQKv/IZ4XLMnUR1mjMD8fzsh/LyzGsBC1u2X5FqFlULtfLXCcce/p1l6y4F6zn4xW6UCW/HSjmGHUqryPNTXgaXVcU0+zF8DJF7imYUlahHAuj+3OcAzow/mbBev8r7KOEgc54otUhNdKFf1JejRsYnazSIhJX+uSnv5m8g/hN8kgAwVMYc9JJ0fVB3UQpzb9du1vjq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 2:41=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Thu, 21 Aug 2025 13:29:04 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > On Thu, Aug 21, 2025 at 11:54=E2=80=AFAM SeongJae Park <sj@kernel.org> =
wrote:
> > >
> > > On Thu, 21 Aug 2025 10:08:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.=
com> wrote:
> > >
> > > > On Thu, Aug 21, 2025 at 3:27=E2=80=AFAM SeongJae Park <sj@kernel.or=
g> wrote:
> > > > >
> > > > > On Wed, 20 Aug 2025 22:18:53 +0900 Sang-Heon Jeon <ekffu200098@gm=
ail.com> wrote:
> > > > >
> > > > > > Hello, SeongJae
> > > > > >
> > > > > > On Wed, Aug 20, 2025 at 2:27=E2=80=AFAM SeongJae Park <sj@kerne=
l.org> wrote:
> > > > > > >
> > > > > > > On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu20009=
8@gmail.com> wrote:
> > > [...]
> > > > I think that I checked about user impact already but it should be
> > > > insufficient. As you said, I should discuss it first. Anyway, the
> > > > whole thing is my mistake. I'm really so sorry.
> > >
> > > Everyone makes mistakes.  You don't need to apologize.
> > >
> > > >
> > > > So, Would it be better to send an RFC patch even now, instead of
> > > > asking on this email thread? (I'll make next v3 patch with RFC tag,
> > > > it's not question of v3 direction and just about remained question =
on
> > > > this email thread)
> > >
> > > If you unsure something and there is no reason to send a patch withou=
t a
> > > discussion for the point, please discuss first.  To be honest I don't
> > > understand the above question at all.
> >
> > Ah, I just mean that I need to make a new RFC patch instead of
> > replying to this email thread.
>
> Why?
>
> > I'll just keep asking about previous
> > comments on this email thread.
>
> You said you will send a new patch instead of replying here, and then now=
 you
> are saying you will keep aking to this thread.
>
> I'm confused.

I think I miscommunicated something. I'll just follow your suggestion
below. it's the same as my first thought (discussion here, new patch
after discussion finished)

> [...]
>
> Ok, I think this discussion is going unnecessarily deep and only wasting =
our
> time at clarifying intention of past sentence.  Meanwhile apparently you
> understood my major points.  To repeat, please clarify what is the proble=
m and
> user impacts, when and how it happens, and why the solution solves it.
>
> Let's restart.  Could you please rewrite the commit log for this patch an=
d send
> the draft as a reply to this?
>
> We can further discuss on the new draft if it has more things to improve.=
  And
> once the discussion is finalized, you can post v4 of this patch with the
> updated commit message.

Good Idea. This is the draft for commit message. Also, Thank you for
your patience and understanding.

Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
include/linux/jiffies.h

/*
 * Have the 32 bit jiffies value wrap 5 minutes after boot
 * so jiffies wrap bugs show up earlier.
 */
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

And jiffies comparison help functions cast unsigned value to signed to
cover wraparound

 #define time_after_eq(a,b) \
  (typecheck(unsigned long, a) && \
  typecheck(unsigned long, b) && \
  ((long)((a) - (b)) >=3D 0))

When quota->charged_from is initialized to 0, time_after_eq() can incorrect=
ly
return FALSE even after reset_interval has elapsed. This occurs when
(jiffies - reset_interval) produces a value with MSB=3D1, which is interpre=
ted
as negative in signed arithmetic.

This issue primarily affects 32-bit systems because:
On 64-bit systems: MSB=3D1 values occur after ~292 million years from boot
(assuming HZ=3D1000), almost impossible.

On 32-bit systems: MSB=3D1 values occur during the first 5 minutes after bo=
ot,
and the second half of every jiffies wraparound cycle, starting from day 25
(assuming HZ=3D1000)

When above unexpected FALSE return from time_after_eq() occurs, the
charging window will not reset. The user impact depends on esz value
at that time.

If esz is 0, scheme ignores configured quotas and runs without any
limits.

If esz is not 0, scheme stops working once the quota is exhausted. It
remains until the charging window finally resets.

So, change quota->charged_from to jiffies at damos_adjust_quota() when
it is considered as the first charge window. By this change, we can avoid
unexpected FALSE return from time_after_eq()


>
> Thanks,
> SJ

Best Regards
Sang-Heon Jeon

