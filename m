Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4A4C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 16:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5E96B0005; Thu,  9 Jul 2026 12:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D596B0088; Thu,  9 Jul 2026 12:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C326B008A; Thu,  9 Jul 2026 12:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22FBA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:34:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACAD98C98A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:34:58 +0000 (UTC)
X-FDA: 84969787476.02.3B77D0F
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id B605220008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:34:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=XpUTgRR+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783614896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l267axzxai0vXVqlDynaMeRFVbBWGC6BhHXwUJcMsIo=;
	b=YnF1gAv4RQgL9088tFN3A/yx0KbUHfwD8e5988y+AFrrYlZog9cyBrANJnnVpvZdLXJ9BR
	s3eXctcUAADD43QpC4ZlyiOujmI/eSqrBWmynSbWFN3JPDzE43TKJuFlruKnB/3qOr2J8o
	ZEJRZISeUFv60sXc28pXh46sM0se9tI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=XpUTgRR+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783614896;
	b=OSrl2U0BBZAzUUSvpA36WPsKrMD4H3aVcSZh40hN1NCPc+LDOj+/BmiJPp4I6jNB2VdX0S
	mFrdO++oW5LAgs5lA7beEL7z0bC73QtTRpRFyQ0d6Ntgdum45yuAwMvarMhcQm/Y2nm83b
	ECO16qRXIq9BTy52GpRBgRG2nKhaY6w=
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4a25f986bffso840959b6e.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 09:34:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783614896; cv=none;
        d=google.com; s=arc-20260327;
        b=W8s8tavS6u7VRCMNqrT1t4e+2jY+g5qw04N5VP71wT9lzAkejTw/488gdp0fu+GM42
         IyNUmfc+LNasYuip+vIloz52JLh2xzCXxYxCMUBl3ZF8+Fof+IwPyfzP6AveE553m5JD
         NoSTuS4XEhhlqw0zTCBLpoDyls4ojckgYs2knUhZIMmBjUJ56bFiI7PBNFWxW0I1l0VB
         V8BxaUbiXE9zKrsu5OOoRncA1l2xgnHKdx23fZQuBg1CajUmROXoNDyWqGHY5BUjp7WZ
         OL7qBTXTuSvqxmQdoAiHOqhGit0ucoOdOn7rSgMxMkFRe8/jKw1TXLO/SLpDtmAWUO9p
         C6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l267axzxai0vXVqlDynaMeRFVbBWGC6BhHXwUJcMsIo=;
        fh=hOfPe38KdSs+cGK2mFSV3biKCnxf2o2UVyDEExK0HoQ=;
        b=HLQFoEWpl2H0gFDdRxOug0N5k1NnRNTBomQmKJ8G/CxG0wPXnuYweE09hEzbtkskRb
         xcSpaM6ZKtgTjvXPO+iuZoBYMjNjaYSuakHM9RCiIZuAeoU+/Zxs+/7xrZxgvr2PAXus
         dlJ2AuChFKo8c7YRCUdZjjAdHiXRvoJ0M+HERRNXzww1cgh9OU2s8Pgv9GqhAHT+4JK4
         nGbV09wk3heQh8tD/fTF6Z7laaK5pHhLLDD/sO7eNMQ9YQm+YKDiuRpf79IdWJAXNMcF
         G/sNdsF0MB3Y2CwWU1lKW1x+jMoTzg25MN2ubGedBr5Tg/2m+qyrZVqIUCmuRuYJngxa
         /h9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1783614896; x=1784219696; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l267axzxai0vXVqlDynaMeRFVbBWGC6BhHXwUJcMsIo=;
        b=XpUTgRR+a4Mi8mo5WMScXj1dS1n3wNckSKIZyvoIEENwawjXwuMD2lwPGXHJ65gJRj
         +nDajOfmfA93YIqUv21Mqm+AX8T9xhtxCK2f8et8J4lpZZgaCcfWDAyUgl5mhV07Bgao
         NbesxNurbALtBMmpUvTzr1qYMp2aNU/rF9V6xrJK4VUyrw2C/ObpsFwwGfwIfTKi9inB
         W7jQ34TrEbuMDSwiRVzs26f4/hNCiJ5wygaWfqTmL9SZL+rhcyNvAtFr7uR0ZY8Yu0Zw
         cNMmgnI3jUsjCWVMVmo2VyI93w0JzWUQf+r+g9dRsACzG5S7sXBLD8m2VmyXNStMRYha
         6sNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783614896; x=1784219696;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l267axzxai0vXVqlDynaMeRFVbBWGC6BhHXwUJcMsIo=;
        b=Fhux0iD7NocsM5KUK+pR+JuBM5iCWjlj5G1IskLzyY7HMdmu4IkHalI+Norl5utCAJ
         uGR+S89p2OC100dbvYpcLaMMpeWh80xKfG3YnxoXntGvIZ2uyLqwaXWE9xIhZkutOxZa
         X+zbjHYOVx77dbmvEJUSV1M1jYtMmQkyr+mgqs+X1FipBtHM+W0jmOq5ChRfbw8Te12J
         s2Eo3SdWJPRqu6zOJiqWV2bUAbX6qa42pT8xoeyvtebs40Op6BUfO2Gk11SJjAkW4Ofh
         LsW4MKUMcciUO+WQFdldW+YGTwwRstW6uU/CdlA/cyAyQKOUQ/LHkJq1QpA9yER1pl/k
         utjw==
