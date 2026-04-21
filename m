Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCBBF8FA90
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 15:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA536B0088; Tue, 21 Apr 2026 11:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91D26B008A; Tue, 21 Apr 2026 11:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7446B008C; Tue, 21 Apr 2026 11:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98A836B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:55:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB6A48D9C3
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:55:08 +0000 (UTC)
X-FDA: 84683011896.12.DFEEC83
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC4E240014
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:55:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Fd15i/B6";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776786907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZJifi5xv/2zNGOHm6PWpOJpaLSfKnpwch9WlPfDXVM=;
	b=CLBZZ0cGbAP1ltnJ4U2jXXs/5Tod8zyTndmXNXx85ECUJ3oduuITP0zeAhFqYdMvCeO8CI
	GTSA1PqjR+y4KX+BhhHtquRV3LrFjnmt4swmZUFe5rVzr3EsBgkwK5jQl+hxY0V+iv/PtD
	MDMBhtUII/sOGystG7AxZLPiwHC/Tfk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776786907; a=rsa-sha256;
	cv=pass;
	b=tJbqbIMavHkNjzAjPpE2X4As+BqqK2VsHdX6yV1taRAQANZDoJTd7blSaAtNHJmebVBie8
	M5K4mIFodqfidXs3+JC06XQo2eB/FtK+/5Xwajut3DZCWgBj2uG1QgT1niXED4VUP9QNX7
	8n5EV9bENNbs25JByj8lgNE8XHawD+I=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Fd15i/B6";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43cfd1f9fd1so2763154f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:55:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776786905; cv=none;
        d=google.com; s=arc-20240605;
        b=Ydp/+6Y8OPW8ZDcdK0/zIcyKKfrmiyE7TMRI5x9Fe34xAOYBFwyMOgAgTTu29KFW0k
         nJMn51GKd0IrhwR9diEYCLB5C9xwHE7TXdHUdIli4/+zb5QhXNzO1kvKqCqux9SpETVG
         jYcswzJK7x+MjCfMkvyiNbw6l7YKrxDB9EwRrsPz2i21HwzOas0M4RUAao+9FcBRtek6
         +htg9zWbfAuJujJhNyXXeVfbzdYbQcdyb1UsSzpNDcHxA4g7BLuSX1xUDjueR/wtuxGX
         A0G70H3lM7ycif0uxXlPkaGZQneXGIevxnHP+3fAYcAqz1LFaw8m7wabIx34IEWpWZIB
         D7+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GZJifi5xv/2zNGOHm6PWpOJpaLSfKnpwch9WlPfDXVM=;
        fh=pigLL3PuZrzDtX0Pxn1IEsDGM2EcHghRXgRtm9cvdhM=;
        b=S8LsjP2s2r4rkBA7JyGpMlVwZ1L4XvAsmGCoN2IVaKPxb4VuywNnhLvFA5VVHitilf
         77ob64ojxiWldn7zLPWvaL+T15jtdRJXlbwZIqdzTDkorPzba41mKr6X+0JxY4GOpkRy
         n59uzqAu8mwf4rl16QPHJNnuRzrpeHkVB9glo36/0Mznql6R/48g3xU1nTFgvyIsfrUU
         TgW+N1rUvxngvumsdozgHE3Rd6gHuvPy4loKkrrPVKrFhfBiEWou11+0HYurf5uXO2iJ
         bGHua4rnIYxdVvZ1zRSl0wFcQw3ZHJpkdYOkO2l+cRlWkMzI/DRhH10OXkZ38wl3N9DU
         moqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776786905; x=1777391705; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZJifi5xv/2zNGOHm6PWpOJpaLSfKnpwch9WlPfDXVM=;
        b=Fd15i/B6rbpK9v0IL+ocjv6ZuwT7DBOzvYeqRvM2QbcGTLzRb4ov7dkd/4LgeMERvq
         Y9KKVS65ocnzQy0Dmk8WzfDlesNsytVPqB1P5WUzbvt453E+HBsqM/c97aP+wN2zWf+j
         A8li0+SE8oNSuHgx/oC/Qb0g+GLN3VqqED7vCqCWtA13ABak22rQUp4ISgyPCFs5TeO5
         wD77qZrX38Czr0OZD3PTHqpoKNWpPvgTjDLbrAwhLRgn+YemIxzwPKx8jc+VTlrsO4KI
         y8cJMtRYhyiC6wrytuIsTLRCZakjCv14eIjkmcwtl6qw5sVRaLdhdaYqxPLJUtWmvdoP
         DzHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776786905; x=1777391705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GZJifi5xv/2zNGOHm6PWpOJpaLSfKnpwch9WlPfDXVM=;
        b=BIwoC8ohtn/QkCAeHGtYiN2i+Ln/y8RJFR14p5HCWcFma1CSs7PMwK8eTLn8ya5LN1
         iGBGeuCnHVGOBQMxU+ibcYGwrlpXAeLA9GndNKckwZ8Lloj+LqtZGGl0pqhWD4K86wnT
         auYXlty9u/oepBgcxvEf/ujesDTFBL8mZzEFEKQ3aGDBC8WVp+xHq8CTUAG0JUOwMMJ6
         LQMRhXwnt4KjzwjWyfIMokS4c8LAFI7xFQkKW3hjYh4FLvVrU7IVIkmPmJX3vNLd4AQU
         J5C8dXADS1mrMC+QTY/neQI1W7pe2jPTvckZYkR5M53CVQCmr9gg8Nhel4cTPib0CrG3
         YkOA==
