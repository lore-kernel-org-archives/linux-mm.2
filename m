Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985DACD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78856B00B1; Wed,  3 Jun 2026 14:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4F5D6B00B3; Wed,  3 Jun 2026 14:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65226B00B5; Wed,  3 Jun 2026 14:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5AA66B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:34:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4690014056B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:34:17 +0000 (UTC)
X-FDA: 84839451354.02.7B46CFD
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id 39AA02000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:34:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hXRQO6S6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780511655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TH54AoJ4jB9hdDfjGSLbEq+o20RGSclv34XZcGmgbfU=;
	b=8J2AesPO5QKEqnXNKCxrWwHe8ZlNk1f7XVgC7Yuo/I8O1UQvVgLKJKyWYdBRn0pZsv/Jd3
	dZwU+zrlZVfj/VxkQLuOVZ98hvE5DvCyU3VXPAw1xxjnQ6PUhOqlAXkkZoNkos7Txd3k6P
	XXdZPXIpkD1tNfgpJICeG034L75YHtE=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hXRQO6S6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780511655;
	b=GRnsEAMhZg5IGYVx7sTxPrn0oVVAiYIV5orSH4UirxDM4C+KkrWPNMW0v67GZtLrzmPsyh
	nMN4WIQmueOz3dFMgcvtGDNhu491NpoqVYqxu627KwswXye5gEDqx3FYBMmfBst3agQUPB
	uWC+ay3hnYVakqjffdguCPFx+t7bBCI=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45ef41adbc1so3982272f8f.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:34:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780511654; cv=none;
        d=google.com; s=arc-20240605;
        b=NLp4FrVl2W3g2FZ5wELxjjKdy3Jl+x5peGeQDHIcqgvrvvDP9YKSTjVNV7PMqZgjEu
         Q1qDHORAtEiZ5CFUevWfkJXWH1R3xAuTnbXJ3mIdMGfkfMlaX3mUtdbY2sEYxPNSYH/u
         BOYxMQkjHYxQkpSjsjihclosLdpZvrKxXk1FTRnIia7sy5B9Jo+hO5TJ6NQ1UL4eRI3x
         0JyD17fVw5O8QuzXB2Iqq/tv0TF4PeTsrP4b6vwheYM5aVDvKGitmmuWHnt89qUfWlc/
         srAx/l8q/XV2CBc9bqRGS+84OsYKMGf2eQXTCRxgHdOau5tIr1vov8rChFHWm11FARMd
         wQkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TH54AoJ4jB9hdDfjGSLbEq+o20RGSclv34XZcGmgbfU=;
        fh=qBhYu7dvJaOqwVpYFuck4YLiQaXnJiJ6Uw9yWePZ6l8=;
        b=Uz89figUiwwp0S+CuyNq29aiEEIavIVvhDASZonpiNcrDL161zS4b4f2Ut+4RvEyei
         8JjT0IH40qv8lW3Wk/oKfoZIVoKpWDau2eR1z7bNO537N2bv0RB3R5HGJDsF5zZ0p6/q
         I0b514mlCJgc8rJZLZHRjC+9q2rVJHqBv9qg5gCYw/zjlAUJmnflyry7bI+k89pInU/R
         jWyao6r4jTwvbpkR+Bxt/FRGU9qXyzYWvqWQLKsGIWuOLWDbFUw+P1jurDj3OVnNsbmp
         J6YbsHQ/upYkKJU32N/l2IFzE4/715H4Ix7utUz/ipV4azGIzJRST8SNlQ9MBbH4gJWq
         ZpZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780511654; x=1781116454; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TH54AoJ4jB9hdDfjGSLbEq+o20RGSclv34XZcGmgbfU=;
        b=hXRQO6S65mTFJHvdnO8T4uCbijeMh4o1T1zz+rUCiony7wJrYvukdpKPFaABY+/Tx5
         qKJLMMWYWSU9T7gms2xCDfw6ZKoSJwDjzyJ3hiTp8a+rBwrPGQSv9qX5YQtkLH7F7G2a
         hsMNDmesvWuxskUdnTBl2h+Rt9elPrJsYoLFQnWqYfm6WLi7/Qa1CL3cJeMSn5Ixk/uT
         Yn4jCS5F+IoByFj6WBf0aPCh7nqPWNTrTRwULgj0hFpI9oiFn85LL13mB7kEbIDafe2d
         zfvRWAprXRBA5TflvTLBO/RGCjUsN39yTM3jTm42nhSx5uVHGy8q/WO1JRr4hBIuP6wJ
         aDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780511654; x=1781116454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TH54AoJ4jB9hdDfjGSLbEq+o20RGSclv34XZcGmgbfU=;
        b=sCT6mxcf5MInwFFc7fzUGYS4AmppjGebSxYUAfGlL/fDezZjWX+N+ElUUBTvM+JLaO
         xd6L1OHZA3aUg98Infcfwh6vtOKaIhoQLOUBNdYBfVGs/IZg4rZ6VPrCzjWituHSpOxq
         U+LnvP0pEmCNy6YyvE4yXzyUfsbZX9/P+OIIhi4Xk4xmIVrxOMLfg9uYnI2RS0X+ptcx
         jHQQHduTXJltznY27JFAi/OQdzpAe14K3/eiqK3HCr4X/qJ+Uh/SiFD4RyJH7M6B+LDU
         Dg4cV6P06KdLe4N9QqsLakG7yOCdgTc34Lj+c0L6AjNCL+gBEQQiRn+kGcAERU/W8a4N
         fMhA==
