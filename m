Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6EB10F9303
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD2A6B0092; Tue, 31 Mar 2026 16:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D5E6B0095; Tue, 31 Mar 2026 16:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C746B0096; Tue, 31 Mar 2026 16:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1B966B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:58:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 756808B4A3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:58:52 +0000 (UTC)
X-FDA: 84607572504.06.62DB367
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7499F80010
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:58:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cffk4lX7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774990730; a=rsa-sha256;
	cv=pass;
	b=TAZVVF+optLF+Cy2MnCpVlu9jP5zIBpMLFLg1anW0bzbvp8kIga4XQR+DO+OAiN1qR7GZx
	wH7ZhDt+tbzq4MDm7X1GQmFOzSuZqLl5TJFrd1sEGkBg1mu4Mr8+xJo9ZCIKla6kT8vMbY
	kb2eAj5wDWVD7UaRbTAFnb+JOziaO3E=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cffk4lX7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774990730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLY9rDGUzAEWyF/YQZN9r1lSRA7JufMKV4ZLHNJ/vEo=;
	b=Y68Lt2aS1OFXF3wsaYv56dg3RuKNgd9d1HsC4nwI1WHZJnE0T/PkIjjHPMV0zQiOcHiMbs
	XLpKHsiP6vAkbIX+TFc0w1ovaGjm7VSm8bTkXCiFUDHRp75TidGJ6QO2HxBd4w6tYSOU7U
	O9TbYfTVvAW7+5x7N5lRAOdCHMiV9q0=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2bdd40d3c61so4976796eec.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:58:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774990729; cv=none;
        d=google.com; s=arc-20240605;
        b=HuyiVcfG733nGDR0ePYmsZFW+Xe4f3gnIrrlrvUpwG+Z4L/JWJu2X0RbWI2siPw5Y8
         Kg3uhUJ46zntTTgOxZHO2SyW0DjyKfRCxgzeOw3Z72EZIMBMHYwYPnxfGmkLOEeKYPkq
         vEhzu1UVrETxK0ffUqdgG1Bc2VIgl79lYqjWVNoVevGQmj7b1H4rxfg/ELu9ii6wSHIi
         U2HvWwfDLEKDdrcY+IdbymNRjvXtgLh02djz7ZciQy0KnHjWVfv52MXteWR1WiRs18yc
         7QheVvGqtfwAFfZkjwLhM2obsxC6dwIgpKN4sYC30QI6ODXPKDOLykHDxJdLGG8dWlaB
         0VzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uLY9rDGUzAEWyF/YQZN9r1lSRA7JufMKV4ZLHNJ/vEo=;
        fh=H1+OES0CsB1fvHUn71h6l+CkFnZmgmCrFlWtBtGoo18=;
        b=FdseEgbj347CPa4dqrFUEpFmnzs/02cIs9B/8C6dZEbLS5XWnkXJkllqlP84GSBHX4
         PAui9AWTweuDfqdBtbfb2DEGAzxOWhp/q6rSms7eAur2riJzikDJa0GJ7wcIcIOUOv2D
         3iSUqpugYhSrhW9aJFpGWFHzOPXkHlJNsigI91FZ609drgPp+bTlTX4h1nr0CHcnZRy7
         R+TD7DAbQt98NmWHUeWhPtMfGcqu1j+DfuKyWSqPw8jYTh4tsofuIHeXqv2eeoESNy4R
         uAK+Am0vUu6g/ueFK+7fl1x4iy06rGZBCpzT9bTyES395NSCa9vXOJ2b3f2vs9eWvAqE
         ZwnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774990729; x=1775595529; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLY9rDGUzAEWyF/YQZN9r1lSRA7JufMKV4ZLHNJ/vEo=;
        b=Cffk4lX7OnLVYE8YMyt2doOhwE59t+25lbNno7Moyhfzf4IOFvSxjpKrEazQRL1izG
         7TtzkuPhTYE8Jsff07Zo/3z6GFFN9EcqIyVS6ZyOIbBYvww0esq2a+LEUEHHAwZxESmm
         3wDGdvK5tl7duaTrddLcN1XvGbAtZdZ+xhfUa/0mUA1xzk6vqd2XZfRTHhrGaReDD52N
         /7eBxbqWi+jfdsOoD7BOmajvP1iqE2URlOjXOgxKETKe9mcJCmFGwGVfQMkwa+Noo3c/
         K2/yif2++1fal81PrRo6KDfz4SEziSCzzMgqJ9V0mZBgukY8UJHHFhLbnGoQl5oCNJ7Z
         uOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774990729; x=1775595529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uLY9rDGUzAEWyF/YQZN9r1lSRA7JufMKV4ZLHNJ/vEo=;
        b=j8jl8hrH5d8WuroSqVbsrZVr1E56QI/BmPZWgwMmGq0KtXGTyEWrH28B+9piqcAKdj
         2dVWctTngEnxGF2lo5IEjHGhW870KAqS+zOgYriKCT7h469fYAeCvw1PzMUAm/JhrVOO
         ze/3v8cEvc9OfqxfUwGrt1dDmbgwon2f+KDsot/D41GjEc7tnGM23Wgc2D86iwqRombb
         E+MHwilGTkWIqVyGS+NTs9wcXuyDdaVrSdDcG1QxInlna0v9gs+KC53gKjlCP7NutFFo
         TIlOwGShhmDtmtN8IuVnvQrI50lw+4Igm++IybPLnQpZg5QmoHj8BrJ3iaeB7c1d6JBH
         TpVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXppJM3c6R7UoYuTf0lDnk4ncQugJ1faEpzrKuHkQi95P0kuyeFZRwwDIj4zu5Wf9A7vXXdTW4tgA==@kvack.org
