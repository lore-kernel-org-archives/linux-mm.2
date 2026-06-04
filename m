Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174DFCD6E74
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 17:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3908F6B0005; Thu,  4 Jun 2026 13:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341FF6B0088; Thu,  4 Jun 2026 13:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22FD76B008A; Thu,  4 Jun 2026 13:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 148276B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:23:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A38008C6AF
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:23:51 +0000 (UTC)
X-FDA: 84842902662.03.50735E8
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9163240008
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:23:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N2HU5NjS;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780593829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rB/IXV+OMc2A+R0X4txGzVE+20Yu2JeN9gbqIkZf1A=;
	b=UqWEWzvRIDTCSFna9tLq+6gsxUqP8HhirE35mhI9Q4C9wAruBm7RIxpwZUVzmwSoGb1pE1
	QK+h3aIfcb+pNJep0HOedoIKuprjaCdwQTjdi8FIjfHhKGnH0wRexo1dS/sTTSvsj2/ko4
	xgePo9Rmns8cmpe21aZl8NEL26VymkY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N2HU5NjS;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780593829;
	b=t/tZWTtIGDt+xkGd/7AFLbPfNBbvJxkafphU6GcdWChRWspzBq1EIyKZkbyCx+TV6XbqZz
	v9g0pScOBYWlZlaKs28A/59ceHhrHsljNb/Y+mdQv+Se8vttbbfieQq463qr6hU2oiceHV
	w4VgEzyltCl44ErZzCrH3jEwB1fOzBA=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-46019b190b6so778848f8f.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 10:23:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780593828; cv=none;
        d=google.com; s=arc-20240605;
        b=A+2PdSGh9cRkbrGbEIQruK35gzTtX/vhyREkafMA8XjnkCsRZRCNJUtPG3+//2GyYl
         an2PLup+Pg0/kA7sEeKp2ZItzxAcpVwYPg/0T1sfqXOeeTOhjSQApls5m0X6rCX3uj0v
         4FfS2XBJlW/SlHyBSw0hmsQ9Ea2IcGXZhM05RQRaZwZ5eAjlxWVuz4aF+z5ZBVcOfhXE
         +H+ptjRa1vxUcQWf5a8zpIIlWoxmkXOaDnfH+UddkF5CAPPrBSrzgX+FpcBVeLKHtEZY
         cFC0Qf05vkVJEwpEPJi7+JfAc0POyg2RsNOPMdZAEz74Ov2GnkhhxHodOOPqb0y+RET3
         0i4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/rB/IXV+OMc2A+R0X4txGzVE+20Yu2JeN9gbqIkZf1A=;
        fh=xqBVRFtVKo3lWez8XPeEpYmFiQUZzGjpRkcThysZzEI=;
        b=GSPr+RLGOjdd0ipM19R+VzkFAgso8VZFtZBxtPldR+frxW2HOazG4DgcHW8hjnCgz1
         MgF9JmXE5BEfp0vJdyvg++tj7E2XFYN57u9Jpgy0HJIjFYKL3aS66akSRlLkhg+Bs5ts
         2e4Pg8vsE+u66XKIsz2Mp8WEwP4LzT9VDr0kCSLmgmfDtFvX1Cxa1NwKJnm6hVSMa3sj
         L7h93zgxXITAiwgmqddYmbPdLfLcf9K6g5/L9BN7TVwzS81obMDuXcUAbvV8q3+uE0kx
         4yOVUF1T7VoWLTcumvfh+9owsefPXgXPx1UfmxkPulwYiBSzi41P2R/lelJAbvJXb1i9
         xxZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780593828; x=1781198628; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/rB/IXV+OMc2A+R0X4txGzVE+20Yu2JeN9gbqIkZf1A=;
        b=N2HU5NjSPlrejWTC2WBjXCEqfOHxupTFmNOF0QyE5V4SdGyn2bppzH0F3JlxitX9SQ
         P+gFGocbk72fIDbt49pSj0ZDmCVtaO4FUUbwVKt9i0+U+w+pid05ulF8G/CZCem3z/4b
         eOozV39yPQrIxS8/l+kS2GXZCQSMvK0Yi4rffOz9LjYJhrm4FSqVGaAnEShIxCJWgekK
         vDL3FQ7+508B78qjdG2UBT4wLODWPAsIVFRTjmjV2+PltONJ+lukSkkUkfmlm1qj1h+I
         rUclf5QGvGgpsa2iD0niuedISL7O502NkQmaGKfolIQUhwoayE0VB20/8OixdIb49ZCh
         6uxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780593828; x=1781198628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/rB/IXV+OMc2A+R0X4txGzVE+20Yu2JeN9gbqIkZf1A=;
        b=DDjikonrD81BrZIJmDZYpWIp1F/bX5pWj4PozmIIbmqB9r28XZoWW+mCZEXipKRaHk
         FspC5eaXj6tK6+xvntKeYmBo0Cb5s8R4pbEdoWq9GR1ocCbAgyWniykN5QVL8kAvHq3e
         vyprGl383ZYnkly4GM4b8V0ry1AKLzjDVj8AbuWW4BqzYhho3s6hZxyK/CCdtmxwT8n+
         EhL0nsJVHu2/YzN1qmLlGZmuj2iajppin6B3TlijBtTZYlUzkMSEWQJJZ6hjB7Th/H3N
         EX5cAkJyVeqpHhhRQRNP8uP7KCxNAt2sQyT3TJmxXZSm+DQj0QI7lAXBJKXSsH8ghFx5
         R4aQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LGc42n0wHYLET0O0sCqWjThdbXsaSqbn2adXEalpivMcrOzjDSMHKsBQLgr2C6wo+lqVOVFuifQ==@kvack.org
