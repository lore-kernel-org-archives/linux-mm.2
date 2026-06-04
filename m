Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E7DCCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A4346B008C; Thu,  4 Jun 2026 01:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B316B0092; Thu,  4 Jun 2026 01:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8AC6B0093; Thu,  4 Jun 2026 01:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BC336B008C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:34:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45C62C1BAB
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:34:33 +0000 (UTC)
X-FDA: 84841115226.18.D38F985
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7D0731C000A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:34:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxW4QK6l;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780551271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBjgi3h65nFOda/5nltf0/WjlV3uis7HxPyve8TgC1A=;
	b=E8l4KMMerzl5EUA4toMeZTMEQ+JwEkSZnsi0xS2iI7/XSNrdyVMI/wYQhCUk+W1gw/Vw1y
	wqCOehCf1MGNIrzg7i9eorHVOBTUtGv5LFFovGhmPcoVE1JteHR2KpZg7SQJLikhRjwZNL
	IF6tCekX/ijMb/9zzdFJZIqptV6sTZQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxW4QK6l;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780551271;
	b=xEas2vFYGWUcelh5Yiitr/UDyIDOEfkr46+GwtLZi3kQe+jbItHGffiqVcFn6lc5xNouBM
	Ex0Rbk6PCQ9+6gpUpjFTKyqp/nDCtxoLup8lJFvreQ5L5xkT4LO3hdvT/kg+wPfYV4Ol6p
	N6wLbMTvdZYLlxin2GOvZyEEJSVeZQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2633B60219
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8F11F008A1
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780551270;
	bh=dBjgi3h65nFOda/5nltf0/WjlV3uis7HxPyve8TgC1A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IxW4QK6ls26ShtfRGvRr2x2HcKcyVcz1DPWUOMq1tHyNNvLdnaBWG/e5h3c4wvy99
	 KSF+Sf1Z+1gfhGpMUHohUTifmkOUeu+bx/Fa17b+Gp0SbL2jCMde1RGLp1EOb6vkG/
	 yrca4otWvs1k3I9lBeifqV46S5F87O8j0GRzQjFJ5pp39tcAcxRhCRtI6xE/Vy7PfF
	 lJM04L/X7ll7kEf5wItZH82axyFQ/o6YeQ4RflDEkLzXfLuhQbk7paIBrPixNaC2Lb
	 ei2uav4+KTiqZs+xiWrzD2fC9p00Ch6ihJaa5FTiKcOb3mGC5f6sDiKwRty7Iqp7pU
	 epc8D2iBZwMyg==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-68be16c61d1so487734a12.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 22:34:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/LoixrxUGhQc5bzNMPjgmo9LFeVXPmO6xkoZuvPLfnozk2NoqFamaX9T1dRfM2VO/4erqtzqW8kQ==@kvack.org
X-Gm-Message-State: AOJu0YzOIvI47y9r6HQoiKE3fDpfDMEdNWMrVWqhowoJmzUyhMQXLn11
	xrtKYlCSFd9yQBWNlTaiIxLx2ROnblp1w5Rhz4Yz/VhiOzGa47HyUjGXYvPL+VNFKWIBuwRm69B
	jXiWR06VXpJa4Xiw/UmGcKIifW58zS3k=
X-Received: by 2002:a17:907:7f9e:b0:bec:2d9f:2aa7 with SMTP id
 a640c23a62f3a-bf0b2bd07edmr353177466b.24.1780551269748; Wed, 03 Jun 2026
 22:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com> <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com> <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com> <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
