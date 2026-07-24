Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D428C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693966B007B; Fri, 24 Jul 2026 18:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643496B008A; Fri, 24 Jul 2026 18:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5354D6B009F; Fri, 24 Jul 2026 18:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1396B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:22:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 861DBA01B6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:22:48 +0000 (UTC)
X-FDA: 85025096016.01.09DF67E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9F49BA0007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:22:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jX0NIuST;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784931766;
	b=iDaRngrs3K2ypIlXO78lko67L4M7cRQXucHAUAgp3X1TftkYtqkjuN7WWnHmdvGRiIQA+r
	AcmJMwrCUJvwsiwPWrHU6N5Bs7vYZi9Ob2sTSUSQG6M0WiIryABjJ7upFaXfD/WLUCI1H7
	kj+di5MJYWwjUqgPifzI9f6ww3U7QA4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jX0NIuST;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784931766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXZKDQ87kQqy8zSD4SMdY4M6jHe3cDz0dPfx73Mi5sU=;
	b=RUAYvUsweJcSIjImPGi4VoilAit4Lf+b23S9GhmKVinyZNMpDj02GLOkYSb994ghfFY54q
	DSjdtN+lZcsEyTOy9C4CqNb8p2c54xlpASrrE/lHntOcTmXAWc8rCjx5wK8cbParD7KFfC
	p9Fk3RGSG+WgicsLpj6MlfsYNW5GOUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EACB60A85
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0DC1F00A3A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784931765;
	bh=OXZKDQ87kQqy8zSD4SMdY4M6jHe3cDz0dPfx73Mi5sU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jX0NIuST7H7h4aKAPJAsCqGkVwC7H3437UBy3bFE5wsiTdrixGUpvAjGuhZ4YgGOj
	 6rjxAyJ/tLJ7KRw7fue9YeK4aXKQHhHT0vY1a7A8IU9Ry6TK9ivv7XqgsC12QRiEKs
	 bFmkmgLBC7LaFcEu7+XE9lzsN66c2r1ZsM7HzvpchQ2tK58mycdX5Smobmv3QtFV0G
	 W8t7Llz06hxUfIGnzbZTIzFTvnFUc+LDdhNJ2U9JBQsri9WvsrMUsubyG9vi7orHCg
	 jWEs+o/o5QW+t9hBxBPwkXPkntjDgGLYLolo4KJzm5vjX6/QZn0ZwIZSxw/JmyFzoX
	 Z0n47iAZ56Iwg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1c4c7ddaf6so139004966b.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:22:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RokJt322H0ZSWlIQ3iatyouyQJLF70k73YhHVLoziSpOslVfVZjH27jcgV7jihyt+SdzaCZfmHEuQ==@kvack.org
X-Gm-Message-State: AOJu0YxgztWKSOTK8ICMSq26YNLd+JE/AnnQEKsapmc886igFtmFj3Iq
	Ce7+QnOLkl/ZvXdKSb52pKjjFvDnM7COP7gcAWnr2J/BYpDw5lOBRXT3WheopTW8HFtzgGMvmFx
	MA41yXBVImxlzBpu496njSD01pWvB9Qw=
X-Received: by 2002:a17:906:794a:b0:c1c:4858:c19f with SMTP id
 a640c23a62f3a-c1f1eabc1f5mr9842466b.5.1784931764726; Fri, 24 Jul 2026
 15:22:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com> <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org> <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com> <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
 <CAKEwX=MG0F1+my1krUiOrHCn-Lypq2gq-g8Rv07Mz7sC=YEKaw@mail.gmail.com>
 <CAO9r8zOH93mfdjHq+Ljm7X+ykZS_rjzAvp9OBCzo+uyTbM1fDQ@mail.gmail.com> <amO-hwo8OGV5Goz0@cmpxchg.org>
