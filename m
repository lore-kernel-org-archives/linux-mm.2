Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 452A8C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 19:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221336B00A5; Mon,  6 Jul 2026 15:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8526B00A6; Mon,  6 Jul 2026 15:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111026B00A7; Mon,  6 Jul 2026 15:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E01966B00A5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:33:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6605B1679AC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:33:54 +0000 (UTC)
X-FDA: 84959351988.02.DB19D82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8DA97140009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:33:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=do+qsvS7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783366432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgeAs0ILMEUxRaUEmhq6DVdls3/aBsdrj6eO6rYrOOg=;
	b=3RDdMH/E926K4z31vAwppGzJkmE1yz4cPPaBIn/F9qXm5/2jcypqLAkGF63gbRt1EBa3AV
	3GvXNPIUzDsjmOHeYkD5DsY8eOd0urQ45ImgAa8Rqr8gi7RvdJ8yI7Vh0qzyav2JOux5NM
	HH220Wu6xp3VVlhybzrJavHk6C76fVU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=do+qsvS7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783366432;
	b=zHaRbx7gIYoeZ5TFs+8UOgt7SostkgosdLgxjdkjz8zzRPqRPvFnVm7M2AZJpbDG+bS1Lx
	c0kW5lkmVxDZjwTPCqfHlfX5KmgAe8ei4TK9hSTQaXuSN64p9LKMgOwPWjxFiqtZC+M+3j
	hiWgPpQptj4CJbEZ1fMNPNFcZCNZG5M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11FB961838
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE2F1F00ADE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783366431;
	bh=LgeAs0ILMEUxRaUEmhq6DVdls3/aBsdrj6eO6rYrOOg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=do+qsvS7AFlAkXCPeq2WOuGUNZLmIP/FFCnkzVr8WVRMt2kohwsPQA3So565D7jmc
	 DilSS4ApSr9NLjZVFcpZvNVvuJKT8Gb8s9GWBJZBOjDIl7gLjikvGn6CSwsivgQQ9p
	 xGQymHmRr4A5cOUnsGj6bNvsCufJi+BwrGJ5r/yfrWkIgxfWAj4ACdgmoMan1dK0Z3
	 3H5o1sJiNa5bTO5yraoUmm1jivQ2ej2WNqNpIKqQfUJwuXdJpP6kTlyKmT+/SOJMvu
	 2pQvZAKWuc+0xKgAUqkeYEBn47Bl/+yTpHQYlusZSeSKKgOe4NAWBRM3xcRQMuuBvo
	 l+89LBB312HZQ==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69a5ecbbfb2so1866788a12.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 12:33:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+TpuNN9DKQK/NPEovLlmLmgoSHgHAyExpInBTlAfWkphnU4Sd6ztL6Ii58+QwL/MHbtCBgPomkow==@kvack.org
X-Gm-Message-State: AOJu0YxX4WKXhpTvJ7/VBzdWtLD1r+WtA3bjHt/QXRF9i3+e3lwRxGSE
	W5DY7a1PmO/9lE7ynUSdSvq/ond/eyF9Kt0izm6xUadHYCdkB+UavF8qtp3p2zCJjxkldCqWqho
	x2kAq32h8JX5dxEtgrNE01/gR0NsHg3s=
X-Received: by 2002:a17:906:2b0f:b0:c12:70e8:6025 with SMTP id
 a640c23a62f3a-c15a679c178mr91843266b.21.1783366430587; Mon, 06 Jul 2026
 12:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com> <akMJ8UfeZXrVe5LN@google.com>
 <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com> <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
 <4ec2bd64-af40-8ebf-b8a8-2dd7421a1100@gmail.com> <5ce4035b-7f56-d1d2-2d2a-668446d870e8@gmail.com>