X-Gm-Message-State: AOJu0Yz3VetLWKxOlVAN6hCZiUZ4njiLoDvSxhb36hzD2dlt5liTtD6t
	ifpW4zjLrpOxgnl2uvS452RoaeC4zZ6hnV/xITMfWV16+DnHBd7Y5v+EFe+TXDsn5A3nbkB3znO
	yNT1O8uYykGSGTdQqHKp7KQ6Gd2GmMIY=
X-Gm-Gg: ATEYQzwHY96h/6Qo2wkoG2yDjV/qlIEFRrWIYdyRMkjmJQKQtPjmz4Aw3S4GxBwsXMj
	SwInEmOhZeoG77pgiAuK6ji4/bACAXSTAVXe1Y5w/ZFcme/n3ar6OtxtFVkcwd6AzrYWdncdIGl
	8PxRdSlg4byoWkdhbLWQXtw/l0M1GKfBHheeGYLwwlWbgP59IwsbgP5njdA/iJ17Y5bWDR6VOxb
	IUD3Eac33b/oohMgLMYYNZ6uRKbENyoMrRufy8kEbk6/109/OMoot1CpzRUKQkxIfWDfPyBp7IJ
	pmZw5ZwfZAd/RXGAs2U0YzrI4jXOFYNAlBeYTA==
X-Received: by 2002:a05:7300:a90c:b0:2c1:27c:7598 with SMTP id
 5a478bee46e88-2c9330aff2emr450940eec.30.1774990728979; Tue, 31 Mar 2026
 13:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com> <CAO9r8zNaEKDdOxe9yOC0yEgh_obRQTHTo3hJ8t39=UbJ74fVDg@mail.gmail.com>
