Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D5B5F8DFF9
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 17:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE196B0134; Fri, 17 Apr 2026 13:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7DC56B0135; Fri, 17 Apr 2026 13:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CF66B0136; Fri, 17 Apr 2026 13:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 949E76B0134
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:53:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BACEB6E68
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:53:36 +0000 (UTC)
X-FDA: 84668795232.07.E5528F2
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1CCD320019
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:53:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nxhV1d0V;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776448414; a=rsa-sha256;
	cv=pass;
	b=iSmTSdUkY65HE23dF7c10+nwk6ODkjm6rkq4GRWSbGatD4USb7yIJv9ZYsuJsKz8dPFzsQ
	+UGJb20eB8DrEZBqXy+x/884okhcOBIFi4OVBNT1Y/UDawwHknrNZUdKpL/zDkbnmgdjf8
	Bsvpb9K6jGx0jBsZbbLSbOrN9Jtrd50=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nxhV1d0V;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776448414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQ/Xl4UCTqHANPQy3R1nGibzID2aX50LAp8wgUs6k2c=;
	b=IEqz13cH1p2+HeUlSoFOfojv5l5qZTPbAOjGKxGVK2U2WWjrNT6l3QjeAk8UEF3ihZkBkD
	4JyIgo/UFCbjgabKvgZ6rszBfhtAkJS45C4udbnXqv+iYHIRIxq8KFpShJ5jGUXfbEwS4O
	45dTzPLrZMA96z7x+tidHnY/wulA5ck=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-66e8cf72a93so1294720a12.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:53:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776448412; cv=none;
        d=google.com; s=arc-20240605;
        b=loN/Tm6OoljLnnS5PDNsoH+Z8XAJi3pfeMA8gCP7GawxW0b13tja7cDE9CPnm7KiZH
         /r/R5n4Hpuk4lxwfJwvH8RZflaz7e09GuimU3dgg1ZG7e3oTqTSd/5mwKJ9WNdbdzMTZ
         8fVgTeHgbr5q8lica3DLQT8El8oTeWIPn68iSSG0XQLMFJH/cmdYr0guJ4pegbVY0dXG
         5V55t62iHVJiD4Luvv/vPhvCSOMpr323e4JquFXsbSRzGxIbJ8XqdPAXjmly2I3P642z
         q0M+CobxPqm9lNTXL/B1Ua+gL0N0utrCQTJPtJ6wALJgCBgjVo5EiB806kAb+p7foGpo
         +0SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UQ/Xl4UCTqHANPQy3R1nGibzID2aX50LAp8wgUs6k2c=;
        fh=Vu5UQ0LPT2pxnOyCOqaVwzhhpp76hEnM8VsJlUOnetE=;
        b=dlYh0e/ZeNnY0sC2pMmIqkHlhx+wv4xAgNZNbX70KJ+3TOUbdWADiOIbF48WjfvOrC
         /y8z5vv4rXcImZRPzcdKIa1omn3smiOIw6x+vDHfpz0bSELTsYLgWKRL6DCUhPN/h1J2
         lHCX3m48nx/KflwtN9nEzo7NYz3OdKpW7TunnZsVnHo4Ozf8r7q49dN6y87aF0jx7wv3
         39WqbnzHvjxUcosM5SoCMq3GUcTy41tGdLet1wJP/KqGy0PMoVkjb36fOrXBLo56MPJJ
         rGYmof3jAk2akyOMBghlIxte1j+eScWTXGgo7ODrWuKsoqgh3WqdtSSfvk/PaCz/23Zq
         3Dcw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776448412; x=1777053212; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQ/Xl4UCTqHANPQy3R1nGibzID2aX50LAp8wgUs6k2c=;
        b=nxhV1d0VNhsn++cKdhzGZm2Yz09crKVRoHMLE/ger82MSs5rl2rcAFWwV6sGksOJ5D
         eA4CSOEw0kmK0u9zMAL246fAUzMAULwe1MkyKMUmKc1yidTa1uR/C46NQRALQVUV348N
         iomReZcm44q+h9TEhrytgBDoIF7UdVAoF8UXgLRdweLcHRri5wiBQOzcXXzId3cK05So
         PeszcWlv0Rfjo19vtunUpJkoxSc5HV0YyBTuDWeh4K01LS1RqWUKt1IB3fEKMiwDrjxJ
         6uPaQKlFBVA4myXGY4J+HczJgcMknSwpiVfIjpQP76S4CzE6ZTx1Z4PHuhCqStAoVqAl
         O6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776448412; x=1777053212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UQ/Xl4UCTqHANPQy3R1nGibzID2aX50LAp8wgUs6k2c=;
        b=KlDplUKKPw3AYD0B6i04UJjqVMxDZoHB04TPZIWoHRK1AzA2wZvb4dsk1b0mKA1jcv
         jhBMzKL5Ivzch1lLMeJ8q4cLGnvpNhOAZNrCDo+6ZVNE0QEL8HCR90vIo7cK4LlgUVvn
         IzIj9IIvReVerLnDOVjPaL+NNG9pR4XBJXxqkYOmWUFQAn1mRn1JeV1eGooRjYuRIZnP
         /cnvmROsu0Fyz2jmsfSBA3GYvFSkTabTJ52BCqK3ngyaqNvYHQWN6pX8RETctl6BOFh6
         i/6c1A1lUPAfkDrLpJskiVF893Uf+5I70BugyJz3YAEoo61nRA9dYxYjjMFQwK7oGdt5
         fglg==