In-Reply-To: <5ce4035b-7f56-d1d2-2d2a-668446d870e8@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 6 Jul 2026 12:33:39 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOLe5eJfNmoszCX3rtD=6YEa_7xrvDV1acVDOtZg4vWYA@mail.gmail.com>
X-Gm-Features: AVVi8CeAj3ZDhW9qHe6cGwTDwasOvswtbG6oJ2oKJtzbR49964SalAtsxIJukwU
Message-ID: <CAO9r8zOLe5eJfNmoszCX3rtD=6YEa_7xrvDV1acVDOtZg4vWYA@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8DA97140009
X-Stat-Signature: bbs58mjngagfo51w4nmfkxh3ra9t3uyy
X-Rspam-User: 
X-HE-Tag: 1783366432-302576
X-HE-Meta: U2FsdGVkX18PlBbatOu8+3BVmPXoxfV38U8UKzUz+1p9v94V1v+nKyN9FfxG4hPiGDcLVZjq0g5u8acWGdlyNJ2reK+S3p2inXOjTrFRfMeXzsntWoK4/BgAtnuPdxDYEPPmf40kcIrF/cIkuwoIFlr8FAy0qnP0gf6AjZBj8VOnJ0+vr26OLIBKgrHnPvAl4FAjjX6ybzhHpTbVt6iRAGLH8cwSwDiGJHYypsijE7CUD4rZ0NXFn/dWkowc6uVZqjtOCRtuup/qCay6UOg5BnpOwLTQaNLs8zpkaojF+j/pEgbpLbf4k2xszG6jyyO3uSbXNsugM4NvPSTKPLX3jERM197VVyLlEX6e/P3lBKv6tts8Xz/bQV63oqSaZx5Zyzpc80NBdUhL5S3jWFzUMKffaHNwePyQYNEfWc6LMAK2Wov+bYhVcLGAPPCDjitIZFenVWq2AggmQOQnFVF6HmFqX/nDXZ+WTlF+91YuE2SsbBVeemIEua+RnIC3jwIdgKBkXG223A7KEeqkPXiO1TahayIR5RnyHiAuAMJ3TE3zPjAebDdAIL3gHT25CeGIL/sbL91Vy8AHzwP4imnb71fg4SrpXznVx4H16mElZJLixwqHMmrLQLGrnvkxc5+kAfT3lpQZqoUQbBdqSQMPY9zIxQ7C46J0XOwLXdV35UT8w2yof/ZfYvtp13DBdLhMtnpeHaJqLw4hj/WVBB1bgWy9kb9v4I7u+S2Y7JflB4ZSQEAKYmIc9qYvg+evlbktog0+lAcezyLsHd2Fa0FTkzi5Od5zGhKXJKwm9OkS0xSJy2Pi9UaEZYxN6jw1kUQk290OeYdgW9q9WS1sp++xv8u3OrnE6GxqT8ifD/jFMgaTEN0CJ4S4pjAAfasoCIWhAr60SwxyasMqWyazMlaIOkfG0bj8Lg+KJKyhbLmfS4BR6APOfN1kN5oxAMlaGgCnFFE9EF0mBsnA+agGfac
 ZBqrMTcg
 XOZuUqFoqryMUBWegKKShtMeRdqoQnaA/89T3q2uHbFqSUkph5EStTVt8txUGHY2KQzi4gh+MQLq9AV52jECw5tgVWlex+wtJOQUxaL6+OVXovwgNlmwbgeJ3NbT5NxfDJlVeDltdpZBGHue5v5dDGXVUYGsCmLj6ARLzhbIIRlhtQDQJZsw8beOhpdrkfzRDUOFMsODz9p8UrfFDgIEPCHcgANaWBUzkAND0YBsJwO6bUlGub0wNPBBYV3cVh0zgmFxjRaD/HFQlMosrYAKgdPIB+twBcUD63CfeJxt9a+jm3Cd3PKysBJ8B+xUMYM4KH26TFJoRnRALmRjXLhIwA+HT/JxvfYru2flsCdJWZxUD5tf6tB9FA5zKRCiJ8Nnbo6d9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 5:32=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> wr=
ote:
>
>
>
> On 2026/7/1 19:45, Hao Jia wrote:
> >
> >
> > On 2026/7/1 00:10, Yosry Ahmed wrote:
> >>>> Before going through more versions we need to figure out if this wil=
l
> >>>> pivot to be a proactive demotion interfcae for swap tiering.
> >>>>
> >>>
> >>> Yes. Should I drop patches 4-6 in the next version and wait for swap
> >>> tiering to be finalized?
> >>> We can try to get the non-memcg parts (patches 1-3) merged upstream
> >>> first. This would also give them plenty of time to bake and catch any
> >>> potential regressions. Thoughts?
> >>
> >> Patches 1-2 can be sent and merged separately, yes. For patch 2,
> >> please include some numbers for the writeback performance before and
> >> after batching.
> >
> > I'd love to collect some performance data. Do you have any recommended
> > benchmarks for this?
> >
>
> Perhaps the following test case could work?
>
> Test Setup:
> - Total memory: 32 GB
> - zswap settings: max_pool_percent=3D1, accept_threshold_percent=3D50,
> shrinker_enabled=3DN
> - cgroup constraint: memory.max=3D1G
> - Workload: Run the following stress-ng command inside the cgroup for
> 120s to
>    continuously force zswap store failures and trigger shrink_worker():
>
>    bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
>    exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t
> 120s -q'
>
> The following comparison results were collected over multiple runs via
> bpftrace
> and the 'written_back_pages' sysfs interface:
>
>                           Baseline         Patched
> ---------------------------------------------------
> shrink_worker wakeups       5,587             878
> shrink_memcg calls      7,823,853       2,347,320
> written_back                  257         781,214
>
> Conclusion:
> Under the same workload and duration, the patched kernel shows a
> significant reduction
> in both shrink_worker wakeups and shrink_memcg calls, while successfully
> executing a
> much higher volume of page writebacks.

Hmm this is actually a bit concerning. Yes, we are invoking the
shrinker less, but we're writing back *a lot* more memory, orders of
magnitude more. We are using a batch size of 64, and making ~1/3 of
the calls to shrink_memcg(), so the number of written back pages
should be ~20x more, not 3000x more? I think I am missing something.

Also, ideally, the batching wouldn't result in significantly more
writeback, but a similar amount of writeback over less shrinker
invocations. If we are writing back significantly more pages then the
batching logic is probably too aggressive?