X-Forwarded-Encrypted: i=1; AFNElJ+qgoPa/lpzRVpVzqUEKrdkQ7doCDGvgVa4kjTStAVCip070Wf8HMjP42+nJOfrJPmeudn5URCmgw==@kvack.org
X-Gm-Message-State: AOJu0YwmqZ+mx6KcgA7NAqnqi4zWpqpuZQbBWSUgZfOY8RLICqCN7Jbt
	6XqTtwDbML1+qH4JKRYc3nA6yc+rOtNU8j/gDhwloRvRsyQQCL269r7soGNBoW4vGSO4ujqEYKY
	Q2jmxe6K06w86VK513YacPdLbX14LuoQ=
X-Gm-Gg: Acq92OGZxPxc4T+o0x2brSEJ6R6diQ4NxeETtweeuiOwB4Kdi7Waohq7et1ssmCbVAb
	CEVF1lu9IyjBWVukIluihIIcPhfMMccAFsRFUAGe+5/QTk0inqosos6NQYZLKCcD/a4sjc2efqB
	SLn00ep4l6lo8RVTB7MtaN6L6WJGYzZW4REWmSSrJdCGPSnKVsUlUGHIULtsFfX2rG6KUPKZl/2
	ykMbJXyfSuHE71GPnSpVUBgxru5X+bzCrUZrM3oLbnkr7CQBNJEOKWM9D5VMeYfihlSrvmJp7os
	KQT1E6A/H95PMcHOy7O+K44jfzKy44KL6p1CTZK43X7OK8DIeA==
X-Received: by 2002:a05:6000:60a:b0:45e:f4f7:7cad with SMTP id
 ffacd0b85a97d-46021980b94mr6753458f8f.39.1780511653643; Wed, 03 Jun 2026
 11:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com> <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
 <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
