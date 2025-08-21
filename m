Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963F0CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39F48E000A; Thu, 21 Aug 2025 12:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E111A8E0001; Thu, 21 Aug 2025 12:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E6C8E000A; Thu, 21 Aug 2025 12:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C46898E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:18:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77C73B904D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:18:47 +0000 (UTC)
X-FDA: 83801273094.19.0A97D55
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9A9BC160004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:18:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lFdHfLnB;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755793125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/kgWz84JgBVeLVTDbEVdswXhuU3eGT9Q6c09Y/7GpI=;
	b=lxYZqDpzp1FmWrwx2hpwkqc4ok4N857ETivd0/ZY1T8r6fS28t3TAFI/i0q8/UCDrHmjcT
	Dt/1XkMASTImsbMdBxVqWwt6IFnvLX9NdVqJtbpN5Wk4LVT6sSStfNH2RA3dvtTQmrNIKm
	O49gLHqC/M2N2c0YnqNf3BIVFE0pShI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lFdHfLnB;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755793125; a=rsa-sha256;
	cv=none;
	b=0FD4CI2ZwfuG0OuM+Dvimh5V8Us/SYVaJ/2VoACxJ9h/hkrb/xFGiZ+J2pV/aJoUvUkfmh
	noDZxhHamscpbwyX+7pOk9NGO2XElup1cujPnvTTRdnTROencmtiLU2GKMzVD8oFtsx56K
	O+2nWjh+sVgA5I/ItzOlzxLgkK6qUKQ=
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-61c13125538so306775eaf.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755793124; x=1756397924; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/kgWz84JgBVeLVTDbEVdswXhuU3eGT9Q6c09Y/7GpI=;
        b=lFdHfLnBWgp/No2XkHRgXVXuDrVL/3GVzNG4qdJbH5aHBS8ckOs4gN5Ybj0ZFMwhGv
         N0WIiFFfHLIXQnSLxu/Bsmc6wa57eRpdZBEvVZU45lHaerH18+Vmcj+qlYDX1MOFxVGR
         quye/N+gvGlBnBYEg6I/TsDXVJ7DIkg4iEE45EL7zcUmGcuuKnwdBslLt/Bl48TEUAd7
         BAhPxRykxZwDt+EJ6hrUGlTG2hpxsR8vsLlH7Gev0SJXrkebECkmMvHPfvVJh7BhHBVs
         yP9M0S2kfYd+QaEHH2wS7cgJEZYjpo+YhYsXqpO8KQenAsqlxaHVzDzYWWCvqUW0nC3b
         SZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755793124; x=1756397924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2/kgWz84JgBVeLVTDbEVdswXhuU3eGT9Q6c09Y/7GpI=;
        b=eLnfXaSS97OX7kTgwpM7tTskW63VHbe8BCqCb7G2YTkhuLJnbDSKqhAbP+hxh5pFa2
         B1vcSnNmx2LzZuoyWXjuELL/3DxRbKlZEWuyKomn5W84UILgrC4xVsBANue9GGP+CEm3
         hii+/AAghzGySgJWwADD+7sgK2VmS/OXTW0kNC7SYuM3SXfiG+H6hqysTrbqu0HYU7ut
         Nm82Mgh5/ihx+qBMjFBJyvarGBCNJZN5l7NpeKS6dYGszBYI+XYknB14tt2IHlB46gHE
         TxES6KR7rE2xGcktHhY2Yx3rJIVRxsyGCyc4k7qR79b1rrpdcxFboSzHM0wXeheY/u3S
         /hBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmT0OWUA1YZ3rtRMVwyymeTYxy4qcVVmXcEH3BTQ+ZCaWrB5EhYnE26C7LD8k3J2vQG0eExtsnmQ==@kvack.org
X-Gm-Message-State: AOJu0YxwpYj4fbtR9gkUBWAq2+2XrXQzl6mZxtSynCSIQwEDcTHBzETn
	3XV99/mYoxkspNCcXPK1+DigcxRk+X/SqG/Np1oEMsuQIEzXg9Shp3Z9IlJbJh+W+UKhnO+adcd
	MEbfUElPqi0iNlJihpBouKFHRfdOLD9ZHG0sI
