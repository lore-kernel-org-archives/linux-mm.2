Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A72FDEE25
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 16:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DB56B0088; Thu, 23 Apr 2026 12:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227B56B008A; Thu, 23 Apr 2026 12:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1164B6B008C; Thu, 23 Apr 2026 12:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2F2C6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:40:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A29A91402F7
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:40:35 +0000 (UTC)
X-FDA: 84690384030.06.15381E8
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 830FCC0002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:40:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=inNV0K9S;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776962433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PokA5EaZgDdzkAI1t9Qd6gl0E9Yg3pzz/mixh3rkBk=;
	b=zDcGVvkfOWTMu1WM6BBM7dpM0QUTSYZYfXID9275OZdiqEyZ5ULxPCV3nc9uoso/yv3oyR
	RWI/6Lz8v2VS8AdPe+FTcEtvqpc6PkchS/s/jkg4QVAjyPF8MSysrcmusIOnWXVopOBfew
	mHBca5M6RdDS7aRKxmCSLPudpZl6JUM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=inNV0K9S;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776962433; a=rsa-sha256;
	cv=pass;
	b=HYIe8PSaUfIINtcJn5tpoBbkq8eIZ+j9G6Df1twrZr+BaBp2u/S4LGNfXumk4/eklP3jTc
	I7jZENiJwyfDde8YFKYJS7q0UJw26PovMt1O/5cWsv+vcOrCus4J9D4AbENl94/7/sqyYm
	jkvB9G9telz/BA9fSN3dBATcuexot3M=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d70c30767so4599758f8f.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:40:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776962432; cv=none;
        d=google.com; s=arc-20240605;
        b=ecuDBnAp6cf4uFxEvnctTO3Lgi5RxIsFwh07wwQDMZQQbXHqyPcUticOXeypdt/0Wu
         FeTWY+56ayYRNcAl++JIqyzv4yRIn9K69oPRR31oCMjXKUQ5SIxQNbytUqF5HbiGkurp
         uuMomTNN/sZDqhWIScZY6FGOnaECDO1y3PJOlGIjhM6iNeMxY1oNaZ1tYjme/tlfhUS4
         +pvqiz6zBl+fKWwKQAoyXANbReoNNPk1fMJXJFYDfAPPXmg4IoCtaOQYe1sffgzLdKRE
         9Ub8VKZu7QKvGI9SWESEBaX+MR+NScPbdRfVCp5IhaF5JL0ejVGH5K0uqUiIE84lsNX8
         XR8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3PokA5EaZgDdzkAI1t9Qd6gl0E9Yg3pzz/mixh3rkBk=;
        fh=IN92e/EByU/qGyYA2OHhi7qEWbWzWzK58aPZJcEpjl4=;
        b=UOCtKlvH3U9yCs7V2yyz2xCyLoD52ykbZe89FlU7Z9cJDmj+06CWE8fnM1JnHNgQRW
         xSEjl3Yhv5SpRbgwDV089yPyuZjaXKINSAypB/kmPP1pOIHsUNNq8C+2zqRIJiUgejbT
         B0oAQdhq/zU9YgM+yMmActx9mZdsp0a6SJsJHdz/dv1/UrJC/DWdEnBoT4+LZJ5MS710
         SL/A4Wr3Lcmg5IU6M60Ldt0njSgb2AOFTIER6/7Rjm/8e4to72k1BCA2hebk1iXNptCg
         ZbjxtdA1rq7ZTgZE+bE0F2SRCiml3Av406TuF3xZNspPzLulvdVeojtzk+pEZGhaqIHX
         J0DQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776962432; x=1777567232; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PokA5EaZgDdzkAI1t9Qd6gl0E9Yg3pzz/mixh3rkBk=;
        b=inNV0K9SoF9LDGwh4rs0RntCVr9w3d6kfnk6hOOmkFJndnEYd52zpJtorwrGEC4vrT
         i+OYhOnzbdIdnMODbiq6qxDuszJ4LuLhIhnR9RkFIcCOLzQJftv6Mz5QnvcYSdP+0ZWJ
         NIXpWphIGFYie3iteq2KJjfuHxWsz4wdYkMirWSEI9j5WZSogE9fOVRQH+15Sr+1bqur
         1LYtGGh7uW+ssyMb6NLg4DiZKovBuPzW50so/UMBIShei2np0S7yU5zdvq+msfP49juI
         m5SmAvxFpTtpALRvYz/crUXdy3F0rF1bXE/+t/npED62RZmotatgDnsT+9x1GjgzIsUu
         ffiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776962432; x=1777567232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3PokA5EaZgDdzkAI1t9Qd6gl0E9Yg3pzz/mixh3rkBk=;
        b=fU6y/T+O2lOQrcOmPwVuYGaceHoHMczIefFu4axk0W9g0lUxqFSaEGsGKXrXuxRRh+
         xiFWX0WQmIBmNKYkshU6klsfnNNDFDsuepkeGE5gfbiRjYL6FN5tRc7ihid1t7F/UTSg
         A4JIhcrsu8HeOzk2NHS5KSZd5rgMXRsAyeg1f/LrD/ZnFfzFZyNWr4RNpk8GbMkmK+Qt
         MMht+91MJSH68f5bwT0z1/b2tlzoZnW01+fkkB+lPKx6OU6MLfq2UVxUJIRKy4DTpqNI
         WKmrfxg3OR2Sb19GXUsOzkyGG384A9BBtLUXlgt8axwUWh1dIDFFBF1e1W4U3xJli7Ao
         rPHg==