In-Reply-To: <amO-hwo8OGV5Goz0@cmpxchg.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 24 Jul 2026 15:22:32 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMgVmgQET+PUGexAgNqCZavA2YoTTXKSbWWoUv=A=ytSQ@mail.gmail.com>
X-Gm-Features: AUfX_mxJB29BzNphsC7-RiJPu217rkOtkTuaNG2bcSLXzPxEK8QFDnuX2f3Sw9k
Message-ID: <CAO9r8zMgVmgQET+PUGexAgNqCZavA2YoTTXKSbWWoUv=A=ytSQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Hao Jia <jiahao.kernel@gmail.com>, 
	akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8qa93ei59hy3cj17bohrtnch5fnndtbj
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9F49BA0007
X-Rspam-User: 
X-HE-Tag: 1784931766-564472
X-HE-Meta: U2FsdGVkX19SFsA5w8BbyqzUKOgwYN82ZeJAAkVq8cpRB+c672S6ubS5/F0eJPP5QdXkRGAXodxEx0DGMS1EODl1RZd9ClA2EnAB/M1wJYoSEJxWW37S49EUF7OT0eUhqzHtYJk0kc9vBWpaJAsqNw46Fih+QHe9k6ciN6TkLe5DNquW3BSvfdeacbVz811dgGwjpScX1TVMi0grWjjvt6ouQsIghZlH7icbsI0gZ2UwSWcYj8mStMCfkXbbJlKfxy5g7t+EV7MJ/pzwraDK7/lQVmdtZ54FUZQEi0OiMfOBLMroHRpPYs+Owmu9gKOpkwT4ELzd6+3sTTB4m1yCA80ftcAdotQuHaXVGTjMZChZhWsx1+FHa7uhzksQ2Ij474+abpFlJBYiwXhLCwLGXLJEGSeldasjcg/vxL1lKTKiEIyDzgSWxeLXRaycemWAPqyMFv2/CZNtATwFpnqpMv0UKfMhD09B8v83+lWtudd9SsmhZFuoNdtqOWIFTfPJ7D54oA+eSe7W1tp4fFSdxRXJZ9KzRUA0RQGVtGE1v7bx14SseQ44nKWlycSGkYA3MynVwT6A6XgxD3mxIcdTOH/8MpX8aAdq6pDDOZnWT6ovgebenoLsmwZzWqXhImrtHbVbSqc4/2MJYl1Wm7NPmcIv7rvAqTVJVlNA7j0CndFwCUfZYSjrHV7dwIYJO+BCgxAAUYhkwNGB3VKd555Ctp/lhRrC1obbiCakzoIJCEro+qnYzpDr4L6Kk+j2eqCezT49MifvUpyq5jnno2vB9zIZKoirAovO43N+zjucxadBPSewAR/qlXjcwjwEWWOd1w6WphvXTsyO4QmrytLoS6gvhZD+qWKAPATQBOjoDiNvgvy3S/vNK8HFDz7GqFv5NHO3S/OPooyahcS9B2bc1CUonBlcoRF/TxbiTCUun/BAM6wPZxFincCN4qKNCzYlrZnz5Jhq+WP91I78/Mx
 ZrpTpEX2
 d1iKA03MyqJXHCBricIUNiTley1y9G5nZ2kMUN99tspYXe/5qb9KQd4AjWqBIljtv8OM0goDKIvKdgZZUSDhATkYn/PFzbLo3rwURebF0l67yvJfwVdLnnhm/HzjBG9NXOwDX0h8AMO39KCGaGuQWv0MrIQEvxZ/hga/y2xg6Css+n5ZBNa0Ycslcqayn9UCPYAqwdTMyobNmLClldi1g7RvOLnLsR3eQwxCcWU0kWCzfBrRn0rm3YVHK9pG/OMt48GQSUeH1MJcxbheJ4HtE/GXVzhCUwcTa6whgzt+Ml7RUGIIti8jv1ytpVxMFvJ3rvhhZU61TCfdyPsq4cK5ilbjkYoQQ8PAmTPOd3ZG4B6l0KYa1T39+R/NjQhgGM3DunFTLprNp3jrA4+FcX7jGZ8bC7MnRDU/AKEYJVy4uvRW5wclRdqEcdNzIf8PRu6Yo5KeLv5XBoWK8vEcd41351mHcyJ4NnkpBfYdnxA0cINI+kNl6NxkEE7vJ+rJEQtjxeATu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 12:35=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Fri, Jul 24, 2026 at 11:39:41AM -0700, Yosry Ahmed wrote:
> > On Fri, Jul 24, 2026 at 11:37=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> =
wrote:
> > >
> > > On Fri, Jul 24, 2026 at 10:57=E2=80=AFAM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > >
> > > > The numbers generally look good, the store rejection rate is
> > > > decreasing and we are naturally doing more writeback which makes
> > > > sense. The store rejection rate actually increases when the batch s=
ize
> > > > increases to 64, maybe aggressive writeback is more likely to fail =
and
> > > > cause a store rejection, so that also makes sense.
> > > >
> > > > The only part I can't immediately reason about is pswpin. How are w=
e
> > > > reading from physical swap more than we ever wrote to it?
> > >
> > > The same page can be swapped out once, and swap in multiple times :)
> > >
> > > Unlike zswap, physical swap in is not necessarily exclusive. You load
> > > the page in memory, but if the swapfile is not full, etc. etc. you
> > > don't invalidate the copy of the data on the swapfile. At reclaim
> > > time, we notice the page is not dirty, so we just skip (z)swapout.
> >
> > Oh right, I forgot about that, thanks.
> >
> > I still don't fully understand why pswpin is significantly increased
> > with batching here. I would hope that with less LRU inversion we end
> > up with less disk swapin. Probably the test access patterns are just
> > too random compared to real workloads?
>
> Maybe more time in zswap for those tail entries left behind with the
> smaller batch?
>
> That's a 32 entry window that could zswpin with the smaller batch but
> pswpin with the larger one.

Oh I was talking about going from no batching to batch=3D32. pspwin
increased by 387,400 (~30%). We are writing back 272,880 more pages
but we also have 209,837 less store rejections. So overall ~ 63,043
more pages should end up on disk, which doesn't explain the increase
in pspwin.

The only explanation I can think of is that the test is just randomly
accessing memory, so it ends up accessing colder memory that we moved
to disk more than hotter memory that we kept in zswap. IOW, the access
patterns do not conform to a "normal" workload that benefits from the
LRU.