In-Reply-To: <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Jun 2026 11:34:00 -0700
X-Gm-Features: AVHnY4LBOBaSAnmMiBIxd2EE7a4jNLcFpjuYk3Z2E2kzH2esEzwrCqzQSkwrWXY
Message-ID: <CAKEwX=NQUqqrM9vdYE2KhWEZx-YwPc7YPhfz7xaBrGVDf824bA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 39AA02000E
X-Stat-Signature: uz1kfh9wmra1bdtke3qjky3ijtzetpnu
X-Rspam-User: 
X-HE-Tag: 1780511654-799639
X-HE-Meta: U2FsdGVkX1+A04klKCJ/x9GFHlTqzBQkdUGfQfMKRgUnIAgYHt19g41jgW1GPJrAgqdxY4Q/fw1eBjNgW2JaLz/JhDrU99B30P65rYzIYtCROHrdMB4hKlEpSxIZdc4x64o+sJ+t6YLSy1PRPKM+uk7lpUFIpUn4dw7hWk0x8ArxpBkiqaDveBUqkAJrl8lDEtRlGM0GPQLq/I/pB/sJqbn4IjcoSvUCJKynQOvlGMsNfIUz6mX1HUJ0VLa3fcNZnpiHvr/W5ul2ZU74YSB8GUVQOyt3dde7cKTJRqpvDmTm+wwVtBxawmkPEb6dLU6E2s/wgQF3UGcljrI38NC0B8iy5iBN48sWMsY3/q606HToSGgBIwylby/RHnfEkiz/wK/JdNNK+E7XREcyowcGeHAlNA644EIo4cDq56XIETz0WF4I1Z5FjXxXFjMkbwwpKT1xO5ZlAlc9/MafuFNM48r7f2CULZd9drbRqfmGSKXx272An69AGHqg1Nm8832r/Wk9wXlln4u6mLZ8XAg02ajUyGSmJnDolcqiOwttv8jNYuOUJ1AcBQP4bvl5Q8IfVqLcAVcrwLdDFzTyegL/lZJEo5P6B1fttzJIxyd6aIb2jCtlt7cHmYhbEMdEygEzBZFy2HMZRvh5SmLJDBW80217zc11W7fql2euWMeso4t0MMdUOX77S3Cu/653gwYQKdVmEIkX3p3u4pW68a1doFjkinxZCV+U+6D2i3n/UgnbW93xoNfah4Cgi9XVr70qvw5kPLmSKYduDrN3ZZmUoXL0HQpbJLKsIFdqQCZBU1808/Q5x/KbDNtr3UqEmphUsKIyTFoUsXbQngLj3S1zsxt3vPmlDhPBK3hVmL0azYkGeMqxgvXJiIygyzV/63USpFya05eHD9+jLFwyBNbtGRmVBthodtw5NrHVz47jw1ebqRxxchiFaxs3XdWvjSAF9C7wGwTnk4NNkzYT3zp
 SSBdYIzr
 IGvumStLf+PDg0KxhzZJARksZTG3DfnYrwP0kMIZhTCYT61EViun34EPY7r0a+OZI9jxliW00fhh0RDdZRZuzDpbojxfJXvL2oUhb2cgeK9Bu2mKgMI4Nza3NPgHr0THcL8tytI2/rV5NZ6NlYvNY085iathvIMinyXTGdnqWqDhfonnoE8OB5uwO2Q9xVUNP1toEC8l7GEzQw+eSkyaLJaTwssBEcbKg3z3wMR3uTRvudFv80YD+xXOubL5mX46zULB9Tm3bX8o/gQd4SbzgOFQYCfbrYnp/7QF5zVrwt4wzEts6mHDGbR0hj9z4sgvv/4Ic9uHzkTqnL7OrUDULjvDgvT1l5Alm+rPvM7mQgiN8b0kuENGvqt/boeBQkWWs13PZAaV9OrV08sa55ndXftisKplLwwYcUh/XR/4O0nRgbH+EZ9sD/95m4s7zCECSjw0IeFA0MUC0MyXCuQVkqrFP6PQv+U/la2yhyIxI15Pv3cLZygNFWiyr9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 11:26=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > Is the main difference that we are scanning in batches here? I thin=
k we
> > > > can have shrink_memcg() do that too. If anything, it might make the
> > > > shrinker more efficient. Over-reclaim is ofc a concern, and especia=
lly
> > > > in the zswap_store() path as the overhead can be noticeable. Maybe =
we
> > > > can parameterize the batch size based on the code path.
> > > >
> > > > Nhat, what do you think?
> > >
> > > Nhat, since we now have the referenced-based second chance algorithm,
> > > should we consider doing batch writeback for shrink_memcg() as well?
> >
> > I just take a look at shrink_memcg() and realized it's reclaiming one
> > page at a time. Thanks for the reminder - I hated it.
> >
> > Please batchify it if it makes your life easier :) We don't reclaim
> > "just one page/object" anywhere else in the reclaim path, Sure, it
> > adds a bit of latency to zswap_store() if we reached cgroup limit, but
> > IMHO if we hit zswap.max limit at zswap_store() time, that is already
> > the slowest of slow path that you should have avoided with proactive
> > reclaim/zswap shrinker in the first place. And, setting zswap.max does
> > not make sense to me in the first place (I can write a whole essay
> > about it).
>
> Should we batchify shrink_memcg() from the shrinker and background
> writeback, but leave the synchronous zswap_store() path to reclaim one
> page for this series at least to avoid potential regressions?
>
> I think this change specifically needs more intensive testing (vs the
> other code paths).

I'm fine with having shrink_memcg() takes a batch_size argument for now :)

I suspect not a lot of people invokes the shrink_memcg() synchronous
path in zswap store though. Setting zswap.max is hard (as it involves
guessing compression ratio ahead of time) and induces quite a bit of
overhead (obj_cgroup_may_zswap() does a force flush for every store if
you set zswap.max to a value other than 0 and max).