X-Forwarded-Encrypted: i=1; AFNElJ9KXOEHkEn14ajGKAz/W2FNiGGoKyes5sQ8EVZtP/UEvFKyzq3DMfcgAH5BgEGlIGIF7i/F2Qex0Q==@kvack.org
X-Gm-Message-State: AOJu0YyhXnhPtc/Q5lvHKZxFOmG8A6TBlWrVjj5MkOkLMsQ1xbAfZBUI
	/Tr6rZaMM6xIDVHmZDzNaNhoBJKwmXd2pbf9SKPf0ZHJkhqkGblKXQ1IjTtWKNa6lsYVlw7fwxF
	gdtTo5E2jEzJXqIpxZ+b5DQbvyHsF0to=
X-Gm-Gg: AeBDieu+owN7E+GoP78630H8ES7869VWtJl7HFzHJ54acRZK15be+OreOyy+byrvav2
	eE1+eT7iPAGpEz3hfQp9UkfjItLegoTgGsA9FuChUbW76k9UhsiYmBhKXpOFIZNFY7KkDR14o1O
	9xu+rF+oCgvF8p0Blyu54p6uwNaE1/lHx7GYejfOOfhZlvBxW++GlTu722igwFSRZQ4dYC93n8v
	UNMtnFtOpiZsCYGf6W7ahz5qlsc6FfdKXgqbg2zYWatFPAw/s4RDPSGaaoK0+7y/4vRCKxawqP5
	G2DUQan8wbO6ilP2RyYOKDQi0ayZEbCGYrKHB8IdPVuiUDmuag==
X-Received: by 2002:a05:6000:2387:b0:43f:dfc3:555f with SMTP id
 ffacd0b85a97d-43fe3e1f3eemr28962901f8f.43.1776786904997; Tue, 21 Apr 2026
 08:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
In-Reply-To: <20260421121616.3298845-1-haowenchao@xiaomi.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 21 Apr 2026 08:54:51 -0700
X-Gm-Features: AQROBzDF2ZcdhFQzlhJdAP9qpHTl51Ndnh4fL7thLPJceU614blRIDlQ6JBq81w
Message-ID: <CAKEwX=M5YpR0cQrryX_y4pm_BuxyUWZ_8MbhWodwbf1Fe=gzew@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EC4E240014
X-Rspamd-Server: rspam07
X-Stat-Signature: yjj6e3juza9nxgwjqe1oqjq61yrsy6gx
X-Rspam-User: 
X-HE-Tag: 1776786906-365486
X-HE-Meta: U2FsdGVkX18q7T0cYE/ZL6mBjcy4IB938HuXV65AKnozJVaZfy7dFYFRURtlcr1gQiSzHk7vJCbIpf3QiriGAURpzH3c7oB+0mW/0y5UOiHKQ1MNvjfgp/bnMP+soQEKYwpwRApEguoiC7KcIBKiuZzl95zSghR7A//UWFUw9WmoSqH+o6CJhKAVJBXCEoJH2VhibU0fCgYPmj3zKyAbZ441JTW6+fk+2beTp8J/oZEBADSN8Qb9lhskuaqfRyiNjru5sL4mVRM0iHa0kWN+NDxXBoHeKHYKv7OHZdRNAcQlGZkV30Qx1paENSP5415FuEGhyaFjkzucUeKJVzcxDFahpqbAiv2oRkM3JdCJwPIngLXb8xTOgWbFDmFkSz+HnsPaO3beMxbjhUGDd6CzFyStWSx1ZFGwn7pXOUCyZawRDkagnTRz6m8mGGItE2Jf2Qa5oRLMOcZf+zVwQ36Zz201q9DhrNtoIcEGJqU1URIr6OAbuWItj44m4+rUYxRtXemqR+uH7GXdklHSG2XeRncHfBuKRS9xhokkTlCIZ5qcK/u4f2bS8x2PhaC++s+Ge/U9SpsmhveFt8wXTc2tT5PlxNncZ9mbEq/NmLg4GzzJgJpNPUif4MWZGE86s1K8Is7CEut4OZIx1qubQRxAk8IPkqLW1N2Phzx+u6X6MqFB8GP8pB22FszsWAXxyCsmBzi6iYFzKh9rQI2hnhvPpdPOZqvvlpDGrML+xIyAnlW/xfYG5F++hgKhVwox7O2Q1sE4OPYL9HB00sBw9Cp2ebLuuGHVgiV+tDCAVDI+n7wY41UX22oX4WK35twSemqzKxWssA1V97/pMaOgeZkrW2EVJZmXtv7UfiSt118XoYW4b4A+XabPgIZRjwpXfsnt9lqRC6qx/TefBxAB9M3uFJ5dPP73pnUgpKxlSFR9e02SoIifLebtg6rFRHrrqzEA8IdEV2KM1YMNGwfmvlH
 MFNfzhgz
 EfskGCcPp/xngVenbhvEUIWbiawznjGKs7BrmwTjXuhvlEPXLA1regVffgw1rxCIexpd56mx3gJeyorh177mqfq3thRHHoIk4hMphPACXmaNbISWjjECOMf3CJUkM3M8zL55g6prgoOvU3Z+lRrImaSvB52q9+MHI1MHSOBSJSwvtHW5y7RBeMhjNt64qirZ6PfjKUbf2jNm4P+cRo+K/gVegVil6/LYnGyfAqDGsj5XIAiA7VpxHpQVQbi5NOPmIubgPgC4UdItO63ALvKjrq//qQh278tVzSswq1zzsuUTs7okfyRR5H6xXDpidXZKqA+jzRc4N+7K2DSj0W/OiHDg+aPxIav/cNMw5t5RS/ZgTOzk7UFptL244UeP3yrQghVQUkgEyeNeAgTtayme2lPPEzPfUCnxF+6BfMK9zVSHCFB5+WqjSYcvU2A4B8O9659uqBDmVbKdKk9nVOHCmYNo5YqXaHHgH7BCxIL1Z5W0hlbF936mmMxQnlGKBa9XhaQlxr9ScZYP6Hbl+fIWlgtgnWJAcj3lggHhS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 5:16=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> Swap freeing can be expensive when unmapping a VMA containing