X-Gm-Message-State: AOJu0YxJcb3Ezw/Uhu/pgPJ10FQD4VHMUxg69LQrmb8dp/VuwUiewakk
	mCZVOJWHvk7Ob6k4aTESpRTsBL/gNC0MJsS3iWoWWqh3p1NlndmbL5AvBOQ7l1dr/42fxuvc78W
	i497MWc9DujW8LYHAIayokbwfeb8Ue04=
X-Gm-Gg: Acq92OHfYIABWV2BW8m6ZBZ9steewS3G6nAhd0IkjIcgz9+4Tupg4AsXm7Upcfba8y/
	xd3y3mrMknZksJ5TdbXBwGBPZmNvd3FFl6pONC8Lsr083U248nue8IXemDbI8ZOJZZKtaXv6z87
	2YecEb91QgpiM9JJ8lKewQzzW5EVeAE58NXSZxnAk+kfzGt5S23Zz0DAreePGYdNnVtkFg7wlpw
	IphaF225685Ng1isTF7J5ZmQegBXJoNovYeNelVavV7s3hXvmGX6AHX/nr0JLjVtlPw27Xl42Gt
	NIWQqWsE/QMZKFr5dqr0O99jVX9ut16QERHw6IcosV+lRsmxjg==
X-Received: by 2002:a5d:604b:0:b0:43d:69ff:6898 with SMTP id
 ffacd0b85a97d-460302e6f06mr103580f8f.9.1780593827921; Thu, 04 Jun 2026
 10:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com> <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com> <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com> <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com> <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
