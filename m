Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40832CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A196B0010; Mon, 24 Nov 2025 09:58:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901EF6B0032; Mon, 24 Nov 2025 09:58:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E706B0062; Mon, 24 Nov 2025 09:58:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 725FC6B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:58:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D498B4F22F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:58:15 +0000 (UTC)
X-FDA: 84145806150.07.2E47C9C
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id B1D851C0002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:58:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iFBHcHHZ;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763996293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QlsGXLnolIwD4FFhjv81uv1vh4++PmTqjIYectZ3SI=;
	b=hQT5d7yGUhFgFlwHVwZKyLOkzFZ4OjIcxcMKbHzr1X8VbJWZeMRGVG58oQ6rUX0792LZ+I
	4vs1LR6y1JJ4TNg26mNjZQu9EXIVEXdOw7Za+JshbHm9glG1Uza9gdL70GQ57pL2/a/v+A
	vL8ZXNQxIf3/Z7e/7JSvq0n8oEWW3N0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iFBHcHHZ;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763996293; a=rsa-sha256;
	cv=none;
	b=SB/UGG30xEayVaaLY9t5RugVAF4zyR1d5rDOpqecGGPUjuRRhnnIyCN5HjzjCh8JrLePTE
	VTsmjBDVe91ZD5ckmaLFyB0oBQyhm/yQW7YRL6F1G0rJyP2RYgZVe200kfUQdY88PQZ7z0
	FB1wZp780mPgoC2KGUpdHwLfjTHDmnU=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37b99da107cso38512161fa.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763996292; x=1764601092; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QlsGXLnolIwD4FFhjv81uv1vh4++PmTqjIYectZ3SI=;
        b=iFBHcHHZBGn4GgHxFUbWSvSnW2t7xVwMEhcy+ItZqnSaR7Bm6vkHHQBcqKx1ULV2Uc
         GWsiElmocAWeAnpGqNTf11sLfvYPX9CK3hTCCwebOgpUVy1fufslxYmsVWAs3bU4kR13
         9gueX3IAHk4OtxPDOlX/Dr8iV2OPm+NNJBU+kwHj2gKdEgEW+uC1xWYkJBRdZGXM3yjV
         SxUsLz8lhLd8mAaHw+RxKP0hHFK8PIrl+2yjnfwKDFZyX2UzescnhQnnv5lXsDrs8HUt
         x6f4s0psIUl348vWTp5CDxt660aMgBqOHmfL53mceoaQPgO1cc8HgZCgbydnMX386pg1
         0itA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763996292; x=1764601092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3QlsGXLnolIwD4FFhjv81uv1vh4++PmTqjIYectZ3SI=;
        b=SjHOe0LMJJWos4Jhs1Yb2x7d6Q7D1Y3Hxdij8UzIapqOZZHh7yPIPMeOjJAyX5oJwL
         Dtp14nOvT8iGFmKLQeHXZ21Zpau++YVslrCgfVuOnVmHHfKuoi7BXmJjEcdPqdQXmn2C
         M24JBacp+p710TUw9OOJtDsTZ/UFS+RSG54XSNwRB0TnNMJt07uobiJRVpwPAyH7dNHk
         sCBnomeP8HyIFG5Yflsa4/eYp1IsSTq8ZuF+0OaKBJA/FWoMeB05bIa3mIhkgRfjWCAo
         U7DxfwRskChr02wSgKVc2bh9mqI5pDGusXZOCaKdi/NGeNoDIejA5iWlIKrry5l9gbhJ
         gnVA==
X-Forwarded-Encrypted: i=1; AJvYcCXySUX6OPFPlyqjOfroI9YwjW34uwvlruH2+BK5t9tDlWccnwfOQiEBYiJr0aNo/jvya254fENj6w==@kvack.org
X-Gm-Message-State: AOJu0YwKYg9tuGwOrBKEgpiduLInW2DIqzxP6RxXkW7VJ8VH9MXbtn1y
	U4Uwar85xRVOqY3b/OQzziYoGlywvX/l9Zogi7n62FEzXQK6Ltb3pMn5BFustNiIAwWqQdkKyQG
	R68YZCj30zKloGB/LMKYTKxbLk3iMf2Q=