X-Forwarded-Encrypted: i=1; AFNElJ8/8oI1NaV8oBkmxVO05VLqIbzxjC8EQPFii3PBTDffo+26Sikruh5Ljg1HQbgzV1aRBiScPI5h3w==@kvack.org
X-Gm-Message-State: AOJu0YxK0ETuqxO5URTlqAlysbWUqJmhtq4mFJeLYg5qeaFBk/7O6vSA
	HoMBMPt3OHNQwPyfiD0fH+C6G8fpVl+VWSHsVaDTqUWc3YG4c8ATCUibKOlE4n+GLK/IMBUx+5g
	eylw4PzwSXOkzSDEHfItM3je6/dY14/+GktXxtirQQFD4CgPfN8srh2Mddg==
X-Gm-Gg: AfdE7cnqCxN5XXBVHfJ8S9JAl0P0a8Va0gnJ0gtAWxI0oAi4FX18EDKrGD52m688HhT
	CyaHaf4JSAROaYQtgcLneW/94gIbq1Qkfz6EuaiRrlUW/cf5tPJx76Be/Et6dsDGiFNIlYIxoKO
	9DBXE0f7lr4AbAVFHw7sWC2Y7RQ5fqqwOz+BqCP+Cfv84eLVrOqYFwZ5jfTtF5DDkdS9uJPg/IZ
	yWd8jBmSLgImY5NTJ+v2McG6OM0/CE736xplZUgGQ89RE3HcFFeLXQECY/I9WcErqhDA3YQJ8kX
	ak9BT7BsHVE4q8Q=
X-Received: by 2002:a05:6808:220a:b0:486:4892:d553 with SMTP id
 5614622812f47-4a1fe61bc2amr8165005b6e.0.1783614895716; Thu, 09 Jul 2026
 09:34:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org> <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org> <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
 <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com> <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