In-Reply-To: <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 4 Jun 2026 10:23:36 -0700
X-Gm-Features: AVVi8Cflh7M61FcoQfkq5TRPiQaxI_Tappj1TjJNCo92lEJSIG0y-zr5pc0cdEk
Message-ID: <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9163240008
X-Stat-Signature: kkby1oonc7du15nwksmxpg8upf4tudm3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780593829-312724
X-HE-Meta: U2FsdGVkX1+rhnjBafa8aaiCWzXvUo2tR5UdhRUUJ4cZcSG9lKO4fpJCehtNxXZYDLnrKNppKXIUaGbi4bdhvbXzKi7LjNOSRWKJj0mLwqgJLlccBjzWMHj2CrLOvE9ZZlGDeAAfbtjlJziqmP9C8GTCk5isFSpvh/BWd+yHHR+0piW1iyEaQYtLVKte5hXw8Imt2j3WheF49qhC4GKx39gYrbe3Ab8HGZ+6BnrhYLI9eO2UfgQjeU24ZhpkOuIHa1jvUCjrkAQLseGOdbUFNrFy0t6A5rknkY7SGgFFBaKfrSdZmGVrFt5Nrv3N+qjSsFPkFsJgXwVJzvahahAMzhcwT0VI2CYiQZVkwDG23Uuz+FigjgzbAz9ZQ9cYHsnraMGCz10Drf9LugCeTchAxShotkdjfVdIoedVO8OPajSslCj5h4b3oDDx06V5ddXJjYzIiJkArh49cYYPVXGMiS2QU8SLbhdtMyWVR+7uxIJ2RQCblJfbV3L1HE5n63Ake5/RT4AbU1dv4Go6G/iMFUVlv1zqIgsTbYT26UTYHhBCR8WAZU0BlMWR+GQ81c4HkbZKCGmNjtgL3DxKdWc7hJVk5DhQypW+t5hBZs0NOk9zE/jUlDDWhEoeeV+HlHe8ltmqgjvX8dclCAw6AcIVer8C3BfrPUlL8v0yC1KaNfOyVspuDig6mNRwLg4CBmnnsV6c/UBntn2R0+dw/nUF306gtCP6M2wjXSlF2XZHehDw/7+45wGQAbPwEl+DZh+ga4jpiJd2LFBqCt5gb0ws20cL+th7utnUcJTNUkNTaV6rKma7z9kVaV0ozbSBr++5iDG99tZyRA6CNQIS/8CrIJorrs1rXwpkLP8edEXj9Ngb86zMr1Ca/fZhOzhdbgjk5QxNIpvCzdSYJCO1JL+s1r9Knj6VlodV/8wOui3eD+mwXe01ZReM9OqQKtHyNXpJIEbKC8nphaAX1KnwZWh
 2hnqKhgt
 voJj9IxtkDeb88aqraoueJogfWu9+Tj1ZWvJ6GKHaWMjOExH/LgGAyne5o/FDqyFdnIiYwApAXpgZd/T12A8kzFfC98Adg7RZ/bt8A25iTkVCQtG/J9Ftl3ADVlg38Qa/pI/WcqezgGwNng37obO2/YJZGa8TpAgVD/P/XLXZFxAWVqej2pW74j7UnkYfFMDTm8Yhy2klQNzLyAdH6R2u+3Nsb5K7ov9/tw0cVPdOeBR4MfNhDqFvZw3u3yd23BXwb2FPbO0Manxf3cf+bZfqs8vfV7ZAitSsPRplgMPrd3oopjQUqNGY6AMKx6/eJwieWFNpChGBNZiC+SMYRvIbxwhWOG+f4TSD5dSIK1glVbkjf4PagfAAMAfQK7Zq9yF+bYxDUbHFQY+PyMilUXrL/biSL47I32kbLTTgwqRQr3M5NOxUEUZPJewF7bBW6bSIV6l/mtkA/Yooac7yY4oQEsIb5LmCZSA9d56hGZwEkou1azu83tQ2GbPe4AlBxpSpOvG9JnTdo85UBVv34xeo6VQT+kDTgt4fGECeudCu9h287tk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 6:06=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> wr=
ote:
>
>
>
> On 2026/6/4 13:34, Yosry Ahmed wrote:
> >>>> For instance, suppose a parent memcg has two children, memcg1 and me=
mcg2,
> >>>> each with 200MB of zswap (100MB inactive). Triggering proactive writ=
eback on
> >>>> the parent memcg will exhaust memcg1's inactive zswap pages. After t=
hat,
> >>>> even though memcg2 still has plenty of inactive zswap pages, it will
> >>>> continue to write back memcg1's active zswap pages. Writing back act=
ive
> >>>> zswap pages causes the user-space agent to prematurely abort the wri=
teback
> >>>> because it detects that certain memcg metrics have exceeded predefin=
ed
> >>>> thresholds.
> >>>
> >>> This will only happen if the reclaim size is smaller than the batch
> >>> size, right? Otherwise the kernel should reclaim more or less equally
> >>> from both memcgs?
> >>>
> >>
> >> I gave it some thought. Not using a cursor could lead to unfairness
> >> issues with certain writeback sizes:
> >>
> >>    - If the writeback size is an odd multiple of WB_BATCH (e.g.,
> >> triggering a writeback of 3 * WB_BATCH), with 2 child cgroups, the
> >> writeback ratio might end up being 2:1.
> >>    - If a memcg has 5 child cgroups and a writeback of 2 * WB_BATCH is
> >> triggered, it might repeatedly write back from only the first 2 child
> >> cgroups.
> >>
> >> Although setting a smaller WB_BATCH might mitigate this unfairness, it
> >> could hurt writeback efficiency. Let's just use per-memcg cursors to
> >> completely fix these corner cases.
> >
> > Exactly, the batch size should be small enough that any unfairness is
> > not a problem. I would honestly just do batching without a per-memcg
> > cursor, unless we have numbers to prove that the efficiency is
> > affected when we use a small batch size. Let's only introduce
> > complexity when needed please.

I'm impartial towards the complexity of per-memcg cursor. I don't
think it's that big of a deal, but only if it's warranted.

Hao, if you're convinced that doing small batch is not efficient,
could you run some experiments to show the improvement bigger batchign
and fairness? Maybe implement a small batch, no-memcg cursor first.
Then implement a patch on top of it to add per-memcg cursor, and show
how much performance win we can get from that patch on top of the
patch series?

FWIW, zswap writeback right now is not that batch-efficient :) There
is no IO batching, or batched lock operations (we drop the lock
whenever we attempt to writeback a page), etc. Might be a good avenue
to optimize.