X-Forwarded-Encrypted: i=1; AFNElJ+2Ju9H2bE1Xjv5noTzOjxj+b1V4i5J8nHlLdizV8fGUiKtXxN1uT115Ye/Hf/ErWD1UqRxJ/QdeA==@kvack.org
X-Gm-Message-State: AOJu0YxXTU+v7X8lBsnLGGIroydRe7EdnNWRaN0dVi0c9sMc7LfKuXEb
	hbvfoxm5ynmFJ1KoawwpTtF0SQiNlaaXP0vkh3vtmgsjt3HP6zTphH7qGFtgc03DueFKv5m/Yy+
	WpOM7ndjbqpp3IOVOSqHmyLEwukXCaeg=
X-Gm-Gg: AeBDiesLnf1Akl1cJJOswL8MpU4cCOV3weadyhiWNuuJtIYuzoKgai1Z4jxr7P2oCet
	1dNWZOm1hw53ZXNFN5W8zl9crBce083pjT21rELLuSCNsBQS1Nu7X1r2VB6qjzjDzdHaB3DOtuh
	7FRAt+hYmDePrraVDOkE42Q5gQDx4NOmOFf2H3IK8HMDGBKfY84yd4hkinluhKafCCnusN9AoVg
	nSkqOjA8wa813O6NX5zJSYcahWOlo3agu0PiCbyZlMaqahy1DL4I6TRl4eJz6FKikrobrVF9g+R
	JILXnrArxNN5ZB/RrL97qNjhj5D0F/GT+U7hbZjGcjJFJZkBJMtP5Qqwiwxc
X-Received: by 2002:a5d:6f13:0:b0:43e:a703:3675 with SMTP id
 ffacd0b85a97d-43fe40329ecmr37687772f8f.5.1776962431493; Thu, 23 Apr 2026
 09:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <20260421121616.3298845-3-haowenchao@xiaomi.com> <CAKEwX=P8_5qyou0KgvwvoPpRsUN4ohwsC7ysxjTW=Fbwk2uSOQ@mail.gmail.com>
 <CAGsJ_4xosgszLBGXdXGchgYW6ks_XB1vO35scrO0UUiQ1ZvVvQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xosgszLBGXdXGchgYW6ks_XB1vO35scrO0UUiQ1ZvVvQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 23 Apr 2026 09:40:20 -0700
X-Gm-Features: AQROBzDdE4pGGd6mO7mjlt9Pk8Ovl7lU8fEPEqM39shN4JBZIr2r2Cztec_PHnw
Message-ID: <CAKEwX=PX1yiYuZvQafQ-y0p-JHchdGKMHLpvsB+P-0zPoW4LMA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] mm/zsmalloc: introduce zs_free_deferred() for
 async handle freeing