X-Gm-Gg: ASbGncuy5r2CfwMj5ZE1yKeN8B0hdnvlh7Z52r0LEYySN7G7s4LMmt1uxu7V8TXheFj
	5nbSL5Sgz5Lng2zF8YB4FooM8VwinJFxoGEAaJSec11j730MPPjoUfN10fqQpzWSd/vMnpWmrIM
	LI57qQiw4SHuwNdPUWs8mEXwA581eL+LR9HuaGWHHI4ZJoH/Bb5OUYy6Q9TnnLsIkkwvnnj0M0/
	7LJ
X-Google-Smtp-Source: AGHT+IGxmLuafPwAwDkyNnqlueog5FlfgG/j27pU5nhQ2cB04Y8TJM9Suwdckz/XzevG80YdbjM0/bKtFAjNu506HBg=
X-Received: by 2002:a05:6820:1c99:b0:61c:4fa:7465 with SMTP id
 006d021491bc7-61dab06512emr1351756eaf.0.1755793124399; Thu, 21 Aug 2025
 09:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <CABFDxMHgOPt5zx3q=KRxGGfp86R4V0AgO+FrHDftqLYoG20BWw@mail.gmail.com>
 <20250821155833.57597-1-sj@kernel.org>
In-Reply-To: <20250821155833.57597-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 22 Aug 2025 01:18:32 +0900
X-Gm-Features: Ac12FXzi3h9xpcGpuOkzdRydRGIYtRmhUHBmyrmZ9RELoX71HPL9qduVXxKXs_E
Message-ID: <CABFDxMFy18rb3K0NYYKifsBVD8MoA=O5Aj=g+KS5gR1R9GCEdQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at
 first charge window
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9A9BC160004
X-Stat-Signature: rcq3cbra5zzgucbhknhbttsj4fxs75rr
X-Rspam-User: 
X-HE-Tag: 1755793125-390111
X-HE-Meta: U2FsdGVkX1+JSXxsfLKPv8jwsZJxKNAlGf0qTbkE/1xuZNf4oh9CXypKhyP6WrmQS5KzYd8X5Lx7VbCqDgk1QW8NECz//BPYowuE1P/r7e4wdo6qsEXyjqM8LqOL/itVAX6n9wYNkimsmy8p3QCxk7iWEywhNxB4CVei3QVCPzYhqp/iH/l/cCbrmfOlG/mHgWrBn/e9BMUQWmzgoXH2FbwaRc2fOE2gZebEfjCx/Xly6hvgx9icncHjU0DDNhuMTtiKFIPxt7peSri2uysIJ52tU2W6ZmmtIIuneahSxoPTNVUwpFmgy21K84pGIbGz5u2fdxGL/dm46i5fK8B5cZIm/RiCkUmJWAcUkHrjQBO5isXioSDFjmfBu3UJXdvL5kUtGeEQcnml3y+jA+OUDRfxWiTyH0pN6yWn6CX0CHAabbvBFUWNRTgPQFcIeM+cSQaBeV0Fij9EvGgc93KKJ4qKVwl/Ep3TCwLoiX0F/OsJLEWaVybnQPiyT9nlSNVPge6RxKoB+c9CEEXNiSvtIRiwjF2c3jE3AA946/pUJVYpB3XGlOanZmDpvl7fFtArc2wBXiQ/8lKHnChu1Clo447Q+3Jm/CBE/0y4R38aNekfV4SLYfCWGxu4m+NGgCcBv1DlusHyigskucnCR8/ewUyMLK/2hpCML6sq9+XWdirJa71ZLJJ1y1oj3fqmzhNO9V+xtn6Nt1mZqzA9GPFHJ1JWdqGJNok3IyGkb5p0/kuUk+BmSqmXANvZMQGj22rwjLUxvGyO2UFQxFTq1oIxkUS+Ie91UivtPlr58edvyCe/STCIWj2XoITFoRZV1rIE+LxfRR6839tCEGusBIcoFdDRQvmumKFva5x6rP3K7M17YMjNc/jD+NsWGVjxLIvTCo1p5sb5DiwMsZmOZOD1oWGCBYot5Ub2p7huHYgt8NdFrjGn2pbMYb6jjRTBSrwiwqFfirGlYwQvNlD4iOM
 RmkJdRQ/
 hIUR6QYfDmh7JpXDWaxpWXiQCBIAJYsy1Qof2kH5TEaV6YqtjAVzDw7GQWJntiZAe8Pk0PQP69KHmw8iCHNzQCxOnKLJDzeS7El94TGTN7pVRrYAAulRaLPtCCZnadwAAGSmU9arpNAGXYlkdM6zkIy/x/BjDfbMn92UaMqUfaPMA1Z86P1H8qliWiCaro9+oy/9xziQWVle8tfNBJwBrNa4LGYyTaKtZDr7hsBmzzEWf983tF00jfywJHK3G+15wUaZuCFWPdYvYPOy38ZbBsnmNmGAwK8pmR6NeNKt+9bLUhRoRyZje98o+l0Ba9wuqSupX88phucQ23WX0ApqMThLyVUfN8ULP/3tEdvwTmz2cS0LRM/oipp2vQvmK3E0E67ZEnSu6EsFwDLd02h3WFk5lsNpkXhZ5fSGSqkeLhL5cCkSwcmKXcinjrsORZ8nKPc+u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 12:58=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> On Thu, 21 Aug 2025 20:06:58 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > On Thu, Aug 21, 2025 at 2:41=E2=80=AFPM SeongJae Park <sj@kernel.org> w=