X-Forwarded-Encrypted: i=1; AFNElJ+v/N624ZNymVAn1X68lEVsCRHHB/OKvYvTHK3GiM0EnSPPG07Kvu0ZaCp577sUN4rBSQRVwL05Bg==@kvack.org
X-Gm-Message-State: AOJu0Yy/AtJiK7CjTK7HypiLPQH75k+9MifE68ol3e5/dRIM5gIikzq7
	nG+qnwcywo4QcJsnusPI1h/iSVHKehAi6LArPE0tefPvgYxOQ9aPzSYZSAtynGyDDsz6bgGtzcY
	tzqUKDotJZqrFWTXUoOjdDbSPagqkZD8=
X-Gm-Gg: AeBDiesdAgpO/tZBv7Wc7pX7BCtpzw8pg7/XPdrAePxrEOgMH0z/uypa5aDhpTGCOCM
	uS9stDfZuk8u8tMHj+0aKKKXYxhXy/BDXS8hp4GrxtItHjFK4wZbOY4Zljwi05lZKwbqiIP7lWC
	hiNQHL2D8nQPKp4hb+mGmzPCQ5F0AwOnpRxLL9dD0gDg4ha4Pa0CiRigPDW+GHb3VVLWSp3eIT5
	D2s61+I+pPUW0iAZYvgHSxdVMyoCrawroUcAtvH9ONFw7x2pEOHWpJjQ9Su7uJu7FxOdLVBDdUV
	9nE5HAEDIMzI1LQSY8v56SaYUf/Y2/PTiJKJoRkjQuQDJLS3tNQ=
X-Received: by 2002:a05:6402:2b99:b0:674:28d8:11b9 with SMTP id
 4fb4d7f45d1cf-67428d81399mr513143a12.4.1776448412162; Fri, 17 Apr 2026
 10:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com> <20260417025123.2971253-1-wxy2009nrrr@163.com>
In-Reply-To: <20260417025123.2971253-1-wxy2009nrrr@163.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 18 Apr 2026 01:52:38 +0800
X-Gm-Features: AQROBzCxzggeda9zzj7lsVXPjjKfOGLVd75FlBgh5DBNICPRHRhJjCLuob2dcgA
Message-ID: <CAMgjq7B8udNHhEtLr2ecBho8Ev1vf646mrdGKujtAnMSOkV-tA@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: wangxinyu19 <wxy2009nrrr@163.com>
Cc: devnull+kasong.tencent.com@kernel.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	chenridong@huaweicloud.com, chrisl@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, kaleshsingh@google.com, laoar.shao@gmail.com, 
	lenohou@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@google.com, surenb@google.com, vernon2gm@gmail.com, 
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, 
	yuzhao@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1CCD320019