In-Reply-To: <CAO9r8zNaEKDdOxe9yOC0yEgh_obRQTHTo3hJ8t39=UbJ74fVDg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 31 Mar 2026 13:58:37 -0700
X-Gm-Features: AQROBzA9ZSoIDzkoZbPHpCipWylmpJkNBlGAZiNG_lJB22CqtR9m_YX0aEhKVXA
Message-ID: <CACpmpofnKdfprZG=WHW-jOeeXGF47MYoCJDbkZJnemQU+x4wdw@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7499F80010
X-Stat-Signature: 5ttb146n6to8k97nso1d6bei5f4n8i1w
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774990730-921381
X-HE-Meta: U2FsdGVkX1+9c9WXEhWjRu8dzVA0r1P5X/tWp6EvUIqD8MrJ74AP7t4tquXWAseDqrpYipNZPMPGb9rMqU1ylNRwZdNVnopE7ShaIm7Z6+tuiXnL8Am9QAgHqJJdzX/LNSYmelQmouCpKA8YiNOPtKyxidjOgtVBCnzJ/xUuY8SJFu0YQsF6uexIn4N4MP14QTrVpe1PyzjHWkw1RAysymSmtN6KBw7AnQHPYpmLGwZGOZJnNtPtnglboGVqrHvueUK+SllrbQEK6UkIcRYQTmSaaE8Zxw8tyb0CZP20qGTx8sN5TZ8x1UHojFnZCbRcE+LOMQao6A7Emqnw9ZdhM9Dyvk3zdnkoAaUY/oXofVJEGt28y83agYDHqZLUABJ++khJmakHHYqAKGtWTH1QpDGsb3iQ3tn6hRjCms2cBGTd8XT4rDoB/x7ziHZzE6/gR5kvRZcL5dJKk6fPL33wup2DgKz8DVtwh2YlIHzz4cxVdGOiJKO5h0/kewc7pWMEGc8H8yp3KDAOC1ADR4vsMjag/XyaNrF8eDtP6GbMM096GQzSUg0QQ40DARjYN23evaHx/hEuDlo6jEGx01ffJw5sWNzbfMjASF2ZMazLcVuY3xl/KjfbiemA6zasZDGEP8jpBE6kXmcM7neM3bsMCYVkIagWY4ts7uAwukzBdWOUhvf80PTu8WlbNvUBumT1u+1WP8qQFZS0YIRvheeq9wCindzBwIL93TmapU3fWtfV+97rHiooVxod3PYPr0cs5GMLHss273Ldrny5p0cFMtnhjoHo9fV31GgpylR0CJiXmGjV0Z9aMWlGJJKiPPsYw4MdszFcwWqCBPliZsMKictuNqDGVyhekiZrJ464cVMikuyYdNLkKWJo4j7cQk8qgQdDCCPjQqgfzRIc7vAvsK+LSqSZIaoCJTru+ckbwXJoNEUnrSnAIoMvLMqGYn2g6074WYyWujKq0zHxzoH
 as5vJ6QG
 bnfbrPWsk5epFk1kvjza/nD6W41O176hn4LHlfB4Fm4lM3moLZwhVLctEm/hqD2G6J2d0bTdfunHHjrRL2XxkclQQ7s0qDSP3nlKd37ypx1QCtUi2+n6kt0H2G8ogbivBNBUtCSdxVLDznSmskX2Qi3judYQPJehPlzNxC0SwbI8HQTmnGoQRM6oamj7buGalHhRSeTvRTiFSdJ0dnmyIMg8GKCQxqGJ2QRdDPlgzeRRVDUZPLaEpwIHksuasBCrdP53P+ahp9sMQ6Xzzbvsc6v++/qjbr9qdNDrlYEC86MXFjr556vhxrxER0jzMFfxGrjuhcxoPWbztT7LyU4ES2L4sB/R/ETRuW/ihaGr1Jd5WdniZ/A3R+1PsD6rhva0lgQQFegD/0xpvkPUly9wph6zpMf/9AjczwTf7CFFqWq+uVUNhWtkFuIfFINHZG6soKIieoB5nU5svSUF/xJ43agLkYNbzrY4ZWl0ZKOKitsE/VP8fzMapqd0gsRxIs5YosCErGVCQbtfu+2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 12:23=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Tue, Mar 31, 2026 at 11:34=E2=80=AFAM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > This patchset first removes redundant checks on the acomp_ctx and its
> > "req" member in zswap_cpu_comp_dead().
> >
> > Next, it persists the zswap pool's per-CPU acomp_ctx resources to
> > last until the pool is destroyed. It then simplifies the per-CPU
> > acomp_ctx mutex locking in zswap_compress()/zswap_decompress().
> >
> > Code comments added after allocation and before checking to deallocate
> > the per-CPU acomp_ctx's members, based on expected crypto API return
> > values and zswap changes this patchset makes.
> >
> > Patch 2 is an independent submission of patch 23 from [1], to
> > facilitate merging.
> >
> > [1]: https://patchwork.kernel.org/project/linux-mm/list/?series=3D10466=
77
> >
> > Changes since v2:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > 1) Rebased to mm-unstable as of 3-31-2026 (commit 24e341657c28).
> > 2) Collected Acks.
> >
> > Changes since v1:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > 1) Made the changes to eliminate redundant checks on
> >    acomp_ctx/acomp_ctx->req in zswap_cpu_comp_dead(), per Yosry.
> > 2) Renamed acomp_ctx_dealloc() to acomp_ctx_free(), per Yosry.
> > 3) Incorporated suggestions from Yosry and Sashiko to reset the
> >    acomp_ctx's members to NULL after freeing them, to prevent UAF and
> >    double free issues.
> > 4) Replaced v1's patch 2 with v2's patch 1.
> >
> >
> > Kanchana P. Sridhar (2):
> >   mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
> >   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
>
> Sashiko was able to apply the patches and doesn't seem to find any
> regressions: https://sashiko.dev/#/patchset/20260331183351.29844-1-kancha=
napsridhar2026%40gmail.com.

That's good to know, thanks for confirming Yosry!