X-Gm-Gg: ASbGncuGFppcWMmnD+BBORe+XNSZFsjF6TqSW9I/oXu4/RUf9H38/gLYkTq3oHV1ssX
	RSyhTO7MhBk3U9S39lsS+/KXl2MgWMACmbTqeFBxIMI50uu8iOpoNOK6qxKExvKKrIlHAlvN+2f
	vQu7HbCP1z1G1xnSH8zt/rI0BxnwPHbTM16kwSFXiTeBWCqn0uTEHRVlK1/ZJuHv2/rtWHQ0duJ
	c7QyasIbplRckTbMJVEU3GC3ugcTYCk0hnWaGqFelLQwGm6V9RMKO3n6LwuIeQdsvOIT2k=
X-Google-Smtp-Source: AGHT+IH4bfvEN5QLedqHox+9fwWISgxbndiZzzwqGEb0uKERYy8M/ijiJIVpVGtp53Gb+uwALvXIsa8Gd3Bxq3wS0aE=
X-Received: by 2002:a2e:8696:0:b0:37b:991a:5440 with SMTP id
 38308e7fff4ca-37cd9272c3emr29452321fa.33.1763996291487; Mon, 24 Nov 2025
 06:58:11 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <454ejfdrzcdo5a4fmqeaf4nwhxwqnvgmcj7ussl7ws3lpdc7zg@67yqrig42erd>
 <CACePvbWEXfuwk1MuhGn5JV674vJnmaGY2Q5=Am1O9bDVK_J0PA@mail.gmail.com>
In-Reply-To: <CACePvbWEXfuwk1MuhGn5JV674vJnmaGY2Q5=Am1O9bDVK_J0PA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 24 Nov 2025 06:57:59 -0800
X-Gm-Features: AWmQ_bmKbDigl8CA7qdTUGEHk43khsmkFTje9u7BTCVkH4qAObfGxaLwfOYx7dQ
Message-ID: <CAKEwX=PtXrKXiqDQ+s01OkCqO4LFbJUH0RD6K6hKGe=AKDjXHg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B1D851C0002
X-Stat-Signature: yo6jr8uxo8m51cyq1durg7wq8ki7aqct
X-Rspam-User: 
X-HE-Tag: 1763996293-936216
X-HE-Meta: U2FsdGVkX1/1UyiBjvBTUq/WBZEBc0mQb0WHH2DtM6Pm8K9WxMbdnCGV0kaX/M82k+ITw+aAZD9OVangiVzevKkw364CXd6Kr+8bNZFFyeje/qMCAzdCDE0DeEL2l0L9pl5doMhuYRdbzbhacSm/I+lV0Lur6HMxYSq18miwGa7A0R2J06NipcTSnSV7zqBKd+pqw1HyNH/XeBPrbw2fK8fDCRbUiQEzyHWQvnE3WfY8+5Kt8mLipRsUhYAoyLABItiGv9W8TLVQ1/dSGrvV3ijf21D/kemaM8e0BZo5tppD55FCFFW/4nRvNKHoFOR1pkEVAoyrEGFql8IRxhKOW3jOwDuSyFbm5GOd2Fnw2pEeVJcjvDMxLFu4wSq8bw4bLQJbQO/6lGWXPg0dKbNJ1CjEa3tAmMXIWZr2apGNcAiNF5p2Q71hatr+5tce9NQCNqLhzhkcJ+9vjEPTl8rY+9NY+EhbjxKgOIU1ZlsXIkgsD4mAgZq8ari+23p0etyKE5NeKcFpt1vmnRT3Q4ZhnHwI4CMx2ETnM+xyk2GKfJoKVSP8Obl0a/7NbbYQsABppaWJ5F/paiYMSwgt0u8bbwHxm+XaJiKoveNdza4oMH/SjiAx5HgaDhnmdn8EGgTAtqGgSPDMzVqIsAiEsAV55kzAW3V0cJxHlyaNNv6eb1O1NgWTKa1tnkX1DQaE5qfsVtqyDCGxynuvWYwOXiOHBS7VFyDwrkEmvTAytxRU4u20OZ42M1vGIlwLRSJB3ugfZGkkH7A1dR52OznXUOmSxX1eI9c+MKEpY7M0QSo5SGwwwtIHIJSi5UpzrnKHfxmYxhwIcB1VhhvYLySjN0Jgmri2R7hgX+tCG5ckWbtKQoFdCi9yOWbNjWaxqKew82I0ek/xaE3jJdI3XrMpjp5lWCCZqeiJCzzMWCJzH6XAf2SyQNpwp1Bj9yEByHsA8AoLDgnApvOQPoYVnrqy6bd
 WPsfEUJz
 HElYERPtY3q49yVNYUiWDXFpFaaMWjRHO/JUbBI89tU3RlGqg45GwfpStjcrnQPbnP2DFlwj3L8RMMVqjlXKMOPk/XMsuQxvP9mQMP6z9y6KDINGOAJpm19gGbPkLRbrL/6fdMcscCc5KcFg6BCJruEMmQeB8gHS0WfBkR22a0/b6uUTK+PvIjzzqdkcgDLzGkK8fcK2b+1PTVl3aeXK4wvMSPxUOx7YJz7r5+eG/0J+4ntvQP+yiVZHvLLzU5EsLUvV09KS8/zokWFrMnk7zTU7kcCdXrfZn5TJ2S1dzPNUJd/DsI64tasSIYMWj7niF4mAa6odQFERNSpk2ulLyEjIaov1CWcjOn3/zMsPqEUiMkek8xujquUNsbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 5:52=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Fri, Nov 21, 2025 at 7:14=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.de=