X-Stat-Signature: m7at5ox7rat9gy19ogxntjyjg7ejga6n
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776448413-630521
X-HE-Meta: U2FsdGVkX18ZYSoYTSLwD6CxOhn1FH0zXHIiLiPs4V+p9quRdZ/jNHRIBUxoj5LyZUPVrqs/gXe83AQZ1yfsds1hex+6CqsKjcyK3RCYvN85LKGj94PycvQSbsKtuMRjGT+/ZpTlt7f7zMZ7PRNHXtOygiJIHnNPTDBHBBx7Z5WahmT0adclPStJ8s5ZwbgF2WJ7amtclGC4cJO5G4JosmOl9bWED6KDTfnfvdho6/AfDOGf4C3Bptpoo1RB4qxZ/H1BRV5QdOyX7hZkhnYvO2MMUxymk/r+j7VVsazGaZZB42V68rRkvQ/nj1pD7rkWBBo/kpQ1uNgn+JVVSaeG7gwKDWJ+0pmnhqv+uS1KRKnjDwJJ6/v16OemV5L+A7Cs1HR2JPllWxf73g1X3ASt7nbFW+DGhxIxORztEra2ruTRXvydYvrZvd5q6k+Ellt9qvXyLlMHJPqzts/EA5JS3dTo8e13FPBdWkp3rq16rCSXn+ALS189QFg8OP9bVw4KfE0g8godk/MSITkgsXVL+M+q3MSK/ZSONH/LXbrQ2jI633UOas18fE+O68N/AYw6v6jEz+2Z7TAKiFlfwQCOwZnASuLQo//9vVqkTmUBlarI5PLPMsBLuVL2G03t7NuJBe1o9vhltfPQTUozuwaY87XQE7lCXKzdxPn0RcvtzCXlp6xLklOytgFFfBXROmbfsN9f15IAhXcwIShtr9oErhDBL7IrBBoTH+T1nlkvtsgDT8JTt6uKZdXWvJ+1xjIWn51iwQ9EFyXmtZBFqBSGthqQ9lb3hZwk0Q3Da3E6V+YgnPr/RmyFMoL4iI2ZRXoVj0l4j3sKmyu1RnpyF9860ECsPTd1VQwlXg3WXdBL4DtOaP1wOF0DiVTvEJUpmBmHwlgjwjmvTQqCGNWJHJBHbUSBCsEdrM6HbX5Mr0cH84E4bf/VeEBpGYQEh6zzgX2lllouxPpwY5jDONm1vBv
 gCpb+QAf
 FsawHPpcAicOWqA6fyqgnfUXf3OlkvoBQ5J9hT9o1RE+cSnuiymUD3oSumUibLesW8S2UNfJjG7TyZUvVpQ7B4ligxoqa4lUTyqUjzQwr0+rC3s3+WTTsA+NFHmwDKKjj6v0bcVEKO/0J4P8rSOSWlgnGOdo4D0L3CLLaoV6eZBo/q0akborHe0ZAI6GCAU5rJfOhg7K3ou5ck5xexlm1+8Bg2S9ii+CFKO0C8HCZIBz+/zUsudlrZ+nEeMdu6XbaYbCZ58a6n+eGMyvD23i2N4/JNgkulTfBByhGasF6CIo3wp6oS86iiF5hKrzakMnoE9pKMTEAIVvyTWIULEYp3IFPK2hh2/2XRa5wNIWxp+hRXje0cFKlEXlNgxUN1kdjq05SUOF/ERcRxQ39IoHCd5h+2x2uLBS23etx7hQAS7qHeDG+QfJ2c/FBQNXzRC9QrELbzCDXQz9PAcb/p01EGODf1Ckn/qa2VeFAToeEWkZGOUf7BW/77W13qC1KInlGdVOYN12BmI5CvR3kFgu08vnr9T0mFXBWtjX9Nk5MPJGit6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 10:53=E2=80=AFAM wangxinyu19 <wxy2009nrrr@163.com> =
wrote:
>
> On Mon, 13 Apr 2026 00:48:14 +0800, Kairui Song wrote:
> > This series is based on mm-unstable, also applies to mm-new.
> >
> > This series cleans up and slightly improves MGLRU's reclaim loop and
> > dirty writeback handling. As a result, we can see an up to ~30% increas=
e
> > in some workloads like MongoDB with YCSB and a huge decrease in file
> > refault, no swap involved. Other common benchmarks have no regression,
> > and LOC is reduced, with less unexpected OOM, too.
> >
> > Some of the problems were found in our production environment, and
> > others were mostly exposed while stress testing during the development
> > of the LSM/MM/BPF topic on improving MGLRU [1]. This series cleans up
> > the code base and fixes several performance issues, preparing for
> > further work.
> >
> > MGLRU's reclaim loop is a bit complex, and hence these problems are
> > somehow related to each other. The aging, scan number calculation, and
> > reclaim loop are coupled together, and the dirty folio handling logic i=
s
> > quite different, making the reclaim loop hard to follow and the dirty
> > flush ineffective.
>
> > This series slightly cleans up and improves these issues using a scan
> > budget by calculating the number of folios to scan at the beginning of
> > the loop, and decouples aging from the reclaim calculation helpers.
> > Then, move the dirty flush logic inside the reclaim loop so it can kick
> > in more effectively. These issues are somehow related, and this series
> > handles them and improves MGLRU reclaim in many ways.
> >
> > Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> > and a 128G memory machine using NVME as storage.
>
> Hi Kairui,

Hello Xinyu,

> After:
>   /proc/vmstat info:
>     pgpgin 223,801                (-16.9%)
>     pgpgout 308,873
>     workingset_refault_anon 498
>     workingset_refault_file 17075 (-38.3%)
>
>   Launch Time Summary (all apps, all runs)
>     Mean 850.5ms (-2.07%)
>     P50 861.5ms  (-3.04%)
>     P90 1179.0ms (-8.05%)
>     P95 1228.0ms (-12.2%)

Thanks a lot for testing! Results are looking good, fewer refaults and
pgin, better performance. pgout is a bit higher, maybe because
retaining the flags on dirty protected folios helped identify or
protect more file folios, or maybe anon / cold file reclaim is more
effective since writeback pending folios are activated to the hottest
gen instead of stuck on tail gen; or maybe the reclaim loop is better
structured so there are less wasted loops and unnecessary reclaim to
slab. In any case, it's a good thing. Will mention this in the next
update.

