Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8F1CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699526B0088; Thu,  4 Jun 2026 01:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649D26B0093; Thu,  4 Jun 2026 01:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586F36B0095; Thu,  4 Jun 2026 01:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47A276B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:36:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB1CA16291F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:36:22 +0000 (UTC)
X-FDA: 84841119804.13.2F899B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 09A3D1C0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:36:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwRV0eD2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780551381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlf6gZ7zE0nZZVqddnEN3mtWYxn26ImLM+nzUagCUEc=;
	b=sJsbDpDMamIf491Z5xO40jU/alRPty/65UKR3UvrZo3a9GygwPnzNZAxiBARQq20xrwFv1
	MBAnk/8wPW8ObZ44rvhE833PQfcM/e3Dp4Nw/2tr7T1i+wq9OByHbP3h7l0AMjC/4Mal9I
	Fv/FOKhjm/50qvBFa4rdHntuZLXVeHk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwRV0eD2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780551381;
	b=sake3p72vkcO/dw5TUVAvWsrx+KltPKGkGtziyM2a+42u2Nwg1Ur3EqEV46ZDb5ruUmWvM
	SoT6rl2wKxfeKTUG+G8cQcvVcL1TFvRdzwToOypzq4IY0qlkUWTI98azDxwYS6yrIHtikn
	14Yp4sSkY7+uLJ0s2wSTVEKyuXjr4JA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1287C43D8E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C8B1F0089B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780551379;
	bh=hlf6gZ7zE0nZZVqddnEN3mtWYxn26ImLM+nzUagCUEc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XwRV0eD2mP3KPr7RZkEfnvYCGUrsjbiPIQZYk9xpDp5lqBMHUJ4b7FXfPUH99wSC1
	 w815Qu9kAKBgRkZBqOGFybdtc+cvpVNV4lUM3yZ8LJUipzdRpcJSpkepHqK69p3RkI
	 8Fn/PMW0aph95zGIThx6M4OeODH4XOf/jhRxnIRhYgTVziJUr/dj4osCOYygmz3EpD
	 CatAHI8bo+2WXB4fBMtaFOUKEOMiKhlyiwSaY2FVID6E0jiIV97z3HwGgkpcfPMQR4
	 9sBrEQlxvfkI5vhyWAp321cqPo/R0JHYH9h84fnHD+g2Rr1BhDmvshLwvlguw7hoj/
	 D8G60UKBgs+dA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bec354815b9so22758566b.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 22:36:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/F6nZIDgG28Qh76wlYnSHjXlk+aSpzllPM29CCoWF0gIfnMOjgkXk893qH4BuohtGadd7Xyl4X1w==@kvack.org
X-Gm-Message-State: AOJu0YwvyCpi/nPlHrtghYbePxsbwKRt9tlX3aJFzjoAnUcUqus4V7fI
	j4dnHOhEP5PMfJN3AboalL6R3ZhdA2I70XPVZLRMZcZSFLNXF2sHobmn7pGrcXFlnkW7HxpXyun
	MgdCyc3sRjAylXtxNcLcO38kL4HHBMJY=
X-Received: by 2002:a17:907:c289:b0:bef:87ca:aec5 with SMTP id
 a640c23a62f3a-bf0afaf5209mr309828866b.47.1780551378864; Wed, 03 Jun 2026
 22:36:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com> <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com> <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
In-Reply-To: <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 22:36:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
X-Gm-Features: AVHnY4IE7N3d59FLndV-s7gDFevntutRjRoeBw3qu7WJHZARyl3yLsqSevGQ5pQ
Message-ID: <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, shakeel.butt@linux.dev, 
	mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09A3D1C0006
