Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8897CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 16:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D26D6B008A; Thu,  4 Jun 2026 12:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4824B6B008C; Thu,  4 Jun 2026 12:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF8D6B0092; Thu,  4 Jun 2026 12:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1056B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:10:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E161F8BF98
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:10:18 +0000 (UTC)
X-FDA: 84842717316.28.410C67D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E6F99A0019
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:10:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEq5dlFI;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780589417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YW7V6VQa29YjcMSrmd42lxjY3Q5BWm+8nU4PiEtSpss=;
	b=f+d0JpZ8ajVVvD8B4eCqzPhJUALUSp7O2WLjXP0h/U/ACrKeweK92R94i231Z7ybPBC8c2
	zPnuDgG/+kEzSto14BOBsb5LYiT2KvT20hAaoKxg8DZRlC8RFnHcxtuY/+cciDJ3hj5gYU
	vTv8Qf5DU8dz7CHgqPQhcNf+4Z2fD7E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780589417;
	b=JJ801g+QmOBipsRB3S7c1qAtEQoEXlQ2Wk4msnHAU9+0qaK8aZTm0pa5zs3LKjWTWGhiDj
	qnWVAwraP2fVyCwCKUB68oZevQL0rQw5rUl4kXrjVumN7FF1NrOC/tQfqp3gsdGpbM/6bm
	inW3f88cwoLVBvq0gFCbh6OAQDFg/uw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEq5dlFI;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCDDD44498
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB2D1F0089C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780589415;
	bh=YW7V6VQa29YjcMSrmd42lxjY3Q5BWm+8nU4PiEtSpss=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MEq5dlFIJfV2cj25Gy5Iphar+8EB3Q+M++ma3ddkZ79VItR+ZvWCy5GquLxnOwLVT
	 J0TvzAcGjl7Z1/O41TXXKHBFelMg54n3BTGq2Q9EZgUNoAihogBT0qG+6UYmqVnx2H
	 Mu7raqFZSeIZhtTt2+xGRdXmofZV6p0dcICRAwft3WVZmbtnX+2V2U5eRc3gWEeD0u
	 Lg5SEKkRDUZMSEKAkIxpE3/03WJK7VloDAFzWaehmiYDKu9IZw5eqQFmuC9/jPXudl
	 Pqvz5HUrco5yx9+lUkOI41JCLlWsJ1Flg08a2vxZpM9oXrMH5s7EcHnoJFSDpt2rW1
	 X/t1zmDjUd3fg==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9158643e538so82467085a.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 09:10:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+4pg2WvuAC03BZulNzIy5xUTJI4mCivTOKZTcnIT4K4SK9kGW11DKywY14W1/BYhnDlR98M55OIg==@kvack.org
X-Gm-Message-State: AOJu0YxS67McuRK9IAgoUwAqR6g1DK9bkqpy4rwP7RFSpQOiRa9BXQtz
	0fpjdsRBgZj9P9q0u/NmUxHwd8Q4q03crJQ5Lm/qDI9XX4NIlSQGWK6t8r9c/sFCud+VM1VQFJI
	uSjfdadJWM2PFPquVDAhkmgyqHjUyYPI=
X-Received: by 2002:a05:620a:a181:10b0:914:ca75:e8cb with SMTP id
 af79cd13be357-9158a7a7d31mr980372885a.39.1780589414974; Thu, 04 Jun 2026
 09:10:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com> <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com> <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com> <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com> <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