In-Reply-To: <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 22:34:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
X-Gm-Features: AVHnY4Ku_FxWJkBn8j4XFqE3NCwF4f-sPcyoSpNO4PUEnd9_caFmKAyU5mggsGc
Message-ID: <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7D0731C000A
X-Stat-Signature: pxgum478ofif9oc834umb7psf7js1ywt
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780551271-810686
X-HE-Meta: U2FsdGVkX1+m7UKrEQAtRVbpilnba+KSW78nnaue+uhOkExrQWaQZRttDVad3814SNpZJ2wcZO1oC8Cbjt62ePAD0RSf31WMTOhAF0aLD20TGUIMpxpR+pFmc8bma0i2P3d7MK3I9HwgYh7zZ1a7Nn94gjWFVo5y/3EfSy+9AExXuWLpVKIUcF6dp2Ove7elnCjGeypL7s9HfAnPlUUsQMjIk25w0Guv2Q+3/UjRR+CBkVfPaCuDUT1CV0H7JMOvQLKuwS5S2cVRVMoIDKQuKSo9G4Z6B2+ICzRsUo4o9DB2yJfW/g3JZuGfPDCpuB9AIVEovFTrX5QNZ4zA6JZm84fwUm2W4sZuE9ZhXFKHNiTokFt9IyljGgp2GHgHr4DJ+6/hJYkva/KKdO9NLC7jK3VE+vgj/HwPzVpTvOPOBKRhZG+MXnA+Bx+BHjkaR5Q6GuCE3MPOsqTB8ekqr4tT0iXwKmCAsccADy2lsEHJ0HAF3b3UQQQ52piN2aeT3uiAVMZAAhSpT1YeKzY0/fM6CbGVp3KrkZE2OfGnznKD6BIV4TVCr/yjRqijTLLDYLtQWpBGZy+UO4MKm+mFaLAsdfbegZnXvcQYdQyTKlMe3D7uqqh+PXQ/KTx2QxBuazP0ZwtN08PV2/JUs2+SWkTyuEFr1KldBcUHnVWItYxHJiK8k5a5QkY6kh6duCTa6Na0eV/3LzAIJY9uwemB3nCEgr8ZI9Sy862aPyuYnMyMaNd6DgXtHmmob3yXkEkupFVWyGN0KczB/Zsae109L4q+NkydMeAGHgFqBGvk7lAfNxn+vxTsHXq/FCoQMjj6iUR5s9effDpDSb/GV6Bbi5M0g1++xvMhjXmNSj7OetxcHrEDWILVYbl+esWg9s5Kv6tWqInmFDN1EYZL4B27EpI9Zfkh2o9XcAX41DaWheWi4UIOnARFX6c1Gg99KNEGCGqzTNdwVPoNrl2CMfjJmUa
 dS0ExxIg
 f8SsJYv10YYxPKtLV2WnMQMLAxaeDLWeboO0VLqzVbkEIbVQbhTctfmWA40Daro1CqHlXL4WDxQUaJfup5wcP69Bm+3uuq76LKPDpcst6bkdQj0AThYEK8W90Sl3SoqLNcGbSTDL8iDNuIHQwdhfZWtTyYSytavXFjt8c4SxGXaVxnYPKHIy7m0Tk1lPDhNLRyYbeADi8LJEl5s7bMdXhtOxtssJLORrKoky48xlxbZkp5wcbdm0+TDN1JBIIP93zbsDXsIrZUGpRFiUHTGs6v2Q3ux22LSHBnbUN8U32grMgjJagy+f8T+7Tnan7IVZTxcH3NwyOznbBQ0B8ZjAdbwvge9DhKuqw88ai5VW4tzd7ZsBwES1aDM9AHzBm721pIKuzrpwipb/6qK/ICJzJH6/RFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> For instance, suppose a parent memcg has two children, memcg1 and memcg2,
> >> each with 200MB of zswap (100MB inactive). Triggering proactive writeback on
> >> the parent memcg will exhaust memcg1's inactive zswap pages. After that,
> >> even though memcg2 still has plenty of inactive zswap pages, it will
> >> continue to write back memcg1's active zswap pages. Writing back active
> >> zswap pages causes the user-space agent to prematurely abort the writeback
> >> because it detects that certain memcg metrics have exceeded predefined
> >> thresholds.
> >
> > This will only happen if the reclaim size is smaller than the batch
> > size, right? Otherwise the kernel should reclaim more or less equally
> > from both memcgs?
> >
>
> I gave it some thought. Not using a cursor could lead to unfairness
> issues with certain writeback sizes:
>
>   - If the writeback size is an odd multiple of WB_BATCH (e.g.,
> triggering a writeback of 3 * WB_BATCH), with 2 child cgroups, the
> writeback ratio might end up being 2:1.
>   - If a memcg has 5 child cgroups and a writeback of 2 * WB_BATCH is
> triggered, it might repeatedly write back from only the first 2 child
> cgroups.
>
> Although setting a smaller WB_BATCH might mitigate this unfairness, it
> could hurt writeback efficiency. Let's just use per-memcg cursors to
> completely fix these corner cases.

Exactly, the batch size should be small enough that any unfairness is
not a problem. I would honestly just do batching without a per-memcg
cursor, unless we have numbers to prove that the efficiency is
affected when we use a small batch size. Let's only introduce
complexity when needed please.