X-Stat-Signature: 9ubz53w57qzqwxcb3bbsqepw33owiq1d
X-Rspam-User: 
X-HE-Tag: 1780551380-820815
X-HE-Meta: U2FsdGVkX1/F1M0f9lu98eemjgcuTuwYdjwAWCbMU0mbEFUVSKWvWjOyWPk/k/QGE9vr+ho/p3f7pZvMB0oT/YFedpANT2t9cK5VbgjLnI+TyIJiDNWpyumzOSF9raCPOn6Z1Q11KUOOK7ZSfdIw7rxWjBjIsKZihNQEtOFLPait0gz2PXUq6RG4SLESn3nmFb1EqteUJLg43zkkzZGDBPRGo2Y8dD9baa5T6T2YU6m3AOrYcbwxA+fyzp03CCg7YhzjFATlN9Ie3Z/CL8KiuEZcj3knV1u10s4jTr2z2YROB3NAivRtMLhu5LzXABKWxOpwFUlzThvMNADRbdnI1LmBldiYN85dEkxlf4ugG383XULnm/vAyYseXZlg15mnGdtRbWcwGnATc7JugBsvYBG9XgrwIIzF+xLrJUEclU6vuphP9D6mMH6eiKz4nOHwARYzPa+TGAd46YhVDen+cn+9M8/AYHLxarq4zD2ajCt3aUmeki4FWv6cVzB0JaXD8M217tM8lNbz3DDWjR3s8pyi7uRAsEuYhEf8fhs7YnHy89Fr0fn7OlLNS3flUFfpVkbiD7Pj1rnrO3CUhNvp9xojilX+oePVyggUfewcIfGenBjrmj475aNGmSFke9YDTC70ZIBSWk74cIj85MkE7H7pZq4eKUY5crlHOvcLACbnO+6iUT+AteITAp7sZarksUrbgD4EkTcHMICeq/tg7cZIHrpQQd9XquWBpJnyVG+2Tz21tYamp57NQQYBPsRiOIY1Lrw1194ItDgeOtSU7ZUM9fvNGhdV9ip7A5lg38xCDDoPnHuvBjeZSTYub+9uESwhUvwFvuYqCkGWuI7DVs8hsZTwy/hDufU39kxfpePb1GbZNzjUqrz0gWUrcjwTHnWqcASQdk5x+Wb4kUeqMN+Kv6mIMygQ0g2EwiCsnvd0P52mKYy+RrKiy3RWHpikf3K7Iyw/agXNuuR8GQ1
 wxNoRbar
 6ceaFfwcaTnm5jk5vPxqu2T+IntQ3cIuCiIFt8usZYBKLlG+kIKeYNTm8B0I23xN9mzFgNoMJWfVGE3f9jPf6eLiNcHngyO+oM+xkSEVq6d0+SohInsP5RhCoyzkNEZ1vHsvpR3WPJMp7phJp8IIpAaZk/39c8pPMcs58vVYBXODGMj1QTXLD5AJy+utCeW8iabnv8mYC6EjYiHy2YciAUgDWZHWgQlVWeLS9PTqxnASEmnKzwp+oKQoxxzYIbkZaWIGr2rQWFWGnLcskKY1tQDws6MxNZWuDoL/LenObKqPFgd5xu98hX8/e9KQjJid0IKqKkXoehTBrFhRVL1G8U8RdnNpM7K6nIzeT8HoGeY4aiA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> But doesn't it make more sense to specify the compressed size, which is
> >> ultimately the amount of memory you actually want to reclaim.
> >>
> >
> > I personally prefer compressed size to pre-compressed size. That's
> > kinda what user cares about, no?
> >
> > One thing we can do is let users prescribe a compressed size, but
> > internally, we can multiply that by the average compression ratio.
> > That gives us a guesstimate of how many pages we need to reclaim, and
> > you can follow the rest of your implementation as is (perhaps with
> > short-circuit when we reach the goal with fewer pages reclaimed).
>
> Got it. I will change it to use the compressed size in the next version.
>
> Yosry, Nhat, should we continue using the zswap_writeback_only key to
> trigger proactive writeback?

I *really* want the memcg maintainers to chime in here, it's
ultimately their call.

Michal? Johannes? Shakeel? Roman? Anyone? :D