> many swap entries. This has been reported to significantly
> delay memory reclamation during Android's low-memory killing,
> especially when multiple processes are terminated to free
> memory, with slot_free() accounting for more than 80% of
> the total cost of freeing swap entries.
>
> Two earlier attempts by Lei and Zhiguo added a new thread in the mm core
> to asynchronously collect and free swap entries [1][2], but the
> design itself is fairly complex.
>
> When anon folios and swap entries are mixed within a
> process, reclaiming anon folios from killed processes
> helps return memory to the system as quickly as possible,
> so that newly launched applications can satisfy their
> memory demands. It is not ideal for swap freeing to block
> anon folio freeing. On the other hand, swap freeing can
> still return memory to the system, although at a slower
> rate due to memory compression.

Is this correct? I don't think we do decompression in
zswap_invalidate() path. We do decompression in zswap_load(), but as a
separate step from zswap_invalidate().

zswap/zsmalloc entry freeing is decoupled from decompression. For
example, on process teardown, we free the zsmalloc memory but never
decompress (if we do then it's a bug to be fixed lol, but I doubt it).

Zsmalloc freeing might not be worth as much bang-for-your-buck wise
compared to anon folio freeing, but if it's "expensive", then I think
that points to a different root-cause: zsmalloc's poor scalability in
the free path.

I've stared at this code path for a bit, because my other patch series
(vswap - see [1]) was reported to display regression on the free path
on the usemem benchmark. And one of the issues was the contention
between compaction (both systemwide compaction, i.e zs_page_migrate,
and zsmalloc's internal compaction, but mostly the former).:

* zs_free read-acquires pool->lock, and compaction write-acquires the
same lock. So the compaction thread will make all zs free-ers wait for
it. I saw this read lock delay when I perfed the free step of usemem.

* If this lock has fair queue-ing semantics (I have not checked), then
if there a compaction is behind a bunch of zs_free in the queue, then
all the subsequent zs_free's ers are blocked :)

* I'm also curious about cache-friendliness of this rwlock, bouncing
across CPUs, if you have multiple processes being torn down
concurrently.

Have you perf-ed process teardown yet? Can I ask you for a perf trace
on this part? I'm not against async zs-freeing (might still be
required after all), but if it's something fixable on the zsmalloc
side, we should probably prioritize that :) Otherwise these swap
freeing workers will exhibit the same poor scalability behavior - we
might be better off because we manage to get rid of bigger chunks of
uncompressed memory first, but we will still be slowed in releasing
the system's and cgroup's (in zswap's case) compressed memory

I'd love to hear more about thoughts from Yosry, Johannes, Sergey and
Minchan too.