To: Barry Song <baohua@kernel.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 830FCC0002
X-Stat-Signature: p6i7g3hbb584yry7exy47fjrzez74k1o
X-Rspam-User: 
X-HE-Tag: 1776962433-892423
X-HE-Meta: U2FsdGVkX18zPnYx6fnNElXHOvEEvaAN0kdXa/jzY0/wZaB4SC4zwBsfnd7touOMK46UhkxfVDZbfRcNZishin/phpU7XBFOhOLbeuWYpjyqvFWgCOCq40X8Ct3Jsf/6kcubm6/yKYGhU0Y0xBVZtvxHi8+5G8q3UNHXxCZNM8bTPqGUDoIguCa6zwdP3/auayqLqZlQxhZjdoHFbgbwaZoUyoM1mZhtUlO+pJ3oLX3Ml0zR/MNV4eX+7CRsH4P1+oH81i1qLprOARTe1Vfnr2XDqSSjlOOqx+iP4L3Qb7ZcJV2wcPxPsvGOu3XHMRu/pZeNZrh2IFh0gqrCCNaapfud9cHzvHTWczK3cgS5Ad/aAIcCfq59vd2sbDOnGx/uit1rnExvAnvu3bY7fqUbo2CWVrsPcVpc94WA3qqZHT1pkyfMr5BG1cvr9Hb8N5X+qXcdW2eWHOzc8PVBDrs+hO1RrMUq2eQIndBlu6LVhV11znRYIi1VMjd3QY316rsL8WDKXlyYpCuQ2Zp0yOIXJkUlEjC5p7/V+Y8HilTkz67sFbon6o/+9UxF9sErmv3zRu4ZAmYYsW+krqQZ/G4Luyg8dtiKoiArNMBb5nxKFwhNNAgdMwOYWXAxz8EDw1QYpIrtC7tudk81ziARacb5JguW2yv7QQXeCMuCtCI3IqTNPe9Fqv0HZQxCQiRdVgRhKeBIuyZWgY+bDRDufO7XjQzFPThhgvlc8Vx7SV013+VtHyj34T76eabZzrh3JQ/94QjmtCP41kSH7VvE68DtEnDsYy0nFpirQOOQUk/sGC3LdqxJ4JOUnnqpK/h9hLvmP8VRLYLlDZRPH2BNV9QU8WQJ2rJ6fNh7z+XDwWImAMxyqLlAGJFBA5Y1Qa1PwNSHe7+gwA1yufC02jmfkoQPbFycU6HxdyfFLthWdLUzGoRYs07f5cqu2nTVHJdb+Kn7GhPS/SEcyxniC9pT8qw
 Rm5oeLyb
 nERrsbRkidARy/9Ft4NvO1pWncXgyXFwALkjOWIgpFykIG+YKhBZ8K1hJirWqCdLlfWXWnTv373KWcTy/zVM9v3oFa+fMETzqJVBEYhDni45T5iGKF6isq6BJuswmGnYJSS1ejBzNEBOrbfwyv7xbKu435VXRH/gwpTSGSttT3w3dCCibotEZFyPf5GMz3rFixglLlFfoWXolHuomUKXylzGQowN2LTPmM+kOBS3uKaqbKZoZim+4SkFPW3/AIlmVXVgJGsu2PuRuE4U4lYIT5qkqmlI3huchTCbvh6I5+hmCTl804TA2NkeHPHYdmiWR7HdmNQIF5dyDdBW/hIlBxdkOPq8WPgK+m7ys7OkPm/gxVx/3qBy4v6sj2e0q42mkucD4UsiUMmVb4ZhEkBGDdag6wZ2TORL7AmqvDFc4+XG6z5Q+ZkleQ+qafClwaC7QXE9UsgcW/TVAjF079pNryyJIHFPcWyiOSdCsXPoZjQPIsaVeo1R6GGB1uSseGRbnN3ckyseMgQTpOh+94SM9PLQ/FFh51UOtNS+km4fQgr8PpFiKEreX0DGazN8r2oud/rj01TP22tgM1Oxu1Yz6gDizO+4a1VY432KU65P18GgrqStNYT19Qo6a8ia4RPo+QnCMLKl7HEFkqK0cqGSHUIArGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 2:42=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
> On Wed, Apr 22, 2026 at 3:47=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Tue, Apr 21, 2026 at 5:16=E2=80=AFAM Wenchao Hao <haowenchao22@gmail=
.com> wrote:
> > >
> > > zs_free() is expensive due to internal locking (pool->lock, class->lo=
ck)
> > > and potential zspage freeing. On the process exit path, the slow
> > > zs_free() blocks memory reclamation, delaying overall memory release.
> > > This has been reported to significantly impact Android low-memory
> > > killing where slot_free() accounts for over 80% of the total swap
> > > entry freeing cost.
> > >
> > > Introduce zs_free_deferred() which queues handles into a fixed-size
> > > per-pool array for later processing by a workqueue. This allows calle=
rs
> > > to defer the expensive zs_free() and return quickly, so the process
> > > exit path can release memory faster. The array capacity is derived fr=
om
> > > a 128MB uncompressed data budget (128MB >> PAGE_SHIFT entries), which
> > > scales naturally with PAGE_SIZE. When the array reaches half capacity=
,
> > > the workqueue is scheduled to drain pending handles.
> > >
> > > zs_free_deferred() uses spin_trylock() to access the deferred queue.
> > > If the lock is contended (e.g. drain in progress) or the queue is ful=
l,
> > > it falls back to synchronous zs_free() to guarantee correctness.
> > >
> > > Also introduce zs_free_deferred_flush() for use during pool teardown =
to
> > > ensure all pending handles are freed.
> >
> > Hmmm per-pool workqueue.
> >
> > Does that mean that if you only have one zs pool (in the case of
> > zswap, or if you only have one zram device), you'll have less
> > concurrency in freeing up zsmalloc memory for process teardown? Would
> > this be problematic?
>
> I believe so, as reported in the original email from Lei and Zhiguo,
> which proposed introducing a swap entries list for async free.
>
> >
> > I think Kairui was also suggesting per-cpu-fying these batches/queues.
>
> I guess a per=E2=80=93size-class workqueue might strike a balance
> between scalability and reducing lock contention across
> multiple classes, where the locks actually reside.

Sounds good! Let the numbers decide :)

>
> Thanks
> Barry