In-Reply-To: <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
From: Yunzhao Li <yunzhao@cloudflare.com>
Date: Thu, 9 Jul 2026 09:34:44 -0700
X-Gm-Features: AVVi8Cc4MajxLm8eoL_39FDAK26R50F5uujiggtGuhsjjVnbf3kEqFSa9UCT1GE
Message-ID: <CAAnvDSziZM9TOExkFrF9vNi4VN=7T6yofS-=4rmFqc3jXncveQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9dr4gdwxrujye3exgwpmf13oruatfdm6
X-Rspamd-Queue-Id: B605220008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783614896-968167
X-HE-Meta: U2FsdGVkX19sifrnBffVOfGFT6CGvFJ5hhQuJqkOR6z3Zrv/rAQ1iYeF5/21mYx0Cvi1bvxQn1zoq+5bYqahS8OoGmcqwqjZkloQuX9Q/MfjmvE/4D+M3LSgX8WpdaBEsNdtFYch+4Mec3DNT7DumCzOqzRehHeJroui0F5bsB8FyyVaX8nv37OzHVFHxVy9l8xLLS5tpTYFu+Ls4RpUs0Nam2rs1iNJ8r8R4UG6R5xqzcm5cW+N8LAhxAJT+HgpaiY+/8ulhBcE1lL0H0hSxmKB4Gm2Agv8C1YTsJr9ZhXIr1+WSLQ0xbgiE7iM9ekZVBPQ5JBEfyc4jq6letTcd+hu3wbn3JUwhnuhkdECkL6Wh8lKttRo9LCPbSVFoY4wcSK6b7nE/TI+urpT3TWEuOOVD+H7CX0xNvEWkjn5kCYLV3nNf3FWYvP7V+8AzwAzsCUgaR1qMKSw1ovbr6XQ5JLX23dM1i34CgFaLoOMFfUgQoVcZC58P7Ez6BrRtwgsYtrEPBQfRGWVdMIbyroxdLMbYQ3oi49f5re9N/4nUzR70IFR5mtTS2XiJjVB92vSSVNaEuaOM1BARjuz8e4VXSQxnJUSJOObuZPWcN4WgTZLjiW9OofccyTh7srNChTVtT5VoDQcSrAlGK9XE/SIpNAY7eSM1808lIgv/XsNs8YRiCEjBCstmXLlUbTyWrip/i5XptguwQqXxWnHRxtE86YDKwNXTLIpIyUMq+OAkCuFUG0bg6v2nkx82owNETY1xqN64mm46h81wGdr4wHUwvv19SIJr33qSu0zTKOqFJ7/1ynwP91pqxYllTMJK3rDN023vH9RjzBXpBkBEgehKS0rWvfHF23YtmmiuAUbIVqfHUQ5xKLzFyk1CwIk5VlE5TOicqyW5D4md31mRB2LH91roWGlit4jJVL3JQlF4sYZgJMQY7GOrJSBLBWkrQoq95at5Rvmip0jSm7Yxv9
 KmX6R+io
 jWHaLQh4UPg8OzQFKJv1usdpEF8jYLpMkgynHFzlLg5A9m4ckCL5l7wmllsrIRfRxjTqvTDSvAAEiNxGXqdVqi9olNtww5evTZQlhalp9xmj+Dhr3HO6hyRm4cVbRLRkhqQG5gfC/WKKLJQ/dOibT1NSQV2/zZ3Ycv0PLZ1ROwtg9AAxxic6LkgnP/ut/uLzRfIhUrJ3oUrX7n4xoGkCQO8xjL+AzHbrwpcO/muQ3MQazFY4HCAqj/8+oN58cH499uvX6/Tm5EIDoJY4xRVm5quPPBZv43lIYqOunXwjD/z16Xbek9aCfqQzr19yTfEJH8QMb1CH2R33YneivQzMsqw8dmRvFljd6ZqDS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Are you observing any performance impact when enabling it
> (e.g. higher fault latencies)?

Actually the opposite with this patch. Swap performance is better with the
shrinker enabled:

  shrinker=3DY: sync swap overhead 10.3 ms, swap rate ~800/s
  shrinker=3DN: sync swap overhead 22.5 ms, swap rate ~1.7K/s

Per-swap latency is about the same (~30 =C2=B5s P99 both ways), but
with shrinker=3DN there's roughly 2x more swap activity. I think
the extra 16 GiB of free RAM from the shrinker just means less
memory pressure overall, so fewer pages need to be swapped in.
The shrinker seems to do a good job picking entries that don't
get faulted back in under our Prod environment.

Yunzhao

On Wed, Jul 8, 2026 at 5:09=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Wed, Jul 8, 2026 at 3:16=E2=80=AFPM Yunzhao Li <yunzhao@cloudflare.com=
> wrote:
> >
> > > What disadvantages are you running into with disabling the shrinker?
> >
> > We lose about 16 GiB of MemAvailable per machine. We A/B'd this on
> > the same hardware (EPYC 9684X, 96c/12 NUMA, 384 GiB), same workload:
> >
> >   shrinker=3DY: MemAvailable ~75 GiB
> >   shrinker=3DN: MemAvailable ~59 GiB
> >
> > Based on my reading of the code, the zswap pool's zsmalloc pages
> > aren't on any LRU list, so kswapd can only reach them through the
> > shrinker. With shrinker=3DN the pool just grows until store-time
> > rejection or swapin frees entries.
>
> Thanks for sharing the data, it's actually good to know that the
> shrinker is resulting in significant savings. Are you observing any
> performance impact when enabling it (e.g. higher fault latencies)?