v> wrote:
> >
> > On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > > The current zswap requires a backing swapfile. The swap slot used
> > > by zswap is not able to be used by the swapfile. That waste swapfile
> > > space.
> > >
> > > The ghost swapfile is a swapfile that only contains the swapfile head=
er
> > > for zswap. The swapfile header indicate the size of the swapfile. The=
re
> > > is no swap data section in the ghost swapfile, therefore, no waste of
> > > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > > prevents accidental read or write of ghost swapfile, bdev of
> > > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > > flag because there is no rotation disk access when using zswap.
> > >
> > > The zswap write back has been disabled if all swapfiles in the system
> > > are ghost swap files.
> > >
> > > Signed-off-by: Chris Li <chrisl@kernel.org>
> >
> > This was brought up before, I think it's not the right way to go
> > upstream. Even if it's good for the short-term, it's a behavior exposed
> > to userspace that we'll have to maintain. With the ongoing work to
> > decouple zswap and swap backends, this will end up being something we
> > have to workaround indefinitely to keep the same userspace semantics.
>
> Actually, this doesn't need to be the short term solution. It can be
> long term. I get  it your zswap maintainers do not want to get
> involved in the ghost swapfile. I will leave you guys alone. Remember
> 2023 LPC swap abstraction talk, the community picked my approach to
> the VFS swap ops over the swap abstraction which the swap
> virtualization is based on. I take some time to come up with the
> cluster based swap allocator and swap table to clean up and speed up
> the swap stack. Now I am finally able to circle back and fulfill my
> promise of the VFS swap ops. Have a little faith I will solve this
> swap entry redirection issue nicely for you, better than the swap
> virtualization approach can.

Look man, I'm not married to any idea. If your VFS approach solve our
problems, I can move on to other projects :) We have lots of
swap/memory reclaim/MM problems to solve, both internally at Meta and
upstream.

But please explain how your VFS approach solved the 3 requirements I
mentioned in the other email, and more specifically the backend
transfer requirement.

I have explicitly asked about it in your submission for your 2024
LSFMMBPF talk - at that time I have not seriously started the swap
virtualization work, only at the design phase. You just handwaved it
away and never really explained to me how you can achieve backend
transfer with your design:

https://lore.kernel.org/all/CAF8kJuNFtejEtjQHg5UBGduvFNn3AaGn4ffyoOrEnXfHpx=
6Ubg@mail.gmail.com/

I understand that you had more pressing issues to fix at a time, so I
did not bring it up during the conference. But it's an imperative
requirement for us.

swap.tiers is nice for initial placement and for hierarchy
determination in general, but when the page is already placed on one
tier and needs to be transferred to the tier, how will you move it
from one tier to another?

What zram is doing right now, IIUC, is building the redirection
internally. I would like to try avoiding repeating that for zswap, and
for every other future backends, by pulling it out of backend internal
code and build a dedicated module for it. That is just swap
virtualization.