rote:
> [...]
> > > Let's restart.  Could you please rewrite the commit log for this patc=
h and send
> > > the draft as a reply to this?
> > >
> > > We can further discuss on the new draft if it has more things to impr=
ove.  And
> > > once the discussion is finalized, you can post v4 of this patch with =
the
> > > updated commit message.
> >
> > Good Idea. This is the draft for commit message. Also, Thank you for
> > your patience and understanding.
>
> Thank you for accepting my humble suggestion.
>
> >
> > Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> > include/linux/jiffies.h
> >
> > /*
> >  * Have the 32 bit jiffies value wrap 5 minutes after boot
> >  * so jiffies wrap bugs show up earlier.
> >  */
> >  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> >
> > And jiffies comparison help functions cast unsigned value to signed to
> > cover wraparound
> >
> >  #define time_after_eq(a,b) \
> >   (typecheck(unsigned long, a) && \
> >   typecheck(unsigned long, b) && \
> >   ((long)((a) - (b)) >=3D 0))
> >
> > When quota->charged_from is initialized to 0, time_after_eq() can incor=
rectly
> > return FALSE even after reset_interval has elapsed. This occurs when
> > (jiffies - reset_interval) produces a value with MSB=3D1, which is inte=
rpreted
> > as negative in signed arithmetic.
> >
> > This issue primarily affects 32-bit systems because:
> > On 64-bit systems: MSB=3D1 values occur after ~292 million years from b=
oot
> > (assuming HZ=3D1000), almost impossible.
> >
> > On 32-bit systems: MSB=3D1 values occur during the first 5 minutes afte=
r boot,
> > and the second half of every jiffies wraparound cycle, starting from da=
y 25
> > (assuming HZ=3D1000)
> >
> > When above unexpected FALSE return from time_after_eq() occurs, the
> > charging window will not reset. The user impact depends on esz value
> > at that time.
> >
> > If esz is 0, scheme ignores configured quotas and runs without any
> > limits.
> >
> > If esz is not 0, scheme stops working once the quota is exhausted. It
> > remains until the charging window finally resets.
> >
> > So, change quota->charged_from to jiffies at damos_adjust_quota() when
> > it is considered as the first charge window. By this change, we can avo=
id
> > unexpected FALSE return from time_after_eq()
>
> This new draft looks good to me.  I find nothing to further modify.  Coul=
d you
> please send v3 of this patch with the above commit log?

I'm really glad to hear that! Your thoughtful comments really brought
this together.

>
> Thanks,
> SJ
>
> [...]

Best Regards
Sang-Heon Jeon