In-Reply-To: <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 4 Jun 2026 09:10:01 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMydJfQ+28OQkPYyH1yHngxYCNByo-4hu=D2eoJBtTX-Q@mail.gmail.com>
X-Gm-Features: AVHnY4JkU6wiALPrkeGY5YeF8-NFodHMhfIp-dzt841kR4__pG_M4xsJghd5PrI
Message-ID: <CAO9r8zMydJfQ+28OQkPYyH1yHngxYCNByo-4hu=D2eoJBtTX-Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6F99A0019
X-Stat-Signature: ficn1xf3ecixetmksiganzinhrytyp7u
X-HE-Tag: 1780589416-337004
X-HE-Meta: U2FsdGVkX1+2yZy7fIb5y85XlULizgRyhN1BdV5AUcy6xfsETo5rUrHjjb8Ue5h4U3E0JE5CrR91kxaDzboo1Bu5C+/GRfKcgAFuMqzYHKG04ZjbF460EC07W+C4jBhlz/K8EyKrX0fKlanBPnqWcS2iknw1o+0IE+Wrab4V5vLRx4huF/xt5yjBqwmetturjKuAoRbD9Fr9zejJEc3uYEqXJgO7bGb4aFBvQq21hIifIUsUvcNo9PleWY00rMOnmUPpiAgd+TGp23QZtY+bHShsipNQQw0aayfWauqqNku+YoVhW/uRrtRLm9VOmAAw/hHwcCNzXVLFYKd7O2YvUqFa1GSKvFCSc6GTgsNnZAdiDnZ5jmJmt4/KM3ZeqaN8IRyyGRxI50uqpJlVpHN2c4BDPteuX1XgEpI0fZ3+PTqnmjzqvV9Hg4O+F85UV0IaDqxVqoqHgITYF8+a2EF60nuMWwZLcsM3+u5Bl0bh6t66WBl+12mxmOj9eEGhG1G1tm7RO8HOrAJ0R5q3nJQC5c4e1nWX/ng92ihFIOm7N1f/OqKeYiWCB5XzTdyASYxaV7297Qw0coxPZr+58yuxBn4aku9zRcnrsWug+jZRnTmknTa1XibOrhQ5+rPipoIl1zM9ffwB7gqRDfdclwjkNjAbtrrxfCTai+s+0MHgC+BdiVINQyLIERnbpNv5SLz4cb2yFBbxK//vIP0nUN0RjIF+W5P3Q/IzuIGNg0NJmAcPItEvgMxRUOEDPPqboiEt50fg9KMgKEf+bzmmWY3BINyJmh0TZSZxDnyqdJFZigZWKGYBOpfDNFDbhcuOScYMfe9Fv+kOAcFNq+YsgIgHK15oGxfrj85xdC122VNnNJp4kwgOorEvuzKdiq2+OGBrvNEZXVFQlweGq0ZuiOiS0bxehSBKRwMQwLXlwTFhC8pyJppFCJ21nB7xDXl+BRjNwqLZnTFlSTLRWtmWDzF
 LtLBRvfY
 6BSqPL9XCXC67YeC+m+/nM4Y2Cn0PmxTNKTj6EQgxMPKfhwlviFZKJdJ1JrgELW2RrDfzqboSdg8hHGCl+DI+O0oBdlzskWzkKc3s62ayR6WwTLAIbQ/2gnLxZNiH6llL4Ryk1Pzh5ZbA7QJkHkvMXtfAGhopqPFhSv4Fq9UOT18aS2/9nTrLX2mgeiV+zcD2tjkiFRGCFp6UzwoitJIhGbKWC+nK6Q/KcspuS6eGXLR5wl1shOd4PHeNq5165FmhpIc+fiir5GA6BYSPXpbYUGBMEcr24p9uRq1k4OnP/410hksaR7hkESzKL2tF7zrv4NHhHvCG7b3IPZ8COR30d8I1FDS4KoFgHCAILdWZB8f1xZDRC9FjEg6tELGFpnjTtG63k2C5fJGqqzVWERy7IHQZvz6ik707NKNpdKcNRXpBD3KYDgVXiSlWIg==
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
>
>
> If you prefer not to use per-cgroup cursors, do we still need to keep
> the global cursor (i.e., the root cgroup's cursor) zswap_next_shrink?
> I found this part to be quite tricky when trying to reuse the main logic
> of shrink_worker() in zswap_proactive_writeback().
>
> Of course, I think we could also keep zswap_next_shrink and write a
> small helper to check if it's the root cgroup, allowing us to use
> different memcg iteration methods.

I think we want to keep the global cursor, at least for now.

